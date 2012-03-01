Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965663Ab2CAVx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:53:27 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46239 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965353Ab2CAVut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:50:49 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.197.199 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120301213927.606796177@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Thu, 01 Mar 2012 13:39:55 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, rjw@sisk.pl, valdis.kletnieks@vt.edu,
        cloos@hjcloos.com, riesebie@lxtec.de,
        penguin-kernel@i-love.sakura.ne.jp, srivatsa.bhat@linux.vnet.ibm.com
Subject: [ 33/34] PM / Sleep: Fix freezer failures due to racy usermodehelper_is_disabled()
In-Reply-To: <20120301214654.GA13231@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------


From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

[ Upstream commit b298d289c79211508f11cb50749b0d1d54eb244a ]

Commit a144c6a (PM: Print a warning if firmware is requested when tasks
are frozen) introduced usermodehelper_is_disabled() to warn and exit
immediately if firmware is requested when usermodehelpers are disabled.

However, it is racy. Consider the following scenario, currently used in
drivers/base/firmware_class.c:

...
if (usermodehelper_is_disabled())
        goto out;

/* Do actual work */
...

out:
        return err;

Nothing prevents someone from disabling usermodehelpers just after the check
in the 'if' condition, which means that it is quite possible to try doing the
"actual work" with usermodehelpers disabled, leading to undesirable
consequences.

In particular, this race condition in _request_firmware() causes task freezing
failures whenever suspend/hibernation is in progress because, it wrongly waits
to get the firmware/microcode image from userspace when actually the
usermodehelpers are disabled or userspace has been frozen.
Some of the example scenarios that cause freezing failures due to this race
are those that depend on userspace via request_firmware(), such as x86
microcode module initialization and microcode image reload.

Previous discussions about this issue can be found at:
http://thread.gmane.org/gmane.linux.kernel/1198291/focus=1200591

This patch adds proper synchronization to fix this issue.

It is to be noted that this patchset fixes the freezing failures but doesn't
remove the warnings. IOW, it does not attempt to add explicit synchronization
to x86 microcode driver to avoid requesting microcode image at inopportune
moments. Because, the warnings were introduced to highlight such cases, in the
first place. And we need not silence the warnings, since we take care of the
*real* problem (freezing failure) and hence, after that, the warnings are
pretty harmless anyway.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

 drivers/base/firmware_class.c |    3 +++
 include/linux/kmod.h          |    4 ++++
 kernel/kmod.c                 |   24 +++++++++++++++++++++++-
 3 files changed, 30 insertions(+), 1 deletion(-)

--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -508,6 +508,8 @@ _request_firmware(const struct firmware
 		return 0;
 	}
 
+	read_lock_usermodehelper();
+
 	if (WARN_ON(usermodehelper_is_disabled())) {
 		dev_err(device, "firmware: %s will not be loaded\n", name);
 		retval = -EBUSY;
@@ -551,6 +553,7 @@ error_kfree_fw:
 	kfree(firmware);
 	*firmware_p = NULL;
 out:
+	read_unlock_usermodehelper();
 	return retval;
 }
 
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -108,8 +108,12 @@ extern int call_usermodehelper_pipe(char
 extern int usermodehelper_disable(void);
 extern void usermodehelper_enable(void);
 extern bool usermodehelper_is_disabled(void);
+extern void read_lock_usermodehelper(void);
+extern void read_unlock_usermodehelper(void);
 #else
 static inline bool usermodehelper_is_disabled(void) { return false; }
+static inline void read_lock_usermodehelper(void) {}
+static inline void read_unlock_usermodehelper(void) {}
 #endif
 
 #endif /* __LINUX_KMOD_H__ */
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -35,6 +35,7 @@
 #include <linux/resource.h>
 #include <linux/notifier.h>
 #include <linux/suspend.h>
+#include <linux/rwsem.h>
 #include <asm/uaccess.h>
 
 #include <trace/events/module.h>
@@ -43,6 +44,8 @@ extern int max_threads;
 
 static struct workqueue_struct *khelper_wq;
 
+static DECLARE_RWSEM(umhelper_sem);
+
 #ifdef CONFIG_MODULES
 
 /*
@@ -286,6 +289,7 @@ static void __call_usermodehelper(struct
  * If set, call_usermodehelper_exec() will exit immediately returning -EBUSY
  * (used for preventing user land processes from being created after the user
  * land has been frozen during a system-wide hibernation or suspend operation).
+ * Should always be manipulated under umhelper_sem acquired for write.
  */
 static int usermodehelper_disabled;
 
@@ -304,6 +308,18 @@ static DECLARE_WAIT_QUEUE_HEAD(running_h
  */
 #define RUNNING_HELPERS_TIMEOUT	(5 * HZ)
 
+void read_lock_usermodehelper(void)
+{
+	down_read(&umhelper_sem);
+}
+EXPORT_SYMBOL_GPL(read_lock_usermodehelper);
+
+void read_unlock_usermodehelper(void)
+{
+	up_read(&umhelper_sem);
+}
+EXPORT_SYMBOL_GPL(read_unlock_usermodehelper);
+
 /**
  * usermodehelper_disable - prevent new helpers from being started
  */
@@ -311,8 +327,10 @@ int usermodehelper_disable(void)
 {
 	long retval;
 
+	down_write(&umhelper_sem);
 	usermodehelper_disabled = 1;
-	smp_mb();
+	up_write(&umhelper_sem);
+
 	/*
 	 * From now on call_usermodehelper_exec() won't start any new
 	 * helpers, so it is sufficient if running_helpers turns out to
@@ -325,7 +343,9 @@ int usermodehelper_disable(void)
 	if (retval)
 		return 0;
 
+	down_write(&umhelper_sem);
 	usermodehelper_disabled = 0;
+	up_write(&umhelper_sem);
 	return -EAGAIN;
 }
 
@@ -334,7 +354,9 @@ int usermodehelper_disable(void)
  */
 void usermodehelper_enable(void)
 {
+	down_write(&umhelper_sem);
 	usermodehelper_disabled = 0;
+	up_write(&umhelper_sem);
 }
 
 /**



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab1LHRbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 12:31:42 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:59677 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab1LHRbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 12:31:41 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2] PM / Usermodehelper: Fix freezer failures due to racy
 usermodehelper_is_disabled()
To: gregkh@suse.de
Cc: dhowells@redhat.com, eparis@redhat.com, rjw@sisk.pl, kay.sievers@vrfy.org,
        jmorris@namei.org, tj@kernel.org, bp@amd64.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        namhyung@gmail.com
Date: Thu, 08 Dec 2011 23:01:30 +0530
Message-ID: <20111208173012.17763.39306.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11120817-9574-0000-0000-00000074A02F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

v2: Used rwsemaphores to implement the synchronization, as Tejun suggested.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/base/firmware_class.c |    4 ++++
 include/linux/kmod.h          |    2 ++
 kernel/kmod.c                 |   23 ++++++++++++++++++++++-
 3 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 06ed6b4..d5585da 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -534,6 +534,8 @@ static int _request_firmware(const struct firmware **firmware_p,
 		return 0;
 	}
 
+	read_lock_usermodehelper();
+
 	if (WARN_ON(usermodehelper_is_disabled())) {
 		dev_err(device, "firmware: %s will not be loaded\n", name);
 		retval = -EBUSY;
@@ -572,6 +574,8 @@ static int _request_firmware(const struct firmware **firmware_p,
 	fw_destroy_instance(fw_priv);
 
 out:
+	read_unlock_usermodehelper();
+
 	if (retval) {
 		release_firmware(firmware);
 		*firmware_p = NULL;
diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index b16f653..722f477 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -117,5 +117,7 @@ extern void usermodehelper_init(void);
 extern int usermodehelper_disable(void);
 extern void usermodehelper_enable(void);
 extern bool usermodehelper_is_disabled(void);
+extern void read_lock_usermodehelper(void);
+extern void read_unlock_usermodehelper(void);
 
 #endif /* __LINUX_KMOD_H__ */
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 2142687..2b656fe 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -34,6 +34,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/resource.h>
+#include <linux/rwsem.h>
 #include <asm/uaccess.h>
 
 #include <trace/events/module.h>
@@ -48,6 +49,7 @@ static struct workqueue_struct *khelper_wq;
 static kernel_cap_t usermodehelper_bset = CAP_FULL_SET;
 static kernel_cap_t usermodehelper_inheritable = CAP_FULL_SET;
 static DEFINE_SPINLOCK(umh_sysctl_lock);
+static DECLARE_RWSEM(umhelper_sem);
 
 #ifdef CONFIG_MODULES
 
@@ -273,6 +275,7 @@ static void __call_usermodehelper(struct work_struct *work)
  * If set, call_usermodehelper_exec() will exit immediately returning -EBUSY
  * (used for preventing user land processes from being created after the user
  * land has been frozen during a system-wide hibernation or suspend operation).
+ * Should always be manipulated under umhelper_sem acquired for write.
  */
 static int usermodehelper_disabled = 1;
 
@@ -291,6 +294,18 @@ static DECLARE_WAIT_QUEUE_HEAD(running_helpers_waitq);
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
@@ -298,8 +313,10 @@ int usermodehelper_disable(void)
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
@@ -312,7 +329,9 @@ int usermodehelper_disable(void)
 	if (retval)
 		return 0;
 
+	down_write(&umhelper_sem);
 	usermodehelper_disabled = 0;
+	up_write(&umhelper_sem);
 	return -EAGAIN;
 }
 
@@ -321,7 +340,9 @@ int usermodehelper_disable(void)
  */
 void usermodehelper_enable(void)
 {
+	down_write(&umhelper_sem);
 	usermodehelper_disabled = 0;
+	up_write(&umhelper_sem);
 }
 
 /**


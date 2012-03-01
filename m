Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965757Ab2CAVxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:53:43 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46239 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965566Ab2CAVuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:50:40 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.239.229 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120301213927.258700108@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Thu, 01 Mar 2012 13:39:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, rjw@sisk.pl, valdis.kletnieks@vt.edu,
        cloos@hjcloos.com, riesebie@lxtec.de,
        penguin-kernel@i-love.sakura.ne.jp, srivatsa.bhat@linux.vnet.ibm.com
Subject: [ 31/34] PM: Print a warning if firmware is requested when tasks are frozen
In-Reply-To: <20120301214654.GA13231@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------


From: Rafael J. Wysocki <rjw@sisk.pl>

[ Upstream commit a144c6a6c924aa1da04dd77fb84b89927354fdff ]

Some drivers erroneously use request_firmware() from their ->resume()
(or ->thaw(), or ->restore()) callbacks, which is not going to work
unless the firmware has been built in.  This causes system resume to
stall until the firmware-loading timeout expires, which makes users
think that the resume has failed and reboot their machines
unnecessarily.  For this reason, make _request_firmware() print a
warning and return immediately with error code if it has been called
when tasks are frozen and it's impossible to start any new usermode
helpers.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Reviewed-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

 drivers/base/firmware_class.c |    5 +++++
 include/linux/kmod.h          |    5 +++++
 kernel/kmod.c                 |    9 +++++++++
 3 files changed, 19 insertions(+)

--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -489,6 +489,11 @@ _request_firmware(const struct firmware
 	if (!firmware_p)
 		return -EINVAL;
 
+	if (WARN_ON(usermodehelper_is_disabled())) {
+		dev_err(device, "firmware: %s will not be loaded\n", name);
+		return -EBUSY;
+	}
+
 	*firmware_p = firmware = kzalloc(sizeof(*firmware), GFP_KERNEL);
 	if (!firmware) {
 		dev_err(device, "%s: kmalloc(struct firmware) failed\n",
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -104,7 +104,12 @@ struct file;
 extern int call_usermodehelper_pipe(char *path, char *argv[], char *envp[],
 				    struct file **filp);
 
+#ifdef CONFIG_PM_SLEEP
 extern int usermodehelper_disable(void);
 extern void usermodehelper_enable(void);
+extern bool usermodehelper_is_disabled(void);
+#else
+static inline bool usermodehelper_is_disabled(void) { return false; }
+#endif
 
 #endif /* __LINUX_KMOD_H__ */
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -337,6 +337,15 @@ void usermodehelper_enable(void)
 	usermodehelper_disabled = 0;
 }
 
+/**
+ * usermodehelper_is_disabled - check if new helpers are allowed to be started
+ */
+bool usermodehelper_is_disabled(void)
+{
+	return usermodehelper_disabled;
+}
+EXPORT_SYMBOL_GPL(usermodehelper_is_disabled);
+
 static void helper_lock(void)
 {
 	atomic_inc(&running_helpers);



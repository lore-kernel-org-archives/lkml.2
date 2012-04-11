Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813Ab2DKXQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:16:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39063 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933784Ab2DKXP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:15:59 -0400
Message-Id: <20120411231024.912032710@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:10:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [ 39/78] firmware_class: Rework usermodehelper check
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rjw@sisk.pl>

commit fe2e39d8782d885755139304d8dba0b3e5bfa878 upstream.

Instead of two functions, read_lock_usermodehelper() and
usermodehelper_is_disabled(), used in combination, introduce
usermodehelper_read_trylock() that will only return with umhelper_sem
held if usermodehelper_disabled is unset (and will return -EAGAIN
otherwise) and make _request_firmware() use it.

Rename read_unlock_usermodehelper() to
usermodehelper_read_unlock() to follow the naming convention of the
new function.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/firmware_class.c |   11 +++++------
 include/linux/kmod.h          |    5 ++---
 kernel/kmod.c                 |   24 +++++++++++-------------
 3 files changed, 18 insertions(+), 22 deletions(-)

--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -533,12 +533,10 @@ static int _request_firmware(const struc
 		return 0;
 	}
 
-	read_lock_usermodehelper();
-
-	if (WARN_ON(usermodehelper_is_disabled())) {
+	retval = usermodehelper_read_trylock();
+	if (WARN_ON(retval)) {
 		dev_err(device, "firmware: %s will not be loaded\n", name);
-		retval = -EBUSY;
-		goto out;
+		goto out_nolock;
 	}
 
 	if (uevent)
@@ -573,8 +571,9 @@ static int _request_firmware(const struc
 	fw_destroy_instance(fw_priv);
 
 out:
-	read_unlock_usermodehelper();
+	usermodehelper_read_unlock();
 
+out_nolock:
 	if (retval) {
 		release_firmware(firmware);
 		*firmware_p = NULL;
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -116,8 +116,7 @@ extern void usermodehelper_init(void);
 
 extern int usermodehelper_disable(void);
 extern void usermodehelper_enable(void);
-extern bool usermodehelper_is_disabled(void);
-extern void read_lock_usermodehelper(void);
-extern void read_unlock_usermodehelper(void);
+extern int usermodehelper_read_trylock(void);
+extern void usermodehelper_read_unlock(void);
 
 #endif /* __LINUX_KMOD_H__ */
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -296,17 +296,24 @@ static DECLARE_WAIT_QUEUE_HEAD(running_h
  */
 #define RUNNING_HELPERS_TIMEOUT	(5 * HZ)
 
-void read_lock_usermodehelper(void)
+int usermodehelper_read_trylock(void)
 {
+	int ret = 0;
+
 	down_read(&umhelper_sem);
+	if (usermodehelper_disabled) {
+		up_read(&umhelper_sem);
+		ret = -EAGAIN;
+	}
+	return ret;
 }
-EXPORT_SYMBOL_GPL(read_lock_usermodehelper);
+EXPORT_SYMBOL_GPL(usermodehelper_read_trylock);
 
-void read_unlock_usermodehelper(void)
+void usermodehelper_read_unlock(void)
 {
 	up_read(&umhelper_sem);
 }
-EXPORT_SYMBOL_GPL(read_unlock_usermodehelper);
+EXPORT_SYMBOL_GPL(usermodehelper_read_unlock);
 
 /**
  * usermodehelper_disable - prevent new helpers from being started
@@ -347,15 +354,6 @@ void usermodehelper_enable(void)
 	up_write(&umhelper_sem);
 }
 
-/**
- * usermodehelper_is_disabled - check if new helpers are allowed to be started
- */
-bool usermodehelper_is_disabled(void)
-{
-	return usermodehelper_disabled;
-}
-EXPORT_SYMBOL_GPL(usermodehelper_is_disabled);
-
 static void helper_lock(void)
 {
 	atomic_inc(&running_helpers);



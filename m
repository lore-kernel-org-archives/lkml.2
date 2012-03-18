Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab2CRXSG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 19:18:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51278 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756432Ab2CRXR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 19:17:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Christian Lamparter <chunkeey@googlemail.com>
Subject: [PATCH 1/3] firmware_class: Rework usermodehelper check
Date: Mon, 19 Mar 2012 00:17:21 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <201203181343.40760.chunkeey@googlemail.com> <201203190015.42495.rjw@sisk.pl>
In-Reply-To: <201203190015.42495.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203190017.22048.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Instead of two functions, read_lock_usermodehelper() and
usermodehelper_is_disabled(), used in combination, introduce
usermodehelper_read_trylock() that will only return with umhelper_sem
held if usermodehelper_disabled is unset (and will return -EAGAIN
otherwise) and make _request_firmware() use it.

Rename read_unlock_usermodehelper() to
usermodehelper_read_unlock() to follow the naming convention of the
new function.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/firmware_class.c |   11 +++++------
 include/linux/kmod.h          |    5 ++---
 kernel/kmod.c                 |   24 +++++++++++-------------
 3 files changed, 18 insertions(+), 22 deletions(-)

Index: linux/include/linux/kmod.h
===================================================================
--- linux.orig/include/linux/kmod.h
+++ linux/include/linux/kmod.h
@@ -116,8 +116,7 @@ extern void usermodehelper_init(void);
 
 extern int usermodehelper_disable(void);
 extern void usermodehelper_enable(void);
-extern bool usermodehelper_is_disabled(void);
-extern void read_lock_usermodehelper(void);
-extern void read_unlock_usermodehelper(void);
+extern int usermodehelper_read_trylock(void);
+extern void usermodehelper_read_unlock(void);
 
 #endif /* __LINUX_KMOD_H__ */
Index: linux/kernel/kmod.c
===================================================================
--- linux.orig/kernel/kmod.c
+++ linux/kernel/kmod.c
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
Index: linux/drivers/base/firmware_class.c
===================================================================
--- linux.orig/drivers/base/firmware_class.c
+++ linux/drivers/base/firmware_class.c
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


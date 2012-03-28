Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814Ab2C1VXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 17:23:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40752 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758763Ab2C1VWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 17:22:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/8] firmware_class: Rework usermodehelper check
Date: Wed, 28 Mar 2012 23:20:55 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <201203260000.34377.rjw@sisk.pl> <201203282319.54708.rjw@sisk.pl>
In-Reply-To: <201203282319.54708.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203282320.55385.rjw@sisk.pl>
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
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/firmware_class.c |   11 +++++------
 include/linux/kmod.h          |    5 ++---
 kernel/kmod.c                 |   24 +++++++++++-------------
 3 files changed, 18 insertions(+), 22 deletions(-)

Index: linux/include/linux/kmod.h
===================================================================
--- linux.orig/include/linux/kmod.h
+++ linux/include/linux/kmod.h
@@ -114,8 +114,7 @@ extern void usermodehelper_init(void);
 
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
@@ -339,17 +339,24 @@ static DECLARE_WAIT_QUEUE_HEAD(running_h
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
@@ -390,15 +397,6 @@ void usermodehelper_enable(void)
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


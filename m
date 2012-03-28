Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779Ab2C1VWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 17:22:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40763 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758746Ab2C1VWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 17:22:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/8] firmware_class: Do not warn that system is not ready from async loads
Date: Wed, 28 Mar 2012 23:22:23 +0200
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
Message-Id: <201203282322.23539.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

If firmware is requested asynchronously, by calling
request_firmware_nowait(), there is no reason to fail the request
(and warn the user) when the system is (presumably temporarily)
unready to handle it (because user space is not available yet or
frozen).  For this reason, introduce an alternative routine for
read-locking umhelper_sem, usermodehelper_read_lock_wait(), that
will wait for usermodehelper_disabled to be unset (possibly with
a timeout) and make request_firmware_work_func() use it instead of
usermodehelper_read_trylock().

Accordingly, modify request_firmware() so that it uses
usermodehelper_read_trylock() to acquire umhelper_sem and remove
the code related to that lock from _request_firmware().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/firmware_class.c |   51 +++++++++++++++++++++---------------
 include/linux/kmod.h          |    1 
 kernel/kmod.c                 |   58 ++++++++++++++++++++++++++++++++----------
 3 files changed, 76 insertions(+), 34 deletions(-)

Index: linux/include/linux/kmod.h
===================================================================
--- linux.orig/include/linux/kmod.h
+++ linux/include/linux/kmod.h
@@ -115,6 +115,7 @@ extern void usermodehelper_init(void);
 extern int usermodehelper_disable(void);
 extern void usermodehelper_enable(void);
 extern int usermodehelper_read_trylock(void);
+extern long usermodehelper_read_lock_wait(long timeout);
 extern void usermodehelper_read_unlock(void);
 
 #endif /* __LINUX_KMOD_H__ */
Index: linux/kernel/kmod.c
===================================================================
--- linux.orig/kernel/kmod.c
+++ linux/kernel/kmod.c
@@ -334,6 +334,12 @@ static atomic_t running_helpers = ATOMIC
 static DECLARE_WAIT_QUEUE_HEAD(running_helpers_waitq);
 
 /*
+ * Used by usermodehelper_read_lock_wait() to wait for usermodehelper_disabled
+ * to become 'false'.
+ */
+static DECLARE_WAIT_QUEUE_HEAD(usermodehelper_disabled_waitq);
+
+/*
  * Time to wait for running_helpers to become zero before the setting of
  * usermodehelper_disabled in usermodehelper_disable() fails
  */
@@ -352,6 +358,33 @@ int usermodehelper_read_trylock(void)
 }
 EXPORT_SYMBOL_GPL(usermodehelper_read_trylock);
 
+long usermodehelper_read_lock_wait(long timeout)
+{
+	DEFINE_WAIT(wait);
+
+	if (timeout < 0)
+		return -EINVAL;
+
+	down_read(&umhelper_sem);
+	for (;;) {
+		prepare_to_wait(&usermodehelper_disabled_waitq, &wait,
+				TASK_UNINTERRUPTIBLE);
+		if (!usermodehelper_disabled)
+			break;
+
+		up_read(&umhelper_sem);
+
+		timeout = schedule_timeout(timeout);
+		if (!timeout)
+			break;
+
+		down_read(&umhelper_sem);
+	}
+	finish_wait(&usermodehelper_disabled_waitq, &wait);
+	return timeout;
+}
+EXPORT_SYMBOL_GPL(usermodehelper_read_lock_wait);
+
 void usermodehelper_read_unlock(void)
 {
 	up_read(&umhelper_sem);
@@ -359,6 +392,17 @@ void usermodehelper_read_unlock(void)
 EXPORT_SYMBOL_GPL(usermodehelper_read_unlock);
 
 /**
+ * usermodehelper_enable - allow new helpers to be started again
+ */
+void usermodehelper_enable(void)
+{
+	down_write(&umhelper_sem);
+	usermodehelper_disabled = 0;
+	wake_up(&usermodehelper_disabled_waitq);
+	up_write(&umhelper_sem);
+}
+
+/**
  * usermodehelper_disable - prevent new helpers from being started
  */
 int usermodehelper_disable(void)
@@ -381,22 +425,10 @@ int usermodehelper_disable(void)
 	if (retval)
 		return 0;
 
-	down_write(&umhelper_sem);
-	usermodehelper_disabled = 0;
-	up_write(&umhelper_sem);
+	usermodehelper_enable();
 	return -EAGAIN;
 }
 
-/**
- * usermodehelper_enable - allow new helpers to be started again
- */
-void usermodehelper_enable(void)
-{
-	down_write(&umhelper_sem);
-	usermodehelper_disabled = 0;
-	up_write(&umhelper_sem);
-}
-
 static void helper_lock(void)
 {
 	atomic_inc(&running_helpers);
Index: linux/drivers/base/firmware_class.c
===================================================================
--- linux.orig/drivers/base/firmware_class.c
+++ linux/drivers/base/firmware_class.c
@@ -81,6 +81,11 @@ enum {
 
 static int loading_timeout = 60;	/* In seconds */
 
+static inline long firmware_loading_timeout(void)
+{
+	return loading_timeout > 0 ? loading_timeout * HZ : MAX_SCHEDULE_TIMEOUT;
+}
+
 /* fw_lock could be moved to 'struct firmware_priv' but since it is just
  * guarding for corner cases a global lock should be OK */
 static DEFINE_MUTEX(fw_lock);
@@ -541,31 +546,22 @@ static void _request_firmware_cleanup(co
 
 static int _request_firmware(const struct firmware *firmware,
 			     const char *name, struct device *device,
-			     bool uevent, bool nowait)
+			     bool uevent, bool nowait, long timeout)
 {
 	struct firmware_priv *fw_priv;
-	int retval;
-
-	retval = usermodehelper_read_trylock();
-	if (WARN_ON(retval)) {
-		dev_err(device, "firmware: %s will not be loaded\n", name);
-		return retval;
-	}
+	int retval = 0;
 
 	if (uevent)
 		dev_dbg(device, "firmware: requesting %s\n", name);
 
 	fw_priv = fw_create_instance(firmware, name, device, uevent, nowait);
-	if (IS_ERR(fw_priv)) {
-		retval = PTR_ERR(fw_priv);
-		goto out;
-	}
+	if (IS_ERR(fw_priv))
+		return PTR_ERR(fw_priv);
 
 	if (uevent) {
-		if (loading_timeout > 0)
+		if (timeout != MAX_SCHEDULE_TIMEOUT)
 			mod_timer(&fw_priv->timeout,
-				  round_jiffies_up(jiffies +
-						   loading_timeout * HZ));
+				  round_jiffies_up(jiffies + timeout));
 
 		kobject_uevent(&fw_priv->dev.kobj, KOBJ_ADD);
 	}
@@ -582,9 +578,6 @@ static int _request_firmware(const struc
 	mutex_unlock(&fw_lock);
 
 	fw_destroy_instance(fw_priv);
-
-out:
-	usermodehelper_read_unlock();
 	return retval;
 }
 
@@ -613,7 +606,14 @@ request_firmware(const struct firmware *
 	if (ret <= 0)
 		return ret;
 
-	ret = _request_firmware(*firmware_p, name, device, true, false);
+	ret = usermodehelper_read_trylock();
+	if (WARN_ON(ret)) {
+		dev_err(device, "firmware: %s will not be loaded\n", name);
+	} else {
+		ret = _request_firmware(*firmware_p, name, device, true, false,
+					firmware_loading_timeout());
+		usermodehelper_read_unlock();
+	}
 	if (ret)
 		_request_firmware_cleanup(firmware_p);
 
@@ -648,6 +648,7 @@ static int request_firmware_work_func(vo
 {
 	struct firmware_work *fw_work = arg;
 	const struct firmware *fw;
+	long timeout;
 	int ret;
 
 	if (!arg) {
@@ -659,8 +660,16 @@ static int request_firmware_work_func(vo
 	if (ret <= 0)
 		goto out;
 
-	ret = _request_firmware(fw, fw_work->name, fw_work->device,
-				fw_work->uevent, true);
+	timeout = usermodehelper_read_lock_wait(firmware_loading_timeout());
+	if (timeout) {
+		ret = _request_firmware(fw, fw_work->name, fw_work->device,
+					fw_work->uevent, true, timeout);
+		usermodehelper_read_unlock();
+	} else {
+		dev_dbg(fw_work->device, "firmware: %s loading timed out\n",
+			fw_work->name);
+		ret = -EAGAIN;
+	}
 	if (ret)
 		_request_firmware_cleanup(&fw);
 


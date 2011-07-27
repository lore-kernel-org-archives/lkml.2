Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab1G0USv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 16:18:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:35092 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864Ab1G0URj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 16:17:39 -0400
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Wim Van Sebroeck <wim@iguana.be>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 4/9] watchdog: WatchDog Timer Driver Core - Add WDIOC_SETOPTIONS ioctl
Date: Wed, 27 Jul 2011 20:16:35 +0000
Message-Id: <1311797800-2706-4-git-send-email-wim@iguana.be>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311797800-2706-1-git-send-email-wim@iguana.be>
References: <20110727201537.GA13819@infomag.iguana.be>
 <1311797800-2706-1-git-send-email-wim@iguana.be>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Jul 2011 20:17:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This part add's the WDIOC_SETOPTIONS ioctl functionality
to the WatchDog Timer Driver Core framework.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
---
 Documentation/watchdog/watchdog-kernel-api.txt |    9 ++-
 drivers/watchdog/watchdog_dev.c                |   79 +++++++++++++++++++++--
 include/linux/watchdog.h                       |    1 +
 3 files changed, 80 insertions(+), 9 deletions(-)

diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index abbcf2c..429f81b 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -56,8 +56,9 @@ It contains following fields:
   This data should only be accessed via the watchdog_set_drvadata and
   watchdog_get_drvdata routines.
 * status: this field contains a number of status bits that give extra
-  information about the status of the device (Like: is the device opened via
-  the /dev/watchdog interface or not, ...).
+  information about the status of the device (Like: is the watchdog timer
+  running/active, is the device opened via the /dev/watchdog interface or not,
+  ...).
 
 The list of watchdog operations is defined as:
 
@@ -109,6 +110,10 @@ they are supported. These optional routines/operations are:
 
 The status bits should (preferably) be set with the set_bit and clear_bit alike
 bit-operations. The status bits that are defined are:
+* WDOG_ACTIVE: this status bit indicates whether or not a watchdog timer device
+  is active or not. When the watchdog is active after booting, then you should
+  set this status bit (Note: when you register the watchdog timer device with
+  this bit set, then opening /dev/watchdog will skip the start operation)
 * WDOG_DEV_OPEN: this status bit shows whether or not the watchdog device
   was opened via /dev/watchdog.
   (This bit should only be used by the WatchDog Timer Driver Core).
diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 2fb4cec..9f5550e 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -54,14 +54,64 @@ static struct watchdog_device *wdd;
  *	If the watchdog has no own ping operation then it needs to be
  *	restarted via the start operation. This wrapper function does
  *	exactly that.
+ *	We only ping when the watchdog device is running.
  */
 
 static int watchdog_ping(struct watchdog_device *wddev)
 {
-	if (wddev->ops->ping)
-		return wddev->ops->ping(wddev);  /* ping the watchdog */
-	else
-		return wddev->ops->start(wddev); /* restart the watchdog */
+	if (test_bit(WDOG_ACTIVE, &wdd->status)) {
+		if (wddev->ops->ping)
+			return wddev->ops->ping(wddev);  /* ping the watchdog */
+		else
+			return wddev->ops->start(wddev); /* restart watchdog */
+	}
+	return 0;
+}
+
+/*
+ *	watchdog_start: wrapper to start the watchdog.
+ *	@wddev: the watchdog device to start
+ *
+ *	Start the watchdog if it is not active and mark it active.
+ *	This function returns zero on success or a negative errno code for
+ *	failure.
+ */
+
+static int watchdog_start(struct watchdog_device *wddev)
+{
+	int err;
+
+	if (!test_bit(WDOG_ACTIVE, &wdd->status)) {
+		err = wddev->ops->start(wddev);
+		if (err < 0)
+			return err;
+
+		set_bit(WDOG_ACTIVE, &wdd->status);
+	}
+	return 0;
+}
+
+/*
+ *	watchdog_stop: wrapper to stop the watchdog.
+ *	@wddev: the watchdog device to stop
+ *
+ *	Stop the watchdog if it is still active and unmark it active.
+ *	This function returns zero on success or a negative errno code for
+ *	failure.
+ */
+
+static int watchdog_stop(struct watchdog_device *wddev)
+{
+	int err;
+
+	if (test_bit(WDOG_ACTIVE, &wdd->status)) {
+		err = wddev->ops->stop(wddev);
+		if (err < 0)
+			return err;
+
+		clear_bit(WDOG_ACTIVE, &wdd->status);
+	}
+	return 0;
 }
 
 /*
@@ -110,6 +160,7 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	unsigned int val;
+	int err;
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
@@ -120,6 +171,20 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
 		return put_user(val, p);
 	case WDIOC_GETBOOTSTATUS:
 		return put_user(wdd->bootstatus, p);
+	case WDIOC_SETOPTIONS:
+		if (get_user(val, p))
+			return -EFAULT;
+		if (val & WDIOS_DISABLECARD) {
+			err = watchdog_stop(wdd);
+			if (err < 0)
+				return err;
+		}
+		if (val & WDIOS_ENABLECARD) {
+			err = watchdog_start(wdd);
+			if (err < 0)
+				return err;
+		}
+		return 0;
 	case WDIOC_KEEPALIVE:
 		if (!(wdd->info->options & WDIOF_KEEPALIVEPING))
 			return -EOPNOTSUPP;
@@ -155,7 +220,7 @@ static int watchdog_open(struct inode *inode, struct file *file)
 	if (!try_module_get(wdd->ops->owner))
 		goto out;
 
-	err = wdd->ops->start(wdd);
+	err = watchdog_start(wdd);
 	if (err < 0)
 		goto out_mod;
 
@@ -181,8 +246,8 @@ static int watchdog_release(struct inode *inode, struct file *file)
 {
 	int err;
 
-	err = wdd->ops->stop(wdd);
-	if (err != 0) {
+	err = watchdog_stop(wdd);
+	if (err < 0) {
 		pr_crit("%s: watchdog did not stop!\n", wdd->info->identity);
 		watchdog_ping(wdd);
 	}
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index 29ff808..db46fe8 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -106,6 +106,7 @@ struct watchdog_device {
 	void *driver_data;
 	unsigned long status;
 /* Bit numbers for status flags */
+#define WDOG_ACTIVE		0	/* Is the watchdog running/active */
 #define WDOG_DEV_OPEN		1	/* Opened via /dev/watchdog ? */
 };
 
-- 
1.7.6


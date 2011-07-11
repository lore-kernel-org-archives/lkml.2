Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab1GKOWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:22:06 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:18268 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752874Ab1GKOWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:22:04 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAJMFG05tg34q/2dsb2JhbABGDac5eIh8v0AOgxWDFwSSVIgiiCc
Date: Mon, 11 Jul 2011 16:22:02 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 04/11] watchdog: WatchDog Timer Driver Core - Add
	WDIOC_SETOPTIONS ioctl
Message-ID: <1310392522-9949-4-git-send-email-wim@iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310392522-9949-1-git-send-email-wim@iguana.be>
X-Mailer: git-send-email 1.7.6
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This part add's the WDIOC_SETOPTIONS ioctl functionality
to the WatchDog Timer Driver Core framework.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
---
 Documentation/watchdog/watchdog-kernel-api.txt |    9 ++-
 drivers/watchdog/watchdog_dev.c                |   79 +++++++++++++++++++++--
 include/linux/watchdog.h                       |    1 +
 3 files changed, 80 insertions(+), 9 deletions(-)

diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index 8ca0571..6df1ade 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -54,8 +54,9 @@ It contains following fields:
   WDIOF_* status bits).
 * priv: a pointer to the private data of a watchdog device
 * status: this field contains a number of status bits that give extra
-  information about the status of the device (Like: is the device opened via
-  the /dev/watchdog interface or not, ...)
+  information about the status of the device (Like: is the watchdog timer
+  running/active, is the device opened via the /dev/watchdog interface or not,
+  ...)
 
 The list of watchdog operations is defined as:
 
@@ -107,6 +108,10 @@ they are supported. These optional routines/operations are:
 
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
index cc361e1..530003b 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -65,14 +65,64 @@ static struct watchdog_device *wdd;
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
@@ -121,6 +171,7 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	unsigned int val;
+	int err;
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
@@ -131,6 +182,20 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
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
@@ -168,7 +233,7 @@ static int watchdog_open(struct inode *inode, struct file *file)
 		goto out;
 
 	/* start the watchdog */
-	err = wdd->ops->start(wdd);
+	err = watchdog_start(wdd);
 	if (err < 0)
 		goto out_mod;
 
@@ -195,8 +260,8 @@ static int watchdog_release(struct inode *inode, struct file *file)
 	int err;
 
 	/* stop the watchdog */
-	err = wdd->ops->stop(wdd);
-	if (err != 0) {
+	err = watchdog_stop(wdd);
+	if (err < 0) {
 		pr_crit("%s: watchdog did not stop!\n", wdd->info->identity);
 		watchdog_ping(wdd);
 	}
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index a2b639b..853387f 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -81,6 +81,7 @@ struct watchdog_device {
 	void *priv;
 	unsigned long status;
 /* Bit numbers for status flags */
+#define WDOG_ACTIVE		0	/* Is the watchdog running/active */
 #define WDOG_DEV_OPEN		1	/* Opened via /dev/watchdog ? */
 };
 
-- 
1.7.6


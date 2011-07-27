Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab1G0URq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 16:17:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:35085 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748Ab1G0UR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 16:17:29 -0400
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Wim Van Sebroeck <wim@iguana.be>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 2/9] watchdog: WatchDog Timer Driver Core - Add basic ioctl functionality
Date: Wed, 27 Jul 2011 20:16:33 +0000
Message-Id: <1311797800-2706-2-git-send-email-wim@iguana.be>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311797800-2706-1-git-send-email-wim@iguana.be>
References: <20110727201537.GA13819@infomag.iguana.be>
 <1311797800-2706-1-git-send-email-wim@iguana.be>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Jul 2011 20:17:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This part add's the basic ioctl functionality to the
WatchDog Timer Driver Core framework. The supported
ioctl call's are:
	WDIOC_GETSUPPORT
	WDIOC_GETSTATUS
	WDIOC_GETBOOTSTATUS

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
---
 Documentation/watchdog/watchdog-kernel-api.txt |    6 ++++
 drivers/watchdog/watchdog_dev.c                |   32 ++++++++++++++++++++++++
 include/linux/watchdog.h                       |    4 +++
 3 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index 3db67e7..2bdc6dc 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -41,6 +41,7 @@ The watchdog device structure looks like this:
 struct watchdog_device {
 	const struct watchdog_info *info;
 	const struct watchdog_ops *ops;
+	unsigned int bootstatus;
 	void *driver_data;
 	unsigned long status;
 };
@@ -49,6 +50,8 @@ It contains following fields:
 * info: a pointer to a watchdog_info structure. This structure gives some
   additional information about the watchdog timer itself. (Like it's unique name)
 * ops: a pointer to the list of watchdog operations that the watchdog supports.
+* bootstatus: status of the device after booting (reported with watchdog
+  WDIOF_* status bits).
 * driver_data: a pointer to the drivers private data of a watchdog device.
   This data should only be accessed via the watchdog_set_drvadata and
   watchdog_get_drvdata routines.
@@ -65,6 +68,7 @@ struct watchdog_ops {
 	int (*stop)(struct watchdog_device *);
 	/* optional operations */
 	int (*ping)(struct watchdog_device *);
+	unsigned int (*status)(struct watchdog_device *);
 };
 
 It is important that you first define the module owner of the watchdog timer
@@ -97,6 +101,8 @@ they are supported. These optional routines/operations are:
   the watchdog timer driver core does: to send a keepalive ping to the watchdog
   timer hardware it will either use the ping operation (when available) or the
   start operation (when the ping operation is not available).
+* status: this routine checks the status of the watchdog timer device. The
+  status of the device is reported with watchdog WDIOF_* status flags/bits.
 
 The status bits should (preferably) be set with the set_bit and clear_bit alike
 bit-operations. The status bits that are defined are:
diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 366f49c..00a6112 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -95,6 +95,37 @@ static ssize_t watchdog_write(struct file *file, const char __user *data,
 }
 
 /*
+ *	watchdog_ioctl: handle the different ioctl's for the watchdog device.
+ *	@file: file handle to the device
+ *	@cmd: watchdog command
+ *	@arg: argument pointer
+ *
+ *	The watchdog API defines a common set of functions for all watchdogs
+ *	according to their available features.
+ */
+
+static long watchdog_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	unsigned int val;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, wdd->info,
+			sizeof(struct watchdog_info)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+		val = wdd->ops->status ? wdd->ops->status(wdd) : 0;
+		return put_user(val, p);
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(wdd->bootstatus, p);
+	default:
+		return -ENOTTY;
+	}
+}
+
+/*
  *	watchdog_open: open the /dev/watchdog device.
  *	@inode: inode of device
  *	@file: file handle to device
@@ -163,6 +194,7 @@ static int watchdog_release(struct inode *inode, struct file *file)
 static const struct file_operations watchdog_fops = {
 	.owner		= THIS_MODULE,
 	.write		= watchdog_write,
+	.unlocked_ioctl	= watchdog_ioctl,
 	.open		= watchdog_open,
 	.release	= watchdog_release,
 };
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index 5ab31bf..29ff808 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -68,6 +68,7 @@ struct watchdog_device;
  * @start:	The routine for starting the watchdog device.
  * @stop:	The routine for stopping the watchdog device.
  * @ping:	The routine that sends a keepalive ping to the watchdog device.
+ * @status:	The routine that shows the status of the watchdog device.
  *
  * The watchdog_ops structure contains a list of low-level operations
  * that control a watchdog device. It also contains the module that owns
@@ -81,12 +82,14 @@ struct watchdog_ops {
 	int (*stop)(struct watchdog_device *);
 	/* optional operations */
 	int (*ping)(struct watchdog_device *);
+	unsigned int (*status)(struct watchdog_device *);
 };
 
 /** struct watchdog_device - The structure that defines a watchdog device
  *
  * @info:	Pointer to a watchdog_info structure.
  * @ops:	Pointer to the list of watchdog operations.
+ * @bootstatus:	Status of the watchdog device at boot.
  * @driver-data:Pointer to the drivers private data.
  * @status:	Field that contains the devices internal status bits.
  *
@@ -99,6 +102,7 @@ struct watchdog_ops {
 struct watchdog_device {
 	const struct watchdog_info *info;
 	const struct watchdog_ops *ops;
+	unsigned int bootstatus;
 	void *driver_data;
 	unsigned long status;
 /* Bit numbers for status flags */
-- 
1.7.6


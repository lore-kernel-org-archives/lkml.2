Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312Ab1FRRUs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 13:20:48 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:24807 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764Ab1FRRUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 13:20:45 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAKzc/E1tgyeh/2dsb2JhbABFDaZeeIh1vRkOgxCDDAShYQ
Date: Sat, 18 Jun 2011 19:20:43 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/10 v2] Generic Watchdog Timer Driver
Message-ID: <20110618172043.GC3441@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

watchdog: WatchDog Timer Driver Core - Part 2

This part add's the basic ioctl functionality to the
WatchDog Timer Driver Core framework. The supported
ioctl call's are:
	WDIOC_GETSUPPORT
	WDIOC_GETSTATUS
	WDIOC_GETBOOTSTATUS

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

diff -urN linux-2.6.38-generic-part1/Documentation/watchdog/src/watchdog-with-timer-example.c linux-2.6.38-generic-part2/Documentation/watchdog/src/watchdog-with-timer-example.c
--- linux-2.6.38-generic-part1/Documentation/watchdog/src/watchdog-with-timer-example.c	2011-06-16 20:07:33.939170516 +0200
+++ linux-2.6.38-generic-part2/Documentation/watchdog/src/watchdog-with-timer-example.c	2011-06-16 20:07:44.671177621 +0200
@@ -115,6 +115,10 @@
 /*
  * The watchdog kernel structures
  */
+static const struct watchdog_info wdt_info = {
+	.identity =	DRV_NAME,
+};
+
 static const struct watchdog_ops wdt_ops = {
 	.owner =	THIS_MODULE,
 	.start =	wdt_start,
@@ -124,6 +128,7 @@
 
 static struct watchdog_device wdt_dev = {
 	.name =		DRV_NAME,
+	.info =		&wdt_info,
 	.ops =		&wdt_ops,
 };
 
diff -urN linux-2.6.38-generic-part1/Documentation/watchdog/watchdog-kernel-api.txt linux-2.6.38-generic-part2/Documentation/watchdog/watchdog-kernel-api.txt
--- linux-2.6.38-generic-part1/Documentation/watchdog/watchdog-kernel-api.txt	2011-06-16 14:26:05.928061789 +0200
+++ linux-2.6.38-generic-part2/Documentation/watchdog/watchdog-kernel-api.txt	2011-06-16 16:57:31.388541823 +0200
@@ -40,13 +40,19 @@
 
 struct watchdog_device {
 	char *name;
+	const struct watchdog_info *info;
 	const struct watchdog_ops *ops;
+	int bootstatus;
 	long status;
 };
 
 It contains following fields:
 * name: a pointer to the (preferably unique) name of the watchdog timer device.
+* info: a pointer to a watchdog_info structure. This structure gives some
+  additional information about the watchdog timer itself.
 * ops: a pointer to the list of watchdog operations that the watchdog supports.
+* bootstatus: status of the device after booting (reported with watchdog
+  WDIOF_* status bits).
 * status: this field contains a number of status bits that give extra
   information about the status of the device (Like: is the device opened via
   the /dev/watchdog interface or not, ...)
@@ -60,6 +66,7 @@
 	int (*stop)(struct watchdog_device *);
 	/* optional operations */
 	int (*ping)(struct watchdog_device *);
+	int (*status)(struct watchdog_device *);
 };
 
 It is important that you first define the module owner of the watchdog timer
@@ -94,6 +101,8 @@
   the watchdog timer driver core does: to send a keepalive ping to the watchdog
   timer hardware it will either use the ping operation (when available) or the
   start operation (when the ping operation is not available).
+* status: this routine checks the status of the watchdog timer device. The
+  status of the device is reported with watchdog WDIOF_* status flags/bits.
 
 The status bits should (preferably) be set with the set_bit and clear_bit alike
 bit-operations. The status bit's that are defined are:
diff -urN linux-2.6.38-generic-part1/drivers/watchdog/core/watchdog_core.c linux-2.6.38-generic-part2/drivers/watchdog/core/watchdog_core.c
--- linux-2.6.38-generic-part1/drivers/watchdog/core/watchdog_core.c	2011-06-16 19:24:39.955179826 +0200
+++ linux-2.6.38-generic-part2/drivers/watchdog/core/watchdog_core.c	2011-06-16 19:33:08.647178048 +0200
@@ -59,7 +59,7 @@
 	int ret;
 
 	/* Make sure we have a valid watchdog_device structure */
-	if (wdd == NULL || wdd->ops == NULL)
+	if (wdd == NULL || wdd->info == NULL || wdd->ops == NULL)
 		return -ENODATA;
 
 	/* Make sure that the mandatory operations are supported */
diff -urN linux-2.6.38-generic-part1/drivers/watchdog/core/watchdog_dev.c linux-2.6.38-generic-part2/drivers/watchdog/core/watchdog_dev.c
--- linux-2.6.38-generic-part1/drivers/watchdog/core/watchdog_dev.c	2011-06-16 19:32:27.183186141 +0200
+++ linux-2.6.38-generic-part2/drivers/watchdog/core/watchdog_dev.c	2011-06-16 19:34:22.927178838 +0200
@@ -125,6 +125,41 @@
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
+	int val = 0;
+
+	trace("%p, %u, %li", file, cmd, arg);
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, wdd->info,
+			sizeof(struct watchdog_info)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+		if (wdd->ops->status)
+			val = wdd->ops->status(wdd);
+		return put_user(val, p);
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(wdd->bootstatus, p);
+	default:
+		return -ENOTTY;
+	}
+	return -ENOTTY;
+}
+
+/*
  *	watchdog_open: open the /dev/watchdog device.
  *	@inode: inode of device
  *	@file: file handle to device
@@ -202,6 +237,7 @@
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= watchdog_write,
+	.unlocked_ioctl	= watchdog_ioctl,
 	.open		= watchdog_open,
 	.release	= watchdog_release,
 };
diff -urN linux-2.6.38-generic-part1/include/linux/watchdog.h linux-2.6.38-generic-part2/include/linux/watchdog.h
--- linux-2.6.38-generic-part1/include/linux/watchdog.h	2011-06-16 14:28:32.848061741 +0200
+++ linux-2.6.38-generic-part2/include/linux/watchdog.h	2011-06-16 16:57:31.388541823 +0200
@@ -70,12 +70,15 @@
 	int (*stop)(struct watchdog_device *);
 	/* optional operations */
 	int (*ping)(struct watchdog_device *);
+	int (*status)(struct watchdog_device *);
 };
 
 /* The structure that defines a watchdog device */
 struct watchdog_device {
 	char *name;
+	const struct watchdog_info *info;
 	const struct watchdog_ops *ops;
+	int bootstatus;
 	long status;
 #define WDOG_DEV_OPEN		1	/* is the watchdog opened via
 					 * /dev/watchdog */

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab1BWUmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:42:32 -0500
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:46373 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752166Ab1BWUmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:42:31 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAH7+ZE1R8sEZ/2dsb2JhbACmIHS8HQ2CcYJgBA
Date: Wed, 23 Feb 2011 21:42:28 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [RFC] [PATCH 2/10] Generic Watchdog Timer Driver
Message-ID: <20110223204228.GA7369@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 79a856016f4f4314360d6efbbbc334828006a79f
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri Jun 18 08:58:13 2010 +0000

    watchdog: WatchDog Timer Driver Core - Part 2
    
    This part add's the basic ioctl functionality to the
    WatchDog Timer Driver Core framework. The supported
    ioctl call's are:
    	WDIOC_GETSUPPORT
    	WDIOC_GETSTATUS
    	WDIOC_GETBOOTSTATUS
    
    Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

diff --git a/Documentation/watchdog/src/watchdog-with-timer-example.c b/Documentation/watchdog/src/watchdog-with-timer-example.c
index d0b6056..ed7852a 100644
--- a/Documentation/watchdog/src/watchdog-with-timer-example.c
+++ b/Documentation/watchdog/src/watchdog-with-timer-example.c
@@ -115,6 +115,10 @@ static int wdt_stop(struct watchdog_device *wdd)
 /*
  * The watchdog kernel structures
  */
+static const struct watchdog_info wdt_info = {
+	.identity =	DRV_NAME,
+};
+
 static const struct watchdog_ops wdt_ops = {
 	.start =	wdt_start,
 	.stop =		wdt_stop,
@@ -123,6 +127,7 @@ static const struct watchdog_ops wdt_ops = {
 
 static struct watchdog_device wdt_dev = {
 	.name =		DRV_NAME,
+	.info =		&wdt_info,
 	.ops =		&wdt_ops,
 };
 
diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index e69d1cc..9418d4c 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -40,13 +40,19 @@ The watchdog device structure looks like this:
 
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
@@ -59,6 +65,7 @@ struct watchdog_ops {
 	int (*stop)(struct watchdog_device *);
 	/* optional operations */
 	int (*ping)(struct watchdog_device *);
+	int (*status)(struct watchdog_device *);
 };
 
 Some operations are mandatory and some are optional. The mandatory operations
@@ -89,6 +96,8 @@ they are supported. These optional routines/operations are:
   the watchdog timer driver core does: to send a keepalive ping to the watchdog
   timer hardware it will either use the ping operation (when available) or the
   start operation (when the ping operation is not available).
+* status: this routine checks the status of the watchdog timer device. The
+  status of the device is reported with watchdog WDIOF_* status flags/bits.
 
 The status bits should (preferably) be set with the set_bit and clear_bit alike
 bit-operations. The status bit's that are defined are:
diff --git a/drivers/watchdog/core/watchdog_core.c b/drivers/watchdog/core/watchdog_core.c
index d37006c..52bc520 100644
--- a/drivers/watchdog/core/watchdog_core.c
+++ b/drivers/watchdog/core/watchdog_core.c
@@ -57,7 +57,7 @@ int register_watchdogdevice(struct watchdog_device *wdd)
 	int ret;
 
 	/* Make sure we have a valid watchdog_device structure */
-	if (wdd == NULL || wdd->ops == NULL)
+	if (wdd == NULL || wdd->info == NULL || wdd->ops == NULL)
 		return -ENODATA;
 
 	/* Make sure that the mandatory operations are supported */
diff --git a/drivers/watchdog/core/watchdog_dev.c b/drivers/watchdog/core/watchdog_dev.c
index 881ca42..ad08a93 100644
--- a/drivers/watchdog/core/watchdog_dev.c
+++ b/drivers/watchdog/core/watchdog_dev.c
@@ -123,6 +123,41 @@ static ssize_t watchdog_write(struct file *file, const char __user *data,
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
@@ -190,6 +225,7 @@ static const struct file_operations watchdog_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= watchdog_write,
+	.unlocked_ioctl	= watchdog_ioctl,
 	.open		= watchdog_open,
 	.release	= watchdog_release,
 };

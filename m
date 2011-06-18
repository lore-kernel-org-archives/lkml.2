Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab1FRRXF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 13:23:05 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:63427 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750782Ab1FRRXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 13:23:03 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAKTd/E1tgyeh/2dsb2JhbABSpl54iHW9Gw6GHAShYQ
Date: Sat, 18 Jun 2011 19:23:01 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 4/10 v2] Generic Watchdog Timer Driver
Message-ID: <20110618172301.GE3441@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

watchdog: WatchDog Timer Driver Core - Part 4

This part add's the WDIOC_SETOPTIONS ioctl functionality
to the WatchDog Timer Driver Core framework.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

diff -urN linux-2.6.38-generic-part3/Documentation/watchdog/src/watchdog-with-timer-example.c linux-2.6.38-generic-part4/Documentation/watchdog/src/watchdog-with-timer-example.c
--- linux-2.6.38-generic-part3/Documentation/watchdog/src/watchdog-with-timer-example.c	2011-06-16 20:07:53.631174037 +0200
+++ linux-2.6.38-generic-part4/Documentation/watchdog/src/watchdog-with-timer-example.c	2011-06-16 20:08:16.987178248 +0200
@@ -45,11 +45,11 @@
 MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. "
 	"(default = " __MODULE_STRING(WDT_TIMEOUT) ")");
 
+static struct watchdog_device wdt_dev;
 static void wdt_timer_tick(unsigned long data);
 static DEFINE_TIMER(timer, wdt_timer_tick, 0, 0);
 					/* The timer that pings the watchdog */
 static unsigned long next_heartbeat;	/* the next_heartbeat for the timer */
-static unsigned long running;		/* is watchdog running for userspace? */
 
 static struct platform_device *wdt_platform_device;
 
@@ -73,7 +73,7 @@
 static void wdt_timer_tick(unsigned long data)
 {
 	if (time_before(jiffies, next_heartbeat) ||
-			(!running)) {
+	    (!test_bit(WDOG_ACTIVE, &wdt_dev.status))) {
 		wdt_reset();
 		mod_timer(&timer, jiffies + WDT_HEARTBEAT);
 	} else
@@ -99,7 +99,6 @@
 	/* Start the watchdog timer hardware here */
 	pr_info("wdt_start\n");
 
-	running = 1;
 	return 0;
 }
 
@@ -108,7 +107,6 @@
 	/* The watchdog timer hardware can not be stopped... */
 	pr_info("wdt_stop\n");
 
-	running = 0;
 	return 0;
 }
 
diff -urN linux-2.6.38-generic-part3/Documentation/watchdog/watchdog-kernel-api.txt linux-2.6.38-generic-part4/Documentation/watchdog/watchdog-kernel-api.txt
--- linux-2.6.38-generic-part3/Documentation/watchdog/watchdog-kernel-api.txt	2011-06-16 18:44:20.747179936 +0200
+++ linux-2.6.38-generic-part4/Documentation/watchdog/watchdog-kernel-api.txt	2011-06-16 19:14:34.603180137 +0200
@@ -54,8 +54,9 @@
 * bootstatus: status of the device after booting (reported with watchdog
   WDIOF_* status bits).
 * status: this field contains a number of status bits that give extra
-  information about the status of the device (Like: is the device opened via
-  the /dev/watchdog interface or not, ...)
+  information about the status of the device (Like: is the watchdog timer
+  running/active, is the device opened via the /dev/watchdog interface or not,
+  ...)
 
 The list of watchdog operations is defined as:
 
@@ -109,6 +110,10 @@
 
 The status bits should (preferably) be set with the set_bit and clear_bit alike
 bit-operations. The status bit's that are defined are:
+* WDOG_ACTIVE: this status bit indicates whether or not a watchdog timer device
+  is active or not. When the watchdog is active after booting, then you should
+  set this status bit (Note: when you register the watchdog timer device with
+  this bit set, then opening /dev/watchdog will skip the start operation)
 * WDOG_DEV_OPEN: this status bit shows whether or not the watchdog device
   was opened via /dev/watchdog.
   (This bit should only be used by the WatchDog Timer Driver Core).
diff -urN linux-2.6.38-generic-part3/drivers/watchdog/core/watchdog_dev.c linux-2.6.38-generic-part4/drivers/watchdog/core/watchdog_dev.c
--- linux-2.6.38-generic-part3/drivers/watchdog/core/watchdog_dev.c	2011-06-16 19:35:22.415178710 +0200
+++ linux-2.6.38-generic-part4/drivers/watchdog/core/watchdog_dev.c	2011-06-16 19:36:11.571178880 +0200
@@ -82,14 +82,64 @@
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
@@ -140,6 +190,7 @@
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int val = 0;
+	int err;
 
 	trace("%p, %u, %li", file, cmd, arg);
 
@@ -153,6 +204,20 @@
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
@@ -190,7 +255,7 @@
 		goto out;
 
 	/* start the watchdog */
-	err = wdd->ops->start(wdd);
+	err = watchdog_start(wdd);
 	if (err < 0)
 		goto out_mod;
 
@@ -219,8 +284,8 @@
 	trace("%p, %p", inode, file);
 
 	/* stop the watchdog */
-	err = wdd->ops->stop(wdd);
-	if (err != 0) {
+	err = watchdog_stop(wdd);
+	if (err < 0) {
 		pr_crit("%s: not stopping watchdog!\n", wdd->name);
 		watchdog_ping(wdd);
 	}
diff -urN linux-2.6.38-generic-part3/include/linux/watchdog.h linux-2.6.38-generic-part4/include/linux/watchdog.h
--- linux-2.6.38-generic-part3/include/linux/watchdog.h	2011-06-16 16:57:31.388541823 +0200
+++ linux-2.6.38-generic-part4/include/linux/watchdog.h	2011-06-16 19:14:34.603180137 +0200
@@ -80,6 +80,7 @@
 	const struct watchdog_ops *ops;
 	int bootstatus;
 	long status;
+#define WDOG_ACTIVE		0	/* is the watchdog running/active */
 #define WDOG_DEV_OPEN		1	/* is the watchdog opened via
 					 * /dev/watchdog */
 };

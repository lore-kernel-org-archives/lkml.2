Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab1BWUnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:43:15 -0500
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:9178 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752291Ab1BWUnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:43:13 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEADP/ZE1R8sEZ/2dsb2JhbACmIHS8Gw2FUQQ
Date: Wed, 23 Feb 2011 21:43:11 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [RFC] [PATCH 4/10] Generic Watchdog Timer Driver
Message-ID: <20110223204311.GA7401@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 254c9369d07a369fd45e4be343ed2062ecd915a6
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri Jun 18 09:44:49 2010 +0000

    watchdog: WatchDog Timer Driver Core - Part 4
    
    This part add's the WDIOC_SETOPTIONS ioctl functionality
    to the WatchDog Timer Driver Core framework.
    
    Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

diff --git a/Documentation/watchdog/src/watchdog-with-timer-example.c b/Documentation/watchdog/src/watchdog-with-timer-example.c
index d64cac6..6a4af47 100644
--- a/Documentation/watchdog/src/watchdog-with-timer-example.c
+++ b/Documentation/watchdog/src/watchdog-with-timer-example.c
@@ -45,11 +45,11 @@ module_param(timeout, int, 0);
 MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. "
 	"(default = " __MODULE_STRING(WDT_TIMEOUT) ")");
 
+static struct watchdog_device wdt_dev;
 static void wdt_timer_tick(unsigned long data);
 static DEFINE_TIMER(timer, wdt_timer_tick, 0, 0);
 					/* The timer that pings the watchdog */
 static unsigned long next_heartbeat;	/* the next_heartbeat for the timer */
-static unsigned long running;		/* is watchdog running for userspace? */
 
 static struct platform_device *wdt_platform_device;
 
@@ -73,7 +73,7 @@ static inline void wdt_reset(void)
 static void wdt_timer_tick(unsigned long data)
 {
 	if (time_before(jiffies, next_heartbeat) ||
-			(!running)) {
+	    (!test_bit(WDOG_ACTIVE, &wdt_dev.status))) {
 		wdt_reset();
 		mod_timer(&timer, jiffies + WDT_HEARTBEAT);
 	} else
@@ -99,7 +99,6 @@ static int wdt_start(struct watchdog_device *wdd)
 	/* Start the watchdog timer hardware here */
 	printk(KERN_INFO PFX "wdt_start\n");
 
-	running = 1;
 	return 0;
 }
 
@@ -108,7 +107,6 @@ static int wdt_stop(struct watchdog_device *wdd)
 	/* The watchdog timer hardware can not be stopped... */
 	printk(KERN_INFO PFX "wdt_stop\n");
 
-	running = 0;
 	return 0;
 }
 
diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index 4a68e5e..3de69e7 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -54,8 +54,9 @@ It contains following fields:
 * bootstatus: status of the device after booting (reported with watchdog
   WDIOF_* status bits).
 * status: this field contains a number of status bits that give extra
-  information about the status of the device (Like: is the device opened via
-  the /dev/watchdog interface or not, ...)
+  information about the status of the device (Like: is the watchdog timer
+  running/active, is the device opened via the /dev/watchdog interface or not,
+  ...)
 
 The list of watchdog operations is defined as:
 
@@ -104,6 +105,10 @@ they are supported. These optional routines/operations are:
 
 The status bits should (preferably) be set with the set_bit and clear_bit alike
 bit-operations. The status bit's that are defined are:
+* WDOG_ACTIVE: this status bit indicates whether or not a watchdog timer device
+  is active or not. When the watchdog is active after booting, then you should
+  set this status bit (Note: when you register the watchdog timer device with
+  this bit set, then opening /dev/watchdog will skip the start operation)
 * WDOG_DEV_OPEN: this status bit shows whether or not the watchdog device
   was opened via /dev/watchdog.
   (This bit should only be used by the WatchDog Timer Driver Core).
diff --git a/drivers/watchdog/core/watchdog_dev.c b/drivers/watchdog/core/watchdog_dev.c
index 0d2ed1d..2bf4f67 100644
--- a/drivers/watchdog/core/watchdog_dev.c
+++ b/drivers/watchdog/core/watchdog_dev.c
@@ -80,14 +80,64 @@ static struct watchdog_device *wdd;
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
@@ -138,6 +188,7 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int val = 0;
+	int err;
 
 	trace("%p, %u, %li", file, cmd, arg);
 
@@ -151,8 +202,22 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
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
-		if (!(wdd->info->options & WDIOF_MAGICCLOSE))
+		if (!(wdd->info->options & WDIOF_KEEPALIVEPING))
 			return -EOPNOTSUPP;
 		watchdog_ping(wdd);
 		return 0;
@@ -183,7 +248,7 @@ static int watchdog_open(struct inode *inode, struct file *file)
 		return -EBUSY;
 
 	/* start the watchdog */
-	err = wdd->ops->start(wdd);
+	err = watchdog_start(wdd);
 	if (err < 0)
 		goto out;
 
@@ -210,8 +275,8 @@ static int watchdog_release(struct inode *inode, struct file *file)
 	trace("%p, %p", inode, file);
 
 	/* stop the watchdog */
-	err = wdd->ops->stop(wdd);
-	if (err != 0) {
+	err = watchdog_stop(wdd);
+	if (err < 0) {
 		printk(KERN_CRIT "%s: not stopping watchdog!\n", wdd->name);
 		watchdog_ping(wdd);
 	}
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index a41dca3..736814f 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -79,6 +79,7 @@ struct watchdog_device {
 	const struct watchdog_ops *ops;
 	int bootstatus;
 	long status;
+#define WDOG_ACTIVE		0	/* is the watchdog running/active */
 #define WDOG_DEV_OPEN		1	/* is the watchdog opened via
 					 * /dev/watchdog */
 };

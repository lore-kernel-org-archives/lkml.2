Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452Ab1FRR0m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 13:26:42 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:44102 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750732Ab1FRR0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 13:26:39 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAKTd/E1tgyeh/2dsb2JhbABSpl54iHW9Gw6GHAShYQ
Date: Sat, 18 Jun 2011 19:26:37 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 8/10 v2] Generic Watchdog Timer Driver
Message-ID: <20110618172637.GI3441@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

watchdog: WatchDog Timer Driver Core - Part 8
   
Add support for a parent device so that it can
be set as the parent of the misc_device.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

diff -urN linux-2.6.38-generic-part7/Documentation/watchdog/src/watchdog-with-timer-example.c linux-2.6.38-generic-part8/Documentation/watchdog/src/watchdog-with-timer-example.c
--- linux-2.6.38-generic-part7/Documentation/watchdog/src/watchdog-with-timer-example.c	2011-06-17 09:52:32.866632635 +0200
+++ linux-2.6.38-generic-part8/Documentation/watchdog/src/watchdog-with-timer-example.c	2011-06-17 12:03:43.389063903 +0200
@@ -82,7 +82,7 @@
 		wdt_reset();
 		mod_timer(&timer, jiffies + WDT_HEARTBEAT);
 	} else
-		pr_crit("I will reboot your machine !\n");
+		dev_crit(wdt_dev.parent, "I will reboot your machine !\n");
 }
 
 /*
@@ -102,7 +102,7 @@
 	mod_timer(&timer, jiffies + WDT_HEARTBEAT);
 
 	/* Start the watchdog timer hardware here */
-	pr_info("wdt_start\n");
+	dev_info(wdt_dev.parent, "wdt_start\n");
 
 	return 0;
 }
@@ -110,7 +110,7 @@
 static int wdt_stop(struct watchdog_device *wdd)
 {
 	/* The watchdog timer hardware can not be stopped... */
-	pr_info("wdt_stop\n");
+	dev_info(wdt_dev.parent, "wdt_stop\n");
 
 	return 0;
 }
@@ -157,17 +157,19 @@
 
 	/* Set watchdog_device parameters */
 	wdt_dev.timeout = timeout;
+	wdt_dev.parent = &pdev->dev;
 	if (nowayout)
 		set_bit(WDOG_NO_WAY_OUT, &wdt_dev.status);
 
 	/* Register the watchdog timer device */
 	res = watchdog_register_device(&wdt_dev);
 	if (res) {
-		pr_err("watchdog_register_device returned %d\n", res);
+		dev_err(wdt_dev.parent,
+			"watchdog_register_device returned %d\n", res);
 		return res;
 	}
 
-	pr_info("enabled (timeout=%d sec)\n", timeout);
+	dev_info(wdt_dev.parent, "enabled (timeout=%d sec)\n", timeout);
 
 	return 0;
 }
@@ -178,7 +180,7 @@
 	watchdog_unregister_device(&wdt_dev);
 
 	/* stop and delete the timer */
-	pr_warn("I quit now, hardware will probably reboot!\n");
+	dev_warn(wdt_dev.parent, "I quit now, hardware will probably reboot!\n");
 	del_timer(&timer);
 
 	/* Unregister other stuff */
diff -urN linux-2.6.38-generic-part7/Documentation/watchdog/watchdog-kernel-api.txt linux-2.6.38-generic-part8/Documentation/watchdog/watchdog-kernel-api.txt
--- linux-2.6.38-generic-part7/Documentation/watchdog/watchdog-kernel-api.txt	2011-06-17 09:58:20.754629453 +0200
+++ linux-2.6.38-generic-part8/Documentation/watchdog/watchdog-kernel-api.txt	2011-06-17 10:03:41.326632851 +0200
@@ -42,6 +42,7 @@
 	char *name;
 	const struct watchdog_info *info;
 	const struct watchdog_ops *ops;
+	struct device *parent;
 	int timeout;
 	int bootstatus;
 	long status;
@@ -52,6 +53,8 @@
 * info: a pointer to a watchdog_info structure. This structure gives some
   additional information about the watchdog timer itself.
 * ops: a pointer to the list of watchdog operations that the watchdog supports.
+* parent: a pointer to the parent device of the watchdog. This will be set
+  as the parent of the misc device.
 * timeout: the watchdog timer's timeout value (in seconds).
 * bootstatus: status of the device after booting (reported with watchdog
   WDIOF_* status bits).
diff -urN linux-2.6.38-generic-part7/drivers/watchdog/core/watchdog_dev.c linux-2.6.38-generic-part8/drivers/watchdog/core/watchdog_dev.c
--- linux-2.6.38-generic-part7/drivers/watchdog/core/watchdog_dev.c	2011-06-17 09:52:32.870632731 +0200
+++ linux-2.6.38-generic-part8/drivers/watchdog/core/watchdog_dev.c	2011-06-17 10:03:41.326632851 +0200
@@ -389,6 +389,7 @@
 
 	/* Register the miscdevice */
 	dbg("Register a new /dev/watchdog device");
+	watchdog_miscdev.parent = watchdog->parent;
 	err = misc_register(&watchdog_miscdev);
 	if (err != 0) {
 		pr_err("%s: cannot register miscdev on minor=%d (err=%d).\n",
diff -urN linux-2.6.38-generic-part7/include/linux/watchdog.h linux-2.6.38-generic-part8/include/linux/watchdog.h
--- linux-2.6.38-generic-part7/include/linux/watchdog.h	2011-06-17 12:17:39.205063756 +0200
+++ linux-2.6.38-generic-part8/include/linux/watchdog.h	2011-06-17 12:17:52.893063162 +0200
@@ -79,6 +79,7 @@
 	char *name;
 	const struct watchdog_info *info;
 	const struct watchdog_ops *ops;
+	struct device *parent;
 	int bootstatus;
 	int timeout;
 	long status;

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab1BWUo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:44:59 -0500
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:41191 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752353Ab1BWUo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:44:58 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAKv/ZE1R8sEZ/2dsb2JhbACmIHS8FQ2FUQQ
Date: Wed, 23 Feb 2011 21:44:56 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [RFC] [PATCH 9/10] Generic Watchdog Timer Driver
Message-ID: <20110223204456.GA7481@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 2f28f0348ea738eb71177f348cbf33ce7fd38bf6
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sun Jul 18 10:56:19 2010 +0000

    watchdog: WatchDog Timer Driver Core - Part 9
    
    Add support for a parent device so that it can
    be set as the parent of the misc_device.
    
    Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

diff --git a/Documentation/watchdog/src/watchdog-with-timer-example.c b/Documentation/watchdog/src/watchdog-with-timer-example.c
index 8ba5d5f..8efd6d2 100644
--- a/Documentation/watchdog/src/watchdog-with-timer-example.c
+++ b/Documentation/watchdog/src/watchdog-with-timer-example.c
@@ -82,7 +82,7 @@ static void wdt_timer_tick(unsigned long data)
 		wdt_reset();
 		mod_timer(&timer, jiffies + WDT_HEARTBEAT);
 	} else
-		printk(KERN_CRIT PFX "I will reboot your machine !\n");
+		dev_crit(wdt_dev.parent, "I will reboot your machine !\n");
 }
 
 /*
@@ -102,7 +102,7 @@ static int wdt_start(struct watchdog_device *wdd)
 	mod_timer(&timer, jiffies + WDT_HEARTBEAT);
 
 	/* Start the watchdog timer hardware here */
-	printk(KERN_INFO PFX "wdt_start\n");
+	dev_info(wdt_dev.parent, "wdt_start\n");
 
 	return 0;
 }
@@ -110,7 +110,7 @@ static int wdt_start(struct watchdog_device *wdd)
 static int wdt_stop(struct watchdog_device *wdd)
 {
 	/* The watchdog timer hardware can not be stopped... */
-	printk(KERN_INFO PFX "wdt_stop\n");
+	dev_info(wdt_dev.parent, "wdt_stop\n");
 
 	return 0;
 }
@@ -157,18 +157,19 @@ static int __devinit wdt_probe(struct platform_device *pdev)
 
 	/* Set watchdog_device parameters */
 	wdt_dev.timeout = timeout;
+	wdt_dev.parent = &pdev->dev;
 	if (nowayout)
 		set_bit(WDOG_NO_WAY_OUT, &wdt_dev.status);
 
 	/* Register the watchdog timer device */
 	res = register_watchdogdevice(&wdt_dev);
 	if (res) {
-		printk(KERN_ERR PFX
+		dev_err(wdt_dev.parent,
 				"register_watchdogdevice returned %d\n", res);
 		return res;
 	}
 
-	printk(KERN_INFO PFX "enabled (timeout=%d sec)\n", timeout);
+	dev_info(wdt_dev.parent, "enabled (timeout=%d sec)\n", timeout);
 
 	return 0;
 }
@@ -179,7 +180,7 @@ static int __devexit wdt_remove(struct platform_device *pdev)
 	unregister_watchdogdevice(&wdt_dev);
 
 	/* stop and delete the timer */
-	printk(KERN_WARNING PFX "I quit now, hardware will probably reboot!\n");
+	dev_warn(wdt_dev.parent, "I quit now, hardware will probably reboot!\n");
 	del_timer(&timer);
 
 	/* Unregister other stuff */
diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index 91c4299..aa4f836 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -42,6 +42,7 @@ struct watchdog_device {
 	char *name;
 	const struct watchdog_info *info;
 	const struct watchdog_ops *ops;
+	struct device *parent;
 	int timeout;
 	int bootstatus;
 	long status;
@@ -52,6 +53,8 @@ It contains following fields:
 * info: a pointer to a watchdog_info structure. This structure gives some
   additional information about the watchdog timer itself.
 * ops: a pointer to the list of watchdog operations that the watchdog supports.
+* parent: a pointer to the parent device of the watchdog. This will be set
+  as the parent of the misc device.
 * timeout: the watchdog timer's timeout value (in seconds).
 * bootstatus: status of the device after booting (reported with watchdog
   WDIOF_* status bits).
diff --git a/drivers/watchdog/core/watchdog_dev.c b/drivers/watchdog/core/watchdog_dev.c
index 76be752..ad080fe 100644
--- a/drivers/watchdog/core/watchdog_dev.c
+++ b/drivers/watchdog/core/watchdog_dev.c
@@ -394,6 +394,7 @@ int watchdog_dev_register(struct watchdog_device *watchdog)
 
 	/* Register the miscdevice */
 	dbg("Register a new /dev/watchdog device");
+	watchdog_miscdev.parent = watchdog->parent;
 	err = misc_register(&watchdog_miscdev);
 	if (err != 0) {
 		printk(KERN_ERR
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index 40ed78c..d264493 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -79,6 +79,7 @@ struct watchdog_device {
 	char *name;
 	const struct watchdog_info *info;
 	const struct watchdog_ops *ops;
+	struct device *parent;
 	int bootstatus;
 	int timeout;
 	long status;

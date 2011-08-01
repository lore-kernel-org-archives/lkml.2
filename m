Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab1HAU6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 16:58:30 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:58733 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab1HAU6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 16:58:24 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-127.messagelabs.com!1312232300!14020879!16
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.180]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] watchdog: ep93xx: Use the WatchDog Timer Driver Core.
Date: Mon, 1 Aug 2011 13:57:24 -0700
User-Agent: KMail/1.9.9
CC: <linux-watchdog@vger.kernel.org>, <wim@iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201108011357.24745.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Wim Van Sebroeck <wim@iguana.be> (maintainer:WATCHDOG DEVICE D...)

---

diff --git a/drivers/watchdog/ep93xx_wdt.c b/drivers/watchdog/ep93xx_wdt.c
index 726b7df..bb97351 100644
--- a/drivers/watchdog/ep93xx_wdt.c
+++ b/drivers/watchdog/ep93xx_wdt.c
@@ -24,11 +24,9 @@
  */
 
 #include <linux/module.h>
-#include <linux/fs.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/timer.h>
-#include <linux/uaccess.h>
 #include <linux/io.h>
 #include <mach/hardware.h>
 
@@ -39,15 +37,17 @@
 #define WDT_TIMEOUT 30
 
 static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started");
+
 static int timeout = WDT_TIMEOUT;
+module_param(timeout, int, 0);
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. (1<=timeout<=3600, default="
+				__MODULE_STRING(WDT_TIMEOUT) ")");
 
 static struct timer_list timer;
 static unsigned long next_heartbeat;
-static unsigned long wdt_status;
-static unsigned long boot_status;
-
-#define WDT_IN_USE		0
-#define WDT_OK_TO_CLOSE		1
 
 #define EP93XX_WDT_REG(x)	(EP93XX_WATCHDOG_BASE + (x))
 #define EP93XX_WDT_WATCHDOG	EP93XX_WDT_REG(0x00)
@@ -71,130 +71,46 @@ static inline void wdt_ping(void)
 	__raw_writew(0x5555, EP93XX_WDT_WATCHDOG);
 }
 
-static void wdt_startup(void)
+static int void ep93xx_wdt_start(struct watchdog_device *wdd)
 {
-	next_heartbeat = jiffies + (timeout * HZ);
+	next_heartbeat = jiffies + (wdd->timeout * HZ);
 
 	wdt_enable();
 	mod_timer(&timer, jiffies + WDT_INTERVAL);
+	return 0;
 }
 
-static void wdt_shutdown(void)
+static int ep93xx_wdt_stop(struct watchdog_device *wdd)
 {
 	del_timer_sync(&timer);
 	wdt_disable();
+	return 0;
 }
 
-static void wdt_keepalive(void)
+static int ep93xx_wdt_keepalive(struct watchdog_device *wdd)
 {
 	/* user land ping */
-	next_heartbeat = jiffies + (timeout * HZ);
-}
-
-static int ep93xx_wdt_open(struct inode *inode, struct file *file)
-{
-	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
-		return -EBUSY;
-
-	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-
-	wdt_startup();
-
-	return nonseekable_open(inode, file);
-}
-
-static ssize_t
-ep93xx_wdt_write(struct file *file, const char __user *data, size_t len,
-		 loff_t *ppos)
-{
-	if (len) {
-		if (!nowayout) {
-			size_t i;
-
-			clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-
-			for (i = 0; i != len; i++) {
-				char c;
-
-				if (get_user(c, data + i))
-					return -EFAULT;
-
-				if (c == 'V')
-					set_bit(WDT_OK_TO_CLOSE, &wdt_status);
-				else
-					clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-			}
-		}
-		wdt_keepalive();
-	}
-
-	return len;
+	next_heartbeat = jiffies + (wdd->timeout * HZ);
+	return 0;
 }
 
-static const struct watchdog_info ident = {
-	.options = WDIOF_CARDRESET | WDIOF_MAGICCLOSE,
-	.identity = "EP93xx Watchdog",
+static const struct watchdog_info ep93xx_wdt_ident = {
+	.options	= WDIOF_CARDRESET | WDIOF_MAGICCLOSE,
+	.identity	= "EP93xx Watchdog",
 };
 
-static long ep93xx_wdt_ioctl(struct file *file,
-					unsigned int cmd, unsigned long arg)
-{
-	int ret = -ENOTTY;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		ret = copy_to_user((struct watchdog_info __user *)arg, &ident,
-				sizeof(ident)) ? -EFAULT : 0;
-		break;
-
-	case WDIOC_GETSTATUS:
-		ret = put_user(0, (int __user *)arg);
-		break;
-
-	case WDIOC_GETBOOTSTATUS:
-		ret = put_user(boot_status, (int __user *)arg);
-		break;
-
-	case WDIOC_KEEPALIVE:
-		wdt_keepalive();
-		ret = 0;
-		break;
-
-	case WDIOC_GETTIMEOUT:
-		/* actually, it is 0.250 seconds.... */
-		ret = put_user(1, (int __user *)arg);
-		break;
-	}
-	return ret;
-}
-
-static int ep93xx_wdt_release(struct inode *inode, struct file *file)
-{
-	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
-		wdt_shutdown();
-	else
-		printk(KERN_CRIT PFX
-			"Device closed unexpectedly - timer will not stop\n");
-
-	clear_bit(WDT_IN_USE, &wdt_status);
-	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-
-	return 0;
-}
-
-static const struct file_operations ep93xx_wdt_fops = {
+static const struct watchdog_ops ep93xx_wdt_ops = {
 	.owner		= THIS_MODULE,
-	.write		= ep93xx_wdt_write,
-	.unlocked_ioctl	= ep93xx_wdt_ioctl,
-	.open		= ep93xx_wdt_open,
-	.release	= ep93xx_wdt_release,
-	.llseek		= no_llseek,
+	.start		= ep93xx_wdt_start,
+	.stop		= ep93xx_wdt_stop,
+	.ping		= ep93xx_wdt_keepalive,
 };
 
-static struct miscdevice ep93xx_wdt_miscdev = {
-	.minor		= WATCHDOG_MINOR,
-	.name		= "watchdog",
-	.fops		= &ep93xx_wdt_fops,
+static struct watchdog_device ep93xx_wdd = {
+	.info		= &ep93xx_wdt_ident,
+	.ops		= &ep93xx_wdt_ops,
+	.min_timeout	= 1,
+	.max_timeout	= 3600,
 };
 
 static void ep93xx_timer_ping(unsigned long data)
@@ -210,43 +126,31 @@ static int __init ep93xx_wdt_init(void)
 {
 	int err;
 
-	err = misc_register(&ep93xx_wdt_miscdev);
+	ep93xx_wdd.bootstatus = readl(EP93XX_WDT_WATCHDOG);
+	ep93xx_wdd.timeout = timeout;
+
+	err = watchdog_register_device(&ep93xx_wdd);
+	if (err)
+		return err;
 
-	boot_status = __raw_readl(EP93XX_WDT_WATCHDOG) & 0x01 ? 1 : 0;
+	setup_timer(&timer, ep93xx_timer_ping, 1);
 
 	printk(KERN_INFO PFX "EP93XX watchdog, driver version "
 		WDT_VERSION "%s\n",
-		(__raw_readl(EP93XX_WDT_WATCHDOG) & 0x08)
+		(ep93xx_wdd.bootstatus & 0x08)
 		? " (nCS1 disable detected)" : "");
 
-	if (timeout < 1 || timeout > 3600) {
-		timeout = WDT_TIMEOUT;
-		printk(KERN_INFO PFX
-			"timeout value must be 1<=x<=3600, using %d\n",
-			timeout);
-	}
-
-	setup_timer(&timer, ep93xx_timer_ping, 1);
-	return err;
+	return 0;
 }
+module_init(ep93xx_wdt_init);
 
 static void __exit ep93xx_wdt_exit(void)
 {
-	wdt_shutdown();
-	misc_deregister(&ep93xx_wdt_miscdev);
+	wdt_shutdown(&ep93xx_wdd);
+	watchdog_unregister_device(&ep93xx_wdd);
 }
-
-module_init(ep93xx_wdt_init);
 module_exit(ep93xx_wdt_exit);
 
-module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started");
-
-module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout,
-	"Watchdog timeout in seconds. (1<=timeout<=3600, default="
-				__MODULE_STRING(WDT_TIMEOUT) ")");
-
 MODULE_AUTHOR("Ray Lehtiniemi <rayl@mail.com>,"
 		"Alessandro Zummo <a.zummo@towertech.it>");
 MODULE_DESCRIPTION("EP93xx Watchdog");

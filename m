Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab2LEBjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 20:39:49 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:11696 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab2LEBjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 20:39:02 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com, JM.Lin@atmel.com,
        wenyou.yang@atmel.com, wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [v2 PATCH 2/8] watchdog/at91sam9_wdt: Convert to use the watchdog framework
Date: Wed,  5 Dec 2012 09:34:21 +0800
Message-Id: <1354671267-19277-3-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354671267-19277-1-git-send-email-wenyou.yang@atmel.com>
References: <1354671267-19277-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 05 Dec 2012 01:38:38.0538 (UTC) FILETIME=[3FBDFAA0:01CDD289]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the kernel document: convert_drivers_to_kernel_api.txt,
remove the file_operations struct, miscdevice, and obsolete includes

Since the at91sam watchdog inherent characteristics, add the watchdog
operations: at91wdt_start, at91wdt_stop and at91wdt_ping.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Cc: wim@iguana.be
Cc: linux-watchdog@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/watchdog/at91sam9_wdt.c |  203 +++++++++++++++------------------------
 1 file changed, 75 insertions(+), 128 deletions(-)

diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index f10a897..92467d4 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -13,16 +13,17 @@
  * The Watchdog Timer Mode Register can be only written to once. If the
  * timeout need to be set from Linux, be sure that the bootstrap or the
  * bootloader doesn't write to this register.
+ * The Watchdog Timer default is running with maximum counter value
+ * (WDV=0xfff) at reset, i.e., at power-up. It MUST be either disabled
+ * or be reprogrammed within the maxinum margin(16s).
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/errno.h>
-#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
-#include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/platform_device.h>
@@ -31,7 +32,6 @@
 #include <linux/jiffies.h>
 #include <linux/timer.h>
 #include <linux/bitops.h>
-#include <linux/uaccess.h>
 #include <linux/of.h>
 
 #include "at91sam9_wdt.h"
@@ -65,8 +65,6 @@ module_param(nowayout, bool, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
 	"(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
-static void at91_ping(unsigned long data);
-
 struct at91wdt_drvdata {
 	void __iomem	*phybase;
 	bool		is_enable;	/* indicate if the watchdog is eabled */
@@ -88,6 +86,11 @@ static inline void wdt_write(struct at91wdt_drvdata *driver_data,
 	writel_relaxed((val), driver_data->phybase + field);
 }
 
+static inline bool watchdog_is_open(struct watchdog_device *wddev)
+{
+	return test_bit(WDOG_DEV_OPEN, &wddev->status);
+}
+
 /*
  * Reload the watchdog timer.  (ie, pat the watchdog)
  */
@@ -99,7 +102,7 @@ static inline void at91_wdt_reset(struct at91wdt_drvdata *driver_data)
 /*
  * Timer tick
  */
-static void at91_ping(unsigned long data)
+static void at91wdt_timer_tick(unsigned long data)
 {
 	struct watchdog_device *wddev = (struct watchdog_device *)data;
 	struct at91wdt_drvdata *driver_data = watchdog_get_drvdata(wddev);
@@ -107,45 +110,30 @@ static void at91_ping(unsigned long data)
 	if (time_before(jiffies, driver_data->next_heartbeat)) {
 		at91_wdt_reset(driver_data);
 		mod_timer(&driver_data->timer, jiffies + WDT_TIMEOUT);
+
+		if (!watchdog_is_open(wddev))
+			driver_data->next_heartbeat = jiffies
+						+ wddev->timeout * HZ;
 	} else
 		pr_crit("I will reset your machine !\n");
 }
 
-/*
- * Watchdog device is opened, and watchdog starts running.
- */
-static int at91_wdt_open(struct inode *inode, struct file *file)
-{
-	driver_data->next_heartbeat = jiffies + heartbeat * HZ;
-	mod_timer(&driver_data->timer, jiffies + WDT_TIMEOUT);
-
-	return nonseekable_open(inode, file);
-}
-
-/*
- * Close the watchdog device.
- */
-static int at91_wdt_close(struct inode *inode, struct file *file)
-{
-	del_timer(&driver_data->timer);
-
-	return 0;
-}
-
-/*
- * Set the watchdog time interval in 1/256Hz (write-once)
- * Counter is 12 bit.
- */
-static int at91_wdt_settimeout(unsigned int timeout)
+static int at91wdt_enable(struct watchdog_device *wddev, unsigned int timeout)
 {
+	struct at91wdt_drvdata *driver_data = watchdog_get_drvdata(wddev);
 	unsigned int reg;
-	unsigned int mr;
 
-	/* Check if disabled */
-	mr = wdt_read(AT91_WDT_MR);
-	if (mr & AT91_WDT_WDDIS) {
-		pr_err("sorry, watchdog is disabled\n");
-		return -EIO;
+	/*
+	 * Check if the watchdog is disabled,
+	 * if disabled, the reason is the bootstrap or the bootloader has
+	 * written the Watchdog Timer Mode Register to disable the
+	 * watchdog timer
+	 */
+	reg = wdt_read(driver_data, AT91_WDT_MR);
+	if (reg & AT91_WDT_WDDIS) {
+		driver_data->is_enable = false;
+		pr_info("sorry, watchdog is disabled\n");
+		return -1;
 	}
 
 	/*
@@ -159,7 +147,9 @@ static int at91_wdt_settimeout(unsigned int timeout)
 		| AT91_WDT_WDDBGHLT	/* disabled in debug mode */
 		| AT91_WDT_WDD		/* restart at any time */
 		| (timeout & AT91_WDT_WDV);  /* timer value */
-	wdt_write(AT91_WDT_MR, reg);
+	wdt_write(driver_data, AT91_WDT_MR, reg);
+
+	driver_data->is_enable = true;
 
 	return 0;
 }
@@ -170,99 +160,61 @@ static const struct watchdog_info at91_wdt_info = {
 						WDIOF_MAGICCLOSE,
 };
 
-/*
- * Handle commands from user-space.
- */
-static long at91_wdt_ioctl(struct file *file,
-		unsigned int cmd, unsigned long arg)
+static int at91wdt_start(struct watchdog_device *wddev)
 {
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	int new_value;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user(argp, &at91_wdt_info,
-				    sizeof(at91_wdt_info)) ? -EFAULT : 0;
-
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
+	struct at91wdt_drvdata *driver_data = watchdog_get_drvdata(wddev);
 
-	case WDIOC_KEEPALIVE:
-		driver_data->next_heartbeat = jiffies + heartbeat * HZ;
+	if (driver_data->is_enable) {
+		driver_data->next_heartbeat = jiffies + wddev->timeout * HZ;
+		mod_timer(&driver_data->timer, jiffies + WDT_TIMEOUT);
 		return 0;
-
-	case WDIOC_SETTIMEOUT:
-		if (get_user(new_value, p))
-			return -EFAULT;
-
-		heartbeat = new_value;
-		driver_data->next_heartbeat = jiffies + heartbeat * HZ;
-
-		return put_user(new_value, p);  /* return current value */
-
-	case WDIOC_GETTIMEOUT:
-		return put_user(heartbeat, p);
-	}
-	return -ENOTTY;
+	} else
+		return -EIO;
 }
 
-/*
- * Pat the watchdog whenever device is written to.
- */
-static ssize_t at91_wdt_write(struct file *file, const char *data, size_t len,
-								loff_t *ppos)
+static int at91wdt_stop(struct watchdog_device *wddev)
 {
-	if (!len)
-		return 0;
-
-	/* Scan for magic character */
-	if (!nowayout) {
-		size_t i;
-
+	struct at91wdt_drvdata *driver_data = watchdog_get_drvdata(wddev);
 
-		for (i = 0; i < len; i++) {
-			char c;
-			if (get_user(c, data + i))
-				return -EFAULT;
-			}
-		}
-	}
+	if (driver_data->is_enable)
+		return -EIO;
+	else
+		return 0;
+}
 
-	driver_data->next_heartbeat = jiffies + heartbeat * HZ;
+static int at91wdt_ping(struct watchdog_device *wddev)
+{
+	struct at91wdt_drvdata *driver_data = watchdog_get_drvdata(wddev);
 
-	return len;
+	if (driver_data->is_enable) {
+		driver_data->next_heartbeat = jiffies + wddev->timeout * HZ;
+		 mod_timer(&driver_data->timer, jiffies + WDT_TIMEOUT);
+		return 0;
+	} else
+		return -EIO;
 }
-
 /* ......................................................................... */
 
-static const struct file_operations at91wdt_fops = {
-	.owner			= THIS_MODULE,
-	.llseek			= no_llseek,
-	.unlocked_ioctl	= at91_wdt_ioctl,
-	.open			= at91_wdt_open,
-	.release		= at91_wdt_close,
-	.write			= at91_wdt_write,
-};
-
-static struct miscdevice at91wdt_miscdev = {
-	.minor		= WATCHDOG_MINOR,
-	.name		= "watchdog",
-	.fops		= &at91wdt_fops,
+static struct watchdog_ops at91wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = at91wdt_start,
+	.stop = at91wdt_stop,
+	.ping = at91wdt_ping,
 };
 
 static struct watchdog_device at91wdt_wdd __initdata = {
 	.timeout = WDT_HEARTBEAT,
 	.min_timeout = MIN_HEARTBEAT,
 	.max_timeout = MAX_HEARTBEAT,
+	.info = &at91_wdt_info,
+	.ops = &at91wdt_ops,
 };
 
 static int __init at91wdt_probe(struct platform_device *pdev)
 {
 	struct at91wdt_drvdata *driver_data;
 	struct resource	*r;
-	int res;
+	int ret;
 
 	driver_data = devm_kzalloc(&pdev->dev,
 				sizeof(*driver_data), GFP_KERNEL);
@@ -273,32 +225,32 @@ static int __init at91wdt_probe(struct platform_device *pdev)
 
 	watchdog_set_drvdata(&at91wdt_wdd, driver_data);
 
-	if (at91wdt_miscdev.parent)
-		return -EBUSY;
-	at91wdt_miscdev.parent = &pdev->dev;
-
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r)
 		return -ENODEV;
+
 	driver_data->phybase = ioremap(r->start, resource_size(r));
 	if (!driver_data->phybase) {
 		dev_err(&pdev->dev, "failed to map registers, aborting.\n");
 		return -ENOMEM;
 	}
 
-	watchdog_init_timeout(&at91wdt_wdd, heartbeat, pdev->dev.of_node);
+	ret = watchdog_register_device(&at91wdt_wdd);
+	if (ret) {
+		dev_err(&pdev->dev, "cannot register watchdog (%d)\n", ret);
+		return ret;
+	}
 
-	/* Set watchdog */
-	res = at91_wdt_settimeout(ms_to_ticks(WDT_HW_TIMEOUT * 1000));
-	if (res)
-		return res;
+	watchdog_init_timeout(&at91wdt_wdd, heartbeat, pdev->dev.of_node);
 
-	res = misc_register(&at91wdt_miscdev);
-	if (res)
-		return res;
+	ret = at91wdt_enable(&at91wdt_wdd, ms_to_ticks(WDT_HW_TIMEOUT * 1000));
+	if (ret) {
+		pr_info("the watchdog has been disabled\n");
+		return 0;
+	}
 
 	driver_data->next_heartbeat = jiffies + at91wdt_wdd.timeout * HZ;
-	setup_timer(&driver_data->timer, at91_ping,
+	setup_timer(&driver_data->timer, at91wdt_timer_tick,
 					(unsigned long)&at91wdt_wdd);
 	mod_timer(&driver_data->timer, jiffies + WDT_TIMEOUT);
 
@@ -310,13 +262,9 @@ static int __init at91wdt_probe(struct platform_device *pdev)
 
 static int __exit at91wdt_remove(struct platform_device *pdev)
 {
-	int res;
+	watchdog_unregister_device(&at91wdt_wdd);
 
-	res = misc_deregister(&at91wdt_miscdev);
-	if (!res)
-		at91wdt_miscdev.parent = NULL;
-
-	return res;
+	return 0;
 }
 
 #if defined(CONFIG_OF)
@@ -353,4 +301,3 @@ module_exit(at91sam_wdt_exit);
 MODULE_AUTHOR("Renaud CERRATO <r.cerrato@til-technologies.fr>");
 MODULE_DESCRIPTION("Watchdog driver for Atmel AT91SAM9x processors");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-- 
1.7.9.5


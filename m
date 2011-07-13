Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831Ab1GMU00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 16:26:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55534 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab1GMUZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 16:25:03 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-watchdog@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        wim@iguana.be, tim.bird@am.sony.com,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [RFC 5/6] watchdog: pnx4008: convert driver to use the watchdog framework
Date: Wed, 13 Jul 2011 22:26:05 +0200
Message-Id: <1310588766-16638-6-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1310588766-16638-1-git-send-email-w.sang@pengutronix.de>
References: <1310588766-16638-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make this driver a user of the watchdog framework and remove now
centrally handled parts. Tested on a custom lpc32xx-board.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/watchdog/Kconfig       |    1 +
 drivers/watchdog/pnx4008_wdt.c |  154 ++++++++++------------------------------
 2 files changed, 39 insertions(+), 116 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 4f1379c..4ef6ba9 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -236,6 +236,7 @@ config OMAP_WATCHDOG
 config PNX4008_WATCHDOG
 	tristate "PNX4008 and LPC32XX Watchdog"
 	depends on ARCH_PNX4008 || ARCH_LPC32XX
+	select WATCHDOG_CORE
 	help
 	  Say Y here if to include support for the watchdog timer
 	  in the PNX4008 or LPC32XX processor.
diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index 4cc9c27..1ccb49a 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -18,7 +18,6 @@
 #include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/fs.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/init.h>
@@ -32,6 +31,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <mach/hardware.h>
+#include <linux/err.h>
 
 #define MODULE_NAME "PNX4008-WDT: "
 
@@ -81,18 +81,11 @@ static int nowayout = WATCHDOG_NOWAYOUT;
 static int heartbeat = DEFAULT_HEARTBEAT;
 
 static DEFINE_SPINLOCK(io_lock);
-static unsigned long wdt_status;
-#define WDT_IN_USE        0
-#define WDT_OK_TO_CLOSE   1
-#define WDT_REGION_INITED 2
-#define WDT_DEVICE_INITED 3
-
-static unsigned long boot_status;
 
 static void __iomem	*wdt_base;
 struct clk		*wdt_clk;
 
-static void wdt_enable(void)
+static int pnx4008_wdt_ping(struct watchdog_device *wdd)
 {
 	spin_lock(&io_lock);
 
@@ -109,11 +102,13 @@ static void wdt_enable(void)
 	writel(MATCH_INT, WDTIM_INT(wdt_base));
 	/* the longest pulse period 65541/(13*10^6) seconds ~ 5 ms. */
 	writel(0xFFFF, WDTIM_PULSE(wdt_base));
-	writel(heartbeat * WDOG_COUNTER_RATE, WDTIM_MATCH0(wdt_base));
+	writel(wdd->timeout * WDOG_COUNTER_RATE, WDTIM_MATCH0(wdt_base));
 	/*enable counter, stop when debugger active */
 	writel(COUNT_ENAB | DEBUG_EN, WDTIM_CTRL(wdt_base));
 
 	spin_unlock(&io_lock);
+
+	return 0;
 }
 
 static void wdt_disable(void)
@@ -125,128 +120,53 @@ static void wdt_disable(void)
 	spin_unlock(&io_lock);
 }
 
-static int pnx4008_wdt_open(struct inode *inode, struct file *file)
+static int pnx4008_wdt_start(struct watchdog_device *wdd)
 {
 	int ret;
 
-	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
-		return -EBUSY;
-
-	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-
 	ret = clk_enable(wdt_clk);
-	if (ret) {
-		clear_bit(WDT_IN_USE, &wdt_status);
+	if (ret)
 		return ret;
-	}
 
-	wdt_enable();
+	pnx4008_wdt_ping(wdd);
 
-	return nonseekable_open(inode, file);
+	return 0;
 }
 
-static ssize_t pnx4008_wdt_write(struct file *file, const char *data,
-					size_t len, loff_t *ppos)
+static int pnx4008_wdt_stop(struct watchdog_device *wdd)
 {
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
-				if (c == 'V')
-					set_bit(WDT_OK_TO_CLOSE, &wdt_status);
-			}
-		}
-		wdt_enable();
-	}
-
-	return len;
-}
-
-static const struct watchdog_info ident = {
-	.options = WDIOF_CARDRESET | WDIOF_MAGICCLOSE |
-	    WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
-	.identity = "PNX4008 Watchdog",
-};
+	wdt_disable();
+	clk_disable(wdt_clk);
 
-static long pnx4008_wdt_ioctl(struct file *file, unsigned int cmd,
-				unsigned long arg)
-{
-	int ret = -ENOTTY;
-	int time;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		ret = copy_to_user((struct watchdog_info *)arg, &ident,
-				   sizeof(ident)) ? -EFAULT : 0;
-		break;
-
-	case WDIOC_GETSTATUS:
-		ret = put_user(0, (int *)arg);
-		break;
-
-	case WDIOC_GETBOOTSTATUS:
-		ret = put_user(boot_status, (int *)arg);
-		break;
-
-	case WDIOC_KEEPALIVE:
-		wdt_enable();
-		ret = 0;
-		break;
-
-	case WDIOC_SETTIMEOUT:
-		ret = get_user(time, (int *)arg);
-		if (ret)
-			break;
-
-		if (time <= 0 || time > MAX_HEARTBEAT) {
-			ret = -EINVAL;
-			break;
-		}
-
-		heartbeat = time;
-		wdt_enable();
-		/* Fall through */
-
-	case WDIOC_GETTIMEOUT:
-		ret = put_user(heartbeat, (int *)arg);
-		break;
-	}
-	return ret;
+	return 0;
 }
 
-static int pnx4008_wdt_release(struct inode *inode, struct file *file)
+static int pnx4008_set_timeout(struct watchdog_device *wdd, unsigned timeout)
 {
-	if (!test_bit(WDT_OK_TO_CLOSE, &wdt_status))
-		printk(KERN_WARNING "WATCHDOG: Device closed unexpectdly\n");
-
-	wdt_disable();
-	clk_disable(wdt_clk);
-	clear_bit(WDT_IN_USE, &wdt_status);
-	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+	pnx4008_wdt_ping(wdd);
 
 	return 0;
 }
 
-static const struct file_operations pnx4008_wdt_fops = {
+static const struct watchdog_info pnx4008_wdt_ident = {
+	.options = WDIOF_CARDRESET | WDIOF_MAGICCLOSE |
+	    WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.identity = "PNX4008 Watchdog",
+};
+
+static struct watchdog_ops pnx4008_wdt_ops = {
 	.owner = THIS_MODULE,
-	.llseek = no_llseek,
-	.write = pnx4008_wdt_write,
-	.unlocked_ioctl = pnx4008_wdt_ioctl,
-	.open = pnx4008_wdt_open,
-	.release = pnx4008_wdt_release,
+	.start = pnx4008_wdt_start,
+	.stop = pnx4008_wdt_stop,
+	.ping = pnx4008_wdt_ping,
+	.set_timeout = pnx4008_set_timeout,
 };
 
-static struct miscdevice pnx4008_wdt_miscdev = {
-	.minor = WATCHDOG_MINOR,
-	.name = "watchdog",
-	.fops = &pnx4008_wdt_fops,
+static struct watchdog_device pnx4008_wdd = {
+	.info = &pnx4008_wdt_ident,
+	.ops = &pnx4008_wdt_ops,
+	.min_timeout = 1,
+	.max_timeout = MAX_HEARTBEAT,
 };
 
 static int __devinit pnx4008_wdt_probe(struct platform_device *pdev)
@@ -286,14 +206,16 @@ static int __devinit pnx4008_wdt_probe(struct platform_device *pdev)
 	if (ret)
 		goto put_clk;
 
-	ret = misc_register(&pnx4008_wdt_miscdev);
+	pnx4008_wdd.timeout = heartbeat;
+	pnx4008_wdd.bootstatus = (readl(WDTIM_RES(wdt_base)) & WDOG_RESET) ?
+				WDIOF_CARDRESET : 0;
+
+	ret = watchdog_register_device(&pnx4008_wdd);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "cannot register misc device\n");
+		dev_err(&pdev->dev, "cannot register watchdog device\n");
 		goto disable_clk;
 	}
 
-	pnx4008_wdd.bootstatus = (readl(WDTIM_RES(wdt_base)) & WDOG_RESET) ?
-				WDIOF_CARDRESET : 0;
 	wdt_disable();		/*disable for now */
 	clk_disable(wdt_clk);
 
@@ -312,7 +234,7 @@ static int __devinit pnx4008_wdt_probe(struct platform_device *pdev)
 
 static int __devexit pnx4008_wdt_remove(struct platform_device *pdev)
 {
-	misc_deregister(&pnx4008_wdt_miscdev);
+	watchdog_unregister_device(&pnx4008_wdd);
 
 	clk_disable(wdt_clk);
 	clk_put(wdt_clk);
-- 
1.7.2.5


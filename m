Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab2FOHW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 03:22:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55031 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab2FOHW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 03:22:56 -0400
Message-ID: <1339744964.20824.5.camel@phoenix>
Subject: [PATCH RFT] watchdog: Convert orion_wdt driver to watchdog core
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sylver Bruneau <sylver.bruneau@googlemail.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Jamie Lentin <jm@lentin.co.uk>, Mike Turquette <mturquette@linaro.org>
Date: Fri, 15 Jun 2012 15:22:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the orion_wdt driver to the watchdog framework API.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Hi Andrew, Jamie and Mike,
I sent this patch a few weeks ago, but seems nobody testing it.
I found you are the last one touching this file.
So I re-generate my patch against current linux-next tree.
Maybe you can hep to test this patch on your hardware.

Regards,
Axel
 drivers/watchdog/Kconfig     |    1 +
 drivers/watchdog/orion_wdt.c |  204 +++++++++++-------------------------------
 2 files changed, 52 insertions(+), 153 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index fe819b7..6539df5 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -279,6 +279,7 @@ config DAVINCI_WATCHDOG
 config ORION_WATCHDOG
 	tristate "Orion watchdog"
 	depends on ARCH_ORION5X || ARCH_KIRKWOOD
+	select WATCHDOG_CORE
 	help
 	  Say Y here if to include support for the watchdog timer
 	  in the Marvell Orion5x and Kirkwood ARM SoCs.
diff --git a/drivers/watchdog/orion_wdt.c b/drivers/watchdog/orion_wdt.c
index 0f57369..223d90f 100644
--- a/drivers/watchdog/orion_wdt.c
+++ b/drivers/watchdog/orion_wdt.c
@@ -16,22 +16,22 @@
 #include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/fs.h>
 #include <linux/miscdevice.h>
+#include <linux/watchdog.h>
 #include <linux/platform_device.h>
 #include <linux/watchdog.h>
 #include <linux/init.h>
-#include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/spinlock.h>
 #include <linux/clk.h>
+#include <linux/err.h>
 #include <mach/bridge-regs.h>
 
 /*
  * Watchdog timer block registers.
  */
 #define TIMER_CTRL		0x0000
-#define  WDT_EN			0x0010
+#define WDT_EN			0x0010
 #define WDT_VAL			0x0024
 
 #define WDT_MAX_CYCLE_COUNT	0xffffffff
@@ -44,27 +44,27 @@ static unsigned int wdt_max_duration;	/* (seconds) */
 static struct clk *clk;
 static unsigned int wdt_tclk;
 static void __iomem *wdt_reg;
-static unsigned long wdt_status;
 static DEFINE_SPINLOCK(wdt_lock);
 
-static void orion_wdt_ping(void)
+static int orion_wdt_ping(struct watchdog_device *wdt_dev)
 {
 	spin_lock(&wdt_lock);
 
 	/* Reload watchdog duration */
-	writel(wdt_tclk * heartbeat, wdt_reg + WDT_VAL);
+	writel(wdt_tclk * wdt_dev->timeout, wdt_reg + WDT_VAL);
 
 	spin_unlock(&wdt_lock);
+	return 0;
 }
 
-static void orion_wdt_enable(void)
+static int orion_wdt_start(struct watchdog_device *wdt_dev)
 {
 	u32 reg;
 
 	spin_lock(&wdt_lock);
 
 	/* Set watchdog duration */
-	writel(wdt_tclk * heartbeat, wdt_reg + WDT_VAL);
+	writel(wdt_tclk * wdt_dev->timeout, wdt_reg + WDT_VAL);
 
 	/* Clear watchdog timer interrupt */
 	reg = readl(BRIDGE_CAUSE);
@@ -82,9 +82,10 @@ static void orion_wdt_enable(void)
 	writel(reg, RSTOUTn_MASK);
 
 	spin_unlock(&wdt_lock);
+	return 0;
 }
 
-static void orion_wdt_disable(void)
+static int orion_wdt_stop(struct watchdog_device *wdt_dev)
 {
 	u32 reg;
 
@@ -101,139 +102,44 @@ static void orion_wdt_disable(void)
 	writel(reg, wdt_reg + TIMER_CTRL);
 
 	spin_unlock(&wdt_lock);
+	return 0;
 }
 
-static int orion_wdt_get_timeleft(int *time_left)
+static unsigned int orion_wdt_get_timeleft(struct watchdog_device *wdt_dev)
 {
+	unsigned int time_left;
+
 	spin_lock(&wdt_lock);
-	*time_left = readl(wdt_reg + WDT_VAL) / wdt_tclk;
+	time_left = readl(wdt_reg + WDT_VAL) / wdt_tclk;
 	spin_unlock(&wdt_lock);
-	return 0;
-}
-
-static int orion_wdt_open(struct inode *inode, struct file *file)
-{
-	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
-		return -EBUSY;
-	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-	orion_wdt_enable();
-	return nonseekable_open(inode, file);
-}
 
-static ssize_t orion_wdt_write(struct file *file, const char *data,
-					size_t len, loff_t *ppos)
-{
-	if (len) {
-		if (!nowayout) {
-			size_t i;
-
-			clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-			for (i = 0; i != len; i++) {
-				char c;
-
-				if (get_user(c, data + i))
-					return -EFAULT;
-				if (c == 'V')
-					set_bit(WDT_OK_TO_CLOSE, &wdt_status);
-			}
-		}
-		orion_wdt_ping();
-	}
-	return len;
+	return time_left;
 }
 
-static int orion_wdt_settimeout(int new_time)
+static int orion_wdt_set_timeout(struct watchdog_device *wdt_dev,
+				 unsigned int timeout)
 {
-	if ((new_time <= 0) || (new_time > wdt_max_duration))
-		return -EINVAL;
-
-	/* Set new watchdog time to be used when
-	 * orion_wdt_enable() or orion_wdt_ping() is called. */
-	heartbeat = new_time;
+	wdt_dev->timeout = timeout;
 	return 0;
 }
 
-static const struct watchdog_info ident = {
-	.options	= WDIOF_MAGICCLOSE | WDIOF_SETTIMEOUT |
-			  WDIOF_KEEPALIVEPING,
-	.identity	= "Orion Watchdog",
+static const struct watchdog_info orion_wdt_info = {
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
+	.identity = "Orion Watchdog",
 };
 
-static long orion_wdt_ioctl(struct file *file, unsigned int cmd,
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
-	case WDIOC_GETBOOTSTATUS:
-		ret = put_user(0, (int *)arg);
-		break;
-
-	case WDIOC_KEEPALIVE:
-		orion_wdt_ping();
-		ret = 0;
-		break;
-
-	case WDIOC_SETTIMEOUT:
-		ret = get_user(time, (int *)arg);
-		if (ret)
-			break;
-
-		if (orion_wdt_settimeout(time)) {
-			ret = -EINVAL;
-			break;
-		}
-		orion_wdt_ping();
-		/* Fall through */
-
-	case WDIOC_GETTIMEOUT:
-		ret = put_user(heartbeat, (int *)arg);
-		break;
-
-	case WDIOC_GETTIMELEFT:
-		if (orion_wdt_get_timeleft(&time)) {
-			ret = -EINVAL;
-			break;
-		}
-		ret = put_user(time, (int *)arg);
-		break;
-	}
-	return ret;
-}
-
-static int orion_wdt_release(struct inode *inode, struct file *file)
-{
-	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
-		orion_wdt_disable();
-	else
-		pr_crit("Device closed unexpectedly - timer will not stop\n");
-	clear_bit(WDT_IN_USE, &wdt_status);
-	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-
-	return 0;
-}
-
-
-static const struct file_operations orion_wdt_fops = {
-	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
-	.write		= orion_wdt_write,
-	.unlocked_ioctl	= orion_wdt_ioctl,
-	.open		= orion_wdt_open,
-	.release	= orion_wdt_release,
+static const struct watchdog_ops orion_wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = orion_wdt_start,
+	.stop = orion_wdt_stop,
+	.ping = orion_wdt_ping,
+	.set_timeout = orion_wdt_set_timeout,
+	.get_timeleft = orion_wdt_get_timeleft,
 };
 
-static struct miscdevice orion_wdt_miscdev = {
-	.minor		= WATCHDOG_MINOR,
-	.name		= "watchdog",
-	.fops		= &orion_wdt_fops,
+static struct watchdog_device orion_wdt = {
+	.info = &orion_wdt_info,
+	.ops = &orion_wdt_ops,
 };
 
 static int __devinit orion_wdt_probe(struct platform_device *pdev)
@@ -241,29 +147,34 @@ static int __devinit orion_wdt_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret;
 
-	clk = clk_get(&pdev->dev, NULL);
+	clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(clk)) {
-		printk(KERN_ERR "Orion Watchdog missing clock\n");
+		dev_err(&pdev->dev, "Orion Watchdog missing clock\n");
 		return -ENODEV;
 	}
 	clk_prepare_enable(clk);
 	wdt_tclk = clk_get_rate(clk);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-
-	wdt_reg = ioremap(res->start, resource_size(res));
-
-	if (orion_wdt_miscdev.parent)
-		return -EBUSY;
-	orion_wdt_miscdev.parent = &pdev->dev;
+	wdt_reg = devm_ioremap(&pdev->dev, res->start, resource_size(res));
+	if (!wdt_reg)
+		return -ENOMEM;
 
 	wdt_max_duration = WDT_MAX_CYCLE_COUNT / wdt_tclk;
-	if (orion_wdt_settimeout(heartbeat))
+
+	if ((heartbeat < 1) || (heartbeat > wdt_max_duration))
 		heartbeat = wdt_max_duration;
 
-	ret = misc_register(&orion_wdt_miscdev);
-	if (ret)
+	orion_wdt.timeout = heartbeat;
+	orion_wdt.min_timeout = 1;
+	orion_wdt.max_timeout = wdt_max_duration;
+
+	watchdog_set_nowayout(&orion_wdt, nowayout);
+	ret = watchdog_register_device(&orion_wdt);
+	if (ret) {
+		clk_disable_unprepare(clk);
 		return ret;
+	}
 
 	pr_info("Initial timeout %d sec%s\n",
 		heartbeat, nowayout ? ", nowayout" : "");
@@ -272,27 +183,14 @@ static int __devinit orion_wdt_probe(struct platform_device *pdev)
 
 static int __devexit orion_wdt_remove(struct platform_device *pdev)
 {
-	int ret;
-
-	if (test_bit(WDT_IN_USE, &wdt_status)) {
-		orion_wdt_disable();
-		clear_bit(WDT_IN_USE, &wdt_status);
-	}
-
-	ret = misc_deregister(&orion_wdt_miscdev);
-	if (!ret)
-		orion_wdt_miscdev.parent = NULL;
-
+	watchdog_unregister_device(&orion_wdt);
 	clk_disable_unprepare(clk);
-	clk_put(clk);
-
-	return ret;
+	return 0;
 }
 
 static void orion_wdt_shutdown(struct platform_device *pdev)
 {
-	if (test_bit(WDT_IN_USE, &wdt_status))
-		orion_wdt_disable();
+	orion_wdt_stop(&orion_wdt);
 }
 
 static struct platform_driver orion_wdt_driver = {
-- 
1.7.9.5




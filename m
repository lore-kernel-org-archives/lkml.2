Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab2CZXUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 19:20:53 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56246 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab2CZXUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 19:20:51 -0400
Message-ID: <1332804040.5294.2.camel@phoenix>
Subject: [PATCH RFT v3] watchdog: Convert orion_wdt driver to watchdog core
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sylver Bruneau <sylver.bruneau@googlemail.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>
Date: Tue, 27 Mar 2012 07:20:40 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert orion_wdt driver to use watchdog framework API.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Hi Jason, Andrew,
I don't have this hardware handy.
I'd appreciate if you can review and test this patch.

Thanks,
Axel
v3: Base on Jason's comment, platform data is changing soon with devicetree
   support, so I don't change the coding style for getting tclk from pdata.
   I keep the whitespace change for WDT_EN in this version, as it makes the
   code looks better and I don't think it worth to send a separate patch for
   fixing a whilespace.
v2: v1 does not apply to current tree. so I re-generate this patch.

 drivers/watchdog/Kconfig     |    1 +
 drivers/watchdog/orion_wdt.c |  193 ++++++++++--------------------------------
 2 files changed, 46 insertions(+), 148 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 3709624..db7aeeb 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -277,6 +277,7 @@ config DAVINCI_WATCHDOG
 config ORION_WATCHDOG
 	tristate "Orion watchdog"
 	depends on ARCH_ORION5X || ARCH_KIRKWOOD
+	select WATCHDOG_CORE
 	help
 	  Say Y here if to include support for the watchdog timer
 	  in the Marvell Orion5x and Kirkwood ARM SoCs.
diff --git a/drivers/watchdog/orion_wdt.c b/drivers/watchdog/orion_wdt.c
index 788aa15..4b6e35f 100644
--- a/drivers/watchdog/orion_wdt.c
+++ b/drivers/watchdog/orion_wdt.c
@@ -16,12 +16,11 @@
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
 #include <mach/bridge-regs.h>
@@ -31,7 +30,7 @@
  * Watchdog timer block registers.
  */
 #define TIMER_CTRL		0x0000
-#define  WDT_EN			0x0010
+#define WDT_EN			0x0010
 #define WDT_VAL			0x0024
 
 #define WDT_MAX_CYCLE_COUNT	0xffffffff
@@ -43,27 +42,27 @@ static int heartbeat = -1;		/* module parameter (seconds) */
 static unsigned int wdt_max_duration;	/* (seconds) */
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
@@ -81,9 +80,10 @@ static void orion_wdt_enable(void)
 	writel(reg, RSTOUTn_MASK);
 
 	spin_unlock(&wdt_lock);
+	return 0;
 }
 
-static void orion_wdt_disable(void)
+static int orion_wdt_stop(struct watchdog_device *wdt_dev)
 {
 	u32 reg;
 
@@ -100,139 +100,44 @@ static void orion_wdt_disable(void)
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
 
-static int orion_wdt_open(struct inode *inode, struct file *file)
-{
-	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
-		return -EBUSY;
-	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-	orion_wdt_enable();
-	return nonseekable_open(inode, file);
+	return time_left;
 }
 
-static ssize_t orion_wdt_write(struct file *file, const char *data,
-					size_t len, loff_t *ppos)
+static int orion_wdt_set_timeout(struct watchdog_device *wdt_dev,
+				 unsigned int timeout)
 {
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
-}
-
-static int orion_wdt_settimeout(int new_time)
-{
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
@@ -249,18 +154,21 @@ static int __devinit orion_wdt_probe(struct platform_device *pdev)
 	}
 
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
+	orion_wdt.timeout = heartbeat;
+	orion_wdt.min_timeout = 1;
+	orion_wdt.max_timeout = wdt_max_duration;
+
+	watchdog_set_nowayout(&orion_wdt, nowayout);
+	ret = watchdog_register_device(&orion_wdt);
 	if (ret)
 		return ret;
 
@@ -271,24 +179,13 @@ static int __devinit orion_wdt_probe(struct platform_device *pdev)
 
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
-	return ret;
+	watchdog_unregister_device(&orion_wdt);
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
1.7.5.4




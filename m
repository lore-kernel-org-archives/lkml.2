Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031542Ab2CPDyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 23:54:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56559 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031128Ab2CPDyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 23:54:03 -0400
Message-ID: <1331870033.13760.2.camel@phoenix>
Subject: [PATCH RFT] watchdog: Convert txx9wdt driver to watchdog framework
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, Ralf Baechle <ralf@linux-mips.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Date: Fri, 16 Mar 2012 11:53:53 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts txx9wdt driver to watchdog framework.
Also use devm_* APIs to save a few error handling code.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/watchdog/txx9wdt.c |  155 +++++++++++---------------------------------
 1 files changed, 37 insertions(+), 118 deletions(-)

diff --git a/drivers/watchdog/txx9wdt.c b/drivers/watchdog/txx9wdt.c
index d02804c..53f1b17 100644
--- a/drivers/watchdog/txx9wdt.c
+++ b/drivers/watchdog/txx9wdt.c
@@ -15,9 +15,7 @@
 #include <linux/types.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
-#include <linux/fs.h>
 #include <linux/init.h>
-#include <linux/uaccess.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/err.h>
@@ -43,20 +41,19 @@ MODULE_PARM_DESC(nowayout,
 #define WD_TIMER_CLK	(clk_get_rate(txx9_imclk) / (2 << WD_TIMER_CCD))
 #define WD_MAX_TIMEOUT	((0xffffffff >> (32 - TXX9_TIMER_BITS)) / WD_TIMER_CLK)
 
-static unsigned long txx9wdt_alive;
-static int expect_close;
 static struct txx9_tmr_reg __iomem *txx9wdt_reg;
 static struct clk *txx9_imclk;
 static DEFINE_SPINLOCK(txx9_lock);
 
-static void txx9wdt_ping(void)
+static int txx9wdt_ping(struct watchdog_device *wdt_dev)
 {
 	spin_lock(&txx9_lock);
 	__raw_writel(TXx9_TMWTMR_TWIE | TXx9_TMWTMR_TWC, &txx9wdt_reg->wtmr);
 	spin_unlock(&txx9_lock);
+	return 0;
 }
 
-static void txx9wdt_start(void)
+static int txx9wdt_start(struct watchdog_device *wdt_dev)
 {
 	spin_lock(&txx9_lock);
 	__raw_writel(WD_TIMER_CLK * timeout, &txx9wdt_reg->cpra);
@@ -66,120 +63,44 @@ static void txx9wdt_start(void)
 		     &txx9wdt_reg->tcr);
 	__raw_writel(TXx9_TMWTMR_TWIE | TXx9_TMWTMR_TWC, &txx9wdt_reg->wtmr);
 	spin_unlock(&txx9_lock);
+	return 0;
 }
 
-static void txx9wdt_stop(void)
+static int txx9wdt_stop(struct watchdog_device *wdt_dev)
 {
 	spin_lock(&txx9_lock);
 	__raw_writel(TXx9_TMWTMR_WDIS, &txx9wdt_reg->wtmr);
 	__raw_writel(__raw_readl(&txx9wdt_reg->tcr) & ~TXx9_TMTCR_TCE,
 		     &txx9wdt_reg->tcr);
 	spin_unlock(&txx9_lock);
-}
-
-static int txx9wdt_open(struct inode *inode, struct file *file)
-{
-	if (test_and_set_bit(0, &txx9wdt_alive))
-		return -EBUSY;
-
-	if (__raw_readl(&txx9wdt_reg->tcr) & TXx9_TMTCR_TCE) {
-		clear_bit(0, &txx9wdt_alive);
-		return -EBUSY;
-	}
-
-	if (nowayout)
-		__module_get(THIS_MODULE);
-
-	txx9wdt_start();
-	return nonseekable_open(inode, file);
-}
-
-static int txx9wdt_release(struct inode *inode, struct file *file)
-{
-	if (expect_close)
-		txx9wdt_stop();
-	else {
-		pr_crit("Unexpected close, not stopping watchdog!\n");
-		txx9wdt_ping();
-	}
-	clear_bit(0, &txx9wdt_alive);
-	expect_close = 0;
 	return 0;
 }
 
-static ssize_t txx9wdt_write(struct file *file, const char __user *data,
-			     size_t len, loff_t *ppos)
+static int txx9wdt_set_timeout(struct watchdog_device *wdt_dev,
+			       unsigned int new_timeout)
 {
-	if (len) {
-		if (!nowayout) {
-			size_t i;
-
-			expect_close = 0;
-			for (i = 0; i != len; i++) {
-				char c;
-				if (get_user(c, data + i))
-					return -EFAULT;
-				if (c == 'V')
-					expect_close = 1;
-			}
-		}
-		txx9wdt_ping();
-	}
-	return len;
+	timeout = new_timeout;
+	txx9wdt_stop(wdt_dev);
+	txx9wdt_start(wdt_dev);
+	return 0;
 }
 
-static long txx9wdt_ioctl(struct file *file, unsigned int cmd,
-							unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	int new_timeout;
-	static const struct watchdog_info ident = {
-		.options =		WDIOF_SETTIMEOUT |
-					WDIOF_KEEPALIVEPING |
-					WDIOF_MAGICCLOSE,
-		.firmware_version =	0,
-		.identity =		"Hardware Watchdog for TXx9",
-	};
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
-	case WDIOC_KEEPALIVE:
-		txx9wdt_ping();
-		return 0;
-	case WDIOC_SETTIMEOUT:
-		if (get_user(new_timeout, p))
-			return -EFAULT;
-		if (new_timeout < 1 || new_timeout > WD_MAX_TIMEOUT)
-			return -EINVAL;
-		timeout = new_timeout;
-		txx9wdt_stop();
-		txx9wdt_start();
-		/* Fall */
-	case WDIOC_GETTIMEOUT:
-		return put_user(timeout, p);
-	default:
-		return -ENOTTY;
-	}
-}
+static const struct watchdog_info txx9wdt_info = {
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
+	.identity = "Hardware Watchdog for TXx9",
+};
 
-static const struct file_operations txx9wdt_fops = {
-	.owner		=	THIS_MODULE,
-	.llseek		=	no_llseek,
-	.write		=	txx9wdt_write,
-	.unlocked_ioctl =	txx9wdt_ioctl,
-	.open		=	txx9wdt_open,
-	.release	=	txx9wdt_release,
+static const struct watchdog_ops txx9wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = txx9wdt_start,
+	.stop = txx9wdt_stop,
+	.ping = txx9wdt_ping,
+	.set_timeout = txx9wdt_set_timeout,
 };
 
-static struct miscdevice txx9wdt_miscdev = {
-	.minor	=	WATCHDOG_MINOR,
-	.name	=	"watchdog",
-	.fops	=	&txx9wdt_fops,
+static struct watchdog_device txx9wdt = {
+	.info = &txx9wdt_info,
+	.ops = &txx9wdt_ops,
 };
 
 static int __init txx9wdt_probe(struct platform_device *dev)
@@ -201,26 +122,24 @@ static int __init txx9wdt_probe(struct platform_device *dev)
 	}
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	if (!res)
-		goto exit_busy;
-	if (!devm_request_mem_region(&dev->dev, res->start, resource_size(res),
-				     "txx9wdt"))
-		goto exit_busy;
-	txx9wdt_reg = devm_ioremap(&dev->dev, res->start, resource_size(res));
-	if (!txx9wdt_reg)
-		goto exit_busy;
-
-	ret = misc_register(&txx9wdt_miscdev);
-	if (ret) {
+	txx9wdt_reg = devm_request_and_ioremap(&dev->dev, res);
+	if (!txx9wdt_reg) {
+		ret = -EBUSY;
 		goto exit;
 	}
 
+	txx9wdt.min_timeout = 1;
+	txx9wdt.max_timeout = WD_MAX_TIMEOUT;
+	watchdog_set_nowayout(&txx9wdt, nowayout);
+
+	ret = watchdog_register_device(&txx9wdt);
+	if (ret)
+		goto exit;
+
 	pr_info("Hardware Watchdog Timer: timeout=%d sec (max %ld) (nowayout= %d)\n",
 		timeout, WD_MAX_TIMEOUT, nowayout);
 
 	return 0;
-exit_busy:
-	ret = -EBUSY;
 exit:
 	if (txx9_imclk) {
 		clk_disable(txx9_imclk);
@@ -231,7 +150,7 @@ exit:
 
 static int __exit txx9wdt_remove(struct platform_device *dev)
 {
-	misc_deregister(&txx9wdt_miscdev);
+	watchdog_unregister_device(&txx9wdt);
 	clk_disable(txx9_imclk);
 	clk_put(txx9_imclk);
 	return 0;
@@ -239,7 +158,7 @@ static int __exit txx9wdt_remove(struct platform_device *dev)
 
 static void txx9wdt_shutdown(struct platform_device *dev)
 {
-	txx9wdt_stop();
+	txx9wdt_stop(&txx9wdt);
 }
 
 static struct platform_driver txx9wdt_driver = {
-- 
1.7.5.4




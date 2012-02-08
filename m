Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab2BHGYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 01:24:21 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62478 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab2BHGYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 01:24:19 -0500
Message-ID: <1328682250.13350.1.camel@phoenix>
Subject: [RFC][PATCH] watchdog: Convert max63xx_wdt driver to watchdog
 framework
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@misterjones.org>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Date: Wed, 08 Feb 2012 14:24:10 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts max63xx_wdt driver to watchdog framework.
Also use devm_* APIs to save a few error handling code.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Hi,
I don't have this hardware, I'd appreciate if someone can test this patch.

Thanks,
Axel
 drivers/watchdog/Kconfig       |    1 +
 drivers/watchdog/max63xx_wdt.c |  188 +++++++---------------------------------
 2 files changed, 31 insertions(+), 158 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 877b107..4f4ee10 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -328,6 +328,7 @@ config TS72XX_WATCHDOG
 config MAX63XX_WATCHDOG
 	tristate "Max63xx watchdog"
 	depends on ARM && HAS_IOMEM
+	select WATCHDOG_CORE
 	help
 	  Support for memory mapped max63{69,70,71,72,73,74} watchdog timer.
 
diff --git a/drivers/watchdog/max63xx_wdt.c b/drivers/watchdog/max63xx_wdt.c
index af63ecf..4d144a5 100644
--- a/drivers/watchdog/max63xx_wdt.c
+++ b/drivers/watchdog/max63xx_wdt.c
@@ -18,16 +18,13 @@
 #include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/fs.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/platform_device.h>
 #include <linux/spinlock.h>
-#include <linux/uaccess.h>
 #include <linux/io.h>
-#include <linux/device.h>
 #include <linux/slab.h>
 
 #define DEFAULT_HEARTBEAT 60
@@ -45,15 +42,8 @@ static int nowayout  = WATCHDOG_NOWAYOUT;
 
 static DEFINE_SPINLOCK(io_lock);
 
-static unsigned long wdt_status;
-#define WDT_IN_USE	0
-#define WDT_RUNNING	1
-#define WDT_OK_TO_CLOSE 2
-
 static int nodelay;
-static struct resource	*wdt_mem;
 static void __iomem	*wdt_base;
-static struct platform_device *max63xx_pdev;
 
 /*
  * The timeout values used are actually the absolute minimum the chip
@@ -117,7 +107,7 @@ max63xx_select_timeout(struct max63xx_timeout *table, int value)
 	return NULL;
 }
 
-static void max63xx_wdt_ping(void)
+static int max63xx_wdt_ping(struct watchdog_device *wdd)
 {
 	u8 val;
 
@@ -129,15 +119,14 @@ static void max63xx_wdt_ping(void)
 	__raw_writeb(val & ~MAX6369_WDI, wdt_base);
 
 	spin_unlock(&io_lock);
+	return 0;
 }
 
-static void max63xx_wdt_enable(struct max63xx_timeout *entry)
+static int max63xx_wdt_start(struct watchdog_device *wdd)
 {
+	struct max63xx_timeout *entry = watchdog_get_drvdata(wdd);
 	u8 val;
 
-	if (test_and_set_bit(WDT_RUNNING, &wdt_status))
-		return;
-
 	spin_lock(&io_lock);
 
 	val = __raw_readb(wdt_base);
@@ -149,10 +138,11 @@ static void max63xx_wdt_enable(struct max63xx_timeout *entry)
 
 	/* check for a edge triggered startup */
 	if (entry->tdelay == 0)
-		max63xx_wdt_ping();
+		max63xx_wdt_ping(wdd);
+	return 0;
 }
 
-static void max63xx_wdt_disable(void)
+static int max63xx_wdt_stop(struct watchdog_device *wdd)
 {
 	u8 val;
 
@@ -164,113 +154,29 @@ static void max63xx_wdt_disable(void)
 	__raw_writeb(val, wdt_base);
 
 	spin_unlock(&io_lock);
-
-	clear_bit(WDT_RUNNING, &wdt_status);
-}
-
-static int max63xx_wdt_open(struct inode *inode, struct file *file)
-{
-	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
-		return -EBUSY;
-
-	max63xx_wdt_enable(current_timeout);
-	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-
-	return nonseekable_open(inode, file);
-}
-
-static ssize_t max63xx_wdt_write(struct file *file, const char *data,
-				 size_t len, loff_t *ppos)
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
-
-				if (c == 'V')
-					set_bit(WDT_OK_TO_CLOSE, &wdt_status);
-			}
-		}
-
-		max63xx_wdt_ping();
-	}
-
-	return len;
+	return 0;
 }
 
-static const struct watchdog_info ident = {
-	.options = WDIOF_MAGICCLOSE | WDIOF_KEEPALIVEPING,
+static const struct watchdog_info max63xx_wdt_info = {
+	.options = WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
 	.identity = "max63xx Watchdog",
 };
 
-static long max63xx_wdt_ioctl(struct file *file, unsigned int cmd,
-			      unsigned long arg)
-{
-	int ret = -ENOTTY;
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
-		max63xx_wdt_ping();
-		ret = 0;
-		break;
-
-	case WDIOC_GETTIMEOUT:
-		ret = put_user(heartbeat, (int *)arg);
-		break;
-	}
-	return ret;
-}
-
-static int max63xx_wdt_release(struct inode *inode, struct file *file)
-{
-	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
-		max63xx_wdt_disable();
-	else
-		dev_crit(&max63xx_pdev->dev,
-			 "device closed unexpectedly - timer will not stop\n");
-
-	clear_bit(WDT_IN_USE, &wdt_status);
-	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-
-	return 0;
-}
-
-static const struct file_operations max63xx_wdt_fops = {
-	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
-	.write		= max63xx_wdt_write,
-	.unlocked_ioctl	= max63xx_wdt_ioctl,
-	.open		= max63xx_wdt_open,
-	.release	= max63xx_wdt_release,
+static const struct watchdog_ops max63xx_wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = max63xx_wdt_start,
+	.stop = max63xx_wdt_stop,
+	.ping = max63xx_wdt_ping,
 };
 
-static struct miscdevice max63xx_wdt_miscdev = {
-	.minor	= WATCHDOG_MINOR,
-	.name	= "watchdog",
-	.fops	= &max63xx_wdt_fops,
+static struct watchdog_device max63xx_wdt_dev = {
+	.info = &max63xx_wdt_info,
+	.ops = &max63xx_wdt_ops,
 };
 
 static int __devinit max63xx_wdt_probe(struct platform_device *pdev)
 {
-	int ret = 0;
-	int size;
-	struct device *dev = &pdev->dev;
+	struct resource	*wdt_mem;
 	struct max63xx_timeout *table;
 
 	table = (struct max63xx_timeout *)pdev->id_entry->driver_data;
@@ -278,68 +184,34 @@ static int __devinit max63xx_wdt_probe(struct platform_device *pdev)
 	if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
 		heartbeat = DEFAULT_HEARTBEAT;
 
-	dev_info(dev, "requesting %ds heartbeat\n", heartbeat);
+	dev_info(&pdev->dev, "requesting %ds heartbeat\n", heartbeat);
 	current_timeout = max63xx_select_timeout(table, heartbeat);
 
 	if (!current_timeout) {
-		dev_err(dev, "unable to satisfy heartbeat request\n");
+		dev_err(&pdev->dev, "unable to satisfy heartbeat request\n");
 		return -EINVAL;
 	}
 
-	dev_info(dev, "using %ds heartbeat with %ds initial delay\n",
+	dev_info(&pdev->dev, "using %ds heartbeat with %ds initial delay\n",
 		 current_timeout->twd, current_timeout->tdelay);
 
 	heartbeat = current_timeout->twd;
 
-	max63xx_pdev = pdev;
-
 	wdt_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (wdt_mem == NULL) {
-		dev_err(dev, "failed to get memory region resource\n");
-		return -ENOENT;
-	}
+	wdt_base = devm_request_and_ioremap(&pdev->dev, wdt_mem);
+	if (!wdt_base)
+		return -ENOMEM;
 
-	size = resource_size(wdt_mem);
-	if (!request_mem_region(wdt_mem->start, size, pdev->name)) {
-		dev_err(dev, "failed to get memory region\n");
-		return -ENOENT;
-	}
-
-	wdt_base = ioremap(wdt_mem->start, size);
-	if (!wdt_base) {
-		dev_err(dev, "failed to map memory region\n");
-		ret = -ENOMEM;
-		goto out_request;
-	}
+	max63xx_wdt_dev.timeout = heartbeat;
+	watchdog_set_nowayout(&max63xx_wdt_dev, nowayout);
+	watchdog_set_drvdata(&max63xx_wdt_dev, current_timeout);
 
-	ret = misc_register(&max63xx_wdt_miscdev);
-	if (ret < 0) {
-		dev_err(dev, "cannot register misc device\n");
-		goto out_unmap;
-	}
-
-	return 0;
-
-out_unmap:
-	iounmap(wdt_base);
-out_request:
-	release_mem_region(wdt_mem->start, size);
-	wdt_mem = NULL;
-
-	return ret;
+	return watchdog_register_device(&max63xx_wdt_dev);
 }
 
 static int __devexit max63xx_wdt_remove(struct platform_device *pdev)
 {
-	misc_deregister(&max63xx_wdt_miscdev);
-	if (wdt_mem) {
-		release_mem_region(wdt_mem->start, resource_size(wdt_mem));
-		wdt_mem = NULL;
-	}
-
-	if (wdt_base)
-		iounmap(wdt_base);
-
+	watchdog_unregister_device(&max63xx_wdt_dev);
 	return 0;
 }
 
-- 
1.7.5.4




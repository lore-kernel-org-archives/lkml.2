Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab2KLSrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 13:47:23 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:55410 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab2KLSrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 13:47:17 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [RESEND PATCH v3 1/6] watchdog: omap_wdt: convert to new watchdog core
Date: Mon, 12 Nov 2012 20:47:00 +0200
Message-Id: <1352746025-1669-2-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1352746025-1669-1-git-send-email-aaro.koskinen@iki.fi>
References: <1352746025-1669-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert omap_wdt to new watchdog core. On OMAP boards, there are usually
multiple watchdogs. Since the new watchdog core supports multiple
watchdogs, all watchdog drivers used on OMAP should be converted.

The legacy watchdog device node is still created, so this should not
break existing users.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Tested-by: Jarkko Nikula <jarkko.nikula@jollamobile.com>
Tested-by: Lokesh Vutla <lokeshvutla@ti.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
---
 drivers/watchdog/Kconfig    |    1 +
 drivers/watchdog/omap_wdt.c |  274 ++++++++++++++++++-------------------------
 2 files changed, 118 insertions(+), 157 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index ad1bb93..a7f5590 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -232,6 +232,7 @@ config EP93XX_WATCHDOG
 config OMAP_WATCHDOG
 	tristate "OMAP Watchdog"
 	depends on ARCH_OMAP16XX || ARCH_OMAP2PLUS
+	select WATCHDOG_CORE
 	help
 	  Support for TI OMAP1610/OMAP1710/OMAP2420/OMAP3430/OMAP4430 watchdog.  Say 'Y'
 	  here to enable the OMAP1610/OMAP1710/OMAP2420/OMAP3430/OMAP4430 watchdog timer.
diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index f5db18db..d28ad5e 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -31,18 +31,14 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/fs.h>
 #include <linux/mm.h>
-#include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/moduleparam.h>
-#include <linux/bitops.h>
 #include <linux/io.h>
-#include <linux/uaccess.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
 #include <mach/hardware.h>
@@ -51,24 +47,20 @@
 
 #include "omap_wdt.h"
 
-static struct platform_device *omap_wdt_dev;
-
 static unsigned timer_margin;
 module_param(timer_margin, uint, 0);
 MODULE_PARM_DESC(timer_margin, "initial watchdog timeout (in seconds)");
 
-static unsigned int wdt_trgr_pattern = 0x1234;
-static DEFINE_SPINLOCK(wdt_lock);
-
 struct omap_wdt_dev {
 	void __iomem    *base;          /* physical */
 	struct device   *dev;
-	int             omap_wdt_users;
+	bool		omap_wdt_users;
 	struct resource *mem;
-	struct miscdevice omap_wdt_miscdev;
+	int		wdt_trgr_pattern;
+	struct mutex	lock;		/* to avoid races with PM */
 };
 
-static void omap_wdt_ping(struct omap_wdt_dev *wdev)
+static void __omap_wdt_ping(struct omap_wdt_dev *wdev)
 {
 	void __iomem    *base = wdev->base;
 
@@ -76,8 +68,8 @@ static void omap_wdt_ping(struct omap_wdt_dev *wdev)
 	while ((__raw_readl(base + OMAP_WATCHDOG_WPS)) & 0x08)
 		cpu_relax();
 
-	wdt_trgr_pattern = ~wdt_trgr_pattern;
-	__raw_writel(wdt_trgr_pattern, (base + OMAP_WATCHDOG_TGR));
+	wdev->wdt_trgr_pattern = ~wdev->wdt_trgr_pattern;
+	__raw_writel(wdev->wdt_trgr_pattern, (base + OMAP_WATCHDOG_TGR));
 
 	/* wait for posted write to complete */
 	while ((__raw_readl(base + OMAP_WATCHDOG_WPS)) & 0x08)
@@ -85,7 +77,7 @@ static void omap_wdt_ping(struct omap_wdt_dev *wdev)
 	/* reloaded WCRR from WLDR */
 }
 
-static void omap_wdt_enable(struct omap_wdt_dev *wdev)
+static void __omap_wdt_enable(struct omap_wdt_dev *wdev)
 {
 	void __iomem *base = wdev->base;
 
@@ -99,7 +91,7 @@ static void omap_wdt_enable(struct omap_wdt_dev *wdev)
 		cpu_relax();
 }
 
-static void omap_wdt_disable(struct omap_wdt_dev *wdev)
+static void __omap_wdt_disable(struct omap_wdt_dev *wdev)
 {
 	void __iomem *base = wdev->base;
 
@@ -113,18 +105,10 @@ static void omap_wdt_disable(struct omap_wdt_dev *wdev)
 		cpu_relax();
 }
 
-static void omap_wdt_adjust_timeout(unsigned new_timeout)
-{
-	if (new_timeout < TIMER_MARGIN_MIN)
-		new_timeout = TIMER_MARGIN_DEFAULT;
-	if (new_timeout > TIMER_MARGIN_MAX)
-		new_timeout = TIMER_MARGIN_MAX;
-	timer_margin = new_timeout;
-}
-
-static void omap_wdt_set_timeout(struct omap_wdt_dev *wdev)
+static void __omap_wdt_set_timeout(struct omap_wdt_dev *wdev,
+				   unsigned int timeout)
 {
-	u32 pre_margin = GET_WLDR_VAL(timer_margin);
+	u32 pre_margin = GET_WLDR_VAL(timeout);
 	void __iomem *base = wdev->base;
 
 	/* just count up at 32 KHz */
@@ -136,16 +120,14 @@ static void omap_wdt_set_timeout(struct omap_wdt_dev *wdev)
 		cpu_relax();
 }
 
-/*
- *	Allow only one task to hold it open
- */
-static int omap_wdt_open(struct inode *inode, struct file *file)
+static int omap_wdt_start(struct watchdog_device *wdog)
 {
-	struct omap_wdt_dev *wdev = platform_get_drvdata(omap_wdt_dev);
+	struct omap_wdt_dev *wdev = watchdog_get_drvdata(wdog);
 	void __iomem *base = wdev->base;
 
-	if (test_and_set_bit(1, (unsigned long *)&(wdev->omap_wdt_users)))
-		return -EBUSY;
+	mutex_lock(&wdev->lock);
+
+	wdev->omap_wdt_users = true;
 
 	pm_runtime_get_sync(wdev->dev);
 
@@ -157,119 +139,79 @@ static int omap_wdt_open(struct inode *inode, struct file *file)
 	while (__raw_readl(base + OMAP_WATCHDOG_WPS) & 0x01)
 		cpu_relax();
 
-	file->private_data = (void *) wdev;
+	__omap_wdt_set_timeout(wdev, wdog->timeout);
+	__omap_wdt_ping(wdev); /* trigger loading of new timeout value */
+	__omap_wdt_enable(wdev);
 
-	omap_wdt_set_timeout(wdev);
-	omap_wdt_ping(wdev); /* trigger loading of new timeout value */
-	omap_wdt_enable(wdev);
+	mutex_unlock(&wdev->lock);
 
-	return nonseekable_open(inode, file);
+	return 0;
 }
 
-static int omap_wdt_release(struct inode *inode, struct file *file)
+static int omap_wdt_stop(struct watchdog_device *wdog)
 {
-	struct omap_wdt_dev *wdev = file->private_data;
-
-	/*
-	 *      Shut off the timer unless NOWAYOUT is defined.
-	 */
-#ifndef CONFIG_WATCHDOG_NOWAYOUT
-	omap_wdt_disable(wdev);
+	struct omap_wdt_dev *wdev = watchdog_get_drvdata(wdog);
 
+	mutex_lock(&wdev->lock);
+	__omap_wdt_disable(wdev);
 	pm_runtime_put_sync(wdev->dev);
-#else
-	pr_crit("Unexpected close, not stopping!\n");
-#endif
-	wdev->omap_wdt_users = 0;
-
+	wdev->omap_wdt_users = false;
+	mutex_unlock(&wdev->lock);
 	return 0;
 }
 
-static ssize_t omap_wdt_write(struct file *file, const char __user *data,
-		size_t len, loff_t *ppos)
+static int omap_wdt_ping(struct watchdog_device *wdog)
 {
-	struct omap_wdt_dev *wdev = file->private_data;
+	struct omap_wdt_dev *wdev = watchdog_get_drvdata(wdog);
 
-	/* Refresh LOAD_TIME. */
-	if (len) {
-		spin_lock(&wdt_lock);
-		omap_wdt_ping(wdev);
-		spin_unlock(&wdt_lock);
-	}
-	return len;
+	mutex_lock(&wdev->lock);
+	__omap_wdt_ping(wdev);
+	mutex_unlock(&wdev->lock);
+
+	return 0;
 }
 
-static long omap_wdt_ioctl(struct file *file, unsigned int cmd,
-						unsigned long arg)
+static int omap_wdt_set_timeout(struct watchdog_device *wdog,
+				unsigned int timeout)
 {
-	struct omap_wdt_dev *wdev;
-	int new_margin;
-	static const struct watchdog_info ident = {
-		.identity = "OMAP Watchdog",
-		.options = WDIOF_SETTIMEOUT,
-		.firmware_version = 0,
-	};
-
-	wdev = file->private_data;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user((struct watchdog_info __user *)arg, &ident,
-				sizeof(ident));
-	case WDIOC_GETSTATUS:
-		return put_user(0, (int __user *)arg);
-	case WDIOC_GETBOOTSTATUS:
-#ifdef CONFIG_ARCH_OMAP1
-		if (cpu_is_omap16xx())
-			return put_user(__raw_readw(ARM_SYSST),
-					(int __user *)arg);
-#endif
-#ifdef CONFIG_ARCH_OMAP2PLUS
-		if (cpu_is_omap24xx())
-			return put_user(omap_prcm_get_reset_sources(),
-					(int __user *)arg);
-#endif
-		return put_user(0, (int __user *)arg);
-	case WDIOC_KEEPALIVE:
-		spin_lock(&wdt_lock);
-		omap_wdt_ping(wdev);
-		spin_unlock(&wdt_lock);
-		return 0;
-	case WDIOC_SETTIMEOUT:
-		if (get_user(new_margin, (int __user *)arg))
-			return -EFAULT;
-		omap_wdt_adjust_timeout(new_margin);
-
-		spin_lock(&wdt_lock);
-		omap_wdt_disable(wdev);
-		omap_wdt_set_timeout(wdev);
-		omap_wdt_enable(wdev);
-
-		omap_wdt_ping(wdev);
-		spin_unlock(&wdt_lock);
-		/* Fall */
-	case WDIOC_GETTIMEOUT:
-		return put_user(timer_margin, (int __user *)arg);
-	default:
-		return -ENOTTY;
-	}
+	struct omap_wdt_dev *wdev = watchdog_get_drvdata(wdog);
+
+	mutex_lock(&wdev->lock);
+	__omap_wdt_disable(wdev);
+	__omap_wdt_set_timeout(wdev, timeout);
+	__omap_wdt_enable(wdev);
+	__omap_wdt_ping(wdev);
+	wdog->timeout = timeout;
+	mutex_unlock(&wdev->lock);
+
+	return 0;
 }
 
-static const struct file_operations omap_wdt_fops = {
-	.owner = THIS_MODULE,
-	.write = omap_wdt_write,
-	.unlocked_ioctl = omap_wdt_ioctl,
-	.open = omap_wdt_open,
-	.release = omap_wdt_release,
-	.llseek = no_llseek,
+static const struct watchdog_info omap_wdt_info = {
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.identity = "OMAP Watchdog",
+};
+
+static const struct watchdog_ops omap_wdt_ops = {
+	.owner		= THIS_MODULE,
+	.start		= omap_wdt_start,
+	.stop		= omap_wdt_stop,
+	.ping		= omap_wdt_ping,
+	.set_timeout	= omap_wdt_set_timeout,
 };
 
 static int __devinit omap_wdt_probe(struct platform_device *pdev)
 {
+	bool nowayout = WATCHDOG_NOWAYOUT;
+	struct watchdog_device *omap_wdt;
 	struct resource *res, *mem;
 	struct omap_wdt_dev *wdev;
 	int ret;
 
+	omap_wdt = kzalloc(sizeof(*omap_wdt), GFP_KERNEL);
+	if (!omap_wdt)
+		return -ENOMEM;
+
 	/* reserve static register mappings */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
@@ -277,11 +219,6 @@ static int __devinit omap_wdt_probe(struct platform_device *pdev)
 		goto err_get_resource;
 	}
 
-	if (omap_wdt_dev) {
-		ret = -EBUSY;
-		goto err_busy;
-	}
-
 	mem = request_mem_region(res->start, resource_size(res), pdev->name);
 	if (!mem) {
 		ret = -EBUSY;
@@ -294,9 +231,34 @@ static int __devinit omap_wdt_probe(struct platform_device *pdev)
 		goto err_kzalloc;
 	}
 
-	wdev->omap_wdt_users = 0;
-	wdev->mem = mem;
-	wdev->dev = &pdev->dev;
+	omap_wdt->info	      = &omap_wdt_info;
+	omap_wdt->ops	      = &omap_wdt_ops;
+	omap_wdt->min_timeout = TIMER_MARGIN_MIN;
+	omap_wdt->max_timeout = TIMER_MARGIN_MAX;
+
+	if (timer_margin >= TIMER_MARGIN_MIN &&
+	    timer_margin <= TIMER_MARGIN_MAX)
+		omap_wdt->timeout = timer_margin;
+	else
+		omap_wdt->timeout = TIMER_MARGIN_DEFAULT;
+
+#ifdef CONFIG_ARCH_OMAP1
+	if (cpu_is_omap16xx())
+		omap_wdt->bootstatus = __raw_readw(ARM_SYSST);
+#endif
+#ifdef CONFIG_ARCH_OMAP2PLUS
+	if (cpu_is_omap24xx())
+		omap_wdt->bootstatus = omap_prcm_get_reset_sources();
+#endif
+
+	watchdog_set_drvdata(omap_wdt, wdev);
+	watchdog_set_nowayout(omap_wdt, nowayout);
+
+	wdev->omap_wdt_users	= false;
+	wdev->mem		= mem;
+	wdev->dev		= &pdev->dev;
+	wdev->wdt_trgr_pattern	= 0x1234;
+	mutex_init(&wdev->lock);
 
 	wdev->base = ioremap(res->start, resource_size(res));
 	if (!wdev->base) {
@@ -304,31 +266,23 @@ static int __devinit omap_wdt_probe(struct platform_device *pdev)
 		goto err_ioremap;
 	}
 
-	platform_set_drvdata(pdev, wdev);
+	platform_set_drvdata(pdev, omap_wdt);
 
 	pm_runtime_enable(wdev->dev);
 	pm_runtime_get_sync(wdev->dev);
 
-	omap_wdt_disable(wdev);
-	omap_wdt_adjust_timeout(timer_margin);
-
-	wdev->omap_wdt_miscdev.parent = &pdev->dev;
-	wdev->omap_wdt_miscdev.minor = WATCHDOG_MINOR;
-	wdev->omap_wdt_miscdev.name = "watchdog";
-	wdev->omap_wdt_miscdev.fops = &omap_wdt_fops;
+	__omap_wdt_disable(wdev);
 
-	ret = misc_register(&(wdev->omap_wdt_miscdev));
+	ret = watchdog_register_device(omap_wdt);
 	if (ret)
 		goto err_misc;
 
 	pr_info("OMAP Watchdog Timer Rev 0x%02x: initial timeout %d sec\n",
 		__raw_readl(wdev->base + OMAP_WATCHDOG_REV) & 0xFF,
-		timer_margin);
+		omap_wdt->timeout);
 
 	pm_runtime_put_sync(wdev->dev);
 
-	omap_wdt_dev = pdev;
-
 	return 0;
 
 err_misc:
@@ -345,37 +299,38 @@ err_kzalloc:
 
 err_busy:
 err_get_resource:
-
+	kfree(omap_wdt);
 	return ret;
 }
 
 static void omap_wdt_shutdown(struct platform_device *pdev)
 {
-	struct omap_wdt_dev *wdev = platform_get_drvdata(pdev);
+	struct watchdog_device *wdog = platform_get_drvdata(pdev);
+	struct omap_wdt_dev *wdev = watchdog_get_drvdata(wdog);
 
+	mutex_lock(&wdev->lock);
 	if (wdev->omap_wdt_users) {
-		omap_wdt_disable(wdev);
+		__omap_wdt_disable(wdev);
 		pm_runtime_put_sync(wdev->dev);
 	}
+	mutex_unlock(&wdev->lock);
 }
 
 static int __devexit omap_wdt_remove(struct platform_device *pdev)
 {
-	struct omap_wdt_dev *wdev = platform_get_drvdata(pdev);
+	struct watchdog_device *wdog = platform_get_drvdata(pdev);
+	struct omap_wdt_dev *wdev = watchdog_get_drvdata(wdog);
 	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
 	pm_runtime_disable(wdev->dev);
-	if (!res)
-		return -ENOENT;
-
-	misc_deregister(&(wdev->omap_wdt_miscdev));
+	watchdog_unregister_device(wdog);
 	release_mem_region(res->start, resource_size(res));
 	platform_set_drvdata(pdev, NULL);
 
 	iounmap(wdev->base);
 
 	kfree(wdev);
-	omap_wdt_dev = NULL;
+	kfree(wdog);
 
 	return 0;
 }
@@ -390,25 +345,31 @@ static int __devexit omap_wdt_remove(struct platform_device *pdev)
 
 static int omap_wdt_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	struct omap_wdt_dev *wdev = platform_get_drvdata(pdev);
+	struct watchdog_device *wdog = platform_get_drvdata(pdev);
+	struct omap_wdt_dev *wdev = watchdog_get_drvdata(wdog);
 
+	mutex_lock(&wdev->lock);
 	if (wdev->omap_wdt_users) {
-		omap_wdt_disable(wdev);
+		__omap_wdt_disable(wdev);
 		pm_runtime_put_sync(wdev->dev);
 	}
+	mutex_unlock(&wdev->lock);
 
 	return 0;
 }
 
 static int omap_wdt_resume(struct platform_device *pdev)
 {
-	struct omap_wdt_dev *wdev = platform_get_drvdata(pdev);
+	struct watchdog_device *wdog = platform_get_drvdata(pdev);
+	struct omap_wdt_dev *wdev = watchdog_get_drvdata(wdog);
 
+	mutex_lock(&wdev->lock);
 	if (wdev->omap_wdt_users) {
 		pm_runtime_get_sync(wdev->dev);
-		omap_wdt_enable(wdev);
-		omap_wdt_ping(wdev);
+		__omap_wdt_enable(wdev);
+		__omap_wdt_ping(wdev);
 	}
+	mutex_unlock(&wdev->lock);
 
 	return 0;
 }
@@ -441,5 +402,4 @@ module_platform_driver(omap_wdt_driver);
 
 MODULE_AUTHOR("George G. Davis");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 MODULE_ALIAS("platform:omap_wdt");
-- 
1.7.2.5


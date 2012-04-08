Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab2DHKOE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 06:14:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54412 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2DHKOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 06:14:02 -0400
Message-ID: <1333880031.25028.3.camel@phoenix>
Subject: [PATCH RFT] watchdog: Convert riowd driver to watchdog framework
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Date: Sun, 08 Apr 2012 18:13:51 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts riowd driver to use watchdog core APIs.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/watchdog/Kconfig |    1 +
 drivers/watchdog/riowd.c |  178 +++++++++++++--------------------------------
 2 files changed, 53 insertions(+), 126 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 3709624..fbd3c2b 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1173,6 +1173,7 @@ config WATCHDOG_CP1XXX
 config WATCHDOG_RIO
 	tristate "RIO Hardware Watchdog support"
 	depends on SPARC64 && PCI
+	select WATCHDOG_CORE
 	help
 	  Say Y here to support the hardware watchdog capability on Sun RIO
 	  machines.  The watchdog timeout period is normally one minute but
diff --git a/drivers/watchdog/riowd.c b/drivers/watchdog/riowd.c
index 49e1b1c..d691567 100644
--- a/drivers/watchdog/riowd.c
+++ b/drivers/watchdog/riowd.c
@@ -8,15 +8,12 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/types.h>
-#include <linux/fs.h>
 #include <linux/errno.h>
 #include <linux/init.h>
-#include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/io.h>
-#include <linux/uaccess.h>
 #include <linux/slab.h>
 
 
@@ -52,181 +49,110 @@ MODULE_LICENSE("GPL");
 #define DRIVER_NAME	"riowd"
 #define PFX		DRIVER_NAME ": "
 
-struct riowd {
+struct riowd_wdt_drvdata {
 	void __iomem		*regs;
 	spinlock_t		lock;
 };
 
-static struct riowd *riowd_device;
-
 #define WDTO_INDEX	0x05
 
 static int riowd_timeout = 1;		/* in minutes */
 module_param(riowd_timeout, int, 0);
 MODULE_PARM_DESC(riowd_timeout, "Watchdog timeout in minutes");
 
-static void riowd_writereg(struct riowd *p, u8 val, int index)
+static void riowd_writereg(struct riowd_wdt_drvdata *drvdata, u8 val, int index)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&p->lock, flags);
-	writeb(index, p->regs + 0);
-	writeb(val, p->regs + 1);
-	spin_unlock_irqrestore(&p->lock, flags);
+	spin_lock_irqsave(&drvdata->lock, flags);
+	writeb(index, drvdata->regs + 0);
+	writeb(val, drvdata->regs + 1);
+	spin_unlock_irqrestore(&drvdata->lock, flags);
 }
 
-static int riowd_open(struct inode *inode, struct file *filp)
+static int riowd_wdt_start(struct watchdog_device *wdd)
 {
-	nonseekable_open(inode, filp);
-	return 0;
-}
+	struct riowd_wdt_drvdata *drvdata = watchdog_get_drvdata(wdd);
 
-static int riowd_release(struct inode *inode, struct file *filp)
-{
+	/* Write the watchdog time-out in minutes to WDTO_INDEX */
+	riowd_writereg(drvdata, wdd->timeout / 60, WDTO_INDEX);
 	return 0;
 }
 
-static long riowd_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+static int riowd_wdt_stop(struct watchdog_device *wdd)
 {
-	static const struct watchdog_info info = {
-		.options		= WDIOF_SETTIMEOUT,
-		.firmware_version	= 1,
-		.identity		= DRIVER_NAME,
-	};
-	void __user *argp = (void __user *)arg;
-	struct riowd *p = riowd_device;
-	unsigned int options;
-	int new_margin;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		if (copy_to_user(argp, &info, sizeof(info)))
-			return -EFAULT;
-		break;
-
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		if (put_user(0, (int __user *)argp))
-			return -EFAULT;
-		break;
-
-	case WDIOC_KEEPALIVE:
-		riowd_writereg(p, riowd_timeout, WDTO_INDEX);
-		break;
-
-	case WDIOC_SETOPTIONS:
-		if (copy_from_user(&options, argp, sizeof(options)))
-			return -EFAULT;
-
-		if (options & WDIOS_DISABLECARD)
-			riowd_writereg(p, 0, WDTO_INDEX);
-		else if (options & WDIOS_ENABLECARD)
-			riowd_writereg(p, riowd_timeout, WDTO_INDEX);
-		else
-			return -EINVAL;
-
-		break;
-
-	case WDIOC_SETTIMEOUT:
-		if (get_user(new_margin, (int __user *)argp))
-			return -EFAULT;
-		if ((new_margin < 60) || (new_margin > (255 * 60)))
-			return -EINVAL;
-		riowd_timeout = (new_margin + 59) / 60;
-		riowd_writereg(p, riowd_timeout, WDTO_INDEX);
-		/* Fall */
-
-	case WDIOC_GETTIMEOUT:
-		return put_user(riowd_timeout * 60, (int __user *)argp);
-
-	default:
-		return -EINVAL;
-	};
+	struct riowd_wdt_drvdata *drvdata = watchdog_get_drvdata(wdd);
 
+	riowd_writereg(drvdata, 0, WDTO_INDEX);
 	return 0;
 }
 
-static ssize_t riowd_write(struct file *file, const char __user *buf,
-						size_t count, loff_t *ppos)
+static int riowd_wdt_set_timeout(struct watchdog_device *wdd, unsigned timeout)
 {
-	struct riowd *p = riowd_device;
-
-	if (count) {
-		riowd_writereg(p, riowd_timeout, WDTO_INDEX);
-		return 1;
-	}
-
+	wdd->timeout = DIV_ROUND_UP(timeout, 60) * 60;
 	return 0;
 }
 
-static const struct file_operations riowd_fops = {
-	.owner =		THIS_MODULE,
-	.llseek =		no_llseek,
-	.unlocked_ioctl =	riowd_ioctl,
-	.open =			riowd_open,
-	.write =		riowd_write,
-	.release =		riowd_release,
+static const struct watchdog_info riowd_wdt_info = {
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
+	.firmware_version = 1,
+	.identity = DRIVER_NAME,
 };
 
-static struct miscdevice riowd_miscdev = {
-	.minor	= WATCHDOG_MINOR,
-	.name	= "watchdog",
-	.fops	= &riowd_fops
+static const struct watchdog_ops riowd_wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = riowd_wdt_start,
+	.stop = riowd_wdt_stop,
+	.set_timeout = riowd_wdt_set_timeout,
+};
+
+static struct watchdog_device riowd_wdt_dev = {
+	.info = &riowd_wdt_info,
+	.ops = &riowd_wdt_ops,
+	.min_timeout = 60,
+	.max_timeout = 255 * 60,
 };
 
 static int __devinit riowd_probe(struct platform_device *op)
 {
-	struct riowd *p;
-	int err = -EINVAL;
-
-	if (riowd_device)
-		goto out;
+	struct riowd_wdt_drvdata *drvdata;
+	int err;
 
-	err = -ENOMEM;
-	p = kzalloc(sizeof(*p), GFP_KERNEL);
-	if (!p)
-		goto out;
+	drvdata = devm_kzalloc(&op->dev, sizeof(*drvdata), GFP_KERNEL);
+	if (!drvdata)
+		return -ENOMEM;
 
-	spin_lock_init(&p->lock);
+	spin_lock_init(&drvdata->lock);
 
-	p->regs = of_ioremap(&op->resource[0], 0, 2, DRIVER_NAME);
-	if (!p->regs) {
+	drvdata->regs = of_ioremap(&op->resource[0], 0, 2, DRIVER_NAME);
+	if (!drvdata->regs) {
 		pr_err("Cannot map registers\n");
-		goto out_free;
+		return -ENOMEM;
 	}
-	/* Make miscdev useable right away */
-	riowd_device = p;
 
-	err = misc_register(&riowd_miscdev);
+	riowd_wdt_dev.timeout = riowd_timeout * 60;
+	watchdog_set_drvdata(&riowd_wdt_dev, drvdata);
+
+	err = watchdog_register_device(&riowd_wdt_dev);
 	if (err) {
-		pr_err("Cannot register watchdog misc device\n");
-		goto out_iounmap;
+		of_iounmap(&op->resource[0], drvdata->regs, 2);
+		return err;
 	}
 
 	pr_info("Hardware watchdog [%i minutes], regs at %p\n",
-		riowd_timeout, p->regs);
+		riowd_timeout, drvdata->regs);
 
-	dev_set_drvdata(&op->dev, p);
-	return 0;
+	dev_set_drvdata(&op->dev, drvdata);
 
-out_iounmap:
-	riowd_device = NULL;
-	of_iounmap(&op->resource[0], p->regs, 2);
-
-out_free:
-	kfree(p);
-
-out:
-	return err;
+	return 0;
 }
 
 static int __devexit riowd_remove(struct platform_device *op)
 {
-	struct riowd *p = dev_get_drvdata(&op->dev);
+	struct riowd_wdt_drvdata *drvdata = dev_get_drvdata(&op->dev);
 
-	misc_deregister(&riowd_miscdev);
-	of_iounmap(&op->resource[0], p->regs, 2);
-	kfree(p);
+	watchdog_unregister_device(&riowd_wdt_dev);
+	of_iounmap(&op->resource[0], drvdata->regs, 2);
 
 	return 0;
 }
-- 
1.7.5.4




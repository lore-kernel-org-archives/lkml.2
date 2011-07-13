Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683Ab1GMUZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 16:25:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55529 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab1GMUZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 16:25:03 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-watchdog@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        wim@iguana.be, tim.bird@am.sony.com,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [RFC 2/6] watchdog: s3c2410: convert to use the watchdog framework
Date: Wed, 13 Jul 2011 22:26:02 +0200
Message-Id: <1310588766-16638-3-git-send-email-w.sang@pengutronix.de>
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
centrally handled parts. Tested on a mini2440.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/watchdog/Kconfig       |    1 +
 drivers/watchdog/s3c2410_wdt.c |  176 +++++++++-------------------------------
 2 files changed, 38 insertions(+), 139 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index edb0f1b..4f1379c 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -173,6 +173,7 @@ config HAVE_S3C2410_WATCHDOG
 config S3C2410_WATCHDOG
 	tristate "S3C2410 Watchdog"
 	depends on ARCH_S3C2410 || HAVE_S3C2410_WATCHDOG
+	select WATCHDOG_CORE
 	help
 	  Watchdog timer block in the Samsung SoCs. This will reboot
 	  the system when the timer expires with the watchdog enabled.
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 30da88f..5de7e4f 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -27,9 +27,8 @@
 #include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/timer.h>
-#include <linux/miscdevice.h>
+#include <linux/miscdevice.h> /* for MODULE_ALIAS_MISCDEV */
 #include <linux/watchdog.h>
-#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
@@ -38,6 +37,7 @@
 #include <linux/io.h>
 #include <linux/cpufreq.h>
 #include <linux/slab.h>
+#include <linux/err.h>
 
 #include <mach/map.h>
 
@@ -74,14 +74,12 @@ MODULE_PARM_DESC(soft_noboot, "Watchdog action, set to 1 to ignore reboots, "
 			"0 to reboot (default 0)");
 MODULE_PARM_DESC(debug, "Watchdog debug, set to >1 for debug (default 0)");
 
-static unsigned long open_lock;
 static struct device    *wdt_dev;	/* platform device attached to */
 static struct resource	*wdt_mem;
 static struct resource	*wdt_irq;
 static struct clk	*wdt_clock;
 static void __iomem	*wdt_base;
 static unsigned int	 wdt_count;
-static char		 expect_close;
 static DEFINE_SPINLOCK(wdt_lock);
 
 /* watchdog control routines */
@@ -93,11 +91,13 @@ static DEFINE_SPINLOCK(wdt_lock);
 
 /* functions */
 
-static void s3c2410wdt_keepalive(void)
+static int s3c2410wdt_keepalive(struct watchdog_device *wdd)
 {
 	spin_lock(&wdt_lock);
 	writel(wdt_count, wdt_base + S3C2410_WTCNT);
 	spin_unlock(&wdt_lock);
+
+	return 0;
 }
 
 static void __s3c2410wdt_stop(void)
@@ -109,14 +109,16 @@ static void __s3c2410wdt_stop(void)
 	writel(wtcon, wdt_base + S3C2410_WTCON);
 }
 
-static void s3c2410wdt_stop(void)
+static int s3c2410wdt_stop(struct watchdog_device *wdd)
 {
 	spin_lock(&wdt_lock);
 	__s3c2410wdt_stop();
 	spin_unlock(&wdt_lock);
+
+	return 0;
 }
 
-static void s3c2410wdt_start(void)
+static int s3c2410wdt_start(struct watchdog_device *wdd)
 {
 	unsigned long wtcon;
 
@@ -142,6 +144,8 @@ static void s3c2410wdt_start(void)
 	writel(wdt_count, wdt_base + S3C2410_WTCNT);
 	writel(wtcon, wdt_base + S3C2410_WTCON);
 	spin_unlock(&wdt_lock);
+
+	return 0;
 }
 
 static inline int s3c2410wdt_is_running(void)
@@ -149,7 +153,7 @@ static inline int s3c2410wdt_is_running(void)
 	return readl(wdt_base + S3C2410_WTCON) & S3C2410_WTCON_ENABLE;
 }
 
-static int s3c2410wdt_set_heartbeat(int timeout)
+static int s3c2410wdt_set_heartbeat(struct watchdog_device *wdd, unsigned timeout)
 {
 	unsigned long freq = clk_get_rate(wdt_clock);
 	unsigned int count;
@@ -182,8 +186,6 @@ static int s3c2410wdt_set_heartbeat(int timeout)
 		}
 	}
 
-	tmr_margin = timeout;
-
 	DBG("%s: timeout=%d, divisor=%d, count=%d (%08x)\n",
 	    __func__, timeout, divisor, count, count/divisor);
 
@@ -201,70 +203,6 @@ static int s3c2410wdt_set_heartbeat(int timeout)
 	return 0;
 }
 
-/*
- *	/dev/watchdog handling
- */
-
-static int s3c2410wdt_open(struct inode *inode, struct file *file)
-{
-	if (test_and_set_bit(0, &open_lock))
-		return -EBUSY;
-
-	if (nowayout)
-		__module_get(THIS_MODULE);
-
-	expect_close = 0;
-
-	/* start the timer */
-	s3c2410wdt_start();
-	return nonseekable_open(inode, file);
-}
-
-static int s3c2410wdt_release(struct inode *inode, struct file *file)
-{
-	/*
-	 *	Shut off the timer.
-	 *	Lock it in if it's a module and we set nowayout
-	 */
-
-	if (expect_close == 42)
-		s3c2410wdt_stop();
-	else {
-		dev_err(wdt_dev, "Unexpected close, not stopping watchdog\n");
-		s3c2410wdt_keepalive();
-	}
-	expect_close = 0;
-	clear_bit(0, &open_lock);
-	return 0;
-}
-
-static ssize_t s3c2410wdt_write(struct file *file, const char __user *data,
-				size_t len, loff_t *ppos)
-{
-	/*
-	 *	Refresh the timer.
-	 */
-	if (len) {
-		if (!nowayout) {
-			size_t i;
-
-			/* In case it was set long ago */
-			expect_close = 0;
-
-			for (i = 0; i != len; i++) {
-				char c;
-
-				if (get_user(c, data + i))
-					return -EFAULT;
-				if (c == 'V')
-					expect_close = 42;
-			}
-		}
-		s3c2410wdt_keepalive();
-	}
-	return len;
-}
-
 #define OPTIONS (WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE)
 
 static const struct watchdog_info s3c2410_wdt_ident = {
@@ -273,53 +211,17 @@ static const struct watchdog_info s3c2410_wdt_ident = {
 	.identity         =	"S3C2410 Watchdog",
 };
 
-
-static long s3c2410wdt_ioctl(struct file *file,	unsigned int cmd,
-							unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	int new_margin;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user(argp, &s3c2410_wdt_ident,
-			sizeof(s3c2410_wdt_ident)) ? -EFAULT : 0;
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
-	case WDIOC_KEEPALIVE:
-		s3c2410wdt_keepalive();
-		return 0;
-	case WDIOC_SETTIMEOUT:
-		if (get_user(new_margin, p))
-			return -EFAULT;
-		if (s3c2410wdt_set_heartbeat(new_margin))
-			return -EINVAL;
-		s3c2410wdt_keepalive();
-		return put_user(tmr_margin, p);
-	case WDIOC_GETTIMEOUT:
-		return put_user(tmr_margin, p);
-	default:
-		return -ENOTTY;
-	}
-}
-
-/* kernel interface */
-
-static const struct file_operations s3c2410wdt_fops = {
-	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
-	.write		= s3c2410wdt_write,
-	.unlocked_ioctl	= s3c2410wdt_ioctl,
-	.open		= s3c2410wdt_open,
-	.release	= s3c2410wdt_release,
+static struct watchdog_ops s3c2410wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = s3c2410wdt_start,
+	.stop = s3c2410wdt_stop,
+	.ping = s3c2410wdt_keepalive,
+	.set_timeout = s3c2410wdt_set_heartbeat,
 };
 
-static struct miscdevice s3c2410wdt_miscdev = {
-	.minor		= WATCHDOG_MINOR,
-	.name		= "watchdog",
-	.fops		= &s3c2410wdt_fops,
+static struct watchdog_device s3c2410_wdd = {
+	.info = &s3c2410_wdt_ident,
+	.ops = &s3c2410wdt_ops,
 };
 
 /* interrupt handler code */
@@ -328,7 +230,7 @@ static irqreturn_t s3c2410wdt_irq(int irqno, void *param)
 {
 	dev_info(wdt_dev, "watchdog timer expired (irq)\n");
 
-	s3c2410wdt_keepalive();
+	s3c2410wdt_keepalive(&s3c2410_wdd);
 	return IRQ_HANDLED;
 }
 
@@ -349,14 +251,14 @@ static int s3c2410wdt_cpufreq_transition(struct notifier_block *nb,
 		 * the watchdog is running.
 		 */
 
-		s3c2410wdt_keepalive();
+		s3c2410wdt_keepalive(&s3c2410_wdd);
 	} else if (val == CPUFREQ_POSTCHANGE) {
-		s3c2410wdt_stop();
+		s3c2410wdt_stop(&s3c2410_wdd);
 
-		ret = s3c2410wdt_set_heartbeat(tmr_margin);
+		ret = s3c2410wdt_set_heartbeat(&s3c2410_wdd, s3c2410_wdd.timeout);
 
 		if (ret >= 0)
-			s3c2410wdt_start();
+			s3c2410wdt_start(&s3c2410_wdd);
 		else
 			goto err;
 	}
@@ -365,7 +267,8 @@ done:
 	return 0;
 
  err:
-	dev_err(wdt_dev, "cannot set new value for timeout %d\n", tmr_margin);
+	dev_err(wdt_dev, "cannot set new value for timeout %d\n",
+				s3c2410_wdd.timeout);
 	return ret;
 }
 
@@ -396,10 +299,6 @@ static inline void s3c2410wdt_cpufreq_deregister(void)
 }
 #endif
 
-
-
-/* device interface */
-
 static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 {
 	struct device *dev;
@@ -466,8 +365,8 @@ static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 	/* see if we can actually set the requested timer margin, and if
 	 * not, try the default value */
 
-	if (s3c2410wdt_set_heartbeat(tmr_margin)) {
-		started = s3c2410wdt_set_heartbeat(
+	if (s3c2410wdt_set_heartbeat(&s3c2410_wdd, tmr_margin)) {
+		started = s3c2410wdt_set_heartbeat(&s3c2410_wdd,
 					CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME);
 
 		if (started == 0)
@@ -479,22 +378,21 @@ static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 							"cannot start\n");
 	}
 
-	ret = misc_register(&s3c2410wdt_miscdev);
+	ret = watchdog_register_device(&s3c2410_wdd);
 	if (ret) {
-		dev_err(dev, "cannot register miscdev on minor=%d (%d)\n",
-			WATCHDOG_MINOR, ret);
+		dev_err(dev, "cannot register watchdog (%d)\n", ret);
 		goto err_cpufreq;
 	}
 
 	if (tmr_atboot && started == 0) {
 		dev_info(dev, "starting watchdog timer\n");
-		s3c2410wdt_start();
+		s3c2410wdt_start(&s3c2410_wdd);
 	} else if (!tmr_atboot) {
 		/* if we're not enabling the watchdog, then ensure it is
 		 * disabled if it has been left running from the bootloader
 		 * or other source */
 
-		s3c2410wdt_stop();
+		s3c2410wdt_stop(&s3c2410_wdd);
 	}
 
 	/* print out a statement of readiness */
@@ -530,7 +428,7 @@ static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 
 static int __devexit s3c2410wdt_remove(struct platform_device *dev)
 {
-	misc_deregister(&s3c2410wdt_miscdev);
+	watchdog_unregister_device(&s3c2410_wdd);
 
 	s3c2410wdt_cpufreq_deregister();
 
@@ -550,7 +448,7 @@ static int __devexit s3c2410wdt_remove(struct platform_device *dev)
 
 static void s3c2410wdt_shutdown(struct platform_device *dev)
 {
-	s3c2410wdt_stop();
+	s3c2410wdt_stop(&s3c2410_wdd);
 }
 
 #ifdef CONFIG_PM
@@ -565,7 +463,7 @@ static int s3c2410wdt_suspend(struct platform_device *dev, pm_message_t state)
 	wtdat_save = readl(wdt_base + S3C2410_WTDAT);
 
 	/* Note that WTCNT doesn't need to be saved. */
-	s3c2410wdt_stop();
+	s3c2410wdt_stop(&s3c2410_wdd);
 
 	return 0;
 }
-- 
1.7.2.5


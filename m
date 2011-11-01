Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab1KATug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 15:50:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56374 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750939Ab1KATue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 15:50:34 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wim Van Sebroeck <wim@iguana.be>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] watchdog: Convert wm831x driver to watchdog core
Date: Tue,  1 Nov 2011 19:50:30 +0000
Message-Id: <1320177030-1049-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fairly large code churn but not much doing with that and the overall
result is a definite win.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/watchdog/Kconfig      |    1 +
 drivers/watchdog/wm831x_wdt.c |  318 ++++++++++++++---------------------------
 2 files changed, 106 insertions(+), 213 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 884f369..37dae3c 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -66,6 +66,7 @@ config SOFT_WATCHDOG
 config WM831X_WATCHDOG
 	tristate "WM831x watchdog"
 	depends on MFD_WM831X
+	select WATCHDOG_CORE
 	help
 	  Support for the watchdog in the WM831x AudioPlus PMICs.  When
 	  the watchdog triggers the system will be reset.
diff --git a/drivers/watchdog/wm831x_wdt.c b/drivers/watchdog/wm831x_wdt.c
index 871caea..7be3855 100644
--- a/drivers/watchdog/wm831x_wdt.c
+++ b/drivers/watchdog/wm831x_wdt.c
@@ -12,8 +12,7 @@
 #include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/fs.h>
-#include <linux/miscdevice.h>
+#include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/watchdog.h>
 #include <linux/uaccess.h>
@@ -29,19 +28,19 @@ MODULE_PARM_DESC(nowayout,
 		 "Watchdog cannot be stopped once started (default="
 		 __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
-static unsigned long wm831x_wdt_users;
-static struct miscdevice wm831x_wdt_miscdev;
-static int wm831x_wdt_expect_close;
-static DEFINE_MUTEX(wdt_mutex);
-static struct wm831x *wm831x;
-static unsigned int update_gpio;
-static unsigned int update_state;
+struct wm831x_wdt_drvdata {
+	struct watchdog_device wdt;
+	struct wm831x *wm831x;
+	struct mutex lock;
+	int update_gpio;
+	int update_state;
+};
 
 /* We can't use the sub-second values here but they're included
  * for completeness.  */
 static struct {
-	int time;  /* Seconds */
-	u16 val;   /* WDOG_TO value */
+	unsigned int time;  /* Seconds */
+	u16 val;            /* WDOG_TO value */
 } wm831x_wdt_cfgs[] = {
 	{  1, 2 },
 	{  2, 3 },
@@ -52,32 +51,13 @@ static struct {
 	{ 33, 7 },  /* Actually 32.768s so include both, others round down */
 };
 
-static int wm831x_wdt_set_timeout(struct wm831x *wm831x, u16 value)
-{
-	int ret;
-
-	mutex_lock(&wdt_mutex);
-
-	ret = wm831x_reg_unlock(wm831x);
-	if (ret == 0) {
-		ret = wm831x_set_bits(wm831x, WM831X_WATCHDOG,
-				      WM831X_WDOG_TO_MASK, value);
-		wm831x_reg_lock(wm831x);
-	} else {
-		dev_err(wm831x->dev, "Failed to unlock security key: %d\n",
-			ret);
-	}
-
-	mutex_unlock(&wdt_mutex);
-
-	return ret;
-}
-
-static int wm831x_wdt_start(struct wm831x *wm831x)
+static int wm831x_wdt_start(struct watchdog_device *wdt_dev)
 {
+	struct wm831x_wdt_drvdata *driver_data = watchdog_get_drvdata(wdt_dev);
+	struct wm831x *wm831x = driver_data->wm831x;
 	int ret;
 
-	mutex_lock(&wdt_mutex);
+	mutex_lock(&driver_data->lock);
 
 	ret = wm831x_reg_unlock(wm831x);
 	if (ret == 0) {
@@ -89,16 +69,18 @@ static int wm831x_wdt_start(struct wm831x *wm831x)
 			ret);
 	}
 
-	mutex_unlock(&wdt_mutex);
+	mutex_unlock(&driver_data->lock);
 
 	return ret;
 }
 
-static int wm831x_wdt_stop(struct wm831x *wm831x)
+static int wm831x_wdt_stop(struct watchdog_device *wdt_dev)
 {
+	struct wm831x_wdt_drvdata *driver_data = watchdog_get_drvdata(wdt_dev);
+	struct wm831x *wm831x = driver_data->wm831x;
 	int ret;
 
-	mutex_lock(&wdt_mutex);
+	mutex_lock(&driver_data->lock);
 
 	ret = wm831x_reg_unlock(wm831x);
 	if (ret == 0) {
@@ -110,26 +92,28 @@ static int wm831x_wdt_stop(struct wm831x *wm831x)
 			ret);
 	}
 
-	mutex_unlock(&wdt_mutex);
+	mutex_unlock(&driver_data->lock);
 
 	return ret;
 }
 
-static int wm831x_wdt_kick(struct wm831x *wm831x)
+static int wm831x_wdt_ping(struct watchdog_device *wdt_dev)
 {
+	struct wm831x_wdt_drvdata *driver_data = watchdog_get_drvdata(wdt_dev);
+	struct wm831x *wm831x = driver_data->wm831x;
 	int ret;
 	u16 reg;
 
-	mutex_lock(&wdt_mutex);
+	mutex_lock(&driver_data->lock);
 
-	if (update_gpio) {
-		gpio_set_value_cansleep(update_gpio, update_state);
-		update_state = !update_state;
+	if (driver_data->update_gpio) {
+		gpio_set_value_cansleep(driver_data->update_gpio,
+					driver_data->update_state);
+		driver_data->update_state = !driver_data->update_state;
 		ret = 0;
 		goto out;
 	}
 
-
 	reg = wm831x_reg_read(wm831x, WM831X_WATCHDOG);
 
 	if (!(reg & WM831X_WDOG_RST_SRC)) {
@@ -150,182 +134,59 @@ static int wm831x_wdt_kick(struct wm831x *wm831x)
 	}
 
 out:
-	mutex_unlock(&wdt_mutex);
+	mutex_unlock(&driver_data->lock);
 
 	return ret;
 }
 
-static int wm831x_wdt_open(struct inode *inode, struct file *file)
+static int wm831x_wdt_set_timeout(struct watchdog_device *wdt_dev,
+				  unsigned int timeout)
 {
-	int ret;
-
-	if (!wm831x)
-		return -ENODEV;
-
-	if (test_and_set_bit(0, &wm831x_wdt_users))
-		return -EBUSY;
+	struct wm831x_wdt_drvdata *driver_data = watchdog_get_drvdata(wdt_dev);
+	struct wm831x *wm831x = driver_data->wm831x;
+	int ret, i;
 
-	ret = wm831x_wdt_start(wm831x);
-	if (ret != 0)
-		return ret;
-
-	return nonseekable_open(inode, file);
-}
+	for (i = 0; i < ARRAY_SIZE(wm831x_wdt_cfgs); i++)
+		if (wm831x_wdt_cfgs[i].time == timeout)
+			break;
+	if (i == ARRAY_SIZE(wm831x_wdt_cfgs))
+		ret = -EINVAL;
 
-static int wm831x_wdt_release(struct inode *inode, struct file *file)
-{
-	if (wm831x_wdt_expect_close)
-		wm831x_wdt_stop(wm831x);
-	else {
-		dev_warn(wm831x->dev, "Watchdog device closed uncleanly\n");
-		wm831x_wdt_kick(wm831x);
+	ret = wm831x_reg_unlock(wm831x);
+	if (ret == 0) {
+		ret = wm831x_set_bits(wm831x, WM831X_WATCHDOG,
+				      WM831X_WDOG_TO_MASK,
+				      wm831x_wdt_cfgs[i].val);
+		wm831x_reg_lock(wm831x);
+	} else {
+		dev_err(wm831x->dev, "Failed to unlock security key: %d\n",
+			ret);
 	}
 
-	clear_bit(0, &wm831x_wdt_users);
-
-	return 0;
-}
-
-static ssize_t wm831x_wdt_write(struct file *file,
-				const char __user *data, size_t count,
-				loff_t *ppos)
-{
-	size_t i;
-
-	if (count) {
-		wm831x_wdt_kick(wm831x);
-
-		if (!nowayout) {
-			/* In case it was set long ago */
-			wm831x_wdt_expect_close = 0;
-
-			/* scan to see whether or not we got the magic
-			   character */
-			for (i = 0; i != count; i++) {
-				char c;
-				if (get_user(c, data + i))
-					return -EFAULT;
-				if (c == 'V')
-					wm831x_wdt_expect_close = 42;
-			}
-		}
-	}
-	return count;
+	return ret;
 }
 
-static const struct watchdog_info ident = {
+static const struct watchdog_info wm831x_wdt_info = {
 	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
 	.identity = "WM831x Watchdog",
 };
 
-static long wm831x_wdt_ioctl(struct file *file, unsigned int cmd,
-			     unsigned long arg)
-{
-	int ret = -ENOTTY, time, i;
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	u16 reg;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		ret = copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
-		break;
-
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		ret = put_user(0, p);
-		break;
-
-	case WDIOC_SETOPTIONS:
-	{
-		int options;
-
-		if (get_user(options, p))
-			return -EFAULT;
-
-		ret = -EINVAL;
-
-		/* Setting both simultaneously means at least one must fail */
-		if (options == WDIOS_DISABLECARD)
-			ret = wm831x_wdt_start(wm831x);
-
-		if (options == WDIOS_ENABLECARD)
-			ret = wm831x_wdt_stop(wm831x);
-		break;
-	}
-
-	case WDIOC_KEEPALIVE:
-		ret = wm831x_wdt_kick(wm831x);
-		break;
-
-	case WDIOC_SETTIMEOUT:
-		ret = get_user(time, p);
-		if (ret)
-			break;
-
-		if (time == 0) {
-			if (nowayout)
-				ret = -EINVAL;
-			else
-				wm831x_wdt_stop(wm831x);
-			break;
-		}
-
-		for (i = 0; i < ARRAY_SIZE(wm831x_wdt_cfgs); i++)
-			if (wm831x_wdt_cfgs[i].time == time)
-				break;
-		if (i == ARRAY_SIZE(wm831x_wdt_cfgs))
-			ret = -EINVAL;
-		else
-			ret = wm831x_wdt_set_timeout(wm831x,
-						     wm831x_wdt_cfgs[i].val);
-		break;
-
-	case WDIOC_GETTIMEOUT:
-		reg = wm831x_reg_read(wm831x, WM831X_WATCHDOG);
-		reg &= WM831X_WDOG_TO_MASK;
-		for (i = 0; i < ARRAY_SIZE(wm831x_wdt_cfgs); i++)
-			if (wm831x_wdt_cfgs[i].val == reg)
-				break;
-		if (i == ARRAY_SIZE(wm831x_wdt_cfgs)) {
-			dev_warn(wm831x->dev,
-				 "Unknown watchdog configuration: %x\n", reg);
-			ret = -EINVAL;
-		} else
-			ret = put_user(wm831x_wdt_cfgs[i].time, p);
-
-	}
-
-	return ret;
-}
-
-static const struct file_operations wm831x_wdt_fops = {
+static const struct watchdog_ops wm831x_wdt_ops = {
 	.owner = THIS_MODULE,
-	.llseek = no_llseek,
-	.write = wm831x_wdt_write,
-	.unlocked_ioctl = wm831x_wdt_ioctl,
-	.open = wm831x_wdt_open,
-	.release = wm831x_wdt_release,
-};
-
-static struct miscdevice wm831x_wdt_miscdev = {
-	.minor = WATCHDOG_MINOR,
-	.name = "watchdog",
-	.fops = &wm831x_wdt_fops,
+	.start = wm831x_wdt_start,
+	.stop = wm831x_wdt_stop,
+	.ping = wm831x_wdt_ping,
+	.set_timeout = wm831x_wdt_set_timeout,
 };
 
 static int __devinit wm831x_wdt_probe(struct platform_device *pdev)
 {
+	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_pdata *chip_pdata;
 	struct wm831x_watchdog_pdata *pdata;
-	int reg, ret;
-
-	if (wm831x) {
-		dev_err(&pdev->dev, "wm831x watchdog already registered\n");
-		return -EBUSY;
-	}
-
-	wm831x = dev_get_drvdata(pdev->dev.parent);
+	struct wm831x_wdt_drvdata *driver_data;
+	struct watchdog_device *wm831x_wdt;
+	int reg, ret, i;
 
 	ret = wm831x_reg_read(wm831x, WM831X_WATCHDOG);
 	if (ret < 0) {
@@ -338,6 +199,36 @@ static int __devinit wm831x_wdt_probe(struct platform_device *pdev)
 	if (reg & WM831X_WDOG_DEBUG)
 		dev_warn(wm831x->dev, "Watchdog is paused\n");
 
+	driver_data = kzalloc(sizeof(*driver_data), GFP_KERNEL);
+	if (!driver_data) {
+		dev_err(wm831x->dev, "Unable to alloacate watchdog device\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	mutex_init(&driver_data->lock);
+	driver_data->wm831x = wm831x;
+
+	wm831x_wdt = &driver_data->wdt;
+
+	wm831x_wdt->info = &wm831x_wdt_info;
+	wm831x_wdt->ops = &wm831x_wdt_ops;
+	watchdog_set_drvdata(wm831x_wdt, driver_data);
+
+	if (nowayout)
+		wm831x_wdt->status |= WDOG_NO_WAY_OUT;
+
+	reg = wm831x_reg_read(wm831x, WM831X_WATCHDOG);
+	reg &= WM831X_WDOG_TO_MASK;
+	for (i = 0; i < ARRAY_SIZE(wm831x_wdt_cfgs); i++)
+		if (wm831x_wdt_cfgs[i].val == reg)
+			break;
+	if (i == ARRAY_SIZE(wm831x_wdt_cfgs))
+		dev_warn(wm831x->dev,
+			 "Unknown watchdog timeout: %x\n", reg);
+	else
+		wm831x_wdt->timeout = wm831x_wdt_cfgs[i].time;
+
 	/* Apply any configuration */
 	if (pdev->dev.parent->platform_data) {
 		chip_pdata = pdev->dev.parent->platform_data;
@@ -361,7 +252,7 @@ static int __devinit wm831x_wdt_probe(struct platform_device *pdev)
 				dev_err(wm831x->dev,
 					"Failed to request update GPIO: %d\n",
 					ret);
-				goto err;
+				goto err_alloc;
 			}
 
 			ret = gpio_direction_output(pdata->update_gpio, 0);
@@ -372,7 +263,7 @@ static int __devinit wm831x_wdt_probe(struct platform_device *pdev)
 				goto err_gpio;
 			}
 
-			update_gpio = pdata->update_gpio;
+			driver_data->update_gpio = pdata->update_gpio;
 
 			/* Make sure the watchdog takes hardware updates */
 			reg |= WM831X_WDOG_RST_SRC;
@@ -389,33 +280,34 @@ static int __devinit wm831x_wdt_probe(struct platform_device *pdev)
 		}
 	}
 
-	wm831x_wdt_miscdev.parent = &pdev->dev;
-
-	ret = misc_register(&wm831x_wdt_miscdev);
+	ret = watchdog_register_device(&driver_data->wdt);
 	if (ret != 0) {
-		dev_err(wm831x->dev, "Failed to register miscdev: %d\n", ret);
+		dev_err(wm831x->dev, "watchdog_register_device() failed: %d\n",
+			ret);
 		goto err_gpio;
 	}
 
+	dev_set_drvdata(&pdev->dev, driver_data);
+
 	return 0;
 
 err_gpio:
-	if (update_gpio) {
-		gpio_free(update_gpio);
-		update_gpio = 0;
-	}
+	if (driver_data->update_gpio)
+		gpio_free(driver_data->update_gpio);
+err_alloc:
+	kfree(driver_data);
 err:
 	return ret;
 }
 
 static int __devexit wm831x_wdt_remove(struct platform_device *pdev)
 {
-	if (update_gpio) {
-		gpio_free(update_gpio);
-		update_gpio = 0;
-	}
+	struct wm831x_wdt_drvdata *driver_data = dev_get_drvdata(&pdev->dev);
+
+	watchdog_unregister_device(&driver_data->wdt);
 
-	misc_deregister(&wm831x_wdt_miscdev);
+	if (driver_data->update_gpio)
+		gpio_free(driver_data->update_gpio);
 
 	return 0;
 }
-- 
1.7.7.1


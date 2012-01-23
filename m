Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab2AWH1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 02:27:12 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39020 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab2AWH1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 02:27:10 -0500
Message-ID: <1327303619.31138.3.camel@phoenix>
Subject: [RFC][PATCH] watchdog: Convert wm8350_wdt driver to watchdog core
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-watchdog@vger.kernel.org
Date: Mon, 23 Jan 2012 15:26:59 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts wm8350_wdt driver to use watchdog core APIs.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Hi Mark,
I don't have this hardware.
I'd appreciate if you can review and test this patch.

Thanks,
Axel

 drivers/watchdog/Kconfig      |    1 +
 drivers/watchdog/wm8350_wdt.c |  213 +++++++----------------------------------
 2 files changed, 35 insertions(+), 179 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 877b107..9dfad61 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -74,6 +74,7 @@ config WM831X_WATCHDOG
 config WM8350_WATCHDOG
 	tristate "WM8350 watchdog"
 	depends on MFD_WM8350
+	select WATCHDOG_CORE
 	help
 	  Support for the watchdog in the WM8350 AudioPlus PMIC.  When
 	  the watchdog triggers the system will be reset.
diff --git a/drivers/watchdog/wm8350_wdt.c b/drivers/watchdog/wm8350_wdt.c
index 5d7113c..f38da4d 100644
--- a/drivers/watchdog/wm8350_wdt.c
+++ b/drivers/watchdog/wm8350_wdt.c
@@ -12,8 +12,6 @@
 #include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/fs.h>
-#include <linux/miscdevice.h>
 #include <linux/platform_device.h>
 #include <linux/watchdog.h>
 #include <linux/uaccess.h>
@@ -25,36 +23,36 @@ MODULE_PARM_DESC(nowayout,
 		 "Watchdog cannot be stopped once started (default="
 		 __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
-static unsigned long wm8350_wdt_users;
-static struct miscdevice wm8350_wdt_miscdev;
-static int wm8350_wdt_expect_close;
 static DEFINE_MUTEX(wdt_mutex);
 
 static struct {
-	int time;  /* Seconds */
-	u16 val;   /* To be set in WM8350_SYSTEM_CONTROL_2 */
+	unsigned int time;  /* Seconds */
+	u16 val;	    /* To be set in WM8350_SYSTEM_CONTROL_2 */
 } wm8350_wdt_cfgs[] = {
 	{ 1, 0x02 },
 	{ 2, 0x04 },
 	{ 4, 0x05 },
 };
 
-static struct wm8350 *get_wm8350(void)
+static int wm8350_wdt_set_timeout(struct watchdog_device *wdt_dev,
+				  unsigned int timeout)
 {
-	return dev_get_drvdata(wm8350_wdt_miscdev.parent);
-}
-
-static int wm8350_wdt_set_timeout(struct wm8350 *wm8350, u16 value)
-{
-	int ret;
+	struct wm8350 *wm8350 = watchdog_get_drvdata(wdt_dev);
+	int ret, i;
 	u16 reg;
 
+	for (i = 0; i < ARRAY_SIZE(wm8350_wdt_cfgs); i++)
+		if (wm8350_wdt_cfgs[i].time == timeout)
+			break;
+	if (i == ARRAY_SIZE(wm8350_wdt_cfgs))
+		return -EINVAL;
+
 	mutex_lock(&wdt_mutex);
 	wm8350_reg_unlock(wm8350);
 
 	reg = wm8350_reg_read(wm8350, WM8350_SYSTEM_CONTROL_2);
 	reg &= ~WM8350_WDOG_TO_MASK;
-	reg |= value;
+	reg |= wm8350_wdt_cfgs[i].val;
 	ret = wm8350_reg_write(wm8350, WM8350_SYSTEM_CONTROL_2, reg);
 
 	wm8350_reg_lock(wm8350);
@@ -63,8 +61,9 @@ static int wm8350_wdt_set_timeout(struct wm8350 *wm8350, u16 value)
 	return ret;
 }
 
-static int wm8350_wdt_start(struct wm8350 *wm8350)
+static int wm8350_wdt_start(struct watchdog_device *wdt_dev)
 {
+	struct wm8350 *wm8350 = watchdog_get_drvdata(wdt_dev);
 	int ret;
 	u16 reg;
 
@@ -82,8 +81,9 @@ static int wm8350_wdt_start(struct wm8350 *wm8350)
 	return ret;
 }
 
-static int wm8350_wdt_stop(struct wm8350 *wm8350)
+static int wm8350_wdt_stop(struct watchdog_device *wdt_dev)
 {
+	struct wm8350 *wm8350 = watchdog_get_drvdata(wdt_dev);
 	int ret;
 	u16 reg;
 
@@ -100,8 +100,9 @@ static int wm8350_wdt_stop(struct wm8350 *wm8350)
 	return ret;
 }
 
-static int wm8350_wdt_kick(struct wm8350 *wm8350)
+static int wm8350_wdt_ping(struct watchdog_device *wdt_dev)
 {
+	struct wm8350 *wm8350 = watchdog_get_drvdata(wdt_dev);
 	int ret;
 	u16 reg;
 
@@ -115,168 +116,22 @@ static int wm8350_wdt_kick(struct wm8350 *wm8350)
 	return ret;
 }
 
-static int wm8350_wdt_open(struct inode *inode, struct file *file)
-{
-	struct wm8350 *wm8350 = get_wm8350();
-	int ret;
-
-	if (!wm8350)
-		return -ENODEV;
-
-	if (test_and_set_bit(0, &wm8350_wdt_users))
-		return -EBUSY;
-
-	ret = wm8350_wdt_start(wm8350);
-	if (ret != 0)
-		return ret;
-
-	return nonseekable_open(inode, file);
-}
-
-static int wm8350_wdt_release(struct inode *inode, struct file *file)
-{
-	struct wm8350 *wm8350 = get_wm8350();
-
-	if (wm8350_wdt_expect_close)
-		wm8350_wdt_stop(wm8350);
-	else {
-		dev_warn(wm8350->dev, "Watchdog device closed uncleanly\n");
-		wm8350_wdt_kick(wm8350);
-	}
-
-	clear_bit(0, &wm8350_wdt_users);
-
-	return 0;
-}
-
-static ssize_t wm8350_wdt_write(struct file *file,
-				const char __user *data, size_t count,
-				loff_t *ppos)
-{
-	struct wm8350 *wm8350 = get_wm8350();
-	size_t i;
-
-	if (count) {
-		wm8350_wdt_kick(wm8350);
-
-		if (!nowayout) {
-			/* In case it was set long ago */
-			wm8350_wdt_expect_close = 0;
-
-			/* scan to see whether or not we got the magic
-			   character */
-			for (i = 0; i != count; i++) {
-				char c;
-				if (get_user(c, data + i))
-					return -EFAULT;
-				if (c == 'V')
-					wm8350_wdt_expect_close = 42;
-			}
-		}
-	}
-	return count;
-}
-
-static const struct watchdog_info ident = {
+static const struct watchdog_info wm8350_wdt_info = {
 	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
 	.identity = "WM8350 Watchdog",
 };
 
-static long wm8350_wdt_ioctl(struct file *file, unsigned int cmd,
-			     unsigned long arg)
-{
-	struct wm8350 *wm8350 = get_wm8350();
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
-			ret = wm8350_wdt_stop(wm8350);
-
-		if (options == WDIOS_ENABLECARD)
-			ret = wm8350_wdt_start(wm8350);
-		break;
-	}
-
-	case WDIOC_KEEPALIVE:
-		ret = wm8350_wdt_kick(wm8350);
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
-				wm8350_wdt_stop(wm8350);
-			break;
-		}
-
-		for (i = 0; i < ARRAY_SIZE(wm8350_wdt_cfgs); i++)
-			if (wm8350_wdt_cfgs[i].time == time)
-				break;
-		if (i == ARRAY_SIZE(wm8350_wdt_cfgs))
-			ret = -EINVAL;
-		else
-			ret = wm8350_wdt_set_timeout(wm8350,
-						     wm8350_wdt_cfgs[i].val);
-		break;
-
-	case WDIOC_GETTIMEOUT:
-		reg = wm8350_reg_read(wm8350, WM8350_SYSTEM_CONTROL_2);
-		reg &= WM8350_WDOG_TO_MASK;
-		for (i = 0; i < ARRAY_SIZE(wm8350_wdt_cfgs); i++)
-			if (wm8350_wdt_cfgs[i].val == reg)
-				break;
-		if (i == ARRAY_SIZE(wm8350_wdt_cfgs)) {
-			dev_warn(wm8350->dev,
-				 "Unknown watchdog configuration: %x\n", reg);
-			ret = -EINVAL;
-		} else
-			ret = put_user(wm8350_wdt_cfgs[i].time, p);
-
-	}
-
-	return ret;
-}
-
-static const struct file_operations wm8350_wdt_fops = {
+static const struct watchdog_ops wm8350_wdt_ops = {
 	.owner = THIS_MODULE,
-	.llseek = no_llseek,
-	.write = wm8350_wdt_write,
-	.unlocked_ioctl = wm8350_wdt_ioctl,
-	.open = wm8350_wdt_open,
-	.release = wm8350_wdt_release,
+	.start = wm8350_wdt_start,
+	.stop = wm8350_wdt_stop,
+	.ping = wm8350_wdt_ping,
+	.set_timeout = wm8350_wdt_set_timeout,
 };
 
-static struct miscdevice wm8350_wdt_miscdev = {
-	.minor = WATCHDOG_MINOR,
-	.name = "watchdog",
-	.fops = &wm8350_wdt_fops,
+static struct watchdog_device wm8350_wdt = {
+	.info = &wm8350_wdt_info,
+	.ops = &wm8350_wdt_ops,
 };
 
 static int __devinit wm8350_wdt_probe(struct platform_device *pdev)
@@ -288,18 +143,18 @@ static int __devinit wm8350_wdt_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	/* Default to 4s timeout */
-	wm8350_wdt_set_timeout(wm8350, 0x05);
+	watchdog_set_nowayout(&wm8350_wdt, nowayout);
+	watchdog_set_drvdata(&wm8350_wdt, wm8350);
 
-	wm8350_wdt_miscdev.parent = &pdev->dev;
+	/* Default to 4s timeout */
+	wm8350_wdt_set_timeout(&wm8350_wdt, 4);
 
-	return misc_register(&wm8350_wdt_miscdev);
+	return watchdog_register_device(&wm8350_wdt);
 }
 
 static int __devexit wm8350_wdt_remove(struct platform_device *pdev)
 {
-	misc_deregister(&wm8350_wdt_miscdev);
-
+	watchdog_unregister_device(&wm8350_wdt);
 	return 0;
 }
 
-- 
1.7.5.4




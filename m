Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab1HHQed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 12:34:33 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:28352 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab1HHQec convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 12:34:32 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-132.messagelabs.com!1312821261!34480778!27
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.97]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] watchdog: ep93xx: Use the WatchDog Timer Core
Date: Mon, 8 Aug 2011 09:33:52 -0700
User-Agent: KMail/1.9.9
CC: <linux-watchdog@vger.kernel.org>, <mika.westerberg@linux.intel.com>,
        <wim@iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <201108080933.52313.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the ep93xx watchdog driver to using the WatchDog Timer Driver Core.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Tested-by: : Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Wim Van Sebroeck <wim@iguana.be>

---

v3: add select WATCHDOG_CORE to Kconfig
    reorder the code so that the #defines follow the #includes
    fix the namespace for some of the #defines
    remove WDIOF_CARDRESET from the watchdog_info options
      (this is a status flag not an options flag)
    hookup the nowayout module parameter to the status bit
      WDOG_NO_WAY_OUT
    reorder the code so that the relationship between the internal
      timer ping and the watchdog ping is more obvious

v2: use the pr_* functions instead of printk(KERN_* PFX
    document the register magic numbers and bits
    fold the register access functions into the callers
    add WDIOF_KEEPALIVEPING to the options
    fix the bootstatus use, any detected reset is reported as WDIOF_CARDRESET
    add a boot message so the user can see what actually caused the reset
    validate that the user's requested timeout is actually valid
    fix a typo in the v1 patch (extra void in ep93xx_wdt_start)
    fix ep93xx_wdt_exit, ep93xx_wdt_stop should be called not wdt_shutdown

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 86b0735..55fa024 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -215,6 +215,7 @@ config MPCORE_WATCHDOG
 config EP93XX_WATCHDOG
 	tristate "EP93xx Watchdog"
 	depends on ARCH_EP93XX
+	select WATCHDOG_CORE
 	help
 	  Say Y here if to include support for the watchdog timer
 	  embedded in the Cirrus Logic EP93xx family of devices.
diff --git a/drivers/watchdog/ep93xx_wdt.c b/drivers/watchdog/ep93xx_wdt.c
index 726b7df..8de71da 100644
--- a/drivers/watchdog/ep93xx_wdt.c
+++ b/drivers/watchdog/ep93xx_wdt.c
@@ -23,233 +23,158 @@
  *	- Add a few missing ioctls
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
-#include <linux/fs.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/timer.h>
-#include <linux/uaccess.h>
 #include <linux/io.h>
 #include <mach/hardware.h>
 
-#define WDT_VERSION	"0.3"
-#define PFX		"ep93xx_wdt: "
-
-/* default timeout (secs) */
-#define WDT_TIMEOUT 30
-
-static int nowayout = WATCHDOG_NOWAYOUT;
-static int timeout = WDT_TIMEOUT;
-
-static struct timer_list timer;
-static unsigned long next_heartbeat;
-static unsigned long wdt_status;
-static unsigned long boot_status;
-
-#define WDT_IN_USE		0
-#define WDT_OK_TO_CLOSE		1
-
 #define EP93XX_WDT_REG(x)	(EP93XX_WATCHDOG_BASE + (x))
 #define EP93XX_WDT_WATCHDOG	EP93XX_WDT_REG(0x00)
 #define EP93XX_WDT_WDSTATUS	EP93XX_WDT_REG(0x04)
 
+/* Watchdog register write only values */
+#define EP93XX_WATCHDOG_RESTART		0x5555
+#define EP93XX_WATCHDOG_DISABLE		0xaa55
+#define EP93XX_WATCHDOG_ENABLE		0xaaaa
+
+/* Watchdog register read only bits */
+#define EP93XX_WATCHDOG_PLSDSN		(1 << 6)
+#define EP93XX_WATCHDOG_OVRID		(1 << 5)
+#define EP93XX_WATCHDOG_SWDIS		(1 << 4)
+#define EP93XX_WATCHDOG_HWDIS		(1 << 3)
+#define EP93XX_WATCHDOG_URST		(1 << 2)
+#define EP93XX_WATCHDOG_3KRST		(1 << 1)
+#define EP93XX_WATCHDOG_WD		(1 << 0)
+#define EP93XX_WATCHDOG_RESET_MASK	(0x07)
+
 /* reset the wdt every ~200ms */
-#define WDT_INTERVAL (HZ/5)
+#define EP93XX_WATCHDOG_INTERVAL	(HZ/5)
 
-static void wdt_enable(void)
-{
-	__raw_writew(0xaaaa, EP93XX_WDT_WATCHDOG);
-}
+/* default timeout (secs) */
+#define EP93XX_WATCHDOG_TIMEOUT		30
 
-static void wdt_disable(void)
-{
-	__raw_writew(0xaa55, EP93XX_WDT_WATCHDOG);
-}
+#define EP93XX_WATCHDOG_VERSION		"0.3"
 
-static inline void wdt_ping(void)
-{
-	__raw_writew(0x5555, EP93XX_WDT_WATCHDOG);
-}
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started");
 
-static void wdt_startup(void)
-{
-	next_heartbeat = jiffies + (timeout * HZ);
+static int timeout = EP93XX_WATCHDOG_TIMEOUT;
+module_param(timeout, int, 0);
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. (1<=timeout<=3600, default="
+			__MODULE_STRING(EP93XX_WATCHDOG_TIMEOUT) ")");
 
-	wdt_enable();
-	mod_timer(&timer, jiffies + WDT_INTERVAL);
-}
+static struct timer_list timer;
+static unsigned long next_heartbeat;
 
-static void wdt_shutdown(void)
+static void ep93xx_timer_ping(unsigned long data)
 {
-	del_timer_sync(&timer);
-	wdt_disable();
+	if (time_before(jiffies, next_heartbeat))
+		__raw_writew(EP93XX_WATCHDOG_RESTART, EP93XX_WDT_WATCHDOG);
+
+	/* Re-set the timer interval */
+	mod_timer(&timer, jiffies + EP93XX_WATCHDOG_INTERVAL);
 }
 
-static void wdt_keepalive(void)
+static int ep93xx_wdt_keepalive(struct watchdog_device *wdd)
 {
 	/* user land ping */
-	next_heartbeat = jiffies + (timeout * HZ);
+	next_heartbeat = jiffies + (wdd->timeout * HZ);
+	return 0;
 }
 
-static int ep93xx_wdt_open(struct inode *inode, struct file *file)
+static int ep93xx_wdt_start(struct watchdog_device *wdd)
 {
-	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
-		return -EBUSY;
-
-	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-
-	wdt_startup();
-
-	return nonseekable_open(inode, file);
+	ep93xx_wdt_keepalive(wdd);
+	__raw_writew(EP93XX_WATCHDOG_ENABLE, EP93XX_WDT_WATCHDOG);
+	mod_timer(&timer, jiffies + EP93XX_WATCHDOG_INTERVAL);
+	return 0;
 }
 
-static ssize_t
-ep93xx_wdt_write(struct file *file, const char __user *data, size_t len,
-		 loff_t *ppos)
+static int ep93xx_wdt_stop(struct watchdog_device *wdd)
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
-
-				if (c == 'V')
-					set_bit(WDT_OK_TO_CLOSE, &wdt_status);
-				else
-					clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-			}
-		}
-		wdt_keepalive();
-	}
-
-	return len;
+	del_timer_sync(&timer);
+	__raw_writew(EP93XX_WATCHDOG_DISABLE, EP93XX_WDT_WATCHDOG);
+	return 0;
 }
 
-static const struct watchdog_info ident = {
-	.options = WDIOF_CARDRESET | WDIOF_MAGICCLOSE,
-	.identity = "EP93xx Watchdog",
+static const struct watchdog_info ep93xx_wdt_ident = {
+	.options	= WDIOF_MAGICCLOSE |
+			  WDIOF_KEEPALIVEPING,
+	.identity	= "EP93xx Watchdog",
 };
 
-static long ep93xx_wdt_ioctl(struct file *file,
-					unsigned int cmd, unsigned long arg)
-{
-	int ret = -ENOTTY;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		ret = copy_to_user((struct watchdog_info __user *)arg, &ident,
-				sizeof(ident)) ? -EFAULT : 0;
-		break;
-
-	case WDIOC_GETSTATUS:
-		ret = put_user(0, (int __user *)arg);
-		break;
-
-	case WDIOC_GETBOOTSTATUS:
-		ret = put_user(boot_status, (int __user *)arg);
-		break;
-
-	case WDIOC_KEEPALIVE:
-		wdt_keepalive();
-		ret = 0;
-		break;
-
-	case WDIOC_GETTIMEOUT:
-		/* actually, it is 0.250 seconds.... */
-		ret = put_user(1, (int __user *)arg);
-		break;
-	}
-	return ret;
-}
-
-static int ep93xx_wdt_release(struct inode *inode, struct file *file)
-{
-	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
-		wdt_shutdown();
-	else
-		printk(KERN_CRIT PFX
-			"Device closed unexpectedly - timer will not stop\n");
-
-	clear_bit(WDT_IN_USE, &wdt_status);
-	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-
-	return 0;
-}
-
-static const struct file_operations ep93xx_wdt_fops = {
+static const struct watchdog_ops ep93xx_wdt_ops = {
 	.owner		= THIS_MODULE,
-	.write		= ep93xx_wdt_write,
-	.unlocked_ioctl	= ep93xx_wdt_ioctl,
-	.open		= ep93xx_wdt_open,
-	.release	= ep93xx_wdt_release,
-	.llseek		= no_llseek,
+	.start		= ep93xx_wdt_start,
+	.stop		= ep93xx_wdt_stop,
+	.ping		= ep93xx_wdt_keepalive,
 };
 
-static struct miscdevice ep93xx_wdt_miscdev = {
-	.minor		= WATCHDOG_MINOR,
-	.name		= "watchdog",
-	.fops		= &ep93xx_wdt_fops,
+static struct watchdog_device ep93xx_wdd = {
+	.info		= &ep93xx_wdt_ident,
+	.ops		= &ep93xx_wdt_ops,
+	.min_timeout	= 1,
+	.max_timeout	= 3600,
 };
 
-static void ep93xx_timer_ping(unsigned long data)
-{
-	if (time_before(jiffies, next_heartbeat))
-		wdt_ping();
-
-	/* Re-set the timer interval */
-	mod_timer(&timer, jiffies + WDT_INTERVAL);
-}
-
 static int __init ep93xx_wdt_init(void)
 {
+	int v;
 	int err;
 
-	err = misc_register(&ep93xx_wdt_miscdev);
+	v = readl(EP93XX_WDT_WATCHDOG);
+	ep93xx_wdd.bootstatus = (v & EP93XX_WATCHDOG_RESET_MASK)
+				? WDIOF_CARDRESET : 0;
+	if (ep93xx_wdd.bootstatus) {
+		/* Only a power-on-reset will clear these bits */
+		pr_info("Last reset was due to %s%s%s\n",
+			(v & EP93XX_WATCHDOG_WD) ? "- watchdog timeout " : "",
+			(v & EP93XX_WATCHDOG_3KRST) ? "- 3-key reset " : "",
+			(v & EP93XX_WATCHDOG_URST) ? "- user reset" : "");
+	}
 
-	boot_status = __raw_readl(EP93XX_WDT_WATCHDOG) & 0x01 ? 1 : 0;
+	if (timeout < ep93xx_wdd.min_timeout ||
+	    timeout > ep93xx_wdd.max_timeout) {
+		ep93xx_wdd.timeout = EP93XX_WATCHDOG_TIMEOUT;
+		pr_info("timeout value must be %d<=x<=%d, using %d\n",
+			ep93xx_wdd.min_timeout, ep93xx_wdd.max_timeout,
+			ep93xx_wdd.timeout);
+	} else {
+		ep93xx_wdd.timeout = timeout;
+	}
 
-	printk(KERN_INFO PFX "EP93XX watchdog, driver version "
-		WDT_VERSION "%s\n",
-		(__raw_readl(EP93XX_WDT_WATCHDOG) & 0x08)
-		? " (nCS1 disable detected)" : "");
+	if (nowayout)
+		set_bit(WDOG_NO_WAY_OUT, &ep93xx_wdd.status);
 
-	if (timeout < 1 || timeout > 3600) {
-		timeout = WDT_TIMEOUT;
-		printk(KERN_INFO PFX
-			"timeout value must be 1<=x<=3600, using %d\n",
-			timeout);
-	}
+	err = watchdog_register_device(&ep93xx_wdd);
+	if (err)
+		return err;
 
 	setup_timer(&timer, ep93xx_timer_ping, 1);
-	return err;
+
+	pr_info("EP93XX watchdog, driver v" EP93XX_WATCHDOG_VERSION "%s\n",
+		(v & EP93XX_WATCHDOG_HWDIS) ? " (nCS1 disable detected)" : "");
+
+	return 0;
 }
+module_init(ep93xx_wdt_init);
 
 static void __exit ep93xx_wdt_exit(void)
 {
-	wdt_shutdown();
-	misc_deregister(&ep93xx_wdt_miscdev);
+	ep93xx_wdt_stop(&ep93xx_wdd);
+	watchdog_unregister_device(&ep93xx_wdd);
 }
-
-module_init(ep93xx_wdt_init);
 module_exit(ep93xx_wdt_exit);
 
-module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started");
-
-module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout,
-	"Watchdog timeout in seconds. (1<=timeout<=3600, default="
-				__MODULE_STRING(WDT_TIMEOUT) ")");
-
 MODULE_AUTHOR("Ray Lehtiniemi <rayl@mail.com>,"
 		"Alessandro Zummo <a.zummo@towertech.it>");
 MODULE_DESCRIPTION("EP93xx Watchdog");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(WDT_VERSION);
+MODULE_VERSION(EP93XX_WATCHDOG_VERSION);
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);

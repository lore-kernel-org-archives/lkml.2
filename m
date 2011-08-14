Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab1HNUZd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 16:25:33 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:62377 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab1HNUZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 16:25:31 -0400
From: Vincent Li <vincent.mc.li@gmail.com>
To: linux-watchdog@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Vincent Li <vincent.mc.li@gmail.com>
Subject: [PATCH] Convert software watchdog softdog to use basic watchdog core framework
Date: Sun, 14 Aug 2011 13:25:03 -0700
Message-Id: <1313353503-26094-1-git-send-email-vincent.mc.li@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert software watchdog softdog to use basic watchdog core framework
to reduce dulicate code according to commit 43316044d watchdog:
WatchDog Timer Driver Core - Add basic framework

Compiled and tested against v3.1.0-rc1.


Signed-off-by: Vincent Li <vincent.mc.li@gmail.com>
---
 drivers/watchdog/Kconfig   |    1 +
 drivers/watchdog/softdog.c |  154 ++++++++++---------------------------------
 2 files changed, 37 insertions(+), 118 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 86b0735..b563c1d 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -55,6 +55,7 @@ comment "Watchdog Device Drivers"
 
 config SOFT_WATCHDOG
 	tristate "Software watchdog"
+	select WATCHDOG_CORE
 	help
 	  A software monitoring watchdog. This will fail to reboot your system
 	  from some situations that the hardware watchdog will recover
diff --git a/drivers/watchdog/softdog.c b/drivers/watchdog/softdog.c
index bf16ffb..0fb793a 100644
--- a/drivers/watchdog/softdog.c
+++ b/drivers/watchdog/softdog.c
@@ -42,12 +42,10 @@
 #include <linux/timer.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
-#include <linux/fs.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/jiffies.h>
-#include <linux/uaccess.h>
 #include <linux/kernel.h>
 
 #define PFX "SoftDog: "
@@ -90,7 +88,6 @@ static void watchdog_fire(unsigned long);
 static struct timer_list watchdog_ticktock =
 		TIMER_INITIALIZER(watchdog_fire, 0, 0);
 static unsigned long driver_open, orphan_timer;
-static char expect_close;
 
 
 /*
@@ -118,32 +115,28 @@ static void watchdog_fire(unsigned long data)
  *	Softdog operations
  */
 
-static int softdog_keepalive(void)
+static int softdog_keepalive(struct watchdog_device *wdd)
 {
 	mod_timer(&watchdog_ticktock, jiffies+(soft_margin*HZ));
 	return 0;
 }
 
-static int softdog_stop(void)
+static int softdog_stop(struct watchdog_device *wdd)
 {
 	del_timer(&watchdog_ticktock);
 	return 0;
 }
 
-static int softdog_set_heartbeat(int t)
+static int softdog_set_heartbeat(struct watchdog_device *wdd, unsigned int t)
 {
 	if ((t < 0x0001) || (t > 0xFFFF))
 		return -EINVAL;
 
-	soft_margin = t;
+	wdd->timeout = t;
 	return 0;
 }
 
-/*
- *	/dev/watchdog handling
- */
-
-static int softdog_open(struct inode *inode, struct file *file)
+static int softdog_start(struct watchdog_device *wdd)
 {
 	if (test_and_set_bit(0, &driver_open))
 		return -EBUSY;
@@ -152,92 +145,35 @@ static int softdog_open(struct inode *inode, struct file *file)
 	/*
 	 *	Activate timer
 	 */
-	softdog_keepalive();
-	return nonseekable_open(inode, file);
-}
-
-static int softdog_release(struct inode *inode, struct file *file)
-{
-	/*
-	 *	Shut off the timer.
-	 *	Lock it in if it's a module and we set nowayout
-	 */
-	if (expect_close == 42) {
-		softdog_stop();
-		module_put(THIS_MODULE);
-	} else {
-		printk(KERN_CRIT PFX
-			"Unexpected close, not stopping watchdog!\n");
-		set_bit(0, &orphan_timer);
-		softdog_keepalive();
-	}
-	clear_bit(0, &driver_open);
-	expect_close = 0;
+	softdog_keepalive(wdd);
 	return 0;
 }
 
-static ssize_t softdog_write(struct file *file, const char __user *data,
-						size_t len, loff_t *ppos)
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
-		softdog_keepalive();
-	}
-	return len;
-}
+/*
+ *     Kernel Interfaces
+ */
 
-static long softdog_ioctl(struct file *file, unsigned int cmd,
-							unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	int new_margin;
-	static const struct watchdog_info ident = {
-		.options =		WDIOF_SETTIMEOUT |
-					WDIOF_KEEPALIVEPING |
-					WDIOF_MAGICCLOSE,
-		.firmware_version =	0,
-		.identity =		"Software Watchdog",
-	};
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
-	case WDIOC_KEEPALIVE:
-		softdog_keepalive();
-		return 0;
-	case WDIOC_SETTIMEOUT:
-		if (get_user(new_margin, p))
-			return -EFAULT;
-		if (softdog_set_heartbeat(new_margin))
-			return -EINVAL;
-		softdog_keepalive();
-		/* Fall */
-	case WDIOC_GETTIMEOUT:
-		return put_user(soft_margin, p);
-	default:
-		return -ENOTTY;
-	}
-}
+static const struct watchdog_ops softdog_ops = {
+	.owner          = THIS_MODULE,
+	.start          = softdog_start,
+	.stop           = softdog_stop,
+	.ping           = softdog_keepalive,
+	.set_timeout    = softdog_set_heartbeat,
+};
+
+static const struct watchdog_info softdog_ident = {
+	.options	= WDIOF_MAGICCLOSE |
+			  WDIOF_KEEPALIVEPING |
+			  WDIOF_SETTIMEOUT,
+	.identity       = "Softdog Watchdog",
+};
+
+static struct watchdog_device softdog_wdd = {
+	.info           = &softdog_ident,
+	.ops            = &softdog_ops,
+	.min_timeout    = 0x0001,
+	.max_timeout    = 0xFFFF,
+};
 
 /*
  *	Notifier for system down
@@ -248,29 +184,10 @@ static int softdog_notify_sys(struct notifier_block *this, unsigned long code,
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
 		/* Turn the WDT off */
-		softdog_stop();
+		softdog_stop(&softdog_wdd);
 	return NOTIFY_DONE;
 }
 
-/*
- *	Kernel Interfaces
- */
-
-static const struct file_operations softdog_fops = {
-	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
-	.write		= softdog_write,
-	.unlocked_ioctl	= softdog_ioctl,
-	.open		= softdog_open,
-	.release	= softdog_release,
-};
-
-static struct miscdevice softdog_miscdev = {
-	.minor		= WATCHDOG_MINOR,
-	.name		= "watchdog",
-	.fops		= &softdog_fops,
-};
-
 static struct notifier_block softdog_notifier = {
 	.notifier_call	= softdog_notify_sys,
 };
@@ -285,8 +202,8 @@ static int __init watchdog_init(void)
 
 	/* Check that the soft_margin value is within it's range;
 	   if not reset to the default */
-	if (softdog_set_heartbeat(soft_margin)) {
-		softdog_set_heartbeat(TIMER_MARGIN);
+	if (softdog_set_heartbeat(&softdog_wdd, soft_margin)) {
+		softdog_set_heartbeat(&softdog_wdd, TIMER_MARGIN);
 		printk(KERN_INFO PFX
 		    "soft_margin must be 0 < soft_margin < 65536, using %d\n",
 			TIMER_MARGIN);
@@ -299,7 +216,7 @@ static int __init watchdog_init(void)
 		return ret;
 	}
 
-	ret = misc_register(&softdog_miscdev);
+	ret = watchdog_register_device(&softdog_wdd);
 	if (ret) {
 		printk(KERN_ERR PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
@@ -315,7 +232,8 @@ static int __init watchdog_init(void)
 
 static void __exit watchdog_exit(void)
 {
-	misc_deregister(&softdog_miscdev);
+	softdog_stop(&softdog_wdd);
+	watchdog_unregister_device(&softdog_wdd);
 	unregister_reboot_notifier(&softdog_notifier);
 }
 
-- 
1.7.0.4


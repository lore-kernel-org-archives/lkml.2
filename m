Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab2KNHTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:19:35 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:25317 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab2KNHTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:19:32 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, wenyou.yang@atmel.com, JM.Lin@atmel.com
Subject: [PATCH 01/11] watchdog/at91sam9_wdt: remove the file_operations struct
Date: Wed, 14 Nov 2012 15:15:59 +0800
Message-Id: <1352877369-19740-2-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352877369-19740-1-git-send-email-wenyou.yang@atmel.com>
References: <1352877369-19740-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 14 Nov 2012 07:19:17.0603 (UTC) FILETIME=[5BB30B30:01CDC238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the file_operations struct and miscdevice struct for future
add to use the watchdog framework.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 drivers/watchdog/at91sam9_wdt.c |  131 ---------------------------------------
 1 file changed, 131 deletions(-)

diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index 05e1be8..549c256 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -18,11 +18,9 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/errno.h>
-#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
-#include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/platform_device.h>
@@ -31,7 +29,6 @@
 #include <linux/jiffies.h>
 #include <linux/timer.h>
 #include <linux/bitops.h>
-#include <linux/uaccess.h>
 
 #include "at91sam9_wdt.h"
 
@@ -102,35 +99,6 @@ static void at91_ping(unsigned long data)
 }
 
 /*
- * Watchdog device is opened, and watchdog starts running.
- */
-static int at91_wdt_open(struct inode *inode, struct file *file)
-{
-	if (test_and_set_bit(0, &at91wdt_private.open))
-		return -EBUSY;
-
-	at91wdt_private.next_heartbeat = jiffies + heartbeat * HZ;
-	mod_timer(&at91wdt_private.timer, jiffies + WDT_TIMEOUT);
-
-	return nonseekable_open(inode, file);
-}
-
-/*
- * Close the watchdog device.
- */
-static int at91_wdt_close(struct inode *inode, struct file *file)
-{
-	clear_bit(0, &at91wdt_private.open);
-
-	/* stop internal ping */
-	if (!at91wdt_private.expect_close)
-		del_timer(&at91wdt_private.timer);
-
-	at91wdt_private.expect_close = 0;
-	return 0;
-}
-
-/*
  * Set the watchdog time interval in 1/256Hz (write-once)
  * Counter is 12 bit.
  */
@@ -168,101 +136,11 @@ static const struct watchdog_info at91_wdt_info = {
 						WDIOF_MAGICCLOSE,
 };
 
-/*
- * Handle commands from user-space.
- */
-static long at91_wdt_ioctl(struct file *file,
-		unsigned int cmd, unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	int new_value;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user(argp, &at91_wdt_info,
-				    sizeof(at91_wdt_info)) ? -EFAULT : 0;
-
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
-
-	case WDIOC_KEEPALIVE:
-		at91wdt_private.next_heartbeat = jiffies + heartbeat * HZ;
-		return 0;
-
-	case WDIOC_SETTIMEOUT:
-		if (get_user(new_value, p))
-			return -EFAULT;
-
-		heartbeat = new_value;
-		at91wdt_private.next_heartbeat = jiffies + heartbeat * HZ;
-
-		return put_user(new_value, p);  /* return current value */
-
-	case WDIOC_GETTIMEOUT:
-		return put_user(heartbeat, p);
-	}
-	return -ENOTTY;
-}
-
-/*
- * Pat the watchdog whenever device is written to.
- */
-static ssize_t at91_wdt_write(struct file *file, const char *data, size_t len,
-								loff_t *ppos)
-{
-	if (!len)
-		return 0;
-
-	/* Scan for magic character */
-	if (!nowayout) {
-		size_t i;
-
-		at91wdt_private.expect_close = 0;
-
-		for (i = 0; i < len; i++) {
-			char c;
-			if (get_user(c, data + i))
-				return -EFAULT;
-			if (c == 'V') {
-				at91wdt_private.expect_close = 42;
-				break;
-			}
-		}
-	}
-
-	at91wdt_private.next_heartbeat = jiffies + heartbeat * HZ;
-
-	return len;
-}
-
-/* ......................................................................... */
-
-static const struct file_operations at91wdt_fops = {
-	.owner			= THIS_MODULE,
-	.llseek			= no_llseek,
-	.unlocked_ioctl	= at91_wdt_ioctl,
-	.open			= at91_wdt_open,
-	.release		= at91_wdt_close,
-	.write			= at91_wdt_write,
-};
-
-static struct miscdevice at91wdt_miscdev = {
-	.minor		= WATCHDOG_MINOR,
-	.name		= "watchdog",
-	.fops		= &at91wdt_fops,
-};
-
 static int __init at91wdt_probe(struct platform_device *pdev)
 {
 	struct resource	*r;
 	int res;
 
-	if (at91wdt_miscdev.parent)
-		return -EBUSY;
-	at91wdt_miscdev.parent = &pdev->dev;
-
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r)
 		return -ENODEV;
@@ -277,10 +155,6 @@ static int __init at91wdt_probe(struct platform_device *pdev)
 	if (res)
 		return res;
 
-	res = misc_register(&at91wdt_miscdev);
-	if (res)
-		return res;
-
 	at91wdt_private.next_heartbeat = jiffies + heartbeat * HZ;
 	setup_timer(&at91wdt_private.timer, at91_ping, 0);
 	mod_timer(&at91wdt_private.timer, jiffies + WDT_TIMEOUT);
@@ -295,10 +169,6 @@ static int __exit at91wdt_remove(struct platform_device *pdev)
 {
 	int res;
 
-	res = misc_deregister(&at91wdt_miscdev);
-	if (!res)
-		at91wdt_miscdev.parent = NULL;
-
 	return res;
 }
 
@@ -326,4 +196,3 @@ module_exit(at91sam_wdt_exit);
 MODULE_AUTHOR("Renaud CERRATO <r.cerrato@til-technologies.fr>");
 MODULE_DESCRIPTION("Watchdog driver for Atmel AT91SAM9x processors");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-- 
1.7.9.5


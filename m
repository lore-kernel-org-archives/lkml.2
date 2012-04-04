Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab2DDBfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 21:35:08 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55928 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab2DDBed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 21:34:33 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@fluxnic.net>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Rob Herring <rob.herring@calxeda.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: [PATCH 5/5] watchdog: remove ixp2000 driver
Date: Tue,  3 Apr 2012 20:34:03 -0500
Message-Id: <1333503243-7702-5-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333503243-7702-1-git-send-email-robherring2@gmail.com>
References: <1333503243-7702-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

The platform is removed, so there are no users of this driver.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org
---
 drivers/watchdog/Kconfig       |   11 --
 drivers/watchdog/Makefile      |    1 -
 drivers/watchdog/ixp2000_wdt.c |  215 ----------------------------------------
 3 files changed, 0 insertions(+), 227 deletions(-)
 delete mode 100644 drivers/watchdog/ixp2000_wdt.c

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 3709624..2cb3438 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -129,17 +129,6 @@ config 977_WATCHDOG
 
 	  Not sure? It's safe to say N.
 
-config IXP2000_WATCHDOG
-	tristate "IXP2000 Watchdog"
-	depends on ARCH_IXP2000
-	help
-	  Say Y here if to include support for the watchdog timer
-	  in the Intel IXP2000(2400, 2800, 2850) network processors.
-	  This driver can be built as a module by choosing M. The module
-	  will be called ixp2000_wdt.
-
-	  Say N if you are unsure.
-
 config IXP4XX_WATCHDOG
 	tristate "IXP4xx Watchdog"
 	depends on ARCH_IXP4XX
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index e8f479a..34b4ceb 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -36,7 +36,6 @@ obj-$(CONFIG_OMAP_WATCHDOG) += omap_wdt.o
 obj-$(CONFIG_TWL4030_WATCHDOG) += twl4030_wdt.o
 obj-$(CONFIG_21285_WATCHDOG) += wdt285.o
 obj-$(CONFIG_977_WATCHDOG) += wdt977.o
-obj-$(CONFIG_IXP2000_WATCHDOG) += ixp2000_wdt.o
 obj-$(CONFIG_IXP4XX_WATCHDOG) += ixp4xx_wdt.o
 obj-$(CONFIG_KS8695_WATCHDOG) += ks8695_wdt.o
 obj-$(CONFIG_S3C2410_WATCHDOG) += s3c2410_wdt.o
diff --git a/drivers/watchdog/ixp2000_wdt.c b/drivers/watchdog/ixp2000_wdt.c
deleted file mode 100644
index 3f047a5..0000000
--- a/drivers/watchdog/ixp2000_wdt.c
+++ /dev/null
@@ -1,215 +0,0 @@
-/*
- * drivers/char/watchdog/ixp2000_wdt.c
- *
- * Watchdog driver for Intel IXP2000 network processors
- *
- * Adapted from the IXP4xx watchdog driver by Lennert Buytenhek.
- * The original version carries these notices:
- *
- * Author: Deepak Saxena <dsaxena@plexity.net>
- *
- * Copyright 2004 (c) MontaVista, Software, Inc.
- * Based on sa1100 driver, Copyright (C) 2000 Oleg Drokin <green@crimea.edu>
- *
- * This file is licensed under  the terms of the GNU General Public
- * License version 2. This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
- */
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/types.h>
-#include <linux/timer.h>
-#include <linux/kernel.h>
-#include <linux/fs.h>
-#include <linux/miscdevice.h>
-#include <linux/watchdog.h>
-#include <linux/init.h>
-#include <linux/bitops.h>
-#include <linux/uaccess.h>
-#include <mach/hardware.h>
-
-static bool nowayout = WATCHDOG_NOWAYOUT;
-static unsigned int heartbeat = 60;	/* (secs) Default is 1 minute */
-static unsigned long wdt_status;
-static DEFINE_SPINLOCK(wdt_lock);
-
-#define	WDT_IN_USE		0
-#define	WDT_OK_TO_CLOSE		1
-
-static unsigned long wdt_tick_rate;
-
-static void wdt_enable(void)
-{
-	spin_lock(&wdt_lock);
-	ixp2000_reg_write(IXP2000_RESET0, *(IXP2000_RESET0) | WDT_RESET_ENABLE);
-	ixp2000_reg_write(IXP2000_TWDE, WDT_ENABLE);
-	ixp2000_reg_write(IXP2000_T4_CLD, heartbeat * wdt_tick_rate);
-	ixp2000_reg_write(IXP2000_T4_CTL, TIMER_DIVIDER_256 | TIMER_ENABLE);
-	spin_unlock(&wdt_lock);
-}
-
-static void wdt_disable(void)
-{
-	spin_lock(&wdt_lock);
-	ixp2000_reg_write(IXP2000_T4_CTL, 0);
-	spin_unlock(&wdt_lock);
-}
-
-static void wdt_keepalive(void)
-{
-	spin_lock(&wdt_lock);
-	ixp2000_reg_write(IXP2000_T4_CLD, heartbeat * wdt_tick_rate);
-	spin_unlock(&wdt_lock);
-}
-
-static int ixp2000_wdt_open(struct inode *inode, struct file *file)
-{
-	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
-		return -EBUSY;
-
-	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-
-	wdt_enable();
-
-	return nonseekable_open(inode, file);
-}
-
-static ssize_t ixp2000_wdt_write(struct file *file, const char *data,
-						size_t len, loff_t *ppos)
-{
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
-				if (c == 'V')
-					set_bit(WDT_OK_TO_CLOSE, &wdt_status);
-			}
-		}
-		wdt_keepalive();
-	}
-
-	return len;
-}
-
-
-static const struct watchdog_info ident = {
-	.options	= WDIOF_MAGICCLOSE | WDIOF_SETTIMEOUT |
-				WDIOF_KEEPALIVEPING,
-	.identity	= "IXP2000 Watchdog",
-};
-
-static long ixp2000_wdt_ioctl(struct file *file, unsigned int cmd,
-							unsigned long arg)
-{
-	int ret = -ENOTTY;
-	int time;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		ret = copy_to_user((struct watchdog_info *)arg, &ident,
-				   sizeof(ident)) ? -EFAULT : 0;
-		break;
-
-	case WDIOC_GETSTATUS:
-		ret = put_user(0, (int *)arg);
-		break;
-
-	case WDIOC_GETBOOTSTATUS:
-		ret = put_user(0, (int *)arg);
-		break;
-
-	case WDIOC_KEEPALIVE:
-		wdt_enable();
-		ret = 0;
-		break;
-
-	case WDIOC_SETTIMEOUT:
-		ret = get_user(time, (int *)arg);
-		if (ret)
-			break;
-
-		if (time <= 0 || time > 60) {
-			ret = -EINVAL;
-			break;
-		}
-
-		heartbeat = time;
-		wdt_keepalive();
-		/* Fall through */
-
-	case WDIOC_GETTIMEOUT:
-		ret = put_user(heartbeat, (int *)arg);
-		break;
-	}
-
-	return ret;
-}
-
-static int ixp2000_wdt_release(struct inode *inode, struct file *file)
-{
-	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
-		wdt_disable();
-	else
-		pr_crit("Device closed unexpectedly - timer will not stop\n");
-	clear_bit(WDT_IN_USE, &wdt_status);
-	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-
-	return 0;
-}
-
-
-static const struct file_operations ixp2000_wdt_fops = {
-	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
-	.write		= ixp2000_wdt_write,
-	.unlocked_ioctl	= ixp2000_wdt_ioctl,
-	.open		= ixp2000_wdt_open,
-	.release	= ixp2000_wdt_release,
-};
-
-static struct miscdevice ixp2000_wdt_miscdev = {
-	.minor		= WATCHDOG_MINOR,
-	.name		= "watchdog",
-	.fops		= &ixp2000_wdt_fops,
-};
-
-static int __init ixp2000_wdt_init(void)
-{
-	if ((*IXP2000_PRODUCT_ID & 0x001ffef0) == 0x00000000) {
-		pr_info("Unable to use IXP2000 watchdog due to IXP2800 erratum #25\n");
-		return -EIO;
-	}
-	wdt_tick_rate = (*IXP2000_T1_CLD * HZ) / 256;
-	return misc_register(&ixp2000_wdt_miscdev);
-}
-
-static void __exit ixp2000_wdt_exit(void)
-{
-	misc_deregister(&ixp2000_wdt_miscdev);
-}
-
-module_init(ixp2000_wdt_init);
-module_exit(ixp2000_wdt_exit);
-
-MODULE_AUTHOR("Deepak Saxena <dsaxena@plexity.net>");
-MODULE_DESCRIPTION("IXP2000 Network Processor Watchdog");
-
-module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds (default 60s)");
-
-module_param(nowayout, bool, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started");
-
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-
-- 
1.7.5.4


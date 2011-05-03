Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab1ECFjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 01:39:40 -0400
Received: from mhqmail.moxa.com ([59.124.42.180]:42480 "EHLO
	mhqmail01.moxa.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751219Ab1ECFjj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 01:39:39 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/2] watchdog: add support for MOXA V2100 watchdog driver
Date: Tue, 3 May 2011 13:38:24 +0800
Message-ID: <ECB3782BB8F03341905DD923270296115F7124@mhqms01.moxa.com>
In-Reply-To: <ECB3782BB8F03341905DD923270296115F7122@mhqms01.moxa.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] watchdog: add support for MOXA V2100 watchdog driver
Thread-Index: AcwD/NBMCatjKIfPTFqwalST3J4LDgFVsldQAAANs0AAABG6IA==
From: =?big5?B?SmltbXkgQ2hlbiAos6+lw7lGKQ==?= <jimmy.chen@moxa.com>
To: =?big5?B?SmltbXkgQ2hlbiAos6+lw7lGKQ==?= <jimmy.chen@moxa.com>,
        <linux-kernel@vger.kernel.org>, <linux-watchdog@vger.kernel.org>,
        <wim@iguana.be>
X-OriginalArrivalTime: 03 May 2011 05:38:25.0070 (UTC) FILETIME=[525E0CE0:01CC0954]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jimmy Chen <jimmy.chen@moxa.com>

Add real function for watchdog driver

Signed-off-by: Jimmy Chen <jimmy.chen@moxa.com>
---
diff --git a/drivers/watchdog/moxa_wdt.c b/drivers/watchdog/moxa_wdt.c
new file mode 100644
index 0000000..1238e56
--- /dev/null
+++ b/drivers/watchdog/moxa_wdt.c
@@ -0,0 +1,387 @@
+/*
+ * serial driver for the MOXA V2100 platform.
+ *
+ * Copyright (c) MOXA Inc.  All rights reserved.
+ *	Jimmy Chen <jimmy.chen@moxa.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * History:
+ * Date		Author			Comment
+ * 04-29-2011	Jimmy Chen.		copy wdt.c code
+ */
+
+#define __KERNEL_SYSCALLS__
+
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/fs.h>
+#include <linux/ioport.h>
+#include <linux/notifier.h>
+#include <linux/reboot.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+
+#include <asm/system.h>
+
+#include "moxa_wdt.h"
+
+#define MOXA_WDT_VERSION		"v0.1.0"
+#define HW_VENDOR_ID_H			0x87
+#define HW_VENDOR_ID_L			0x83
+
+
+static unsigned long wdt_is_open;
+static char expect_close;
+
+static int timeout = DEFAULT_WATCHDOG_TIMEOUT;
+module_param(timeout, int, 0);
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. 1<= timeout <=63, default="
+		__MODULE_STRING(WATCHDOG_TIMEOUT) ".");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be "
+		"stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+
+static int debug;
+module_param(debug, int, 0);
+MODULE_PARM_DESC(debug, "print the debug message in this driver");
+
+static spinlock_t wdt_lock = SPIN_LOCK_UNLOCKED;
+
+/**
+ *	wdt_start:
+ *
+ *	Start the watchdog driver.
+ */
+
+static int moxawdt_start(void)
+{
+	unsigned long flags;
+	unsigned char val;
+
+	if (debug)
+		printk(KERN_DEBUG "wdt_start: timeout=%d\n", timeout);
+
+	spin_lock_irqsave(&wdt_lock, flags);
+	superio_init();
+	superio_select_dev(7);
+	val = superio_get_reg(0x72) | 0x10;
+	superio_set_reg(val, 0x72);
+	superio_set_reg((timeout/1000), 0x73);
+	spin_unlock_irqrestore(&wdt_lock, flags);
+	return 0;
+}
+
+/**
+ *	wdt_stop:
+ *
+ *	Stop the watchdog driver.
+ */
+
+static int wdt_stop(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&wdt_lock, flags);
+
+	if (debug)
+		printk(KERN_DEBUG "wdt_disable\n");
+	superio_init();
+	superio_select_dev(7);	/* logic device 8 */
+	superio_set_reg(0, 0x73);	/* Reg:F6 counter register */
+	spin_unlock_irqrestore(&wdt_lock, flags);
+	return 0;
+}
+
+/**
+ *	wdt_ping:
+ *
+ *	Reload counter one with the watchdog heartbeat. We don't bother
+ *	reloading the cascade counter.
+ */
+
+static void wdt_ping(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&wdt_lock, flags);
+
+	if (debug)
+		printk(KERN_DEBUG "wdt_ping: timeout=%d\n", timeout);
+	superio_init();
+	superio_select_dev(7);    /* logic device 7 */
+	superio_set_reg((timeout/1000), 0x73);    /* Reg:F6,30 sec */
+	spin_unlock_irqrestore(&wdt_lock, flags);
+}
+
+/**
+ *	wdt_verify_vendor:
+ *	return true if vendor ID match
+ */
+
+static int wdt_verify_vendor(void)
+{
+	unsigned char chip_id_h; /* chip id high byte */
+	unsigned char chip_id_l; /* chip id low byte */
+
+	superio_init();
+	superio_select_dev(7);
+	chip_id_h = superio_get_reg(0x20);
+	chip_id_l = superio_get_reg(0x21);
+	if ((chip_id_h == 0x87) && (chip_id_l == 0x83))
+		return 0;
+
+	return -1;
+}
+
+/**
+ *	wdt_set_timeout:
+ *	@t:		the new heartbeat value that needs to be set.
+ *
+ *	Set a new heartbeat value for the watchdog device. If the heartbeat
+ *	value is incorrect we keep the old value and return -EINVAL. If
+ *	successful we return 0.
+ */
+
+static int wdt_set_timeout(int *t)
+{
+	if (*t < WATCHDOG_MIN_TIMEOUT || *t > WATCHDOG_MAX_TIMEOUT) {
+		*t = DEFAULT_WATCHDOG_TIMEOUT;
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int moxawdt_open(struct inode *inode, struct file *file)
+{
+
+	if (test_and_set_bit(0, &wdt_is_open))
+		return -EBUSY;
+	/*
+	 *	Activate
+	 */
+	if (debug)
+		printk(KERN_DEBUG "moxawdt_open entry\n");
+	moxawdt_start();
+	return nonseekable_open(inode, file);
+
+	return 0;
+}
+
+static int moxawdt_release(struct inode *inode, struct file *file)
+{
+	if (debug)
+		printk(KERN_DEBUG "moxawdt_release entry\n");
+
+	if (expect_close == 42) {
+		wdt_stop();
+		clear_bit(0, &wdt_is_open);
+	} else {
+		printk(KERN_CRIT
+		 "wdt: WDT device closed unexpectedly.  WDT will not stop!\n");
+		wdt_ping();
+	}
+	expect_close = 0;
+
+	return 0;
+}
+
+static long moxawdt_ioctl(struct file *file,
+		unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	int new_timeout;
+	int status;
+
+	static struct watchdog_info ident = {
+		.options =		WDIOF_SETTIMEOUT|
+					WDIOF_MAGICCLOSE|
+					WDIOF_KEEPALIVEPING,
+		.firmware_version =	1,
+		.identity =		"MOXA2100WDT ",
+	};
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+		status = 1;
+		return put_user(status, p);
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_KEEPALIVE:
+		wdt_ping();
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_timeout, p))
+			return -EFAULT;
+		if (wdt_set_timeout(&new_timeout))
+			return -EINVAL;
+		wdt_ping();
+		/* Fall */
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, p);
+	default:
+		return -ENOTTY;
+	}
+	return 0;
+}
+
+/*
+ *      moxawdt_write:
+ *      @file: file handle to the watchdog
+ *      @buf: buffer to write (unused as data does not matter here
+ *      @count: count of bytes
+ *      @ppos: pointer to the position to write. No seeks allowed
+ *
+ *      A write to a watchdog device is defined as a keepalive signal. Any
+ *      write of data will do, as we we don't define content meaning.
+ */
+
+static ssize_t moxawdt_write(struct file *file, const char *buf, \
+			    size_t count, loff_t *ppos)
+{
+	if (count) {
+		if (!nowayout) {
+			size_t i;
+
+			/* In case it was set long ago */
+			for (i = 0; i != count; i++) {
+				char c;
+				if (get_user(c, buf + i))
+					return -EFAULT;
+				if (c == 'V')
+					expect_close = 42;
+			}
+		}
+
+	}
+	return count;
+}
+
+/**
+ *	notify_sys:
+ *	@this: our notifier block
+ *	@code: the event being reported
+ *	@unused: unused
+ *
+ *	Our notifier is called on system shutdowns. We want to turn the card
+ *	off at reboot otherwise the machine will reboot again during memory
+ *	test or worse yet during the following fsck. This would suck, in fact
+ *	trust me - if it happens it does suck.
+ */
+
+static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
+	void *unused)
+{
+	if (code == SYS_DOWN || code == SYS_HALT)
+		wdt_stop();
+	return NOTIFY_DONE;
+}
+
+/*
+ *	The WDT card needs to learn about soft shutdowns in order to
+ *	turn the timebomb registers off.
+ */
+
+static struct notifier_block wdt_notifier = {
+	.notifier_call = wdt_notify_sys,
+};
+
+static const struct file_operations moxawdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.open		= moxawdt_open,
+	.write		= moxawdt_write,
+	.unlocked_ioctl	= moxawdt_ioctl,
+	.release	= moxawdt_release,
+};
+
+static struct miscdevice wdt_miscdev = {
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &moxawdt_fops,
+};
+
+static int __init moxawdt_init(void)
+{
+	int ret;
+
+	/* we suppose to check magic id in case wrong devices */
+	if (wdt_verify_vendor()) {
+		printk(KERN_ERR "hw device id not match!!\n");
+		ret = -ENODEV;
+		goto reqreg_err;
+	}
+
+	/* check timeout valid */
+	if (wdt_set_timeout(&timeout)) {
+		printk(KERN_ERR "timeout value must be "
+				"%lu < timeout < %lu, using %d\n",
+				WATCHDOG_MIN_TIMEOUT, WATCHDOG_MAX_TIMEOUT,
+				timeout);
+	}
+
+	if (!request_region(SUPERIO_PORT, 2, "moxawdt")) {
+		printk(KERN_ERR "moxawdt_init: can't get I/O "
+				"address 0x%x\n", SUPERIO_PORT);
+		ret = -EBUSY;
+		goto reqreg_err;
+	}
+
+	ret = register_reboot_notifier(&wdt_notifier);
+	if (ret) {
+		printk(KERN_ERR "can't register reboot notifier\n");
+		goto regreb_err;
+	}
+
+	ret = misc_register(&wdt_miscdev);
+	if (ret) {
+		printk(KERN_ERR "Moxa V2100-LX WatchDog: Register misc fail !\n");
+		goto regmisc_err;
+	}
+
+	printk(KERN_INFO "Moxa V2100 Watchdog Driver,
+			version %s\n", MOXA_WDT_VERSION);
+	printk(KERN_INFO "initialized. (nowayout=%d)\n", nowayout);
+	printk(KERN_INFO "initialized. (timeout=%d)\n", timeout);
+	printk(KERN_INFO "initialized. (debug=%d)\n", debug);
+
+	return 0;
+
+regmisc_err:
+	unregister_reboot_notifier(&wdt_notifier);
+regreb_err:
+	release_region(SUPERIO_PORT, 2);
+reqreg_err:
+	return ret;
+}
+
+static void __exit moxawdt_exit(void)
+{
+	misc_deregister(&wdt_miscdev);
+	unregister_reboot_notifier(&wdt_notifier);
+	release_region(SUPERIO_PORT, 2);
+	superio_release();
+}
+
+module_init(moxawdt_init);
+module_exit(moxawdt_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Jimmy.Chen@moxa.com");
+MODULE_DESCRIPTION("Moxa V2100-LX WDT driver");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+
diff --git a/drivers/watchdog/moxa_wdt.h b/drivers/watchdog/moxa_wdt.h
new file mode 100644
index 0000000..3f3ff68
--- /dev/null
+++ b/drivers/watchdog/moxa_wdt.h
@@ -0,0 +1,53 @@
+/*
+ * serial driver for the MOXA V2100 platform.
+ *
+ * Copyright (c) MOXA Inc.  All rights reserved.
+ *	Jimmy Chen <jimmy.chen@moxa.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __X86__MOXAWDT__
+#define __X86__MOXAWDT__
+
+#define	SUPERIO_PORT		((u8)0x2e)
+
+#define DEFAULT_WATCHDOG_TIMEOUT	(30UL*1000UL)	/* 30 seconds */
+#define WATCHDOG_MIN_TIMEOUT	(1UL*1000UL)	/*  2 seconds */
+#define WATCHDOG_MAX_TIMEOUT	(255UL*1000UL)	/* 255 seconds */
+
+unsigned char superio_get_reg(u8 val)
+{
+	outb_p(val, SUPERIO_PORT);
+	val = inb_p(SUPERIO_PORT+1);
+	return val;
+}
+
+void superio_set_reg(u8 val, u8 index)
+{
+	outb_p(index, SUPERIO_PORT);
+	outb_p(val, (SUPERIO_PORT+1));
+}
+
+void superio_select_dev(u8 val)
+{
+	superio_set_reg(val, 0x07);
+}
+
+void superio_init(void)
+{
+	outb(0x87, SUPERIO_PORT);
+	outb(0x01, SUPERIO_PORT);
+	outb(0x55, SUPERIO_PORT);
+	outb(0x55, SUPERIO_PORT);
+}
+
+void superio_release(void)
+{
+	outb_p(0x02, SUPERIO_PORT);
+	outb_p(0x02, SUPERIO_PORT+1);
+}
+
+#endif	/* __X86__MOXAWDT__ */
--
To unsubscribe from this list: send the line "unsubscribe 
linux-kernel" in the body of a message to majordomo@vger.kernel.org 
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

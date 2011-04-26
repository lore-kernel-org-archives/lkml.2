Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab1DZKnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 06:43:40 -0400
Received: from mhqmail.moxa.com ([59.124.42.180]:7557 "EHLO mhqmail01.moxa.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754167Ab1DZKni convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 06:43:38 -0400
X-Greylist: delayed 850 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Apr 2011 06:43:37 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/2] watchdog: add real function on MOXA V2100 watchdog driver
Date: Tue, 26 Apr 2011 18:34:12 +0800
Message-ID: <ECB3782BB8F03341905DD923270296115F6ADB@mhqms01.moxa.com>
In-Reply-To: <ECB3782BB8F03341905DD923270296115F6AD9@mhqms01.moxa.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] watchdog: add real function on MOXA V2100 watchdog driver
Thread-Index: AcwD/NBMCatjKIfPTFqwalST3J4LDgAAAlXQAAAYEaA=
From: =?big5?B?SmltbXkgQ2hlbiAos6+lw7lGKQ==?= <jimmy.chen@moxa.com>
To: =?big5?B?SmltbXkgQ2hlbiAos6+lw7lGKQ==?= <jimmy.chen@moxa.com>,
        <linux-kernel@vger.kernel.org>, <linux-watchdog@vger.kernel.org>,
        <wim@iguana.be>
X-OriginalArrivalTime: 26 Apr 2011 10:34:12.0977 (UTC) FILETIME=[7C0D7E10:01CC03FD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jimmy Chen <jimmy.chen@moxa.com>

Add real function for watchdog driver

Signed-off-by: Jimmy Chen <jimmy.chen@moxa.com>
---
diff --git a/drivers/watchdog/moxa_swtd.c b/drivers/watchdog/moxa_swtd.c
index e69de29..4905338 100644
--- a/drivers/watchdog/moxa_swtd.c
+++ b/drivers/watchdog/moxa_swtd.c
@@ -0,0 +1,471 @@
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
+#define __KERNEL_SYSCALLS__
+#include <linux/proc_fs.h> /* Necessary because we use the proc fs */
+#include <linux/version.h>
+#include <linux/fs_struct.h>
+#include <linux/unistd.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/miscdevice.h>
+#include <linux/fcntl.h>
+#include <linux/init.h>
+#include <linux/poll.h>
+#include <linux/spinlock.h>
+#include <linux/delay.h>
+#include <linux/timer.h>
+#include <linux/ioport.h>
+#include <linux/interrupt.h>
+#include <linux/sched.h>
+#include <linux/signal.h>
+#include <linux/mm.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+#include <asm/system.h>
+#include <linux/irq.h>
+#include <linux/bitops.h>
+#include <linux/reboot.h>
+#include <linux/types.h>
+#include <linux/notifier.h>
+#include <linux/workqueue.h>
+
+#include "moxa_swtd.h"
+#ifndef WATCHDOG_NOWAYOUT
+#define WATCHDOG_NOWAYOUT 0
+#endif
+
+#define MOXA_SWTD_VERSION		"v0.1.0"
+
+static struct proc_dir_entry *swtd_proc_file;
+static int			opencounts ;
+static int			swtduserenabled ;
+static unsigned long		swtdtime = DEFAULT_WATCHDOG_TIME;
+static struct timer_list	timer_swtd;
+static int			bswtd_timeout ;
+static int			nowayout = WATCHDOG_NOWAYOUT;
+static int			debug ;
+static char			expect_close;
+static spinlock_t swtd_lock = SPIN_LOCK_UNLOCKED;
+
+static void swtd_ack(unsigned long swtd_ack_time)
+{
+	if (debug)
+		printk(KERN_DEBUG "swtd_ack: swtd_time=%lu\n", swtd_ack_time);
+	superio_enter_config();
+	superio_set_logic_device(7);    /* logic device 7 */
+	superio_set_reg((swtd_ack_time/1000), 0x73);    /* Reg:F6,30 sec */
+}
+
+static void swtd_enable(void)
+{
+	unsigned char reg_tmp;
+	if (debug)
+		printk(KERN_DEBUG "swtd_enable: swtdtime=%lu\n", swtdtime);
+	superio_enter_config();
+	superio_set_logic_device(7);
+	reg_tmp = superio_get_reg(0x72) | 0x10;
+	superio_set_reg(reg_tmp, 0x72);
+	superio_set_reg((swtdtime+WATCHDOG_DEFER_TIME)/1000, 0x73);
+}
+
+static void swtd_disable(void)
+{
+	if (debug)
+		printk(KERN_DEBUG "swtd_disable\n");
+	superio_enter_config();
+	superio_set_logic_device(7);    /* logic device 8 */
+	superio_set_reg(0, 0x73);       /* Reg:F6 counter register */
+}
+
+static void swtd_reboot(void *unused)
+{
+	char    *argv[2], *envp[5];
+
+	if (in_interrupt())
+		return;
+	if (!current->fs->root.dentry)
+		return;
+	argv[0] = "/sbin/reboot";
+	argv[1] = 0;
+	envp[0] = "HOME=/";
+	envp[1] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
+	envp[2] = 0;
+	/* important: prefer sw approach before hw reset,
+	 * make sure file system keep in safety
+	 * circumstances.
+	 */
+	call_usermodehelper(argv[0], argv, envp, 0);
+}
+
+DECLARE_WORK(rebootqueue, swtd_reboot);
+
+static void swtd_poll(unsigned long ignore)
+{
+	spin_lock(&swtd_lock);
+
+	if (swtduserenabled) {
+		swtd_ack(WATCHDOG_DEFER_TIME);
+		if (debug)
+			printk(KERN_DEBUG "swtd_poll: Now reboot the system.\n");
+		schedule_work(&rebootqueue);
+		bswtd_timeout = 1;
+	} else {
+		if (debug)
+			printk(KERN_DEBUG "swtd_poll: ack the hardware watchdog timer\n");
+
+		timer_swtd.expires = jiffies + WATCHDOG_ACK_JIFFIES(swtdtime);
+		add_timer(&timer_swtd);
+		swtd_ack(swtdtime + WATCHDOG_DEFER_TIME);
+	}
+	spin_unlock(&swtd_lock);
+}
+
+ssize_t moxaswtd_proc_read(char *buffer, char **buffer_location,
+		off_t offset, int buffer_length, int *eof, void *data)
+{
+	/* The number of bytes actually used */
+	int len = 0;
+
+	if (offset > 0) {
+		len = 0;
+	} else {
+		/* Fill the buffer and get its length */
+		len += sprintf(buffer+len,
+				"user enable\t: %d\n"
+				"ack time\t: %d msec\n"
+				"hardware watchdog counter\t: %d sec\n"
+				, swtduserenabled, (int)swtdtime,
+				superio_get_reg(0x73));
+	}
+	return len;
+}
+
+static int swtd_open(struct inode *inode, struct file *file)
+{
+
+	spin_lock_irq(&swtd_lock);
+	if (nowayout)
+		__module_get(THIS_MODULE);
+	bswtd_timeout = 0; /* reset the timeout flag */
+	opencounts++;
+	spin_unlock_irq(&swtd_lock);
+
+	return 0;
+}
+
+/* Kernel ack the watchdog timer and reset the state machine */
+static void swtd_release_timer(void)
+{
+	swtdtime = DEFAULT_WATCHDOG_TIME;
+	mod_timer(&timer_swtd, jiffies + WATCHDOG_ACK_JIFFIES(swtdtime));
+	swtd_ack(swtdtime+WATCHDOG_DEFER_TIME);
+	swtduserenabled = 0;
+	bswtd_timeout = 0; /* reset the timeout flag */
+
+}
+
+static int swtd_release(struct inode *inode, struct file *file)
+{
+	sigset_t *sigset = &current->signal->shared_pending.signal;
+
+	spin_lock_irq(&swtd_lock);
+
+	if (debug)
+		printk(KERN_DEBUG "swtd_release entry\n");
+	opencounts--;
+
+	if (opencounts <= 0) {
+		/*
+		 *      Shut off the timer.
+		 */
+		if (expect_close == 42) {
+			printk(KERN_DEBUG "swtd_release: expect close\n");
+			if (!bswtd_timeout)
+				swtd_release_timer();
+		} else if (signal_pending(current)) {
+			if (debug)
+				printk(KERN_DEBUG "swtd_release[%d] has\
+						 signal pending\n", __LINE__);
+			if (sigismember(sigset, SIGKILL) ||
+			    sigismember(sigset, SIGINT) ||
+			    sigismember(sigset, SIGTERM)) {
+				if (debug)
+					printk(KERN_DEBUG "swtd_release[%d]\
+							 get SIGKILL/\
+							SIGINT/SIGTERM\
+							 signal\n", __LINE__);
+				if (!bswtd_timeout)
+					swtd_release_timer();
+			}
+		} else if (current->signal->group_exit_code == SIGQUIT ||
+			current->signal->group_exit_code == SIGILL ||
+			current->signal->group_exit_code == SIGABRT ||
+			current->signal->group_exit_code == SIGFPE ||
+			current->signal->group_exit_code == SIGSEGV) {
+			if (debug)
+				printk(KERN_DEBUG "swtd_release[%d]\
+						 got coredump\n", __LINE__);
+		} else {	/* normal close the file handle */
+			if (debug)
+				printk(KERN_DEBUG "swtd_release_l1[%d]\
+						 kernel ack the\
+						 watchdog timer\n", __LINE__);
+			if (!bswtd_timeout)
+				swtd_release_timer();
+		}
+		expect_close = 0;
+	}
+	spin_unlock_irq(&swtd_lock);
+
+	return 0;
+}
+
+static int swtd_ioctl(struct inode *inode, struct file *file,
+		unsigned int ioc_cmd, unsigned long arg)
+{
+	unsigned long time;
+	struct swtd_set_struct nowset;
+
+	switch (ioc_cmd) {
+	case IOCTL_WATCHDOG_ENABLE:
+		if (copy_from_user(&time, (unsigned long *)arg,
+					sizeof(unsigned long)))
+			return -EFAULT;
+		if (time < WATCHDOG_MIN_TIME || time > WATCHDOG_MAX_TIME)
+			return -EINVAL;
+		spin_lock_irq(&swtd_lock);
+		if (!bswtd_timeout) {
+			/* Switch to user mode watchdog.
+			 * When the kernel timer timeout, the system will reboot
+			 */
+			swtduserenabled = 1;
+			swtdtime = time;
+			mod_timer(&timer_swtd, jiffies +
+					WATCHDOG_ACK_JIFFIES(swtdtime));
+			swtd_ack(swtdtime + WATCHDOG_DEFER_TIME);
+		}
+		spin_unlock_irq(&swtd_lock);
+		break;
+	case IOCTL_WATCHDOG_DISABLE:
+		spin_lock_irq(&swtd_lock);
+		if (swtduserenabled && !bswtd_timeout) {
+			/* Switch to kernel mode watchdog.
+			 * The kernel timer will acknowledge the HW watchdog
+			 */
+			swtd_enable();
+			mod_timer(&timer_swtd, jiffies +
+					WATCHDOG_ACK_JIFFIES(swtdtime));
+			swtdtime = DEFAULT_WATCHDOG_TIME;
+			bswtd_timeout = 0; /* reset the timeout flag */
+			swtduserenabled = 0;
+		}
+		spin_unlock_irq(&swtd_lock);
+		break;
+	case IOCTL_WATCHDOG_GET_SETTING:
+		nowset.mode = swtduserenabled;
+		nowset.time = swtdtime;
+		if (copy_to_user((void *)arg, &nowset, sizeof(nowset)))
+			return -EFAULT;
+		break;
+	case IOCTL_WATCHDOG_ACK:
+		spin_lock_irq(&swtd_lock);
+		if (swtduserenabled && !bswtd_timeout) {
+			/* Switch to user mode watchdog.
+			 * When the kernel timer timeout, the system will reboot
+			 */
+			mod_timer(&timer_swtd, jiffies +
+					WATCHDOG_ACK_JIFFIES(swtdtime));
+			swtd_ack(swtdtime + WATCHDOG_DEFER_TIME);
+		}
+		spin_unlock_irq(&swtd_lock);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/*
+ *      swtd_write:
+ *      @file: file handle to the watchdog
+ *      @buf: buffer to write (unused as data does not matter here
+ *      @count: count of bytes
+ *      @ppos: pointer to the position to write. No seeks allowed
+ *
+ *      A write to a watchdog device is defined as a keepalive signal. Any
+ *      write of data will do, as we we don't define content meaning.
+ */
+
+static ssize_t swtd_write(struct file *file, const char *buf, \
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
+		/* someone wrote to us, we should restart timer */
+		spin_lock_irq(&swtd_lock);
+		if (!bswtd_timeout) {
+			swtduserenabled = 1;
+			mod_timer(&timer_swtd, jiffies +
+					WATCHDOG_ACK_JIFFIES(swtdtime));
+			swtd_ack(swtdtime + WATCHDOG_DEFER_TIME);
+		}
+		spin_unlock_irq(&swtd_lock);
+	}
+	return count;
+}
+
+/* Panic hander */
+static int swtd_panic_handler(struct notifier_block *this,
+		unsigned long event, void *unused)
+{
+	unsigned char reg_tmp;
+	/* Avoid the software interrupt of swtd_ack */
+	spin_lock_bh(&swtd_lock);
+
+	if (debug) {
+		printk(KERN_DEBUG "swtd_panic_handler: enter\n");
+
+		/* Reset flash state */
+		printk(KERN_DEBUG "swtd_panic_handler: reset flash state\n");
+		/* Call hardware reboot */
+		printk(KERN_DEBUG "swtd_panic_handler: call hardware rebooot\n");
+	}
+	superio_enter_config();
+	superio_set_logic_device(7);
+	reg_tmp = superio_get_reg(0x72) | 0x10;
+	superio_set_reg(reg_tmp, 0x72);
+	superio_set_reg(1000/1000, 0x73);
+
+	return NOTIFY_OK;
+
+	spin_unlock_bh(&swtd_lock);
+}
+
+/* Structure for notification */
+static struct notifier_block swtd_panic_notifier = {
+	swtd_panic_handler,
+	NULL,
+	150   /* priority: INT_MAX >= x >= 0 */
+};
+
+static const struct file_operations moxa_swtd_fops = {
+	.owner = THIS_MODULE,
+	.open = swtd_open,
+	.write = swtd_write,
+	.ioctl = swtd_ioctl,
+	.release = swtd_release,
+};
+
+static struct miscdevice wdt_miscdev = {
+	.minor = MOXA_WATCHDOG_MINOR,
+	.name = "swtd",
+	.fops = &moxa_swtd_fops,
+};
+
+static int __init moxaswtd_init(void)
+{
+	struct resource *base_res;
+
+	/* register misc */
+	if (misc_register(&wdt_miscdev) != 0) {
+		printk(KERN_ERR "Moxa V2100-LX WatchDog: Register misc fail !\n");
+		goto moxa_swtd_init_err1;
+	}
+
+	/* register panic hander */
+	atomic_notifier_chain_register(&panic_notifier_list,
+			&swtd_panic_notifier);
+
+	init_timer(&timer_swtd);
+	timer_swtd.function = swtd_poll;
+	timer_swtd.expires = jiffies + WATCHDOG_ACK_JIFFIES(swtdtime);
+	add_timer(&timer_swtd);
+	swtd_enable();
+
+	swtd_proc_file = create_proc_read_entry("driver/swtd", 0644,
+			NULL, moxaswtd_proc_read, NULL);
+	if (!swtd_proc_file) {
+		printk(KERN_ERR "moxaswtd_init:create_proc_read_entry() fail\n");
+		goto moxa_swtd_init_err2;
+	}
+
+	base_res = request_region(SUPERIO_CONFIG_PORT, 2, "swtd");
+	if (!base_res) {
+		printk(KERN_ERR "moxaswtd_init: can't get I/O\
+				 address 0x%x\n", SUPERIO_CONFIG_PORT);
+		goto moxa_swtd_init_err3;
+	}
+
+	opencounts = 0;
+	swtduserenabled = 0;
+	bswtd_timeout = 0;
+
+	printk(KERN_INFO "Moxa V2100 Watchdog Driver, version "
+			MOXA_SWTD_VERSION", init OK\n");
+	printk(KERN_INFO "initialized. (nowayout=%d)\n", nowayout);
+	printk(KERN_INFO "initialized. (debug=%d)\n", debug);
+
+	return 0;
+
+moxa_swtd_init_err3:
+	remove_proc_entry("driver/swtd", NULL);
+moxa_swtd_init_err2:
+	if (timer_pending(&timer_swtd))
+		del_timer(&timer_swtd);
+	misc_deregister(&wdt_miscdev);
+moxa_swtd_init_err1:
+	return -ENOMEM;
+}
+
+static void __exit moxaswtd_exit(void)
+{
+	release_region(SUPERIO_CONFIG_PORT, 2);
+	superio_exit_config();
+	remove_proc_entry("driver/swtd", NULL);
+	swtd_disable();
+	if (timer_pending(&timer_swtd))
+		del_timer(&timer_swtd);
+	if (swtduserenabled) {
+		swtduserenabled = 0;
+		opencounts = 0;
+	}
+	misc_deregister(&wdt_miscdev);
+
+	atomic_notifier_chain_unregister(&panic_notifier_list,
+			&swtd_panic_notifier);
+
+}
+
+module_init(moxaswtd_init);
+module_exit(moxaswtd_exit);
+
+MODULE_AUTHOR("Jimmy.Chen@moxa.com");
+MODULE_LICENSE("GPL v2");
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be\
+		 stopped once started (default=CONFIG_WATCHDOG_NOWAYOUT)");
+module_param(debug, int, 0);
+MODULE_PARM_DESC(debug, "print the debug message in this driver");
diff --git a/drivers/watchdog/moxa_swtd.h b/drivers/watchdog/moxa_swtd.h
index e69de29..f026858 100644
--- a/drivers/watchdog/moxa_swtd.h
+++ b/drivers/watchdog/moxa_swtd.h
@@ -0,0 +1,73 @@
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
+#define	SUPERIO_CONFIG_PORT		0x2e
+
+#define DEFAULT_WATCHDOG_TIME	(30UL*1000UL)	/* 30 seconds */
+#define WATCHDOG_MIN_TIME	(1UL*1000UL)	/*  2 seconds */
+#define WATCHDOG_MAX_TIME	(255UL*1000UL)	/* 255 seconds */
+/* 50 msec, for watchdog timer polling */
+#define WATCHDOG_TOL_TIME	(50UL)
+/* 5 sec, for hw watchdog timer rebooting */
+#define WATCHDOG_DEFER_TIME	(15000UL)
+#define WATCHDOG_ACK_JIFFIES(x)	(((x-WATCHDOG_TOL_TIME)*HZ/1000UL))
+
+#define MOXA_WATCHDOG_MINOR	255
+/* enable watch dog and set time (unint msec) */
+#define IOCTL_WATCHDOG_ENABLE		1
+/* disable watch dog, kernel do it */
+#define IOCTL_WATCHDOG_DISABLE		2
+/* get now setting about mode and time */
+#define IOCTL_WATCHDOG_GET_SETTING	3
+/* to ack watch dog */
+#define IOCTL_WATCHDOG_ACK		4
+
+struct swtd_set_struct {
+	int		mode;
+	unsigned long	time;
+};
+
+unsigned char superio_get_reg(u8 val)
+{
+	outb_p(val, SUPERIO_CONFIG_PORT);
+	val = inb(SUPERIO_CONFIG_PORT+1);
+	return val;
+}
+
+void superio_set_reg(u8 val, u8 index)
+{
+	outb_p(index, SUPERIO_CONFIG_PORT);
+	outb_p(val, (SUPERIO_CONFIG_PORT+1));
+}
+
+void superio_set_logic_device(u8 val)
+{
+	superio_set_reg(val, 0x07);
+}
+
+void superio_enter_config(void)
+{
+	outb_p(0x87, SUPERIO_CONFIG_PORT);
+	outb_p(0x01, SUPERIO_CONFIG_PORT);
+	outb_p(0x55, SUPERIO_CONFIG_PORT);
+	outb_p(0x55, SUPERIO_CONFIG_PORT);
+}
+
+void superio_exit_config(void)
+{
+	outb_p(0x02, SUPERIO_CONFIG_PORT);
+	outb_p(0x02, SUPERIO_CONFIG_PORT+1);
+}
+
+#endif	/* __X86__MOXAWDT__ */
--
To unsubscribe from this list: send the line "unsubscribe 
linux-kernel" in the body of a message to majordomo@vger.kernel.org 
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

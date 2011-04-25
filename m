Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab1DYGov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 02:44:51 -0400
Received: from mhqmail.moxa.com ([218.210.60.130]:16441 "EHLO
	mhqmail01.moxa.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755410Ab1DYGor convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 02:44:47 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/2] misc: add real function open/read/write/ioctl/close for moxa_serial_io driver
Date: Mon, 25 Apr 2011 14:44:45 +0800
Message-ID: <ECB3782BB8F03341905DD923270296115F67B2@mhqms01.moxa.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] misc: add real function open/read/write/ioctl/close for moxa_serial_io driver
Thread-Index: AcwA0y++eDmjYMfeS5uFGN/WQ83uQQAAETrgAAA4trAAABnAcACGpmwQAAB3CSAACIW30A==
From: =?big5?B?SmltbXkgQ2hlbiAos6+lw7lGKQ==?= <jimmy.chen@moxa.com>
To: =?big5?B?SmltbXkgQ2hlbiAos6+lw7lGKQ==?= <jimmy.chen@moxa.com>,
        <linux-kernel@vger.kernel.org>
Cc: <gregkh@suse.de>
X-OriginalArrivalTime: 25 Apr 2011 06:44:46.0285 (UTC) FILETIME=[440D3FD0:01CC0314]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jimmy Chen <jimmy.chen@moxa.com>

Add real function and GPL license.
Check with script/checkpatch.pl

Signed-off-by: Jimmy Chen <jimmy.chen@moxa.com>
---
diff --git a/drivers/misc/moxa_serial_io.c b/drivers/misc/moxa_serial_io.c
index e69de29..eb6c65e 100644
--- a/drivers/misc/moxa_serial_io.c
+++ b/drivers/misc/moxa_serial_io.c
@@ -0,0 +1,296 @@
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
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/miscdevice.h>
+#include <linux/interrupt.h>
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+#include "moxa_serial_io.h"
+
+#define MOXA_IO_MINOR 255
+#define BASEPORT 0x800
+#define MOXA_SERIAL_IO_VERSION "v0.1.0"
+/*
+ * DIO file operaiton function call
+*/
+#define MAX_DIO                 3
+
+#define DIO_INPUT               1
+#define DIO_OUTPUT              0
+#define DIO_HIGH                1
+#define DIO_LOW                 0
+#define IOCTL_DIO_GET_MODE      1
+#define IOCTL_DIO_SET_MODE      2
+#define IOCTL_DIO_GET_DATA      3
+#define IOCTL_DIO_SET_DATA      4
+#define IOCTL_SET_DOUT          15
+#define IOCTL_GET_DOUT          16
+#define IOCTL_GET_DIN           17
+
+#define MOXA                    0x400
+#define MOXA_SET_OP_MODE      (MOXA + 66)
+#define MOXA_GET_OP_MODE      (MOXA + 67)
+
+#define RS232_MODE              0
+#define RS485_2WIRE_MODE        1
+#define RS422_MODE              2
+#define RS485_4WIRE_MODE        3
+
+
+struct dio_set_struct {
+	int io_number;
+	/* 1 for input, 0 for output, 1 for high, 0 for low */
+	int mode_data;
+};
+
+static unsigned char do_state_keep = 0xff;
+static unsigned int counter = 1;
+static char string[128];
+unsigned char keep_opmode = 0x00;
+
+/* open function - called when the "file" /dev/mxsio is opened in userspace */
+static int io_open(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
+/* close function - called when the "file" /dev/mxsio is closed in userspace */
+static int io_release(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
+/* read function called when from /dev/mxsio is read */
+static ssize_t io_read(struct file *file, char *buf,
+		size_t count, loff_t *ppos)
+{
+	int len, err;
+
+	if (counter <= 0)
+		return 0;
+	err = copy_to_user(buf, string, counter);
+	if (err != 0)
+		return -EFAULT;
+	len  = counter;
+	counter = 0;
+	return len;
+}
+
+/* write function called when to /dev/mxsio is written */
+static ssize_t io_write(struct file *file, const char *buf,
+		size_t count, loff_t *ppos)
+{
+	int err;
+	err = copy_from_user(string, buf, count);
+
+	if (count < 3)
+		return -EINVAL;
+	if (err != 0)
+		return -EFAULT;
+	outb((unsigned char)string[2],
+			(((unsigned short)string[0])<<8) |
+			((unsigned short)string[1]));
+
+	counter += count;
+	return count;
+}
+
+/* ioctl - I/O control */
+static int io_ioctl(struct inode *inode, struct file *file,
+		unsigned int cmd, unsigned long arg)
+{
+	struct dio_set_struct   set;
+	unsigned char di_state;
+	unsigned char port, opmode, val;
+
+	switch (cmd) {
+	case IOCTL_SET_DOUT:
+		if (copy_from_user(&set, (struct dio_set_struct *)arg,
+					sizeof(struct dio_set_struct)))
+			return -EFAULT;
+		if (set.io_number < 0 || set.io_number >= MAX_DIO)
+			return -EINVAL;
+		if (set.mode_data == DIO_HIGH)
+			do_state_keep |= (1<<set.io_number);
+		else if (set.mode_data == DIO_LOW)
+			do_state_keep &= ~(1<<set.io_number);
+		else
+			return -EINVAL;
+		outb(do_state_keep, BASEPORT+5);
+		break;
+	case IOCTL_GET_DOUT:
+	case IOCTL_GET_DIN:
+		if (copy_from_user(&set, (struct dio_set_struct *)arg,
+					sizeof(struct dio_set_struct)))
+			return -EFAULT;
+		if (set.io_number == -1) {	/* get all port */
+			if (cmd == IOCTL_GET_DOUT)
+				set.mode_data = do_state_keep & 0xf;
+			else
+				set.mode_data = (inb(BASEPORT+5)>>4) & 0xf;
+			goto ioctl_get_label;
+		}
+		if (set.io_number < 0 || set.io_number >= MAX_DIO)
+			return -EINVAL;
+		if (cmd == IOCTL_GET_DOUT) {
+			if (do_state_keep & (1<<set.io_number))
+				set.mode_data = 1;
+			else
+				set.mode_data = 0;
+		} else {
+			di_state = inb(BASEPORT+5)>>4;
+			if (di_state & (1<<set.io_number))
+				set.mode_data = 1;
+			else
+				set.mode_data = 0;
+		}
+ioctl_get_label:
+		if (copy_to_user((struct dio_set_struct *)arg,
+					&set, sizeof(struct dio_set_struct)))
+			return -EFAULT;
+		break;
+	case MOXA_SET_OP_MODE:
+		copy_from_user(&opmode, (unsigned char *)arg,
+				sizeof(unsigned char));
+		port = opmode >> 4 ;
+		opmode = opmode & 0xf;
+
+		if (opmode != RS232_MODE && opmode != RS485_2WIRE_MODE &&
+				opmode != RS422_MODE &&
+				opmode != RS485_4WIRE_MODE &&
+				port > 1)
+			return -EFAULT;
+
+		val = inb(BASEPORT+4)&(~(((unsigned char)0xe)<<(4*port)));
+
+		switch (opmode) {
+		case RS232_MODE:
+			val |= (((unsigned char)0x8)<<(4*port));
+			break;
+		case RS485_2WIRE_MODE:
+			val |= (((unsigned char)0x2)<<(4*port));
+			break;
+		case RS422_MODE:
+		case RS485_4WIRE_MODE:
+			val |= (((unsigned char)0x4)<<(4*port));
+			break;
+		}
+
+		outb(val, BASEPORT+4);
+
+		keep_opmode &= ~(((unsigned char)0xf)<<(port*4));
+		keep_opmode |= opmode<<(port*4);
+
+		superio_enter_config();
+		superio_set_logic_device((u8)(port+1));
+		if (opmode == RS232_MODE)
+			val = superio_get_reg(0xf0) & 0x7f;
+		else
+			val = superio_get_reg(0xf0) | 0x80;
+
+		superio_set_reg(val , 0xf0);
+
+		break;
+
+	case MOXA_GET_OP_MODE:
+		copy_from_user(&port, (unsigned char *)arg,
+				sizeof(unsigned char));
+		if (port > 1)
+			return -EINVAL;
+		opmode = (keep_opmode>>(port*4)) & 0xf;
+		copy_to_user((unsigned char *)arg,
+				&opmode, sizeof(unsigned char));
+
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+
+/* define which file operations are supported */
+static const struct file_operations io_fops = {
+	.owner	=	THIS_MODULE,
+	.llseek	=	NULL,
+	.read	=	io_read,
+	.write	=	io_write,
+	.readdir	=	NULL,
+	.poll		=	NULL,
+	.ioctl	=   io_ioctl,
+	.mmap	=	NULL,
+	.open	=   io_open,
+	.flush	=	NULL,
+	.release	=   io_release,
+	.fsync	=	NULL,
+	.fasync	=	NULL,
+	.lock	=	NULL,
+};
+
+/* register as misc driver */
+static struct miscdevice dio_miscdev = {
+	.minor = MOXA_IO_MINOR,
+	.name = "mxsio",
+	.fops = &io_fops,
+};
+
+
+/* initialize module (and interrupt) */
+static int __init io_init_module(void)
+{
+	unsigned char val;
+	printk(KERN_INFO "initializing MOXA SERIAL IO module\n");
+
+	if (misc_register(&dio_miscdev) != 0) {
+		printk(KERN_INFO "Moxa serial io driver: Register misc fail !\n");
+		return -ENOMEM;
+	}
+
+	outb(do_state_keep, BASEPORT+5);
+	outb(0x00, BASEPORT);
+
+	/* set default serial mode to RS232 */
+	outb(0x88, BASEPORT+4);
+
+	superio_enter_config();
+	superio_set_logic_device(1);
+	val = superio_get_reg(0xf0)&0x7f;
+	superio_set_reg(val, 0xf0);
+
+	superio_enter_config();
+	superio_set_logic_device(2);
+	val = superio_get_reg(0xf0)&0x7f;
+	superio_set_reg(val, 0xf0);
+
+	printk(KERN_INFO "Moxa V2100 serial io driver, version "
+			MOXA_SERIAL_IO_VERSION ", " "init OK\n");
+	return 0;
+}
+
+/* close and cleanup module */
+static void __exit io_cleanup_module(void)
+{
+	printk("cleaning up module\n");
+	misc_deregister(&dio_miscdev);
+}
+
+module_init(io_init_module);
+module_exit(io_cleanup_module);
+MODULE_AUTHOR("Jimmy.Chen@moxa.com");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("MOXA SERIAL IO module");
diff --git a/drivers/misc/moxa_serial_io.h b/drivers/misc/moxa_serial_io.h
index e69de29..1d5ecf8 100644
--- a/drivers/misc/moxa_serial_io.h
+++ b/drivers/misc/moxa_serial_io.h
@@ -0,0 +1,55 @@
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
+#ifndef __X86__SUPERIO__
+#define __X86__SUPERIO__
+
+#define	SUPERIO_CONFIG_PORT		0x2e
+
+unsigned char superio_get_reg(u8 val)
+{
+	outb(val, SUPERIO_CONFIG_PORT);
+	outb(0x80, 0xeb);
+	val = inb(SUPERIO_CONFIG_PORT+1);
+	outb(0x80, 0xeb);
+	return val;
+}
+
+void superio_set_reg(u8 val, u8 index)
+{
+	outb(index, SUPERIO_CONFIG_PORT);
+	outb(0x80, 0xeb);
+	outb(val, (SUPERIO_CONFIG_PORT+1));
+	outb(0x80, 0xeb);
+}
+
+void superio_set_logic_device(u8 val)
+{
+	superio_set_reg(val, 0x07);
+	outb(0x80, 0xeb);
+}
+
+void superio_enter_config(void)
+{
+	outb(0x87, SUPERIO_CONFIG_PORT);
+	outb(0x01, SUPERIO_CONFIG_PORT);
+	outb(0x55, SUPERIO_CONFIG_PORT);
+	outb(0x55, SUPERIO_CONFIG_PORT);
+}
+
+void superio_exit_config(void)
+{
+	outb(0x02, SUPERIO_CONFIG_PORT);
+	outb(0x80, 0xeb);
+	outb(0x02, SUPERIO_CONFIG_PORT+1);
+}
+
+#endif	/* __X86__SUPERIO__ */
---
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

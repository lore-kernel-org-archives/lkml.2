Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266Ab1FRRTx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 13:19:53 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:43723 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764Ab1FRRTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 13:19:49 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAILc/E1tgyeh/2dsb2JhbABSpl54iHW9GQ6GHAShYQ
Date: Sat, 18 Jun 2011 19:19:46 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/10 v2] Generic Watchdog Timer Driver
Message-ID: <20110618171946.GB3441@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

watchdog: WatchDog Timer Driver Core - Part 1

The WatchDog Timer Driver Core is a framework
that contains the common code for all watchdog-driver's.
It also introduces a watchdog device structure and the
operations that go with it.

This is the introduction of this framework. This part
supports the minimal watchdog userspace API (or with
other words: the functionality to use /dev/watchdog's
open, release and write functionality as defined in
the simplest watchdog API). Extra functionality will
follow in the next set of patches.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

diff -urN linux-2.6.38-orig/Documentation/watchdog/src/watchdog-with-timer-example.c linux-2.6.38-generic-part1/Documentation/watchdog/src/watchdog-with-timer-example.c
--- linux-2.6.38-orig/Documentation/watchdog/src/watchdog-with-timer-example.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.38-generic-part1/Documentation/watchdog/src/watchdog-with-timer-example.c	2011-06-16 20:07:33.939170516 +0200
@@ -0,0 +1,210 @@
+/*
+ * Watchdog timer driver example with timer.
+ *
+ * Copyright (C) 2009-2011 Wim Van Sebroeck <wim@iguana.be>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+/*
+ * This is an example driver where the hardware does not support
+ * stopping the watchdog timer.
+ */
+
+#define DRV_NAME KBUILD_MODNAME
+#define pr_fmt(fmt) DRV_NAME ": " fmt
+
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/watchdog.h>
+#include <linux/jiffies.h>
+#include <linux/timer.h>
+#include <linux/bitops.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+
+/* Hardware heartbeat in seconds */
+#define WDT_HW_HEARTBEAT 2
+
+/* Timer heartbeat (500ms) */
+#define WDT_HEARTBEAT	(HZ/2)	/* should be <= ((WDT_HW_HEARTBEAT*HZ)/2) */
+
+/* User land timeout */
+#define WDT_TIMEOUT 15
+static int timeout = WDT_TIMEOUT;
+module_param(timeout, int, 0);
+MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. "
+	"(default = " __MODULE_STRING(WDT_TIMEOUT) ")");
+
+static void wdt_timer_tick(unsigned long data);
+static DEFINE_TIMER(timer, wdt_timer_tick, 0, 0);
+					/* The timer that pings the watchdog */
+static unsigned long next_heartbeat;	/* the next_heartbeat for the timer */
+static unsigned long running;		/* is watchdog running for userspace? */
+
+static struct platform_device *wdt_platform_device;
+
+/*
+ * Reset the watchdog timer.  (ie, pat the watchdog)
+ */
+static inline void wdt_reset(void)
+{
+	/* Reset the watchdog timer hardware here */
+}
+
+/*
+ * Timer tick: the timer will make sure that the watchdog timer hardware
+ * is being reset in time. The conditions to do this are:
+ *  1) the watchog timer has been started and /dev/watchdog is open
+ *     and there is still time left before userspace should send the
+ *     next heartbeat/ping. (note: the internal heartbeat is much smaller
+ *     then the external/userspace heartbeat).
+ *  2) the watchdog timer has been stopped by userspace.
+ */
+static void wdt_timer_tick(unsigned long data)
+{
+	if (time_before(jiffies, next_heartbeat) ||
+			(!running)) {
+		wdt_reset();
+		mod_timer(&timer, jiffies + WDT_HEARTBEAT);
+	} else
+		pr_crit("I will reboot your machine !\n");
+}
+
+/*
+ * The watchdog operations
+ */
+static int wdt_ping(struct watchdog_device *wdd)
+{
+	/* calculate when the next userspace timeout will be */
+	next_heartbeat = jiffies + timeout * HZ;
+	return 0;
+}
+
+static int wdt_start(struct watchdog_device *wdd)
+{
+	/* calculate the next userspace timeout and modify the timer */
+	wdt_ping(wdd);
+	mod_timer(&timer, jiffies + WDT_HEARTBEAT);
+
+	/* Start the watchdog timer hardware here */
+	pr_info("wdt_start\n");
+
+	running = 1;
+	return 0;
+}
+
+static int wdt_stop(struct watchdog_device *wdd)
+{
+	/* The watchdog timer hardware can not be stopped... */
+	pr_info("wdt_stop\n");
+
+	running = 0;
+	return 0;
+}
+
+/*
+ * The watchdog kernel structures
+ */
+static const struct watchdog_ops wdt_ops = {
+	.owner =	THIS_MODULE,
+	.start =	wdt_start,
+	.stop =		wdt_stop,
+	.ping =		wdt_ping,
+};
+
+static struct watchdog_device wdt_dev = {
+	.name =		DRV_NAME,
+	.ops =		&wdt_ops,
+};
+
+/*
+ * The watchdog timer drivers init and exit routines
+ */
+static int __devinit wdt_probe(struct platform_device *pdev)
+{
+	int res;
+
+	/* Register other stuff */
+
+	/* Register the watchdog timer device */
+	res = watchdog_register_device(&wdt_dev);
+	if (res) {
+		pr_err("watchdog_register_device returned %d\n", res);
+		return res;
+	}
+
+	pr_info("enabled (timeout=%d sec)\n", timeout);
+
+	return 0;
+}
+
+static int __devexit wdt_remove(struct platform_device *pdev)
+{
+	/* Unregister the watchdog timer device */
+	watchdog_unregister_device(&wdt_dev);
+
+	/* stop and delete the timer */
+	pr_warn("I quit now, hardware will probably reboot!\n");
+	del_timer(&timer);
+
+	/* Unregister other stuff */
+	return 0;
+}
+
+static struct platform_driver wdt_driver = {
+	.probe		= wdt_probe,
+	.remove		= __devexit_p(wdt_remove),
+	.driver		= {
+		.name	= DRV_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init wdt_init(void)
+{
+	int err;
+
+	pr_info("WDT driver initialising.\n");
+
+	err = platform_driver_register(&wdt_driver);
+	if (err)
+		return err;
+
+	wdt_platform_device = platform_device_register_simple(DRV_NAME,
+								-1, NULL, 0);
+	if (IS_ERR(wdt_platform_device)) {
+		err = PTR_ERR(wdt_platform_device);
+		goto unreg_platform_driver;
+	}
+
+	return 0;
+
+unreg_platform_driver:
+	platform_driver_unregister(&wdt_driver);
+	return err;
+}
+
+static void __exit wdt_exit(void)
+{
+	platform_device_unregister(wdt_platform_device);
+	platform_driver_unregister(&wdt_driver);
+	pr_info("Watchdog Module Unloaded.\n");
+}
+
+module_init(wdt_init);
+module_exit(wdt_exit);
+
+MODULE_AUTHOR("Wim Van Sebroeck <wim@iguana.be>");
+MODULE_DESCRIPTION("WatchDog Timer Driver example with timer");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" DRV_NAME);
diff -urN linux-2.6.38-orig/Documentation/watchdog/watchdog-kernel-api.txt linux-2.6.38-generic-part1/Documentation/watchdog/watchdog-kernel-api.txt
--- linux-2.6.38-orig/Documentation/watchdog/watchdog-kernel-api.txt	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.38-generic-part1/Documentation/watchdog/watchdog-kernel-api.txt	2011-06-16 14:26:05.928061789 +0200
@@ -0,0 +1,102 @@
+The Linux WatchDog Timer Driver Core kernel API.
+===============================================
+Last reviewed: 16-Jun-2011
+
+Wim Van Sebroeck <wim@iguana.be>
+
+Introduction
+------------
+This document does not describe what a WatchDog Timer (WDT) Driver or Device is.
+It also does not describe the API which can be used by user space to communicate
+with a WatchDog Timer. If you want to know this then please read the following
+file: Documentation/watchdog/watchdog-api.txt .
+
+So what does this document describe? It describes the API that can be used by
+WatchDog Timer Drivers that want to use the WatchDog Timer Driver Core
+Framework. This framework provides all interfacing towards user space so that
+the same code does not have to be reproduced each time. This also means that
+a watchdog timer driver then only needs to provide the different routines
+(operations) that control the watchdog timer (WDT).
+
+The API
+-------
+Each watchdog timer driver that wants to use the WatchDog Timer Driver Core
+must #include <linux/watchdog.h> (you would have to do this anyway when
+writing a watchdog device driver). This include file contains following
+register/unregister routines:
+
+extern int watchdog_register_device(struct watchdog_device *);
+extern void watchdog_unregister_device(struct watchdog_device *);
+
+The watchdog_register_device routine registers a watchdog timer device.
+The parameter of this routine is a pointer to a watchdog_device structure.
+This routine returns zero on success and a negative errno code for failure.
+
+The watchdog_unregister_device routine deregisters a registered watchdog timer
+device. The parameter of this routine is the pointer to the registered
+watchdog_device structure.
+
+The watchdog device structure looks like this:
+
+struct watchdog_device {
+	char *name;
+	const struct watchdog_ops *ops;
+	long status;
+};
+
+It contains following fields:
+* name: a pointer to the (preferably unique) name of the watchdog timer device.
+* ops: a pointer to the list of watchdog operations that the watchdog supports.
+* status: this field contains a number of status bits that give extra
+  information about the status of the device (Like: is the device opened via
+  the /dev/watchdog interface or not, ...)
+
+The list of watchdog operations is defined as:
+
+struct watchdog_ops {
+	struct module *owner;
+	/* mandatory operations */
+	int (*start)(struct watchdog_device *);
+	int (*stop)(struct watchdog_device *);
+	/* optional operations */
+	int (*ping)(struct watchdog_device *);
+};
+
+It is important that you first define the module owner of the watchdog timer
+driver's operations. This module owner will be used to lock the module when
+the watchdog is active. (This to avoid a system crash when you unload the
+module and /dev/watchdog is still open).
+Some operations are mandatory and some are optional. The mandatory operations
+are:
+* start: this is a pointer to the routine that starts the watchdog timer
+  device.
+  The routine needs a pointer to the watchdog timer device structure as a
+  parameter. It returns zero on success or a negative errno code for failure.
+* stop: with this routine the watchdog timer device is being stopped.
+  The routine needs a pointer to the watchdog timer device structure as a
+  parameter. It returns zero on success or a negative errno code for failure.
+  Some watchdog timer hardware can only be started and not be stopped. The
+  driver supporting this hardware needs to make sure that a start and stop
+  routine is being provided. This can be done by using a timer in the driver
+  that regularly sends a keepalive ping to the watchdog timer hardware.
+  (See Documentation/watchdog/src/watchdog-with-timer-example.c for an
+  example).
+
+Not all watchdog timer hardware supports the same functionality. That's why
+all other routines/operations are optional. They only need to be provided if
+they are supported. These optional routines/operations are:
+* ping: this is the routine that sends a keepalive ping to the watchdog timer
+  hardware.
+  The routine needs a pointer to the watchdog timer device structure as a
+  parameter. It returns zero on success or a negative errno code for failure.
+  Most hardware that does not support this as a separate function uses the
+  start function to restart the watchdog timer hardware. And that's also what
+  the watchdog timer driver core does: to send a keepalive ping to the watchdog
+  timer hardware it will either use the ping operation (when available) or the
+  start operation (when the ping operation is not available).
+
+The status bits should (preferably) be set with the set_bit and clear_bit alike
+bit-operations. The status bit's that are defined are:
+* WDOG_DEV_OPEN: this status bit shows whether or not the watchdog device
+  was opened via /dev/watchdog.
+  (This bit should only be used by the WatchDog Timer Driver Core).
diff -urN linux-2.6.38-orig/drivers/watchdog/core/Kconfig linux-2.6.38-generic-part1/drivers/watchdog/core/Kconfig
--- linux-2.6.38-orig/drivers/watchdog/core/Kconfig	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.38-generic-part1/drivers/watchdog/core/Kconfig	2011-06-16 13:32:00.036062851 +0200
@@ -0,0 +1,30 @@
+#
+# Watchdog timer driver core
+#
+
+if WATCHDOG
+
+config WATCHDOG_CORE
+	tristate "WatchDog Timer Driver Core"
+	depends on EXPERIMENTAL
+	default m
+	---help---
+	  Say Y here if you want to use the new watchdog timer driver core.
+	  This driver provides a framework for all watchdog timer drivers
+	  and gives them the /dev/watchdog interface (and later also the
+	  sysfs interface).
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called watchdog.
+
+config WATCHDOG_DEBUG_CORE
+	bool "WatchDog Timer Driver Core debugging output"
+	depends on WATCHDOG_CORE
+	default n
+	---help---
+	  Say Y here if you want the Watchdog Timer Driver Core to
+	  produce debugging information. Select this if you are having a
+	  problem with the watchdog timer driver core and want to see
+	  more of what is really happening.
+
+endif # WATCHDOG
diff -urN linux-2.6.38-orig/drivers/watchdog/core/Makefile linux-2.6.38-generic-part1/drivers/watchdog/core/Makefile
--- linux-2.6.38-orig/drivers/watchdog/core/Makefile	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.38-generic-part1/drivers/watchdog/core/Makefile	2011-06-16 13:32:00.036062851 +0200
@@ -0,0 +1,6 @@
+#
+# Makefile for the WatchDog Timer Driver Core.
+#
+
+watchdog-objs	+= watchdog_core.o watchdog_dev.o
+obj-$(CONFIG_WATCHDOG_CORE)	+= watchdog.o
diff -urN linux-2.6.38-orig/drivers/watchdog/core/watchdog_core.c linux-2.6.38-generic-part1/drivers/watchdog/core/watchdog_core.c
--- linux-2.6.38-orig/drivers/watchdog/core/watchdog_core.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.38-generic-part1/drivers/watchdog/core/watchdog_core.c	2011-06-16 19:24:39.955179826 +0200
@@ -0,0 +1,132 @@
+/*
+ *	watchdog_core.c
+ *
+ *	(c) Copyright 2008-2011 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
+ *
+ *	(c) Copyright 2008-2011 Wim Van Sebroeck <wim@iguana.be>.
+ *
+ *	This source code is part of the generic code that can be used
+ *	by all the watchdog timer drivers.
+ *
+ *	Based on source code of the following authors:
+ *	  Matt Domsch <Matt_Domsch@dell.com>,
+ *	  Rob Radez <rob@osinvestor.com>,
+ *	  Rusty Lynch <rusty@linux.co.intel.com>
+ *	  Satyam Sharma <satyam@infradead.org>
+ *	  Randy Dunlap <randy.dunlap@oracle.com>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ *
+ *	Neither Alan Cox, CymruNet Ltd., Wim Van Sebroeck nor Iguana vzw.
+ *	admit liability nor provide warranty for any of this software.
+ *	This material is provided "AS-IS" and at no charge.
+ */
+
+/*
+ *	Version information
+ */
+#define DRV_VERSION	"0.01"
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+/*
+ *	Include files
+ */
+#include <linux/module.h>	/* For EXPORT_SYMBOL//module stuff/... */
+#include <linux/types.h>	/* For standard types */
+#include <linux/errno.h>	/* For the -ENODEV/... values */
+#include <linux/kernel.h>	/* For printk/panic/... */
+#include <linux/watchdog.h>	/* For watchdog specific items */
+#include <linux/init.h>		/* For __init/__exit/... */
+
+#include "watchdog_core.h"	/* For watchdog_dev_register/... */
+
+/**
+ *	watchdog_register_device	-	register a watchdog device
+ *	@wdd: watchdog device
+ *
+ *	Register a watchdog device with the kernel so that the
+ *	watchdog timer can be accessed from userspace.
+ *
+ *	A zero is returned on success and a negative errno code for
+ *	failure.
+ */
+int watchdog_register_device(struct watchdog_device *wdd)
+{
+	int ret;
+
+	/* Make sure we have a valid watchdog_device structure */
+	if (wdd == NULL || wdd->ops == NULL)
+		return -ENODATA;
+
+	/* Make sure that the mandatory operations are supported */
+	if (wdd->ops->start == NULL || wdd->ops->stop == NULL)
+		return -ENODATA;
+
+	/* Note: now that all watchdog_device data has been verified, we
+	 * will not check this anymore in other functions. If data get's
+	 * corrupted in a later stage then we expect a kernel panic! */
+
+	/* The future version will have to manage a list of all
+	 * registered watchdog devices. To start we will only
+	 * support 1 watchdog device via the /dev/watchdog interface */
+
+	/* create the /dev/watchdog interface */
+	ret = watchdog_dev_register(wdd);
+	if (ret) {
+		pr_err("error registering /dev/watchdog (err=%d)", ret);
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(watchdog_register_device);
+
+/**
+ *	watchdog_unregister_device	-	unregister a watchdog device
+ *	@wdd: watchdog device to unregister
+ *
+ *	Unregister a watchdog device that was previously successfully
+ *	registered with watchdog_register_device().
+ */
+void watchdog_unregister_device(struct watchdog_device *wdd)
+{
+	int ret;
+
+	/* Make sure we have a valid watchdog_device structure */
+	if (wdd == NULL)
+		return;
+
+	/* The future version will check if this watchdog can be found
+	 * in the list of registered watchdog devices */
+
+	/* remove the /dev/watchdog interface */
+	ret = watchdog_dev_unregister(wdd);
+	if (ret)
+		pr_err("error unregistering /dev/watchdog (err=%d)", ret);
+}
+EXPORT_SYMBOL(watchdog_unregister_device);
+
+static int __init watchdog_init(void)
+{
+	pr_info("Watchdog timer driver core v%s loaded\n", DRV_VERSION);
+	return 0;
+}
+
+static void __exit watchdog_exit(void)
+{
+	pr_info("Watchdog timer driver core unloaded\n");
+}
+
+module_init(watchdog_init);
+module_exit(watchdog_exit);
+
+MODULE_AUTHOR("Alan Cox <alan@lxorguk.ukuu.org.uk>, "
+		"Wim Van Sebroeck <wim@iguana.be>");
+MODULE_DESCRIPTION("WatchDog Timer Driver Core");
+MODULE_VERSION(DRV_VERSION);
+MODULE_LICENSE("GPL");
+MODULE_SUPPORTED_DEVICE("watchdog");
diff -urN linux-2.6.38-orig/drivers/watchdog/core/watchdog_core.h linux-2.6.38-generic-part1/drivers/watchdog/core/watchdog_core.h
--- linux-2.6.38-orig/drivers/watchdog/core/watchdog_core.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.38-generic-part1/drivers/watchdog/core/watchdog_core.h	2011-06-16 13:32:00.036062851 +0200
@@ -0,0 +1,33 @@
+/*
+ *	watchdog_core.h
+ *
+ *	(c) Copyright 2008-2011 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
+ *
+ *	(c) Copyright 2008-2011 Wim Van Sebroeck <wim@iguana.be>.
+ *
+ *	This source code is part of the generic code that can be used
+ *	by all the watchdog timer drivers.
+ *
+ *	Based on source code of the following authors:
+ *	  Matt Domsch <Matt_Domsch@dell.com>,
+ *	  Rob Radez <rob@osinvestor.com>,
+ *	  Rusty Lynch <rusty@linux.co.intel.com>
+ *	  Satyam Sharma <satyam@infradead.org>
+ *	  Randy Dunlap <randy.dunlap@oracle.com>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ *
+ *	Neither Alan Cox, CymruNet Ltd., Wim Van Sebroeck nor Iguana vzw.
+ *	admit liability nor provide warranty for any of this software.
+ *	This material is provided "AS-IS" and at no charge.
+ */
+
+/*
+ *	External functions/procedures
+ */
+extern int watchdog_dev_register(struct watchdog_device *);
+extern int watchdog_dev_unregister(struct watchdog_device *);
diff -urN linux-2.6.38-orig/drivers/watchdog/core/watchdog_dev.c linux-2.6.38-generic-part1/drivers/watchdog/core/watchdog_dev.c
--- linux-2.6.38-orig/drivers/watchdog/core/watchdog_dev.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.38-generic-part1/drivers/watchdog/core/watchdog_dev.c	2011-06-16 19:32:27.183186141 +0200
@@ -0,0 +1,290 @@
+/*
+ *	watchdog_dev.c
+ *
+ *	(c) Copyright 2008-2011 Alan Cox <alan@lxorguk.ukuu.org.uk>,
+ *						All Rights Reserved.
+ *
+ *	(c) Copyright 2008-2011 Wim Van Sebroeck <wim@iguana.be>.
+ *
+ *
+ *	This source code is part of the generic code that can be used
+ *	by all the watchdog timer drivers.
+ *
+ *	This part of the generic code takes care of the following
+ *	misc device: /dev/watchdog.
+ *
+ *	Based on source code of the following authors:
+ *	  Matt Domsch <Matt_Domsch@dell.com>,
+ *	  Rob Radez <rob@osinvestor.com>,
+ *	  Rusty Lynch <rusty@linux.co.intel.com>
+ *	  Satyam Sharma <satyam@infradead.org>
+ *	  Randy Dunlap <randy.dunlap@oracle.com>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ *
+ *	Neither Alan Cox, CymruNet Ltd., Wim Van Sebroeck nor Iguana vzw.
+ *	admit liability nor provide warranty for any of this software.
+ *	This material is provided "AS-IS" and at no charge.
+ */
+
+/*
+ *	Version information
+ */
+#define DRV_VERSION	"0.01"
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+/*
+ *	Include files
+ */
+#include <linux/module.h>	/* For EXPORT_SYMBOL/module stuff/... */
+#include <linux/types.h>	/* For standard types (like size_t) */
+#include <linux/errno.h>	/* For the -ENODEV/... values */
+#include <linux/kernel.h>	/* For printk/panic/... */
+#include <linux/fs.h>		/* For file operations */
+#include <linux/watchdog.h>	/* For watchdog specific items */
+#include <linux/miscdevice.h>	/* For handling misc devices */
+#include <linux/init.h>		/* For __init/__exit/... */
+#include <linux/uaccess.h>	/* For copy_to_user/put_user/... */
+
+/*
+ *	Debugging Macros
+ */
+#ifdef CONFIG_WATCHDOG_DEBUG_CORE
+#define trace(format, args...) \
+	pr_info("%s(" format ")\n", __func__ , ## args)
+#define dbg(format, args...) \
+	pr_info("%s: " format "\n", __func__, ## args)
+#else
+#define trace(format, args...) do { } while (0)
+#define dbg(format, args...) do { } while (0)
+#endif
+
+/*
+ *	Locally used variables
+ */
+
+/* make sure we only register one /dev/watchdog device */
+static unsigned long watchdog_dev_busy;
+/* the watchdog device behind /dev/watchdog */
+static struct watchdog_device *wdd;
+
+/*
+ *	/dev/watchdog operations
+ */
+
+/*
+ *	watchdog_ping: ping the watchdog.
+ *	@wddev: the watchdog device to ping
+ *
+ *	If the watchdog has no own ping operation then it needs to be
+ *	restarted via the start operation. This wrapper function does
+ *	exactly that.
+ */
+
+static int watchdog_ping(struct watchdog_device *wddev)
+{
+	if (wddev->ops->ping)
+		return wddev->ops->ping(wddev);  /* ping the watchdog */
+	else
+		return wddev->ops->start(wddev); /* restart the watchdog */
+}
+
+/*
+ *	watchdog_write: writes to the watchdog.
+ *	@file: file from VFS
+ *	@data: user address of data
+ *	@len: length of data
+ *	@ppos: pointer to the file offset
+ *
+ *	A write to a watchdog device is defined as a keepalive ping.
+ */
+
+static ssize_t watchdog_write(struct file *file, const char __user *data,
+						size_t len, loff_t *ppos)
+{
+	size_t i;
+	char c;
+
+	trace("%p, %p, %zu, %p", file, data, len, ppos);
+
+	if (len == 0)	/* Can we see this even ? */
+		return 0;
+
+	for (i = 0; i != len; i++) {
+		if (get_user(c, data + i))
+			return -EFAULT;
+	}
+
+	/* someone wrote to us, so we sent the watchdog a keepalive ping */
+	watchdog_ping(wdd);
+
+	return len;
+}
+
+/*
+ *	watchdog_open: open the /dev/watchdog device.
+ *	@inode: inode of device
+ *	@file: file handle to device
+ *
+ *	When the /dev/watchdog device get's opened, we start the watchdog.
+ *	Watch out: the /dev/watchdog device is single open, so we make sure
+ *	it can only be opened once.
+ */
+
+static int watchdog_open(struct inode *inode, struct file *file)
+{
+	int err = -EBUSY;
+
+	trace("%p, %p", inode, file);
+
+	/* the watchdog is single open! */
+	if (test_and_set_bit(WDOG_DEV_OPEN, &wdd->status))
+		return -EBUSY;
+
+	/* if the /dev/watchdog device is open, we don't want the module
+	 * to be unloaded. */
+	if (!try_module_get(wdd->ops->owner))
+		goto out;
+
+	/* start the watchdog */
+	err = wdd->ops->start(wdd);
+	if (err < 0)
+		goto out_mod;
+
+	/* dev/watchdog is a virtual (and thus non-seekable) filesystem */
+	return nonseekable_open(inode, file);
+
+out_mod:
+	module_put(wdd->ops->owner);
+out:
+	clear_bit(WDOG_DEV_OPEN, &wdd->status);
+	return err;
+}
+
+/*
+ *      watchdog_release: release the /dev/watchdog device.
+ *      @inode: inode of device
+ *      @file: file handle to device
+ *
+ *	This is the code for when /dev/watchdog get's closed.
+ */
+
+static int watchdog_release(struct inode *inode, struct file *file)
+{
+	int err = -1;
+
+	trace("%p, %p", inode, file);
+
+	/* stop the watchdog */
+	err = wdd->ops->stop(wdd);
+	if (err != 0) {
+		pr_crit("%s: not stopping watchdog!\n", wdd->name);
+		watchdog_ping(wdd);
+	}
+
+	/* Allow the owner module to be unloaded again */
+	module_put(wdd->ops->owner);
+
+	/* make sure that /dev/watchdog can be re-opened */
+	clear_bit(WDOG_DEV_OPEN, &wdd->status);
+
+	return 0;
+}
+
+/*
+ *	/dev/watchdog kernel interfaces
+ */
+
+static const struct file_operations watchdog_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write		= watchdog_write,
+	.open		= watchdog_open,
+	.release	= watchdog_release,
+};
+
+static struct miscdevice watchdog_miscdev = {
+	.minor		= WATCHDOG_MINOR,
+	.name		= "watchdog",
+	.fops		= &watchdog_fops,
+};
+
+/*
+ *	/dev/watchdog register and unregister functions
+ */
+
+/*
+ *	watchdog_dev_register:
+ *	@watchdog: watchdog device
+ *
+ *	Register a watchdog device as /dev/watchdog. /dev/watchdog
+ *	is actually a miscdevice and thus we set it up like that.
+ */
+
+int watchdog_dev_register(struct watchdog_device *watchdog)
+{
+	int err;
+
+	trace("%p", watchdog);
+
+	/* Only one device can register for /dev/watchdog */
+	if (test_and_set_bit(0, &watchdog_dev_busy)) {
+		pr_err("only one watchdog can use /dev/watchdog.\n");
+		return -EBUSY;
+	}
+
+	wdd = watchdog;
+
+	/* Register the miscdevice */
+	dbg("Register a new /dev/watchdog device");
+	err = misc_register(&watchdog_miscdev);
+	if (err != 0) {
+		pr_err("%s: cannot register miscdev on minor=%d (err=%d).\n",
+			watchdog->name, WATCHDOG_MINOR, err);
+		goto out;
+	}
+
+	return 0;
+
+out:
+	wdd = NULL;
+	clear_bit(0, &watchdog_dev_busy);
+	return err;
+}
+EXPORT_SYMBOL(watchdog_dev_register);
+
+/*
+ *	watchdog_dev_unregister:
+ *	@watchdog: watchdog device
+ *
+ *	Deregister the /dev/watchdog device.
+ */
+
+int watchdog_dev_unregister(struct watchdog_device *watchdog)
+{
+	trace("%p", watchdog);
+
+	/* Check that a watchdog device was registered in the past */
+	if (!test_bit(0, &watchdog_dev_busy) || !wdd)
+		return -ENODEV;
+
+	/* We can only unregister the watchdog device that was registered */
+	if (watchdog != wdd) {
+		pr_err("%s: watchdog was not registered as /dev/watchdog.\n",
+			watchdog->name);
+		return -ENODEV;
+	}
+
+	/* Unregister the miscdevice */
+	dbg("Unregister /dev/watchdog device");
+	misc_deregister(&watchdog_miscdev);
+	wdd = NULL;
+	clear_bit(0, &watchdog_dev_busy);
+	return 0;
+}
+EXPORT_SYMBOL(watchdog_dev_unregister);
+
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 39cad45..6ddd312 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -37,6 +37,8 @@ config WATCHDOG_NOWAYOUT
 	  get killed. If you say Y here, the watchdog cannot be stopped once
 	  it has been started.
 
+source "drivers/watchdog/core/Kconfig"
+
 #
 # General Watchdog drivers
 #
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index b2ddff7..e9160eb 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -2,6 +2,8 @@
 # Makefile for the WatchDog device drivers.
 #
 
+obj-$(CONFIG_WATCHDOG)  += core/
+
 # Only one watchdog can succeed. We probe the ISA/PCI/USB based
 # watchdog-cards first, then the architecture specific watchdog
 # drivers and then the architecture independent "softdog" driver.
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index 011bcfe..57a9c70 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -59,6 +59,32 @@ struct watchdog_info {
 #define WATCHDOG_NOWAYOUT	0
 #endif
 
+struct watchdog_ops;
+struct watchdog_device;
+
+/* The watchdog-devices operations */
+struct watchdog_ops {
+	struct module *owner;
+	/* mandatory operations */
+	int (*start)(struct watchdog_device *);
+	int (*stop)(struct watchdog_device *);
+	/* optional operations */
+	int (*ping)(struct watchdog_device *);
+};
+
+/* The structure that defines a watchdog device */
+struct watchdog_device {
+	char *name;
+	const struct watchdog_ops *ops;
+	long status;
+#define WDOG_DEV_OPEN		1	/* is the watchdog opened via
+					 * /dev/watchdog */
+};
+
+/* drivers/watchdog/core/watchdog_core.c */
+extern int watchdog_register_device(struct watchdog_device *);
+extern void watchdog_unregister_device(struct watchdog_device *);
+
 #endif	/* __KERNEL__ */
 
 #endif  /* ifndef _LINUX_WATCHDOG_H */

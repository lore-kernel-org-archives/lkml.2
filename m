Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab0E2Nlz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 09:41:55 -0400
Received: from misc-148-66-126-238.pool.starband.net ([148.66.126.238]:44091
	"EHLO archaeopteryx.synaptics.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756480Ab0E2Nlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 09:41:49 -0400
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Input <linux-input@vger.kernel.org>,
       Christopher Heiny <cheiny@synaptics.com>,
       Allie Xiong <axiong@synaptics.com>,
       William Manson <wmanson@synaptics.com>,
       Joerie de Gram <j.de.gram@gmail.com>,
       William Manson <WManson@synaptics.com>
Subject: [RFC PATCH 1/1] input/touchscreen: Synaptics Touchscreen Driver
Date: Fri, 28 May 2010 17:29:40 -0700
Message-Id: <1275092980-29208-2-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1275092980-29208-1-git-send-email-cheiny@synaptics.com>
References: <1275092980-29208-1-git-send-email-cheiny@synaptics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initial driver for Synaptics touchscreens using RMI4 protocol.

Signed-off-by: William Manson <WManson@synaptics.com>
Signed-off-by: Allie Xiong <axiong@synaptics.com>
Signed-off-by: Christopher Heiny <cheiny@synaptics.com>
---

 drivers/input/touchscreen/Kconfig            |   13 +
 drivers/input/touchscreen/Makefile           |    1 +
 drivers/input/touchscreen/rmi.h              |  206 ++++++++
 drivers/input/touchscreen/rmi_app_touchpad.c |  400 +++++++++++++++
 drivers/input/touchscreen/rmi_core.c         |  708 ++++++++++++++++++++++++++
 drivers/input/touchscreen/rmi_core.h         |   58 +++
 drivers/input/touchscreen/rmi_function_11.c  |  438 ++++++++++++++++
 drivers/input/touchscreen/rmi_function_11.h  |   43 ++
 drivers/input/touchscreen/rmi_functions.h    |  111 ++++
 drivers/input/touchscreen/rmi_i2c.h          |   51 ++
 drivers/input/touchscreen/rmi_i2c_gta01.c    |  117 +++++
 drivers/input/touchscreen/rmi_phys_i2c.c     |  578 +++++++++++++++++++++
 12 files changed, 2724 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 8a8fa4d..ebd3abf 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -307,6 +307,19 @@ config TOUCHSCREEN_MIGOR
 	  To compile this driver as a module, choose M here: the
 	  module will be called migor_ts.
 
+config TOUCHSCREEN_SYNAPTICS_RMI4_I2C
+	tristate "Synaptics RMI4 I2C touchscreens"
+	depends on I2C
+	help
+	  Say Y here if you have a Synaptics RMI4 I2C touchscreen connected to
+	  your system. This enables support for Synaptics RMI4 over I2C based
+	  touchscreens.
+
+	  If unsure, say N.
+
+	  To compile this driver as a set of modules, choose M here: the
+	  modules will be called rmi, rmi_app_touchpad, rmi_phys_i2c.
+
 config TOUCHSCREEN_TOUCHRIGHT
 	tristate "Touchright serial touchscreen"
 	select SERIO
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 7fef7d5..d76bca4 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_TOUCHSCREEN_USB_COMPOSITE)	+= usbtouchscreen.o
 obj-$(CONFIG_TOUCHSCREEN_PCAP)		+= pcap_ts.o
 obj-$(CONFIG_TOUCHSCREEN_PENMOUNT)	+= penmount.o
 obj-$(CONFIG_TOUCHSCREEN_S3C2410)	+= s3c2410_ts.o
+obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_RMI4_I2C)	+= rmi_core.o rmi_app_touchpad.o rmi_function_11.o rmi_phys_i2c.o rmi_i2c_gta01.o
 obj-$(CONFIG_TOUCHSCREEN_TOUCHIT213)	+= touchit213.o
 obj-$(CONFIG_TOUCHSCREEN_TOUCHRIGHT)	+= touchright.o
 obj-$(CONFIG_TOUCHSCREEN_TOUCHWIN)	+= touchwin.o
diff --git a/drivers/input/touchscreen/rmi.h b/drivers/input/touchscreen/rmi.h
new file mode 100755
index 0000000..7cec9b8
--- /dev/null
+++ b/drivers/input/touchscreen/rmi.h
@@ -0,0 +1,206 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) Header File.
+ * Copyright (c) 2007 - 2010, Synaptics Incorporated
+ *
+ *
+ */
+/*
+ * This file is licensed under the GPL2 license.
+ *
+ *#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ *#############################################################################
+ */
+
+#ifndef _RMI_H
+#define _RMI_H
+
+/*  RMI4 Protocol Support
+ */
+
+/* For each function present on the RMI device, we need to get the RMI4 Function
+ * Descriptor info from the Page Descriptor Table. This will give us the
+ * addresses for Query, Command, Control, Data and the Source Count (number
+ * of sources for this function) and the function id.
+ */
+struct rmi_function_descriptor {
+	unsigned char queryBaseAddr;
+	unsigned char commandBaseAddr;
+	unsigned char controlBaseAddr;
+	unsigned char dataBaseAddr;
+	unsigned char interruptSrcCnt;
+	unsigned char functionNum;
+};
+
+/* For each function present on the RMI device, there will be a corresponding
+ * entry in the functions list of the rmi_module_info structure.  This entry
+ * gives information about the number of data sources and the number of data
+ * registers associated with the function.
+ */
+struct rmi_function_info {
+	unsigned char functionNum;
+
+	/* This is the number of data sources associated with the function.*/
+	unsigned char numSources;
+
+	/* This is the number of data points supported - for example, for
+	*  function $11 (2D sensor) the number of data points is equal to the
+	*  number of fingers - for function $19 (buttons)it is the number of
+	*  buttons.
+	*/
+	unsigned char numDataPoints;
+
+	/* This is the number of data registers to read.*/
+	unsigned char dataRegBlockSize;
+
+	/* This is the interrupt register and mask - needed for enabling the
+	*  interrupts and for checking what source had caused the attention line
+	* interrupt.
+	*/
+	unsigned char interruptRegister;
+	unsigned char interruptMask;
+
+	/* This is the RMI function descriptor associated with this function.
+	*  It contains the Base addresses for the functions query, command,
+	*  control, and data registers.
+	*/
+	struct rmi_function_descriptor funcDescriptor;
+
+	/* A list of the function information.
+	*  This list uses the standard kernel linked list implementation.
+	*  Documentation on on how to use it can be found at
+	*  http://isis.poly.edu/kulesh/stuff/src/klist/.
+	*/
+	struct list_head link;
+};
+
+/*  This encapsulates the information found using the RMI4 Function $01
+ *  query registers. There is only one Function $01 per device.
+ *
+ *  Assuming appropriate endian-ness, you can populate most of this
+ *  structure by reading query registers starting at the query base address
+ *  that was obtained from RMI4 function 0x01 function descriptor info read
+ *  from the Page Descriptor Table.
+ *
+ *  Specific register information is provided in the comments for each field.
+ *  For further reference, please see the "Synaptics RMI 4 Interfacing
+ *  Guide" document : go to http://www.synaptics.com/developers/manuals - and
+ *  select "Synaptics RMI 4 Interfacting Guide".
+ */
+struct rmi_module_info {
+	/* The Protocol Major Version number.*/
+	unsigned rmi_maj_ver;
+
+	/* The Protocol Minor Version number.*/
+	unsigned rmi_min_ver;
+
+	/* The manufacturer identification byte.*/
+	unsigned char mfgid;
+
+	/* The Product Properties information.*/
+	unsigned char properties;
+
+	/* The product info bytes.*/
+	unsigned char prod_info[2];
+
+	/* Date Code - Year, Month, Day.*/
+	unsigned char date_code[3];
+
+	/* Tester ID (14 bits).*/
+	unsigned short tester_id;
+
+	/* Serial Number (14 bits).*/
+	unsigned short serial_num;
+
+	/* A null-terminated string that identifies this particular product.*/
+	char prod_id[10];
+
+	/* A list of the function presence queries.
+	*  This list uses the standard kernel linked list implementation.
+	*  Documentation on on how to use it can be found at
+	*  http://isis.poly.edu/kulesh/stuff/src/klist/.
+	*/
+	struct list_head functions;
+};
+
+struct rmi_phys_driver {
+	char *name;
+	int (*write)(struct rmi_phys_driver *pd, unsigned short address,
+			char data);
+	int (*read)(struct rmi_phys_driver *pd, unsigned short address,
+			char *buffer);
+	int (*write_multiple)(struct rmi_phys_driver *pd,
+			unsigned short address, char *buffer, int length);
+	int (*read_multiple)(struct rmi_phys_driver *pd, unsigned short address,
+			char *buffer, int length);
+	void (*attention)(struct rmi_phys_driver *pd, int instance);
+	bool polling_required;
+	int irq;
+
+	/* Standard kernel linked list implementation.
+	*  Documentation on how to use it can be found at
+	*  http://isis.poly.edu/kulesh/stuff/src/klist/.
+	*/
+	struct list_head drivers;
+	struct rmi_application *app;
+	struct rmi_module_info rmi;
+	struct module *module;
+};
+
+int rmi_read(struct rmi_application *app, unsigned short address, char *dest);
+int rmi_write(struct rmi_application *app, unsigned short address,
+		unsigned char data);
+int rmi_read_multiple(struct rmi_application *app, unsigned short address,
+		char *dest, int length);
+int rmi_write_multiple(struct rmi_application *app, unsigned short address,
+		unsigned char *data, int length);
+int rmi_register_phys_driver(struct rmi_phys_driver *rpd);
+int rmi_unregister_phys_driver(struct rmi_phys_driver *rpd);
+
+struct rmi_application *rmi_register_application(const char *name,
+	void (*attention)(struct rmi_phys_driver *pd, int instance),
+	int (*probe)(struct rmi_application *app,
+	const struct rmi_module_info *rmi),
+	void (*config)(struct rmi_application *app));
+
+void rmi_unregister_application(struct rmi_application *app);
+bool rmi_polling_required(struct rmi_application *app);
+
+/* Set this to 1 to turn on code used in detecting buffer leaks. */
+#define RMI_ALLOC_STATS 1
+
+#if RMI_ALLOC_STATS
+extern int appallocsrmi;
+extern int rfiallocsrmi;
+extern int fnallocsrmi;
+
+#define INC_ALLOC_STAT(X)   (X##allocsrmi++)
+#define DEC_ALLOC_STAT(X)   \
+	do { \
+		if (X##allocsrmi) X##allocsrmi--; \
+		else printk(KERN_DEBUG "Too many " #X " frees\n"); \
+	} while (0)
+#define CHECK_ALLOC_STAT(X) \
+	do { \
+		if (X##allocsrmi) \
+			printk(KERN_DEBUG "Left over " #X " buffers: %d\n", \
+					X##allocsrmi); \
+	} while (0)
+#else
+#define INC_ALLOC_STAT(X) do { } while (0)
+#define DEC_ALLOC_STAT(X) do { } while (0)
+#define CHECK_ALLOC_STAT(X) do { } while (0)
+#endif
+
+#endif
diff --git a/drivers/input/touchscreen/rmi_app_touchpad.c b/drivers/input/touchscreen/rmi_app_touchpad.c
new file mode 100755
index 0000000..5f3bd81
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_app_touchpad.c
@@ -0,0 +1,400 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) TouchPad Application Layer Driver.
+ * Copyright (c) 2007 - 2010, Synaptics Incorporated
+ *
+ *
+ * This code implements a polling mechanism using a timer as well as
+ * interrupt-driven sampling.
+ *
+ * Note that it is the lower-level drivers that determine whether this driver
+ * has to do polling or interrupt-driven.  Polling can always be done, but if
+ * we have an interrupt connected to the attention (ATTN) line, then it is
+ * better to be interrupt driven.
+ *
+ */
+/*
+ * This file is licensed under the GPL2 license.
+ *
+ *#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ *#############################################################################
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/hrtimer.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+
+#include "rmi.h"
+#include "rmi_core.h"
+#include "rmi_functions.h"
+
+#define RMI_REPORT_RATE_80 0
+#define RMI_REPORT_RATE_40 (1 << 6)
+
+static long polltime = 25000000;
+module_param(polltime, long, 0644);
+MODULE_PARM_DESC(polltime, "How long to wait between polls (in nano seconds).");
+
+static struct rmi_application *app;
+
+/* TODO: We should move this to the application data struct and allow more than
+	one input device per system. We'll address in a follow up patch. */
+static struct input_dev *input;
+
+/* RMI4 device control == function 0x01 */
+extern unsigned short fn01ControlBaseAddr;
+/* number of total interrupt registers to read */
+extern unsigned int interruptRegisterCount;
+
+
+/**
+ * This is the function we pass to the RMI4 subsystem so we can be notified
+ * when attention is required.  It may be called in interrupt context.
+ */
+static void attention(struct rmi_phys_driver *rpd, int instance)
+{
+	/* All we have to do is schedule work. */
+	schedule_work(&(rpd->app->work));
+}
+
+/**
+ * This is the meat of the driver.  It reads in all data sources and reports
+ * them to the input subsystem.  It is used for both polling and interrupt
+ * driven operation.
+ */
+int report_sensor_data(struct rmi_application *app)
+{
+	unsigned char interruptStatus[4] = {0, 0, 0, 0};
+	int touch; /* number of touch points - fingers or buttons */
+	struct rmi_functions *fn;
+	struct rmi_function_info *rfi;
+	struct rmi_phys_driver *rpd;
+	struct rmi_module_info *rmi;
+	static int num_error_reports;
+
+	touch = 0;
+
+	/* Get the interrupt status from the function $01 control register+1 to
+	find which source(s) were interrupting so we can read the data from the
+	source(s) (2D sensor, buttons, etc.).
+	*/
+	if (rmi_read_multiple(app, fn01ControlBaseAddr + 1,
+			interruptStatus, interruptRegisterCount)) {
+		printk(KERN_ERR "%s: Could not read interrupt status registers 0x%x\n",
+				__func__, fn01ControlBaseAddr + 1);
+		return 0;
+	}
+
+	/* check each function that has data sources and if the interrupt for
+	 * that triggered then call that RMI4 functions report() function to
+	 * gather data and report it to the input subsystem */
+	rpd = app->rpd; /* get ptr to rmi_physical_driver from app */
+	rmi = &(rpd->rmi); /* get ptr to rmi_module_info from physical driver */
+
+	list_for_each_entry(rfi, &rmi->functions, link) {
+		if (rfi->numSources) {
+			if (interruptStatus[rfi->interruptRegister] &
+					rfi->interruptMask) {
+				bool found;
+				found = false;
+				fn = rmi_find_function(rfi->functionNum);
+				if (fn) {
+					found = true;
+					if (fn->report) {
+						touch = fn->report(app,
+							rfi, fn->input);
+					} else {
+						num_error_reports++;
+						if (num_error_reports < 6) {
+							/* the developer did not add in the
+							pointer to the report function into
+							rmi4_supported_data_src_functions */
+							printk(KERN_ERR "%s: no find report function for function 0x%x\n", __func__, fn->functionNum);
+						}
+					}
+				}
+
+				if (!found) {
+					num_error_reports++;
+					if (num_error_reports < 6) {
+						/* if no support found for this
+						RMI4 function it means the
+						developer did not add the
+						appropriate function pointer
+						list into the rmi4_supported_data_src_functions
+						array and/or did not bump up
+						the number of supported RMI4
+						functions in rmi.h as required.
+						*/
+						printk(KERN_ERR "%s: could not find any support for function 0x%x\n", __func__, fn->functionNum);
+					}
+				}
+			}
+		}
+	}
+
+	/* return the number of touch points - fingers down and/or buttons
+	 * pressed, etc. */
+	return touch;
+}
+
+/* This is the worker function  - it simply has to call report_sensor_data. */
+static void ts_work_func(struct work_struct *work)
+{
+	struct  rmi_application *app = container_of(work,
+			struct rmi_application, work);
+
+	report_sensor_data(app);
+
+	/* we only need to enable the irq if doing interrupts */
+	if (!rmi_polling_required(app))
+		enable_irq(app->rpd->irq);
+}
+
+/* This is the timer function for polling - it simply has to schedule work
+ * and restart the timer. */
+static enum hrtimer_restart ts_poll_timer_func(struct hrtimer *timer)
+{
+	struct  rmi_application *app = container_of(timer,
+			struct rmi_application, timer);
+
+	schedule_work(&app->work);
+	hrtimer_start(&app->timer, ktime_set(0, polltime), HRTIMER_MODE_REL);
+	return HRTIMER_NORESTART;
+}
+
+/**
+ * This is the probe function passed to the RMI4 subsystem that gives us a
+ * chance to recognize an RMI4 device.  In this case, we're looking for
+ * Synaptics devices that have data sources - such as touch screens, buttons,
+ * etc.
+ */
+static int probe(struct rmi_application *app,
+		const struct rmi_module_info *rmi)
+{
+	struct rmi_function_info *rfi;
+	int data_sources = 0;
+	int retval = 0;
+
+	if (!rmi) {
+		printk(KERN_ERR "%s: Invalid module info: %p\n", __func__, rmi);
+		return 0;
+	}
+
+	/* Check if this is a Synaptics device - report if not. */
+	if (rmi->mfgid != 1) { /* Synaptics? */
+		printk(KERN_INFO "%s: non-Synaptics mfg id: %d\n",
+				__func__, rmi->mfgid);
+	}
+
+	/* for each function entry in the list accumulate it's number of data
+	sources */
+	list_for_each_entry(rfi, &rmi->functions, link) {
+		data_sources += rfi->numSources;
+	}
+
+	if (data_sources) {
+		retval = 1;
+		/* We have detected one or more data sources such as
+		2D Sensors, buttons, etc. */
+		printk(KERN_INFO "%s: Found %d data sources for : %p\n",
+				__func__, data_sources, rmi);
+	} else {
+		/* we don't have any data sources for this sensor - oops!
+		- either an un-flashed sensor or bad!! */
+		printk(KERN_INFO "%s: No data sources found for : %p\n",
+				__func__, rmi);
+	}
+
+	return retval;
+}
+
+static void config(struct rmi_application *app)
+{
+	/* For each data source we had detected print info and set up interrupts
+	or polling. */
+	struct rmi_function_info *rfi;
+	struct rmi_phys_driver *rpd;
+	struct rmi_module_info *rmi;
+
+	rpd = app->rpd; /* get ptr to rmi_physical_driver from app */
+	rmi = &(rpd->rmi); /* get ptr to rmi_module_info from physical driver */
+
+	list_for_each_entry(rfi, &rmi->functions, link) {
+		if (rfi->numSources) {
+			/* This function has data sources associated with it.*/
+			/* Get and print some info about the data sources... */
+			struct rmi_functions *fn;
+			bool found = false;
+			/* check if function number matches - if so call that
+			config function */
+			fn = rmi_find_function(rfi->functionNum);
+			if (fn) {
+				found = true;
+				if (fn->config) {
+					fn->config(app, rfi);
+				} else {
+					/* the developer did not add in the
+					pointer to the config function into
+					rmi4_supported_data_src_functions */
+					printk(KERN_ERR
+						"%s: no config function for "
+						"function 0x%x\n",
+						__func__, rfi->functionNum);
+					break;
+				}
+			}
+
+			if (!found) {
+				/* if no support found for this RMI4 function
+				it means the developer did not add the
+				appropriate function pointer list into the
+				rmi4_supported_data_src_functions array and/or
+				did not bump up the number of supported RMI4
+				functions in rmi.h as required */
+				printk(KERN_ERR"%s: could not find support "
+					"for function 0x%x\n",
+					__func__, rfi->functionNum);
+			}
+
+			/* if we are not doing polling then enable the
+			interrupts for the data sources for this function */
+			if (!rmi_polling_required(app)) {
+				/* Turn on interrupts for this
+				function's data sources. */
+				rmi_write(app, fn01ControlBaseAddr + 1 +
+						rfi->interruptRegister,
+						rfi->interruptMask);
+				printk(KERN_INFO
+					"%s: Interrupt Driven - turning on "
+					"interrupts for function 0x%x\n",
+					__func__, rfi->functionNum);
+			}
+		}
+	}
+
+	/* if we are not polling we need to set up the interrupt worker
+	thread - otherwise we need to set up the polling callback and
+	worker thread. */
+	if (!rmi_polling_required(app)) {
+		/* We're interrupt driven, so set up packet rate and the worker
+		thread function. */
+		if (HZ < 500) {
+			/* The default packet rate of 80 packets per
+			* second is too fast (the Linux time slice for
+			* sub-GHz processors is only 100 times per second).
+			* So re-program it to 40 packets per second.
+			*/
+			rmi_write(app, fn01ControlBaseAddr, RMI_REPORT_RATE_40);
+		}
+
+		INIT_WORK(&app->work, ts_work_func);
+
+	} else {
+		/* We're polling driven, so set up the polling timer
+		and timer function. */
+		INIT_WORK(&app->work, ts_work_func);
+		hrtimer_init(&app->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		app->timer.function = ts_poll_timer_func;
+		hrtimer_start(&app->timer, ktime_set(1, 0), HRTIMER_MODE_REL);
+	}
+}
+
+/**
+ * The module initialization function in which we register as a RMI4
+ * application driver.  We also register with the input subsystem so we can
+ * pass coordinates to it.
+ */
+static int __init rmi_app_touchpad_init(void)
+{
+	int retval;
+
+	retval = 0;
+
+	pr_debug("%s: RMI4 TouchPad Driver\n", __func__);
+
+	/* NOTE: we are creating only one input dev file for this but
+	theoretically you could create a separate one for each data
+	source and store it below. This will let you put 2D sensor
+	events into one dev file, button events into a separate dev file,
+	other data source event like GPIOs, etc. into yet a third dev file.
+	As this is being coded it will dump all events into the one dev file.
+	*/
+	input = input_allocate_device();
+	if (input == NULL) {
+		printk(KERN_ERR "%s:  Failed to allocate memory for a "
+			"new input device.\n",
+			__func__);
+		return -ENOMEM;
+	}
+
+	input->name = "RMI4 Touchpad";
+	input->phys = "rmi_app_touchpad";
+
+	/* Set input device specific params for each data source...*/
+	retval = rmi_functions_init(input);
+
+	if (retval) {
+		printk(KERN_ERR "%s:  Failed rmi_functions_init.\n", __func__);
+		return retval;
+	}
+
+	retval = input_register_device(input);
+
+	if (retval) {
+		printk(KERN_ERR "%s:  Failed input_register_device.\n",
+			__func__);
+		return retval;
+	}
+
+	app = rmi_register_application("rmi4_touchpad",
+		attention, probe, config);
+
+	if (!app) {
+		printk(KERN_ERR "%s:  Failed to register app.\n", __func__);
+		input_unregister_device(input);
+		retval = -ENODEV;
+	}
+
+	return retval;
+}
+
+static void __exit rmi_app_touchpad_exit(void)
+{
+	pr_debug("%s: RMI4 TouchPad Driver\n", __func__);
+
+	/* Stop the polling timer if doing polling */
+	if (rmi_polling_required(app))
+		hrtimer_cancel(&app->timer);
+
+	flush_scheduled_work(); /* Make sure all scheduled work is stopped */
+
+	/* Unregister everything */
+	printk(KERN_WARNING "%s: Unregistering app - %s\n",
+		__func__, app->name);
+	rmi_unregister_application(app);
+	input_unregister_device(input);
+}
+
+module_init(rmi_app_touchpad_init);
+module_exit(rmi_app_touchpad_exit);
+
+MODULE_AUTHOR("Synaptics, Inc.");
+MODULE_DESCRIPTION("RMI4 Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/input/touchscreen/rmi_core.c b/drivers/input/touchscreen/rmi_core.c
new file mode 100755
index 0000000..893619a
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_core.c
@@ -0,0 +1,708 @@
+/**
+ * Synaptics Register Mapped Interface (RMI4) Data Layer Driver.
+ * Copyright (C) 2007 - 2010, Synaptics Incorporated
+ *
+ *
+ * This protocol is layered as follows.
+ *
+ *
+ *  +----------------------------------------+
+ *  |                                        |
+ *  |               Application              |
+ *  |                                        |
+ *  +----------------------------------------+
+ *  |                                        |
+ *  |                RMI4 Driver             | Data Layer (THIS DRIVER)
+ *  |                (this file)             |
+ *  +-----+-----+-------+----------+---------+
+ *  | I2C | SPI | SMBus |         etc.       | Physical Layer
+ *  +-----+-----+-------+----------+---------+
+ *
+ *  Each of the physical layer drivers is contained in a file called
+ *  rmi_phys_xxx.c.  Someone compiling the kernel enables CONFIG_RMI and then
+ *  one or more CONFIG_RMI_xxx options in the .config file.  For example, when
+ *  CONFIG_RMI_I2C=m is enabled, a rmi.ko and a rmi_phys_i2c.ko will be
+ *  compiled.  rmi_phys_i2c.ko will depend on rmi.ko, so when rmi_phys_i2c.ko
+ *  is loaded, rmi.ko will automatically be loaded.  Each of the physical
+ *  layer drivers is a platform_driver that may handle suspend/resume, etc.,
+ *  so this driver does not do so.
+ *
+ *  The register paradigm of RMI is a "pull" rather than "push" data flow.
+ *  As such, it is the application driver that needs to implement either
+ *  polling or interrupt driven, and the physical driver merely handles
+ *  the register accesses.  For interrupt driven, the application registers
+ *  an "attention" function that may be called in interrupt context by the
+ *  physical driver if an attention interrupt is available.  The physical
+ *  driver notifies the application through the polling_required variable,
+ *  and the application driver must do one or the other based on this variable.
+ *
+ *  At this point in time, there can only be one application driver per
+ *  physical driver.
+ *
+ */
+/*
+ * This file is licensed under the GPL2 license.
+ *
+ *#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ *#############################################################################
+ */
+
+static const char drvname[] = "rmi4";
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/hrtimer.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include <linux/delay.h>
+#include <linux/uaccess.h>
+#include <linux/slab.h>
+
+#include "rmi.h"
+#include "rmi_core.h"
+#include "rmi_functions.h"
+
+/* we need these to control the device and query interrupts */
+unsigned short fn01QueryBaseAddr; /* RMI4 device control */
+EXPORT_SYMBOL(fn01QueryBaseAddr);
+unsigned short fn01ControlBaseAddr;
+EXPORT_SYMBOL(fn01ControlBaseAddr);
+unsigned int interruptRegisterCount;
+EXPORT_SYMBOL(interruptRegisterCount);
+
+#define PDT_START_SCAN_LOCATION 0x00E9
+#define PDT_END_SCAN_LOCATION 0x000A
+#define PDT_ENTRY_SIZE 0x0006
+
+static LIST_HEAD(phys_drivers);
+static DEFINE_MUTEX(phys_drivers_mutex);
+static LIST_HEAD(app_drivers);
+static DEFINE_MUTEX(app_drivers_mutex);
+static DEFINE_MUTEX(rfi_mutex);
+static LIST_HEAD(fns_list);
+static DEFINE_MUTEX(fns_mutex);
+
+
+#if RMI_ALLOC_STATS
+int appallocsrmi;
+EXPORT_SYMBOL(appallocsrmi);
+int rfiallocsrmi;
+EXPORT_SYMBOL(rfiallocsrmi);
+int fnallocsrmi;
+EXPORT_SYMBOL(fnallocsrmi);
+#endif
+
+/* NOTE: Developer - add in any new RMI4 fn data info - function number
+   and ptrs to report, config, init and detect functions.  This data is
+   used to point to the functions that need to be called to config, init,
+   detect and report data for the new RMI4 function. These only need to
+   be added for RMI4 functions that support data source - like 2D sensors,
+   buttons, LEDs, GPIOs, etc. Refer to the RMI4 specification for
+   information on these RMI4 functions and what data they report.
+*/
+
+static struct rmi_functions_data
+	rmi4_supported_data_src_functions[rmi4_num_supported_data_src_fns] = {
+	/* Fn $11 */
+	{0x11, FN_11_report, FN_11_config, FN_11_init, FN_11_detect},
+	/* Fn $19 */
+	/* {0x19, FN_19_report, FN_19_config, FN_19_init, FN_19_detect), */
+};
+
+
+int rmi_read(struct rmi_application *app, unsigned short address, char *dest)
+{
+	struct rmi_phys_driver *rpd = app->rpd;
+	if (!app->rpd)
+		return -ENODEV;
+	return rpd->read(rpd, address, dest);
+}
+EXPORT_SYMBOL(rmi_read);
+
+int rmi_write(struct rmi_application *app, unsigned short address,
+		unsigned char data)
+{
+	struct rmi_phys_driver *rpd = app->rpd;
+	if (!app->rpd)
+		return -ENODEV;
+	return rpd->write(rpd, address, data);
+}
+EXPORT_SYMBOL(rmi_write);
+
+int rmi_read_multiple(struct rmi_application *app, unsigned short address,
+		char *dest, int length)
+{
+	struct rmi_phys_driver *rpd = app->rpd;
+	if (!app->rpd)
+		return -ENODEV;
+	return rpd->read_multiple(rpd, address, dest, length);
+}
+EXPORT_SYMBOL(rmi_read_multiple);
+
+int rmi_write_multiple(struct rmi_application *app, unsigned short address,
+		unsigned char *data, int length)
+{
+	struct rmi_phys_driver *rpd = app->rpd;
+	if (!app->rpd)
+		return -ENODEV;
+	return rpd->write_multiple(rpd, address, data, length);
+}
+EXPORT_SYMBOL(rmi_write_multiple);
+
+bool rmi_polling_required(struct rmi_application *app)
+{
+	return app->polling_required;
+}
+EXPORT_SYMBOL(rmi_polling_required);
+
+/* This function searches for a match between an app driver and physical
+ * driver and binds them together.
+ */
+static void match_and_bind(struct rmi_application *app,
+		struct rmi_phys_driver *rpd)
+{
+	app->polling_required = rpd->polling_required;
+
+	if (app->probe(app, &rpd->rmi)) {
+		/* Found a match, bind them together. */
+		/* The try_module_get() makes sure that the physical
+		* driver cannot be unloaded while a app driver is
+		* using it.
+		*/
+		if (try_module_get(rpd->module)) {
+			app->rpd = rpd;
+			rpd->app = app;
+			printk(KERN_INFO "%s: %s is %s bound to %s\n",
+				__func__, drvname, app->name, rpd->name);
+			rpd->attention = app->attention;
+			app->config(app);
+		}
+	} else {
+		app->polling_required = false;
+	}
+}
+
+/* This function is here to provide a way for external modules to access the
+ * functions list.  It will try to find a matching function base on the passed
+ * in RMI4 function number and return  the pointer to the struct rmi_functions
+ * if a match is found or NULL if not found.
+ */
+struct rmi_functions *rmi_find_function(int functionNum)
+{
+	struct rmi_functions *fn;
+	bool found = false;
+
+	list_for_each_entry(fn, &fns_list, link) {
+		if (functionNum == fn->functionNum) {
+			found = true;
+			break;
+		}
+	}
+
+	if (!found)
+		return NULL;
+	else
+		return fn;
+}
+EXPORT_SYMBOL(rmi_find_function);
+
+/* This function calls init for all of the functions on the functions list and
+ * passes in the input_dev ptr so that each fn can store it for later use.
+ */
+int rmi_functions_init(struct input_dev *inputdev)
+{
+	int retval = 0;
+	struct rmi_functions *fn;
+
+	/* Set input device specific params for each data source...*/
+	list_for_each_entry(fn, &fns_list, link) {
+		if (fn->init) {
+			/* store the input_dev ptr for use later */
+			fn->input = inputdev;
+			retval = fn->init(fn->input);
+		} else {
+			/* the developer did not add in the pointer to the init
+			function into rmi4_supported_data_src_functions */
+			printk(KERN_ERR
+				"%s: No init function for function 0x%x\n",
+				__func__, fn->functionNum);
+		}
+	}
+
+	return retval;
+}
+EXPORT_SYMBOL(rmi_functions_init);
+
+int rmi_register_phys_driver(struct rmi_phys_driver *rpd)
+{
+	struct rmi_application *app;
+	int i;
+	unsigned char std_queries[21];
+	unsigned char interruptCount;
+	struct rmi_function_info *rfi;
+	struct rmi_function_descriptor rmi_fd;
+	struct rmi_functions *fn;
+	bool found;
+	int retval;
+
+	if (!rpd->name) {
+		printk(KERN_ERR "%s: %s: Physical driver must specify a name\n",
+			__func__, drvname);
+		return -EINVAL;
+	}
+	if (!rpd->write) {
+		printk(KERN_ERR
+			"%s: %s: Physical driver %s must specify a writer.\n",
+			__func__, drvname, rpd->name);
+		return -EINVAL;
+	}
+	if (!rpd->read) {
+		printk(KERN_ERR
+			"%s: %s: Physical driver %s must specify a reader.\n",
+			__func__, drvname, rpd->name);
+		return -EINVAL;
+	}
+	if (!rpd->write_multiple) {
+		printk(KERN_ERR "%s: %s: Physical driver %s must specify a "
+			"multiple writer.\n",
+			__func__, drvname, rpd->name);
+		return -EINVAL;
+	}
+	if (!rpd->read_multiple) {
+		printk(KERN_ERR "%s: %s: Physical driver %s must specify a "
+			"multiple reader.\n",
+			__func__, drvname, rpd->name);
+		return -EINVAL;
+	}
+	if (!rpd->module) {
+		printk(KERN_ERR
+			"%s: %s: Physical driver %s must specify a module.\n",
+			__func__, drvname, rpd->name);
+		return -EINVAL;
+	}
+
+	pr_debug("%s: %s: Registering phys driver %s\n",
+			__func__, drvname, rpd->name);
+
+	rpd->attention = 0;
+
+	/* Get some information from the device */
+	{
+		pr_debug("%s: Functions:\n", __func__);
+
+		interruptCount = 0;
+
+		/* init the physical drivers RMI module
+		info list of functions */
+		INIT_LIST_HEAD(&rpd->rmi.functions);
+
+		/* Read the Page Descriptor Table to determine what functions
+		are present */
+		for (i = PDT_START_SCAN_LOCATION;
+				i > PDT_END_SCAN_LOCATION;
+				i -= PDT_ENTRY_SIZE) {
+			retval = rpd->read_multiple(rpd, i, (char *)&rmi_fd,
+					sizeof(rmi_fd));
+			if (!retval) {
+				rfi = NULL;
+
+				if (rmi_fd.functionNum) {
+					switch (rmi_fd.functionNum & 0xff) {
+					case 0x01:
+						pr_debug("%s:   Fn $01 Found - RMI Device Control\n", __func__);
+						/* Save Fn $01 query and control base addresses since
+						we'll need them later to get/set properties and check
+						interrupts.  There is only one Fn $01 for the device
+						that is used to control and query device specific info
+						so we only need to save it globally here for later use.
+						*/
+						fn01QueryBaseAddr =
+							rmi_fd.queryBaseAddr;
+						fn01ControlBaseAddr =
+							rmi_fd.controlBaseAddr;
+					break;
+
+					default:
+						if (rmi_fd.interruptSrcCnt) {
+							rfi = kmalloc(sizeof(*rfi), GFP_KERNEL);
+
+							if (!rfi) {
+								printk(KERN_ERR "%s: %s: could not allocate memory for function 0x%x\n",
+									__func__, drvname, rmi_fd.functionNum);
+								retval = -ENOMEM;
+								goto exit_fail;
+							} else {
+								INC_ALLOC_STAT(rfi);
+
+								/* Get the ptr to the detect function based on
+								the function number */
+								found = false;
+								list_for_each_entry(fn, &fns_list, link) {
+									/* check if function number matches - if so
+									call that detect function */
+									if (fn->functionNum == rmi_fd.functionNum) {
+										found = true;
+										fn->detect(rpd->app, rfi, &rmi_fd,
+												interruptCount);
+									}
+								}
+
+								if (!found) {
+									printk(KERN_ERR "%s: %s: could not find support for function 0x%x\n",
+										__func__, drvname, rmi_fd.functionNum);
+								}
+							}
+						} else {
+							printk(KERN_INFO "%s: %s: Found Function %02x - Ignored.\n", __func__, drvname, rmi_fd.functionNum & 0xff);
+						}
+						break;
+					}
+
+					/* bump interrupt count for
+					next iteration */
+					interruptCount +=
+						(rmi_fd.interruptSrcCnt & 0x7);
+
+					/* We only want to add functions
+					to the list that have
+					data associated with them. */
+					if (rfi && rmi_fd.interruptSrcCnt) {
+						pr_debug("%s: Adding function "
+						"0x%x with %d sources.\n",
+						drvname, rfi->functionNum,
+						rfi->numSources);
+
+						/* link this function info to
+						the RMI module infos list
+						of functions */
+						mutex_lock(&rfi_mutex);
+						list_add_tail(&rfi->link,
+							&rpd->rmi.functions);
+						mutex_unlock(&rfi_mutex);
+					}
+				} else {
+					/* A zero in the function number
+					signals the end of the PDT */
+					pr_debug("%s:   Found End of PDT\n",
+						__func__);
+					break;
+				}
+			} else {
+				/* failed to read next PDT entry - end PDT
+				scan - this may result in an incomplete set
+				of recognized functions - should probably
+				return an error but the driver may still be
+				viable for diagnostics and debugging so let's
+				let it continue. */
+				printk(KERN_ERR "%s: %s: Read Error 0x%x when "
+					"reading next PDT entry - "
+					"ending PDT scan.\n",
+					__func__, drvname, retval);
+				break;
+			}
+		}
+
+		/* calculate the interrupt register count - used in the
+		ISR to read the correct number of interrupt registers */
+		interruptRegisterCount = (interruptCount + 7) / 8;
+
+		/* Function $01 will be used to query the product properties,
+		and product ID  so we had to read the PDT above first to get
+		the Fn $01 query address and prior to filling in the product
+		info. NOTE: Even an unflashed device will still have FN $01.
+		*/
+
+		/* Load up the standard queries and get the RMI4 module info */
+		retval = rpd->read_multiple(rpd, fn01QueryBaseAddr, std_queries,
+				sizeof(std_queries));
+		if (retval) {
+			printk(KERN_ERR "%s: %s: Failed reading queries\n",
+				__func__, drvname);
+			retval = -EIO;
+			goto exit_fail;
+		}
+
+		/* Currently supported RMI version is 4.0 */
+		rpd->rmi.rmi_maj_ver  = 4;
+		rpd->rmi.rmi_min_ver  = 0;
+
+		/* get manufacturer id, properties, product info,
+		date code, tester id, serial num and product id (name) */
+		rpd->rmi.mfgid        = std_queries[0];
+		rpd->rmi.properties   = std_queries[1];
+
+		rpd->rmi.prod_info[0] = std_queries[2];
+		rpd->rmi.prod_info[1] = std_queries[3];
+
+		/* year - 2001-2032 */
+		rpd->rmi.date_code[0] = std_queries[4] & 0x1f;
+		/* month - 1-12 */
+		rpd->rmi.date_code[1] = std_queries[5] & 0x0f;
+		/* day - 1-31 */
+		rpd->rmi.date_code[2] = std_queries[6] & 0x1f;
+
+		rpd->rmi.tester_id = ((std_queries[7] & 0x7f) << 8) |
+			(std_queries[8] & 0x7f);
+
+		rpd->rmi.serial_num = ((std_queries[9] & 0x7f) << 8) |
+		(std_queries[10] & 0x7f);
+
+		memcpy(rpd->rmi.prod_id, &std_queries[11], 10);
+		rpd->rmi.prod_id[10] = 0;
+
+		pr_debug("%s: RMI Protocol: %d.%d\n",
+			__func__, rpd->rmi.rmi_maj_ver, rpd->rmi.rmi_min_ver);
+		pr_debug("%s: Manufacturer: %d", __func__,
+			rpd->rmi.mfgid);
+
+		if (rpd->rmi.mfgid == 1)
+			pr_debug(" (Synaptics)");
+		pr_debug("\n");
+
+		pr_debug("%s: Properties: 0x%x\n",
+			__func__, rpd->rmi.properties);
+		pr_debug("%s: Product Info: 0x%x 0x%x\n",
+			__func__, rpd->rmi.prod_info[0], rpd->rmi.prod_info[1]);
+		pr_debug("%s: Date Code: Year : %d Month: %d Day: %d\n",
+			__func__, rpd->rmi.date_code[0], rpd->rmi.date_code[1],
+			rpd->rmi.date_code[2]);
+		pr_debug("%s: Tester ID: %d\n", __func__, rpd->rmi.tester_id);
+		pr_debug("%s: Serial Number: 0x%x\n",
+			__func__, rpd->rmi.serial_num);
+		pr_debug("%s: Product ID: %s\n", __func__, rpd->rmi.prod_id);
+	}
+
+	/* Add physical driver struct to list */
+	mutex_lock(&phys_drivers_mutex);
+	list_add_tail(&rpd->drivers, &phys_drivers);
+	mutex_unlock(&phys_drivers_mutex);
+
+	/* Do a probe for any applications that are registered and bind this
+	physical driver to them */
+	list_for_each_entry(app, &app_drivers, apps) {
+		/* Only check apps that are not already bound */
+		if (!app->rpd)
+			match_and_bind(app, rpd);
+	}
+
+	pr_debug("%s: Registered phys driver %s\n", __func__, rpd->name);
+
+	return 0;
+
+exit_fail:
+	return retval;
+}
+EXPORT_SYMBOL(rmi_register_phys_driver);
+
+int rmi_unregister_phys_driver(struct rmi_phys_driver *rpd)
+{
+	if (rpd->app) {
+		printk(KERN_WARNING "%s: %s: WARNING: unregister of %s while %s still attached\n",
+			__func__, drvname, rpd->name, rpd->app->name);
+	}
+
+	pr_debug("%s: Unregistering phys driver %s\n", __func__, rpd->name);
+	mutex_lock(&phys_drivers_mutex);
+	list_del(&rpd->drivers);
+	mutex_unlock(&phys_drivers_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL(rmi_unregister_phys_driver);
+
+struct rmi_application *rmi_register_application(const char *name,
+	void (*attention)(struct rmi_phys_driver *pd, int instance),
+	int (*probe)(struct rmi_application *app,
+	const struct rmi_module_info *rmi),
+	void (*config)(struct rmi_application *app))
+{
+	struct rmi_application *app;
+	struct rmi_phys_driver *rpd;
+
+	if (!name) {
+		printk(KERN_ERR "%s: %s: Application driver must specify a name\n",
+				__func__, drvname);
+		return 0;
+	}
+
+	if (!attention) {
+		printk(KERN_ERR "%s: %s: Application driver %s must specify attention notifier.\n",
+			__func__, drvname, name);
+		return 0;
+	}
+
+	if (!probe) {
+		printk(KERN_ERR "%s: %s: Application driver %s must specify a probe function.\n",
+			__func__, drvname, name);
+		return 0;
+	}
+
+	if (!config) {
+		printk(KERN_ERR "%s: %s: Application driver %s must specify a config function.\n",
+			__func__, drvname, name);
+		return 0;
+	}
+
+	pr_debug("%s: Registering app driver %s\n", __func__, name);
+
+	app = kmalloc(sizeof(*app), GFP_KERNEL);
+	if (!app) {
+		printk(KERN_ERR "%s: %s: Out of memory\n", __func__, drvname);
+		return 0;
+	}
+	INC_ALLOC_STAT(app);
+
+	app->name  = name;
+	app->attention = attention;
+	app->probe = probe;
+	app->config = config;
+	app->rpd = 0;
+
+	mutex_lock(&app_drivers_mutex);
+	list_add_tail(&app->apps, &app_drivers);
+	mutex_unlock(&app_drivers_mutex);
+
+	/* Probe for any matches with physical drivers and bind them. */
+	list_for_each_entry(rpd, &phys_drivers, drivers) {
+		if (!rpd->app)
+			match_and_bind(app, rpd);
+	}
+
+	pr_debug("%s: Registered app driver %s (%p)\n", __func__, name, app);
+
+	return app;
+}
+EXPORT_SYMBOL(rmi_register_application);
+
+void rmi_unregister_application(struct rmi_application *app)
+{
+	struct rmi_application *tmp;
+	int found = 0;
+
+	if (!app)
+		return;
+
+	pr_debug("%s: Unregistering app driver %s (%p)\n",
+			__func__, app->name, app);
+
+	list_for_each_entry(tmp, &app_drivers, apps) {
+		if (tmp == app) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (!found) {
+		printk(KERN_ERR "%s: %s: Removing rmi application %s: not found\n",
+			__func__, drvname, app->name);
+		return;
+	}
+
+	if (app->rpd) {
+		/* Release the phys driver so it can be unloaded. */
+		module_put(app->rpd->module);
+		app->rpd->app = 0;
+	}
+
+	list_del(&app->apps);
+	kfree(app);
+	DEC_ALLOC_STAT(app);
+
+	pr_debug("%s: Unregistered app driver %p\n", __func__, app);
+}
+EXPORT_SYMBOL(rmi_unregister_application);
+
+static int __init rmi_core_init(void)
+{
+	int i;
+	struct rmi_functions_data *rmi4_fn;
+
+	pr_debug("%s: Register Mapped Interface Data Layer Driver\n", __func__);
+
+	/* Initialize global list of RMI4 Functions that have data sources.
+	We need to add all new functions to this list so that we will have
+	pointers to the associated functions for init, config, report and
+	detect. See rmi.h for more details. The developer will add a new
+	RMI4 function number in the array in rmi.h, then add a new file to
+	the build (called rmi_function_XX.c where XX is the hex number for
+	the added RMI4 function). The rest should be automatic.
+	*/
+
+	/* for each function number defined in rmi.h creat a new rmi_function
+	struct and initialize the pointers to the servicing functions and then
+	add it into the global list for function support.
+	*/
+	for (i = 0; i < rmi4_num_supported_data_src_fns; i++) {
+		/* Add new rmi4 function struct to list */
+		struct rmi_functions *fn = kmalloc(sizeof(*fn), GFP_KERNEL);
+		if (!fn) {
+			printk(KERN_ERR "%s: %s: could not allocate memory "
+				"for rmi_function struct for function 0x%x\n",
+				__func__, drvname,
+				rmi4_supported_data_src_functions[i].functionNumber);
+			return -ENOMEM;
+		} else {
+			INC_ALLOC_STAT(fn);
+
+			rmi4_fn = &rmi4_supported_data_src_functions[i];
+			fn->functionNum = rmi4_fn->functionNumber;
+			/* Fill in ptrs to functions. The functions are
+			linked in from a file called rmi_function_xx.c
+			where xx is the hex number of the RMI4 function
+			from the RMI4 spec. Also, the function prototypes
+			need to be added to rmi_function_xx.h - also where
+			xx is the hex number of the RMI4 function.  So
+			that you don't get compile errors and that new
+			header needs to be included in the rmi.h header file.
+			*/
+			fn->report = rmi4_fn->reportFn;
+			fn->config = rmi4_fn->configFn;
+			fn->init =   rmi4_fn->initFn;
+			fn->detect = rmi4_fn->detectFn;
+
+			/* Add the new fn to the global list */
+			mutex_lock(&fns_mutex);
+			list_add_tail(&fn->link, &fns_list);
+			mutex_unlock(&fns_mutex);
+		}
+	}
+
+	return 0;
+}
+
+static void __exit rmi_core_exit(void)
+{
+	struct rmi_application *app, *apptmp;
+
+	/* These lists should be empty, but just in case . . . */
+	mutex_lock(&app_drivers_mutex);
+	list_for_each_entry_safe(app, apptmp, &app_drivers, apps) {
+		list_del(&app->apps);
+		kfree(app);
+		DEC_ALLOC_STAT(app);
+	}
+	mutex_unlock(&app_drivers_mutex);
+
+	CHECK_ALLOC_STAT(app);
+}
+
+/* TODO: Investigate implimenting "rmi" bus and device and driver on that bus
+	as per Documentation/driver-model/bus.txt */
+
+module_init(rmi_core_init);
+module_exit(rmi_core_exit);
+
+MODULE_AUTHOR("Synaptics, Inc.");
+MODULE_DESCRIPTION("RMI4 Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/input/touchscreen/rmi_core.h b/drivers/input/touchscreen/rmi_core.h
new file mode 100755
index 0000000..174b427
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_core.h
@@ -0,0 +1,58 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) Data Layer Core Header.
+ * Copyright (c) 2007 - 2010, Synaptics Incorporated.
+ *
+ */
+/*
+ *
+ * This file is licensed under the GPL2 license.
+ *
+ *#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ *#############################################################################
+ */
+
+#ifndef _RMI_CORE_H
+#define _RMI_CORE_H
+
+struct rmi_application {
+	const char *name;
+	void (*attention)(struct rmi_phys_driver *pd, int instance);
+	/* Probe Function
+	*  This function is called to give the application layer an
+	*  opportunity to claim an RMI device.  The application layer cannot
+	*  read RMI registers at this point.  Defer that to the config
+	*  function call which occurs immediately after a successful probe.
+	*/
+	int (*probe)(struct rmi_application *app,
+			const struct rmi_module_info *rmi);
+	/* Config Function
+	*  This function is called after a successful probe.  It gives the
+	*  application driver an opportunity to query and/or configure an RMI
+	*  device before data starts flowing.
+	*/
+	void (*config)(struct rmi_application *app);
+	/* Standard kernel linked list implementation.
+	*  Documentation on how to use it can be found at
+	*  http://isis.poly.edu/kulesh/stuff/src/klist/.
+	*/
+	struct list_head apps;
+	struct rmi_phys_driver *rpd;
+	bool polling_required;
+	struct hrtimer timer;
+	struct work_struct work;
+};
+
+#endif
+
diff --git a/drivers/input/touchscreen/rmi_function_11.c b/drivers/input/touchscreen/rmi_function_11.c
new file mode 100755
index 0000000..999d911
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_function_11.c
@@ -0,0 +1,438 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) Function $11 support for 2D.
+ * Copyright (c) 2007 - 2010, Synaptics Incorporated
+ *
+ * For every RMI4 function that has a data source - like 2D sensors,
+ * buttons, LEDs, GPIOs, etc. - the user will create a new rmi_function_xx.c
+ * file and add these functions to perform the config(), init(), report()
+ * and detect() functionality. The function pointers are then srored under
+ * the RMI function info and these functions will automatically be called by
+ * the global config(), init(), report() and detect() functions that will
+ * loop through all data sources and call the data sources functions using
+ * these functions pointed to by the function ptrs.
+ */
+/*
+ * This file is licensed under the GPL2 license.
+ *
+ *#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ *#############################################################################
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include <linux/input.h>
+
+#include "rmi.h"
+#include "rmi_core.h"
+#include "rmi_functions.h"
+
+/* RMI4 device control == function 0x01 */
+extern unsigned short fn01ControlBaseAddr;
+
+static int sensorMaxX;
+static int sensorMaxY;
+
+/*
+ * This reads in a sample and reports the function $11 source data to the
+ * input subsystem. It is used for both polling and interrupt driven
+ * operation. This is called a lot so don't put in any informational
+ * printks since they will slow things way down!
+ */
+int FN_11_report(struct rmi_application *app,
+		struct rmi_function_info *rfi, struct input_dev *input)
+{
+	unsigned char values[2] = {0, 0};
+	unsigned char data[12] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
+	/* number of touch points - fingers down in this case */
+	int fingerDownCount;
+	int X, Y, Z, W, Wy, Wx;
+	int finger;
+	int fn11FingersSupported;
+	int fn11FingerRegisters;
+	unsigned short fn11DataBaseAddr;
+	unsigned char fn11DataRegBlockSize;
+	static bool wasdown;
+
+	fingerDownCount = 0;
+
+	/* get 2D sensor finger data */
+
+	/* First get the finger status field - the size of the finger status
+	field is determined by the number of finger supporte - 2 bits per
+	finger, so the number of registers to read is:
+		registerCount = ceil(numberOfFingers/4).
+	Read the required number of registers and check each 2 bit field to
+	determine if a finger is down:
+		00 = finger not present,
+		01 = finger present and data accurate,
+		10 = finger present but data may not be accurate,
+		11 = reserved for product use.
+	*/
+	fn11FingersSupported = rfi->numDataPoints;
+	fn11FingerRegisters = (fn11FingersSupported + 3)/4;
+
+	fn11DataBaseAddr = rfi->funcDescriptor.dataBaseAddr;
+
+	if (rmi_read_multiple(app, fn11DataBaseAddr, values,
+			fn11FingerRegisters)) {
+		printk(KERN_ERR "%s: RMI4 function $11 report: "
+			"Could not read finger status registers 0x%x\n",
+			__func__, fn11DataBaseAddr);
+		return 0;
+	}
+
+	/* For each finger present, read the proper number of registers
+	to get absolute data. */
+	fn11DataRegBlockSize = rfi->dataRegBlockSize;
+
+	for (finger = 0; finger < fn11FingersSupported; finger++) {
+		int reg;
+		int fingerShift;
+		int fingerStatus;
+
+		/* determine which data byte the finger status is in */
+		reg = finger/4;
+		/* bit shift to get finger's status */
+		fingerShift = (finger % 4) * 2;
+		fingerStatus = (values[reg] >> fingerShift) & 3;
+
+		/* if finger status indicates a finger is present then
+		read the finger data and report it */
+		if (fingerStatus == 1 || fingerStatus == 2) {
+			/* number of active touch points not same as
+			number of supported fingers */
+			fingerDownCount++;
+
+			/* Read the finger data */
+			if (rmi_read_multiple(app, fn11DataBaseAddr +
+					((finger  * fn11DataRegBlockSize) +
+					fn11FingerRegisters),
+					data, fn11DataRegBlockSize)) {
+				printk(KERN_ERR "%s: RMI4 function $11 report: "
+					"Could not read finger data registers "
+					"0x%x\n", __func__,
+					fn11DataBaseAddr +
+					((finger  * fn11DataRegBlockSize) +
+					fn11FingerRegisters));
+				return 0;
+			} else {
+				X = (data[0] & 0x1f) << 4;
+				X |= data[2] & 0xf;
+				Y = (data[1] & 0x1f) << 4;
+				Y |= (data[2] >> 4) & 0xf;
+				W = data[3];
+
+				/* upper 4 bits of W are Wy,
+				lower 4 of W are Wx */
+				Wy =  (W >> 4) & 0x0f;
+				Wx = W & 0x0f;
+
+				Z = data[4];
+
+				/* if this is the first finger report normal
+				ABS_X, ABS_Y, PRESSURE, TOOL_WIDTH events for
+				non-MT apps. Apps that support Multi-touch
+				will ignore these events and use the MT events.
+				Apps that don't support Multi-touch will still
+				function.
+				*/
+				if (fingerDownCount == 1) {
+					input_report_abs(input, ABS_X, X);
+					input_report_abs(input, ABS_Y, Y);
+					input_report_abs(input, ABS_PRESSURE,
+							Z);
+					input_report_abs(input, ABS_TOOL_WIDTH,
+							max(Wx, Wy));
+					input_report_key(input, BTN_TOUCH, 1);
+					wasdown = true;
+				}
+
+				/* Report Multi-Touch events for each finger */
+				/* major axis of touch area ellipse */
+				input_report_abs(input, ABS_MT_TOUCH_MAJOR,
+						max(Wx, Wy));
+				/* minor axis of touch area ellipse */
+				input_report_abs(input, ABS_MT_TOUCH_MINOR,
+						min(Wx, Wy));
+				/* Currently only 2 supported - 1 or 0 */
+				input_report_abs(input, ABS_MT_ORIENTATION,
+						(Wx > Wy ? 1 : 0));
+				input_report_abs(input, ABS_MT_POSITION_X, X);
+				input_report_abs(input, ABS_MT_POSITION_Y, Y);
+				/* Tracking ID reported but not used yet */
+				input_report_abs(input, ABS_MT_TRACKING_ID,
+						finger+1);
+				/* MT sync between fingers */
+				input_mt_sync(input);
+			}
+		}
+	}
+
+	if (fingerDownCount) {
+		/* touch will be non-zero if we had any reported events */
+		input_sync(input); /* sync after groups of events */
+	} else {
+		/* if we had a finger down before and now we don't have
+		any we need to send a button up and a sync. */
+		if (wasdown) {
+			wasdown = false;
+			input_report_key(input, BTN_TOUCH, 0);
+			input_sync(input); /* sync after groups of events */
+		}
+	}
+
+	/* return the number of touch points: fingers down or buttons pressed */
+	return fingerDownCount;
+}
+
+int FN_11_config(struct rmi_application *app, struct rmi_function_info *rfi)
+{
+	/* For the data source - print info and do any
+	source specific configuration. */
+	unsigned char data[14];
+	int retval = 0;
+
+	pr_debug("%s: RMI4 function $11 config\n", __func__);
+
+	/* Get and print some info about the data source... */
+
+	/* To Query 2D devices we need to read from the address obtained
+	* from the function descriptor stored in the RMI function info.
+	*/
+	retval = rmi_read_multiple(app, rfi->funcDescriptor.queryBaseAddr,
+		data, 9);
+	if (retval) {
+		printk(KERN_ERR "%s: RMI4 function $11 config:"
+			"Could not read function query registers 0x%x\n",
+			__func__, rfi->funcDescriptor.queryBaseAddr);
+	} else {
+		pr_debug("%s:  Number of Fingers:   %d\n",
+				__func__, data[1] & 7);
+		pr_debug("%s:  Is Configurable:     %d\n",
+				__func__, data[1] & (1 << 7) ? 1 : 0);
+		pr_debug("%s:  Has Gestures:        %d\n",
+				__func__, data[1] & (1 << 5) ? 1 : 0);
+		pr_debug("%s:  Has Absolute:        %d\n",
+				__func__, data[1] & (1 << 4) ? 1 : 0);
+		pr_debug("%s:  Has Relative:        %d\n",
+				__func__, data[1] & (1 << 3) ? 1 : 0);
+
+		pr_debug("%s:  Number X Electrodes: %d\n",
+				__func__, data[2] & 0x1f);
+		pr_debug("%s:  Number Y Electrodes: %d\n",
+				__func__, data[3] & 0x1f);
+		pr_debug("%s:  Maximum Electrodes:  %d\n",
+				__func__, data[4] & 0x1f);
+
+		pr_debug("%s:  Absolute Data Size:  %d\n",
+				__func__, data[5] & 3);
+
+		pr_debug("%s:  Has XY Dist:         %d\n",
+				__func__, data[7] & (1 << 7) ? 1 : 0);
+		pr_debug("%s:  Has Pinch:           %d\n",
+				__func__, data[7] & (1 << 6) ? 1 : 0);
+		pr_debug("%s:  Has Press:           %d\n",
+				__func__, data[7] & (1 << 5) ? 1 : 0);
+		pr_debug("%s:  Has Flick:           %d\n",
+				__func__, data[7] & (1 << 4) ? 1 : 0);
+		pr_debug("%s:  Has Early Tap:       %d\n",
+				__func__, data[7] & (1 << 3) ? 1 : 0);
+		pr_debug("%s:  Has Double Tap:      %d\n",
+				__func__, data[7] & (1 << 2) ? 1 : 0);
+		pr_debug("%s:  Has Tap and Hold:    %d\n",
+				__func__, data[7] & (1 << 1) ? 1 : 0);
+		pr_debug("%s:  Has Tap:             %d\n",
+				__func__, data[7] & 1 ? 1 : 0);
+		pr_debug("%s:  Has Palm Detect:     %d\n",
+				__func__, data[8] & 1 ? 1 : 0);
+		pr_debug("%s:  Has Rotate:          %d\n",
+				__func__, data[8] & (1 << 1) ? 1 : 0);
+
+		retval = rmi_read_multiple(app,
+				rfi->funcDescriptor.controlBaseAddr, data, 14);
+		if (retval) {
+			printk(KERN_ERR "%s: RMI4 function $11 config:"
+				"Could not read control registers 0x%x\n",
+				__func__, rfi->funcDescriptor.controlBaseAddr);
+			return retval;
+		}
+
+		/* Store these for use later...*/
+		sensorMaxX = ((data[6] & 0x1f) << 8) | ((data[7] & 0xff) << 0);
+		sensorMaxY = ((data[8] & 0x1f) << 8) | ((data[9] & 0xff) << 0);
+
+		pr_debug("%s:  Sensor Max X:  %d\n", __func__, sensorMaxX);
+		pr_debug("%s:  Sensor Max Y:  %d\n", __func__, sensorMaxY);
+	}
+
+	return retval;
+}
+
+/* Initialize any function $11 specific params and settings - input
+ * settings, device settings, etc.
+ */
+int FN_11_init(struct input_dev *input)
+{
+	pr_debug("%s: RMI4 function $11 init\n", __func__);
+
+	/* need to init the input abs params for the 2D */
+	input->evbit[0] = BIT(EV_ABS);
+
+	/* Use the max X and max Y read from the device...*/
+	input_set_abs_params(input, ABS_X, 0, sensorMaxX, 0, 0);
+	input_set_abs_params(input, ABS_Y, 0, sensorMaxY, 0, 0);
+	input_set_abs_params(input, ABS_MT_POSITION_X, 0, sensorMaxX, 0, 0);
+	input_set_abs_params(input, ABS_MT_POSITION_Y, 0, sensorMaxY, 0, 0);
+
+	input_set_abs_params(input, ABS_PRESSURE, 0, 255, 0, 0);
+	input_set_abs_params(input, ABS_TOOL_WIDTH, 0, 15, 0, 0);
+
+	input_set_abs_params(input, ABS_MT_TOUCH_MAJOR, 0, 15, 0, 0);
+	input_set_abs_params(input, ABS_MT_TOUCH_MINOR, 0, 15, 0, 0);
+	input_set_abs_params(input, ABS_MT_ORIENTATION, 0, 1, 0, 0);
+	input_set_abs_params(input, ABS_MT_TRACKING_ID, 1, 10, 0, 0);
+
+	return 0;
+}
+
+int FN_11_detect(struct rmi_application *app, struct rmi_function_info *rfi,
+  struct rmi_function_descriptor *fd, unsigned int interruptCount)
+{
+	char fn11Queries[9];
+	int i;
+	unsigned short fn11InterruptOffset;
+	unsigned char fn11AbsDataSize;
+	unsigned char fn11AbsDataBlockSize;
+	int fn11HasPinch, fn11HasFlick, fn11HasTap;
+	int fn11HasTapAndHold, fn11HasDoubleTap;
+	int fn11HasEarlyTap, fn11HasPress;
+	int fn11HasPalmDetect, fn11HasRotate;
+	int fn11HasRel;
+	unsigned char f11_egr_0, f11_egr_1;
+	unsigned int fn11AllDataBlockSize;
+	int retval = 0;
+
+	pr_debug("%s: RMI4 function $11 detect\n", __func__);
+
+	/* Store addresses - used elsewhere to read data,
+	 * control, query, etc. */
+	rfi->funcDescriptor.queryBaseAddr = fd->queryBaseAddr;
+	rfi->funcDescriptor.commandBaseAddr = fd->commandBaseAddr;
+	rfi->funcDescriptor.controlBaseAddr = fd->controlBaseAddr;
+	rfi->funcDescriptor.dataBaseAddr = fd->dataBaseAddr;
+	rfi->funcDescriptor.interruptSrcCnt = fd->interruptSrcCnt;
+	rfi->funcDescriptor.functionNum = fd->functionNum;
+
+	rfi->numSources = fd->interruptSrcCnt;
+
+	/* need to get number of fingers supported, data size, etc. -
+	to be used when getting data since the number of registers to
+	read depends on the number of fingers supported and data size. */
+	retval = rmi_read_multiple(app, fd->queryBaseAddr, fn11Queries,
+			sizeof(fn11Queries));
+	if (retval) {
+		printk(KERN_ERR "%s: RMI4 function $11 detect: "
+			"Could not read function query registers 0x%x\n",
+			__func__,  rfi->funcDescriptor.queryBaseAddr);
+		return retval;
+	}
+
+	/* 2D data sources have only 3 bits for the number of fingers
+	supported - so the encoding is a bit wierd. */
+	rfi->numDataPoints = 2; /* default number of fingers supported */
+	if ((fn11Queries[1] & 0x7) <= 4)
+		/* add 1 since zero based */
+		rfi->numDataPoints = (fn11Queries[1] & 0x7) + 1;
+	else {
+		/* a value of 5 is up to 10 fingers - 6 and 7 are reserved
+		(shouldn't get these i int retval;n a normal 2D source). */
+		if ((fn11Queries[1] & 0x7) == 5)
+			rfi->numDataPoints = 10;
+	}
+
+	/* Need to get interrupt info to be used later when handling
+	interrupts. */
+	rfi->interruptRegister = (interruptCount + 7)/8;
+
+	/* loop through interrupts for each source in fn $11 and or in a bit
+	to the interrupt mask for each. */
+	fn11InterruptOffset = interruptCount % 8;
+
+	for (i = fn11InterruptOffset;
+			i < ((fd->interruptSrcCnt & 0x7) + fn11InterruptOffset);
+			i++)
+		rfi->interruptMask |= 1 << i;
+
+	/* Size of just the absolute data for one finger */
+	fn11AbsDataSize = fn11Queries[5] & 0x03;
+	/* One each for X and Y, one for LSB for X & Y, one for W, one for Z */
+	fn11AbsDataBlockSize = 3 + (2 * (fn11AbsDataSize == 0 ? 1 : 0));
+	rfi->dataRegBlockSize = fn11AbsDataBlockSize;
+
+	/* need to determine the size of data to read - this depends on
+	conditions such as whether Relative data is reported and if Gesture
+	data is reported. */
+	f11_egr_0 = fn11Queries[7];
+	f11_egr_1 = fn11Queries[8];
+
+	/* Get info about what EGR data is supported, whether it has
+	Relative data supported, etc. */
+	fn11HasPinch = f11_egr_0 & 0x40;
+	fn11HasFlick = f11_egr_0 & 0x10;
+	fn11HasTap = f11_egr_0 & 0x01;
+	fn11HasTapAndHold = f11_egr_0 & 0x02;
+	fn11HasDoubleTap = f11_egr_0 & 0x04;
+	fn11HasEarlyTap = f11_egr_0 & 0x08;
+	fn11HasPress = f11_egr_0 & 0x20;
+	fn11HasPalmDetect = f11_egr_1 & 0x01;
+	fn11HasRotate = f11_egr_1 & 0x02;
+	fn11HasRel = fn11Queries[1] & 0x08;
+
+	/* Size of all data including finger status, absolute data for each
+	finger, relative data and EGR data */
+	fn11AllDataBlockSize =
+		/* finger status, four fingers per register */
+		((rfi->numDataPoints + 3) / 4) +
+		/* absolute data, per finger times number of fingers */
+		(fn11AbsDataBlockSize * rfi->numDataPoints) +
+		/* two relative registers (if relative is being reported) */
+		2 * fn11HasRel +
+		/* F11_2D_Data8 is only present if the egr_0
+		register is non-zero. */
+		!!(f11_egr_0) +
+		/* F11_2D_Data9 is only present if either egr_0 or
+		egr_1 registers are non-zero. */
+		(f11_egr_0 || f11_egr_1) +
+		/* F11_2D_Data10 is only present if EGR_PINCH or EGR_FLICK of
+		egr_0 reports as 1. */
+		!!(fn11HasPinch | fn11HasFlick) +
+		/* F11_2D_Data11 and F11_2D_Data12 are only present if
+		EGR_FLICK of egr_0 reports as 1. */
+		2 * !!(fn11HasFlick);
+
+	/* Disable Interrupts. It is up to the Application Driver to
+	* turn them on when it's ready for them. */
+	retval = rmi_write(app,
+			fn01ControlBaseAddr + 1 + rfi->interruptRegister, 0);
+	if (!retval) {
+		printk(KERN_ERR "%s: Function $11 Interrupt Disable Fail: %d\n",
+				__func__, retval);
+	}
+
+	return retval;
+}
diff --git a/drivers/input/touchscreen/rmi_function_11.h b/drivers/input/touchscreen/rmi_function_11.h
new file mode 100755
index 0000000..e90d889
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_function_11.h
@@ -0,0 +1,43 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) Function $11 support for 2D.
+ * Copyright (c) 2007 - 2010, Synaptics Incorporated
+ *
+ * For every RMI4 function that has a data source - like 2D sensors,
+ * buttons, LEDs, GPIOs, etc. - the user will create a new rmi_function_xx.c
+ * file and add these functions to perform the config(), init(), report()
+ * and detect() functionality. The function pointers are then srored under
+ * the RMI function info and these functions will automatically be called by
+ * the global config(), init(), report() and detect() functions that will
+ * loop through all data sources and call the data sources functions using
+ * these functions pointed to by the function ptrs.
+ */
+/*
+ * This file is licensed under the GPL2 license.
+ *
+ *#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ *#############################################################################
+ */
+#ifndef _RMI_FUNCTION_11_H
+#define _RMI_FUNCTION_11_H
+
+int FN_11_report(struct rmi_application *app, struct rmi_function_info *rfi,
+		struct input_dev *input);
+int FN_11_config(struct rmi_application *app, struct rmi_function_info *rfi);
+int FN_11_init(struct input_dev *input);
+int FN_11_detect(struct rmi_application *app, struct rmi_function_info *rfi,
+		struct rmi_function_descriptor *fd,
+		unsigned int interruptCount);
+
+#endif
diff --git a/drivers/input/touchscreen/rmi_functions.h b/drivers/input/touchscreen/rmi_functions.h
new file mode 100644
index 0000000..75f1ded
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_functions.h
@@ -0,0 +1,111 @@
+
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) Functions Definition Header File.
+ * Copyright (c) 2007 - 2010, Synaptics Incorporated
+ *
+ *
+ */
+/*
+ * This file is licensed under the GPL2 license.
+ *
+ *#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ *#############################################################################
+ */
+
+#ifndef _RMI_FUNCTIONS_H
+#define _RMI_FUNCTIONS_H
+
+/* This struct is for creating a list of RMI4 functions that have data sources
+   associated with them. This is to facilitate adding new support for other
+   data sources besides 2D sensors.
+   To add a new data source support, the developer will create a new file
+   and add these 4 functions below with FN$## in front of the names - where
+   ## is the hex number for the function taken from the RMI4 specification.
+
+   The function number will be associated with this and later will be used to
+   match the RMI4 function to the 4 functions for that RMI4 function number.
+
+   The user will also have to add code that adds the new rmi_functions item
+   to the global list of RMI4 functions and stores the pointers to the 4
+   functions in the function pointers.
+*/
+struct rmi_functions {
+	unsigned char functionNum;
+
+	struct input_dev *input;
+
+	/* Pointers to function specific functions for report, config, init
+	   and detect. */
+	/* These ptrs. need to be filled in for every RMI4 function that has
+	   data source(s) associated with it - like fn $11 (2D sensors),
+	   fn $19 (buttons), etc. Each RMI4 function that has data sources
+	   will be added into a list that is used to match the function
+	   number against the number stored here.
+	*/
+	int (*report)(struct rmi_application *app,
+		struct rmi_function_info *rfi, struct input_dev *input);
+	int (*config)(struct rmi_application *app,
+		struct rmi_function_info *rfi);
+	int (*init)(struct input_dev *input);
+	int (*detect)(struct rmi_application *app,
+		struct rmi_function_info *rfi,
+		struct rmi_function_descriptor *fd,
+		unsigned int interruptCount);
+
+	/* Standard kernel linked list implementation.
+	* Documentation on how to use it can be found at
+	* http://isis.poly.edu/kulesh/stuff/src/klist/.
+	*/
+	struct list_head link;
+};
+
+
+/* Each time a new RMI4 function support is added the developer needs to
+   bump the number of supported data src functions and add the info for
+   that RMI4 function to the array along with pointers to the report,
+   config, init and detect functions that they coded in rmi_function_xx.c
+   and rmi_function_xx.h - where xx is the RMI4 function number for the new
+   RMI4 data source function. The information for the RMI4 functions is
+   obtained from the RMI4 specification document.
+*/
+#define rmi4_num_supported_data_src_fns 1
+
+/* add hdr files for all prototypes for RMI4 data source
+   functions being supported. */
+#include "rmi_function_11.h"
+/* #include "rmi_function_19.h" */
+
+typedef int(*reportFuncPtr)(struct rmi_application *app,
+	struct rmi_function_info *rfi, struct input_dev *input);
+typedef int(*configFuncPtr)(struct rmi_application *app,
+	struct rmi_function_info *rfi);
+typedef int(*initFuncPtr)(struct input_dev *input);
+typedef int(*detectFuncPtr)(struct rmi_application *app,
+	struct rmi_function_info *rfi, struct rmi_function_descriptor *fd,
+	unsigned int interruptCount);
+
+struct rmi_functions_data {
+	int functionNumber;
+	reportFuncPtr reportFn;
+	configFuncPtr configFn;
+	initFuncPtr initFn;
+	detectFuncPtr detectFn;
+};
+
+
+struct rmi_functions *rmi_find_function(int functionNum);
+int rmi_functions_init(struct input_dev *inputdev);
+
+#endif
diff --git a/drivers/input/touchscreen/rmi_i2c.h b/drivers/input/touchscreen/rmi_i2c.h
new file mode 100755
index 0000000..fecda60
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_i2c.h
@@ -0,0 +1,51 @@
+/**
+ *
+ * Synaptics RMI over I2C Physical Layer Driver Header File.
+ * Copyright (c) 2007 - 2010, Synaptics Incorporated
+ *
+ */
+/*
+ * This file is licensed under the GPL2 license.
+ *
+ *#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ *#############################################################################
+ */
+
+#ifndef _RMI_I2C_H
+#define _RMI_I2C_H
+
+/* Platform-specific configuration data.
+ * This structure is used by the platform-specific driver to designate
+ * specific information about the hardware.  A platform client may supply
+ * an array of these to the rmi_phys_i2c driver.
+ */
+struct rmi_i2c_platformdata {
+	/* The seven-bit i2c address of the device. */
+	int i2c_address;
+	/* The number of the irq.  Set to zero if polling is required. */
+	int irq;
+	/* The type of the irq (e.g., IRQF_TRIGGER_FALLING).
+	   Only valid if irq != 0 */
+	int irq_type;
+};
+
+/* Descriptor structure.
+ * Describes the number of i2c devices on the bus that speak RMI.
+ */
+struct rmi_i2c_data {
+	int num_clients;
+	struct rmi_i2c_platformdata *platformdata;
+};
+
+#endif
diff --git a/drivers/input/touchscreen/rmi_i2c_gta01.c b/drivers/input/touchscreen/rmi_i2c_gta01.c
new file mode 100755
index 0000000..c3bd509
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_i2c_gta01.c
@@ -0,0 +1,117 @@
+/**
+ *
+ * Synaptics RMI4 Support for I2C the OpenMoko phone (GTA01) hardware platform.
+ * Copyright (c) 2007 - 2010, Synaptics Incorporated.
+ *
+ * To support a different device - for example if the GPIOs are different or
+ * different hardware is being used - make a copy of this file and change the
+ * name to reflect the new hardware platform then modify it to support the new
+ * platforms hardware (interrupts, IC chip, etc.).
+ *
+ */
+/*
+ * This file is licensed under the GPL2 license.
+ *
+ *#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ *#############################################################################
+ */
+
+#include <linux/module.h>
+#include <linux/jiffies.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/gpio.h>
+#include "rmi_i2c.h"
+
+/* Set this to either 1 or 0 depending on your clearpad hardware. */
+#define ATTENTION_ACTIVE_LOW 1
+
+#if ATTENTION_ACTIVE_LOW
+#define IRQ_TRIGGER IRQF_TRIGGER_FALLING
+#else
+#define IRQ_TRIGGER IRQF_TRIGGER_RISING
+#endif
+
+#define GPF3 S3C2410_GPF3
+#define GPF3INT3 S3C2410_GPF3_EINT3
+#define IRQINT3 IRQ_EINT3
+
+#define GPIO_CFG s3c2410_gpio_cfgpin(S3C2410_GPF3, S3C2410_GPF3_EINT3)
+
+
+static struct rmi_i2c_platformdata rmi_i2c_dev_platformdata[] = {
+	[0] = {
+		.i2c_address = 0x20,
+		.irq = IRQINT3,
+		.irq_type = IRQ_TRIGGER,
+	},
+};
+
+static struct rmi_i2c_data rmi_platform_data = {
+	.num_clients = ARRAY_SIZE(rmi_i2c_dev_platformdata),
+	.platformdata  = rmi_i2c_dev_platformdata,
+};
+
+static void
+rmi_i2c_release(struct device *dev)
+{
+	struct platform_device *pd = container_of(dev,
+			struct platform_device, dev);
+
+	kfree(pd);
+}
+
+static struct platform_device *gta01_rmi_device;
+
+/*
+ * These are the module insert and remove functions.
+ */
+static int __init
+mod_init(void)
+{
+	struct platform_device *pd;
+
+	pr_debug("%s: GTA01 RMI4 Platform Driver Init.\n", __func__);
+
+	gta01_rmi_device = pd = kzalloc(sizeof(*pd), GFP_KERNEL);
+	if (!pd) {
+		printk(KERN_ERR
+			"%s: Failed to alloc memory for struct platform_dev.\n",
+			__func__);
+		return -ENOMEM;
+	}
+
+	/* Set up the GPIO for interrupts */
+	GPIO_CFG;
+
+	pd->name              = "rmi4-i2c";
+	pd->id                = -1;
+	pd->dev.platform_data = &rmi_platform_data;
+	pd->dev.release       = rmi_i2c_release;
+
+	return platform_device_register(pd);
+}
+
+static void __exit
+mod_exit(void)
+{
+	return platform_device_unregister(gta01_rmi_device);
+}
+
+module_init(mod_init);
+module_exit(mod_exit);
+
+MODULE_AUTHOR("Synaptics, Inc.");
+MODULE_DESCRIPTION("GTA01 (OpenMoko Phone) RMI4 over I2C Device Configuration");
+MODULE_LICENSE("GPL");
diff --git a/drivers/input/touchscreen/rmi_phys_i2c.c b/drivers/input/touchscreen/rmi_phys_i2c.c
new file mode 100755
index 0000000..945633b
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_phys_i2c.c
@@ -0,0 +1,578 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) I2C Physical Layer Driver.
+ * Copyright (c) 2007-2010, Synaptics Incorporated
+ *
+ */
+/*
+ * This file is licensed under the GPL2 license.
+ *
+ *#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ *#############################################################################
+ */
+
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include "rmi_i2c.h"
+#include "rmi.h"
+
+/* TODO: for multiple device support will need a per-device mutex */
+#define DRIVER_NAME "rmi4-i2c"
+
+/* TODO: for multiple device support will need a per-device device name */
+#define DEVICE_NAME "rmi4-i2c"
+
+/* Used to lock access to the page address.
+ */
+static DEFINE_MUTEX(page_mutex);
+
+
+static const struct i2c_device_id rmi_i2c_id_table[] = {
+	{ DEVICE_NAME, 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, rmi_i2c_id_table);
+
+
+/*
+ * This is the data kept on a per instance (client) basis.  This data is
+ * always accessible by using the container_of() macro of the various elements
+ * inside.
+ */
+struct instance_data {
+	int instance_no;
+	int irq;
+	struct rmi_phys_driver rpd;
+	struct i2c_client *i2cclient; /* pointer to i2c_client for later use in
+					 read, write, read_multiple, etc. */
+	int page;
+};
+
+/*
+ * RMI devices have 16-bit addressing, but some of the physical
+ * implementations (like SMBus) only have 8-bit addressing.  So RMI implements
+ * a page address at 0xff of every page so we can reliable page addresses
+ * every 256 registers.  This function sets the page.
+ *
+ * The page_mutex lock must be held when this function is entered.
+ *
+ * param[in] id - The pointer to the instance_data struct
+ * param[in] page - The new page address.
+ * returns zero on success, non-zero on failure.
+ */
+int
+rmi_set_page(struct instance_data *id, unsigned int page)
+{
+	char txbuf[2];
+	int retval;
+	txbuf[0] = 0xff;
+	txbuf[1] = page;
+	retval = i2c_master_send(id->i2cclient, txbuf, 2);
+	if (retval != 2) {
+		dev_err(&id->i2cclient->dev,
+				"%s: Set page fail: %d\n", __func__, retval);
+	} else {
+		retval = 0;
+		id->page = page;
+	}
+	return retval;
+}
+
+/*
+ * Read a single register through i2c.
+ *
+ * param[in] pd - The pointer to the rmi_phys_driver struct
+ * param[in] address - The address at which to start the data read.
+ * param[out] valp - Pointer to the buffer where the data will be stored.
+ * returns xero upon success (with the byte read in valp), non-zero upon error.
+ */
+static int
+rmi_i2c_read(struct rmi_phys_driver *pd, unsigned short address, char *valp)
+{
+	struct instance_data *id = container_of(pd, struct instance_data, rpd);
+	char txbuf[2];
+	int retval = 0;
+	int retry_count = 0;
+
+	/* Can't have anyone else changing the page behind our backs */
+	mutex_lock(&page_mutex);
+
+	if (((address >> 8) & 0xff) != id->page) {
+		/* Switch pages */
+		retval = rmi_set_page(id, ((address >> 8) & 0xff));
+		if (retval)
+			goto exit;
+	}
+
+retry:
+	txbuf[0] = address & 0xff;
+	retval = i2c_master_send(id->i2cclient, txbuf, 1);
+
+	if (retval != 1) {
+		dev_err(&id->i2cclient->dev, "%s: Write fail: %d\n",
+				__func__, retval);
+		goto exit;
+	}
+	retval = i2c_master_recv(id->i2cclient, txbuf, 1);
+
+	if (retval != 1) {
+		if (++retry_count == 5) {
+			dev_err(&id->i2cclient->dev,
+					"%s: Read of 0x%04x fail: %d\n",
+					__func__, address, retval);
+		} else {
+			mdelay(10);
+			rmi_set_page(id, ((address >> 8) & 0xff));
+			goto retry;
+		}
+	} else {
+		retval = 0;
+		*valp = txbuf[0];
+	}
+exit:
+	mutex_unlock(&page_mutex);
+	return retval;
+}
+
+/*
+ * Same as rmi_i2c_read, except that multiple bytes are allowed to be read.
+ *
+ * param[in] pd - The pointer to the rmi_phys_driver struct
+ * param[in] address - The address at which to start the data read.
+ * param[out] valp - Pointer to the buffer where the data will be stored.  This
+ *     buffer must be at least size bytes long.
+ * param[in] size - The number of bytes to be read.
+ * returns zero upon success (with the byte read in valp), non-zero upon error.
+ *
+ */
+static int
+rmi_i2c_read_multiple(struct rmi_phys_driver *pd, unsigned short address,
+	char *valp, int size)
+{
+	struct instance_data *id = container_of(pd, struct instance_data, rpd);
+	char txbuf[2];
+	int retval = 0;
+	int retry_count = 0;
+
+	/* Can't have anyone else changing the page behind our backs */
+	mutex_lock(&page_mutex);
+
+	if (((address >> 8) & 0xff) != id->page) {
+		/* Switch pages */
+		retval = rmi_set_page(id, ((address >> 8) & 0xff));
+		if (retval)
+			goto exit;
+	}
+
+retry:
+	txbuf[0] = address & 0xff;
+	retval = i2c_master_send(id->i2cclient, txbuf, 1);
+
+	if (retval != 1) {
+		dev_err(&id->i2cclient->dev, "%s: Write fail: %d\n",
+				__func__, retval);
+		goto exit;
+	}
+	retval = i2c_master_recv(id->i2cclient, valp, size);
+
+	if (retval != size) {
+		if (++retry_count == 5) {
+			dev_err(&id->i2cclient->dev,
+					"%s: Read of 0x%04x size %d fail: %d\n",
+					__func__, address, size, retval);
+		} else {
+			mdelay(10);
+			rmi_set_page(id, ((address >> 8) & 0xff));
+			goto retry;
+		}
+	} else {
+		retval = 0;
+	}
+exit:
+	mutex_unlock(&page_mutex);
+	return retval;
+}
+
+
+/*
+ * Write a single register through i2c.
+ * You can write multiple registers at once, but I made the functions for that
+ * seperate for performance reasons.  Writing multiple requires allocation and
+ * freeing.
+ *
+ * param[in] pd - The pointer to the rmi_phys_driver struct
+ * param[in] address - The address at which to start the write.
+ * param[in] data - The data to be written.
+ * returns one upon success, something else upon error.
+ */
+static int
+rmi_i2c_write(struct rmi_phys_driver *pd, unsigned short address, char data)
+{
+	struct instance_data *id = container_of(pd, struct instance_data, rpd);
+	unsigned char txbuf[2];
+	int retval = 0;
+
+	/* Can't have anyone else changing the page behind our backs */
+	mutex_lock(&page_mutex);
+
+	if (((address >> 8) & 0xff) != id->page) {
+		/* Switch pages */
+		retval = rmi_set_page(id, ((address >> 8) & 0xff));
+		if (retval)
+			goto exit;
+	}
+
+	txbuf[0] = address & 0xff;
+	txbuf[1] = data;
+	retval = i2c_master_send(id->i2cclient, txbuf, 2);
+
+	/* TODO: Add in retry on writes only in certian error return values */
+	if (retval != 2) {
+		dev_err(&id->i2cclient->dev, "%s: Write fail: %d\n",
+			__func__, retval);
+		goto exit; /* Leave this in case we add code below */
+	}
+exit:
+	mutex_unlock(&page_mutex);
+	return retval;
+}
+
+/*
+ * Write multiple registers.
+ *
+ * For fast writes of 16 bytes of less we will re-use a buffer on the stack.
+ * For larger writes (like for RMI reflashing) we will need to allocate a
+ * temp buffer.
+ *
+ * param[in] pd - The pointer to the rmi_phys_driver struct
+ * param[in] address - The address at which to start the write.
+ * param[in] valp - A pointer to a buffer containing the data to be written.
+ * param[in] size - The number of bytes to write.
+ * returns one upon success, something else upon error.
+ */
+static int
+rmi_i2c_write_multiple(struct rmi_phys_driver *pd, unsigned short address,
+	char *valp, int size)
+{
+	struct instance_data *id = container_of(pd, struct instance_data, rpd);
+	unsigned char *txbuf;
+	unsigned char txbuf_most[17]; /* Use this buffer for fast writes of 16
+					bytes or less.  The first byte will
+					contain the address at which to start
+					the write. */
+	int retval = 0;
+	int i;
+
+	if (size < sizeof(txbuf_most)) {
+		/* Avoid an allocation if we can help it. */
+		txbuf = txbuf_most;
+	} else {
+		/* over 16 bytes write we'll need to allocate a temp buffer */
+		txbuf = kmalloc(size + 1, GFP_KERNEL);
+		if (!txbuf)
+			return -ENOMEM;
+	}
+
+	/* Yes, it stinks here that we have to copy the buffer */
+	/* We copy from valp to txbuf leaving
+	the first location open for the address */
+	for (i = 0; i < size; i++)
+		txbuf[i + 1] = valp[i];
+
+	/* Can't have anyone else changing the page behind our backs */
+	mutex_lock(&page_mutex);
+
+	if (((address >> 8) & 0xff) != id->page) {
+		/* Switch pages */
+		retval = rmi_set_page(id, ((address >> 8) & 0xff));
+		if (retval)
+			goto exit;
+	}
+
+	txbuf[0] = address & 0xff; /* put the address in the first byte */
+	retval = i2c_master_send(id->i2cclient, txbuf, size + 1);
+
+	/* TODO: Add in retyr on writes only in certian error return values */
+	if (retval != 1) {
+		dev_err(&id->i2cclient->dev, "%s: Write fail: %d\n",
+				__func__, retval);
+		goto exit;
+	}
+exit:
+	mutex_unlock(&page_mutex);
+	if (txbuf != txbuf_most)
+		kfree(txbuf);
+	return retval;
+}
+
+/*
+ * This is the Interrupt Service Routine.  It just notifies the application
+ * layer that attention is required.
+ */
+static irqreturn_t
+i2c_attn_isr(int irq, void *info)
+{
+	struct instance_data *id = info;
+	disable_irq(id->irq);
+	if (id->rpd.attention)
+		id->rpd.attention(&id->rpd, id->instance_no);
+	return IRQ_HANDLED;
+}
+
+/* The Driver probe function - will allocate and initialize the instance
+   data and request the irq and set the instance data as the clients
+   platform data then register the physical driver which will do a scan of
+   the RMI4 Physical Device Table and enumerate any RMI4 functions that
+   have data sources associated with them.
+ */
+static int
+rmi_i2c_probe(struct i2c_client *client, const struct i2c_device_id *dev_id)
+{
+	struct instance_data *id;
+	int retval = 0;
+	int i;
+	bool found = false;
+
+	struct rmi_i2c_data *rmii2cdata;
+	struct rmi_i2c_platformdata *platformdata;
+
+	pr_debug("Probing i2c RMI device\n");
+
+	/* Allocate and initialize the instance data for this client */
+	id = kzalloc(sizeof(*id) * 2, GFP_KERNEL);
+	if (!id) {
+		dev_err(&client->dev,
+			"%s: Out of memory trying to allocate instance_data.\n",
+			__func__);
+		return -ENOMEM;
+	}
+
+	id->rpd.name           = DRIVER_NAME;
+	id->rpd.write          = rmi_i2c_write;
+	id->rpd.read           = rmi_i2c_read;
+	id->rpd.write_multiple = rmi_i2c_write_multiple;
+	id->rpd.read_multiple  = rmi_i2c_read_multiple;
+	id->rpd.module         = THIS_MODULE;
+	id->rpd.polling_required = true; /* Set default to polling in case no
+					    matching platform data is located
+					    for this device. We'll still work
+					    but in polling mode since we didn't
+					    find any irq info */
+
+	id->page               = 0xffff; /* So we set the page correctly
+					    the first time */
+
+	/* cast to our struct rmi_i2c_data so we know
+	the fields (see rmi_ic2.h) */
+	rmii2cdata = ((struct rmi_i2c_data *)(client->dev.platform_data));
+
+	/* Loop through the platform data and locate the one that matches
+	the i2c_client I2C address */
+	for (i = 0; i < rmii2cdata->num_clients; i++) {
+		platformdata = &(rmii2cdata->platformdata[i]);
+		if (client->addr == platformdata->i2c_address) {
+			id->instance_no = i;
+			found = true;
+			/* set the device name using the instance_no appended
+			to DEVICE_NAME to make a unique name */
+			dev_set_name(&client->dev,
+				"rmi4-i2c%d", id->instance_no);
+
+			/* Determine if we need to poll (inefficient) or
+			use interrupts.
+			*/
+			if (platformdata->irq) {
+				int irqtype;
+
+				id->irq = platformdata->irq;
+				switch (platformdata->irq_type) {
+				case IORESOURCE_IRQ_HIGHEDGE:
+					irqtype = IRQF_TRIGGER_RISING;
+					break;
+				case IORESOURCE_IRQ_LOWEDGE:
+					irqtype = IRQF_TRIGGER_FALLING;
+					break;
+				case IORESOURCE_IRQ_HIGHLEVEL:
+					irqtype = IRQF_TRIGGER_HIGH;
+					break;
+				case IORESOURCE_IRQ_LOWLEVEL:
+					irqtype = IRQF_TRIGGER_LOW;
+					break;
+				default:
+					dev_warn(&client->dev,
+						"%s: Invalid IRQ flags in "
+						"platform data.\n",
+						__func__);
+					kfree(id);
+					return -ENXIO;
+				}
+
+				retval = request_irq(id->irq, i2c_attn_isr,
+					irqtype, "rmi_i2c", id);
+				if (retval) {
+					dev_info(&client->dev,
+						"%s: Unable to get attn irq %d."
+						" Reverting to polling.\n",
+						__func__, id->irq);
+					id->rpd.polling_required = true;
+				} else {
+					dev_dbg(&client->dev,
+						"rmi_i2c_probe: got irq.\n");
+					id->rpd.polling_required = false;
+					id->rpd.irq = id->irq;
+				}
+			} else {
+				id->rpd.polling_required = true;
+				dev_info(&client->dev,
+						"%s: No IRQ info given. "
+						"Polling required.\n",
+						__func__);
+			}
+		}
+	}
+
+	/* if went through all the platform data list and didn't find a match
+	then notify that we are defaulting to polling */
+	if (!found) {
+		dev_info(&client->dev,
+			"%s: No platform data match found. "
+			"Defaulting to use polling.\n",
+			__func__);
+	}
+
+	/* Store the instance data in the i2c_client - we need to do this prior
+	 * to calling register_physical_driver since it may use the read, write
+	 * functions. If nothing was found then the id fields will be set to 0
+	 * for the irq and the default  will be set to polling required so we
+	 * will still work but in polling mode. */
+	i2c_set_clientdata(client, id);
+
+	/* Copy i2c_client pointer into instance_data's i2c_client pointer for
+	later use in rmi4_read, rmi4_write, etc. */
+	id->i2cclient = client;
+
+	/* Register physical driver - this will call the detect function that
+	 will then scan the device and determine the supported RMI4 functions.
+	 */
+	retval = rmi_register_phys_driver(&id->rpd);
+	if (retval) {
+		dev_err(&client->dev, "%s: Failed to Register %s phys driver\n",
+				__func__, id->rpd.name);
+		i2c_set_clientdata(client, NULL);
+		/* only free irq if we have an irq - otherwise the instance_data
+		will be 0 for that field since kzalloc was used to alloc id */
+		if (id->irq)
+			free_irq(id->irq, id);
+		kfree(id);
+		return retval;
+	}
+
+	dev_dbg(&client->dev, "%s: Successfully Registered %s phys driver\n",
+			__func__, id->rpd.name);
+
+	return retval;
+}
+
+/* The Driver remove function.  We tear down the instance data and unregister
+ * the phys driver in this call.
+ */
+static int
+rmi_i2c_remove(struct i2c_client *client)
+{
+	struct instance_data *id = i2c_get_clientdata(client);
+
+	pr_debug("%s: Unregistering phys driver %s\n", __func__, id->rpd.name);
+
+	rmi_unregister_phys_driver(&id->rpd);
+
+	dev_dbg(&client->dev, "%s: Unregistered phys driver %s\n",
+			__func__, id->rpd.name);
+
+	/* only free irq if we have an irq - otherwise the instance_data
+	will be 0 for that field */
+	if (id->irq)
+		free_irq(id->irq, id);
+
+	kfree(id);
+	dev_dbg(&client->dev, "%s: Remove successful\n", __func__);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int
+rmi_i2c_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+	/* Touch sleep mode */
+	return 0;
+}
+
+static int
+rmi_i2c_resume(struct i2c_client *client)
+{
+	/* Re-initialize upon resume */
+	return 0;
+}
+#else
+#define rmi_i2c_suspend	NULL
+#define rmi_i2c_resume	NULL
+#endif
+
+/*
+ * This structure tells the i2c subsystem about us.
+ *
+ * TODO: we should add .suspend and .resume fns.
+ *
+ */
+static struct i2c_driver rmi_i2c_driver = {
+	.probe		= rmi_i2c_probe,
+	.remove		= rmi_i2c_remove,
+	.suspend	= rmi_i2c_suspend,
+	.resume		= rmi_i2c_resume,
+	.driver = {
+		.name  = DRIVER_NAME,
+		.owner = THIS_MODULE,
+	},
+	.id_table	= rmi_i2c_id_table,
+};
+
+/*
+ * Register ourselves with i2c Chip Driver.
+ *
+ */
+static int __init rmi_phys_i2c_init(void)
+{
+	return i2c_add_driver(&rmi_i2c_driver);
+}
+
+/*
+ * Un-register ourselves from the i2c Chip Driver.
+ *
+ */
+static void __exit rmi_phys_i2c_exit(void)
+{
+	i2c_del_driver(&rmi_i2c_driver);
+}
+
+
+module_init(rmi_phys_i2c_init);
+module_exit(rmi_phys_i2c_exit);
+
+MODULE_AUTHOR("Synaptics, Inc.");
+MODULE_DESCRIPTION("RMI4 Driver I2C Physical Layer");
+MODULE_LICENSE("GPL");

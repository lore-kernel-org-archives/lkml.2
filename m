Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617Ab1CBFCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 00:02:10 -0500
Received: from [12.234.97.163] ([12.234.97.163]:45776 "EHLO
	archaeopteryx.synaptics.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750714Ab1CBFBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 00:01:55 -0500
X-Greylist: delayed 2084 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Mar 2011 00:01:54 EST
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Christopher Heiny <cheiny@synaptics.com>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [PATCH 1/1] input synaptics-rmi4: Synaptics RMI4 Touchscreen Driver
Date: Tue,  1 Mar 2011 20:26:35 -0800
Message-Id: <1299039995-11055-2-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299039995-11055-1-git-send-email-cheiny@synaptics.com>
References: <1299039995-11055-1-git-send-email-cheiny@synaptics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver for Synaptics touchscreens using RMI4 protocol.

Signed-off-by: William Manson <wmanson@synaptics.com>
Signed-off-by: Allie Xiong <axiong@synaptics.com>
Signed-off-by: Christopher Heiny <cheiny@synaptics.com>

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>

Acked-by: Jean Delvare <khali@linux-fr.org>

---

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index b62139b..48219b3 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -314,7 +314,24 @@ config TOUCHSCREEN_SYNAPTICS_RMI4_I2C
 	  If unsure, say N.
 
 	  To compile this driver as a set of modules, choose M here: the
-	  modules will be called rmi, rmi_app_touchpad, rmi_phys_i2c.
+	  modules will be called rmi_core, rmi_app_touchpad, rmi_phys_i2c.
+
+config TOUCHSCREEN_SYNAPTICS_RMI4_SPI
+	tristate "Synaptics RMI4 SPI touchscreens"
+	depends on SPI
+	help
+	  Say Y here if you have a Synaptics RMI4 SPI touchscreen connected to
+	  your system. This enables support for Synaptics RMI4 over SPI based
+	  touchscreens.
+
+	  If unsure, say N.
+
+	  To compile this driver as a set of modules, choose M here: the
+	  modules will be called rmi_core, rmi_app_touchpad, rmi_phys_spi.
+
+config SYNA_MULTI_TOUCH
+	bool "Synaptics pointing using multi-touch events"
+	depends on TOUCHSCREEN_SYNAPTICS_RMI4_I2C || TOUCHSCREEN_SYNAPTICS_RMI4_SPI
 
 config TOUCHSCREEN_TOUCHRIGHT
 	tristate "Touchright serial touchscreen"
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index b81109b..a17e03e 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -31,7 +31,8 @@ obj-$(CONFIG_TOUCHSCREEN_USB_COMPOSITE)	+= usbtouchscreen.o
 obj-$(CONFIG_TOUCHSCREEN_PCAP)		+= pcap_ts.o
 obj-$(CONFIG_TOUCHSCREEN_PENMOUNT)	+= penmount.o
 obj-$(CONFIG_TOUCHSCREEN_S3C2410)	+= s3c2410_ts.o
-obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_RMI4_I2C)	+= rmi_core.o rmi_app_touchpad.o rmi_function_11.o rmi_phys_i2c.o
+obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_RMI4_I2C)	+=  rmi_bus.o rmi_sensor.o rmi_function.o rmi_f01.o rmi_f11.o rmi_f34.o rmi_i2c.o
+obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_RMI4_SPI)	+=  rmi_bus.o rmi_sensor.o rmi_function.o rmi_f01.o rmi_f11.o rmi_f34.o rmi_spi.o
 obj-$(CONFIG_TOUCHSCREEN_TOUCHIT213)	+= touchit213.o
 obj-$(CONFIG_TOUCHSCREEN_TOUCHRIGHT)	+= touchright.o
 obj-$(CONFIG_TOUCHSCREEN_TOUCHWIN)	+= touchwin.o
diff --git a/drivers/input/touchscreen/rmi.h b/drivers/input/touchscreen/rmi.h
index 7cec9b8..c90b8e7 100644
--- a/drivers/input/touchscreen/rmi.h
+++ b/drivers/input/touchscreen/rmi.h
@@ -1,7 +1,7 @@
 /**
  *
  * Synaptics Register Mapped Interface (RMI4) Header File.
- * Copyright (c) 2007 - 2010, Synaptics Incorporated
+ * Copyright (c) 2007 - 2011, Synaptics Incorporated
  *
  *
  */
@@ -43,48 +43,6 @@ struct rmi_function_descriptor {
 	unsigned char functionNum;
 };
 
-/* For each function present on the RMI device, there will be a corresponding
- * entry in the functions list of the rmi_module_info structure.  This entry
- * gives information about the number of data sources and the number of data
- * registers associated with the function.
- */
-struct rmi_function_info {
-	unsigned char functionNum;
-
-	/* This is the number of data sources associated with the function.*/
-	unsigned char numSources;
-
-	/* This is the number of data points supported - for example, for
-	*  function $11 (2D sensor) the number of data points is equal to the
-	*  number of fingers - for function $19 (buttons)it is the number of
-	*  buttons.
-	*/
-	unsigned char numDataPoints;
-
-	/* This is the number of data registers to read.*/
-	unsigned char dataRegBlockSize;
-
-	/* This is the interrupt register and mask - needed for enabling the
-	*  interrupts and for checking what source had caused the attention line
-	* interrupt.
-	*/
-	unsigned char interruptRegister;
-	unsigned char interruptMask;
-
-	/* This is the RMI function descriptor associated with this function.
-	*  It contains the Base addresses for the functions query, command,
-	*  control, and data registers.
-	*/
-	struct rmi_function_descriptor funcDescriptor;
-
-	/* A list of the function information.
-	*  This list uses the standard kernel linked list implementation.
-	*  Documentation on on how to use it can be found at
-	*  http://isis.poly.edu/kulesh/stuff/src/klist/.
-	*/
-	struct list_head link;
-};
-
 /*  This encapsulates the information found using the RMI4 Function $01
  *  query registers. There is only one Function $01 per device.
  *
@@ -98,7 +56,7 @@ struct rmi_function_info {
  *  Guide" document : go to http://www.synaptics.com/developers/manuals - and
  *  select "Synaptics RMI 4 Interfacting Guide".
  */
-struct rmi_module_info {
+struct rmi_F01_query {
 	/* The Protocol Major Version number.*/
 	unsigned rmi_maj_ver;
 
@@ -124,83 +82,66 @@ struct rmi_module_info {
 	unsigned short serial_num;
 
 	/* A null-terminated string that identifies this particular product.*/
-	char prod_id[10];
-
-	/* A list of the function presence queries.
-	*  This list uses the standard kernel linked list implementation.
-	*  Documentation on on how to use it can be found at
-	*  http://isis.poly.edu/kulesh/stuff/src/klist/.
-	*/
-	struct list_head functions;
+	char prod_id[11];
 };
 
-struct rmi_phys_driver {
-	char *name;
-	int (*write)(struct rmi_phys_driver *pd, unsigned short address,
-			char data);
-	int (*read)(struct rmi_phys_driver *pd, unsigned short address,
-			char *buffer);
-	int (*write_multiple)(struct rmi_phys_driver *pd,
-			unsigned short address, char *buffer, int length);
-	int (*read_multiple)(struct rmi_phys_driver *pd, unsigned short address,
-			char *buffer, int length);
-	void (*attention)(struct rmi_phys_driver *pd, int instance);
-	bool polling_required;
-	int irq;
-
-	/* Standard kernel linked list implementation.
-	*  Documentation on how to use it can be found at
-	*  http://isis.poly.edu/kulesh/stuff/src/klist/.
-	*/
-	struct list_head drivers;
-	struct rmi_application *app;
-	struct rmi_module_info rmi;
-	struct module *module;
+/* This encapsulates the F01 Device Control control registers.
+ * TODO: This isn't right.  The number of interrupt enables needs to be determined
+ * dynamically as the sensor is initialized.  Fix this.
+ */
+struct rmi_F01_control {
+    unsigned char deviceControl;
+    unsigned char interruptEnable[1];
 };
 
-int rmi_read(struct rmi_application *app, unsigned short address, char *dest);
-int rmi_write(struct rmi_application *app, unsigned short address,
-		unsigned char data);
-int rmi_read_multiple(struct rmi_application *app, unsigned short address,
-		char *dest, int length);
-int rmi_write_multiple(struct rmi_application *app, unsigned short address,
-		unsigned char *data, int length);
-int rmi_register_phys_driver(struct rmi_phys_driver *rpd);
-int rmi_unregister_phys_driver(struct rmi_phys_driver *rpd);
-
-struct rmi_application *rmi_register_application(const char *name,
-	void (*attention)(struct rmi_phys_driver *pd, int instance),
-	int (*probe)(struct rmi_application *app,
-	const struct rmi_module_info *rmi),
-	void (*config)(struct rmi_application *app));
-
-void rmi_unregister_application(struct rmi_application *app);
-bool rmi_polling_required(struct rmi_application *app);
-
-/* Set this to 1 to turn on code used in detecting buffer leaks. */
-#define RMI_ALLOC_STATS 1
-
-#if RMI_ALLOC_STATS
-extern int appallocsrmi;
-extern int rfiallocsrmi;
-extern int fnallocsrmi;
-
-#define INC_ALLOC_STAT(X)   (X##allocsrmi++)
-#define DEC_ALLOC_STAT(X)   \
-	do { \
-		if (X##allocsrmi) X##allocsrmi--; \
-		else printk(KERN_DEBUG "Too many " #X " frees\n"); \
-	} while (0)
-#define CHECK_ALLOC_STAT(X) \
-	do { \
-		if (X##allocsrmi) \
-			printk(KERN_DEBUG "Left over " #X " buffers: %d\n", \
-					X##allocsrmi); \
-	} while (0)
-#else
-#define INC_ALLOC_STAT(X) do { } while (0)
-#define DEC_ALLOC_STAT(X) do { } while (0)
-#define CHECK_ALLOC_STAT(X) do { } while (0)
-#endif
+/** This encapsulates the F01 Device Control data registers.
+ * TODO: This isn't right.  The number of irqs needs to be determined
+ * dynamically as the sensor is initialized.  Fix this.
+ */
+struct rmi_F01_data {
+    unsigned char deviceStatus;
+    unsigned char irqs[1];
+};
+
+
+/**********************************************************/
+
+/** This is the data read from the F11 query registers.
+ */
+struct rmi_F11_device_query {
+    bool hasQuery9;
+    unsigned char numberOfSensors;
+};
+
+struct rmi_F11_sensor_query {
+    bool configurable;
+    bool hasSensitivityAdjust;
+    bool hasGestures;
+    bool hasAbs;
+    bool hasRel;
+    unsigned char numberOfFingers;
+    unsigned char numberOfXElectrodes;
+    unsigned char numberOfYElectrodes;
+    unsigned char maximumElectrodes;
+    bool hasAnchoredFinger;
+    unsigned char absDataSize;
+};
+
+struct rmi_F11_control {
+    bool relativeBallistics;
+    bool relativePositionFilter;
+    bool absolutePositionFilter;
+    unsigned char reportingMode;
+    bool manuallyTrackedFinger;
+    bool manuallyTrackedFingerEnable;
+    unsigned char motionSensitivity;
+    unsigned char palmDetectThreshold;
+    unsigned char deltaXPosThreshold;
+    unsigned char deltaYPosThreshold;
+    unsigned char velocity;
+    unsigned char acceleration;
+    unsigned short sensorMaxXPos;
+    unsigned short sensorMaxYPos;
+};
 
 #endif
diff --git a/drivers/input/touchscreen/rmi_app_touchpad.c b/drivers/input/touchscreen/rmi_app_touchpad.c
deleted file mode 100644
index 5f3bd81..0000000
--- a/drivers/input/touchscreen/rmi_app_touchpad.c
+++ /dev/null
@@ -1,400 +0,0 @@
-/**
- *
- * Synaptics Register Mapped Interface (RMI4) TouchPad Application Layer Driver.
- * Copyright (c) 2007 - 2010, Synaptics Incorporated
- *
- *
- * This code implements a polling mechanism using a timer as well as
- * interrupt-driven sampling.
- *
- * Note that it is the lower-level drivers that determine whether this driver
- * has to do polling or interrupt-driven.  Polling can always be done, but if
- * we have an interrupt connected to the attention (ATTN) line, then it is
- * better to be interrupt driven.
- *
- */
-/*
- * This file is licensed under the GPL2 license.
- *
- *#############################################################################
- * GPL
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2 as published
- * by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
- * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
- * for more details.
- *
- *#############################################################################
- */
-
-#include <linux/kernel.h>
-#include <linux/device.h>
-#include <linux/delay.h>
-#include <linux/hrtimer.h>
-#include <linux/kthread.h>
-#include <linux/freezer.h>
-#include <linux/input.h>
-#include <linux/interrupt.h>
-
-#include "rmi.h"
-#include "rmi_core.h"
-#include "rmi_functions.h"
-
-#define RMI_REPORT_RATE_80 0
-#define RMI_REPORT_RATE_40 (1 << 6)
-
-static long polltime = 25000000;
-module_param(polltime, long, 0644);
-MODULE_PARM_DESC(polltime, "How long to wait between polls (in nano seconds).");
-
-static struct rmi_application *app;
-
-/* TODO: We should move this to the application data struct and allow more than
-	one input device per system. We'll address in a follow up patch. */
-static struct input_dev *input;
-
-/* RMI4 device control == function 0x01 */
-extern unsigned short fn01ControlBaseAddr;
-/* number of total interrupt registers to read */
-extern unsigned int interruptRegisterCount;
-
-
-/**
- * This is the function we pass to the RMI4 subsystem so we can be notified
- * when attention is required.  It may be called in interrupt context.
- */
-static void attention(struct rmi_phys_driver *rpd, int instance)
-{
-	/* All we have to do is schedule work. */
-	schedule_work(&(rpd->app->work));
-}
-
-/**
- * This is the meat of the driver.  It reads in all data sources and reports
- * them to the input subsystem.  It is used for both polling and interrupt
- * driven operation.
- */
-int report_sensor_data(struct rmi_application *app)
-{
-	unsigned char interruptStatus[4] = {0, 0, 0, 0};
-	int touch; /* number of touch points - fingers or buttons */
-	struct rmi_functions *fn;
-	struct rmi_function_info *rfi;
-	struct rmi_phys_driver *rpd;
-	struct rmi_module_info *rmi;
-	static int num_error_reports;
-
-	touch = 0;
-
-	/* Get the interrupt status from the function $01 control register+1 to
-	find which source(s) were interrupting so we can read the data from the
-	source(s) (2D sensor, buttons, etc.).
-	*/
-	if (rmi_read_multiple(app, fn01ControlBaseAddr + 1,
-			interruptStatus, interruptRegisterCount)) {
-		printk(KERN_ERR "%s: Could not read interrupt status registers 0x%x\n",
-				__func__, fn01ControlBaseAddr + 1);
-		return 0;
-	}
-
-	/* check each function that has data sources and if the interrupt for
-	 * that triggered then call that RMI4 functions report() function to
-	 * gather data and report it to the input subsystem */
-	rpd = app->rpd; /* get ptr to rmi_physical_driver from app */
-	rmi = &(rpd->rmi); /* get ptr to rmi_module_info from physical driver */
-
-	list_for_each_entry(rfi, &rmi->functions, link) {
-		if (rfi->numSources) {
-			if (interruptStatus[rfi->interruptRegister] &
-					rfi->interruptMask) {
-				bool found;
-				found = false;
-				fn = rmi_find_function(rfi->functionNum);
-				if (fn) {
-					found = true;
-					if (fn->report) {
-						touch = fn->report(app,
-							rfi, fn->input);
-					} else {
-						num_error_reports++;
-						if (num_error_reports < 6) {
-							/* the developer did not add in the
-							pointer to the report function into
-							rmi4_supported_data_src_functions */
-							printk(KERN_ERR "%s: no find report function for function 0x%x\n", __func__, fn->functionNum);
-						}
-					}
-				}
-
-				if (!found) {
-					num_error_reports++;
-					if (num_error_reports < 6) {
-						/* if no support found for this
-						RMI4 function it means the
-						developer did not add the
-						appropriate function pointer
-						list into the rmi4_supported_data_src_functions
-						array and/or did not bump up
-						the number of supported RMI4
-						functions in rmi.h as required.
-						*/
-						printk(KERN_ERR "%s: could not find any support for function 0x%x\n", __func__, fn->functionNum);
-					}
-				}
-			}
-		}
-	}
-
-	/* return the number of touch points - fingers down and/or buttons
-	 * pressed, etc. */
-	return touch;
-}
-
-/* This is the worker function  - it simply has to call report_sensor_data. */
-static void ts_work_func(struct work_struct *work)
-{
-	struct  rmi_application *app = container_of(work,
-			struct rmi_application, work);
-
-	report_sensor_data(app);
-
-	/* we only need to enable the irq if doing interrupts */
-	if (!rmi_polling_required(app))
-		enable_irq(app->rpd->irq);
-}
-
-/* This is the timer function for polling - it simply has to schedule work
- * and restart the timer. */
-static enum hrtimer_restart ts_poll_timer_func(struct hrtimer *timer)
-{
-	struct  rmi_application *app = container_of(timer,
-			struct rmi_application, timer);
-
-	schedule_work(&app->work);
-	hrtimer_start(&app->timer, ktime_set(0, polltime), HRTIMER_MODE_REL);
-	return HRTIMER_NORESTART;
-}
-
-/**
- * This is the probe function passed to the RMI4 subsystem that gives us a
- * chance to recognize an RMI4 device.  In this case, we're looking for
- * Synaptics devices that have data sources - such as touch screens, buttons,
- * etc.
- */
-static int probe(struct rmi_application *app,
-		const struct rmi_module_info *rmi)
-{
-	struct rmi_function_info *rfi;
-	int data_sources = 0;
-	int retval = 0;
-
-	if (!rmi) {
-		printk(KERN_ERR "%s: Invalid module info: %p\n", __func__, rmi);
-		return 0;
-	}
-
-	/* Check if this is a Synaptics device - report if not. */
-	if (rmi->mfgid != 1) { /* Synaptics? */
-		printk(KERN_INFO "%s: non-Synaptics mfg id: %d\n",
-				__func__, rmi->mfgid);
-	}
-
-	/* for each function entry in the list accumulate it's number of data
-	sources */
-	list_for_each_entry(rfi, &rmi->functions, link) {
-		data_sources += rfi->numSources;
-	}
-
-	if (data_sources) {
-		retval = 1;
-		/* We have detected one or more data sources such as
-		2D Sensors, buttons, etc. */
-		printk(KERN_INFO "%s: Found %d data sources for : %p\n",
-				__func__, data_sources, rmi);
-	} else {
-		/* we don't have any data sources for this sensor - oops!
-		- either an un-flashed sensor or bad!! */
-		printk(KERN_INFO "%s: No data sources found for : %p\n",
-				__func__, rmi);
-	}
-
-	return retval;
-}
-
-static void config(struct rmi_application *app)
-{
-	/* For each data source we had detected print info and set up interrupts
-	or polling. */
-	struct rmi_function_info *rfi;
-	struct rmi_phys_driver *rpd;
-	struct rmi_module_info *rmi;
-
-	rpd = app->rpd; /* get ptr to rmi_physical_driver from app */
-	rmi = &(rpd->rmi); /* get ptr to rmi_module_info from physical driver */
-
-	list_for_each_entry(rfi, &rmi->functions, link) {
-		if (rfi->numSources) {
-			/* This function has data sources associated with it.*/
-			/* Get and print some info about the data sources... */
-			struct rmi_functions *fn;
-			bool found = false;
-			/* check if function number matches - if so call that
-			config function */
-			fn = rmi_find_function(rfi->functionNum);
-			if (fn) {
-				found = true;
-				if (fn->config) {
-					fn->config(app, rfi);
-				} else {
-					/* the developer did not add in the
-					pointer to the config function into
-					rmi4_supported_data_src_functions */
-					printk(KERN_ERR
-						"%s: no config function for "
-						"function 0x%x\n",
-						__func__, rfi->functionNum);
-					break;
-				}
-			}
-
-			if (!found) {
-				/* if no support found for this RMI4 function
-				it means the developer did not add the
-				appropriate function pointer list into the
-				rmi4_supported_data_src_functions array and/or
-				did not bump up the number of supported RMI4
-				functions in rmi.h as required */
-				printk(KERN_ERR"%s: could not find support "
-					"for function 0x%x\n",
-					__func__, rfi->functionNum);
-			}
-
-			/* if we are not doing polling then enable the
-			interrupts for the data sources for this function */
-			if (!rmi_polling_required(app)) {
-				/* Turn on interrupts for this
-				function's data sources. */
-				rmi_write(app, fn01ControlBaseAddr + 1 +
-						rfi->interruptRegister,
-						rfi->interruptMask);
-				printk(KERN_INFO
-					"%s: Interrupt Driven - turning on "
-					"interrupts for function 0x%x\n",
-					__func__, rfi->functionNum);
-			}
-		}
-	}
-
-	/* if we are not polling we need to set up the interrupt worker
-	thread - otherwise we need to set up the polling callback and
-	worker thread. */
-	if (!rmi_polling_required(app)) {
-		/* We're interrupt driven, so set up packet rate and the worker
-		thread function. */
-		if (HZ < 500) {
-			/* The default packet rate of 80 packets per
-			* second is too fast (the Linux time slice for
-			* sub-GHz processors is only 100 times per second).
-			* So re-program it to 40 packets per second.
-			*/
-			rmi_write(app, fn01ControlBaseAddr, RMI_REPORT_RATE_40);
-		}
-
-		INIT_WORK(&app->work, ts_work_func);
-
-	} else {
-		/* We're polling driven, so set up the polling timer
-		and timer function. */
-		INIT_WORK(&app->work, ts_work_func);
-		hrtimer_init(&app->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-		app->timer.function = ts_poll_timer_func;
-		hrtimer_start(&app->timer, ktime_set(1, 0), HRTIMER_MODE_REL);
-	}
-}
-
-/**
- * The module initialization function in which we register as a RMI4
- * application driver.  We also register with the input subsystem so we can
- * pass coordinates to it.
- */
-static int __init rmi_app_touchpad_init(void)
-{
-	int retval;
-
-	retval = 0;
-
-	pr_debug("%s: RMI4 TouchPad Driver\n", __func__);
-
-	/* NOTE: we are creating only one input dev file for this but
-	theoretically you could create a separate one for each data
-	source and store it below. This will let you put 2D sensor
-	events into one dev file, button events into a separate dev file,
-	other data source event like GPIOs, etc. into yet a third dev file.
-	As this is being coded it will dump all events into the one dev file.
-	*/
-	input = input_allocate_device();
-	if (input == NULL) {
-		printk(KERN_ERR "%s:  Failed to allocate memory for a "
-			"new input device.\n",
-			__func__);
-		return -ENOMEM;
-	}
-
-	input->name = "RMI4 Touchpad";
-	input->phys = "rmi_app_touchpad";
-
-	/* Set input device specific params for each data source...*/
-	retval = rmi_functions_init(input);
-
-	if (retval) {
-		printk(KERN_ERR "%s:  Failed rmi_functions_init.\n", __func__);
-		return retval;
-	}
-
-	retval = input_register_device(input);
-
-	if (retval) {
-		printk(KERN_ERR "%s:  Failed input_register_device.\n",
-			__func__);
-		return retval;
-	}
-
-	app = rmi_register_application("rmi4_touchpad",
-		attention, probe, config);
-
-	if (!app) {
-		printk(KERN_ERR "%s:  Failed to register app.\n", __func__);
-		input_unregister_device(input);
-		retval = -ENODEV;
-	}
-
-	return retval;
-}
-
-static void __exit rmi_app_touchpad_exit(void)
-{
-	pr_debug("%s: RMI4 TouchPad Driver\n", __func__);
-
-	/* Stop the polling timer if doing polling */
-	if (rmi_polling_required(app))
-		hrtimer_cancel(&app->timer);
-
-	flush_scheduled_work(); /* Make sure all scheduled work is stopped */
-
-	/* Unregister everything */
-	printk(KERN_WARNING "%s: Unregistering app - %s\n",
-		__func__, app->name);
-	rmi_unregister_application(app);
-	input_unregister_device(input);
-}
-
-module_init(rmi_app_touchpad_init);
-module_exit(rmi_app_touchpad_exit);
-
-MODULE_AUTHOR("Synaptics, Inc.");
-MODULE_DESCRIPTION("RMI4 Driver");
-MODULE_LICENSE("GPL");
diff --git a/drivers/input/touchscreen/rmi_bus.c b/drivers/input/touchscreen/rmi_bus.c
new file mode 100755
index 0000000..15b83a1
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_bus.c
@@ -0,0 +1,388 @@
+/**
+ * Synaptics Register Mapped Interface (RMI4) - RMI Bus Module.
+ * Copyright (C) 2007 - 2011, Synaptics Incorporated
+ *
+ * Impliments "rmi" bus per Documentation/driver-model/bus.txt
+ *
+ * This protocol is layered as follows.
+ *
+ *
+ *
+ *  +-------+ +-------+ +-------+ +--------+
+ *  | Fn32  | |   Fn11| |  Fn19 | |  Fn11  |   Devices/Functions
+ *  *---|---+ +--|----+ +----|--+ +----|---*   (2D, cap. btns, etc.)
+ *      |        |           |         |
+ *  +----------------+      +----------------+
+ *  | Sensor0        |      |  Sensor1       | Sensors Dev/Drivers
+ *  +----------------+      +----------------+ (a sensor has one or
+ *          |                      |            more functions)
+ *          |                      |
+ *  +----------------------------------------+
+ *  |                                        |
+ *  |                RMI4 Bus                | RMI Bus Layer
+ *  |                (this file)             |
+ *  *--|-----|------|--------------|---------*
+ *     |     |      |              |
+ *     |     |      |              |
+ *  +-----+-----+-------+--------------------+
+ *  | I2C | SPI | SMBus |         etc.       | Physical Layer
+ *  +-----+-----+-------+--------------------+
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
+static const char busname[] = "rmi";
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/hrtimer.h>
+#include <linux/list.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include <linux/delay.h>
+#include <linux/uaccess.h>
+#include <linux/slab.h>
+
+#include "rmi_drvr.h"
+#include "rmi.h"
+#include "rmi_bus.h"
+#include "rmi_sensor.h"
+#include "rmi_function.h"
+
+/* list of physical drivers - i2c, spi, etc. */
+static LIST_HEAD(phys_drivers);
+static DEFINE_MUTEX(phys_drivers_mutex);
+
+/* list of sensors found on a physical bus (i2c, smi, etc.)*/
+static LIST_HEAD(sensor_drivers);
+static DEFINE_MUTEX(sensor_drivers_mutex);
+static LIST_HEAD(sensor_devices);
+static DEFINE_MUTEX(sensor_devices_mutex);
+
+#define PDT_START_SCAN_LOCATION 0x00E9
+#define PDT_END_SCAN_LOCATION 0x0005
+#define PDT_ENTRY_SIZE 0x0006
+
+/* definitions for rmi bus */
+struct device rmi_bus_device;
+
+struct bus_type rmi_bus_type;
+EXPORT_SYMBOL(rmi_bus_type);
+
+
+/*
+ * This method is called, perhaps multiple times, whenever a new device or driver
+ * is added for this bus. It should return a nonzero value if the given device can be
+ * handled by the given driver. This function must be handled at the bus level,
+ * because that is where the proper logic exists; the core kernel cannot know how
+ * to match devices and drivers for every possible bus type
+ * The match function does a comparison between the hardware ID provided by
+ * the device itself and the IDs supported by the driver.
+ *
+ */
+static int rmi_bus_match(struct device *dev, struct device_driver *driver)
+{
+	printk(KERN_DEBUG "%s: Matching %s for rmi bus.\n", __func__, dev->bus->name);
+	return !strncmp(dev->bus->name, driver->name, strlen(driver->name));
+}
+
+/** Stub for now.
+ */
+static int rmi_bus_suspend(struct device *dev, pm_message_t state)
+{
+	printk(KERN_INFO "%s: RMI bus suspending.", __func__);
+	return 0;
+}
+
+/** Stub for now.
+ */
+static int rmi_bus_resume(struct device *dev)
+{
+	printk(KERN_INFO "%s: RMI bus resuming.", __func__);
+	return 0;
+}
+
+/*
+ * This method is called, whenever a new device is added for this bus.
+ * It will scan the devices PDT to get the function $01 query, control,
+ * command and data regsiters so that it can create a function $01 (sensor)
+ * device for the new physical device. It also caches the PDT for later use by
+ * other functions that are created for the device. For example, if a function
+ * $11 is found it will need the query, control, command and data register
+ * addresses for that function. The new function could re-scan the PDT but
+ * since it is being done here we can cache it and keep it around.
+ *
+ * TODO: If the device is reset or some action takes place that would invalidate
+ * the PDT - such as a reflash of the firmware - then the device should be re-added
+ * to the bus and the PDT re-scanned and cached.
+ *
+ */
+int rmi_register_sensors(struct rmi_phys_driver *rpd)
+{
+	int i;
+	struct rmi_sensor_device *rmi_sensor_dev;
+	struct rmi_function_info *rfi;
+	struct rmi_function_descriptor rmi_fd;
+	int retval;
+	static int index;
+
+	/* Make sure we have a read, write, read_multiple, write_multiple
+	function pointers from whatever physical layer the sensor is on.
+	*/
+	if (!rpd->name) {
+		printk(KERN_ERR "%s: Physical driver must specify a name\n",
+			__func__);
+		return -EINVAL;
+	}
+	if (!rpd->write) {
+		printk(KERN_ERR
+			"%s: Physical driver %s must specify a writer.\n",
+			__func__, rpd->name);
+		return -EINVAL;
+	}
+	if (!rpd->read) {
+		printk(KERN_ERR
+			"%s: Physical driver %s must specify a reader.\n",
+			__func__, rpd->name);
+		return -EINVAL;
+	}
+	if (!rpd->write_multiple) {
+		printk(KERN_ERR "%s: Physical driver %s must specify a "
+			"multiple writer.\n",
+			__func__, rpd->name);
+		return -EINVAL;
+	}
+	if (!rpd->read_multiple) {
+		printk(KERN_ERR "%s: Physical driver %s must specify a "
+			"multiple reader.\n",
+			__func__, rpd->name);
+		return -EINVAL;
+	}
+
+	/* Get some information from the device */
+	printk(KERN_INFO "%s: Identifying sensors by presence of F01...\n", __func__);
+
+	rmi_sensor_dev = NULL;
+
+	/* Read the Page Descriptor Table to determine what functions
+	are present */
+	for (i = PDT_START_SCAN_LOCATION;	/* Register the rmi sensor driver */
+			i >= PDT_END_SCAN_LOCATION;
+			i -= PDT_ENTRY_SIZE) {
+		retval = rpd->read_multiple(rpd, i, (char *)&rmi_fd,
+				sizeof(rmi_fd));
+		if (!retval) {
+			rfi = NULL;
+
+			if (rmi_fd.functionNum != 0x00 && rmi_fd.functionNum != 0xff) {
+				if ((rmi_fd.functionNum & 0xff) == 0x01) {
+					printk(KERN_INFO "%s: F01 Found - RMI Device Control\n", __func__);
+
+					/* This appears to be a valid device, so create a sensor
+					* device and sensor driver for it. */
+					rmi_sensor_dev = kzalloc(sizeof(*rmi_sensor_dev), GFP_KERNEL);
+					if (!rmi_sensor_dev) {
+						printk(KERN_ERR "%s: Error allocating memory for rmi_sensor_device\n", __func__);
+						return -ENOMEM;
+					}
+					rmi_sensor_dev->dev.bus = &rmi_bus_type;
+
+					retval = rmi_sensor_register_device(rmi_sensor_dev, index++);
+					if (retval < 0) {
+						printk(KERN_ERR "%s: Error %d registering sensor device\n", __func__, retval);
+						goto exit_fail;
+					}
+
+					rmi_sensor_dev->driver = kzalloc(sizeof(struct rmi_sensor_driver), GFP_KERNEL);
+					if (!rmi_sensor_dev->driver) {
+						printk(KERN_ERR "%s: Error allocating memory for rmi_sensor_driver\n", __func__);
+						return -ENOMEM;
+					}
+					rmi_sensor_dev->driver->sensor_device = rmi_sensor_dev;
+					rmi_sensor_dev->driver->polling_required = rpd->polling_required;
+					rmi_sensor_dev->driver->rpd = rpd;
+					INIT_LIST_HEAD(&rmi_sensor_dev->driver->functions);
+
+					retval = rmi_sensor_register_driver(rmi_sensor_dev->driver);
+					if (retval < 0) {
+						printk(KERN_ERR "%s: Error %d registering sensor driver\n", __func__, retval);
+						goto exit_fail;
+					}
+
+					/* link the attention fn in the rpd to the sensor attn fn */
+					printk(KERN_DEBUG "%s: linking sensor driver attention fn to rmi_phys_driver attention fn.\n", __func__);
+					rpd->sensor = rmi_sensor_dev->driver;
+					rpd->attention = rmi_sensor_dev->driver->attention;
+
+					/* Add it into the list of sensors on the rmi bus */
+					mutex_lock(&sensor_devices_mutex);
+					list_add_tail(&rmi_sensor_dev->sensors, &sensor_devices);
+					mutex_unlock(&sensor_devices_mutex);
+
+					/* All done with this sensor, fall out of PDT scan loop. */
+					break;
+				} else {
+					/* Just print out the function found for now */
+					printk(KERN_INFO "%s: Found Function %02x - Ignored.\n", __func__, rmi_fd.functionNum & 0xff);
+				}
+			} else {
+				/* A zero or 0xff in the function number
+				signals the end of the PDT */
+				pr_debug("%s:   Found End of PDT\n",
+					__func__);
+				break;
+			}
+		} else {
+			/* failed to read next PDT entry - end PDT
+			scan - this may result in an incomplete set
+			of recognized functions - should probably
+			return an error but the driver may still be
+			viable for diagnostics and debugging so let's
+			let it continue. */
+			printk(KERN_ERR "%s: Read Error %d when reading next PDT entry - "
+				"ending PDT scan.\n",
+				__func__, retval);
+			break;
+		}
+	}
+
+	/* If we actually found a sensor, keep it around. */
+	if (rmi_sensor_dev) {
+		/* Add physical driver struct to list */
+		mutex_lock(&phys_drivers_mutex);
+		list_add_tail(&rpd->drivers, &phys_drivers);
+		mutex_unlock(&phys_drivers_mutex);
+	}
+
+	printk(KERN_DEBUG "%s: Registered sensor drivers.\n", __func__);
+
+	return 0;
+
+exit_fail:
+	return retval;
+}
+EXPORT_SYMBOL(rmi_register_sensors);
+
+int rmi_unregister_sensors(struct rmi_phys_driver *rpd)
+{
+	if (rpd->sensor) {
+		printk(KERN_WARNING "%s: WARNING: unregister of %s while %s still attached\n",
+			__func__, rpd->name, rpd->sensor->drv.name);
+	}
+
+	pr_debug("%s: Unregistering sensor drivers %s\n", __func__, rpd->name);
+
+	mutex_lock(&sensor_drivers_mutex);
+	list_del(&rpd->sensor->sensor_drivers);
+	mutex_unlock(&sensor_drivers_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL(rmi_unregister_sensors);
+
+
+static void rmi_bus_dev_release(struct device *dev)
+{
+	printk(KERN_DEBUG "rmi bus device release\n");
+}
+
+
+int rmi_register_bus_device(struct device *rmibusdev)
+{
+	printk(KERN_DEBUG "%s: Registering RMI4 bus device.\n", __func__);
+
+	/* Here, we simply fill in some of the embedded device structure fields
+	(which individual drivers should not need to know about), and register
+	the device with the driver core. */
+
+	rmibusdev->bus = &rmi_bus_type;
+	rmibusdev->parent = &rmi_bus_device;
+	rmibusdev->release = rmi_bus_dev_release;
+	dev_set_name(rmibusdev, "rmi");
+
+	/* If we wanted to add bus-specific attributes to the device, we could do so here.*/
+
+	return device_register(rmibusdev);
+}
+EXPORT_SYMBOL(rmi_register_bus_device);
+
+void rmi_unregister_bus_device(struct device *rmibusdev)
+{
+	printk(KERN_DEBUG "%s: Unregistering bus device.\n", __func__);
+
+	device_unregister(rmibusdev);
+}
+EXPORT_SYMBOL(rmi_unregister_bus_device);
+
+static int __init rmi_bus_init(void)
+{
+	int status;
+
+	status = 0;
+
+	printk(KERN_INFO "%s: RMI Bus Driver Init\n", __func__);
+
+	/* Register the rmi bus */
+	rmi_bus_type.name = busname;
+	rmi_bus_type.match = rmi_bus_match;
+	rmi_bus_type.suspend = rmi_bus_suspend;
+	rmi_bus_type.resume = rmi_bus_resume;
+	status = bus_register(&rmi_bus_type);
+	if (status < 0) {
+		printk(KERN_ERR "%s: Error %d registering the rmi bus\n", __func__, status);
+		goto err_exit;
+	}
+	printk(KERN_DEBUG "%s: registered bus.", __func__);
+
+#if 0
+	/** This doesn't seem to be required any more.  It worked OK in Froyo,
+	 * but breaks in Gingerbread */
+	/* Register the rmi bus device - "rmi". There is only one rmi bus device. */
+	status = rmi_register_bus_device(&rmi_bus_device);
+	if (status < 0) {
+		printk(KERN_ERR "%s: Error %d registering rmi bus device\n", __func__, status);
+		bus_unregister(&rmi_bus_type);
+		goto err_exit;
+	}
+	printk(KERN_DEBUG "%s: Registered bus device.", __func__);
+#endif
+
+	return 0;
+err_exit:
+	return status;
+}
+
+static void __exit rmi_bus_exit(void)
+{
+	printk(KERN_DEBUG "%s: RMI Bus Driver Exit\n", __func__);
+
+	/* Unregister the rmi bus device - "rmi". There is only one rmi bus device. */
+	rmi_unregister_bus_device(&rmi_bus_device);
+
+	/* Unregister the rmi bus */
+	bus_unregister(&rmi_bus_type);
+}
+
+
+module_init(rmi_bus_init);
+module_exit(rmi_bus_exit);
+
+MODULE_AUTHOR("Synaptics, Inc.");
+MODULE_DESCRIPTION("RMI4 Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/input/touchscreen/rmi_bus.h b/drivers/input/touchscreen/rmi_bus.h
new file mode 100755
index 0000000..70c6b68
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_bus.h
@@ -0,0 +1,33 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) - RMI Bus Module Header.
+ * Copyright (C) 2007 - 2010, Synaptics Incorporated
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
+#ifndef _RMI_BUS_H
+#define _RMI_BUS_H
+
+
+extern struct bus_type rmi_bus_type;
+
+#endif
+
diff --git a/drivers/input/touchscreen/rmi_core.c b/drivers/input/touchscreen/rmi_core.c
deleted file mode 100644
index d25f982..0000000
--- a/drivers/input/touchscreen/rmi_core.c
+++ /dev/null
@@ -1,708 +0,0 @@
-/**
- * Synaptics Register Mapped Interface (RMI4) Data Layer Driver.
- * Copyright (C) 2007 - 2010, Synaptics Incorporated
- *
- *
- * This protocol is layered as follows.
- *
- *
- *  +----------------------------------------+
- *  |                                        |
- *  |               Application              |
- *  |                                        |
- *  +----------------------------------------+
- *  |                                        |
- *  |                RMI4 Driver             | Data Layer (THIS DRIVER)
- *  |                (this file)             |
- *  +-----+-----+-------+----------+---------+
- *  | I2C | SPI | SMBus |         etc.       | Physical Layer
- *  +-----+-----+-------+----------+---------+
- *
- *  Each of the physical layer drivers is contained in a file called
- *  rmi_phys_xxx.c.  Someone compiling the kernel enables CONFIG_RMI and then
- *  one or more CONFIG_RMI_xxx options in the .config file.  For example, when
- *  CONFIG_RMI_I2C=m is enabled, a rmi.ko and a rmi_phys_i2c.ko will be
- *  compiled.  rmi_phys_i2c.ko will depend on rmi.ko, so when rmi_phys_i2c.ko
- *  is loaded, rmi.ko will automatically be loaded.  Each of the physical
- *  layer drivers is a platform_driver that may handle suspend/resume, etc.,
- *  so this driver does not do so.
- *
- *  The register paradigm of RMI is a "pull" rather than "push" data flow.
- *  As such, it is the application driver that needs to implement either
- *  polling or interrupt driven, and the physical driver merely handles
- *  the register accesses.  For interrupt driven, the application registers
- *  an "attention" function that may be called in interrupt context by the
- *  physical driver if an attention interrupt is available.  The physical
- *  driver notifies the application through the polling_required variable,
- *  and the application driver must do one or the other based on this variable.
- *
- *  At this point in time, there can only be one application driver per
- *  physical driver.
- *
- */
-/*
- * This file is licensed under the GPL2 license.
- *
- *#############################################################################
- * GPL
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2 as published
- * by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
- * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
- * for more details.
- *
- *#############################################################################
- */
-
-static const char drvname[] = "rmi4_ts";
-
-#include <linux/kernel.h>
-#include <linux/device.h>
-#include <linux/hrtimer.h>
-#include <linux/miscdevice.h>
-#include <linux/fs.h>
-#include <linux/delay.h>
-#include <linux/uaccess.h>
-#include <linux/slab.h>
-
-#include "rmi.h"
-#include "rmi_core.h"
-#include "rmi_functions.h"
-
-/* we need these to control the device and query interrupts */
-unsigned short fn01QueryBaseAddr; /* RMI4 device control */
-EXPORT_SYMBOL(fn01QueryBaseAddr);
-unsigned short fn01ControlBaseAddr;
-EXPORT_SYMBOL(fn01ControlBaseAddr);
-unsigned int interruptRegisterCount;
-EXPORT_SYMBOL(interruptRegisterCount);
-
-#define PDT_START_SCAN_LOCATION 0x00E9
-#define PDT_END_SCAN_LOCATION 0x000A
-#define PDT_ENTRY_SIZE 0x0006
-
-static LIST_HEAD(phys_drivers);
-static DEFINE_MUTEX(phys_drivers_mutex);
-static LIST_HEAD(app_drivers);
-static DEFINE_MUTEX(app_drivers_mutex);
-static DEFINE_MUTEX(rfi_mutex);
-static LIST_HEAD(fns_list);
-static DEFINE_MUTEX(fns_mutex);
-
-
-#if RMI_ALLOC_STATS
-int appallocsrmi;
-EXPORT_SYMBOL(appallocsrmi);
-int rfiallocsrmi;
-EXPORT_SYMBOL(rfiallocsrmi);
-int fnallocsrmi;
-EXPORT_SYMBOL(fnallocsrmi);
-#endif
-
-/* NOTE: Developer - add in any new RMI4 fn data info - function number
-   and ptrs to report, config, init and detect functions.  This data is
-   used to point to the functions that need to be called to config, init,
-   detect and report data for the new RMI4 function. These only need to
-   be added for RMI4 functions that support data source - like 2D sensors,
-   buttons, LEDs, GPIOs, etc. Refer to the RMI4 specification for
-   information on these RMI4 functions and what data they report.
-*/
-
-static struct rmi_functions_data
-	rmi4_supported_data_src_functions[rmi4_num_supported_data_src_fns] = {
-	/* Fn $11 */
-	{0x11, FN_11_report, FN_11_config, FN_11_init, FN_11_detect},
-	/* Fn $19 */
-	/* {0x19, FN_19_report, FN_19_config, FN_19_init, FN_19_detect), */
-};
-
-
-int rmi_read(struct rmi_application *app, unsigned short address, char *dest)
-{
-	struct rmi_phys_driver *rpd = app->rpd;
-	if (!app->rpd)
-		return -ENODEV;
-	return rpd->read(rpd, address, dest);
-}
-EXPORT_SYMBOL(rmi_read);
-
-int rmi_write(struct rmi_application *app, unsigned short address,
-		unsigned char data)
-{
-	struct rmi_phys_driver *rpd = app->rpd;
-	if (!app->rpd)
-		return -ENODEV;
-	return rpd->write(rpd, address, data);
-}
-EXPORT_SYMBOL(rmi_write);
-
-int rmi_read_multiple(struct rmi_application *app, unsigned short address,
-		char *dest, int length)
-{
-	struct rmi_phys_driver *rpd = app->rpd;
-	if (!app->rpd)
-		return -ENODEV;
-	return rpd->read_multiple(rpd, address, dest, length);
-}
-EXPORT_SYMBOL(rmi_read_multiple);
-
-int rmi_write_multiple(struct rmi_application *app, unsigned short address,
-		unsigned char *data, int length)
-{
-	struct rmi_phys_driver *rpd = app->rpd;
-	if (!app->rpd)
-		return -ENODEV;
-	return rpd->write_multiple(rpd, address, data, length);
-}
-EXPORT_SYMBOL(rmi_write_multiple);
-
-bool rmi_polling_required(struct rmi_application *app)
-{
-	return app->polling_required;
-}
-EXPORT_SYMBOL(rmi_polling_required);
-
-/* This function searches for a match between an app driver and physical
- * driver and binds them together.
- */
-static void match_and_bind(struct rmi_application *app,
-		struct rmi_phys_driver *rpd)
-{
-	app->polling_required = rpd->polling_required;
-
-	if (app->probe(app, &rpd->rmi)) {
-		/* Found a match, bind them together. */
-		/* The try_module_get() makes sure that the physical
-		* driver cannot be unloaded while a app driver is
-		* using it.
-		*/
-		if (try_module_get(rpd->module)) {
-			app->rpd = rpd;
-			rpd->app = app;
-			printk(KERN_INFO "%s: %s is %s bound to %s\n",
-				__func__, drvname, app->name, rpd->name);
-			rpd->attention = app->attention;
-			app->config(app);
-		}
-	} else {
-		app->polling_required = false;
-	}
-}
-
-/* This function is here to provide a way for external modules to access the
- * functions list.  It will try to find a matching function base on the passed
- * in RMI4 function number and return  the pointer to the struct rmi_functions
- * if a match is found or NULL if not found.
- */
-struct rmi_functions *rmi_find_function(int functionNum)
-{
-	struct rmi_functions *fn;
-	bool found = false;
-
-	list_for_each_entry(fn, &fns_list, link) {
-		if (functionNum == fn->functionNum) {
-			found = true;
-			break;
-		}
-	}
-
-	if (!found)
-		return NULL;
-	else
-		return fn;
-}
-EXPORT_SYMBOL(rmi_find_function);
-
-/* This function calls init for all of the functions on the functions list and
- * passes in the input_dev ptr so that each fn can store it for later use.
- */
-int rmi_functions_init(struct input_dev *inputdev)
-{
-	int retval = 0;
-	struct rmi_functions *fn;
-
-	/* Set input device specific params for each data source...*/
-	list_for_each_entry(fn, &fns_list, link) {
-		if (fn->init) {
-			/* store the input_dev ptr for use later */
-			fn->input = inputdev;
-			retval = fn->init(fn->input);
-		} else {
-			/* the developer did not add in the pointer to the init
-			function into rmi4_supported_data_src_functions */
-			printk(KERN_ERR
-				"%s: No init function for function 0x%x\n",
-				__func__, fn->functionNum);
-		}
-	}
-
-	return retval;
-}
-EXPORT_SYMBOL(rmi_functions_init);
-
-int rmi_register_phys_driver(struct rmi_phys_driver *rpd)
-{
-	struct rmi_application *app;
-	int i;
-	unsigned char std_queries[21];
-	unsigned char interruptCount;
-	struct rmi_function_info *rfi;
-	struct rmi_function_descriptor rmi_fd;
-	struct rmi_functions *fn;
-	bool found;
-	int retval;
-
-	if (!rpd->name) {
-		printk(KERN_ERR "%s: %s: Physical driver must specify a name\n",
-			__func__, drvname);
-		return -EINVAL;
-	}
-	if (!rpd->write) {
-		printk(KERN_ERR
-			"%s: %s: Physical driver %s must specify a writer.\n",
-			__func__, drvname, rpd->name);
-		return -EINVAL;
-	}
-	if (!rpd->read) {
-		printk(KERN_ERR
-			"%s: %s: Physical driver %s must specify a reader.\n",
-			__func__, drvname, rpd->name);
-		return -EINVAL;
-	}
-	if (!rpd->write_multiple) {
-		printk(KERN_ERR "%s: %s: Physical driver %s must specify a "
-			"multiple writer.\n",
-			__func__, drvname, rpd->name);
-		return -EINVAL;
-	}
-	if (!rpd->read_multiple) {
-		printk(KERN_ERR "%s: %s: Physical driver %s must specify a "
-			"multiple reader.\n",
-			__func__, drvname, rpd->name);
-		return -EINVAL;
-	}
-	if (!rpd->module) {
-		printk(KERN_ERR
-			"%s: %s: Physical driver %s must specify a module.\n",
-			__func__, drvname, rpd->name);
-		return -EINVAL;
-	}
-
-	pr_debug("%s: %s: Registering phys driver %s\n",
-			__func__, drvname, rpd->name);
-
-	rpd->attention = 0;
-
-	/* Get some information from the device */
-	{
-		pr_debug("%s: Functions:\n", __func__);
-
-		interruptCount = 0;
-
-		/* init the physical drivers RMI module
-		info list of functions */
-		INIT_LIST_HEAD(&rpd->rmi.functions);
-
-		/* Read the Page Descriptor Table to determine what functions
-		are present */
-		for (i = PDT_START_SCAN_LOCATION;
-				i > PDT_END_SCAN_LOCATION;
-				i -= PDT_ENTRY_SIZE) {
-			retval = rpd->read_multiple(rpd, i, (char *)&rmi_fd,
-					sizeof(rmi_fd));
-			if (!retval) {
-				rfi = NULL;
-
-				if (rmi_fd.functionNum != 0x00 && rmi_fd.functionNum != 0xff) {
-					switch (rmi_fd.functionNum & 0xff) {
-					case 0x01:
-						pr_debug("%s:   Fn $01 Found - RMI Device Control\n", __func__);
-						/* Save Fn $01 query and control base addresses since
-						we'll need them later to get/set properties and check
-						interrupts.  There is only one Fn $01 for the device
-						that is used to control and query device specific info
-						so we only need to save it globally here for later use.
-						*/
-						fn01QueryBaseAddr =
-							rmi_fd.queryBaseAddr;
-						fn01ControlBaseAddr =
-							rmi_fd.controlBaseAddr;
-					break;
-
-					default:
-						if (rmi_fd.interruptSrcCnt) {
-							rfi = kmalloc(sizeof(*rfi), GFP_KERNEL);
-
-							if (!rfi) {
-								printk(KERN_ERR "%s: %s: could not allocate memory for function 0x%x\n",
-									__func__, drvname, rmi_fd.functionNum);
-								retval = -ENOMEM;
-								goto exit_fail;
-							} else {
-								INC_ALLOC_STAT(rfi);
-
-								/* Get the ptr to the detect function based on
-								the function number */
-								found = false;
-								list_for_each_entry(fn, &fns_list, link) {
-									/* check if function number matches - if so
-									call that detect function */
-									if (fn->functionNum == rmi_fd.functionNum) {
-										found = true;
-										fn->detect(rpd->app, rfi, &rmi_fd,
-												interruptCount);
-									}
-								}
-
-								if (!found) {
-									printk(KERN_ERR "%s: %s: could not find support for function 0x%x\n",
-										__func__, drvname, rmi_fd.functionNum);
-								}
-							}
-						} else {
-							printk(KERN_INFO "%s: %s: Found Function %02x - Ignored.\n", __func__, drvname, rmi_fd.functionNum & 0xff);
-						}
-						break;
-					}
-
-					/* bump interrupt count for
-					next iteration */
-					interruptCount +=
-						(rmi_fd.interruptSrcCnt & 0x7);
-
-					/* We only want to add functions
-					to the list that have
-					data associated with them. */
-					if (rfi && rmi_fd.interruptSrcCnt) {
-						pr_debug("%s: Adding function "
-						"0x%x with %d sources.\n",
-						drvname, rfi->functionNum,
-						rfi->numSources);
-
-						/* link this function info to
-						the RMI module infos list
-						of functions */
-						mutex_lock(&rfi_mutex);
-						list_add_tail(&rfi->link,
-							&rpd->rmi.functions);
-						mutex_unlock(&rfi_mutex);
-					}
-				} else {
-					/* A zero in the function number
-					signals the end of the PDT */
-					pr_debug("%s:   Found End of PDT\n",
-						__func__);
-					break;
-				}
-			} else {
-				/* failed to read next PDT entry - end PDT
-				scan - this may result in an incomplete set
-				of recognized functions - should probably
-				return an error but the driver may still be
-				viable for diagnostics and debugging so let's
-				let it continue. */
-				printk(KERN_ERR "%s: %s: Read Error 0x%x when "
-					"reading next PDT entry - "
-					"ending PDT scan.\n",
-					__func__, drvname, retval);
-				break;
-			}
-		}
-
-		/* calculate the interrupt register count - used in the
-		ISR to read the correct number of interrupt registers */
-		interruptRegisterCount = (interruptCount + 7) / 8;
-
-		/* Function $01 will be used to query the product properties,
-		and product ID  so we had to read the PDT above first to get
-		the Fn $01 query address and prior to filling in the product
-		info. NOTE: Even an unflashed device will still have FN $01.
-		*/
-
-		/* Load up the standard queries and get the RMI4 module info */
-		retval = rpd->read_multiple(rpd, fn01QueryBaseAddr, std_queries,
-				sizeof(std_queries));
-		if (retval) {
-			printk(KERN_ERR "%s: %s: Failed reading queries\n",
-				__func__, drvname);
-			retval = -EIO;
-			goto exit_fail;
-		}
-
-		/* Currently supported RMI version is 4.0 */
-		rpd->rmi.rmi_maj_ver  = 4;
-		rpd->rmi.rmi_min_ver  = 0;
-
-		/* get manufacturer id, properties, product info,
-		date code, tester id, serial num and product id (name) */
-		rpd->rmi.mfgid        = std_queries[0];
-		rpd->rmi.properties   = std_queries[1];
-
-		rpd->rmi.prod_info[0] = std_queries[2];
-		rpd->rmi.prod_info[1] = std_queries[3];
-
-		/* year - 2001-2032 */
-		rpd->rmi.date_code[0] = std_queries[4] & 0x1f;
-		/* month - 1-12 */
-		rpd->rmi.date_code[1] = std_queries[5] & 0x0f;
-		/* day - 1-31 */
-		rpd->rmi.date_code[2] = std_queries[6] & 0x1f;
-
-		rpd->rmi.tester_id = ((std_queries[7] & 0x7f) << 8) |
-			(std_queries[8] & 0x7f);
-
-		rpd->rmi.serial_num = ((std_queries[9] & 0x7f) << 8) |
-		(std_queries[10] & 0x7f);
-
-		memcpy(rpd->rmi.prod_id, &std_queries[11], 10);
-		rpd->rmi.prod_id[10] = 0;
-
-		pr_debug("%s: RMI Protocol: %d.%d\n",
-			__func__, rpd->rmi.rmi_maj_ver, rpd->rmi.rmi_min_ver);
-		pr_debug("%s: Manufacturer: %d", __func__,
-			rpd->rmi.mfgid);
-
-		if (rpd->rmi.mfgid == 1)
-			pr_debug(" (Synaptics)");
-		pr_debug("\n");
-
-		pr_debug("%s: Properties: 0x%x\n",
-			__func__, rpd->rmi.properties);
-		pr_debug("%s: Product Info: 0x%x 0x%x\n",
-			__func__, rpd->rmi.prod_info[0], rpd->rmi.prod_info[1]);
-		pr_debug("%s: Date Code: Year : %d Month: %d Day: %d\n",
-			__func__, rpd->rmi.date_code[0], rpd->rmi.date_code[1],
-			rpd->rmi.date_code[2]);
-		pr_debug("%s: Tester ID: %d\n", __func__, rpd->rmi.tester_id);
-		pr_debug("%s: Serial Number: 0x%x\n",
-			__func__, rpd->rmi.serial_num);
-		pr_debug("%s: Product ID: %s\n", __func__, rpd->rmi.prod_id);
-	}
-
-	/* Add physical driver struct to list */
-	mutex_lock(&phys_drivers_mutex);
-	list_add_tail(&rpd->drivers, &phys_drivers);
-	mutex_unlock(&phys_drivers_mutex);
-
-	/* Do a probe for any applications that are registered and bind this
-	physical driver to them */
-	list_for_each_entry(app, &app_drivers, apps) {
-		/* Only check apps that are not already bound */
-		if (!app->rpd)
-			match_and_bind(app, rpd);
-	}
-
-	pr_debug("%s: Registered phys driver %s\n", __func__, rpd->name);
-
-	return 0;
-
-exit_fail:
-	return retval;
-}
-EXPORT_SYMBOL(rmi_register_phys_driver);
-
-int rmi_unregister_phys_driver(struct rmi_phys_driver *rpd)
-{
-	if (rpd->app) {
-		printk(KERN_WARNING "%s: %s: WARNING: unregister of %s while %s still attached\n",
-			__func__, drvname, rpd->name, rpd->app->name);
-	}
-
-	pr_debug("%s: Unregistering phys driver %s\n", __func__, rpd->name);
-	mutex_lock(&phys_drivers_mutex);
-	list_del(&rpd->drivers);
-	mutex_unlock(&phys_drivers_mutex);
-
-	return 0;
-}
-EXPORT_SYMBOL(rmi_unregister_phys_driver);
-
-struct rmi_application *rmi_register_application(const char *name,
-	void (*attention)(struct rmi_phys_driver *pd, int instance),
-	int (*probe)(struct rmi_application *app,
-	const struct rmi_module_info *rmi),
-	void (*config)(struct rmi_application *app))
-{
-	struct rmi_application *app;
-	struct rmi_phys_driver *rpd;
-
-	if (!name) {
-		printk(KERN_ERR "%s: %s: Application driver must specify a name\n",
-				__func__, drvname);
-		return 0;
-	}
-
-	if (!attention) {
-		printk(KERN_ERR "%s: %s: Application driver %s must specify attention notifier.\n",
-			__func__, drvname, name);
-		return 0;
-	}
-
-	if (!probe) {
-		printk(KERN_ERR "%s: %s: Application driver %s must specify a probe function.\n",
-			__func__, drvname, name);
-		return 0;
-	}
-
-	if (!config) {
-		printk(KERN_ERR "%s: %s: Application driver %s must specify a config function.\n",
-			__func__, drvname, name);
-		return 0;
-	}
-
-	pr_debug("%s: Registering app driver %s\n", __func__, name);
-
-	app = kmalloc(sizeof(*app), GFP_KERNEL);
-	if (!app) {
-		printk(KERN_ERR "%s: %s: Out of memory\n", __func__, drvname);
-		return 0;
-	}
-	INC_ALLOC_STAT(app);
-
-	app->name  = name;
-	app->attention = attention;
-	app->probe = probe;
-	app->config = config;
-	app->rpd = 0;
-
-	mutex_lock(&app_drivers_mutex);
-	list_add_tail(&app->apps, &app_drivers);
-	mutex_unlock(&app_drivers_mutex);
-
-	/* Probe for any matches with physical drivers and bind them. */
-	list_for_each_entry(rpd, &phys_drivers, drivers) {
-		if (!rpd->app)
-			match_and_bind(app, rpd);
-	}
-
-	pr_debug("%s: Registered app driver %s (%p)\n", __func__, name, app);
-
-	return app;
-}
-EXPORT_SYMBOL(rmi_register_application);
-
-void rmi_unregister_application(struct rmi_application *app)
-{
-	struct rmi_application *tmp;
-	int found = 0;
-
-	if (!app)
-		return;
-
-	pr_debug("%s: Unregistering app driver %s (%p)\n",
-			__func__, app->name, app);
-
-	list_for_each_entry(tmp, &app_drivers, apps) {
-		if (tmp == app) {
-			found = 1;
-			break;
-		}
-	}
-
-	if (!found) {
-		printk(KERN_ERR "%s: %s: Removing rmi application %s: not found\n",
-			__func__, drvname, app->name);
-		return;
-	}
-
-	if (app->rpd) {
-		/* Release the phys driver so it can be unloaded. */
-		module_put(app->rpd->module);
-		app->rpd->app = 0;
-	}
-
-	list_del(&app->apps);
-	kfree(app);
-	DEC_ALLOC_STAT(app);
-
-	pr_debug("%s: Unregistered app driver %p\n", __func__, app);
-}
-EXPORT_SYMBOL(rmi_unregister_application);
-
-static int __init rmi_core_init(void)
-{
-	int i;
-	struct rmi_functions_data *rmi4_fn;
-
-	pr_debug("%s: Register Mapped Interface Data Layer Driver\n", __func__);
-
-	/* Initialize global list of RMI4 Functions that have data sources.
-	We need to add all new functions to this list so that we will have
-	pointers to the associated functions for init, config, report and
-	detect. See rmi.h for more details. The developer will add a new
-	RMI4 function number in the array in rmi.h, then add a new file to
-	the build (called rmi_function_XX.c where XX is the hex number for
-	the added RMI4 function). The rest should be automatic.
-	*/
-
-	/* for each function number defined in rmi.h creat a new rmi_function
-	struct and initialize the pointers to the servicing functions and then
-	add it into the global list for function support.
-	*/
-	for (i = 0; i < rmi4_num_supported_data_src_fns; i++) {
-		/* Add new rmi4 function struct to list */
-		struct rmi_functions *fn = kmalloc(sizeof(*fn), GFP_KERNEL);
-		if (!fn) {
-			printk(KERN_ERR "%s: %s: could not allocate memory "
-				"for rmi_function struct for function 0x%x\n",
-				__func__, drvname,
-				rmi4_supported_data_src_functions[i].functionNumber);
-			return -ENOMEM;
-		} else {
-			INC_ALLOC_STAT(fn);
-
-			rmi4_fn = &rmi4_supported_data_src_functions[i];
-			fn->functionNum = rmi4_fn->functionNumber;
-			/* Fill in ptrs to functions. The functions are
-			linked in from a file called rmi_function_xx.c
-			where xx is the hex number of the RMI4 function
-			from the RMI4 spec. Also, the function prototypes
-			need to be added to rmi_function_xx.h - also where
-			xx is the hex number of the RMI4 function.  So
-			that you don't get compile errors and that new
-			header needs to be included in the rmi.h header file.
-			*/
-			fn->report = rmi4_fn->reportFn;
-			fn->config = rmi4_fn->configFn;
-			fn->init =   rmi4_fn->initFn;
-			fn->detect = rmi4_fn->detectFn;
-
-			/* Add the new fn to the global list */
-			mutex_lock(&fns_mutex);
-			list_add_tail(&fn->link, &fns_list);
-			mutex_unlock(&fns_mutex);
-		}
-	}
-
-	return 0;
-}
-
-static void __exit rmi_core_exit(void)
-{
-	struct rmi_application *app, *apptmp;
-
-	/* These lists should be empty, but just in case . . . */
-	mutex_lock(&app_drivers_mutex);
-	list_for_each_entry_safe(app, apptmp, &app_drivers, apps) {
-		list_del(&app->apps);
-		kfree(app);
-		DEC_ALLOC_STAT(app);
-	}
-	mutex_unlock(&app_drivers_mutex);
-
-	CHECK_ALLOC_STAT(app);
-}
-
-/* TODO: Investigate implimenting "rmi" bus and device and driver on that bus
-	as per Documentation/driver-model/bus.txt */
-
-module_init(rmi_core_init);
-module_exit(rmi_core_exit);
-
-MODULE_AUTHOR("Synaptics, Inc.");
-MODULE_DESCRIPTION("RMI4 Driver");
-MODULE_LICENSE("GPL");
diff --git a/drivers/input/touchscreen/rmi_core.h b/drivers/input/touchscreen/rmi_core.h
deleted file mode 100644
index fc93aed..0000000
--- a/drivers/input/touchscreen/rmi_core.h
+++ /dev/null
@@ -1,57 +0,0 @@
-/**
- *
- * Synaptics Register Mapped Interface (RMI4) Data Layer Core Header.
- * Copyright (c) 2007 - 2010, Synaptics Incorporated.
- *
- */
-/*
- *
- * This file is licensed under the GPL2 license.
- *
- *#############################################################################
- * GPL
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2 as published
- * by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
- * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
- * for more details.
- *
- *#############################################################################
- */
-
-#ifndef _RMI_CORE_H
-#define _RMI_CORE_H
-
-struct rmi_application {
-	const char *name;
-	void (*attention)(struct rmi_phys_driver *pd, int instance);
-	/* Probe Function
-	*  This function is called to give the application layer an
-	*  opportunity to claim an RMI device.  The application layer cannot
-	*  read RMI registers at this point.  Defer that to the config
-	*  function call which occurs immediately after a successful probe.
-	*/
-	int (*probe)(struct rmi_application *app,
-			const struct rmi_module_info *rmi);
-	/* Config Function
-	*  This function is called after a successful probe.  It gives the
-	*  application driver an opportunity to query and/or configure an RMI
-	*  device before data starts flowing.
-	*/
-	void (*config)(struct rmi_application *app);
-	/* Standard kernel linked list implementation.
-	*  Documentation on how to use it can be found at
-	*  http://isis.poly.edu/kulesh/stuff/src/klist/.
-	*/
-	struct list_head apps;
-	struct rmi_phys_driver *rpd;
-	bool polling_required;
-	struct hrtimer timer;
-	struct work_struct work;
-};
-
-#endif
diff --git a/drivers/input/touchscreen/rmi_drvr.h b/drivers/input/touchscreen/rmi_drvr.h
new file mode 100755
index 0000000..fb251c5
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_drvr.h
@@ -0,0 +1,93 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) RMI Driver Header File.
+ * Copyright (c) 2007 - 2011, Synaptics Incorporated
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
+#include "rmi.h"
+
+#ifndef _RMI_DRVR_H
+#define _RMI_DRVR_H
+
+/*  RMI4 Protocol Support
+ */
+
+struct rmi_phys_driver {
+	char *name;
+	int (*write)(struct rmi_phys_driver *physdrvr, unsigned short address,
+			char data);
+	int (*read)(struct rmi_phys_driver *physdrvr, unsigned short address,
+			char *buffer);
+	int (*write_multiple)(struct rmi_phys_driver *physdrvr,
+			unsigned short address, char *buffer, int length);
+	int (*read_multiple)(struct rmi_phys_driver *physdrvr, unsigned short address,
+			char *buffer, int length);
+	void (*attention)(struct rmi_phys_driver *physdrvr, int instance);
+	bool polling_required;
+	int irq;
+
+	/* Standard kernel linked list implementation.
+	*  Documentation on how to use it can be found at
+	*  http://isis.poly.edu/kulesh/stuff/src/klist/.
+	*/
+	struct list_head drivers;
+	struct rmi_sensor_driver *sensor;
+	struct module *module;
+};
+
+int rmi_read(struct rmi_sensor_driver *sensor, unsigned short address, char *dest);
+int rmi_write(struct rmi_sensor_driver *sensor, unsigned short address,
+		unsigned char data);
+int rmi_read_multiple(struct rmi_sensor_driver *sensor, unsigned short address,
+		char *dest, int length);
+int rmi_write_multiple(struct rmi_sensor_driver *sensor, unsigned short address,
+		unsigned char *data, int length);
+int rmi_register_sensors(struct rmi_phys_driver *physdrvr);
+int rmi_unregister_sensors(struct rmi_phys_driver *physdrvr);
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
diff --git a/drivers/input/touchscreen/rmi_f01.c b/drivers/input/touchscreen/rmi_f01.c
new file mode 100755
index 0000000..ddf6cd3
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_f01.c
@@ -0,0 +1,245 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) Function $01 support for sensor
+ * control and configuration.
+ *
+ * Copyright (c) 2007 - 2011, Synaptics Incorporated
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
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include <linux/input.h>
+#include <linux/slab.h>
+#include <linux/param.h>
+
+#include "rmi.h"
+#include "rmi_drvr.h"
+#include "rmi_bus.h"
+#include "rmi_sensor.h"
+#include "rmi_function.h"
+#include "rmi_f01.h"
+
+
+#define RMI_REPORT_RATE_80 0
+#define RMI_REPORT_RATE_40 (1 << 6)
+
+/** Context data for each F01 we find.
+ */
+struct f01_instance_data {
+	struct rmi_F01_control *controlRegisters;
+	struct rmi_F01_data *dataRegisters;
+	struct rmi_F01_query *queryRegisters;
+};
+
+/*.
+ * The interrupt handler for Fn $01 doesn't do anything (for now).
+ */
+void FN_01_inthandler(struct rmi_function_info *rmifninfo,
+	unsigned int assertedIRQs)
+{
+	struct f01_instance_data *instanceData = (struct f01_instance_data *) rmifninfo->fndata;
+
+	printk(KERN_DEBUG "%s: Read device status.", __func__);
+
+	if (rmi_read_multiple(rmifninfo->sensor, rmifninfo->funcDescriptor.dataBaseAddr,
+		&instanceData->dataRegisters->deviceStatus, 1)) {
+		printk(KERN_ERR "%s : Could not read F01 device status.\n",
+			__func__);
+	}
+
+	/* TODO: Check for reset and handle appropriately.
+	*/
+}
+EXPORT_SYMBOL(FN_01_inthandler);
+
+/*
+ * This reads in the function $01 source data.
+ *
+ */
+void FN_01_attention(struct rmi_function_info *rmifninfo)
+{
+	struct f01_instance_data *instanceData = (struct f01_instance_data *) rmifninfo->fndata;
+
+	/* TODO: Compute size to read and number of IRQ registers to processors
+	* dynamically.  See comments in rmi.h. */
+	if (rmi_read_multiple(rmifninfo->sensor, rmifninfo->funcDescriptor.dataBaseAddr+1,
+		instanceData->dataRegisters->irqs, 1)) {
+		printk(KERN_ERR "%s : Could not read interrupt status registers at 0x%02x\n",
+			__func__, rmifninfo->funcDescriptor.dataBaseAddr);
+	}
+
+	if (instanceData->dataRegisters->irqs[0] & instanceData->controlRegisters->interruptEnable[0]) {
+		/* call down to the sensors irq dispatcher to dispatch all enabled IRQs */
+		rmifninfo->sensor->dispatchIRQs(rmifninfo->sensor,
+			instanceData->dataRegisters->irqs[0]);
+	}
+
+}
+EXPORT_SYMBOL(FN_01_attention);
+
+int FN_01_config(struct rmi_function_info *rmifninfo)
+{
+	/* print info and do any source specific configuration. */
+	int retval = 0;
+
+	printk(KERN_DEBUG "%s: RMI4 function $01 config\n", __func__);
+
+	/* On slow processors, we need to throttle back the rate at which
+	* data updates become ready. */
+#if 0
+	/* TODO: This code gets invoked pointlessly on some systems, and causes
+	 * the Synaptics device to stop working in those cases.  We need to figure
+	 * out what's going on there.
+	 */
+	if (HZ < 500) {
+		/* The default packet rate of 80 packets per
+		* second is too fast (the Linux time slice for
+		* sub-GHz processors is only 100 times per second).
+		* So re-program it to 40 packets per second.
+		*/
+		/* TODO: We need to OR this in, rather than stomping on the other
+		 * contents of the register.  It's OK for now, because this is
+		 * early in the initializaton process and nobody else has had
+		 * a chance to change this register, which defaults to 0.
+		 */
+		rmi_write(rmifninfo->sensor, rmifninfo->funcDescriptor.controlBaseAddr, RMI_REPORT_RATE_40);
+		printk(KERN_INFO "%s: Throttled back reporting for slow CPU (%d HZ).", __func__, HZ);
+	}
+#endif
+
+	return retval;
+}
+EXPORT_SYMBOL(FN_01_config);
+
+/* Initialize any function $01 specific params and settings - input
+ * settings, device settings, etc.
+ */
+int FN_01_init(struct rmi_function_device *function_device)
+{
+	pr_debug("%s: RMI4 function $01 init\n", __func__);
+
+	return 0;
+}
+EXPORT_SYMBOL(FN_01_init);
+
+int FN_01_detect(struct rmi_function_info *rmifninfo,
+	struct rmi_function_descriptor *fndescr, unsigned int interruptCount)
+{
+	int i;
+	int InterruptOffset;
+	int retval = 0;
+	struct f01_instance_data *instanceData;
+	struct rmi_F01_control *controlRegisters;
+	struct rmi_F01_data *dataRegisters;
+	struct rmi_F01_query *queryRegisters;
+
+	pr_debug("%s: RMI4 function $01 detect\n", __func__);
+
+	/* Store addresses - used elsewhere to read data,
+	* control, query, etc. */
+	rmifninfo->funcDescriptor.queryBaseAddr = fndescr->queryBaseAddr;
+	rmifninfo->funcDescriptor.commandBaseAddr = fndescr->commandBaseAddr;
+	rmifninfo->funcDescriptor.controlBaseAddr = fndescr->controlBaseAddr;
+	rmifninfo->funcDescriptor.dataBaseAddr = fndescr->dataBaseAddr;
+	rmifninfo->funcDescriptor.interruptSrcCnt = fndescr->interruptSrcCnt;
+	rmifninfo->funcDescriptor.functionNum = fndescr->functionNum;
+
+	rmifninfo->numSources = fndescr->interruptSrcCnt;
+
+	/* Set up context data. */
+	instanceData = kzalloc(sizeof(*instanceData), GFP_KERNEL);
+	if (!instanceData) {
+		printk(KERN_ERR "%s: Error allocating memory for F01 context data.\n", __func__);
+		return -ENOMEM;
+	}
+	queryRegisters = kzalloc(sizeof(*queryRegisters), GFP_KERNEL);
+	if (!queryRegisters) {
+		printk(KERN_ERR "%s: Error allocating memory for F01 query registers.\n", __func__);
+		return -ENOMEM;
+	}
+	instanceData->queryRegisters = queryRegisters;
+	retval = rmi_read_multiple(rmifninfo->sensor, rmifninfo->funcDescriptor.queryBaseAddr,
+		(char *)instanceData->queryRegisters, sizeof(struct rmi_F01_query));
+	if (retval) {
+		printk(KERN_ERR "%s : Could not read F01 control registers at 0x%02x. Error %d.\n",
+			__func__, rmifninfo->funcDescriptor.dataBaseAddr, retval);
+	}
+	printk(KERN_DEBUG "%s: RMI Protocol: %d.%d",
+		__func__, queryRegisters->rmi_maj_ver, queryRegisters->rmi_min_ver);
+	printk(KERN_DEBUG "%s: Manufacturer: %d %s", __func__,
+		queryRegisters->mfgid, queryRegisters->mfgid == 1 ? "(Synaptics)" : "");
+	printk(KERN_DEBUG "%s: Properties: 0x%x",
+		__func__, queryRegisters->properties);
+	printk(KERN_DEBUG "%s: Product Info: 0x%x 0x%x",
+		__func__, queryRegisters->prod_info[0], queryRegisters->prod_info[1]);
+	printk(KERN_DEBUG "%s: Date Code: Year : %d Month: %d Day: %d",
+		__func__, queryRegisters->date_code[0], queryRegisters->date_code[1],
+		queryRegisters->date_code[2]);
+	printk(KERN_DEBUG "%s: Tester ID: %d", __func__, queryRegisters->tester_id);
+	printk(KERN_DEBUG "%s: Serial Number: 0x%x",
+		__func__, queryRegisters->serial_num);
+	printk(KERN_DEBUG "%s: Product ID: %s", __func__, queryRegisters->prod_id);
+
+	/* TODO: size of control registers needs to be computed dynamically.  See comment
+	* in rmi.h. */
+	controlRegisters = kzalloc(sizeof(*controlRegisters), GFP_KERNEL);
+	if (!controlRegisters) {
+		printk(KERN_ERR "%s: Error allocating memory for F01 control registers.\n", __func__);
+		return -ENOMEM;
+	}
+	instanceData->controlRegisters = controlRegisters;
+	retval = rmi_read_multiple(rmifninfo->sensor, rmifninfo->funcDescriptor.controlBaseAddr,
+		(char *)instanceData->controlRegisters, sizeof(struct rmi_F01_control));
+	if (retval) {
+		printk(KERN_ERR "%s : Could not read F01 control registers at 0x%02x. Error %d.\n",
+			__func__, rmifninfo->funcDescriptor.dataBaseAddr, retval);
+	}
+
+	/* TODO: size of data registers needs to be computed dynamically.  See comment
+	* in rmi.h. */
+	dataRegisters = kzalloc(sizeof(*dataRegisters), GFP_KERNEL);
+	if (!dataRegisters) {
+		printk(KERN_ERR "%s: Error allocating memory for F01 data registers.\n", __func__);
+		return -ENOMEM;
+	}
+	instanceData->dataRegisters = dataRegisters;
+	rmifninfo->fndata = instanceData;
+
+	/* Need to get interrupt info to be used later when handling
+	interrupts. */
+	rmifninfo->interruptRegister = interruptCount/8;
+
+	/* loop through interrupts for each source and or in a bit
+	to the interrupt mask for each. */
+	InterruptOffset = interruptCount % 8;
+
+	for (i = InterruptOffset;
+		i < ((fndescr->interruptSrcCnt & 0x7) + InterruptOffset);
+		i++) {
+			rmifninfo->interruptMask |= 1 << i;
+	}
+
+	return retval;
+}
+EXPORT_SYMBOL(FN_01_detect);
diff --git a/drivers/input/touchscreen/rmi_f01.h b/drivers/input/touchscreen/rmi_f01.h
new file mode 100755
index 0000000..976e062
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_f01.h
@@ -0,0 +1,40 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) Function $01 header.
+ * Copyright (c) 2007 - 2011, Synaptics Incorporated
+ *
+ * There is only one function $01 for each RMI4 sensor. This will be
+ * the function that is used to set sensor control and configurations
+ * and check the interrupts to find the source function that is interrupting.
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
+#ifndef _RMI_FUNCTION_01_H
+#define _RMI_FUNCTION_01_H
+
+void FN_01_inthandler(struct rmi_function_info *rmifninfo,
+	unsigned int assertedIRQs);
+int FN_01_config(struct rmi_function_info *rmifninfo);
+int FN_01_init(struct rmi_function_device *function_device);
+int FN_01_detect(struct rmi_function_info *rmifninfo,
+		struct rmi_function_descriptor *fndescr,
+		unsigned int interruptCount);
+void FN_01_attention(struct rmi_function_info *rmifninfo);
+#endif
diff --git a/drivers/input/touchscreen/rmi_f11.c b/drivers/input/touchscreen/rmi_f11.c
new file mode 100755
index 0000000..5e75427
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_f11.c
@@ -0,0 +1,712 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) Function $11 support for 2D.
+ * Copyright (c) 2007 - 2011, Synaptics Incorporated
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
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include <linux/input.h>
+#include <linux/slab.h>
+
+#include "rmi.h"
+#include "rmi_drvr.h"
+#include "rmi_bus.h"
+#include "rmi_sensor.h"
+#include "rmi_function.h"
+#include "rmi_f11.h"
+
+
+static int sensorMaxX;
+static int sensorMaxY;
+
+struct f11_instance_data {
+	struct rmi_F11_device_query *deviceInfo;
+	struct rmi_F11_sensor_query *sensorInfo;
+	struct rmi_F11_control *controlRegisters;
+	unsigned char fingerDataBufferSize;
+	unsigned char absDataOffset;
+	unsigned char absDataSize;
+	unsigned char relDataOffset;
+	unsigned char gestureDataOffset;
+	unsigned char *fingerDataBuffer;
+		/* Last X & Y seen, needed at finger lift.  Was down indicates at least one finger was here. */
+		/* TODO: Eventually we'll need to track this info on a per finger basis. */
+	bool wasdown;
+	unsigned int oldX;
+	unsigned int oldY;
+		/* Transformations to be applied to coordinates before reporting. */
+	bool flipX;
+	bool flipY;
+	int offsetX;
+	int offsetY;
+	int clipXLow;
+	int clipXHigh;
+	int clipYLow;
+	int clipYHigh;
+};
+
+enum f11_finger_state {
+	F11_NO_FINGER = 0,
+	F11_PRESENT = 1,
+	F11_INACCURATE = 2,
+	F11_RESERVED = 3
+};
+
+
+static ssize_t rmi_fn_11_flip_show(struct device *dev,
+				struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_fn_11_flip_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count);
+
+DEVICE_ATTR(flip, 0664, rmi_fn_11_flip_show, rmi_fn_11_flip_store);     /* RW attr */
+
+static ssize_t rmi_fn_11_clip_show(struct device *dev,
+				struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_fn_11_clip_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count);
+
+DEVICE_ATTR(clip, 0664, rmi_fn_11_clip_show, rmi_fn_11_clip_store);     /* RW attr */
+
+static ssize_t rmi_fn_11_offset_show(struct device *dev,
+				struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_fn_11_offset_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count);
+
+DEVICE_ATTR(offset, 0664, rmi_fn_11_offset_show, rmi_fn_11_offset_store);     /* RW attr */
+
+/*
+ * There is no attention function for Fn $11 - it is left NULL
+ * in the function table so it is not called.
+ *
+ */
+
+
+/*
+ * This reads in a sample and reports the function $11 source data to the
+ * input subsystem. It is used for both polling and interrupt driven
+ * operation. This is called a lot so don't put in any informational
+ * printks since they will slow things way down!
+ */
+void FN_11_inthandler(struct rmi_function_info *rmifninfo,
+	unsigned int assertedIRQs)
+{
+	/* number of touch points - fingers down in this case */
+	int fingerDownCount;
+	int finger;
+	struct rmi_function_device *function_device;
+	struct f11_instance_data *instanceData;
+
+	instanceData = (struct f11_instance_data *) rmifninfo->fndata;
+
+	fingerDownCount = 0;
+	function_device = rmifninfo->function_device;
+
+	/* get 2D sensor finger data */
+
+	if (rmi_read_multiple(rmifninfo->sensor, rmifninfo->funcDescriptor.dataBaseAddr,
+		instanceData->fingerDataBuffer, instanceData->fingerDataBufferSize)) {
+		printk(KERN_ERR "%s: Failed to read finger data registers.\n", __func__);
+		return;
+	}
+
+		/* First we need to count the fingers and generate some events related to that. */
+	for (finger = 0; finger < instanceData->sensorInfo->numberOfFingers; finger++) {
+		int reg;
+		int fingerShift;
+		int fingerStatus;
+
+		/* determine which data byte the finger status is in */
+		reg = finger/4;
+		/* bit shift to get finger's status */
+		fingerShift = (finger % 4) * 2;
+		fingerStatus = (instanceData->fingerDataBuffer[reg] >> fingerShift) & 3;
+
+		if (fingerStatus == F11_PRESENT || fingerStatus == F11_INACCURATE) {
+			fingerDownCount++;
+			instanceData->wasdown = true;
+		}
+	}
+	input_report_key(function_device->input,
+			BTN_TOUCH, fingerDownCount);
+	for (finger = 0; finger < (instanceData->sensorInfo->numberOfFingers - 1); finger++) {
+		input_report_key(function_device->input,
+			BTN_2 + finger, fingerDownCount >= (finger + 2));
+	}
+
+	for (finger = 0; finger < instanceData->sensorInfo->numberOfFingers; finger++) {
+		int reg;
+		int fingerShift;
+		int fingerStatus;
+		int X = 0, Y = 0, Z = 0, Wy = 0, Wx = 0;
+
+		/* determine which data byte the finger status is in */
+		reg = finger/4;
+		/* bit shift to get finger's status */
+		fingerShift = (finger % 4) * 2;
+		fingerStatus = (instanceData->fingerDataBuffer[reg] >> fingerShift) & 3;
+
+		/* if finger status indicates a finger is present then
+		read the finger data and report it */
+		if (fingerStatus == F11_PRESENT || fingerStatus == F11_INACCURATE) {
+
+			if (instanceData->sensorInfo->hasAbs) {
+				reg = instanceData->absDataOffset + (finger * instanceData->absDataSize);
+				X = (instanceData->fingerDataBuffer[reg] << 4) & 0x0ff0;
+				X |= (instanceData->fingerDataBuffer[reg+2] & 0x0f);
+				if (instanceData->flipX)
+					X = max(instanceData->controlRegisters->sensorMaxXPos-X, 0);
+				X = X - instanceData->offsetX;
+				X = min(max(X, instanceData->clipXLow), instanceData->clipXHigh);
+				Y = (instanceData->fingerDataBuffer[reg+1] << 4) & 0x0ff0;
+				Y |= ((instanceData->fingerDataBuffer[reg+2] & 0xf0) >> 4) & 0x0f;
+				if (instanceData->flipY)
+					Y = max(instanceData->controlRegisters->sensorMaxYPos-Y, 0);
+				Y = Y - instanceData->offsetY;
+				Y = min(max(Y, instanceData->clipYLow), instanceData->clipYHigh);
+
+				/* upper 4 bits of W are Wy,
+				lower 4 of W are Wx */
+				Wy =  (instanceData->fingerDataBuffer[reg+3] >> 4) & 0x0f;
+				Wx = instanceData->fingerDataBuffer[reg+3] & 0x0f;
+
+				Z = instanceData->fingerDataBuffer[reg+4];
+
+				printk(KERN_DEBUG "%s: Finger %d X %d Y %d Z %d Wx %d Wy %d", __func__, finger, X, Y, Z, Wx, Wy);
+
+				/* if this is the first finger report normal
+				ABS_X, ABS_Y, PRESSURE, TOOL_WIDTH events for
+				non-MT apps. Apps that support Multi-touch
+				will ignore these events and use the MT events.
+				Apps that don't support Multi-touch will still
+				function.
+				*/
+				if (fingerDownCount == 1) {
+					instanceData->oldX = X;
+					instanceData->oldY = Y;
+					input_report_abs(function_device->input, ABS_X, X);
+					input_report_abs(function_device->input, ABS_Y, Y);
+					input_report_abs(function_device->input, ABS_PRESSURE, Z);
+					input_report_abs(function_device->input, ABS_TOOL_WIDTH,
+							max(Wx, Wy));
+				} else {
+					/* TODO generate non MT events for multifinger situation. */
+				}
+#ifdef CONFIG_SYNA_MULTI_TOUCH
+				/* Report Multi-Touch events for each finger */
+				/* major axis of touch area ellipse */
+				input_report_abs(function_device->input, ABS_MT_TOUCH_MAJOR, Z);
+				/* minor axis of touch area ellipse */
+				input_report_abs(function_device->input, ABS_MT_WIDTH_MAJOR,
+						max(Wx, Wy));
+				/* Currently only 2 supported - 1 or 0 */
+				input_report_abs(function_device->input, ABS_MT_ORIENTATION,
+					(Wx > Wy ? 1 : 0));
+				input_report_abs(function_device->input, ABS_MT_POSITION_X, X);
+				input_report_abs(function_device->input, ABS_MT_POSITION_Y, Y);
+
+				/* TODO: Tracking ID needs to be reported but not used yet. */
+				/* Could be formed by keeping an id per position and assiging */
+				/* a new id when fingerStatus changes for that position.*/
+				input_report_abs(function_device->input, ABS_MT_TRACKING_ID,
+						finger+1);
+
+				/* MT sync between fingers */
+				input_mt_sync(function_device->input);
+#endif
+			}
+		}
+	}
+
+	/* if we had a finger down before and now we don't have any send a button up. */
+	if ((fingerDownCount == 0) && instanceData->wasdown) {
+		instanceData->wasdown = false;
+
+#ifdef CONFIG_SYNA_MULTI_TOUCH
+		input_report_abs(function_device->input, ABS_MT_TOUCH_MAJOR, 0);
+		input_report_abs(function_device->input, ABS_MT_WIDTH_MAJOR, 0);
+		input_report_abs(function_device->input, ABS_MT_POSITION_X, instanceData->oldX);
+		input_report_abs(function_device->input, ABS_MT_POSITION_Y, instanceData->oldY);
+		input_report_abs(function_device->input, ABS_MT_TRACKING_ID, 1);
+		input_mt_sync(function_device->input);
+#endif
+
+		input_report_abs(function_device->input, ABS_X, instanceData->oldX);
+		input_report_abs(function_device->input, ABS_Y, instanceData->oldY);
+		instanceData->oldX = instanceData->oldY = 0;
+		printk(KERN_DEBUG "%s: Finger up.", __func__);
+	}
+
+	input_sync(function_device->input); /* sync after groups of events */
+
+}
+EXPORT_SYMBOL(FN_11_inthandler);
+
+int FN_11_config(struct rmi_function_info *rmifninfo)
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
+	retval = rmi_read_multiple(rmifninfo->sensor, rmifninfo->funcDescriptor.queryBaseAddr,
+		data, 9);
+	if (retval) {
+		printk(KERN_ERR "%s: RMI4 function $11 config:"
+			"Could not read function query registers 0x%x\n",
+			__func__, rmifninfo->funcDescriptor.queryBaseAddr);
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
+		retval = rmi_read_multiple(rmifninfo->sensor,
+				rmifninfo->funcDescriptor.controlBaseAddr, data, 14);
+		if (retval) {
+			printk(KERN_ERR "%s: RMI4 function $11 config:"
+				"Could not read control registers 0x%x\n",
+				__func__, rmifninfo->funcDescriptor.controlBaseAddr);
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
+EXPORT_SYMBOL(FN_11_config);
+
+/* Initialize any function $11 specific params and settings - input
+ * settings, device settings, etc.
+ */
+int FN_11_init(struct rmi_function_device *function_device)
+{
+	int retval = 0;
+	struct f11_instance_data *instance_data = function_device->rfi->fndata;
+	printk(KERN_DEBUG "%s: RMI4 F11 init\n", __func__);
+
+	/* need to init the input abs params for the 2D */
+	set_bit(EV_ABS, function_device->input->evbit);
+	set_bit(EV_SYN, function_device->input->evbit);
+	set_bit(EV_KEY, function_device->input->evbit);
+
+	/* Use the max X and max Y read from the device, or the clip values,
+	 * whichever is stricter.
+	 */
+	input_set_abs_params(function_device->input, ABS_X, instance_data->clipXLow,
+		min((int) instance_data->controlRegisters->sensorMaxXPos, instance_data->clipXHigh),
+		0, 0);
+	input_set_abs_params(function_device->input, ABS_Y, instance_data->clipYLow,
+		min((int) instance_data->controlRegisters->sensorMaxYPos, instance_data->clipYHigh),
+		0, 0);
+	input_set_abs_params(function_device->input, ABS_PRESSURE, 0, 255, 0, 0);
+	input_set_abs_params(function_device->input, ABS_TOOL_WIDTH, 0, 15, 0, 0);
+
+#ifdef CONFIG_SYNA_MULTI_TOUCH
+	input_set_abs_params(function_device->input, ABS_MT_TOUCH_MAJOR, 0, 15, 0, 0);
+	input_set_abs_params(function_device->input, ABS_MT_TOUCH_MINOR, 0, 15, 0, 0);
+	input_set_abs_params(function_device->input, ABS_MT_ORIENTATION, 0, 1, 0, 0);
+	input_set_abs_params(function_device->input, ABS_MT_TRACKING_ID, 1, 10, 0, 0);
+	input_set_abs_params(function_device->input, ABS_MT_POSITION_X, instance_data->clipXLow,
+		min((int) instance_data->controlRegisters->sensorMaxXPos, instance_data->clipXHigh),
+		0, 0);
+	input_set_abs_params(function_device->input, ABS_MT_POSITION_Y, instance_data->clipYLow,
+		min((int) instance_data->controlRegisters->sensorMaxYPos, instance_data->clipYHigh),
+		0, 0);
+#endif
+
+	printk(KERN_DEBUG "%s: Creating sysfs files.", __func__);
+	retval = device_create_file(&function_device->dev, &dev_attr_flip);
+	if (retval) {
+		printk(KERN_ERR "%s: Failed to create flip.", __func__);
+		return retval;
+	}
+	retval = device_create_file(&function_device->dev, &dev_attr_clip);
+	if (retval) {
+		printk(KERN_ERR "%s: Failed to create clip.", __func__);
+		return retval;
+	}
+	retval = device_create_file(&function_device->dev, &dev_attr_offset);
+	if (retval) {
+		printk(KERN_ERR "%s: Failed to create offset.", __func__);
+		return retval;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(FN_11_init);
+
+int FN_11_detect(struct rmi_function_info *rmifninfo,
+	struct rmi_function_descriptor *fndescr, unsigned int interruptCount)
+{
+	unsigned char fn11Queries[12];   /* TODO: Compute size correctly. */
+	unsigned char fn11Control[12];   /* TODO: Compute size correctly. */
+	int i;
+	unsigned short fn11InterruptOffset;
+	unsigned char fn11AbsDataBlockSize;
+	int fn11HasPinch, fn11HasFlick, fn11HasTap;
+	int fn11HasTapAndHold, fn11HasDoubleTap;
+	int fn11HasEarlyTap, fn11HasPress;
+	int fn11HasPalmDetect, fn11HasRotate;
+	int fn11HasRel;
+	unsigned char f11_egr_0, f11_egr_1;
+	unsigned int fn11AllDataBlockSize;
+	int retval = 0;
+	struct f11_instance_data *instanceData;
+
+	printk(KERN_DEBUG "%s: RMI4 F11 detect\n", __func__);
+
+	instanceData = kzalloc(sizeof(struct f11_instance_data), GFP_KERNEL);
+	if (!instanceData) {
+		printk(KERN_ERR "%s: Error allocating F11 instance data.\n", __func__);
+		return -ENOMEM;
+	}
+	instanceData->deviceInfo = kzalloc(sizeof(struct rmi_F11_device_query), GFP_KERNEL);
+	if (!instanceData->deviceInfo) {
+		printk(KERN_ERR "%s: Error allocating F11 device query.\n", __func__);
+		return -ENOMEM;
+	}
+	instanceData->sensorInfo = kzalloc(sizeof(struct rmi_F11_sensor_query), GFP_KERNEL);
+	if (!instanceData->sensorInfo) {
+		printk(KERN_ERR "%s: Error allocating F11 sensor query.\n", __func__);
+		return -ENOMEM;
+	}
+	rmifninfo->fndata = instanceData;
+
+	/* TODO: Initialize these through some normal kernel mechanism.
+	 */
+	instanceData->flipX = true;
+	instanceData->flipY = false;
+	instanceData->offsetX = instanceData->offsetY = 0;
+	instanceData->clipXLow = instanceData->clipYLow = 0;
+	/* TODO: 65536 should actually be the largest valid RMI4 position coordinate */
+	instanceData->clipXHigh = instanceData->clipYHigh = 65536;
+
+	/* Store addresses - used elsewhere to read data,
+	* control, query, etc. */
+	rmifninfo->funcDescriptor.queryBaseAddr = fndescr->queryBaseAddr;
+	rmifninfo->funcDescriptor.commandBaseAddr = fndescr->commandBaseAddr;
+	rmifninfo->funcDescriptor.controlBaseAddr = fndescr->controlBaseAddr;
+	rmifninfo->funcDescriptor.dataBaseAddr = fndescr->dataBaseAddr;
+	rmifninfo->funcDescriptor.interruptSrcCnt = fndescr->interruptSrcCnt;
+	rmifninfo->funcDescriptor.functionNum = fndescr->functionNum;
+
+	rmifninfo->numSources = fndescr->interruptSrcCnt;
+
+	/* need to get number of fingers supported, data size, etc. -
+	to be used when getting data since the number of registers to
+	read depends on the number of fingers supported and data size. */
+	retval = rmi_read_multiple(rmifninfo->sensor, fndescr->queryBaseAddr, fn11Queries,
+			sizeof(fn11Queries));
+	if (retval) {
+		printk(KERN_ERR "%s: RMI4 function $11 detect: "
+			"Could not read function query registers 0x%x\n",
+			__func__,  rmifninfo->funcDescriptor.queryBaseAddr);
+		return retval;
+	}
+
+	/* Extract device data. */
+	instanceData->deviceInfo->hasQuery9 = (fn11Queries[0] & 0x04) != 0;
+	instanceData->deviceInfo->numberOfSensors = (fn11Queries[0] & 0x07) + 1;
+	printk(KERN_DEBUG "%s: F11 device - %d sensors.  Query 9? %d.", __func__, instanceData->deviceInfo->numberOfSensors, instanceData->deviceInfo->hasQuery9);
+
+	/* Extract sensor data. */
+	/* 2D data sources have only 3 bits for the number of fingers
+	supported - so the encoding is a bit wierd. */
+	instanceData->sensorInfo->numberOfFingers = 2; /* default number of fingers supported */
+	if ((fn11Queries[1] & 0x7) <= 4)
+		/* add 1 since zero based */
+		instanceData->sensorInfo->numberOfFingers = (fn11Queries[1] & 0x7) + 1;
+	else {
+		/* a value of 5 is up to 10 fingers - 6 and 7 are reserved
+		(shouldn't get these i int retval;n a normal 2D source). */
+		if ((fn11Queries[1] & 0x7) == 5)
+			instanceData->sensorInfo->numberOfFingers = 10;
+	}
+	instanceData->sensorInfo->configurable = (fn11Queries[1] & 0x80) != 0;
+	instanceData->sensorInfo->hasSensitivityAdjust = (fn11Queries[1] & 0x40) != 0;
+	instanceData->sensorInfo->hasGestures = (fn11Queries[1] & 0x20) != 0;
+	instanceData->sensorInfo->hasAbs = (fn11Queries[1] & 0x10) != 0;
+	instanceData->sensorInfo->hasRel = (fn11Queries[1] & 0x08) != 0;
+	instanceData->sensorInfo->absDataSize = fn11Queries[5] & 0x03;
+	printk(KERN_DEBUG "%s: Number of fingers: %d.", __func__, instanceData->sensorInfo->numberOfFingers);
+
+	/* Need to get interrupt info to be used later when handling
+	interrupts. */
+	rmifninfo->interruptRegister = interruptCount/8;
+
+	/* loop through interrupts for each source in fn $11 and or in a bit
+	to the interrupt mask for each. */
+	fn11InterruptOffset = interruptCount % 8;
+
+	for (i = fn11InterruptOffset;
+			i < ((fndescr->interruptSrcCnt & 0x7) + fn11InterruptOffset);
+			i++)
+		rmifninfo->interruptMask |= 1 << i;
+
+	/* Figure out just how much data we'll need to read. */
+	instanceData->fingerDataBufferSize = (instanceData->sensorInfo->numberOfFingers + 3) / 4;
+	/* One each for X and Y, one for LSB for X & Y, one for W, one for Z */
+	fn11AbsDataBlockSize = 5;
+	if (instanceData->sensorInfo->absDataSize != 0)
+		printk(KERN_WARNING "%s: Unrecognized abs data size %d ignored.", __func__, instanceData->sensorInfo->absDataSize);
+	if (instanceData->sensorInfo->hasAbs) {
+		instanceData->absDataSize = fn11AbsDataBlockSize;
+		instanceData->absDataOffset = instanceData->fingerDataBufferSize;
+		instanceData->fingerDataBufferSize += instanceData->sensorInfo->numberOfFingers * fn11AbsDataBlockSize;
+	}
+	if (instanceData->sensorInfo->hasRel) {
+		instanceData->relDataOffset = instanceData->fingerDataBufferSize;
+		instanceData->fingerDataBufferSize += instanceData->sensorInfo->numberOfFingers * 2;
+	}
+	if (instanceData->sensorInfo->hasGestures) {
+		instanceData->gestureDataOffset = instanceData->fingerDataBufferSize;
+		printk(KERN_WARNING "%s: WARNING Need to correctly compute gesture data location.", __func__);
+	}
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
+		((instanceData->sensorInfo->numberOfFingers + 3) / 4) +
+		/* absolute data, per finger times number of fingers */
+		(fn11AbsDataBlockSize * instanceData->sensorInfo->numberOfFingers) +
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
+	instanceData->fingerDataBuffer = kcalloc(instanceData->fingerDataBufferSize, sizeof(unsigned char), GFP_KERNEL);
+	if (!instanceData->fingerDataBuffer) {
+		printk(KERN_ERR "%s: Failed to allocate finger data buffer.", __func__);
+		return -ENOMEM;
+	}
+
+	/* Grab a copy of the control registers. */
+	instanceData->controlRegisters = kzalloc(sizeof(struct rmi_F11_control), GFP_KERNEL);
+	if (!instanceData->controlRegisters) {
+		printk(KERN_ERR "%s: Error allocating F11 control registers.\n", __func__);
+		return -ENOMEM;
+	}
+	retval = rmi_read_multiple(rmifninfo->sensor, fndescr->controlBaseAddr,
+		fn11Control, sizeof(fn11Control));
+	if (retval) {
+		printk(KERN_ERR "%s: Failed to read F11 control registers.", __func__);
+		return retval;
+	}
+	instanceData->controlRegisters->sensorMaxXPos = (((int) fn11Control[7] & 0x0F) << 8) + fn11Control[6];
+	instanceData->controlRegisters->sensorMaxYPos = (((int) fn11Control[9] & 0x0F) << 8) + fn11Control[8];
+	printk(KERN_DEBUG "%s: Max X %d Max Y %d", __func__, instanceData->controlRegisters->sensorMaxXPos, instanceData->controlRegisters->sensorMaxYPos);
+	return 0;
+}
+EXPORT_SYMBOL(FN_11_detect);
+
+static ssize_t rmi_fn_11_flip_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = (struct f11_instance_data *)fn->rfi->fndata;
+
+	return sprintf(buf, "%u %u\n", instance_data->flipX, instance_data->flipY);
+}
+
+static ssize_t rmi_fn_11_flip_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = (struct f11_instance_data *)fn->rfi->fndata;
+	unsigned int newX, newY;
+
+	printk(KERN_INFO "%s: Flip set to %s.", __func__, buf);
+
+	if (sscanf(buf, "%u %u", &newX, &newY) != 2)
+		return -EINVAL;
+	if (newX < 0 || newX > 1 || newY < 0 || newY > 1)
+		return -EINVAL;
+	instance_data->flipX = newX;
+	instance_data->flipY = newY;
+
+	return count;
+}
+
+static ssize_t rmi_fn_11_offset_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = (struct f11_instance_data *)fn->rfi->fndata;
+
+	return sprintf(buf, "%d %d\n", instance_data->offsetX, instance_data->offsetY);
+}
+
+static ssize_t rmi_fn_11_offset_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = (struct f11_instance_data *)fn->rfi->fndata;
+	int newX, newY;
+
+	printk(KERN_INFO "%s: Offset set to %s.", __func__, buf);
+
+	if (sscanf(buf, "%d %d", &newX, &newY) != 2)
+		return -EINVAL;
+	instance_data->offsetX = newX;
+	instance_data->offsetY = newY;
+
+	return count;
+}
+
+static ssize_t rmi_fn_11_clip_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = (struct f11_instance_data *)fn->rfi->fndata;
+
+	return sprintf(buf, "%u %u %u %u\n",
+				   instance_data->clipXLow, instance_data->clipXHigh,
+				   instance_data->clipYLow, instance_data->clipYHigh);
+}
+
+static ssize_t rmi_fn_11_clip_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct f11_instance_data *instance_data = (struct f11_instance_data *)fn->rfi->fndata;
+	unsigned int newXLow, newXHigh, newYLow, newYHigh;
+
+	printk(KERN_INFO "%s: Clip set to %s.", __func__, buf);
+
+	if (sscanf(buf, "%u %u %u %u", &newXLow, &newXHigh, &newYLow, &newYHigh) != 4)
+		return -EINVAL;
+	if (newXLow < 0 || newXLow >= newXHigh || newYLow < 0 || newYLow >= newYHigh)
+		return -EINVAL;
+	instance_data->clipXLow = newXLow;
+	instance_data->clipXHigh = newXHigh;
+	instance_data->clipYLow = newYLow;
+	instance_data->clipYHigh = newYHigh;
+
+	input_set_abs_params(fn->input, ABS_X, instance_data->clipXLow,
+		min((int) instance_data->controlRegisters->sensorMaxXPos, instance_data->clipXHigh),
+		0, 0);
+	input_set_abs_params(fn->input, ABS_Y, instance_data->clipYLow,
+		min((int) instance_data->controlRegisters->sensorMaxYPos, instance_data->clipYHigh),
+		0, 0);
+
+#ifdef CONFIG_SYNA_MULTI_TOUCH
+	input_set_abs_params(fn->input, ABS_MT_POSITION_X, instance_data->clipXLow,
+		min((int) instance_data->controlRegisters->sensorMaxXPos, instance_data->clipXHigh),
+		0, 0);
+	input_set_abs_params(fn->input, ABS_MT_POSITION_Y, instance_data->clipYLow,
+		min((int) instance_data->controlRegisters->sensorMaxYPos, instance_data->clipYHigh),
+		0, 0);
+#endif
+
+	return count;
+}
diff --git a/drivers/input/touchscreen/rmi_f11.h b/drivers/input/touchscreen/rmi_f11.h
new file mode 100755
index 0000000..0bf386a
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_f11.h
@@ -0,0 +1,43 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) Function $11 header.
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
+void FN_11_inthandler(struct rmi_function_info *rmifninfo,
+	unsigned int assertedIRQs);
+int FN_11_config(struct rmi_function_info *rmifninfo);
+int FN_11_init(struct rmi_function_device *function_device);
+int FN_11_detect(struct rmi_function_info *rmifninfo,
+		struct rmi_function_descriptor *fndescr,
+		unsigned int interruptCount);
+/* No attention function for Fn $11 */
+#endif
diff --git a/drivers/input/touchscreen/rmi_f34.c b/drivers/input/touchscreen/rmi_f34.c
new file mode 100755
index 0000000..583e0f8
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_f34.c
@@ -0,0 +1,556 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) Function $34 support for sensor
+ * firmware reflashing.
+ *
+ * Copyright (c) 2007 - 2011, Synaptics Incorporated
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
+#include <linux/slab.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include <linux/input.h>
+#include <linux/sysfs.h>
+#include <linux/math64.h>
+#include "rmi_drvr.h"
+#include "rmi_bus.h"
+#include "rmi_sensor.h"
+#include "rmi_function.h"
+#include "rmi_f34.h"
+
+/* data specific to fn $34 that needs to be kept around */
+struct rmi_fn_34_data {
+	unsigned char   status;
+	unsigned char   cmd;
+	unsigned short  bootloaderid;
+	unsigned short  blocksize;
+};
+
+
+static ssize_t rmi_fn_34_status_show(struct device *dev,
+				struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_fn_34_status_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count);
+
+
+static ssize_t rmi_fn_34_cmd_show(struct device *dev,
+				struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_fn_34_cmd_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count);
+
+static ssize_t rmi_fn_34_data_read(struct kobject *kobj,
+				char *buf, loff_t pos, size_t count);
+
+static ssize_t rmi_fn_34_data_write(struct kobject *kobj,
+				const char *buf, loff_t pos, size_t count);
+
+static ssize_t rmi_fn_34_bootloaderid_show(struct device *dev,
+				struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_fn_34_bootloaderid_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count);
+
+static ssize_t rmi_fn_34_blocksize_show(struct device *dev,
+				struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_fn_34_blocksize_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count);
+
+/* define the device attributes using DEVICE_ATTR macros */
+DEVICE_ATTR(status, 0444, rmi_fn_34_status_show, rmi_fn_34_status_store);  /* RO attr */
+DEVICE_ATTR(cmd, 0664, rmi_fn_34_cmd_show, rmi_fn_34_cmd_store);     /* RW attr */
+DEVICE_ATTR(bootloaderid, 0644, rmi_fn_34_bootloaderid_show, rmi_fn_34_bootloaderid_store); /* RW attr */
+DEVICE_ATTR(blocksize, 0444, rmi_fn_34_blocksize_show, rmi_fn_34_blocksize_store);    /* RO attr */
+
+
+struct bin_attribute dev_attr_data = {
+	.attr = {
+			.name = "data",
+			.mode = 0644
+	},
+	.size = 0,
+	.read = rmi_fn_34_data_read,
+	.write = rmi_fn_34_data_write,
+};
+
+/* Helper fn to convert from processor specific data to our firmware specific endianness.
+ * TODO: Should we use ntohs or something like that?
+ */
+void copyEndianAgnostic(unsigned char *dest, unsigned short src)
+{
+	dest[0] = src%0x100;
+	dest[1] = src/0x100;
+}
+
+/*.
+ * The interrupt handler for Fn $34.
+ */
+void FN_34_inthandler(struct rmi_function_info *rmifninfo,
+	unsigned int assertedIRQs)
+{
+	unsigned int status;
+	struct rmi_function_device *function_device = rmifninfo->function_device;
+	struct rmi_fn_34_data *fn34data = (struct rmi_fn_34_data *)rmifninfo->fndata;
+
+	return; /* TODO: Remove this. */
+
+	/* Read the Fn $34 status register to see whether the previous command executed OK */
+	/* inform user space - through a sysfs param. */
+	if (rmi_read_multiple(function_device->sensor, function_device->function->functionDataBaseAddr+3,
+		(unsigned char *)&status, 1)) {
+		printk(KERN_ERR "%s : Could not read status from 0x%x\n",
+			__func__, function_device->function->functionDataBaseAddr+3);
+		status = 0xff; /* failure */
+	}
+
+	/* set a sysfs value that the user mode can read - only upper 4 bits are the status */
+	fn34data->status = status & 0xf0; /* successful is $80, anything else is failure */
+
+}
+EXPORT_SYMBOL(FN_34_inthandler);
+
+void FN_34_attention(struct rmi_function_info *rmifninfo)
+{
+
+}
+EXPORT_SYMBOL(FN_34_attention);
+
+int FN_34_config(struct rmi_function_info *rmifninfo)
+{
+	/* TODO: FIX THIS!  We were panicking in this routine, but need to get
+	 * other things working before returning to this.
+	 */
+	int retval = 0;
+#if 0
+	unsigned char uData[2];
+	struct rmi_function_device *function_device = rmifninfo->function_device;
+	struct rmi_fn_34_data *fn34data;
+
+	pr_debug("%s: RMI4 function $34 config\n", __func__);
+
+	/* Here we will need to set up sysfs files for Bootloader ID and Block size */
+	fn34data = (struct rmi_fn_34_data *)kzalloc(sizeof(struct rmi_fn_34_data), GFP_KERNEL);
+	if (!rmifninfo->fndata) {
+		printk(KERN_ERR "%s: Error allocating memeory for rmi_fn_34_data.\n", __func__);
+		return -ENOMEM;
+	}
+	rmifninfo->fndata = (void *)fn34data;
+
+	/* set up sysfs file for Bootloader ID. */
+	if (sysfs_create_file(&function_device->dev.kobj, &dev_attr_bootloaderid.attr) < 0) {
+		printk(KERN_ERR "Failed to create sysfs file for fn 34 bootloaderid.\n");
+		return -ENODEV;
+	}
+
+	/* set up sysfs file for Block Size. */
+	if (sysfs_create_file(&function_device->dev.kobj, &dev_attr_blocksize.attr) < 0) {
+		printk(KERN_ERR "Failed to create sysfs file for fn 34 blocksize.\n");
+		return -ENODEV;
+	}
+
+	/* get the Bootloader ID and Block Size and store in the sysfs attributes. */
+	retval = rmi_read_multiple(rmifninfo->sensor, function_device->function->functionQueryBaseAddr,
+		uData, 2);
+	if (retval) {
+		printk(KERN_ERR "%s : Could not read bootloaderid from 0x%x\n",
+			__func__, function_device->function->functionQueryBaseAddr);
+		return retval;
+	}
+	/* need to convert from our firmware storage to processore specific data */
+	fn34data->bootloaderid = (unsigned int)uData[0] + (unsigned int)uData[1]*0x100;
+
+	retval = rmi_read_multiple(rmifninfo->sensor, function_device->function->functionQueryBaseAddr+3,
+		uData, 2);
+	if (retval) {
+		printk(KERN_ERR "%s : Could not read block size from 0x%x\n",
+			__func__, function_device->function->functionQueryBaseAddr+3);
+		return retval;
+	}
+	/* need to convert from our firmware storage to processor specific data */
+	fn34data->blocksize = (unsigned int)uData[0] + (unsigned int)uData[1]*0x100;
+
+	/* set up sysfs file for status. */
+	if (sysfs_create_file(&function_device->dev.kobj, &dev_attr_status.attr) < 0) {
+		printk(KERN_ERR "Failed to create sysfs file for fn 34 status.\n");
+		return -ENODEV;
+	}
+
+	/* Also, sysfs will need to have a file set up to distinguish between commands - like
+	Config write/read, Image write/verify.*/
+	/* set up sysfs file for command code. */
+	if (sysfs_create_file(&function_device->dev.kobj, &dev_attr_cmd.attr) < 0) {
+		printk(KERN_ERR "Failed to create sysfs file for fn 34 cmd.\n");
+		return -ENODEV;
+	}
+
+	/* We will also need a sysfs file for the image/config block to write or read.*/
+	/* set up sysfs bin file for binary data block. Since the image is already in our format
+	there is no need to convert the data for endianess. */
+	if (sysfs_create_bin_file(&function_device->dev.kobj, &dev_attr_data) < 0) {
+		printk(KERN_ERR "Failed to create sysfs file for fn 34 data.\n");
+		return -ENODEV;
+	}
+#endif
+	return retval;
+}
+EXPORT_SYMBOL(FN_34_config);
+
+
+int FN_34_init(struct rmi_function_device *function_device)
+{
+	pr_debug("%s: RMI4 function $34 init\n", __func__);
+	return 0;
+}
+EXPORT_SYMBOL(FN_34_init);
+
+int FN_34_detect(struct rmi_function_info *rmifninfo,
+	struct rmi_function_descriptor *fndescr, unsigned int interruptCount)
+{
+	int i;
+	int InterruptOffset;
+	int retval = 0;
+
+	pr_debug("%s: RMI4 function $34 detect\n", __func__);
+	if (rmifninfo->sensor == NULL) {
+		printk(KERN_ERR "%s: NULL sensor passed in!", __func__);
+		return -EINVAL;
+	}
+
+	/* Store addresses - used elsewhere to read data,
+	* control, query, etc. */
+	rmifninfo->funcDescriptor.queryBaseAddr = fndescr->queryBaseAddr;
+	rmifninfo->funcDescriptor.commandBaseAddr = fndescr->commandBaseAddr;
+	rmifninfo->funcDescriptor.controlBaseAddr = fndescr->controlBaseAddr;
+	rmifninfo->funcDescriptor.dataBaseAddr = fndescr->dataBaseAddr;
+	rmifninfo->funcDescriptor.interruptSrcCnt = fndescr->interruptSrcCnt;
+	rmifninfo->funcDescriptor.functionNum = fndescr->functionNum;
+
+	rmifninfo->numSources = fndescr->interruptSrcCnt;
+
+	/* Need to get interrupt info to be used later when handling
+	interrupts. */
+	rmifninfo->interruptRegister = interruptCount/8;
+
+	/* loop through interrupts for each source and or in a bit
+	to the interrupt mask for each. */
+	InterruptOffset = interruptCount % 8;
+
+	for (i = InterruptOffset;
+		i < ((fndescr->interruptSrcCnt & 0x7) + InterruptOffset);
+		i++) {
+			rmifninfo->interruptMask |= 1 << i;
+	}
+
+	return retval;
+}
+EXPORT_SYMBOL(FN_34_detect);
+
+static ssize_t rmi_fn_34_bootloaderid_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct rmi_fn_34_data *fn34data = (struct rmi_fn_34_data *)fn->rfi->fndata;
+
+	return sprintf(buf, "%u\n", fn34data->bootloaderid);
+}
+
+static ssize_t rmi_fn_34_bootloaderid_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	int error;
+	unsigned long val;
+	unsigned char uData[2];
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct rmi_fn_34_data *fn34data = (struct rmi_fn_34_data *)fn->rfi->fndata;
+
+	/* need to convert the string data to an actual value */
+	error = strict_strtoul(buf, 10, &val);
+
+	if (error)
+		return error;
+
+	fn34data->bootloaderid = val;
+
+	/* Write the Bootloader ID key data back to the first two Block Data registers
+	(F34_Flash_Data2.0 and F34_Flash_Data2.1).*/
+	copyEndianAgnostic(uData, (unsigned short)val);
+	error = rmi_write_multiple(fn->sensor, fn->function->functionDataBaseAddr,
+		uData, 2);
+	if (error) {
+		printk(KERN_ERR "%s : Could not write bootloader id to 0x%x\n",
+			__func__, fn->function->functionDataBaseAddr);
+		return error;
+	}
+
+	return count;
+}
+
+static ssize_t rmi_fn_34_blocksize_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct rmi_fn_34_data *fn34data = (struct rmi_fn_34_data *)fn->rfi->fndata;
+
+	return sprintf(buf, "%u\n", fn34data->blocksize);
+}
+
+static ssize_t rmi_fn_34_blocksize_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	/* Block Size is RO so we shouldn't do anything if the
+	user space writes to the sysfs file. */
+
+	return -EPERM;
+}
+
+static ssize_t rmi_fn_34_status_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct rmi_fn_34_data *fn34data = (struct rmi_fn_34_data *)fn->rfi->fndata;
+
+	return sprintf(buf, "%u\n", fn34data->status);
+}
+
+static ssize_t rmi_fn_34_status_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	/* Status is RO so we shouldn't do anything if the user
+	app writes to the sysfs file. */
+	return -EPERM;
+}
+
+static ssize_t rmi_fn_34_cmd_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct rmi_fn_34_data *fn34data = (struct rmi_fn_34_data *)fn->rfi->fndata;
+
+	return sprintf(buf, "%u\n", fn34data->cmd);
+}
+
+static ssize_t rmi_fn_34_cmd_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct rmi_fn_34_data *fn34data = (struct rmi_fn_34_data *)fn->rfi->fndata;
+	unsigned long val;
+	unsigned char cmd;
+	int error;
+
+	/* need to convert the string data to an actual value */
+	error = strict_strtoul(buf, 10, &val);
+
+	if (error)
+		return error;
+
+	fn34data->cmd = val;
+
+	/* determine the proper command to issue.
+	*/
+	switch (val) {
+	case ENABLE_FLASH_PROG:
+		/* Issue a Flash Program Enable ($0F) command to the Flash Command
+		(F34_Flash_Data3, bits 3:0) field.*/
+		cmd = 0x0F;
+		error = rmi_write_multiple(fn->sensor, fn->function->functionDataBaseAddr+3,
+			(unsigned char *)&cmd, 1);
+		if (error) {
+			printk(KERN_ERR "%s : Could not write Flash Program Enable cmd to 0x%x\n",
+				__func__, fn->function->functionDataBaseAddr+3);
+			return error;
+		}
+		break;
+
+	case ERASE_ALL:
+		/* Issue a Erase All ($03) command to the Flash Command
+		(F34_Flash_Data3, bits 3:0) field.*/
+		cmd = 0x03;
+		error = rmi_write_multiple(fn->sensor, fn->function->functionDataBaseAddr+3,
+			(unsigned char *)&cmd, 1);
+		if (error) {
+			printk(KERN_ERR "%s : Could not write Erase All cmd to 0x%x\n",
+				__func__, fn->function->functionDataBaseAddr+3);
+			return error;
+		}
+		break;
+
+	case ERASE_CONFIG:
+		/* Issue a Erase Configuration ($07) command to the Flash Command
+		(F34_Flash_Data3, bits 3:0) field.*/
+		cmd = 0x07;
+		error = rmi_write_multiple(fn->sensor, fn->function->functionDataBaseAddr+3,
+			(unsigned char *)&cmd, 1);
+		if (error) {
+			printk(KERN_ERR "%s : Could not write Erase Configuration cmd to 0x%x\n",
+				__func__, fn->function->functionDataBaseAddr+3);
+			return error;
+		}
+		break;
+
+	case WRITE_FW_BLOCK:
+		/* Issue a Write Firmware Block ($02) command to the Flash Command
+		(F34_Flash_Data3, bits 3:0) field.*/
+		cmd = 0x02;
+		error = rmi_write_multiple(fn->sensor, fn->function->functionDataBaseAddr+3,
+			(unsigned char *)&cmd, 1);
+		if (error) {
+			printk(KERN_ERR "%s : Could not write Write Firmware Block cmd to 0x%x\n",
+				__func__, fn->function->functionDataBaseAddr+3);
+		return error;
+		}
+		break;
+
+	case WRITE_CONFIG_BLOCK:
+		/* Issue a Write Config Block ($06) command to the Flash Command
+		(F34_Flash_Data3, bits 3:0) field.*/
+		cmd = 0x06;
+		error = rmi_write_multiple(fn->sensor, fn->function->functionDataBaseAddr+3,
+			(unsigned char *)&cmd, 1);
+		if (error) {
+			printk(KERN_ERR "%s : Could not write Write Config Block cmd to 0x%x\n",
+				__func__, fn->function->functionDataBaseAddr+3);
+			return error;
+		}
+		break;
+
+	case READ_CONFIG_BLOCK:
+		/* Issue a Read Config Block ($05) command to the Flash Command
+		(F34_Flash_Data3, bits 3:0) field.*/
+		cmd = 0x05;
+		error = rmi_write_multiple(fn->sensor, fn->function->functionDataBaseAddr+3,
+			(unsigned char *)&cmd, 1);
+		if (error) {
+			printk(KERN_ERR "%s : Could not write Read Config Block cmd to 0x%x\n",
+				__func__, fn->function->functionDataBaseAddr+3);
+			return error;
+		}
+		break;
+
+	case DISABLE_FLASH_PROG:
+		/* Issue a reset command ($01) - this will reboot the sensor and ATTN will now go to
+		the Fn $01 instead of the Fn $34 since the sensor will no longer be in Flash mode. */
+		cmd = 0x01;
+		/*if ((error = rmi_write_multiple(fn->sensor, fn->sensor->sensorCommandBaseAddr,
+			(unsigned char *)&cmd, 1))) {
+			printk(KERN_ERR "%s : Could not write Reset cmd to 0x%x\n",
+				__func__, fn->sensor->sensorCommandBaseAddr);
+		return error;
+		}*/
+		break;
+
+	default:
+		pr_debug("%s: RMI4 function $34 - unknown command.\n", __func__);
+		break;
+	}
+
+	return count;
+}
+
+static ssize_t rmi_fn_34_data_read(struct kobject *kobj,
+				char *buf, loff_t pos, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	int error;
+
+	/* TODO: add check for count to verify it's the correct blocksize */
+
+	/* read the data from flash into buf. */
+	/* the app layer will be blocked at reading from the sysfs file. */
+	/* when we return the count (or error if we fail) the app will resume. */
+	error = rmi_read_multiple(fn->sensor, fn->function->functionDataBaseAddr+pos,
+		(unsigned char *)buf, count);
+	if (error) {
+		printk(KERN_ERR "%s : Could not read data from 0x%llx\n",
+			__func__, fn->function->functionDataBaseAddr+pos);
+		return error;
+	}
+
+	return count;
+}
+
+static ssize_t rmi_fn_34_data_write(struct kobject *kobj,
+				const char *buf, loff_t pos, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct rmi_function_device *fn = dev_get_drvdata(dev);
+	struct rmi_fn_34_data *fn34data = (struct rmi_fn_34_data *)fn->rfi->fndata;
+	unsigned int blocknum;
+	int error;
+
+	/* write the data from buf to flash. */
+	/* the app layer will be blocked at writing to the sysfs file. */
+	/* when we return the count (or error if we fail) the app will resume. */
+
+	/* TODO: Add check on count - if non-zero veriy it's the correct blocksize */
+
+	/* Verify that the byte offset is always aligned on a block boundary and if not
+	return an error.  We can't just use the mod operator % and do a (pos % fn34data->blocksize) because of a gcc
+	bug that results in undefined symbols.  So we have to compute it the hard
+	way.  Grumble. */
+	unsigned int remainder;
+	div_u64_rem(pos, fn34data->blocksize, &remainder);
+	if (remainder) {
+		printk(KERN_ERR "%s : Invalid byte offset of %llx leads to invalid block number.\n",
+			__func__, pos);
+		return -EINVAL;
+	}
+
+	/* Compute the block number using the byte offset (pos) and the block size.
+	once again, we can't just do a divide due to a gcc bug. */
+	blocknum = div_u64(pos, fn34data->blocksize);
+
+	/* Write the block number first */
+	error = rmi_write_multiple(fn->sensor, fn->function->functionDataBaseAddr,
+		(unsigned char *)&blocknum, 2);
+	if (error) {
+		printk(KERN_ERR "%s : Could not write block number to 0x%x\n",
+			__func__, fn->function->functionDataBaseAddr);
+		return error;
+	}
+
+	/* Write the data block - only if the count is non-zero  */
+	if (count) {
+		error = rmi_write_multiple(fn->sensor, fn->function->functionDataBaseAddr+2,
+			(unsigned char *)buf, count);
+		if (error) {
+			printk(KERN_ERR "%s : Could not write block data to 0x%x\n",
+				__func__, fn->function->functionDataBaseAddr+2);
+			return error;
+		}
+	}
+
+	return count;
+}
diff --git a/drivers/input/touchscreen/rmi_f34.h b/drivers/input/touchscreen/rmi_f34.h
new file mode 100755
index 0000000..48293e3
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_f34.h
@@ -0,0 +1,50 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) Function $34 header.
+ * Copyright (c) 2007 - 2011, Synaptics Incorporated
+ *
+ * There is only one function $34 for each RMI4 sensor. This will be
+ * the function that is used to reflash the firmware and get the
+ * boot loader address and the boot image block size.
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
+#ifndef _RMI_FUNCTION_34_H
+#define _RMI_FUNCTION_34_H
+
+/* define fn $34 commands */
+#define WRITE_FW_BLOCK            2
+#define ERASE_ALL                 3
+#define READ_CONFIG_BLOCK         5
+#define WRITE_CONFIG_BLOCK        6
+#define ERASE_CONFIG              7
+#define ENABLE_FLASH_PROG         15
+#define DISABLE_FLASH_PROG        16
+
+void FN_34_inthandler(struct rmi_function_info *rmifninfo,
+	unsigned int assertedIRQs);
+int FN_34_config(struct rmi_function_info *rmifninfo);
+int FN_34_init(struct rmi_function_device *function_device);
+int FN_34_detect(struct rmi_function_info *rmifninfo,
+		struct rmi_function_descriptor *fndescr,
+		unsigned int interruptCount);
+void FN_34_attention(struct rmi_function_info *rmifninfo);
+
+#endif
diff --git a/drivers/input/touchscreen/rmi_function.c b/drivers/input/touchscreen/rmi_function.c
new file mode 100755
index 0000000..45938bc
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_function.c
@@ -0,0 +1,304 @@
+/**
+ * Synaptics Register Mapped Interface (RMI4) - RMI Function Module.
+ * Copyright (C) 2007 - 2011, Synaptics Incorporated
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
+static const char functionname[10] = "fn";
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/hrtimer.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include <linux/delay.h>
+#include <linux/uaccess.h>
+#include <linux/slab.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+
+#include "rmi_drvr.h"
+#include "rmi_function.h"
+#include "rmi_bus.h"
+#include "rmi_sensor.h"
+
+/* supported RMI4 functions list - controls what we
+ * will provide support for - if it's not in the list then
+ * the developer needs to add support functions for it.*/
+static LIST_HEAD(fns_list);
+static DEFINE_MUTEX(fns_mutex);
+
+/* NOTE: Developer - add in any new RMI4 fn data info - function number
+ * and ptrs to report, config, init and detect functions.  This data is
+ * used to point to the functions that need to be called to config, init,
+ * detect and report data for the new RMI4 function. Refer to the RMI4
+ * specification for information on RMI4 functions.
+ */
+/* TODO: This will eventually go away, and each function will be an independent
+ * module. */
+static struct rmi_functions_data
+	rmi4_supported_data_src_functions[rmi4_num_supported_data_src_fns] = {
+	/* Fn $11 - 2D sensing */
+	{.functionNumber = 0x11, .inthandlerFn = FN_11_inthandler, .configFn = FN_11_config, .initFn = FN_11_init, .detectFn = FN_11_detect, .attnFn = NULL},
+	/* Fn $01 - device control */
+	{.functionNumber = 0x01, .inthandlerFn = FN_01_inthandler, .configFn = FN_01_config, .initFn = FN_01_init, .detectFn = FN_01_detect, .attnFn = FN_01_attention},
+	/* Fn $34 - firmware reflash */
+	{.functionNumber = 0x34, .inthandlerFn = FN_34_inthandler, .configFn = FN_34_config, .initFn = FN_34_init, .detectFn = FN_34_detect, .attnFn = FN_34_attention},
+};
+
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
+
+static void rmi_function_config(struct rmi_function_device *function)
+{
+	printk(KERN_DEBUG "%s: rmi_function_config", __func__);
+
+}
+
+/**
+ * This is the probe function passed to the RMI4 subsystem that gives us a
+ * chance to recognize an RMI4 function.
+ */
+static int rmi_function_probe(struct rmi_function_driver *function)
+{
+	struct rmi_phys_driver *rpd;
+
+	rpd = function->rpd;
+
+	if (!rpd) {
+		printk(KERN_ERR "%s: Invalid rmi physical driver - null ptr.", __func__);
+		return 0;
+	}
+
+	return 1;
+}
+
+/** Just a stub for now.
+ */
+static int rmi_function_suspend(struct device *dev, pm_message_t state)
+{
+	printk(KERN_INFO "%s: function suspend called.", __func__);
+	return 0;
+}
+
+/** Just a stub for now.
+ */
+static int rmi_function_resume(struct device *dev)
+{
+	printk(KERN_INFO "%s: function resume called.", __func__);
+	return 0;
+}
+
+int rmi_function_register_driver(struct rmi_function_driver *drv, int fnNumber)
+{
+	int retval;
+	char *drvrname;
+
+	printk(KERN_INFO "%s: Registering function driver for F%02x.\n", __func__, fnNumber);
+
+	retval = 0;
+
+	/* Create a function device and function driver for this Fn */
+	drvrname = kzalloc(sizeof(functionname) + 4, GFP_KERNEL);
+	if (!drvrname) {
+		printk(KERN_ERR "%s: Error allocating memeory for rmi_function_driver name.\n", __func__);
+		return -ENOMEM;
+	}
+	sprintf(drvrname, "fn%02x", fnNumber);
+
+	drv->drv.name = drvrname;
+	drv->module = drv->drv.owner;
+
+	drv->drv.suspend = rmi_function_suspend;
+	drv->drv.resume = rmi_function_resume;
+
+	/* register the sensor driver */
+	retval = driver_register(&drv->drv);
+	if (retval) {
+		printk(KERN_ERR "%s: Failed driver_register %d\n",
+			__func__, retval);
+	}
+
+	return retval;
+}
+EXPORT_SYMBOL(rmi_function_register_driver);
+
+void rmi_function_unregister_driver(struct rmi_function_driver *drv)
+{
+	printk(KERN_INFO "%s: Unregistering function driver.\n", __func__);
+
+	driver_unregister(&drv->drv);
+}
+EXPORT_SYMBOL(rmi_function_unregister_driver);
+
+int rmi_function_register_device(struct rmi_function_device *function_device, int fnNumber)
+{
+	struct input_dev *input;
+	int retval;
+
+	printk(KERN_INFO "%s: Registering function device for F%02x.\n", __func__, fnNumber);
+
+	retval = 0;
+
+	/* make name - fn11, fn19, etc. */
+	dev_set_name(&function_device->dev, "%sfn%02x", function_device->sensor->drv.name, fnNumber);
+	dev_set_drvdata(&function_device->dev, function_device);
+	retval = device_register(&function_device->dev);
+	if (retval) {
+		printk(KERN_ERR "%s:  Failed device_register for function device.\n",
+			__func__);
+		return retval;
+	}
+
+	input = input_allocate_device();
+	if (input == NULL) {
+		printk(KERN_ERR "%s:  Failed to allocate memory for a "
+			"new input device.\n",
+			__func__);
+		return -ENOMEM;
+	}
+
+	input->name = dev_name(&function_device->dev);
+	input->phys = "rmi_function";
+	function_device->input = input;
+
+
+	/* init any input specific params for this function */
+	function_device->rmi_funcs->init(function_device);
+
+	retval = input_register_device(input);
+
+	if (retval) {
+		printk(KERN_ERR "%s:  Failed input_register_device.\n",
+			__func__);
+		return retval;
+	}
+
+
+	rmi_function_config(function_device);
+
+	return retval;
+}
+EXPORT_SYMBOL(rmi_function_register_device);
+
+void rmi_function_unregister_device(struct rmi_function_device *dev)
+{
+	printk(KERN_INFO "%s: Unregistering function device.n", __func__);
+
+	input_unregister_device(dev->input);
+	device_unregister(&dev->dev);
+}
+EXPORT_SYMBOL(rmi_function_unregister_device);
+
+static int __init rmi_function_init(void)
+{
+	struct rmi_functions_data *rmi4_fn;
+	int i;
+
+	printk(KERN_DEBUG "%s: RMI Function Init\n", __func__);
+
+	/* Initialize global list of RMI4 Functions.
+	We need to add the supported RMI4 funcions so that we will have
+	pointers to the associated functions for init, config, report and
+	detect. See rmi.h for more details. The developer will add a new
+	RMI4 function number in the array in rmi_drvr.h, then add a new file to
+	the build (called rmi_fXX.c where XX is the hex number for
+	the added RMI4 function). The rest should be automatic.
+	*/
+
+	/* for each function number defined in rmi.h creat a new rmi_function
+	struct and initialize the pointers to the servicing functions and then
+	add it into the global list for function support.
+	*/
+	for (i = 0; i < rmi4_num_supported_data_src_fns; i++) {
+		/* Add new rmi4 function struct to list */
+		struct rmi_functions *fn = kzalloc(sizeof(*fn), GFP_KERNEL);
+		if (!fn) {
+			printk(KERN_ERR "%s: could not allocate memory "
+				"for rmi_function struct for function 0x%x\n",
+				__func__,
+				rmi4_supported_data_src_functions[i].functionNumber);
+			return -ENOMEM;
+		} else {
+
+			rmi4_fn = &rmi4_supported_data_src_functions[i];
+			fn->functionNum = rmi4_fn->functionNumber;
+			/* Fill in ptrs to functions. The functions are
+			linked in from a file called rmi_fxx.c
+			where xx is the hex number of the RMI4 function
+			from the RMI4 spec. Also, the function prototypes
+			need to be added to rmi_fxx.h - also where
+			xx is the hex number of the RMI4 function.  So
+			that you don't get compile errors and that new
+			header needs to be included in the rmi_function.h
+			*/
+			fn->inthandler = rmi4_fn->inthandlerFn;
+			fn->config = rmi4_fn->configFn;
+			fn->init =   rmi4_fn->initFn;
+			fn->detect = rmi4_fn->detectFn;
+			fn->attention = rmi4_fn->attnFn;
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
+static void __exit rmi_function_exit(void)
+{
+	printk(KERN_DEBUG "%s: RMI Function Exit\n", __func__);
+}
+
+
+module_init(rmi_function_init);
+module_exit(rmi_function_exit);
+
+MODULE_AUTHOR("Synaptics, Inc.");
+MODULE_DESCRIPTION("RMI4 Function Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/input/touchscreen/rmi_function.h b/drivers/input/touchscreen/rmi_function.h
new file mode 100755
index 0000000..b17ffef
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_function.h
@@ -0,0 +1,229 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) Function Device Header File.
+ * Copyright (c) 2007 - 2011, Synaptics Incorporated
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
+#ifndef _RMI_FUNCTION_H
+#define _RMI_FUNCTION_H
+
+#include <linux/input.h>
+#include <linux/device.h>
+
+
+/* For each function present on the RMI device, there will be a corresponding
+ * entry in the functions list of the rmi_sensor_driver structure.  This entry
+ * gives information about the number of data sources and the number of data
+ * registers associated with the function.
+ */
+struct rmi_function_info {
+	/* The sensor this function belongs to.
+	*/
+	struct rmi_sensor_driver *sensor;
+
+	/* A device associated with this function.
+	*/
+	struct rmi_function_device *function_device;
+
+	unsigned char functionNum;
+
+	/* This is the number of data sources associated with the function.*/
+	unsigned char numSources;
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
+	/* pointer to data specific to a functions implementation. */
+	void *fndata;
+
+	/* A list of the function information.
+	*  This list uses the standard kernel linked list implementation.
+	*  Documentation on on how to use it can be found at
+	*  http://isis.poly.edu/kulesh/stuff/src/klist/.
+	*/
+	struct list_head link;
+};
+
+
+/* This struct is for creating a list of RMI4 functions that have data sources
+associated with them. This is to facilitate adding new support for other
+data sources besides 2D sensors.
+To add a new data source support, the developer will create a new file
+and add these 4 functions below with FN$## in front of the names - where
+## is the hex number for the function taken from the RMI4 specification.
+
+The function number will be associated with this and later will be used to
+match the RMI4 function to the 4 functions for that RMI4 function number.
+The user will also have to add code that adds the new rmi_functions item
+to the global list of RMI4 functions and stores the pointers to the 4
+functions in the function pointers.
+ */
+struct rmi_functions {
+	unsigned char functionNum;
+
+	/* Pointers to function specific functions for interruptHandler, config, init
+	, detect and attention. */
+	/* These ptrs. need to be filled in for every RMI4 function that has
+	data source(s) associated with it - like fn $11 (2D sensors),
+	fn $19 (buttons), etc. Each RMI4 function that has data sources
+	will be added into a list that is used to match the function
+	number against the number stored here.
+	*/
+	/* The sensor implementation will call this whenever and IRQ is
+	* dispatched that this function is interested in.
+	*/
+	void (*inthandler)(struct rmi_function_info *rfi, unsigned int assertedIRQs);
+
+	int (*config)(struct rmi_function_info *rmifninfo);
+	int (*init)(struct rmi_function_device *function_device);
+	int (*detect)(struct rmi_function_info *rmifninfo,
+		struct rmi_function_descriptor *fndescr,
+		unsigned int interruptCount);
+	/** If this is non-null, the sensor implemenation will call this
+	* whenever the ATTN line is asserted.
+	*/
+	void (*attention)(struct rmi_function_info *rmifninfo);
+
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
+bump the number of supported functions and add the info for
+that RMI4 function to the array along with pointers to the report,
+config, init and detect functions that they coded in rmi_fxx.c
+and rmi_fxx.h - where xx is the RMI4 function number in hex for the new
+RMI4 data source function. The information for the RMI4 functions is
+obtained from the RMI4 specification document.
+ */
+#define rmi4_num_supported_data_src_fns 3
+
+/* add hdr files for all prototypes for RMI4 data source
+functions being supported. */
+#include "rmi_f01.h"
+#include "rmi_f11.h"
+#include "rmi_f34.h"
+
+typedef void(*inthandlerFuncPtr)(struct rmi_function_info *rfi, unsigned int assertedIRQs);
+typedef int(*configFuncPtr)(struct rmi_function_info *rmifninfo);
+typedef int(*initFuncPtr)(struct rmi_function_device *function_device);
+typedef int(*detectFuncPtr)(struct rmi_function_info *rmifninfo,
+		struct rmi_function_descriptor *fndescr,
+		unsigned int interruptCount);
+typedef	void (*attnFuncPtr)(struct rmi_function_info *rmifninfo);
+
+struct rmi_functions_data {
+	int functionNumber;
+	inthandlerFuncPtr inthandlerFn;
+	configFuncPtr configFn;
+	initFuncPtr initFn;
+	detectFuncPtr detectFn;
+	attnFuncPtr attnFn;
+};
+
+
+struct rmi_functions *rmi_find_function(int functionNum);
+int rmi_functions_init(struct input_dev *inputdev);
+
+struct rmi_function_driver {
+	struct module *module;
+	struct device_driver drv;
+
+	/* Probe Function
+	*  This function is called to give the function driver layer an
+	*  opportunity to claim an RMI function.
+	*/
+	int (*probe)(struct rmi_function_driver *function);
+	/* Config Function
+	*  This function is called after a successful probe.  It gives the
+	*  function driver an opportunity to query and/or configure an RMI
+	*  function before data starts flowing.
+	*/
+	void (*config)(struct rmi_function_driver *function);
+
+	unsigned short functionQueryBaseAddr; /* RMI4 function control */
+	unsigned short functionControlBaseAddr;
+	unsigned short functionCommandBaseAddr;
+	unsigned short functionDataBaseAddr;
+	unsigned int interruptRegisterOffset; /* offset from start of interrupt registers */
+	unsigned int interruptMask;
+
+	/* pointer to the corresponding phys driver info for this sensor */
+	/* The phys driver has the pointers to read, write, etc. */
+	/* Probably don't need it here - used down in bus driver and sensor driver */
+	struct rmi_phys_driver *rpd;
+
+	/* Standard kernel linked list implementation.
+	*  Documentation on how to use it can be found at
+	*  http://isis.poly.edu/kulesh/stuff/src/klist/.
+	*/
+	struct list_head function_drivers; /* link function drivers into list */
+};
+
+struct rmi_function_device {
+	struct rmi_function_driver *function;
+	struct device dev;
+	struct input_dev *input;
+	struct rmi_sensor_driver *sensor; /* need this to be bound to phys driver layer */
+
+	/* the function ptrs to the config, init, detect and
+	report fns for this rmi function device. */
+	struct rmi_functions *rmi_funcs;
+	struct rmi_function_info *rfi;
+
+	/** An RMI sensor might actually have several IRQ registers -
+	* this tells us which IRQ register this function is interested in.
+	*/
+	unsigned int irqRegisterSet;
+
+	/** This is a mask of the IRQs the function is interested in.
+	*/
+	unsigned int irqMask;
+
+	/* Standard kernel linked list implementation.
+	*  Documentation on how to use it can be found at
+	*  http://isis.poly.edu/kulesh/stuff/src/klist/.
+	*/
+	struct list_head functions; /* link functions into list */
+};
+
+int rmi_function_register_device(struct rmi_function_device *dev, int fnNumber);
+
+#endif
diff --git a/drivers/input/touchscreen/rmi_function_11.c b/drivers/input/touchscreen/rmi_function_11.c
deleted file mode 100644
index ab63f4c..0000000
--- a/drivers/input/touchscreen/rmi_function_11.c
+++ /dev/null
@@ -1,439 +0,0 @@
-/**
- *
- * Synaptics Register Mapped Interface (RMI4) Function $11 support for 2D.
- * Copyright (c) 2007 - 2010, Synaptics Incorporated
- *
- * For every RMI4 function that has a data source - like 2D sensors,
- * buttons, LEDs, GPIOs, etc. - the user will create a new rmi_function_xx.c
- * file and add these functions to perform the config(), init(), report()
- * and detect() functionality. The function pointers are then srored under
- * the RMI function info and these functions will automatically be called by
- * the global config(), init(), report() and detect() functions that will
- * loop through all data sources and call the data sources functions using
- * these functions pointed to by the function ptrs.
- */
-/*
- * This file is licensed under the GPL2 license.
- *
- *#############################################################################
- * GPL
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2 as published
- * by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
- * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
- * for more details.
- *
- *#############################################################################
- */
-
-#include <linux/kernel.h>
-#include <linux/device.h>
-#include <linux/delay.h>
-#include <linux/kthread.h>
-#include <linux/freezer.h>
-#include <linux/input.h>
-
-#include "rmi.h"
-#include "rmi_core.h"
-#include "rmi_functions.h"
-
-extern unsigned short fn01ControlBaseAddr;  /* RMI4 device control == function 0x01 */
-
-static int sensorMaxX;
-static int sensorMaxY;
-
-/*
- * This reads in a sample and reports the function $11 source data to the
- * input subsystem. It is used for both polling and interrupt driven
- * operation. This is called a lot so don't put in any informational
- * printks since they will slow things way down!
- */
-int FN_11_report(struct rmi_application *app,
-		struct rmi_function_info *rfi, struct input_dev *input)
-{
-	unsigned char values[2] = {0, 0};
-	unsigned char data[12] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
-	/* number of touch points - fingers down in this case */
-	int fingerDownCount;
-	int X, Y, Z, W, Wy, Wx;
-	int finger;
-	int ret;
-	int fn11FingersSupported;
-	int fn11FingerRegisters;
-	unsigned short fn11DataBaseAddr;
-	unsigned char fn11DataRegBlockSize;
-	static bool wasdown = false;
-
-	ret = 0;
-	fingerDownCount = 0;
-
-	/* get 2D sensor finger data */
-
-	/* First get the finger status field - the size of the finger status field is
-	determined by the number of fingers supported - 2 bits per finger, so the number
-	of registers to read is : registerCount = ciel(numberOfFingers/4).
-	Read the required number of registers and check each 2 bit field to determine
-	if a finger is down (00 = finger not present, 01 = finger present and data accurate,
-	10 = finger present but data may not be accurate, 11 = reserved for product use).
-	*/
-	fn11FingersSupported = rfi->numDataPoints;
-	fn11FingerRegisters = (fn11FingersSupported + 3)/4;
-
-	fn11DataBaseAddr = rfi->funcDescriptor.dataBaseAddr;
-
-	if (rmi_read_multiple(app, fn11DataBaseAddr, values,
-			fn11FingerRegisters)) {
-		printk(KERN_ERR "%s: RMI4 function $11 report: "
-			"Could not read finger status registers 0x%x\n",
-			__func__, fn11DataBaseAddr);
-		ret = -ENODEV;
-		goto err_ret;
-	}
-
-	/* For each finger present, read the proper number of registers
-	to get absolute data. */
-	fn11DataRegBlockSize = rfi->dataRegBlockSize;
-
-	for (finger = 0; finger < fn11FingersSupported; finger++) {
-		int reg;
-		int fingerShift;
-		int fingerStatus;
-
-		/* determine which data byte the finger status is in */
-		reg = finger/4;
-		/* bit shift to get finger's status */
-		fingerShift = (finger % 4) * 2;
-		fingerStatus = (values[reg] >> fingerShift) & 3;
-
-		/* if finger status indicates a finger is present then
-		read the finger data and report it */
-		if (fingerStatus == 1 || fingerStatus == 2) {
-			/* number of active touch points not same as
-			number of supported fingers */
-			fingerDownCount++;
-
-			/* Read the finger data */
-			if (rmi_read_multiple(app, fn11DataBaseAddr +
-					((finger  * fn11DataRegBlockSize) +
-					fn11FingerRegisters),
-					data, fn11DataRegBlockSize)) {
-				pr_debug("%s: RMI4 function $11 report: "
-					"Could not read finger data registers "
-					"0x%x\n", __func__,
-					fn11DataBaseAddr +
-					((finger  * fn11DataRegBlockSize) +
-					fn11FingerRegisters));
-				break; /* failed to read this finger - skip */
-			} else {
-				X = (data[0] & 0x1f) << 4;
-				X |= data[2] & 0xf;
-				Y = (data[1] & 0x1f) << 4;
-				Y |= (data[2] >> 4) & 0xf;
-				W = data[3];
-
-				/* upper 4 bits of W are Wy,
-				lower 4 of W are Wx */
-				Wy =  (W >> 4) & 0x0f;
-				Wx = W & 0x0f;
-
-				Z = data[4];
-
-				/* if this is the first finger report normal
-				ABS_X, ABS_Y, PRESSURE, TOOL_WIDTH events for
-				non-MT apps. Apps that support Multi-touch
-				will ignore these events and use the MT events.
-				Apps that don't support Multi-touch will still
-				function.
-				*/
-
-				if (fingerDownCount == 1) {
-					input_report_abs(input, ABS_X, X);
-					input_report_abs(input, ABS_Y, Y);
-					input_report_abs(input, ABS_PRESSURE, Z);
-					input_report_abs(input, ABS_TOOL_WIDTH,
-							max(Wx, Wy));
-					input_report_key(input, BTN_TOUCH, 1);
-					wasdown = true;
-				}
-
-#ifdef CONFIG_SYNA_MULTI_TOUCH
-				/* Report Multi-Touch events for each finger */
-				/* major axis of touch area ellipse */
-				input_report_abs(input, ABS_MT_TOUCH_MAJOR,
-						max(Wx, Wy));
-				/* minor axis of touch area ellipse */
-				input_report_abs(input, ABS_MT_TOUCH_MINOR,
-						min(Wx, Wy));
-				/* Currently only 2 supported - 1 or 0 */
-				input_report_abs(input, ABS_MT_ORIENTATION,
-						(Wx > Wy ? 1 : 0));
-				input_report_abs(input, ABS_MT_POSITION_X, X);
-				input_report_abs(input, ABS_MT_POSITION_Y, Y);
-
-				/* TODO: Tracking ID needs to be reported but not used yet. */
-				/* Could be formed by keeping an id per position and assiging */
-				/* a new id when fingerStatus changes for that position.*/
-				input_report_abs(input, ABS_MT_TRACKING_ID,
-						finger+1);
-
-				/* MT sync between fingers */
-				input_mt_sync(input);
-#endif
-			}
-		}
-	}
-
-	/* if we had a finger down before and now we don't have any send a button up. */
-	if ((fingerDownCount == 0) && wasdown) {
-		wasdown = false;
-		input_report_key(input, BTN_TOUCH, 0);
-	}
-
-	input_sync(input); /* sync after groups of events */
-
-err_ret:
-
-	return ret;
-}
-
-int FN_11_config(struct rmi_application *app, struct rmi_function_info *rfi)
-{
-	/* For the data source - print info and do any
-	source specific configuration. */
-	unsigned char data[14];
-	int retval = 0;
-
-	pr_debug("%s: RMI4 function $11 config\n", __func__);
-
-	/* Get and print some info about the data source... */
-
-	/* To Query 2D devices we need to read from the address obtained
-	* from the function descriptor stored in the RMI function info.
-	*/
-	retval = rmi_read_multiple(app, rfi->funcDescriptor.queryBaseAddr,
-		data, 9);
-	if (retval) {
-		printk(KERN_ERR "%s: RMI4 function $11 config:"
-			"Could not read function query registers 0x%x\n",
-			__func__, rfi->funcDescriptor.queryBaseAddr);
-	} else {
-		pr_debug("%s:  Number of Fingers:   %d\n",
-				__func__, data[1] & 7);
-		pr_debug("%s:  Is Configurable:     %d\n",
-				__func__, data[1] & (1 << 7) ? 1 : 0);
-		pr_debug("%s:  Has Gestures:        %d\n",
-				__func__, data[1] & (1 << 5) ? 1 : 0);
-		pr_debug("%s:  Has Absolute:        %d\n",
-				__func__, data[1] & (1 << 4) ? 1 : 0);
-		pr_debug("%s:  Has Relative:        %d\n",
-				__func__, data[1] & (1 << 3) ? 1 : 0);
-
-		pr_debug("%s:  Number X Electrodes: %d\n",
-				__func__, data[2] & 0x1f);
-		pr_debug("%s:  Number Y Electrodes: %d\n",
-				__func__, data[3] & 0x1f);
-		pr_debug("%s:  Maximum Electrodes:  %d\n",
-				__func__, data[4] & 0x1f);
-
-		pr_debug("%s:  Absolute Data Size:  %d\n",
-				__func__, data[5] & 3);
-
-		pr_debug("%s:  Has XY Dist:         %d\n",
-				__func__, data[7] & (1 << 7) ? 1 : 0);
-		pr_debug("%s:  Has Pinch:           %d\n",
-				__func__, data[7] & (1 << 6) ? 1 : 0);
-		pr_debug("%s:  Has Press:           %d\n",
-				__func__, data[7] & (1 << 5) ? 1 : 0);
-		pr_debug("%s:  Has Flick:           %d\n",
-				__func__, data[7] & (1 << 4) ? 1 : 0);
-		pr_debug("%s:  Has Early Tap:       %d\n",
-				__func__, data[7] & (1 << 3) ? 1 : 0);
-		pr_debug("%s:  Has Double Tap:      %d\n",
-				__func__, data[7] & (1 << 2) ? 1 : 0);
-		pr_debug("%s:  Has Tap and Hold:    %d\n",
-				__func__, data[7] & (1 << 1) ? 1 : 0);
-		pr_debug("%s:  Has Tap:             %d\n",
-				__func__, data[7] & 1 ? 1 : 0);
-		pr_debug("%s:  Has Palm Detect:     %d\n",
-				__func__, data[8] & 1 ? 1 : 0);
-		pr_debug("%s:  Has Rotate:          %d\n",
-				__func__, data[8] & (1 << 1) ? 1 : 0);
-
-		retval = rmi_read_multiple(app,
-				rfi->funcDescriptor.controlBaseAddr, data, 14);
-		if (retval) {
-			printk(KERN_ERR "%s: RMI4 function $11 config:"
-				"Could not read control registers 0x%x\n",
-				__func__, rfi->funcDescriptor.controlBaseAddr);
-			return retval;
-		}
-
-		/* Store these for use later...*/
-		sensorMaxX = ((data[6] & 0x1f) << 8) | ((data[7] & 0xff) << 0);
-		sensorMaxY = ((data[8] & 0x1f) << 8) | ((data[9] & 0xff) << 0);
-
-		pr_debug("%s:  Sensor Max X:  %d\n", __func__, sensorMaxX);
-		pr_debug("%s:  Sensor Max Y:  %d\n", __func__, sensorMaxY);
-	}
-
-	return retval;
-}
-
-/* Initialize any function $11 specific params and settings - input
- * settings, device settings, etc.
- */
-int FN_11_init(struct input_dev *input)
-{
-	pr_debug("%s: RMI4 function $11 init\n", __func__);
-
-	/* need to init the input abs params for the 2D */
-	input->evbit[0] = BIT(EV_ABS);
-
-	/* Use the max X and max Y read from the device...*/
-	input_set_abs_params(input, ABS_X, 0, sensorMaxX, 0, 0);
-	input_set_abs_params(input, ABS_Y, 0, sensorMaxY, 0, 0);
-	input_set_abs_params(input, ABS_PRESSURE, 0, 255, 0, 0);
-	input_set_abs_params(input, ABS_TOOL_WIDTH, 0, 15, 0, 0);
-
-#ifdef CONFIG_SYNA_MULTI_TOUCH
-	input_set_abs_params(input, ABS_MT_TOUCH_MAJOR, 0, 15, 0, 0);
-	input_set_abs_params(input, ABS_MT_TOUCH_MINOR, 0, 15, 0, 0);
-	input_set_abs_params(input, ABS_MT_ORIENTATION, 0, 1, 0, 0);
-	input_set_abs_params(input, ABS_MT_TRACKING_ID, 1, 10, 0, 0);
-	input_set_abs_params(input, ABS_MT_POSITION_X, 0, sensorMaxX, 0, 0);
-	input_set_abs_params(input, ABS_MT_POSITION_Y, 0, sensorMaxY, 0, 0);
-#endif
-
-	return 0;
-}
-
-int FN_11_detect(struct rmi_application *app, struct rmi_function_info *rfi,
-	struct rmi_function_descriptor *fd, unsigned int interruptCount)
-{
-	char fn11Queries[9];
-	int i;
-	unsigned short fn11InterruptOffset;
-	unsigned char fn11AbsDataSize;
-	unsigned char fn11AbsDataBlockSize;
-	int fn11HasPinch, fn11HasFlick, fn11HasTap;
-	int fn11HasTapAndHold, fn11HasDoubleTap;
-	int fn11HasEarlyTap, fn11HasPress;
-	int fn11HasPalmDetect, fn11HasRotate;
-	int fn11HasRel;
-	unsigned char f11_egr_0, f11_egr_1;
-	unsigned int fn11AllDataBlockSize;
-	int retval = 0;
-
-	pr_debug("%s: RMI4 function $11 detect\n", __func__);
-
-	/* Store addresses - used elsewhere to read data,
-	 * control, query, etc. */
-	rfi->funcDescriptor.queryBaseAddr = fd->queryBaseAddr;
-	rfi->funcDescriptor.commandBaseAddr = fd->commandBaseAddr;
-	rfi->funcDescriptor.controlBaseAddr = fd->controlBaseAddr;
-	rfi->funcDescriptor.dataBaseAddr = fd->dataBaseAddr;
-	rfi->funcDescriptor.interruptSrcCnt = fd->interruptSrcCnt;
-	rfi->funcDescriptor.functionNum = fd->functionNum;
-
-	rfi->numSources = fd->interruptSrcCnt;
-
-	/* need to get number of fingers supported, data size, etc. -
-	to be used when getting data since the number of registers to
-	read depends on the number of fingers supported and data size. */
-	retval = rmi_read_multiple(app, fd->queryBaseAddr, fn11Queries,
-			sizeof(fn11Queries));
-	if (retval) {
-		printk(KERN_ERR "%s: RMI4 function $11 detect: "
-			"Could not read function query registers 0x%x\n",
-			__func__,  rfi->funcDescriptor.queryBaseAddr);
-		return retval;
-	}
-
-	/* 2D data sources have only 3 bits for the number of fingers
-	supported - so the encoding is a bit wierd. */
-	rfi->numDataPoints = 2; /* default number of fingers supported */
-	if ((fn11Queries[1] & 0x7) <= 4)
-		/* add 1 since zero based */
-		rfi->numDataPoints = (fn11Queries[1] & 0x7) + 1;
-	else {
-		/* a value of 5 is up to 10 fingers - 6 and 7 are reserved
-		(shouldn't get these i int retval;n a normal 2D source). */
-		if ((fn11Queries[1] & 0x7) == 5)
-			rfi->numDataPoints = 10;
-	}
-
-	/* Need to get interrupt info to be used later when handling
-	interrupts. */
-	rfi->interruptRegister = (interruptCount + 7)/8;
-
-	/* loop through interrupts for each source in fn $11 and or in a bit
-	to the interrupt mask for each. */
-	fn11InterruptOffset = interruptCount % 8;
-
-	for (i = fn11InterruptOffset;
-			i < ((fd->interruptSrcCnt & 0x7) + fn11InterruptOffset);
-			i++)
-		rfi->interruptMask |= 1 << i;
-
-	/* Size of just the absolute data for one finger */
-	fn11AbsDataSize = fn11Queries[5] & 0x03;
-	/* One each for X and Y, one for LSB for X & Y, one for W, one for Z */
-	fn11AbsDataBlockSize = 3 + (2 * (fn11AbsDataSize == 0 ? 1 : 0));
-	rfi->dataRegBlockSize = fn11AbsDataBlockSize;
-
-	/* need to determine the size of data to read - this depends on
-	conditions such as whether Relative data is reported and if Gesture
-	data is reported. */
-	f11_egr_0 = fn11Queries[7];
-	f11_egr_1 = fn11Queries[8];
-
-	/* Get info about what EGR data is supported, whether it has
-	Relative data supported, etc. */
-	fn11HasPinch = f11_egr_0 & 0x40;
-	fn11HasFlick = f11_egr_0 & 0x10;
-	fn11HasTap = f11_egr_0 & 0x01;
-	fn11HasTapAndHold = f11_egr_0 & 0x02;
-	fn11HasDoubleTap = f11_egr_0 & 0x04;
-	fn11HasEarlyTap = f11_egr_0 & 0x08;
-	fn11HasPress = f11_egr_0 & 0x20;
-	fn11HasPalmDetect = f11_egr_1 & 0x01;
-	fn11HasRotate = f11_egr_1 & 0x02;
-	fn11HasRel = fn11Queries[1] & 0x08;
-
-	/* Size of all data including finger status, absolute data for each
-	finger, relative data and EGR data */
-	fn11AllDataBlockSize =
-		/* finger status, four fingers per register */
-		((rfi->numDataPoints + 3) / 4) +
-		/* absolute data, per finger times number of fingers */
-		(fn11AbsDataBlockSize * rfi->numDataPoints) +
-		/* two relative registers (if relative is being reported) */
-		2 * fn11HasRel +
-		/* F11_2D_Data8 is only present if the egr_0
-		register is non-zero. */
-		!!(f11_egr_0) +
-		/* F11_2D_Data9 is only present if either egr_0 or
-		egr_1 registers are non-zero. */
-		(f11_egr_0 || f11_egr_1) +
-		/* F11_2D_Data10 is only present if EGR_PINCH or EGR_FLICK of
-		egr_0 reports as 1. */
-		!!(fn11HasPinch | fn11HasFlick) +
-		/* F11_2D_Data11 and F11_2D_Data12 are only present if
-		EGR_FLICK of egr_0 reports as 1. */
-		2 * !!(fn11HasFlick);
-
-	/* Disable Interrupts. It is up to the Application Driver to
-	* turn them on when it's ready for them. */
-	retval = rmi_write(app,
-			fn01ControlBaseAddr + 1 + rfi->interruptRegister, 0);
-	if (!retval) {
-		printk(KERN_ERR "%s: Function $11 Interrupt Disable Fail: %d\n",
-				__func__, retval);
-	}
-
-	return retval;
-}
diff --git a/drivers/input/touchscreen/rmi_function_11.h b/drivers/input/touchscreen/rmi_function_11.h
deleted file mode 100644
index e90d889..0000000
--- a/drivers/input/touchscreen/rmi_function_11.h
+++ /dev/null
@@ -1,43 +0,0 @@
-/**
- *
- * Synaptics Register Mapped Interface (RMI4) Function $11 support for 2D.
- * Copyright (c) 2007 - 2010, Synaptics Incorporated
- *
- * For every RMI4 function that has a data source - like 2D sensors,
- * buttons, LEDs, GPIOs, etc. - the user will create a new rmi_function_xx.c
- * file and add these functions to perform the config(), init(), report()
- * and detect() functionality. The function pointers are then srored under
- * the RMI function info and these functions will automatically be called by
- * the global config(), init(), report() and detect() functions that will
- * loop through all data sources and call the data sources functions using
- * these functions pointed to by the function ptrs.
- */
-/*
- * This file is licensed under the GPL2 license.
- *
- *#############################################################################
- * GPL
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2 as published
- * by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
- * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
- * for more details.
- *
- *#############################################################################
- */
-#ifndef _RMI_FUNCTION_11_H
-#define _RMI_FUNCTION_11_H
-
-int FN_11_report(struct rmi_application *app, struct rmi_function_info *rfi,
-		struct input_dev *input);
-int FN_11_config(struct rmi_application *app, struct rmi_function_info *rfi);
-int FN_11_init(struct input_dev *input);
-int FN_11_detect(struct rmi_application *app, struct rmi_function_info *rfi,
-		struct rmi_function_descriptor *fd,
-		unsigned int interruptCount);
-
-#endif
diff --git a/drivers/input/touchscreen/rmi_functions.h b/drivers/input/touchscreen/rmi_functions.h
deleted file mode 100644
index 75f1ded..0000000
--- a/drivers/input/touchscreen/rmi_functions.h
+++ /dev/null
@@ -1,111 +0,0 @@
-
-/**
- *
- * Synaptics Register Mapped Interface (RMI4) Functions Definition Header File.
- * Copyright (c) 2007 - 2010, Synaptics Incorporated
- *
- *
- */
-/*
- * This file is licensed under the GPL2 license.
- *
- *#############################################################################
- * GPL
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2 as published
- * by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
- * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
- * for more details.
- *
- *#############################################################################
- */
-
-#ifndef _RMI_FUNCTIONS_H
-#define _RMI_FUNCTIONS_H
-
-/* This struct is for creating a list of RMI4 functions that have data sources
-   associated with them. This is to facilitate adding new support for other
-   data sources besides 2D sensors.
-   To add a new data source support, the developer will create a new file
-   and add these 4 functions below with FN$## in front of the names - where
-   ## is the hex number for the function taken from the RMI4 specification.
-
-   The function number will be associated with this and later will be used to
-   match the RMI4 function to the 4 functions for that RMI4 function number.
-
-   The user will also have to add code that adds the new rmi_functions item
-   to the global list of RMI4 functions and stores the pointers to the 4
-   functions in the function pointers.
-*/
-struct rmi_functions {
-	unsigned char functionNum;
-
-	struct input_dev *input;
-
-	/* Pointers to function specific functions for report, config, init
-	   and detect. */
-	/* These ptrs. need to be filled in for every RMI4 function that has
-	   data source(s) associated with it - like fn $11 (2D sensors),
-	   fn $19 (buttons), etc. Each RMI4 function that has data sources
-	   will be added into a list that is used to match the function
-	   number against the number stored here.
-	*/
-	int (*report)(struct rmi_application *app,
-		struct rmi_function_info *rfi, struct input_dev *input);
-	int (*config)(struct rmi_application *app,
-		struct rmi_function_info *rfi);
-	int (*init)(struct input_dev *input);
-	int (*detect)(struct rmi_application *app,
-		struct rmi_function_info *rfi,
-		struct rmi_function_descriptor *fd,
-		unsigned int interruptCount);
-
-	/* Standard kernel linked list implementation.
-	* Documentation on how to use it can be found at
-	* http://isis.poly.edu/kulesh/stuff/src/klist/.
-	*/
-	struct list_head link;
-};
-
-
-/* Each time a new RMI4 function support is added the developer needs to
-   bump the number of supported data src functions and add the info for
-   that RMI4 function to the array along with pointers to the report,
-   config, init and detect functions that they coded in rmi_function_xx.c
-   and rmi_function_xx.h - where xx is the RMI4 function number for the new
-   RMI4 data source function. The information for the RMI4 functions is
-   obtained from the RMI4 specification document.
-*/
-#define rmi4_num_supported_data_src_fns 1
-
-/* add hdr files for all prototypes for RMI4 data source
-   functions being supported. */
-#include "rmi_function_11.h"
-/* #include "rmi_function_19.h" */
-
-typedef int(*reportFuncPtr)(struct rmi_application *app,
-	struct rmi_function_info *rfi, struct input_dev *input);
-typedef int(*configFuncPtr)(struct rmi_application *app,
-	struct rmi_function_info *rfi);
-typedef int(*initFuncPtr)(struct input_dev *input);
-typedef int(*detectFuncPtr)(struct rmi_application *app,
-	struct rmi_function_info *rfi, struct rmi_function_descriptor *fd,
-	unsigned int interruptCount);
-
-struct rmi_functions_data {
-	int functionNumber;
-	reportFuncPtr reportFn;
-	configFuncPtr configFn;
-	initFuncPtr initFn;
-	detectFuncPtr detectFn;
-};
-
-
-struct rmi_functions *rmi_find_function(int functionNum);
-int rmi_functions_init(struct input_dev *inputdev);
-
-#endif
diff --git a/drivers/input/touchscreen/rmi_i2c.c b/drivers/input/touchscreen/rmi_i2c.c
new file mode 100755
index 0000000..b877112
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_i2c.c
@@ -0,0 +1,639 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) I2C Physical Layer Driver.
+ * Copyright (c) 2007-2011, Synaptics Incorporated
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
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include "rmi_i2c.h"
+#include "rmi_drvr.h"
+
+
+#define DRIVER_NAME "rmi4_ts"
+
+#define DEVICE_NAME "rmi4_ts"
+
+/* Used to lock access to the page address.*/
+/* TODO: for multiple device support will need a per-device mutex */
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
+	struct rmi_phys_driver rmiphysdrvr;
+	struct i2c_client *i2cclient; /* pointer to i2c_client for later use in
+					read, write, read_multiple, etc. */
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
+rmi_set_page(struct instance_data *instancedata, unsigned int page)
+{
+	char txbuf[2];
+	int retval;
+	txbuf[0] = 0xff;
+	txbuf[1] = page;
+	retval = i2c_master_send(instancedata->i2cclient, txbuf, 2);
+	if (retval != 2) {
+		dev_err(&instancedata->i2cclient->dev,
+				"%s: Set page fail: %d\n", __func__, retval);
+	} else {
+		retval = 0;
+		instancedata->page = page;
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
+rmi_i2c_read(struct rmi_phys_driver *physdrvr, unsigned short address, char *valp)
+{
+	struct instance_data *instancedata =
+		container_of(physdrvr, struct instance_data, rmiphysdrvr);
+
+	char txbuf[2];
+	int retval = 0;
+	int retry_count = 0;
+
+	/* Can't have anyone else changing the page behind our backs */
+#if 0
+	mutex_lock(&page_mutex);
+
+	if (((address >> 8) & 0xff) != instancedata->page) {
+		/* Switch pages */
+		retval = rmi_set_page(instancedata, ((address >> 8) & 0xff));
+		if (retval)
+			goto exit;
+	}
+#endif
+
+retry:
+	txbuf[0] = address & 0xff;
+	retval = i2c_master_send(instancedata->i2cclient, txbuf, 1);
+
+	if (retval != 1) {
+		dev_err(&instancedata->i2cclient->dev, "%s: Write fail: %d\n",
+				__func__, retval);
+		goto exit;
+	}
+	retval = i2c_master_recv(instancedata->i2cclient, txbuf, 1);
+
+	if (retval != 1) {
+		if (++retry_count == 5) {
+			dev_err(&instancedata->i2cclient->dev,
+					"%s: Read of 0x%04x fail: %d\n",
+					__func__, address, retval);
+		} else {
+			mdelay(10);
+#if 0
+			rmi_set_page(instancedata, ((address >> 8) & 0xff));
+#endif
+			goto retry;
+		}
+	} else {
+		retval = 0;
+		*valp = txbuf[0];
+	}
+exit:
+
+#if 0
+	mutex_unlock(&page_mutex);
+#endif
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
+rmi_i2c_read_multiple(struct rmi_phys_driver *physdrvr, unsigned short address,
+	char *valp, int size)
+{
+	struct instance_data *instancedata =
+		container_of(physdrvr, struct instance_data, rmiphysdrvr);
+
+	char txbuf[2];
+	int retval = 0;
+	int retry_count = 0;
+
+#if 0
+	/* Can't have anyone else changing the page behind our backs */
+	mutex_lock(&page_mutex);
+
+	if (((address >> 8) & 0xff) != instancedata->page) {
+		/* Switch pages */
+		retval = rmi_set_page(instancedata, ((address >> 8) & 0xff));
+		if (retval)
+			goto exit;
+	}
+#endif
+
+retry:
+	txbuf[0] = address & 0xff;
+	retval = i2c_master_send(instancedata->i2cclient, txbuf, 1);
+
+	if (retval != 1) {
+		dev_err(&instancedata->i2cclient->dev, "%s: Write fail: %d\n",
+				__func__, retval);
+		goto exit;
+	}
+	retval = i2c_master_recv(instancedata->i2cclient, valp, size);
+
+	if (retval != size) {
+		if (++retry_count == 5) {
+			dev_err(&instancedata->i2cclient->dev,
+					"%s: Read of 0x%04x size %d fail: %d\n",
+					__func__, address, size, retval);
+		} else {
+			mdelay(10);
+#if 0
+			rmi_set_page(instancedata, ((address >> 8) & 0xff));
+#endif
+			goto retry;
+		}
+	} else {
+		retval = 0;
+	}
+exit:
+
+#if 0
+	mutex_unlock(&page_mutex);
+#endif
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
+rmi_i2c_write(struct rmi_phys_driver *physdrvr, unsigned short address, char data)
+{
+	struct instance_data *instancedata =
+		container_of(physdrvr, struct instance_data, rmiphysdrvr);
+
+	unsigned char txbuf[2];
+	int retval = 0;
+
+#if 0
+	/* Can't have anyone else changing the page behind our backs */
+	mutex_lock(&page_mutex);
+
+	if (((address >> 8) & 0xff) != instancedata->page) {
+		/* Switch pages */
+		retval = rmi_set_page(instancedata, ((address >> 8) & 0xff));
+		if (retval)
+			goto exit;
+	}
+#endif
+
+	txbuf[0] = address & 0xff;
+	txbuf[1] = data;
+	retval = i2c_master_send(instancedata->i2cclient, txbuf, 2);
+
+	/* TODO: Add in retry on writes only in certian error return values */
+	if (retval != 2) {
+		dev_err(&instancedata->i2cclient->dev, "%s: Write fail: %d\n",
+			__func__, retval);
+		goto exit; /* Leave this in case we add code below */
+	}
+exit:
+
+#if 0
+	mutex_unlock(&page_mutex);
+#endif
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
+rmi_i2c_write_multiple(struct rmi_phys_driver *physdrvr, unsigned short address,
+	char *valp, int size)
+{
+	struct instance_data *instancedata =
+		container_of(physdrvr, struct instance_data, rmiphysdrvr);
+
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
+		txbuf = kzalloc(size + 1, GFP_KERNEL);
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
+#if 0
+	/* Can't have anyone else changing the page behind our backs */
+	mutex_lock(&page_mutex);
+
+	if (((address >> 8) & 0xff) != instancedata->page) {
+		/* Switch pages */
+		retval = rmi_set_page(instancedata, ((address >> 8) & 0xff));
+		if (retval)
+			goto exit;
+	}
+#endif
+
+	txbuf[0] = address & 0xff; /* put the address in the first byte */
+	retval = i2c_master_send(instancedata->i2cclient, txbuf, size + 1);
+
+	/* TODO: Add in retyr on writes only in certian error return values */
+	if (retval != 1) {
+		dev_err(&instancedata->i2cclient->dev, "%s: Write fail: %d\n",
+				__func__, retval);
+		goto exit;
+	}
+exit:
+
+#if 0
+	mutex_unlock(&page_mutex);
+#endif
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
+	struct instance_data *instancedata = info;
+
+	disable_irq_nosync(instancedata->irq);
+
+	if (instancedata->rmiphysdrvr.attention) {
+		instancedata->rmiphysdrvr.attention(&instancedata->rmiphysdrvr,
+			instancedata->instance_no);
+	}
+
+	return IRQ_HANDLED;
+}
+
+/* The Driver probe function - will allocate and initialize the instance
+ * data and request the irq and set the instance data as the clients
+ * platform data then register the physical driver which will do a scan of
+ * the RMI4 Physical Device Table and enumerate any RMI4 functions that
+ * have data sources associated with them.
+ */
+static int
+rmi_i2c_probe(struct i2c_client *client, const struct i2c_device_id *dev_id)
+{
+
+	struct instance_data *instancedata;
+	int retval = 0;
+	int i;
+	bool found = false;
+	int irqtype = 0;
+
+	struct rmi_i2c_platformdata *platformdata;
+	struct rmi_i2c_sensordata *sensordata;
+
+	if (client == NULL) {
+		printk(KERN_ERR "%s: Invalid NULL client received.", __func__);
+		return -EINVAL;
+	}
+
+	printk(KERN_INFO "%s: Probing i2c RMI device, addr: 0x%02x", __func__, client->addr);
+
+	/* Egregiously horrible delay here that seems to prevent I2C disasters on
+	 * certain broken dev systems.  In most cases, you can safely remove this.
+	 * TODO: convert this to a parameter than can be spec'ed at boot time,
+	 * so not everyone needs to suffer.
+	 */
+	mdelay(1000);
+
+	/* Allocate and initialize the instance data for this client */
+	instancedata = kzalloc(sizeof(*instancedata), GFP_KERNEL);
+	if (!instancedata) {
+		dev_err(&client->dev,
+			"%s: Out of memory trying to allocate instance_data.\n",
+			__func__);
+		return -ENOMEM;
+	}
+
+	instancedata->rmiphysdrvr.name           = DRIVER_NAME;
+	instancedata->rmiphysdrvr.write          = rmi_i2c_write;
+	instancedata->rmiphysdrvr.read           = rmi_i2c_read;
+	instancedata->rmiphysdrvr.write_multiple = rmi_i2c_write_multiple;
+	instancedata->rmiphysdrvr.read_multiple  = rmi_i2c_read_multiple;
+	instancedata->rmiphysdrvr.module         = THIS_MODULE;
+
+	/* Set default to polling in case no matching platform data is located
+	for this device. We'll still work but in polling mode since we didn't
+	find any irq info */
+	instancedata->rmiphysdrvr.polling_required = true;
+
+	instancedata->page = 0xffff; /* Force a set page the first time */
+
+	/* cast to our struct rmi_i2c_platformdata so we know
+	the fields (see rmi_ic2.h) */
+	platformdata = client->dev.platform_data;
+	if (platformdata == NULL) {
+		printk(KERN_ERR "%s: CONFIGURATION ERROR - platform data is NULL.", __func__);
+		return -EINVAL;
+	}
+
+	/* Loop through the platform data and locate the one that matches
+	the i2c_client I2C address */
+	for (i = 0; i < platformdata->num_sensors; i++) {
+		sensordata = &(platformdata->sensordata[i]);
+		if (sensordata == NULL) {
+			printk(KERN_ERR "%s: CONFIGURATION ERROR - platformdata sensordata[%d] is NULL.", __func__, i);
+			return -EINVAL;
+		}
+		printk(KERN_DEBUG "%s: sensor: %d addr: 0x%02x irq: 0x%x type: %d",
+			__func__, i, sensordata->i2c_address, sensordata->irq, sensordata->irq_type);
+		if (client->addr == sensordata->i2c_address) {
+			instancedata->instance_no = i;
+			found = true;
+			/* set the device name using the instance_no appended
+			to DEVICE_NAME to make a unique name */
+			dev_set_name(&client->dev,
+				"rmi4-i2c%d", instancedata->instance_no);
+
+			/* Determine if we need to poll (inefficient) or
+			use interrupts.
+			*/
+			if (sensordata->irq) {
+				instancedata->irq = sensordata->irq;
+				switch (sensordata->irq_type) {
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
+						"%s: Invalid IRQ flags in platform data.\n",
+						__func__);
+					kfree(instancedata);
+					return -ENXIO;
+				}
+
+				instancedata->rmiphysdrvr.polling_required = false;
+				instancedata->rmiphysdrvr.irq = instancedata->irq;
+
+			} else {
+				instancedata->rmiphysdrvr.polling_required = true;
+				dev_info(&client->dev,
+						"%s: No IRQ info given. Polling required.\n",
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
+	* to calling register_physical_driver since it may use the read, write
+	* functions. If nothing was found then the id fields will be set to 0
+	* for the irq and the default  will be set to polling required so we
+	* will still work but in polling mode. */
+	i2c_set_clientdata(client, instancedata);
+
+	/* Copy i2c_client pointer into instance_data's i2c_client pointer for
+	later use in rmi4_read, rmi4_write, etc. */
+	instancedata->i2cclient = client;
+
+	/* Register sensor drivers - this will call the detect function that
+	* will then scan the device and determine the supported RMI4 sensors
+	* and functions.
+	*/
+	retval = rmi_register_sensors(&instancedata->rmiphysdrvr);
+	if (retval) {
+		dev_err(&client->dev, "%s: Failed to Register %s sensor drivers\n",
+				__func__, instancedata->rmiphysdrvr.name);
+		i2c_set_clientdata(client, NULL);
+		kfree(instancedata);
+		return retval;
+	}
+
+	if (instancedata->rmiphysdrvr.polling_required == false) {
+		retval = request_irq(instancedata->irq, i2c_attn_isr,
+				irqtype, "rmi_i2c", instancedata);
+		if (retval) {
+			dev_err(&client->dev, "%s: failed to obtain IRQ %d. Result: %d.",
+				__func__, instancedata->irq, retval);
+			dev_info(&client->dev, "%s: Reverting to polling.\n", __func__);
+			instancedata->rmiphysdrvr.polling_required = true;
+			/* TODO: Need to revert back to polling - create and start timer, turn off interrupts for each fn */
+		} else {
+			dev_dbg(&client->dev, "%s: got irq.\n", __func__);
+		}
+	}
+
+	dev_dbg(&client->dev, "%s: Successfully registered %s sensor driver.\n",
+			__func__, instancedata->rmiphysdrvr.name);
+
+	printk(KERN_INFO "%s: Successfully registered %s sensor driver.\n", __func__, instancedata->rmiphysdrvr.name);
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
+	struct instance_data *instancedata =
+		i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "%s: Unregistering phys driver %s\n", __func__,
+		instancedata->rmiphysdrvr.name);
+
+	rmi_unregister_sensors(&instancedata->rmiphysdrvr);
+
+	dev_dbg(&client->dev, "%s: Unregistered phys driver %s\n",
+			__func__, instancedata->rmiphysdrvr.name);
+
+	/* only free irq if we have an irq - otherwise the instance_data
+	will be 0 for that field */
+	if (instancedata->irq)
+		free_irq(instancedata->irq, instancedata);
+
+	kfree(instancedata);
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
diff --git a/drivers/input/touchscreen/rmi_i2c.h b/drivers/input/touchscreen/rmi_i2c.h
old mode 100644
new mode 100755
index fecda60..cf79760
--- a/drivers/input/touchscreen/rmi_i2c.h
+++ b/drivers/input/touchscreen/rmi_i2c.h
@@ -1,7 +1,7 @@
 /**
  *
  * Synaptics RMI over I2C Physical Layer Driver Header File.
- * Copyright (c) 2007 - 2010, Synaptics Incorporated
+ * Copyright (c) 2007 - 2011, Synaptics Incorporated
  *
  */
 /*
@@ -25,27 +25,28 @@
 #ifndef _RMI_I2C_H
 #define _RMI_I2C_H
 
-/* Platform-specific configuration data.
- * This structure is used by the platform-specific driver to designate
- * specific information about the hardware.  A platform client may supply
- * an array of these to the rmi_phys_i2c driver.
+/* Sensor-specific configuration data.
+ * There is one of these for each RMI4 sensor on the I2C bus, describing
+ * its address, IRQ (if any), and the type of IRQ (if applicable).  An
+ * array of these gets included as part of the platformdata (see below).
  */
-struct rmi_i2c_platformdata {
-	/* The seven-bit i2c address of the device. */
+struct rmi_i2c_sensordata {
+	/* The seven-bit i2c address of the sensor. */
 	int i2c_address;
 	/* The number of the irq.  Set to zero if polling is required. */
 	int irq;
 	/* The type of the irq (e.g., IRQF_TRIGGER_FALLING).
-	   Only valid if irq != 0 */
+	Only valid if irq != 0 */
 	int irq_type;
 };
 
-/* Descriptor structure.
- * Describes the number of i2c devices on the bus that speak RMI.
+/* Platform-specific configuration data.
+ * Describes the number of i2c sensors on the bus that speak RMI, and
+ * some basic properties for each of those sensors.
  */
-struct rmi_i2c_data {
-	int num_clients;
-	struct rmi_i2c_platformdata *platformdata;
+struct rmi_i2c_platformdata {
+	int num_sensors;
+	struct rmi_i2c_sensordata *sensordata;
 };
 
 #endif
diff --git a/drivers/input/touchscreen/rmi_phys_i2c.c b/drivers/input/touchscreen/rmi_phys_i2c.c
deleted file mode 100644
index 397c717..0000000
--- a/drivers/input/touchscreen/rmi_phys_i2c.c
+++ /dev/null
@@ -1,577 +0,0 @@
-/**
- *
- * Synaptics Register Mapped Interface (RMI4) I2C Physical Layer Driver.
- * Copyright (c) 2007-2010, Synaptics Incorporated
- *
- */
-/*
- * This file is licensed under the GPL2 license.
- *
- *#############################################################################
- * GPL
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2 as published
- * by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
- * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
- * for more details.
- *
- *#############################################################################
- */
-
-#include <linux/module.h>
-#include <linux/i2c.h>
-#include <linux/platform_device.h>
-#include <linux/interrupt.h>
-#include <linux/delay.h>
-#include <linux/slab.h>
-#include "rmi_i2c.h"
-#include "rmi.h"
-
-
-#define DRIVER_NAME "rmi4_ts"
-
-#define DEVICE_NAME "rmi4_ts"
-
-/* Used to lock access to the page address.*/
-/* TODO: for multiple device support will need a per-device mutex */
-static DEFINE_MUTEX(page_mutex);
-
-
-static const struct i2c_device_id rmi_i2c_id_table[] = {
-	{ DEVICE_NAME, 0 },
-	{ },
-};
-MODULE_DEVICE_TABLE(i2c, rmi_i2c_id_table);
-
-
-/*
- * This is the data kept on a per instance (client) basis.  This data is
- * always accessible by using the container_of() macro of the various elements
- * inside.
- */
-struct instance_data {
-	int instance_no;
-	int irq;
-	struct rmi_phys_driver rpd;
-	struct i2c_client *i2cclient; /* pointer to i2c_client for later use in
-					 read, write, read_multiple, etc. */
-	int page;
-};
-
-/*
- * RMI devices have 16-bit addressing, but some of the physical
- * implementations (like SMBus) only have 8-bit addressing.  So RMI implements
- * a page address at 0xff of every page so we can reliable page addresses
- * every 256 registers.  This function sets the page.
- *
- * The page_mutex lock must be held when this function is entered.
- *
- * param[in] id - The pointer to the instance_data struct
- * param[in] page - The new page address.
- * returns zero on success, non-zero on failure.
- */
-int
-rmi_set_page(struct instance_data *id, unsigned int page)
-{
-	char txbuf[2];
-	int retval;
-	txbuf[0] = 0xff;
-	txbuf[1] = page;
-	retval = i2c_master_send(id->i2cclient, txbuf, 2);
-	if (retval != 2) {
-		dev_err(&id->i2cclient->dev,
-				"%s: Set page fail: %d\n", __func__, retval);
-	} else {
-		retval = 0;
-		id->page = page;
-	}
-	return retval;
-}
-
-/*
- * Read a single register through i2c.
- *
- * param[in] pd - The pointer to the rmi_phys_driver struct
- * param[in] address - The address at which to start the data read.
- * param[out] valp - Pointer to the buffer where the data will be stored.
- * returns xero upon success (with the byte read in valp), non-zero upon error.
- */
-static int
-rmi_i2c_read(struct rmi_phys_driver *pd, unsigned short address, char *valp)
-{
-	struct instance_data *id = container_of(pd, struct instance_data, rpd);
-	char txbuf[2];
-	int retval = 0;
-	int retry_count = 0;
-
-	/* Can't have anyone else changing the page behind our backs */
-	mutex_lock(&page_mutex);
-
-	if (((address >> 8) & 0xff) != id->page) {
-		/* Switch pages */
-		retval = rmi_set_page(id, ((address >> 8) & 0xff));
-		if (retval)
-			goto exit;
-	}
-
-retry:
-	txbuf[0] = address & 0xff;
-	retval = i2c_master_send(id->i2cclient, txbuf, 1);
-
-	if (retval != 1) {
-		dev_err(&id->i2cclient->dev, "%s: Write fail: %d\n",
-				__func__, retval);
-		goto exit;
-	}
-	retval = i2c_master_recv(id->i2cclient, txbuf, 1);
-
-	if (retval != 1) {
-		if (++retry_count == 5) {
-			dev_err(&id->i2cclient->dev,
-					"%s: Read of 0x%04x fail: %d\n",
-					__func__, address, retval);
-		} else {
-			mdelay(10);
-			rmi_set_page(id, ((address >> 8) & 0xff));
-			goto retry;
-		}
-	} else {
-		retval = 0;
-		*valp = txbuf[0];
-	}
-exit:
-	mutex_unlock(&page_mutex);
-	return retval;
-}
-
-/*
- * Same as rmi_i2c_read, except that multiple bytes are allowed to be read.
- *
- * param[in] pd - The pointer to the rmi_phys_driver struct
- * param[in] address - The address at which to start the data read.
- * param[out] valp - Pointer to the buffer where the data will be stored.  This
- *     buffer must be at least size bytes long.
- * param[in] size - The number of bytes to be read.
- * returns zero upon success (with the byte read in valp), non-zero upon error.
- *
- */
-static int
-rmi_i2c_read_multiple(struct rmi_phys_driver *pd, unsigned short address,
-	char *valp, int size)
-{
-	struct instance_data *id = container_of(pd, struct instance_data, rpd);
-	char txbuf[2];
-	int retval = 0;
-	int retry_count = 0;
-
-	/* Can't have anyone else changing the page behind our backs */
-	mutex_lock(&page_mutex);
-
-	if (((address >> 8) & 0xff) != id->page) {
-		/* Switch pages */
-		retval = rmi_set_page(id, ((address >> 8) & 0xff));
-		if (retval)
-			goto exit;
-	}
-
-retry:
-	txbuf[0] = address & 0xff;
-	retval = i2c_master_send(id->i2cclient, txbuf, 1);
-
-	if (retval != 1) {
-		dev_err(&id->i2cclient->dev, "%s: Write fail: %d\n",
-				__func__, retval);
-		goto exit;
-	}
-	retval = i2c_master_recv(id->i2cclient, valp, size);
-
-	if (retval != size) {
-		if (++retry_count == 5) {
-			dev_err(&id->i2cclient->dev,
-					"%s: Read of 0x%04x size %d fail: %d\n",
-					__func__, address, size, retval);
-		} else {
-			mdelay(10);
-			rmi_set_page(id, ((address >> 8) & 0xff));
-			goto retry;
-		}
-	} else {
-		retval = 0;
-	}
-exit:
-	mutex_unlock(&page_mutex);
-	return retval;
-}
-
-
-/*
- * Write a single register through i2c.
- * You can write multiple registers at once, but I made the functions for that
- * seperate for performance reasons.  Writing multiple requires allocation and
- * freeing.
- *
- * param[in] pd - The pointer to the rmi_phys_driver struct
- * param[in] address - The address at which to start the write.
- * param[in] data - The data to be written.
- * returns one upon success, something else upon error.
- */
-static int
-rmi_i2c_write(struct rmi_phys_driver *pd, unsigned short address, char data)
-{
-	struct instance_data *id = container_of(pd, struct instance_data, rpd);
-	unsigned char txbuf[2];
-	int retval = 0;
-
-	/* Can't have anyone else changing the page behind our backs */
-	mutex_lock(&page_mutex);
-
-	if (((address >> 8) & 0xff) != id->page) {
-		/* Switch pages */
-		retval = rmi_set_page(id, ((address >> 8) & 0xff));
-		if (retval)
-			goto exit;
-	}
-
-	txbuf[0] = address & 0xff;
-	txbuf[1] = data;
-	retval = i2c_master_send(id->i2cclient, txbuf, 2);
-
-	/* TODO: Add in retry on writes only in certian error return values */
-	if (retval != 2) {
-		dev_err(&id->i2cclient->dev, "%s: Write fail: %d\n",
-			__func__, retval);
-		goto exit; /* Leave this in case we add code below */
-	}
-exit:
-	mutex_unlock(&page_mutex);
-	return retval;
-}
-
-/*
- * Write multiple registers.
- *
- * For fast writes of 16 bytes of less we will re-use a buffer on the stack.
- * For larger writes (like for RMI reflashing) we will need to allocate a
- * temp buffer.
- *
- * param[in] pd - The pointer to the rmi_phys_driver struct
- * param[in] address - The address at which to start the write.
- * param[in] valp - A pointer to a buffer containing the data to be written.
- * param[in] size - The number of bytes to write.
- * returns one upon success, something else upon error.
- */
-static int
-rmi_i2c_write_multiple(struct rmi_phys_driver *pd, unsigned short address,
-	char *valp, int size)
-{
-	struct instance_data *id = container_of(pd, struct instance_data, rpd);
-	unsigned char *txbuf;
-	unsigned char txbuf_most[17]; /* Use this buffer for fast writes of 16
-					bytes or less.  The first byte will
-					contain the address at which to start
-					the write. */
-	int retval = 0;
-	int i;
-
-	if (size < sizeof(txbuf_most)) {
-		/* Avoid an allocation if we can help it. */
-		txbuf = txbuf_most;
-	} else {
-		/* over 16 bytes write we'll need to allocate a temp buffer */
-		txbuf = kmalloc(size + 1, GFP_KERNEL);
-		if (!txbuf)
-			return -ENOMEM;
-	}
-
-	/* Yes, it stinks here that we have to copy the buffer */
-	/* We copy from valp to txbuf leaving
-	the first location open for the address */
-	for (i = 0; i < size; i++)
-		txbuf[i + 1] = valp[i];
-
-	/* Can't have anyone else changing the page behind our backs */
-	mutex_lock(&page_mutex);
-
-	if (((address >> 8) & 0xff) != id->page) {
-		/* Switch pages */
-		retval = rmi_set_page(id, ((address >> 8) & 0xff));
-		if (retval)
-			goto exit;
-	}
-
-	txbuf[0] = address & 0xff; /* put the address in the first byte */
-	retval = i2c_master_send(id->i2cclient, txbuf, size + 1);
-
-	/* TODO: Add in retyr on writes only in certian error return values */
-	if (retval != 1) {
-		dev_err(&id->i2cclient->dev, "%s: Write fail: %d\n",
-				__func__, retval);
-		goto exit;
-	}
-exit:
-	mutex_unlock(&page_mutex);
-	if (txbuf != txbuf_most)
-		kfree(txbuf);
-	return retval;
-}
-
-/*
- * This is the Interrupt Service Routine.  It just notifies the application
- * layer that attention is required.
- */
-static irqreturn_t
-i2c_attn_isr(int irq, void *info)
-{
-	struct instance_data *id = info;
-	disable_irq(id->irq);
-	if (id->rpd.attention)
-		id->rpd.attention(&id->rpd, id->instance_no);
-	return IRQ_HANDLED;
-}
-
-/* The Driver probe function - will allocate and initialize the instance
-   data and request the irq and set the instance data as the clients
-   platform data then register the physical driver which will do a scan of
-   the RMI4 Physical Device Table and enumerate any RMI4 functions that
-   have data sources associated with them.
- */
-static int
-rmi_i2c_probe(struct i2c_client *client, const struct i2c_device_id *dev_id)
-{
-	struct instance_data *id;
-	int retval = 0;
-	int i;
-	bool found = false;
-
-	struct rmi_i2c_data *rmii2cdata;
-	struct rmi_i2c_platformdata *platformdata;
-
-	dev_dbg(&client->dev, "Probing i2c RMI device\n");
-
-	/* Allocate and initialize the instance data for this client */
-	id = kzalloc(sizeof(*id), GFP_KERNEL);
-	if (!id) {
-		dev_err(&client->dev,
-			"%s: Out of memory trying to allocate instance_data.\n",
-			__func__);
-		return -ENOMEM;
-	}
-
-	id->rpd.name           = DRIVER_NAME;
-	id->rpd.write          = rmi_i2c_write;
-	id->rpd.read           = rmi_i2c_read;
-	id->rpd.write_multiple = rmi_i2c_write_multiple;
-	id->rpd.read_multiple  = rmi_i2c_read_multiple;
-	id->rpd.module         = THIS_MODULE;
-	id->rpd.polling_required = true; /* Set default to polling in case no
-					    matching platform data is located
-					    for this device. We'll still work
-					    but in polling mode since we didn't
-					    find any irq info */
-
-	id->page               = 0xffff; /* So we set the page correctly
-					    the first time */
-
-	/* cast to our struct rmi_i2c_data so we know
-	the fields (see rmi_ic2.h) */
-	rmii2cdata = client->dev.platform_data;
-
-	/* Loop through the platform data and locate the one that matches
-	the i2c_client I2C address */
-	for (i = 0; i < rmii2cdata->num_clients; i++) {
-		platformdata = &(rmii2cdata->platformdata[i]);
-		if (client->addr == platformdata->i2c_address) {
-			id->instance_no = i;
-			found = true;
-			/* set the device name using the instance_no appended
-			to DEVICE_NAME to make a unique name */
-			dev_set_name(&client->dev,
-				"rmi4-i2c%d", id->instance_no);
-
-			/* Determine if we need to poll (inefficient) or
-			use interrupts.
-			*/
-			if (platformdata->irq) {
-				int irqtype;
-
-				id->irq = platformdata->irq;
-				switch (platformdata->irq_type) {
-				case IORESOURCE_IRQ_HIGHEDGE:
-					irqtype = IRQF_TRIGGER_RISING;
-					break;
-				case IORESOURCE_IRQ_LOWEDGE:
-					irqtype = IRQF_TRIGGER_FALLING;
-					break;
-				case IORESOURCE_IRQ_HIGHLEVEL:
-					irqtype = IRQF_TRIGGER_HIGH;
-					break;
-				case IORESOURCE_IRQ_LOWLEVEL:
-					irqtype = IRQF_TRIGGER_LOW;
-					break;
-				default:
-					dev_warn(&client->dev,
-						"%s: Invalid IRQ flags in "
-						"platform data.\n",
-						__func__);
-					kfree(id);
-					return -ENXIO;
-				}
-
-				retval = request_irq(id->irq, i2c_attn_isr,
-					irqtype, "rmi_i2c", id);
-				if (retval) {
-					dev_info(&client->dev,
-						"%s: Unable to get attn irq %d."
-						" Reverting to polling.\n",
-						__func__, id->irq);
-					id->rpd.polling_required = true;
-				} else {
-					dev_dbg(&client->dev,
-						"rmi_i2c_probe: got irq.\n");
-					id->rpd.polling_required = false;
-					id->rpd.irq = id->irq;
-				}
-			} else {
-				id->rpd.polling_required = true;
-				dev_info(&client->dev,
-						"%s: No IRQ info given. "
-						"Polling required.\n",
-						__func__);
-			}
-		}
-	}
-
-	/* if went through all the platform data list and didn't find a match
-	then notify that we are defaulting to polling */
-	if (!found) {
-		dev_info(&client->dev,
-			"%s: No platform data match found. "
-			"Defaulting to use polling.\n",
-			__func__);
-	}
-
-	/* Store the instance data in the i2c_client - we need to do this prior
-	 * to calling register_physical_driver since it may use the read, write
-	 * functions. If nothing was found then the id fields will be set to 0
-	 * for the irq and the default  will be set to polling required so we
-	 * will still work but in polling mode. */
-	i2c_set_clientdata(client, id);
-
-	/* Copy i2c_client pointer into instance_data's i2c_client pointer for
-	later use in rmi4_read, rmi4_write, etc. */
-	id->i2cclient = client;
-
-	/* Register physical driver - this will call the detect function that
-	 will then scan the device and determine the supported RMI4 functions.
-	 */
-	retval = rmi_register_phys_driver(&id->rpd);
-	if (retval) {
-		dev_err(&client->dev, "%s: Failed to Register %s phys driver\n",
-				__func__, id->rpd.name);
-		i2c_set_clientdata(client, NULL);
-		/* only free irq if we have an irq - otherwise the instance_data
-		will be 0 for that field since kzalloc was used to alloc id */
-		if (id->irq)
-			free_irq(id->irq, id);
-		kfree(id);
-		return retval;
-	}
-
-	dev_dbg(&client->dev, "%s: Successfully Registered %s phys driver\n",
-			__func__, id->rpd.name);
-
-	return retval;
-}
-
-/* The Driver remove function.  We tear down the instance data and unregister
- * the phys driver in this call.
- */
-static int
-rmi_i2c_remove(struct i2c_client *client)
-{
-	struct instance_data *id = i2c_get_clientdata(client);
-
-	dev_dbg(&client->dev, "%s: Unregistering phys driver %s\n", __func__, id->rpd.name);
-
-	rmi_unregister_phys_driver(&id->rpd);
-
-	dev_dbg(&client->dev, "%s: Unregistered phys driver %s\n",
-			__func__, id->rpd.name);
-
-	/* only free irq if we have an irq - otherwise the instance_data
-	will be 0 for that field */
-	if (id->irq)
-		free_irq(id->irq, id);
-
-	kfree(id);
-	dev_dbg(&client->dev, "%s: Remove successful\n", __func__);
-
-	return 0;
-}
-
-#ifdef CONFIG_PM
-static int
-rmi_i2c_suspend(struct i2c_client *client, pm_message_t mesg)
-{
-	/* Touch sleep mode */
-	return 0;
-}
-
-static int
-rmi_i2c_resume(struct i2c_client *client)
-{
-	/* Re-initialize upon resume */
-	return 0;
-}
-#else
-#define rmi_i2c_suspend	NULL
-#define rmi_i2c_resume	NULL
-#endif
-
-/*
- * This structure tells the i2c subsystem about us.
- *
- * TODO: we should add .suspend and .resume fns.
- *
- */
-static struct i2c_driver rmi_i2c_driver = {
-	.probe		= rmi_i2c_probe,
-	.remove		= rmi_i2c_remove,
-	.suspend	= rmi_i2c_suspend,
-	.resume		= rmi_i2c_resume,
-	.driver = {
-		.name  = DRIVER_NAME,
-		.owner = THIS_MODULE,
-	},
-	.id_table	= rmi_i2c_id_table,
-};
-
-/*
- * Register ourselves with i2c Chip Driver.
- *
- */
-static int __init rmi_phys_i2c_init(void)
-{
-	return i2c_add_driver(&rmi_i2c_driver);
-}
-
-/*
- * Un-register ourselves from the i2c Chip Driver.
- *
- */
-static void __exit rmi_phys_i2c_exit(void)
-{
-	i2c_del_driver(&rmi_i2c_driver);
-}
-
-
-module_init(rmi_phys_i2c_init);
-module_exit(rmi_phys_i2c_exit);
-
-MODULE_AUTHOR("Synaptics, Inc.");
-MODULE_DESCRIPTION("RMI4 Driver I2C Physical Layer");
-MODULE_LICENSE("GPL");
diff --git a/drivers/input/touchscreen/rmi_sensor.c b/drivers/input/touchscreen/rmi_sensor.c
new file mode 100755
index 0000000..8b0dc35
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_sensor.c
@@ -0,0 +1,588 @@
+/**
+ * Synaptics Register Mapped Interface (RMI4) - RMI Sensor Module.
+ * Copyright (C) 2007 - 2011, Synaptics Incorporated
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
+static const char sensorname[] = "sensor";
+
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/device.h>
+#include <linux/hrtimer.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include <linux/delay.h>
+#include <linux/uaccess.h>
+#include <linux/slab.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+
+
+#include "rmi_drvr.h"
+#include "rmi_bus.h"
+#include "rmi_function.h"
+#include "rmi_sensor.h"
+
+long polltime = 25000000;   /* Shared with rmi_function.c. */
+EXPORT_SYMBOL(polltime);
+module_param(polltime, long, 0644);
+MODULE_PARM_DESC(polltime, "How long to wait between polls (in nano seconds).");
+
+
+#define PDT_START_SCAN_LOCATION 0x00E9
+#define PDT_END_SCAN_LOCATION 0x0005
+#define PDT_ENTRY_SIZE 0x0006
+
+static DEFINE_MUTEX(rfi_mutex);
+
+struct rmi_functions *rmi_find_function(int functionNum);
+
+int rmi_read(struct rmi_sensor_driver *sensor, unsigned short address, char *dest)
+{
+	struct rmi_phys_driver *rpd = sensor->rpd;
+	if (!rpd)
+		return -ENODEV;
+	return rpd->read(rpd, address, dest);
+}
+EXPORT_SYMBOL(rmi_read);
+
+int rmi_write(struct rmi_sensor_driver *sensor, unsigned short address,
+		unsigned char data)
+{
+	struct rmi_phys_driver *rpd = sensor->rpd;
+	if (!rpd)
+		return -ENODEV;
+	return rpd->write(rpd, address, data);
+}
+EXPORT_SYMBOL(rmi_write);
+
+int rmi_read_multiple(struct rmi_sensor_driver *sensor, unsigned short address,
+		char *dest, int length)
+{
+	struct rmi_phys_driver *rpd = sensor->rpd;
+	if (!rpd)
+		return -ENODEV;
+	return rpd->read_multiple(rpd, address, dest, length);
+}
+EXPORT_SYMBOL(rmi_read_multiple);
+
+int rmi_write_multiple(struct rmi_sensor_driver *sensor, unsigned short address,
+		unsigned char *data, int length)
+{
+	struct rmi_phys_driver *rpd = sensor->rpd;
+	if (!rpd)
+		return -ENODEV;
+	return rpd->write_multiple(rpd, address, data, length);
+}
+EXPORT_SYMBOL(rmi_write_multiple);
+
+bool rmi_polling_required(struct rmi_sensor_driver *sensor)
+{
+	return sensor->polling_required;
+}
+EXPORT_SYMBOL(rmi_polling_required);
+
+/** Functions can call this in order to dispatch IRQs. */
+void dispatchIRQs(struct rmi_sensor_driver *sensor, unsigned int irqStatus)
+{
+	struct rmi_function_info *functionInfo;
+
+
+	list_for_each_entry(functionInfo, &sensor->functions, link) {
+		if ((functionInfo->interruptMask & irqStatus)) {
+			if (functionInfo->function_device->rmi_funcs->inthandler) {
+				/* Call the functions interrupt handler function. */
+				functionInfo->function_device->rmi_funcs->inthandler(functionInfo, (functionInfo->interruptMask & irqStatus));
+			}
+		}
+	}
+}
+
+/**
+ * This is the function we pass to the RMI4 subsystem so we can be notified
+ * when attention is required.  It may be called in interrupt context.
+ */
+static void attention(struct rmi_phys_driver *physdrvr, int instance)
+{
+	/* All we have to do is schedule work. */
+
+	/* TODO: It's possible that workIsReady is not really needed anymore.
+	 * Investigate this to see if the race condition between setting up
+	 * the work and enabling the interrupt still exists. */
+	if (physdrvr->sensor->workIsReady) {
+		schedule_work(&(physdrvr->sensor->work));
+	} else {
+		/* Got an interrupt but we're not ready so enable the irq so it doesn't get hung up */
+		printk(KERN_DEBUG "%s: Work not initialized yet - enabling irqs.\n", __func__);
+		enable_irq(physdrvr->irq);
+	}
+}
+
+/**
+ * This notifies any interested functions that there
+ * is an Attention interrupt.  The interested functions should take appropriate
+ * actions (such as reading the interrupt status register and dispatching any
+ * appropriate RMI4 interreupts).
+ */
+void attn_notify(struct rmi_sensor_driver *sensor)
+{
+	struct rmi_function_info *functionInfo;
+
+	/* check each function that has data sources and if the interrupt for
+	* that triggered then call that RMI4 functions report() function to
+	* gather data and report it to the input subsystem */
+	list_for_each_entry(functionInfo, &sensor->functions, link) {
+		if (functionInfo->function_device->rmi_funcs->attention)
+			functionInfo->function_device->rmi_funcs->attention(functionInfo);
+	}
+}
+
+/* This is the worker function - for now it simply has to call attn_notify. This work
+ * should be scheduled whenever an ATTN interrupt is asserted by the touch sensor.
+ * We then call attn_notify to dispatch notification of the ATTN interrupt to all
+ * interested functions. After all the attention handling functions
+ * have returned, it is presumed safe to re-enable the Attention interrupt.
+ */
+static void sensor_work_func(struct work_struct *work)
+{
+	struct rmi_sensor_driver *sensor = container_of(work,
+			struct rmi_sensor_driver, work);
+
+	attn_notify(sensor);
+
+	/* we only need to enable the irq if doing interrupts */
+	if (!rmi_polling_required(sensor))
+		enable_irq(sensor->rpd->irq);
+}
+
+/* This is the timer function for polling - it simply has to schedule work
+ * and restart the timer. */
+static enum hrtimer_restart sensor_poll_timer_func(struct hrtimer *timer)
+{
+	struct rmi_sensor_driver *sensor = container_of(timer,
+			struct rmi_sensor_driver, timer);
+
+	schedule_work(&sensor->work);
+	hrtimer_start(&sensor->timer, ktime_set(0, polltime), HRTIMER_MODE_REL);
+	return HRTIMER_NORESTART;
+}
+
+/* This is the probe function passed to the RMI4 subsystem that gives us a
+ * chance to recognize an RMI4 device.  In this case, we're looking for
+ * Synaptics devices that have data sources - such as touch screens, buttons,
+ * etc.
+ *
+ * TODO: Well, it used to do this.  I'm not sure it's required any more.
+ */
+static int probe(struct rmi_sensor_driver *sensor)
+{
+	struct rmi_phys_driver *rpd;
+
+	rpd = sensor->rpd;
+
+	if (!rpd) {
+		printk(KERN_ERR "%s: Invalid rmi physical driver - null ptr: %p\n", __func__, rpd);
+		return 0;
+	}
+
+	return 1;
+}
+
+static void config(struct rmi_sensor_driver *sensor)
+{
+	/* For each data source we had detected print info and set up interrupts
+	or polling. */
+	struct rmi_function_info *functionInfo;
+	struct rmi_phys_driver *rpd;
+
+	rpd = sensor->rpd; /* get ptr to rmi_physical_driver from app */
+
+	list_for_each_entry(functionInfo, &sensor->functions, link) {
+		/* Get and print some info about the data sources... */
+		struct rmi_functions *fn;
+		bool found = false;
+		/* check if function number matches - if so call that
+		config function */
+		fn = rmi_find_function(functionInfo->functionNum);
+		if (fn) {
+			found = true;
+
+			if (fn->config) {
+				fn->config(functionInfo);
+			} else {
+				/* the developer did not add in the
+				pointer to the config function into
+				rmi4_supported_data_src_functions */
+				printk(KERN_ERR
+					"%s: no config function for "
+					"function 0x%x\n",
+					__func__, functionInfo->functionNum);
+				break;
+			}
+		}
+
+		if (!found) {
+			/* if no support found for this RMI4 function
+			it means the developer did not add the
+			appropriate function pointer list into the
+			rmi4_supported_data_src_functions array and/or
+			did not bump up the number of supported RMI4
+			functions in rmi.h as required */
+			printk(KERN_ERR "%s: could not find support "
+				"for function 0x%x\n",
+				__func__, functionInfo->functionNum);
+		}
+	}
+
+	/* This will handle interrupts on the ATTN line (interrupt driven)
+	* or will be called every poll interval (when we're not interrupt
+	* driven).
+	*/
+	INIT_WORK(&sensor->work, sensor_work_func);
+	sensor->workIsReady = true;
+
+	if (rmi_polling_required(sensor)) {
+		/* We're polling driven, so set up the polling timer
+		and timer function. */
+		printk(KERN_INFO "%s: Setting up polling.", __func__);
+		hrtimer_init(&sensor->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		sensor->timer.function = sensor_poll_timer_func;
+		hrtimer_start(&sensor->timer, ktime_set(1, 0), HRTIMER_MODE_REL);
+	}
+}
+
+/** Just a stub for now.
+ */
+static int rmi_sensor_suspend(struct device *dev, pm_message_t state)
+{
+	printk(KERN_INFO "%s: sensor suspend called.", __func__);
+	return 0;
+}
+
+/** Just a stub for now.
+ */
+static int rmi_sensor_resume(struct device *dev)
+{
+	printk(KERN_INFO "%s: sensor resume called.", __func__);
+	return 0;
+}
+
+/*
+ * This method is called, whenever a new sensor device is added for the rmi
+ * bus.
+ *
+ * It will scan the devices PDT to determine the supported functions
+ * and create a new function device for each of these. It will read
+ * the query, control, command and data regsiters for the function
+ * to be used for each newly created function device.
+ *
+ * The sensor device is then bound to every function it supports.
+ *
+ */
+int rmi_sensor_register_functions(struct rmi_sensor_driver *sensor)
+{
+	struct rmi_function_device *function;
+	unsigned int interruptRegisterCount;
+	struct rmi_phys_driver *rpd;
+	int i;
+	unsigned char interruptCount;
+	struct rmi_function_info *functionInfo;
+	struct rmi_function_descriptor rmi_fd;
+	struct rmi_functions *fn;
+	bool found;
+	int retval;
+
+	pr_debug("%s: Registering sensor functions\n", __func__);
+
+	retval = 0;
+
+	/* Scan device for functions that may be supported */
+	{
+		pr_debug("%s: Scanning sensor for Functions:\n", __func__);
+
+		interruptCount = 0;
+		rpd = sensor->rpd;
+
+		/* Read the Page Descriptor Table to determine what functions
+		are present */
+		printk(KERN_DEBUG "%s: Scanning page descriptors.", __func__);
+		for (i = PDT_START_SCAN_LOCATION;
+				i >= PDT_END_SCAN_LOCATION;
+				i -= PDT_ENTRY_SIZE) {
+			printk(KERN_DEBUG "%s: Reading page descriptor 0x%02x", __func__, i);
+			retval = rpd->read_multiple(rpd, i, (char *)&rmi_fd,
+					sizeof(rmi_fd));
+			if (!retval) {
+				functionInfo = NULL;
+
+				if (rmi_fd.functionNum != 0x00 && rmi_fd.functionNum != 0xff) {
+					printk(KERN_DEBUG "%s: F%02x - queries %02x commands %02x control %02x data %02x ints %02x", __func__, rmi_fd.functionNum, rmi_fd.queryBaseAddr, rmi_fd.commandBaseAddr, rmi_fd.controlBaseAddr, rmi_fd.dataBaseAddr, rmi_fd.interruptSrcCnt);
+
+					/* Print a helpful message for debugging. */
+					if ((rmi_fd.functionNum & 0xff) == 0x01)
+						printk(KERN_DEBUG "%s:   Fn $01 Found - RMI Device Control\n", __func__);
+
+					/* determine if the function is supported and if so
+					then bind this function device to the sensor */
+					if (rmi_fd.interruptSrcCnt) {
+						functionInfo = kzalloc(sizeof(*functionInfo), GFP_KERNEL);
+						if (!functionInfo) {
+							printk(KERN_ERR "%s: could not allocate memory for function 0x%x\n",
+								__func__, rmi_fd.functionNum);
+							retval = -ENOMEM;
+							goto exit_fail;
+						}
+						functionInfo->sensor = sensor;
+						functionInfo->functionNum = (rmi_fd.functionNum & 0xff);
+						INIT_LIST_HEAD(&functionInfo->link);
+						/* Get the ptr to the detect function based on
+						the function number */
+						found = false;
+						printk(KERN_DEBUG "%s: Checking for RMI function F%02x.", __func__, rmi_fd.functionNum);
+						fn = rmi_find_function(rmi_fd.functionNum);
+						if (fn) {
+							found = true;
+							retval = fn->detect(functionInfo, &rmi_fd,
+								interruptCount);
+							if (retval)
+								printk(KERN_ERR "%s: Function detect for F%02x failed with %d.",
+									   __func__, rmi_fd.functionNum, retval);
+
+							/* Create a function device and function driver for this Fn */
+							function = kzalloc(sizeof(*function), GFP_KERNEL);
+							if (!function) {
+								printk(KERN_ERR "%s: Error allocating memeory for rmi_function_device\n", __func__);
+								return -ENOMEM;
+							}
+
+							function->dev.parent = &sensor->sensor_device->dev;
+							function->dev.bus = sensor->sensor_device->dev.bus;
+							function->rmi_funcs = fn;
+							function->sensor = sensor;
+							function->rfi = functionInfo;
+							functionInfo->function_device = function;
+
+							/* Check if we have an interrupt mask of 0 and a non-NULL interrupt
+							handler function and print a debug message since we should never
+							have this.
+							*/
+							if (functionInfo->interruptMask == 0 && fn->inthandler != NULL) {
+								printk(KERN_DEBUG "%s: Can't have a zero interrupt mask for function F%02x (which requires an interrupt handler).\n",
+									__func__, rmi_fd.functionNum);
+							}
+
+
+							/* Check if we have a non-zero interrupt mask and a NULL interrupt
+							handler function and print a debug message since we should never
+							have this.
+							*/
+							if (functionInfo->interruptMask != 0 && fn->inthandler == NULL) {
+								printk(KERN_DEBUG "%s: Can't have a non-zero interrupt mask %d for function F%02x with a NULL inthandler fn.\n",
+									__func__, functionInfo->interruptMask, rmi_fd.functionNum);
+							}
+
+							/* Register the rmi function device */
+							retval = rmi_function_register_device(function, rmi_fd.functionNum);
+							if (retval) {
+								printk(KERN_ERR "%s:  Failed rmi_function_register_device.\n",
+									__func__);
+								return retval;
+							}
+						}
+
+						if (!found) {
+							printk(KERN_ERR "%s: could not find support for function 0x%x\n",
+								__func__, rmi_fd.functionNum);
+						}
+					} else {
+						printk(KERN_INFO "%s: Found function F%02x - Ignored.\n", __func__, rmi_fd.functionNum & 0xff);
+					}
+
+					/* bump interrupt count for next iteration */
+					/* NOTE: The value 7 is reserved - for now, only bump up one for an interrupt count of 7 */
+					if ((rmi_fd.interruptSrcCnt & 0x7) == 0x7) {
+						interruptCount += 1;
+					} else {
+						interruptCount +=
+							(rmi_fd.interruptSrcCnt & 0x7);
+					}
+
+					/* link this function info to the RMI module infos list
+					of functions */
+					if (functionInfo == NULL) {
+						printk(KERN_DEBUG "%s: WTF? functionInfo is null here.", __func__);
+					} else {
+						printk(KERN_DEBUG "%s: Adding function F%02x with %d sources.\n",
+							__func__, functionInfo->functionNum, functionInfo->numSources);
+
+						mutex_lock(&rfi_mutex);
+						list_add_tail(&functionInfo->link,
+							&sensor->functions);
+						mutex_unlock(&rfi_mutex);
+					}
+
+				} else {
+					/* A zero or 0xff in the function number
+					signals the end of the PDT */
+					printk(KERN_DEBUG "%s:   Found End of PDT\n",
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
+				printk(KERN_ERR "%s: Read Error %d when reading next PDT entry - "
+					"ending PDT scan.\n",
+					__func__, retval);
+				break;
+			}
+		}
+		printk(KERN_DEBUG "%s: Done scanning.", __func__);
+
+		/* calculate the interrupt register count - used in the
+		ISR to read the correct number of interrupt registers */
+		interruptRegisterCount = (interruptCount + 7) / 8;
+		sensor->interruptRegisterCount = interruptRegisterCount;    /* TODO: Is this needed by the sensor anymore? */
+	}
+
+	return 0;
+
+exit_fail:
+	return retval;
+}
+EXPORT_SYMBOL(rmi_sensor_register_functions);
+
+int rmi_sensor_register_device(struct rmi_sensor_device *dev, int index)
+{
+	int status;
+
+	printk(KERN_INFO "%s: Registering sensor device.\n", __func__);
+
+	/* make name - sensor00, sensor01, etc. */
+	dev_set_name(&dev->dev, "sensor%02d", index);
+	status = device_register(&dev->dev);
+
+	return status;
+}
+EXPORT_SYMBOL(rmi_sensor_register_device);
+
+static void rmi_sensor_unregister_device(struct rmi_sensor_device *rmisensordev)
+{
+	printk(KERN_INFO "%s: Unregistering sensor device.\n", __func__);
+
+	device_unregister(&rmisensordev->dev);
+}
+EXPORT_SYMBOL(rmi_sensor_unregister_device);
+
+int rmi_sensor_register_driver(struct rmi_sensor_driver *driver)
+{
+	static int index;
+	int ret;
+	char *drvrname;
+
+	driver->workIsReady = false;
+
+	printk(KERN_INFO "%s: Registering sensor driver.\n", __func__);
+	driver->dispatchIRQs = dispatchIRQs;
+	driver->attention = attention;
+	driver->config = config;
+	driver->probe = probe;
+
+	/* assign the bus type for this driver to be rmi bus */
+	driver->drv.bus = &rmi_bus_type;
+	driver->drv.suspend = rmi_sensor_suspend;
+	driver->drv.resume = rmi_sensor_resume;
+	/* Create a function device and function driver for this Fn */
+	drvrname = kzalloc(sizeof(sensorname) + 4, GFP_KERNEL);
+	if (!drvrname) {
+		printk(KERN_ERR "%s: Error allocating memeory for rmi_sensor_driver name.\n", __func__);
+		return -ENOMEM;
+	}
+	sprintf(drvrname, "sensor%02d", index++);
+
+	driver->drv.name = drvrname;
+	driver->module = driver->drv.owner;
+
+	/* register the sensor driver */
+	ret = driver_register(&driver->drv);
+	if (ret) {
+		printk(KERN_ERR "%s: Failed driver_register %d\n",
+			__func__, ret);
+		goto exit_fail;
+	}
+
+	/* register the functions on the sensor */
+	ret = rmi_sensor_register_functions(driver);
+	if (ret) {
+		printk(KERN_ERR "%s: Failed rmi_sensor_register_functions %d\n",
+			__func__, ret);
+	}
+
+	/* configure the sensor - enable interrupts for each function, init work, set polling timer or adjust report rate, etc. */
+	config(driver);
+
+	printk(KERN_INFO "%s: sensor driver registration completed.", __func__);
+
+exit_fail:
+	return ret;
+}
+EXPORT_SYMBOL(rmi_sensor_register_driver);
+
+static void rmi_sensor_unregister_driver(struct rmi_sensor_driver *driver)
+{
+	printk(KERN_INFO "%s: Unregistering sensor driver.\n", __func__);
+
+	/* Stop the polling timer if doing polling */
+	if (rmi_polling_required(driver))
+		hrtimer_cancel(&driver->timer);
+
+	flush_scheduled_work(); /* Make sure all scheduled work is stopped */
+
+	driver_unregister(&driver->drv);
+}
+EXPORT_SYMBOL(rmi_sensor_unregister_driver);
+
+
+static int __init rmi_sensor_init(void)
+{
+	printk(KERN_INFO "%s: RMI Sensor Init\n", __func__);
+	return 0;
+}
+
+static void __exit rmi_sensor_exit(void)
+{
+	printk(KERN_INFO "%s: RMI Sensor Driver Exit\n", __func__);
+	flush_scheduled_work(); /* Make sure all scheduled work is stopped */
+}
+
+
+module_init(rmi_sensor_init);
+module_exit(rmi_sensor_exit);
+
+MODULE_AUTHOR("Synaptics, Inc.");
+MODULE_DESCRIPTION("RMI4 Sensor Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/input/touchscreen/rmi_sensor.h b/drivers/input/touchscreen/rmi_sensor.h
new file mode 100755
index 0000000..280dcc3
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_sensor.h
@@ -0,0 +1,123 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) - RMI Sensor Module Header.
+ * Copyright (C) 2007 - 2011, Synaptics Incorporated
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
+#include <linux/device.h>
+
+#ifndef _RMI_SENSOR_H
+#define _RMI_SENSOR_H
+
+struct rmi_sensor_driver {
+	struct module *module;
+	struct device_driver drv;
+	struct rmi_sensor_device *sensor_device;
+
+	/* Attention Function
+	*  This function is called by the low level isr in the physical
+	* driver. It merely schedules work to be done.
+	*/
+	void (*attention)(struct rmi_phys_driver *physdrvr, int instance);
+	/* Probe Function
+	*  This function is called to give the sensor driver layer an
+	*  opportunity to claim an RMI device.  The sensor layer cannot
+	*  read RMI registers at this point since the rmi physical driver
+	*  has not been bound to it yet.  Defer that to the config
+	*  function call which occurs immediately after a successful probe.
+	*/
+	int (*probe)(struct rmi_sensor_driver *sensor);
+	/* Config Function
+	*  This function is called after a successful probe.  It gives the
+	*  sensor driver an opportunity to query and/or configure an RMI
+	*  device before data starts flowing.
+	*/
+	void (*config)(struct rmi_sensor_driver *sensor);
+
+	/** Functions can call this in order to dispatch IRQs. */
+	void (*dispatchIRQs)(struct rmi_sensor_driver *sensor,
+		unsigned int irqStatus);
+
+	/* Register Functions
+	*  This function is called in the rmi bus
+	* driver to have the sensor driver scan for any supported
+	* functions on the sensor and add devices for each one.
+	*/
+	void (*rmi_sensor_register_functions)(struct rmi_sensor_driver *sensor);
+
+	unsigned int interruptRegisterCount;
+
+	bool polling_required;
+
+	/* pointer to the corresponding phys driver info for this sensor */
+	/* The phys driver has the pointers to read, write, etc. */
+	struct rmi_phys_driver *rpd;
+
+	struct hrtimer timer;
+	struct work_struct work;
+	bool workIsReady;
+
+	/* This list is for keeping around the list of sensors.
+	*  Every time that a physical device is detected by the
+	*  physical layer - be it i2c, spi, or some other - then
+	*  we need to bind the physical layer to the device. When
+	*  the Page Descriptor Table is scanned and when Function $01
+	*  is found then a new sensor device is created. The corresponding
+	*  rmi_phys_driver struct pointer needs to be bound to the new
+	*  sensor since Function $01 will be used to control and get
+	*  interrupt information about the particular data source that is
+	*  doing the interrupt. The rmi_phys_driver contains the pointers
+	*  to the particular read, write, read_multiple, write_multiple
+	*  functions for this device. This rmi_phys_driver struct will
+	*  have to be up-bound to any drivers upstream that need it.
+	*/
+
+	/* Standard kernel linked list implementation.
+	*  Documentation on how to use it can be found at
+	*  http://isis.poly.edu/kulesh/stuff/src/klist/.
+	*/
+	struct list_head sensor_drivers; /* link sensor drivers into list */
+
+	struct list_head functions;     /* List of rmi_function_infos */
+};
+
+/* macro to get the pointer to the device_driver struct from the sensor */
+#define to_rmi_sensor_driver(drv) container_of(drv, struct rmi_sensor_driver, drv);
+
+struct rmi_sensor_device {
+	struct rmi_sensor_driver *driver;
+	struct device dev;
+
+	/* Standard kernel linked list implementation.
+	*  Documentation on how to use it can be found at
+	*  http://isis.poly.edu/kulesh/stuff/src/klist/.
+	*/
+	struct list_head sensors; /* link sensors into list */
+};
+
+int rmi_sensor_register_device(struct rmi_sensor_device *dev, int index);
+int rmi_sensor_register_driver(struct rmi_sensor_driver *driver);
+int rmi_sensor_register_functions(struct rmi_sensor_driver *sensor);
+bool rmi_polling_required(struct rmi_sensor_driver *sensor);
+
+#endif
+
diff --git a/drivers/input/touchscreen/rmi_spi.c b/drivers/input/touchscreen/rmi_spi.c
new file mode 100755
index 0000000..82d0914
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_spi.c
@@ -0,0 +1,477 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) SPI Physical Layer Driver.
+ * Copyright (C) 2008-2011, Synaptics Incorporated
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
+#include <linux/interrupt.h>
+#include <linux/spi/spi.h>
+#include <linux/platform_device.h>
+#include <linux/semaphore.h>
+#include "rmi_spi.h"
+#include "rmi_drvr.h"
+
+#define DRIVER_NAME "rmi4_ts"
+#define DEVICE_NAME "rmi4_ts"
+
+#define RMI_TDPB	65 /* 65 microseconds inter-byte delay between bytes for RMI chip*/
+#define	SPI_BUFSIZ	32
+
+static u8 *buf;
+
+/** This is a count of how many clients are accessing this driver.
+ */
+static int num_clients;
+static struct rmi_spi_platformdata *platformdata;
+
+
+/**
+ * This is the data kept on a per instance (client) basis.  This data is
+ * always accessible by using the container_of() macro of the various elements
+ * inside.
+ */
+struct instance_data {
+	int instance_no;
+	int irq;
+	struct rmi_phys_driver rpd;
+	struct spi_device *spidev;
+};
+
+
+static int spi_xfer(struct spi_device *spi,
+		const u8 *txbuf, unsigned n_tx,
+		u8 *rxbuf, unsigned n_rx)
+{
+	static DECLARE_MUTEX(lock);
+
+	int			status;
+	struct spi_message	message;
+	struct spi_transfer	x[2];
+	u8			*local_buf;
+
+
+	if ((n_tx + n_rx) > SPI_BUFSIZ)
+		return -EINVAL;
+
+	spi_message_init(&message);
+	memset(x, 0, sizeof x);
+	if (n_tx) {
+		x[0].len = n_tx;
+		x[0].delay_usecs = RMI_TDPB;
+		spi_message_add_tail(&x[0], &message);
+	}
+	if (n_rx) {
+#ifdef CONFIG_ARCH_OMAP
+		x[1].len = n_rx-1;	/* since OMAP has one dummy byte. */
+#else
+		x[1].len = n_rx;
+#endif
+		x[1].delay_usecs = RMI_TDPB;
+		spi_message_add_tail(&x[1], &message);
+	}
+
+	/* ... unless someone else is using the pre-allocated buffer */
+	if (down_trylock(&lock)) {
+		local_buf = kmalloc(SPI_BUFSIZ, GFP_KERNEL);
+		if (!local_buf)
+			return -ENOMEM;
+	} else
+		local_buf = buf;
+
+	memcpy(local_buf, txbuf, n_tx);
+
+
+	x[0].tx_buf = local_buf;
+	x[1].rx_buf = local_buf + n_tx;
+
+	/* do the i/o */
+	status = spi_sync(spi, &message);
+	if (status == 0) {
+		memcpy(rxbuf, x[1].rx_buf, n_rx);
+		status = message.status;
+	} else {
+		printk(KERN_ERR "spi_sync fials!\n");
+	}
+
+	if (x[0].tx_buf == buf)
+		up(&lock);
+	else
+		kfree(local_buf);
+
+	return status;
+}
+
+/**
+ * Read a single register through spi.
+ * \param[in] pd
+ * \param[in] address The address at which to start the data read.
+ * \param[out] valp Pointer to the buffer where the data will be stored.
+ * \return zero upon success (with the byte read in valp), non-zero upon error.
+ */
+static int
+rmi_spi_read(struct rmi_phys_driver *pd, unsigned short address, char *valp)
+{
+	struct instance_data *id = container_of(pd, struct instance_data, rpd);
+
+	char rxbuf[2];
+	int retval;
+	unsigned short addr = address;
+
+	addr = ((addr & 0xff00) >> 8);
+	address = ((address & 0x00ff) << 8);
+	addr |= address;
+	addr |= 0x80;		/* High bit set indicates read. */
+
+	retval = spi_xfer(id->spidev, (u8 *)&addr, 2, rxbuf, 1);
+
+	*valp = rxbuf[0];
+
+	return retval;
+}
+
+/**
+ * Same as rmi_spi_read, except that multiple bytes are allowed to be read.
+ * \param[in] pd
+ * \param[in] address The address at which to start the data read.
+ * \param[out] valp Pointer to the buffer where the data will be stored.  This
+ * buffer must be at least size bytes long.
+ * \param[in] size The number of bytes to be read.
+ * \return zero upon success (with the byte read in valp), non-zero upon error.
+ */
+static int
+rmi_spi_read_multiple(struct rmi_phys_driver *pd, unsigned short address,
+	char *valp, int size)
+{
+	struct instance_data *id = container_of(pd, struct instance_data, rpd);
+	int retval;
+
+	unsigned short addr = address;
+
+	addr = ((addr & 0xff00) >> 8);
+	address = ((address & 0x00ff) << 8);
+	addr |= address;
+	addr |= 0x80;		/* High bit set indicates read. */
+
+	retval = spi_xfer(id->spidev, (u8 *)&addr, 2, valp, size);
+
+	return retval;
+}
+
+/**
+ * Write a single register through spi.
+ * You can write multiple registers at once, but I made the functions for that
+ * seperate for performance reasons.  Writing multiple requires allocation and
+ * freeing.
+ * \param[in] pd
+ * \param[in] address The address at which to start the write.
+ * \param[in] data The data to be written.
+ * \return one upon success, something else upon error.
+ */
+static int
+rmi_spi_write(struct rmi_phys_driver *pd, unsigned short address, char data)
+{
+	struct instance_data *id = container_of(pd, struct instance_data, rpd);
+	unsigned char txbuf[4];
+	int retval;
+
+	txbuf[2]  = data;
+	txbuf[1]  = address;
+	txbuf[0]  = address>>8;
+
+	retval = spi_xfer(id->spidev, txbuf, 3, NULL, 0);
+	return retval ? 0 : 1;
+}
+
+/**
+ * Write multiple registers.
+ * \param[in] pd
+ * \param[in] address The address at which to start the write.
+ * \param[in] valp A pointer to a buffer containing the data to be written.
+ * \param[in] size The number of bytes to write.
+ * \return one upon success, something else upon error.
+ */
+static int
+rmi_spi_write_multiple(struct rmi_phys_driver *pd, unsigned short address,
+	char *valp, int size)
+{
+	struct instance_data *id = container_of(pd, struct instance_data, rpd);
+	unsigned char txbuf[32];
+	int retval;
+	int i;
+
+	txbuf[1]  = address;
+	txbuf[0]  = address>>8;
+
+	for (i = 0; i < size; i++)
+		txbuf[i + 2] = valp[i];
+
+	retval = spi_xfer(id->spidev, txbuf, size+2, NULL, 0);
+
+	return retval ? 0 : 1;
+}
+
+/**
+ * This is the Interrupt Service Routine.  It just notifies the application
+ * layer that attention is required.
+ */
+static irqreturn_t spi_attn_isr(int irq, void *info)
+{
+	struct instance_data *id = info;
+	disable_irq(id->irq);
+	if (id->rpd.attention)
+		id->rpd.attention(&id->rpd, id->instance_no);
+	return IRQ_HANDLED;
+}
+
+
+static int rmi_spi_probe(struct spi_device *spi)
+{
+	struct instance_data *id;
+	int retval;
+	int i;
+	bool found;
+	struct rmi_spi_data *rmispidata;
+	struct rmi_spi_platformdata *platformdata;
+
+	printk(KERN_INFO "Probing RMI4 SPI device\n");
+
+	found = false;
+
+	spi->bits_per_word = 8;
+
+	spi->mode = SPI_MODE_3;
+
+	buf = kmalloc(SPI_BUFSIZ, GFP_KERNEL);
+	if (!buf) {
+		printk(KERN_ERR "%s: Out of memory - can't allocate memory for spi buffer\n", __func__);
+		return -ENOMEM;
+	}
+
+	retval = spi_setup(spi);
+	if (retval < 0) {
+		printk(KERN_ERR "%s: spi_setup failed\n", __func__);
+		return retval;
+	}
+
+	id = kzalloc(sizeof(*id), GFP_KERNEL);
+	if (!id) {
+		printk(KERN_ERR "%s: Out of memory - can't allocate memory for instance data\n", __func__);
+		return -ENOMEM;
+	}
+
+	id->spidev             = spi;
+	id->rpd.name           = DRIVER_NAME;
+	id->rpd.write          = rmi_spi_write;
+	id->rpd.read           = rmi_spi_read;
+	id->rpd.write_multiple = rmi_spi_write_multiple;
+	id->rpd.read_multiple  = rmi_spi_read_multiple;
+	id->rpd.module         = THIS_MODULE;
+	id->rpd.polling_required = true; /* default to polling if irq not used */
+
+	/* Loop through the client data and locate the one that was found. */
+
+	rmispidata = spi->dev.platform_data;
+
+	/* Loop through the platform data and locate the one that matches the clients address */
+	for (i = 0; i < rmispidata->num_clients; i++) {
+		platformdata = &(rmispidata->platformdata[i]);
+		if (platformdata->chip == RMI_SUPPORT) {
+			id->instance_no = i;
+			found = true;
+
+			/* set the device name using the instance_no appended to DEVICE_NAME to make a unique name */
+			dev_set_name(&spi->dev, "rmi4-spi%d", id->instance_no);
+			/*
+			* Determine if we need to poll (inefficient) or use interrupts.
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
+					dev_warn(&spi->dev, "%s: Invalid IRQ flags in platform data\n", __func__);
+					kfree(id);
+					return -ENXIO;
+				}
+
+				retval = request_irq(id->irq, spi_attn_isr, irqtype, "rmi_spi", id);
+				if (retval) {
+					dev_info(&spi->dev, "%s: Unable to get attn irq %d.  Reverting to polling.\n", __func__, id->irq);
+					id->rpd.polling_required = true;
+				} else {
+					dev_dbg(&spi->dev, "%s: got irq\n", __func__);
+					id->rpd.polling_required = false;
+					id->rpd.irq = id->irq;
+				}
+			} else {
+				id->rpd.polling_required = true;
+				dev_info(&spi->dev, "%s: No IRQ info given. Polling required.\n", __func__);
+			}
+		}
+	}
+
+	/* if went through all the platform data list and didn't find a match then notify that we are defaulting to polling */
+	if (!found) {
+		dev_info(&spi->dev, "%s: No platform data match found.Defaulting to use polling.\n", __func__);
+	}
+
+	/* Store instance data for later access. */
+	if (id) {
+		spi_set_drvdata(spi, id);
+	}
+
+	/* Register the sensor driver - which will trigger a scan of the PDT. */
+	retval = rmi_register_sensors(&id->rpd);
+	if (retval) {
+		printk(KERN_ERR "rmi_register_phys_driver failed.\n");
+		if (id->irq)
+			free_irq(id->irq, id);
+		kfree(id);
+		return retval;
+	}
+
+	printk(KERN_INFO "%s: Successfully Registered %s\n", __func__, id->rpd.name);
+
+	return 0;
+}
+
+static int rmi_spi_suspend(struct spi_device *spi, pm_message_t message)
+{
+	return 0;
+}
+
+static int rmi_spi_resume(struct spi_device *spi)
+{
+	return 0;
+}
+
+static int __devexit rmi_spi_remove(struct spi_device *spi)
+{
+	struct instance_data *id = spi_get_drvdata(spi);
+
+	rmi_spi_suspend(spi, PMSG_SUSPEND);
+
+	rmi_unregister_sensors(&id->rpd);
+
+	if (id) {
+		if (id->irq)
+			free_irq(id->irq, id);
+		kfree(id);
+	}
+
+	return 0;
+}
+
+static struct spi_driver rmi_spi_driver = {
+	.driver = {
+		.name  = "rmi_spi",
+		.bus   = &spi_bus_type,
+		.owner = THIS_MODULE,
+	},
+	.probe    = rmi_spi_probe,
+	.remove   = __devexit_p(rmi_spi_remove),
+	.suspend  = rmi_spi_suspend,
+	.resume   = rmi_spi_resume,
+};
+
+/**
+ * The Platform Driver probe function.  We just tell the spi subsystem about
+ * ourselves in this call.
+ */
+static int
+rmi_spi_plat_probe(struct platform_device *dev)
+{
+	struct rmi_spi_data *mid = dev->dev.platform_data;
+
+	if (!mid) {
+		printk(KERN_ERR "A platform device must contain rmi_spi_data\n");
+		return -ENXIO;
+	}
+
+	num_clients = mid->num_clients;
+	platformdata  = mid->platformdata;
+
+	return spi_register_driver(&rmi_spi_driver);
+}
+
+/**
+ * Tell the spi subsystem that we're done.
+ * \param[in] dev
+ * \return Always returns 0.
+ */
+static int
+rmi_spi_plat_remove(struct platform_device *dev)
+{
+	spi_unregister_driver(&rmi_spi_driver);
+	return 0;
+}
+
+/**
+ * Structure used to tell the Platform Driver subsystem about us.
+ */
+static struct platform_driver rmi_spi_platform_driver = {
+	.driver		= {
+		.name	= "rmi_spi_plat",
+	},
+	.probe		= rmi_spi_plat_probe,
+	.remove		= rmi_spi_plat_remove,
+};
+
+static int __init rmi_spi_init(void)
+{
+	return platform_driver_register(&rmi_spi_platform_driver);
+}
+module_init(rmi_spi_init);
+
+static void __exit rmi_spi_exit(void)
+{
+	if (buf) {
+		kfree(buf);
+		buf = NULL;
+	}
+	platform_driver_unregister(&rmi_spi_platform_driver);
+}
+module_exit(rmi_spi_exit);
+
+/** Standard driver module information - the author of the module.
+ */
+MODULE_AUTHOR("Synaptics, Inc.");
+/** Standard driver module information - a summary description of this module.
+ */
+MODULE_DESCRIPTION("RMI4 Driver SPI Physical Layer");
+/** Standard driver module information - the license under which this module
+ * is included in the kernel.
+ */
+MODULE_LICENSE("GPL");
+
diff --git a/drivers/input/touchscreen/rmi_spi.h b/drivers/input/touchscreen/rmi_spi.h
new file mode 100755
index 0000000..b957338
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_spi.h
@@ -0,0 +1,53 @@
+/**
+ *
+ * Register Mapped Interface SPI Physical Layer Driver Header File.
+ * Copyright (C) 2008-2011, Synaptics Incorporated
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
+#define RMI_CHIP_VER_3	0
+#define RMI_CHIP_VER_4	1
+
+#define RMI_SUPPORT (RMI_CHIP_VER_3|RMI_CHIP_VER_4)
+
+/** Platform-specific configuration data.
+ * This structure is used by the platform-specific driver to designate
+ * specific information about the hardware.  A platform client may supply
+ * an array of these to the rmi_phys_spi driver.
+ */
+struct rmi_spi_platformdata {
+	/* struct spi_device spi_dev; */
+	int chip;
+
+	/** The number of the irq.  Set to zero if polling is required. */
+	int irq;
+
+	/** The type of the irq (e.g., IRQF_TRIGGER_FALLING).  Only valid if
+	* irq != 0 */
+	int irq_type;
+};
+
+/** Descriptor structure.
+ * Describes the number of spi devices on the bus that speak RMI.
+ */
+struct rmi_spi_data {
+	int num_clients;
+	struct rmi_spi_platformdata *platformdata;
+};

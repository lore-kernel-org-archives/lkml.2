Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab2LSAsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 19:48:01 -0500
Received: from [12.239.217.82] ([12.239.217.82]:37442 "EHLO
	venom.synaptics.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755118Ab2LSArz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 19:47:55 -0500
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Christopher Heiny <cheiny@synaptics.com>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 01/05] input: RMI4 header file
Date: Tue, 18 Dec 2012 16:46:32 -0800
Message-Id: <1355877996-1433-2-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1355877996-1433-1-git-send-email-cheiny@synaptics.com>
References: <1355877996-1433-1-git-send-email-cheiny@synaptics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In addition to the changes described in part 0/5, this fixes some cut&paste
issues in the comments for module_rmi_function_driver.

Signed-off-by: Christopher Heiny <cheiny@synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Joeri de Gram <j.de.gram@gmail.com>
Acked-by: Jean Delvare <khali@linux-fr.org>

---

 include/linux/rmi.h |   95 +++++++++++++++++++++++----------------------------
 1 files changed, 43 insertions(+), 52 deletions(-)

diff --git a/include/linux/rmi.h b/include/linux/rmi.h
index daca41b..eec926f 100644
--- a/include/linux/rmi.h
+++ b/include/linux/rmi.h
@@ -2,25 +2,16 @@
  * Copyright (c) 2011, 2012 Synaptics Incorporated
  * Copyright (c) 2011 Unixphere
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
  */

 #ifndef _RMI_H
 #define _RMI_H
 #include <linux/kernel.h>
 #include <linux/cdev.h>
+#include <linux/debugfs.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/input.h>
@@ -31,7 +22,6 @@
 #include <linux/stat.h>
 #include <linux/types.h>
 #include <linux/wait.h>
-#include <linux/debugfs.h>

 extern struct bus_type rmi_bus_type;

@@ -73,7 +63,7 @@ enum rmi_attn_polarity {
  *               automatically enabled for this sensor.
  */
 struct rmi_f11_2d_axis_alignment {
-	bool swap_axes;
+	u32 swap_axes;
 	bool flip_x;
 	bool flip_y;
 	int clip_X_low;
@@ -82,7 +72,6 @@ struct rmi_f11_2d_axis_alignment {
 	int clip_Y_high;
 	int offset_X;
 	int offset_Y;
-	int rel_report_enabled;
 	u8 delta_x_threshold;
 	u8 delta_y_threshold;
 };
@@ -105,6 +94,7 @@ enum rmi_f11_sensor_type {

 /**
  * struct rmi_f11_sensor_data - overrides defaults for a single F11 2D sensor.
+ *
  * @axis_align - provides axis alignment overrides (see above).
  * @type_a - all modern RMI F11 firmwares implement Multifinger Type B
  * protocol.  Set this to true to force MF Type A behavior, in case you find
@@ -338,13 +328,14 @@ struct rmi_function_descriptor {
 	u8 function_version;
 };

-struct rmi_function;
+struct rmi_function_dev;
 struct rmi_device;

 /**
- * struct rmi_function_handler - driver routines for a particular RMI function.
+ * struct rmi_function_driver - driver routines for a particular RMI function.
  *
  * @func: The RMI function number
+ * @probe: Called when the handler is successfully matched to a function device.
  * @reset: Called when a reset of the touch sensor is detected.  The routine
  * should perform any out-of-the-ordinary reset handling that might be
  * necessary.  Restoring of touch sensor configuration registers should be
@@ -361,37 +352,31 @@ struct rmi_device;
  *
  * All callbacks are expected to return 0 on success, error code on failure.
  */
-struct rmi_function_handler {
+struct rmi_function_driver {
 	struct device_driver driver;

 	u8 func;
-	int (*probe)(struct rmi_function *fn);
-	void (*remove)(struct rmi_function *fn);
-	int (*config)(struct rmi_function *fn);
-	int (*reset)(struct rmi_function *fn);
-	int (*attention)(struct rmi_function *fn, unsigned long *irq_bits);
+	int (*probe)(struct rmi_function_dev *fc);
+	int (*remove)(struct rmi_function_dev *fc);
+	int (*config)(struct rmi_function_dev *fc);
+	int (*reset)(struct rmi_function_dev *fc);
+	int (*attention)(struct rmi_function_dev *fc,
+				unsigned long *irq_bits);
 #ifdef CONFIG_PM
-	int (*suspend)(struct rmi_function *fn);
-	int (*resume)(struct rmi_function *fn);
+	int (*suspend)(struct rmi_function_dev *fc);
+	int (*resume)(struct rmi_function_dev *fc);
 #endif
 };

-#define to_rmi_function_handler(d) \
-		container_of(d, struct rmi_function_handler, driver)
-
-int __must_check __rmi_register_function_handler(struct rmi_function_handler *,
-						 struct module *, const char *);
-#define rmi_register_function_handler(handler) \
-	__rmi_register_function_handler(handler, THIS_MODULE, KBUILD_MODNAME)
-
-void rmi_unregister_function_handler(struct rmi_function_handler *);
+#define to_rmi_function_driver(d) \
+		container_of(d, struct rmi_function_driver, driver);

 /**
- * struct rmi_function - represents the implementation of an RMI4
- * function for a particular device (basically, a driver for that RMI4 function)
+ * struct rmi_function_dev - represents an a particular RMI4 function on a given
+ * RMI4 sensor.
  *
  * @fd: The function descriptor of the RMI function
- * @rmi_dev: Pointer to the RMI device associated with this function container
+ * @rmi_dev: Pointer to the RMI device associated with this function device
  * @dev: The device associated with this particular function.
  *
  * @num_of_irqs: The number of irqs needed by this function
@@ -400,11 +385,12 @@ void rmi_unregister_function_handler(struct rmi_function_handler *);
  * interrupt handling.
  * @data: Private data pointer
  *
- * @list: Used to create a list of function containers.
+ * @list: Used to create a list of function devices.
  * @debugfs_root: used during debugging
  *
  */
-struct rmi_function {
+struct rmi_function_dev {
+
 	struct rmi_function_descriptor fd;
 	struct rmi_device *rmi_dev;
 	struct device dev;
@@ -414,13 +400,19 @@ struct rmi_function {
 	void *data;
 	struct list_head list;

-#ifdef CONFIG_RMI4_DEBUG
 	struct dentry *debugfs_root;
-#endif
 };

-#define to_rmi_function(d) \
-		container_of(d, struct rmi_function, dev)
+#define to_rmi_function_dev(d) \
+		container_of(d, struct rmi_function_dev, dev);
+
+
+int __must_check __rmi_register_function_driver(struct rmi_function_driver *,
+						 struct module *, const char *);
+#define rmi_register_function_driver(handler) \
+	__rmi_register_function_driver(handler, THIS_MODULE, KBUILD_MODNAME)
+
+void rmi_unregister_function_driver(struct rmi_function_driver *);

 /**
  * struct rmi_driver - driver for an RMI4 sensor on the RMI bus.
@@ -446,6 +438,7 @@ struct rmi_driver {
 	int (*store_productid)(struct rmi_device *rmi_dev);
 	int (*set_input_params)(struct rmi_device *rmi_dev,
 			struct input_dev *input);
+	int (*remove)(struct rmi_device *rmi_dev);
 	void *data;
 };

@@ -528,9 +521,7 @@ struct rmi_device {
 	struct rmi_driver *driver;
 	struct rmi_phys_device *phys;

-#ifdef CONFIG_RMI4_DEBUG
 	struct dentry *debugfs_root;
-#endif
 };

 #define to_rmi_device(d) container_of(d, struct rmi_device, dev);
@@ -601,17 +592,17 @@ void rmi_unregister_phys_device(struct rmi_phys_device *phys);
 int rmi_for_each_dev(void *data, int (*func)(struct device *dev, void *data));

 /**
- * module_serio_driver() - Helper macro for registering a serio driver
- * @__serio_driver: serio_driver struct
+ * module_rmi_function_driver() - Helper macro for registering a function driver
+ * @__rmi_driver: rmi_function_driver struct
  *
- * Helper macro for serio drivers which do not do anything special in
+ * Helper macro for RMI4 function drivers which do not do anything special in
  * module init/exit. This eliminates a lot of boilerplate. Each module
  * may only use this macro once, and calling it replaces module_init()
  * and module_exit().
  */
-#define module_rmi_driver(__rmi_driver)			\
+#define module_rmi_function_driver(__rmi_driver)	\
 	module_driver(__rmi_driver,			\
-		      rmi_register_function_handler,	\
-		      rmi_unregister_function_handler)
+		      rmi_register_function_driver,	\
+		      rmi_unregister_function_driver)

 #endif

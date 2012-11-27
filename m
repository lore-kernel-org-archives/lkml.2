Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255Ab2K0JVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 04:21:51 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33930 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758628Ab2K0JVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 04:21:47 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Linux Input <linux-input@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [PATCH 3/4] Input: RMI4 - move function registration into the core
Date: Tue, 27 Nov 2012 01:21:37 -0800
Message-Id: <1354008098-26346-3-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354008098-26346-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1354008098-26346-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This saves on boilerplate code that is needed in individual modules
implementing function handlers.

Also converted bool bitfields back to u8.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/rmi4/rmi_bus.c    | 189 ++++++++++++++++++++++--------
 drivers/input/rmi4/rmi_driver.c |   2 +-
 drivers/input/rmi4/rmi_driver.h |   6 +-
 drivers/input/rmi4/rmi_f01.c    |  57 ++-------
 drivers/input/rmi4/rmi_f11.c    | 250 +++++++++++++++++-----------------------
 include/linux/rmi.h             |   9 ++
 6 files changed, 271 insertions(+), 242 deletions(-)

diff --git a/drivers/input/rmi4/rmi_bus.c b/drivers/input/rmi4/rmi_bus.c
index 47cf0d5..acbfd3d 100644
--- a/drivers/input/rmi4/rmi_bus.c
+++ b/drivers/input/rmi4/rmi_bus.c
@@ -73,51 +73,6 @@ static atomic_t physical_device_count = ATOMIC_INIT(0);
 static struct dentry *rmi_debugfs_root;
 #endif
 
-#ifdef CONFIG_PM
-static int rmi_bus_suspend(struct device *dev)
-{
-	struct device_driver *driver = dev->driver;
-	const struct dev_pm_ops *pm;
-
-	if (!driver)
-		return 0;
-
-	pm = driver->pm;
-	if (pm && pm->suspend)
-		return pm->suspend(dev);
-	if (driver->suspend)
-		return driver->suspend(dev, PMSG_SUSPEND);
-
-	return 0;
-}
-
-static int rmi_bus_resume(struct device *dev)
-{
-	struct device_driver *driver = dev->driver;
-	const struct dev_pm_ops *pm;
-
-	if (!driver)
-		return 0;
-
-	pm = driver->pm;
-	if (pm && pm->resume)
-		return pm->resume(dev);
-	if (driver->resume)
-		return driver->resume(dev);
-
-	return 0;
-}
-#endif
-
-static SIMPLE_DEV_PM_OPS(rmi_bus_pm_ops,
-			 rmi_bus_suspend, rmi_bus_resume);
-
-struct bus_type rmi_bus_type = {
-	.name		= "rmi",
-	.pm		= &rmi_bus_pm_ops
-};
-EXPORT_SYMBOL_GPL(rmi_bus_type);
-
 static void release_rmidev_device(struct device *dev)
 {
 	device_unregister(dev);
@@ -184,6 +139,142 @@ void rmi_unregister_phys_device(struct rmi_phys_device *phys)
 EXPORT_SYMBOL(rmi_unregister_phys_device);
 
 /**
+ * rmi_register_function_handler - register a handler for an RMI function
+ * @handler: RMI handler that should be registered.
+ * @module: pointer to module that implements the handler
+ * @mod_name: name of the module implementing the handler
+ *
+ * This function performs additional setup of RMI function handler and
+ * registers it with the RMI core so that it can be bound to
+ * RMI function devices.
+ */
+int __rmi_register_function_handler(struct rmi_function_handler *handler,
+				     struct module *owner,
+				     const char *mod_name)
+{
+	int error;
+
+	handler->driver.bus = &rmi_bus_type;
+	handler->driver.owner = owner;
+	handler->driver.mod_name = mod_name;
+
+	error = driver_register(&handler->driver);
+	if (error) {
+		pr_err("driver_register() failed for %s, error: %d\n",
+			handler->driver.name, error);
+		return error;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(__rmi_register_function_handler);
+
+/**
+ * rmi_unregister_function_handler - unregister given RMI function handler
+ * @handler: RMI handler that should be unregistered.
+ *
+ * This function unregisters given function handler from RMI core which
+ * causes it to be unbound from the function devices.
+ */
+void rmi_unregister_function_handler(struct rmi_function_handler *handler)
+{
+	driver_unregister(&handler->driver);
+}
+EXPORT_SYMBOL(rmi_unregister_function_handler);
+
+
+static int rmi_function_match(struct device *dev, struct device_driver *drv)
+{
+	struct rmi_function_handler *handler;
+	struct rmi_function *fn;
+
+	if (dev->type != &rmi_function_type)
+		return 0;
+
+	if (drv == &rmi_sensor_driver.driver)
+		return 0;
+
+	fn = to_rmi_function(dev);
+	handler = to_rmi_function_handler(drv);
+
+	return fn->fd.function_number == handler->func;
+}
+
+static int rmi_function_probe(struct device *dev)
+{
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct rmi_function_handler *handler =
+					to_rmi_function_handler(dev->driver);
+	int error;
+
+	if (handler->probe) {
+		error = handler->probe(fn);
+		return error;
+	}
+
+	return 0;
+}
+
+static int rmi_function_remove(struct device *dev)
+{
+	struct rmi_function *fn = to_rmi_function(dev);
+	struct rmi_function_handler *handler =
+					to_rmi_function_handler(dev->driver);
+
+	if (handler->remove)
+		handler->remove(fn);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int rmi_bus_suspend(struct device *dev)
+{
+	struct device_driver *driver = dev->driver;
+	const struct dev_pm_ops *pm;
+
+	if (!driver)
+		return 0;
+
+	pm = driver->pm;
+	if (pm && pm->suspend)
+		return pm->suspend(dev);
+	if (driver->suspend)
+		return driver->suspend(dev, PMSG_SUSPEND);
+
+	return 0;
+}
+
+static int rmi_bus_resume(struct device *dev)
+{
+	struct device_driver *driver = dev->driver;
+	const struct dev_pm_ops *pm;
+
+	if (!driver)
+		return 0;
+
+	pm = driver->pm;
+	if (pm && pm->resume)
+		return pm->resume(dev);
+	if (driver->resume)
+		return driver->resume(dev);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(rmi_bus_pm_ops,
+			 rmi_bus_suspend, rmi_bus_resume);
+
+struct bus_type rmi_bus_type = {
+	.match		= rmi_function_match,
+	.probe		= rmi_function_probe,
+	.remove		= rmi_function_remove,
+	.name		= "rmi",
+	.pm		= &rmi_bus_pm_ops,
+};
+
+/**
  * rmi_for_each_dev - provides a way for other parts of the system to enumerate
  * the devices on the RMI bus.
  *
@@ -198,7 +289,7 @@ int rmi_for_each_dev(void *data, int (*func)(struct device *dev, void *data))
 	mutex_unlock(&rmi_bus_mutex);
 	return retval;
 }
-EXPORT_SYMBOL_GPL(rmi_for_each_dev);
+EXPORT_SYMBOL(rmi_for_each_dev);
 
 static int __init rmi_bus_init(void)
 {
@@ -213,7 +304,7 @@ static int __init rmi_bus_init(void)
 		return error;
 	}
 
-	error = rmi_register_f01_handler();
+	error = rmi_register_function_handler(&rmi_f01_handler);
 	if (error) {
 		pr_err("%s: error registering the RMI F01 handler: %d\n",
 			__func__, error);
@@ -242,7 +333,7 @@ static int __init rmi_bus_init(void)
 	return 0;
 
 err_unregister_f01:
-	rmi_unregister_f01_handler();
+	rmi_unregister_function_handler(&rmi_f01_handler);
 err_unregister_bus:
 	bus_unregister(&rmi_bus_type);
 	return error;
@@ -258,7 +349,7 @@ static void __exit rmi_bus_exit(void)
 		debugfs_remove(rmi_debugfs_root);
 
 	rmi_unregister_sensor_driver();
-	rmi_unregister_f01_handler();
+	rmi_unregister_function_handler(&rmi_f01_handler);
 	bus_unregister(&rmi_bus_type);
 }
 
diff --git a/drivers/input/rmi4/rmi_driver.c b/drivers/input/rmi4/rmi_driver.c
index 6b6ac0c..bbd23f9 100644
--- a/drivers/input/rmi4/rmi_driver.c
+++ b/drivers/input/rmi4/rmi_driver.c
@@ -1608,7 +1608,7 @@ static int __devinit rmi_driver_probe(struct device *dev)
 static UNIVERSAL_DEV_PM_OPS(rmi_driver_pm, rmi_driver_suspend,
 			    rmi_driver_resume, NULL);
 
-static struct rmi_driver rmi_sensor_driver = {
+struct rmi_driver rmi_sensor_driver = {
 	.driver = {
 		.owner = THIS_MODULE,
 		.name = "rmi_generic",
diff --git a/drivers/input/rmi4/rmi_driver.h b/drivers/input/rmi4/rmi_driver.h
index e71ffdc..2866f7d 100644
--- a/drivers/input/rmi4/rmi_driver.h
+++ b/drivers/input/rmi4/rmi_driver.h
@@ -136,10 +136,10 @@ extern void rmi4_fw_update(struct rmi_device *rmi_dev,
 #define rmi4_fw_update(rmi_dev, f01_pdt, f34_pdt)
 #endif
 
+extern struct rmi_driver rmi_sensor_driver;
+extern struct rmi_function_handler rmi_f01_handler;
+
 int rmi_register_sensor_driver(void);
 void rmi_unregister_sensor_driver(void);
 
-int rmi_register_f01_handler(void);
-void rmi_unregister_f01_handler(void);
-
 #endif
diff --git a/drivers/input/rmi4/rmi_f01.c b/drivers/input/rmi4/rmi_f01.c
index 41ac5f0..d7461d7 100644
--- a/drivers/input/rmi4/rmi_f01.c
+++ b/drivers/input/rmi4/rmi_f01.c
@@ -26,8 +26,6 @@
 #include "rmi_driver.h"
 #include "rmi_f01.h"
 
-#define FUNCTION_NUMBER 0x01
-
 /**
  * @reset - set this bit to force a firmware reset of the sensor.
  */
@@ -1120,7 +1118,7 @@ static int rmi_f01_config(struct rmi_function *fn)
 	return 0;
 }
 
-static int f01_device_init(struct rmi_function *fn)
+static int rmi_f01_probe(struct rmi_function *fn)
 {
 	struct rmi_driver_data *driver_data =
 			dev_get_drvdata(&fn->rmi_dev->dev);
@@ -1141,6 +1139,12 @@ static int f01_device_init(struct rmi_function *fn)
 	return 0;
 }
 
+static void rmi_f01_remove(struct rmi_function *fn)
+{
+	teardown_debugfs(fn->data);
+	sysfs_remove_group(&fn->dev.kobj, &rmi_fn_01_attr_group);
+}
+
 #ifdef CONFIG_PM
 static int rmi_f01_suspend(struct rmi_function *fn)
 {
@@ -1200,18 +1204,8 @@ static int rmi_f01_resume(struct rmi_function *fn)
 }
 #endif /* CONFIG_PM */
 
-static int f01_remove(struct device *dev)
-{
-	struct rmi_function *fn = to_rmi_function(dev);
-
-	teardown_debugfs(fn->data);
-	sysfs_remove_group(&fn->dev.kobj, &rmi_fn_01_attr_group);
-
-	return 0;
-}
-
 static int rmi_f01_attention(struct rmi_function *fn,
-						unsigned long *irq_bits)
+			     unsigned long *irq_bits)
 {
 	struct rmi_device *rmi_dev = fn->rmi_dev;
 	struct f01_data *data = fn->data;
@@ -1233,44 +1227,17 @@ static int rmi_f01_attention(struct rmi_function *fn,
 	return 0;
 }
 
-static int f01_probe(struct device *dev)
-{
-	struct rmi_function *fn;
-
-	if (dev->type != &rmi_function_type)
-		return 1;
-
-	fn = to_rmi_function(dev);
-	if (fn->fd.function_number != FUNCTION_NUMBER)
-		return 1;
-
-	return f01_device_init(fn);
-}
-
-static struct rmi_function_handler function_handler = {
+struct rmi_function_handler rmi_f01_handler = {
 	.driver = {
-		.owner = THIS_MODULE,
 		.name = "rmi_f01",
-		.bus = &rmi_bus_type,
-		.probe = f01_probe,
-		.remove = f01_remove,
 	},
-	.func = FUNCTION_NUMBER,
+	.func = 0x01,
+	.probe = rmi_f01_probe,
+	.remove = rmi_f01_remove,
 	.config = rmi_f01_config,
 	.attention = rmi_f01_attention,
-
 #ifdef CONFIG_PM
 	.suspend = rmi_f01_suspend,
 	.resume = rmi_f01_resume,
 #endif  /* CONFIG_PM */
 };
-
-int __init rmi_register_f01_handler(void)
-{
-	return driver_register(&function_handler.driver);
-}
-
-void __exit rmi_unregister_f01_handler(void)
-{
-	driver_unregister(&function_handler.driver);
-}
diff --git a/drivers/input/rmi4/rmi_f11.c b/drivers/input/rmi4/rmi_f11.c
index dd270b4..dbb6060 100644
--- a/drivers/input/rmi4/rmi_f11.c
+++ b/drivers/input/rmi4/rmi_f11.c
@@ -18,7 +18,6 @@
  */
 
 #define FUNCTION_DATA f11_data
-#define FNUM 11
 
 #include <linux/kernel.h>
 #include <linux/delay.h>
@@ -108,7 +107,7 @@
  * current capacitive state.
  */
 struct f11_2d_commands {
-	bool rezero:1;
+	u8 rezero:1;
 	u8 reserved:7;
 } __attribute__((__packed__));
 
@@ -122,11 +121,11 @@ struct f11_2d_commands {
  */
 struct f11_2d_device_query {
 	u8 nbr_of_sensors:3;
-	bool has_query9:1;
-	bool has_query11:1;
-	bool has_query12:1;
-	bool has_query27:1;
-	bool has_query28:1;
+	u8 has_query9:1;
+	u8 has_query11:1;
+	u8 has_query12:1;
+	u8 has_query27:1;
+	u8 has_query28:1;
 } __attribute__((__packed__));
 
 /** Query registers 1 through 4 are always present.
@@ -148,11 +147,11 @@ struct f11_2d_device_query {
 struct f11_2d_sensor_info {
 	/* query1 */
 	u8 number_of_fingers:3;
-	bool has_rel:1;
-	bool has_abs:1;
-	bool has_gestures:1;
-	bool has_sensitivity_adjust:1;
-	bool configurable:1;
+	u8 has_rel:1;
+	u8 has_abs:1;
+	u8 has_gestures:1;
+	u8 has_sensitivity_adjust:1;
+	u8 configurable:1;
 	/* query2 */
 	u8 num_of_x_electrodes:7;
 	u8 reserved_1:1;
@@ -184,12 +183,12 @@ struct f11_2d_sensor_info {
  */
 struct f11_2d_abs_info {
 	u8 abs_data_size:2;
-	bool has_anchored_finger:1;
-	bool has_adj_hyst:1;
-	bool has_dribble:1;
-	bool has_bending_correction:1;
-	bool has_large_object_suppression:1;
-	bool has_jitter_filter:1;
+	u8 has_anchored_finger:1;
+	u8 has_adj_hyst:1;
+	u8 has_dribble:1;
+	u8 has_bending_correction:1;
+	u8 has_large_object_suppression:1;
+	u8 has_jitter_filter:1;
 } __attribute__((__packed__));
 
 /** Gesture information queries 7 and 8 are present if has_gestures bit is set.
@@ -215,23 +214,23 @@ struct f11_2d_abs_info {
  * more than one finger is involved in a scrolling action.
  */
 struct f11_2d_gesture_info {
-	bool has_single_tap:1;
-	bool has_tap_n_hold:1;
-	bool has_double_tap:1;
-	bool has_early_tap:1;
-	bool has_flick:1;
-	bool has_press:1;
-	bool has_pinch:1;
-	bool has_chiral:1;
-
-	bool has_palm_det:1;
-	bool has_rotate:1;
-	bool has_touch_shapes:1;
-	bool has_scroll_zones:1;
-	bool has_individual_scroll_zones:1;
-	bool has_multi_finger_scroll:1;
-	bool has_mf_edge_motion:1;
-	bool has_mf_scroll_inertia:1;
+	u8 has_single_tap:1;
+	u8 has_tap_n_hold:1;
+	u8 has_double_tap:1;
+	u8 has_early_tap:1;
+	u8 has_flick:1;
+	u8 has_press:1;
+	u8 has_pinch:1;
+	u8 has_chiral:1;
+
+	u8 has_palm_det:1;
+	u8 has_rotate:1;
+	u8 has_touch_shapes:1;
+	u8 has_scroll_zones:1;
+	u8 has_individual_scroll_zones:1;
+	u8 has_multi_finger_scroll:1;
+	u8 has_mf_edge_motion:1;
+	u8 has_mf_scroll_inertia:1;
 } __attribute__((__packed__));
 
 /** Utility for checking bytes in the gesture info registers.  This is done
@@ -255,14 +254,14 @@ static bool has_gesture_bits(const struct f11_2d_gesture_info *info,
  * F11_2D_Data27 exist.
  */
 struct f11_2d_query9 {
-	bool has_pen:1;
-	bool has_proximity:1;
-	bool has_palm_det_sensitivity:1;
-	bool has_suppress_on_palm_detect:1;
-	bool has_two_pen_thresholds:1;
-	bool has_contact_geometry:1;
-	bool has_pen_hover_discrimination:1;
-	bool has_pen_filters:1;
+	u8 has_pen:1;
+	u8 has_proximity:1;
+	u8 has_palm_det_sensitivity:1;
+	u8 has_suppress_on_palm_detect:1;
+	u8 has_two_pen_thresholds:1;
+	u8 has_contact_geometry:1;
+	u8 has_pen_hover_discrimination:1;
+	u8 has_pen_filters:1;
 } __attribute__((__packed__));
 
 /** Touch shape info (query 10) is present if has_touch_shapes is set.
@@ -296,14 +295,14 @@ struct f11_2d_ts_info {
  * F11_2D_Ctrl50 and F11_2D_Ctrl51 exist.
  */
 struct f11_2d_query11 {
-	bool has_z_tuning:1;
-	bool has_algorithm_selection:1;
-	bool has_w_tuning:1;
-	bool has_pitch_info:1;
-	bool has_finger_size:1;
-	bool has_segmentation_aggressiveness:1;
-	bool has_XY_clip:1;
-	bool has_drumming_filter:1;
+	u8 has_z_tuning:1;
+	u8 has_algorithm_selection:1;
+	u8 has_w_tuning:1;
+	u8 has_pitch_info:1;
+	u8 has_finger_size:1;
+	u8 has_segmentation_aggressiveness:1;
+	u8 has_XY_clip:1;
+	u8 has_drumming_filter:1;
 } __attribute__((__packed__));
 
 /**
@@ -320,14 +319,14 @@ struct f11_2d_query11 {
  * @has_linear_coeff - indicates that F11 Ctrl 81 exists.
  */
 struct f11_2d_query12 {
-	bool has_gapless_finger:1;
-	bool has_gapless_finger_tuning:1;
-	bool has_8bit_w:1;
-	bool has_adjustable_mapping:1;
-	bool has_info2:1;
-	bool has_physical_props:1;
-	bool has_finger_limit:1;
-	bool has_linear_coeff_2:1;
+	u8 has_gapless_finger:1;
+	u8 has_gapless_finger_tuning:1;
+	u8 has_8bit_w:1;
+	u8 has_adjustable_mapping:1;
+	u8 has_info2:1;
+	u8 has_physical_props:1;
+	u8 has_finger_limit:1;
+	u8 has_linear_coeff_2:1;
 } __attribute__((__packed__));
 
 /** This register is present if Query 5's has_jitter_filter bit is set.
@@ -353,10 +352,10 @@ struct f11_2d_query13 {
  */
 struct f11_2d_query14 {
 	u8 light_control:2;
-	bool is_clear:1;
+	u8 is_clear:1;
 	u8 clickpad_props:2;
 	u8 mouse_buttons:2;
-	bool has_advanced_gestures:1;
+	u8 has_advanced_gestures:1;
 } __attribute__((__packed__));
 
 #define F11_LIGHT_CTL_NONE 0x00
@@ -371,23 +370,14 @@ struct f11_2d_query14 {
  */
 struct f11_2d_sensor_queries {
 	struct f11_2d_sensor_info info;
-
 	struct f11_2d_abs_info abs_info;
-
 	u8 f11_2d_query6;
-
 	struct f11_2d_gesture_info gesture_info;
-
 	struct f11_2d_query9 query9;
-
 	struct f11_2d_ts_info ts_info;
-
 	struct f11_2d_query11 features_1;
-
 	struct f11_2d_query12 features_2;
-
 	struct f11_2d_query13 jitter_filter;
-
 	struct f11_2d_query14 info_2;
 };
 
@@ -426,16 +416,16 @@ struct f11_2d_sensor_queries {
 struct f11_2d_ctrl0_9 {
 	/* F11_2D_Ctrl0 */
 	u8 reporting_mode:3;
-	bool abs_pos_filt:1;
-	bool rel_pos_filt:1;
-	bool rel_ballistics:1;
-	bool dribble:1;
-	bool report_beyond_clip:1;
+	u8 abs_pos_filt:1;
+	u8 rel_pos_filt:1;
+	u8 rel_ballistics:1;
+	u8 dribble:1;
+	u8 report_beyond_clip:1;
 	/* F11_2D_Ctrl1 */
 	u8 palm_detect_thres:4;
 	u8 motion_sensitivity:2;
-	bool man_track_en:1;
-	bool man_tracked_finger:1;
+	u8 man_track_en:1;
+	u8 man_tracked_finger:1;
 	/* F11_2D_Ctrl2 and 3 */
 	u8 delta_x_threshold:8;
 	u8 delta_y_threshold:8;
@@ -459,13 +449,13 @@ struct f11_2d_ctrl0_9 {
  * @pinch_int_enable - enable pinch detection.
  */
 struct f11_2d_ctrl10 {
-	bool single_tap_int_enable:1;
-	bool tap_n_hold_int_enable:1;
-	bool double_tap_int_enable:1;
-	bool early_tap_int_enable:1;
-	bool flick_int_enable:1;
-	bool press_int_enable:1;
-	bool pinch_int_enable:1;
+	u8 single_tap_int_enable:1;
+	u8 tap_n_hold_int_enable:1;
+	u8 double_tap_int_enable:1;
+	u8 early_tap_int_enable:1;
+	u8 flick_int_enable:1;
+	u8 press_int_enable:1;
+	u8 pinch_int_enable:1;
 	u8 reserved:1;
 } __attribute__((__packed__));
 
@@ -477,11 +467,11 @@ struct f11_2d_ctrl10 {
  * @multi_finger_scroll_int_enable - enable the multfinger scroll feature.
  */
 struct f11_2d_ctrl11 {
-	bool palm_detect_int_enable:1;
-	bool rotate_int_enable:1;
-	bool touch_shape_int_enable:1;
-	bool scroll_zone_int_enable:1;
-	bool multi_finger_scroll_int_enable:1;
+	u8 palm_detect_int_enable:1;
+	u8 rotate_int_enable:1;
+	u8 touch_shape_int_enable:1;
+	u8 scroll_zone_int_enable:1;
+	u8 multi_finger_scroll_int_enable:1;
 	u8 reserved:3;
 } __attribute__((__packed__));
 
@@ -540,8 +530,8 @@ struct f11_2d_ctrl18_19 {
  * values result in higher sensitivity.
  */
 struct f11_2d_ctrl20_21 {
-	bool pen_detect_enable:1;
-	bool pen_jitter_filter_enable:1;
+	u8 pen_detect_enable:1;
+	u8 pen_jitter_filter_enable:1;
 	u8 ctrl20_reserved:6;
 	u8 pen_z_threshold:8;
 } __attribute__((__packed__));
@@ -566,8 +556,8 @@ struct f11_2d_ctrl20_21 {
  */
 struct f11_2d_ctrl22_26 {
 	/* control 22 */
-	bool proximity_detect_int_en:1;
-	bool proximity_jitter_filter_en:1;
+	u8 proximity_detect_int_en:1;
+	u8 proximity_jitter_filter_en:1;
 	u8 f11_2d_ctrl6_b3__7:6;
 
 	/* control 23 */
@@ -592,7 +582,7 @@ struct f11_2d_ctrl22_26 {
  */
 struct f11_2d_ctrl27 {
 	s8 palm_detect_sensitivity:4;
-	bool suppress_on_palm_detect:1;
+	u8 suppress_on_palm_detect:1;
 	u8 f11_2d_ctrl27_b5__7:3;
 } __attribute__((__packed__));
 
@@ -605,8 +595,8 @@ struct f11_2d_ctrl27 {
  */
 struct f11_2d_ctrl28 {
 	u8 multi_finger_scroll_mode:2;
-	bool edge_motion_en:1;
-	bool f11_2d_ctrl28b_3:1;
+	u8 edge_motion_en:1;
+	u8 f11_2d_ctrl28b_3:1;
 	u8 multi_finger_scroll_momentum:4;
 } __attribute__((__packed__));
 
@@ -2711,30 +2701,7 @@ static int rmi_f11_resume(struct rmi_function *fn)
 }
 #endif /* CONFIG_PM */
 
-static int f11_remove_device(struct device *dev)
-{
-	int attr_count = 0;
-	struct f11_data *f11;
-	struct rmi_function *fn = to_rmi_function(dev);
-
-	f11 = fn->data;
-
-	if (IS_ENABLED(CONFIG_RMI4_DEBUG)) {
-		int i;
-
-		for (i = 0; i < f11->dev_query.nbr_of_sensors + 1; i++)
-			teardown_sensor_debugfs(&f11->sensors[i]);
-		teardown_f11_debugfs(f11);
-	}
-
-	for (attr_count = 0; attr_count < ARRAY_SIZE(attrs); attr_count++)
-		sysfs_remove_file(&fn->dev.kobj, &attrs[attr_count].attr);
-
-	rmi_f11_free_devices(fn);
-	return 0;
-}
-
-static int f11_device_init(struct rmi_function *fn)
+static int rmi_f11_probe(struct rmi_function *fn)
 {
 	int rc;
 
@@ -2753,30 +2720,33 @@ static int f11_device_init(struct rmi_function *fn)
 	return 0;
 }
 
-static __devinit int f11_probe(struct device *dev)
+static void rmi_f11_remove(struct rmi_function *fn)
 {
-	struct rmi_function *fn;
+	struct f11_data *f11 = fn->data;
+	int attr_count = 0;
 
-	if (dev->type != &rmi_function_type)
-		return 1;
+	if (IS_ENABLED(CONFIG_RMI4_DEBUG)) {
+		int i;
 
-	fn = to_rmi_function(dev);
-	if (fn->fd.function_number != FUNCTION_NUMBER)
-		return 1;
+		for (i = 0; i < f11->dev_query.nbr_of_sensors + 1; i++)
+			teardown_sensor_debugfs(&f11->sensors[i]);
+		teardown_f11_debugfs(f11);
+	}
+
+	for (attr_count = 0; attr_count < ARRAY_SIZE(attrs); attr_count++)
+		sysfs_remove_file(&fn->dev.kobj, &attrs[attr_count].attr);
 
-	return f11_device_init(fn);
+	rmi_f11_free_devices(fn);
 }
 
 
-static struct rmi_function_handler function_handler = {
+static struct rmi_function_handler rmi_f11_handler = {
 	.driver = {
-		.owner = THIS_MODULE,
 		.name = "rmi_f11",
-		.bus = &rmi_bus_type,
-		.probe = f11_probe,
-		.remove = f11_remove_device,
 	},
-	.func = FUNCTION_NUMBER,
+	.func = 0x11,
+	.probe = rmi_f11_probe,
+	.remove = rmi_f11_remove,
 	.config = rmi_f11_config,
 	.attention = rmi_f11_attention,
 #ifdef CONFIG_HAS_EARLYSUSPEND
@@ -2788,20 +2758,12 @@ static struct rmi_function_handler function_handler = {
 
 static int __init rmi_f11_module_init(void)
 {
-	int error;
-
-	error = driver_register(&function_handler.driver);
-	if (error < 0) {
-		pr_err("%s: register driver failed!\n", __func__);
-		return error;
-	}
-
-	return 0;
+	return rmi_register_function_handler(&rmi_f11_handler);
 }
 
 static void __exit rmi_f11_module_exit(void)
 {
-	driver_unregister(&function_handler.driver);
+	rmi_unregister_function_handler(&rmi_f11_handler);
 }
 
 module_init(rmi_f11_module_init);
diff --git a/include/linux/rmi.h b/include/linux/rmi.h
index fa8a352e..8a74066 100644
--- a/include/linux/rmi.h
+++ b/include/linux/rmi.h
@@ -365,6 +365,8 @@ struct rmi_function_handler {
 	struct device_driver driver;
 
 	u8 func;
+	int (*probe)(struct rmi_function *fn);
+	void (*remove)(struct rmi_function *fn);
 	int (*config)(struct rmi_function *fn);
 	int (*reset)(struct rmi_function *fn);
 	int (*attention)(struct rmi_function *fn, unsigned long *irq_bits);
@@ -377,6 +379,13 @@ struct rmi_function_handler {
 #define to_rmi_function_handler(d) \
 		container_of(d, struct rmi_function_handler, driver)
 
+int __must_check __rmi_register_function_handler(struct rmi_function_handler *,
+						 struct module *, const char *);
+#define rmi_register_function_handler(handler) \
+	__rmi_register_function_handler(handler, THIS_MODULE, KBUILD_MODNAME)
+
+void rmi_unregister_function_handler(struct rmi_function_handler *);
+
 /**
  * struct rmi_function - represents the implementation of an RMI4
  * function for a particular device (basically, a driver for that RMI4 function)
-- 
1.7.11.7


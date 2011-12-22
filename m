Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab1LVCVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 21:21:36 -0500
Received: from [12.239.217.82] ([12.239.217.82]:9459 "EHLO venom.synaptics.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754667Ab1LVCUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 21:20:49 -0500
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Dec 2011 21:20:28 EST
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Christopher Heiny <cheiny@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [RFC PATCH 10/11] input: RMI4 F19 - capacitive buttons
Date: Wed, 21 Dec 2011 18:10:01 -0800
Message-Id: <1324519802-23894-11-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1324519802-23894-1-git-send-email-cheiny@synaptics.com>
References: <1324519802-23894-1-git-send-email-cheiny@synaptics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christopher Heiny <cheiny@synaptics.com>

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Cc: Joeri de Gram <j.de.gram@gmail.com>

---

 drivers/input/rmi4/rmi_f19.c | 1571 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 1571 insertions(+), 0 deletions(-)

diff --git a/drivers/input/rmi4/rmi_f19.c b/drivers/input/rmi4/rmi_f19.c
new file mode 100644
index 0000000..a678f30
--- /dev/null
+++ b/drivers/input/rmi4/rmi_f19.c
@@ -0,0 +1,1571 @@
+/*
+ * Copyright (c) 2011 Synaptics Incorporated
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/kernel.h>
+#include <linux/rmi.h>
+#include <linux/input.h>
+#include <linux/slab.h>
+
+#define QUERY_BASE_INDEX 1
+#define MAX_LEN 256
+
+struct f19_0d_query {
+	union {
+		struct {
+			u8 configurable:1;
+			u8 has_sensitivity_adjust:1;
+			u8 has_hysteresis_threshold:1;
+		};
+		u8 f19_0d_query0;
+	};
+	u8 f19_0d_query1:5;
+};
+
+struct f19_0d_control_0 {
+	union {
+		struct {
+			u8 button_usage:2;
+			u8 filter_mode:2;
+		};
+		u8 f19_0d_control0;
+	};
+};
+
+struct f19_0d_control_1 {
+	u8 int_enabled_button;
+};
+
+struct f19_0d_control_2 {
+	u8 single_button;
+};
+
+struct f19_0d_control_3_4 {
+	u8 sensor_map_button:7;
+	/*u8 sensitivity_button;*/
+};
+
+struct f19_0d_control_5 {
+	u8 sensitivity_adj;
+};
+struct f19_0d_control_6 {
+	u8 hysteresis_threshold;
+};
+
+struct f19_0d_control {
+	struct f19_0d_control_0 *general_control;
+	struct f19_0d_control_1 *button_int_enable;
+	struct f19_0d_control_2 *single_button_participation;
+	struct f19_0d_control_3_4 *sensor_map;
+	struct f19_0d_control_5 *all_button_sensitivity_adj;
+	struct f19_0d_control_6 *all_button_hysteresis_threshold;
+};
+/* data specific to fn $19 that needs to be kept around */
+struct f19_data {
+	struct f19_0d_control *button_control;
+	struct f19_0d_query button_query;
+	u8 button_rezero;
+	bool *button_down;
+	unsigned char button_count;
+	unsigned char button_data_buffer_size;
+	unsigned char *button_data_buffer;
+	unsigned char *button_map;
+	char input_name[MAX_LEN];
+	char input_phys[MAX_LEN];
+	struct input_dev *input;
+};
+
+static ssize_t rmi_f19_button_count_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf);
+
+static ssize_t rmi_f19_button_map_show(struct device *dev,
+				      struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_f19_button_map_store(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t count);
+static ssize_t rmi_f19_rezero_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf);
+static ssize_t rmi_f19_rezero_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count);
+static ssize_t rmi_f19_has_hysteresis_threshold_show(struct device *dev,
+				      struct device_attribute *attr, char *buf);
+static ssize_t rmi_f19_has_sensitivity_adjust_show(struct device *dev,
+				      struct device_attribute *attr, char *buf);
+static ssize_t rmi_f19_configurable_show(struct device *dev,
+				      struct device_attribute *attr, char *buf);
+static ssize_t rmi_f19_filter_mode_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf);
+static ssize_t rmi_f19_filter_mode_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count);
+static ssize_t rmi_f19_button_usage_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf);
+static ssize_t rmi_f19_button_usage_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count);
+static ssize_t rmi_f19_interrupt_enable_button_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf);
+static ssize_t rmi_f19_interrupt_enable_button_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count);
+static ssize_t rmi_f19_single_button_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf);
+static ssize_t rmi_f19_single_button_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count);
+static ssize_t rmi_f19_sensor_map_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf);
+static ssize_t rmi_f19_sensor_map_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count);
+static ssize_t rmi_f19_sensitivity_adjust_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf);
+static ssize_t rmi_f19_sensitivity_adjust_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count);
+static ssize_t rmi_f19_hysteresis_threshold_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf);
+static ssize_t rmi_f19_hysteresis_threshold_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count);
+
+
+
+static inline int rmi_f19_alloc_memory(struct rmi_function_container *fc);
+
+static inline void rmi_f19_free_memory(struct rmi_function_container *fc);
+
+static inline int rmi_f19_initialize(struct rmi_function_container *fc);
+
+static inline int rmi_f19_register_device(struct rmi_function_container *fc);
+
+static inline int rmi_f19_create_sysfs(struct rmi_function_container *fc);
+
+static int rmi_f19_config(struct rmi_function_container *fc);
+
+static int rmi_f19_reset(struct rmi_function_container *fc);
+
+static struct device_attribute attrs[] = {
+	__ATTR(button_count, RMI_RO_ATTR,
+		rmi_f19_button_count_show, rmi_store_error),
+	__ATTR(button_map, RMI_RW_ATTR,
+		rmi_f19_button_map_show, rmi_f19_button_map_store),
+	__ATTR(rezero, RMI_RW_ATTR,
+		rmi_f19_rezero_show, rmi_f19_rezero_store),
+	__ATTR(has_hysteresis_threshold, RMI_RO_ATTR,
+		rmi_f19_has_hysteresis_threshold_show, rmi_store_error),
+	__ATTR(has_sensitivity_adjust, RMI_RO_ATTR,
+		rmi_f19_has_sensitivity_adjust_show, rmi_store_error),
+	__ATTR(configurable, RMI_RO_ATTR,
+		rmi_f19_configurable_show, rmi_store_error),
+	__ATTR(filter_mode, RMI_RW_ATTR,
+		rmi_f19_filter_mode_show, rmi_f19_filter_mode_store),
+	__ATTR(button_usage, RMI_RW_ATTR,
+		rmi_f19_button_usage_show, rmi_f19_button_usage_store),
+	__ATTR(interrupt_enable_button, RMI_RW_ATTR,
+		rmi_f19_interrupt_enable_button_show,
+		rmi_f19_interrupt_enable_button_store),
+	__ATTR(single_button, RMI_RW_ATTR,
+		rmi_f19_single_button_show, rmi_f19_single_button_store),
+	__ATTR(sensor_map, RMI_RW_ATTR,
+		rmi_f19_sensor_map_show, rmi_f19_sensor_map_store),
+	__ATTR(sensitivity_adjust, RMI_RW_ATTR,
+		rmi_f19_sensitivity_adjust_show,
+		rmi_f19_sensitivity_adjust_store),
+	__ATTR(hysteresis_threshold, RMI_RW_ATTR,
+		rmi_f19_hysteresis_threshold_show,
+		rmi_f19_hysteresis_threshold_store)
+};
+
+
+int rmi_f19_read_control_parameters(struct rmi_device *rmi_dev,
+	struct f19_0d_control *button_control,
+	unsigned char button_count,
+	unsigned char int_button_enabled_count,
+	u8 ctrl_base_addr)
+{
+	int error = 0;
+	int i;
+
+	if (button_control->general_control) {
+		error = rmi_read_block(rmi_dev, ctrl_base_addr,
+				(u8 *)button_control->general_control,
+				sizeof(struct f19_0d_control_0));
+		if (error < 0) {
+			dev_err(&rmi_dev->dev,
+				"Failed to read f19_0d_control_0, code:"
+				" %d.\n", error);
+			return error;
+		}
+		ctrl_base_addr = ctrl_base_addr +
+				sizeof(struct f19_0d_control_0);
+	}
+
+	if (button_control->button_int_enable) {
+		for (i = 0; i < int_button_enabled_count; i++) {
+			error = rmi_read_block(rmi_dev, ctrl_base_addr,
+				(u8 *)&button_control->button_int_enable[i],
+				sizeof(struct f19_0d_control_1));
+			if (error < 0) {
+				dev_err(&rmi_dev->dev,
+					"Failed to read f19_0d_control_2,"
+					" code: %d.\n", error);
+				return error;
+			}
+			ctrl_base_addr = ctrl_base_addr +
+				sizeof(struct f19_0d_control_1);
+		}
+	}
+
+	if (button_control->single_button_participation) {
+		for (i = 0; i < int_button_enabled_count; i++) {
+			error = rmi_read_block(rmi_dev, ctrl_base_addr,
+					(u8 *)&button_control->
+						single_button_participation[i],
+					sizeof(struct f19_0d_control_2));
+			if (error < 0) {
+				dev_err(&rmi_dev->dev,
+					"Failed to read f19_0d_control_2,"
+					" code: %d.\n", error);
+				return error;
+			}
+			ctrl_base_addr = ctrl_base_addr +
+				sizeof(struct f19_0d_control_2);
+		}
+	}
+
+	if (button_control->sensor_map) {
+		for (i = 0; i < button_count; i++) {
+			error = rmi_read_block(rmi_dev, ctrl_base_addr,
+					(u8 *)&button_control->sensor_map[i],
+					sizeof(struct f19_0d_control_3_4));
+			if (error < 0) {
+				dev_err(&rmi_dev->dev,
+				"Failed to read f19_0d_control_3_4,"
+				" code: %d.\n", error);
+				return error;
+			}
+			ctrl_base_addr = ctrl_base_addr +
+				sizeof(struct f19_0d_control_3_4);
+		}
+	}
+
+	if (button_control->all_button_sensitivity_adj) {
+		error = rmi_read_block(rmi_dev, ctrl_base_addr,
+				(u8 *)button_control->
+					all_button_sensitivity_adj,
+				sizeof(struct f19_0d_control_5));
+		if (error < 0) {
+			dev_err(&rmi_dev->dev,
+				"Failed to read f19_0d_control_5,"
+				" code: %d.\n", error);
+			return error;
+		}
+		ctrl_base_addr = ctrl_base_addr +
+			sizeof(struct f19_0d_control_5);
+	}
+
+	if (button_control->all_button_hysteresis_threshold) {
+		error = rmi_read_block(rmi_dev, ctrl_base_addr,
+				(u8 *)button_control->
+					all_button_hysteresis_threshold,
+				sizeof(struct f19_0d_control_6));
+		if (error < 0) {
+			dev_err(&rmi_dev->dev,
+				"Failed to read f19_0d_control_6,"
+				" code: %d.\n", error);
+			return error;
+		}
+		ctrl_base_addr = ctrl_base_addr +
+			sizeof(struct f19_0d_control_6);
+	}
+	return 0;
+}
+
+
+static int rmi_f19_init(struct rmi_function_container *fc)
+{
+	int rc;
+
+	rc = rmi_f19_alloc_memory(fc);
+	if (rc < 0)
+		goto err_free_data;
+
+	rc = rmi_f19_initialize(fc);
+	if (rc < 0)
+		goto err_free_data;
+
+	rc = rmi_f19_register_device(fc);
+	if (rc < 0)
+		goto err_free_data;
+
+	rc = rmi_f19_create_sysfs(fc);
+	if (rc < 0)
+		goto err_free_data;
+
+	return 0;
+
+err_free_data:
+	rmi_f19_free_memory(fc);
+
+	return rc;
+}
+
+
+static inline int rmi_f19_alloc_memory(struct rmi_function_container *fc)
+{
+	struct f19_data *f19;
+	int rc;
+
+	f19 = kzalloc(sizeof(struct f19_data), GFP_KERNEL);
+	if (!f19) {
+		dev_err(&fc->dev, "Failed to allocate function data.\n");
+		return -ENOMEM;
+	}
+	fc->data = f19;
+
+	rc = rmi_read_block(fc->rmi_dev,
+						fc->fd.query_base_addr,
+						(u8 *)&f19->button_query,
+						sizeof(struct f19_0d_query));
+	if (rc < 0) {
+		dev_err(&fc->dev, "Failed to read query register.\n");
+		return rc;
+	}
+
+	f19->button_count = f19->button_query.f19_0d_query1;
+
+	f19->button_down = kcalloc(f19->button_count,
+			sizeof(bool), GFP_KERNEL);
+	if (!f19->button_down) {
+		dev_err(&fc->dev, "Failed to allocate button state buffer.\n");
+		return -ENOMEM;
+	}
+
+	f19->button_data_buffer_size = (f19->button_count + 7) / 8;
+	f19->button_data_buffer =
+	    kcalloc(f19->button_data_buffer_size,
+		    sizeof(unsigned char), GFP_KERNEL);
+	if (!f19->button_data_buffer) {
+		dev_err(&fc->dev, "Failed to allocate button data buffer.\n");
+		return -ENOMEM;
+	}
+
+	f19->button_map = kcalloc(f19->button_count,
+				sizeof(unsigned char), GFP_KERNEL);
+	if (!f19->button_map) {
+		dev_err(&fc->dev, "Failed to allocate button map.\n");
+		return -ENOMEM;
+	}
+
+	f19->button_control = kzalloc(sizeof(struct f19_0d_control),
+				GFP_KERNEL);
+	if (!f19->button_control) {
+		dev_err(&fc->dev, "Failed to allocate button_control.\n");
+		return -ENOMEM;
+	}
+
+	f19->button_control->general_control =
+		kzalloc(sizeof(struct f19_0d_control_0), GFP_KERNEL);
+	if (!f19->button_control->general_control) {
+		dev_err(&fc->dev, "Failed to allocate"
+				" f19_0d_control_0.\n");
+		return -ENOMEM;
+	}
+
+	f19->button_control->button_int_enable =
+		kzalloc(f19->button_data_buffer_size *
+			sizeof(struct f19_0d_control_2), GFP_KERNEL);
+	if (!f19->button_control->button_int_enable) {
+		dev_err(&fc->dev, "Failed to allocate f19_0d_control_1.\n");
+		return -ENOMEM;
+	}
+
+	f19->button_control->single_button_participation =
+		kzalloc(f19->button_data_buffer_size *
+			sizeof(struct f19_0d_control_2), GFP_KERNEL);
+	if (!f19->button_control->single_button_participation) {
+		dev_err(&fc->dev, "Failed to allocate"
+			" f19_0d_control_2.\n");
+		return -ENOMEM;
+	}
+
+	f19->button_control->sensor_map =
+		kzalloc(f19->button_count *
+			sizeof(struct f19_0d_control_3_4), GFP_KERNEL);
+	if (!f19->button_control->sensor_map) {
+		dev_err(&fc->dev, "Failed to allocate"
+			" f19_0d_control_3_4.\n");
+		return -ENOMEM;
+	}
+
+	f19->button_control->all_button_sensitivity_adj =
+		kzalloc(sizeof(struct f19_0d_control_5), GFP_KERNEL);
+	if (!f19->button_control->all_button_sensitivity_adj) {
+		dev_err(&fc->dev, "Failed to allocate"
+			" f19_0d_control_5.\n");
+		return -ENOMEM;
+	}
+
+	f19->button_control->all_button_hysteresis_threshold =
+		kzalloc(sizeof(struct f19_0d_control_6), GFP_KERNEL);
+	if (!f19->button_control->all_button_hysteresis_threshold) {
+		dev_err(&fc->dev, "Failed to allocate"
+			" f19_0d_control_6.\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+
+
+static inline void rmi_f19_free_memory(struct rmi_function_container *fc)
+{
+	struct f19_data *f19 = fc->data;
+
+	if (f19) {
+		kfree(f19->button_down);
+		kfree(f19->button_data_buffer);
+		kfree(f19->button_map);
+		if (f19->button_control) {
+			kfree(f19->button_control->general_control);
+			kfree(f19->button_control->button_int_enable);
+			kfree(f19->button_control->single_button_participation);
+			kfree(f19->button_control->sensor_map);
+			kfree(f19->button_control->all_button_sensitivity_adj);
+			kfree(f19->button_control->
+				  all_button_hysteresis_threshold);
+			kfree(f19->button_control);
+		}
+		kfree(f19);
+		fc->data = NULL;
+	}
+}
+
+
+static inline int rmi_f19_initialize(struct rmi_function_container *fc)
+{
+	struct rmi_device *rmi_dev = fc->rmi_dev;
+	struct rmi_device_platform_data *pdata;
+	struct f19_data *f19 = fc->data;
+	int i;
+	int rc;
+
+	dev_info(&fc->dev, "Intializing F19 values.");
+
+	/* initial all default values for f19 data here */
+	rc = rmi_read(rmi_dev, fc->fd.command_base_addr,
+		(u8 *)&f19->button_rezero);
+	if (rc < 0) {
+		dev_err(&fc->dev, "Failed to read command register.\n");
+		return rc;
+	}
+	f19->button_rezero = f19->button_rezero & 1;
+
+	pdata = to_rmi_platform_data(rmi_dev);
+	if (pdata) {
+		if (!pdata->button_map) {
+			dev_warn(&fc->dev, "%s - button_map is NULL", __func__);
+		} else if (pdata->button_map->nbuttons != f19->button_count) {
+			dev_warn(&fc->dev,
+				"Platformdata button map size (%d) != number "
+				"of buttons on device (%d) - ignored.\n",
+				pdata->button_map->nbuttons,
+				f19->button_count);
+		} else if (!pdata->button_map->map) {
+			dev_warn(&fc->dev,
+				 "Platformdata button map is missing!\n");
+		} else {
+			for (i = 0; i < pdata->button_map->nbuttons; i++)
+				f19->button_map[i] = pdata->button_map->map[i];
+		}
+	}
+
+	rc = rmi_f19_read_control_parameters(rmi_dev,
+						  f19->button_control,
+						  f19->button_count,
+						  f19->button_data_buffer_size,
+						  fc->fd.control_base_addr);
+	if (rc < 0) {
+		dev_err(&fc->dev,
+			"Failed to initialize F19 control params.\n");
+		return rc;
+	}
+
+	return 0;
+}
+
+
+
+static inline int rmi_f19_register_device(struct rmi_function_container *fc)
+{
+	struct rmi_device *rmi_dev = fc->rmi_dev;
+	struct input_dev *input_dev;
+	struct f19_data *f19 = fc->data;
+	int i;
+	int rc;
+
+	input_dev = input_allocate_device();
+	if (!input_dev) {
+		dev_err(&fc->dev, "Failed to allocate input device.\n");
+		return -ENOMEM;
+	}
+
+	f19->input = input_dev;
+	snprintf(f19->input_name, MAX_LEN, "%sfn%02x", dev_name(&rmi_dev->dev),
+		fc->fd.function_number);
+	input_dev->name = f19->input_name;
+	snprintf(f19->input_phys, MAX_LEN, "%s/input0", input_dev->name);
+	input_dev->phys = f19->input_phys;
+	input_dev->dev.parent = &rmi_dev->dev;
+	input_set_drvdata(input_dev, f19);
+
+	/* Set up any input events. */
+	set_bit(EV_SYN, input_dev->evbit);
+	set_bit(EV_KEY, input_dev->evbit);
+	/* set bits for each button... */
+	for (i = 0; i < f19->button_count; i++)
+		set_bit(f19->button_map[i], input_dev->keybit);
+	rc = input_register_device(input_dev);
+	if (rc < 0) {
+		dev_err(&fc->dev, "Failed to register input device.\n");
+		goto error_free_device;
+	}
+
+	return 0;
+
+error_free_device:
+	input_free_device(input_dev);
+
+	return rc;
+}
+
+
+static inline int rmi_f19_create_sysfs(struct rmi_function_container *fc)
+{
+	int attr_count = 0;
+	int rc;
+
+	dev_dbg(&fc->dev, "Creating sysfs files.\n");
+	/* Set up sysfs device attributes. */
+	for (attr_count = 0; attr_count < ARRAY_SIZE(attrs); attr_count++) {
+		if (sysfs_create_file
+		    (&fc->dev.kobj, &attrs[attr_count].attr) < 0) {
+			dev_err(&fc->dev,
+				"Failed to create sysfs file for %s.",
+				attrs[attr_count].attr.name);
+			rc = -ENODEV;
+			goto err_remove_sysfs;
+		}
+	}
+
+	return 0;
+
+err_remove_sysfs:
+	for (attr_count--; attr_count >= 0; attr_count--)
+		sysfs_remove_file(&fc->dev.kobj,
+						  &attrs[attr_count].attr);
+	return rc;
+
+}
+
+
+
+static int rmi_f19_config(struct rmi_function_container *fc)
+{
+	struct f19_data *data;
+	int retval;
+	int ctrl_base_addr;
+	int button_reg;
+
+	data = fc->data;
+
+	ctrl_base_addr = fc->fd.control_base_addr;
+
+	button_reg = (data->button_count / 7) + 1;
+
+	retval = rmi_write_block(fc->rmi_dev, ctrl_base_addr,
+		(u8 *)data->button_control->general_control,
+			sizeof(struct f19_0d_control_0));
+	if (retval < 0) {
+		dev_err(&fc->dev, "%s : Could not write general_control to 0x%x\n",
+				__func__, fc->fd.control_base_addr);
+		return retval;
+	}
+
+	ctrl_base_addr += sizeof(struct f19_0d_control_0);
+	retval = rmi_write_block(fc->rmi_dev, ctrl_base_addr,
+		(u8 *)data->button_control->button_int_enable,
+			sizeof(struct f19_0d_control_1)*(button_reg + 1));
+	if (retval < 0) {
+		dev_err(&fc->dev, "%s : Could not write interrupt_enable_store"
+			" to 0x%x\n", __func__, ctrl_base_addr);
+		return retval;
+	}
+
+	ctrl_base_addr += sizeof(struct f19_0d_control_2)*(button_reg + 1);
+	retval = rmi_write_block(fc->rmi_dev, ctrl_base_addr,
+		(u8 *)data->button_control->single_button_participation,
+			sizeof(struct f19_0d_control_2)*(button_reg + 1));
+	if (retval < 0) {
+		dev_err(&fc->dev,
+				"%s : Could not write interrupt_enable_store to"
+				" 0x%x\n", __func__, ctrl_base_addr);
+		return -EINVAL;
+	}
+
+	ctrl_base_addr = fc->fd.control_base_addr +
+		sizeof(struct f19_0d_control_0) +
+		sizeof(struct f19_0d_control_1)*button_reg +
+		sizeof(struct f19_0d_control_2)*button_reg;
+	retval = rmi_write_block(fc->rmi_dev, ctrl_base_addr,
+		(u8 *)data->button_control->sensor_map,
+			sizeof(struct f19_0d_control_3_4)*data->button_count);
+	if (retval < 0) {
+		dev_err(&fc->dev, "%s : Could not sensor_map_store to 0x%x\n",
+				__func__, ctrl_base_addr);
+		return -EINVAL;
+	}
+		/* write back to the control register */
+	ctrl_base_addr += sizeof(struct f19_0d_control_3_4)*data->button_count;
+	retval = rmi_write_block(fc->rmi_dev, ctrl_base_addr,
+		(u8 *)data->button_control->all_button_sensitivity_adj,
+			sizeof(struct f19_0d_control_5));
+	if (retval < 0) {
+		dev_err(&fc->dev, "%s : Could not sensitivity_adjust_store to"
+			" 0x%x\n", __func__, ctrl_base_addr);
+		return retval;
+	}
+
+	ctrl_base_addr += sizeof(struct f19_0d_control_5);
+	retval = rmi_write_block(fc->rmi_dev, ctrl_base_addr,
+		(u8 *)data->button_control->all_button_sensitivity_adj,
+			sizeof(struct f19_0d_control_6));
+	if (retval < 0) {
+		dev_err(&fc->dev, "%s : Could not write all_button hysteresis "
+			"threshold to 0x%x\n", __func__, ctrl_base_addr);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+
+static int rmi_f19_reset(struct rmi_function_container *fc)
+{
+	/* we do nnothing here */
+	return 0;
+}
+
+
+static void rmi_f19_remove(struct rmi_function_container *fc)
+{
+	struct f19_data *f19 = fc->data;
+	int attr_count = 0;
+
+	for (attr_count = 0; attr_count < ARRAY_SIZE(attrs); attr_count++)
+		sysfs_remove_file(&fc->dev.kobj,
+				  &attrs[attr_count].attr);
+
+	input_unregister_device(f19->input);
+
+	rmi_f19_free_memory(fc);
+}
+
+int rmi_f19_attention(struct rmi_function_container *fc, u8 *irq_bits)
+{
+	struct rmi_device *rmi_dev = fc->rmi_dev;
+	struct f19_data *f19 = fc->data;
+	u8 data_base_addr = fc->fd.data_base_addr;
+	int error;
+	int button;
+
+	/* Read the button data. */
+
+	error = rmi_read_block(rmi_dev, data_base_addr, f19->button_data_buffer,
+			f19->button_data_buffer_size);
+	if (error < 0) {
+		dev_err(&fc->dev, "%s: Failed to read button data registers.\n",
+			__func__);
+		return error;
+	}
+
+	/* Generate events for buttons that change state. */
+	for (button = 0; button < f19->button_count;
+	     button++) {
+		int button_reg;
+		int button_shift;
+		bool button_status;
+
+		/* determine which data byte the button status is in */
+		button_reg = button / 7;
+		/* bit shift to get button's status */
+		button_shift = button % 8;
+		button_status =
+		    ((f19->button_data_buffer[button_reg] >> button_shift)
+			& 0x01) != 0;
+
+		/* if the button state changed from the last time report it
+		 * and store the new state */
+		if (button_status != f19->button_down[button]) {
+			dev_dbg(&fc->dev, "%s: Button %d (code %d) -> %d.\n",
+				__func__, button, f19->button_map[button],
+				 button_status);
+			/* Generate an event here. */
+			input_report_key(f19->input, f19->button_map[button],
+					 button_status);
+			f19->button_down[button] = button_status;
+		}
+	}
+
+	input_sync(f19->input); /* sync after groups of events */
+	return 0;
+}
+
+static struct rmi_function_handler function_handler = {
+	.func = 0x19,
+	.init = rmi_f19_init,
+	.config = rmi_f19_config,
+	.reset = rmi_f19_reset,
+	.attention = rmi_f19_attention,
+	.remove = rmi_f19_remove
+};
+
+static int __init rmi_f19_module_init(void)
+{
+	int error;
+
+	error = rmi_register_function_driver(&function_handler);
+	if (error < 0) {
+		pr_err("%s: register failed!\n", __func__);
+		return error;
+	}
+
+	return 0;
+}
+
+static void rmi_f19_module_exit(void)
+{
+	rmi_unregister_function_driver(&function_handler);
+}
+
+static ssize_t rmi_f19_filter_mode_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct rmi_function_container *fc;
+	struct f19_data *data;
+
+	fc = to_rmi_function_container(dev);
+	data = fc->data;
+
+	return snprintf(buf, PAGE_SIZE, "%u\n",
+			data->button_control->general_control->filter_mode);
+
+}
+
+static ssize_t rmi_f19_filter_mode_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
+{
+	struct rmi_function_container *fc;
+	struct f19_data *data;
+	unsigned int new_value;
+	int result;
+
+	fc = to_rmi_function_container(dev);
+	data = fc->data;
+	if (sscanf(buf, "%u", &new_value) != 1) {
+		dev_err(dev,
+		"%s: Error - filter_mode_store has an "
+		"invalid len.\n",
+		__func__);
+		return -EINVAL;
+	}
+
+	if (new_value < 0 || new_value > 4) {
+		dev_err(dev, "%s: Error - filter_mode_store has an "
+		"invalid value %d.\n",
+		__func__, new_value);
+		return -EINVAL;
+	}
+	data->button_control->general_control->filter_mode = new_value;
+	result = rmi_write_block(fc->rmi_dev, fc->fd.control_base_addr,
+		(u8 *)data->button_control->general_control,
+			sizeof(struct f19_0d_control_0));
+	if (result < 0) {
+		dev_err(dev, "%s : Could not write filter_mode_store to 0x%x\n",
+				__func__, fc->fd.control_base_addr);
+		return result;
+	}
+
+	return count;
+}
+
+static ssize_t rmi_f19_button_usage_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct rmi_function_container *fc;
+	struct f19_data *data;
+
+	fc = to_rmi_function_container(dev);
+	data = fc->data;
+
+	return snprintf(buf, PAGE_SIZE, "%u\n",
+			data->button_control->general_control->button_usage);
+
+}
+
+static ssize_t rmi_f19_button_usage_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
+{
+	struct rmi_function_container *fc;
+	struct f19_data *data;
+	unsigned int new_value;
+	int result;
+
+	fc = to_rmi_function_container(dev);
+	data = fc->data;
+	if (sscanf(buf, "%u", &new_value) != 1) {
+		dev_err(dev,
+		"%s: Error - button_usage_store has an "
+		"invalid len.\n",
+		__func__);
+		return -EINVAL;
+	}
+
+	if (new_value < 0 || new_value > 4) {
+		dev_err(dev, "%s: Error - button_usage_store has an "
+		"invalid value %d.\n",
+		__func__, new_value);
+		return -EINVAL;
+	}
+	data->button_control->general_control->button_usage = new_value;
+	result = rmi_write_block(fc->rmi_dev, fc->fd.control_base_addr,
+		(u8 *)data->button_control->general_control,
+			sizeof(struct f19_0d_control_0));
+	if (result < 0) {
+		dev_err(dev, "%s: Could not write button_usage_store to 0x%x\n",
+				__func__, fc->fd.control_base_addr);
+		return result;
+	}
+
+	return count;
+
+}
+
+static ssize_t rmi_f19_interrupt_enable_button_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct rmi_function_container *fc;
+	struct f19_data *data;
+	int i, len, total_len = 0;
+	char *current_buf = buf;
+
+	fc = to_rmi_function_container(dev);
+	data = fc->data;
+	/* loop through each button map value and copy its
+	 * string representation into buf */
+	for (i = 0; i < data->button_count; i++) {
+		int button_reg;
+		int button_shift;
+		int interrupt_button;
+
+		button_reg = i / 7;
+		button_shift = i % 8;
+		interrupt_button =
+		    ((data->button_control->
+			button_int_enable[button_reg].int_enabled_button >>
+				button_shift) & 0x01);
+
+		/* get next button mapping value and write it to buf */
+		len = snprintf(current_buf, PAGE_SIZE - total_len,
+			"%u ", interrupt_button);
+		/* bump up ptr to next location in buf if the
+		 * snprintf was valid.  Otherwise issue an error
+		 * and return. */
+		if (len > 0) {
+			current_buf += len;
+			total_len += len;
+		} else {
+			dev_err(dev, "%s: Failed to build interrupt button"
+				" buffer, code = %d.\n", __func__, len);
+			return snprintf(buf, PAGE_SIZE, "unknown\n");
+		}
+	}
+	len = snprintf(current_buf, PAGE_SIZE - total_len, "\n");
+	if (len > 0)
+		total_len += len;
+	else
+		dev_warn(dev, "%s: Failed to append carriage return.\n",
+			 __func__);
+	return total_len;
+
+}
+
+static ssize_t rmi_f19_interrupt_enable_button_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
+{
+	struct rmi_function_container *fc;
+	struct f19_data *data;
+	int i;
+	int button_count = 0;
+	int retval = count;
+	int button_reg = 0;
+	int ctrl_bass_addr;
+
+	fc = to_rmi_function_container(dev);
+	data = fc->data;
+	for (i = 0; i < data->button_count && *buf != 0;
+	     i++) {
+		int button_shift;
+		int button;
+
+		button_reg = i / 7;
+		button_shift = i % 8;
+		/* get next button mapping value and store and bump up to
+		 * point to next item in buf */
+		sscanf(buf, "%u", &button);
+
+		if (button != 0 && button != 1) {
+			dev_err(dev,
+				"%s: Error - interrupt enable button for"
+				" button %d is not a valid value 0x%x.\n",
+				__func__, i, button);
+			return -EINVAL;
+		}
+
+		if (button_shift == 0)
+			data->button_control->button_int_enable[button_reg].
+				int_enabled_button = 0;
+		data->button_control->button_int_enable[button_reg].
+			int_enabled_button |= (button << button_shift);
+		button_count++;
+		/* bump up buf to point to next item to read */
+		while (*buf != 0) {
+			buf++;
+			if (*(buf - 1) == ' ')
+				break;
+		}
+	}
+
+	/* Make sure the button count matches */
+	if (button_count != data->button_count) {
+		dev_err(dev,
+			"%s: Error - interrupt enable button count of %d"
+			" doesn't match device button count of %d.\n",
+			 __func__, button_count, data->button_count);
+		return -EINVAL;
+	}
+
+	/* write back to the control register */
+	ctrl_bass_addr = fc->fd.control_base_addr +
+			sizeof(struct f19_0d_control_0);
+	retval = rmi_write_block(fc->rmi_dev, ctrl_bass_addr,
+		(u8 *)data->button_control->button_int_enable,
+			sizeof(struct f19_0d_control_1)*(button_reg + 1));
+	if (retval < 0) {
+		dev_err(dev, "%s : Could not write interrupt_enable_store"
+			" to 0x%x\n", __func__, ctrl_bass_addr);
+		return retval;
+	}
+
+	return count;
+}
+
+static ssize_t rmi_f19_single_button_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct rmi_function_container *fc;
+	struct f19_data *data;
+	int i, len, total_len = 0;
+	char *current_buf = buf;
+
+	fc = to_rmi_function_container(dev);
+	data = fc->data;
+	/* loop through each button map value and copy its
+	 * string representation into buf */
+	for (i = 0; i < data->button_count; i++) {
+		int button_reg;
+		int button_shift;
+		int single_button;
+
+		button_reg = i / 7;
+		button_shift = i % 8;
+		single_button = ((data->button_control->
+			single_button_participation[button_reg].single_button
+			>> button_shift) & 0x01);
+
+		/* get next button mapping value and write it to buf */
+		len = snprintf(current_buf, PAGE_SIZE - total_len,
+			"%u ", single_button);
+		/* bump up ptr to next location in buf if the
+		 * snprintf was valid.  Otherwise issue an error
+		 * and return. */
+		if (len > 0) {
+			current_buf += len;
+			total_len += len;
+		} else {
+			dev_err(dev, "%s: Failed to build signle button buffer"
+				", code = %d.\n", __func__, len);
+			return snprintf(buf, PAGE_SIZE, "unknown\n");
+		}
+	}
+	len = snprintf(current_buf, PAGE_SIZE - total_len, "\n");
+	if (len > 0)
+		total_len += len;
+	else
+		dev_warn(dev, "%s: Failed to append carriage return.\n",
+			 __func__);
+
+	return total_len;
+
+}
+
+static ssize_t rmi_f19_single_button_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
+{
+	struct rmi_function_container *fc;
+	struct f19_data *data;
+	int i;
+	int button_count = 0;
+	int retval = count;
+	int ctrl_bass_addr;
+	int button_reg = 0;
+
+	fc = to_rmi_function_container(dev);
+	data = fc->data;
+	for (i = 0; i < data->button_count && *buf != 0;
+	     i++) {
+		int button_shift;
+		int button;
+
+		button_reg = i / 7;
+		button_shift = i % 8;
+		/* get next button mapping value and store and bump up to
+		 * point to next item in buf */
+		sscanf(buf, "%u", &button);
+
+		if (button != 0 && button != 1) {
+			dev_err(dev,
+				"%s: Error - single button for button %d"
+				" is not a valid value 0x%x.\n",
+				__func__, i, button);
+			return -EINVAL;
+		}
+		if (button_shift == 0)
+			data->button_control->
+				single_button_participation[button_reg].
+				single_button = 0;
+		data->button_control->single_button_participation[button_reg].
+			single_button |=  (button << button_shift);
+		button_count++;
+		/* bump up buf to point to next item to read */
+		while (*buf != 0) {
+			buf++;
+			if (*(buf - 1) == ' ')
+				break;
+		}
+	}
+
+	/* Make sure the button count matches */
+	if (button_count != data->button_count) {
+		dev_err(dev,
+		    "%s: Error - single button count of %d doesn't match"
+		     " device button count of %d.\n", __func__, button_count,
+		     data->button_count);
+		return -EINVAL;
+	}
+	/* write back to the control register */
+	ctrl_bass_addr = fc->fd.control_base_addr +
+		sizeof(struct f19_0d_control_0) +
+		sizeof(struct f19_0d_control_2)*(button_reg + 1);
+	retval = rmi_write_block(fc->rmi_dev, ctrl_bass_addr,
+		(u8 *)data->button_control->single_button_participation,
+			sizeof(struct f19_0d_control_2)*(button_reg + 1));
+	if (retval < 0) {
+		dev_err(dev, "%s : Could not write interrupt_enable_store to"
+			" 0x%x\n", __func__, ctrl_bass_addr);
+		return -EINVAL;
+	}
+	return count;
+}
+
+static ssize_t rmi_f19_sensor_map_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct rmi_function_container *fc;
+	struct f19_data *data;
+	int i, len, total_len = 0;
+	char *current_buf = buf;
+
+	fc = to_rmi_function_container(dev);
+	data = fc->data;
+
+	for (i = 0; i < data->button_count; i++) {
+		len = snprintf(current_buf, PAGE_SIZE - total_len,
+			"%u ", data->button_control->sensor_map[i].
+			sensor_map_button);
+		/* bump up ptr to next location in buf if the
+		 * snprintf was valid.  Otherwise issue an error
+		 * and return. */
+		if (len > 0) {
+			current_buf += len;
+			total_len += len;
+		} else {
+			dev_err(dev, "%s: Failed to build sensor map buffer, "
+				"code = %d.\n", __func__, len);
+			return snprintf(buf, PAGE_SIZE, "unknown\n");
+		}
+	}
+	len = snprintf(current_buf, PAGE_SIZE - total_len, "\n");
+	if (len > 0)
+		total_len += len;
+	else
+		dev_warn(dev, "%s: Failed to append carriage return.\n",
+			 __func__);
+	return total_len;
+
+
+}
+
+static ssize_t rmi_f19_sensor_map_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
+{
+	struct rmi_function_container *fc;
+	struct f19_data *data;
+	int sensor_map;
+	int i;
+	int retval = count;
+	int button_count = 0;
+	int ctrl_bass_addr;
+	int button_reg;
+	fc = to_rmi_function_container(dev);
+	data = fc->data;
+
+	if (data->button_query.configurable == 0) {
+		dev_err(dev,
+			"%s: Error - sensor map is not configuralbe at"
+			" run-time", __func__);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < data->button_count && *buf != 0; i++) {
+		/* get next button mapping value and store and bump up to
+		 * point to next item in buf */
+		sscanf(buf, "%u", &sensor_map);
+
+		/* Make sure the key is a valid key */
+		if (sensor_map < 0 || sensor_map > 127) {
+			dev_err(dev,
+				"%s: Error - sensor map for button %d is"
+				" not a valid value 0x%x.\n",
+				__func__, i, sensor_map);
+			return -EINVAL;
+		}
+
+		data->button_control->sensor_map[i].sensor_map_button =
+			sensor_map;
+		button_count++;
+
+		/* bump up buf to point to next item to read */
+		while (*buf != 0) {
+			buf++;
+			if (*(buf - 1) == ' ')
+				break;
+		}
+	}
+
+	if (button_count != data->button_count) {
+		dev_err(dev,
+		    "%s: Error - button map count of %d doesn't match device "
+		     "button count of %d.\n", __func__, button_count,
+		     data->button_count);
+		return -EINVAL;
+	}
+
+	/* write back to the control register */
+	button_reg = (button_count / 7) + 1;
+	ctrl_bass_addr = fc->fd.control_base_addr +
+		sizeof(struct f19_0d_control_0) +
+		sizeof(struct f19_0d_control_1)*button_reg +
+		sizeof(struct f19_0d_control_2)*button_reg;
+	retval = rmi_write_block(fc->rmi_dev, ctrl_bass_addr,
+		(u8 *)data->button_control->sensor_map,
+			sizeof(struct f19_0d_control_3_4)*button_count);
+	if (retval < 0) {
+		dev_err(dev, "%s : Could not sensor_map_store to 0x%x\n",
+				__func__, ctrl_bass_addr);
+		return -EINVAL;
+	}
+	return count;
+}
+
+static ssize_t rmi_f19_sensitivity_adjust_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct rmi_function_container *fc;
+	struct f19_data *data;
+
+	fc = to_rmi_function_container(dev);
+	data = fc->data;
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", data->button_control->
+		all_button_sensitivity_adj->sensitivity_adj);
+
+}
+
+static ssize_t rmi_f19_sensitivity_adjust_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
+{
+	struct rmi_function_container *fc;
+	struct f19_data *data;
+	unsigned int new_value;
+	int len;
+	int ctrl_bass_addr;
+	int button_reg;
+
+	fc = to_rmi_function_container(dev);
+
+	data = fc->data;
+
+	if (data->button_query.configurable == 0) {
+		dev_err(dev,
+			"%s: Error - sensitivity_adjust is not"
+			" configuralbe at run-time", __func__);
+		return -EINVAL;
+	}
+
+	len = sscanf(buf, "%u", &new_value);
+	if (new_value < 0 || new_value > 31)
+		return -EINVAL;
+
+	data->button_control->all_button_sensitivity_adj->sensitivity_adj =
+		 new_value;
+	/* write back to the control register */
+	button_reg = (data->button_count / 7) + 1;
+	ctrl_bass_addr = fc->fd.control_base_addr +
+		sizeof(struct f19_0d_control_0) +
+		sizeof(struct f19_0d_control_1)*button_reg +
+		sizeof(struct f19_0d_control_2)*button_reg +
+		sizeof(struct f19_0d_control_3_4)*data->button_count;
+	len = rmi_write_block(fc->rmi_dev, ctrl_bass_addr,
+		(u8 *)data->button_control->all_button_sensitivity_adj,
+			sizeof(struct f19_0d_control_5));
+	if (len < 0) {
+		dev_err(dev, "%s : Could not sensitivity_adjust_store to"
+			" 0x%x\n", __func__, ctrl_bass_addr);
+		return len;
+	}
+
+	return len;
+}
+
+static ssize_t rmi_f19_hysteresis_threshold_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct rmi_function_container *fc;
+	struct f19_data *data;
+
+	fc = to_rmi_function_container(dev);
+	data = fc->data;
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", data->button_control->
+		all_button_hysteresis_threshold->hysteresis_threshold);
+
+}
+static ssize_t rmi_f19_hysteresis_threshold_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
+{
+	struct rmi_function_container *fc;
+	struct f19_data *data;
+	unsigned int new_value;
+	int len;
+	int ctrl_bass_addr;
+	int button_reg;
+
+	fc = to_rmi_function_container(dev);
+	data = fc->data;
+	len = sscanf(buf, "%u", &new_value);
+	if (new_value < 0 || new_value > 15) {
+		dev_err(dev, "%s: Error - hysteresis_threshold_store has an "
+		"invalid value %d.\n",
+		__func__, new_value);
+		return -EINVAL;
+	}
+	data->button_control->all_button_hysteresis_threshold->
+		hysteresis_threshold = new_value;
+	/* write back to the control register */
+	button_reg = (data->button_count / 7) + 1;
+	ctrl_bass_addr = fc->fd.control_base_addr +
+		sizeof(struct f19_0d_control_0) +
+		sizeof(struct f19_0d_control_1)*button_reg +
+		sizeof(struct f19_0d_control_2)*button_reg +
+		sizeof(struct f19_0d_control_3_4)*data->button_count+
+		sizeof(struct f19_0d_control_5);
+	len = rmi_write_block(fc->rmi_dev, ctrl_bass_addr,
+		(u8 *)data->button_control->all_button_sensitivity_adj,
+			sizeof(struct f19_0d_control_6));
+	if (len < 0) {
+		dev_err(dev, "%s : Could not write all_button hysteresis "
+			"threshold to 0x%x\n", __func__, ctrl_bass_addr);
+		return -EINVAL;
+	}
+
+	return count;
+}
+
+static ssize_t rmi_f19_has_hysteresis_threshold_show(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct rmi_function_container *fc;
+	struct f19_data *data;
+
+	fc = to_rmi_function_container(dev);
+	data = fc->data;
+
+	return snprintf(buf, PAGE_SIZE, "%u\n",
+			data->button_query.has_hysteresis_threshold);
+}
+
+static ssize_t rmi_f19_has_sensitivity_adjust_show(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct rmi_function_container *fc;
+	struct f19_data *data;
+
+	fc = to_rmi_function_container(dev);
+	data = fc->data;
+
+	return snprintf(buf, PAGE_SIZE, "%u\n",
+			data->button_query.has_sensitivity_adjust);
+}
+
+static ssize_t rmi_f19_configurable_show(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct rmi_function_container *fc;
+	struct f19_data *data;
+
+	fc = to_rmi_function_container(dev);
+	data = fc->data;
+
+	return snprintf(buf, PAGE_SIZE, "%u\n",
+			data->button_query.configurable);
+}
+
+static ssize_t rmi_f19_rezero_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct rmi_function_container *fc;
+	struct f19_data *data;
+
+	fc = to_rmi_function_container(dev);
+	data = fc->data;
+
+	return snprintf(buf, PAGE_SIZE, "%u\n",
+			data->button_rezero);
+
+}
+
+static ssize_t rmi_f19_rezero_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf,
+					 size_t count)
+{
+	struct rmi_function_container *fc;
+	struct f19_data *data;
+	unsigned int new_value;
+	int len;
+
+	fc = to_rmi_function_container(dev);
+	data = fc->data;
+	len = sscanf(buf, "%u", &new_value);
+	if (new_value != 0 && new_value != 1) {
+		dev_err(dev,
+			"%s: Error - rezero is not a "
+			"valid value 0x%x.\n",
+			__func__, new_value);
+		return -EINVAL;
+	}
+	data->button_rezero = new_value & 1;
+	len = rmi_write(fc->rmi_dev, fc->fd.command_base_addr,
+		data->button_rezero);
+
+	if (len < 0) {
+		dev_err(dev, "%s : Could not write rezero to 0x%x\n",
+				__func__, fc->fd.command_base_addr);
+		return -EINVAL;
+	}
+	return count;
+}
+
+static ssize_t rmi_f19_button_count_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct rmi_function_container *fc;
+	struct f19_data *data;
+
+	fc = to_rmi_function_container(dev);
+	data = fc->data;
+	return snprintf(buf, PAGE_SIZE, "%u\n",
+			data->button_count);
+}
+
+static ssize_t rmi_f19_button_map_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+
+	struct rmi_function_container *fc;
+	struct f19_data *data;
+	int i, len, total_len = 0;
+	char *current_buf = buf;
+
+	fc = to_rmi_function_container(dev);
+	data = fc->data;
+	/* loop through each button map value and copy its
+	 * string representation into buf */
+	for (i = 0; i < data->button_count; i++) {
+		/* get next button mapping value and write it to buf */
+		len = snprintf(current_buf, PAGE_SIZE - total_len,
+			"%u ", data->button_map[i]);
+		/* bump up ptr to next location in buf if the
+		 * snprintf was valid.  Otherwise issue an error
+		 * and return. */
+		if (len > 0) {
+			current_buf += len;
+			total_len += len;
+		} else {
+			dev_err(dev, "%s: Failed to build button map buffer, "
+				"code = %d.\n", __func__, len);
+			return snprintf(buf, PAGE_SIZE, "unknown\n");
+		}
+	}
+	len = snprintf(current_buf, PAGE_SIZE - total_len, "\n");
+	if (len > 0)
+		total_len += len;
+	else
+		dev_warn(dev, "%s: Failed to append carriage return.\n",
+			 __func__);
+	return total_len;
+}
+
+static ssize_t rmi_f19_button_map_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf,
+				size_t count)
+{
+	struct rmi_function_container *fc;
+	struct f19_data *data;
+	unsigned int button;
+	int i;
+	int retval = count;
+	int button_count = 0;
+	unsigned char temp_button_map[KEY_MAX];
+
+	fc = to_rmi_function_container(dev);
+	data = fc->data;
+
+	/* Do validation on the button map data passed in.  Store button
+	 * mappings into a temp buffer and then verify button count and
+	 * data prior to clearing out old button mappings and storing the
+	 * new ones. */
+	for (i = 0; i < data->button_count && *buf != 0;
+	     i++) {
+		/* get next button mapping value and store and bump up to
+		 * point to next item in buf */
+		sscanf(buf, "%u", &button);
+
+		/* Make sure the key is a valid key */
+		if (button > KEY_MAX) {
+			dev_err(dev,
+				"%s: Error - button map for button %d is not a"
+				" valid value 0x%x.\n", __func__, i, button);
+			retval = -EINVAL;
+			goto err_ret;
+		}
+
+		temp_button_map[i] = button;
+		button_count++;
+
+		/* bump up buf to point to next item to read */
+		while (*buf != 0) {
+			buf++;
+			if (*(buf - 1) == ' ')
+				break;
+		}
+	}
+
+	/* Make sure the button count matches */
+	if (button_count != data->button_count) {
+		dev_err(dev,
+		    "%s: Error - button map count of %d doesn't match device "
+		     "button count of %d.\n", __func__, button_count,
+		     data->button_count);
+		retval = -EINVAL;
+		goto err_ret;
+	}
+
+	/* Clear the key bits for the old button map. */
+	for (i = 0; i < button_count; i++)
+		clear_bit(data->button_map[i], data->input->keybit);
+
+	/* Switch to the new map. */
+	memcpy(data->button_map, temp_button_map,
+	       data->button_count);
+
+	/* Loop through the key map and set the key bit for the new mapping. */
+	for (i = 0; i < button_count; i++)
+		set_bit(data->button_map[i], data->input->keybit);
+
+err_ret:
+	return retval;
+}
+
+module_init(rmi_f19_module_init);
+module_exit(rmi_f19_module_exit);
+
+MODULE_AUTHOR("Vivian Ly <vly@synaptics.com>");
+MODULE_DESCRIPTION("RMI F19 module");
+MODULE_LICENSE("GPL");
+

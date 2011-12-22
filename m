Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab1LVCUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 21:20:43 -0500
Received: from [12.239.217.82] ([12.239.217.82]:9459 "EHLO venom.synaptics.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754677Ab1LVCUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 21:20:32 -0500
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
Subject: [RFC PATCH 6/11] input: RMI4 F09 - self test.
Date: Wed, 21 Dec 2011 18:09:57 -0800
Message-Id: <1324519802-23894-7-git-send-email-cheiny@synaptics.com>
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

 drivers/input/rmi4/rmi_f09.c |  411 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 411 insertions(+), 0 deletions(-)

diff --git a/drivers/input/rmi4/rmi_f09.c b/drivers/input/rmi4/rmi_f09.c
new file mode 100644
index 0000000..dd00d8c
--- /dev/null
+++ b/drivers/input/rmi4/rmi_f09.c
@@ -0,0 +1,411 @@
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
+
+/* data specific to fn $09 that needs to be kept around */
+struct f09_query {
+	u8 limit_register_count;
+	union {
+		struct {
+			u8 result_register_count:3;
+			u8 reserved:3;
+			u8 internal_limits:1;
+			u8 host_test_enable:1;
+		};
+		u8 f09_bist_query1;
+	};
+};
+
+struct f09_control {
+	/* test1 */
+	u8 test1_limit_low;
+	u8 test1_limit_high;
+	u8 test1_limit_diff;
+	/* test2 */
+	u8 test2_limit_low;
+	u8 test2_limit_high;
+	u8 test2_limit_diff;
+};
+
+struct f09_data {
+	u8 test_number_control;
+	u8 overall_bist_result;
+	u8 test_result1;
+	u8 test_result2;
+	u8 transmitter_number;
+
+	union {
+		struct {
+			u8 receiver_number:6;
+			u8 limit_failure_code:2;
+		};
+		u8 f09_bist_data2;
+	};
+};
+
+struct f09_cmd {
+	union {
+		struct {
+			u8 run_bist:1;
+		};
+		u8 f09_bist_cmd0;
+	};
+};
+
+struct rmi_fn_09_data {
+	struct f09_query query;
+	signed char status;
+};
+
+
+static ssize_t rmi_f09_status_show(struct device *dev,
+				     struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_f09_status_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count);
+
+static ssize_t rmi_f09_limit_register_count_show(struct device *dev,
+				struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_f09_host_test_enable_show(struct device *dev,
+				struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_f09_host_test_enable_store(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t count);
+
+static ssize_t rmi_f09_internal_limits_show(struct device *dev,
+				struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_f09_result_register_count_show(struct device *dev,
+				struct device_attribute *attr, char *buf);
+
+/*
+static ssize_t rmi_f09_overall_bist_result_show(struct device *dev,
+				struct device_attribute *attr, char *buf);
+
+static ssize_t rmi_f09_overall_bist_result_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count);
+*/
+
+static inline int rmi_f09_alloc_memory(struct rmi_function_container *fc);
+
+static inline void rmi_f09_free_memory(struct rmi_function_container *fc);
+
+static inline int rmi_f09_initialize(struct rmi_function_container *fc);
+
+static int rmi_f09_config(struct rmi_function_container *fc);
+
+static int rmi_f09_reset(struct rmi_function_container *fc);
+
+static inline int rmi_f09_create_sysfs(struct rmi_function_container *fc);
+
+
+static struct device_attribute attrs[] = {
+	__ATTR(status, RMI_RW_ATTR,
+		   rmi_f09_status_show, rmi_f09_status_store),
+	__ATTR(limitRegisterCount, RMI_RO_ATTR,
+	       rmi_f09_limit_register_count_show, rmi_store_error),
+	__ATTR(hostTestEnable, RMI_RW_ATTR,
+	       rmi_f09_host_test_enable_show, rmi_f09_host_test_enable_store),
+	__ATTR(internalLimits, RMI_RO_ATTR,
+	       rmi_f09_internal_limits_show, rmi_store_error),
+	__ATTR(resultRegisterCount, RMI_RO_ATTR,
+	       rmi_f09_result_register_count_show, rmi_store_error),
+};
+
+static int rmi_f09_init(struct rmi_function_container *fc)
+{
+	int rc;
+
+	dev_info(&fc->dev, "Intializing F09 values.");
+
+	rc = rmi_f09_alloc_memory(fc);
+	if (rc < 0)
+		goto error_exit;
+
+	rc = rmi_f09_initialize(fc);
+	if (rc < 0)
+		goto error_exit;
+
+	rc = rmi_f09_create_sysfs(fc);
+	if (rc < 0)
+		goto error_exit;
+
+	return 0;
+
+error_exit:
+	rmi_f09_free_memory(fc);
+
+	return rc;
+}
+
+static inline int rmi_f09_alloc_memory(struct rmi_function_container *fc)
+{
+	struct rmi_fn_09_data *f09;
+
+	f09 = kzalloc(sizeof(struct rmi_fn_09_data), GFP_KERNEL);
+	if (!f09) {
+		dev_err(&fc->dev, "Failed to allocate rmi_fn_09_data.\n");
+		return -ENOMEM;
+	}
+	fc->data = f09;
+
+	return 0;
+}
+
+static inline void rmi_f09_free_memory(struct rmi_function_container *fc)
+{
+	kfree(fc->data);
+	fc->data = NULL;
+}
+
+static inline int rmi_f09_initialize(struct rmi_function_container *fc)
+{
+	struct rmi_device *rmi_dev = fc->rmi_dev;
+	struct rmi_device_platform_data *pdata;
+	struct rmi_fn_09_data *f09 = fc->data;
+	u8 query_base_addr;
+	int rc;
+
+
+	pdata = to_rmi_platform_data(rmi_dev);
+	query_base_addr = fc->fd.query_base_addr;
+
+	/* initial all default values for f09 query here */
+	rc = rmi_read_block(rmi_dev, query_base_addr,
+		(u8 *)&f09->query, sizeof(f09->query));
+	if (rc < 0) {
+		dev_err(&fc->dev, "Failed to read query register."
+			" from 0x%04x\n", query_base_addr);
+		return rc;
+	}
+
+	return 0;
+}
+
+static inline int rmi_f09_create_sysfs(struct rmi_function_container *fc)
+{
+	int attr_count = 0;
+	int rc;
+
+	dev_dbg(&fc->dev, "Creating sysfs files.");
+	/* Set up sysfs device attributes. */
+	for (attr_count = 0; attr_count < ARRAY_SIZE(attrs); attr_count++) {
+		if (sysfs_create_file
+		    (&fc->dev.kobj, &attrs[attr_count].attr) < 0) {
+			dev_err(&fc->dev, "Failed to create sysfs file for %s.",
+			     attrs[attr_count].attr.name);
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
+				  &attrs[attr_count].attr);
+
+	return rc;
+}
+
+static int rmi_f09_config(struct rmi_function_container *fc)
+{
+	/*we do nothing here. instead reset should notify the user.*/
+	return 0;
+}
+
+static int rmi_f09_reset(struct rmi_function_container *fc)
+{
+	struct  rmi_fn_09_data  *instance_data = fc->data;
+
+	instance_data->status = -ECONNRESET;
+
+	return 0;
+}
+
+static void rmi_f09_remove(struct rmi_function_container *fc)
+{
+	int attr_count;
+
+	for (attr_count = 0; attr_count < ARRAY_SIZE(attrs); attr_count++)
+		sysfs_remove_file(&fc->dev.kobj,
+				  &attrs[attr_count].attr);
+
+	rmi_f09_free_memory(fc);
+}
+
+static struct rmi_function_handler function_handler = {
+	.func = 0x09,
+	.init = rmi_f09_init,
+	.config = rmi_f09_config,
+	.reset = rmi_f09_reset,
+	.remove = rmi_f09_remove
+};
+
+static int __init rmi_f09_module_init(void)
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
+static void rmi_f09_module_exit(void)
+{
+	rmi_unregister_function_driver(&function_handler);
+}
+
+static ssize_t rmi_f09_status_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct rmi_function_container *fc;
+	struct rmi_fn_09_data *instance_data;
+
+	fc = to_rmi_function_container(dev);
+	instance_data = fc->data;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", instance_data->status);
+}
+
+static ssize_t rmi_f09_status_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct rmi_function_container *fc;
+	struct rmi_fn_09_data *instance_data;
+
+	fc = to_rmi_function_container(dev);
+	instance_data = fc->data;
+
+	/* any write to status resets 1 */
+	instance_data->status = 0;
+
+	return 0;
+}
+
+static ssize_t rmi_f09_limit_register_count_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct rmi_function_container *fc;
+	struct rmi_fn_09_data *data;
+
+	fc = to_rmi_function_container(dev);
+	data = fc->data;
+	return snprintf(buf, PAGE_SIZE, "%u\n",
+			data->query.limit_register_count);
+}
+
+static ssize_t rmi_f09_host_test_enable_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct rmi_function_container *fc;
+	struct rmi_fn_09_data *data;
+
+	fc = to_rmi_function_container(dev);
+	data = fc->data;
+	return snprintf(buf, PAGE_SIZE, "%u\n",
+			data->query.host_test_enable);
+}
+
+static ssize_t rmi_f09_host_test_enable_store(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t count)
+{
+	struct rmi_function_container *fc;
+	struct rmi_fn_09_data *data;
+	unsigned int new_value;
+	int result;
+
+	fc = to_rmi_function_container(dev);
+	data = fc->data;
+	if (sscanf(buf, "%u", &new_value) != 1) {
+		dev_err(dev,
+			"%s: Error - hostTestEnable has an invalid length.\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	if (new_value < 0 || new_value > 1) {
+		dev_err(dev, "%s: Invalid hostTestEnable bit %s.",
+			__func__, buf);
+		return -EINVAL;
+	}
+	data->query.host_test_enable = new_value;
+	result = rmi_write(fc->rmi_dev, fc->fd.query_base_addr,
+		data->query.host_test_enable);
+	if (result < 0) {
+		dev_err(dev, "%s: Could not write hostTestEnable to 0x%x\n",
+				__func__, fc->fd.query_base_addr);
+		return result;
+	}
+
+	return count;
+
+}
+
+static ssize_t rmi_f09_internal_limits_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct rmi_function_container *fc;
+	struct rmi_fn_09_data *data;
+
+	fc = to_rmi_function_container(dev);
+	data = fc->data;
+	return snprintf(buf, PAGE_SIZE, "%u\n",
+			data->query.internal_limits);
+}
+
+static ssize_t rmi_f09_result_register_count_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct rmi_function_container *fc;
+	struct rmi_fn_09_data *data;
+
+	fc = to_rmi_function_container(dev);
+	data = fc->data;
+	return snprintf(buf, PAGE_SIZE, "%u\n",
+			data->query.result_register_count);
+}
+
+module_init(rmi_f09_module_init);
+module_exit(rmi_f09_module_exit);
+
+MODULE_AUTHOR("Allie Xiong <axiong@Synaptics.com>");
+MODULE_DESCRIPTION("RMI F09 module");
+MODULE_LICENSE("GPL");
+

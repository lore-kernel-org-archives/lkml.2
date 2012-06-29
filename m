Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab2F2Mq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 08:46:57 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:29160 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755045Ab2F2Mqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 08:46:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAHGj7U9bdWOb/2dsb2JhbABFhVqwcoEHghkBBSMECwFGECUCJgICVwcSiA+od5NAgSCPD4ESA5UykAOCYYFUIg
X-IronPort-AV: E=Sophos;i="4.77,498,1336341600"; 
   d="scan'208";a="1011331797"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: cascardo@holoscopio.com, don@syst.com.br, mjg@redhat.com
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH] classmate-laptop: Add support for Classmate V3 accelerometer.
Date: Fri, 29 Jun 2012 14:46:30 +0200
Message-Id: <1340974003-11481-1-git-send-email-magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1340971993.git.magomez@igalia.com>
References: <cover.1340971993.git.magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Classmate V3 laptop includes a new accelerometer that can't be handled by
previous driver. This patch adds a new driver to handle it.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/platform/x86/classmate-laptop.c |  400 ++++++++++++++++++++++++++++++-
 1 file changed, 398 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platform/x86/classmate-laptop.c
index 94f93b6..f8cd3ad 100644
--- a/drivers/platform/x86/classmate-laptop.c
+++ b/drivers/platform/x86/classmate-laptop.c
@@ -31,12 +31,18 @@ MODULE_LICENSE("GPL");
 
 struct cmpc_accel {
 	int sensitivity;
+	int g_select;
+	int inputdev_state;
 };
 
-#define CMPC_ACCEL_SENSITIVITY_DEFAULT		5
+#define CMPC_ACCEL_DEV_STATE_CLOSED	0
+#define CMPC_ACCEL_DEV_STATE_OPEN	1
 
+#define CMPC_ACCEL_SENSITIVITY_DEFAULT		5
+#define CMPC_ACCEL_G_SELECT_DEFAULT		0
 
 #define CMPC_ACCEL_HID		"ACCE0000"
+#define CMPC_ACCEL_HID_V3	"ACCE0001"
 #define CMPC_TABLET_HID		"TBLT0000"
 #define CMPC_IPML_HID	"IPML200"
 #define CMPC_KEYS_HID		"FnBT0000"
@@ -76,7 +82,388 @@ static int cmpc_remove_acpi_notify_device(struct acpi_device *acpi)
 }
 
 /*
- * Accelerometer code.
+ * Accelerometer code for Classmate V3
+ */
+static acpi_status cmpc_start_accel_v3(acpi_handle handle)
+{
+	union acpi_object param[4];
+	struct acpi_object_list input;
+	acpi_status status;
+
+	param[0].type = ACPI_TYPE_INTEGER;
+	param[0].integer.value = 0x3;
+	param[1].type = ACPI_TYPE_INTEGER;
+	param[1].integer.value = 0;
+	param[2].type = ACPI_TYPE_INTEGER;
+	param[2].integer.value = 0;
+	param[3].type = ACPI_TYPE_INTEGER;
+	param[3].integer.value = 0;
+	input.count = 4;
+	input.pointer = param;
+	status = acpi_evaluate_object(handle, "ACMD", &input, NULL);
+	return status;
+}
+
+static acpi_status cmpc_stop_accel_v3(acpi_handle handle)
+{
+	union acpi_object param[4];
+	struct acpi_object_list input;
+	acpi_status status;
+
+	param[0].type = ACPI_TYPE_INTEGER;
+	param[0].integer.value = 0x4;
+	param[1].type = ACPI_TYPE_INTEGER;
+	param[1].integer.value = 0;
+	param[2].type = ACPI_TYPE_INTEGER;
+	param[2].integer.value = 0;
+	param[3].type = ACPI_TYPE_INTEGER;
+	param[3].integer.value = 0;
+	input.count = 4;
+	input.pointer = param;
+	status = acpi_evaluate_object(handle, "ACMD", &input, NULL);
+	return status;
+}
+
+static acpi_status cmpc_accel_set_sensitivity_v3(acpi_handle handle, int val)
+{
+	union acpi_object param[4];
+	struct acpi_object_list input;
+
+	param[0].type = ACPI_TYPE_INTEGER;
+	param[0].integer.value = 0x02;
+	param[1].type = ACPI_TYPE_INTEGER;
+	param[1].integer.value = val;
+	param[2].type = ACPI_TYPE_INTEGER;
+	param[2].integer.value = 0;
+	param[3].type = ACPI_TYPE_INTEGER;
+	param[3].integer.value = 0;
+	input.count = 4;
+	input.pointer = param;
+	return acpi_evaluate_object(handle, "ACMD", &input, NULL);
+}
+
+static acpi_status cmpc_accel_set_g_select_v3(acpi_handle handle, int val)
+{
+	union acpi_object param[4];
+	struct acpi_object_list input;
+
+	param[0].type = ACPI_TYPE_INTEGER;
+	param[0].integer.value = 0x05;
+	param[1].type = ACPI_TYPE_INTEGER;
+	param[1].integer.value = val;
+	param[2].type = ACPI_TYPE_INTEGER;
+	param[2].integer.value = 0;
+	param[3].type = ACPI_TYPE_INTEGER;
+	param[3].integer.value = 0;
+	input.count = 4;
+	input.pointer = param;
+	return acpi_evaluate_object(handle, "ACMD", &input, NULL);
+}
+
+static acpi_status cmpc_get_accel_v3(acpi_handle handle,
+				     int16_t *x,
+				     int16_t *y,
+				     int16_t *z)
+{
+	union acpi_object param[4];
+	struct acpi_object_list input;
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	int16_t *locs;
+	acpi_status status;
+
+	param[0].type = ACPI_TYPE_INTEGER;
+	param[0].integer.value = 0x01;
+	param[1].type = ACPI_TYPE_INTEGER;
+	param[1].integer.value = 0;
+	param[2].type = ACPI_TYPE_INTEGER;
+	param[2].integer.value = 0;
+	param[3].type = ACPI_TYPE_INTEGER;
+	param[3].integer.value = 0;
+	input.count = 4;
+	input.pointer = param;
+	status = acpi_evaluate_object(handle, "ACMD", &input, &output);
+	if (ACPI_SUCCESS(status)) {
+		union acpi_object *obj;
+		obj = output.pointer;
+		locs = (int16_t *) obj->buffer.pointer;
+		*x = locs[0];
+		*y = locs[1];
+		*z = locs[2];
+		kfree(output.pointer);
+	}
+	return status;
+}
+
+static void cmpc_accel_handler_v3(struct acpi_device *dev, u32 event)
+{
+	if (event == 0x81) {
+		int16_t x, y, z;
+		acpi_status status;
+
+		status = cmpc_get_accel_v3(dev->handle, &x, &y, &z);
+		if (ACPI_SUCCESS(status)) {
+			struct input_dev *inputdev = dev_get_drvdata(&dev->dev);
+
+			input_report_abs(inputdev, ABS_X, x);
+			input_report_abs(inputdev, ABS_Y, y);
+			input_report_abs(inputdev, ABS_Z, z);
+			input_sync(inputdev);
+		}
+	}
+}
+
+static ssize_t cmpc_accel_sensitivity_show_v3(struct device *dev,
+					      struct device_attribute *attr,
+					      char *buf)
+{
+	struct acpi_device *acpi;
+	struct input_dev *inputdev;
+	struct cmpc_accel *accel;
+
+	acpi = to_acpi_device(dev);
+	inputdev = dev_get_drvdata(&acpi->dev);
+	accel = dev_get_drvdata(&inputdev->dev);
+
+	return sprintf(buf, "%d\n", accel->sensitivity);
+}
+
+static ssize_t cmpc_accel_sensitivity_store_v3(struct device *dev,
+					       struct device_attribute *attr,
+					       const char *buf, size_t count)
+{
+	struct acpi_device *acpi;
+	struct input_dev *inputdev;
+	struct cmpc_accel *accel;
+	unsigned long sensitivity;
+	int r;
+
+	acpi = to_acpi_device(dev);
+	inputdev = dev_get_drvdata(&acpi->dev);
+	accel = dev_get_drvdata(&inputdev->dev);
+
+	r = kstrtoul(buf, 0, &sensitivity);
+	if (r)
+		return r;
+
+	/* sensitivity must be between 1 and 127 */
+	if (sensitivity < 1 || sensitivity > 127)
+		return -EINVAL;
+
+	accel->sensitivity = sensitivity;
+	cmpc_accel_set_sensitivity_v3(acpi->handle, sensitivity);
+
+	return strnlen(buf, count);
+}
+
+static struct device_attribute cmpc_accel_sensitivity_attr_v3 = {
+	.attr = { .name = "sensitivity", .mode = 0660 },
+	.show = cmpc_accel_sensitivity_show_v3,
+	.store = cmpc_accel_sensitivity_store_v3
+};
+
+static ssize_t cmpc_accel_g_select_show_v3(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct acpi_device *acpi;
+	struct input_dev *inputdev;
+	struct cmpc_accel *accel;
+
+	acpi = to_acpi_device(dev);
+	inputdev = dev_get_drvdata(&acpi->dev);
+	accel = dev_get_drvdata(&inputdev->dev);
+
+	return sprintf(buf, "%d\n", accel->g_select);
+}
+
+static ssize_t cmpc_accel_g_select_store_v3(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t count)
+{
+	struct acpi_device *acpi;
+	struct input_dev *inputdev;
+	struct cmpc_accel *accel;
+	unsigned long g_select;
+	int r;
+
+	acpi = to_acpi_device(dev);
+	inputdev = dev_get_drvdata(&acpi->dev);
+	accel = dev_get_drvdata(&inputdev->dev);
+
+	r = kstrtoul(buf, 0, &g_select);
+	if (r)
+		return r;
+
+	/* 0 means 1.5g, 1 means 6g, everything else is wrong */
+	if (g_select != 0 && g_select != 1)
+		return -EINVAL;
+
+	accel->g_select = g_select;
+	cmpc_accel_set_g_select_v3(acpi->handle, g_select);
+
+	return strnlen(buf, count);
+}
+
+static struct device_attribute cmpc_accel_g_select_attr_v3 = {
+	.attr = { .name = "g_select", .mode = 0660 },
+	.show = cmpc_accel_g_select_show_v3,
+	.store = cmpc_accel_g_select_store_v3
+};
+
+static int cmpc_accel_open_v3(struct input_dev *input)
+{
+	struct acpi_device *acpi;
+	struct cmpc_accel *accel;
+
+	acpi = to_acpi_device(input->dev.parent);
+	accel = dev_get_drvdata(&input->dev);
+
+	cmpc_accel_set_sensitivity_v3(acpi->handle, accel->sensitivity);
+	cmpc_accel_set_g_select_v3(acpi->handle, accel->g_select);
+
+	if (ACPI_SUCCESS(cmpc_start_accel_v3(acpi->handle))) {
+		accel->inputdev_state = CMPC_ACCEL_DEV_STATE_OPEN;
+		return 0;
+	}
+	return -EIO;
+}
+
+static void cmpc_accel_close_v3(struct input_dev *input)
+{
+	struct acpi_device *acpi;
+	struct cmpc_accel *accel;
+
+	acpi = to_acpi_device(input->dev.parent);
+	accel = dev_get_drvdata(&input->dev);
+
+	cmpc_stop_accel_v3(acpi->handle);
+	accel->inputdev_state = CMPC_ACCEL_DEV_STATE_CLOSED;
+}
+
+static void cmpc_accel_idev_init_v3(struct input_dev *inputdev)
+{
+	set_bit(EV_ABS, inputdev->evbit);
+	input_set_abs_params(inputdev, ABS_X, -255, 255, 16, 0);
+	input_set_abs_params(inputdev, ABS_Y, -255, 255, 16, 0);
+	input_set_abs_params(inputdev, ABS_Z, -255, 255, 16, 0);
+	inputdev->open = cmpc_accel_open_v3;
+	inputdev->close = cmpc_accel_close_v3;
+}
+
+static int cmpc_accel_suspend_v3(struct acpi_device *acpi, pm_message_t state)
+{
+	struct input_dev *inputdev;
+	struct cmpc_accel *accel;
+
+	inputdev = dev_get_drvdata(&acpi->dev);
+	accel = dev_get_drvdata(&inputdev->dev);
+
+	if (accel->inputdev_state == CMPC_ACCEL_DEV_STATE_OPEN)
+		return cmpc_stop_accel_v3(acpi->handle);
+
+	return 0;
+}
+
+static int cmpc_accel_resume_v3(struct acpi_device *acpi)
+{
+
+	struct input_dev *inputdev;
+	struct cmpc_accel *accel;
+
+	inputdev = dev_get_drvdata(&acpi->dev);
+	accel = dev_get_drvdata(&inputdev->dev);
+
+	if (accel->inputdev_state == CMPC_ACCEL_DEV_STATE_OPEN) {
+		cmpc_accel_set_sensitivity_v3(acpi->handle, accel->sensitivity);
+		cmpc_accel_set_g_select_v3(acpi->handle, accel->g_select);
+
+		if (ACPI_FAILURE(cmpc_start_accel_v3(acpi->handle)))
+			return -EIO;
+	}
+
+	return 0;
+}
+
+static int cmpc_accel_add_v3(struct acpi_device *acpi)
+{
+	int error;
+	struct input_dev *inputdev;
+	struct cmpc_accel *accel;
+
+	accel = kmalloc(sizeof(*accel), GFP_KERNEL);
+	if (!accel)
+		return -ENOMEM;
+
+	accel->inputdev_state = CMPC_ACCEL_DEV_STATE_CLOSED;
+
+	accel->sensitivity = CMPC_ACCEL_SENSITIVITY_DEFAULT;
+	cmpc_accel_set_sensitivity_v3(acpi->handle, accel->sensitivity);
+
+	error = device_create_file(&acpi->dev, &cmpc_accel_sensitivity_attr_v3);
+	if (error)
+		goto failed_sensitivity;
+
+	accel->g_select = CMPC_ACCEL_G_SELECT_DEFAULT;
+	cmpc_accel_set_g_select_v3(acpi->handle, accel->g_select);
+
+	error = device_create_file(&acpi->dev, &cmpc_accel_g_select_attr_v3);
+	if (error)
+		goto failed_g_select;
+
+	error = cmpc_add_acpi_notify_device(acpi, "cmpc_accel_v3",
+					    cmpc_accel_idev_init_v3);
+	if (error)
+		goto failed_input;
+
+	inputdev = dev_get_drvdata(&acpi->dev);
+	dev_set_drvdata(&inputdev->dev, accel);
+
+	return 0;
+
+failed_input:
+	device_remove_file(&acpi->dev, &cmpc_accel_g_select_attr_v3);
+failed_g_select:
+	device_remove_file(&acpi->dev, &cmpc_accel_sensitivity_attr_v3);
+failed_sensitivity:
+	kfree(accel);
+	return error;
+}
+
+static int cmpc_accel_remove_v3(struct acpi_device *acpi, int type)
+{
+	struct input_dev *inputdev;
+	struct cmpc_accel *accel;
+
+	inputdev = dev_get_drvdata(&acpi->dev);
+	accel = dev_get_drvdata(&inputdev->dev);
+
+	device_remove_file(&acpi->dev, &cmpc_accel_sensitivity_attr_v3);
+	device_remove_file(&acpi->dev, &cmpc_accel_g_select_attr_v3);
+	return cmpc_remove_acpi_notify_device(acpi);
+}
+
+static const struct acpi_device_id cmpc_accel_device_ids_v3[] = {
+	{CMPC_ACCEL_HID_V3, 0},
+	{"", 0}
+};
+
+static struct acpi_driver cmpc_accel_acpi_driver_v3 = {
+	.owner = THIS_MODULE,
+	.name = "cmpc_accel_v3",
+	.class = "cmpc_accel_v3",
+	.ids = cmpc_accel_device_ids_v3,
+	.ops = {
+		.add = cmpc_accel_add_v3,
+		.remove = cmpc_accel_remove_v3,
+		.notify = cmpc_accel_handler_v3,
+		.suspend = cmpc_accel_suspend_v3,
+		.resume = cmpc_accel_resume_v3,
+	}
+};
+
+
+/*
+ * Accelerometer code for classmate V1 and V2
  */
 static acpi_status cmpc_start_accel(acpi_handle handle)
 {
@@ -723,8 +1110,15 @@ static int cmpc_init(void)
 	if (r)
 		goto failed_accel;
 
+	r = acpi_bus_register_driver(&cmpc_accel_acpi_driver_v3);
+	if (r)
+		goto failed_accel_v3;
+
 	return r;
 
+failed_accel_v3:
+	acpi_bus_unregister_driver(&cmpc_accel_acpi_driver);
+
 failed_accel:
 	acpi_bus_unregister_driver(&cmpc_tablet_acpi_driver);
 
@@ -740,6 +1134,7 @@ failed_keys:
 
 static void cmpc_exit(void)
 {
+	acpi_bus_unregister_driver(&cmpc_accel_acpi_driver_v3);
 	acpi_bus_unregister_driver(&cmpc_accel_acpi_driver);
 	acpi_bus_unregister_driver(&cmpc_tablet_acpi_driver);
 	acpi_bus_unregister_driver(&cmpc_ipml_acpi_driver);
@@ -751,6 +1146,7 @@ module_exit(cmpc_exit);
 
 static const struct acpi_device_id cmpc_device_ids[] = {
 	{CMPC_ACCEL_HID, 0},
+	{CMPC_ACCEL_HID_V3, 0},
 	{CMPC_TABLET_HID, 0},
 	{CMPC_IPML_HID, 0},
 	{CMPC_KEYS_HID, 0},
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab3AHNCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 08:02:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:39791 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756287Ab3AHNCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 08:02:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,430,1355126400"; 
   d="scan'208";a="271273142"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-input@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] HID: i2c-hid: add ACPI support
Date: Tue,  8 Jan 2013 15:05:32 +0200
Message-Id: <1357650332-30031-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HID over I2C protocol specification states that when the device is
enumerated from ACPI the HID descriptor address can be obtained by
executing "_DSM" for the device with function 1. Enable this.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/hid/i2c-hid/i2c-hid.c |   73 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 71 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index 9ef22244..b2eebb6 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -34,6 +34,7 @@
 #include <linux/kernel.h>
 #include <linux/hid.h>
 #include <linux/mutex.h>
+#include <linux/acpi.h>
 
 #include <linux/i2c/i2c-hid.h>
 
@@ -810,6 +811,70 @@ static int __devinit i2c_hid_fetch_hid_descriptor(struct i2c_hid *ihid)
 	return 0;
 }
 
+#ifdef CONFIG_ACPI
+static struct i2c_hid_platform_data *
+i2c_hid_acpi_pdata(struct i2c_client *client)
+{
+	static u8 i2c_hid_guid[] = {
+		0xF7, 0xF6, 0xDF, 0x3C, 0x67, 0x42, 0x55, 0x45,
+		0xAD, 0x05, 0xB3, 0x0A, 0x3D, 0x89, 0x38, 0xDE,
+	};
+	struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER, NULL };
+	struct i2c_hid_platform_data *pdata = NULL;
+	union acpi_object params[4], *obj;
+	struct acpi_object_list input;
+	struct acpi_device *adev;
+	acpi_handle handle;
+
+	handle = ACPI_HANDLE(&client->dev);
+	if (!handle || acpi_bus_get_device(handle, &adev))
+		return NULL;
+
+	input.count = ARRAY_SIZE(params);
+	input.pointer = params;
+
+	params[0].type = ACPI_TYPE_BUFFER;
+	params[0].buffer.length = sizeof(i2c_hid_guid);
+	params[0].buffer.pointer = i2c_hid_guid;
+	params[1].type = ACPI_TYPE_INTEGER;
+	params[1].integer.value = 1;
+	params[2].type = ACPI_TYPE_INTEGER;
+	params[2].integer.value = 1; /* HID function */
+	params[3].type = ACPI_TYPE_INTEGER;
+	params[3].integer.value = 0;
+
+	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_DSM", &input, &buf)))
+		return NULL;
+
+	obj = (union acpi_object *)buf.pointer;
+	if (obj->type != ACPI_TYPE_INTEGER)
+		goto fail;
+
+	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		goto fail;
+
+	pdata->hid_descriptor_address = obj->integer.value;
+
+fail:
+	kfree(buf.pointer);
+	return pdata;
+}
+
+static struct acpi_device_id i2c_hid_acpi_match[] = {
+	{"ACPI0C50", 0 },
+	{"PNP0C50", 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(acpi, i2c_hid_acpi_match);
+#else
+static inline struct i2c_hid_platform_data *
+i2c_hid_acpi_pdata(struct i2c_client *client)
+{
+	return NULL;
+}
+#endif
+
 static int __devinit i2c_hid_probe(struct i2c_client *client,
 		const struct i2c_device_id *dev_id)
 {
@@ -822,8 +887,11 @@ static int __devinit i2c_hid_probe(struct i2c_client *client,
 	dbg_hid("HID probe called for i2c 0x%02x\n", client->addr);
 
 	if (!platform_data) {
-		dev_err(&client->dev, "HID register address not provided\n");
-		return -EINVAL;
+		platform_data = i2c_hid_acpi_pdata(client);
+		if (!platform_data) {
+			dev_err(&client->dev, "HID register address not provided\n");
+			return -EINVAL;
+		}
 	}
 
 	if (!client->irq) {
@@ -964,6 +1032,7 @@ static struct i2c_driver i2c_hid_driver = {
 		.name	= "i2c_hid",
 		.owner	= THIS_MODULE,
 		.pm	= &i2c_hid_pm,
+		.acpi_match_table = ACPI_PTR(i2c_hid_acpi_match),
 	},
 
 	.probe		= i2c_hid_probe,
-- 
1.7.10.4


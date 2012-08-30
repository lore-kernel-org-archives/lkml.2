Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab2H3UV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 16:21:58 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:13735 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab2H3UV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 16:21:57 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, bhelgaas@google.com,
        liuj97@gmail.com, isimatu.yasuaki@jp.fujitsu.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [RFC PATCH 1/5] ACPI: Add acpi_lookup_driver() function
Date: Thu, 30 Aug 2012 14:16:02 -0600
Message-Id: <1346357766-14030-2-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1346357766-14030-1-git-send-email-toshi.kani@hp.com>
References: <1346357766-14030-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added acpi_lookup_driver(), which looks up an associated driver
for the notified ACPI device object by walking through the list
of ACPI drivers.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/scan.c     |   65 +++++++++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpi_bus.h |    2 +
 2 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index d1ecca2..d0e0d18 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1630,3 +1630,68 @@ int __init acpi_scan_init(void)
 
 	return result;
 }
+
+static int acpi_match_driver(struct device_driver *drv, void *data)
+{
+	struct acpi_driver *driver = to_acpi_driver(drv);
+	struct acpi_device *device = (struct acpi_device *) data;
+	int ret;
+
+	ret = acpi_match_device_ids(device, driver->ids);
+	if (!ret)
+		device->driver = driver;
+
+	return !ret;
+}
+
+/**
+ * acpi_lookup_driver: Look up a driver for the notified ACPI device
+ * @handle: ACPI handle of the notified device object
+ * @event: Notify event 
+ *
+ * Look up an associated driver for the notified ACPI device object
+ * by walking through the list of ACPI drivers.
+ */
+struct acpi_driver *acpi_lookup_driver(acpi_handle handle, u32 event)
+{
+	struct acpi_device *device;
+	struct acpi_driver *driver = NULL;
+	unsigned long long sta;
+	int type;
+	int ret;
+
+	/* allocate a temporary device object */
+	device = kzalloc(sizeof(struct acpi_device), GFP_KERNEL);
+	if (!device) {
+		pr_err(PREFIX "No memory to allocate a tmp device\n");
+		return NULL;
+	}
+
+	ret = acpi_bus_type_and_status(handle, &type, &sta);
+	if (ret) {
+		pr_err(PREFIX "Failed to get type of device\n");
+		goto out;
+	}
+
+	/* setup this temporary device object */
+	INIT_LIST_HEAD(&device->pnp.ids);
+	device->device_type = type;
+	device->handle = handle;
+	device->parent = acpi_bus_get_parent(handle);
+	device->dev.bus = &acpi_bus_type;
+	device->driver = NULL;
+	STRUCT_TO_INT(device->status) = sta;
+	device->status.present = 1;
+
+	/* set HID to this device object */
+	acpi_device_set_id(device);
+
+	/* lookup a matching driver */
+	(void) bus_for_each_drv(device->dev.bus, NULL,
+					device, acpi_match_driver);
+	driver = device->driver;
+
+out:
+	kfree(device);
+	return driver;
+}
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index bde976e..a773b46 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -345,6 +345,8 @@ extern int unregister_acpi_notifier(struct notifier_block *);
 
 extern int register_acpi_bus_notifier(struct notifier_block *nb);
 extern void unregister_acpi_bus_notifier(struct notifier_block *nb);
+extern struct acpi_driver *acpi_lookup_driver(acpi_handle handle, u32 event);
+
 /*
  * External Functions
  */
-- 
1.7.7.6


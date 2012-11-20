Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab2KTSK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 13:10:27 -0500
Received: from mga03.intel.com ([143.182.124.21]:59001 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab2KTSKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 13:10:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,287,1352102400"; 
   d="scan'208";a="170653166"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org, w.sang@pengutronix.de,
        rafael.j.wysocki@intel.com
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org,
        broonie@opensource.wolfsonmicro.com, khali@linux-fr.org,
        ben-linux@fluff.org, bhelgaas@google.com,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v4 3/3] i2c / ACPI: add ACPI enumeration support
Date: Tue, 20 Nov 2012 20:13:32 +0200
Message-Id: <1353435212-15325-4-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1353435212-15325-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1353407384-26880-1-git-send-email-mika.westerberg@linux.intel.com>
 <1353435212-15325-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI 5 introduced I2cSerialBus resource that makes it possible to enumerate
and configure the I2C slave devices behind the I2C controller. This patch
adds helper functions to support I2C slave enumeration.

An ACPI enabled I2C controller driver only needs to call acpi_i2c_register_devices()
in order to get its slave devices enumerated, created and bound to the
corresponding ACPI handle.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/acpi/Kconfig    |    6 +++
 drivers/acpi/Makefile   |    1 +
 drivers/acpi/acpi_i2c.c |  103 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/i2c/i2c-core.c  |    6 +++
 include/linux/i2c.h     |    9 +++++
 5 files changed, 125 insertions(+)
 create mode 100644 drivers/acpi/acpi_i2c.c

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 119d58d..0300bf6 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -181,6 +181,12 @@ config ACPI_DOCK
 	  This driver supports ACPI-controlled docking stations and removable
 	  drive bays such as the IBM Ultrabay and the Dell Module Bay.
 
+config ACPI_I2C
+	def_tristate I2C
+	depends on I2C
+	help
+	  ACPI I2C enumeration support.
+
 config ACPI_PROCESSOR
 	tristate "Processor"
 	select THERMAL
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 7289828..2a4502b 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -70,6 +70,7 @@ obj-$(CONFIG_ACPI_HED)		+= hed.o
 obj-$(CONFIG_ACPI_EC_DEBUGFS)	+= ec_sys.o
 obj-$(CONFIG_ACPI_CUSTOM_METHOD)+= custom_method.o
 obj-$(CONFIG_ACPI_BGRT)		+= bgrt.o
+obj-$(CONFIG_ACPI_I2C)		+= acpi_i2c.o
 
 # processor has its own "processor." module_param namespace
 processor-y			:= processor_driver.o processor_throttling.o
diff --git a/drivers/acpi/acpi_i2c.c b/drivers/acpi/acpi_i2c.c
new file mode 100644
index 0000000..82045e3
--- /dev/null
+++ b/drivers/acpi/acpi_i2c.c
@@ -0,0 +1,103 @@
+/*
+ * ACPI I2C enumeration support
+ *
+ * Copyright (C) 2012, Intel Corporation
+ * Author: Mika Westerberg <mika.westerberg@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/acpi.h>
+#include <linux/device.h>
+#include <linux/export.h>
+#include <linux/i2c.h>
+#include <linux/ioport.h>
+
+ACPI_MODULE_NAME("i2c");
+
+static int acpi_i2c_add_resource(struct acpi_resource *ares, void *data)
+{
+	struct i2c_board_info *info = data;
+
+	if (ares->type == ACPI_RESOURCE_TYPE_SERIAL_BUS) {
+		struct acpi_resource_i2c_serialbus *sb;
+
+		sb = &ares->data.i2c_serial_bus;
+		if (sb->type == ACPI_RESOURCE_SERIAL_TYPE_I2C) {
+			info->addr = sb->slave_address;
+			if (sb->access_mode == ACPI_I2C_10BIT_MODE)
+				info->flags |= I2C_CLIENT_TEN;
+		}
+	} else if (info->irq < 0) {
+		struct resource r;
+
+		if (acpi_dev_resource_interrupt(ares, 0, &r))
+			info->irq = r.start;
+	}
+
+	/* Tell the ACPI core to skip this resource */
+	return 1;
+}
+
+static acpi_status acpi_i2c_add_device(acpi_handle handle, u32 level,
+				       void *data, void **return_value)
+{
+	struct i2c_adapter *adapter = data;
+	struct list_head resource_list;
+	struct i2c_board_info info;
+	struct acpi_device *adev;
+	int ret;
+
+	if (acpi_bus_get_device(handle, &adev))
+		return AE_OK;
+	if (acpi_bus_get_status(adev) || !adev->status.present)
+		return AE_OK;
+
+	memset(&info, 0, sizeof(info));
+	info.acpi_node.handle = handle;
+	info.irq = -1;
+
+	INIT_LIST_HEAD(&resource_list);
+	ret = acpi_dev_get_resources(adev, &resource_list,
+				     acpi_i2c_add_resource, &info);
+	acpi_dev_free_resource_list(&resource_list);
+
+	if (ret < 0 || !info.addr)
+		return AE_OK;
+
+	strlcpy(info.type, dev_name(&adev->dev), sizeof(info.type));
+	if (!i2c_new_device(adapter, &info)) {
+		dev_err(&adapter->dev,
+			"failed to add I2C device %s from ACPI\n",
+			dev_name(&adev->dev));
+	}
+
+	return AE_OK;
+}
+
+/**
+ * acpi_i2c_register_devices - enumerate I2C slave devices behind adapter
+ * @adapter: pointer to adapter
+ *
+ * Enumerate all I2C slave devices behind this adapter by walking the ACPI
+ * namespace. When a device is found it will be added to the Linux device
+ * model and bound to the corresponding ACPI handle.
+ */
+void acpi_i2c_register_devices(struct i2c_adapter *adapter)
+{
+	acpi_handle handle;
+	acpi_status status;
+
+	handle = ACPI_HANDLE(&adapter->dev);
+	if (!handle)
+		return;
+
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1,
+				     acpi_i2c_add_device, NULL,
+				     adapter, NULL);
+	if (ACPI_FAILURE(status))
+		dev_warn(&adapter->dev, "failed to enumerate I2C slaves\n");
+}
+EXPORT_SYMBOL_GPL(acpi_i2c_register_devices);
diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index a7edf98..e388590 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -39,6 +39,7 @@
 #include <linux/irqflags.h>
 #include <linux/rwsem.h>
 #include <linux/pm_runtime.h>
+#include <linux/acpi.h>
 #include <asm/uaccess.h>
 
 #include "i2c-core.h"
@@ -78,6 +79,10 @@ static int i2c_device_match(struct device *dev, struct device_driver *drv)
 	if (of_driver_match_device(dev, drv))
 		return 1;
 
+	/* Then ACPI style match */
+	if (acpi_driver_match_device(dev, drv))
+		return 1;
+
 	driver = to_i2c_driver(drv);
 	/* match on an id table if there is one */
 	if (driver->id_table)
@@ -539,6 +544,7 @@ i2c_new_device(struct i2c_adapter *adap, struct i2c_board_info const *info)
 	client->dev.bus = &i2c_bus_type;
 	client->dev.type = &i2c_client_type;
 	client->dev.of_node = info->of_node;
+	ACPI_HANDLE_SET(&client->dev, info->acpi_node.handle);
 
 	/* For 10-bit clients, add an arbitrary offset to avoid collisions */
 	dev_set_name(&client->dev, "%d-%04x", i2c_adapter_id(adap),
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 800de22..d0c4db7 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -259,6 +259,7 @@ static inline void i2c_set_clientdata(struct i2c_client *dev, void *data)
  * @platform_data: stored in i2c_client.dev.platform_data
  * @archdata: copied into i2c_client.dev.archdata
  * @of_node: pointer to OpenFirmware device node
+ * @acpi_node: ACPI device node
  * @irq: stored in i2c_client.irq
  *
  * I2C doesn't actually support hardware probing, although controllers and
@@ -279,6 +280,7 @@ struct i2c_board_info {
 	void		*platform_data;
 	struct dev_archdata	*archdata;
 	struct device_node *of_node;
+	struct acpi_dev_node acpi_node;
 	int		irq;
 };
 
@@ -501,4 +503,11 @@ static inline int i2c_adapter_id(struct i2c_adapter *adap)
 			i2c_del_driver)
 
 #endif /* I2C */
+
+#if IS_ENABLED(CONFIG_ACPI_I2C)
+extern void acpi_i2c_register_devices(struct i2c_adapter *adap);
+#else
+static inline void acpi_i2c_register_devices(struct i2c_adapter *adap) {}
+#endif
+
 #endif /* _LINUX_I2C_H */
-- 
1.7.10.4


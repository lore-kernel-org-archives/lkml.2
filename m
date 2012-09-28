Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab2I1Hjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 03:39:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:38680 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276Ab2I1Hjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 03:39:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,499,1344236400"; 
   d="scan'208,223";a="227634450"
Message-ID: <1348818032.10877.325.camel@rui.sh.intel.com>
Subject: [RFC PATCH 5/6] ACPI: Introduce ACPI I2C controller enumeration
 driver
From: Zhang Rui <rui.zhang@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Len, Brown" <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Zhang, Rui" <rui.zhang@intel.com>
Date: Fri, 28 Sep 2012 15:40:32 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6077a62f2865201ab6727ca7d628ee5e43aa57e1 Mon Sep 17 00:00:00 2001
From: Zhang Rui <rui.zhang@intel.com>
Date: Fri, 24 Aug 2012 15:18:25 +0800
Subject: [RFC PATCH 5/6] ACPI: Introduce ACPI I2C controller enumeration
 driver

This driver is able to
1) enumerate I2C controller via ACPI namespace
   and register it as a platform device.
2) enumerate I2C slave devices via ACPI namespace.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/Makefile       |    1 +
 drivers/acpi/i2c_root.c     |  229 +++++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/sysfs.c        |    1 +
 include/acpi/acpi_drivers.h |    1 +
 4 files changed, 232 insertions(+), 0 deletions(-)
 create mode 100644 drivers/acpi/i2c_root.c

diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 4b65608..5b14f05 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -35,6 +35,7 @@ acpi-y				+= scan.o
 acpi-y				+= processor_core.o
 acpi-y				+= ec.o
 acpi-y				+= gpio.o
+acpi-y				+= i2c_root.o
 acpi-$(CONFIG_ACPI_DOCK)	+= dock.o
 acpi-y				+= pci_root.o pci_link.o pci_irq.o pci_bind.o
 acpi-y				+= power.o
diff --git a/drivers/acpi/i2c_root.c b/drivers/acpi/i2c_root.c
new file mode 100644
index 0000000..b9a042b
--- /dev/null
+++ b/drivers/acpi/i2c_root.c
@@ -0,0 +1,229 @@
+/*
+ *  i2c_root.c - ACPI I2C controller Driver ($Revision: 40 $)
+ *
+ *  Copyright (C) 2012 Intel Corp
+ *  Copyright (C) 2012 Zhang Rui <rui.zhang@intel.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/spinlock.h>
+#include <linux/pm.h>
+#include <linux/pm_runtime.h>
+#include <linux/platform_device.h>
+#include <linux/i2c.h>
+#include <linux/acpi.h>
+#include <linux/slab.h>
+#include <acpi/acpi_bus.h>
+#include <acpi/acpi_drivers.h>
+#include <acpi/apei.h>
+
+#define PREFIX "ACPI: "
+
+#define _COMPONENT		ACPI_SPB_COMPONENT
+ACPI_MODULE_NAME("i2c_root");
+#define ACPI_I2C_ROOT_CLASS		"i2c_root"
+#define ACPI_I2C_ROOT_DEVICE_NAME	"I2C Controller"
+
+static int acpi_i2c_root_add(struct acpi_device *device);
+static int acpi_i2c_root_remove(struct acpi_device *device, int type);
+
+static const struct acpi_device_id root_device_ids[] = {
+	{"INT33B1", 0},
+	{"", 0},
+};
+
+MODULE_DEVICE_TABLE(acpi, root_device_ids);
+
+static struct acpi_driver acpi_i2c_root_driver = {
+	.name = "i2c_root",
+	.class = ACPI_I2C_ROOT_CLASS,
+	.ids = root_device_ids,
+	.ops = {
+		.add = acpi_i2c_root_add,
+		.remove = acpi_i2c_root_remove,
+		},
+};
+
+struct acpi_i2c_root {
+	struct acpi_device *device;
+	struct platform_device *pdev;
+	int busnum;
+	int slaves;
+	struct i2c_board_info *info;
+};
+
+static int add_slave(struct acpi_i2c_root *root, struct i2c_board_info *info)
+{
+	struct i2c_board_info *p;
+
+	if (!info)
+		return 0;
+
+	p = kzalloc(sizeof(*p) * (root->slaves + 1), GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	memcpy(p, info, sizeof(*p));
+	if (root->info)
+		memcpy(p + 1, root->info, sizeof(*p) * root->slaves);
+
+	kfree(root->info);
+	root->info = p;
+	root->slaves++;
+	return 0;
+}
+
+static int register_slaves(struct acpi_i2c_root *root)
+{
+	return i2c_register_board_info(root->busnum, root->info, root->slaves);
+}
+
+/*
+ * The i2c info registering call back for each i2c slave device
+ */
+acpi_status __init i2c_enumerate_slave(acpi_handle handle, u32 level,
+				       void *data, void **return_value)
+{
+	int result;
+	acpi_status status;
+	struct acpi_buffer buffer;
+	struct acpi_resource *resource;
+	struct acpi_resource_gpio *gpio;
+	struct acpi_resource_i2c_serialbus *i2c;
+	int i;
+	struct acpi_i2c_root *root = data;
+	struct i2c_board_info info;
+	struct acpi_device *device;
+
+	if (acpi_bus_get_device(handle, &device))
+		return AE_OK;
+
+	status = acpi_get_current_resources(handle, &buffer);
+	if (ACPI_FAILURE(status)) {
+		dev_err(&device->dev, "Failed to get ACPI resources\n");
+		return AE_OK;
+	}
+
+	for (i = 0; i < buffer.length; i += sizeof(struct acpi_resource)) {
+		resource = (struct acpi_resource *)(buffer.pointer + i);
+
+		switch (resource->type) {
+		case ACPI_RESOURCE_TYPE_GPIO:
+			gpio = &resource->data.gpio;
+
+			if (gpio->connection_type == ACPI_RESOURCE_GPIO_TYPE_INT) {
+				result =
+				    acpi_device_get_gpio_irq
+				    (gpio->resource_source.string_ptr,
+				     gpio->pin_table[0], &info.irq);
+				if (result)
+					dev_err(&device->dev,
+						"Failed to get IRQ\n");
+			}
+			break;
+		case ACPI_RESOURCE_TYPE_SERIAL_BUS:
+			i2c = &resource->data.i2c_serial_bus;
+
+			info.addr = i2c->slave_address;
+			break;
+		default:
+			break;
+		}
+	}
+
+	add_slave(root, &info);
+
+	kfree(buffer.pointer);
+	return AE_OK;
+}
+
+static int __devinit acpi_i2c_root_add(struct acpi_device *device)
+{
+	acpi_status status;
+	struct acpi_i2c_root *root;
+	struct resource *resources;
+	int result;
+
+	if (!device->pnp.unique_id) {
+		dev_err(&device->dev,
+			"Unsupported ACPI I2C controller. No UID\n");
+		return -ENODEV;
+	}
+
+	root = kzalloc(sizeof(struct acpi_i2c_root), GFP_KERNEL);
+	if (!root)
+		return -ENOMEM;
+
+	root->device = device;
+
+	kstrtoint(device->pnp.unique_id, 10, &root->busnum);
+
+	/* enumerate I2C controller */
+	root->pdev =
+	    platform_device_alloc(acpi_device_hid(device), root->busnum);
+	if (!root->pdev) {
+		dev_err(&device->dev, "Failed to alloc platform device\n");
+		goto err;
+	}
+
+	result = acpi_get_generic_resources(device, &resources);
+	if (result < 0) {
+		dev_err(&device->dev, "Failed to get resources\n");
+		goto err;
+	}
+
+	platform_device_add_resources(root->pdev, resources, result);
+	platform_device_add(root->pdev);
+
+	/* enumerate I2C slave devices */
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, root->device->handle, 1,
+				     i2c_enumerate_slave, NULL, root, NULL);
+
+	if (ACPI_FAILURE(status)) {
+		dev_err(&root->device->dev, "i2c ACPI namespace walk error!\n");
+		kfree(root);
+		return -ENODEV;
+	}
+
+	register_slaves(root);
+
+	return 0;
+err:
+	kfree(root);
+	return -ENODEV;
+}
+
+static int acpi_i2c_root_remove(struct acpi_device *device, int type)
+{
+	struct acpi_i2c_root *root = acpi_driver_data(device);
+
+	kfree(root->info);
+	kfree(root);
+
+	return 0;
+}
+
+int __init acpi_i2c_root_init(void)
+{
+	return acpi_bus_register_driver(&acpi_i2c_root_driver);
+}
diff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c
index 240a244..0e0c83c 100644
--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -63,6 +63,7 @@ static const struct acpi_dlayer acpi_debug_layers[] = {
 	ACPI_DEBUG_INIT(ACPI_MEMORY_DEVICE_COMPONENT),
 	ACPI_DEBUG_INIT(ACPI_VIDEO_COMPONENT),
 	ACPI_DEBUG_INIT(ACPI_PROCESSOR_COMPONENT),
+	ACPI_DEBUG_INIT(ACPI_SPB_COMPONENT),
 };
 
 static const struct acpi_dlevel acpi_debug_levels[] = {
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index b75a408..499376c 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -49,6 +49,7 @@
 #define ACPI_MEMORY_DEVICE_COMPONENT	0x08000000
 #define ACPI_VIDEO_COMPONENT		0x10000000
 #define ACPI_PROCESSOR_COMPONENT	0x20000000
+#define ACPI_SPB_COMPONENT		0x40000000
 
 /*
  * _HID definitions
-- 
1.7.7.6




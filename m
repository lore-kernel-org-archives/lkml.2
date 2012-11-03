Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab2KCHoV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 03:44:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:19720 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab2KCHoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 03:44:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,704,1344236400"; 
   d="scan'208";a="236669611"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, mathias.nyman@linux.intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org
Subject: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
Date: Sat,  3 Nov 2012 09:46:32 +0200
Message-Id: <1351928793-14375-3-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI 5 introduced SPISerialBus resource that allows us to enumerate and
configure the SPI slave devices behind the SPI controller. This patch adds
support for this to the SPI core.

In addition we bind ACPI nodes to SPI devices. This makes it possible for
the slave drivers to get the ACPI handle for further configuration.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/spi/spi.c |  231 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 230 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 84c2861..de22a6e 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -35,6 +35,7 @@
 #include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
+#include <linux/acpi.h>
 
 static void spidev_release(struct device *dev)
 {
@@ -93,6 +94,10 @@ static int spi_match_device(struct device *dev, struct device_driver *drv)
 	if (of_driver_match_device(dev, drv))
 		return 1;
 
+	/* Then try ACPI */
+	if (acpi_driver_match_device(dev, drv))
+		return 1;
+
 	if (sdrv->id_table)
 		return !!spi_match_id(sdrv->id_table, spi);
 
@@ -888,6 +893,227 @@ static void of_register_spi_devices(struct spi_master *master)
 static void of_register_spi_devices(struct spi_master *master) { }
 #endif
 
+#ifdef CONFIG_ACPI
+struct acpi_spi {
+	acpi_status (*callback)(struct acpi_device *, void *);
+	void *data;
+};
+
+static acpi_status acpi_spi_enumerate_device(acpi_handle handle, u32 level,
+					     void *data, void **return_value)
+{
+	struct acpi_spi *acpi_spi = data;
+	struct acpi_device *adev;
+
+	if (acpi_bus_get_device(handle, &adev))
+		return AE_OK;
+	if (acpi_bus_get_status(adev) || !adev->status.present)
+		return AE_OK;
+
+	return acpi_spi->callback(adev, acpi_spi->data);
+}
+
+static acpi_status acpi_spi_enumerate(acpi_handle handle,
+	acpi_status (*callback)(struct acpi_device *, void *), void *data)
+{
+	struct acpi_spi acpi_spi;
+
+	acpi_spi.callback = callback;
+	acpi_spi.data = data;
+
+	return acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1,
+				   acpi_spi_enumerate_device, NULL,
+				   &acpi_spi, NULL);
+}
+
+struct acpi_spi_device_info {
+	struct spi_device *spi;
+	int triggering;
+	int polarity;
+	int gsi;
+	bool valid;
+};
+
+static acpi_status acpi_spi_add_resources(struct acpi_resource *res, void *data)
+{
+	struct acpi_spi_device_info *info = data;
+	struct acpi_resource_spi_serialbus *sb;
+	struct spi_device *spi = info->spi;
+
+	switch (res->type) {
+	case ACPI_RESOURCE_TYPE_SERIAL_BUS:
+		sb = &res->data.spi_serial_bus;
+		if (sb->type == ACPI_RESOURCE_SERIAL_TYPE_SPI) {
+			spi->chip_select = sb->device_selection;
+			spi->max_speed_hz = sb->connection_speed;
+
+			/* Mode (clock phase/polarity/etc. */
+			if (sb->clock_phase == ACPI_SPI_SECOND_PHASE)
+				spi->mode |= SPI_CPHA;
+			if (sb->clock_polarity == ACPI_SPI_START_HIGH)
+				spi->mode |= SPI_CPOL;
+			if (sb->device_polarity == ACPI_SPI_ACTIVE_HIGH)
+				spi->mode |= SPI_CS_HIGH;
+
+			/*
+			 * The info is valid once we have found the
+			 * SPISerialBus resource.
+			 */
+			info->valid = true;
+		}
+		break;
+
+	case ACPI_RESOURCE_TYPE_IRQ:
+		info->gsi = res->data.irq.interrupts[0];
+		info->triggering = res->data.irq.triggering;
+		info->polarity = res->data.irq.polarity;
+		break;
+
+	case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
+		info->gsi = res->data.extended_irq.interrupts[0];
+		info->triggering = res->data.extended_irq.triggering;
+		info->polarity = res->data.extended_irq.polarity;
+		break;
+	}
+
+	return AE_OK;
+}
+
+static acpi_status acpi_spi_add_device(struct acpi_device *adev, void *data)
+{
+	struct acpi_spi_device_info info;
+	struct spi_master *master = data;
+	struct spi_device *spi;
+	acpi_status status;
+
+	spi = spi_alloc_device(master);
+	if (!spi) {
+		dev_err(&master->dev, "failed to allocate SPI device\n");
+		return AE_ERROR;
+	}
+
+	memset(&info, 0, sizeof(info));
+	info.spi = spi;
+	info.gsi = -1;
+
+	status = acpi_walk_resources(adev->handle, METHOD_NAME__CRS,
+				     acpi_spi_add_resources, &info);
+	if (ACPI_FAILURE(status) || !info.valid)
+		goto fail_put_dev;
+
+	strlcpy(spi->modalias, acpi_device_hid(adev), sizeof(spi->modalias));
+	if (info.gsi >= 0)
+		spi->irq = acpi_register_gsi(&adev->dev, info.gsi,
+					     info.triggering, info.polarity);
+	request_module(spi->modalias);
+	if (spi_add_device(spi)) {
+		dev_err(&master->dev, "failed to add SPI device from ACPI\n");
+		goto fail_unregister_gsi;
+	}
+
+	return AE_OK;
+
+ fail_unregister_gsi:
+	if (info.gsi >= 0)
+		acpi_unregister_gsi(info.gsi);
+ fail_put_dev:
+	spi_dev_put(spi);
+
+	return AE_OK;
+}
+
+static void acpi_register_spi_devices(struct spi_master *master)
+{
+	acpi_status status;
+	acpi_handle handle;
+
+	handle = master->dev.acpi_handle;
+	if (!handle)
+		return;
+
+	status = acpi_spi_enumerate(handle, acpi_spi_add_device, master);
+	if (ACPI_FAILURE(status))
+		dev_warn(&master->dev, "failed to enumerate SPI slaves\n");
+}
+
+struct acpi_spi_find {
+	acpi_handle handle;
+	u16 chip_select;
+	bool found;
+};
+
+static acpi_status acpi_spi_find_child_address(struct acpi_resource *res,
+					       void *data)
+{
+	struct acpi_resource_spi_serialbus *sb;
+	struct acpi_spi_find *spi_find = data;
+
+	if (res->type != ACPI_RESOURCE_TYPE_SERIAL_BUS)
+		return AE_OK;
+
+	sb = &res->data.spi_serial_bus;
+	if (sb->type != ACPI_RESOURCE_SERIAL_TYPE_SPI)
+		return AE_OK;
+
+	if (sb->device_selection == spi_find->chip_select) {
+		spi_find->found = true;
+		return AE_CTRL_TERMINATE;
+	}
+
+	return AE_OK;
+}
+
+static acpi_status acpi_spi_find_child(struct acpi_device *adev, void *data)
+{
+	struct acpi_spi_find *spi_find = data;
+	acpi_status status;
+
+	status = acpi_walk_resources(adev->handle, METHOD_NAME__CRS,
+				     acpi_spi_find_child_address, spi_find);
+	if (ACPI_FAILURE(status) || !spi_find->found)
+		return status;
+
+	spi_find->handle = adev->handle;
+	return AE_CTRL_TERMINATE;
+}
+
+static int acpi_spi_find_device(struct device *dev, acpi_handle *handle)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	struct spi_master *master = spi->master;
+	struct acpi_spi_find spi_find;
+	acpi_handle parent;
+	acpi_status status;
+
+	parent = master->dev.acpi_handle;
+	if (!parent)
+		return -ENODEV;
+
+	memset(&spi_find, 0, sizeof(spi_find));
+	spi_find.chip_select = spi->chip_select;
+
+	status = acpi_spi_enumerate(parent, acpi_spi_find_child, &spi_find);
+	if (ACPI_FAILURE(status) || !spi_find.handle)
+		return -ENODEV;
+
+	*handle = spi_find.handle;
+	return 0;
+}
+
+static struct acpi_bus_type acpi_spi_bus = {
+	.bus = &spi_bus_type,
+	.find_device = acpi_spi_find_device,
+};
+
+static void acpi_spi_bus_register(void)
+{
+	register_acpi_bus_type(&acpi_spi_bus);
+}
+#else
+static inline void acpi_register_spi_devices(struct spi_master *master) {}
+static inline void acpi_spi_bus_register(void) {}
+#endif /* CONFIG_ACPI */
+
 static void spi_master_release(struct device *dev)
 {
 	struct spi_master *master;
@@ -1023,8 +1249,9 @@ int spi_register_master(struct spi_master *master)
 		spi_match_master_to_boardinfo(master, &bi->board_info);
 	mutex_unlock(&board_lock);
 
-	/* Register devices from the device tree */
+	/* Register devices from the device tree and ACPI */
 	of_register_spi_devices(master);
+	acpi_register_spi_devices(master);
 done:
 	return status;
 }
@@ -1550,6 +1777,8 @@ static int __init spi_init(void)
 	status = class_register(&spi_master_class);
 	if (status < 0)
 		goto err2;
+
+	acpi_spi_bus_register();
 	return 0;
 
 err2:
-- 
1.7.10.4


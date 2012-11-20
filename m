Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab2KTSKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 13:10:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:23912 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197Ab2KTSKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 13:10:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,287,1352102400"; 
   d="scan'208";a="251976696"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org, w.sang@pengutronix.de,
        rafael.j.wysocki@intel.com
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org,
        broonie@opensource.wolfsonmicro.com, khali@linux-fr.org,
        ben-linux@fluff.org, bhelgaas@google.com,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v4 2/3] spi / ACPI: add ACPI enumeration support
Date: Tue, 20 Nov 2012 20:13:31 +0200
Message-Id: <1353435212-15325-3-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1353435212-15325-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1353407384-26880-1-git-send-email-mika.westerberg@linux.intel.com>
 <1353435212-15325-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI 5 introduced SPISerialBus resource that allows us to enumerate and
configure the SPI slave devices behind the SPI controller. This patch adds
support for this to the SPI core.

In addition we bind ACPI nodes to SPI devices. This makes it possible for
the slave drivers to get the ACPI handle for further configuration.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi.c |  103 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 102 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 84c2861..1ab0523 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -35,6 +35,8 @@
 #include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
+#include <linux/ioport.h>
+#include <linux/acpi.h>
 
 static void spidev_release(struct device *dev)
 {
@@ -93,6 +95,10 @@ static int spi_match_device(struct device *dev, struct device_driver *drv)
 	if (of_driver_match_device(dev, drv))
 		return 1;
 
+	/* Then try ACPI */
+	if (acpi_driver_match_device(dev, drv))
+		return 1;
+
 	if (sdrv->id_table)
 		return !!spi_match_id(sdrv->id_table, spi);
 
@@ -888,6 +894,100 @@ static void of_register_spi_devices(struct spi_master *master)
 static void of_register_spi_devices(struct spi_master *master) { }
 #endif
 
+#ifdef CONFIG_ACPI
+static int acpi_spi_add_resource(struct acpi_resource *ares, void *data)
+{
+	struct spi_device *spi = data;
+
+	if (ares->type == ACPI_RESOURCE_TYPE_SERIAL_BUS) {
+		struct acpi_resource_spi_serialbus *sb;
+
+		sb = &ares->data.spi_serial_bus;
+		if (sb->type == ACPI_RESOURCE_SERIAL_TYPE_SPI) {
+			spi->chip_select = sb->device_selection;
+			spi->max_speed_hz = sb->connection_speed;
+
+			if (sb->clock_phase == ACPI_SPI_SECOND_PHASE)
+				spi->mode |= SPI_CPHA;
+			if (sb->clock_polarity == ACPI_SPI_START_HIGH)
+				spi->mode |= SPI_CPOL;
+			if (sb->device_polarity == ACPI_SPI_ACTIVE_HIGH)
+				spi->mode |= SPI_CS_HIGH;
+		}
+	} else if (spi->irq < 0) {
+		struct resource r;
+
+		if (acpi_dev_resource_interrupt(ares, 0, &r))
+			spi->irq = r.start;
+	}
+
+	/* Always tell the ACPI core to skip this resource */
+	return 1;
+}
+
+static acpi_status acpi_spi_add_device(acpi_handle handle, u32 level,
+				       void *data, void **return_value)
+{
+	struct spi_master *master = data;
+	struct list_head resource_list;
+	struct acpi_device *adev;
+	struct spi_device *spi;
+	int ret;
+
+	if (acpi_bus_get_device(handle, &adev))
+		return AE_OK;
+	if (acpi_bus_get_status(adev) || !adev->status.present)
+		return AE_OK;
+
+	spi = spi_alloc_device(master);
+	if (!spi) {
+		dev_err(&master->dev, "failed to allocate SPI device for %s\n",
+			dev_name(&adev->dev));
+		return AE_NO_MEMORY;
+	}
+
+	ACPI_HANDLE_SET(&spi->dev, handle);
+	spi->irq = -1;
+
+	INIT_LIST_HEAD(&resource_list);
+	ret = acpi_dev_get_resources(adev, &resource_list,
+				     acpi_spi_add_resource, spi);
+	acpi_dev_free_resource_list(&resource_list);
+
+	if (ret < 0 || !spi->max_speed_hz) {
+		spi_dev_put(spi);
+		return AE_OK;
+	}
+
+	strlcpy(spi->modalias, dev_name(&adev->dev), sizeof(spi->modalias));
+	if (spi_add_device(spi)) {
+		dev_err(&master->dev, "failed to add SPI device %s from ACPI\n",
+			dev_name(&adev->dev));
+		spi_dev_put(spi);
+	}
+
+	return AE_OK;
+}
+
+static void acpi_register_spi_devices(struct spi_master *master)
+{
+	acpi_status status;
+	acpi_handle handle;
+
+	handle = ACPI_HANDLE(&master->dev);
+	if (!handle)
+		return;
+
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1,
+				     acpi_spi_add_device, NULL,
+				     master, NULL);
+	if (ACPI_FAILURE(status))
+		dev_warn(&master->dev, "failed to enumerate SPI slaves\n");
+}
+#else
+static inline void acpi_register_spi_devices(struct spi_master *master) {}
+#endif /* CONFIG_ACPI */
+
 static void spi_master_release(struct device *dev)
 {
 	struct spi_master *master;
@@ -1023,8 +1123,9 @@ int spi_register_master(struct spi_master *master)
 		spi_match_master_to_boardinfo(master, &bi->board_info);
 	mutex_unlock(&board_lock);
 
-	/* Register devices from the device tree */
+	/* Register devices from the device tree and ACPI */
 	of_register_spi_devices(master);
+	acpi_register_spi_devices(master);
 done:
 	return status;
 }
-- 
1.7.10.4


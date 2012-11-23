Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030279Ab2KWIEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 03:04:37 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:24458 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030213Ab2KWIEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 03:04:36 -0500
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Nov 2012 03:04:35 EST
X-RZG-AUTH: :IW0NeWC7b/q2i6W/qstXb1SBUuFnrGohdvpEkce+Ub4+ReKfHD+mCZKG5kA79A==
X-RZG-CLASS-ID: mo05
From: Stefan Roese <sr@denx.de>
To: linux-kernel@vger.kernel.org
Cc: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH] firmware: Add Lattice ECP3 FPGA configuration via SPI
Date: Fri, 23 Nov 2012 08:58:25 +0100
Message-Id: <1353657505-23003-1-git-send-email-sr@denx.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for bitstream configuration (programming /
loading) of the Lattice ECP3 FPGA's via the SPI bus.

Here an example on my custom MPC5200 based board:

$ echo 1 > /sys/class/firmware/lattice-ecp3.0/loading
$ cat fpga_a4m2k.bit > /sys/class/firmware/lattice-ecp3.0/data
$ echo 0 > /sys/class/firmware/lattice-ecp3.0/loading

leads to these messages:

lattice-ecp3 spi32766.0: FPGA Lattice ECP3-35 detected
lattice-ecp3 spi32766.0: Configuring the FPGA...
lattice-ecp3 spi32766.0: FPGA succesfully configured!

Signed-off-by: Stefan Roese <sr@denx.de>
Cc: Ming Lei <ming.lei@canonical.com>
---
 arch/powerpc/Kconfig                   |   2 +
 drivers/firmware/Kconfig               |  11 ++
 drivers/firmware/Makefile              |   1 +
 drivers/firmware/lattice-ecp3-config.c | 254 +++++++++++++++++++++++++++++++++
 4 files changed, 268 insertions(+)
 create mode 100644 drivers/firmware/lattice-ecp3-config.c

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index a902a5c..0c138d2 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -1006,6 +1006,8 @@ source "net/Kconfig"
 
 source "drivers/Kconfig"
 
+source "drivers/firmware/Kconfig"
+
 source "fs/Kconfig"
 
 source "arch/powerpc/sysdev/qe_lib/Kconfig"
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 9b00072..f7f864f 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -145,6 +145,17 @@ config ISCSI_IBFT
 	  detect iSCSI boot parameters dynamically during system boot, say Y.
 	  Otherwise, say N.
 
+config LATTICE_ECP3_CONFIG
+	tristate "Lattice ECP3 FPGA bitstream configuration via SPI module"
+	select FW_LOADER
+	depends on SPI
+	default	n
+	help
+	  This option enables support for bitstream configuration (programming
+	  or loading) of the Lattice ECP3 FPGA family via SPI.
+
+	  If unsure, say N.
+
 source "drivers/firmware/google/Kconfig"
 
 endmenu
diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index 5a7e273..9dadb3f 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -12,5 +12,6 @@ obj-$(CONFIG_DMIID)		+= dmi-id.o
 obj-$(CONFIG_ISCSI_IBFT_FIND)	+= iscsi_ibft_find.o
 obj-$(CONFIG_ISCSI_IBFT)	+= iscsi_ibft.o
 obj-$(CONFIG_FIRMWARE_MEMMAP)	+= memmap.o
+obj-$(CONFIG_LATTICE_ECP3_CONFIG) += lattice-ecp3-config.o
 
 obj-$(CONFIG_GOOGLE_FIRMWARE)	+= google/
diff --git a/drivers/firmware/lattice-ecp3-config.c b/drivers/firmware/lattice-ecp3-config.c
new file mode 100644
index 0000000..213c526
--- /dev/null
+++ b/drivers/firmware/lattice-ecp3-config.c
@@ -0,0 +1,254 @@
+/*
+ * linux/drivers/firmware/lattice-ecp3-config.c
+ *
+ * Copyright (C) 2012 Stefan Roese <sr@denx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/firmware.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/spi/spi.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+
+#define DRIVER_NAME	"lattice-ecp3"
+#define DRIVER_VER	"1.0"
+#define FIRMWARE_NAME	"lattice-ecp3.bit"
+
+/*
+ * The JTAG ID's of the supported FPGA's. The ID is 32bit wide
+ * reversed as noted in the manual.
+ */
+#define ID_ECP3_17	0xc2088080
+#define ID_ECP3_35	0xc2048080
+
+/* FPGA commands */
+#define FPGA_CMD_READ_ID	0x07	/* plus 24 bits */
+#define FPGA_CMD_READ_STATUS	0x09	/* plus 24 bits */
+#define FPGA_CMD_CLEAR		0x70
+#define FPGA_CMD_REFRESH	0x71
+#define FPGA_CMD_WRITE_EN	0x4a	/* plus 2 bits */
+#define FPGA_CMD_WRITE_DIS	0x4f	/* plus 8 bits */
+#define FPGA_CMD_WRITE_INC	0x41	/* plus 0 bits */
+
+/*
+ * The status register is 32bit revered, DONE is bit 17 from the TN1222.pdf
+ * (LatticeECP3 Slave SPI Port User's Guide)
+ */
+#define FPGA_STATUS_DONE	0x00004000
+#define FPGA_STATUS_CLEARED	0x00010000
+
+#define FPGA_CLEAR_TIMEOUT	5000	/* max. 5000ms for FPGA clear */
+#define FPGA_CLEAR_MSLEEP	10
+#define FPGA_CLEAR_LOOP_COUNT	(FPGA_CLEAR_TIMEOUT / FPGA_CLEAR_MSLEEP)
+
+struct ecp3_dev {
+	u32 jedec_id;
+	char *name;
+};
+
+static const struct ecp3_dev ecp3_dev[] = {
+	{
+		.jedec_id = ID_ECP3_17,
+		.name = "Lattice ECP3-17",
+	},
+	{
+		.jedec_id = ID_ECP3_35,
+		.name = "Lattice ECP3-35",
+	},
+};
+static void dev_release(struct device *dev)
+{
+	return;
+}
+
+static struct platform_device pseudo_dev = {
+	.name = DRIVER_NAME,
+	.id   = 0,
+	.num_resources = 0,
+	.dev  = {
+		.release = dev_release,
+	}
+};
+
+static struct device *ecp3_device = &pseudo_dev.dev;
+
+static void firmware_load(const struct firmware *fw, void *context)
+{
+	struct spi_device *spi = (struct spi_device *)context;
+	static u8 *buffer;
+	int ret;
+	u8 txbuf[8];
+	u8 rxbuf[8];
+	int rx_len = 8;
+	int i;
+	u32 jedec_id;
+	u32 status;
+
+	if (fw->size == 0) {
+		dev_err(&spi->dev, "Error: Firmware size is 0!\n");
+		return;
+	}
+
+	if (!buffer) {
+		buffer = devm_kzalloc(&pseudo_dev.dev, fw->size + 8,
+				      GFP_KERNEL);
+		if (!buffer) {
+			dev_err(&spi->dev, "Error: Can't allocate memory!\n");
+			return;
+		}
+	}
+
+	/* Fill dummy data (24 stuffing bits for commands) */
+	txbuf[1] = 0x00;
+	txbuf[2] = 0x00;
+	txbuf[3] = 0x00;
+
+	/* Trying to speak with the FPGA via SPI... */
+	txbuf[0] = FPGA_CMD_READ_ID;
+	ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
+	dev_dbg(&spi->dev, "FPGA JTAG ID=%08x\n", *(u32 *)&rxbuf[4]);
+	jedec_id = *(u32 *)&rxbuf[4];
+
+	for (i = 0; i < ARRAY_SIZE(ecp3_dev); i++) {
+		if (jedec_id == ecp3_dev[i].jedec_id)
+			break;
+	}
+	if (i == ARRAY_SIZE(ecp3_dev)) {
+		dev_err(&spi->dev,
+			"Error: No supported FPGA detected (JEDEC_ID=%08x)!\n",
+			jedec_id);
+		return;
+	}
+
+	dev_info(&spi->dev, "FPGA %s detected\n", ecp3_dev[i].name);
+
+	txbuf[0] = FPGA_CMD_READ_STATUS;
+	ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
+	dev_dbg(&spi->dev, "FPGA Status=%08x\n", *(u32 *)&rxbuf[4]);
+
+	/*
+	 * Insert WRITE_INC command into stream (one SPI frame)
+	 */
+	buffer[0] = FPGA_CMD_WRITE_INC;
+	buffer[1] = 0xff;
+	buffer[2] = 0xff;
+	buffer[3] = 0xff;
+	memcpy(buffer + 4, fw->data, fw->size);
+
+	txbuf[0] = FPGA_CMD_REFRESH;
+	ret = spi_write(spi, txbuf, 4);
+
+	txbuf[0] = FPGA_CMD_WRITE_EN;
+	ret = spi_write(spi, txbuf, 4);
+
+	txbuf[0] = FPGA_CMD_CLEAR;
+	ret = spi_write(spi, txbuf, 4);
+
+	/*
+	 * Wait for FPGA memory to become cleared
+	 */
+	for (i = 0; i < FPGA_CLEAR_LOOP_COUNT; i++) {
+		txbuf[0] = FPGA_CMD_READ_STATUS;
+		ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
+		status = *(u32 *)&rxbuf[4];
+		if (status == FPGA_STATUS_CLEARED)
+			break;
+
+		msleep(FPGA_CLEAR_MSLEEP);
+	}
+
+	if (i == FPGA_CLEAR_LOOP_COUNT) {
+		dev_err(&spi->dev,
+			"Error: Timeout waiting for FPGA to clear (status=%08x)!\n",
+			status);
+		return;
+	}
+
+	dev_info(&spi->dev, "Configuring the FPGA...\n");
+	ret = spi_write(spi, buffer, fw->size + 8);
+
+	txbuf[0] = FPGA_CMD_WRITE_DIS;
+	ret = spi_write(spi, txbuf, 4);
+
+	txbuf[0] = FPGA_CMD_READ_STATUS;
+	ret = spi_write_then_read(spi, txbuf, 8, rxbuf, rx_len);
+	dev_dbg(&spi->dev, "FPGA Status=%08x\n", *(u32 *)&rxbuf[4]);
+	status = *(u32 *)&rxbuf[4];
+
+	/* Check result */
+	if (status & FPGA_STATUS_DONE)
+		dev_info(&spi->dev, "FPGA succesfully configured!\n");
+	else
+		dev_info(&spi->dev, "FPGA not configured (DONE not set)\n");
+
+	/*
+	 * Don't forget to release the firmware again
+	 */
+	release_firmware(fw);
+}
+
+static int __devinit lattice_ecp3_probe(struct spi_device *spi)
+{
+	int err;
+
+	if (platform_device_register(&pseudo_dev))
+		return -ENODEV;
+
+	err = request_firmware_nowait(THIS_MODULE, FW_ACTION_NOHOTPLUG,
+				      FIRMWARE_NAME, ecp3_device,
+				      GFP_KERNEL, spi, firmware_load);
+	if (err) {
+		dev_err(&spi->dev, "Firmware loading failed with %d!\n", err);
+		goto err;
+	}
+
+	dev_info(&spi->dev, "FPGA bitstream configuration driver registered (ver %s)\n",
+		DRIVER_VER);
+
+	return 0;
+
+err:
+	platform_device_unregister(&pseudo_dev);
+
+	return err;
+}
+
+static int __devexit lattice_ecp3_remove(struct spi_device *spi)
+{
+	platform_device_unregister(&pseudo_dev);
+
+	return 0;
+}
+
+static const struct spi_device_id lattice_ecp3_id[] __devinitdata = {
+	{ "ecp3-17", 0 },
+	{ "ecp3-35", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(spi, lattice_ecp3_id);
+
+static struct spi_driver lattice_ecp3_driver = {
+	.driver = {
+		.name = "lattice-ecp3",
+		.owner = THIS_MODULE,
+	},
+	.probe = lattice_ecp3_probe,
+	.remove = __devexit_p(lattice_ecp3_remove),
+	.id_table = lattice_ecp3_id,
+};
+
+module_spi_driver(lattice_ecp3_driver);
+
+MODULE_AUTHOR("Stefan Roese <sr@denx.de>");
+MODULE_DESCRIPTION("Lattice ECP3 FPGA configuration via SPI driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:ecp3");
-- 
1.8.0


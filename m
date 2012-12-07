Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab2LGIHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 03:07:25 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:51901 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab2LGIHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 03:07:17 -0500
X-RZG-AUTH: :IW0NeWC7b/q2i6W/qstXb1SBUuFnrGohdvpEkce+Ub4+ReKfHD+mBj53PiAAaA==
X-RZG-CLASS-ID: mo05
From: Stefan Roese <sr@denx.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v5] misc: Add Lattice ECP3 FPGA configuration via SPI
Date: Fri,  7 Dec 2012 09:06:59 +0100
Message-Id: <1354867619-18522-1-git-send-email-sr@denx.de>
X-Mailer: git-send-email 1.8.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for bitstream configuration (programming /
loading) of the Lattice ECP3 FPGA's via the SPI bus.

Here an example on my custom MPC5200 based board:

$ echo 1 > /sys/class/firmware/spi0.0/loading
$ cat fpga_a4m2k.bit > /sys/class/firmware/spi0.0/data
$ echo 0 > /sys/class/firmware/spi0.0/loading

leads to these messages:

lattice-ecp3 spi0.0: FPGA Lattice ECP3-35 detected
lattice-ecp3 spi0.0: Configuring the FPGA...
lattice-ecp3 spi0.0: FPGA succesfully configured!

Signed-off-by: Stefan Roese <sr@denx.de>
Acked-by: Ming Lei <ming.lei@canonical.com>
Reviewed-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v5:
- Moved to drivers/misc as suggested by Grant
- Removed DRIVER_* macros
- Added Acked-by from Ming Lei
- Added Reviewed-by from Grant Likely

v4:
- Allocate per-device struct to store the completion
  variable unique per device

v3:
- Removed unnecessary goto (return instead)
- Added waiting for completion in remove

v2:
- Moved from drivers/firmware to drivers/spi as suggested by
  Ming Lei
- Removed pseudo device
- Removed static buffer pointer usage

 drivers/misc/Kconfig               |  11 ++
 drivers/misc/Makefile              |   1 +
 drivers/misc/lattice-ecp3-config.c | 243 +++++++++++++++++++++++++++++++++++++
 3 files changed, 255 insertions(+)
 create mode 100644 drivers/misc/lattice-ecp3-config.c

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index b151b7c..50a0840 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -499,6 +499,17 @@ config USB_SWITCH_FSA9480
 	  stereo and mono audio, video, microphone and UART data to use
 	  a common connector port.
 
+config LATTICE_ECP3_CONFIG
+	tristate "Lattice ECP3 FPGA bitstream configuration via SPI"
+	depends on SPI && SYSFS
+	select FW_LOADER
+	default	n
+	help
+	  This option enables support for bitstream configuration (programming
+	  or loading) of the Lattice ECP3 FPGA family via SPI.
+
+	  If unsure, say N.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 2129377..d19d364 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -49,3 +49,4 @@ obj-y				+= carma/
 obj-$(CONFIG_USB_SWITCH_FSA9480) += fsa9480.o
 obj-$(CONFIG_ALTERA_STAPL)	+=altera-stapl/
 obj-$(CONFIG_INTEL_MEI)		+= mei/
+obj-$(CONFIG_LATTICE_ECP3_CONFIG)	+= lattice-ecp3-config.o
diff --git a/drivers/misc/lattice-ecp3-config.c b/drivers/misc/lattice-ecp3-config.c
new file mode 100644
index 0000000..ff3106c
--- /dev/null
+++ b/drivers/misc/lattice-ecp3-config.c
@@ -0,0 +1,243 @@
+/*
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
+struct fpga_data {
+	struct completion fw_loaded;
+};
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
+
+static void firmware_load(const struct firmware *fw, void *context)
+{
+	struct spi_device *spi = (struct spi_device *)context;
+	struct fpga_data *data = dev_get_drvdata(&spi->dev);
+	u8 *buffer;
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
+	buffer = kzalloc(fw->size + 8, GFP_KERNEL);
+	if (!buffer) {
+		dev_err(&spi->dev, "Error: Can't allocate memory!\n");
+		return;
+	}
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
+		kfree(buffer);
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
+
+	kfree(buffer);
+
+	complete(&data->fw_loaded);
+}
+
+static int __devinit lattice_ecp3_probe(struct spi_device *spi)
+{
+	struct fpga_data *data;
+	int err;
+
+	data = devm_kzalloc(&spi->dev, sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		dev_err(&spi->dev, "Memory allocation for fpga_data failed\n");
+		return -ENOMEM;
+	}
+	spi_set_drvdata(spi, data);
+
+	init_completion(&data->fw_loaded);
+	err = request_firmware_nowait(THIS_MODULE, FW_ACTION_NOHOTPLUG,
+				      FIRMWARE_NAME, &spi->dev,
+				      GFP_KERNEL, spi, firmware_load);
+	if (err) {
+		dev_err(&spi->dev, "Firmware loading failed with %d!\n", err);
+		return err;
+	}
+
+	dev_info(&spi->dev, "FPGA bitstream configuration driver registered\n");
+
+	return 0;
+}
+
+static int __devexit lattice_ecp3_remove(struct spi_device *spi)
+{
+	struct fpga_data *data = spi_get_drvdata(spi);
+
+	wait_for_completion(&data->fw_loaded);
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
+MODULE_DESCRIPTION("Lattice ECP3 FPGA configuration via SPI");
+MODULE_LICENSE("GPL");
-- 
1.8.0.1


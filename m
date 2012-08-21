Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830Ab2HUQBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:01:53 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:45957 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751666Ab2HUQBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:01:51 -0400
From: Roland Stigge <stigge@antcom.de>
To: linus.walleij@linaro.org, aletes.xgr@gmail.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        gabriel.fernandez@stericsson.com, lee.jones@linaro.org,
        viresh.kumar@linaro.org, sachin.verma@st.co
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v5 2/2] spi/pl022: Add devicetree support
Date: Tue, 21 Aug 2012 18:01:25 +0200
Message-Id: <1345564885-11970-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree support to the spi-pl022 driver.

Based on the initial patch by Alexandre Pereira da Silva <aletes.xgr@gmail.com>

Signed-off-by: Roland Stigge <stigge@antcom.de>
---

 Documentation/devicetree/bindings/spi/spi_pl022.txt |   15 +++
 drivers/spi/spi-pl022.c                             |   79 +++++++++++++++++---
 2 files changed, 85 insertions(+), 9 deletions(-)

--- linux-2.6.orig/Documentation/devicetree/bindings/spi/spi_pl022.txt
+++ linux-2.6/Documentation/devicetree/bindings/spi/spi_pl022.txt
@@ -6,7 +6,22 @@ Required properties:
 - interrupts : Should contain SPI controller interrupt
 
 Optional properties:
+- num-cs : total number of chipselects
 - cs-gpios : should specify GPIOs used for chipselects.
   The gpios will be referred to as reg = <index> in the SPI child nodes.
   If unspecified, a single SPI device without a chip select can be used.
 
+SPI slave nodes must be children of the SPI master node and can
+contain the following properties.
+
+- pl022,interface : interface type:
+	0: SPI
+	1: Texas Instruments Synchronous Serial Frame Format
+	2: Microwire (Half Duplex)
+- pl022,com-mode : polling, interrupt or dma
+- pl022,rx-level-trig : Rx FIFO watermark level
+- pl022,tx-level-trig : Tx FIFO watermark level
+- pl022,ctrl-len : Microwire interface: Control length
+- pl022,wait-state : Microwire interface: Wait state
+- pl022,duplex : Microwire interface: Full/Half duplex
+
--- linux-2.6.orig/drivers/spi/spi-pl022.c
+++ linux-2.6/drivers/spi/spi-pl022.c
@@ -41,6 +41,7 @@
 #include <linux/scatterlist.h>
 #include <linux/pm_runtime.h>
 #include <linux/gpio.h>
+#include <linux/of_gpio.h>
 
 /*
  * This macro is used to define some register default values.
@@ -1778,12 +1779,14 @@ static const struct pl022_config_chip pl
 static int pl022_setup(struct spi_device *spi)
 {
 	struct pl022_config_chip const *chip_info;
+	struct pl022_config_chip chip_info_dt;
 	struct chip_data *chip;
 	struct ssp_clock_params clk_freq = { .cpsdvsr = 0, .scr = 0};
 	int status = 0;
 	struct pl022 *pl022 = spi_master_get_devdata(spi->master);
 	unsigned int bits = spi->bits_per_word;
 	u32 tmp;
+	struct device_node *np = spi->dev.of_node;
 
 	if (!spi->max_speed_hz)
 		return -EINVAL;
@@ -1806,10 +1809,32 @@ static int pl022_setup(struct spi_device
 	chip_info = spi->controller_data;
 
 	if (chip_info == NULL) {
-		chip_info = &pl022_default_chip_info;
-		/* spi_board_info.controller_data not is supplied */
-		dev_dbg(&spi->dev,
-			"using default controller_data settings\n");
+		if (np) {
+			chip_info_dt = pl022_default_chip_info;
+
+			chip_info_dt.hierarchy = SSP_MASTER;
+			of_property_read_u32(np, "pl022,interface",
+				&chip_info_dt.iface);
+			of_property_read_u32(np, "pl022,com-mode",
+				&chip_info_dt.com_mode);
+			of_property_read_u32(np, "pl022,rx-level-trig",
+				&chip_info_dt.rx_lev_trig);
+			of_property_read_u32(np, "pl022,tx-level-trig",
+				&chip_info_dt.tx_lev_trig);
+			of_property_read_u32(np, "pl022,ctrl-len",
+				&chip_info_dt.ctrl_len);
+			of_property_read_u32(np, "pl022,wait-state",
+				&chip_info_dt.wait_state);
+			of_property_read_u32(np, "pl022,duplex",
+				&chip_info_dt.duplex);
+
+			chip_info = &chip_info_dt;
+		} else {
+			chip_info = &pl022_default_chip_info;
+			/* spi_board_info.controller_data not is supplied */
+			dev_dbg(&spi->dev,
+				"using default controller_data settings\n");
+		}
 	} else
 		dev_dbg(&spi->dev,
 			"using user supplied controller_data settings\n");
@@ -2006,7 +2031,8 @@ pl022_probe(struct amba_device *adev, co
 	struct pl022_ssp_controller *platform_info = adev->dev.platform_data;
 	struct spi_master *master;
 	struct pl022 *pl022 = NULL;	/*Data for this driver */
-	int status = 0, i;
+	struct device_node *np = adev->dev.of_node;
+	int status = 0, i, num_cs;
 
 	dev_info(&adev->dev,
 		 "ARM PL022 driver, device ID: 0x%08x\n", adev->periphid);
@@ -2016,9 +2042,19 @@ pl022_probe(struct amba_device *adev, co
 		goto err_no_pdata;
 	}
 
+	if (platform_info->num_chipselect) {
+		num_cs = platform_info->num_chipselect;
+	} else if (IS_ENABLED(CONFIG_OF)) {
+		of_property_read_u32(np, "num-cs", &num_cs);
+	} else {
+		dev_err(&adev->dev, "probe: no chip select defined\n");
+		status = -ENODEV;
+		goto err_no_pdata;
+	}
+
 	/* Allocate master with space for data */
 	master = spi_alloc_master(dev, sizeof(struct pl022) + sizeof(int) *
-				  platform_info->num_chipselect);
+				  num_cs);
 	if (master == NULL) {
 		dev_err(&adev->dev, "probe - cannot alloc SPI master\n");
 		status = -ENOMEM;
@@ -2037,17 +2073,41 @@ pl022_probe(struct amba_device *adev, co
 	 * on this board
 	 */
 	master->bus_num = platform_info->bus_id;
-	master->num_chipselect = platform_info->num_chipselect;
+	master->num_chipselect = num_cs;
 	master->cleanup = pl022_cleanup;
 	master->setup = pl022_setup;
 	master->prepare_transfer_hardware = pl022_prepare_transfer_hardware;
 	master->transfer_one_message = pl022_transfer_one_message;
 	master->unprepare_transfer_hardware = pl022_unprepare_transfer_hardware;
 	master->rt = platform_info->rt;
+	master->dev.of_node = dev->of_node;
 
-	if (platform_info->num_chipselect && platform_info->chipselects)
-		for (i = 0; i < platform_info->num_chipselect; i++)
+	if (platform_info->num_chipselect && platform_info->chipselects) {
+		for (i = 0; i < num_cs; i++)
 			pl022->chipselect[i] = platform_info->chipselects[i];
+	} else if (IS_ENABLED(CONFIG_OF)) {
+		for (i = 0; i < num_cs; i++) {
+			int cs_gpio = of_get_named_gpio(np, "cs-gpios", i);
+
+			if (cs_gpio == -EPROBE_DEFER) {
+				status = -EPROBE_DEFER;
+				goto err_no_gpio;
+			}
+
+			pl022->chipselect[i] = cs_gpio;
+
+			if (gpio_is_valid(cs_gpio)) {
+				if (gpio_request(cs_gpio, "ssp-pl022"))
+					dev_err(&adev->dev,
+						"could not request %d gpio\n",
+						cs_gpio);
+				else if (gpio_direction_output(cs_gpio, 1))
+					dev_err(&adev->dev,
+						"could set gpio %d as output\n",
+						cs_gpio);
+			}
+		}
+	}
 
 	/*
 	 * Supports mode 0-3, loopback, and active low CS. Transfers are
@@ -2157,6 +2217,7 @@ pl022_probe(struct amba_device *adev, co
  err_no_ioremap:
 	amba_release_regions(adev);
  err_no_ioregion:
+ err_no_gpio:
 	spi_master_put(master);
  err_no_master:
  err_no_pdata:

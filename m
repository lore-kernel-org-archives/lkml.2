Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab2FYVGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 17:06:33 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:61711 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757461Ab2FYVGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 17:06:30 -0400
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: [PATCH v2] spi/pl022: add devicetree support
Date: Mon, 25 Jun 2012 18:06:28 -0300
Message-Id: <1340658390-29569-1-git-send-email-aletes.xgr@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the chipselect array and cur_cs properties to pl022 main structure

Add a wrapper function to decide if the cs should be controlled by the
cs_control callback or the chipselect gpio

Populate chipselect property from cs-gpios

Populate master->dev.of_node, so the spi bus can find child spi
devices and register them

At pl022 setup, fill chip_data structure from dt nodes, if not provided
by platform.

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Tested-by: Roland Stigge <stigge@antcom.de>
---
Applies to v3.5-rc4

Changes since v1:
return EPROBE_DEFFER if gpios are not initialized yet

 .../devicetree/bindings/spi/spi_pl022.txt          |   15 +++
 drivers/spi/spi-pl022.c                            |  117 ++++++++++++++++----
 2 files changed, 112 insertions(+), 20 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/spi_pl022.txt b/Documentation/devicetree/bindings/spi/spi_pl022.txt
index 306ec3f..b089ec7 100644
--- a/Documentation/devicetree/bindings/spi/spi_pl022.txt
+++ b/Documentation/devicetree/bindings/spi/spi_pl022.txt
@@ -6,7 +6,22 @@ Required properties:
 - interrupts : Should contain SPI controller interrupt
 
 Optional properties:
+- pl022,num-chipselects : total number of chipselects
 - cs-gpios : should specify GPIOs used for chipselects.
   The gpios will be referred to as reg = <index> in the SPI child nodes.
   If unspecified, a single SPI device without a chip select can be used.
 
+SPI slave nodes must be children of the SPI master node and can
+contain the following properties.
+See include/linux/amba/pl022.h for more details
+
+- pl022,hierarchy : master or slave interface
+- pl022,interface : interface type
+- pl022,slave-tx-disable : disconnect tx line in slave mode
+- pl022,com-mode : polling, interrupt or dma
+- pl022,rx-level-trig : Rx FIFO watermark level
+- pl022,tx-level-trig : Tx FIFO watermark level
+- pl022,ctrl-len : Microwire interface: Control length
+- pl022,wait-state : Microwire interface: Wait state
+- pl022,duplex : Microwire interface: Full/Half duplex
+
diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index 400ae21..f33e3fa 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -40,6 +40,8 @@
 #include <linux/dma-mapping.h>
 #include <linux/scatterlist.h>
 #include <linux/pm_runtime.h>
+#include <linux/gpio.h>
+#include <linux/of_gpio.h>
 
 /*
  * This macro is used to define some register default values.
@@ -389,6 +391,8 @@ struct pl022 {
 	char				*dummypage;
 	bool				dma_running;
 #endif
+	int cur_cs;
+	int chipselect[0];
 };
 
 /**
@@ -433,6 +437,14 @@ static void null_cs_control(u32 command)
 	pr_debug("pl022: dummy chip select control, CS=0x%x\n", command);
 }
 
+static void pl022_cs_control(struct pl022 *pl022, u32 command)
+{
+	if (gpio_is_valid(pl022->cur_cs))
+		gpio_set_value(pl022->cur_cs, command);
+	else
+		pl022->cur_chip->cs_control(command);
+}
+
 /**
  * giveback - current spi_message is over, schedule next message and call
  * callback of this message. Assumes that caller already
@@ -479,7 +491,7 @@ static void giveback(struct pl022 *pl022)
 		if (next_msg && next_msg->spi != pl022->cur_msg->spi)
 			next_msg = NULL;
 		if (!next_msg || pl022->cur_msg->state == STATE_ERROR)
-			pl022->cur_chip->cs_control(SSP_CHIP_DESELECT);
+			pl022_cs_control(pl022, SSP_CHIP_DESELECT);
 		else
 			pl022->next_msg_cs_active = true;
 
@@ -813,8 +825,7 @@ static void dma_callback(void *data)
 	/* Update total bytes transferred */
 	msg->actual_length += pl022->cur_transfer->len;
 	if (pl022->cur_transfer->cs_change)
-		pl022->cur_chip->
-			cs_control(SSP_CHIP_DESELECT);
+		pl022_cs_control(pl022, SSP_CHIP_DESELECT);
 
 	/* Move to next transfer */
 	msg->state = next_transfer(pl022);
@@ -1247,8 +1258,7 @@ static irqreturn_t pl022_interrupt_handler(int irq, void *dev_id)
 		/* Update total bytes transferred */
 		msg->actual_length += pl022->cur_transfer->len;
 		if (pl022->cur_transfer->cs_change)
-			pl022->cur_chip->
-				cs_control(SSP_CHIP_DESELECT);
+			pl022_cs_control(pl022, SSP_CHIP_DESELECT);
 		/* Move to next transfer */
 		msg->state = next_transfer(pl022);
 		tasklet_schedule(&pl022->pump_transfers);
@@ -1333,7 +1343,7 @@ static void pump_transfers(unsigned long data)
 
 		/* Reselect chip select only if cs_change was requested */
 		if (previous->cs_change)
-			pl022->cur_chip->cs_control(SSP_CHIP_SELECT);
+			pl022_cs_control(pl022, SSP_CHIP_SELECT);
 	} else {
 		/* STATE_START */
 		message->state = STATE_RUNNING;
@@ -1372,7 +1382,7 @@ static void do_interrupt_dma_transfer(struct pl022 *pl022)
 
 	/* Enable target chip, if not already active */
 	if (!pl022->next_msg_cs_active)
-		pl022->cur_chip->cs_control(SSP_CHIP_SELECT);
+		pl022_cs_control(pl022, SSP_CHIP_SELECT);
 
 	if (set_up_next_transfer(pl022, pl022->cur_transfer)) {
 		/* Error path */
@@ -1424,12 +1434,12 @@ static void do_polling_transfer(struct pl022 *pl022)
 			if (previous->delay_usecs)
 				udelay(previous->delay_usecs);
 			if (previous->cs_change)
-				pl022->cur_chip->cs_control(SSP_CHIP_SELECT);
+				pl022_cs_control(pl022, SSP_CHIP_SELECT);
 		} else {
 			/* STATE_START */
 			message->state = STATE_RUNNING;
 			if (!pl022->next_msg_cs_active)
-				pl022->cur_chip->cs_control(SSP_CHIP_SELECT);
+				pl022_cs_control(pl022, SSP_CHIP_SELECT);
 		}
 
 		/* Configuration Changing Per Transfer */
@@ -1461,7 +1471,7 @@ static void do_polling_transfer(struct pl022 *pl022)
 		/* Update total byte transferred */
 		message->actual_length += pl022->cur_transfer->len;
 		if (pl022->cur_transfer->cs_change)
-			pl022->cur_chip->cs_control(SSP_CHIP_DESELECT);
+			pl022_cs_control(pl022, SSP_CHIP_DESELECT);
 		/* Move to next transfer */
 		message->state = next_transfer(pl022);
 	}
@@ -1490,6 +1500,7 @@ static int pl022_transfer_one_message(struct spi_master *master,
 
 	/* Setup the SPI using the per chip configuration */
 	pl022->cur_chip = spi_get_ctldata(msg->spi);
+	pl022->cur_cs = pl022->chipselect[msg->spi->chip_select];
 
 	restore_state(pl022);
 	flush(pl022);
@@ -1733,7 +1744,7 @@ static int calculate_effective_freq(struct pl022 *pl022, int freq, struct
  * A piece of default chip info unless the platform
  * supplies it.
  */
-static const struct pl022_config_chip pl022_default_chip_info = {
+static struct pl022_config_chip pl022_default_chip_info = {
 	.com_mode = POLLING_TRANSFER,
 	.iface = SSP_INTERFACE_MOTOROLA_SPI,
 	.hierarchy = SSP_SLAVE,
@@ -1761,12 +1772,14 @@ static const struct pl022_config_chip pl022_default_chip_info = {
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
@@ -1789,10 +1802,36 @@ static int pl022_setup(struct spi_device *spi)
 	chip_info = spi->controller_data;
 
 	if (chip_info == NULL) {
-		chip_info = &pl022_default_chip_info;
-		/* spi_board_info.controller_data not is supplied */
-		dev_dbg(&spi->dev,
-			"using default controller_data settings\n");
+		if (np) {
+			chip_info_dt = pl022_default_chip_info;
+
+			of_property_read_u32(np, "pl022,hierarchy",
+				&chip_info_dt.hierarchy);
+			of_property_read_u32(np, "pl022,interface",
+				&chip_info_dt.iface);
+			chip_info_dt.slave_tx_disable =
+				of_property_read_bool(np,
+					"pl022,slave-tx-disable");
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
@@ -1835,8 +1874,9 @@ static int pl022_setup(struct spi_device *spi)
 	chip->xfer_type = chip_info->com_mode;
 	if (!chip_info->cs_control) {
 		chip->cs_control = null_cs_control;
-		dev_warn(&spi->dev,
-			 "chip select function is NULL for this chip\n");
+		if (!gpio_is_valid(pl022->chipselect[spi->chip_select]))
+			dev_warn(&spi->dev,
+				 "chip select function is NULL for this chip\n");
 	} else
 		chip->cs_control = chip_info->cs_control;
 
@@ -1988,7 +2028,8 @@ pl022_probe(struct amba_device *adev, const struct amba_id *id)
 	struct pl022_ssp_controller *platform_info = adev->dev.platform_data;
 	struct spi_master *master;
 	struct pl022 *pl022 = NULL;	/*Data for this driver */
-	int status = 0;
+	struct device_node *np = adev->dev.of_node;
+	int status = 0, i, num_cs;
 
 	dev_info(&adev->dev,
 		 "ARM PL022 driver, device ID: 0x%08x\n", adev->periphid);
@@ -1998,8 +2039,14 @@ pl022_probe(struct amba_device *adev, const struct amba_id *id)
 		goto err_no_pdata;
 	}
 
+	num_cs = platform_info->num_chipselect;
+#ifdef CONFIG_OF
+	of_property_read_u32(np, "pl022,num-chipselects", &num_cs);
+#endif
+
 	/* Allocate master with space for data */
-	master = spi_alloc_master(dev, sizeof(struct pl022));
+	master = spi_alloc_master(dev,
+		sizeof(struct pl022) + sizeof(int) * num_cs);
 	if (master == NULL) {
 		dev_err(&adev->dev, "probe - cannot alloc SPI master\n");
 		status = -ENOMEM;
@@ -2017,13 +2064,40 @@ pl022_probe(struct amba_device *adev, const struct amba_id *id)
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
+
+#ifdef CONFIG_OF
+	for (i = 0; i < num_cs; i++) {
+		int cs_gpio = of_get_named_gpio(np, "cs-gpios", i);
+
+		if (cs_gpio == -EPROBE_DEFER) {
+			status = -EPROBE_DEFER;
+			goto err_no_gpio;
+		}
+
+		pl022->chipselect[i] = cs_gpio;
+
+		if (gpio_is_valid(cs_gpio)) {
+			if (gpio_request(cs_gpio, "ssp-pl022"))
+				dev_err(&adev->dev,
+					"could not request %d gpio\n", cs_gpio);
+			else if (gpio_direction_output(cs_gpio, 1))
+				dev_err(&adev->dev,
+					"could set gpio %d as output\n",
+					cs_gpio);
+		}
+	}
+#else
+	for (i = 0; i < num_cs; i++)
+		pl022->chipselect[i] = -EINVAL;
+#endif
 
 	/*
 	 * Supports mode 0-3, loopback, and active low CS. Transfers are
@@ -2130,6 +2204,9 @@ pl022_probe(struct amba_device *adev, const struct amba_id *id)
  err_no_ioremap:
 	amba_release_regions(adev);
  err_no_ioregion:
+ #ifdef CONFIG_OF
+ err_no_gpio:
+ #endif
 	spi_master_put(master);
  err_no_master:
  err_no_pdata:
-- 
1.7.10


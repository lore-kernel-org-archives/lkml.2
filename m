Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab0IPUTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 16:19:46 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34776 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab0IPUTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 16:19:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ly/qr5xETd3H/zA5LGFZ/bh3zkD8BgGF4SexYYM996ROKKmcJ/+IM7BBjib/3sk8p2
         OImCpOPqjsbJ8DkilZkSfzwsPN58bu5BEQ7zI5HhcODg8D3PUQvCNfZ1FtclMZEEnJme
         N+2R+Sv5uge2QkShk8i6n2+RYEhOQtkvPIyK8=
From: wellsk40@gmail.com
To: linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        spi-devel-general@lists.sourceforge.net
Cc: sameo@linux.intel.com, rabin.vincent@stericsson.com,
        srinidhi.kasagar@stericsson.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, u.kleine-koenig@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, tj@kernel.org,
        Kevin Wells <wellsk40@gmail.com>
Subject: [PATCH] spi: amba_pl022: Add spi->mode support to AMBA SPI driver
Date: Thu, 16 Sep 2010 06:18:50 -0700
Message-Id: <1284643130-17659-2-git-send-email-wellsk40@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1284643130-17659-1-git-send-email-wellsk40@gmail.com>
References: <1284643130-17659-1-git-send-email-wellsk40@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Wells <wellsk40@gmail.com>

This patch adds spi->mode support for the AMBA pl022 driver and
allows spidev to correctly alter SPI modes. Unused fields used in
the pl022 header file for the pl022_config_chip have been removed.

The ab8500 client driver selects the data transfer size instead
of the platform data.

For platforms that use the amba pl022 driver, the unused fields
in the controller data structure have been removed and the .mode
field in the SPI board info structure is used instead.

Signed-off-by: Kevin Wells <wellsk40@gmail.com>
Acked-by/Tested-by/Reviewed-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-lpc32xx/phy3250.c    |    7 +--
 arch/arm/mach-u300/dummyspichip.c  |    5 +-
 arch/arm/mach-u300/spi.c           |   10 +---
 arch/arm/mach-ux500/board-mop500.c |    8 +--
 drivers/mfd/ab8500-spi.c           |    5 ++
 drivers/spi/amba-pl022.c           |  121 ++++++++++++++++--------------------
 include/linux/amba/pl022.h         |    6 --
 7 files changed, 63 insertions(+), 99 deletions(-)

diff --git a/arch/arm/mach-lpc32xx/phy3250.c b/arch/arm/mach-lpc32xx/phy3250.c
index bc9a42d..0c936cf 100644
--- a/arch/arm/mach-lpc32xx/phy3250.c
+++ b/arch/arm/mach-lpc32xx/phy3250.c
@@ -172,18 +172,12 @@ static void phy3250_spi_cs_set(u32 control)
 }
 
 static struct pl022_config_chip spi0_chip_info = {
-	.lbm			= LOOPBACK_DISABLED,
 	.com_mode		= INTERRUPT_TRANSFER,
 	.iface			= SSP_INTERFACE_MOTOROLA_SPI,
 	.hierarchy		= SSP_MASTER,
 	.slave_tx_disable	= 0,
-	.endian_tx		= SSP_TX_LSB,
-	.endian_rx		= SSP_RX_LSB,
-	.data_size		= SSP_DATA_BITS_8,
 	.rx_lev_trig		= SSP_RX_4_OR_MORE_ELEM,
 	.tx_lev_trig		= SSP_TX_4_OR_MORE_EMPTY_LOC,
-	.clk_phase		= SSP_CLK_FIRST_EDGE,
-	.clk_pol		= SSP_CLK_POL_IDLE_LOW,
 	.ctrl_len		= SSP_BITS_8,
 	.wait_state		= SSP_MWIRE_WAIT_ZERO,
 	.duplex			= SSP_MICROWIRE_CHANNEL_FULL_DUPLEX,
@@ -239,6 +233,7 @@ static int __init phy3250_spi_board_register(void)
 			.max_speed_hz = 5000000,
 			.bus_num = 0,
 			.chip_select = 0,
+			.mode = SPI_MODE_0,
 			.platform_data = &eeprom,
 			.controller_data = &spi0_chip_info,
 		},
diff --git a/arch/arm/mach-u300/dummyspichip.c b/arch/arm/mach-u300/dummyspichip.c
index 5f55012..03f7936 100644
--- a/arch/arm/mach-u300/dummyspichip.c
+++ b/arch/arm/mach-u300/dummyspichip.c
@@ -46,7 +46,6 @@ static ssize_t dummy_looptest(struct device *dev,
 	 * struct, this is just used here to alter the behaviour of the chip
 	 * in order to perform tests.
 	 */
-	struct pl022_config_chip *chip_info = spi->controller_data;
 	int status;
 	u8 txbuf[14] = {0xDE, 0xAD, 0xBE, 0xEF, 0x2B, 0xAD,
 			0xCA, 0xFE, 0xBA, 0xBE, 0xB1, 0x05,
@@ -72,7 +71,7 @@ static ssize_t dummy_looptest(struct device *dev,
 	 * Force chip to 8 bit mode
 	 * WARNING: NEVER DO THIS IN REAL DRIVER CODE, THIS SHOULD BE STATIC!
 	 */
-	chip_info->data_size = SSP_DATA_BITS_8;
+	spi->bits_per_word = 8;
 	/* You should NOT DO THIS EITHER */
 	spi->master->setup(spi);
 
@@ -159,7 +158,7 @@ static ssize_t dummy_looptest(struct device *dev,
 	 * Force chip to 16 bit mode
 	 * WARNING: NEVER DO THIS IN REAL DRIVER CODE, THIS SHOULD BE STATIC!
 	 */
-	chip_info->data_size = SSP_DATA_BITS_16;
+	spi->bits_per_word = 16;
 	/* You should NOT DO THIS EITHER */
 	spi->master->setup(spi);
 
diff --git a/arch/arm/mach-u300/spi.c b/arch/arm/mach-u300/spi.c
index f0e887b..edb2c0d 100644
--- a/arch/arm/mach-u300/spi.c
+++ b/arch/arm/mach-u300/spi.c
@@ -30,8 +30,6 @@ static void select_dummy_chip(u32 chipselect)
 }
 
 struct pl022_config_chip dummy_chip_info = {
-	/* Nominally this is LOOPBACK_DISABLED, but this is our dummy chip! */
-	.lbm = LOOPBACK_ENABLED,
 	/*
 	 * available POLLING_TRANSFER and INTERRUPT_TRANSFER,
 	 * DMA_TRANSFER does not work
@@ -42,14 +40,8 @@ struct pl022_config_chip dummy_chip_info = {
 	.hierarchy = SSP_MASTER,
 	/* 0 = drive TX even as slave, 1 = do not drive TX as slave */
 	.slave_tx_disable = 0,
-	/* LSB first */
-	.endian_tx = SSP_TX_LSB,
-	.endian_rx = SSP_RX_LSB,
-	.data_size = SSP_DATA_BITS_8, /* used to be 12 in some default */
 	.rx_lev_trig = SSP_RX_1_OR_MORE_ELEM,
 	.tx_lev_trig = SSP_TX_1_OR_MORE_EMPTY_LOC,
-	.clk_phase = SSP_CLK_SECOND_EDGE,
-	.clk_pol = SSP_CLK_POL_IDLE_LOW,
 	.ctrl_len = SSP_BITS_12,
 	.wait_state = SSP_MWIRE_WAIT_ZERO,
 	.duplex = SSP_MICROWIRE_CHANNEL_FULL_DUPLEX,
@@ -75,7 +67,7 @@ static struct spi_board_info u300_spi_devices[] = {
 		.bus_num        = 0, /* Only one bus on this chip */
 		.chip_select    = 0,
 		/* Means SPI_CS_HIGH, change if e.g low CS */
-		.mode           = 0,
+		.mode           = SPI_MODE_1 | SPI_LSB_FIRST | SPI_LOOP,
 	},
 #endif
 };
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 0e8fd13..219ae0c 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -55,19 +55,13 @@ static void ab4500_spi_cs_control(u32 command)
 }
 
 struct pl022_config_chip ab4500_chip_info = {
-	.lbm = LOOPBACK_DISABLED,
 	.com_mode = INTERRUPT_TRANSFER,
 	.iface = SSP_INTERFACE_MOTOROLA_SPI,
 	/* we can act as master only */
 	.hierarchy = SSP_MASTER,
 	.slave_tx_disable = 0,
-	.endian_rx = SSP_RX_MSB,
-	.endian_tx = SSP_TX_MSB,
-	.data_size = SSP_DATA_BITS_24,
 	.rx_lev_trig = SSP_RX_1_OR_MORE_ELEM,
 	.tx_lev_trig = SSP_TX_1_OR_MORE_EMPTY_LOC,
-	.clk_phase = SSP_CLK_SECOND_EDGE,
-	.clk_pol = SSP_CLK_POL_IDLE_HIGH,
 	.cs_control = ab4500_spi_cs_control,
 };
 
@@ -83,7 +77,7 @@ static struct spi_board_info u8500_spi_devices[] = {
 		.max_speed_hz = 12000000,
 		.bus_num = 0,
 		.chip_select = 0,
-		.mode = SPI_MODE_0,
+		.mode = SPI_MODE_3,
 		.irq = IRQ_DB8500_AB8500,
 	},
 };
diff --git a/drivers/mfd/ab8500-spi.c b/drivers/mfd/ab8500-spi.c
index e1c8b62..01b6d58 100644
--- a/drivers/mfd/ab8500-spi.c
+++ b/drivers/mfd/ab8500-spi.c
@@ -83,6 +83,11 @@ static int __devinit ab8500_spi_probe(struct spi_device *spi)
 	struct ab8500 *ab8500;
 	int ret;
 
+	spi->bits_per_word = 24;
+	ret = spi_setup(spi);
+	if (ret < 0)
+		return ret;
+
 	ab8500 = kzalloc(sizeof *ab8500, GFP_KERNEL);
 	if (!ab8500)
 		return -ENOMEM;
diff --git a/drivers/spi/amba-pl022.c b/drivers/spi/amba-pl022.c
index acd35d1..5ab6dbe 100644
--- a/drivers/spi/amba-pl022.c
+++ b/drivers/spi/amba-pl022.c
@@ -1248,12 +1248,6 @@ static int destroy_queue(struct pl022 *pl022)
 static int verify_controller_parameters(struct pl022 *pl022,
 					struct pl022_config_chip *chip_info)
 {
-	if ((chip_info->lbm != LOOPBACK_ENABLED)
-	    && (chip_info->lbm != LOOPBACK_DISABLED)) {
-		dev_err(chip_info->dev,
-			"loopback Mode is configured incorrectly\n");
-		return -EINVAL;
-	}
 	if ((chip_info->iface < SSP_INTERFACE_MOTOROLA_SPI)
 	    || (chip_info->iface > SSP_INTERFACE_UNIDIRECTIONAL)) {
 		dev_err(chip_info->dev,
@@ -1279,24 +1273,6 @@ static int verify_controller_parameters(struct pl022 *pl022,
 			"cpsdvsr is configured incorrectly\n");
 		return -EINVAL;
 	}
-	if ((chip_info->endian_rx != SSP_RX_MSB)
-	    && (chip_info->endian_rx != SSP_RX_LSB)) {
-		dev_err(chip_info->dev,
-			"RX FIFO endianess is configured incorrectly\n");
-		return -EINVAL;
-	}
-	if ((chip_info->endian_tx != SSP_TX_MSB)
-	    && (chip_info->endian_tx != SSP_TX_LSB)) {
-		dev_err(chip_info->dev,
-			"TX FIFO endianess is configured incorrectly\n");
-		return -EINVAL;
-	}
-	if ((chip_info->data_size < SSP_DATA_BITS_4)
-	    || (chip_info->data_size > SSP_DATA_BITS_32)) {
-		dev_err(chip_info->dev,
-			"DATA Size is configured incorrectly\n");
-		return -EINVAL;
-	}
 	if ((chip_info->com_mode != INTERRUPT_TRANSFER)
 	    && (chip_info->com_mode != DMA_TRANSFER)
 	    && (chip_info->com_mode != POLLING_TRANSFER)) {
@@ -1316,20 +1292,6 @@ static int verify_controller_parameters(struct pl022 *pl022,
 			"TX FIFO Trigger Level is configured incorrectly\n");
 		return -EINVAL;
 	}
-	if (chip_info->iface == SSP_INTERFACE_MOTOROLA_SPI) {
-		if ((chip_info->clk_phase != SSP_CLK_FIRST_EDGE)
-		    && (chip_info->clk_phase != SSP_CLK_SECOND_EDGE)) {
-			dev_err(chip_info->dev,
-				"Clock Phase is configured incorrectly\n");
-			return -EINVAL;
-		}
-		if ((chip_info->clk_pol != SSP_CLK_POL_IDLE_LOW)
-		    && (chip_info->clk_pol != SSP_CLK_POL_IDLE_HIGH)) {
-			dev_err(chip_info->dev,
-				"Clock Polarity is configured incorrectly\n");
-			return -EINVAL;
-		}
-	}
 	if (chip_info->iface == SSP_INTERFACE_NATIONAL_MICROWIRE) {
 		if ((chip_info->ctrl_len < SSP_BITS_4)
 		    || (chip_info->ctrl_len > SSP_BITS_32)) {
@@ -1494,23 +1456,14 @@ static int process_dma_info(struct pl022_config_chip *chip_info,
  * controller hardware here, that is not done until the actual transfer
  * commence.
  */
-
-/* FIXME: JUST GUESSING the spi->mode bits understood by this driver */
-#define MODEBITS	(SPI_CPOL | SPI_CPHA | SPI_CS_HIGH \
-			| SPI_LSB_FIRST | SPI_LOOP)
-
 static int pl022_setup(struct spi_device *spi)
 {
 	struct pl022_config_chip *chip_info;
 	struct chip_data *chip;
 	int status = 0;
 	struct pl022 *pl022 = spi_master_get_devdata(spi->master);
-
-	if (spi->mode & ~MODEBITS) {
-		dev_dbg(&spi->dev, "unsupported mode bits %x\n",
-			spi->mode & ~MODEBITS);
-		return -EINVAL;
-	}
+	unsigned int bits = spi->bits_per_word;
+	u32 tmp;
 
 	if (!spi->max_speed_hz)
 		return -EINVAL;
@@ -1555,18 +1508,12 @@ static int pl022_setup(struct spi_device *spi)
 		 * Set controller data default values:
 		 * Polling is supported by default
 		 */
-		chip_info->lbm = LOOPBACK_DISABLED;
 		chip_info->com_mode = POLLING_TRANSFER;
 		chip_info->iface = SSP_INTERFACE_MOTOROLA_SPI;
 		chip_info->hierarchy = SSP_SLAVE;
 		chip_info->slave_tx_disable = DO_NOT_DRIVE_TX;
-		chip_info->endian_tx = SSP_TX_LSB;
-		chip_info->endian_rx = SSP_RX_LSB;
-		chip_info->data_size = SSP_DATA_BITS_12;
 		chip_info->rx_lev_trig = SSP_RX_1_OR_MORE_ELEM;
 		chip_info->tx_lev_trig = SSP_TX_1_OR_MORE_EMPTY_LOC;
-		chip_info->clk_phase = SSP_CLK_SECOND_EDGE;
-		chip_info->clk_pol = SSP_CLK_POL_IDLE_LOW;
 		chip_info->ctrl_len = SSP_BITS_8;
 		chip_info->wait_state = SSP_MWIRE_WAIT_ZERO;
 		chip_info->duplex = SSP_MICROWIRE_CHANNEL_FULL_DUPLEX;
@@ -1601,12 +1548,16 @@ static int pl022_setup(struct spi_device *spi)
 	chip->xfer_type = chip_info->com_mode;
 	chip->cs_control = chip_info->cs_control;
 
-	if (chip_info->data_size <= 8) {
-		dev_dbg(&spi->dev, "1 <= n <=8 bits per word\n");
+	if (bits <= 3) {
+		/* PL022 doesn't support less than 4-bits */
+		status = -ENOTSUPP;
+		goto err_config_params;
+	} else if (bits <= 8) {
+		dev_dbg(&spi->dev, "4 <= n <=8 bits per word\n");
 		chip->n_bytes = 1;
 		chip->read = READING_U8;
 		chip->write = WRITING_U8;
-	} else if (chip_info->data_size <= 16) {
+	} else if (bits <= 16) {
 		dev_dbg(&spi->dev, "9 <= n <= 16 bits per word\n");
 		chip->n_bytes = 2;
 		chip->read = READING_U16;
@@ -1623,6 +1574,7 @@ static int pl022_setup(struct spi_device *spi)
 			dev_err(&spi->dev,
 				"a standard pl022 can only handle "
 				"1 <= n <= 16 bit words\n");
+			status = -ENOTSUPP;
 			goto err_config_params;
 		}
 	}
@@ -1656,6 +1608,8 @@ static int pl022_setup(struct spi_device *spi)
 
 	/* Special setup for the ST micro extended control registers */
 	if (pl022->vendor->extended_cr) {
+		u32 etx;
+
 		if (pl022->vendor->pl023) {
 			/* These bits are only in the PL023 */
 			SSP_WRITE_BITS(chip->cr1, chip_info->clkdelay,
@@ -1671,29 +1625,51 @@ static int pl022_setup(struct spi_device *spi)
 			SSP_WRITE_BITS(chip->cr1, chip_info->wait_state,
 				       SSP_CR1_MASK_MWAIT_ST, 6);
 		}
-		SSP_WRITE_BITS(chip->cr0, chip_info->data_size,
+		SSP_WRITE_BITS(chip->cr0, bits - 1,
 			       SSP_CR0_MASK_DSS_ST, 0);
-		SSP_WRITE_BITS(chip->cr1, chip_info->endian_rx,
-			       SSP_CR1_MASK_RENDN_ST, 4);
-		SSP_WRITE_BITS(chip->cr1, chip_info->endian_tx,
-			       SSP_CR1_MASK_TENDN_ST, 5);
+
+		if (spi->mode & SPI_LSB_FIRST) {
+			tmp = SSP_RX_LSB;
+			etx = SSP_TX_LSB;
+		} else {
+			tmp = SSP_RX_MSB;
+			etx = SSP_TX_MSB;
+		}
+		SSP_WRITE_BITS(chip->cr1, tmp, SSP_CR1_MASK_RENDN_ST, 4);
+		SSP_WRITE_BITS(chip->cr1, etx, SSP_CR1_MASK_TENDN_ST, 5);
 		SSP_WRITE_BITS(chip->cr1, chip_info->rx_lev_trig,
 			       SSP_CR1_MASK_RXIFLSEL_ST, 7);
 		SSP_WRITE_BITS(chip->cr1, chip_info->tx_lev_trig,
 			       SSP_CR1_MASK_TXIFLSEL_ST, 10);
 	} else {
-		SSP_WRITE_BITS(chip->cr0, chip_info->data_size,
+		SSP_WRITE_BITS(chip->cr0, bits - 1,
 			       SSP_CR0_MASK_DSS, 0);
 		SSP_WRITE_BITS(chip->cr0, chip_info->iface,
 			       SSP_CR0_MASK_FRF, 4);
 	}
+
 	/* Stuff that is common for all versions */
-	SSP_WRITE_BITS(chip->cr0, chip_info->clk_pol, SSP_CR0_MASK_SPO, 6);
-	SSP_WRITE_BITS(chip->cr0, chip_info->clk_phase, SSP_CR0_MASK_SPH, 7);
+	if (spi->mode & SPI_CPOL)
+		tmp = SSP_CLK_POL_IDLE_HIGH;
+	else
+		tmp = SSP_CLK_POL_IDLE_LOW;
+	SSP_WRITE_BITS(chip->cr0, tmp, SSP_CR0_MASK_SPO, 6);
+
+	if (spi->mode & SPI_CPHA)
+		tmp = SSP_CLK_SECOND_EDGE;
+	else
+		tmp = SSP_CLK_FIRST_EDGE;
+	SSP_WRITE_BITS(chip->cr0, tmp, SSP_CR0_MASK_SPH, 7);
+
 	SSP_WRITE_BITS(chip->cr0, chip_info->clk_freq.scr, SSP_CR0_MASK_SCR, 8);
 	/* Loopback is available on all versions except PL023 */
-	if (!pl022->vendor->pl023)
-		SSP_WRITE_BITS(chip->cr1, chip_info->lbm, SSP_CR1_MASK_LBM, 0);
+	if (!pl022->vendor->pl023) {
+		if (spi->mode & SPI_LOOP)
+			tmp = LOOPBACK_ENABLED;
+		else
+			tmp = LOOPBACK_DISABLED;
+		SSP_WRITE_BITS(chip->cr1, tmp, SSP_CR1_MASK_LBM, 0);
+	}
 	SSP_WRITE_BITS(chip->cr1, SSP_DISABLED, SSP_CR1_MASK_SSE, 1);
 	SSP_WRITE_BITS(chip->cr1, chip_info->hierarchy, SSP_CR1_MASK_MS, 2);
 	SSP_WRITE_BITS(chip->cr1, chip_info->slave_tx_disable, SSP_CR1_MASK_SOD, 3);
@@ -1702,6 +1678,7 @@ static int pl022_setup(struct spi_device *spi)
 	spi_set_ctldata(spi, chip);
 	return status;
  err_config_params:
+	spi_set_ctldata(spi, NULL);
  err_first_setup:
 	kfree(chip);
 	return status;
@@ -1764,6 +1741,14 @@ pl022_probe(struct amba_device *adev, struct amba_id *id)
 	master->setup = pl022_setup;
 	master->transfer = pl022_transfer;
 
+	/*
+	 * Supports mode 0-3, loopback, and active low CS. Transfers are
+	 * always MS bit first on the original pl022.
+	 */
+	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LOOP;
+	if (pl022->vendor->extended_cr)
+		master->mode_bits |= SPI_LSB_FIRST;
+
 	dev_dbg(&adev->dev, "BUSNO: %d\n", master->bus_num);
 
 	status = amba_request_regions(adev, NULL);
diff --git a/include/linux/amba/pl022.h b/include/linux/amba/pl022.h
index abf26cc..0ad6977 100644
--- a/include/linux/amba/pl022.h
+++ b/include/linux/amba/pl022.h
@@ -271,19 +271,13 @@ struct pl022_ssp_controller {
  */
 struct pl022_config_chip {
 	struct device *dev;
-	enum ssp_loopback lbm;
 	enum ssp_interface iface;
 	enum ssp_hierarchy hierarchy;
 	bool slave_tx_disable;
 	struct ssp_clock_params clk_freq;
-	enum ssp_rx_endian endian_rx;
-	enum ssp_tx_endian endian_tx;
-	enum ssp_data_size data_size;
 	enum ssp_mode com_mode;
 	enum ssp_rx_level_trig rx_lev_trig;
 	enum ssp_tx_level_trig tx_lev_trig;
-	enum ssp_spi_clk_phase clk_phase;
-	enum ssp_spi_clk_pol clk_pol;
 	enum ssp_microwire_ctrl_len ctrl_len;
 	enum ssp_microwire_wait_state wait_state;
 	enum ssp_duplex duplex;
-- 
1.7.2.2


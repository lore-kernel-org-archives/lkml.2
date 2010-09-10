Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab0IJW57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 18:57:59 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46094 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab0IJW56 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 18:57:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=L24c03vrHXr//UYvpmApRHClj9xYZ1j5NECjJmNVeLcx4jmnonY227AgG0EtLUUVvR
         RpmD9CkES75UVsXFgwzcbNULktl0YLWZJq3zJTaHR0oPQkJ3or8j3F5CX5rbW8Yoa9Zv
         W8nWdjp7gk0YkTTFXU3YBn32StJPDty3Tqnqo=
MIME-Version: 1.0
Date: Fri, 10 Sep 2010 15:57:57 -0700
Message-ID: <AANLkTikbKwo9=xLWo1qEcc2E5aa2iN2F_KCokJPpnWOk@mail.gmail.com>
Subject: resend: [PATCH] amba_pl022: Setup SPI configuration based on spi->mode
From: Kevin Wells <wellsk40@gmail.com>
To: sameo@linux.intel.com, rabin.vincent@stericsson.com,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        tj@kernel.org, grant.likely@secretlab.ca,
        spi-devel-general@lists.sourceforge.net
Cc: quentinyang05@gmail.com, Lukasz.Baj@tieto.com, kevin.wells@nxp.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Re-send with full distribution list)

This patch changes the way SPI transfers are setup. The previous
method uses the pl022_config_chip data for configuration of
loopback mode, edge count, clock polarity, number of data bits,
and bit transfer order. This change configures these parameters
based on spi->mode passed via master->setup and will allow the
drivers use SPI to configure the interface.

The fields lbm, clk_phase, clk_pol, and data_size are no longer
needed. For the ST/pl023 setup, the first bit transferred for
both RX and TX is now selected with the SPI_LSB_FIRST flag in
spi->mode.

There are also several very minor cleanups in the patch that
fix return status on setup failures.

This has been tested with the AT25 serial EEPROM driver and
spidev modes 0-3 with loopback and varying data sizes.

Reported-by: Quentin Yang <quentinyang05@gmail.com>
Signed-off-by: Kevin Wells <wellsk40@gmail.com>
---
 drivers/spi/amba-pl022.c |  121 ++++++++++++++++++++--------------------------
 1 files changed, 53 insertions(+), 68 deletions(-)

diff --git a/drivers/spi/amba-pl022.c b/drivers/spi/amba-pl022.c
index acd35d1..1be488a 100644
--- a/drivers/spi/amba-pl022.c
+++ b/drivers/spi/amba-pl022.c
@@ -1248,12 +1248,6 @@ static int destroy_queue(struct pl022 *pl022)
 static int verify_controller_parameters(struct pl022 *pl022,
                                       struct pl022_config_chip *chip_info)
 {
-       if ((chip_info->lbm != LOOPBACK_ENABLED)
-           && (chip_info->lbm != LOOPBACK_DISABLED)) {
-               dev_err(chip_info->dev,
-                       "loopback Mode is configured incorrectly\n");
-               return -EINVAL;
-       }
       if ((chip_info->iface < SSP_INTERFACE_MOTOROLA_SPI)
           || (chip_info->iface > SSP_INTERFACE_UNIDIRECTIONAL)) {
               dev_err(chip_info->dev,
@@ -1279,24 +1273,6 @@ static int verify_controller_parameters(struct
pl022 *pl022,
                       "cpsdvsr is configured incorrectly\n");
               return -EINVAL;
       }
-       if ((chip_info->endian_rx != SSP_RX_MSB)
-           && (chip_info->endian_rx != SSP_RX_LSB)) {
-               dev_err(chip_info->dev,
-                       "RX FIFO endianess is configured incorrectly\n");
-               return -EINVAL;
-       }
-       if ((chip_info->endian_tx != SSP_TX_MSB)
-           && (chip_info->endian_tx != SSP_TX_LSB)) {
-               dev_err(chip_info->dev,
-                       "TX FIFO endianess is configured incorrectly\n");
-               return -EINVAL;
-       }
-       if ((chip_info->data_size < SSP_DATA_BITS_4)
-           || (chip_info->data_size > SSP_DATA_BITS_32)) {
-               dev_err(chip_info->dev,
-                       "DATA Size is configured incorrectly\n");
-               return -EINVAL;
-       }
       if ((chip_info->com_mode != INTERRUPT_TRANSFER)
           && (chip_info->com_mode != DMA_TRANSFER)
           && (chip_info->com_mode != POLLING_TRANSFER)) {
@@ -1316,20 +1292,6 @@ static int verify_controller_parameters(struct
pl022 *pl022,
                       "TX FIFO Trigger Level is configured incorrectly\n");
               return -EINVAL;
       }
-       if (chip_info->iface == SSP_INTERFACE_MOTOROLA_SPI) {
-               if ((chip_info->clk_phase != SSP_CLK_FIRST_EDGE)
-                   && (chip_info->clk_phase != SSP_CLK_SECOND_EDGE)) {
-                       dev_err(chip_info->dev,
-                               "Clock Phase is configured incorrectly\n");
-                       return -EINVAL;
-               }
-               if ((chip_info->clk_pol != SSP_CLK_POL_IDLE_LOW)
-                   && (chip_info->clk_pol != SSP_CLK_POL_IDLE_HIGH)) {
-                       dev_err(chip_info->dev,
-                               "Clock Polarity is configured incorrectly\n");
-                       return -EINVAL;
-               }
-       }
       if (chip_info->iface == SSP_INTERFACE_NATIONAL_MICROWIRE) {
               if ((chip_info->ctrl_len < SSP_BITS_4)
                   || (chip_info->ctrl_len > SSP_BITS_32)) {
@@ -1494,23 +1456,14 @@ static int process_dma_info(struct
pl022_config_chip *chip_info,
 * controller hardware here, that is not done until the actual transfer
 * commence.
 */
-
-/* FIXME: JUST GUESSING the spi->mode bits understood by this driver */
-#define MODEBITS       (SPI_CPOL | SPI_CPHA | SPI_CS_HIGH \
-                       | SPI_LSB_FIRST | SPI_LOOP)
-
 static int pl022_setup(struct spi_device *spi)
 {
       struct pl022_config_chip *chip_info;
       struct chip_data *chip;
       int status = 0;
       struct pl022 *pl022 = spi_master_get_devdata(spi->master);
-
-       if (spi->mode & ~MODEBITS) {
-               dev_dbg(&spi->dev, "unsupported mode bits %x\n",
-                       spi->mode & ~MODEBITS);
-               return -EINVAL;
-       }
+       unsigned int bits = spi->bits_per_word;
+       u32 tmp;

       if (!spi->max_speed_hz)
               return -EINVAL;
@@ -1555,18 +1508,12 @@ static int pl022_setup(struct spi_device *spi)
                * Set controller data default values:
                * Polling is supported by default
                */
-               chip_info->lbm = LOOPBACK_DISABLED;
               chip_info->com_mode = POLLING_TRANSFER;
               chip_info->iface = SSP_INTERFACE_MOTOROLA_SPI;
               chip_info->hierarchy = SSP_SLAVE;
               chip_info->slave_tx_disable = DO_NOT_DRIVE_TX;
-               chip_info->endian_tx = SSP_TX_LSB;
-               chip_info->endian_rx = SSP_RX_LSB;
-               chip_info->data_size = SSP_DATA_BITS_12;
               chip_info->rx_lev_trig = SSP_RX_1_OR_MORE_ELEM;
               chip_info->tx_lev_trig = SSP_TX_1_OR_MORE_EMPTY_LOC;
-               chip_info->clk_phase = SSP_CLK_SECOND_EDGE;
-               chip_info->clk_pol = SSP_CLK_POL_IDLE_LOW;
               chip_info->ctrl_len = SSP_BITS_8;
               chip_info->wait_state = SSP_MWIRE_WAIT_ZERO;
               chip_info->duplex = SSP_MICROWIRE_CHANNEL_FULL_DUPLEX;
@@ -1601,12 +1548,16 @@ static int pl022_setup(struct spi_device *spi)
       chip->xfer_type = chip_info->com_mode;
       chip->cs_control = chip_info->cs_control;

-       if (chip_info->data_size <= 8) {
-               dev_dbg(&spi->dev, "1 <= n <=8 bits per word\n");
+       if (bits <= 3) {
+               /* PL022 doesn't support less than 4-bits */
+               status = -ENOTSUPP;
+               goto err_config_params;
+       } else if (bits <= 8) {
+               dev_dbg(&spi->dev, "4 <= n <=8 bits per word\n");
               chip->n_bytes = 1;
               chip->read = READING_U8;
               chip->write = WRITING_U8;
-       } else if (chip_info->data_size <= 16) {
+       } else if (bits <= 16) {
               dev_dbg(&spi->dev, "9 <= n <= 16 bits per word\n");
               chip->n_bytes = 2;
               chip->read = READING_U16;
@@ -1623,6 +1574,7 @@ static int pl022_setup(struct spi_device *spi)
                       dev_err(&spi->dev,
                               "a standard pl022 can only handle "
                               "1 <= n <= 16 bit words\n");
+                       status = -ENOTSUPP;
                       goto err_config_params;
               }
       }
@@ -1656,6 +1608,8 @@ static int pl022_setup(struct spi_device *spi)

       /* Special setup for the ST micro extended control registers */
       if (pl022->vendor->extended_cr) {
+               u32 etx;
+
               if (pl022->vendor->pl023) {
                       /* These bits are only in the PL023 */
                       SSP_WRITE_BITS(chip->cr1, chip_info->clkdelay,
@@ -1671,29 +1625,51 @@ static int pl022_setup(struct spi_device *spi)
                       SSP_WRITE_BITS(chip->cr1, chip_info->wait_state,
                                      SSP_CR1_MASK_MWAIT_ST, 6);
               }
-               SSP_WRITE_BITS(chip->cr0, chip_info->data_size,
+               SSP_WRITE_BITS(chip->cr0, bits - 1,
                              SSP_CR0_MASK_DSS_ST, 0);
-               SSP_WRITE_BITS(chip->cr1, chip_info->endian_rx,
-                              SSP_CR1_MASK_RENDN_ST, 4);
-               SSP_WRITE_BITS(chip->cr1, chip_info->endian_tx,
-                              SSP_CR1_MASK_TENDN_ST, 5);
+
+               if (spi->mode & SPI_LSB_FIRST) {
+                       tmp = SSP_RX_LSB;
+                       etx = SSP_TX_LSB;
+               } else {
+                       tmp = SSP_RX_MSB;
+                       etx = SSP_TX_MSB;
+               }
+               SSP_WRITE_BITS(chip->cr1, tmp, SSP_CR1_MASK_RENDN_ST, 4);
+               SSP_WRITE_BITS(chip->cr1, etx, SSP_CR1_MASK_TENDN_ST, 5);
               SSP_WRITE_BITS(chip->cr1, chip_info->rx_lev_trig,
                              SSP_CR1_MASK_RXIFLSEL_ST, 7);
               SSP_WRITE_BITS(chip->cr1, chip_info->tx_lev_trig,
                              SSP_CR1_MASK_TXIFLSEL_ST, 10);
       } else {
-               SSP_WRITE_BITS(chip->cr0, chip_info->data_size,
+               SSP_WRITE_BITS(chip->cr0, bits - 1,
                              SSP_CR0_MASK_DSS, 0);
               SSP_WRITE_BITS(chip->cr0, chip_info->iface,
                              SSP_CR0_MASK_FRF, 4);
       }
+
       /* Stuff that is common for all versions */
-       SSP_WRITE_BITS(chip->cr0, chip_info->clk_pol, SSP_CR0_MASK_SPO, 6);
-       SSP_WRITE_BITS(chip->cr0, chip_info->clk_phase, SSP_CR0_MASK_SPH, 7);
+       if (spi->mode & SPI_CPOL)
+               tmp = SSP_CLK_POL_IDLE_HIGH;
+       else
+               tmp = SSP_CLK_POL_IDLE_LOW;
+       SSP_WRITE_BITS(chip->cr0, tmp, SSP_CR0_MASK_SPO, 6);
+
+       if (spi->mode & SPI_CPHA)
+               tmp = SSP_CLK_SECOND_EDGE;
+       else
+               tmp = SSP_CLK_FIRST_EDGE;
+       SSP_WRITE_BITS(chip->cr0, tmp, SSP_CR0_MASK_SPH, 6);
+
       SSP_WRITE_BITS(chip->cr0, chip_info->clk_freq.scr, SSP_CR0_MASK_SCR, 8);
       /* Loopback is available on all versions except PL023 */
-       if (!pl022->vendor->pl023)
-               SSP_WRITE_BITS(chip->cr1, chip_info->lbm, SSP_CR1_MASK_LBM, 0);
+       if (!pl022->vendor->pl023) {
+               if (spi->mode & SPI_LOOP)
+                       tmp = LOOPBACK_ENABLED;
+               else
+                       tmp = LOOPBACK_DISABLED;
+               SSP_WRITE_BITS(chip->cr1, tmp, SSP_CR1_MASK_LBM, 0);
+       }
       SSP_WRITE_BITS(chip->cr1, SSP_DISABLED, SSP_CR1_MASK_SSE, 1);
       SSP_WRITE_BITS(chip->cr1, chip_info->hierarchy, SSP_CR1_MASK_MS, 2);
       SSP_WRITE_BITS(chip->cr1, chip_info->slave_tx_disable,
SSP_CR1_MASK_SOD, 3);
@@ -1702,6 +1678,7 @@ static int pl022_setup(struct spi_device *spi)
       spi_set_ctldata(spi, chip);
       return status;
 err_config_params:
+       spi_set_ctldata(spi, NULL);
 err_first_setup:
       kfree(chip);
       return status;
@@ -1764,6 +1741,14 @@ pl022_probe(struct amba_device *adev, struct amba_id *id)
       master->setup = pl022_setup;
       master->transfer = pl022_transfer;

+       /*
+        * Supports mode 0-3, loopback, and active low CS. Transfers are
+        * always MS bit first on the original pl022.
+        */
+       master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LOOP;
+       if (pl022->vendor->extended_cr)
+               master->mode_bits |= SPI_LSB_FIRST;
+
       dev_dbg(&adev->dev, "BUSNO: %d\n", master->bus_num);

       status = amba_request_regions(adev, NULL);
--
1.7.2.2

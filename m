Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab0IJXT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 19:19:28 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34663 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab0IJXTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 19:19:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MuQxBQNMXNIvqwnD/734YeG+7bGgwja5Lt7izwKxjyyp7XJNyoejLgGCxY/eK1SJtC
         uk2FxuolX1vGhHa6PJdQnPnk5BqPRP8e+otDfaenuKDi9MPuuElztHh5fvcEZ5KWxX5p
         xbfFPM5TPzfbyzALGklwBaYWVWBq8os9k+gG8=
From: wellsk40@gmail.com
To: linus.walleij@stericsson.com, spi-devel-general@lists.sourceforge.net
Cc: sameo@linux.intel.com, rabin.vincent@stericsson.com,
        srinidhi.kasagar@stericsson.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, u.kleine-koenig@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, tj@kernel.org,
        grant.likely@secretlab.ca, Lukasz.Baj@tieto.com,
        quentinyang05@gmail.com, Kevin Wells <wellsk40@gmail.com>
Subject: [PATCH 3/5] ARM: U300: spi->mode and spi_bits_per_words updates
Date: Fri, 10 Sep 2010 09:19:37 -0700
Message-Id: <1284135579-13578-4-git-send-email-wellsk40@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1284135579-13578-1-git-send-email-wellsk40@gmail.com>
References: <1284135579-13578-1-git-send-email-wellsk40@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Wells <wellsk40@gmail.com>

Some of the fields in the pl022_chip_info structure used with
the amba pl022 driver are no longer used. This patch removes
those unused fields and changes the .mode flags in the
spi_board_info structure to setup the correct SPI mode.

For the loopback driver, the bus_info pointer can be removed
and the bits_per_word field can be used instead for setting
the bus data width.

Signed-off-by: Kevin Wells <wellsk40@gmail.com>
---
 arch/arm/mach-u300/dummyspichip.c |    5 ++---
 arch/arm/mach-u300/spi.c          |   10 +---------
 2 files changed, 3 insertions(+), 12 deletions(-)

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
-- 
1.7.2.2


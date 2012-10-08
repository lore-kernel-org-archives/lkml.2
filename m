Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab2JHWk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 18:40:29 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:62991 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab2JHWkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 18:40:23 -0400
From: Stan Hu <stanhu@gmail.com>
To: spi-devel-general@lists.sourceforge.net,
        Grant Likely <grant.likely@secretlab.ca>,
        Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Pitre <nico@linaro.org>, linux-kernel@vger.kernel.org
Cc: Stan Hu <stanhu@gmail.com>
Subject: [PATCH 1/1] spi: omap2-mcspi: add option to configure output line for McSPI driver
Date: Mon,  8 Oct 2012 16:39:40 -0600
Message-Id: <1349735980-17015-1-git-send-email-stanhu@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

McSPI driver previously assumed that D0 was input (MISO) and D1 was output (MOSI).
This forces the hardware designer to wire all SPI peripherals in this way when
it should be a software configuration option.

Signed-off-by: Stan Hu <stanhu@gmail.com>
---
 drivers/spi/spi-omap2-mcspi.c                 |   11 +++++++++--
 include/linux/platform_data/spi-omap2-mcspi.h |    2 ++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 3542fdc..d7c7e13 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -740,6 +740,7 @@ static int omap2_mcspi_setup_transfer(struct spi_device *spi,
 		struct spi_transfer *t)
 {
 	struct omap2_mcspi_cs *cs = spi->controller_state;
+	struct omap2_mcspi_device_config *cd = spi->controller_data;
 	struct omap2_mcspi *mcspi;
 	struct spi_master *spi_cntrl;
 	u32 l = 0, div = 0;
@@ -765,8 +766,14 @@ static int omap2_mcspi_setup_transfer(struct spi_device *spi,
 	/* standard 4-wire master mode:  SCK, MOSI/out, MISO/in, nCS
 	 * REVISIT: this controller could support SPI_3WIRE mode.
 	 */
-	l &= ~(OMAP2_MCSPI_CHCONF_IS|OMAP2_MCSPI_CHCONF_DPE1);
-	l |= OMAP2_MCSPI_CHCONF_DPE0;
+	l &= ~(OMAP2_MCSPI_CHCONF_IS|
+		OMAP2_MCSPI_CHCONF_DPE0|OMAP2_MCSPI_CHCONF_DPE1);
+
+	/* set input selection for D0 and D1 */
+	if (cd->d0_is_output)
+		l |= OMAP2_MCSPI_CHCONF_IS|OMAP2_MCSPI_CHCONF_DPE1;
+	else
+		l |= OMAP2_MCSPI_CHCONF_DPE0;
 
 	/* wordlength */
 	l &= ~OMAP2_MCSPI_CHCONF_WL_MASK;
diff --git a/include/linux/platform_data/spi-omap2-mcspi.h b/include/linux/platform_data/spi-omap2-mcspi.h
index a357eb2..419d08a 100644
--- a/include/linux/platform_data/spi-omap2-mcspi.h
+++ b/include/linux/platform_data/spi-omap2-mcspi.h
@@ -18,6 +18,8 @@ struct omap2_mcspi_dev_attr {
 
 struct omap2_mcspi_device_config {
 	unsigned turbo_mode:1;
+	/* 0 -> [D0 = MISO, D1 = MOSI], 1 -> [D0 = MOSI, D1 = MISO] */
+	unsigned d0_is_output:1;
 };
 
 #endif
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213Ab2IZSeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 14:34:46 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39705 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757436Ab2IZSeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 14:34:44 -0400
From: Stan Hu <stanhu@gmail.com>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Stan Hu <stanhu@gmail.com>
Subject: [PATCH 1/1] ARM: Add option to configure output line for McSPI driver
Date: Wed, 26 Sep 2012 11:34:27 -0700
Message-Id: <1348684467-5707-1-git-send-email-stanhu@gmail.com>
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
 arch/arm/plat-omap/include/plat/mcspi.h |    2 ++
 drivers/spi/spi-omap2-mcspi.c           |   11 +++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/mcspi.h b/arch/arm/plat-omap/include/plat/mcspi.h
index a357eb2..0a6b790 100644
--- a/arch/arm/plat-omap/include/plat/mcspi.h
+++ b/arch/arm/plat-omap/include/plat/mcspi.h
@@ -18,6 +18,8 @@ struct omap2_mcspi_dev_attr {
 
 struct omap2_mcspi_device_config {
 	unsigned turbo_mode:1;
+	/* 1 -> [D0 = MOSI, D1 = MISO], otherwise vice versa */
+	unsigned d0_is_output:1;
 };
 
 #endif
diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index b2fb141..1853527 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -717,6 +717,7 @@ static int omap2_mcspi_setup_transfer(struct spi_device *spi,
 		struct spi_transfer *t)
 {
 	struct omap2_mcspi_cs *cs = spi->controller_state;
+	struct omap2_mcspi_device_config *cd = spi->controller_data;
 	struct omap2_mcspi *mcspi;
 	struct spi_master *spi_cntrl;
 	u32 l = 0, div = 0;
@@ -742,8 +743,14 @@ static int omap2_mcspi_setup_transfer(struct spi_device *spi,
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
-- 
1.7.9.5


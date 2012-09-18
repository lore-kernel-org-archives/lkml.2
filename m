Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab2IRS0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:26:09 -0400
Received: from mail-gg0-f202.google.com ([209.85.161.202]:62504 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab2IRSYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:24:34 -0400
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org
Cc: "kgene.kim" <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Simon Glass <sjg@chromium.org>
Subject: [PATCH 6/7] spi: s3c64xx: Tidy up SPI chip select handling
Date: Tue, 18 Sep 2012 11:21:58 -0700
Message-Id: <1347992519-6904-7-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1347992519-6904-1-git-send-email-sjg@chromium.org>
References: <1347992519-6904-1-git-send-email-sjg@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While it is possible to use a GPIO, it is useful to be able to use the
SPI peripheral's built-in chip select feature. This should be supported.

The current driver is broken in that it doesn't properly support
the cs_change property in the message. To fix this, the chip select
should be changed in one place (enable/disable_cs()) instead of using the
macro separately in a different place. Also we need to make sure that
the FIFOs are cleared even in the event of an empty transaction or
error.

(This adds a proposed new fdt binding for Samsung SPI)

Signed-off-by: Simon Glass <sjg@chromium.org>
---
 .../devicetree/bindings/spi/spi-samsung.txt        |    7 ++++
 arch/arm/plat-samsung/include/plat/s3c64xx-spi.h   |    6 ++-
 drivers/spi/spi-s3c64xx.c                          |   34 +++++++++++++------
 3 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/spi-samsung.txt b/Documentation/devicetree/bindings/spi/spi-samsung.txt
index 59bfc4f..74d67e1 100644
--- a/Documentation/devicetree/bindings/spi/spi-samsung.txt
+++ b/Documentation/devicetree/bindings/spi/spi-samsung.txt
@@ -60,6 +60,13 @@ SPI Controller specific data in SPI slave nodes:
       - 2: 180 degree phase shift sampling.
       - 3: 270 degree phase shift sampling.
 
+- The spi slave nodes may provide the following optional properties:
+
+  - samsung,spi-cs: (boolean property). If present, uses the SPI controller's
+    built-in chip select feature,  rather than toggling GPIOs manually. The
+    correct chip select line must still be specified in cs-gpio, and in this
+    case should be assigned to the SPI controller.
+
 Aliases:
 
 - All the SPI controller nodes should be represented in the aliases node using
diff --git a/arch/arm/plat-samsung/include/plat/s3c64xx-spi.h b/arch/arm/plat-samsung/include/plat/s3c64xx-spi.h
index ceba18d..7103f71 100644
--- a/arch/arm/plat-samsung/include/plat/s3c64xx-spi.h
+++ b/arch/arm/plat-samsung/include/plat/s3c64xx-spi.h
@@ -17,7 +17,8 @@ struct platform_device;
  * struct s3c64xx_spi_csinfo - ChipSelect description
  * @fb_delay: Slave specific feedback delay.
  *            Refer to FB_CLK_SEL register definition in SPI chapter.
- * @line: Custom 'identity' of the CS line.
+ * @line: Custom 'identity' of the CS line (-1 to use SPI controller)
+ * @use_spi_cs: Use SPI's chip select toggle instead of GPIO
  *
  * This is per SPI-Slave Chipselect information.
  * Allocate and initialize one in machine init code and make the
@@ -25,7 +26,8 @@ struct platform_device;
  */
 struct s3c64xx_spi_csinfo {
 	u8 fb_delay;
-	unsigned line;
+	int line;
+	bool only_spi_cs;
 };
 
 /**
diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index ed12872..c34ef8f 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -414,14 +414,21 @@ static inline void enable_cs(struct s3c64xx_spi_driver_data *sdd,
 		if (sdd->tgl_spi != spi) { /* if last mssg on diff device */
 			/* Deselect the last toggled device */
 			cs = sdd->tgl_spi->controller_data;
-			gpio_set_value(cs->line,
-				spi->mode & SPI_CS_HIGH ? 0 : 1);
+			writel(S3C64XX_SPI_SLAVE_SIG_INACT,
+				sdd->regs + S3C64XX_SPI_SLAVE_SEL);
+			if (!cs->only_spi_cs) {
+				gpio_set_value(cs->line,
+					spi->mode & SPI_CS_HIGH ? 0 : 1);
+			}
 		}
 		sdd->tgl_spi = NULL;
 	}
 
+	/* Start the signals */
 	cs = spi->controller_data;
-	gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 1 : 0);
+	if (!cs->only_spi_cs)
+		gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 1 : 0);
+	writel(0, sdd->regs + S3C64XX_SPI_SLAVE_SEL);
 }
 
 static int wait_for_xfer(struct s3c64xx_spi_driver_data *sdd,
@@ -514,7 +521,10 @@ static inline void disable_cs(struct s3c64xx_spi_driver_data *sdd,
 	if (sdd->tgl_spi == spi)
 		sdd->tgl_spi = NULL;
 
-	gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 0 : 1);
+	/* Quiese the signals */
+	writel(S3C64XX_SPI_SLAVE_SIG_INACT, sdd->regs + S3C64XX_SPI_SLAVE_SEL);
+	if (!cs->only_spi_cs)
+		gpio_set_value(cs->line, spi->mode & SPI_CS_HIGH ? 0 : 1);
 }
 
 static void s3c64xx_spi_config(struct s3c64xx_spi_driver_data *sdd)
@@ -746,17 +756,10 @@ static int s3c64xx_spi_transfer_one_message(struct spi_master *master,
 		/* Slave Select */
 		enable_cs(sdd, spi);
 
-		/* Start the signals */
-		writel(0, sdd->regs + S3C64XX_SPI_SLAVE_SEL);
-
 		spin_unlock_irqrestore(&sdd->lock, flags);
 
 		status = wait_for_xfer(sdd, xfer, use_dma);
 
-		/* Quiese the signals */
-		writel(S3C64XX_SPI_SLAVE_SIG_INACT,
-		       sdd->regs + S3C64XX_SPI_SLAVE_SEL);
-
 		if (status) {
 			dev_err(&spi->dev, "I/O Error: "
 				"rx-%d tx-%d res:rx-%c tx-%c len-%d\n",
@@ -801,6 +804,9 @@ out:
 	else
 		sdd->tgl_spi = spi;
 
+	/* Make sure empty transactions and error clean up the state */
+	flush_fifo(sdd);
+
 	if (have_dma)
 		s3c64xx_spi_unmap_mssg(sdd, msg);
 out_nomap:
@@ -878,6 +884,12 @@ static struct s3c64xx_spi_csinfo *s3c64xx_get_slave_ctrldata(
 		return ERR_PTR(-EINVAL);
 	}
 
+	/*
+	 * Rather than manually toggle GPIOs, we can use the SPI chip select
+	 * feature.
+	 */
+	cs->only_spi_cs = of_property_read_bool(data_np, "samsung,spi-cs");
+
 	of_property_read_u32(data_np, "samsung,spi-feedback-delay", &fb_delay);
 	cs->fb_delay = fb_delay;
 	return cs;
-- 
1.7.7.3


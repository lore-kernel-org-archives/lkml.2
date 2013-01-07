Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab3AGB4f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 20:56:35 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:13285 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab3AGB42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 20:56:28 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, richard.genoud@gmail.com, JM.Lin@atmel.com,
        wenyou.yang@atmel.com
Subject: [v3 PATCH 05/12] spi/atmel_spi: update the dt support
Date: Mon,  7 Jan 2013 09:50:06 +0800
Message-Id: <1357523413-27209-6-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357523413-27209-1-git-send-email-wenyou.yang@atmel.com>
References: <1357523413-27209-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 07 Jan 2013 01:56:19.0646 (UTC) FILETIME=[2FD7F5E0:01CDEC7A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To meet the different spi IP version of atmel SoC,
add more compatible "atmel,at91rm9200-spi", "atmel,at91sam9260-spi"
"atmel,at91sam9g45-spi", "atmel,at91sam9x5-spi" with different
config and devtype.

The "has_dma_support" is used to select the dma engine transfer mode.

The "has_wdrbt" indicate if there is the "WDRBT" bit in the Mode Register,
WDRBT (Wait Data Read Before Transfer),if WDRBT is set,
a transfer can start only if the Receive Data Register is empty,i.e. does not
contain any unread data, to prevent overrun error in reception

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 drivers/spi/spi-atmel.c |  137 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 118 insertions(+), 19 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 8f6f0a0..43374ca 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -71,6 +71,8 @@
 #define SPI_FDIV_SIZE				1
 #define SPI_MODFDIS_OFFSET			4
 #define SPI_MODFDIS_SIZE			1
+#define SPI_WDRBT_OFFSET			5
+#define SPI_WDRBT_SIZE				1
 #define SPI_LLB_OFFSET				7
 #define SPI_LLB_SIZE				1
 #define SPI_PCS_OFFSET				16
@@ -186,6 +188,12 @@
  * DMA transfers; transfer queue progress is driven by IRQs.  The clock
  * framework provides the base clock, subdivided for each spi_device.
  */
+struct atmel_spi_pdata {
+	u8	version;
+	bool	has_dma_support;
+	bool	has_wdrbt;
+};
+
 struct atmel_spi {
 	spinlock_t		lock;
 	unsigned long		flags;
@@ -204,6 +212,7 @@ struct atmel_spi {
 	struct spi_transfer	*next_transfer;
 	unsigned long		next_remaining_bytes;
 	int			done_status;
+	struct atmel_spi_pdata	*pdata;
 
 	void			*buffer;
 	dma_addr_t		buffer_dma;
@@ -218,6 +227,69 @@ struct atmel_spi_device {
 #define BUFFER_SIZE		PAGE_SIZE
 #define INVALID_DMA_ADDRESS	0xffffffff
 
+static struct atmel_spi_pdata at91rm9200_config = {
+	.version = 1,
+	.has_dma_support = false,
+	.has_wdrbt = false,
+};
+
+static struct atmel_spi_pdata at91sam9260_config = {
+	.version = 2,
+	.has_dma_support = false,
+	.has_wdrbt = false,
+};
+
+static struct atmel_spi_pdata at91sam9g45_config = {
+	.version = 2,
+	.has_dma_support = false,
+	.has_wdrbt = true,
+};
+
+static struct atmel_spi_pdata at91sam9x5_config = {
+	.version = 2,
+	.has_dma_support = true,
+	.has_wdrbt = true,
+};
+
+static const struct platform_device_id atmel_spi_devtypes[] = {
+	{
+		.name = "spi-at91rm9200",
+		.driver_data = (unsigned long) &at91rm9200_config,
+	}, {
+		.name = "spi-at91sam9260",
+		.driver_data = (unsigned long) &at91sam9260_config,
+	}, {
+		.name = "spi-at91sam9g45",
+		.driver_data = (unsigned long) &at91sam9g45_config,
+	}, {
+		.name = "spi-at91sam9x5",
+		.driver_data = (unsigned long) &at91sam9x5_config,
+	}, {
+		/* sentinel */
+	}
+};
+
+#if defined(CONFIG_OF)
+static const struct of_device_id atmel_spi_dt_ids[] = {
+	{
+		.compatible = "atmel,at91rm9200-spi",
+		.data = &at91rm9200_config,
+	} , {
+		.compatible = "atmel,at91sam9260-spi",
+		.data = &at91sam9260_config,
+	} , {
+		.compatible = "atmel,at91sam9g45-spi",
+		.data = &at91sam9g45_config,
+	} , {
+		.compatible = "atmel,at91sam9x5-spi",
+		.data = &at91sam9x5_config,
+	}, {
+		/* sentinel */
+	}
+};
+MODULE_DEVICE_TABLE(of, atmel_spi_dt_ids);
+#endif
+
 /*
  * Version 2 of the SPI controller has
  *  - CR.LASTXFER
@@ -230,11 +302,15 @@ struct atmel_spi_device {
  * register, but I haven't checked that it exists on all chips, and
  * this is cheaper anyway.
  */
-static bool atmel_spi_is_v2(void)
+static bool atmel_spi_is_v2(struct atmel_spi *as)
 {
-	return !cpu_is_at91rm9200();
+	if (as->pdata->version == 2)
+		return true;
+	else
+		return false;
 }
 
+
 /*
  * Earlier SPI controllers (e.g. on at91rm9200) have a design bug whereby
  * they assume that spi slave device state will not change on deselect, so
@@ -266,15 +342,21 @@ static void cs_activate(struct atmel_spi *as, struct spi_device *spi)
 	unsigned active = spi->mode & SPI_CS_HIGH;
 	u32 mr;
 
-	if (atmel_spi_is_v2()) {
+	if (atmel_spi_is_v2(as)) {
 		/*
 		 * Always use CSR0. This ensures that the clock
 		 * switches to the correct idle polarity before we
 		 * toggle the CS.
 		 */
 		spi_writel(as, CSR0, asd->csr);
-		spi_writel(as, MR, SPI_BF(PCS, 0x0e) | SPI_BIT(MODFDIS)
-				| SPI_BIT(MSTR));
+
+		if (as->pdata->has_wdrbt)
+			spi_writel(as, MR, SPI_BF(PCS, 0x0e) | SPI_BIT(MSTR)
+					| SPI_BIT(MODFDIS) | SPI_BIT(WDRBT));
+		else
+			spi_writel(as, MR, SPI_BF(PCS, 0x0e)
+					| SPI_BIT(MSTR) | SPI_BIT(MODFDIS));
+
 		mr = spi_readl(as, MR);
 		gpio_set_value(asd->npcs_pin, active);
 	} else {
@@ -321,7 +403,7 @@ static void cs_deactivate(struct atmel_spi *as, struct spi_device *spi)
 			asd->npcs_pin, active ? " (low)" : "",
 			mr);
 
-	if (atmel_spi_is_v2() || spi->chip_select != 0)
+	if (atmel_spi_is_v2(as) || spi->chip_select != 0)
 		gpio_set_value(asd->npcs_pin, !active);
 }
 
@@ -734,7 +816,7 @@ static int atmel_spi_setup(struct spi_device *spi)
 	}
 
 	/* see notes above re chipselect */
-	if (!atmel_spi_is_v2()
+	if (!atmel_spi_is_v2(as)
 			&& spi->chip_select == 0
 			&& (spi->mode & SPI_CS_HIGH)) {
 		dev_dbg(&spi->dev, "setup: can't be active-high\n");
@@ -743,7 +825,7 @@ static int atmel_spi_setup(struct spi_device *spi)
 
 	/* v1 chips start out at half the peripheral bus speed. */
 	bus_hz = clk_get_rate(as->clk);
-	if (!atmel_spi_is_v2())
+	if (!atmel_spi_is_v2(as))
 		bus_hz /= 2;
 
 	if (spi->max_speed_hz) {
@@ -817,7 +899,7 @@ static int atmel_spi_setup(struct spi_device *spi)
 		"setup: %lu Hz bpw %u mode 0x%x -> csr%d %08x\n",
 		bus_hz / scbr, bits, spi->mode, spi->chip_select, csr);
 
-	if (!atmel_spi_is_v2())
+	if (!atmel_spi_is_v2(as))
 		spi_writel(as, CSR0 + 4 * spi->chip_select, csr);
 
 	return 0;
@@ -921,6 +1003,21 @@ static void atmel_spi_cleanup(struct spi_device *spi)
 	kfree(asd);
 }
 
+static struct atmel_spi_pdata * __devinit atmel_spi_get_driver_data(
+					struct platform_device *pdev)
+{
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+		match = of_match_node(atmel_spi_dt_ids, pdev->dev.of_node);
+		if (!match)
+			return NULL;
+		return (struct atmel_spi_pdata *) match->data;
+	}
+
+	return (struct atmel_spi_pdata *)
+			platform_get_device_id(pdev)->driver_data;
+}
+
 /*-------------------------------------------------------------------------*/
 
 static int atmel_spi_probe(struct platform_device *pdev)
@@ -987,11 +1084,21 @@ static int atmel_spi_probe(struct platform_device *pdev)
 	if (ret)
 		goto out_unmap_regs;
 
+	as->pdata = atmel_spi_get_driver_data(pdev);
+	if (!as->pdata)
+		goto out_unmap_regs;
+
 	/* Initialize the hardware */
 	clk_enable(clk);
 	spi_writel(as, CR, SPI_BIT(SWRST));
 	spi_writel(as, CR, SPI_BIT(SWRST)); /* AT91SAM9263 Rev B workaround */
-	spi_writel(as, MR, SPI_BIT(MSTR) | SPI_BIT(MODFDIS));
+
+	if (as->pdata->has_wdrbt)
+		spi_writel(as, MR,
+			SPI_BIT(MSTR) | SPI_BIT(MODFDIS) | SPI_BIT(WDRBT));
+	else
+		spi_writel(as, MR, SPI_BIT(MSTR) | SPI_BIT(MODFDIS));
+
 	spi_writel(as, PTCR, SPI_BIT(RXTDIS) | SPI_BIT(TXTDIS));
 	spi_writel(as, CR, SPI_BIT(SPIEN));
 
@@ -1084,21 +1191,13 @@ static int atmel_spi_resume(struct platform_device *pdev)
 #define	atmel_spi_resume	NULL
 #endif
 
-#if defined(CONFIG_OF)
-static const struct of_device_id atmel_spi_dt_ids[] = {
-	{ .compatible = "atmel,at91rm9200-spi" },
-	{ /* sentinel */ }
-};
-
-MODULE_DEVICE_TABLE(of, atmel_spi_dt_ids);
-#endif
-
 static struct platform_driver atmel_spi_driver = {
 	.driver		= {
 		.name	= "atmel_spi",
 		.owner	= THIS_MODULE,
 		.of_match_table	= of_match_ptr(atmel_spi_dt_ids),
 	},
+	.id_table	= atmel_spi_devtypes,
 	.suspend	= atmel_spi_suspend,
 	.resume		= atmel_spi_resume,
 	.probe		= atmel_spi_probe,
-- 
1.7.9.5


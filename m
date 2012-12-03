Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab2LCSiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 13:38:55 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49866 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784Ab2LCSiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 13:38:52 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <spi-devel-general@lists.sourceforge.net>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-keystone@list.ti.com>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v1 1/1] spi: davinci: add OF support for the spi controller
Date: Mon, 3 Dec 2012 13:38:38 -0500
Message-ID: <1354559918-15105-2-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354559918-15105-1-git-send-email-m-karicheri2@ti.com>
References: <1354559918-15105-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds OF support to DaVinci SPI controller to configure platform
data through device bindings. Also replaces clk_enable() with
of clk_prepare_enable() as well as clk_disable() with
clk_disable_unprepare().

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
Reviewed-by : Grant Likely <grant.likely@secretlab.ca>
---
 .../devicetree/bindings/spi/spi-davinci.txt        |   51 ++++++++++
 drivers/spi/spi-davinci.c                          |  102 +++++++++++++++++---
 2 files changed, 139 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spi/spi-davinci.txt

diff --git a/Documentation/devicetree/bindings/spi/spi-davinci.txt b/Documentation/devicetree/bindings/spi/spi-davinci.txt
new file mode 100644
index 0000000..a2746c5
--- /dev/null
+++ b/Documentation/devicetree/bindings/spi/spi-davinci.txt
@@ -0,0 +1,51 @@
+Davinci SPI controller device bindings
+
+Required properties:
+- #address-cells: number of cells required to define a chip select
+	address on the SPI bus. Should be set to 1.
+- #size-cells: should be zero.
+- compatible:
+	- "ti,davinci-spi-v1" for SPI version 1.0
+	- "ti,davinci-spi-v2" for SPI version 2.0
+- reg: Offset and length of SPI controller register space
+- ti,davinci-spi-num-cs: Number of chip selects
+- ti,davinci-spi-intr-line: interrupt line used to connect the SPI
+	IP to the interrupt controller withn the SoC. Possible values
+	are 0 and 1. Manual says one of the two possible interrupt
+	lines can be tied to the interrupt controller. Set this
+	based on a specifc SoC configuration.
+- interrupts: interrupt number offset at the irq parent
+- clocks: spi clk phandle
+
+Example of a NOR flash slave device (n25q032) connected to DaVinci
+SPI controller device over the SPI bus.
+
+spi0:spi@20BF0000 {
+	#address-cells			= <1>;
+	#size-cells			= <0>;
+	compatible			= "ti,davinci-spi-v1";
+	reg				= <0x20BF0000 0x1000>;
+	ti,davinci-spi-num-cs		= <4>;
+	ti,davinci-spi-intr-line	= <0>;
+	interrupts			= <338>;
+	clocks				= <&clkspi>;
+
+	flash: n25q032@0 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "st,m25p32";
+		spi-max-frequency = <25000000>;
+		reg = <0>;
+
+		partition@0 {
+			label = "u-boot-spl";
+			reg = <0x0 0x80000>;
+			read-only;
+		};
+
+		partition@1 {
+			label = "test";
+			reg = <0x80000 0x380000>;
+		};
+	};
+};
diff --git a/drivers/spi/spi-davinci.c b/drivers/spi/spi-davinci.c
index 147dfa8..4d5f166 100644
--- a/drivers/spi/spi-davinci.c
+++ b/drivers/spi/spi-davinci.c
@@ -28,6 +28,8 @@
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
 #include <linux/edma.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/spi_bitbang.h>
 #include <linux/slab.h>
@@ -135,7 +137,7 @@ struct davinci_spi {
 	int			dma_rx_chnum;
 	int			dma_tx_chnum;
 
-	struct davinci_spi_platform_data *pdata;
+	struct davinci_spi_platform_data pdata;
 
 	void			(*get_rx)(u32 rx_data, struct davinci_spi *);
 	u32			(*get_tx)(struct davinci_spi *);
@@ -213,7 +215,7 @@ static void davinci_spi_chipselect(struct spi_device *spi, int value)
 	bool gpio_chipsel = false;
 
 	dspi = spi_master_get_devdata(spi->master);
-	pdata = dspi->pdata;
+	pdata = &dspi->pdata;
 
 	if (pdata->chip_sel && chip_sel < pdata->num_chipselect &&
 				pdata->chip_sel[chip_sel] != SPI_INTERN_CS)
@@ -392,7 +394,7 @@ static int davinci_spi_setup(struct spi_device *spi)
 	struct davinci_spi_platform_data *pdata;
 
 	dspi = spi_master_get_devdata(spi->master);
-	pdata = dspi->pdata;
+	pdata = &dspi->pdata;
 
 	/* if bits per word length is zero then set it default 8 */
 	if (!spi->bits_per_word)
@@ -534,7 +536,7 @@ static int davinci_spi_bufs(struct spi_device *spi, struct spi_transfer *t)
 	struct scatterlist sg_rx, sg_tx;
 
 	dspi = spi_master_get_devdata(spi->master);
-	pdata = dspi->pdata;
+	pdata = &dspi->pdata;
 	spicfg = (struct davinci_spi_config *)spi->controller_data;
 	if (!spicfg)
 		spicfg = &davinci_spi_default_cfg;
@@ -758,6 +760,70 @@ rx_dma_failed:
 	return r;
 }
 
+#if defined(CONFIG_OF)
+static const struct of_device_id davinci_spi_of_match[] = {
+	{
+		.compatible = "ti,davinci-spi-v1",
+	},
+	{
+		.compatible = "ti,davinci-spi-v2",
+		.data = (void *)SPI_VERSION_2,
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, davini_spi_of_match);
+
+/**
+ * spi_davinci_get_pdata - Get platform data from DTS binding
+ * @pdev: ptr to platform data
+ * @dspi: ptr to driver data
+ *
+ * Parses and populates pdata in dspi from device tree bindings.
+ *
+ * NOTE: Not all platform data params are supported currently.
+ */
+static int spi_davinci_get_pdata(struct platform_device *pdev,
+			struct davinci_spi *dspi)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct davinci_spi_platform_data *pdata;
+	unsigned int num_cs, intr_line = 0;
+	const struct of_device_id *match;
+
+	pdata = &dspi->pdata;
+
+	pdata->version = SPI_VERSION_1;
+	match = of_match_device(of_match_ptr(davinci_spi_of_match),
+				&pdev->dev);
+	if (!match)
+		return -ENODEV;
+
+	/* match data has the SPI version number for SPI_VERSION_2 */
+	if (match->data == (void *)SPI_VERSION_2)
+		pdata->version = SPI_VERSION_2;
+
+	/*
+	 * default num_cs is 1 and all chipsel are internal to the chip
+	 * indicated by chip_sel being NULL. GPIO based CS is not
+	 * supported yet in DT bindings.
+	 */
+	num_cs = 1;
+	of_property_read_u32(node, "ti,davinci-spi-num-cs", &num_cs);
+	pdata->num_chipselect = num_cs;
+	of_property_read_u32(node, "ti,davinci-spi-intr-line", &intr_line);
+	pdata->intr_line = intr_line;
+	return 0;
+}
+#else
+#define davinci_spi_of_match NULL
+static struct davinci_spi_platform_data
+	*spi_davinci_get_pdata(struct platform_device *pdev,
+		struct davinci_spi *dspi)
+{
+	return -ENODEV;
+}
+#endif
+
 /**
  * davinci_spi_probe - probe function for SPI Master Controller
  * @pdev: platform_device structure which contains plateform specific data
@@ -780,12 +846,6 @@ static int __devinit davinci_spi_probe(struct platform_device *pdev)
 	int i = 0, ret = 0;
 	u32 spipc0;
 
-	pdata = pdev->dev.platform_data;
-	if (pdata == NULL) {
-		ret = -ENODEV;
-		goto err;
-	}
-
 	master = spi_alloc_master(&pdev->dev, sizeof(struct davinci_spi));
 	if (master == NULL) {
 		ret = -ENOMEM;
@@ -800,6 +860,19 @@ static int __devinit davinci_spi_probe(struct platform_device *pdev)
 		goto free_master;
 	}
 
+	if (pdev->dev.platform_data) {
+		pdata = pdev->dev.platform_data;
+		dspi->pdata = *pdata;
+	} else {
+		/* update dspi pdata with that from the DT */
+		ret = spi_davinci_get_pdata(pdev, dspi);
+		if (ret < 0)
+			goto free_master;
+	}
+
+	/* pdata in dspi is now updated and point pdata to that */
+	pdata = &dspi->pdata;
+
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (r == NULL) {
 		ret = -ENOENT;
@@ -807,7 +880,6 @@ static int __devinit davinci_spi_probe(struct platform_device *pdev)
 	}
 
 	dspi->pbase = r->start;
-	dspi->pdata = pdata;
 
 	mem = request_mem_region(r->start, resource_size(r), pdev->name);
 	if (mem == NULL) {
@@ -843,8 +915,9 @@ static int __devinit davinci_spi_probe(struct platform_device *pdev)
 		ret = -ENODEV;
 		goto put_master;
 	}
-	clk_enable(dspi->clk);
+	clk_prepare_enable(dspi->clk);
 
+	master->dev.of_node = pdev->dev.of_node;
 	master->bus_num = pdev->id;
 	master->num_chipselect = pdata->num_chipselect;
 	master->setup = davinci_spi_setup;
@@ -927,7 +1000,7 @@ free_dma:
 	dma_release_channel(dspi->dma_rx);
 	dma_release_channel(dspi->dma_tx);
 free_clk:
-	clk_disable(dspi->clk);
+	clk_disable_unprepare(dspi->clk);
 	clk_put(dspi->clk);
 put_master:
 	spi_master_put(master);
@@ -963,7 +1036,7 @@ static int __devexit davinci_spi_remove(struct platform_device *pdev)
 
 	spi_bitbang_stop(&dspi->bitbang);
 
-	clk_disable(dspi->clk);
+	clk_disable_unprepare(dspi->clk);
 	clk_put(dspi->clk);
 	spi_master_put(master);
 	free_irq(dspi->irq, dspi);
@@ -978,6 +1051,7 @@ static struct platform_driver davinci_spi_driver = {
 	.driver = {
 		.name = "spi_davinci",
 		.owner = THIS_MODULE,
+		.of_match_table = davinci_spi_of_match,
 	},
 	.probe = davinci_spi_probe,
 	.remove = __devexit_p(davinci_spi_remove),
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab3AGKnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 05:43:19 -0500
Received: from mga03.intel.com ([143.182.124.21]:33340 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771Ab3AGKlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 05:41:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,423,1355126400"; 
   d="scan'208";a="188437146"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, haojian.zhuang@gmail.com,
        broonie@opensource.wolfsonmicro.com, chao.bi@intel.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 11/11] spi/pxa2xx: add support for Lynxpoint SPI controllers
Date: Mon,  7 Jan 2013 12:44:40 +0200
Message-Id: <1357555480-24022-12-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel Lynxpoint PCH Low Power Subsystem has two general purpose SPI
controllers that are LPSS_SSP compatible. These controllers are enumerated
from ACPI namespace with ACPI IDs INT33C0 and INT33C1.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/Kconfig      |    2 +-
 drivers/spi/spi-pxa2xx.c |  131 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 130 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index a90393d..bf1d3b5 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -299,7 +299,7 @@ config SPI_PPC4xx
 
 config SPI_PXA2XX
 	tristate "PXA2xx SSP SPI master"
-	depends on ARCH_PXA || PCI
+	depends on ARCH_PXA || PCI || ACPI
 	select PXA_SSP if ARCH_PXA
 	help
 	  This enables using a PXA2xx or Sodaville SSP port as a SPI master
diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index d6295c0..9ebbfcf 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -37,6 +37,7 @@
 #include <linux/slab.h>
 #include <linux/clk.h>
 #include <linux/pm_runtime.h>
+#include <linux/acpi.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -1916,6 +1917,13 @@ static int setup(struct spi_device *spi)
 		chip->dma_threshold = 0;
 		if (chip_info->enable_loopback)
 			chip->cr1 = SSCR1_LBM;
+	} else if (ACPI_HANDLE(&spi->dev)) {
+		/*
+		 * Slave devices enumerated from ACPI namespace don't
+		 * usually have chip_info but we still might want to use
+		 * DMA with them.
+		 */
+		chip->enable_dma = drv_data->master_info->enable_dma;
 	}
 
 	chip->threshold = (SSCR1_RxTresh(rx_thres) & SSCR1_RFT) |
@@ -2007,6 +2015,120 @@ static void cleanup(struct spi_device *spi)
 	kfree(chip);
 }
 
+#ifdef CONFIG_ACPI
+struct pxa2xx_spi_acpi_config {
+	enum pxa_ssp_type type;
+	unsigned long clk_rate;
+};
+
+/* Lynxpoint SPI controllers */
+static const struct pxa2xx_spi_acpi_config lpt_acpi_config = {
+	.type = LPSS_SSP,
+	.clk_rate = 100000000,
+};
+
+static struct acpi_device_id pxa2xx_spi_acpi_match[] = {
+	{ "INT33C0", (kernel_ulong_t)&lpt_acpi_config },
+	{ "INT33C1", (kernel_ulong_t)&lpt_acpi_config },
+	{ },
+};
+MODULE_DEVICE_TABLE(acpi, pxa2xx_spi_acpi_match);
+
+static int pxa2xx_spi_acpi_add_dma(struct acpi_resource *res, void *data)
+{
+	struct pxa2xx_spi_master *pdata = data;
+
+	if (res->type == ACPI_RESOURCE_TYPE_FIXED_DMA) {
+		const struct acpi_resource_fixed_dma *dma;
+
+		dma = &res->data.fixed_dma;
+		if (pdata->tx_slave_id < 0) {
+			pdata->tx_slave_id = dma->request_lines;
+			pdata->tx_chan_id = dma->channels;
+		} else if (pdata->rx_slave_id < 0) {
+			pdata->rx_slave_id = dma->request_lines;
+			pdata->rx_chan_id = dma->channels;
+		}
+	}
+
+	/* Tell the ACPI core to skip this resource */
+	return 1;
+}
+
+static struct pxa2xx_spi_master *
+pxa2xx_spi_acpi_get_pdata(struct platform_device *pdev)
+{
+	const struct pxa2xx_spi_acpi_config *conf;
+	struct pxa2xx_spi_master *pdata;
+	const struct acpi_device_id *id;
+	struct list_head resource_list;
+	struct acpi_device *adev;
+	struct ssp_device *ssp;
+	struct resource *res;
+	int devid;
+
+	if (!ACPI_HANDLE(&pdev->dev) ||
+	    acpi_bus_get_device(ACPI_HANDLE(&pdev->dev), &adev))
+		return NULL;
+
+	id = acpi_match_device(pxa2xx_spi_acpi_match, &pdev->dev);
+	if (!id)
+		return NULL;
+
+	conf = (const struct pxa2xx_spi_acpi_config *)id->driver_data;
+	if (!conf)
+		return NULL;
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*ssp), GFP_KERNEL);
+	if (!pdata) {
+		dev_err(&pdev->dev,
+			"failed to allocate memory for platform data\n");
+		return NULL;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return NULL;
+
+	ssp = &pdata->ssp;
+
+	ssp->phys_base = res->start;
+	ssp->mmio_base = devm_request_and_ioremap(&pdev->dev, res);
+	if (!ssp->mmio_base) {
+		dev_err(&pdev->dev, "failed to ioremap mmio_base\n");
+		return NULL;
+	}
+
+	ssp->irq = platform_get_irq(pdev, 0);
+	ssp->type = conf->type;
+	ssp->pdev = pdev;
+
+	ssp->port_id = -1;
+	if (adev->pnp.unique_id && !kstrtoint(adev->pnp.unique_id, 0, &devid))
+		ssp->port_id = devid;
+
+	pdata->num_chipselect = 1;
+	pdata->rx_slave_id = -1;
+	pdata->tx_slave_id = -1;
+	pdata->fixed_clk_rate = conf->clk_rate;
+
+	INIT_LIST_HEAD(&resource_list);
+	acpi_dev_get_resources(adev, &resource_list, pxa2xx_spi_acpi_add_dma,
+			       pdata);
+	acpi_dev_free_resource_list(&resource_list);
+
+	pdata->enable_dma = pdata->rx_slave_id >= 0 && pdata->tx_slave_id >= 0;
+
+	return pdata;
+}
+#else
+static inline struct pxa2xx_spi_master *
+pxa2xx_spi_acpi_get_pdata(struct platform_device *pdev)
+{
+	return NULL;
+}
+#endif
+
 static int pxa2xx_spi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -2018,8 +2140,11 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 
 	platform_info = dev_get_platdata(dev);
 	if (!platform_info) {
-		dev_err(&pdev->dev, "missing platform data\n");
-		return -ENODEV;
+		platform_info = pxa2xx_spi_acpi_get_pdata(pdev);
+		if (!platform_info) {
+			dev_err(&pdev->dev, "missing platform data\n");
+			return -ENODEV;
+		}
 	}
 
 	ssp = pxa_ssp_request(pdev->id, pdev->name);
@@ -2046,6 +2171,7 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 
 	master->dev.parent = &pdev->dev;
 	master->dev.of_node = pdev->dev.of_node;
+	ACPI_HANDLE_SET(&master->dev, ACPI_HANDLE(&pdev->dev));
 	/* the spi->mode bits understood by this driver: */
 	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LOOP;
 
@@ -2252,6 +2378,7 @@ static struct platform_driver driver = {
 		.name	= "pxa2xx-spi",
 		.owner	= THIS_MODULE,
 		.pm	= &pxa2xx_spi_pm_ops,
+		.acpi_match_table = ACPI_PTR(pxa2xx_spi_acpi_match),
 	},
 	.probe = pxa2xx_spi_probe,
 	.remove = pxa2xx_spi_remove,
-- 
1.7.10.4


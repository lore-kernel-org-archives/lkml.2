Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab3AGKlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 05:41:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:26455 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580Ab3AGKlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 05:41:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,423,1355126400"; 
   d="scan'208";a="273733515"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, haojian.zhuang@gmail.com,
        broonie@opensource.wolfsonmicro.com, chao.bi@intel.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 04/11] spi/pxa2xx: embed the ssp_device to platform data
Date: Mon,  7 Jan 2013 12:44:33 +0200
Message-Id: <1357555480-24022-5-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The spi-pxa2xx-pci glue driver had to implement pxa_ssp_request()/free() in
order to support the spi-pxa2xx platform driver. Since the ACPI enabled
platforms can use the same platform driver we would need to implement
pxa_ssp_request()/free() in some central place that can be shared by the
ACPI and PCI glue code.

Instead of doing that we can make pxa_ssp_request()/free() to be available
only when CONFIG_ARCH_PXA is set. On other arches these are being stubbed
out in preference to passing the ssp_device from the platform data
directly.

We also change the SPI bus number to be taken from ssp->port_id instead of
platform device id. This way the supporting code that passes the ssp can
decide the number (or it can set it to the same as pdev->id).

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi-pxa2xx-pci.c   |   73 +++-------------------------------------
 drivers/spi/spi-pxa2xx.c       |   15 ++++++---
 include/linux/pxa2xx_ssp.h     |    9 +++++
 include/linux/spi/pxa2xx_spi.h |    3 ++
 4 files changed, 28 insertions(+), 72 deletions(-)

diff --git a/drivers/spi/spi-pxa2xx-pci.c b/drivers/spi/spi-pxa2xx-pci.c
index ece979e..364964d 100644
--- a/drivers/spi/spi-pxa2xx-pci.c
+++ b/drivers/spi/spi-pxa2xx-pci.c
@@ -8,55 +8,11 @@
 #include <linux/module.h>
 #include <linux/spi/pxa2xx_spi.h>
 
-struct ce4100_info {
-	struct ssp_device ssp;
-	struct platform_device *spi_pdev;
-};
-
-static DEFINE_MUTEX(ssp_lock);
-static LIST_HEAD(ssp_list);
-
-struct ssp_device *pxa_ssp_request(int port, const char *label)
-{
-	struct ssp_device *ssp = NULL;
-
-	mutex_lock(&ssp_lock);
-
-	list_for_each_entry(ssp, &ssp_list, node) {
-		if (ssp->port_id == port && ssp->use_count == 0) {
-			ssp->use_count++;
-			ssp->label = label;
-			break;
-		}
-	}
-
-	mutex_unlock(&ssp_lock);
-
-	if (&ssp->node == &ssp_list)
-		return NULL;
-
-	return ssp;
-}
-EXPORT_SYMBOL_GPL(pxa_ssp_request);
-
-void pxa_ssp_free(struct ssp_device *ssp)
-{
-	mutex_lock(&ssp_lock);
-	if (ssp->use_count) {
-		ssp->use_count--;
-		ssp->label = NULL;
-	} else
-		dev_err(&ssp->pdev->dev, "device already free\n");
-	mutex_unlock(&ssp_lock);
-}
-EXPORT_SYMBOL_GPL(pxa_ssp_free);
-
 static int ce4100_spi_probe(struct pci_dev *dev,
 		const struct pci_device_id *ent)
 {
 	struct platform_device_info pi;
 	int ret;
-	struct ce4100_info *spi_info;
 	struct platform_device *pdev;
 	struct pxa2xx_spi_master spi_pdata;
 	struct ssp_device *ssp;
@@ -69,14 +25,10 @@ static int ce4100_spi_probe(struct pci_dev *dev,
 	if (!ret)
 		return ret;
 
-	spi_info = devm_kzalloc(&dev->dev, sizeof(*spi_info), GFP_KERNEL);
-	if (!spi_info)
-		return -ENOMEM;
-
 	memset(&spi_pdata, 0, sizeof(spi_pdata));
 	spi_pdata.num_chipselect = dev->devfn;
 
-	ssp = &spi_info->ssp;
+	ssp = &spi_pdata.ssp;
 	ssp->phys_base = pci_resource_start(dev, 0);
 	ssp->mmio_base = pcim_iomap_table(dev)[0];
 	if (!ssp->mmio_base) {
@@ -87,10 +39,6 @@ static int ce4100_spi_probe(struct pci_dev *dev,
 	ssp->port_id = dev->devfn;
 	ssp->type = PXA25x_SSP;
 
-	mutex_lock(&ssp_lock);
-	list_add(&ssp->node, &ssp_list);
-	mutex_unlock(&ssp_lock);
-
 	memset(&pi, 0, sizeof(pi));
 	pi.parent = &dev->dev;
 	pi.name = "pxa2xx-spi";
@@ -99,30 +47,19 @@ static int ce4100_spi_probe(struct pci_dev *dev,
 	pi.size_data = sizeof(spi_pdata);
 
 	pdev = platform_device_register_full(&pi);
-	if (!pdev) {
-		mutex_lock(&ssp_lock);
-		list_del(&ssp->node);
-		mutex_unlock(&ssp_lock);
-
+	if (!pdev)
 		return -ENOMEM;
-	}
 
-	spi_info->spi_pdev = pdev;
-	pci_set_drvdata(dev, spi_info);
+	pci_set_drvdata(dev, pdev);
 
 	return 0;
 }
 
 static void ce4100_spi_remove(struct pci_dev *dev)
 {
-	struct ce4100_info *spi_info = pci_get_drvdata(dev);
-	struct ssp_device *ssp = &spi_info->ssp;
-
-	platform_device_unregister(spi_info->spi_pdev);
+	struct platform_device *pdev = pci_get_drvdata(dev);
 
-	mutex_lock(&ssp_lock);
-	list_del(&ssp->node);
-	mutex_unlock(&ssp_lock);
+	platform_device_unregister(pdev);
 }
 
 static DEFINE_PCI_DEVICE_TABLE(ce4100_spi_devices) = {
diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index ad842eb..17bd136 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1374,11 +1374,18 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 	struct ssp_device *ssp;
 	int status;
 
-	platform_info = dev->platform_data;
+	platform_info = dev_get_platdata(dev);
+	if (!platform_info) {
+		dev_err(&pdev->dev, "missing platform data\n");
+		return -ENODEV;
+	}
 
 	ssp = pxa_ssp_request(pdev->id, pdev->name);
-	if (ssp == NULL) {
-		dev_err(&pdev->dev, "failed to request SSP%d\n", pdev->id);
+	if (!ssp)
+		ssp = &platform_info->ssp;
+
+	if (!ssp->mmio_base) {
+		dev_err(&pdev->dev, "failed to get ssp\n");
 		return -ENODEV;
 	}
 
@@ -1400,7 +1407,7 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 	/* the spi->mode bits understood by this driver: */
 	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
 
-	master->bus_num = pdev->id;
+	master->bus_num = ssp->port_id;
 	master->num_chipselect = platform_info->num_chipselect;
 	master->dma_alignment = DMA_ALIGNMENT;
 	master->cleanup = cleanup;
diff --git a/include/linux/pxa2xx_ssp.h b/include/linux/pxa2xx_ssp.h
index f366320..065e7f6 100644
--- a/include/linux/pxa2xx_ssp.h
+++ b/include/linux/pxa2xx_ssp.h
@@ -206,6 +206,15 @@ static inline u32 pxa_ssp_read_reg(struct ssp_device *dev, u32 reg)
 	return __raw_readl(dev->mmio_base + reg);
 }
 
+#ifdef CONFIG_ARCH_PXA
 struct ssp_device *pxa_ssp_request(int port, const char *label);
 void pxa_ssp_free(struct ssp_device *);
+#else
+static inline struct ssp_device *pxa_ssp_request(int port, const char *label)
+{
+	return NULL;
+}
+static inline void pxa_ssp_free(struct ssp_device *ssp) {}
+#endif
+
 #endif
diff --git a/include/linux/spi/pxa2xx_spi.h b/include/linux/spi/pxa2xx_spi.h
index c73d144..6b99f09 100644
--- a/include/linux/spi/pxa2xx_spi.h
+++ b/include/linux/spi/pxa2xx_spi.h
@@ -28,6 +28,9 @@ struct pxa2xx_spi_master {
 	u32 clock_enable;
 	u16 num_chipselect;
 	u8 enable_dma;
+
+	/* For non-PXA arches */
+	struct ssp_device ssp;
 };
 
 /* spi_board_info.controller_data for SPI slave devices,
-- 
1.7.10.4


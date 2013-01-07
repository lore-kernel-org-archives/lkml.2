Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab3AGKlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 05:41:22 -0500
Received: from mga03.intel.com ([143.182.124.21]:33340 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568Ab3AGKlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 05:41:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,423,1355126400"; 
   d="scan'208";a="188437114"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, haojian.zhuang@gmail.com,
        broonie@opensource.wolfsonmicro.com, chao.bi@intel.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 03/11] spi/pxa2xx-pci: switch to use pcim_* interfaces
Date: Mon,  7 Jan 2013 12:44:32 +0200
Message-Id: <1357555480-24022-4-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of open-coding all the error management in the driver we can take
advantage of the pcim_* interfaces that release the resources automatically.

We also use platform_device_register_full() to register the platform device
because it allows us to create and register the platform device at one go,
simplifying the error management.

This a preparatory step for getting rid of pxa_ssp_request()/free() which
we will do in the next patch.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi-pxa2xx-pci.c |   86 +++++++++++++++---------------------------
 1 file changed, 30 insertions(+), 56 deletions(-)

diff --git a/drivers/spi/spi-pxa2xx-pci.c b/drivers/spi/spi-pxa2xx-pci.c
index cf95587..ece979e 100644
--- a/drivers/spi/spi-pxa2xx-pci.c
+++ b/drivers/spi/spi-pxa2xx-pci.c
@@ -54,101 +54,75 @@ EXPORT_SYMBOL_GPL(pxa_ssp_free);
 static int ce4100_spi_probe(struct pci_dev *dev,
 		const struct pci_device_id *ent)
 {
+	struct platform_device_info pi;
 	int ret;
-	resource_size_t phys_beg;
-	resource_size_t phys_len;
 	struct ce4100_info *spi_info;
 	struct platform_device *pdev;
 	struct pxa2xx_spi_master spi_pdata;
 	struct ssp_device *ssp;
 
-	ret = pci_enable_device(dev);
+	ret = pcim_enable_device(dev);
 	if (ret)
 		return ret;
 
-	phys_beg = pci_resource_start(dev, 0);
-	phys_len = pci_resource_len(dev, 0);
-
-	if (!request_mem_region(phys_beg, phys_len,
-				"CE4100 SPI")) {
-		dev_err(&dev->dev, "Can't request register space.\n");
-		ret = -EBUSY;
+	ret = pcim_iomap_regions(dev, 1 << 0, "PXA2xx SPI");
+	if (!ret)
 		return ret;
-	}
 
-	pdev = platform_device_alloc("pxa2xx-spi", dev->devfn);
-	spi_info = kzalloc(sizeof(*spi_info), GFP_KERNEL);
-	if (!pdev || !spi_info ) {
-		ret = -ENOMEM;
-		goto err_nomem;
-	}
+	spi_info = devm_kzalloc(&dev->dev, sizeof(*spi_info), GFP_KERNEL);
+	if (!spi_info)
+		return -ENOMEM;
+
 	memset(&spi_pdata, 0, sizeof(spi_pdata));
 	spi_pdata.num_chipselect = dev->devfn;
 
-	ret = platform_device_add_data(pdev, &spi_pdata, sizeof(spi_pdata));
-	if (ret)
-		goto err_nomem;
-
-	pdev->dev.parent = &dev->dev;
-	pdev->dev.of_node = dev->dev.of_node;
 	ssp = &spi_info->ssp;
 	ssp->phys_base = pci_resource_start(dev, 0);
-	ssp->mmio_base = ioremap(phys_beg, phys_len);
+	ssp->mmio_base = pcim_iomap_table(dev)[0];
 	if (!ssp->mmio_base) {
-		dev_err(&pdev->dev, "failed to ioremap() registers\n");
-		ret = -EIO;
-		goto err_nomem;
+		dev_err(&dev->dev, "failed to ioremap() registers\n");
+		return -EIO;
 	}
 	ssp->irq = dev->irq;
-	ssp->port_id = pdev->id;
+	ssp->port_id = dev->devfn;
 	ssp->type = PXA25x_SSP;
 
 	mutex_lock(&ssp_lock);
 	list_add(&ssp->node, &ssp_list);
 	mutex_unlock(&ssp_lock);
 
-	pci_set_drvdata(dev, spi_info);
+	memset(&pi, 0, sizeof(pi));
+	pi.parent = &dev->dev;
+	pi.name = "pxa2xx-spi";
+	pi.id = ssp->port_id;
+	pi.data = &spi_pdata;
+	pi.size_data = sizeof(spi_pdata);
 
-	ret = platform_device_add(pdev);
-	if (ret)
-		goto err_dev_add;
+	pdev = platform_device_register_full(&pi);
+	if (!pdev) {
+		mutex_lock(&ssp_lock);
+		list_del(&ssp->node);
+		mutex_unlock(&ssp_lock);
 
-	return ret;
+		return -ENOMEM;
+	}
 
-err_dev_add:
-	pci_set_drvdata(dev, NULL);
-	mutex_lock(&ssp_lock);
-	list_del(&ssp->node);
-	mutex_unlock(&ssp_lock);
-	iounmap(ssp->mmio_base);
+	spi_info->spi_pdev = pdev;
+	pci_set_drvdata(dev, spi_info);
 
-err_nomem:
-	release_mem_region(phys_beg, phys_len);
-	platform_device_put(pdev);
-	kfree(spi_info);
-	return ret;
+	return 0;
 }
 
 static void ce4100_spi_remove(struct pci_dev *dev)
 {
-	struct ce4100_info *spi_info;
-	struct ssp_device *ssp;
+	struct ce4100_info *spi_info = pci_get_drvdata(dev);
+	struct ssp_device *ssp = &spi_info->ssp;
 
-	spi_info = pci_get_drvdata(dev);
-	ssp = &spi_info->ssp;
 	platform_device_unregister(spi_info->spi_pdev);
 
-	iounmap(ssp->mmio_base);
-	release_mem_region(pci_resource_start(dev, 0),
-			pci_resource_len(dev, 0));
-
 	mutex_lock(&ssp_lock);
 	list_del(&ssp->node);
 	mutex_unlock(&ssp_lock);
-
-	pci_set_drvdata(dev, NULL);
-	pci_disable_device(dev);
-	kfree(spi_info);
 }
 
 static DEFINE_PCI_DEVICE_TABLE(ce4100_spi_devices) = {
-- 
1.7.10.4


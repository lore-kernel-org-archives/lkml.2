Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab2KWLdl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 06:33:41 -0500
Received: from mga01.intel.com ([192.55.52.88]:1596 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab2KWLdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 06:33:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,307,1352102400"; 
   d="scan'208";a="253225958"
From: Adrian Hunter <adrian.hunter@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chris Ball <cjb@laptop.org>, mika.westerberg@linux.intel.com,
        linux-mmc@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] mmc: sdhci-acpi: add SDHCI ACPI driver
Date: Fri, 23 Nov 2012 13:36:01 +0200
Message-Id: <1353670561-22515-4-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353670561-22515-1-git-send-email-adrian.hunter@intel.com>
References: <1353670561-22515-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Chris Ball <cjb@laptop.org>
---
 drivers/mmc/host/Kconfig      |  12 ++
 drivers/mmc/host/Makefile     |   1 +
 drivers/mmc/host/sdhci-acpi.c | 304 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 317 insertions(+)
 create mode 100644 drivers/mmc/host/sdhci-acpi.c

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 9bf10e7..56eac10 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -81,6 +81,18 @@ config MMC_RICOH_MMC
 
 	  If unsure, say Y.
 
+config MMC_SDHCI_ACPI
+	tristate "SDHCI support for ACPI enumerated SDHCI controllers"
+	depends on MMC_SDHCI && ACPI
+	help
+	  This selects support for ACPI enumerated SDHCI controllers,
+	  identified by ACPI Compatibility ID PNP0D40 or specific
+	  ACPI Hardware IDs.
+
+	  If you have a controller with this interface, say Y or M here.
+
+	  If unsure, say N.
+
 config MMC_SDHCI_PLTFM
 	tristate "SDHCI platform and OF driver helper"
 	depends on MMC_SDHCI
diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index 17ad0a7..0e4960a 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_MMC_MXS)		+= mxs-mmc.o
 obj-$(CONFIG_MMC_SDHCI)		+= sdhci.o
 obj-$(CONFIG_MMC_SDHCI_PCI)	+= sdhci-pci.o
 obj-$(subst m,y,$(CONFIG_MMC_SDHCI_PCI))	+= sdhci-pci-data.o
+obj-$(CONFIG_MMC_SDHCI_ACPI)	+= sdhci-acpi.o
 obj-$(CONFIG_MMC_SDHCI_PXAV3)	+= sdhci-pxav3.o
 obj-$(CONFIG_MMC_SDHCI_PXAV2)	+= sdhci-pxav2.o
 obj-$(CONFIG_MMC_SDHCI_S3C)	+= sdhci-s3c.o
diff --git a/drivers/mmc/host/sdhci-acpi.c b/drivers/mmc/host/sdhci-acpi.c
new file mode 100644
index 0000000..6ac3617
--- /dev/null
+++ b/drivers/mmc/host/sdhci-acpi.c
@@ -0,0 +1,304 @@
+/*
+ * Secure Digital Host Controller Interface ACPI driver.
+ *
+ * Copyright (c) 2012, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/export.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/ioport.h>
+#include <linux/io.h>
+#include <linux/dma-mapping.h>
+#include <linux/compiler.h>
+#include <linux/stddef.h>
+#include <linux/bitops.h>
+#include <linux/types.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/acpi.h>
+#include <linux/pm.h>
+#include <linux/pm_runtime.h>
+
+#include <linux/mmc/host.h>
+#include <linux/mmc/pm.h>
+#include <linux/mmc/sdhci.h>
+
+#include "sdhci.h"
+
+enum {
+	SDHCI_ACPI_SD_CD	= BIT(0),
+	SDHCI_ACPI_RUNTIME_PM	= BIT(1),
+};
+
+struct sdhci_acpi_chip {
+	const struct	sdhci_ops *ops;
+	unsigned int	quirks;
+	unsigned int	quirks2;
+	unsigned long	caps;
+	unsigned int	caps2;
+	mmc_pm_flag_t	pm_caps;
+};
+
+struct sdhci_acpi_slot {
+	const struct	sdhci_acpi_chip *chip;
+	unsigned int	quirks;
+	unsigned int	quirks2;
+	unsigned long	caps;
+	unsigned int	caps2;
+	mmc_pm_flag_t	pm_caps;
+	unsigned int	flags;
+};
+
+struct sdhci_acpi_host {
+	struct sdhci_host		*host;
+	const struct sdhci_acpi_slot	*slot;
+	struct platform_device		*pdev;
+	bool				use_runtime_pm;
+};
+
+static inline bool sdhci_acpi_flag(struct sdhci_acpi_host *c, unsigned int flag)
+{
+	return c->slot && (c->slot->flags & flag);
+}
+
+static int sdhci_acpi_enable_dma(struct sdhci_host *host)
+{
+	return 0;
+}
+
+static const struct sdhci_ops sdhci_acpi_ops_dflt = {
+	.enable_dma = sdhci_acpi_enable_dma,
+};
+
+static const struct acpi_device_id sdhci_acpi_ids[] = {
+	{ "PNP0D40" },
+	{ },
+};
+MODULE_DEVICE_TABLE(acpi, sdhci_acpi_ids);
+
+static const struct sdhci_acpi_slot *sdhci_acpi_get_slot(const char *hid)
+{
+	const struct acpi_device_id *id;
+
+	for (id = sdhci_acpi_ids; id->id[0]; id++)
+		if (!strcmp(id->id, hid))
+			return (const struct sdhci_acpi_slot *)id->driver_data;
+	return NULL;
+}
+
+static int __devinit sdhci_acpi_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	acpi_handle handle = ACPI_HANDLE(dev);
+	struct acpi_device *device;
+	struct sdhci_acpi_host *c;
+	struct sdhci_host *host;
+	struct resource *iomem;
+	resource_size_t len;
+	const char *hid;
+	int err;
+
+	if (acpi_bus_get_device(handle, &device))
+		return -ENODEV;
+
+	if (acpi_bus_get_status(device) || !device->status.present)
+		return -ENODEV;
+
+	hid = acpi_device_hid(device);
+
+	iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!iomem)
+		return -ENOMEM;
+
+	len = resource_size(iomem);
+	if (len < 0x100)
+		dev_err(dev, "Invalid iomem size!\n");
+
+	if (!devm_request_mem_region(dev, iomem->start, len, dev_name(dev)))
+		return -ENOMEM;
+
+	host = sdhci_alloc_host(dev, sizeof(struct sdhci_acpi_host));
+	if (IS_ERR(host))
+		return PTR_ERR(host);
+
+	c = sdhci_priv(host);
+	c->host = host;
+	c->slot = sdhci_acpi_get_slot(hid);
+	c->pdev = pdev;
+	c->use_runtime_pm = sdhci_acpi_flag(c, SDHCI_ACPI_RUNTIME_PM);
+
+	platform_set_drvdata(pdev, c);
+
+	host->hw_name	= "ACPI";
+	host->ops	= &sdhci_acpi_ops_dflt;
+	host->irq	= platform_get_irq(pdev, 0);
+
+	host->ioaddr = devm_ioremap_nocache(dev, iomem->start,
+					    resource_size(iomem));
+	if (host->ioaddr == NULL) {
+		err = -ENOMEM;
+		goto err_free;
+	}
+
+	if (!dev->dma_mask) {
+		u64 dma_mask;
+
+		if (sdhci_readl(host, SDHCI_CAPABILITIES) & SDHCI_CAN_64BIT) {
+			/* 64-bit DMA is not supported at present */
+			dma_mask = DMA_BIT_MASK(32);
+		} else {
+			dma_mask = DMA_BIT_MASK(32);
+		}
+
+		dev->dma_mask = &dev->coherent_dma_mask;
+		dev->coherent_dma_mask = dma_mask;
+	}
+
+	if (c->slot) {
+		if (c->slot->chip) {
+			host->ops            = c->slot->chip->ops;
+			host->quirks        |= c->slot->chip->quirks;
+			host->quirks2       |= c->slot->chip->quirks2;
+			host->mmc->caps     |= c->slot->chip->caps;
+			host->mmc->caps2    |= c->slot->chip->caps2;
+			host->mmc->pm_caps  |= c->slot->chip->pm_caps;
+		}
+		host->quirks        |= c->slot->quirks;
+		host->quirks2       |= c->slot->quirks2;
+		host->mmc->caps     |= c->slot->caps;
+		host->mmc->caps2    |= c->slot->caps2;
+		host->mmc->pm_caps  |= c->slot->pm_caps;
+	}
+
+	err = sdhci_add_host(host);
+	if (err)
+		goto err_free;
+
+	if (c->use_runtime_pm) {
+		pm_suspend_ignore_children(dev, 1);
+		pm_runtime_set_autosuspend_delay(dev, 50);
+		pm_runtime_use_autosuspend(dev);
+		pm_runtime_enable(dev);
+	}
+
+	return 0;
+
+err_free:
+	platform_set_drvdata(pdev, NULL);
+	sdhci_free_host(c->host);
+	return err;
+}
+
+static int __devexit sdhci_acpi_remove(struct platform_device *pdev)
+{
+	struct sdhci_acpi_host *c = platform_get_drvdata(pdev);
+	struct device *dev = &pdev->dev;
+	int dead;
+
+	if (c->use_runtime_pm) {
+		pm_runtime_get_sync(dev);
+		pm_runtime_disable(dev);
+		pm_runtime_put_noidle(dev);
+	}
+
+	dead = (sdhci_readl(c->host, SDHCI_INT_STATUS) == ~0);
+	sdhci_remove_host(c->host, dead);
+	platform_set_drvdata(pdev, NULL);
+	sdhci_free_host(c->host);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+
+static int sdhci_acpi_suspend(struct device *dev)
+{
+	struct sdhci_acpi_host *c = dev_get_drvdata(dev);
+
+	return sdhci_suspend_host(c->host);
+}
+
+static int sdhci_acpi_resume(struct device *dev)
+{
+	struct sdhci_acpi_host *c = dev_get_drvdata(dev);
+
+	return sdhci_resume_host(c->host);
+}
+
+#else
+
+#define sdhci_acpi_suspend	NULL
+#define sdhci_acpi_resume	NULL
+
+#endif
+
+#ifdef CONFIG_PM_RUNTIME
+
+static int sdhci_acpi_runtime_suspend(struct device *dev)
+{
+	struct sdhci_acpi_host *c = dev_get_drvdata(dev);
+
+	return sdhci_runtime_suspend_host(c->host);
+}
+
+static int sdhci_acpi_runtime_resume(struct device *dev)
+{
+	struct sdhci_acpi_host *c = dev_get_drvdata(dev);
+
+	return sdhci_runtime_resume_host(c->host);
+}
+
+static int sdhci_acpi_runtime_idle(struct device *dev)
+{
+	return 0;
+}
+
+#else
+
+#define sdhci_acpi_runtime_suspend	NULL
+#define sdhci_acpi_runtime_resume	NULL
+#define sdhci_acpi_runtime_idle		NULL
+
+#endif
+
+static const struct dev_pm_ops sdhci_acpi_pm_ops = {
+	.suspend		= sdhci_acpi_suspend,
+	.resume			= sdhci_acpi_resume,
+	.runtime_suspend	= sdhci_acpi_runtime_suspend,
+	.runtime_resume		= sdhci_acpi_runtime_resume,
+	.runtime_idle		= sdhci_acpi_runtime_idle,
+};
+
+static struct platform_driver sdhci_acpi_driver = {
+	.driver = {
+		.name			= "sdhci-acpi",
+		.owner			= THIS_MODULE,
+		.acpi_match_table	= sdhci_acpi_ids,
+		.pm			= &sdhci_acpi_pm_ops,
+	},
+	.probe	= sdhci_acpi_probe,
+	.remove	= __devexit_p(sdhci_acpi_remove),
+};
+
+module_platform_driver(sdhci_acpi_driver);
+
+MODULE_DESCRIPTION("Secure Digital Host Controller Interface ACPI driver");
+MODULE_AUTHOR("Adrian Hunter");
+MODULE_LICENSE("GPL v2");
-- 
1.7.11.7


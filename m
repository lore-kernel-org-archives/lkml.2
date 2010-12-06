Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab0LFMuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 07:50:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:48508 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491Ab0LFMuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 07:50:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,305,1288594800"; 
   d="scan'208,223";a="633512325"
Date: Mon, 6 Dec 2010 20:22:36 +0800
From: Yunpeng Gao <yunpeng.gao@intel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3]mmc: enable runtime PM support of sdhci host
	controller
Message-ID: <20101206122236.GC30654@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From fab85166c387c5f590ab2d85ab73af52c684a6a5 Mon Sep 17 00:00:00 2001
From: Yunpeng Gao <yunpeng.gao@intel.com>
Date: Sun, 28 Nov 2010 08:27:46 +0800
Subject: [PATCH] Enable runtime pm support of sdhci host controller with pci interface.

Follow the kernel runtime pm framework, enable runtime pm support
of the sdhci host controller with pci interface.

Signed-off-by: Yunpeng Gao <yunpeng.gao@intel.com>
---
 drivers/mmc/host/sdhci-pci.c |  120 ++++++++++++++++++++++++++++++++++++++++++
 drivers/mmc/host/sdhci.c     |   44 +++++++++++++++
 drivers/mmc/host/sdhci.h     |    5 ++
 3 files changed, 169 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 3d9c246..a78eb16 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -18,6 +18,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
 #include <linux/device.h>
+#include <linux/pm_runtime.h>
 
 #include <linux/mmc/host.h>
 
@@ -934,6 +935,10 @@ static int __devinit sdhci_pci_probe(struct pci_dev *pdev,
 		chip->slots[i] = slot;
 	}
 
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_allow(&pdev->dev);
+
 	return 0;
 
 free:
@@ -960,9 +965,121 @@ static void __devexit sdhci_pci_remove(struct pci_dev *pdev)
 		kfree(chip);
 	}
 
+	pm_runtime_forbid(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
 	pci_disable_device(pdev);
 }
 
+#ifdef CONFIG_PM_RUNTIME
+
+static int sdhci_pci_runtime_suspend(struct device *dev)
+{
+	struct pci_dev *pdev = container_of(dev, struct pci_dev, dev);
+	struct sdhci_pci_chip *chip;
+	struct sdhci_pci_slot *slot;
+	int i, ret;
+	mmc_pm_flag_t pm_flags = 0;
+	pm_message_t state;
+
+	chip = pci_get_drvdata(pdev);
+	if (!chip)
+		return 0;
+
+	for (i = 0; i < chip->num_slots; i++) {
+		slot = chip->slots[i];
+		if (!slot)
+			continue;
+
+		ret = sdhci_runtime_suspend(slot->host);
+
+		if (ret) {
+			for (i--; i >= 0; i--)
+				sdhci_runtime_resume(chip->slots[i]->host);
+			return ret;
+		}
+
+		pm_flags |= slot->host->mmc->pm_flags;
+	}
+
+	state.event = PM_EVENT_AUTO_SUSPEND;
+	if (chip->fixes && chip->fixes->suspend) {
+		ret = chip->fixes->suspend(chip, state);
+		if (ret) {
+			for (i = chip->num_slots - 1; i >= 0; i--)
+				sdhci_runtime_resume(chip->slots[i]->host);
+			return ret;
+		}
+	}
+
+	pci_save_state(pdev);
+	if (pm_flags & MMC_PM_KEEP_POWER) {
+		if (pm_flags & MMC_PM_WAKE_SDIO_IRQ)
+			pci_enable_wake(pdev, PCI_D3hot, 1);
+	} else {
+		pci_enable_wake(pdev, PCI_D3hot, 0);
+		pci_disable_device(pdev);
+	}
+	pci_set_power_state(pdev, PCI_D3hot);
+
+	return 0;
+}
+
+static int sdhci_pci_runtime_resume(struct device *dev)
+{
+	struct pci_dev *pdev = container_of(dev, struct pci_dev, dev);
+	struct sdhci_pci_chip *chip;
+	struct sdhci_pci_slot *slot;
+	int i, ret;
+
+	chip = pci_get_drvdata(pdev);
+	if (!chip)
+		return 0;
+
+	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
+	ret = pci_enable_device(pdev);
+	if (ret)
+		return ret;
+
+	if (chip->fixes && chip->fixes->resume) {
+		ret = chip->fixes->resume(chip);
+		if (ret)
+			return ret;
+	}
+
+	for (i = 0; i < chip->num_slots; i++) {
+		slot = chip->slots[i];
+		if (!slot)
+			continue;
+
+		ret = sdhci_runtime_resume(slot->host);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int sdhci_pci_runtime_idle(struct device *dev)
+{
+	return 0;
+}
+
+#else
+
+#define sdhci_pci_runtime_suspend	NULL
+#define sdhci_pci_runtime_resume	NULL
+#define sdhci_pci_runtime_idle		NULL
+
+#endif
+
+static const struct dev_pm_ops sdhci_pci_pm_ops = {
+	.runtime_suspend = sdhci_pci_runtime_suspend,
+	.runtime_resume = sdhci_pci_runtime_resume,
+	.runtime_idle = sdhci_pci_runtime_idle,
+};
+
 static struct pci_driver sdhci_driver = {
 	.name = 	"sdhci-pci",
 	.id_table =	pci_ids,
@@ -970,6 +1087,9 @@ static struct pci_driver sdhci_driver = {
 	.remove =	__devexit_p(sdhci_pci_remove),
 	.suspend =	sdhci_pci_suspend,
 	.resume	=	sdhci_pci_resume,
+	.driver =	{
+		.pm =	&sdhci_pci_pm_ops
+	},
 };
 
 /*****************************************************************************\
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index a25db42..c437390 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1707,6 +1707,50 @@ EXPORT_SYMBOL_GPL(sdhci_enable_irq_wakeups);
 
 #endif /* CONFIG_PM */
 
+#ifdef CONFIG_PM_RUNTIME
+
+int sdhci_runtime_suspend(struct sdhci_host *host)
+{
+	int ret = 0;
+
+	if (host->vmmc)
+		ret = regulator_disable(host->vmmc);
+
+	return ret;
+}
+
+EXPORT_SYMBOL_GPL(sdhci_runtime_suspend);
+
+int sdhci_runtime_resume(struct sdhci_host *host)
+{
+	int ret = 0;
+
+	if (host->vmmc) {
+		int ret = regulator_enable(host->vmmc);
+		if (ret)
+			return ret;
+	}
+
+	if (host->flags & (SDHCI_USE_SDMA | SDHCI_USE_ADMA)) {
+		if (host->ops->enable_dma)
+			host->ops->enable_dma(host);
+	}
+
+	sdhci_init(host, (host->mmc->pm_flags & MMC_PM_KEEP_POWER));
+
+	if (host->mmc->pm_flags & MMC_PM_KEEP_POWER)
+		sdhci_set_ios(host->mmc, &host->mmc->ios);
+
+	mmiowb();
+
+	return ret;
+}
+
+EXPORT_SYMBOL_GPL(sdhci_runtime_resume);
+
+#endif /* CONFIG_PM_RUNTIME */
+
+
 /*****************************************************************************\
  *                                                                           *
  * Device allocation/registration                                            *
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index e42d7f0..d3a8855 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -326,4 +326,9 @@ extern int sdhci_resume_host(struct sdhci_host *host);
 extern void sdhci_enable_irq_wakeups(struct sdhci_host *host);
 #endif
 
+#ifdef CONFIG_PM_RUNTIME
+extern int sdhci_runtime_suspend(struct sdhci_host *host);
+extern int sdhci_runtime_resume(struct sdhci_host *host);
+#endif
+
 #endif /* __SDHCI_HW_H */
-- 
1.6.6.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab1ANI2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 03:28:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:47304 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757363Ab1ANI2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 03:28:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,322,1291622400"; 
   d="scan'208";a="592928949"
Date: Fri, 14 Jan 2011 16:23:18 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, ohad@wizery.com
Subject: [PATCH v1 2/3]mmc: implemented SDHCI host controller driver
	runtime pm
Message-ID: <20110114082318.GC27523@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add runtime power managment for sdhci pci host

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 drivers/mmc/host/sdhci-pci.c |  104 ++++++++++++++++++++++++++++++++++++++++++
 drivers/mmc/host/sdhci.c     |   39 ++++++++++++++++
 drivers/mmc/host/sdhci.h     |    5 ++
 3 files changed, 148 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 0dc905b..c2c4e97 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -18,6 +18,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
 #include <linux/device.h>
+#include <linux/pm_runtime.h>
 
 #include <linux/mmc/host.h>
 
@@ -1083,6 +1084,10 @@ static int __devinit sdhci_pci_probe(struct pci_dev *pdev,
 		chip->slots[i] = slot;
 	}
 
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_allow(&pdev->dev);
+
 	return 0;
 
 free:
@@ -1099,6 +1104,8 @@ static void __devexit sdhci_pci_remove(struct pci_dev *pdev)
 	int i;
 	struct sdhci_pci_chip *chip;
 
+	pm_runtime_get_sync(&pdev->dev);
+
 	chip = pci_get_drvdata(pdev);
 
 	if (chip) {
@@ -1110,8 +1117,102 @@ static void __devexit sdhci_pci_remove(struct pci_dev *pdev)
 	}
 
 	pci_disable_device(pdev);
+
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_forbid(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+}
+
+#ifdef CONFIG_PM_RUNTIME
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
+	return 0;
 }
 
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
+#define sdhci_pci_runtime_suspend	NULL
+#define sdhci_pci_runtime_resume	NULL
+#define sdhci_pci_runtime_idle		NULL
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
@@ -1119,6 +1220,9 @@ static struct pci_driver sdhci_driver = {
 	.remove =	__devexit_p(sdhci_pci_remove),
 	.suspend =	sdhci_pci_suspend,
 	.resume	=	sdhci_pci_resume,
+	.driver = {
+		.pm = &sdhci_pci_pm_ops
+	},
 };
 
 /*****************************************************************************\
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 9e15f41..89464bd 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1715,6 +1715,45 @@ EXPORT_SYMBOL_GPL(sdhci_enable_irq_wakeups);
 
 #endif /* CONFIG_PM */
 
+#ifdef CONFIG_PM_RUNTIME
+int sdhci_runtime_suspend(struct sdhci_host *host)
+{
+	int ret = 0;
+
+	if (host->vmmc)
+		ret = regulator_disable(host->vmmc);
+
+	host->clock = 0;
+	host->pwr = 0;
+
+	return ret;
+}
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
+	sdhci_set_ios(host->mmc, &host->mmc->ios);
+	mmiowb();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sdhci_runtime_resume);
+#endif /* CONFIG_PM_RUNTIME */
+
 /*****************************************************************************\
  *                                                                           *
  * Device allocation/registration                                            *
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 6e0969e..1f032c0 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -327,4 +327,9 @@ extern int sdhci_resume_host(struct sdhci_host *host);
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


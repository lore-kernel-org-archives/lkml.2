Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab1BFSDZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 13:03:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:50627 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488Ab1BFSDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 13:03:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,434,1291622400"; 
   d="scan'208";a="884836438"
From: Pierre Tardy <pierre.tardy@intel.com>
To: linux-pm@lists.linux-foundation.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Yunpeng Gao <yunpeng.gao@intel.com>, Pierre Tardy <pierre.tardy@intel.com>
Subject: [PATCH v2 2/3] sdhci-pci : Enable runtime PM support
Date: Sun,  6 Feb 2011 19:02:49 +0100
Message-Id: <6722fa7986194808f4d69a1e5ba6d3f163b77da9.1297014479.git.pierre.tardy@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1297014479.git.pierre.tardy@intel.com>
References: <cover.1297014479.git.pierre.tardy@intel.com>
In-Reply-To: <cover.1297014479.git.pierre.tardy@intel.com>
References: <cover.1297014479.git.pierre.tardy@intel.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yunpeng Gao <yunpeng.gao@intel.com>

Follow the kernel runtime PM framework, enable runtime PM support of the
sdhci host controller with pci interface.

Note that this patch implements runtime_pm but now actually detects
activity.
It relies on higher level (childrens) to do actual waking up
Activity detection is put in following patch

Original version from: Yunpeng Gao <yunpeng.gao@intel.com>
with modifications by: Pierre Tardy <pierre.tardy@intel.com>

Signed-off-by: Pierre Tardy <pierre.tardy@intel.com>
---
 drivers/mmc/host/sdhci-pci.c |  121 ++++++++++++++++++++++++++++++++++++++++++
 drivers/mmc/host/sdhci.c     |   31 +++++++++++
 drivers/mmc/host/sdhci.h     |    5 ++
 3 files changed, 157 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 0dc905b..22581a1 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -1027,6 +1027,8 @@ static int __devinit sdhci_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		return ret;
 
+	pm_runtime_set_active(&pdev->dev);
+
 	slots = PCI_SLOT_INFO_SLOTS(slots) + 1;
 	dev_dbg(&pdev->dev, "found %d slot(s)\n", slots);
 	if (slots == 0)
@@ -1082,6 +1084,8 @@ static int __devinit sdhci_pci_probe(struct pci_dev *pdev,
 
 		chip->slots[i] = slot;
 	}
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_allow(&pdev->dev);
 
 	return 0;
 
@@ -1110,8 +1114,122 @@ static void __devexit sdhci_pci_remove(struct pci_dev *pdev)
 	}
 
 	pci_disable_device(pdev);
+
+	pm_runtime_forbid(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
+}
+
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
+	pm_runtime_autosuspend(dev);
+	return -EAGAIN;
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
@@ -1119,6 +1237,9 @@ static struct pci_driver sdhci_driver = {
 	.remove =	__devexit_p(sdhci_pci_remove),
 	.suspend =	sdhci_pci_suspend,
 	.resume	=	sdhci_pci_resume,
+	.driver =	{
+		.pm =	&sdhci_pci_pm_ops
+	},
 };
 
 /*****************************************************************************\
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 9e15f41..3e65d94 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1715,6 +1715,37 @@ EXPORT_SYMBOL_GPL(sdhci_enable_irq_wakeups);
 
 #endif /* CONFIG_PM */
 
+#ifdef CONFIG_PM_RUNTIME
+
+int sdhci_runtime_suspend(struct sdhci_host *host)
+{
+	/* Nothing to do yet. Still leave the placeholder */
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(sdhci_runtime_suspend);
+
+int sdhci_runtime_resume(struct sdhci_host *host)
+{
+	int ret = 0;
+
+	if (host->flags & (SDHCI_USE_SDMA | SDHCI_USE_ADMA)) {
+		if (host->ops->enable_dma)
+			host->ops->enable_dma(host);
+	}
+
+	sdhci_init(host, (host->mmc->pm_flags & MMC_PM_KEEP_POWER));
+	host->pwr = 0; /* force power reprogram */
+	host->clock = 0; /* force clock reprogram */
+	sdhci_set_ios(host->mmc, &host->mmc->ios);
+	mmiowb();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sdhci_runtime_resume);
+
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
1.7.2.3

---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.


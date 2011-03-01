Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab1CASPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 13:15:53 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59213 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab1CASPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 13:15:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RSQ8ZmLp7EGuVqfqx8UDPlC1yRodY6dwpaknSuw3RnMsfu2x2O6pp+1OAh9UKU0w1/
         q4I4xp/C5r25WX4tGr+MSj496O3DTxGHJub9uwYq9gyUyYU5fEjXjUpbwYEIfbNSjfFJ
         +rt8wi/2xvjMYkS/kGdjG0rGlLX51mLIeHkvA=
From: Pierre Tardy <tardyp@gmail.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-mmc@vger.kernel.org
Cc: Yunpeng Gao <yunpeng.gao@intel.com>, Pierre Tardy <pierre.tardy@intel.com>
Subject: [RFC,PATCHv3 1/3] mmc: sdhci-pci: Enable runtime PM support
Date: Tue,  1 Mar 2011 19:15:31 +0100
Message-Id: <1c071e206d0d02e07d3872f20268fba6b101a6b4.1298820826.git.tardyp@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1298820825.git.tardyp@gmail.com>
References: <cover.1298820825.git.tardyp@gmail.com>
In-Reply-To: <cover.1298820825.git.tardyp@gmail.com>
References: <cover.1298820825.git.tardyp@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yunpeng Gao <yunpeng.gao@intel.com>

Follow the kernel runtime PM framework, enable runtime PM support of the
sdhci host controller with pci interface.

Note that this patch implements runtime_pm but now actually detects
activity.
It relies on higher level (childrens) to do actual waking up
Activity detection is put in a following patch

This patch also does not enable wakeups, so card insertion will not work
if runtime_pm is activated.
This is also dealt in a following patch

Original version from: Yunpeng Gao <yunpeng.gao@intel.com>
with modifications by: Pierre Tardy <pierre.tardy@intel.com>

Signed-off-by: Pierre Tardy <pierre.tardy@intel.com>
---
 drivers/mmc/host/sdhci-pci.c |  120 +++++++++++++++++++++++++++++++++++++++++-
 drivers/mmc/host/sdhci.c     |   31 +++++++++++
 drivers/mmc/host/sdhci.h     |    5 ++
 3 files changed, 155 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 2f8d468..f167a55 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -18,6 +18,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
 #include <linux/device.h>
+#include <linux/pm_runtime.h>
 
 #include <linux/mmc/host.h>
 
@@ -1031,6 +1032,8 @@ static int __devinit sdhci_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		return ret;
 
+	pm_runtime_set_active(&pdev->dev);
+
 	slots = PCI_SLOT_INFO_SLOTS(slots) + 1;
 	dev_dbg(&pdev->dev, "found %d slot(s)\n", slots);
 	if (slots == 0)
@@ -1086,7 +1089,7 @@ static int __devinit sdhci_pci_probe(struct pci_dev *pdev,
 
 		chip->slots[i] = slot;
 	}
-
+	pm_runtime_put_noidle(&pdev->dev);
 	return 0;
 
 free:
@@ -1114,8 +1117,120 @@ static void __devexit sdhci_pci_remove(struct pci_dev *pdev)
 	}
 
 	pci_disable_device(pdev);
+	pm_runtime_get_noresume(&pdev->dev);
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
@@ -1123,6 +1238,9 @@ static struct pci_driver sdhci_driver = {
 	.remove =	__devexit_p(sdhci_pci_remove),
 	.suspend =	sdhci_pci_suspend,
 	.resume	=	sdhci_pci_resume,
+	.driver =	{
+		.pm =	&sdhci_pci_pm_ops
+	},
 };
 
 /*****************************************************************************\
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 9e15f41..cd79a28 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1715,6 +1715,37 @@ EXPORT_SYMBOL_GPL(sdhci_enable_irq_wakeups);
 
 #endif /* CONFIG_PM */
 
+#ifdef CONFIG_PM_RUNTIME
+
+int sdhci_runtime_suspend(struct sdhci_host *host)
+{
+	/* nothing to do yet */
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
1.7.1


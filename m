Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab1KBG6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 02:58:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:62198 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101Ab1KBG5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 02:57:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,442,1315206000"; 
   d="scan'208";a="80330823"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V2 4/4] mmc: sdhci-pci: get gpio numbers from platform data
Date: Wed,  2 Nov 2011 08:57:21 +0200
Message-Id: <1320217041-2580-5-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320217041-2580-1-git-send-email-adrian.hunter@intel.com>
References: <1320217041-2580-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Retrieve the GPIO numbers for hardware reset and
card detect from platform data.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/mmc/host/sdhci-pci.c |  105 +++++++++++++++---------------------------
 1 files changed, 38 insertions(+), 67 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 9d1874a..3d842d9 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -23,7 +23,6 @@
 #include <linux/scatterlist.h>
 #include <linux/io.h>
 #include <linux/gpio.h>
-#include <linux/sfi.h>
 #include <linux/pm_runtime.h>
 #include <linux/mmc/sdhci-pci-data.h>
 
@@ -174,32 +173,9 @@ static int mrst_hc_probe(struct sdhci_pci_chip *chip)
 	return 0;
 }
 
-/* Medfield eMMC hardware reset GPIOs */
-static int mfd_emmc0_rst_gpio = -EINVAL;
-static int mfd_emmc1_rst_gpio = -EINVAL;
-
-static int mfd_emmc_gpio_parse(struct sfi_table_header *table)
-{
-	struct sfi_table_simple *sb = (struct sfi_table_simple *)table;
-	struct sfi_gpio_table_entry *entry;
-	int i, num;
-
-	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_gpio_table_entry);
-	entry = (struct sfi_gpio_table_entry *)sb->pentry;
-
-	for (i = 0; i < num; i++, entry++) {
-		if (!strncmp(entry->pin_name, "emmc0_rst", SFI_NAME_LEN))
-			mfd_emmc0_rst_gpio = entry->pin_no;
-		else if (!strncmp(entry->pin_name, "emmc1_rst", SFI_NAME_LEN))
-			mfd_emmc1_rst_gpio = entry->pin_no;
-	}
-
-	return 0;
-}
-
 #ifdef CONFIG_PM_RUNTIME
 
-static irqreturn_t mfd_sd_cd(int irq, void *dev_id)
+static irqreturn_t sdhci_pci_sd_cd(int irq, void *dev_id)
 {
 	struct sdhci_pci_slot *slot = dev_id;
 	struct sdhci_host *host = slot->host;
@@ -208,15 +184,16 @@ static irqreturn_t mfd_sd_cd(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-#define MFLD_SD_CD_PIN 69
-
-static int mfd_sd_probe_slot(struct sdhci_pci_slot *slot)
+static void sdhci_pci_add_own_cd(struct sdhci_pci_slot *slot)
 {
-	int err, irq, gpio = MFLD_SD_CD_PIN;
+	int err, irq, gpio = slot->cd_gpio;
 
 	slot->cd_gpio = -EINVAL;
 	slot->cd_irq = -EINVAL;
 
+	if (!gpio_is_valid(gpio))
+		return;
+
 	err = gpio_request(gpio, "sd_cd");
 	if (err < 0)
 		goto out;
@@ -229,7 +206,7 @@ static int mfd_sd_probe_slot(struct sdhci_pci_slot *slot)
 	if (irq < 0)
 		goto out_free;
 
-	err = request_irq(irq, mfd_sd_cd, IRQF_TRIGGER_RISING |
+	err = request_irq(irq, sdhci_pci_sd_cd, IRQF_TRIGGER_RISING |
 			  IRQF_TRIGGER_FALLING, "sd_cd", slot);
 	if (err)
 		goto out_free;
@@ -238,16 +215,15 @@ static int mfd_sd_probe_slot(struct sdhci_pci_slot *slot)
 	slot->cd_irq = irq;
 	slot->host->quirks2 |= SDHCI_QUIRK2_OWN_CARD_DETECTION;
 
-	return 0;
+	return;
 
 out_free:
 	gpio_free(gpio);
 out:
 	dev_warn(&slot->chip->pdev->dev, "failed to setup card detect wake up\n");
-	return 0;
 }
 
-static void mfd_sd_remove_slot(struct sdhci_pci_slot *slot, int dead)
+static void sdhci_pci_remove_own_cd(struct sdhci_pci_slot *slot)
 {
 	if (slot->cd_irq >= 0)
 		free_irq(slot->cd_irq, slot);
@@ -256,47 +232,23 @@ static void mfd_sd_remove_slot(struct sdhci_pci_slot *slot, int dead)
 
 #else
 
-#define mfd_sd_probe_slot	NULL
-#define mfd_sd_remove_slot	NULL
+static inline void sdhci_pci_add_own_cd(struct sdhci_pci_slot *slot)
+{
+}
+
+static inline void sdhci_pci_remove_own_cd(struct sdhci_pci_slot *slot)
+{
+}
 
 #endif
 
 static int mfd_emmc_probe_slot(struct sdhci_pci_slot *slot)
 {
-	const char *name = NULL;
-	int gpio = -EINVAL;
-
-	sfi_table_parse(SFI_SIG_GPIO, NULL, NULL, mfd_emmc_gpio_parse);
-
-	switch (slot->chip->pdev->device) {
-	case PCI_DEVICE_ID_INTEL_MFD_EMMC0:
-		gpio = mfd_emmc0_rst_gpio;
-		name = "eMMC0_reset";
-		break;
-	case PCI_DEVICE_ID_INTEL_MFD_EMMC1:
-		gpio = mfd_emmc1_rst_gpio;
-		name = "eMMC1_reset";
-		break;
-	}
-
-	if (!gpio_request(gpio, name)) {
-		gpio_direction_output(gpio, 1);
-		slot->rst_n_gpio = gpio;
-		slot->host->mmc->caps |= MMC_CAP_HW_RESET;
-	}
-
 	slot->host->mmc->caps |= MMC_CAP_8_BIT_DATA | MMC_CAP_NONREMOVABLE;
-
 	slot->host->mmc->caps2 = MMC_CAP2_BOOTPART_NOACC;
-
 	return 0;
 }
 
-static void mfd_emmc_remove_slot(struct sdhci_pci_slot *slot, int dead)
-{
-	gpio_free(slot->rst_n_gpio);
-}
-
 static const struct sdhci_pci_fixes sdhci_intel_mrst_hc0 = {
 	.quirks		= SDHCI_QUIRK_BROKEN_ADMA | SDHCI_QUIRK_NO_HISPD_BIT,
 	.probe_slot	= mrst_hc_probe_slot,
@@ -310,8 +262,6 @@ static const struct sdhci_pci_fixes sdhci_intel_mrst_hc1_hc2 = {
 static const struct sdhci_pci_fixes sdhci_intel_mfd_sd = {
 	.quirks		= SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC,
 	.allow_runtime_pm = true,
-	.probe_slot	= mfd_sd_probe_slot,
-	.remove_slot	= mfd_sd_remove_slot,
 };
 
 static const struct sdhci_pci_fixes sdhci_intel_mfd_sdio = {
@@ -323,7 +273,6 @@ static const struct sdhci_pci_fixes sdhci_intel_mfd_emmc = {
 	.quirks		= SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC,
 	.allow_runtime_pm = true,
 	.probe_slot	= mfd_emmc_probe_slot,
-	.remove_slot	= mfd_emmc_remove_slot,
 };
 
 /* O2Micro extra registers */
@@ -1242,6 +1191,8 @@ static struct sdhci_pci_slot * __devinit sdhci_pci_probe_slot(
 				goto free;
 			}
 		}
+		slot->rst_n_gpio = slot->data->rst_n_gpio;
+		slot->cd_gpio = slot->data->cd_gpio;
 	}
 
 	host->hw_name = "PCI";
@@ -1269,15 +1220,30 @@ static struct sdhci_pci_slot * __devinit sdhci_pci_probe_slot(
 			goto unmap;
 	}
 
+	if (gpio_is_valid(slot->rst_n_gpio)) {
+		if (!gpio_request(slot->rst_n_gpio, "eMMC_reset")) {
+			gpio_direction_output(slot->rst_n_gpio, 1);
+			slot->host->mmc->caps |= MMC_CAP_HW_RESET;
+		} else {
+			dev_warn(&pdev->dev, "failed to request rst_n_gpio\n");
+			slot->rst_n_gpio = -EINVAL;
+		}
+	}
+
 	host->mmc->pm_caps = MMC_PM_KEEP_POWER | MMC_PM_WAKE_SDIO_IRQ;
 
 	ret = sdhci_add_host(host);
 	if (ret)
 		goto remove;
 
+	sdhci_pci_add_own_cd(slot);
+
 	return slot;
 
 remove:
+	if (gpio_is_valid(slot->rst_n_gpio))
+		gpio_free(slot->rst_n_gpio);
+
 	if (chip->fixes && chip->fixes->remove_slot)
 		chip->fixes->remove_slot(slot, 0);
 
@@ -1302,6 +1268,8 @@ static void sdhci_pci_remove_slot(struct sdhci_pci_slot *slot)
 	int dead;
 	u32 scratch;
 
+	sdhci_pci_remove_own_cd(slot);
+
 	dead = 0;
 	scratch = readl(slot->host->ioaddr + SDHCI_INT_STATUS);
 	if (scratch == (u32)-1)
@@ -1309,6 +1277,9 @@ static void sdhci_pci_remove_slot(struct sdhci_pci_slot *slot)
 
 	sdhci_remove_host(slot->host, dead);
 
+	if (gpio_is_valid(slot->rst_n_gpio))
+		gpio_free(slot->rst_n_gpio);
+
 	if (slot->chip->fixes && slot->chip->fixes->remove_slot)
 		slot->chip->fixes->remove_slot(slot, dead);
 
-- 
1.7.6.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab0KXGWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 01:22:05 -0500
Received: from cantor.suse.de ([195.135.220.2]:51571 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab0KXGWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 01:22:03 -0500
From: Takashi Iwai <tiwai@suse.de>
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aries Lee <arieslee@jmicron.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 1/2] mmc: Add support for JMicron 388 SD/MMC controller
Date: Wed, 24 Nov 2010 07:21:13 +0100
Message-Id: <1290579674-4616-2-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1290579674-4616-1-git-send-email-tiwai@suse.de>
References: <1290579674-4616-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

JMicron 388 SD/MMC combo controller supports the 1.8V low-voltage for
SD, but MMC doesn't work with the low-voltage, resulting in an error
at probing.

This patch adds the support for multiple voltage mask per device type,
so that SD works with 1.8V while MMC forces 3.3V.  Here new ocr_avail_*
fields for each device are introduced, so that the actual OCR mask is
switched dynamically.

Also, the restriction of low-voltage in core/sd.c is removed when the
bit is allowed explicitly via ocr_avail_sd mask.

This patch was rewritten from scratch based on Aries' original code.

Signed-off-by: Aries Lee <arieslee@jmicron.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/mmc/core/mmc.c       |    2 ++
 drivers/mmc/core/sd.c        |    5 ++++-
 drivers/mmc/core/sdio.c      |    2 ++
 drivers/mmc/host/sdhci-pci.c |   42 ++++++++++++++++++++++++++++++++++++------
 drivers/mmc/host/sdhci.c     |   11 +++++++++++
 drivers/mmc/host/sdhci.h     |    2 ++
 include/linux/mmc/host.h     |    3 +++
 include/linux/pci_ids.h      |    2 ++
 8 files changed, 62 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 6909a54..e81e6fe 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -703,6 +703,8 @@ int mmc_attach_mmc(struct mmc_host *host, u32 ocr)
 	WARN_ON(!host->claimed);
 
 	mmc_attach_bus_ops(host);
+	if (host->ocr_avail_mmc)
+		host->ocr_avail = host->ocr_avail_mmc;
 
 	/*
 	 * We need to get OCR a different way for SPI.
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 0f52410..7f25b9c 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -768,6 +768,8 @@ int mmc_attach_sd(struct mmc_host *host, u32 ocr)
 	WARN_ON(!host->claimed);
 
 	mmc_sd_attach_bus_ops(host);
+	if (host->ocr_avail_sd)
+		host->ocr_avail = host->ocr_avail_sd;
 
 	/*
 	 * We need to get OCR a different way for SPI.
@@ -791,7 +793,8 @@ int mmc_attach_sd(struct mmc_host *host, u32 ocr)
 		ocr &= ~0x7F;
 	}
 
-	if (ocr & MMC_VDD_165_195) {
+	if ((ocr & MMC_VDD_165_195) &&
+	    !(host->ocr_avail_sd & MMC_VDD_165_195)) {
 		printk(KERN_WARNING "%s: SD card claims to support the "
 		       "incompletely defined 'low voltage range'. This "
 		       "will be ignored.\n", mmc_hostname(host));
diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index f332c52..f7b89e0 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -668,6 +668,8 @@ int mmc_attach_sdio(struct mmc_host *host, u32 ocr)
 	WARN_ON(!host->claimed);
 
 	mmc_attach_bus(host, &mmc_sdio_ops);
+	if (host->ocr_avail_sdio)
+		host->ocr_avail = host->ocr_avail_sdio;
 
 	/*
 	 * Sanity check the voltages that the card claims to
diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index e8aa99d..e2af522 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -173,6 +173,7 @@ static int jmicron_pmos(struct sdhci_pci_chip *chip, int on)
 static int jmicron_probe(struct sdhci_pci_chip *chip)
 {
 	int ret;
+	u16 mmcdev = 0;
 
 	if (chip->pdev->revision == 0) {
 		chip->quirks |= SDHCI_QUIRK_32BIT_DMA_ADDR |
@@ -194,12 +195,17 @@ static int jmicron_probe(struct sdhci_pci_chip *chip)
 	 * 2. The MMC interface has a lower subfunction number
 	 *    than the SD interface.
 	 */
-	if (chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB38X_SD) {
+	if (chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB38X_SD)
+		mmcdev = PCI_DEVICE_ID_JMICRON_JMB38X_MMC;
+	else if (chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB388_SD)
+		mmcdev = PCI_DEVICE_ID_JMICRON_JMB388_ESD;
+
+	if (mmcdev) {
 		struct pci_dev *sd_dev;
 
 		sd_dev = NULL;
 		while ((sd_dev = pci_get_device(PCI_VENDOR_ID_JMICRON,
-			PCI_DEVICE_ID_JMICRON_JMB38X_MMC, sd_dev)) != NULL) {
+						mmcdev, sd_dev)) != NULL) {
 			if ((PCI_SLOT(chip->pdev->devfn) ==
 				PCI_SLOT(sd_dev->devfn)) &&
 				(chip->pdev->bus == sd_dev->bus))
@@ -224,6 +230,10 @@ static int jmicron_probe(struct sdhci_pci_chip *chip)
 		return ret;
 	}
 
+	/* JM388 MMC doesn't support 1.8V while SD supports it */
+	if (chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB388_ESD)
+		chip->quirks |= SDHCI_QUIRK_MMC_VDD_180;
+
 	return 0;
 }
 
@@ -263,7 +273,8 @@ static int jmicron_probe_slot(struct sdhci_pci_slot *slot)
 	 * The secondary interface requires a bit set to get the
 	 * interrupts.
 	 */
-	if (slot->chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB38X_MMC)
+	if (slot->chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB38X_MMC ||
+	    slot->chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB388_ESD)
 		jmicron_enable_mmc(slot->host, 1);
 
 	return 0;
@@ -274,7 +285,8 @@ static void jmicron_remove_slot(struct sdhci_pci_slot *slot, int dead)
 	if (dead)
 		return;
 
-	if (slot->chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB38X_MMC)
+	if (slot->chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB38X_MMC ||
+	    slot->chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB388_ESD)
 		jmicron_enable_mmc(slot->host, 0);
 }
 
@@ -282,7 +294,8 @@ static int jmicron_suspend(struct sdhci_pci_chip *chip, pm_message_t state)
 {
 	int i;
 
-	if (chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB38X_MMC) {
+	if (chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB38X_MMC ||
+	    chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB388_ESD) {
 		for (i = 0;i < chip->num_slots;i++)
 			jmicron_enable_mmc(chip->slots[i]->host, 0);
 	}
@@ -294,7 +307,8 @@ static int jmicron_resume(struct sdhci_pci_chip *chip)
 {
 	int ret, i;
 
-	if (chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB38X_MMC) {
+	if (chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB38X_MMC ||
+	    chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB388_ESD) {
 		for (i = 0;i < chip->num_slots;i++)
 			jmicron_enable_mmc(chip->slots[i]->host, 1);
 	}
@@ -479,6 +493,22 @@ static const struct pci_device_id pci_ids[] __devinitdata = {
 	},
 
 	{
+		.vendor		= PCI_VENDOR_ID_JMICRON,
+		.device		= PCI_DEVICE_ID_JMICRON_JMB388_SD,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (kernel_ulong_t)&sdhci_jmicron,
+	},
+
+	{
+		.vendor		= PCI_VENDOR_ID_JMICRON,
+		.device		= PCI_DEVICE_ID_JMICRON_JMB388_ESD,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (kernel_ulong_t)&sdhci_jmicron,
+	},
+
+	{
 		.vendor		= PCI_VENDOR_ID_SYSKONNECT,
 		.device		= 0x8000,
 		.subvendor	= PCI_ANY_ID,
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 401527d..96e32b1 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1829,6 +1829,10 @@ int sdhci_add_host(struct sdhci_host *host)
 	if (host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION)
 		mmc->caps |= MMC_CAP_NEEDS_POLL;
 
+	/* normal SD controllers don't support 1.8V; exlcude here */
+	if (!(host->quirks & SDHCI_QUIRK_MMC_VDD_180))
+		caps &= ~SDHCI_CAN_VDD_180;
+
 	mmc->ocr_avail = 0;
 	if (caps & SDHCI_CAN_VDD_330)
 		mmc->ocr_avail |= MMC_VDD_32_33|MMC_VDD_33_34;
@@ -1837,6 +1841,13 @@ int sdhci_add_host(struct sdhci_host *host)
 	if (caps & SDHCI_CAN_VDD_180)
 		mmc->ocr_avail |= MMC_VDD_165_195;
 
+	mmc->ocr_avail_sdio = mmc->ocr_avail;
+	mmc->ocr_avail_sd = mmc->ocr_avail;
+	mmc->ocr_avail_mmc = mmc->ocr_avail;
+	/* JMicron 388 combo supports 1.8V for SD but not for MMC */
+	if (host->quirks & SDHCI_QUIRK_MMC_VDD_180)
+		mmc->ocr_avail_mmc &= ~MMC_VDD_165_195;
+
 	if (mmc->ocr_avail == 0) {
 		printk(KERN_ERR "%s: Hardware doesn't report any "
 			"support voltages.\n", mmc_hostname(mmc));
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index d316bc7..cb73651 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -247,6 +247,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12		(1<<28)
 /* Controller doesn't have HISPD bit field in HI-SPEED SD card */
 #define SDHCI_QUIRK_NO_HISPD_BIT			(1<<29)
+/* Controller doesn't support VDD 180 for MMC (for SD/MMC combo chips) */
+#define SDHCI_QUIRK_MMC_VDD_180				(1<<30)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 1575b52..5bb3337 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -124,6 +124,9 @@ struct mmc_host {
 	unsigned int		f_min;
 	unsigned int		f_max;
 	u32			ocr_avail;
+	u32			ocr_avail_sdio;	/* SDIO-specific OCR */
+	u32			ocr_avail_sd;	/* SD-specific OCR */
+	u32			ocr_avail_mmc;	/* MMC-specific OCR */
 	struct notifier_block	pm_notify;
 
 #define MMC_VDD_165_195		0x00000080	/* VDD voltage 1.65 - 1.95 */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index b4c3d1b..40c5bc7 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2358,6 +2358,8 @@
 #define PCI_DEVICE_ID_JMICRON_JMB38X_SD	0x2381
 #define PCI_DEVICE_ID_JMICRON_JMB38X_MMC 0x2382
 #define PCI_DEVICE_ID_JMICRON_JMB38X_MS	0x2383
+#define PCI_DEVICE_ID_JMICRON_JMB388_SD	0x2391
+#define PCI_DEVICE_ID_JMICRON_JMB388_ESD 0x2392
 
 #define PCI_VENDOR_ID_KORENIX		0x1982
 #define PCI_DEVICE_ID_KORENIX_JETCARDF0	0x1600
-- 
1.7.3.1


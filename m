Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039Ab2CNHjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 03:39:13 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:54463 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752034Ab2CNHjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:39:07 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Chris Ball <cjb@laptop.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Adrian Hunter <adrian.hunter@intel.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [PATCH v2] mmc: sdhci-pci: allow 8-bit bus width for Intel PCH
Date: Wed, 14 Mar 2012 08:38:58 +0100
Message-Id: <1331710738-10344-1-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <20120313172514.GA28309@kroah.com>
References: <20120313172514.GA28309@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
---
Changes in v2:
* moved PCI device ID definition to sdhci-pci.c. Thanks Greg for the hint

 drivers/mmc/host/sdhci-pci.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 9382f27..c9db8f8 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -29,6 +29,12 @@
 #include "sdhci.h"
 
 /*
+ * PCI device IDs
+ */
+#define PCI_DEVICE_ID_INTEL_PCH_SDIO0	0x8809
+#define PCI_DEVICE_ID_INTEL_PCH_SDIO1	0x880a
+
+/*
  * PCI registers
  */
 
@@ -172,6 +178,12 @@ static int mrst_hc_probe(struct sdhci_pci_chip *chip)
 	return 0;
 }
 
+static int pch_hc_probe_slot(struct sdhci_pci_slot *slot)
+{
+	slot->host->mmc->caps |= MMC_CAP_8_BIT_DATA;
+	return 0;
+}
+
 #ifdef CONFIG_PM_RUNTIME
 
 static irqreturn_t sdhci_pci_sd_cd(int irq, void *dev_id)
@@ -281,6 +293,11 @@ static const struct sdhci_pci_fixes sdhci_intel_mfd_emmc = {
 	.probe_slot	= mfd_emmc_probe_slot,
 };
 
+static const struct sdhci_pci_fixes sdhci_intel_pch_sdio = {
+	.quirks		= SDHCI_QUIRK_BROKEN_ADMA,
+	.probe_slot	= pch_hc_probe_slot,
+};
+
 /* O2Micro extra registers */
 #define O2_SD_LOCK_WP		0xD3
 #define O2_SD_MULTI_VCC3V	0xEE
@@ -817,6 +834,22 @@ static const struct pci_device_id pci_ids[] __devinitdata = {
 	},
 
 	{
+		.vendor		= PCI_VENDOR_ID_INTEL,
+		.device		= PCI_DEVICE_ID_INTEL_PCH_SDIO0,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (kernel_ulong_t)&sdhci_intel_pch_sdio,
+	},
+
+	{
+		.vendor		= PCI_VENDOR_ID_INTEL,
+		.device		= PCI_DEVICE_ID_INTEL_PCH_SDIO1,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (kernel_ulong_t)&sdhci_intel_pch_sdio,
+	},
+
+	{
 		.vendor		= PCI_VENDOR_ID_O2,
 		.device		= PCI_DEVICE_ID_O2_8120,
 		.subvendor	= PCI_ANY_ID,
-- 
1.7.3.4


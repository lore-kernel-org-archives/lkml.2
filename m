Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab2DRNSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:18:03 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7134 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab2DRNSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:18:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 18 Apr 2012 06:17:48 -0700
From: Pavan Kunapuli <pkunapuli@nvidia.com>
To: <cjb@laptop.org>, <swarren@nvidia.com>, <paul.gortmaker@windriver.com>,
        <olof@lixom.net>, <rmk+kernel@arm.linux.org.uk>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Pavan Kunapuli <pkunapuli@nvidia.com>
Subject: [PATCH V1] mmc: tegra: support SDHCI SPEC 300
Date: Wed, 18 Apr 2012 18:48:02 +0530
Message-ID: <1334755082-26818-1-git-send-email-pkunapuli@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra3 SDHOST controller doesn't advertise
v3.00 support by default. This support has to
be enabled by configuring a vendor register in
the tegra3 sd host address space.

Signed-off-by: Pavan Kunapuli <pkunapuli@nvidia.com>
---
 drivers/mmc/host/sdhci-tegra.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 53b2650..cff0c52 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -32,8 +32,13 @@
 
 #include "sdhci-pltfm.h"
 
+/* Tegra SDHOST controller vendor register definitions */
+#define SDHCI_TEGRA_VENDOR_MISC_CTRL		0x120
+#define SDHCI_MISC_CTRL_ENABLE_SDHCI_SPEC_300	0x20
+
 #define NVQUIRK_FORCE_SDHCI_SPEC_200	BIT(0)
 #define NVQUIRK_ENABLE_BLOCK_GAP_DET	BIT(1)
+#define NVQUIRK_ENABLE_SDHCI_SPEC_300	BIT(2)
 
 struct sdhci_tegra_soc_data {
 	struct sdhci_pltfm_data *pdata;
@@ -120,6 +125,25 @@ static irqreturn_t carddetect_irq(int irq, void *data)
 	return IRQ_HANDLED;
 };
 
+static void tegra_sdhci_reset_exit(struct sdhci_host *host, u8 mask)
+{
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct sdhci_tegra *tegra_host = pltfm_host->priv;
+	const struct sdhci_tegra_soc_data *soc_data = tegra_host->soc_data;
+
+	if (!(mask & SDHCI_RESET_ALL))
+		return;
+
+	/* Erratum: Enable SDHCI spec v3.00 support */
+	if (soc_data->nvquirks & NVQUIRK_ENABLE_SDHCI_SPEC_300) {
+		u32 misc_ctrl;
+
+		misc_ctrl = sdhci_readb(host, SDHCI_TEGRA_VENDOR_MISC_CTRL);
+		misc_ctrl |= SDHCI_MISC_CTRL_ENABLE_SDHCI_SPEC_300;
+		sdhci_writeb(host, misc_ctrl, SDHCI_TEGRA_VENDOR_MISC_CTRL);
+	}
+}
+
 static int tegra_sdhci_8bit(struct sdhci_host *host, int bus_width)
 {
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
@@ -148,6 +172,7 @@ static struct sdhci_ops tegra_sdhci_ops = {
 	.read_w     = tegra_sdhci_readw,
 	.write_l    = tegra_sdhci_writel,
 	.platform_8bit_width = tegra_sdhci_8bit,
+	.platform_reset_exit = tegra_sdhci_reset_exit,
 };
 
 #ifdef CONFIG_ARCH_TEGRA_2x_SOC
@@ -178,6 +203,7 @@ static struct sdhci_pltfm_data sdhci_tegra30_pdata = {
 
 static struct sdhci_tegra_soc_data soc_data_tegra30 = {
 	.pdata = &sdhci_tegra30_pdata,
+	.nvquirks = NVQUIRK_ENABLE_SDHCI_SPEC_300,
 };
 #endif
 
-- 
1.7.1.1


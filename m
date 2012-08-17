Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab2HQJO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 05:14:29 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:53561 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab2HQJOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 05:14:25 -0400
From: Daniel J Blueman <daniel@quora.org>
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel@quora.org>
Subject: [PATCH] Add MSI support for SDHCI PCI hosts
Date: Fri, 17 Aug 2012 17:14:14 +0800
Message-Id: <1345194854-8330-1-git-send-email-daniel@quora.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow module parameter 'enable_msi' to request an MSI interrupt for
hosts where available (presently PCI). Useful as a workaround on
platforms where the legacy interrupt is broken.

Signed-off-by: Daniel J Blueman <daniel@quora.org>
---
 drivers/mmc/host/sdhci-pci.c |   30 ++++++++++++++++++++++++++++++
 drivers/mmc/host/sdhci.c     |   23 +++++++++++++++++++++++
 drivers/mmc/host/sdhci.h     |    2 ++
 3 files changed, 55 insertions(+)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 504da71..fbde589 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -934,6 +934,34 @@ static int sdhci_pci_enable_dma(struct sdhci_host *host)
 	return 0;
 }
 
+static int sdhci_pci_enable_msi(struct sdhci_host *host)
+{
+	struct sdhci_pci_slot *slot;
+	struct pci_dev *pdev;
+	int ret;
+
+	slot = sdhci_priv(host);
+	pdev = slot->chip->pdev;
+
+	ret = pci_enable_msi(pdev);
+	if (ret)
+		return ret;
+
+	host->irq = pdev->irq;
+	return 0;
+}
+
+static void sdhci_pci_disable_msi(struct sdhci_host *host)
+{
+	struct sdhci_pci_slot *slot;
+	struct pci_dev *pdev;
+
+	slot = sdhci_priv(host);
+	pdev = slot->chip->pdev;
+
+	pci_disable_msi(pdev);
+}
+
 static int sdhci_pci_8bit_width(struct sdhci_host *host, int width)
 {
 	u8 ctrl;
@@ -976,6 +1004,8 @@ static void sdhci_pci_hw_reset(struct sdhci_host *host)
 
 static struct sdhci_ops sdhci_pci_ops = {
 	.enable_dma	= sdhci_pci_enable_dma,
+	.enable_msi	= sdhci_pci_enable_msi,
+	.disable_msi	= sdhci_pci_disable_msi,
 	.platform_8bit_width	= sdhci_pci_8bit_width,
 	.hw_reset		= sdhci_pci_hw_reset,
 };
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 9a11dc3..9fa2180 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -45,6 +45,7 @@
 
 static unsigned int debug_quirks = 0;
 static unsigned int debug_quirks2;
+static bool enable_msi;
 
 static void sdhci_finish_data(struct sdhci_host *);
 
@@ -2433,6 +2434,9 @@ int sdhci_suspend_host(struct sdhci_host *host)
 
 	free_irq(host->irq, host);
 
+	if (host->ops->disable_msi && enable_msi)
+		host->ops->disable_msi(host);
+
 	return ret;
 }
 
@@ -2447,6 +2451,12 @@ int sdhci_resume_host(struct sdhci_host *host)
 			host->ops->enable_dma(host);
 	}
 
+	if (host->ops->enable_msi && enable_msi) {
+		ret = host->ops->enable_msi(host);
+		if (ret)
+			return ret;
+	}
+
 	ret = request_irq(host->irq, sdhci_irq, IRQF_SHARED,
 			  mmc_hostname(host->mmc), host);
 	if (ret)
@@ -3024,6 +3034,12 @@ int sdhci_add_host(struct sdhci_host *host)
 		host->tuning_timer.function = sdhci_tuning_timer;
 	}
 
+	if (host->ops->enable_msi && enable_msi) {
+		ret = host->ops->enable_msi(host);
+		if (ret)
+			return ret;
+	}
+
 	ret = request_irq(host->irq, sdhci_irq, IRQF_SHARED,
 		mmc_hostname(mmc), host);
 	if (ret) {
@@ -3071,6 +3087,8 @@ int sdhci_add_host(struct sdhci_host *host)
 reset:
 	sdhci_reset(host, SDHCI_RESET_ALL);
 	free_irq(host->irq, host);
+	if (host->ops->disable_msi && enable_msi)
+		host->ops->disable_msi(host);
 #endif
 untasklet:
 	tasklet_kill(&host->card_tasklet);
@@ -3114,6 +3132,9 @@ void sdhci_remove_host(struct sdhci_host *host, int dead)
 
 	free_irq(host->irq, host);
 
+	if (host->ops->disable_msi && enable_msi)
+		host->ops->disable_msi(host);
+
 	del_timer_sync(&host->timer);
 
 	tasklet_kill(&host->card_tasklet);
@@ -3162,6 +3183,7 @@ module_exit(sdhci_drv_exit);
 
 module_param(debug_quirks, uint, 0444);
 module_param(debug_quirks2, uint, 0444);
+module_param(enable_msi, bool, 0444);
 
 MODULE_AUTHOR("Pierre Ossman <pierre@ossman.eu>");
 MODULE_DESCRIPTION("Secure Digital Host Controller Interface core driver");
@@ -3169,3 +3191,4 @@ MODULE_LICENSE("GPL");
 
 MODULE_PARM_DESC(debug_quirks, "Force certain quirks.");
 MODULE_PARM_DESC(debug_quirks2, "Force certain other quirks.");
+MODULE_PARM_DESC(debug_quirks2, "Enable MSI interrupt support where possible.");
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 97653ea..df4e003 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -264,6 +264,8 @@ struct sdhci_ops {
 	void	(*set_clock)(struct sdhci_host *host, unsigned int clock);
 
 	int		(*enable_dma)(struct sdhci_host *host);
+	int		(*enable_msi)(struct sdhci_host *host);
+	void		(*disable_msi)(struct sdhci_host *host);
 	unsigned int	(*get_max_clock)(struct sdhci_host *host);
 	unsigned int	(*get_min_clock)(struct sdhci_host *host);
 	unsigned int	(*get_timeout_clock)(struct sdhci_host *host);
-- 
1.7.10.4


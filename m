Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab0CPUfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 16:35:19 -0400
Received: from mail-px0-f198.google.com ([209.85.216.198]:43414 "EHLO
	mail-px0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab0CPUfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 16:35:16 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: linux-mmc@vger.kernel.org
Cc: Chaithrika U S <chaithrika@ti.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vipin Bhandari <vipin.bhandari@ti.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] davinci: MMC: Add a function to control reset state of the controller
Date: Tue, 16 Mar 2010 13:30:24 -0700
Message-Id: <1268771425-6277-1-git-send-email-khilman@deeprootsystems.com>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chaithrika U S <chaithrika@ti.com>

Add a helper function which will aid in changing the reset
status of the controller.

Signed-off-by: Chaithrika U S <chaithrika@ti.com>
Acked-by: Kevin Hilman <khilman@deeprootsystems.com>
---
I thought this series had made it into -mm for 2.6.34, but I guess not.
Here it is again for 2.6.35.

 drivers/mmc/host/davinci_mmc.c |   37 ++++++++++++++++---------------------
 1 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index 547d29c..56afe0a 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -909,19 +909,26 @@ static void mmc_davinci_cmd_done(struct mmc_davinci_host *host,
 	}
 }
 
-static void
-davinci_abort_data(struct mmc_davinci_host *host, struct mmc_data *data)
+static inline void mmc_davinci_reset_ctrl(struct mmc_davinci_host *host,
+								int val)
 {
 	u32 temp;
 
-	/* reset command and data state machines */
 	temp = readl(host->base + DAVINCI_MMCCTL);
-	writel(temp | MMCCTL_CMDRST | MMCCTL_DATRST,
-		host->base + DAVINCI_MMCCTL);
+	if (val)	/* reset */
+		temp |= MMCCTL_CMDRST | MMCCTL_DATRST;
+	else		/* enable */
+		temp &= ~(MMCCTL_CMDRST | MMCCTL_DATRST);
 
-	temp &= ~(MMCCTL_CMDRST | MMCCTL_DATRST);
-	udelay(10);
 	writel(temp, host->base + DAVINCI_MMCCTL);
+	udelay(10);
+}
+
+static void
+davinci_abort_data(struct mmc_davinci_host *host, struct mmc_data *data)
+{
+	mmc_davinci_reset_ctrl(host, 1);
+	mmc_davinci_reset_ctrl(host, 0);
 }
 
 static irqreturn_t mmc_davinci_irq(int irq, void *dev_id)
@@ -1125,15 +1132,8 @@ static inline void mmc_davinci_cpufreq_deregister(struct mmc_davinci_host *host)
 #endif
 static void __init init_mmcsd_host(struct mmc_davinci_host *host)
 {
-	/* DAT line portion is diabled and in reset state */
-	writel(readl(host->base + DAVINCI_MMCCTL) | MMCCTL_DATRST,
-		host->base + DAVINCI_MMCCTL);
-
-	/* CMD line portion is diabled and in reset state */
-	writel(readl(host->base + DAVINCI_MMCCTL) | MMCCTL_CMDRST,
-		host->base + DAVINCI_MMCCTL);
 
-	udelay(10);
+	mmc_davinci_reset_ctrl(host, 1);
 
 	writel(0, host->base + DAVINCI_MMCCLK);
 	writel(MMCCLK_CLKEN, host->base + DAVINCI_MMCCLK);
@@ -1141,12 +1141,7 @@ static void __init init_mmcsd_host(struct mmc_davinci_host *host)
 	writel(0x1FFF, host->base + DAVINCI_MMCTOR);
 	writel(0xFFFF, host->base + DAVINCI_MMCTOD);
 
-	writel(readl(host->base + DAVINCI_MMCCTL) & ~MMCCTL_DATRST,
-		host->base + DAVINCI_MMCCTL);
-	writel(readl(host->base + DAVINCI_MMCCTL) & ~MMCCTL_CMDRST,
-		host->base + DAVINCI_MMCCTL);
-
-	udelay(10);
+	mmc_davinci_reset_ctrl(host, 0);
 }
 
 static int __init davinci_mmcsd_probe(struct platform_device *pdev)
-- 
1.7.0.2


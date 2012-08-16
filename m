Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664Ab2HPObd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:31:33 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17221 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084Ab2HPObb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:31:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 16 Aug 2012 07:25:43 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <olof@lixom.net>, <grant.likely@secretlab.ca>,
        <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>
CC: <vinod.koul@linux.intel.com>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <spi-devel-general@lists.sourceforge.net>,
        <alsa-devel@alsa-project.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 3/5] ARM: tegra: apbio: remove support of legacy DMA driver based access
Date: Thu, 16 Aug 2012 19:43:15 +0530
Message-ID: <1345126397-28864-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1345126397-28864-1-git-send-email-ldewangan@nvidia.com>
References: <1345126397-28864-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the support code which uses the legacy APB DMA driver
for accessing the apbio register.
The driver will use the dmaengine based APB DMA driver for
accessing apbio register.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/mach-tegra/apbio.c |  118 +------------------------------------------
 1 files changed, 1 insertions(+), 117 deletions(-)

diff --git a/arch/arm/mach-tegra/apbio.c b/arch/arm/mach-tegra/apbio.c
index 643a378..b5015d0 100644
--- a/arch/arm/mach-tegra/apbio.c
+++ b/arch/arm/mach-tegra/apbio.c
@@ -28,7 +28,7 @@
 
 #include "apbio.h"
 
-#if defined(CONFIG_TEGRA_SYSTEM_DMA) || defined(CONFIG_TEGRA20_APB_DMA)
+#if defined(CONFIG_TEGRA20_APB_DMA)
 static DEFINE_MUTEX(tegra_apb_dma_lock);
 static u32 *tegra_apb_bb;
 static dma_addr_t tegra_apb_bb_phys;
@@ -37,121 +37,6 @@ static DECLARE_COMPLETION(tegra_apb_wait);
 static u32 tegra_apb_readl_direct(unsigned long offset);
 static void tegra_apb_writel_direct(u32 value, unsigned long offset);
 
-#if defined(CONFIG_TEGRA_SYSTEM_DMA)
-static struct tegra_dma_channel *tegra_apb_dma;
-
-bool tegra_apb_init(void)
-{
-	struct tegra_dma_channel *ch;
-
-	mutex_lock(&tegra_apb_dma_lock);
-
-	/* Check to see if we raced to setup */
-	if (tegra_apb_dma)
-		goto out;
-
-	ch = tegra_dma_allocate_channel(TEGRA_DMA_MODE_ONESHOT |
-		TEGRA_DMA_SHARED);
-
-	if (!ch)
-		goto out_fail;
-
-	tegra_apb_bb = dma_alloc_coherent(NULL, sizeof(u32),
-		&tegra_apb_bb_phys, GFP_KERNEL);
-	if (!tegra_apb_bb) {
-		pr_err("%s: can not allocate bounce buffer\n", __func__);
-		tegra_dma_free_channel(ch);
-		goto out_fail;
-	}
-
-	tegra_apb_dma = ch;
-out:
-	mutex_unlock(&tegra_apb_dma_lock);
-	return true;
-
-out_fail:
-	mutex_unlock(&tegra_apb_dma_lock);
-	return false;
-}
-
-static void apb_dma_complete(struct tegra_dma_req *req)
-{
-	complete(&tegra_apb_wait);
-}
-
-static u32 tegra_apb_readl_using_dma(unsigned long offset)
-{
-	struct tegra_dma_req req;
-	int ret;
-
-	if (!tegra_apb_dma && !tegra_apb_init())
-		return tegra_apb_readl_direct(offset);
-
-	mutex_lock(&tegra_apb_dma_lock);
-	req.complete = apb_dma_complete;
-	req.to_memory = 1;
-	req.dest_addr = tegra_apb_bb_phys;
-	req.dest_bus_width = 32;
-	req.dest_wrap = 1;
-	req.source_addr = offset;
-	req.source_bus_width = 32;
-	req.source_wrap = 4;
-	req.req_sel = TEGRA_DMA_REQ_SEL_CNTR;
-	req.size = 4;
-
-	INIT_COMPLETION(tegra_apb_wait);
-
-	tegra_dma_enqueue_req(tegra_apb_dma, &req);
-
-	ret = wait_for_completion_timeout(&tegra_apb_wait,
-		msecs_to_jiffies(50));
-
-	if (WARN(ret == 0, "apb read dma timed out")) {
-		tegra_dma_dequeue_req(tegra_apb_dma, &req);
-		*(u32 *)tegra_apb_bb = 0;
-	}
-
-	mutex_unlock(&tegra_apb_dma_lock);
-	return *((u32 *)tegra_apb_bb);
-}
-
-static void tegra_apb_writel_using_dma(u32 value, unsigned long offset)
-{
-	struct tegra_dma_req req;
-	int ret;
-
-	if (!tegra_apb_dma && !tegra_apb_init()) {
-		tegra_apb_writel_direct(value, offset);
-		return;
-	}
-
-	mutex_lock(&tegra_apb_dma_lock);
-	*((u32 *)tegra_apb_bb) = value;
-	req.complete = apb_dma_complete;
-	req.to_memory = 0;
-	req.dest_addr = offset;
-	req.dest_wrap = 4;
-	req.dest_bus_width = 32;
-	req.source_addr = tegra_apb_bb_phys;
-	req.source_bus_width = 32;
-	req.source_wrap = 1;
-	req.req_sel = TEGRA_DMA_REQ_SEL_CNTR;
-	req.size = 4;
-
-	INIT_COMPLETION(tegra_apb_wait);
-
-	tegra_dma_enqueue_req(tegra_apb_dma, &req);
-
-	ret = wait_for_completion_timeout(&tegra_apb_wait,
-		msecs_to_jiffies(50));
-
-	if (WARN(ret == 0, "apb write dma timed out"))
-		tegra_dma_dequeue_req(tegra_apb_dma, &req);
-
-	mutex_unlock(&tegra_apb_dma_lock);
-}
-
-#else
 static struct dma_chan *tegra_apb_dma_chan;
 static struct dma_slave_config dma_sconfig;
 
@@ -279,7 +164,6 @@ static void tegra_apb_writel_using_dma(u32 value, unsigned long offset)
 		pr_err("error in writing offset 0x%08lx using dma\n", offset);
 	mutex_unlock(&tegra_apb_dma_lock);
 }
-#endif
 #else
 #define tegra_apb_readl_using_dma tegra_apb_readl_direct
 #define tegra_apb_writel_using_dma tegra_apb_writel_direct
-- 
1.7.1.1


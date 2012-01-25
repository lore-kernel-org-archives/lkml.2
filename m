Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab2AYLUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 06:20:34 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19935 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab2AYLUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 06:20:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 25 Jan 2012 03:20:33 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: ccross@android.com, olof@lixom.net, swarren@nvidia.com,
        linux@arm.linux.org.uk
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V1] ARM: tegra: dma: Support variable transfer sizes
Date: Wed, 25 Jan 2012 16:49:38 +0530
Message-Id: <1327490378-10904-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the transfer size to vary in each DMA request,
rather than assuming all requests to be the same size
as the first request made.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/mach-tegra/dma.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/dma.c b/arch/arm/mach-tegra/dma.c
index abea4f6..81a7459 100644
--- a/arch/arm/mach-tegra/dma.c
+++ b/arch/arm/mach-tegra/dma.c
@@ -423,6 +423,7 @@ static void tegra_dma_update_hw_partial(struct tegra_dma_channel *ch,
 {
 	u32 apb_ptr;
 	u32 ahb_ptr;
+	u32 csr;
 
 	if (req->to_memory) {
 		apb_ptr = req->source_addr;
@@ -434,6 +435,15 @@ static void tegra_dma_update_hw_partial(struct tegra_dma_channel *ch,
 	writel(apb_ptr, ch->addr + APB_DMA_CHAN_APB_PTR);
 	writel(ahb_ptr, ch->addr + APB_DMA_CHAN_AHB_PTR);
 
+	if (ch->mode & TEGRA_DMA_MODE_CONTINOUS)
+		ch->req_transfer_count = (req->size >> 3) - 1;
+	else
+		ch->req_transfer_count = (req->size >> 2) - 1;
+	csr = readl(ch->addr + APB_DMA_CHAN_CSR);
+	csr &= ~CSR_WCOUNT_MASK;
+	csr |= ch->req_transfer_count << CSR_WCOUNT_SHIFT;
+	writel(csr, ch->addr + APB_DMA_CHAN_CSR);
+
 	req->status = TEGRA_DMA_REQ_INFLIGHT;
 	return;
 }
-- 
1.7.1.1


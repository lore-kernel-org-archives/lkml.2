Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab2AXILg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 03:11:36 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8896 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab2AXILa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 03:11:30 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 24 Jan 2012 00:11:30 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: ccross@android.com, olof@lixom.net, swarren@nvidia.com,
        linux@arm.linux.org.uk
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V1] arm: tegra: dma: not required to move requestor when stopping.
Date: Tue, 24 Jan 2012 13:40:49 +0530
Message-Id: <1327392649-27605-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not require to move the requestor of dma to INVALID
option before stopping dma.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/mach-tegra/dma.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-tegra/dma.c b/arch/arm/mach-tegra/dma.c
index 998c55d..abea4f6 100644
--- a/arch/arm/mach-tegra/dma.c
+++ b/arch/arm/mach-tegra/dma.c
@@ -52,8 +52,6 @@
 #define CSR_ONCE				(1<<27)
 #define CSR_FLOW				(1<<21)
 #define CSR_REQ_SEL_SHIFT			16
-#define CSR_REQ_SEL_MASK			(0x1F<<CSR_REQ_SEL_SHIFT)
-#define CSR_REQ_SEL_INVALID			(31<<CSR_REQ_SEL_SHIFT)
 #define CSR_WCOUNT_SHIFT			2
 #define CSR_WCOUNT_MASK				0xFFFC
 
@@ -183,18 +181,12 @@ static void tegra_dma_stop(struct tegra_dma_channel *ch)
 
 static int tegra_dma_cancel(struct tegra_dma_channel *ch)
 {
-	u32 csr;
 	unsigned long irq_flags;
 
 	spin_lock_irqsave(&ch->lock, irq_flags);
 	while (!list_empty(&ch->list))
 		list_del(ch->list.next);
 
-	csr = readl(ch->addr + APB_DMA_CHAN_CSR);
-	csr &= ~CSR_REQ_SEL_MASK;
-	csr |= CSR_REQ_SEL_INVALID;
-	writel(csr, ch->addr + APB_DMA_CHAN_CSR);
-
 	tegra_dma_stop(ch);
 
 	spin_unlock_irqrestore(&ch->lock, irq_flags);
-- 
1.7.1.1


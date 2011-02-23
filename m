Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab1BWRSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:18:39 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:43517 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab1BWRSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:18:38 -0500
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Feb 2011 12:18:38 EST
From: Stephen Warren <swarren@nvidia.com>
To: ccross@android.com
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, olof@lixom.net,
        konkers@android.com, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] ARM: Tegra: Make tegra_dma_init a postcore_initcall
Date: Wed, 23 Feb 2011 10:11:20 -0700
Message-Id: <1298481080-27120-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit makes the Tegra APB DMA engine fail to initialize
correctly: 0cf6230af909a86f81907455eca2a5c9b8f68fe6
ARM: tegra: Move tegra_common_init to tegra_init_early

The reason is that tegra_init_early_ calls tegra_dma_init which calls
request_threaded_irq, which fails since the IRQ hasn't yet been marked
valid; that only happens in tegra_init_irq, which gets called after
tegra_init_early.

This used to work OK, since tegra_init_early was tegra_common_init, which
got called after tegra_init_irq, basically from the beginning of
tegra_harmony_init.

Solve this by converting tegra_dma_init to a postcore_initcall. This makes
it execute late enough that IRQs are marked valid, and avoids having to
add it back to every machine's init function.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/mach-tegra/common.c |    3 ---
 arch/arm/mach-tegra/dma.c    |    1 +
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 516e100..b6ab3f8 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -81,7 +81,4 @@ void __init tegra_init_early(void)
 	tegra_init_clock();
 	tegra_clk_init_from_table(common_clk_init_table);
 	tegra_init_cache();
-#ifdef CONFIG_TEGRA_SYSTEM_DMA
-	tegra_dma_init();
-#endif
 }
diff --git a/arch/arm/mach-tegra/dma.c b/arch/arm/mach-tegra/dma.c
index 2d720f2..bd4f62a 100644
--- a/arch/arm/mach-tegra/dma.c
+++ b/arch/arm/mach-tegra/dma.c
@@ -743,6 +743,7 @@ fail:
 	}
 	return ret;
 }
+postcore_initcall(tegra_dma_init);
 
 #ifdef CONFIG_PM
 static u32 apb_dma[5*TEGRA_SYSTEM_DMA_CH_NR + 3];
-- 
1.7.1


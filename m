Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab1LNPIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:08:16 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5110 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272Ab1LNPIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:08:12 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 14 Dec 2011 07:07:54 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>, Gary King <gking@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH v7 08/14] arm/tegra: generalize L2 cache initialization
Date: Wed, 14 Dec 2011 17:03:20 +0200
Message-ID: <1323875032-18221-9-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1323875032-18221-1-git-send-email-pdeschrijver@nvidia.com>
References: <1323875032-18221-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generalize L2 cache initialization and discover L2 cache associativity at
runtime.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/common.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 8da1847..554f18f 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -73,15 +73,20 @@ static __initdata struct tegra_clk_init_table tegra20_clk_init_table[] = {
 };
 #endif
 
-static void __init tegra_init_cache(void)
+static void __init tegra_init_cache(u32 tag_latency, u32 data_latency)
 {
 #ifdef CONFIG_CACHE_L2X0
 	void __iomem *p = IO_ADDRESS(TEGRA_ARM_PERIF_BASE) + 0x3000;
+	u32 aux_ctrl, cache_type;
 
-	writel_relaxed(0x331, p + L2X0_TAG_LATENCY_CTRL);
-	writel_relaxed(0x441, p + L2X0_DATA_LATENCY_CTRL);
+	writel_relaxed(tag_latency, p + L2X0_TAG_LATENCY_CTRL);
+	writel_relaxed(data_latency, p + L2X0_DATA_LATENCY_CTRL);
 
-	l2x0_init(p, 0x6C080001, 0x8200c3fe);
+	cache_type = readl(p + L2X0_CACHE_TYPE);
+	aux_ctrl = (cache_type & 0x700) << (17-8);
+	aux_ctrl |= 0x6C000001;
+
+	l2x0_init(p, aux_ctrl, 0x8200c3fe);
 #endif
 
 }
@@ -92,6 +97,6 @@ void __init tegra20_init_early(void)
 	tegra_init_fuse();
 	tegra2_init_clocks();
 	tegra_clk_init_from_table(tegra20_clk_init_table);
-	tegra_init_cache();
+	tegra_init_cache(0x331, 0x441);
 }
 #endif
-- 
1.7.7.rc0.72.g4b5ea.dirty


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab2DXMFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 08:05:41 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17168 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab2DXMFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 08:05:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 24 Apr 2012 05:05:37 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: hdoyu@nvidia.com
Cc: linux-tegra@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Jamie Iles <jamie@jamieiles.com>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] ARM: tegra: Add SMMU enabler in AHB
Date: Tue, 24 Apr 2012 15:05:15 +0300
Message-Id: <1335269116-9578-2-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335269116-9578-1-git-send-email-hdoyu@nvidia.com>
References: <1335269116-9578-1-git-send-email-hdoyu@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add extern func, "tegra_ahb_enable_smmu()" to inform AHB that SMMU is
ready.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
Cc: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-tegra/include/mach/tegra-ahb.h |   19 +++++++++++++++++++
 arch/arm/mach-tegra/tegra-ahb.c              |   18 ++++++++++++++++++
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/include/mach/tegra-ahb.h b/arch/arm/mach-tegra/include/mach/tegra-ahb.h
new file mode 100644
index 0000000..51a5800
--- /dev/null
+++ b/arch/arm/mach-tegra/include/mach/tegra-ahb.h
@@ -0,0 +1,19 @@
+/*
+ * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#ifndef __MACH_TEGRA_AHB_H__
+#define __MACH_TEGRA_AHB_H__
+
+extern void tegra_ahb_enable_smmu(void);
+
+#endif	/* __MACH_TEGRA_AHB_H__ */
diff --git a/arch/arm/mach-tegra/tegra-ahb.c b/arch/arm/mach-tegra/tegra-ahb.c
index 71b5950..32794ef 100644
--- a/arch/arm/mach-tegra/tegra-ahb.c
+++ b/arch/arm/mach-tegra/tegra-ahb.c
@@ -78,6 +78,9 @@
 
 #define AHB_ARBITRATION_AHB_MEM_WRQUE_MST_ID	0xf8
 
+#define AHB_ARBITRATION_XBAR_CTRL_SMMU_INIT_DONE_DONE	1
+#define AHB_ARBITRATION_XBAR_CTRL_SMMU_INIT_DONE_SHIFT	17
+
 struct __tegra_ahb {
 	void __iomem	*regs;
 	struct device	*dev;
@@ -95,6 +98,21 @@ static inline void gizmo_writel(unsigned long value, unsigned long offset)
 	writel(value, tegra_ahb->regs + offset);
 }
 
+#ifdef CONFIG_ARCH_TEGRA_3x_SOC
+
+void tegra_ahb_enable_smmu(void)
+{
+	unsigned long val;
+
+	val = gizmo_readl(AHB_ARBITRATION_XBAR_CTRL);
+	val |= AHB_ARBITRATION_XBAR_CTRL_SMMU_INIT_DONE_DONE <<
+		AHB_ARBITRATION_XBAR_CTRL_SMMU_INIT_DONE_SHIFT;
+	gizmo_writel(val, AHB_ARBITRATION_XBAR_CTRL);
+}
+EXPORT_SYMBOL(tegra_ahb_enable_smmu);
+
+#endif
+
 struct __ahb_gizmo {
 	unsigned long offset;
 	unsigned long data;
-- 
1.7.5.4


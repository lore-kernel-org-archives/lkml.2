Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab2DWLhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 07:37:43 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10130 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab2DWLhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 07:37:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 23 Apr 2012 04:37:41 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: hdoyu@nvidia.com
Cc: linux-tegra@vger.kernel.org, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Jamie Iles <jamie@jamieiles.com>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ARM: tegra: Add SMMU enabler in AHB
Date: Mon, 23 Apr 2012 14:37:22 +0300
Message-Id: <1335181043-15348-2-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335181043-15348-1-git-send-email-hdoyu@nvidia.com>
References: <1335181043-15348-1-git-send-email-hdoyu@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add extern func, "tegra_ahb_enable_smmu()" to inform AHB that SMMU is
ready.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
 arch/arm/mach-tegra/include/mach/tegra-ahb.h |   19 +++++++++++++++++++
 arch/arm/mach-tegra/tegra-ahb.c              |   19 +++++++++++++++++++
 2 files changed, 38 insertions(+), 0 deletions(-)

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
index 411b51f..40877fa 100644
--- a/arch/arm/mach-tegra/tegra-ahb.c
+++ b/arch/arm/mach-tegra/tegra-ahb.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/io.h>
 #include <linux/syscore_ops.h>
 
@@ -74,6 +75,9 @@
 
 #define AHB_ARBITRATION_AHB_MEM_WRQUE_MST_ID	0xf8
 
+#define AHB_ARBITRATION_XBAR_CTRL_SMMU_INIT_DONE_DONE	1
+#define AHB_ARBITRATION_XBAR_CTRL_SMMU_INIT_DONE_SHIFT	17
+
 static inline unsigned long gizmo_readl(unsigned long offset)
 {
 	return readl(IO_TO_VIRT(TEGRA_AHB_GIZMO_BASE + offset));
@@ -84,6 +88,21 @@ static inline void gizmo_writel(unsigned long value, unsigned long offset)
 	writel(value, IO_TO_VIRT(TEGRA_AHB_GIZMO_BASE + offset));
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
 #ifdef CONFIG_PM
 
 struct __ahb_gizmo {
-- 
1.7.5.4


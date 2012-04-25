Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489Ab2DYLIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:08:19 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2923 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab2DYLIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:08:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 25 Apr 2012 04:08:15 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: swarren@nvidia.com
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hiroshi DOYU <hdoyu@nvidia.com>, Felipe Balbi <balbi@ti.com>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Jamie Iles <jamie@jamieiles.com>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
Subject: [PATCHv3 2/4] ARM: tegra: Add SMMU enabler in AHB
Date: Wed, 25 Apr 2012 14:07:37 +0300
Message-Id: <1335352072-4001-2-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335352072-4001-1-git-send-email-hdoyu@nvidia.com>
References: <1335352072-4001-1-git-send-email-hdoyu@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add extern func, "tegra_ahb_enable_smmu()" to inform AHB that SMMU is
ready.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
Cc: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-tegra/include/mach/tegra-ahb.h |   19 +++++++++++++++++++
 drivers/platform/arm/tegra-ahb.c             |   24 ++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/include/mach/tegra-ahb.h b/arch/arm/mach-tegra/include/mach/tegra-ahb.h
new file mode 100644
index 0000000..296688c
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
+extern int tegra_ahb_enable_smmu(void);
+
+#endif	/* __MACH_TEGRA_AHB_H__ */
diff --git a/drivers/platform/arm/tegra-ahb.c b/drivers/platform/arm/tegra-ahb.c
index dcad2ec..7ad9dfd 100644
--- a/drivers/platform/arm/tegra-ahb.c
+++ b/drivers/platform/arm/tegra-ahb.c
@@ -78,6 +78,10 @@
 
 #define AHB_ARBITRATION_AHB_MEM_WRQUE_MST_ID	0xf8
 
+#define AHB_ARBITRATION_XBAR_CTRL_SMMU_INIT_DONE BIT(17)
+
+static struct platform_driver tegra_ahb_driver;
+
 static u32 tegra_ahb_gizmo[] = {
 	AHB_ARBITRATION_DISABLE,
 	AHB_ARBITRATION_PRIORITY_CTRL,
@@ -126,6 +130,26 @@ static inline void gizmo_writel(struct tegra_ahb *ahb, u32 value, u32 offset)
 	writel(value, ahb->regs + offset);
 }
 
+#ifdef CONFIG_ARCH_TEGRA_3x_SOC
+static int __tegra_ahb_enable_smmu(struct device *dev, void *data)
+{
+	u32 val;
+	struct tegra_ahb *ahb = dev_get_drvdata(dev);
+
+	val = gizmo_readl(ahb, AHB_ARBITRATION_XBAR_CTRL);
+	val |= AHB_ARBITRATION_XBAR_CTRL_SMMU_INIT_DONE;
+	gizmo_writel(ahb, val, AHB_ARBITRATION_XBAR_CTRL);
+	return 0;
+}
+
+int tegra_ahb_enable_smmu(void)
+{
+	return driver_for_each_device(&tegra_ahb_driver.driver, NULL, NULL,
+				      __tegra_ahb_enable_smmu);
+}
+EXPORT_SYMBOL(tegra_ahb_enable_smmu);
+#endif
+
 static int tegra_ahb_suspend(struct device *dev)
 {
 	int i;
-- 
1.7.5.4


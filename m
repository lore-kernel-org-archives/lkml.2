Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab2EGGo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 02:44:29 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12525 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab2EGGoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 02:44:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 06 May 2012 23:43:47 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: swarren@wwwdotorg.org
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hiroshi DOYU <hdoyu@nvidia.com>, Felipe Balbi <balbi@ti.com>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org
Subject: [PATCHv5 2/3] ARM: tegra: Add SMMU enabler in AHB
Date: Mon,  7 May 2012 09:43:46 +0300
Message-Id: <1336373032-16881-2-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1336373032-16881-1-git-send-email-hdoyu@nvidia.com>
References: <1336373032-16881-1-git-send-email-hdoyu@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add extern func, "tegra_ahb_enable_smmu()" to inform AHB that SMMU is
ready.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
Cc: Felipe Balbi <balbi@ti.com>
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
---
 arch/arm/mach-tegra/include/mach/tegra-ahb.h |   19 +++++++++++++++
 drivers/amba/tegra-ahb.c                     |   32 ++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/include/mach/tegra-ahb.h b/arch/arm/mach-tegra/include/mach/tegra-ahb.h
new file mode 100644
index 0000000..e0f8c84
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
+extern int tegra_ahb_enable_smmu(struct device_node *ahb);
+
+#endif	/* __MACH_TEGRA_AHB_H__ */
diff --git a/drivers/amba/tegra-ahb.c b/drivers/amba/tegra-ahb.c
index 106a780..aa0b1f1 100644
--- a/drivers/amba/tegra-ahb.c
+++ b/drivers/amba/tegra-ahb.c
@@ -76,6 +76,10 @@
 
 #define AHB_ARBITRATION_AHB_MEM_WRQUE_MST_ID	0xf8
 
+#define AHB_ARBITRATION_XBAR_CTRL_SMMU_INIT_DONE BIT(17)
+
+static struct platform_driver tegra_ahb_driver;
+
 static const u32 tegra_ahb_gizmo[] = {
 	AHB_ARBITRATION_DISABLE,
 	AHB_ARBITRATION_PRIORITY_CTRL,
@@ -124,6 +128,34 @@ static inline void gizmo_writel(struct tegra_ahb *ahb, u32 value, u32 offset)
 	writel(value, ahb->regs + offset);
 }
 
+#ifdef CONFIG_ARCH_TEGRA_3x_SOC
+static int tegra_ahb_match_by_smmu(struct device *dev, void *data)
+{
+	struct tegra_ahb *ahb = dev_get_drvdata(dev);
+	struct device_node *dn = data;
+
+	return (ahb->dev->of_node == dn) ? 1 : 0;
+}
+
+int tegra_ahb_enable_smmu(struct device_node *dn)
+{
+	struct device *dev;
+	u32 val;
+	struct tegra_ahb *ahb;
+
+	dev = driver_find_device(&tegra_ahb_driver.driver, NULL, dn,
+				 tegra_ahb_match_by_smmu);
+	if (!dev)
+		return -EPROBE_DEFER;
+	ahb = dev_get_drvdata(dev);
+	val = gizmo_readl(ahb, AHB_ARBITRATION_XBAR_CTRL);
+	val |= AHB_ARBITRATION_XBAR_CTRL_SMMU_INIT_DONE;
+	gizmo_writel(ahb, val, AHB_ARBITRATION_XBAR_CTRL);
+	return 0;
+}
+EXPORT_SYMBOL(tegra_ahb_enable_smmu);
+#endif
+
 static int tegra_ahb_suspend(struct device *dev)
 {
 	int i;
-- 
1.7.5.4


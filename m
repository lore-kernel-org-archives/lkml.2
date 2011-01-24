Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab1AXCCc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 21:02:32 -0500
Received: from smtp-out.google.com ([216.239.44.51]:42991 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab1AXCCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 21:02:05 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net, konkers@android.com,
        James Wylder <james.wylder@motorola.com>,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 27/28] ARM: tegra: enable emc clock updates after lp0
Date: Sun, 23 Jan 2011 18:01:32 -0800
Message-Id: <1295834493-5019-28-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1295834493-5019-1-git-send-email-ccross@android.com>
References: <1295834493-5019-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Wylder <james.wylder@motorola.com>

Write a dummy value to EMC_MRW_0 to allow
clock frequency changes after lp0.

Signed-off-by: James Wylder <james.wylder@motorola.com>
Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/suspend.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/suspend.c b/arch/arm/mach-tegra/suspend.c
index 8b32707..9b851c7 100644
--- a/arch/arm/mach-tegra/suspend.c
+++ b/arch/arm/mach-tegra/suspend.c
@@ -122,6 +122,10 @@ static void __iomem *tmrus = IO_ADDRESS(TEGRA_TMRUS_BASE);
 #define FLOW_CTRL_CPU_CSR	0x8
 #define FLOW_CTRL_CPU1_CSR	0x18
 
+#define EMC_MRW_0		0x0e8
+#define EMC_MRW_DEV_SELECTN     30
+#define EMC_MRW_DEV_NONE	(3 << EMC_MRW_DEV_SELECTN)
+
 unsigned long tegra_pgd_phys;  /* pgd used by hotplug & LP2 bootup */
 static pgd_t *tegra_pgd;
 void *tegra_context_area;
@@ -503,6 +507,7 @@ static void tegra_debug_uart_resume(void)
 static int tegra_suspend_enter(suspend_state_t state)
 {
 	void __iomem *mc = IO_ADDRESS(TEGRA_MC_BASE);
+	void __iomem *emc = IO_ADDRESS(TEGRA_EMC_BASE);
 	unsigned long flags;
 	u32 mc_data[3] = {0, 0, 0};
 	bool do_lp0 = (current_suspend_mode == TEGRA_SUSPEND_LP0);
@@ -555,6 +560,9 @@ static int tegra_suspend_enter(suspend_state_t state)
 		writel(mc_data[1], mc + MC_SECURITY_SIZE);
 		writel(mc_data[2], mc + MC_SECURITY_CFG2);
 
+		/* trigger emc mode write */
+		writel(EMC_MRW_DEV_NONE, emc + EMC_MRW_0);
+
 		tegra_clk_resume();
 		tegra_gpio_resume();
 		tegra_timer_resume();
-- 
1.7.3.1


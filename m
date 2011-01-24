Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab1AXCCV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 21:02:21 -0500
Received: from smtp-out.google.com ([216.239.44.51]:42953 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab1AXCCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 21:02:03 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net, konkers@android.com,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 25/28] ARM: tegra: suspend: Save protected aperture across LP0
Date: Sun, 23 Jan 2011 18:01:30 -0800
Message-Id: <1295834493-5019-26-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1295834493-5019-1-git-send-email-ccross@android.com>
References: <1295834493-5019-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/suspend.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-tegra/suspend.c b/arch/arm/mach-tegra/suspend.c
index ded2c36..be8c78f 100644
--- a/arch/arm/mach-tegra/suspend.c
+++ b/arch/arm/mach-tegra/suspend.c
@@ -497,12 +497,13 @@ static void tegra_debug_uart_resume(void)
 
 #define MC_SECURITY_START	0x6c
 #define MC_SECURITY_SIZE	0x70
+#define MC_SECURITY_CFG2	0x7c
 
 static int tegra_suspend_enter(suspend_state_t state)
 {
 	void __iomem *mc = IO_ADDRESS(TEGRA_MC_BASE);
 	unsigned long flags;
-	u32 mc_data[2];
+	u32 mc_data[3] = {0, 0, 0};
 	bool do_lp0 = (current_suspend_mode == TEGRA_SUSPEND_LP0);
 	bool do_lp2 = (current_suspend_mode == TEGRA_SUSPEND_LP2);
 	int lp_state;
@@ -533,6 +534,7 @@ static int tegra_suspend_enter(suspend_state_t state)
 
 		mc_data[0] = readl(mc + MC_SECURITY_START);
 		mc_data[1] = readl(mc + MC_SECURITY_SIZE);
+		mc_data[2] = readl(mc + MC_SECURITY_CFG2);
 	}
 
 	rtc_before = tegra_rtc_read_ms();
@@ -550,6 +552,7 @@ static int tegra_suspend_enter(suspend_state_t state)
 	if (do_lp0) {
 		writel(mc_data[0], mc + MC_SECURITY_START);
 		writel(mc_data[1], mc + MC_SECURITY_SIZE);
+		writel(mc_data[2], mc + MC_SECURITY_CFG2);
 
 		tegra_clk_resume();
 		tegra_gpio_resume();
-- 
1.7.3.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594Ab1IUWKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 18:10:52 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37696 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab1IUWKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 18:10:50 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Olof Johansson <olof@lixom.net>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] arm/tegra: Harmony: Configure PMC for low-level interrupts
Date: Wed, 21 Sep 2011 16:10:40 -0600
Message-Id: <1316643040-7998-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this, the PMC continually detects an interrupt when the PMU_IRQ
line is high, causing the tps6686x IRQ handler thread to hog an entire
CPU.

This change was originally written by Wei Ni <wni@nvidia.com> for Seaboard
in the ChromeOS kernel.

Long-term, this should probably be moved into some kind of PMU driver,
or perhaps integrated into the GPIO/IRQ/pinmux system?

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/mach-tegra/board-harmony-power.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-tegra/board-harmony-power.c b/arch/arm/mach-tegra/board-harmony-power.c
index 5ad8b2f..21d1285 100644
--- a/arch/arm/mach-tegra/board-harmony-power.c
+++ b/arch/arm/mach-tegra/board-harmony-power.c
@@ -18,10 +18,11 @@
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
-
+#include <linux/io.h>
 #include <linux/regulator/machine.h>
 #include <linux/mfd/tps6586x.h>
 
+#include <mach/iomap.h>
 #include <mach/irqs.h>
 
 #include "board-harmony.h"
@@ -113,6 +114,16 @@ static struct i2c_board_info __initdata harmony_regulators[] = {
 
 int __init harmony_regulator_init(void)
 {
+	void __iomem *pmc = IO_ADDRESS(TEGRA_PMC_BASE);
+	u32 pmc_ctrl;
+
+	/*
+	 * Configure the power management controller to trigger PMU
+	 * interrupts when low
+	 */
+	pmc_ctrl = readl(pmc + PMC_CTRL);
+	writel(pmc_ctrl | PMC_CTRL_INTR_LOW, pmc + PMC_CTRL);
+
 	i2c_register_board_info(3, harmony_regulators, 1);
 
 	return 0;
-- 
1.7.0.4


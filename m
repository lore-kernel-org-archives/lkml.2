Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab2AJQWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 11:22:35 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5525 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756470Ab2AJQWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 11:22:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 10 Jan 2012 08:22:33 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: tegra: initialize basic system clocks
Date: Tue, 10 Jan 2012 18:22:18 +0200
Message-Id: <1326212538-15419-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF177EE3A286@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF177EE3A286@HQMAIL01.nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize basic system clocks and provide a auxdata table to allow some
peripheral drivers to find their clocks.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

---

Stephen,

This should fix the hang you observed when sdhci_add_host() fails.
---
 arch/arm/mach-tegra/board-dt-tegra30.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-tegra/board-dt-tegra30.c b/arch/arm/mach-tegra/board-dt-tegra30.c
index 3c197e2..b4124b1 100644
--- a/arch/arm/mach-tegra/board-dt-tegra30.c
+++ b/arch/arm/mach-tegra/board-dt-tegra30.c
@@ -34,16 +34,38 @@
 #include <asm/hardware/gic.h>
 
 #include "board.h"
+#include "clock.h"
 
 static struct of_device_id tegra_dt_match_table[] __initdata = {
 	{ .compatible = "simple-bus", },
 	{}
 };
 
+struct of_dev_auxdata tegra30_auxdata_lookup[] __initdata = {
+	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", 0x78000000, "sdhci-tegra.0", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", 0x78000200, "sdhci-tegra.1", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", 0x78000400, "sdhci-tegra.2", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", 0x78000600, "sdhci-tegra.3", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-i2c", 0x7000C000, "tegra-i2c.0", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-i2c", 0x7000C400, "tegra-i2c.1", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-i2c", 0x7000C500, "tegra-i2c.2", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-i2c", 0x7000C700, "tegra-i2c.3", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-i2c", 0x7000D000, "tegra-i2c.4", NULL),
+	{}
+};
+
+static __initdata struct tegra_clk_init_table tegra_dt_clk_init_table[] = {
+	/* name		parent		rate		enabled */
+	{ "uartd",	"pll_p",	408000000,	true },
+	{ NULL,		NULL,		0,		0},
+};
+
 static void __init tegra30_dt_init(void)
 {
+	tegra_clk_init_from_table(tegra_dt_clk_init_table);
+
 	of_platform_populate(NULL, tegra_dt_match_table,
-				NULL, NULL);
+				tegra30_auxdata_lookup, NULL);
 }
 
 static const char *tegra30_dt_board_compat[] = {
-- 
1.7.7.rc0.72.g4b5ea.dirty


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab2KZNS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:18:26 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3711 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab2KZNQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:16:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 26 Nov 2012 05:16:15 -0800
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <thierry.reding@avionic-design.de>, <linux-tegra@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
CC: <linux-kernel@vger.kernel.org>, Terje Bergstrom <tbergstrom@nvidia.com>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: [RFC v2 5/8] ARM: tegra: Add auxiliary data for nvhost
Date: Mon, 26 Nov 2012 15:19:11 +0200
Message-ID: <1353935954-13763-6-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add SoC specific auxiliary data to host1x and gr2d. nvhost uses
this data.

Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
---
 arch/arm/mach-tegra/board-dt-tegra20.c    |   38 ++++++++++++++++++++++++++++-
 arch/arm/mach-tegra/board-dt-tegra30.c    |   38 ++++++++++++++++++++++++++++-
 arch/arm/mach-tegra/tegra20_clocks_data.c |    8 +++---
 arch/arm/mach-tegra/tegra30_clocks_data.c |    2 ++
 4 files changed, 80 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c
index 1d30eac..c695392 100644
--- a/arch/arm/mach-tegra/board-dt-tegra20.c
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@ -33,6 +33,7 @@
 #include <linux/i2c.h>
 #include <linux/i2c-tegra.h>
 #include <linux/usb/tegra_usb_phy.h>
+#include <linux/nvhost.h>
 
 #include <asm/hardware/gic.h>
 #include <asm/mach-types.h>
@@ -45,6 +46,38 @@
 #include "common.h"
 #include "iomap.h"
 
+static const char *host1x_syncpt_names[32] = {
+	[0] = "gfx_host",
+	[NVSYNCPT_2D_0] = "2d_0",
+	[NVSYNCPT_2D_1] = "2d_1",
+	[NVSYNCPT_VBLANK0] = "vblank0",
+	[NVSYNCPT_VBLANK1] = "vblank1",
+};
+
+static struct host1x_device_info host1x_info = {
+	.nb_channels	= 8,
+	.nb_pts		= 32,
+	.nb_mlocks	= 16,
+	.nb_bases	= 8,
+	.syncpt_names	= host1x_syncpt_names,
+	.client_managed	= NVSYNCPTS_CLIENT_MANAGED,
+};
+
+static struct nvhost_device_data tegra_host1x_info = {
+	.clocks = { {"host1x", UINT_MAX} },
+	NVHOST_MODULE_NO_POWERGATE_IDS,
+	.private_data = &host1x_info,
+};
+
+static struct nvhost_device_data tegra_gr2d_info = {
+	.index		= 2,
+	.syncpts	= BIT(NVSYNCPT_2D_0) | BIT(NVSYNCPT_2D_1),
+	.clocks		= { {"gr2d", UINT_MAX, true}, {"epp", UINT_MAX, true} },
+	NVHOST_MODULE_NO_POWERGATE_IDS,
+	.clockgate_delay = 0,
+	.serialize	= true,
+};
+
 struct tegra_ehci_platform_data tegra_ehci1_pdata = {
 	.operating_mode = TEGRA_USB_OTG,
 	.power_down_on_bus_suspend = 1,
@@ -94,13 +127,16 @@ struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("nvidia,tegra20-slink", 0x7000D600, "spi_tegra.1", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-slink", 0x7000D800, "spi_tegra.2", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-slink", 0x7000DA00, "spi_tegra.3", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-host1x", 0x50000000, "host1x", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-host1x", 0x50000000, "host1x",
+			&tegra_host1x_info),
 	OF_DEV_AUXDATA("nvidia,tegra20-dc", 0x54200000, "tegradc.0", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-dc", 0x54240000, "tegradc.1", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-hdmi", 0x54280000, "hdmi", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-dsi", 0x54300000, "dsi", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-tvo", 0x542c0000, "tvo", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-nand", 0x70008000, "tegra-nand", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-gr2d", 0x54140000, "tegra-gr2d",
+		       &tegra_gr2d_info),
 	{}
 };
 
diff --git a/arch/arm/mach-tegra/board-dt-tegra30.c b/arch/arm/mach-tegra/board-dt-tegra30.c
index 6497d12..1afa68b 100644
--- a/arch/arm/mach-tegra/board-dt-tegra30.c
+++ b/arch/arm/mach-tegra/board-dt-tegra30.c
@@ -29,6 +29,7 @@
 #include <linux/of_fdt.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
+#include <linux/nvhost.h>
 
 #include <asm/mach/arch.h>
 #include <asm/hardware/gic.h>
@@ -38,6 +39,38 @@
 #include "common.h"
 #include "iomap.h"
 
+static const char *host1x_syncpt_names[32] = {
+	[0] = "gfx_host",
+	[NVSYNCPT_2D_0] = "2d_0",
+	[NVSYNCPT_2D_1] = "2d_1",
+	[NVSYNCPT_VBLANK0] = "vblank0",
+	[NVSYNCPT_VBLANK1] = "vblank1",
+};
+
+static struct host1x_device_info host1x_info = {
+	.nb_channels	= 8,
+	.nb_pts		= 32,
+	.nb_mlocks	= 16,
+	.nb_bases	= 8,
+	.syncpt_names	= host1x_syncpt_names,
+	.client_managed	= NVSYNCPTS_CLIENT_MANAGED,
+};
+
+static struct nvhost_device_data tegra_host1x_info = {
+	.clocks = { {"host1x", UINT_MAX} },
+	NVHOST_MODULE_NO_POWERGATE_IDS,
+	.private_data = &host1x_info,
+};
+
+static struct nvhost_device_data tegra_gr2d_info = {
+	.index		= 2,
+	.syncpts	= BIT(NVSYNCPT_2D_0) | BIT(NVSYNCPT_2D_1),
+	.clocks		= { {"gr2d", UINT_MAX, true}, {"epp", UINT_MAX, true} },
+	NVHOST_MODULE_NO_POWERGATE_IDS,
+	.clockgate_delay = 0,
+	.serialize	= true,
+};
+
 struct of_dev_auxdata tegra30_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", 0x78000000, "sdhci-tegra.0", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", 0x78000200, "sdhci-tegra.1", NULL),
@@ -57,12 +90,15 @@ struct of_dev_auxdata tegra30_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("nvidia,tegra30-slink", 0x7000DA00, "spi_tegra.3", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra30-slink", 0x7000DC00, "spi_tegra.4", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra30-slink", 0x7000DE00, "spi_tegra.5", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra30-host1x", 0x50000000, "host1x", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-host1x", 0x50000000, "host1x",
+			&tegra_host1x_info),
 	OF_DEV_AUXDATA("nvidia,tegra30-dc", 0x54200000, "tegradc.0", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra30-dc", 0x54240000, "tegradc.1", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra30-hdmi", 0x54280000, "hdmi", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra30-dsi", 0x54300000, "dsi", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra30-tvo", 0x542c0000, "tvo", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-gr2d", 0x54140000, "gr2d",
+		       &tegra_gr2d_info),
 	{}
 };
 
diff --git a/arch/arm/mach-tegra/tegra20_clocks_data.c b/arch/arm/mach-tegra/tegra20_clocks_data.c
index 7f049ac..3314e50 100644
--- a/arch/arm/mach-tegra/tegra20_clocks_data.c
+++ b/arch/arm/mach-tegra/tegra20_clocks_data.c
@@ -1041,10 +1041,10 @@ static struct clk_duplicate tegra_clk_duplicates[] = {
 	CLK_DUPLICATE("usbd",	"utmip-pad",	NULL),
 	CLK_DUPLICATE("usbd",	"tegra-ehci.0",	NULL),
 	CLK_DUPLICATE("usbd",	"tegra-otg",	NULL),
-	CLK_DUPLICATE("2d",	"tegra_grhost",	"gr2d"),
-	CLK_DUPLICATE("3d",	"tegra_grhost",	"gr3d"),
-	CLK_DUPLICATE("epp",	"tegra_grhost",	"epp"),
-	CLK_DUPLICATE("mpe",	"tegra_grhost",	"mpe"),
+	CLK_DUPLICATE("2d",	NULL,		"gr2d"),
+	CLK_DUPLICATE("3d",	NULL,		"gr3d"),
+	CLK_DUPLICATE("epp",	NULL,		"epp"),
+	CLK_DUPLICATE("mpe",	NULL,		"mpe"),
 	CLK_DUPLICATE("cop",	"tegra-avp",	"cop"),
 	CLK_DUPLICATE("vde",	"tegra-aes",	"vde"),
 	CLK_DUPLICATE("cclk",	NULL,		"cpu"),
diff --git a/arch/arm/mach-tegra/tegra30_clocks_data.c b/arch/arm/mach-tegra/tegra30_clocks_data.c
index 6942c7a..f30bd54 100644
--- a/arch/arm/mach-tegra/tegra30_clocks_data.c
+++ b/arch/arm/mach-tegra/tegra30_clocks_data.c
@@ -1338,6 +1338,8 @@ struct clk_duplicate tegra_clk_duplicates[] = {
 	CLK_DUPLICATE("pll_p", "tegradc.0", "parent"),
 	CLK_DUPLICATE("pll_p", "tegradc.1", "parent"),
 	CLK_DUPLICATE("pll_d2_out0", "hdmi", "parent"),
+	CLK_DUPLICATE("2d", NULL, "gr2d"),
+	CLK_DUPLICATE("epp", NULL, "epp"),
 };
 
 struct clk *tegra_ptr_clks[] = {
-- 
1.7.9.5


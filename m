Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486Ab2JSKjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:39:49 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13166 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab2JSKjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:39:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 19 Oct 2012 03:39:46 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>, <balbi@ti.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH v3 resend] USB: PHY: Re-organize Tegra USB PHY driver
Date: Fri, 19 Oct 2012 16:08:05 +0530
Message-ID: <1350643085-27294-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NVIDIA produces several Tegra SoCs viz Tegra20, Tegra30 etc.
In order to support USB PHY drivers on these SoCs, existing
PHY driver is split into SoC agnostic common USB PHY driver
and Tegra20-specific USB phy driver. This will facilitate
easy addition and deletion of phy drivers for Tegra SoCs.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
delta from v3 resend:
For unknown reasons, email-id in signed-off-by got corrupted.
Hence re-sending the patch, after fixing it.

delta from v3:
Rebased the v3 changes on top of xceiv branch.

delta from v2:
Added an if condition to check for device_node to be not NULL,
before dereferencing it.


 drivers/usb/host/ehci-tegra.c                      |   20 +-
 drivers/usb/phy/Makefile                           |    1 +
 .../usb/phy/{tegra_usb_phy.c => tegra2_usb_phy.c}  |  372 ++---------
 drivers/usb/phy/tegra2_usb_phy.h                   |  178 +++++
 drivers/usb/phy/tegra_usb_phy.c                    |  725 +-------------------
 include/linux/usb/tegra_usb_phy.h                  |   34 +-
 6 files changed, 304 insertions(+), 1026 deletions(-)
 copy drivers/usb/phy/{tegra_usb_phy.c => tegra2_usb_phy.c} (57%)
 create mode 100644 drivers/usb/phy/tegra2_usb_phy.h

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 6223d17..e08aea3 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -618,6 +618,9 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	int err = 0;
 	int irq;
 	int instance = pdev->id;
+	struct device_node *np = pdev->dev.of_node;
+	struct phy_params params;
+	int phy_type;
 
 	pdata = pdev->dev.platform_data;
 	if (!pdata) {
@@ -706,9 +709,22 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 		}
 	}
 
+	phy_type = of_property_match_string(np, "phy_type", "utmi");
+	if (phy_type >= 0)
+		params.type = TEGRA_USB_PHY_TYPE_UTMI;
+	else {
+		phy_type = of_property_match_string(np, "phy_type", "ulpi");
+		if (phy_type >= 0)
+			params.type = TEGRA_USB_PHY_TYPE_ULPI;
+		else
+			params.type = TEGRA_USB_PHY_TYPE_INVALID;
+	}
+
+	params.mode = TEGRA_USB_PHY_MODE_HOST;
+	params.config = pdata->phy_config;
+
 	tegra->phy = tegra_usb_phy_open(&pdev->dev, instance, hcd->regs,
-					pdata->phy_config,
-					TEGRA_USB_PHY_MODE_HOST);
+		&params);
 	if (IS_ERR(tegra->phy)) {
 		dev_err(&pdev->dev, "Failed to open USB phy\n");
 		err = -ENXIO;
diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
index b069f29..21872e1 100644
--- a/drivers/usb/phy/Makefile
+++ b/drivers/usb/phy/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_OMAP_USB2)			+= omap-usb2.o
 obj-$(CONFIG_USB_ISP1301)		+= isp1301.o
 obj-$(CONFIG_MV_U3D_PHY)		+= mv_u3d_phy.o
 obj-$(CONFIG_USB_EHCI_TEGRA)	+= tegra_usb_phy.o
+obj-$(CONFIG_USB_EHCI_TEGRA)	+= tegra2_usb_phy.o
diff --git a/drivers/usb/phy/tegra_usb_phy.c b/drivers/usb/phy/tegra2_usb_phy.c
similarity index 57%
copy from drivers/usb/phy/tegra_usb_phy.c
copy to drivers/usb/phy/tegra2_usb_phy.c
index 9d13c81..2ff6dcb 100644
--- a/drivers/usb/phy/tegra_usb_phy.c
+++ b/drivers/usb/phy/tegra2_usb_phy.c
@@ -1,9 +1,11 @@
 /*
  * Copyright (C) 2010 Google, Inc.
+ * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
  *
  * Author:
  *	Erik Gilling <konkers@google.com>
  *	Benoit Goby <benoit@android.com>
+ *	Venu Byravarasu <vbyravarasu@nvidia.com>
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -29,191 +31,20 @@
 #include <linux/usb/ulpi.h>
 #include <asm/mach-types.h>
 #include <linux/usb/tegra_usb_phy.h>
+#include <mach/iomap.h>
 
-#define TEGRA_USB_BASE		0xC5000000
-#define TEGRA_USB_SIZE		SZ_16K
-
-#define ULPI_VIEWPORT		0x170
-
-#define USB_PORTSC1		0x184
-#define   USB_PORTSC1_PTS(x)	(((x) & 0x3) << 30)
-#define   USB_PORTSC1_PSPD(x)	(((x) & 0x3) << 26)
-#define   USB_PORTSC1_PHCD	(1 << 23)
-#define   USB_PORTSC1_WKOC	(1 << 22)
-#define   USB_PORTSC1_WKDS	(1 << 21)
-#define   USB_PORTSC1_WKCN	(1 << 20)
-#define   USB_PORTSC1_PTC(x)	(((x) & 0xf) << 16)
-#define   USB_PORTSC1_PP	(1 << 12)
-#define   USB_PORTSC1_SUSP	(1 << 7)
-#define   USB_PORTSC1_PE	(1 << 2)
-#define   USB_PORTSC1_CCS	(1 << 0)
-
-#define USB_SUSP_CTRL		0x400
-#define   USB_WAKE_ON_CNNT_EN_DEV	(1 << 3)
-#define   USB_WAKE_ON_DISCON_EN_DEV	(1 << 4)
-#define   USB_SUSP_CLR		(1 << 5)
-#define   USB_PHY_CLK_VALID	(1 << 7)
-#define   UTMIP_RESET			(1 << 11)
-#define   UHSIC_RESET			(1 << 11)
-#define   UTMIP_PHY_ENABLE		(1 << 12)
-#define   ULPI_PHY_ENABLE	(1 << 13)
-#define   USB_SUSP_SET		(1 << 14)
-#define   USB_WAKEUP_DEBOUNCE_COUNT(x)	(((x) & 0x7) << 16)
-
-#define USB1_LEGACY_CTRL	0x410
-#define   USB1_NO_LEGACY_MODE			(1 << 0)
-#define   USB1_VBUS_SENSE_CTL_MASK		(3 << 1)
-#define   USB1_VBUS_SENSE_CTL_VBUS_WAKEUP	(0 << 1)
-#define   USB1_VBUS_SENSE_CTL_AB_SESS_VLD_OR_VBUS_WAKEUP \
-						(1 << 1)
-#define   USB1_VBUS_SENSE_CTL_AB_SESS_VLD	(2 << 1)
-#define   USB1_VBUS_SENSE_CTL_A_SESS_VLD	(3 << 1)
-
-#define ULPI_TIMING_CTRL_0	0x424
-#define   ULPI_OUTPUT_PINMUX_BYP	(1 << 10)
-#define   ULPI_CLKOUT_PINMUX_BYP	(1 << 11)
-
-#define ULPI_TIMING_CTRL_1	0x428
-#define   ULPI_DATA_TRIMMER_LOAD	(1 << 0)
-#define   ULPI_DATA_TRIMMER_SEL(x)	(((x) & 0x7) << 1)
-#define   ULPI_STPDIRNXT_TRIMMER_LOAD	(1 << 16)
-#define   ULPI_STPDIRNXT_TRIMMER_SEL(x)	(((x) & 0x7) << 17)
-#define   ULPI_DIR_TRIMMER_LOAD		(1 << 24)
-#define   ULPI_DIR_TRIMMER_SEL(x)	(((x) & 0x7) << 25)
-
-#define UTMIP_PLL_CFG1		0x804
-#define   UTMIP_XTAL_FREQ_COUNT(x)		(((x) & 0xfff) << 0)
-#define   UTMIP_PLLU_ENABLE_DLY_COUNT(x)	(((x) & 0x1f) << 27)
-
-#define UTMIP_XCVR_CFG0		0x808
-#define   UTMIP_XCVR_SETUP(x)			(((x) & 0xf) << 0)
-#define   UTMIP_XCVR_LSRSLEW(x)			(((x) & 0x3) << 8)
-#define   UTMIP_XCVR_LSFSLEW(x)			(((x) & 0x3) << 10)
-#define   UTMIP_FORCE_PD_POWERDOWN		(1 << 14)
-#define   UTMIP_FORCE_PD2_POWERDOWN		(1 << 16)
-#define   UTMIP_FORCE_PDZI_POWERDOWN		(1 << 18)
-#define   UTMIP_XCVR_HSSLEW_MSB(x)		(((x) & 0x7f) << 25)
-
-#define UTMIP_BIAS_CFG0		0x80c
-#define   UTMIP_OTGPD			(1 << 11)
-#define   UTMIP_BIASPD			(1 << 10)
-
-#define UTMIP_HSRX_CFG0		0x810
-#define   UTMIP_ELASTIC_LIMIT(x)	(((x) & 0x1f) << 10)
-#define   UTMIP_IDLE_WAIT(x)		(((x) & 0x1f) << 15)
-
-#define UTMIP_HSRX_CFG1		0x814
-#define   UTMIP_HS_SYNC_START_DLY(x)	(((x) & 0x1f) << 1)
-
-#define UTMIP_TX_CFG0		0x820
-#define   UTMIP_FS_PREABMLE_J		(1 << 19)
-#define   UTMIP_HS_DISCON_DISABLE	(1 << 8)
-
-#define UTMIP_MISC_CFG0		0x824
-#define   UTMIP_DPDM_OBSERVE		(1 << 26)
-#define   UTMIP_DPDM_OBSERVE_SEL(x)	(((x) & 0xf) << 27)
-#define   UTMIP_DPDM_OBSERVE_SEL_FS_J	UTMIP_DPDM_OBSERVE_SEL(0xf)
-#define   UTMIP_DPDM_OBSERVE_SEL_FS_K	UTMIP_DPDM_OBSERVE_SEL(0xe)
-#define   UTMIP_DPDM_OBSERVE_SEL_FS_SE1 UTMIP_DPDM_OBSERVE_SEL(0xd)
-#define   UTMIP_DPDM_OBSERVE_SEL_FS_SE0 UTMIP_DPDM_OBSERVE_SEL(0xc)
-#define   UTMIP_SUSPEND_EXIT_ON_EDGE	(1 << 22)
-
-#define UTMIP_MISC_CFG1		0x828
-#define   UTMIP_PLL_ACTIVE_DLY_COUNT(x)	(((x) & 0x1f) << 18)
-#define   UTMIP_PLLU_STABLE_COUNT(x)	(((x) & 0xfff) << 6)
-
-#define UTMIP_DEBOUNCE_CFG0	0x82c
-#define   UTMIP_BIAS_DEBOUNCE_A(x)	(((x) & 0xffff) << 0)
-
-#define UTMIP_BAT_CHRG_CFG0	0x830
-#define   UTMIP_PD_CHRG			(1 << 0)
-
-#define UTMIP_SPARE_CFG0	0x834
-#define   FUSE_SETUP_SEL		(1 << 3)
-
-#define UTMIP_XCVR_CFG1		0x838
-#define   UTMIP_FORCE_PDDISC_POWERDOWN	(1 << 0)
-#define   UTMIP_FORCE_PDCHRP_POWERDOWN	(1 << 2)
-#define   UTMIP_FORCE_PDDR_POWERDOWN	(1 << 4)
-#define   UTMIP_XCVR_TERM_RANGE_ADJ(x)	(((x) & 0xf) << 18)
-
-#define UTMIP_BIAS_CFG1		0x83c
-#define   UTMIP_BIAS_PDTRK_COUNT(x)	(((x) & 0x1f) << 3)
+#include "tegra2_usb_phy.h"
 
 static DEFINE_SPINLOCK(utmip_pad_lock);
 static int utmip_pad_count;
 
-struct tegra_xtal_freq {
-	int freq;
-	u8 enable_delay;
-	u8 stable_count;
-	u8 active_delay;
-	u8 xtal_freq_count;
-	u16 debounce;
-};
-
-static const struct tegra_xtal_freq tegra_freq_table[] = {
-	{
-		.freq = 12000000,
-		.enable_delay = 0x02,
-		.stable_count = 0x2F,
-		.active_delay = 0x04,
-		.xtal_freq_count = 0x76,
-		.debounce = 0x7530,
-	},
-	{
-		.freq = 13000000,
-		.enable_delay = 0x02,
-		.stable_count = 0x33,
-		.active_delay = 0x05,
-		.xtal_freq_count = 0x7F,
-		.debounce = 0x7EF4,
-	},
-	{
-		.freq = 19200000,
-		.enable_delay = 0x03,
-		.stable_count = 0x4B,
-		.active_delay = 0x06,
-		.xtal_freq_count = 0xBB,
-		.debounce = 0xBB80,
-	},
-	{
-		.freq = 26000000,
-		.enable_delay = 0x04,
-		.stable_count = 0x66,
-		.active_delay = 0x09,
-		.xtal_freq_count = 0xFE,
-		.debounce = 0xFDE8,
-	},
-};
-
-static struct tegra_utmip_config utmip_default[] = {
-	[0] = {
-		.hssync_start_delay = 9,
-		.idle_wait_delay = 17,
-		.elastic_limit = 16,
-		.term_range_adj = 6,
-		.xcvr_setup = 9,
-		.xcvr_lsfslew = 1,
-		.xcvr_lsrslew = 1,
-	},
-	[2] = {
-		.hssync_start_delay = 9,
-		.idle_wait_delay = 17,
-		.elastic_limit = 16,
-		.term_range_adj = 6,
-		.xcvr_setup = 9,
-		.xcvr_lsfslew = 2,
-		.xcvr_lsrslew = 2,
-	},
-};
-
 static inline bool phy_is_ulpi(struct tegra_usb_phy *phy)
 {
-	return (phy->instance == 1);
+	return (phy->type == TEGRA_USB_PHY_TYPE_ULPI);
 }
 
-static int utmip_pad_open(struct tegra_usb_phy *phy)
+
+static int tegra2_utmip_pad_open(struct tegra_usb_phy *phy)
 {
 	phy->pad_clk = clk_get_sys("utmip-pad", NULL);
 	if (IS_ERR(phy->pad_clk)) {
@@ -234,14 +65,14 @@ static int utmip_pad_open(struct tegra_usb_phy *phy)
 	return 0;
 }
 
-static void utmip_pad_close(struct tegra_usb_phy *phy)
+static void tegra2_utmip_pad_close(struct tegra_usb_phy *phy)
 {
 	if (phy->instance != 0)
 		iounmap(phy->pad_regs);
 	clk_put(phy->pad_clk);
 }
 
-static void utmip_pad_power_on(struct tegra_usb_phy *phy)
+static void tegra2_utmip_pad_power_on(struct tegra_usb_phy *phy)
 {
 	unsigned long val, flags;
 	void __iomem *base = phy->pad_regs;
@@ -261,7 +92,7 @@ static void utmip_pad_power_on(struct tegra_usb_phy *phy)
 	clk_disable_unprepare(phy->pad_clk);
 }
 
-static int utmip_pad_power_off(struct tegra_usb_phy *phy)
+static int tegra2_utmip_pad_power_off(struct tegra_usb_phy *phy)
 {
 	unsigned long val, flags;
 	void __iomem *base = phy->pad_regs;
@@ -291,6 +122,7 @@ static int utmip_pad_power_off(struct tegra_usb_phy *phy)
 static int utmi_wait_register(void __iomem *reg, u32 mask, u32 result)
 {
 	unsigned long timeout = 2000;
+
 	do {
 		if ((readl(reg) & mask) == result)
 			return 0;
@@ -300,7 +132,7 @@ static int utmi_wait_register(void __iomem *reg, u32 mask, u32 result)
 	return -1;
 }
 
-static void utmi_phy_clk_disable(struct tegra_usb_phy *phy)
+static void tegra2_utmi_phy_clk_disable(struct tegra_usb_phy *phy)
 {
 	unsigned long val;
 	void __iomem *base = phy->regs;
@@ -327,7 +159,7 @@ static void utmi_phy_clk_disable(struct tegra_usb_phy *phy)
 		pr_err("%s: timeout waiting for phy to stabilize\n", __func__);
 }
 
-static void utmi_phy_clk_enable(struct tegra_usb_phy *phy)
+static void tegra2_utmi_phy_clk_enable(struct tegra_usb_phy *phy)
 {
 	unsigned long val;
 	void __iomem *base = phy->regs;
@@ -355,7 +187,7 @@ static void utmi_phy_clk_enable(struct tegra_usb_phy *phy)
 		pr_err("%s: timeout waiting for phy to stabilize\n", __func__);
 }
 
-static int utmi_phy_power_on(struct tegra_usb_phy *phy)
+static int tegra2_utmi_phy_power_on(struct tegra_usb_phy *phy)
 {
 	unsigned long val;
 	void __iomem *base = phy->regs;
@@ -413,7 +245,7 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
 		writel(val, base + USB_SUSP_CTRL);
 	}
 
-	utmip_pad_power_on(phy);
+	tegra2_utmip_pad_power_on(phy);
 
 	val = readl(base + UTMIP_XCVR_CFG0);
 	val &= ~(UTMIP_FORCE_PD_POWERDOWN | UTMIP_FORCE_PD2_POWERDOWN |
@@ -470,7 +302,7 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
 		writel(val, base + USB_SUSP_CTRL);
 	}
 
-	utmi_phy_clk_enable(phy);
+	tegra2_utmi_phy_clk_enable(phy);
 
 	if (phy->instance == 2) {
 		val = readl(base + USB_PORTSC1);
@@ -481,12 +313,12 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
 	return 0;
 }
 
-static int utmi_phy_power_off(struct tegra_usb_phy *phy)
+static int tegra2_utmi_phy_power_off(struct tegra_usb_phy *phy)
 {
 	unsigned long val;
 	void __iomem *base = phy->regs;
 
-	utmi_phy_clk_disable(phy);
+	tegra2_utmi_phy_clk_disable(phy);
 
 	if (phy->mode == TEGRA_USB_PHY_MODE_DEVICE) {
 		val = readl(base + USB_SUSP_CTRL);
@@ -513,10 +345,10 @@ static int utmi_phy_power_off(struct tegra_usb_phy *phy)
 	       UTMIP_FORCE_PDDR_POWERDOWN;
 	writel(val, base + UTMIP_XCVR_CFG1);
 
-	return utmip_pad_power_off(phy);
+	return tegra2_utmip_pad_power_off(phy);
 }
 
-static void utmi_phy_preresume(struct tegra_usb_phy *phy)
+static void tegra2_utmi_phy_preresume(struct tegra_usb_phy *phy)
 {
 	unsigned long val;
 	void __iomem *base = phy->regs;
@@ -526,7 +358,7 @@ static void utmi_phy_preresume(struct tegra_usb_phy *phy)
 	writel(val, base + UTMIP_TX_CFG0);
 }
 
-static void utmi_phy_postresume(struct tegra_usb_phy *phy)
+static void tegra2_utmi_phy_postresume(struct tegra_usb_phy *phy)
 {
 	unsigned long val;
 	void __iomem *base = phy->regs;
@@ -536,7 +368,7 @@ static void utmi_phy_postresume(struct tegra_usb_phy *phy)
 	writel(val, base + UTMIP_TX_CFG0);
 }
 
-static void utmi_phy_restore_start(struct tegra_usb_phy *phy,
+static void tegra2_utmi_phy_restore_start(struct tegra_usb_phy *phy,
 				   enum tegra_usb_phy_port_speed port_speed)
 {
 	unsigned long val;
@@ -557,7 +389,7 @@ static void utmi_phy_restore_start(struct tegra_usb_phy *phy,
 	udelay(10);
 }
 
-static void utmi_phy_restore_end(struct tegra_usb_phy *phy)
+static void tegra2_utmi_phy_restore_end(struct tegra_usb_phy *phy)
 {
 	unsigned long val;
 	void __iomem *base = phy->regs;
@@ -568,7 +400,7 @@ static void utmi_phy_restore_end(struct tegra_usb_phy *phy)
 	udelay(10);
 }
 
-static int ulpi_phy_power_on(struct tegra_usb_phy *phy)
+static int tegra2_ulpi_phy_power_on(struct tegra_usb_phy *phy)
 {
 	int ret;
 	unsigned long val;
@@ -637,7 +469,7 @@ static int ulpi_phy_power_on(struct tegra_usb_phy *phy)
 	return 0;
 }
 
-static int ulpi_phy_power_off(struct tegra_usb_phy *phy)
+static int tegra2_ulpi_phy_power_off(struct tegra_usb_phy *phy)
 {
 	unsigned long val;
 	void __iomem *base = phy->regs;
@@ -654,9 +486,8 @@ static int ulpi_phy_power_off(struct tegra_usb_phy *phy)
 	return gpio_direction_output(config->reset_gpio, 0);
 }
 
-static int	tegra_phy_init(struct usb_phy *x)
+static int	tegra2_usb_phy_open(struct tegra_usb_phy *phy)
 {
-	struct tegra_usb_phy *phy = container_of(x, struct tegra_usb_phy, u_phy);
 	struct tegra_ulpi_config *ulpi_config;
 	int err;
 
@@ -683,7 +514,7 @@ static int	tegra_phy_init(struct usb_phy *x)
 		phy->ulpi = otg_ulpi_create(&ulpi_viewport_access_ops, 0);
 		phy->ulpi->io_priv = phy->regs + ULPI_VIEWPORT;
 	} else {
-		err = utmip_pad_open(phy);
+		err = tegra2_utmip_pad_open(phy);
 		if (err < 0)
 			goto err1;
 	}
@@ -694,147 +525,36 @@ err1:
 	return err;
 }
 
-static void tegra_usb_phy_close(struct usb_phy *x)
+static void tegra2_usb_phy_close(struct tegra_usb_phy *phy)
 {
-	struct tegra_usb_phy *phy = container_of(x, struct tegra_usb_phy, u_phy);
-
 	if (phy_is_ulpi(phy))
 		clk_put(phy->clk);
 	else
-		utmip_pad_close(phy);
+		tegra2_utmip_pad_close(phy);
 	clk_disable_unprepare(phy->pll_u);
 	clk_put(phy->pll_u);
-	kfree(phy);
 }
 
-static int tegra_usb_phy_power_on(struct tegra_usb_phy *phy)
+int tegra2_usb_phy_init(struct tegra_usb_phy *phy)
 {
-	if (phy_is_ulpi(phy))
-		return ulpi_phy_power_on(phy);
-	else
-		return utmi_phy_power_on(phy);
-}
+	if ((phy->type != TEGRA_USB_PHY_TYPE_ULPI) &&
+		(phy->type != TEGRA_USB_PHY_TYPE_UTMI))
+			return -EINVAL;
 
-static int tegra_usb_phy_power_off(struct tegra_usb_phy *phy)
-{
-	if (phy_is_ulpi(phy))
-		return ulpi_phy_power_off(phy);
-	else
-		return utmi_phy_power_off(phy);
-}
+	phy->ops.open = tegra2_usb_phy_open;
+	phy->ops.close = tegra2_usb_phy_close;
 
-static int	tegra_usb_phy_suspend(struct usb_phy *x, int suspend)
-{
-	struct tegra_usb_phy *phy = container_of(x, struct tegra_usb_phy, u_phy);
-	if (suspend)
-		return tegra_usb_phy_power_off(phy);
-	else
-		return tegra_usb_phy_power_on(phy);
-}
-
-struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
-	void __iomem *regs, void *config, enum tegra_usb_phy_mode phy_mode)
-{
-	struct tegra_usb_phy *phy;
-	unsigned long parent_rate;
-	int i;
-	int err;
-
-	phy = kmalloc(sizeof(struct tegra_usb_phy), GFP_KERNEL);
-	if (!phy)
-		return ERR_PTR(-ENOMEM);
-
-	phy->instance = instance;
-	phy->regs = regs;
-	phy->config = config;
-	phy->mode = phy_mode;
-	phy->dev = dev;
-
-	if (!phy->config) {
-		if (phy_is_ulpi(phy)) {
-			pr_err("%s: ulpi phy configuration missing", __func__);
-			err = -EINVAL;
-			goto err0;
-		} else {
-			phy->config = &utmip_default[instance];
-		}
-	}
-
-	phy->pll_u = clk_get_sys(NULL, "pll_u");
-	if (IS_ERR(phy->pll_u)) {
-		pr_err("Can't get pll_u clock\n");
-		err = PTR_ERR(phy->pll_u);
-		goto err0;
-	}
-	clk_prepare_enable(phy->pll_u);
-
-	parent_rate = clk_get_rate(clk_get_parent(phy->pll_u));
-	for (i = 0; i < ARRAY_SIZE(tegra_freq_table); i++) {
-		if (tegra_freq_table[i].freq == parent_rate) {
-			phy->freq = &tegra_freq_table[i];
-			break;
-		}
-	}
-	if (!phy->freq) {
-		pr_err("invalid pll_u parent rate %ld\n", parent_rate);
-		err = -EINVAL;
-		goto err1;
+	if (phy_is_ulpi(phy)) {
+		phy->ops.power_on = tegra2_ulpi_phy_power_on;
+		phy->ops.power_off = tegra2_ulpi_phy_power_off;
+	} else if (phy->type == TEGRA_USB_PHY_TYPE_UTMI) {
+		phy->ops.postresume = tegra2_utmi_phy_postresume;
+		phy->ops.power_off = tegra2_utmi_phy_power_off;
+		phy->ops.power_on = tegra2_utmi_phy_power_on;
+		phy->ops.preresume = tegra2_utmi_phy_preresume;
+		phy->ops.restore_end = tegra2_utmi_phy_restore_end;
+		phy->ops.restore_start = tegra2_utmi_phy_restore_start;
 	}
 
-	phy->u_phy.init = tegra_phy_init;
-	phy->u_phy.shutdown = tegra_usb_phy_close;
-	phy->u_phy.set_suspend = tegra_usb_phy_suspend;
-
-	return phy;
-
-err1:
-	clk_disable_unprepare(phy->pll_u);
-	clk_put(phy->pll_u);
-err0:
-	kfree(phy);
-	return ERR_PTR(err);
-}
-EXPORT_SYMBOL_GPL(tegra_usb_phy_open);
-
-void tegra_usb_phy_preresume(struct tegra_usb_phy *phy)
-{
-	if (!phy_is_ulpi(phy))
-		utmi_phy_preresume(phy);
-}
-EXPORT_SYMBOL_GPL(tegra_usb_phy_preresume);
-
-void tegra_usb_phy_postresume(struct tegra_usb_phy *phy)
-{
-	if (!phy_is_ulpi(phy))
-		utmi_phy_postresume(phy);
-}
-EXPORT_SYMBOL_GPL(tegra_usb_phy_postresume);
-
-void tegra_ehci_phy_restore_start(struct tegra_usb_phy *phy,
-				 enum tegra_usb_phy_port_speed port_speed)
-{
-	if (!phy_is_ulpi(phy))
-		utmi_phy_restore_start(phy, port_speed);
-}
-EXPORT_SYMBOL_GPL(tegra_ehci_phy_restore_start);
-
-void tegra_ehci_phy_restore_end(struct tegra_usb_phy *phy)
-{
-	if (!phy_is_ulpi(phy))
-		utmi_phy_restore_end(phy);
-}
-EXPORT_SYMBOL_GPL(tegra_ehci_phy_restore_end);
-
-void tegra_usb_phy_clk_disable(struct tegra_usb_phy *phy)
-{
-	if (!phy_is_ulpi(phy))
-		utmi_phy_clk_disable(phy);
-}
-EXPORT_SYMBOL_GPL(tegra_usb_phy_clk_disable);
-
-void tegra_usb_phy_clk_enable(struct tegra_usb_phy *phy)
-{
-	if (!phy_is_ulpi(phy))
-		utmi_phy_clk_enable(phy);
+	return 0;
 }
-EXPORT_SYMBOL_GPL(tegra_usb_phy_clk_enable);
diff --git a/drivers/usb/phy/tegra2_usb_phy.h b/drivers/usb/phy/tegra2_usb_phy.h
new file mode 100644
index 0000000..32b0c03
--- /dev/null
+++ b/drivers/usb/phy/tegra2_usb_phy.h
@@ -0,0 +1,178 @@
+/*
+ * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * Author: Venu Byravarasu <vbyravarasu@nvidia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef _TEGRA2_USB_PHY_H
+#define _TEGRA2_USB_PHY_H
+
+#define TEGRA_USB_BASE		0xC5000000
+#define TEGRA_USB_SIZE		SZ_16K
+
+#define ULPI_VIEWPORT		0x170
+
+#define USB_PORTSC1		0x184
+#define   USB_PORTSC1_PTS(x)	(((x) & 0x3) << 30)
+#define   USB_PORTSC1_PSPD(x)	(((x) & 0x3) << 26)
+#define   USB_PORTSC1_PHCD	(1 << 23)
+#define   USB_PORTSC1_WKOC	(1 << 22)
+#define   USB_PORTSC1_WKDS	(1 << 21)
+#define   USB_PORTSC1_WKCN	(1 << 20)
+#define   USB_PORTSC1_PTC(x)	(((x) & 0xf) << 16)
+#define   USB_PORTSC1_PP	(1 << 12)
+#define   USB_PORTSC1_SUSP	(1 << 7)
+#define   USB_PORTSC1_PE	(1 << 2)
+#define   USB_PORTSC1_CCS	(1 << 0)
+
+#define USB_SUSP_CTRL		0x400
+#define   USB_WAKE_ON_CNNT_EN_DEV	(1 << 3)
+#define   USB_WAKE_ON_DISCON_EN_DEV	(1 << 4)
+#define   USB_SUSP_CLR		(1 << 5)
+#define   USB_PHY_CLK_VALID	(1 << 7)
+#define   UTMIP_RESET			(1 << 11)
+#define   UHSIC_RESET			(1 << 11)
+#define   UTMIP_PHY_ENABLE		(1 << 12)
+#define   ULPI_PHY_ENABLE	(1 << 13)
+#define   USB_SUSP_SET		(1 << 14)
+#define   USB_WAKEUP_DEBOUNCE_COUNT(x)	(((x) & 0x7) << 16)
+
+#define USB1_LEGACY_CTRL	0x410
+#define   USB1_NO_LEGACY_MODE			(1 << 0)
+#define   USB1_VBUS_SENSE_CTL_MASK		(3 << 1)
+#define   USB1_VBUS_SENSE_CTL_VBUS_WAKEUP	(0 << 1)
+#define   USB1_VBUS_SENSE_CTL_AB_SESS_VLD_OR_VBUS_WAKEUP \
+						(1 << 1)
+#define   USB1_VBUS_SENSE_CTL_AB_SESS_VLD	(2 << 1)
+#define   USB1_VBUS_SENSE_CTL_A_SESS_VLD	(3 << 1)
+
+#define ULPI_TIMING_CTRL_0	0x424
+#define   ULPI_OUTPUT_PINMUX_BYP	(1 << 10)
+#define   ULPI_CLKOUT_PINMUX_BYP	(1 << 11)
+
+#define ULPI_TIMING_CTRL_1	0x428
+#define   ULPI_DATA_TRIMMER_LOAD	(1 << 0)
+#define   ULPI_DATA_TRIMMER_SEL(x)	(((x) & 0x7) << 1)
+#define   ULPI_STPDIRNXT_TRIMMER_LOAD	(1 << 16)
+#define   ULPI_STPDIRNXT_TRIMMER_SEL(x)	(((x) & 0x7) << 17)
+#define   ULPI_DIR_TRIMMER_LOAD		(1 << 24)
+#define   ULPI_DIR_TRIMMER_SEL(x)	(((x) & 0x7) << 25)
+
+#define UTMIP_PLL_CFG1		0x804
+#define   UTMIP_XTAL_FREQ_COUNT(x)		(((x) & 0xfff) << 0)
+#define   UTMIP_PLLU_ENABLE_DLY_COUNT(x)	(((x) & 0x1f) << 27)
+
+#define UTMIP_XCVR_CFG0		0x808
+#define   UTMIP_XCVR_SETUP(x)			(((x) & 0xf) << 0)
+#define   UTMIP_XCVR_LSRSLEW(x)			(((x) & 0x3) << 8)
+#define   UTMIP_XCVR_LSFSLEW(x)			(((x) & 0x3) << 10)
+#define   UTMIP_FORCE_PD_POWERDOWN		(1 << 14)
+#define   UTMIP_FORCE_PD2_POWERDOWN		(1 << 16)
+#define   UTMIP_FORCE_PDZI_POWERDOWN		(1 << 18)
+#define   UTMIP_XCVR_HSSLEW_MSB(x)		(((x) & 0x7f) << 25)
+
+#define UTMIP_BIAS_CFG0		0x80c
+#define   UTMIP_OTGPD			(1 << 11)
+#define   UTMIP_BIASPD			(1 << 10)
+
+#define UTMIP_HSRX_CFG0		0x810
+#define   UTMIP_ELASTIC_LIMIT(x)	(((x) & 0x1f) << 10)
+#define   UTMIP_IDLE_WAIT(x)		(((x) & 0x1f) << 15)
+
+#define UTMIP_HSRX_CFG1		0x814
+#define   UTMIP_HS_SYNC_START_DLY(x)	(((x) & 0x1f) << 1)
+
+#define UTMIP_TX_CFG0		0x820
+#define   UTMIP_FS_PREABMLE_J		(1 << 19)
+#define   UTMIP_HS_DISCON_DISABLE	(1 << 8)
+
+#define UTMIP_MISC_CFG0		0x824
+#define   UTMIP_DPDM_OBSERVE		(1 << 26)
+#define   UTMIP_DPDM_OBSERVE_SEL(x)	(((x) & 0xf) << 27)
+#define   UTMIP_DPDM_OBSERVE_SEL_FS_J	UTMIP_DPDM_OBSERVE_SEL(0xf)
+#define   UTMIP_DPDM_OBSERVE_SEL_FS_K	UTMIP_DPDM_OBSERVE_SEL(0xe)
+#define   UTMIP_DPDM_OBSERVE_SEL_FS_SE1 UTMIP_DPDM_OBSERVE_SEL(0xd)
+#define   UTMIP_DPDM_OBSERVE_SEL_FS_SE0 UTMIP_DPDM_OBSERVE_SEL(0xc)
+#define   UTMIP_SUSPEND_EXIT_ON_EDGE	(1 << 22)
+
+#define UTMIP_MISC_CFG1		0x828
+#define   UTMIP_PLL_ACTIVE_DLY_COUNT(x)	(((x) & 0x1f) << 18)
+#define   UTMIP_PLLU_STABLE_COUNT(x)	(((x) & 0xfff) << 6)
+
+#define UTMIP_DEBOUNCE_CFG0	0x82c
+#define   UTMIP_BIAS_DEBOUNCE_A(x)	(((x) & 0xffff) << 0)
+
+#define UTMIP_BAT_CHRG_CFG0	0x830
+#define   UTMIP_PD_CHRG			(1 << 0)
+
+#define UTMIP_SPARE_CFG0	0x834
+#define   FUSE_SETUP_SEL		(1 << 3)
+
+#define UTMIP_XCVR_CFG1		0x838
+#define   UTMIP_FORCE_PDDISC_POWERDOWN	(1 << 0)
+#define   UTMIP_FORCE_PDCHRP_POWERDOWN	(1 << 2)
+#define   UTMIP_FORCE_PDDR_POWERDOWN	(1 << 4)
+#define   UTMIP_XCVR_TERM_RANGE_ADJ(x)	(((x) & 0xf) << 18)
+
+#define UTMIP_BIAS_CFG1		0x83c
+#define   UTMIP_BIAS_PDTRK_COUNT(x)	(((x) & 0x1f) << 3)
+
+struct tegra_xtal_freq {
+	int freq;
+	u8 enable_delay;
+	u8 stable_count;
+	u8 active_delay;
+	u8 xtal_freq_count;
+	u16 debounce;
+};
+
+static const struct tegra_xtal_freq tegra_freq_table[] = {
+	{
+		.freq = 12000000,
+		.enable_delay = 0x02,
+		.stable_count = 0x2F,
+		.active_delay = 0x04,
+		.xtal_freq_count = 0x76,
+		.debounce = 0x7530,
+	},
+	{
+		.freq = 13000000,
+		.enable_delay = 0x02,
+		.stable_count = 0x33,
+		.active_delay = 0x05,
+		.xtal_freq_count = 0x7F,
+		.debounce = 0x7EF4,
+	},
+	{
+		.freq = 19200000,
+		.enable_delay = 0x03,
+		.stable_count = 0x4B,
+		.active_delay = 0x06,
+		.xtal_freq_count = 0xBB,
+		.debounce = 0xBB80,
+	},
+	{
+		.freq = 26000000,
+		.enable_delay = 0x04,
+		.stable_count = 0x66,
+		.active_delay = 0x09,
+		.xtal_freq_count = 0xFE,
+		.debounce = 0xFDE8,
+	},
+};
+
+int tegra2_usb_phy_init(struct tegra_usb_phy *phy);
+
+#endif /* _TEGRA2_USB_PHY_H */
diff --git a/drivers/usb/phy/tegra_usb_phy.c b/drivers/usb/phy/tegra_usb_phy.c
index 9d13c81..60334d8 100644
--- a/drivers/usb/phy/tegra_usb_phy.c
+++ b/drivers/usb/phy/tegra_usb_phy.c
@@ -29,163 +29,7 @@
 #include <linux/usb/ulpi.h>
 #include <asm/mach-types.h>
 #include <linux/usb/tegra_usb_phy.h>
-
-#define TEGRA_USB_BASE		0xC5000000
-#define TEGRA_USB_SIZE		SZ_16K
-
-#define ULPI_VIEWPORT		0x170
-
-#define USB_PORTSC1		0x184
-#define   USB_PORTSC1_PTS(x)	(((x) & 0x3) << 30)
-#define   USB_PORTSC1_PSPD(x)	(((x) & 0x3) << 26)
-#define   USB_PORTSC1_PHCD	(1 << 23)
-#define   USB_PORTSC1_WKOC	(1 << 22)
-#define   USB_PORTSC1_WKDS	(1 << 21)
-#define   USB_PORTSC1_WKCN	(1 << 20)
-#define   USB_PORTSC1_PTC(x)	(((x) & 0xf) << 16)
-#define   USB_PORTSC1_PP	(1 << 12)
-#define   USB_PORTSC1_SUSP	(1 << 7)
-#define   USB_PORTSC1_PE	(1 << 2)
-#define   USB_PORTSC1_CCS	(1 << 0)
-
-#define USB_SUSP_CTRL		0x400
-#define   USB_WAKE_ON_CNNT_EN_DEV	(1 << 3)
-#define   USB_WAKE_ON_DISCON_EN_DEV	(1 << 4)
-#define   USB_SUSP_CLR		(1 << 5)
-#define   USB_PHY_CLK_VALID	(1 << 7)
-#define   UTMIP_RESET			(1 << 11)
-#define   UHSIC_RESET			(1 << 11)
-#define   UTMIP_PHY_ENABLE		(1 << 12)
-#define   ULPI_PHY_ENABLE	(1 << 13)
-#define   USB_SUSP_SET		(1 << 14)
-#define   USB_WAKEUP_DEBOUNCE_COUNT(x)	(((x) & 0x7) << 16)
-
-#define USB1_LEGACY_CTRL	0x410
-#define   USB1_NO_LEGACY_MODE			(1 << 0)
-#define   USB1_VBUS_SENSE_CTL_MASK		(3 << 1)
-#define   USB1_VBUS_SENSE_CTL_VBUS_WAKEUP	(0 << 1)
-#define   USB1_VBUS_SENSE_CTL_AB_SESS_VLD_OR_VBUS_WAKEUP \
-						(1 << 1)
-#define   USB1_VBUS_SENSE_CTL_AB_SESS_VLD	(2 << 1)
-#define   USB1_VBUS_SENSE_CTL_A_SESS_VLD	(3 << 1)
-
-#define ULPI_TIMING_CTRL_0	0x424
-#define   ULPI_OUTPUT_PINMUX_BYP	(1 << 10)
-#define   ULPI_CLKOUT_PINMUX_BYP	(1 << 11)
-
-#define ULPI_TIMING_CTRL_1	0x428
-#define   ULPI_DATA_TRIMMER_LOAD	(1 << 0)
-#define   ULPI_DATA_TRIMMER_SEL(x)	(((x) & 0x7) << 1)
-#define   ULPI_STPDIRNXT_TRIMMER_LOAD	(1 << 16)
-#define   ULPI_STPDIRNXT_TRIMMER_SEL(x)	(((x) & 0x7) << 17)
-#define   ULPI_DIR_TRIMMER_LOAD		(1 << 24)
-#define   ULPI_DIR_TRIMMER_SEL(x)	(((x) & 0x7) << 25)
-
-#define UTMIP_PLL_CFG1		0x804
-#define   UTMIP_XTAL_FREQ_COUNT(x)		(((x) & 0xfff) << 0)
-#define   UTMIP_PLLU_ENABLE_DLY_COUNT(x)	(((x) & 0x1f) << 27)
-
-#define UTMIP_XCVR_CFG0		0x808
-#define   UTMIP_XCVR_SETUP(x)			(((x) & 0xf) << 0)
-#define   UTMIP_XCVR_LSRSLEW(x)			(((x) & 0x3) << 8)
-#define   UTMIP_XCVR_LSFSLEW(x)			(((x) & 0x3) << 10)
-#define   UTMIP_FORCE_PD_POWERDOWN		(1 << 14)
-#define   UTMIP_FORCE_PD2_POWERDOWN		(1 << 16)
-#define   UTMIP_FORCE_PDZI_POWERDOWN		(1 << 18)
-#define   UTMIP_XCVR_HSSLEW_MSB(x)		(((x) & 0x7f) << 25)
-
-#define UTMIP_BIAS_CFG0		0x80c
-#define   UTMIP_OTGPD			(1 << 11)
-#define   UTMIP_BIASPD			(1 << 10)
-
-#define UTMIP_HSRX_CFG0		0x810
-#define   UTMIP_ELASTIC_LIMIT(x)	(((x) & 0x1f) << 10)
-#define   UTMIP_IDLE_WAIT(x)		(((x) & 0x1f) << 15)
-
-#define UTMIP_HSRX_CFG1		0x814
-#define   UTMIP_HS_SYNC_START_DLY(x)	(((x) & 0x1f) << 1)
-
-#define UTMIP_TX_CFG0		0x820
-#define   UTMIP_FS_PREABMLE_J		(1 << 19)
-#define   UTMIP_HS_DISCON_DISABLE	(1 << 8)
-
-#define UTMIP_MISC_CFG0		0x824
-#define   UTMIP_DPDM_OBSERVE		(1 << 26)
-#define   UTMIP_DPDM_OBSERVE_SEL(x)	(((x) & 0xf) << 27)
-#define   UTMIP_DPDM_OBSERVE_SEL_FS_J	UTMIP_DPDM_OBSERVE_SEL(0xf)
-#define   UTMIP_DPDM_OBSERVE_SEL_FS_K	UTMIP_DPDM_OBSERVE_SEL(0xe)
-#define   UTMIP_DPDM_OBSERVE_SEL_FS_SE1 UTMIP_DPDM_OBSERVE_SEL(0xd)
-#define   UTMIP_DPDM_OBSERVE_SEL_FS_SE0 UTMIP_DPDM_OBSERVE_SEL(0xc)
-#define   UTMIP_SUSPEND_EXIT_ON_EDGE	(1 << 22)
-
-#define UTMIP_MISC_CFG1		0x828
-#define   UTMIP_PLL_ACTIVE_DLY_COUNT(x)	(((x) & 0x1f) << 18)
-#define   UTMIP_PLLU_STABLE_COUNT(x)	(((x) & 0xfff) << 6)
-
-#define UTMIP_DEBOUNCE_CFG0	0x82c
-#define   UTMIP_BIAS_DEBOUNCE_A(x)	(((x) & 0xffff) << 0)
-
-#define UTMIP_BAT_CHRG_CFG0	0x830
-#define   UTMIP_PD_CHRG			(1 << 0)
-
-#define UTMIP_SPARE_CFG0	0x834
-#define   FUSE_SETUP_SEL		(1 << 3)
-
-#define UTMIP_XCVR_CFG1		0x838
-#define   UTMIP_FORCE_PDDISC_POWERDOWN	(1 << 0)
-#define   UTMIP_FORCE_PDCHRP_POWERDOWN	(1 << 2)
-#define   UTMIP_FORCE_PDDR_POWERDOWN	(1 << 4)
-#define   UTMIP_XCVR_TERM_RANGE_ADJ(x)	(((x) & 0xf) << 18)
-
-#define UTMIP_BIAS_CFG1		0x83c
-#define   UTMIP_BIAS_PDTRK_COUNT(x)	(((x) & 0x1f) << 3)
-
-static DEFINE_SPINLOCK(utmip_pad_lock);
-static int utmip_pad_count;
-
-struct tegra_xtal_freq {
-	int freq;
-	u8 enable_delay;
-	u8 stable_count;
-	u8 active_delay;
-	u8 xtal_freq_count;
-	u16 debounce;
-};
-
-static const struct tegra_xtal_freq tegra_freq_table[] = {
-	{
-		.freq = 12000000,
-		.enable_delay = 0x02,
-		.stable_count = 0x2F,
-		.active_delay = 0x04,
-		.xtal_freq_count = 0x76,
-		.debounce = 0x7530,
-	},
-	{
-		.freq = 13000000,
-		.enable_delay = 0x02,
-		.stable_count = 0x33,
-		.active_delay = 0x05,
-		.xtal_freq_count = 0x7F,
-		.debounce = 0x7EF4,
-	},
-	{
-		.freq = 19200000,
-		.enable_delay = 0x03,
-		.stable_count = 0x4B,
-		.active_delay = 0x06,
-		.xtal_freq_count = 0xBB,
-		.debounce = 0xBB80,
-	},
-	{
-		.freq = 26000000,
-		.enable_delay = 0x04,
-		.stable_count = 0x66,
-		.active_delay = 0x09,
-		.xtal_freq_count = 0xFE,
-		.debounce = 0xFDE8,
-	},
-};
+#include "tegra2_usb_phy.h"
 
 static struct tegra_utmip_config utmip_default[] = {
 	[0] = {
@@ -208,550 +52,54 @@ static struct tegra_utmip_config utmip_default[] = {
 	},
 };
 
-static inline bool phy_is_ulpi(struct tegra_usb_phy *phy)
-{
-	return (phy->instance == 1);
-}
-
-static int utmip_pad_open(struct tegra_usb_phy *phy)
-{
-	phy->pad_clk = clk_get_sys("utmip-pad", NULL);
-	if (IS_ERR(phy->pad_clk)) {
-		pr_err("%s: can't get utmip pad clock\n", __func__);
-		return PTR_ERR(phy->pad_clk);
-	}
-
-	if (phy->instance == 0) {
-		phy->pad_regs = phy->regs;
-	} else {
-		phy->pad_regs = ioremap(TEGRA_USB_BASE, TEGRA_USB_SIZE);
-		if (!phy->pad_regs) {
-			pr_err("%s: can't remap usb registers\n", __func__);
-			clk_put(phy->pad_clk);
-			return -ENOMEM;
-		}
-	}
-	return 0;
-}
-
-static void utmip_pad_close(struct tegra_usb_phy *phy)
-{
-	if (phy->instance != 0)
-		iounmap(phy->pad_regs);
-	clk_put(phy->pad_clk);
-}
-
-static void utmip_pad_power_on(struct tegra_usb_phy *phy)
-{
-	unsigned long val, flags;
-	void __iomem *base = phy->pad_regs;
-
-	clk_prepare_enable(phy->pad_clk);
-
-	spin_lock_irqsave(&utmip_pad_lock, flags);
-
-	if (utmip_pad_count++ == 0) {
-		val = readl(base + UTMIP_BIAS_CFG0);
-		val &= ~(UTMIP_OTGPD | UTMIP_BIASPD);
-		writel(val, base + UTMIP_BIAS_CFG0);
-	}
-
-	spin_unlock_irqrestore(&utmip_pad_lock, flags);
-
-	clk_disable_unprepare(phy->pad_clk);
-}
-
-static int utmip_pad_power_off(struct tegra_usb_phy *phy)
-{
-	unsigned long val, flags;
-	void __iomem *base = phy->pad_regs;
-
-	if (!utmip_pad_count) {
-		pr_err("%s: utmip pad already powered off\n", __func__);
-		return -EINVAL;
-	}
-
-	clk_prepare_enable(phy->pad_clk);
-
-	spin_lock_irqsave(&utmip_pad_lock, flags);
-
-	if (--utmip_pad_count == 0) {
-		val = readl(base + UTMIP_BIAS_CFG0);
-		val |= UTMIP_OTGPD | UTMIP_BIASPD;
-		writel(val, base + UTMIP_BIAS_CFG0);
-	}
-
-	spin_unlock_irqrestore(&utmip_pad_lock, flags);
-
-	clk_disable_unprepare(phy->pad_clk);
-
-	return 0;
-}
-
-static int utmi_wait_register(void __iomem *reg, u32 mask, u32 result)
-{
-	unsigned long timeout = 2000;
-	do {
-		if ((readl(reg) & mask) == result)
-			return 0;
-		udelay(1);
-		timeout--;
-	} while (timeout);
-	return -1;
-}
-
-static void utmi_phy_clk_disable(struct tegra_usb_phy *phy)
-{
-	unsigned long val;
-	void __iomem *base = phy->regs;
-
-	if (phy->instance == 0) {
-		val = readl(base + USB_SUSP_CTRL);
-		val |= USB_SUSP_SET;
-		writel(val, base + USB_SUSP_CTRL);
-
-		udelay(10);
-
-		val = readl(base + USB_SUSP_CTRL);
-		val &= ~USB_SUSP_SET;
-		writel(val, base + USB_SUSP_CTRL);
-	}
-
-	if (phy->instance == 2) {
-		val = readl(base + USB_PORTSC1);
-		val |= USB_PORTSC1_PHCD;
-		writel(val, base + USB_PORTSC1);
-	}
-
-	if (utmi_wait_register(base + USB_SUSP_CTRL, USB_PHY_CLK_VALID, 0) < 0)
-		pr_err("%s: timeout waiting for phy to stabilize\n", __func__);
-}
-
-static void utmi_phy_clk_enable(struct tegra_usb_phy *phy)
-{
-	unsigned long val;
-	void __iomem *base = phy->regs;
-
-	if (phy->instance == 0) {
-		val = readl(base + USB_SUSP_CTRL);
-		val |= USB_SUSP_CLR;
-		writel(val, base + USB_SUSP_CTRL);
-
-		udelay(10);
-
-		val = readl(base + USB_SUSP_CTRL);
-		val &= ~USB_SUSP_CLR;
-		writel(val, base + USB_SUSP_CTRL);
-	}
-
-	if (phy->instance == 2) {
-		val = readl(base + USB_PORTSC1);
-		val &= ~USB_PORTSC1_PHCD;
-		writel(val, base + USB_PORTSC1);
-	}
-
-	if (utmi_wait_register(base + USB_SUSP_CTRL, USB_PHY_CLK_VALID,
-						     USB_PHY_CLK_VALID))
-		pr_err("%s: timeout waiting for phy to stabilize\n", __func__);
-}
-
-static int utmi_phy_power_on(struct tegra_usb_phy *phy)
-{
-	unsigned long val;
-	void __iomem *base = phy->regs;
-	struct tegra_utmip_config *config = phy->config;
-
-	val = readl(base + USB_SUSP_CTRL);
-	val |= UTMIP_RESET;
-	writel(val, base + USB_SUSP_CTRL);
-
-	if (phy->instance == 0) {
-		val = readl(base + USB1_LEGACY_CTRL);
-		val |= USB1_NO_LEGACY_MODE;
-		writel(val, base + USB1_LEGACY_CTRL);
-	}
-
-	val = readl(base + UTMIP_TX_CFG0);
-	val &= ~UTMIP_FS_PREABMLE_J;
-	writel(val, base + UTMIP_TX_CFG0);
-
-	val = readl(base + UTMIP_HSRX_CFG0);
-	val &= ~(UTMIP_IDLE_WAIT(~0) | UTMIP_ELASTIC_LIMIT(~0));
-	val |= UTMIP_IDLE_WAIT(config->idle_wait_delay);
-	val |= UTMIP_ELASTIC_LIMIT(config->elastic_limit);
-	writel(val, base + UTMIP_HSRX_CFG0);
-
-	val = readl(base + UTMIP_HSRX_CFG1);
-	val &= ~UTMIP_HS_SYNC_START_DLY(~0);
-	val |= UTMIP_HS_SYNC_START_DLY(config->hssync_start_delay);
-	writel(val, base + UTMIP_HSRX_CFG1);
-
-	val = readl(base + UTMIP_DEBOUNCE_CFG0);
-	val &= ~UTMIP_BIAS_DEBOUNCE_A(~0);
-	val |= UTMIP_BIAS_DEBOUNCE_A(phy->freq->debounce);
-	writel(val, base + UTMIP_DEBOUNCE_CFG0);
-
-	val = readl(base + UTMIP_MISC_CFG0);
-	val &= ~UTMIP_SUSPEND_EXIT_ON_EDGE;
-	writel(val, base + UTMIP_MISC_CFG0);
-
-	val = readl(base + UTMIP_MISC_CFG1);
-	val &= ~(UTMIP_PLL_ACTIVE_DLY_COUNT(~0) | UTMIP_PLLU_STABLE_COUNT(~0));
-	val |= UTMIP_PLL_ACTIVE_DLY_COUNT(phy->freq->active_delay) |
-		UTMIP_PLLU_STABLE_COUNT(phy->freq->stable_count);
-	writel(val, base + UTMIP_MISC_CFG1);
-
-	val = readl(base + UTMIP_PLL_CFG1);
-	val &= ~(UTMIP_XTAL_FREQ_COUNT(~0) | UTMIP_PLLU_ENABLE_DLY_COUNT(~0));
-	val |= UTMIP_XTAL_FREQ_COUNT(phy->freq->xtal_freq_count) |
-		UTMIP_PLLU_ENABLE_DLY_COUNT(phy->freq->enable_delay);
-	writel(val, base + UTMIP_PLL_CFG1);
-
-	if (phy->mode == TEGRA_USB_PHY_MODE_DEVICE) {
-		val = readl(base + USB_SUSP_CTRL);
-		val &= ~(USB_WAKE_ON_CNNT_EN_DEV | USB_WAKE_ON_DISCON_EN_DEV);
-		writel(val, base + USB_SUSP_CTRL);
-	}
-
-	utmip_pad_power_on(phy);
-
-	val = readl(base + UTMIP_XCVR_CFG0);
-	val &= ~(UTMIP_FORCE_PD_POWERDOWN | UTMIP_FORCE_PD2_POWERDOWN |
-		 UTMIP_FORCE_PDZI_POWERDOWN | UTMIP_XCVR_SETUP(~0) |
-		 UTMIP_XCVR_LSFSLEW(~0) | UTMIP_XCVR_LSRSLEW(~0) |
-		 UTMIP_XCVR_HSSLEW_MSB(~0));
-	val |= UTMIP_XCVR_SETUP(config->xcvr_setup);
-	val |= UTMIP_XCVR_LSFSLEW(config->xcvr_lsfslew);
-	val |= UTMIP_XCVR_LSRSLEW(config->xcvr_lsrslew);
-	writel(val, base + UTMIP_XCVR_CFG0);
-
-	val = readl(base + UTMIP_XCVR_CFG1);
-	val &= ~(UTMIP_FORCE_PDDISC_POWERDOWN | UTMIP_FORCE_PDCHRP_POWERDOWN |
-		 UTMIP_FORCE_PDDR_POWERDOWN | UTMIP_XCVR_TERM_RANGE_ADJ(~0));
-	val |= UTMIP_XCVR_TERM_RANGE_ADJ(config->term_range_adj);
-	writel(val, base + UTMIP_XCVR_CFG1);
-
-	val = readl(base + UTMIP_BAT_CHRG_CFG0);
-	val &= ~UTMIP_PD_CHRG;
-	writel(val, base + UTMIP_BAT_CHRG_CFG0);
-
-	val = readl(base + UTMIP_BIAS_CFG1);
-	val &= ~UTMIP_BIAS_PDTRK_COUNT(~0);
-	val |= UTMIP_BIAS_PDTRK_COUNT(0x5);
-	writel(val, base + UTMIP_BIAS_CFG1);
-
-	if (phy->instance == 0) {
-		val = readl(base + UTMIP_SPARE_CFG0);
-		if (phy->mode == TEGRA_USB_PHY_MODE_DEVICE)
-			val &= ~FUSE_SETUP_SEL;
-		else
-			val |= FUSE_SETUP_SEL;
-		writel(val, base + UTMIP_SPARE_CFG0);
-	}
-
-	if (phy->instance == 2) {
-		val = readl(base + USB_SUSP_CTRL);
-		val |= UTMIP_PHY_ENABLE;
-		writel(val, base + USB_SUSP_CTRL);
-	}
-
-	val = readl(base + USB_SUSP_CTRL);
-	val &= ~UTMIP_RESET;
-	writel(val, base + USB_SUSP_CTRL);
-
-	if (phy->instance == 0) {
-		val = readl(base + USB1_LEGACY_CTRL);
-		val &= ~USB1_VBUS_SENSE_CTL_MASK;
-		val |= USB1_VBUS_SENSE_CTL_A_SESS_VLD;
-		writel(val, base + USB1_LEGACY_CTRL);
-
-		val = readl(base + USB_SUSP_CTRL);
-		val &= ~USB_SUSP_SET;
-		writel(val, base + USB_SUSP_CTRL);
-	}
-
-	utmi_phy_clk_enable(phy);
-
-	if (phy->instance == 2) {
-		val = readl(base + USB_PORTSC1);
-		val &= ~USB_PORTSC1_PTS(~0);
-		writel(val, base + USB_PORTSC1);
-	}
-
-	return 0;
-}
-
-static int utmi_phy_power_off(struct tegra_usb_phy *phy)
-{
-	unsigned long val;
-	void __iomem *base = phy->regs;
-
-	utmi_phy_clk_disable(phy);
-
-	if (phy->mode == TEGRA_USB_PHY_MODE_DEVICE) {
-		val = readl(base + USB_SUSP_CTRL);
-		val &= ~USB_WAKEUP_DEBOUNCE_COUNT(~0);
-		val |= USB_WAKE_ON_CNNT_EN_DEV | USB_WAKEUP_DEBOUNCE_COUNT(5);
-		writel(val, base + USB_SUSP_CTRL);
-	}
-
-	val = readl(base + USB_SUSP_CTRL);
-	val |= UTMIP_RESET;
-	writel(val, base + USB_SUSP_CTRL);
-
-	val = readl(base + UTMIP_BAT_CHRG_CFG0);
-	val |= UTMIP_PD_CHRG;
-	writel(val, base + UTMIP_BAT_CHRG_CFG0);
-
-	val = readl(base + UTMIP_XCVR_CFG0);
-	val |= UTMIP_FORCE_PD_POWERDOWN | UTMIP_FORCE_PD2_POWERDOWN |
-	       UTMIP_FORCE_PDZI_POWERDOWN;
-	writel(val, base + UTMIP_XCVR_CFG0);
-
-	val = readl(base + UTMIP_XCVR_CFG1);
-	val |= UTMIP_FORCE_PDDISC_POWERDOWN | UTMIP_FORCE_PDCHRP_POWERDOWN |
-	       UTMIP_FORCE_PDDR_POWERDOWN;
-	writel(val, base + UTMIP_XCVR_CFG1);
-
-	return utmip_pad_power_off(phy);
-}
-
-static void utmi_phy_preresume(struct tegra_usb_phy *phy)
-{
-	unsigned long val;
-	void __iomem *base = phy->regs;
-
-	val = readl(base + UTMIP_TX_CFG0);
-	val |= UTMIP_HS_DISCON_DISABLE;
-	writel(val, base + UTMIP_TX_CFG0);
-}
-
-static void utmi_phy_postresume(struct tegra_usb_phy *phy)
-{
-	unsigned long val;
-	void __iomem *base = phy->regs;
-
-	val = readl(base + UTMIP_TX_CFG0);
-	val &= ~UTMIP_HS_DISCON_DISABLE;
-	writel(val, base + UTMIP_TX_CFG0);
-}
-
-static void utmi_phy_restore_start(struct tegra_usb_phy *phy,
-				   enum tegra_usb_phy_port_speed port_speed)
-{
-	unsigned long val;
-	void __iomem *base = phy->regs;
-
-	val = readl(base + UTMIP_MISC_CFG0);
-	val &= ~UTMIP_DPDM_OBSERVE_SEL(~0);
-	if (port_speed == TEGRA_USB_PHY_PORT_SPEED_LOW)
-		val |= UTMIP_DPDM_OBSERVE_SEL_FS_K;
-	else
-		val |= UTMIP_DPDM_OBSERVE_SEL_FS_J;
-	writel(val, base + UTMIP_MISC_CFG0);
-	udelay(1);
-
-	val = readl(base + UTMIP_MISC_CFG0);
-	val |= UTMIP_DPDM_OBSERVE;
-	writel(val, base + UTMIP_MISC_CFG0);
-	udelay(10);
-}
-
-static void utmi_phy_restore_end(struct tegra_usb_phy *phy)
-{
-	unsigned long val;
-	void __iomem *base = phy->regs;
-
-	val = readl(base + UTMIP_MISC_CFG0);
-	val &= ~UTMIP_DPDM_OBSERVE;
-	writel(val, base + UTMIP_MISC_CFG0);
-	udelay(10);
-}
-
-static int ulpi_phy_power_on(struct tegra_usb_phy *phy)
-{
-	int ret;
-	unsigned long val;
-	void __iomem *base = phy->regs;
-	struct tegra_ulpi_config *config = phy->config;
-
-	gpio_direction_output(config->reset_gpio, 0);
-	msleep(5);
-	gpio_direction_output(config->reset_gpio, 1);
-
-	clk_prepare_enable(phy->clk);
-	msleep(1);
-
-	val = readl(base + USB_SUSP_CTRL);
-	val |= UHSIC_RESET;
-	writel(val, base + USB_SUSP_CTRL);
-
-	val = readl(base + ULPI_TIMING_CTRL_0);
-	val |= ULPI_OUTPUT_PINMUX_BYP | ULPI_CLKOUT_PINMUX_BYP;
-	writel(val, base + ULPI_TIMING_CTRL_0);
-
-	val = readl(base + USB_SUSP_CTRL);
-	val |= ULPI_PHY_ENABLE;
-	writel(val, base + USB_SUSP_CTRL);
-
-	val = 0;
-	writel(val, base + ULPI_TIMING_CTRL_1);
-
-	val |= ULPI_DATA_TRIMMER_SEL(4);
-	val |= ULPI_STPDIRNXT_TRIMMER_SEL(4);
-	val |= ULPI_DIR_TRIMMER_SEL(4);
-	writel(val, base + ULPI_TIMING_CTRL_1);
-	udelay(10);
-
-	val |= ULPI_DATA_TRIMMER_LOAD;
-	val |= ULPI_STPDIRNXT_TRIMMER_LOAD;
-	val |= ULPI_DIR_TRIMMER_LOAD;
-	writel(val, base + ULPI_TIMING_CTRL_1);
-
-	/* Fix VbusInvalid due to floating VBUS */
-	ret = usb_phy_io_write(phy->ulpi, 0x40, 0x08);
-	if (ret) {
-		pr_err("%s: ulpi write failed\n", __func__);
-		return ret;
-	}
-
-	ret = usb_phy_io_write(phy->ulpi, 0x80, 0x0B);
-	if (ret) {
-		pr_err("%s: ulpi write failed\n", __func__);
-		return ret;
-	}
-
-	val = readl(base + USB_PORTSC1);
-	val |= USB_PORTSC1_WKOC | USB_PORTSC1_WKDS | USB_PORTSC1_WKCN;
-	writel(val, base + USB_PORTSC1);
-
-	val = readl(base + USB_SUSP_CTRL);
-	val |= USB_SUSP_CLR;
-	writel(val, base + USB_SUSP_CTRL);
-	udelay(100);
-
-	val = readl(base + USB_SUSP_CTRL);
-	val &= ~USB_SUSP_CLR;
-	writel(val, base + USB_SUSP_CTRL);
-
-	return 0;
-}
-
-static int ulpi_phy_power_off(struct tegra_usb_phy *phy)
-{
-	unsigned long val;
-	void __iomem *base = phy->regs;
-	struct tegra_ulpi_config *config = phy->config;
-
-	/* Clear WKCN/WKDS/WKOC wake-on events that can cause the USB
-	 * Controller to immediately bring the ULPI PHY out of low power
-	 */
-	val = readl(base + USB_PORTSC1);
-	val &= ~(USB_PORTSC1_WKOC | USB_PORTSC1_WKDS | USB_PORTSC1_WKCN);
-	writel(val, base + USB_PORTSC1);
-
-	clk_disable(phy->clk);
-	return gpio_direction_output(config->reset_gpio, 0);
-}
-
-static int	tegra_phy_init(struct usb_phy *x)
+static int tegra_phy_init(struct usb_phy *x)
 {
 	struct tegra_usb_phy *phy = container_of(x, struct tegra_usb_phy, u_phy);
-	struct tegra_ulpi_config *ulpi_config;
-	int err;
 
-	if (phy_is_ulpi(phy)) {
-		ulpi_config = phy->config;
-		phy->clk = clk_get_sys(NULL, ulpi_config->clk);
-		if (IS_ERR(phy->clk)) {
-			pr_err("%s: can't get ulpi clock\n", __func__);
-			err = -ENXIO;
-			goto err1;
-		}
-		if (!gpio_is_valid(ulpi_config->reset_gpio))
-			ulpi_config->reset_gpio =
-				of_get_named_gpio(phy->dev->of_node,
-						  "nvidia,phy-reset-gpio", 0);
-		if (!gpio_is_valid(ulpi_config->reset_gpio)) {
-			pr_err("%s: invalid reset gpio: %d\n", __func__,
-			       ulpi_config->reset_gpio);
-			err = -EINVAL;
-			goto err1;
-		}
-		gpio_request(ulpi_config->reset_gpio, "ulpi_phy_reset_b");
-		gpio_direction_output(ulpi_config->reset_gpio, 0);
-		phy->ulpi = otg_ulpi_create(&ulpi_viewport_access_ops, 0);
-		phy->ulpi->io_priv = phy->regs + ULPI_VIEWPORT;
-	} else {
-		err = utmip_pad_open(phy);
-		if (err < 0)
-			goto err1;
-	}
-	return 0;
-err1:
-	clk_disable_unprepare(phy->pll_u);
-	clk_put(phy->pll_u);
-	return err;
+	return phy->ops.open(phy);
 }
 
 static void tegra_usb_phy_close(struct usb_phy *x)
 {
 	struct tegra_usb_phy *phy = container_of(x, struct tegra_usb_phy, u_phy);
 
-	if (phy_is_ulpi(phy))
-		clk_put(phy->clk);
-	else
-		utmip_pad_close(phy);
-	clk_disable_unprepare(phy->pll_u);
-	clk_put(phy->pll_u);
-	kfree(phy);
-}
-
-static int tegra_usb_phy_power_on(struct tegra_usb_phy *phy)
-{
-	if (phy_is_ulpi(phy))
-		return ulpi_phy_power_on(phy);
-	else
-		return utmi_phy_power_on(phy);
-}
-
-static int tegra_usb_phy_power_off(struct tegra_usb_phy *phy)
-{
-	if (phy_is_ulpi(phy))
-		return ulpi_phy_power_off(phy);
-	else
-		return utmi_phy_power_off(phy);
+	phy->ops.close(phy);
 }
 
 static int	tegra_usb_phy_suspend(struct usb_phy *x, int suspend)
 {
 	struct tegra_usb_phy *phy = container_of(x, struct tegra_usb_phy, u_phy);
-	if (suspend)
-		return tegra_usb_phy_power_off(phy);
-	else
-		return tegra_usb_phy_power_on(phy);
+
+	if (suspend) {
+		if (phy->ops.power_off)
+			return phy->ops.power_off(phy);
+	} else if (phy->ops.power_on)
+		return phy->ops.power_on(phy);
+
+	return 0;
 }
 
 struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
-	void __iomem *regs, void *config, enum tegra_usb_phy_mode phy_mode)
+	void __iomem *regs, struct phy_params *params)
 {
 	struct tegra_usb_phy *phy;
 	unsigned long parent_rate;
 	int i;
 	int err;
 
-	phy = kmalloc(sizeof(struct tegra_usb_phy), GFP_KERNEL);
+	phy = devm_kzalloc(dev, sizeof(struct tegra_usb_phy), GFP_KERNEL);
 	if (!phy)
 		return ERR_PTR(-ENOMEM);
 
 	phy->instance = instance;
 	phy->regs = regs;
-	phy->config = config;
-	phy->mode = phy_mode;
+	phy->config = params->config;
+	phy->mode = params->mode;
 	phy->dev = dev;
+	phy->type = params->type;
 
 	if (!phy->config) {
-		if (phy_is_ulpi(phy)) {
+		if (params->type == TEGRA_USB_PHY_TYPE_ULPI) {
 			pr_err("%s: ulpi phy configuration missing", __func__);
 			err = -EINVAL;
 			goto err0;
@@ -781,6 +129,12 @@ struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
 		goto err1;
 	}
 
+	err = tegra2_usb_phy_init(phy);
+	if (err < 0) {
+		pr_err("phy type %d is not supported\n", phy->type);
+		goto err1;
+	}
+
 	phy->u_phy.init = tegra_phy_init;
 	phy->u_phy.shutdown = tegra_usb_phy_close;
 	phy->u_phy.set_suspend = tegra_usb_phy_suspend;
@@ -791,50 +145,35 @@ err1:
 	clk_disable_unprepare(phy->pll_u);
 	clk_put(phy->pll_u);
 err0:
-	kfree(phy);
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(tegra_usb_phy_open);
 
 void tegra_usb_phy_preresume(struct tegra_usb_phy *phy)
 {
-	if (!phy_is_ulpi(phy))
-		utmi_phy_preresume(phy);
+	if (phy->ops.preresume)
+		phy->ops.preresume(phy);
 }
 EXPORT_SYMBOL_GPL(tegra_usb_phy_preresume);
 
 void tegra_usb_phy_postresume(struct tegra_usb_phy *phy)
 {
-	if (!phy_is_ulpi(phy))
-		utmi_phy_postresume(phy);
+	if (phy->ops.postresume)
+		phy->ops.postresume(phy);
 }
 EXPORT_SYMBOL_GPL(tegra_usb_phy_postresume);
 
 void tegra_ehci_phy_restore_start(struct tegra_usb_phy *phy,
 				 enum tegra_usb_phy_port_speed port_speed)
 {
-	if (!phy_is_ulpi(phy))
-		utmi_phy_restore_start(phy, port_speed);
+	if (phy->ops.restore_start)
+		phy->ops.restore_start(phy, port_speed);
 }
 EXPORT_SYMBOL_GPL(tegra_ehci_phy_restore_start);
 
 void tegra_ehci_phy_restore_end(struct tegra_usb_phy *phy)
 {
-	if (!phy_is_ulpi(phy))
-		utmi_phy_restore_end(phy);
+	if (phy->ops.restore_end)
+		phy->ops.restore_end(phy);
 }
 EXPORT_SYMBOL_GPL(tegra_ehci_phy_restore_end);
-
-void tegra_usb_phy_clk_disable(struct tegra_usb_phy *phy)
-{
-	if (!phy_is_ulpi(phy))
-		utmi_phy_clk_disable(phy);
-}
-EXPORT_SYMBOL_GPL(tegra_usb_phy_clk_disable);
-
-void tegra_usb_phy_clk_enable(struct tegra_usb_phy *phy)
-{
-	if (!phy_is_ulpi(phy))
-		utmi_phy_clk_enable(phy);
-}
-EXPORT_SYMBOL_GPL(tegra_usb_phy_clk_enable);
diff --git a/include/linux/usb/tegra_usb_phy.h b/include/linux/usb/tegra_usb_phy.h
index 176b1ca..c27705b 100644
--- a/include/linux/usb/tegra_usb_phy.h
+++ b/include/linux/usb/tegra_usb_phy.h
@@ -44,8 +44,34 @@ enum tegra_usb_phy_mode {
 	TEGRA_USB_PHY_MODE_HOST,
 };
 
+enum tegra_usb_phy_type {
+	TEGRA_USB_PHY_TYPE_UTMI = 0,
+	TEGRA_USB_PHY_TYPE_ULPI,
+	TEGRA_USB_PHY_TYPE_INVALID,
+};
+
+struct tegra_usb_phy;
+
+struct usb_phy_ops {
+	int (*open)(struct tegra_usb_phy *phy);
+	void (*close)(struct tegra_usb_phy *phy);
+	int (*power_on)(struct tegra_usb_phy *phy);
+	int (*power_off)(struct tegra_usb_phy *phy);
+	void (*preresume)(struct tegra_usb_phy *phy);
+	void (*postresume)(struct tegra_usb_phy *phy);
+	void (*restore_start)(struct tegra_usb_phy *phy,
+				   enum tegra_usb_phy_port_speed port_speed);
+	void (*restore_end)(struct tegra_usb_phy *phy);
+};
+
 struct tegra_xtal_freq;
 
+struct phy_params {
+	void *config;
+	enum tegra_usb_phy_mode mode;
+	enum tegra_usb_phy_type type;
+};
+
 struct tegra_usb_phy {
 	int instance;
 	const struct tegra_xtal_freq *freq;
@@ -58,15 +84,13 @@ struct tegra_usb_phy {
 	void *config;
 	struct usb_phy *ulpi;
 	struct usb_phy u_phy;
+	struct usb_phy_ops ops;
+	enum tegra_usb_phy_type type;
 	struct device *dev;
 };
 
 struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
-	void __iomem *regs, void *config, enum tegra_usb_phy_mode phy_mode);
-
-void tegra_usb_phy_clk_disable(struct tegra_usb_phy *phy);
-
-void tegra_usb_phy_clk_enable(struct tegra_usb_phy *phy);
+	void __iomem *regs, struct phy_params *params);
 
 void tegra_usb_phy_preresume(struct tegra_usb_phy *phy);
 
-- 
1.7.0.4


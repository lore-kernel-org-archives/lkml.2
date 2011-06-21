Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab1FUOo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 10:44:26 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51962 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab1FUOjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 10:39:45 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH v6 02/18] OMAP4: Move common twl6030 configuration to twl-common
Date: Tue, 21 Jun 2011 16:39:00 +0300
Message-ID: <1308663556-29120-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce the amount of duplicated code by moving the common
configuration for TWL6030 (on OMAP4 platform) to the
twl-common file.
Use the omap4_pmic_get_config function from board files to
properly configure the PMIC with the common fields.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/mach-omap2/board-4430sdp.c    |  143 ++--------------------------
 arch/arm/mach-omap2/board-omap4panda.c |  149 +++---------------------------
 arch/arm/mach-omap2/twl-common.c       |  163 ++++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/twl-common.h       |   20 ++++
 4 files changed, 205 insertions(+), 270 deletions(-)

diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index 63de2d3..968029a 100644
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -306,14 +306,6 @@ static struct omap_musb_board_data musb_board_data = {
 	.power			= 100,
 };
 
-static struct twl4030_usb_data omap4_usbphy_data = {
-	.phy_init	= omap4430_phy_init,
-	.phy_exit	= omap4430_phy_exit,
-	.phy_power	= omap4430_phy_power,
-	.phy_set_clock	= omap4430_phy_set_clk,
-	.phy_suspend	= omap4430_phy_suspend,
-};
-
 static struct omap2_hsmmc_info mmc[] = {
 	{
 		.mmc		= 2,
@@ -338,12 +330,6 @@ static struct regulator_consumer_supply sdp4430_vaux_supply[] = {
 		.dev_name = "omap_hsmmc.1",
 	},
 };
-static struct regulator_consumer_supply sdp4430_vmmc_supply[] = {
-	{
-		.supply = "vmmc",
-		.dev_name = "omap_hsmmc.0",
-	},
-};
 
 static int omap4_twl6030_hsmmc_late_init(struct device *dev)
 {
@@ -403,61 +389,6 @@ static struct regulator_init_data sdp4430_vaux1 = {
 	.consumer_supplies      = sdp4430_vaux_supply,
 };
 
-static struct regulator_init_data sdp4430_vaux2 = {
-	.constraints = {
-		.min_uV			= 1200000,
-		.max_uV			= 2800000,
-		.apply_uV		= true,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask	 = REGULATOR_CHANGE_VOLTAGE
-					| REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-};
-
-static struct regulator_init_data sdp4430_vaux3 = {
-	.constraints = {
-		.min_uV			= 1000000,
-		.max_uV			= 3000000,
-		.apply_uV		= true,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask	 = REGULATOR_CHANGE_VOLTAGE
-					| REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-};
-
-/* VMMC1 for MMC1 card */
-static struct regulator_init_data sdp4430_vmmc = {
-	.constraints = {
-		.min_uV			= 1200000,
-		.max_uV			= 3000000,
-		.apply_uV		= true,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask	 = REGULATOR_CHANGE_VOLTAGE
-					| REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies  = 1,
-	.consumer_supplies      = sdp4430_vmmc_supply,
-};
-
-static struct regulator_init_data sdp4430_vpp = {
-	.constraints = {
-		.min_uV			= 1800000,
-		.max_uV			= 2500000,
-		.apply_uV		= true,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask	 = REGULATOR_CHANGE_VOLTAGE
-					| REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-};
-
 static struct regulator_init_data sdp4430_vusim = {
 	.constraints = {
 		.min_uV			= 1200000,
@@ -471,74 +402,10 @@ static struct regulator_init_data sdp4430_vusim = {
 	},
 };
 
-static struct regulator_init_data sdp4430_vana = {
-	.constraints = {
-		.min_uV			= 2100000,
-		.max_uV			= 2100000,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask	 = REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-};
-
-static struct regulator_init_data sdp4430_vcxio = {
-	.constraints = {
-		.min_uV			= 1800000,
-		.max_uV			= 1800000,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask	 = REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-};
-
-static struct regulator_init_data sdp4430_vdac = {
-	.constraints = {
-		.min_uV			= 1800000,
-		.max_uV			= 1800000,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask	 = REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-};
-
-static struct regulator_init_data sdp4430_vusb = {
-	.constraints = {
-		.min_uV			= 3300000,
-		.max_uV			= 3300000,
-		.apply_uV		= true,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask	 =	REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-};
-
-static struct regulator_init_data sdp4430_clk32kg = {
-	.constraints = {
-		.valid_ops_mask		= REGULATOR_CHANGE_STATUS,
-	},
-};
-
 static struct twl4030_platform_data sdp4430_twldata = {
-	.irq_base	= TWL6030_IRQ_BASE,
-	.irq_end	= TWL6030_IRQ_END,
-
 	/* Regulators */
-	.vmmc		= &sdp4430_vmmc,
-	.vpp		= &sdp4430_vpp,
 	.vusim		= &sdp4430_vusim,
-	.vana		= &sdp4430_vana,
-	.vcxio		= &sdp4430_vcxio,
-	.vdac		= &sdp4430_vdac,
-	.vusb		= &sdp4430_vusb,
 	.vaux1		= &sdp4430_vaux1,
-	.vaux2		= &sdp4430_vaux2,
-	.vaux3		= &sdp4430_vaux3,
-	.clk32kg	= &sdp4430_clk32kg,
-	.usb		= &omap4_usbphy_data
 };
 
 static struct i2c_board_info __initdata sdp4430_i2c_3_boardinfo[] = {
@@ -556,6 +423,16 @@ static struct i2c_board_info __initdata sdp4430_i2c_4_boardinfo[] = {
 };
 static int __init omap4_i2c_init(void)
 {
+	omap4_pmic_get_config(&sdp4430_twldata, TWL_COMMON_PDATA_USB,
+			TWL_COMMON_REGULATOR_VDAC |
+			TWL_COMMON_REGULATOR_VAUX2 |
+			TWL_COMMON_REGULATOR_VAUX3 |
+			TWL_COMMON_REGULATOR_VMMC |
+			TWL_COMMON_REGULATOR_VPP |
+			TWL_COMMON_REGULATOR_VANA |
+			TWL_COMMON_REGULATOR_VCXIO |
+			TWL_COMMON_REGULATOR_VUSB |
+			TWL_COMMON_REGULATOR_CLK32KG);
 	omap4_pmic_init("twl6030", &sdp4430_twldata);
 	omap_register_i2c_bus(2, 400, NULL, 0);
 	omap_register_i2c_bus(3, 400, sdp4430_i2c_3_boardinfo,
diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
index 0cfe200..f988a1d 100644
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -155,14 +155,6 @@ static struct omap_musb_board_data musb_board_data = {
 	.power			= 100,
 };
 
-static struct twl4030_usb_data omap4_usbphy_data = {
-	.phy_init	= omap4430_phy_init,
-	.phy_exit	= omap4430_phy_exit,
-	.phy_power	= omap4430_phy_power,
-	.phy_set_clock	= omap4430_phy_set_clk,
-	.phy_suspend	= omap4430_phy_suspend,
-};
-
 static struct omap2_hsmmc_info mmc[] = {
 	{
 		.mmc		= 1,
@@ -182,13 +174,6 @@ static struct omap2_hsmmc_info mmc[] = {
 	{}	/* Terminator */
 };
 
-static struct regulator_consumer_supply omap4_panda_vmmc_supply[] = {
-	{
-		.supply = "vmmc",
-		.dev_name = "omap_hsmmc.0",
-	},
-};
-
 static struct regulator_consumer_supply omap4_panda_vmmc5_supply = {
 	.supply = "vmmc",
 	.dev_name = "omap_hsmmc.4",
@@ -274,128 +259,8 @@ static int __init omap4_twl6030_hsmmc_init(struct omap2_hsmmc_info *controllers)
 	return 0;
 }
 
-static struct regulator_init_data omap4_panda_vaux2 = {
-	.constraints = {
-		.min_uV			= 1200000,
-		.max_uV			= 2800000,
-		.apply_uV		= true,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask	 = REGULATOR_CHANGE_VOLTAGE
-					| REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-};
-
-static struct regulator_init_data omap4_panda_vaux3 = {
-	.constraints = {
-		.min_uV			= 1000000,
-		.max_uV			= 3000000,
-		.apply_uV		= true,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask	 = REGULATOR_CHANGE_VOLTAGE
-					| REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-};
-
-/* VMMC1 for MMC1 card */
-static struct regulator_init_data omap4_panda_vmmc = {
-	.constraints = {
-		.min_uV			= 1200000,
-		.max_uV			= 3000000,
-		.apply_uV		= true,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask	 = REGULATOR_CHANGE_VOLTAGE
-					| REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-	.num_consumer_supplies  = 1,
-	.consumer_supplies      = omap4_panda_vmmc_supply,
-};
-
-static struct regulator_init_data omap4_panda_vpp = {
-	.constraints = {
-		.min_uV			= 1800000,
-		.max_uV			= 2500000,
-		.apply_uV		= true,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask	 = REGULATOR_CHANGE_VOLTAGE
-					| REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-};
-
-static struct regulator_init_data omap4_panda_vana = {
-	.constraints = {
-		.min_uV			= 2100000,
-		.max_uV			= 2100000,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask	 = REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-};
-
-static struct regulator_init_data omap4_panda_vcxio = {
-	.constraints = {
-		.min_uV			= 1800000,
-		.max_uV			= 1800000,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask	 = REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-};
-
-static struct regulator_init_data omap4_panda_vdac = {
-	.constraints = {
-		.min_uV			= 1800000,
-		.max_uV			= 1800000,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask	 = REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-};
-
-static struct regulator_init_data omap4_panda_vusb = {
-	.constraints = {
-		.min_uV			= 3300000,
-		.max_uV			= 3300000,
-		.apply_uV		= true,
-		.valid_modes_mask	= REGULATOR_MODE_NORMAL
-					| REGULATOR_MODE_STANDBY,
-		.valid_ops_mask	 =	REGULATOR_CHANGE_MODE
-					| REGULATOR_CHANGE_STATUS,
-	},
-};
-
-static struct regulator_init_data omap4_panda_clk32kg = {
-	.constraints = {
-		.valid_ops_mask		= REGULATOR_CHANGE_STATUS,
-	},
-};
-
-static struct twl4030_platform_data omap4_panda_twldata = {
-	.irq_base	= TWL6030_IRQ_BASE,
-	.irq_end	= TWL6030_IRQ_END,
-
-	/* Regulators */
-	.vmmc		= &omap4_panda_vmmc,
-	.vpp		= &omap4_panda_vpp,
-	.vana		= &omap4_panda_vana,
-	.vcxio		= &omap4_panda_vcxio,
-	.vdac		= &omap4_panda_vdac,
-	.vusb		= &omap4_panda_vusb,
-	.vaux2		= &omap4_panda_vaux2,
-	.vaux3		= &omap4_panda_vaux3,
-	.clk32kg	= &omap4_panda_clk32kg,
-	.usb		= &omap4_usbphy_data,
-};
+/* Use the common PMIC configuration for Panda */
+static struct twl4030_platform_data omap4_panda_twldata;
 
 /*
  * Display monitor features are burnt in their EEPROM as EDID data. The EEPROM
@@ -409,6 +274,16 @@ static struct i2c_board_info __initdata panda_i2c_eeprom[] = {
 
 static int __init omap4_panda_i2c_init(void)
 {
+	omap4_pmic_get_config(&omap4_panda_twldata, TWL_COMMON_PDATA_USB,
+			TWL_COMMON_REGULATOR_VDAC |
+			TWL_COMMON_REGULATOR_VAUX2 |
+			TWL_COMMON_REGULATOR_VAUX3 |
+			TWL_COMMON_REGULATOR_VMMC |
+			TWL_COMMON_REGULATOR_VPP |
+			TWL_COMMON_REGULATOR_VANA |
+			TWL_COMMON_REGULATOR_VCXIO |
+			TWL_COMMON_REGULATOR_VUSB |
+			TWL_COMMON_REGULATOR_CLK32KG);
 	omap4_pmic_init("twl6030", &omap4_panda_twldata);
 	omap_register_i2c_bus(2, 400, NULL, 0);
 	/*
diff --git a/arch/arm/mach-omap2/twl-common.c b/arch/arm/mach-omap2/twl-common.c
index 4f7b24c..5fd644e 100644
--- a/arch/arm/mach-omap2/twl-common.c
+++ b/arch/arm/mach-omap2/twl-common.c
@@ -23,8 +23,11 @@
 #include <linux/i2c.h>
 #include <linux/i2c/twl.h>
 #include <linux/gpio.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/fixed.h>
 
 #include <plat/i2c.h>
+#include <plat/usb.h>
 
 #include "twl-common.h"
 
@@ -44,3 +47,163 @@ void __init omap_pmic_init(int bus, u32 clkrate,
 
 	omap_register_i2c_bus(bus, clkrate, &pmic_i2c_board_info, 1);
 }
+
+static struct twl4030_usb_data omap4_usb_pdata = {
+	.phy_init	= omap4430_phy_init,
+	.phy_exit	= omap4430_phy_exit,
+	.phy_power	= omap4430_phy_power,
+	.phy_set_clock	= omap4430_phy_set_clk,
+	.phy_suspend	= omap4430_phy_suspend,
+};
+
+static struct regulator_init_data omap4_vdac_idata = {
+	.constraints = {
+		.min_uV			= 1800000,
+		.max_uV			= 1800000,
+		.valid_modes_mask	= REGULATOR_MODE_NORMAL
+					| REGULATOR_MODE_STANDBY,
+		.valid_ops_mask	 = REGULATOR_CHANGE_MODE
+					| REGULATOR_CHANGE_STATUS,
+	},
+};
+
+static struct regulator_init_data omap4_vaux2_idata = {
+	.constraints = {
+		.min_uV			= 1200000,
+		.max_uV			= 2800000,
+		.apply_uV		= true,
+		.valid_modes_mask	= REGULATOR_MODE_NORMAL
+					| REGULATOR_MODE_STANDBY,
+		.valid_ops_mask	 = REGULATOR_CHANGE_VOLTAGE
+					| REGULATOR_CHANGE_MODE
+					| REGULATOR_CHANGE_STATUS,
+	},
+};
+
+static struct regulator_init_data omap4_vaux3_idata = {
+	.constraints = {
+		.min_uV			= 1000000,
+		.max_uV			= 3000000,
+		.apply_uV		= true,
+		.valid_modes_mask	= REGULATOR_MODE_NORMAL
+					| REGULATOR_MODE_STANDBY,
+		.valid_ops_mask	 = REGULATOR_CHANGE_VOLTAGE
+					| REGULATOR_CHANGE_MODE
+					| REGULATOR_CHANGE_STATUS,
+	},
+};
+
+static struct regulator_consumer_supply omap4_vmmc_supply[] = {
+	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.0"),
+};
+
+/* VMMC1 for MMC1 card */
+static struct regulator_init_data omap4_vmmc_idata = {
+	.constraints = {
+		.min_uV			= 1200000,
+		.max_uV			= 3000000,
+		.apply_uV		= true,
+		.valid_modes_mask	= REGULATOR_MODE_NORMAL
+					| REGULATOR_MODE_STANDBY,
+		.valid_ops_mask	 = REGULATOR_CHANGE_VOLTAGE
+					| REGULATOR_CHANGE_MODE
+					| REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies  = ARRAY_SIZE(omap4_vmmc_supply),
+	.consumer_supplies      = omap4_vmmc_supply,
+};
+
+static struct regulator_init_data omap4_vpp_idata = {
+	.constraints = {
+		.min_uV			= 1800000,
+		.max_uV			= 2500000,
+		.apply_uV		= true,
+		.valid_modes_mask	= REGULATOR_MODE_NORMAL
+					| REGULATOR_MODE_STANDBY,
+		.valid_ops_mask	 = REGULATOR_CHANGE_VOLTAGE
+					| REGULATOR_CHANGE_MODE
+					| REGULATOR_CHANGE_STATUS,
+	},
+};
+
+static struct regulator_init_data omap4_vana_idata = {
+	.constraints = {
+		.min_uV			= 2100000,
+		.max_uV			= 2100000,
+		.valid_modes_mask	= REGULATOR_MODE_NORMAL
+					| REGULATOR_MODE_STANDBY,
+		.valid_ops_mask	 = REGULATOR_CHANGE_MODE
+					| REGULATOR_CHANGE_STATUS,
+	},
+};
+
+static struct regulator_init_data omap4_vcxio_idata = {
+	.constraints = {
+		.min_uV			= 1800000,
+		.max_uV			= 1800000,
+		.valid_modes_mask	= REGULATOR_MODE_NORMAL
+					| REGULATOR_MODE_STANDBY,
+		.valid_ops_mask	 = REGULATOR_CHANGE_MODE
+					| REGULATOR_CHANGE_STATUS,
+	},
+};
+
+static struct regulator_init_data omap4_vusb_idata = {
+	.constraints = {
+		.min_uV			= 3300000,
+		.max_uV			= 3300000,
+		.apply_uV		= true,
+		.valid_modes_mask	= REGULATOR_MODE_NORMAL
+					| REGULATOR_MODE_STANDBY,
+		.valid_ops_mask	 =	REGULATOR_CHANGE_MODE
+					| REGULATOR_CHANGE_STATUS,
+	},
+};
+
+static struct regulator_init_data omap4_clk32kg_idata = {
+	.constraints = {
+		.valid_ops_mask		= REGULATOR_CHANGE_STATUS,
+	},
+};
+
+void __init omap4_pmic_get_config(struct twl4030_platform_data *pmic_data,
+				  u32 pdata_flags, u32 regulators_flags)
+{
+	if (!pmic_data->irq_base)
+		pmic_data->irq_base = TWL6030_IRQ_BASE;
+	if (!pmic_data->irq_end)
+		pmic_data->irq_end = TWL6030_IRQ_END;
+
+	/* Common platform data configurations */
+	if (pdata_flags & TWL_COMMON_PDATA_USB && !pmic_data->usb)
+		pmic_data->usb = &omap4_usb_pdata;
+
+	/* Common regulator configurations */
+	if (regulators_flags & TWL_COMMON_REGULATOR_VDAC && !pmic_data->vdac)
+		pmic_data->vdac = &omap4_vdac_idata;
+
+	if (regulators_flags & TWL_COMMON_REGULATOR_VAUX2 && !pmic_data->vaux2)
+		pmic_data->vaux2 = &omap4_vaux2_idata;
+
+	if (regulators_flags & TWL_COMMON_REGULATOR_VAUX3 && !pmic_data->vaux3)
+		pmic_data->vaux3 = &omap4_vaux3_idata;
+
+	if (regulators_flags & TWL_COMMON_REGULATOR_VMMC && !pmic_data->vmmc)
+		pmic_data->vmmc = &omap4_vmmc_idata;
+
+	if (regulators_flags & TWL_COMMON_REGULATOR_VPP && !pmic_data->vpp)
+		pmic_data->vpp = &omap4_vpp_idata;
+
+	if (regulators_flags & TWL_COMMON_REGULATOR_VANA && !pmic_data->vana)
+		pmic_data->vana = &omap4_vana_idata;
+
+	if (regulators_flags & TWL_COMMON_REGULATOR_VCXIO && !pmic_data->vcxio)
+		pmic_data->vcxio = &omap4_vcxio_idata;
+
+	if (regulators_flags & TWL_COMMON_REGULATOR_VUSB && !pmic_data->vusb)
+		pmic_data->vusb = &omap4_vusb_idata;
+
+	if (regulators_flags & TWL_COMMON_REGULATOR_CLK32KG &&
+	    !pmic_data->clk32kg)
+		pmic_data->clk32kg = &omap4_clk32kg_idata;
+}
diff --git a/arch/arm/mach-omap2/twl-common.h b/arch/arm/mach-omap2/twl-common.h
index e9fe2ab..d96c289 100644
--- a/arch/arm/mach-omap2/twl-common.h
+++ b/arch/arm/mach-omap2/twl-common.h
@@ -1,6 +1,23 @@
 #ifndef __OMAP_PMIC_COMMON__
 #define __OMAP_PMIC_COMMON__
 
+#define TWL_COMMON_PDATA_USB		(1 << 0)
+
+/* Common LDO regulators for TWL4030/TWL6030 */
+#define TWL_COMMON_REGULATOR_VDAC	(1 << 0)
+#define TWL_COMMON_REGULATOR_VAUX1	(1 << 1)
+#define TWL_COMMON_REGULATOR_VAUX2	(1 << 2)
+#define TWL_COMMON_REGULATOR_VAUX3	(1 << 3)
+
+/* TWL6030 LDO regulators */
+#define TWL_COMMON_REGULATOR_VMMC	(1 << 4)
+#define TWL_COMMON_REGULATOR_VPP	(1 << 5)
+#define TWL_COMMON_REGULATOR_VUSIM	(1 << 6)
+#define TWL_COMMON_REGULATOR_VANA	(1 << 7)
+#define TWL_COMMON_REGULATOR_VCXIO	(1 << 8)
+#define TWL_COMMON_REGULATOR_VUSB	(1 << 9)
+#define TWL_COMMON_REGULATOR_CLK32KG	(1 << 10)
+
 struct twl4030_platform_data;
 
 void omap_pmic_init(int bus, u32 clkrate, const char *pmic_type, int pmic_irq,
@@ -25,4 +42,7 @@ static inline void omap4_pmic_init(const char *pmic_type,
 	omap_pmic_init(1, 400, pmic_type, OMAP44XX_IRQ_SYS_1N, pmic_data);
 }
 
+void omap4_pmic_get_config(struct twl4030_platform_data *pmic_data,
+			   u32 pdata_flags, u32 regulators_flags);
+
 #endif /* __OMAP_PMIC_COMMON__ */
-- 
1.7.5.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab2C2IU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 04:20:27 -0400
Received: from ftp.meprolight.com ([194.90.149.17]:38705 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751637Ab2C2IUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 04:20:15 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: <s.hauer@pengutronix.de>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <broonie@opensource.wolfsonmicro.com>, <fabio.estevam@freescale.com>,
        Alex Gershgorin <alexg@meprolight.com>
Subject: [PATCH v3] ARM: regulator: i.MX35-PDK Add regulator support
Date: Thu, 29 Mar 2012 10:12:45 +0200
Message-ID: <1333008765-26114-1-git-send-email-alexg@meprolight.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alex Gershgorin <alexg@meprolight.com>
---
Applies to v3.4

Changes since v2:
 * Renaming dev_name from "1-000a" to "0-000a"
---
 arch/arm/mach-imx/mach-mx35_3ds.c |  193 +++++++++++++++++++++++++++++++++++++
 1 files changed, 193 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-imx/mach-mx35_3ds.c b/arch/arm/mach-imx/mach-mx35_3ds.c
index e14291d..9247a79 100644
--- a/arch/arm/mach-imx/mach-mx35_3ds.c
+++ b/arch/arm/mach-imx/mach-mx35_3ds.c
@@ -34,6 +34,8 @@
 #include <linux/usb/otg.h>
 
 #include <linux/mtd/physmap.h>
+#include <linux/mfd/mc13892.h>
+#include <linux/regulator/machine.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -253,6 +255,8 @@ static iomux_v3_cfg_t mx35pdk_pads[] = {
 	MX35_PAD_CSI_MCLK__IPU_CSI_MCLK,
 	MX35_PAD_CSI_PIXCLK__IPU_CSI_PIXCLK,
 	MX35_PAD_CSI_VSYNC__IPU_CSI_VSYNC,
+	/*PMIC IRQ*/
+	MX35_PAD_GPIO2_0__GPIO2_0,
 };
 
 /*
@@ -317,6 +321,193 @@ static struct platform_device mx35_3ds_ov2640 = {
 	},
 };
 
+static struct regulator_consumer_supply sw1_consumers[] = {
+	{
+		.supply = "cpu_vcc",
+	}
+};
+
+static struct regulator_consumer_supply vcam_consumers[] = {
+	/* sgtl5000 */
+	REGULATOR_SUPPLY("VDDA", "0-000a"),
+};
+
+static struct regulator_consumer_supply vaudio_consumers[] = {
+	REGULATOR_SUPPLY("cmos_vio", "soc-camera-pdrv.0"),
+};
+
+static struct regulator_init_data sw1_init = {
+	.constraints = {
+		.name = "SW1",
+		.min_uV = 600000,
+		.max_uV = 1375000,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
+		.valid_modes_mask = 0,
+		.always_on = 1,
+		.boot_on = 1,
+	},
+	.num_consumer_supplies = ARRAY_SIZE(sw1_consumers),
+	.consumer_supplies = sw1_consumers,
+};
+
+static struct regulator_init_data sw2_init = {
+	.constraints = {
+		.name = "SW2",
+		.always_on = 1,
+		.boot_on = 1,
+	}
+};
+
+static struct regulator_init_data sw3_init = {
+	.constraints = {
+		.name = "SW3",
+		.always_on = 1,
+		.boot_on = 1,
+	}
+};
+
+static struct regulator_init_data sw4_init = {
+	.constraints = {
+		.name = "SW4",
+		.always_on = 1,
+		.boot_on = 1,
+	}
+};
+
+static struct regulator_init_data viohi_init = {
+	.constraints = {
+		.name = "VIOHI",
+		.boot_on = 1,
+	}
+};
+
+static struct regulator_init_data vusb_init = {
+	.constraints = {
+		.name = "VUSB",
+		.boot_on = 1,
+	}
+};
+
+static struct regulator_init_data vdig_init = {
+	.constraints = {
+		.name = "VDIG",
+		.boot_on = 1,
+	}
+};
+
+static struct regulator_init_data vpll_init = {
+	.constraints = {
+		.name = "VPLL",
+		.boot_on = 1,
+	}
+};
+
+static struct regulator_init_data vusb2_init = {
+	.constraints = {
+		.name = "VUSB2",
+		.boot_on = 1,
+	}
+};
+
+static struct regulator_init_data vvideo_init = {
+	.constraints = {
+		.name = "VVIDEO",
+		.boot_on = 1
+	}
+};
+
+static struct regulator_init_data vaudio_init = {
+	.constraints = {
+		.name = "VAUDIO",
+		.min_uV = 2300000,
+		.max_uV = 3000000,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
+		.boot_on = 1
+	},
+	.num_consumer_supplies = ARRAY_SIZE(vaudio_consumers),
+	.consumer_supplies = vaudio_consumers,
+};
+
+static struct regulator_init_data vcam_init = {
+	.constraints = {
+		.name = "VCAM",
+		.min_uV = 2500000,
+		.max_uV = 3000000,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
+					REGULATOR_CHANGE_MODE,
+		.valid_modes_mask = REGULATOR_MODE_FAST | REGULATOR_MODE_NORMAL,
+		.boot_on = 1
+	},
+	.num_consumer_supplies = ARRAY_SIZE(vcam_consumers),
+	.consumer_supplies = vcam_consumers,
+};
+
+static struct regulator_init_data vgen1_init = {
+	.constraints = {
+		.name = "VGEN1",
+	}
+};
+
+static struct regulator_init_data vgen2_init = {
+	.constraints = {
+		.name = "VGEN2",
+		.boot_on = 1,
+	}
+};
+
+static struct regulator_init_data vgen3_init = {
+	.constraints = {
+		.name = "VGEN3",
+	}
+};
+
+static struct mc13xxx_regulator_init_data mx35_3ds_regulators[] = {
+	{ .id = MC13892_SW1, .init_data = &sw1_init },
+	{ .id = MC13892_SW2, .init_data = &sw2_init },
+	{ .id = MC13892_SW3, .init_data = &sw3_init },
+	{ .id = MC13892_SW4, .init_data = &sw4_init },
+	{ .id = MC13892_VIOHI, .init_data = &viohi_init },
+	{ .id = MC13892_VPLL, .init_data = &vpll_init },
+	{ .id = MC13892_VDIG, .init_data = &vdig_init },
+	{ .id = MC13892_VUSB2, .init_data = &vusb2_init },
+	{ .id = MC13892_VVIDEO, .init_data = &vvideo_init },
+	{ .id = MC13892_VAUDIO, .init_data = &vaudio_init },
+	{ .id = MC13892_VCAM, .init_data = &vcam_init },
+	{ .id = MC13892_VGEN1, .init_data = &vgen1_init },
+	{ .id = MC13892_VGEN2, .init_data = &vgen2_init },
+	{ .id = MC13892_VGEN3, .init_data = &vgen3_init },
+	{ .id = MC13892_VUSB, .init_data = &vusb_init },
+};
+
+static struct mc13xxx_platform_data mx35_3ds_mc13892_data = {
+	.flags = MC13XXX_USE_RTC | MC13XXX_USE_TOUCHSCREEN,
+	.regulators = {
+		.num_regulators = ARRAY_SIZE(mx35_3ds_regulators),
+		.regulators = mx35_3ds_regulators,
+	},
+};
+
+#define GPIO_PMIC_INT IMX_GPIO_NR(2, 0)
+
+static struct i2c_board_info mx35_3ds_i2c_mc13892 = {
+
+	I2C_BOARD_INFO("mc13892", 0x08),
+	.platform_data = &mx35_3ds_mc13892_data,
+	.irq = IMX_GPIO_TO_IRQ(GPIO_PMIC_INT),
+};
+
+static void __init imx35_3ds_init_mc13892(void)
+{
+	int ret = gpio_request_one(GPIO_PMIC_INT, GPIOF_DIR_IN, "pmic irq");
+
+	if (ret) {
+		pr_err("failed to get pmic irq: %d\n", ret);
+		return;
+	}
+
+	i2c_register_board_info(0, &mx35_3ds_i2c_mc13892, 1);
+}
+
 static int mx35_3ds_otg_init(struct platform_device *pdev)
 {
 	return mx35_initialize_usb_hw(pdev->id, MXC_EHCI_INTERNAL_PHY);
@@ -412,6 +603,8 @@ static void __init mx35_3ds_init(void)
 	imx35_fb_pdev = imx35_add_mx3_sdc_fb(&mx3fb_pdata);
 	mx35_3ds_lcd.dev.parent = &imx35_fb_pdev->dev;
 	platform_device_register(&mx35_3ds_lcd);
+
+	imx35_3ds_init_mc13892();
 }
 
 static void __init mx35pdk_timer_init(void)
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab2CZOnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:43:51 -0400
Received: from ftp.meprolight.com ([194.90.149.17]:35192 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932489Ab2CZOnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:43:50 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: <s.hauer@pengutronix.de>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <fabio.estevam@freescale.com>, Alex Gershgorin <alexg@meprolight.com>
Subject: [PATCH v1] regulator: i.MX35-PDK Add regulator support
Date: Mon, 26 Mar 2012 16:36:33 +0200
Message-ID: <1332772593-13313-1-git-send-email-alexg@meprolight.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch register MC13892 PMIC which connected
via I2C bus and allow set the voltage domains
and constraints for each regulator.

Signed-off-by: Alex Gershgorin <alexg@meprolight.com>
---
 arch/arm/mach-imx/mach-mx35_3ds.c |  200 +++++++++++++++++++++++++++++++++++++
 1 files changed, 200 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-imx/mach-mx35_3ds.c b/arch/arm/mach-imx/mach-mx35_3ds.c
index 0af6c9c..33ba6fe 100644
--- a/arch/arm/mach-imx/mach-mx35_3ds.c
+++ b/arch/arm/mach-imx/mach-mx35_3ds.c
@@ -29,6 +29,8 @@
 #include <linux/usb/otg.h>
 
 #include <linux/mtd/physmap.h>
+#include <linux/mfd/mc13892.h>
+#include <linux/regulator/machine.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -43,6 +45,7 @@
 
 #include "devices-imx35.h"
 
+#define GPIO_PMIC_INT IMX_GPIO_NR(2, 0)
 #define EXPIO_PARENT_INT	gpio_to_irq(IMX_GPIO_NR(1, 1))
 
 static const struct imxuart_platform_data uart_pdata __initconst = {
@@ -120,8 +123,204 @@ static iomux_v3_cfg_t mx35pdk_pads[] = {
 	/* I2C1 */
 	MX35_PAD_I2C1_CLK__I2C1_SCL,
 	MX35_PAD_I2C1_DAT__I2C1_SDA,
+	/*PMIC IRQ*/
+	MX35_PAD_GPIO2_0__GPIO2_0,
 };
 
+static struct regulator_init_data sw1_init = {
+	.constraints = {
+		.name = "SW1",
+		.min_uV = 600000,
+		.max_uV = 1375000,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
+		.valid_modes_mask = 0,
+		.always_on = 1,
+		.boot_on = 1,
+	}
+};
+
+static struct regulator_init_data sw2_init = {
+	.constraints = {
+		.name = "SW2",
+		.min_uV = 900000,
+		.max_uV = 1850000,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
+		.always_on = 1,
+		.boot_on = 1,
+	}
+};
+
+static struct regulator_init_data sw3_init = {
+	.constraints = {
+		.name = "SW3",
+		.min_uV = 1100000,
+		.max_uV = 1850000,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
+		.always_on = 1,
+		.boot_on = 1,
+	}
+};
+
+static struct regulator_init_data sw4_init = {
+	.constraints = {
+		.name = "SW4",
+		.min_uV = 1100000,
+		.max_uV = 1850000,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
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
+		.min_uV = 1050000,
+		.max_uV = 1800000,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
+		.boot_on = 1,
+	}
+};
+
+static struct regulator_init_data vpll_init = {
+	.constraints = {
+		.name = "VPLL",
+		.min_uV = 1050000,
+		.max_uV = 1800000,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
+		.boot_on = 1,
+	}
+};
+
+static struct regulator_init_data vusb2_init = {
+	.constraints = {
+		.name = "VUSB2",
+		.min_uV = 2400000,
+		.max_uV = 2775000,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
+		.boot_on = 1,
+	}
+};
+
+static struct regulator_init_data vvideo_init = {
+	.constraints = {
+		.name = "VVIDEO",
+		.min_uV = 2500000,
+		.max_uV = 2775000,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
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
+	}
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
+};
+
+static struct regulator_init_data vgen1_init = {
+	.constraints = {
+		.name = "VGEN1",
+		.min_uV = 1200000,
+		.max_uV = 3150000,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
+	}
+};
+
+static struct regulator_init_data vgen2_init = {
+	.constraints = {
+		.name = "VGEN2",
+		.min_uV = 1200000,
+		.max_uV = 3150000,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
+		.boot_on = 1,
+	}
+};
+
+static struct regulator_init_data vgen3_init = {
+	.constraints = {
+		.name = "VGEN3",
+		.min_uV = 1800000,
+		.max_uV = 2900000,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
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
@@ -204,6 +403,7 @@ static void __init mx35_3ds_init(void)
 		pr_warn("Init of the debugboard failed, all "
 				"devices on the debugboard are unusable.\n");
 	imx35_add_imx_i2c0(&mx35_3ds_i2c0_data);
+	imx35_3ds_init_mc13892();
 }
 
 static void __init mx35pdk_timer_init(void)
-- 
1.7.1


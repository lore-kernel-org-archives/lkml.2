Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab0JAMB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 08:01:57 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:34583 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932246Ab0JAL7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:59:43 -0400
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org, rtc-linux@googlegroups.com,
        a.zummo@towertech.it, dbrownell@users.sourceforge.net,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Ryan Mallon <ryan@bluewatersys.com>, shiraz.hashim@st.com,
        vipin.kumar@st.com, deepak.sikri@st.com, armando.visconti@st.com,
        vipulkumar.samar@st.com, rajeev-dlh.kumar@st.com,
        pratyush.anand@st.com, bhupesh.sharma@st.com,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V2 59/69] SPEAr3xx: Rework pmx_dev code to remove conflicts
Date: Fri,  1 Oct 2010 17:26:19 +0530
Message-Id: <9b53fbce9f64b51d234cf28c03e698f26cd90775.1285933332.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ryan Mallon <ryan@bluewatersys.com>

Prefix the pmx_devs to remove naming conflicts between the three
SPEAr3xx platforms. Also make pmx_driver static to each platform and
rework the init code to pass the devices rather than export the
pmx_driver structure.

Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 arch/arm/mach-spear3xx/include/mach/generic.h |  129 +++++++++++++------------
 arch/arm/mach-spear3xx/spear300.c             |   40 ++++----
 arch/arm/mach-spear3xx/spear300_evb.c         |   25 ++---
 arch/arm/mach-spear3xx/spear310.c             |   28 +++---
 arch/arm/mach-spear3xx/spear310_evb.c         |   41 ++++-----
 arch/arm/mach-spear3xx/spear320.c             |   56 ++++++-----
 arch/arm/mach-spear3xx/spear320_evb.c         |   35 +++----
 arch/arm/mach-spear3xx/spear3xx.c             |   60 ++++++------
 8 files changed, 206 insertions(+), 208 deletions(-)

diff --git a/arch/arm/mach-spear3xx/include/mach/generic.h b/arch/arm/mach-spear3xx/include/mach/generic.h
index 328f8f5..cef82e8 100644
--- a/arch/arm/mach-spear3xx/include/mach/generic.h
+++ b/arch/arm/mach-spear3xx/include/mach/generic.h
@@ -70,21 +70,21 @@ void spear3xx_pmx_init_addr(struct pmx_driver *driver, unsigned int addr);
 #define PMX_TIMER_1_2_MASK	(1 << 0)
 
 /* pad mux devices */
-extern struct pmx_dev pmx_firda;
-extern struct pmx_dev pmx_i2c;
-extern struct pmx_dev pmx_ssp_cs;
-extern struct pmx_dev pmx_ssp;
-extern struct pmx_dev pmx_mii;
-extern struct pmx_dev pmx_gpio_pin0;
-extern struct pmx_dev pmx_gpio_pin1;
-extern struct pmx_dev pmx_gpio_pin2;
-extern struct pmx_dev pmx_gpio_pin3;
-extern struct pmx_dev pmx_gpio_pin4;
-extern struct pmx_dev pmx_gpio_pin5;
-extern struct pmx_dev pmx_uart0_modem;
-extern struct pmx_dev pmx_uart0;
-extern struct pmx_dev pmx_timer_3_4;
-extern struct pmx_dev pmx_timer_1_2;
+extern struct pmx_dev spear3xx_pmx_firda;
+extern struct pmx_dev spear3xx_pmx_i2c;
+extern struct pmx_dev spear3xx_pmx_ssp_cs;
+extern struct pmx_dev spear3xx_pmx_ssp;
+extern struct pmx_dev spear3xx_pmx_mii;
+extern struct pmx_dev spear3xx_pmx_gpio_pin0;
+extern struct pmx_dev spear3xx_pmx_gpio_pin1;
+extern struct pmx_dev spear3xx_pmx_gpio_pin2;
+extern struct pmx_dev spear3xx_pmx_gpio_pin3;
+extern struct pmx_dev spear3xx_pmx_gpio_pin4;
+extern struct pmx_dev spear3xx_pmx_gpio_pin5;
+extern struct pmx_dev spear3xx_pmx_uart0_modem;
+extern struct pmx_dev spear3xx_pmx_uart0;
+extern struct pmx_dev spear3xx_pmx_timer_3_4;
+extern struct pmx_dev spear3xx_pmx_timer_1_2;
 
 #if defined(CONFIG_MACH_SPEAR310) || defined(CONFIG_MACH_SPEAR320)
 /* padmux plgpio devices */
@@ -105,8 +105,6 @@ extern struct pmx_dev pmx_plgpio_43_44_47_48;
 extern struct pmx_dev pmx_plgpio_45_46_49_50;
 #endif
 
-extern struct pmx_driver pmx_driver;
-
 /* spear300 declarations */
 #ifdef CONFIG_MACH_SPEAR300
 /* Add spear300 machine device structure declarations here */
@@ -135,27 +133,28 @@ extern struct pmx_mode camu_wlcd_mode;
 extern struct pmx_mode caml_lcd_mode;
 
 /* pad mux devices */
-extern struct pmx_dev pmx_fsmc_2_chips;
-extern struct pmx_dev pmx_fsmc_4_chips;
-extern struct pmx_dev pmx_keyboard;
-extern struct pmx_dev pmx_clcd;
-extern struct pmx_dev pmx_telecom_gpio;
-extern struct pmx_dev pmx_telecom_tdm;
-extern struct pmx_dev pmx_telecom_spi_cs_i2c_clk;
-extern struct pmx_dev pmx_telecom_camera;
-extern struct pmx_dev pmx_telecom_dac;
-extern struct pmx_dev pmx_telecom_i2s;
-extern struct pmx_dev pmx_telecom_boot_pins;
-extern struct pmx_dev pmx_telecom_sdhci_4bit;
-extern struct pmx_dev pmx_telecom_sdhci_8bit;
-extern struct pmx_dev pmx_gpio1;
+extern struct pmx_dev spear300_pmx_fsmc_2_chips;
+extern struct pmx_dev spear300_pmx_fsmc_4_chips;
+extern struct pmx_dev spear300_pmx_keyboard;
+extern struct pmx_dev spear300_pmx_clcd;
+extern struct pmx_dev spear300_pmx_telecom_gpio;
+extern struct pmx_dev spear300_pmx_telecom_tdm;
+extern struct pmx_dev spear300_pmx_telecom_spi_cs_i2c_clk;
+extern struct pmx_dev spear300_pmx_telecom_camera;
+extern struct pmx_dev spear300_pmx_telecom_dac;
+extern struct pmx_dev spear300_pmx_telecom_i2s;
+extern struct pmx_dev spear300_pmx_telecom_boot_pins;
+extern struct pmx_dev spear300_pmx_telecom_sdhci_4bit;
+extern struct pmx_dev spear300_pmx_telecom_sdhci_8bit;
+extern struct pmx_dev spear300_pmx_gpio1;
 
 /* pad multiplexing support */
 #define SPEAR300_PAD_MUX_CONFIG_REG	0x99000000
 #define SPEAR300_MODE_CONFIG_REG	0x99000004
 
 /* Add spear300 machine function declarations here */
-void __init spear300_init(void);
+void __init spear300_init(struct pmx_mode *pmx_mode, struct pmx_dev **pmx_devs,
+		u8 pmx_dev_count);
 #define SDHCI_MEM_ENB	0x1
 #define I2S_MEM_ENB	0x2
 void sdhci_i2s_mem_enable(u8 mask);
@@ -176,18 +175,19 @@ extern struct platform_device plgpio_device;
 extern struct platform_device nand_device;
 
 /* pad mux devices */
-extern struct pmx_dev pmx_emi_cs_0_1_4_5;
-extern struct pmx_dev pmx_emi_cs_2_3;
-extern struct pmx_dev pmx_uart1;
-extern struct pmx_dev pmx_uart2;
-extern struct pmx_dev pmx_uart3_4_5;
-extern struct pmx_dev pmx_fsmc;
-extern struct pmx_dev pmx_rs485_0_1;
-extern struct pmx_dev pmx_tdm0;
+extern struct pmx_dev spear310_pmx_emi_cs_0_1_4_5;
+extern struct pmx_dev spear310_pmx_emi_cs_2_3;
+extern struct pmx_dev spear310_pmx_uart1;
+extern struct pmx_dev spear310_pmx_uart2;
+extern struct pmx_dev spear310_pmx_uart3_4_5;
+extern struct pmx_dev spear310_pmx_fsmc;
+extern struct pmx_dev spear310_pmx_rs485_0_1;
+extern struct pmx_dev spear310_pmx_tdm0;
 #define SPEAR310_PAD_MUX_CONFIG_REG	0xB4000008
 
 /* Add spear310 machine function declarations here */
-void __init spear310_init(void);
+void __init spear310_init(struct pmx_mode *pmx_mode, struct pmx_dev **pmx_devs,
+		u8 pmx_dev_count);
 
 /* spear320 declarations */
 #elif defined(CONFIG_MACH_SPEAR320)
@@ -212,35 +212,36 @@ extern struct pmx_mode auto_exp_mode;
 extern struct pmx_mode small_printers_mode;
 
 /* pad mux devices */
-extern struct pmx_dev pmx_clcd;
-extern struct pmx_dev pmx_emi;
-extern struct pmx_dev pmx_fsmc;
-extern struct pmx_dev pmx_spp;
-extern struct pmx_dev pmx_sdhci;
-extern struct pmx_dev pmx_i2s;
-extern struct pmx_dev pmx_uart1;
-extern struct pmx_dev pmx_uart1_modem;
-extern struct pmx_dev pmx_uart2;
-extern struct pmx_dev pmx_touchscreen;
-extern struct pmx_dev pmx_can;
-extern struct pmx_dev pmx_sdhci_led;
-extern struct pmx_dev pmx_pwm0;
-extern struct pmx_dev pmx_pwm1;
-extern struct pmx_dev pmx_pwm2;
-extern struct pmx_dev pmx_pwm3;
-extern struct pmx_dev pmx_ssp1;
-extern struct pmx_dev pmx_ssp2;
-extern struct pmx_dev pmx_mii1;
-extern struct pmx_dev pmx_smii0;
-extern struct pmx_dev pmx_smii1;
-extern struct pmx_dev pmx_i2c1;
+extern struct pmx_dev spear320_pmx_clcd;
+extern struct pmx_dev spear320_pmx_emi;
+extern struct pmx_dev spear320_pmx_fsmc;
+extern struct pmx_dev spear320_pmx_spp;
+extern struct pmx_dev spear320_pmx_sdhci;
+extern struct pmx_dev spear320_pmx_i2s;
+extern struct pmx_dev spear320_pmx_uart1;
+extern struct pmx_dev spear320_pmx_uart1_modem;
+extern struct pmx_dev spear320_pmx_uart2;
+extern struct pmx_dev spear320_pmx_touchscreen;
+extern struct pmx_dev spear320_pmx_can;
+extern struct pmx_dev spear320_pmx_sdhci_led;
+extern struct pmx_dev spear320_pmx_pwm0;
+extern struct pmx_dev spear320_pmx_pwm1;
+extern struct pmx_dev spear320_pmx_pwm2;
+extern struct pmx_dev spear320_pmx_pwm3;
+extern struct pmx_dev spear320_pmx_ssp1;
+extern struct pmx_dev spear320_pmx_ssp2;
+extern struct pmx_dev spear320_pmx_mii1;
+extern struct pmx_dev spear320_pmx_smii0;
+extern struct pmx_dev spear320_pmx_smii1;
+extern struct pmx_dev spear320_pmx_i2c1;
 
 /* pad multiplexing support */
 #define SPEAR320_PAD_MUX_CONFIG_REG	0xB300000C
 #define SPEAR320_MODE_CONFIG_REG	0xB3000010
 
 /* Add spear320 machine function declarations here */
-void __init spear320_init(void);
+void __init spear320_init(struct pmx_mode *pmx_mode, struct pmx_dev **pmx_devs,
+		u8 pmx_dev_count);
 
 /* Add misc structure declarations here */
 extern struct clcd_board clcd_plat_data;
diff --git a/arch/arm/mach-spear3xx/spear300.c b/arch/arm/mach-spear3xx/spear300.c
index b041427..3c040f0 100644
--- a/arch/arm/mach-spear3xx/spear300.c
+++ b/arch/arm/mach-spear3xx/spear300.c
@@ -131,7 +131,7 @@ static struct pmx_dev_mode pmx_fsmc_2_chips_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_fsmc_2_chips = {
+struct pmx_dev spear300_pmx_fsmc_2_chips = {
 	.name = "fsmc_2_chips",
 	.modes = pmx_fsmc_2_chips_modes,
 	.mode_count = ARRAY_SIZE(pmx_fsmc_2_chips_modes),
@@ -154,7 +154,7 @@ static struct pmx_dev_mode pmx_fsmc_4_chips_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_fsmc_4_chips = {
+struct pmx_dev spear300_pmx_fsmc_4_chips = {
 	.name = "fsmc_4_chips",
 	.modes = pmx_fsmc_4_chips_modes,
 	.mode_count = ARRAY_SIZE(pmx_fsmc_4_chips_modes),
@@ -179,7 +179,7 @@ static struct pmx_dev_mode pmx_keyboard_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_keyboard = {
+struct pmx_dev spear300_pmx_keyboard = {
 	.name = "keyboard",
 	.modes = pmx_keyboard_modes,
 	.mode_count = ARRAY_SIZE(pmx_keyboard_modes),
@@ -213,7 +213,7 @@ static struct pmx_dev_mode pmx_clcd_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_clcd = {
+struct pmx_dev spear300_pmx_clcd = {
 	.name = "clcd",
 	.modes = pmx_clcd_modes,
 	.mode_count = ARRAY_SIZE(pmx_clcd_modes),
@@ -280,7 +280,7 @@ static struct pmx_dev_mode pmx_telecom_gpio_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_telecom_gpio = {
+struct pmx_dev spear300_pmx_telecom_gpio = {
 	.name = "telecom_gpio",
 	.modes = pmx_telecom_gpio_modes,
 	.mode_count = ARRAY_SIZE(pmx_telecom_gpio_modes),
@@ -306,7 +306,7 @@ static struct pmx_dev_mode pmx_telecom_tdm_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_telecom_tdm = {
+struct pmx_dev spear300_pmx_telecom_tdm = {
 	.name = "telecom_tdm",
 	.modes = pmx_telecom_tdm_modes,
 	.mode_count = ARRAY_SIZE(pmx_telecom_tdm_modes),
@@ -331,7 +331,7 @@ static struct pmx_dev_mode pmx_telecom_spi_cs_i2c_clk_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_telecom_spi_cs_i2c_clk = {
+struct pmx_dev spear300_pmx_telecom_spi_cs_i2c_clk = {
 	.name = "telecom_spi_cs_i2c_clk",
 	.modes = pmx_telecom_spi_cs_i2c_clk_modes,
 	.mode_count = ARRAY_SIZE(pmx_telecom_spi_cs_i2c_clk_modes),
@@ -363,7 +363,7 @@ static struct pmx_dev_mode pmx_telecom_camera_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_telecom_camera = {
+struct pmx_dev spear300_pmx_telecom_camera = {
 	.name = "telecom_camera",
 	.modes = pmx_telecom_camera_modes,
 	.mode_count = ARRAY_SIZE(pmx_telecom_camera_modes),
@@ -386,7 +386,7 @@ static struct pmx_dev_mode pmx_telecom_dac_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_telecom_dac = {
+struct pmx_dev spear300_pmx_telecom_dac = {
 	.name = "telecom_dac",
 	.modes = pmx_telecom_dac_modes,
 	.mode_count = ARRAY_SIZE(pmx_telecom_dac_modes),
@@ -411,7 +411,7 @@ static struct pmx_dev_mode pmx_telecom_i2s_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_telecom_i2s = {
+struct pmx_dev spear300_pmx_telecom_i2s = {
 	.name = "telecom_i2s",
 	.modes = pmx_telecom_i2s_modes,
 	.mode_count = ARRAY_SIZE(pmx_telecom_i2s_modes),
@@ -434,7 +434,7 @@ static struct pmx_dev_mode pmx_telecom_boot_pins_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_telecom_boot_pins = {
+struct pmx_dev spear300_pmx_telecom_boot_pins = {
 	.name = "telecom_boot_pins",
 	.modes = pmx_telecom_boot_pins_modes,
 	.mode_count = ARRAY_SIZE(pmx_telecom_boot_pins_modes),
@@ -462,7 +462,7 @@ static struct pmx_dev_mode pmx_telecom_sdhci_4bit_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_telecom_sdhci_4bit = {
+struct pmx_dev spear300_pmx_telecom_sdhci_4bit = {
 	.name = "telecom_sdhci_4bit",
 	.modes = pmx_telecom_sdhci_4bit_modes,
 	.mode_count = ARRAY_SIZE(pmx_telecom_sdhci_4bit_modes),
@@ -489,7 +489,7 @@ static struct pmx_dev_mode pmx_telecom_sdhci_8bit_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_telecom_sdhci_8bit = {
+struct pmx_dev spear300_pmx_telecom_sdhci_8bit = {
 	.name = "telecom_sdhci_8bit",
 	.modes = pmx_telecom_sdhci_8bit_modes,
 	.mode_count = ARRAY_SIZE(pmx_telecom_sdhci_8bit_modes),
@@ -512,14 +512,14 @@ static struct pmx_dev_mode pmx_gpio1_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_gpio1 = {
+struct pmx_dev spear300_pmx_gpio1 = {
 	.name = "arm gpio1",
 	.modes = pmx_gpio1_modes,
 	.mode_count = ARRAY_SIZE(pmx_gpio1_modes),
 };
 
 /* pmx driver structure */
-struct pmx_driver pmx_driver = {
+static struct pmx_driver pmx_driver = {
 	.mode_reg = {.address = SPEAR300_MODE_CONFIG_REG, .mask = 0x0000000f},
 };
 
@@ -773,7 +773,8 @@ void sdhci_i2s_mem_enable(u8 mask)
 }
 
 /* spear300 routines */
-void __init spear300_init(void)
+void __init spear300_init(struct pmx_mode *pmx_mode, struct pmx_dev **pmx_devs,
+		u8 pmx_dev_count)
 {
 	int ret = 0;
 
@@ -788,10 +789,13 @@ void __init spear300_init(void)
 			printk(KERN_ERR "Error registering Shared IRQ\n");
 	}
 
+	/* pmx initialization */
+	pmx_driver.mode = pmx_mode;
+	pmx_driver.devs = pmx_devs;
+	pmx_driver.devs_count = pmx_dev_count;
+
 	/* This fixes addresses of all pmx devices for spear300 */
 	spear3xx_pmx_init_addr(&pmx_driver, SPEAR300_PAD_MUX_CONFIG_REG);
-
-	/* pmx initialization */
 	ret = pmx_register(&pmx_driver);
 	if (ret)
 		pr_err("padmux: registeration failed. err no: %d\n", ret);
diff --git a/arch/arm/mach-spear3xx/spear300_evb.c b/arch/arm/mach-spear3xx/spear300_evb.c
index 2bcb55f..0adf9f7 100644
--- a/arch/arm/mach-spear3xx/spear300_evb.c
+++ b/arch/arm/mach-spear3xx/spear300_evb.c
@@ -29,17 +29,17 @@
 /* padmux devices to enable */
 static struct pmx_dev *pmx_devs[] = {
 	/* spear3xx specific devices */
-	&pmx_i2c,
-	&pmx_ssp_cs,
-	&pmx_ssp,
-	&pmx_mii,
-	&pmx_uart0,
+	&spear3xx_pmx_i2c,
+	&spear3xx_pmx_ssp_cs,
+	&spear3xx_pmx_ssp,
+	&spear3xx_pmx_mii,
+	&spear3xx_pmx_uart0,
 
 	/* spear300 specific devices */
-	&pmx_fsmc_2_chips,
-	&pmx_clcd,
-	&pmx_telecom_sdhci_4bit,
-	&pmx_gpio1,
+	&spear300_pmx_fsmc_2_chips,
+	&spear300_pmx_clcd,
+	&spear300_pmx_telecom_sdhci_4bit,
+	&spear300_pmx_gpio1,
 };
 
 static struct amba_device *amba_devs[] __initdata = {
@@ -113,11 +113,6 @@ static void __init spear300_evb_init(void)
 {
 	unsigned int i;
 
-	/* padmux initialization, must be done before spear300_init */
-	pmx_driver.mode = &photo_frame_mode;
-	pmx_driver.devs = pmx_devs;
-	pmx_driver.devs_count = ARRAY_SIZE(pmx_devs);
-
 	/* set keyboard plat data */
 	kbd_set_plat_data(&kbd_device, &kbd_data);
 
@@ -132,7 +127,7 @@ static void __init spear300_evb_init(void)
 	sdhci_i2s_mem_enable(SDHCI_MEM_ENB);
 
 	/* call spear300 machine init function */
-	spear300_init();
+	spear300_init(&photo_frame_mode, pmx_devs, ARRAY_SIZE(pmx_devs));
 
 	/* Register slave devices on the I2C buses */
 	i2c_register_board_devices();
diff --git a/arch/arm/mach-spear3xx/spear310.c b/arch/arm/mach-spear3xx/spear310.c
index 6fb20c3..f25d2b4 100644
--- a/arch/arm/mach-spear3xx/spear310.c
+++ b/arch/arm/mach-spear3xx/spear310.c
@@ -38,7 +38,7 @@ static struct pmx_dev_mode pmx_emi_cs_0_1_4_5_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_emi_cs_0_1_4_5 = {
+struct pmx_dev spear310_pmx_emi_cs_0_1_4_5 = {
 	.name = "emi_cs_0_1_4_5",
 	.modes = pmx_emi_cs_0_1_4_5_modes,
 	.mode_count = ARRAY_SIZE(pmx_emi_cs_0_1_4_5_modes),
@@ -59,7 +59,7 @@ static struct pmx_dev_mode pmx_emi_cs_2_3_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_emi_cs_2_3 = {
+struct pmx_dev spear310_pmx_emi_cs_2_3 = {
 	.name = "emi_cs_2_3",
 	.modes = pmx_emi_cs_2_3_modes,
 	.mode_count = ARRAY_SIZE(pmx_emi_cs_2_3_modes),
@@ -80,7 +80,7 @@ static struct pmx_dev_mode pmx_uart1_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_uart1 = {
+struct pmx_dev spear310_pmx_uart1 = {
 	.name = "uart1",
 	.modes = pmx_uart1_modes,
 	.mode_count = ARRAY_SIZE(pmx_uart1_modes),
@@ -101,7 +101,7 @@ static struct pmx_dev_mode pmx_uart2_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_uart2 = {
+struct pmx_dev spear310_pmx_uart2 = {
 	.name = "uart2",
 	.modes = pmx_uart2_modes,
 	.mode_count = ARRAY_SIZE(pmx_uart2_modes),
@@ -122,7 +122,7 @@ static struct pmx_dev_mode pmx_uart3_4_5_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_uart3_4_5 = {
+struct pmx_dev spear310_pmx_uart3_4_5 = {
 	.name = "uart3_4_5",
 	.modes = pmx_uart3_4_5_modes,
 	.mode_count = ARRAY_SIZE(pmx_uart3_4_5_modes),
@@ -143,7 +143,7 @@ static struct pmx_dev_mode pmx_fsmc_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_fsmc = {
+struct pmx_dev spear310_pmx_fsmc = {
 	.name = "fsmc",
 	.modes = pmx_fsmc_modes,
 	.mode_count = ARRAY_SIZE(pmx_fsmc_modes),
@@ -164,7 +164,7 @@ static struct pmx_dev_mode pmx_rs485_0_1_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_rs485_0_1 = {
+struct pmx_dev spear310_pmx_rs485_0_1 = {
 	.name = "rs485_0_1",
 	.modes = pmx_rs485_0_1_modes,
 	.mode_count = ARRAY_SIZE(pmx_rs485_0_1_modes),
@@ -185,14 +185,14 @@ static struct pmx_dev_mode pmx_tdm0_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_tdm0 = {
+struct pmx_dev spear310_pmx_tdm0 = {
 	.name = "tdm0",
 	.modes = pmx_tdm0_modes,
 	.mode_count = ARRAY_SIZE(pmx_tdm0_modes),
 };
 
 /* pmx driver structure */
-struct pmx_driver pmx_driver;
+static struct pmx_driver pmx_driver;
 
 /* Add spear310 specific devices here */
 /* uart1 device registeration */
@@ -479,7 +479,8 @@ static struct spear_shirq shirq_intrcomm_ras = {
 };
 
 /* spear310 routines */
-void __init spear310_init(void)
+void __init spear310_init(struct pmx_mode *pmx_mode, struct pmx_dev **pmx_devs,
+		u8 pmx_dev_count)
 {
 	void __iomem *base;
 	int ret = 0;
@@ -515,10 +516,13 @@ void __init spear310_init(void)
 			printk(KERN_ERR "Error registering Shared IRQ 4\n");
 	}
 
+	/* pmx initialization */
+	pmx_driver.mode = pmx_mode;
+	pmx_driver.devs = pmx_devs;
+	pmx_driver.devs_count = pmx_dev_count;
+
 	/* This fixes addresses of all pmx devices for spear310 */
 	spear3xx_pmx_init_addr(&pmx_driver, SPEAR310_PAD_MUX_CONFIG_REG);
-
-	/* pmx initialization */
 	ret = pmx_register(&pmx_driver);
 	if (ret)
 		pr_err("padmux: registeration failed. err no: %d\n", ret);
diff --git a/arch/arm/mach-spear3xx/spear310_evb.c b/arch/arm/mach-spear3xx/spear310_evb.c
index 49aca18..953a9ea 100644
--- a/arch/arm/mach-spear3xx/spear310_evb.c
+++ b/arch/arm/mach-spear3xx/spear310_evb.c
@@ -46,25 +46,25 @@ static struct resource emi_nor_resources[] = {
 /* padmux devices to enable */
 static struct pmx_dev *pmx_devs[] = {
 	/* spear3xx specific devices */
-	&pmx_i2c,
-	&pmx_ssp,
-	&pmx_gpio_pin0,
-	&pmx_gpio_pin1,
-	&pmx_gpio_pin2,
-	&pmx_gpio_pin3,
-	&pmx_gpio_pin4,
-	&pmx_gpio_pin5,
-	&pmx_uart0,
+	&spear3xx_pmx_i2c,
+	&spear3xx_pmx_ssp,
+	&spear3xx_pmx_gpio_pin0,
+	&spear3xx_pmx_gpio_pin1,
+	&spear3xx_pmx_gpio_pin2,
+	&spear3xx_pmx_gpio_pin3,
+	&spear3xx_pmx_gpio_pin4,
+	&spear3xx_pmx_gpio_pin5,
+	&spear3xx_pmx_uart0,
 
 	/* spear310 specific devices */
-	&pmx_emi_cs_0_1_4_5,
-	&pmx_emi_cs_2_3,
-	&pmx_uart1,
-	&pmx_uart2,
-	&pmx_uart3_4_5,
-	&pmx_fsmc,
-	&pmx_rs485_0_1,
-	&pmx_tdm0,
+	&spear310_pmx_emi_cs_0_1_4_5,
+	&spear310_pmx_emi_cs_2_3,
+	&spear310_pmx_uart1,
+	&spear310_pmx_uart2,
+	&spear310_pmx_uart3_4_5,
+	&spear310_pmx_fsmc,
+	&spear310_pmx_rs485_0_1,
+	&spear310_pmx_tdm0,
 };
 
 static struct amba_device *amba_devs[] __initdata = {
@@ -131,17 +131,12 @@ static void __init spear310_evb_init(void)
 {
 	unsigned int i;
 
-	/* padmux initialization, must be done before spear310_init */
-	pmx_driver.mode = NULL;
-	pmx_driver.devs = pmx_devs;
-	pmx_driver.devs_count = ARRAY_SIZE(pmx_devs);
-
 	/* set nand device's plat data */
 	fsmc_nand_set_plat_data(&nand_device, NULL, 0, NAND_SKIP_BBTSCAN,
 			FSMC_NAND_BW8);
 
 	/* call spear310 machine init function */
-	spear310_init();
+	spear310_init(NULL, pmx_devs, ARRAY_SIZE(pmx_devs));
 
 	/* Register slave devices on the I2C buses */
 	i2c_register_board_devices();
diff --git a/arch/arm/mach-spear3xx/spear320.c b/arch/arm/mach-spear3xx/spear320.c
index 03d3486..bcd76e4 100644
--- a/arch/arm/mach-spear3xx/spear320.c
+++ b/arch/arm/mach-spear3xx/spear320.c
@@ -71,7 +71,7 @@ static struct pmx_dev_mode pmx_clcd_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_clcd = {
+struct pmx_dev spear320_pmx_clcd = {
 	.name = "clcd",
 	.modes = pmx_clcd_modes,
 	.mode_count = ARRAY_SIZE(pmx_clcd_modes),
@@ -93,7 +93,7 @@ static struct pmx_dev_mode pmx_emi_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_emi = {
+struct pmx_dev spear320_pmx_emi = {
 	.name = "emi",
 	.modes = pmx_emi_modes,
 	.mode_count = ARRAY_SIZE(pmx_emi_modes),
@@ -115,7 +115,7 @@ static struct pmx_dev_mode pmx_fsmc_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_fsmc = {
+struct pmx_dev spear320_pmx_fsmc = {
 	.name = "fsmc",
 	.modes = pmx_fsmc_modes,
 	.mode_count = ARRAY_SIZE(pmx_fsmc_modes),
@@ -137,7 +137,7 @@ static struct pmx_dev_mode pmx_spp_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_spp = {
+struct pmx_dev spear320_pmx_spp = {
 	.name = "spp",
 	.modes = pmx_spp_modes,
 	.mode_count = ARRAY_SIZE(pmx_spp_modes),
@@ -160,7 +160,7 @@ static struct pmx_dev_mode pmx_sdhci_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_sdhci = {
+struct pmx_dev spear320_pmx_sdhci = {
 	.name = "sdhci",
 	.modes = pmx_sdhci_modes,
 	.mode_count = ARRAY_SIZE(pmx_sdhci_modes),
@@ -182,7 +182,7 @@ static struct pmx_dev_mode pmx_i2s_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_i2s = {
+struct pmx_dev spear320_pmx_i2s = {
 	.name = "i2s",
 	.modes = pmx_i2s_modes,
 	.mode_count = ARRAY_SIZE(pmx_i2s_modes),
@@ -204,7 +204,7 @@ static struct pmx_dev_mode pmx_uart1_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_uart1 = {
+struct pmx_dev spear320_pmx_uart1 = {
 	.name = "uart1",
 	.modes = pmx_uart1_modes,
 	.mode_count = ARRAY_SIZE(pmx_uart1_modes),
@@ -239,7 +239,7 @@ static struct pmx_dev_mode pmx_uart1_modem_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_uart1_modem = {
+struct pmx_dev spear320_pmx_uart1_modem = {
 	.name = "uart1_modem",
 	.modes = pmx_uart1_modem_modes,
 	.mode_count = ARRAY_SIZE(pmx_uart1_modem_modes),
@@ -261,7 +261,7 @@ static struct pmx_dev_mode pmx_uart2_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_uart2 = {
+struct pmx_dev spear320_pmx_uart2 = {
 	.name = "uart2",
 	.modes = pmx_uart2_modes,
 	.mode_count = ARRAY_SIZE(pmx_uart2_modes),
@@ -283,7 +283,7 @@ static struct pmx_dev_mode pmx_touchscreen_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_touchscreen = {
+struct pmx_dev spear320_pmx_touchscreen = {
 	.name = "touchscreen",
 	.modes = pmx_touchscreen_modes,
 	.mode_count = ARRAY_SIZE(pmx_touchscreen_modes),
@@ -306,7 +306,7 @@ static struct pmx_dev_mode pmx_can_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_can = {
+struct pmx_dev spear320_pmx_can = {
 	.name = "can",
 	.modes = pmx_can_modes,
 	.mode_count = ARRAY_SIZE(pmx_can_modes),
@@ -328,7 +328,7 @@ static struct pmx_dev_mode pmx_sdhci_led_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_sdhci_led = {
+struct pmx_dev spear320_pmx_sdhci_led = {
 	.name = "sdhci_led",
 	.modes = pmx_sdhci_led_modes,
 	.mode_count = ARRAY_SIZE(pmx_sdhci_led_modes),
@@ -361,7 +361,7 @@ static struct pmx_dev_mode pmx_pwm0_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_pwm0 = {
+struct pmx_dev spear320_pmx_pwm0 = {
 	.name = "pwm0",
 	.modes = pmx_pwm0_modes,
 	.mode_count = ARRAY_SIZE(pmx_pwm0_modes),
@@ -394,7 +394,7 @@ static struct pmx_dev_mode pmx_pwm1_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_pwm1 = {
+struct pmx_dev spear320_pmx_pwm1 = {
 	.name = "pwm1",
 	.modes = pmx_pwm1_modes,
 	.mode_count = ARRAY_SIZE(pmx_pwm1_modes),
@@ -427,7 +427,7 @@ static struct pmx_dev_mode pmx_pwm2_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_pwm2 = {
+struct pmx_dev spear320_pmx_pwm2 = {
 	.name = "pwm2",
 	.modes = pmx_pwm2_modes,
 	.mode_count = ARRAY_SIZE(pmx_pwm2_modes),
@@ -449,7 +449,7 @@ static struct pmx_dev_mode pmx_pwm3_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_pwm3 = {
+struct pmx_dev spear320_pmx_pwm3 = {
 	.name = "pwm3",
 	.modes = pmx_pwm3_modes,
 	.mode_count = ARRAY_SIZE(pmx_pwm3_modes),
@@ -471,7 +471,7 @@ static struct pmx_dev_mode pmx_ssp1_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_ssp1 = {
+struct pmx_dev spear320_pmx_ssp1 = {
 	.name = "ssp1",
 	.modes = pmx_ssp1_modes,
 	.mode_count = ARRAY_SIZE(pmx_ssp1_modes),
@@ -493,7 +493,7 @@ static struct pmx_dev_mode pmx_ssp2_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_ssp2 = {
+struct pmx_dev spear320_pmx_ssp2 = {
 	.name = "ssp2",
 	.modes = pmx_ssp2_modes,
 	.mode_count = ARRAY_SIZE(pmx_ssp2_modes),
@@ -515,7 +515,7 @@ static struct pmx_dev_mode pmx_mii1_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_mii1 = {
+struct pmx_dev spear320_pmx_mii1 = {
 	.name = "mii1",
 	.modes = pmx_mii1_modes,
 	.mode_count = ARRAY_SIZE(pmx_mii1_modes),
@@ -537,7 +537,7 @@ static struct pmx_dev_mode pmx_smii0_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_smii0 = {
+struct pmx_dev spear320_pmx_smii0 = {
 	.name = "smii0",
 	.modes = pmx_smii0_modes,
 	.mode_count = ARRAY_SIZE(pmx_smii0_modes),
@@ -559,7 +559,7 @@ static struct pmx_dev_mode pmx_smii1_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_smii1 = {
+struct pmx_dev spear320_pmx_smii1 = {
 	.name = "smii1",
 	.modes = pmx_smii1_modes,
 	.mode_count = ARRAY_SIZE(pmx_smii1_modes),
@@ -581,14 +581,14 @@ static struct pmx_dev_mode pmx_i2c1_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_i2c1 = {
+struct pmx_dev spear320_pmx_i2c1 = {
 	.name = "i2c1",
 	.modes = pmx_i2c1_modes,
 	.mode_count = ARRAY_SIZE(pmx_i2c1_modes),
 };
 
 /* pmx driver structure */
-struct pmx_driver pmx_driver = {
+static struct pmx_driver pmx_driver = {
 	.mode_reg = {.address = SPEAR320_MODE_CONFIG_REG, .mask = 0x00000007},
 };
 
@@ -959,7 +959,8 @@ static struct spear_shirq shirq_intrcomm_ras = {
 };
 
 /* spear320 routines */
-void __init spear320_init(void)
+void __init spear320_init(struct pmx_mode *pmx_mode, struct pmx_dev **pmx_devs,
+		u8 pmx_dev_count)
 {
 	void __iomem *base;
 	int ret = 0;
@@ -989,10 +990,13 @@ void __init spear320_init(void)
 			printk(KERN_ERR "Error registering Shared IRQ 4\n");
 	}
 
+	/* pmx initialization */
+	pmx_driver.mode = pmx_mode;
+	pmx_driver.devs = pmx_devs;
+	pmx_driver.devs_count = pmx_dev_count;
+
 	/* This fixes addresses of all pmx devices for spear320 */
 	spear3xx_pmx_init_addr(&pmx_driver, SPEAR320_PAD_MUX_CONFIG_REG);
-
-	/* pmx initialization */
 	ret = pmx_register(&pmx_driver);
 	if (ret)
 		pr_err("padmux: registeration failed. err no: %d\n", ret);
diff --git a/arch/arm/mach-spear3xx/spear320_evb.c b/arch/arm/mach-spear3xx/spear320_evb.c
index 04361fc..eff4fb3 100644
--- a/arch/arm/mach-spear3xx/spear320_evb.c
+++ b/arch/arm/mach-spear3xx/spear320_evb.c
@@ -47,22 +47,22 @@ static struct resource emi_nor_resources[] = {
 /* padmux devices to enable */
 static struct pmx_dev *pmx_devs[] = {
 	/* spear3xx specific devices */
-	&pmx_i2c,
-	&pmx_ssp,
-	&pmx_mii,
-	&pmx_uart0,
+	&spear3xx_pmx_i2c,
+	&spear3xx_pmx_ssp,
+	&spear3xx_pmx_mii,
+	&spear3xx_pmx_uart0,
 
 	/* spear320 specific devices */
-	&pmx_fsmc,
-	&pmx_sdhci,
-	&pmx_i2s,
-	&pmx_uart1,
-	&pmx_uart2,
-	&pmx_can,
-	&pmx_pwm0,
-	&pmx_pwm1,
-	&pmx_pwm2,
-	&pmx_mii1,
+	&spear320_pmx_fsmc,
+	&spear320_pmx_sdhci,
+	&spear320_pmx_i2s,
+	&spear320_pmx_uart1,
+	&spear320_pmx_uart2,
+	&spear320_pmx_can,
+	&spear320_pmx_pwm0,
+	&spear320_pmx_pwm1,
+	&spear320_pmx_pwm2,
+	&spear320_pmx_mii1,
 };
 
 static struct amba_device *amba_devs[] __initdata = {
@@ -117,17 +117,12 @@ static void __init spear320_evb_init(void)
 	/* set sdhci device platform data */
 	sdhci_set_plat_data(&sdhci_device, &sdhci_plat_data);
 
-	/* padmux initialization, must be done before spear320_init */
-	pmx_driver.mode = &auto_net_mii_mode;
-	pmx_driver.devs = pmx_devs;
-	pmx_driver.devs_count = ARRAY_SIZE(pmx_devs);
-
 	/* set nand device's plat data */
 	fsmc_nand_set_plat_data(&nand_device, NULL, 0, NAND_SKIP_BBTSCAN,
 			FSMC_NAND_BW8);
 
 	/* call spear320 machine init function */
-	spear320_init();
+	spear320_init(&auto_net_mii_mode, pmx_devs, ARRAY_SIZE(pmx_devs));
 
 	/* initialize serial nor related data in smi plat data */
 	smi_init_board_info(&smi_device);
diff --git a/arch/arm/mach-spear3xx/spear3xx.c b/arch/arm/mach-spear3xx/spear3xx.c
index 2765d32..8c00c2b 100644
--- a/arch/arm/mach-spear3xx/spear3xx.c
+++ b/arch/arm/mach-spear3xx/spear3xx.c
@@ -310,7 +310,7 @@ static struct pmx_dev_mode pmx_firda_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_firda = {
+struct pmx_dev spear3xx_pmx_firda = {
 	.name = "firda",
 	.modes = pmx_firda_modes,
 	.mode_count = ARRAY_SIZE(pmx_firda_modes),
@@ -332,7 +332,7 @@ static struct pmx_dev_mode pmx_i2c_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_i2c = {
+struct pmx_dev spear3xx_pmx_i2c = {
 	.name = "i2c",
 	.modes = pmx_i2c_modes,
 	.mode_count = ARRAY_SIZE(pmx_i2c_modes),
@@ -354,7 +354,7 @@ static struct pmx_dev_mode pmx_ssp_cs_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_ssp_cs = {
+struct pmx_dev spear3xx_pmx_ssp_cs = {
 	.name = "ssp_chip_selects",
 	.modes = pmx_ssp_cs_modes,
 	.mode_count = ARRAY_SIZE(pmx_ssp_cs_modes),
@@ -376,7 +376,7 @@ static struct pmx_dev_mode pmx_ssp_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_ssp = {
+struct pmx_dev spear3xx_pmx_ssp = {
 	.name = "ssp",
 	.modes = pmx_ssp_modes,
 	.mode_count = ARRAY_SIZE(pmx_ssp_modes),
@@ -398,7 +398,7 @@ static struct pmx_dev_mode pmx_mii_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_mii = {
+struct pmx_dev spear3xx_pmx_mii = {
 	.name = "mii",
 	.modes = pmx_mii_modes,
 	.mode_count = ARRAY_SIZE(pmx_mii_modes),
@@ -420,7 +420,7 @@ static struct pmx_dev_mode pmx_gpio_pin0_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_gpio_pin0 = {
+struct pmx_dev spear3xx_pmx_gpio_pin0 = {
 	.name = "gpio_pin0",
 	.modes = pmx_gpio_pin0_modes,
 	.mode_count = ARRAY_SIZE(pmx_gpio_pin0_modes),
@@ -442,7 +442,7 @@ static struct pmx_dev_mode pmx_gpio_pin1_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_gpio_pin1 = {
+struct pmx_dev spear3xx_pmx_gpio_pin1 = {
 	.name = "gpio_pin1",
 	.modes = pmx_gpio_pin1_modes,
 	.mode_count = ARRAY_SIZE(pmx_gpio_pin1_modes),
@@ -464,7 +464,7 @@ static struct pmx_dev_mode pmx_gpio_pin2_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_gpio_pin2 = {
+struct pmx_dev spear3xx_pmx_gpio_pin2 = {
 	.name = "gpio_pin2",
 	.modes = pmx_gpio_pin2_modes,
 	.mode_count = ARRAY_SIZE(pmx_gpio_pin2_modes),
@@ -486,7 +486,7 @@ static struct pmx_dev_mode pmx_gpio_pin3_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_gpio_pin3 = {
+struct pmx_dev spear3xx_pmx_gpio_pin3 = {
 	.name = "gpio_pin3",
 	.modes = pmx_gpio_pin3_modes,
 	.mode_count = ARRAY_SIZE(pmx_gpio_pin3_modes),
@@ -508,7 +508,7 @@ static struct pmx_dev_mode pmx_gpio_pin4_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_gpio_pin4 = {
+struct pmx_dev spear3xx_pmx_gpio_pin4 = {
 	.name = "gpio_pin4",
 	.modes = pmx_gpio_pin4_modes,
 	.mode_count = ARRAY_SIZE(pmx_gpio_pin4_modes),
@@ -530,7 +530,7 @@ static struct pmx_dev_mode pmx_gpio_pin5_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_gpio_pin5 = {
+struct pmx_dev spear3xx_pmx_gpio_pin5 = {
 	.name = "gpio_pin5",
 	.modes = pmx_gpio_pin5_modes,
 	.mode_count = ARRAY_SIZE(pmx_gpio_pin5_modes),
@@ -552,7 +552,7 @@ static struct pmx_dev_mode pmx_uart0_modem_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_uart0_modem = {
+struct pmx_dev spear3xx_pmx_uart0_modem = {
 	.name = "uart0_modem",
 	.modes = pmx_uart0_modem_modes,
 	.mode_count = ARRAY_SIZE(pmx_uart0_modem_modes),
@@ -574,7 +574,7 @@ static struct pmx_dev_mode pmx_uart0_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_uart0 = {
+struct pmx_dev spear3xx_pmx_uart0 = {
 	.name = "uart0",
 	.modes = pmx_uart0_modes,
 	.mode_count = ARRAY_SIZE(pmx_uart0_modes),
@@ -596,7 +596,7 @@ static struct pmx_dev_mode pmx_timer_3_4_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_timer_3_4 = {
+struct pmx_dev spear3xx_pmx_timer_3_4 = {
 	.name = "timer_3_4",
 	.modes = pmx_timer_3_4_modes,
 	.mode_count = ARRAY_SIZE(pmx_timer_3_4_modes),
@@ -618,7 +618,7 @@ static struct pmx_dev_mode pmx_timer_1_2_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_timer_1_2 = {
+struct pmx_dev spear3xx_pmx_timer_1_2 = {
 	.name = "timer_1_2",
 	.modes = pmx_timer_1_2_modes,
 	.mode_count = ARRAY_SIZE(pmx_timer_1_2_modes),
@@ -641,7 +641,7 @@ static struct pmx_dev_mode pmx_plgpio_0_1_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_plgpio_0_1 = {
+struct pmx_dev spear3xx_pmx_plgpio_0_1 = {
 	.name = "plgpio 0 and 1",
 	.modes = pmx_plgpio_0_1_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_0_1_modes),
@@ -663,7 +663,7 @@ static struct pmx_dev_mode pmx_plgpio_2_3_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_plgpio_2_3 = {
+struct pmx_dev spear3xx_pmx_plgpio_2_3 = {
 	.name = "plgpio 2 and 3",
 	.modes = pmx_plgpio_2_3_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_2_3_modes),
@@ -685,7 +685,7 @@ static struct pmx_dev_mode pmx_plgpio_4_5_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_plgpio_4_5 = {
+struct pmx_dev spear3xx_pmx_plgpio_4_5 = {
 	.name = "plgpio 4 and 5",
 	.modes = pmx_plgpio_4_5_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_4_5_modes),
@@ -707,7 +707,7 @@ static struct pmx_dev_mode pmx_plgpio_6_9_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_plgpio_6_9 = {
+struct pmx_dev spear3xx_pmx_plgpio_6_9 = {
 	.name = "plgpio 6 to 9",
 	.modes = pmx_plgpio_6_9_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_6_9_modes),
@@ -729,7 +729,7 @@ static struct pmx_dev_mode pmx_plgpio_10_27_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_plgpio_10_27 = {
+struct pmx_dev spear3xx_pmx_plgpio_10_27 = {
 	.name = "plgpio 10 to 27",
 	.modes = pmx_plgpio_10_27_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_10_27_modes),
@@ -751,7 +751,7 @@ static struct pmx_dev_mode pmx_plgpio_28_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_plgpio_28 = {
+struct pmx_dev spear3xx_pmx_plgpio_28 = {
 	.name = "plgpio 28",
 	.modes = pmx_plgpio_28_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_28_modes),
@@ -773,7 +773,7 @@ static struct pmx_dev_mode pmx_plgpio_29_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_plgpio_29 = {
+struct pmx_dev spear3xx_pmx_plgpio_29 = {
 	.name = "plgpio 29",
 	.modes = pmx_plgpio_29_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_29_modes),
@@ -795,7 +795,7 @@ static struct pmx_dev_mode pmx_plgpio_30_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_plgpio_30 = {
+struct pmx_dev spear3xx_pmx_plgpio_30 = {
 	.name = "plgpio 30",
 	.modes = pmx_plgpio_30_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_30_modes),
@@ -817,7 +817,7 @@ static struct pmx_dev_mode pmx_plgpio_31_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_plgpio_31 = {
+struct pmx_dev spear3xx_pmx_plgpio_31 = {
 	.name = "plgpio 31",
 	.modes = pmx_plgpio_31_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_31_modes),
@@ -839,7 +839,7 @@ static struct pmx_dev_mode pmx_plgpio_32_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_plgpio_32 = {
+struct pmx_dev spear3xx_pmx_plgpio_32 = {
 	.name = "plgpio 32",
 	.modes = pmx_plgpio_32_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_32_modes),
@@ -861,7 +861,7 @@ static struct pmx_dev_mode pmx_plgpio_33_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_plgpio_33 = {
+struct pmx_dev spear3xx_pmx_plgpio_33 = {
 	.name = "plgpio 33",
 	.modes = pmx_plgpio_33_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_33_modes),
@@ -883,7 +883,7 @@ static struct pmx_dev_mode pmx_plgpio_34_36_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_plgpio_34_36 = {
+struct pmx_dev spear3xx_pmx_plgpio_34_36 = {
 	.name = "plgpio 34 to 36",
 	.modes = pmx_plgpio_34_36_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_34_36_modes),
@@ -905,7 +905,7 @@ static struct pmx_dev_mode pmx_plgpio_37_42_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_plgpio_37_42 = {
+struct pmx_dev spear3xx_pmx_plgpio_37_42 = {
 	.name = "plgpio 37 to 42",
 	.modes = pmx_plgpio_37_42_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_37_42_modes),
@@ -927,7 +927,7 @@ static struct pmx_dev_mode pmx_plgpio_43_44_47_48_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_plgpio_43_44_47_48 = {
+struct pmx_dev spear3xx_pmx_plgpio_43_44_47_48 = {
 	.name = "plgpio 43, 44, 47 and 48",
 	.modes = pmx_plgpio_43_44_47_48_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_43_44_47_48_modes),
@@ -949,7 +949,7 @@ static struct pmx_dev_mode pmx_plgpio_45_46_49_50_modes[] = {
 	},
 };
 
-struct pmx_dev pmx_plgpio_45_46_49_50 = {
+struct pmx_dev spear3xx_pmx_plgpio_45_46_49_50 = {
 	.name = "plgpio 45, 46, 49 and 50",
 	.modes = pmx_plgpio_45_46_49_50_modes,
 	.mode_count = ARRAY_SIZE(pmx_plgpio_45_46_49_50_modes),
-- 
1.7.2.2


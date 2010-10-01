Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab0JAMDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 08:03:21 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:35495 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932157Ab0JAL6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:58:32 -0400
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org, rtc-linux@googlegroups.com,
        a.zummo@towertech.it, dbrownell@users.sourceforge.net,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Viresh Kumar <viresh.kumar@st.com>, shiraz.hashim@st.com,
        vipin.kumar@st.com, deepak.sikri@st.com, armando.visconti@st.com,
        vipulkumar.samar@st.com, rajeev-dlh.kumar@st.com,
        pratyush.anand@st.com, bhupesh.sharma@st.com
Subject: [PATCH V2 55/69] ST SPEAr3xx: Passing pmx devices address from machine *.c files
Date: Fri,  1 Oct 2010 17:26:15 +0530
Message-Id: <694da64e36590aafeb8aa214a85f396a1b4dd542.1285933332.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All spear3xx machines have different pad mux register addresses.
In order to have single image for all spear3xx boards, we need to pass
this address from machine specific files to fix addresses of pmx devs found
in spear3xx.c

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 arch/arm/mach-spear3xx/include/mach/generic.h |   11 +++---
 arch/arm/mach-spear3xx/spear300.c             |   27 +++-----------
 arch/arm/mach-spear3xx/spear310.c             |   11 ++----
 arch/arm/mach-spear3xx/spear320.c             |   31 ++--------------
 arch/arm/mach-spear3xx/spear3xx.c             |   48 +++++++++---------------
 5 files changed, 36 insertions(+), 92 deletions(-)

diff --git a/arch/arm/mach-spear3xx/include/mach/generic.h b/arch/arm/mach-spear3xx/include/mach/generic.h
index 1b97ba8..0412808 100644
--- a/arch/arm/mach-spear3xx/include/mach/generic.h
+++ b/arch/arm/mach-spear3xx/include/mach/generic.h
@@ -50,6 +50,7 @@ void __init spear_setup_timer(void);
 void __init spear3xx_map_io(void);
 void __init spear3xx_init_irq(void);
 void __init spear3xx_init(void);
+void spear3xx_pmx_init_addr(struct pmx_driver *driver, unsigned int addr);
 
 /* pad mux declarations */
 #define PMX_FIRDA_MASK		(1 << 14)
@@ -150,8 +151,8 @@ extern struct pmx_dev pmx_telecom_sdhci_8bit;
 extern struct pmx_dev pmx_gpio1;
 
 /* pad multiplexing support */
-#define PAD_MUX_CONFIG_REG	0x99000000
-#define MODE_CONFIG_REG		0x99000004
+#define SPEAR300_PAD_MUX_CONFIG_REG	0x99000000
+#define SPEAR300_MODE_CONFIG_REG	0x99000004
 
 /* Add spear300 machine function declarations here */
 void __init spear300_init(void);
@@ -183,7 +184,7 @@ extern struct pmx_dev pmx_uart3_4_5;
 extern struct pmx_dev pmx_fsmc;
 extern struct pmx_dev pmx_rs485_0_1;
 extern struct pmx_dev pmx_tdm0;
-#define PAD_MUX_CONFIG_REG	0xB4000008
+#define SPEAR310_PAD_MUX_CONFIG_REG	0xB4000008
 
 /* Add spear310 machine function declarations here */
 void __init spear310_init(void);
@@ -235,8 +236,8 @@ extern struct pmx_dev pmx_smii1;
 extern struct pmx_dev pmx_i2c1;
 
 /* pad multiplexing support */
-#define PAD_MUX_CONFIG_REG	0xB300000C
-#define MODE_CONFIG_REG		0xB3000010
+#define SPEAR320_PAD_MUX_CONFIG_REG	0xB300000C
+#define SPEAR320_MODE_CONFIG_REG	0xB3000010
 
 /* Add spear320 machine function declarations here */
 void __init spear320_init(void);
diff --git a/arch/arm/mach-spear3xx/spear300.c b/arch/arm/mach-spear3xx/spear300.c
index 2671cfd..9885fe9 100644
--- a/arch/arm/mach-spear3xx/spear300.c
+++ b/arch/arm/mach-spear3xx/spear300.c
@@ -118,7 +118,6 @@ struct pmx_mode caml_lcd_mode = {
 /* Pad multiplexing for FSMC 2 NAND devices */
 static struct pmx_mux_reg pmx_fsmc_2_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_FIRDA_MASK,
 		.value = 0,
 	},
@@ -142,7 +141,6 @@ struct pmx_dev pmx_fsmc_2_chips = {
 /* Pad multiplexing for FSMC 4 NAND devices */
 static struct pmx_mux_reg pmx_fsmc_4_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_FIRDA_MASK | PMX_UART0_MASK,
 		.value = 0,
 	},
@@ -166,7 +164,6 @@ struct pmx_dev pmx_fsmc_4_chips = {
 /* Pad multiplexing for Keyboard device */
 static struct pmx_mux_reg pmx_kbd_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = 0x0,
 		.value = 0,
 	},
@@ -192,7 +189,6 @@ struct pmx_dev pmx_keyboard = {
 /* Pad multiplexing for CLCD device */
 static struct pmx_mux_reg pmx_clcd_pfmode_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK,
 		.value = 0,
 	},
@@ -200,7 +196,6 @@ static struct pmx_mux_reg pmx_clcd_pfmode_mux[] = {
 
 static struct pmx_mux_reg pmx_clcd_lcdmode_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_3_4_MASK,
 		.value = 0,
 	},
@@ -228,7 +223,6 @@ struct pmx_dev pmx_clcd = {
 /* Pad multiplexing for Telecom GPIO device */
 static struct pmx_mux_reg pmx_gpio_lcdmode_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = 0,
 	},
@@ -236,7 +230,6 @@ static struct pmx_mux_reg pmx_gpio_lcdmode_mux[] = {
 
 static struct pmx_mux_reg pmx_gpio_fonemode_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK | PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK,
 		.value = 0,
 	},
@@ -244,7 +237,6 @@ static struct pmx_mux_reg pmx_gpio_fonemode_mux[] = {
 
 static struct pmx_mux_reg pmx_gpio_atai2smode_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK | PMX_TIMER_3_4_MASK,
 		.value = 0,
 	},
@@ -252,7 +244,6 @@ static struct pmx_mux_reg pmx_gpio_atai2smode_mux[] = {
 
 static struct pmx_mux_reg pmx_gpio_lendfonemode_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK | PMX_TIMER_1_2_MASK,
 		.value = 0,
 	},
@@ -260,7 +251,6 @@ static struct pmx_mux_reg pmx_gpio_lendfonemode_mux[] = {
 
 static struct pmx_mux_reg pmx_gpio_atawi2smode_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK | PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK
 			| PMX_UART0_MODEM_MASK,
 		.value = 0,
@@ -300,7 +290,6 @@ struct pmx_dev pmx_telecom_gpio = {
 /* Pad multiplexing for TDM device */
 static struct pmx_mux_reg pmx_tdm_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK | PMX_SSP_CS_MASK,
 		.value = 0,
 	},
@@ -327,7 +316,6 @@ struct pmx_dev pmx_telecom_tdm = {
 /* Pad multiplexing for spi cs i2c device */
 static struct pmx_mux_reg pmx_spi_cs_i2c_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK,
 		.value = 0,
 	},
@@ -352,7 +340,6 @@ struct pmx_dev pmx_telecom_spi_cs_i2c_clk = {
 
 static struct pmx_mux_reg pmx_caml_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = 0,
 	},
@@ -360,7 +347,6 @@ static struct pmx_mux_reg pmx_caml_mux[] = {
 
 static struct pmx_mux_reg pmx_camu_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK | PMX_MII_MASK,
 		.value = 0,
 	},
@@ -387,7 +373,6 @@ struct pmx_dev pmx_telecom_camera = {
 /* Pad multiplexing for dac device */
 static struct pmx_mux_reg pmx_dac_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK,
 		.value = 0,
 	},
@@ -411,7 +396,6 @@ struct pmx_dev pmx_telecom_dac = {
 /* Pad multiplexing for spi cs i2c device */
 static struct pmx_mux_reg pmx_i2s_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK,
 		.value = 0,
 	},
@@ -437,7 +421,6 @@ struct pmx_dev pmx_telecom_i2s = {
 /* Pad multiplexing for bootpins device */
 static struct pmx_mux_reg pmx_bootpins_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK | PMX_TIMER_1_2_MASK |
 			PMX_TIMER_3_4_MASK,
 		.value = 0,
@@ -461,7 +444,6 @@ struct pmx_dev pmx_telecom_boot_pins = {
 /* Pad multiplexing for sdhci 4bit device */
 static struct pmx_mux_reg pmx_sdhci_4bit_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN0_MASK | PMX_GPIO_PIN1_MASK |
 			PMX_GPIO_PIN2_MASK | PMX_GPIO_PIN3_MASK |
 			PMX_GPIO_PIN4_MASK | PMX_GPIO_PIN5_MASK,
@@ -490,7 +472,6 @@ struct pmx_dev pmx_telecom_sdhci_4bit = {
 /* Pad multiplexing for spi cs i2c device */
 static struct pmx_mux_reg pmx_sdhci_8bit_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN0_MASK | PMX_GPIO_PIN1_MASK |
 			PMX_GPIO_PIN2_MASK | PMX_GPIO_PIN3_MASK |
 			PMX_GPIO_PIN4_MASK | PMX_GPIO_PIN5_MASK | PMX_MII_MASK,
@@ -518,7 +499,6 @@ struct pmx_dev pmx_telecom_sdhci_8bit = {
 /* Pad multiplexing for spi cs i2c device */
 static struct pmx_mux_reg pmx_gpio1_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK | PMX_TIMER_1_2_MASK |
 			PMX_TIMER_3_4_MASK,
 		.value = 0,
@@ -541,7 +521,7 @@ struct pmx_dev pmx_gpio1 = {
 
 /* pmx driver structure */
 struct pmx_driver pmx_driver = {
-	.mode_reg = {.address = MODE_CONFIG_REG, .mask = 0x0000000f},
+	.mode_reg = {.address = SPEAR300_MODE_CONFIG_REG, .mask = 0x0000000f},
 };
 
 /* Add spear300 specific devices here */
@@ -777,7 +757,7 @@ struct spear_shirq shirq_ras1 = {
 void sdhci_i2s_mem_enable(u8 mask)
 {
 	u32 val;
-	void __iomem *config = ioremap(MODE_CONFIG_REG, SZ_16);
+	void __iomem *config = ioremap(SPEAR300_MODE_CONFIG_REG, SZ_16);
 	if (!config) {
 		pr_debug("sdhci_i2s_enb: ioremap fail\n");
 		return;
@@ -809,6 +789,9 @@ void __init spear300_init(void)
 			printk(KERN_ERR "Error registering Shared IRQ\n");
 	}
 
+	/* This fixes addresses of all pmx devices for spear300 */
+	spear3xx_pmx_init_addr(&pmx_driver, SPEAR300_PAD_MUX_CONFIG_REG);
+
 	/* pmx initialization */
 	ret = pmx_register(&pmx_driver);
 	if (ret)
diff --git a/arch/arm/mach-spear3xx/spear310.c b/arch/arm/mach-spear3xx/spear310.c
index 79f7105..be2f9de 100644
--- a/arch/arm/mach-spear3xx/spear310.c
+++ b/arch/arm/mach-spear3xx/spear310.c
@@ -26,7 +26,6 @@
 /* Pad multiplexing for emi_cs_0_1_4_5 devices */
 static struct pmx_mux_reg pmx_emi_cs_0_1_4_5_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_3_4_MASK,
 		.value = 0,
 	},
@@ -48,7 +47,6 @@ struct pmx_dev pmx_emi_cs_0_1_4_5 = {
 /* Pad multiplexing for emi_cs_2_3 devices */
 static struct pmx_mux_reg pmx_emi_cs_2_3_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK,
 		.value = 0,
 	},
@@ -70,7 +68,6 @@ struct pmx_dev pmx_emi_cs_2_3 = {
 /* Pad multiplexing for uart1 device */
 static struct pmx_mux_reg pmx_uart1_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_FIRDA_MASK,
 		.value = 0,
 	},
@@ -92,7 +89,6 @@ struct pmx_dev pmx_uart1 = {
 /* Pad multiplexing for uart2 device */
 static struct pmx_mux_reg pmx_uart2_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK,
 		.value = 0,
 	},
@@ -114,7 +110,6 @@ struct pmx_dev pmx_uart2 = {
 /* Pad multiplexing for uart3_4_5 devices */
 static struct pmx_mux_reg pmx_uart3_4_5_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK,
 		.value = 0,
 	},
@@ -136,7 +131,6 @@ struct pmx_dev pmx_uart3_4_5 = {
 /* Pad multiplexing for fsmc device */
 static struct pmx_mux_reg pmx_fsmc_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_SSP_CS_MASK,
 		.value = 0,
 	},
@@ -158,7 +152,6 @@ struct pmx_dev pmx_fsmc = {
 /* Pad multiplexing for rs485_0_1 devices */
 static struct pmx_mux_reg pmx_rs485_0_1_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = 0,
 	},
@@ -180,7 +173,6 @@ struct pmx_dev pmx_rs485_0_1 = {
 /* Pad multiplexing for tdm0 device */
 static struct pmx_mux_reg pmx_tdm0_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = 0,
 	},
@@ -523,6 +515,9 @@ void __init spear310_init(void)
 			printk(KERN_ERR "Error registering Shared IRQ 4\n");
 	}
 
+	/* This fixes addresses of all pmx devices for spear310 */
+	spear3xx_pmx_init_addr(&pmx_driver, SPEAR310_PAD_MUX_CONFIG_REG);
+
 	/* pmx initialization */
 	ret = pmx_register(&pmx_driver);
 	if (ret)
diff --git a/arch/arm/mach-spear3xx/spear320.c b/arch/arm/mach-spear3xx/spear320.c
index 8481955..bd308b8 100644
--- a/arch/arm/mach-spear3xx/spear320.c
+++ b/arch/arm/mach-spear3xx/spear320.c
@@ -58,7 +58,6 @@ struct pmx_mode small_printers_mode = {
 /* Pad multiplexing for CLCD device */
 static struct pmx_mux_reg pmx_clcd_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = 0x0,
 		.value = 0,
 	},
@@ -81,7 +80,6 @@ struct pmx_dev pmx_clcd = {
 /* Pad multiplexing for EMI (Parallel NOR flash) device */
 static struct pmx_mux_reg pmx_emi_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK,
 		.value = 0,
 	},
@@ -104,7 +102,6 @@ struct pmx_dev pmx_emi = {
 /* Pad multiplexing for FSMC (NAND flash) device */
 static struct pmx_mux_reg pmx_fsmc_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = 0x0,
 		.value = 0,
 	},
@@ -127,7 +124,6 @@ struct pmx_dev pmx_fsmc = {
 /* Pad multiplexing for SPP device */
 static struct pmx_mux_reg pmx_spp_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = 0x0,
 		.value = 0,
 	},
@@ -150,7 +146,6 @@ struct pmx_dev pmx_spp = {
 /* Pad multiplexing for SDHCI device */
 static struct pmx_mux_reg pmx_sdhci_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK,
 		.value = 0,
 	},
@@ -174,7 +169,6 @@ struct pmx_dev pmx_sdhci = {
 /* Pad multiplexing for I2S device */
 static struct pmx_mux_reg pmx_i2s_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK,
 		.value = 0,
 	},
@@ -197,7 +191,6 @@ struct pmx_dev pmx_i2s = {
 /* Pad multiplexing for UART1 device */
 static struct pmx_mux_reg pmx_uart1_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN0_MASK | PMX_GPIO_PIN1_MASK,
 		.value = 0,
 	},
@@ -220,7 +213,6 @@ struct pmx_dev pmx_uart1 = {
 /* Pad multiplexing for UART1 Modem device */
 static struct pmx_mux_reg pmx_uart1_modem_autoexp_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK |
 			PMX_SSP_CS_MASK,
 		.value = 0,
@@ -229,7 +221,6 @@ static struct pmx_mux_reg pmx_uart1_modem_autoexp_mux[] = {
 
 static struct pmx_mux_reg pmx_uart1_modem_smallpri_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN3_MASK | PMX_GPIO_PIN4_MASK |
 			PMX_GPIO_PIN5_MASK | PMX_SSP_CS_MASK,
 		.value = 0,
@@ -257,7 +248,6 @@ struct pmx_dev pmx_uart1_modem = {
 /* Pad multiplexing for UART2 device */
 static struct pmx_mux_reg pmx_uart2_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_FIRDA_MASK,
 		.value = 0,
 	},
@@ -280,7 +270,6 @@ struct pmx_dev pmx_uart2 = {
 /* Pad multiplexing for Touchscreen device */
 static struct pmx_mux_reg pmx_touchscreen_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_SSP_CS_MASK,
 		.value = 0,
 	},
@@ -303,7 +292,6 @@ struct pmx_dev pmx_touchscreen = {
 /* Pad multiplexing for CAN device */
 static struct pmx_mux_reg pmx_can_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN2_MASK | PMX_GPIO_PIN3_MASK |
 			PMX_GPIO_PIN4_MASK | PMX_GPIO_PIN5_MASK,
 		.value = 0,
@@ -327,7 +315,6 @@ struct pmx_dev pmx_can = {
 /* Pad multiplexing for SDHCI LED device */
 static struct pmx_mux_reg pmx_sdhci_led_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_SSP_CS_MASK,
 		.value = 0,
 	},
@@ -350,7 +337,6 @@ struct pmx_dev pmx_sdhci_led = {
 /* Pad multiplexing for PWM0 device */
 static struct pmx_mux_reg pmx_pwm0_net_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK,
 		.value = 0,
 	},
@@ -358,7 +344,6 @@ static struct pmx_mux_reg pmx_pwm0_net_mux[] = {
 
 static struct pmx_mux_reg pmx_pwm0_autoexpsmallpri_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = 0,
 	},
@@ -385,7 +370,6 @@ struct pmx_dev pmx_pwm0 = {
 /* Pad multiplexing for PWM1 device */
 static struct pmx_mux_reg pmx_pwm1_net_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK,
 		.value = 0,
 	},
@@ -393,7 +377,6 @@ static struct pmx_mux_reg pmx_pwm1_net_mux[] = {
 
 static struct pmx_mux_reg pmx_pwm1_autoexpsmallpri_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = 0,
 	},
@@ -420,7 +403,6 @@ struct pmx_dev pmx_pwm1 = {
 /* Pad multiplexing for PWM2 device */
 static struct pmx_mux_reg pmx_pwm2_net_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_SSP_CS_MASK,
 		.value = 0,
 	},
@@ -428,7 +410,6 @@ static struct pmx_mux_reg pmx_pwm2_net_mux[] = {
 
 static struct pmx_mux_reg pmx_pwm2_autoexpsmallpri_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = 0,
 	},
@@ -455,7 +436,6 @@ struct pmx_dev pmx_pwm2 = {
 /* Pad multiplexing for PWM3 device */
 static struct pmx_mux_reg pmx_pwm3_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = 0,
 	},
@@ -478,7 +458,6 @@ struct pmx_dev pmx_pwm3 = {
 /* Pad multiplexing for SSP1 device */
 static struct pmx_mux_reg pmx_ssp1_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = 0,
 	},
@@ -501,7 +480,6 @@ struct pmx_dev pmx_ssp1 = {
 /* Pad multiplexing for SSP2 device */
 static struct pmx_mux_reg pmx_ssp2_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = 0,
 	},
@@ -524,7 +502,6 @@ struct pmx_dev pmx_ssp2 = {
 /* Pad multiplexing for mii1 device */
 static struct pmx_mux_reg pmx_mii1_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = 0x0,
 		.value = 0,
 	},
@@ -547,7 +524,6 @@ struct pmx_dev pmx_mii1 = {
 /* Pad multiplexing for smii0 device */
 static struct pmx_mux_reg pmx_smii0_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = 0,
 	},
@@ -570,7 +546,6 @@ struct pmx_dev pmx_smii0 = {
 /* Pad multiplexing for smii1 device */
 static struct pmx_mux_reg pmx_smii1_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = 0,
 	},
@@ -593,7 +568,6 @@ struct pmx_dev pmx_smii1 = {
 /* Pad multiplexing for i2c1 device */
 static struct pmx_mux_reg pmx_i2c1_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = 0x0,
 		.value = 0,
 	},
@@ -615,7 +589,7 @@ struct pmx_dev pmx_i2c1 = {
 
 /* pmx driver structure */
 struct pmx_driver pmx_driver = {
-	.mode_reg = {.address = MODE_CONFIG_REG, .mask = 0x00000007},
+	.mode_reg = {.address = SPEAR320_MODE_CONFIG_REG, .mask = 0x00000007},
 };
 
 /* Add spear320 specific devices here */
@@ -1015,6 +989,9 @@ void __init spear320_init(void)
 			printk(KERN_ERR "Error registering Shared IRQ 4\n");
 	}
 
+	/* This fixes addresses of all pmx devices for spear320 */
+	spear3xx_pmx_init_addr(&pmx_driver, SPEAR320_PAD_MUX_CONFIG_REG);
+
 	/* pmx initialization */
 	ret = pmx_register(&pmx_driver);
 	if (ret)
diff --git a/arch/arm/mach-spear3xx/spear3xx.c b/arch/arm/mach-spear3xx/spear3xx.c
index 45a0774..ec1340c 100644
--- a/arch/arm/mach-spear3xx/spear3xx.c
+++ b/arch/arm/mach-spear3xx/spear3xx.c
@@ -297,7 +297,6 @@ void __init spear3xx_map_io(void)
 /* Pad multiplexing for firda device */
 static struct pmx_mux_reg pmx_firda_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_FIRDA_MASK,
 		.value = PMX_FIRDA_MASK,
 	},
@@ -320,7 +319,6 @@ struct pmx_dev pmx_firda = {
 /* Pad multiplexing for i2c device */
 static struct pmx_mux_reg pmx_i2c_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_I2C_MASK,
 		.value = PMX_I2C_MASK,
 	},
@@ -343,7 +341,6 @@ struct pmx_dev pmx_i2c = {
 /* Pad multiplexing for firda device */
 static struct pmx_mux_reg pmx_ssp_cs_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_SSP_CS_MASK,
 		.value = PMX_SSP_CS_MASK,
 	},
@@ -366,7 +363,6 @@ struct pmx_dev pmx_ssp_cs = {
 /* Pad multiplexing for ssp device */
 static struct pmx_mux_reg pmx_ssp_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_SSP_MASK,
 		.value = PMX_SSP_MASK,
 	},
@@ -389,7 +385,6 @@ struct pmx_dev pmx_ssp = {
 /* Pad multiplexing for mii device */
 static struct pmx_mux_reg pmx_mii_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = PMX_MII_MASK,
 	},
@@ -412,7 +407,6 @@ struct pmx_dev pmx_mii = {
 /* Pad multiplexing for gpio pin0 device */
 static struct pmx_mux_reg pmx_gpio_pin0_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN0_MASK,
 		.value = PMX_GPIO_PIN0_MASK,
 	},
@@ -435,7 +429,6 @@ struct pmx_dev pmx_gpio_pin0 = {
 /* Pad multiplexing for gpio pin1 device */
 static struct pmx_mux_reg pmx_gpio_pin1_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN1_MASK,
 		.value = PMX_GPIO_PIN1_MASK,
 	},
@@ -458,7 +451,6 @@ struct pmx_dev pmx_gpio_pin1 = {
 /* Pad multiplexing for gpio pin2 device */
 static struct pmx_mux_reg pmx_gpio_pin2_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN2_MASK,
 		.value = PMX_GPIO_PIN2_MASK,
 	},
@@ -481,7 +473,6 @@ struct pmx_dev pmx_gpio_pin2 = {
 /* Pad multiplexing for gpio pin3 device */
 static struct pmx_mux_reg pmx_gpio_pin3_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN3_MASK,
 		.value = PMX_GPIO_PIN3_MASK,
 	},
@@ -504,7 +495,6 @@ struct pmx_dev pmx_gpio_pin3 = {
 /* Pad multiplexing for gpio pin4 device */
 static struct pmx_mux_reg pmx_gpio_pin4_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN4_MASK,
 		.value = PMX_GPIO_PIN4_MASK,
 	},
@@ -527,7 +517,6 @@ struct pmx_dev pmx_gpio_pin4 = {
 /* Pad multiplexing for gpio pin5 device */
 static struct pmx_mux_reg pmx_gpio_pin5_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN5_MASK,
 		.value = PMX_GPIO_PIN5_MASK,
 	},
@@ -550,7 +539,6 @@ struct pmx_dev pmx_gpio_pin5 = {
 /* Pad multiplexing for uart0 modem device */
 static struct pmx_mux_reg pmx_uart0_modem_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK,
 		.value = PMX_UART0_MODEM_MASK,
 	},
@@ -573,7 +561,6 @@ struct pmx_dev pmx_uart0_modem = {
 /* Pad multiplexing for uart0 device */
 static struct pmx_mux_reg pmx_uart0_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MASK,
 		.value = PMX_UART0_MASK,
 	},
@@ -596,7 +583,6 @@ struct pmx_dev pmx_uart0 = {
 /* Pad multiplexing for timer 3, 4 device */
 static struct pmx_mux_reg pmx_timer_3_4_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_3_4_MASK,
 		.value = PMX_TIMER_3_4_MASK,
 	},
@@ -619,7 +605,6 @@ struct pmx_dev pmx_timer_3_4 = {
 /* Pad multiplexing for gpio pin0 device */
 static struct pmx_mux_reg pmx_timer_1_2_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK,
 		.value = PMX_TIMER_1_2_MASK,
 	},
@@ -644,7 +629,6 @@ struct pmx_dev pmx_timer_1_2 = {
 /* Pad multiplexing for plgpio_0_1 devices */
 static struct pmx_mux_reg pmx_plgpio_0_1_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_FIRDA_MASK,
 		.value = 0,
 	},
@@ -667,7 +651,6 @@ struct pmx_dev pmx_plgpio_0_1 = {
 /* Pad multiplexing for plgpio_2_3 devices */
 static struct pmx_mux_reg pmx_plgpio_2_3_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MASK,
 		.value = 0,
 	},
@@ -690,7 +673,6 @@ struct pmx_dev pmx_plgpio_2_3 = {
 /* Pad multiplexing for plgpio_4_5 devices */
 static struct pmx_mux_reg pmx_plgpio_4_5_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_I2C_MASK,
 		.value = 0,
 	},
@@ -713,7 +695,6 @@ struct pmx_dev pmx_plgpio_4_5 = {
 /* Pad multiplexing for plgpio_6_9 devices */
 static struct pmx_mux_reg pmx_plgpio_6_9_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_SSP_MASK,
 		.value = 0,
 	},
@@ -736,7 +717,6 @@ struct pmx_dev pmx_plgpio_6_9 = {
 /* Pad multiplexing for plgpio_10_27 devices */
 static struct pmx_mux_reg pmx_plgpio_10_27_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = 0,
 	},
@@ -759,7 +739,6 @@ struct pmx_dev pmx_plgpio_10_27 = {
 /* Pad multiplexing for plgpio_28 devices */
 static struct pmx_mux_reg pmx_plgpio_28_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN0_MASK,
 		.value = 0,
 	},
@@ -782,7 +761,6 @@ struct pmx_dev pmx_plgpio_28 = {
 /* Pad multiplexing for plgpio_29 devices */
 static struct pmx_mux_reg pmx_plgpio_29_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN1_MASK,
 		.value = 0,
 	},
@@ -805,7 +783,6 @@ struct pmx_dev pmx_plgpio_29 = {
 /* Pad multiplexing for plgpio_30 device */
 static struct pmx_mux_reg pmx_plgpio_30_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN2_MASK,
 		.value = 0,
 	},
@@ -828,7 +805,6 @@ struct pmx_dev pmx_plgpio_30 = {
 /* Pad multiplexing for plgpio_31 device */
 static struct pmx_mux_reg pmx_plgpio_31_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN3_MASK,
 		.value = 0,
 	},
@@ -851,7 +827,6 @@ struct pmx_dev pmx_plgpio_31 = {
 /* Pad multiplexing for plgpio_32 device */
 static struct pmx_mux_reg pmx_plgpio_32_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN4_MASK,
 		.value = 0,
 	},
@@ -874,7 +849,6 @@ struct pmx_dev pmx_plgpio_32 = {
 /* Pad multiplexing for plgpio_33 device */
 static struct pmx_mux_reg pmx_plgpio_33_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN5_MASK,
 		.value = 0,
 	},
@@ -897,7 +871,6 @@ struct pmx_dev pmx_plgpio_33 = {
 /* Pad multiplexing for plgpio_34_36 device */
 static struct pmx_mux_reg pmx_plgpio_34_36_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_SSP_CS_MASK,
 		.value = 0,
 	},
@@ -920,7 +893,6 @@ struct pmx_dev pmx_plgpio_34_36 = {
 /* Pad multiplexing for plgpio_37_42 device */
 static struct pmx_mux_reg pmx_plgpio_37_42_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK,
 		.value = 0,
 	},
@@ -943,7 +915,6 @@ struct pmx_dev pmx_plgpio_37_42 = {
 /* Pad multiplexing for plgpio_43_44_47_48 device */
 static struct pmx_mux_reg pmx_plgpio_43_44_47_48_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK,
 		.value = 0,
 	},
@@ -966,7 +937,6 @@ struct pmx_dev pmx_plgpio_43_44_47_48 = {
 /* Pad multiplexing for plgpio_45_46_49_50 device */
 static struct pmx_mux_reg pmx_plgpio_45_46_49_50_mux[] = {
 	{
-		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_3_4_MASK,
 		.value = 0,
 	},
@@ -1017,3 +987,21 @@ static void __init spear3xx_timer_init(void)
 struct sys_timer spear3xx_timer = {
 	.init = spear3xx_timer_init,
 };
+
+/* This fixes addresses of all pmx devices for different machines */
+void spear3xx_pmx_init_addr(struct pmx_driver *driver, unsigned int addr)
+{
+	int i;
+	for (i = 0; i < driver->devs_count; i++) {
+		int j;
+		struct pmx_dev *pdev = driver->devs[i];
+
+		for (j = 0; j < pdev->mode_count; j++) {
+			int k;
+			struct pmx_dev_mode *mode = &pdev->modes[j];
+
+			for (k = 0; k < mode->mux_reg_cnt; k++)
+				mode->mux_regs[k].address = addr;
+		}
+	}
+}
-- 
1.7.2.2


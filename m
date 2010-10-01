Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab0JAMAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 08:00:13 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:49866 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932476Ab0JAMAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 08:00:05 -0400
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org, rtc-linux@googlegroups.com,
        a.zummo@towertech.it, dbrownell@users.sourceforge.net,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Vipin Kumar <vipin.kumar@st.com>, shiraz.hashim@st.com,
        deepak.sikri@st.com, armando.visconti@st.com, vipulkumar.samar@st.com,
        rajeev-dlh.kumar@st.com, pratyush.anand@st.com, bhupesh.sharma@st.com,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V2 54/69] SPEAr : Updating pad multiplexing support
Date: Fri,  1 Oct 2010 17:26:14 +0530
Message-Id: <28d44ee4486a0621725fbad048014785f40e72a3.1285933332.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vipin Kumar <vipin.kumar@st.com>

This patch makes the following changes
-> Addition of SPEAr1310 pad multiplexing devices.
-> A few bugfixes eg. clcd1 and clcd2 removed and clcd/clcd_hires added
-> Support for modifying multiple regiters in different address ranges

Signed-off-by: Vipin Kumar <vipin.kumar@st.com>
Signed-off-by: shiraz hashim <shiraz.hashim@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 arch/arm/mach-spear13xx/include/mach/generic.h |   50 +++-
 arch/arm/mach-spear13xx/include/mach/spear.h   |    3 -
 arch/arm/mach-spear13xx/spear1300.c            |   11 +-
 arch/arm/mach-spear13xx/spear1300_evb.c        |    5 +-
 arch/arm/mach-spear13xx/spear1310.c            |  346 +++++++++++++++++++++++-
 arch/arm/mach-spear13xx/spear1310_evb.c        |   17 +-
 arch/arm/mach-spear13xx/spear13xx.c            |  169 +++++++-----
 arch/arm/mach-spear3xx/include/mach/generic.h  |   12 +-
 arch/arm/mach-spear3xx/include/mach/spear300.h |    1 -
 arch/arm/mach-spear3xx/spear300.c              |   67 ++---
 arch/arm/mach-spear3xx/spear310.c              |   20 +-
 arch/arm/mach-spear3xx/spear320.c              |   61 ++---
 arch/arm/mach-spear3xx/spear3xx.c              |   60 ++--
 arch/arm/plat-spear/include/plat/padmux.h      |   10 +-
 arch/arm/plat-spear/padmux.c                   |   36 ++-
 15 files changed, 626 insertions(+), 242 deletions(-)

diff --git a/arch/arm/mach-spear13xx/include/mach/generic.h b/arch/arm/mach-spear13xx/include/mach/generic.h
index 8a0dc8c..f619b70 100644
--- a/arch/arm/mach-spear13xx/include/mach/generic.h
+++ b/arch/arm/mach-spear13xx/include/mach/generic.h
@@ -24,10 +24,21 @@
 /*
  * Function enable (Pad multiplexing register) offsets
  */
-#define PAD_MUX_CONFIG_REG_0	0x0
-#define PAD_MUX_CONFIG_REG_1	0x4
-#define PAD_MUX_CONFIG_REG_2	0x8
-#define PAD_MUX_CONFIG_REG_3	0xC
+/* Pad multiplexing base */
+#define SPEAR13XX_FUNC_ENB_BASE		UL(0xE0700650)
+#define SPEAR13XX_PCM_CFG_BASE		UL(0xE0700100)
+
+#define PAD_MUX_CONFIG_REG_0	UL(0xE0700650)
+#define PAD_MUX_CONFIG_REG_1	UL(0xE0700654)
+#define PAD_MUX_CONFIG_REG_2	UL(0xE0700658)
+#define PAD_MUX_CONFIG_REG_3	UL(0xE070065C)
+
+#if defined(CONFIG_MACH_SPEAR1310)
+#define SPEAR1310_FUNC_CNTL_0	UL(0x6C800000)
+
+#define PMX_SMII_MASK		(1 << 24)	/* Func cntl reg0 */
+#define PMX_EGPIO7_MASK		(1 << 2)	/* Pcm cfg reg */
+#endif
 
 /* pad mux declarations */
 #define PMX_I2S1_MASK		(1 << 3)
@@ -111,9 +122,8 @@
 #define PMX_KBD_ROWCOL68_MASK	(1 << 4)	/* Offset 4 */
 #define PMX_KBD_COL0_MASK	(1 << 21)	/* Offset 4 */
 #define PMX_KBD_COL1_MASK	(1 << 19)	/* Offset 4 */
-#define PMX_KEYBOARD_MASK	(PMX_KBD_ROW0_MASK | PMX_KBD_ROW1_MASK | \
-		PMX_KBD_ROWCOL25_MASK | PMX_KBD_ROWCOL68_MASK | \
-		PMX_KBD_COL0_MASK | PMX_KBD_COL1_MASK)
+#define PMX_KEYBOARD_6X6_MASK	(PMX_KBD_ROW0_MASK | PMX_KBD_ROW1_MASK | \
+		PMX_KBD_ROWCOL25_MASK | PMX_KBD_COL0_MASK | PMX_KBD_COL1_MASK)
 
 #define PMX_UART0_MASK		(1 << 1)
 #define PMX_I2C_MASK		(1 << 2)
@@ -164,16 +174,18 @@
 /* pad mux devices */
 extern struct pmx_dev pmx_i2c;
 extern struct pmx_dev pmx_ssp;
+extern struct pmx_dev pmx_i2s1;
 extern struct pmx_dev pmx_i2s2;
-extern struct pmx_dev pmx_clcd1;
-extern struct pmx_dev pmx_clcd2;
+extern struct pmx_dev pmx_clcd;
+extern struct pmx_dev pmx_clcd_hires;
 extern struct pmx_dev pmx_egpio_grp;
 extern struct pmx_dev pmx_smi_2_chips;
 extern struct pmx_dev pmx_smi_4_chips;
 extern struct pmx_dev pmx_gmii;
 extern struct pmx_dev pmx_nand_8bit;
 extern struct pmx_dev pmx_nand_16bit;
-extern struct pmx_dev pmx_keyboard;
+extern struct pmx_dev pmx_keyboard_6x6;
+extern struct pmx_dev pmx_keyboard_9x9;
 extern struct pmx_dev pmx_uart0;
 extern struct pmx_dev pmx_uart0_modem;
 extern struct pmx_dev pmx_gpt_0_1;
@@ -182,6 +194,24 @@ extern struct pmx_dev pmx_gpt_1_1;
 extern struct pmx_dev pmx_gpt_1_2;
 extern struct pmx_dev pmx_mcif;
 
+#if defined(CONFIG_MACH_SPEAR1310)
+extern struct pmx_dev pmx_uart1_modem;
+extern struct pmx_dev pmx_uart_1;
+extern struct pmx_dev pmx_uart_2;
+extern struct pmx_dev pmx_uart_3_4_5;
+extern struct pmx_dev pmx_rs485_hdlc_1_2;
+extern struct pmx_dev pmx_tdm_hdlc_1_2;
+extern struct pmx_dev pmx_nand32bit;
+extern struct pmx_dev pmx_fsmc16bit_4_chips;
+extern struct pmx_dev pmx_fsmc32bit_4_chips;
+extern struct pmx_dev pmx_gmii1;
+extern struct pmx_dev pmx_rgmii;
+extern struct pmx_dev pmx_i2c1;
+extern struct pmx_dev pmx_smii_0_1_2;
+extern struct pmx_dev pmx_can;
+extern struct pmx_dev pmx_uart1_modem;
+#endif
+
 /*
  * Each GPT has 2 timer channels
  * Following GPT channels will be used as clock source and clockevent
diff --git a/arch/arm/mach-spear13xx/include/mach/spear.h b/arch/arm/mach-spear13xx/include/mach/spear.h
index 03f9616..d043280 100644
--- a/arch/arm/mach-spear13xx/include/mach/spear.h
+++ b/arch/arm/mach-spear13xx/include/mach/spear.h
@@ -88,9 +88,6 @@
 #define SPEAR13XX_MCIF_CF_BASE		UL(0xB2800000)
 #define SPEAR13XX_MCIF_SDHCI_BASE	UL(0xB3000000)
 
-/* Pad multiplexing base */
-#define SPEAR13XX_FUNC_ENB_BASE		UL(0xE0700650)
-
 /* Debug uart for linux, will be used for debug and uncompress messages */
 #define SPEAR_DBG_UART_BASE		SPEAR13XX_UART_BASE
 #define VA_SPEAR_DBG_UART_BASE		VA_SPEAR13XX_UART_BASE
diff --git a/arch/arm/mach-spear13xx/spear1300.c b/arch/arm/mach-spear13xx/spear1300.c
index 4569cb5..28822a3 100644
--- a/arch/arm/mach-spear13xx/spear1300.c
+++ b/arch/arm/mach-spear13xx/spear1300.c
@@ -27,12 +27,7 @@ void __init spear1300_init(void)
 	spear13xx_init();
 
 	/* pmx initialization */
-	pmx_driver.base = ioremap(SPEAR13XX_FUNC_ENB_BASE, SZ_4K);
-	if (pmx_driver.base) {
-		ret = pmx_register(&pmx_driver);
-		if (ret)
-			pr_err("padmux: registeration failed. err no: %d\n",
-					ret);
-		iounmap(pmx_driver.base);
-	}
+	ret = pmx_register(&pmx_driver);
+	if (ret)
+		pr_err("padmux: registeration failed. err no: %d\n", ret);
 }
diff --git a/arch/arm/mach-spear13xx/spear1300_evb.c b/arch/arm/mach-spear13xx/spear1300_evb.c
index e35a496..ceb3bd0 100644
--- a/arch/arm/mach-spear13xx/spear1300_evb.c
+++ b/arch/arm/mach-spear13xx/spear1300_evb.c
@@ -43,11 +43,10 @@ static struct pmx_dev *pmx_devs[] = {
 	&pmx_i2c,
 	&pmx_i2s1,
 	&pmx_i2s2,
-	&pmx_clcd1,
-	&pmx_clcd2,
+	&pmx_clcd,
 	&pmx_egpio_grp,
 	&pmx_gmii,
-	&pmx_keyboard,
+	&pmx_keyboard_6x6,
 	&pmx_mcif,
 	&pmx_nand_8bit,
 	&pmx_smi_4_chips,
diff --git a/arch/arm/mach-spear13xx/spear1310.c b/arch/arm/mach-spear13xx/spear1310.c
index cd0878e..39ea491 100644
--- a/arch/arm/mach-spear13xx/spear1310.c
+++ b/arch/arm/mach-spear13xx/spear1310.c
@@ -19,6 +19,341 @@
 /* pmx driver structure */
 struct pmx_driver pmx_driver;
 
+/* Pad multiplexing for uart1_modem device */
+static struct pmx_mux_reg pmx_uart1_modem_mux[] = {
+	{
+		.address = PAD_MUX_CONFIG_REG_0,
+		.mask = PMX_I2S1_MASK | PMX_SSP_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_uart1_modem_modes[] = {
+	{
+		.mux_regs = pmx_uart1_modem_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_uart1_modem_mux),
+	},
+};
+
+struct pmx_dev pmx_uart1_modem = {
+	.name = "uart1_modem",
+	.modes = pmx_uart1_modem_modes,
+	.mode_count = ARRAY_SIZE(pmx_uart1_modem_modes),
+};
+
+/* Pad multiplexing for uart1 device */
+static struct pmx_mux_reg pmx_uart1_mux[] = {
+	{
+		.address = PAD_MUX_CONFIG_REG_0,
+		.mask = PMX_SSP_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_uart1_modes[] = {
+	{
+		.mux_regs = pmx_uart1_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_uart1_mux),
+	},
+};
+
+struct pmx_dev pmx_uart_1 = {
+	.name = "uart1",
+	.modes = pmx_uart1_modes,
+	.mode_count = ARRAY_SIZE(pmx_uart1_modes),
+};
+
+/* Pad multiplexing for uart2 device */
+static struct pmx_mux_reg pmx_uart2_mux[] = {
+	{
+		.address = PAD_MUX_CONFIG_REG_0,
+		.mask = PMX_SSP_MASK | PMX_CLCD1_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_uart2_modes[] = {
+	{
+		.mux_regs = pmx_uart2_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_uart2_mux),
+	},
+};
+
+struct pmx_dev pmx_uart_2 = {
+	.name = "uart2",
+	.modes = pmx_uart2_modes,
+	.mode_count = ARRAY_SIZE(pmx_uart2_modes),
+};
+
+/* Pad multiplexing for uart_3_4_5 device */
+static struct pmx_mux_reg pmx_uart_3_4_5_mux[] = {
+	{
+		.address = PAD_MUX_CONFIG_REG_0,
+		.mask = PMX_CLCD1_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_uart_3_4_5_modes[] = {
+	{
+		.mux_regs = pmx_uart_3_4_5_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_uart_3_4_5_mux),
+	},
+};
+
+struct pmx_dev pmx_uart_3_4_5 = {
+	.name = "uart_3_4_5",
+	.modes = pmx_uart_3_4_5_modes,
+	.mode_count = ARRAY_SIZE(pmx_uart_3_4_5_modes),
+};
+
+/* Pad multiplexing for rs485_hdlc_1_2 device */
+static struct pmx_mux_reg pmx_rs485_hdlc_1_2_mux[] = {
+	{
+		.address = PAD_MUX_CONFIG_REG_0,
+		.mask = PMX_CLCD1_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_rs485_hdlc_1_2_modes[] = {
+	{
+		.mux_regs = pmx_rs485_hdlc_1_2_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_rs485_hdlc_1_2_mux),
+	},
+};
+
+struct pmx_dev pmx_rs485_hdlc_1_2 = {
+	.name = "rs485_hdlc_1_2",
+	.modes = pmx_rs485_hdlc_1_2_modes,
+	.mode_count = ARRAY_SIZE(pmx_rs485_hdlc_1_2_modes),
+};
+
+/* Pad multiplexing for tdm_hdlc_1_2 device */
+static struct pmx_mux_reg pmx_tdm_hdlc_1_2_mux[] = {
+	{
+		.address = PAD_MUX_CONFIG_REG_0,
+		.mask = PMX_CLCD1_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_tdm_hdlc_1_2_modes[] = {
+	{
+		.mux_regs = pmx_tdm_hdlc_1_2_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_tdm_hdlc_1_2_mux),
+	},
+};
+
+struct pmx_dev pmx_tdm_hdlc_1_2 = {
+	.name = "tdm_hdlc_1_2",
+	.modes = pmx_tdm_hdlc_1_2_modes,
+	.mode_count = ARRAY_SIZE(pmx_tdm_hdlc_1_2_modes),
+};
+
+/* Pad multiplexing for fsmc32bit device */
+static struct pmx_mux_reg pmx_fsmc32bit_mux[] = {
+	{
+		.address = PAD_MUX_CONFIG_REG_0,
+		.mask = PMX_EGPIO_0_GRP_MASK | PMX_SMI_MASK | \
+			PMX_NAND16BIT4DEV_0_MASK | PMX_CLCD1_MASK,
+		.value = 0,
+	}, {
+		.address = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_KEYBOARD_6X6_MASK | PMX_NAND16BIT4DEV_1_MASK,
+		.value = 0,
+	}, {
+		.address = SPEAR13XX_PCM_CFG_BASE,
+		.mask = PMX_EGPIO7_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_fsmc32bit_modes[] = {
+	{
+		.mux_regs = pmx_fsmc32bit_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_fsmc32bit_mux),
+	},
+};
+
+struct pmx_dev pmx_fsmc32bit_4_chips = {
+	.name = "fsmc32bit",
+	.modes = pmx_fsmc32bit_modes,
+	.mode_count = ARRAY_SIZE(pmx_fsmc32bit_modes),
+};
+
+/* Pad multiplexing for fsmc16bit device */
+static struct pmx_mux_reg pmx_fsmc16bit_mux[] = {
+	{
+		.address = PAD_MUX_CONFIG_REG_0,
+		.mask = PMX_NAND16BIT4DEV_0_MASK,
+		.value = 0,
+	}, {
+		.address = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_KEYBOARD_6X6_MASK | PMX_NAND16BIT4DEV_1_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_fsmc16bit_modes[] = {
+	{
+		.mux_regs = pmx_fsmc16bit_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_fsmc16bit_mux),
+	},
+};
+
+struct pmx_dev pmx_fsmc16bit_4_chips = {
+	.name = "fsmc16bit",
+	.modes = pmx_fsmc16bit_modes,
+	.mode_count = ARRAY_SIZE(pmx_fsmc16bit_modes),
+};
+
+/* Pad multiplexing for gmii1 device */
+static struct pmx_mux_reg pmx_gmii1_mux[] = {
+	{
+		.address = PAD_MUX_CONFIG_REG_0,
+		.mask = PMX_GMII_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_gmii1_modes[] = {
+	{
+		.mux_regs = pmx_gmii1_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_gmii1_mux),
+	},
+};
+
+struct pmx_dev pmx_gmii1 = {
+	.name = "gmii1",
+	.modes = pmx_gmii1_modes,
+	.mode_count = ARRAY_SIZE(pmx_gmii1_modes),
+};
+
+/* Pad multiplexing for rgmii device */
+static struct pmx_mux_reg pmx_rgmii_mux[] = {
+	{
+		.address = PAD_MUX_CONFIG_REG_0,
+		.mask = PMX_GMII_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_rgmii_modes[] = {
+	{
+		.mux_regs = pmx_rgmii_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_rgmii_mux),
+	},
+};
+
+struct pmx_dev pmx_rgmii = {
+	.name = "rgmii",
+	.modes = pmx_rgmii_modes,
+	.mode_count = ARRAY_SIZE(pmx_rgmii_modes),
+};
+
+/* Pad multiplexing for i2c1 device */
+static struct pmx_mux_reg pmx_i2c1_mux[] = {
+	{
+		.address = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_SMINCS2_MASK | PMX_SMINCS3_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_i2c1_modes[] = {
+	{
+		.mux_regs = pmx_i2c1_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_i2c1_mux),
+	},
+};
+
+struct pmx_dev pmx_i2c1 = {
+	.name = "i2c1",
+	.modes = pmx_i2c1_modes,
+	.mode_count = ARRAY_SIZE(pmx_i2c1_modes),
+};
+
+/* Pad multiplexing for smii_0_1_2 device */
+static struct pmx_mux_reg pmx_smii_0_1_2_mux[] = {
+	{
+		.address = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_CLCD2_MASK | PMX_KBD_ROWCOL68_MASK | \
+			PMX_EGPIO_1_GRP_MASK | PMX_GPT0_TMR1_MASK | \
+			PMX_GPT0_TMR2_MASK | PMX_GPT1_TMR1_MASK | \
+			PMX_GPT1_TMR2_MASK,
+		.value = 0,
+	}, {
+		.address = SPEAR1310_FUNC_CNTL_0,
+		.mask = PMX_SMII_MASK,
+		.value = PMX_SMII_MASK,
+	},
+};
+
+static struct pmx_dev_mode pmx_smii_0_1_2_modes[] = {
+	{
+		.mux_regs = pmx_smii_0_1_2_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_smii_0_1_2_mux),
+	},
+};
+
+struct pmx_dev pmx_smii_0_1_2 = {
+	.name = "smii_0_1_2",
+	.modes = pmx_smii_0_1_2_modes,
+	.mode_count = ARRAY_SIZE(pmx_smii_0_1_2_modes),
+};
+
+/* Pad multiplexing for pci1 device */
+static struct pmx_mux_reg pmx_pci1_mux[] = {
+	{
+		.address = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_CLCD2_MASK | PMX_KBD_ROWCOL68_MASK | \
+			PMX_EGPIO_1_GRP_MASK | PMX_GPT0_TMR1_MASK | \
+			PMX_GPT0_TMR2_MASK | PMX_GPT1_TMR1_MASK | \
+			PMX_GPT1_TMR2_MASK,
+		.value = 0,
+	}, {
+		.address = SPEAR1310_FUNC_CNTL_0,
+		.mask = PMX_SMII_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_pci1_modes[] = {
+	{
+		.mux_regs = pmx_pci1_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_pci1_mux),
+	},
+};
+
+struct pmx_dev pmx_pci1 = {
+	.name = "pci1",
+	.modes = pmx_pci1_modes,
+	.mode_count = ARRAY_SIZE(pmx_pci1_modes),
+};
+
+/* Pad multiplexing for can device */
+static struct pmx_mux_reg pmx_can_mux[] = {
+	{
+		.address = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_I2S2_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_can_modes[] = {
+	{
+		.mux_regs = pmx_can_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_can_mux),
+	},
+};
+
+struct pmx_dev pmx_can = {
+	.name = "can",
+	.modes = pmx_can_modes,
+	.mode_count = ARRAY_SIZE(pmx_can_modes),
+};
+
 /* Add spear1310 specific devices here */
 
 /* CAN device registeration */
@@ -66,12 +401,7 @@ void __init spear1310_init(void)
 	spear13xx_init();
 
 	/* pmx initialization */
-	pmx_driver.base = ioremap(SPEAR13XX_FUNC_ENB_BASE, SZ_4K);
-	if (pmx_driver.base) {
-		ret = pmx_register(&pmx_driver);
-		if (ret)
-			pr_err("padmux: registeration failed. err no: %d\n",
-					ret);
-		iounmap(pmx_driver.base);
-	}
+	ret = pmx_register(&pmx_driver);
+	if (ret)
+		pr_err("padmux: registeration failed. err no: %d\n", ret);
 }
diff --git a/arch/arm/mach-spear13xx/spear1310_evb.c b/arch/arm/mach-spear13xx/spear1310_evb.c
index 87f27cf..c4b83b2 100644
--- a/arch/arm/mach-spear13xx/spear1310_evb.c
+++ b/arch/arm/mach-spear13xx/spear1310_evb.c
@@ -41,19 +41,24 @@ static struct pmx_dev *pmx_devs[] = {
 	/* spear13xx specific devices */
 	&pmx_i2c,
 	&pmx_i2s1,
-	&pmx_i2s2,
-	&pmx_clcd1,
-	&pmx_clcd2,
 	&pmx_egpio_grp,
 	&pmx_gmii,
-	&pmx_keyboard,
+	&pmx_keyboard_6x6,
 	&pmx_mcif,
 	&pmx_nand_8bit,
-	&pmx_smi_4_chips,
-	&pmx_ssp,
+	&pmx_smi_2_chips,
 	&pmx_uart0,
 
 	/* spear1310 specific devices */
+	&pmx_can,
+	&pmx_i2c1,
+	&pmx_smii_0_1_2,
+	&pmx_fsmc16bit_4_chips,
+	&pmx_rs485_hdlc_1_2,
+	&pmx_tdm_hdlc_1_2,
+	&pmx_uart_1,
+	&pmx_uart_2,
+	&pmx_uart_3_4_5,
 };
 
 static struct amba_device *amba_devs[] __initdata = {
diff --git a/arch/arm/mach-spear13xx/spear13xx.c b/arch/arm/mach-spear13xx/spear13xx.c
index 623dffd..fd66db1 100644
--- a/arch/arm/mach-spear13xx/spear13xx.c
+++ b/arch/arm/mach-spear13xx/spear13xx.c
@@ -644,7 +644,7 @@ struct sys_timer spear13xx_timer = {
 /* Pad multiplexing for i2c device */
 static struct pmx_mux_reg pmx_i2c_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG_0,
+		.address = PAD_MUX_CONFIG_REG_0,
 		.mask = PMX_I2C_MASK,
 		.value = PMX_I2C_MASK,
 	},
@@ -666,7 +666,7 @@ struct pmx_dev pmx_i2c = {
 /* Pad multiplexing for ssp device */
 static struct pmx_mux_reg pmx_ssp_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG_0,
+		.address = PAD_MUX_CONFIG_REG_0,
 		.mask = PMX_SSP_MASK,
 		.value = PMX_SSP_MASK,
 	},
@@ -688,7 +688,7 @@ struct pmx_dev pmx_ssp = {
 /* Pad multiplexing for i2s1 device */
 static struct pmx_mux_reg pmx_i2s1_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG_0,
+		.address = PAD_MUX_CONFIG_REG_0,
 		.mask = PMX_I2S1_MASK,
 		.value = PMX_I2S1_MASK,
 	},
@@ -710,7 +710,7 @@ struct pmx_dev pmx_i2s1 = {
 /* Pad multiplexing for i2s2 device */
 static struct pmx_mux_reg pmx_i2s2_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG_1,
+		.address = PAD_MUX_CONFIG_REG_1,
 		.mask = PMX_I2S2_MASK,
 		.value = PMX_I2S2_MASK,
 	},
@@ -729,48 +729,52 @@ struct pmx_dev pmx_i2s2 = {
 	.mode_count = ARRAY_SIZE(pmx_i2s2_modes),
 };
 
-/* Pad multiplexing for clcd1 device */
-static struct pmx_mux_reg pmx_clcd1_mux[] = {
+/* Pad multiplexing for clcd device */
+static struct pmx_mux_reg pmx_clcd_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG_0,
+		.address = PAD_MUX_CONFIG_REG_0,
 		.mask = PMX_CLCD1_MASK,
 		.value = PMX_CLCD1_MASK,
 	},
 };
 
-static struct pmx_dev_mode pmx_clcd1_modes[] = {
+static struct pmx_dev_mode pmx_clcd_modes[] = {
 	{
-		.mux_regs = pmx_clcd1_mux,
-		.mux_reg_cnt = ARRAY_SIZE(pmx_clcd1_mux),
+		.mux_regs = pmx_clcd_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_clcd_mux),
 	},
 };
 
-struct pmx_dev pmx_clcd1 = {
-	.name = "clcd1",
-	.modes = pmx_clcd1_modes,
-	.mode_count = ARRAY_SIZE(pmx_clcd1_modes),
+struct pmx_dev pmx_clcd = {
+	.name = "clcd",
+	.modes = pmx_clcd_modes,
+	.mode_count = ARRAY_SIZE(pmx_clcd_modes),
 };
 
-/* Pad multiplexing for clcd2 device */
-static struct pmx_mux_reg pmx_clcd2_mux[] = {
+/* Pad multiplexing for clcd_hires device */
+static struct pmx_mux_reg pmx_clcd_hires_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG_1,
+		.address = PAD_MUX_CONFIG_REG_0,
+		.mask = PMX_CLCD1_MASK,
+		.value = PMX_CLCD1_MASK,
+	}, {
+		.address = PAD_MUX_CONFIG_REG_1,
 		.mask = PMX_CLCD2_MASK,
 		.value = PMX_CLCD2_MASK,
 	},
 };
 
-static struct pmx_dev_mode pmx_clcd2_modes[] = {
+static struct pmx_dev_mode pmx_clcd_hires_modes[] = {
 	{
-		.mux_regs = pmx_clcd2_mux,
-		.mux_reg_cnt = ARRAY_SIZE(pmx_clcd2_mux),
+		.mux_regs = pmx_clcd_hires_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_clcd_hires_mux),
 	},
 };
 
-struct pmx_dev pmx_clcd2 = {
-	.name = "clcd2",
-	.modes = pmx_clcd2_modes,
-	.mode_count = ARRAY_SIZE(pmx_clcd2_modes),
+struct pmx_dev pmx_clcd_hires = {
+	.name = "clcd_high_res",
+	.modes = pmx_clcd_hires_modes,
+	.mode_count = ARRAY_SIZE(pmx_clcd_hires_modes),
 };
 
 /*
@@ -779,11 +783,11 @@ struct pmx_dev pmx_clcd2 = {
  */
 static struct pmx_mux_reg pmx_egpio_grp_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG_0,
+		.address = PAD_MUX_CONFIG_REG_0,
 		.mask = PMX_EGPIO_0_GRP_MASK,
 		.value = PMX_EGPIO_0_GRP_MASK,
 	}, {
-		.offset = PAD_MUX_CONFIG_REG_1,
+		.address = PAD_MUX_CONFIG_REG_1,
 		.mask = PMX_EGPIO_1_GRP_MASK,
 		.value = PMX_EGPIO_1_GRP_MASK,
 	},
@@ -805,7 +809,7 @@ struct pmx_dev pmx_egpio_grp = {
 /* Pad multiplexing for smi 2 chips device */
 static struct pmx_mux_reg pmx_smi_2_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG_0,
+		.address = PAD_MUX_CONFIG_REG_0,
 		.mask = PMX_SMI_MASK,
 		.value = PMX_SMI_MASK,
 	},
@@ -827,11 +831,11 @@ struct pmx_dev pmx_smi_2_chips = {
 /* Pad multiplexing for smi 4 chips device */
 static struct pmx_mux_reg pmx_smi_4_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG_0,
+		.address = PAD_MUX_CONFIG_REG_0,
 		.mask = PMX_SMI_MASK,
 		.value = PMX_SMI_MASK,
 	}, {
-		.offset = PAD_MUX_CONFIG_REG_1,
+		.address = PAD_MUX_CONFIG_REG_1,
 		.mask = PMX_SMINCS2_MASK | PMX_SMINCS3_MASK,
 		.value = PMX_SMINCS2_MASK | PMX_SMINCS3_MASK,
 	},
@@ -853,7 +857,7 @@ struct pmx_dev pmx_smi_4_chips = {
 /* Pad multiplexing for gmii device */
 static struct pmx_mux_reg pmx_gmii_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG_0,
+		.address = PAD_MUX_CONFIG_REG_0,
 		.mask = PMX_GMII_MASK,
 		.value = PMX_GMII_MASK,
 	},
@@ -875,13 +879,13 @@ struct pmx_dev pmx_gmii = {
 /* Pad multiplexing for nand 8bit (4 chips) */
 static struct pmx_mux_reg pmx_nand8_4_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG_0,
+		.address = PAD_MUX_CONFIG_REG_0,
 		.mask = PMX_NAND8BIT4DEV_0_MASK,
 		.value = PMX_NAND8BIT4DEV_0_MASK,
 	}, {
-		.offset = PAD_MUX_CONFIG_REG_1,
-		.mask = PMX_NAND8BIT4DEV_1_MASK,
-		.value = PMX_NAND8BIT4DEV_1_MASK,
+		.address = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_NAND8BIT4DEV_1_MASK | PMX_KEYBOARD_6X6_MASK,
+		.value = PMX_NAND8BIT4DEV_1_MASK | PMX_KEYBOARD_6X6_MASK,
 	},
 };
 
@@ -898,16 +902,16 @@ struct pmx_dev pmx_nand_8bit_4_chips = {
 	.mode_count = ARRAY_SIZE(pmx_nand8_4_modes),
 };
 
-/* Pad multiplexing for nand 8bit device */
+/* Pad multiplexing for nand 8bit device (cs0 only) */
 static struct pmx_mux_reg pmx_nand8_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG_0,
+		.address = PAD_MUX_CONFIG_REG_0,
 		.mask = PMX_NAND8BIT_0_MASK,
 		.value = PMX_NAND8BIT_0_MASK,
 	}, {
-		.offset = PAD_MUX_CONFIG_REG_1,
-		.mask = PMX_NAND8BIT_1_MASK,
-		.value = PMX_NAND8BIT_1_MASK,
+		.address = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_NAND8BIT_1_MASK | PMX_KEYBOARD_6X6_MASK,
+		.value = PMX_NAND8BIT_1_MASK | PMX_KEYBOARD_6X6_MASK,
 	},
 };
 
@@ -932,13 +936,13 @@ struct pmx_dev pmx_nand_8bit = {
  */
 static struct pmx_mux_reg pmx_nand16_4_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG_0,
+		.address = PAD_MUX_CONFIG_REG_0,
 		.mask = PMX_NAND16BIT4DEV_0_MASK,
 		.value = PMX_NAND16BIT4DEV_0_MASK,
 	}, {
-		.offset = PAD_MUX_CONFIG_REG_1,
-		.mask = PMX_NAND16BIT4DEV_1_MASK,
-		.value = PMX_NAND16BIT4DEV_1_MASK,
+		.address = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_NAND16BIT4DEV_1_MASK | PMX_KEYBOARD_6X6_MASK,
+		.value = PMX_NAND16BIT4DEV_1_MASK | PMX_KEYBOARD_6X6_MASK,
 	},
 };
 
@@ -955,16 +959,16 @@ struct pmx_dev pmx_nand_16bit_4_chips = {
 	.mode_count = ARRAY_SIZE(pmx_nand16_4_modes),
 };
 
-/* Pad multiplexing for nand 16bit device */
+/* Pad multiplexing for nand 16bit device (cs0 only) */
 static struct pmx_mux_reg pmx_nand16_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG_0,
+		.address = PAD_MUX_CONFIG_REG_0,
 		.mask = PMX_NAND16BIT_0_MASK,
 		.value = PMX_NAND16BIT_0_MASK,
 	}, {
-		.offset = PAD_MUX_CONFIG_REG_1,
-		.mask = PMX_NAND16BIT_1_MASK,
-		.value = PMX_NAND16BIT_1_MASK,
+		.address = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_NAND16BIT_1_MASK | PMX_KEYBOARD_6X6_MASK,
+		.value = PMX_NAND16BIT_1_MASK | PMX_KEYBOARD_6X6_MASK,
 	},
 };
 
@@ -981,37 +985,64 @@ struct pmx_dev pmx_nand_16bit = {
 	.mode_count = ARRAY_SIZE(pmx_nand16_modes),
 };
 
-/* Pad multiplexing for keyboard device */
-static struct pmx_mux_reg pmx_keyboard_mux[] = {
+/* Pad multiplexing for keyboard_6x6 device */
+static struct pmx_mux_reg pmx_keyboard_6x6_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG_1,
-		.mask = PMX_KEYBOARD_MASK,
-		.value = PMX_KEYBOARD_MASK,
+		.address = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_KEYBOARD_6X6_MASK,
+		.value = PMX_KEYBOARD_6X6_MASK,
 	}, {
-		.offset = PAD_MUX_CONFIG_REG_1,
+		.address = PAD_MUX_CONFIG_REG_1,
 		.mask = PMX_NFIO815_MASK | PMX_NFCE1_MASK | \
 			PMX_NFCE2_MASK | PMX_NFWPRT1_MASK | PMX_NFWPRT2_MASK,
 		.value = 0,
 	},
 };
 
-static struct pmx_dev_mode pmx_keyboard_modes[] = {
+static struct pmx_dev_mode pmx_keyboard_6x6_modes[] = {
 	{
-		.mux_regs = pmx_keyboard_mux,
-		.mux_reg_cnt = ARRAY_SIZE(pmx_keyboard_mux),
+		.mux_regs = pmx_keyboard_6x6_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_keyboard_6x6_mux),
 	},
 };
 
-struct pmx_dev pmx_keyboard = {
-	.name = "keyboard",
-	.modes = pmx_keyboard_modes,
-	.mode_count = ARRAY_SIZE(pmx_keyboard_modes),
+struct pmx_dev pmx_keyboard_6x6 = {
+	.name = "keyboard_6x6",
+	.modes = pmx_keyboard_6x6_modes,
+	.mode_count = ARRAY_SIZE(pmx_keyboard_6x6_modes),
+};
+
+/* Pad multiplexing for keyboard_9x9 device */
+static struct pmx_mux_reg pmx_keyboard_9x9_mux[] = {
+	{
+		.address = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_KEYBOARD_6X6_MASK | PMX_KBD_ROWCOL68_MASK,
+		.value = PMX_KEYBOARD_6X6_MASK | PMX_KBD_ROWCOL68_MASK,
+	}, {
+		.address = PAD_MUX_CONFIG_REG_1,
+		.mask = PMX_NFIO815_MASK | PMX_NFCE1_MASK | \
+			PMX_NFCE2_MASK | PMX_NFWPRT1_MASK | PMX_NFWPRT2_MASK,
+		.value = 0,
+	},
+};
+
+static struct pmx_dev_mode pmx_keyboard_9x9_modes[] = {
+	{
+		.mux_regs = pmx_keyboard_9x9_mux,
+		.mux_reg_cnt = ARRAY_SIZE(pmx_keyboard_9x9_mux),
+	},
+};
+
+struct pmx_dev pmx_keyboard_9x9 = {
+	.name = "keyboard_9x9",
+	.modes = pmx_keyboard_9x9_modes,
+	.mode_count = ARRAY_SIZE(pmx_keyboard_9x9_modes),
 };
 
 /* Pad multiplexing for uart0 device */
 static struct pmx_mux_reg pmx_uart0_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG_0,
+		.address = PAD_MUX_CONFIG_REG_0,
 		.mask = PMX_UART0_MASK,
 		.value = PMX_UART0_MASK,
 	},
@@ -1033,7 +1064,7 @@ struct pmx_dev pmx_uart0 = {
 /* Pad multiplexing for uart0_modem device */
 static struct pmx_mux_reg pmx_uart0_modem_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG_1,
+		.address = PAD_MUX_CONFIG_REG_1,
 		.mask = PMX_UART0_MODEM_MASK,
 		.value = PMX_UART0_MODEM_MASK,
 	},
@@ -1055,7 +1086,7 @@ struct pmx_dev pmx_uart0_modem = {
 /* Pad multiplexing for gpt_0_1 device */
 static struct pmx_mux_reg pmx_gpt_0_1_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG_1,
+		.address = PAD_MUX_CONFIG_REG_1,
 		.mask = PMX_GPT0_TMR1_MASK,
 		.value = PMX_GPT0_TMR1_MASK,
 	},
@@ -1077,7 +1108,7 @@ struct pmx_dev pmx_gpt_0_1 = {
 /* Pad multiplexing for gpt_0_2 device */
 static struct pmx_mux_reg pmx_gpt_0_2_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG_1,
+		.address = PAD_MUX_CONFIG_REG_1,
 		.mask = PMX_GPT0_TMR2_MASK,
 		.value = PMX_GPT0_TMR2_MASK,
 	},
@@ -1099,7 +1130,7 @@ struct pmx_dev pmx_gpt_0_2 = {
 /* Pad multiplexing for gpt_1_1 device */
 static struct pmx_mux_reg pmx_gpt_1_1_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG_1,
+		.address = PAD_MUX_CONFIG_REG_1,
 		.mask = PMX_GPT1_TMR1_MASK,
 		.value = PMX_GPT1_TMR1_MASK,
 	},
@@ -1121,7 +1152,7 @@ struct pmx_dev pmx_gpt_1_1 = {
 /* Pad multiplexing for gpt_1_2 device */
 static struct pmx_mux_reg pmx_gpt_1_2_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG_1,
+		.address = PAD_MUX_CONFIG_REG_1,
 		.mask = PMX_GPT1_TMR2_MASK,
 		.value = PMX_GPT1_TMR2_MASK,
 	},
@@ -1143,11 +1174,11 @@ struct pmx_dev pmx_gpt_1_2 = {
 /* Pad multiplexing for mcif device */
 static struct pmx_mux_reg pmx_mcif_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG_1,
+		.address = PAD_MUX_CONFIG_REG_1,
 		.mask = PMX_MCIFALL_1_MASK,
 		.value = PMX_MCIFALL_1_MASK,
 	}, {
-		.offset = PAD_MUX_CONFIG_REG_2,
+		.address = PAD_MUX_CONFIG_REG_2,
 		.mask = PMX_MCIFALL_2_MASK,
 		.value = PMX_MCIFALL_2_MASK,
 	},
diff --git a/arch/arm/mach-spear3xx/include/mach/generic.h b/arch/arm/mach-spear3xx/include/mach/generic.h
index 1acb93d..1b97ba8 100644
--- a/arch/arm/mach-spear3xx/include/mach/generic.h
+++ b/arch/arm/mach-spear3xx/include/mach/generic.h
@@ -148,7 +148,10 @@ extern struct pmx_dev pmx_telecom_boot_pins;
 extern struct pmx_dev pmx_telecom_sdhci_4bit;
 extern struct pmx_dev pmx_telecom_sdhci_8bit;
 extern struct pmx_dev pmx_gpio1;
-#define PAD_MUX_CONFIG_REG	0x00
+
+/* pad multiplexing support */
+#define PAD_MUX_CONFIG_REG	0x99000000
+#define MODE_CONFIG_REG		0x99000004
 
 /* Add spear300 machine function declarations here */
 void __init spear300_init(void);
@@ -180,7 +183,7 @@ extern struct pmx_dev pmx_uart3_4_5;
 extern struct pmx_dev pmx_fsmc;
 extern struct pmx_dev pmx_rs485_0_1;
 extern struct pmx_dev pmx_tdm0;
-#define PAD_MUX_CONFIG_REG	0x08
+#define PAD_MUX_CONFIG_REG	0xB4000008
 
 /* Add spear310 machine function declarations here */
 void __init spear310_init(void);
@@ -230,7 +233,10 @@ extern struct pmx_dev pmx_mii1;
 extern struct pmx_dev pmx_smii0;
 extern struct pmx_dev pmx_smii1;
 extern struct pmx_dev pmx_i2c1;
-#define PAD_MUX_CONFIG_REG	0x0C
+
+/* pad multiplexing support */
+#define PAD_MUX_CONFIG_REG	0xB300000C
+#define MODE_CONFIG_REG		0xB3000010
 
 /* Add spear320 machine function declarations here */
 void __init spear320_init(void);
diff --git a/arch/arm/mach-spear3xx/include/mach/spear300.h b/arch/arm/mach-spear3xx/include/mach/spear300.h
index c723515..4fd2d22 100644
--- a/arch/arm/mach-spear3xx/include/mach/spear300.h
+++ b/arch/arm/mach-spear3xx/include/mach/spear300.h
@@ -45,7 +45,6 @@
 #define SPEAR300_NOR_2_BASE		UL(0x92000000)
 #define SPEAR300_NOR_3_BASE		UL(0x93000000)
 #define SPEAR300_FSMC_BASE		UL(0x94000000)
-#define SPEAR300_SOC_CONFIG_BASE	UL(0x99000000)
 #define SPEAR300_KEYBOARD_BASE		UL(0xA0000000)
 #define SPEAR300_GPIO_BASE		UL(0xA9000000)
 
diff --git a/arch/arm/mach-spear3xx/spear300.c b/arch/arm/mach-spear3xx/spear300.c
index 0a0485d..2671cfd 100644
--- a/arch/arm/mach-spear3xx/spear300.c
+++ b/arch/arm/mach-spear3xx/spear300.c
@@ -20,9 +20,6 @@
 #include <mach/spear.h>
 #include <plat/shirq.h>
 
-/* pad multiplexing support */
-#define MODE_CONFIG_REG		0x04
-
 /* modes */
 #define NAND_MODE			(1 << 0)
 #define NOR_MODE			(1 << 1)
@@ -121,7 +118,7 @@ struct pmx_mode caml_lcd_mode = {
 /* Pad multiplexing for FSMC 2 NAND devices */
 static struct pmx_mux_reg pmx_fsmc_2_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_FIRDA_MASK,
 		.value = 0,
 	},
@@ -145,7 +142,7 @@ struct pmx_dev pmx_fsmc_2_chips = {
 /* Pad multiplexing for FSMC 4 NAND devices */
 static struct pmx_mux_reg pmx_fsmc_4_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_FIRDA_MASK | PMX_UART0_MASK,
 		.value = 0,
 	},
@@ -169,7 +166,7 @@ struct pmx_dev pmx_fsmc_4_chips = {
 /* Pad multiplexing for Keyboard device */
 static struct pmx_mux_reg pmx_kbd_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = 0x0,
 		.value = 0,
 	},
@@ -195,7 +192,7 @@ struct pmx_dev pmx_keyboard = {
 /* Pad multiplexing for CLCD device */
 static struct pmx_mux_reg pmx_clcd_pfmode_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK,
 		.value = 0,
 	},
@@ -203,7 +200,7 @@ static struct pmx_mux_reg pmx_clcd_pfmode_mux[] = {
 
 static struct pmx_mux_reg pmx_clcd_lcdmode_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_3_4_MASK,
 		.value = 0,
 	},
@@ -231,7 +228,7 @@ struct pmx_dev pmx_clcd = {
 /* Pad multiplexing for Telecom GPIO device */
 static struct pmx_mux_reg pmx_gpio_lcdmode_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = 0,
 	},
@@ -239,7 +236,7 @@ static struct pmx_mux_reg pmx_gpio_lcdmode_mux[] = {
 
 static struct pmx_mux_reg pmx_gpio_fonemode_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK | PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK,
 		.value = 0,
 	},
@@ -247,7 +244,7 @@ static struct pmx_mux_reg pmx_gpio_fonemode_mux[] = {
 
 static struct pmx_mux_reg pmx_gpio_atai2smode_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK | PMX_TIMER_3_4_MASK,
 		.value = 0,
 	},
@@ -255,7 +252,7 @@ static struct pmx_mux_reg pmx_gpio_atai2smode_mux[] = {
 
 static struct pmx_mux_reg pmx_gpio_lendfonemode_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK | PMX_TIMER_1_2_MASK,
 		.value = 0,
 	},
@@ -263,7 +260,7 @@ static struct pmx_mux_reg pmx_gpio_lendfonemode_mux[] = {
 
 static struct pmx_mux_reg pmx_gpio_atawi2smode_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK | PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK
 			| PMX_UART0_MODEM_MASK,
 		.value = 0,
@@ -303,7 +300,7 @@ struct pmx_dev pmx_telecom_gpio = {
 /* Pad multiplexing for TDM device */
 static struct pmx_mux_reg pmx_tdm_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK | PMX_SSP_CS_MASK,
 		.value = 0,
 	},
@@ -330,7 +327,7 @@ struct pmx_dev pmx_telecom_tdm = {
 /* Pad multiplexing for spi cs i2c device */
 static struct pmx_mux_reg pmx_spi_cs_i2c_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK,
 		.value = 0,
 	},
@@ -355,7 +352,7 @@ struct pmx_dev pmx_telecom_spi_cs_i2c_clk = {
 
 static struct pmx_mux_reg pmx_caml_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = 0,
 	},
@@ -363,7 +360,7 @@ static struct pmx_mux_reg pmx_caml_mux[] = {
 
 static struct pmx_mux_reg pmx_camu_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK | PMX_MII_MASK,
 		.value = 0,
 	},
@@ -390,7 +387,7 @@ struct pmx_dev pmx_telecom_camera = {
 /* Pad multiplexing for dac device */
 static struct pmx_mux_reg pmx_dac_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK,
 		.value = 0,
 	},
@@ -414,7 +411,7 @@ struct pmx_dev pmx_telecom_dac = {
 /* Pad multiplexing for spi cs i2c device */
 static struct pmx_mux_reg pmx_i2s_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK,
 		.value = 0,
 	},
@@ -440,7 +437,7 @@ struct pmx_dev pmx_telecom_i2s = {
 /* Pad multiplexing for bootpins device */
 static struct pmx_mux_reg pmx_bootpins_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK | PMX_TIMER_1_2_MASK |
 			PMX_TIMER_3_4_MASK,
 		.value = 0,
@@ -464,7 +461,7 @@ struct pmx_dev pmx_telecom_boot_pins = {
 /* Pad multiplexing for sdhci 4bit device */
 static struct pmx_mux_reg pmx_sdhci_4bit_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN0_MASK | PMX_GPIO_PIN1_MASK |
 			PMX_GPIO_PIN2_MASK | PMX_GPIO_PIN3_MASK |
 			PMX_GPIO_PIN4_MASK | PMX_GPIO_PIN5_MASK,
@@ -493,7 +490,7 @@ struct pmx_dev pmx_telecom_sdhci_4bit = {
 /* Pad multiplexing for spi cs i2c device */
 static struct pmx_mux_reg pmx_sdhci_8bit_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN0_MASK | PMX_GPIO_PIN1_MASK |
 			PMX_GPIO_PIN2_MASK | PMX_GPIO_PIN3_MASK |
 			PMX_GPIO_PIN4_MASK | PMX_GPIO_PIN5_MASK | PMX_MII_MASK,
@@ -521,7 +518,7 @@ struct pmx_dev pmx_telecom_sdhci_8bit = {
 /* Pad multiplexing for spi cs i2c device */
 static struct pmx_mux_reg pmx_gpio1_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK | PMX_TIMER_1_2_MASK |
 			PMX_TIMER_3_4_MASK,
 		.value = 0,
@@ -544,7 +541,7 @@ struct pmx_dev pmx_gpio1 = {
 
 /* pmx driver structure */
 struct pmx_driver pmx_driver = {
-	.mode_reg = {.offset = MODE_CONFIG_REG, .mask = 0x0000000f},
+	.mode_reg = {.address = MODE_CONFIG_REG, .mask = 0x0000000f},
 };
 
 /* Add spear300 specific devices here */
@@ -780,18 +777,20 @@ struct spear_shirq shirq_ras1 = {
 void sdhci_i2s_mem_enable(u8 mask)
 {
 	u32 val;
-	void __iomem *base = ioremap(SPEAR300_SOC_CONFIG_BASE, SZ_4K);
-	if (!base) {
+	void __iomem *config = ioremap(MODE_CONFIG_REG, SZ_16);
+	if (!config) {
 		pr_debug("sdhci_i2s_enb: ioremap fail\n");
 		return;
 	}
 
-	val = readl(base + MODE_CONFIG_REG);
+	val = readl(config);
 	if (mask == SDHCI_MEM_ENB)
 		val |= SDHCI_MEM_SELECT;
 	else
 		val &= ~SDHCI_MEM_SELECT;
-	writel(val, base + MODE_CONFIG_REG);
+	writel(val, config);
+
+	iounmap(config);
 }
 
 /* spear300 routines */
@@ -811,13 +810,7 @@ void __init spear300_init(void)
 	}
 
 	/* pmx initialization */
-	pmx_driver.base = ioremap(SPEAR300_SOC_CONFIG_BASE, SZ_4K);
-	if (pmx_driver.base) {
-		ret = pmx_register(&pmx_driver);
-		if (ret)
-			printk(KERN_ERR "padmux: registeration failed. err no"
-					": %d\n", ret);
-		/* Free Mapping, device selection already done */
-		iounmap(pmx_driver.base);
-	}
+	ret = pmx_register(&pmx_driver);
+	if (ret)
+		pr_err("padmux: registeration failed. err no: %d\n", ret);
 }
diff --git a/arch/arm/mach-spear3xx/spear310.c b/arch/arm/mach-spear3xx/spear310.c
index 548ad56..79f7105 100644
--- a/arch/arm/mach-spear3xx/spear310.c
+++ b/arch/arm/mach-spear3xx/spear310.c
@@ -26,7 +26,7 @@
 /* Pad multiplexing for emi_cs_0_1_4_5 devices */
 static struct pmx_mux_reg pmx_emi_cs_0_1_4_5_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_3_4_MASK,
 		.value = 0,
 	},
@@ -48,7 +48,7 @@ struct pmx_dev pmx_emi_cs_0_1_4_5 = {
 /* Pad multiplexing for emi_cs_2_3 devices */
 static struct pmx_mux_reg pmx_emi_cs_2_3_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK,
 		.value = 0,
 	},
@@ -70,7 +70,7 @@ struct pmx_dev pmx_emi_cs_2_3 = {
 /* Pad multiplexing for uart1 device */
 static struct pmx_mux_reg pmx_uart1_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_FIRDA_MASK,
 		.value = 0,
 	},
@@ -92,7 +92,7 @@ struct pmx_dev pmx_uart1 = {
 /* Pad multiplexing for uart2 device */
 static struct pmx_mux_reg pmx_uart2_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK,
 		.value = 0,
 	},
@@ -114,7 +114,7 @@ struct pmx_dev pmx_uart2 = {
 /* Pad multiplexing for uart3_4_5 devices */
 static struct pmx_mux_reg pmx_uart3_4_5_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK,
 		.value = 0,
 	},
@@ -136,7 +136,7 @@ struct pmx_dev pmx_uart3_4_5 = {
 /* Pad multiplexing for fsmc device */
 static struct pmx_mux_reg pmx_fsmc_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_SSP_CS_MASK,
 		.value = 0,
 	},
@@ -158,7 +158,7 @@ struct pmx_dev pmx_fsmc = {
 /* Pad multiplexing for rs485_0_1 devices */
 static struct pmx_mux_reg pmx_rs485_0_1_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = 0,
 	},
@@ -180,7 +180,7 @@ struct pmx_dev pmx_rs485_0_1 = {
 /* Pad multiplexing for tdm0 device */
 static struct pmx_mux_reg pmx_tdm0_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = 0,
 	},
@@ -524,9 +524,7 @@ void __init spear310_init(void)
 	}
 
 	/* pmx initialization */
-	pmx_driver.base = base;
 	ret = pmx_register(&pmx_driver);
 	if (ret)
-		printk(KERN_ERR "padmux: registeration failed. err no: %d\n",
-				ret);
+		pr_err("padmux: registeration failed. err no: %d\n", ret);
 }
diff --git a/arch/arm/mach-spear3xx/spear320.c b/arch/arm/mach-spear3xx/spear320.c
index c9f5737c..8481955 100644
--- a/arch/arm/mach-spear3xx/spear320.c
+++ b/arch/arm/mach-spear3xx/spear320.c
@@ -23,9 +23,6 @@
 #include <plat/gpio.h>
 #include <plat/shirq.h>
 
-/* pad multiplexing support */
-#define MODE_CONFIG_REG		0x10
-
 /* modes */
 #define AUTO_NET_SMII_MODE	(1 << 0)
 #define AUTO_NET_MII_MODE	(1 << 1)
@@ -61,7 +58,7 @@ struct pmx_mode small_printers_mode = {
 /* Pad multiplexing for CLCD device */
 static struct pmx_mux_reg pmx_clcd_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = 0x0,
 		.value = 0,
 	},
@@ -84,7 +81,7 @@ struct pmx_dev pmx_clcd = {
 /* Pad multiplexing for EMI (Parallel NOR flash) device */
 static struct pmx_mux_reg pmx_emi_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK,
 		.value = 0,
 	},
@@ -107,7 +104,7 @@ struct pmx_dev pmx_emi = {
 /* Pad multiplexing for FSMC (NAND flash) device */
 static struct pmx_mux_reg pmx_fsmc_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = 0x0,
 		.value = 0,
 	},
@@ -130,7 +127,7 @@ struct pmx_dev pmx_fsmc = {
 /* Pad multiplexing for SPP device */
 static struct pmx_mux_reg pmx_spp_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = 0x0,
 		.value = 0,
 	},
@@ -153,7 +150,7 @@ struct pmx_dev pmx_spp = {
 /* Pad multiplexing for SDHCI device */
 static struct pmx_mux_reg pmx_sdhci_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK,
 		.value = 0,
 	},
@@ -177,7 +174,7 @@ struct pmx_dev pmx_sdhci = {
 /* Pad multiplexing for I2S device */
 static struct pmx_mux_reg pmx_i2s_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK,
 		.value = 0,
 	},
@@ -200,7 +197,7 @@ struct pmx_dev pmx_i2s = {
 /* Pad multiplexing for UART1 device */
 static struct pmx_mux_reg pmx_uart1_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN0_MASK | PMX_GPIO_PIN1_MASK,
 		.value = 0,
 	},
@@ -223,7 +220,7 @@ struct pmx_dev pmx_uart1 = {
 /* Pad multiplexing for UART1 Modem device */
 static struct pmx_mux_reg pmx_uart1_modem_autoexp_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK | PMX_TIMER_3_4_MASK |
 			PMX_SSP_CS_MASK,
 		.value = 0,
@@ -232,7 +229,7 @@ static struct pmx_mux_reg pmx_uart1_modem_autoexp_mux[] = {
 
 static struct pmx_mux_reg pmx_uart1_modem_smallpri_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN3_MASK | PMX_GPIO_PIN4_MASK |
 			PMX_GPIO_PIN5_MASK | PMX_SSP_CS_MASK,
 		.value = 0,
@@ -260,7 +257,7 @@ struct pmx_dev pmx_uart1_modem = {
 /* Pad multiplexing for UART2 device */
 static struct pmx_mux_reg pmx_uart2_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_FIRDA_MASK,
 		.value = 0,
 	},
@@ -283,7 +280,7 @@ struct pmx_dev pmx_uart2 = {
 /* Pad multiplexing for Touchscreen device */
 static struct pmx_mux_reg pmx_touchscreen_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_SSP_CS_MASK,
 		.value = 0,
 	},
@@ -306,7 +303,7 @@ struct pmx_dev pmx_touchscreen = {
 /* Pad multiplexing for CAN device */
 static struct pmx_mux_reg pmx_can_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN2_MASK | PMX_GPIO_PIN3_MASK |
 			PMX_GPIO_PIN4_MASK | PMX_GPIO_PIN5_MASK,
 		.value = 0,
@@ -330,7 +327,7 @@ struct pmx_dev pmx_can = {
 /* Pad multiplexing for SDHCI LED device */
 static struct pmx_mux_reg pmx_sdhci_led_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_SSP_CS_MASK,
 		.value = 0,
 	},
@@ -353,7 +350,7 @@ struct pmx_dev pmx_sdhci_led = {
 /* Pad multiplexing for PWM0 device */
 static struct pmx_mux_reg pmx_pwm0_net_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK,
 		.value = 0,
 	},
@@ -361,7 +358,7 @@ static struct pmx_mux_reg pmx_pwm0_net_mux[] = {
 
 static struct pmx_mux_reg pmx_pwm0_autoexpsmallpri_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = 0,
 	},
@@ -388,7 +385,7 @@ struct pmx_dev pmx_pwm0 = {
 /* Pad multiplexing for PWM1 device */
 static struct pmx_mux_reg pmx_pwm1_net_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK,
 		.value = 0,
 	},
@@ -396,7 +393,7 @@ static struct pmx_mux_reg pmx_pwm1_net_mux[] = {
 
 static struct pmx_mux_reg pmx_pwm1_autoexpsmallpri_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = 0,
 	},
@@ -423,7 +420,7 @@ struct pmx_dev pmx_pwm1 = {
 /* Pad multiplexing for PWM2 device */
 static struct pmx_mux_reg pmx_pwm2_net_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_SSP_CS_MASK,
 		.value = 0,
 	},
@@ -431,7 +428,7 @@ static struct pmx_mux_reg pmx_pwm2_net_mux[] = {
 
 static struct pmx_mux_reg pmx_pwm2_autoexpsmallpri_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = 0,
 	},
@@ -458,7 +455,7 @@ struct pmx_dev pmx_pwm2 = {
 /* Pad multiplexing for PWM3 device */
 static struct pmx_mux_reg pmx_pwm3_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = 0,
 	},
@@ -481,7 +478,7 @@ struct pmx_dev pmx_pwm3 = {
 /* Pad multiplexing for SSP1 device */
 static struct pmx_mux_reg pmx_ssp1_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = 0,
 	},
@@ -504,7 +501,7 @@ struct pmx_dev pmx_ssp1 = {
 /* Pad multiplexing for SSP2 device */
 static struct pmx_mux_reg pmx_ssp2_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = 0,
 	},
@@ -527,7 +524,7 @@ struct pmx_dev pmx_ssp2 = {
 /* Pad multiplexing for mii1 device */
 static struct pmx_mux_reg pmx_mii1_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = 0x0,
 		.value = 0,
 	},
@@ -550,7 +547,7 @@ struct pmx_dev pmx_mii1 = {
 /* Pad multiplexing for smii0 device */
 static struct pmx_mux_reg pmx_smii0_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = 0,
 	},
@@ -573,7 +570,7 @@ struct pmx_dev pmx_smii0 = {
 /* Pad multiplexing for smii1 device */
 static struct pmx_mux_reg pmx_smii1_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = 0,
 	},
@@ -596,7 +593,7 @@ struct pmx_dev pmx_smii1 = {
 /* Pad multiplexing for i2c1 device */
 static struct pmx_mux_reg pmx_i2c1_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = 0x0,
 		.value = 0,
 	},
@@ -618,7 +615,7 @@ struct pmx_dev pmx_i2c1 = {
 
 /* pmx driver structure */
 struct pmx_driver pmx_driver = {
-	.mode_reg = {.offset = MODE_CONFIG_REG, .mask = 0x00000007},
+	.mode_reg = {.address = MODE_CONFIG_REG, .mask = 0x00000007},
 };
 
 /* Add spear320 specific devices here */
@@ -1019,9 +1016,7 @@ void __init spear320_init(void)
 	}
 
 	/* pmx initialization */
-	pmx_driver.base = base;
 	ret = pmx_register(&pmx_driver);
 	if (ret)
-		printk(KERN_ERR "padmux: registeration failed. err no: %d\n",
-				ret);
+		pr_err("padmux: registeration failed. err no: %d\n", ret);
 }
diff --git a/arch/arm/mach-spear3xx/spear3xx.c b/arch/arm/mach-spear3xx/spear3xx.c
index 30e3ab8..45a0774 100644
--- a/arch/arm/mach-spear3xx/spear3xx.c
+++ b/arch/arm/mach-spear3xx/spear3xx.c
@@ -297,7 +297,7 @@ void __init spear3xx_map_io(void)
 /* Pad multiplexing for firda device */
 static struct pmx_mux_reg pmx_firda_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_FIRDA_MASK,
 		.value = PMX_FIRDA_MASK,
 	},
@@ -320,7 +320,7 @@ struct pmx_dev pmx_firda = {
 /* Pad multiplexing for i2c device */
 static struct pmx_mux_reg pmx_i2c_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_I2C_MASK,
 		.value = PMX_I2C_MASK,
 	},
@@ -343,7 +343,7 @@ struct pmx_dev pmx_i2c = {
 /* Pad multiplexing for firda device */
 static struct pmx_mux_reg pmx_ssp_cs_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_SSP_CS_MASK,
 		.value = PMX_SSP_CS_MASK,
 	},
@@ -366,7 +366,7 @@ struct pmx_dev pmx_ssp_cs = {
 /* Pad multiplexing for ssp device */
 static struct pmx_mux_reg pmx_ssp_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_SSP_MASK,
 		.value = PMX_SSP_MASK,
 	},
@@ -389,7 +389,7 @@ struct pmx_dev pmx_ssp = {
 /* Pad multiplexing for mii device */
 static struct pmx_mux_reg pmx_mii_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = PMX_MII_MASK,
 	},
@@ -412,7 +412,7 @@ struct pmx_dev pmx_mii = {
 /* Pad multiplexing for gpio pin0 device */
 static struct pmx_mux_reg pmx_gpio_pin0_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN0_MASK,
 		.value = PMX_GPIO_PIN0_MASK,
 	},
@@ -435,7 +435,7 @@ struct pmx_dev pmx_gpio_pin0 = {
 /* Pad multiplexing for gpio pin1 device */
 static struct pmx_mux_reg pmx_gpio_pin1_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN1_MASK,
 		.value = PMX_GPIO_PIN1_MASK,
 	},
@@ -458,7 +458,7 @@ struct pmx_dev pmx_gpio_pin1 = {
 /* Pad multiplexing for gpio pin2 device */
 static struct pmx_mux_reg pmx_gpio_pin2_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN2_MASK,
 		.value = PMX_GPIO_PIN2_MASK,
 	},
@@ -481,7 +481,7 @@ struct pmx_dev pmx_gpio_pin2 = {
 /* Pad multiplexing for gpio pin3 device */
 static struct pmx_mux_reg pmx_gpio_pin3_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN3_MASK,
 		.value = PMX_GPIO_PIN3_MASK,
 	},
@@ -504,7 +504,7 @@ struct pmx_dev pmx_gpio_pin3 = {
 /* Pad multiplexing for gpio pin4 device */
 static struct pmx_mux_reg pmx_gpio_pin4_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN4_MASK,
 		.value = PMX_GPIO_PIN4_MASK,
 	},
@@ -527,7 +527,7 @@ struct pmx_dev pmx_gpio_pin4 = {
 /* Pad multiplexing for gpio pin5 device */
 static struct pmx_mux_reg pmx_gpio_pin5_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN5_MASK,
 		.value = PMX_GPIO_PIN5_MASK,
 	},
@@ -550,7 +550,7 @@ struct pmx_dev pmx_gpio_pin5 = {
 /* Pad multiplexing for uart0 modem device */
 static struct pmx_mux_reg pmx_uart0_modem_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK,
 		.value = PMX_UART0_MODEM_MASK,
 	},
@@ -573,7 +573,7 @@ struct pmx_dev pmx_uart0_modem = {
 /* Pad multiplexing for uart0 device */
 static struct pmx_mux_reg pmx_uart0_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MASK,
 		.value = PMX_UART0_MASK,
 	},
@@ -596,7 +596,7 @@ struct pmx_dev pmx_uart0 = {
 /* Pad multiplexing for timer 3, 4 device */
 static struct pmx_mux_reg pmx_timer_3_4_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_3_4_MASK,
 		.value = PMX_TIMER_3_4_MASK,
 	},
@@ -619,7 +619,7 @@ struct pmx_dev pmx_timer_3_4 = {
 /* Pad multiplexing for gpio pin0 device */
 static struct pmx_mux_reg pmx_timer_1_2_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK,
 		.value = PMX_TIMER_1_2_MASK,
 	},
@@ -644,7 +644,7 @@ struct pmx_dev pmx_timer_1_2 = {
 /* Pad multiplexing for plgpio_0_1 devices */
 static struct pmx_mux_reg pmx_plgpio_0_1_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_FIRDA_MASK,
 		.value = 0,
 	},
@@ -667,7 +667,7 @@ struct pmx_dev pmx_plgpio_0_1 = {
 /* Pad multiplexing for plgpio_2_3 devices */
 static struct pmx_mux_reg pmx_plgpio_2_3_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MASK,
 		.value = 0,
 	},
@@ -690,7 +690,7 @@ struct pmx_dev pmx_plgpio_2_3 = {
 /* Pad multiplexing for plgpio_4_5 devices */
 static struct pmx_mux_reg pmx_plgpio_4_5_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_I2C_MASK,
 		.value = 0,
 	},
@@ -713,7 +713,7 @@ struct pmx_dev pmx_plgpio_4_5 = {
 /* Pad multiplexing for plgpio_6_9 devices */
 static struct pmx_mux_reg pmx_plgpio_6_9_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_SSP_MASK,
 		.value = 0,
 	},
@@ -736,7 +736,7 @@ struct pmx_dev pmx_plgpio_6_9 = {
 /* Pad multiplexing for plgpio_10_27 devices */
 static struct pmx_mux_reg pmx_plgpio_10_27_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_MII_MASK,
 		.value = 0,
 	},
@@ -759,7 +759,7 @@ struct pmx_dev pmx_plgpio_10_27 = {
 /* Pad multiplexing for plgpio_28 devices */
 static struct pmx_mux_reg pmx_plgpio_28_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN0_MASK,
 		.value = 0,
 	},
@@ -782,7 +782,7 @@ struct pmx_dev pmx_plgpio_28 = {
 /* Pad multiplexing for plgpio_29 devices */
 static struct pmx_mux_reg pmx_plgpio_29_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN1_MASK,
 		.value = 0,
 	},
@@ -805,7 +805,7 @@ struct pmx_dev pmx_plgpio_29 = {
 /* Pad multiplexing for plgpio_30 device */
 static struct pmx_mux_reg pmx_plgpio_30_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN2_MASK,
 		.value = 0,
 	},
@@ -828,7 +828,7 @@ struct pmx_dev pmx_plgpio_30 = {
 /* Pad multiplexing for plgpio_31 device */
 static struct pmx_mux_reg pmx_plgpio_31_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN3_MASK,
 		.value = 0,
 	},
@@ -851,7 +851,7 @@ struct pmx_dev pmx_plgpio_31 = {
 /* Pad multiplexing for plgpio_32 device */
 static struct pmx_mux_reg pmx_plgpio_32_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN4_MASK,
 		.value = 0,
 	},
@@ -874,7 +874,7 @@ struct pmx_dev pmx_plgpio_32 = {
 /* Pad multiplexing for plgpio_33 device */
 static struct pmx_mux_reg pmx_plgpio_33_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_GPIO_PIN5_MASK,
 		.value = 0,
 	},
@@ -897,7 +897,7 @@ struct pmx_dev pmx_plgpio_33 = {
 /* Pad multiplexing for plgpio_34_36 device */
 static struct pmx_mux_reg pmx_plgpio_34_36_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_SSP_CS_MASK,
 		.value = 0,
 	},
@@ -920,7 +920,7 @@ struct pmx_dev pmx_plgpio_34_36 = {
 /* Pad multiplexing for plgpio_37_42 device */
 static struct pmx_mux_reg pmx_plgpio_37_42_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_UART0_MODEM_MASK,
 		.value = 0,
 	},
@@ -943,7 +943,7 @@ struct pmx_dev pmx_plgpio_37_42 = {
 /* Pad multiplexing for plgpio_43_44_47_48 device */
 static struct pmx_mux_reg pmx_plgpio_43_44_47_48_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_1_2_MASK,
 		.value = 0,
 	},
@@ -966,7 +966,7 @@ struct pmx_dev pmx_plgpio_43_44_47_48 = {
 /* Pad multiplexing for plgpio_45_46_49_50 device */
 static struct pmx_mux_reg pmx_plgpio_45_46_49_50_mux[] = {
 	{
-		.offset = PAD_MUX_CONFIG_REG,
+		.address = PAD_MUX_CONFIG_REG,
 		.mask = PMX_TIMER_3_4_MASK,
 		.value = 0,
 	},
diff --git a/arch/arm/plat-spear/include/plat/padmux.h b/arch/arm/plat-spear/include/plat/padmux.h
index 1b69ca5..1959235 100644
--- a/arch/arm/plat-spear/include/plat/padmux.h
+++ b/arch/arm/plat-spear/include/plat/padmux.h
@@ -19,23 +19,23 @@
 /*
  * struct pmx_reg: configuration structure for mode reg and mux reg
  *
- * offset: offset of mode reg
+ * address: physical address of mode reg
  * mask: mask of mode reg
  */
 struct pmx_reg {
-	u32 offset;
+	u32 address;
 	u32 mask;
 };
 
 /*
  * struct pmx_mux_reg: configuration structure every group of modes of a device
  *
- * offset: multiplexing register offset
+ * address: physical address of multiplexing register
  * mask: mask for supported mode
  * value: value to be written
  */
 struct pmx_mux_reg {
-	u32 offset;
+	u32 address;
 	u32 mask;
 	u32 value;
 };
@@ -87,14 +87,12 @@ struct pmx_dev {
  * mode: mode to be set
  * devs: array of pointer to pmx devices
  * devs_count: ARRAY_SIZE of devs
- * base: base address of soc config registers
  * mode_reg: structure of mode config register
  */
 struct pmx_driver {
 	struct pmx_mode *mode;
 	struct pmx_dev **devs;
 	u8 devs_count;
-	u32 *base;
 	struct pmx_reg mode_reg;
 };
 
diff --git a/arch/arm/plat-spear/padmux.c b/arch/arm/plat-spear/padmux.c
index f30f94b..97e4d96 100644
--- a/arch/arm/plat-spear/padmux.c
+++ b/arch/arm/plat-spear/padmux.c
@@ -19,12 +19,10 @@
 /*
  * struct pmx: pmx definition structure
  *
- * base: base address of configuration registers
  * mode_reg: mode configurations
  * active_mode: pointer to current active mode
  */
 struct pmx {
-	u32 base;
 	struct pmx_reg mode_reg;
 	struct pmx_mode *active_mode;
 };
@@ -40,17 +38,22 @@ static struct pmx *pmx;
  */
 static int pmx_mode_set(struct pmx_mode *mode)
 {
-	u32 val;
+	u32 val, *address;
 
 	if (!mode->name)
 		return -EFAULT;
 
 	pmx->active_mode = mode;
 
-	val = readl(pmx->base + pmx->mode_reg.offset);
-	val &= ~pmx->mode_reg.mask;
-	val |= mode->value & pmx->mode_reg.mask;
-	writel(val, pmx->base + pmx->mode_reg.offset);
+	address = ioremap(pmx->mode_reg.address, SZ_16);
+	if (address) {
+		val = readl(address);
+		val &= ~pmx->mode_reg.mask;
+		val |= mode->value & pmx->mode_reg.mask;
+		writel(val, address);
+
+		iounmap(address);
+	}
 
 	return 0;
 }
@@ -70,6 +73,7 @@ static int pmx_mode_set(struct pmx_mode *mode)
 static int pmx_devs_enable(struct pmx_dev **devs, u8 count)
 {
 	u32 val, i;
+	u32 *address;
 
 	if (!count)
 		return -EINVAL;
@@ -104,10 +108,15 @@ static int pmx_devs_enable(struct pmx_dev **devs, u8 count)
 			struct pmx_mux_reg *mux_reg =
 				&devs[i]->modes[j].mux_regs[k];
 
-			val = readl(pmx->base + mux_reg->offset);
-			val &= ~mux_reg->mask;
-			val |= mux_reg->value & mux_reg->mask;
-			writel(val, pmx->base + mux_reg->offset);
+			address = ioremap(mux_reg->address, SZ_16);
+			if (address) {
+				val = readl(address);
+				val &= ~mux_reg->mask;
+				val |= mux_reg->value & mux_reg->mask;
+				writel(val, address);
+
+				iounmap(address);
+			}
 		}
 
 		devs[i]->is_active = true;
@@ -134,15 +143,14 @@ int pmx_register(struct pmx_driver *driver)
 
 	if (pmx)
 		return -EPERM;
-	if (!driver->base || !driver->devs)
+	if (!driver->devs)
 		return -EFAULT;
 
 	pmx = kzalloc(sizeof(*pmx), GFP_KERNEL);
 	if (!pmx)
 		return -ENOMEM;
 
-	pmx->base = (u32)driver->base;
-	pmx->mode_reg.offset = driver->mode_reg.offset;
+	pmx->mode_reg.address = driver->mode_reg.address;
 	pmx->mode_reg.mask = driver->mode_reg.mask;
 
 	/* choose mode to enable */
-- 
1.7.2.2


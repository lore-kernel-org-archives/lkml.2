Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab1JRSsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 14:48:05 -0400
Received: from mail.fuel7.com ([74.222.0.51]:59732 "EHLO mail.fuel7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047Ab1JRSsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 14:48:04 -0400
X-Greylist: delayed 1286 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Oct 2011 14:48:04 EDT
From: Kyle Manna <kyle.manna@fuel7.com>
To: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        Paul Walmsley <paul@pwsan.com>
Cc: Benoit Cousson <b-cousson@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Kyle Manna <kyle.manna@fuel7.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@ti.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: OMAP: Add support for AM35xx UART4/ttyO3
Date: Tue, 18 Oct 2011 13:47:41 -0500
Message-Id: <1318963661-27755-1-git-send-email-kyle.manna@fuel7.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add hwmod support to enable access to UART4 of the AM35xx series of
chips.  The UART4 device referenced from the TRM will show up as ttyO3.

This was tested on an AM3505.

Signed-off-by: Kyle Manna <kyle.manna@fuel7.com>
---
 arch/arm/mach-omap2/clock3xxx_data.c       |   11 ++++++
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |   52 ++++++++++++++++++++++++++++
 arch/arm/mach-omap2/prcm-common.h          |    2 +
 arch/arm/plat-omap/include/plat/irqs.h     |    2 +-
 arch/arm/plat-omap/include/plat/serial.h   |    1 +
 5 files changed, 67 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/clock3xxx_data.c b/arch/arm/mach-omap2/clock3xxx_data.c
index 5d0064a..4e1b1a2 100644
--- a/arch/arm/mach-omap2/clock3xxx_data.c
+++ b/arch/arm/mach-omap2/clock3xxx_data.c
@@ -2480,6 +2480,16 @@ static struct clk uart4_fck = {
 	.recalc		= &followparent_recalc,
 };
 
+static struct clk uart4_fck_am35xx = {
+	.name           = "uart4_fck",
+	.ops            = &clkops_omap2_dflt_wait,
+	.parent         = &per_48m_fck,
+	.enable_reg     = OMAP_CM_REGADDR(CORE_MOD, CM_FCLKEN1),
+	.enable_bit     = OMAP3430_EN_UART4_SHIFT,
+	.clkdm_name     = "core_l4_clkdm",
+	.recalc         = &followparent_recalc,
+};
+
 static struct clk gpt2_fck = {
 	.name		= "gpt2_fck",
 	.ops		= &clkops_omap2_dflt_wait,
@@ -3403,6 +3413,7 @@ static struct omap_clk omap3xxx_clks[] = {
 	CLK(NULL,	"per_48m_fck",	&per_48m_fck,	CK_3XXX),
 	CLK(NULL,	"uart3_fck",	&uart3_fck,	CK_3XXX),
 	CLK(NULL,	"uart4_fck",	&uart4_fck,	CK_36XX),
+	CLK(NULL,	"uart4_fck",	&uart4_fck_am35xx, CK_3505 | CK_3517),
 	CLK(NULL,	"gpt2_fck",	&gpt2_fck,	CK_3XXX),
 	CLK(NULL,	"gpt3_fck",	&gpt3_fck,	CK_3XXX),
 	CLK(NULL,	"gpt4_fck",	&gpt4_fck,	CK_3XXX),
diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index caa4117..8c54531 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -164,6 +164,7 @@ static struct omap_hwmod omap3xxx_uart1_hwmod;
 static struct omap_hwmod omap3xxx_uart2_hwmod;
 static struct omap_hwmod omap3xxx_uart3_hwmod;
 static struct omap_hwmod omap3xxx_uart4_hwmod;
+static struct omap_hwmod am35xx_uart4_hwmod;
 static struct omap_hwmod omap3xxx_usbhsotg_hwmod;
 
 /* l3_core -> usbhsotg interface */
@@ -299,6 +300,23 @@ static struct omap_hwmod_ocp_if omap3_l4_per__uart4 = {
 	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
 
+/* AM35xx: L4 CORE -> UART4 interface */
+static struct omap_hwmod_addr_space am35xx_uart4_addr_space[] = {
+	{
+		.pa_start       = OMAP3_UART4_AM35XX_BASE,
+		.pa_end         = OMAP3_UART4_AM35XX_BASE + SZ_1K - 1,
+		.flags          = ADDR_MAP_ON_INIT | ADDR_TYPE_RT,
+	},
+};
+
+static struct omap_hwmod_ocp_if am35xx_l4_core__uart4 = {
+	.master         = &omap3xxx_l4_core_hwmod,
+	.slave          = &am35xx_uart4_hwmod,
+	.clk            = "uart4_ick",
+	.addr           = am35xx_uart4_addr_space,
+	.user           = OCP_USER_MPU | OCP_USER_SDMA,
+};
+
 /* L4 CORE -> I2C1 interface */
 static struct omap_hwmod_ocp_if omap3_l4_core__i2c1 = {
 	.master		= &omap3xxx_l4_core_hwmod,
@@ -1309,6 +1327,39 @@ static struct omap_hwmod omap3xxx_uart4_hwmod = {
 	.class		= &omap2_uart_class,
 };
 
+static struct omap_hwmod_irq_info am35xx_uart4_mpu_irqs[] = {
+	{ .irq = INT_35XX_UART4_IRQ, },
+};
+
+static struct omap_hwmod_dma_info am35xx_uart4_sdma_reqs[] = {
+	{ .name = "rx", .dma_req = AM35XX_DMA_UART4_RX, },
+	{ .name = "tx", .dma_req = AM35XX_DMA_UART4_TX, },
+};
+
+static struct omap_hwmod_ocp_if *am35xx_uart4_slaves[] = {
+	&am35xx_l4_core__uart4,
+};
+
+static struct omap_hwmod am35xx_uart4_hwmod = {
+	.name           = "uart4",
+	.mpu_irqs       = am35xx_uart4_mpu_irqs,
+	.sdma_reqs      = am35xx_uart4_sdma_reqs,
+	.main_clk       = "uart4_fck",
+	.prcm           = {
+		.omap2 = {
+			.module_offs = CORE_MOD,
+			.prcm_reg_id = 1,
+			.module_bit = OMAP3430_EN_UART4_SHIFT,
+			.idlest_reg_id = 1,
+			.idlest_idle_bit = OMAP3430_EN_UART4_SHIFT,
+		},
+	},
+	.slaves         = am35xx_uart4_slaves,
+	.slaves_cnt     = ARRAY_SIZE(am35xx_uart4_slaves),
+	.class          = &omap2_uart_class,
+};
+
+
 static struct omap_hwmod_class i2c_class = {
 	.name	= "i2c",
 	.sysc	= &i2c_sysc,
@@ -3254,6 +3305,7 @@ static __initdata struct omap_hwmod *omap36xx_hwmods[] = {
 static __initdata struct omap_hwmod *am35xx_hwmods[] = {
 	&omap3xxx_dss_core_hwmod, /* XXX ??? */
 	&am35xx_usbhsotg_hwmod,
+	&am35xx_uart4_hwmod,
 	NULL
 };
 
diff --git a/arch/arm/mach-omap2/prcm-common.h b/arch/arm/mach-omap2/prcm-common.h
index 0363dcb..da2d80f 100644
--- a/arch/arm/mach-omap2/prcm-common.h
+++ b/arch/arm/mach-omap2/prcm-common.h
@@ -201,6 +201,8 @@
 #define OMAP3430_EN_MMC2_SHIFT				25
 #define OMAP3430_EN_MMC1_MASK				(1 << 24)
 #define OMAP3430_EN_MMC1_SHIFT				24
+#define OMAP3430_EN_UART4_MASK				(1 << 23)
+#define OMAP3430_EN_UART4_SHIFT				23
 #define OMAP3430_EN_MCSPI4_MASK				(1 << 21)
 #define OMAP3430_EN_MCSPI4_SHIFT			21
 #define OMAP3430_EN_MCSPI3_MASK				(1 << 20)
diff --git a/arch/arm/plat-omap/include/plat/irqs.h b/arch/arm/plat-omap/include/plat/irqs.h
index 30e1071..6e5d3a0 100644
--- a/arch/arm/plat-omap/include/plat/irqs.h
+++ b/arch/arm/plat-omap/include/plat/irqs.h
@@ -357,7 +357,7 @@
 #define INT_35XX_EMAC_C0_TX_PULSE_IRQ	69
 #define INT_35XX_EMAC_C0_MISC_PULSE_IRQ	70
 #define INT_35XX_USBOTG_IRQ		71
-#define INT_35XX_UART4			84
+#define INT_35XX_UART4_IRQ		84
 #define INT_35XX_CCDC_VD0_IRQ		88
 #define INT_35XX_CCDC_VD1_IRQ		92
 #define INT_35XX_CCDC_VD2_IRQ		93
diff --git a/arch/arm/plat-omap/include/plat/serial.h b/arch/arm/plat-omap/include/plat/serial.h
index 1ab9fd6..865a2ba 100644
--- a/arch/arm/plat-omap/include/plat/serial.h
+++ b/arch/arm/plat-omap/include/plat/serial.h
@@ -44,6 +44,7 @@
 #define OMAP3_UART2_BASE	OMAP2_UART2_BASE
 #define OMAP3_UART3_BASE	0x49020000
 #define OMAP3_UART4_BASE	0x49042000	/* Only on 36xx */
+#define OMAP3_UART4_AM35XX_BASE	0x4809E000	/* Only on AM35xx */
 
 /* OMAP4 serial ports */
 #define OMAP4_UART1_BASE	OMAP2_UART1_BASE
-- 
1.7.5.4


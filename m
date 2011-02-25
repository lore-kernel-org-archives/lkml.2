Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab1BYIqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 03:46:08 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58729 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab1BYIqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 03:46:07 -0500
From: Pratheesh Gangadhar <pratheesh@ti.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: hjk@hansjkoch.de, gregkh@suse.de, tglx@linutronix.de, sshtylyov@mvista.com,
        arnd@arndb.de, pratheesh@ti.com, amit.chatterjee@ti.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v5 2/2] Defines DA850/AM18xx/OMAPL1-38 SOC resources used by PRUSS UIO driver
Date: Fri, 25 Feb 2011 14:15:30 +0530
Message-Id: <1298623530-10294-3-git-send-email-pratheesh@ti.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1298623530-10294-2-git-send-email-pratheesh@ti.com>
References: <1298623530-10294-1-git-send-email-pratheesh@ti.com>
 <1298623530-10294-2-git-send-email-pratheesh@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defines PRUSS, ECAP clocks, memory and IRQ resources
used by PRUSS UIO driver in DA850/AM18xx/OMAPL1-38 devices. UIO
driver exports 64K I/O region of PRUSS, 128KB L3 RAM and 256KB
DDR buffer to user space. PRUSS has 8 host event interrupt lines
mapped to IRQ_DA8XX_EVTOUT0..7 of ARM9 INTC.These in conjunction
with shared memory can be used to implement IPC between ARM9 and
PRUSS.

Signed-off-by: Pratheesh Gangadhar <pratheesh@ti.com>
---
 arch/arm/mach-davinci/board-da850-evm.c    |    4 ++
 arch/arm/mach-davinci/da850.c              |   35 +++++++++++++
 arch/arm/mach-davinci/devices-da8xx.c      |   73 ++++++++++++++++++++++++++++
 arch/arm/mach-davinci/include/mach/da8xx.h |    3 +
 4 files changed, 115 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 11f986b..bd85aa3 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -1077,6 +1077,10 @@ static __init void da850_evm_init(void)
 		pr_warning("da850_evm_init: i2c0 registration failed: %d\n",
 				ret);
 
+	ret = da8xx_register_pruss();
+	if (ret)
+		pr_warning("da850_evm_init: pruss registration failed: %d\n",
+				ret);
 
 	ret = da8xx_register_watchdog();
 	if (ret)
diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index 3443d97..0096d4f 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -238,6 +238,13 @@ static struct clk tptc2_clk = {
 	.flags		= ALWAYS_ENABLED,
 };
 
+static struct clk pruss_clk = {
+	.name		= "pruss",
+	.parent		= &pll0_sysclk2,
+	.lpsc		= DA8XX_LPSC0_DMAX,
+	.flags		= ALWAYS_ENABLED,
+};
+
 static struct clk uart0_clk = {
 	.name		= "uart0",
 	.parent		= &pll0_sysclk2,
@@ -359,6 +366,30 @@ static struct clk usb20_clk = {
 	.gpsc		= 1,
 };
 
+static struct clk ecap0_clk = {
+	.name		= "ecap0",
+	.parent		= &pll0_sysclk2,
+	.lpsc		= DA8XX_LPSC1_ECAP,
+	.flags		= DA850_CLK_ASYNC3,
+	.gpsc		= 1,
+};
+
+static struct clk ecap1_clk = {
+	.name		= "ecap1",
+	.parent		= &pll0_sysclk2,
+	.lpsc		= DA8XX_LPSC1_ECAP,
+	.flags		= DA850_CLK_ASYNC3,
+	.gpsc		= 1,
+};
+
+static struct clk ecap2_clk = {
+	.name		= "ecap2",
+	.parent		= &pll0_sysclk2,
+	.lpsc		= DA8XX_LPSC1_ECAP,
+	.flags		= DA850_CLK_ASYNC3,
+	.gpsc		= 1,
+};
+
 static struct clk_lookup da850_clks[] = {
 	CLK(NULL,		"ref",		&ref_clk),
 	CLK(NULL,		"pll0",		&pll0_clk),
@@ -386,6 +417,7 @@ static struct clk_lookup da850_clks[] = {
 	CLK(NULL,		"tptc1",	&tptc1_clk),
 	CLK(NULL,		"tpcc1",	&tpcc1_clk),
 	CLK(NULL,		"tptc2",	&tptc2_clk),
+	CLK(NULL,		"pruss",	&pruss_clk),
 	CLK(NULL,		"uart0",	&uart0_clk),
 	CLK(NULL,		"uart1",	&uart1_clk),
 	CLK(NULL,		"uart2",	&uart2_clk),
@@ -403,6 +435,9 @@ static struct clk_lookup da850_clks[] = {
 	CLK(NULL,		"aemif",	&aemif_clk),
 	CLK(NULL,		"usb11",	&usb11_clk),
 	CLK(NULL,		"usb20",	&usb20_clk),
+	CLK(NULL,		"ecap0",	&ecap0_clk),
+	CLK(NULL,		"ecap1",	&ecap1_clk),
+	CLK(NULL,		"ecap2",	&ecap2_clk),
 	CLK(NULL,		NULL,		NULL),
 };
 
diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
index beda8a4..4ea3d1f 100644
--- a/arch/arm/mach-davinci/devices-da8xx.c
+++ b/arch/arm/mach-davinci/devices-da8xx.c
@@ -725,3 +725,76 @@ int __init da8xx_register_cpuidle(void)
 
 	return platform_device_register(&da8xx_cpuidle_device);
 }
+static struct resource pruss_resources[] = {
+	[0] = {
+		.start  = DA8XX_PRUSS_BASE,
+		.end    = DA8XX_PRUSS_BASE + SZ_64K - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = DA8XX_L3RAM_BASE,
+		.end    = DA8XX_L3RAM_BASE + SZ_128K - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	[2] = {
+		.start  = 0,
+		.end    = SZ_256K - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+
+	[3] = {
+		.start  = IRQ_DA8XX_EVTOUT0,
+		.end    = IRQ_DA8XX_EVTOUT0,
+		.flags  = IORESOURCE_IRQ,
+	},
+	[4] = {
+		.start  = IRQ_DA8XX_EVTOUT1,
+		.end    = IRQ_DA8XX_EVTOUT1,
+		.flags  = IORESOURCE_IRQ,
+	},
+	[5] = {
+		.start  = IRQ_DA8XX_EVTOUT2,
+		.end    = IRQ_DA8XX_EVTOUT2,
+		.flags  = IORESOURCE_IRQ,
+	},
+	[6] = {
+		.start  = IRQ_DA8XX_EVTOUT3,
+		.end    = IRQ_DA8XX_EVTOUT3,
+		.flags  = IORESOURCE_IRQ,
+	},
+	[7] = {
+		.start  = IRQ_DA8XX_EVTOUT4,
+		.end    = IRQ_DA8XX_EVTOUT4,
+		.flags  = IORESOURCE_IRQ,
+	},
+	[8] = {
+		.start  = IRQ_DA8XX_EVTOUT5,
+		.end    = IRQ_DA8XX_EVTOUT5,
+		.flags  = IORESOURCE_IRQ,
+	},
+	[9] = {
+		.start  = IRQ_DA8XX_EVTOUT6,
+		.end    = IRQ_DA8XX_EVTOUT6,
+		.flags  = IORESOURCE_IRQ,
+	},
+	[10] = {
+		.start  = IRQ_DA8XX_EVTOUT7,
+		.end    = IRQ_DA8XX_EVTOUT7,
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device pruss_device = {
+	.name			= "pruss",
+	.id			= 0,
+	.num_resources		= ARRAY_SIZE(pruss_resources),
+	.resource		= pruss_resources,
+	.dev	 =	{
+		.coherent_dma_mask = 0xffffffff,
+	}
+};
+
+int __init da8xx_register_pruss()
+{
+	return platform_device_register(&pruss_device);
+}
diff --git a/arch/arm/mach-davinci/include/mach/da8xx.h b/arch/arm/mach-davinci/include/mach/da8xx.h
index cfcb223..3ed6ee0 100644
--- a/arch/arm/mach-davinci/include/mach/da8xx.h
+++ b/arch/arm/mach-davinci/include/mach/da8xx.h
@@ -60,6 +60,7 @@ extern unsigned int da850_max_speed;
 #define DA8XX_PLL0_BASE		0x01c11000
 #define DA8XX_TIMER64P0_BASE	0x01c20000
 #define DA8XX_TIMER64P1_BASE	0x01c21000
+#define DA8XX_PRUSS_BASE	0x01c30000
 #define DA8XX_GPIO_BASE		0x01e26000
 #define DA8XX_PSC1_BASE		0x01e27000
 #define DA8XX_LCD_CNTRL_BASE	0x01e13000
@@ -68,6 +69,7 @@ extern unsigned int da850_max_speed;
 #define DA8XX_AEMIF_CS2_BASE	0x60000000
 #define DA8XX_AEMIF_CS3_BASE	0x62000000
 #define DA8XX_AEMIF_CTL_BASE	0x68000000
+#define DA8XX_L3RAM_BASE	0x80000000
 #define DA8XX_DDR2_CTL_BASE	0xb0000000
 #define DA8XX_ARM_RAM_BASE	0xffff0000
 
@@ -90,6 +92,7 @@ int da850_register_cpufreq(char *async_clk);
 int da8xx_register_cpuidle(void);
 void __iomem * __init da8xx_get_mem_ctlr(void);
 int da850_register_pm(struct platform_device *pdev);
+int da8xx_register_pruss(void);
 
 extern struct platform_device da8xx_serial_device;
 extern struct emac_platform_data da8xx_emac_pdata;
-- 
1.6.0.6


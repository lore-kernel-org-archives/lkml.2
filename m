Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab2HMLYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 07:24:30 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:56233 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab2HMLY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 07:24:28 -0400
From: tobetter@gmail.com
Cc: Dongjin Kim <dongjin.kim@agreeyamobility.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Changhwan Youn <chaos.youn@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: EXYNOS: Add audio I2S clock control
Date: Mon, 13 Aug 2012 20:24:04 +0900
Message-Id: <1344857054-6688-1-git-send-email-dongjin.kim@agreeyamobility.net>
X-Mailer: git-send-email 1.7.9.5
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongjin Kim <dongjin.kim@agreeyamobility.net>

This patch adds the clock controls for the audio subsystem channel 0,
and fixes invalid clock gating for i2s.0.

Signed-off-by: Dongjin Kim <dongjin.kim@agreeyamobility.net>
---
 arch/arm/mach-exynos/clock-exynos4.c           |  254 +++++++++++++++++++++++-
 arch/arm/mach-exynos/common.c                  |    5 +
 arch/arm/mach-exynos/include/mach/map.h        |    2 +
 arch/arm/mach-exynos/include/mach/regs-audss.h |    6 +
 arch/arm/plat-samsung/include/plat/map-s5p.h   |    2 +
 5 files changed, 263 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-exynos/clock-exynos4.c b/arch/arm/mach-exynos/clock-exynos4.c
index 2dc96f4..a3478db 100644
--- a/arch/arm/mach-exynos/clock-exynos4.c
+++ b/arch/arm/mach-exynos/clock-exynos4.c
@@ -24,6 +24,7 @@
 
 #include <mach/map.h>
 #include <mach/regs-clock.h>
+#include <mach/regs-audss.h>
 #include <mach/sysmmu.h>
 
 #include "common.h"
@@ -198,6 +199,11 @@ static int exynos4_clk_ip_perir_ctrl(struct clk *clk, int enable)
 	return s5p_gatectrl(EXYNOS4_CLKGATE_IP_PERIR, clk, enable);
 }
 
+static int exynos4_clk_vpll_ctrl(struct clk *clk, int enable)
+{
+	return s5p_gatectrl(EXYNOS4_VPLL_CON0, clk, enable);
+}
+
 int exynos4_clk_ip_dmc_ctrl(struct clk *clk, int enable)
 {
 	return s5p_gatectrl(EXYNOS4_CLKGATE_IP_DMC, clk, enable);
@@ -213,6 +219,16 @@ static int exynos4_clk_dac_ctrl(struct clk *clk, int enable)
 	return s5p_gatectrl(S5P_DAC_PHY_CONTROL, clk, enable);
 }
 
+static int exynos4_clksrc_mask_maudio_ctrl(struct clk *clk, int enable)
+{
+	return s5p_gatectrl(EXYNOS4_CLKSRC_MASK_MAUDIO, clk, enable);
+}
+
+int exynos4_clk_audss_ctrl(struct clk *clk, int enable)
+{
+	return s5p_gatectrl(S5P_CLKGATE_AUDSS, clk, enable);
+}
+
 /* Core list of CMU_CPU side */
 
 static struct clksrc_clk exynos4_clk_mout_apll = {
@@ -451,6 +467,25 @@ static struct clksrc_sources exynos4_clkset_sclk_vpll = {
 	.nr_sources	= ARRAY_SIZE(exynos4_clkset_sclk_vpll_list),
 };
 
+static struct clk *exynos4_clkset_mout_audss_list[] = {
+	&clk_ext_xtal_mux,
+	&clk_fout_epll,
+};
+
+static struct clksrc_sources clkset_mout_audss = {
+	.sources	= exynos4_clkset_mout_audss_list,
+	.nr_sources	= ARRAY_SIZE(exynos4_clkset_mout_audss_list),
+};
+
+static struct clksrc_clk exynos4_clk_mout_audss = {
+	.clk	= {
+		.name		= "mout_audss",
+	},
+	.sources = &clkset_mout_audss,
+	.reg_src = { .reg = S5P_CLKSRC_AUDSS, .shift = 0, .size = 1 },
+};
+
+
 static struct clksrc_clk exynos4_clk_sclk_vpll = {
 	.clk	= {
 		.name		= "sclk_vpll",
@@ -459,6 +494,43 @@ static struct clksrc_clk exynos4_clk_sclk_vpll = {
 	.reg_src = { .reg = EXYNOS4_CLKSRC_TOP0, .shift = 8, .size = 1 },
 };
 
+static struct clksrc_clk exynos4_clk_dout_audss_srp = {
+	.clk	= {
+		.name		= "dout_srp",
+		.parent		= &exynos4_clk_mout_audss.clk,
+	},
+	.reg_div = { .reg = S5P_CLKDIV_AUDSS, .shift = 0, .size = 4 },
+};
+
+static struct clksrc_clk exynos4_clk_sclk_audss_bus = {
+	.clk	= {
+		.name		= "busclk",
+		.parent		= &exynos4_clk_dout_audss_srp.clk,
+		.enable		= exynos4_clk_audss_ctrl,
+		.ctrlbit	= (1 << 2),
+	},
+	.reg_div = { .reg = S5P_CLKDIV_AUDSS, .shift = 4, .size = 4 },
+};
+
+static struct clk exynos4_init_audss_clocks[] = {
+	{
+		.name		= "srpclk",
+		.enable		= exynos4_clk_audss_ctrl,
+		.parent		= &exynos4_clk_dout_audss_srp.clk,
+		.ctrlbit	= (1 << 0),
+	}, {
+		.name		= "iis",
+		.devname	= "samsung-i2s.0",
+		.enable		= exynos4_clk_audss_ctrl,
+		.ctrlbit	= (1 << 3) | (1 << 2),
+	}, {
+		.name		= "pcm",
+		.devname	= "samsung-pcm.0",
+		.enable		= exynos4_clk_audss_ctrl,
+		.ctrlbit	= (1 << 5),
+	},
+};
+
 static struct clk exynos4_init_clocks_off[] = {
 	{
 		.name		= "timers",
@@ -601,11 +673,6 @@ static struct clk exynos4_init_clocks_off[] = {
 		.ctrlbit	= (1 << 18),
 	}, {
 		.name		= "iis",
-		.devname	= "samsung-i2s.0",
-		.enable		= exynos4_clk_ip_peril_ctrl,
-		.ctrlbit	= (1 << 19),
-	}, {
-		.name		= "iis",
 		.devname	= "samsung-i2s.1",
 		.enable		= exynos4_clk_ip_peril_ctrl,
 		.ctrlbit	= (1 << 20),
@@ -728,7 +795,65 @@ static struct clk exynos4_init_clocks_off[] = {
 		.devname	= SYSMMU_CLOCK_DEVNAME(fimd0, 10),
 		.enable		= exynos4_clk_ip_lcd0_ctrl,
 		.ctrlbit	= (1 << 4),
-	}
+	},
+};
+
+struct clksrc_clk exynos4_clk_audiocdclk0 = {
+	.clk	= {
+		.name		= "audiocdclk",
+		.rate		= 16934400,
+	},
+};
+
+static struct clk *clkset_sclk_audio0_list[] = {
+	[0] = &exynos4_clk_audiocdclk0.clk,
+	[1] = NULL,
+	[2] = &exynos4_clk_sclk_hdmi27m,
+	[3] = &exynos4_clk_sclk_usbphy0,
+	[4] = &clk_ext_xtal_mux,
+	[5] = &clk_xusbxti,
+	[6] = &exynos4_clk_mout_mpll.clk,
+	[7] = &exynos4_clk_mout_epll.clk,
+	[8] = &exynos4_clk_sclk_vpll.clk,
+};
+
+static struct clksrc_sources exynos4_clkset_sclk_audio0 = {
+	.sources	= clkset_sclk_audio0_list,
+	.nr_sources	= ARRAY_SIZE(clkset_sclk_audio0_list),
+};
+
+static struct clksrc_clk exynos4_clk_sclk_audio0 = {
+	.clk	= {
+		.name		= "audio-bus",
+		.enable		= exynos4_clksrc_mask_maudio_ctrl,
+		.ctrlbit	= (1 << 0),
+	},
+	.sources = &exynos4_clkset_sclk_audio0,
+	.reg_src = { .reg = EXYNOS4_CLKSRC_MAUDIO, .shift = 0, .size = 4 },
+	.reg_div = { .reg = EXYNOS4_CLKDIV_MAUDIO, .shift = 0, .size = 4 },
+};
+
+static struct clk *exynos4_clkset_sclk_audss_list[] = {
+	&exynos4_clk_mout_audss.clk,
+	&exynos4_clk_audiocdclk0.clk,
+	&exynos4_clk_sclk_audio0.clk,
+};
+
+static struct clksrc_sources exynos4_clkset_sclk_audss = {
+	.sources	= exynos4_clkset_sclk_audss_list,
+	.nr_sources	= ARRAY_SIZE(exynos4_clkset_sclk_audss_list),
+};
+
+static struct clksrc_clk exynos4_clk_sclk_audss_i2s = {
+	.clk		= {
+		.name		= "i2sclk",
+		.parent		= &exynos4_clk_mout_audss.clk,
+		.enable		= exynos4_clk_audss_ctrl,
+		.ctrlbit	= (1 << 3),
+	},
+	.sources = &exynos4_clkset_sclk_audss,
+	.reg_src = { .reg = S5P_CLKSRC_AUDSS, .shift = 2, .size = 2 },
+	.reg_div = { .reg = S5P_CLKDIV_AUDSS, .shift = 8, .size = 4 },
 };
 
 static struct clk exynos4_init_clocks_on[] = {
@@ -1271,6 +1396,14 @@ static struct clksrc_clk exynos4_clk_sclk_spi2 = {
 	.reg_div = { .reg = EXYNOS4_CLKDIV_PERIL2, .shift = 8, .size = 8 },
 };
 
+static struct clksrc_clk exynos4_clk_sclk_pcm0 = {
+	.clk	= {
+		.name		= "sclk_pcm",
+		.parent		= &exynos4_clk_sclk_audio0.clk,
+	},
+	.reg_div = { .reg = EXYNOS4_CLKDIV_MAUDIO, .shift = 4, .size = 8 },
+};
+
 /* Clock initialization code */
 static struct clksrc_clk *exynos4_sysclks[] = {
 	&exynos4_clk_mout_apll,
@@ -1303,6 +1436,13 @@ static struct clksrc_clk *exynos4_sysclks[] = {
 	&exynos4_clk_dout_mmc4,
 	&exynos4_clk_mout_mfc0,
 	&exynos4_clk_mout_mfc1,
+	&exynos4_clk_audiocdclk0,
+	&exynos4_clk_mout_audss,
+	&exynos4_clk_sclk_audss_bus,
+	&exynos4_clk_sclk_audss_i2s,
+	&exynos4_clk_dout_audss_srp,
+	&exynos4_clk_sclk_audio0,
+	&exynos4_clk_sclk_pcm0,
 };
 
 static struct clk *exynos4_clk_cdev[] = {
@@ -1430,6 +1570,92 @@ static struct clk_ops exynos4_vpll_ops = {
 	.set_rate = exynos4_vpll_set_rate,
 };
 
+static unsigned long exynos4_epll_get_rate(struct clk *clk)
+{
+	return clk->rate;
+}
+
+static u32 epll_div[][6] = {
+	{ 192000000, 0, 48, 3, 1, 0 },
+	{ 180000000, 0, 45, 3, 1, 0 },
+	{  73728000, 1, 73, 3, 3, 47710 },
+	{  67737600, 1, 90, 4, 3, 20762 },
+	{  49152000, 0, 49, 3, 3, 9961 },
+	{  45158400, 0, 45, 3, 3, 10381 },
+	{ 180633600, 0, 45, 3, 1, 10381 },
+};
+
+static int exynos4_epll_set_rate(struct clk *clk, unsigned long rate)
+{
+	unsigned int epll_con, epll_con_k;
+	unsigned int i;
+	unsigned int tmp;
+	unsigned int epll_rate;
+	unsigned int locktime;
+	unsigned int lockcnt;
+
+	/* Return if nothing changed */
+	if (clk->rate == rate)
+		return 0;
+
+	if (clk->parent)
+		epll_rate = clk_get_rate(clk->parent);
+	else
+		epll_rate = clk_ext_xtal_mux.rate;
+
+	if (epll_rate != 24000000) {
+		pr_err("Invalid Clock : recommended clock is 24MHz.\n");
+		return -EINVAL;
+	}
+
+
+	epll_con = __raw_readl(EXYNOS4_EPLL_CON0);
+	epll_con &= ~(0x1 << 27 | \
+			PLL46XX_MDIV_MASK << PLL46XX_MDIV_SHIFT |   \
+			PLL46XX_PDIV_MASK << PLL46XX_PDIV_SHIFT | \
+			PLL46XX_SDIV_MASK << PLL46XX_SDIV_SHIFT);
+
+	for (i = 0; i < ARRAY_SIZE(epll_div); i++) {
+		if (epll_div[i][0] == rate) {
+			epll_con_k = epll_div[i][5] << 0;
+			epll_con |= epll_div[i][1] << 27;
+			epll_con |= epll_div[i][2] << PLL46XX_MDIV_SHIFT;
+			epll_con |= epll_div[i][3] << PLL46XX_PDIV_SHIFT;
+			epll_con |= epll_div[i][4] << PLL46XX_SDIV_SHIFT;
+			break;
+		}
+	}
+
+	if (i == ARRAY_SIZE(epll_div)) {
+		pr_err("%s: Invalid Clock EPLL Frequency\n", __func__);
+		return -EINVAL;
+	}
+
+	epll_rate /= 1000000;
+
+	/* 3000 max_cycls : specification data */
+	locktime = 3000 / epll_rate * epll_div[i][3];
+	lockcnt = locktime * 10000 / (10000 / epll_rate);
+
+	__raw_writel(lockcnt, EXYNOS4_EPLL_LOCK);
+
+	__raw_writel(epll_con, EXYNOS4_EPLL_CON0);
+	__raw_writel(epll_con_k, EXYNOS4_EPLL_CON1);
+
+	do {
+		tmp = __raw_readl(EXYNOS4_EPLL_CON0);
+	} while (!(tmp & 0x1 << EXYNOS4_EPLLCON0_LOCKED_SHIFT));
+
+	clk->rate = rate;
+
+	return 0;
+}
+
+static struct clk_ops exynos4_epll_ops = {
+	.get_rate = exynos4_epll_get_rate,
+	.set_rate = exynos4_epll_set_rate,
+};
+
 void __init_or_cpufreq exynos4_setup_clocks(void)
 {
 	struct clk *xtal_clk;
@@ -1486,6 +1712,7 @@ void __init_or_cpufreq exynos4_setup_clocks(void)
 
 	clk_fout_apll.ops = &exynos4_fout_apll_ops;
 	clk_fout_mpll.rate = mpll;
+	clk_fout_epll.ops = &exynos4_epll_ops;
 	clk_fout_epll.rate = epll;
 	clk_fout_vpll.ops = &exynos4_vpll_ops;
 	clk_fout_vpll.rate = vpll;
@@ -1510,6 +1737,16 @@ void __init_or_cpufreq exynos4_setup_clocks(void)
 	clk_h.rate = sclk_dmc;
 	clk_p.rate = aclk_100;
 
+	clk_set_parent(&exynos4_clk_mout_audss.clk, &clk_fout_epll);
+	clk_set_parent(&exynos4_clk_sclk_audio0.clk,
+			&exynos4_clk_mout_epll.clk);
+	clk_set_parent(&exynos4_clk_mout_epll.clk, &clk_fout_epll);
+
+	clk_fout_vpll.enable = exynos4_clk_vpll_ctrl;
+	clk_fout_vpll.ops = &exynos4_vpll_ops;
+
+	clk_set_rate(&exynos4_clk_sclk_apll.clk, 100000000);
+
 	for (ptr = 0; ptr < ARRAY_SIZE(exynos4_clksrcs); ptr++)
 		s3c_set_clksrc(&exynos4_clksrcs[ptr], true);
 }
@@ -1569,6 +1806,11 @@ void __init exynos4_register_clocks(void)
 	s3c_disable_clocks(exynos4_init_clocks_off, ARRAY_SIZE(exynos4_init_clocks_off));
 	clkdev_add_table(exynos4_clk_lookup, ARRAY_SIZE(exynos4_clk_lookup));
 
+	s3c_register_clocks(exynos4_init_audss_clocks,
+				ARRAY_SIZE(exynos4_init_audss_clocks));
+	s3c_disable_clocks(exynos4_init_audss_clocks,
+				ARRAY_SIZE(exynos4_init_audss_clocks));
+
 	register_syscore_ops(&exynos4_clock_syscore_ops);
 	s3c24xx_register_clock(&dummy_apb_pclk);
 
diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
index 94d58af..9450651 100644
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@ -198,6 +198,11 @@ static struct map_desc exynos4_iodesc[] __initdata = {
 		.pfn		= __phys_to_pfn(EXYNOS4_PA_HSPHY),
 		.length		= SZ_4K,
 		.type		= MT_DEVICE,
+	}, {
+		.virtual        = (unsigned long)S5P_VA_AUDSS,
+		.pfn            = __phys_to_pfn(EXYNOS4_PA_AUDSS),
+		.length         = SZ_4K,
+		.type           = MT_DEVICE,
 	},
 };
 
diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-exynos/include/mach/map.h
index c72b675..2f8a16f 100644
--- a/arch/arm/mach-exynos/include/mach/map.h
+++ b/arch/arm/mach-exynos/include/mach/map.h
@@ -34,6 +34,8 @@
 
 #define EXYNOS4_PA_JPEG			0x11840000
 
+#define EXYNOS4_PA_AUDSS		0x03810000
+
 /* x = 0...1 */
 #define EXYNOS4_PA_FIMC_LITE(x)		(0x12390000 + ((x) * 0x10000))
 
diff --git a/arch/arm/mach-exynos/include/mach/regs-audss.h b/arch/arm/mach-exynos/include/mach/regs-audss.h
index ca5a8b6..e75b959 100644
--- a/arch/arm/mach-exynos/include/mach/regs-audss.h
+++ b/arch/arm/mach-exynos/include/mach/regs-audss.h
@@ -15,4 +15,10 @@
 
 #define EXYNOS4_AUDSS_INT_MEM	(0x03000000)
 
+#define EXYNOS4_AUDSSREG(x)	(S5P_VA_AUDSS + (x))
+
+#define S5P_CLKSRC_AUDSS	EXYNOS4_AUDSSREG(0x0)
+#define S5P_CLKDIV_AUDSS	EXYNOS4_AUDSSREG(0x4)
+#define S5P_CLKGATE_AUDSS	EXYNOS4_AUDSSREG(0x8)
+
 #endif /* _PLAT_REGS_AUDSS_H */
diff --git a/arch/arm/plat-samsung/include/plat/map-s5p.h b/arch/arm/plat-samsung/include/plat/map-s5p.h
index c2d7bda..3558277 100644
--- a/arch/arm/plat-samsung/include/plat/map-s5p.h
+++ b/arch/arm/plat-samsung/include/plat/map-s5p.h
@@ -40,6 +40,8 @@
 #define S5P_VA_GIC_CPU		S3C_ADDR(0x02810000)
 #define S5P_VA_GIC_DIST		S3C_ADDR(0x02820000)
 
+#define S5P_VA_AUDSS		S3C_ADDR(0x02910000)
+
 #define VA_VIC(x)		(S3C_VA_IRQ + ((x) * 0x10000))
 #define VA_VIC0			VA_VIC(0)
 #define VA_VIC1			VA_VIC(1)
-- 
1.7.9.5


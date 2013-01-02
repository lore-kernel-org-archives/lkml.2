Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab3ABN0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 08:26:10 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46003 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649Ab3ABN0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 08:26:06 -0500
From: Philip Avinash <avinashphilip@ti.com>
To: <tony@atomide.com>, <paul@pwsan.com>, <linux@arm.linux.org.uk>,
        <b-cousson@ti.com>
CC: <hvaibhav@ti.com>, <anilkumar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>, <vaibhav.bedia@ti.com>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 4/7] ARM: AM33XX: clk: Add clock node for EHRPWM TBCLK
Date: Wed, 2 Jan 2013 18:54:51 +0530
Message-ID: <1357133094-30806-5-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357133094-30806-1-git-send-email-avinashphilip@ti.com>
References: <1357133094-30806-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EHRPWM module requires explicit clock gating of TBCLK from control
module. Hence add TBCLK clock node in clock tree for EHRPWM modules.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
- common clock frame work support

 arch/arm/mach-omap2/cclock33xx_data.c |   30 ++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/control.h         |    8 ++++++++
 2 files changed, 38 insertions(+)

diff --git a/arch/arm/mach-omap2/cclock33xx_data.c b/arch/arm/mach-omap2/cclock33xx_data.c
index ea64ad6..7ff9bc9 100644
--- a/arch/arm/mach-omap2/cclock33xx_data.c
+++ b/arch/arm/mach-omap2/cclock33xx_data.c
@@ -832,6 +832,33 @@ static struct clk_hw_omap wdt1_fck_hw = {
 
 DEFINE_STRUCT_CLK(wdt1_fck, wdt_ck_parents, gpio_fck_ops);
 
+static const char *pwmss_clk_parents[] = {
+	"dpll_per_m2_ck",
+};
+
+static const struct clk_ops ehrpwm_tbclk_ops = {
+	.enable		= &omap2_dflt_clk_enable,
+	.disable	= &omap2_dflt_clk_disable,
+};
+
+DEFINE_CLK_OMAP_MUX_GATE(ehrpwm0_tbclk, "l4ls_clkdm",
+			 0, NULL, 0,
+			 AM33XX_CTRL_REGADDR(AM33XX_PWMSS_TBCLK_CLKCTRL),
+			 AM33XX_PWMSS0_TBCLKEN_SHIFT,
+			 NULL, pwmss_clk_parents, ehrpwm_tbclk_ops);
+
+DEFINE_CLK_OMAP_MUX_GATE(ehrpwm1_tbclk, "l4ls_clkdm",
+			 0, NULL, 0,
+			 AM33XX_CTRL_REGADDR(AM33XX_PWMSS_TBCLK_CLKCTRL),
+			 AM33XX_PWMSS1_TBCLKEN_SHIFT,
+			 NULL, pwmss_clk_parents, ehrpwm_tbclk_ops);
+
+DEFINE_CLK_OMAP_MUX_GATE(ehrpwm2_tbclk, "l4ls_clkdm",
+			 0, NULL, 0,
+			 AM33XX_CTRL_REGADDR(AM33XX_PWMSS_TBCLK_CLKCTRL),
+			 AM33XX_PWMSS2_TBCLKEN_SHIFT,
+			 NULL, pwmss_clk_parents, ehrpwm_tbclk_ops);
+
 /*
  * clkdev
  */
@@ -910,6 +937,9 @@ static struct omap_clk am33xx_clks[] = {
 	CLK(NULL,	"clkout2_div_ck",	&clkout2_div_ck,	CK_AM33XX),
 	CLK(NULL,	"timer_32k_ck",		&clkdiv32k_ick,	CK_AM33XX),
 	CLK(NULL,	"timer_sys_ck",		&sys_clkin_ck,	CK_AM33XX),
+	CLK("48300200.ehrpwm",	"tbclk",	&ehrpwm0_tbclk,	CK_AM33XX),
+	CLK("48302200.ehrpwm",	"tbclk",	&ehrpwm1_tbclk,	CK_AM33XX),
+	CLK("48304200.ehrpwm",	"tbclk",	&ehrpwm2_tbclk,	CK_AM33XX),
 };
 
 
diff --git a/arch/arm/mach-omap2/control.h b/arch/arm/mach-omap2/control.h
index 3d944d3..ad4f1d8 100644
--- a/arch/arm/mach-omap2/control.h
+++ b/arch/arm/mach-omap2/control.h
@@ -358,6 +358,14 @@
 #define AM33XX_CONTROL_STATUS_SYSBOOT1_WIDTH		0x2
 #define AM33XX_CONTROL_STATUS_SYSBOOT1_MASK		(0x3 << 22)
 
+/* AM33XX PWMSS Control register */
+#define AM33XX_PWMSS_TBCLK_CLKCTRL			0x664
+
+/* AM33XX  PWMSS Control bitfields */
+#define AM33XX_PWMSS0_TBCLKEN_SHIFT			0
+#define AM33XX_PWMSS1_TBCLKEN_SHIFT			1
+#define AM33XX_PWMSS2_TBCLKEN_SHIFT			2
+
 /* CONTROL OMAP STATUS register to identify OMAP3 features */
 #define OMAP3_CONTROL_OMAP_STATUS	0x044c
 
-- 
1.7.9.5


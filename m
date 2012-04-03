Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab2DCNTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 09:19:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33366 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644Ab2DCNTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 09:19:11 -0400
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: <davinci-linux-open-source@linux.davincidsp.com>
CC: <nsekhar@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>
Subject: [PATCH] arm: da850: change ASYNC/PLL0_SYSCLK3 clock rate with DVFS
Date: Tue, 3 Apr 2012 18:31:23 +0530
Message-ID: <1333458083-29753-1-git-send-email-prakash.pm@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clock for EMIF is derived from ASYNC clock domain(PLL0_SYSCLK3) and was
configured with fixed divider as there was no significant performance
degradation with existing NAND/NOR EMIF devices if it is not
reconfigured accordingly at different OPPs.

On systems where devices other than NAND/NOR are interfaced through
EMIF, such performance degradation may not be desirable. So change the
PLL0_SYSCLK3 output frequency for different OPPs by re-configuring
the divider value.

Configured values are as per rates specified in OMAP-L138 Data sheet
(http://www.ti.com/lit/ds/symlink/omap-l138.pdf, Table 5-5).

Patch addresses concerns raised in below thread of Linux-DaVinci-community:
http://www.mail-archive.com/davinci-linux-open-source@linux.davincidsp.com/msg22535.html

Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
---
 arch/arm/mach-davinci/da850.c |   37 +++++++++++++++++++++++++++++++++++--
 1 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index b44dc84..7e98ed7 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -49,6 +49,7 @@
 static int da850_set_armrate(struct clk *clk, unsigned long rate);
 static int da850_round_armrate(struct clk *clk, unsigned long rate);
 static int da850_set_pll0rate(struct clk *clk, unsigned long armrate);
+static int da850_set_sysclk3_rate(struct clk *clk, unsigned long rate);
 
 static struct pll_data pll0_data = {
 	.num		= 1,
@@ -88,8 +89,8 @@ static struct clk pll0_sysclk3 = {
 	.parent		= &pll0_clk,
 	.flags		= CLK_PLL,
 	.div_reg	= PLLDIV3,
-	.set_rate	= davinci_set_sysclk_rate,
-	.maxrate	= 100000000,
+	.set_rate	= da850_set_sysclk3_rate,
+	.maxrate	= 148000000,
 };
 
 static struct clk pll0_sysclk4 = {
@@ -1004,6 +1005,33 @@ static int da850_set_pll0rate(struct clk *clk, unsigned long index)
 
 	return 0;
 }
+
+static int da850_set_sysclk3_rate(struct clk *clk, unsigned long rate)
+{
+	struct clk *arm_clk;
+	unsigned long sys_clk3_rate = 148000000;
+	int ret;
+
+	arm_clk = clk_get(NULL, "arm");
+	if (WARN(IS_ERR(arm_clk), "Unable to get ARM clock\n"))
+		return PTR_ERR(arm_clk);
+
+	/* Set EMIF clock based on OPPs */
+	switch (clk_get_rate(arm_clk)) {
+	case 200000000:
+		sys_clk3_rate = 75000000;
+		break;
+	case 96000000:
+		sys_clk3_rate = 50000000;
+		break;
+	}
+
+	ret = davinci_set_sysclk_rate(clk, sys_clk3_rate);
+	if (WARN_ON(ret))
+		return ret;
+
+	return 0;
+}
 #else
 int __init da850_register_cpufreq(char *async_clk)
 {
@@ -1024,6 +1052,11 @@ static int da850_round_armrate(struct clk *clk, unsigned long rate)
 {
 	return clk->rate;
 }
+
+static int da850_set_sysclk3_rate(struct clk *clk, unsigned long rate)
+{
+	return -EINVAL;
+}
 #endif
 
 int __init da850_register_pm(struct platform_device *pdev)
-- 
1.7.1


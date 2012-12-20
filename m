Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab2LTJqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 04:46:12 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17578 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab2LTJp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 04:45:56 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 20 Dec 2012 01:45:52 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-tegra@vger.kernel.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Olof Johansson <olof@lixom.net>,
        Jason Cooper <jason@lakedaemon.net>, Shawn Guo <shawn.guo@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 5/9] clocksource: tegra: Enable ARM arch_timer with TSC
Date: Thu, 20 Dec 2012 11:44:03 +0200
Message-ID: <1355996654-6579-6-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355996654-6579-1-git-send-email-hdoyu@nvidia.com>
References: <1355996654-6579-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add platform enabler for ARM arch_timer(TSC). TSC is more fine grained
timer than TMR0. If it's available, it will be used for clock source
and sched_clock. Otherwise, TMR0 is used. In any case TMR0 is
necessary for clock event.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 .../bindings/arm/tegra/nvidia,tegra114-tsc.txt     |   11 ++++
 drivers/clocksource/tegra20_timer.c                |   64 +++++++++++++++++++-
 2 files changed, 74 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/arm/tegra/nvidia,tegra114-tsc.txt

diff --git a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra114-tsc.txt b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra114-tsc.txt
new file mode 100644
index 0000000..9de936a
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra114-tsc.txt
@@ -0,0 +1,11 @@
+NVIDIA Tegra Timer Stamp Counter(TSC)
+
+Required properties:
+- compatible : "nvidia,tegra114-tsc
+- reg : Should contain 1 register ranges(address and length)
+
+Example:
+	tsc {
+		compatible = "nvidia,tegra114-tsc";
+		reg = <0x700f0000 0x20000>;
+	};
diff --git a/drivers/clocksource/tegra20_timer.c b/drivers/clocksource/tegra20_timer.c
index 1d25de8..285a6f1 100644
--- a/drivers/clocksource/tegra20_timer.c
+++ b/drivers/clocksource/tegra20_timer.c
@@ -30,6 +30,7 @@
 #include <asm/mach/time.h>
 #include <asm/smp_twd.h>
 #include <asm/sched_clock.h>
+#include <asm/arch_timer.h>
 
 #define RTC_SECONDS            0x08
 #define RTC_SHADOW_SECONDS     0x0c
@@ -271,10 +272,71 @@ static void __init tegra20_init_tmr(void)
 	clockevents_register_device(&tegra_clockevent);
 }
 
+#define TSC_CNTCR		0		/* TSC control registers */
+#define TSC_CNTCR_ENABLE	(1 << 0)	/* Enable */
+#define TSC_CNTCR_HDBG		(1 << 1)	/* Halt on debug */
+
+#define TSC_CNTCV0		0x8		/* TSC counter (LSW) */
+#define TSC_CNTCV1		0xc		/* TSC counter (MSW) */
+#define TSC_CNTFID0		0x20		/* TSC freq id 0 */
+
+static const struct of_device_id tegra_tsc_match[] __initconst = {
+	{ .compatible = "nvidia,tegra114-tsc" },
+	{}
+};
+
+static int tegra_arch_timer_init(void)
+{
+	int err;
+	struct device_node *np;
+	struct clk *clk;
+	void __iomem *tsc_base;
+	u32 freq, val;
+
+	np = of_find_matching_node(NULL, tegra_tsc_match);
+	if (!np)
+		return -ENODEV;
+
+	tsc_base = of_iomap(np, 0);
+	if (!tsc_base)
+		return -ENODEV;
+
+	clk = clk_get_sys("clk_m", NULL);
+	if (IS_ERR(clk)) {
+		freq = 12000000;
+		pr_warn("Unable to get timer clock. Assuming 12Mhz input clock.\n");
+	} else {
+		freq = clk_get_rate(clk);
+		clk_put(clk);
+	}
+	writel_relaxed(freq, tsc_base + TSC_CNTFID0);
+
+	/* CNTFRQ */
+	asm("mcr p15, 0, %0, c14, c0, 0\n" : : "r" (freq));
+	asm("mrc p15, 0, %0, c14, c0, 0\n" : "=r" (val));
+	BUG_ON(val != freq);
+
+	val = readl_relaxed(tsc_base + TSC_CNTCR);
+	val |= TSC_CNTCR_ENABLE | TSC_CNTCR_HDBG;
+	writel_relaxed(val, tsc_base + TSC_CNTCR);
+
+	err = arch_timer_of_register();
+	if (!err)
+		err = arch_timer_sched_clock_init();
+	if (err)
+		pr_err("Failed to register ARM arch_timer(TSC)\n");
+	return err;
+}
+
 static void __init tegra20_init_timer(void)
 {
+	int err = -ENODEV;
+
 	tegra20_init_tmr();
-	setup_sched_clock(tegra_read_sched_clock, 32, 1000000);
+	if (IS_ENABLED(CONFIG_ARM_ARCH_TIMER))
+		err = tegra_arch_timer_init();
+	if (err)
+		setup_sched_clock(tegra_read_sched_clock, 32, 1000000);
 	tegra20_init_rtc();
 #ifdef CONFIG_HAVE_ARM_TWD
 	twd_local_timer_of_register();
-- 
1.7.9.5


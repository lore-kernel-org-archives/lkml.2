Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760632Ab2ILQ7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:59:55 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40192 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224Ab2ILQ7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:59:40 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6832"; a="233521455"
From: David Brown <davidb@codeaurora.org>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH 13/24] ARM: msm: Add DT support to msm_timer
Date: Wed, 12 Sep 2012 09:58:49 -0700
Message-Id: <1347469140-25069-14-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
References: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

Add support to setup the MSM timer via information obtained from
the devicetree.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
[davidb@codeaurora.org: Remove leading zeros]
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 .../devicetree/bindings/arm/msm/timer.txt          | 38 ++++++++++
 arch/arm/mach-msm/common.h                         |  1 +
 arch/arm/mach-msm/timer.c                          | 87 ++++++++++++++++++++++
 3 files changed, 126 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/msm/timer.txt

diff --git a/Documentation/devicetree/bindings/arm/msm/timer.txt b/Documentation/devicetree/bindings/arm/msm/timer.txt
new file mode 100644
index 0000000..8c5907b
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/msm/timer.txt
@@ -0,0 +1,38 @@
+* MSM Timer
+
+Properties:
+
+- compatible : Should at least contain "qcom,msm-timer". More specific
+  properties such as "qcom,msm-gpt" and "qcom,msm-dgt" specify a general
+  purpose timer and a debug timer respectively.
+
+- interrupts : Interrupt indicating a match event.
+
+- reg : Specifies the base address of the timer registers. The second region
+  specifies an optional register used to configure the clock divider.
+
+- clock-frequency : The frequency of the timer in Hz.
+
+Optional:
+
+- cpu-offset : per-cpu offset used when the timer is accessed without the
+  CPU remapping facilities. The offset is cpu-offset * cpu-nr.
+
+Example:
+
+       timer@200a004 {
+               compatible = "qcom,msm-gpt", "qcom,msm-timer";
+               interrupts = <1 2 0x301>;
+               reg = <0x0200a004 0x10>;
+               clock-frequency = <32768>;
+               cpu-offset = <0x40000>;
+       };
+
+       timer@200a024 {
+               compatible = "qcom,msm-dgt", "qcom,msm-timer";
+               interrupts = <1 3 0x301>;
+               reg = <0x0200a024 0x10>,
+                     <0x0200a034 0x4>;
+               clock-frequency = <6750000>;
+               cpu-offset = <0x40000>;
+       };
diff --git a/arch/arm/mach-msm/common.h b/arch/arm/mach-msm/common.h
index 4c2dd16..7d57fb0 100644
--- a/arch/arm/mach-msm/common.h
+++ b/arch/arm/mach-msm/common.h
@@ -16,6 +16,7 @@ extern struct sys_timer msm7x01_timer;
 extern struct sys_timer msm7x30_timer;
 extern struct sys_timer msm8x60_timer;
 extern struct sys_timer msm8960_timer;
+extern struct sys_timer msm_dt_timer;
 extern struct sys_timer qsd8x50_timer;
 
 #endif
diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index e0b237b..9f9157a 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -20,6 +20,9 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 
 #include <asm/mach/time.h>
 #include <asm/hardware/gic.h>
@@ -216,6 +219,90 @@ err:
 	setup_sched_clock(msm_sched_clock_read, sched_bits, dgt_hz);
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id msm_dgt_match[] __initconst = {
+	{ .compatible = "qcom,msm-dgt" },
+	{ },
+};
+
+static const struct of_device_id msm_gpt_match[] __initconst = {
+	{ .compatible = "qcom,msm-gpt" },
+	{ },
+};
+
+static void __init msm_dt_timer_init(void)
+{
+	struct device_node *np;
+	u32 freq;
+	int irq;
+	struct resource res;
+	u32 percpu_offset;
+	void __iomem *dgt_clk_ctl;
+
+	np = of_find_matching_node(NULL, msm_gpt_match);
+	if (!np) {
+		pr_err("Can't find GPT DT node\n");
+		return;
+	}
+
+	event_base = of_iomap(np, 0);
+	if (!event_base) {
+		pr_err("Failed to map event base\n");
+		return;
+	}
+
+	irq = irq_of_parse_and_map(np, 0);
+	if (irq <= 0) {
+		pr_err("Can't get irq\n");
+		return;
+	}
+	of_node_put(np);
+
+	np = of_find_matching_node(NULL, msm_dgt_match);
+	if (!np) {
+		pr_err("Can't find DGT DT node\n");
+		return;
+	}
+
+	if (of_property_read_u32(np, "cpu-offset", &percpu_offset))
+		percpu_offset = 0;
+
+	if (of_address_to_resource(np, 0, &res)) {
+		pr_err("Failed to parse DGT resource\n");
+		return;
+	}
+
+	source_base = ioremap(res.start + percpu_offset, resource_size(&res));
+	if (!source_base) {
+		pr_err("Failed to map source base\n");
+		return;
+	}
+
+	if (!of_address_to_resource(np, 1, &res)) {
+		dgt_clk_ctl = ioremap(res.start + percpu_offset,
+				      resource_size(&res));
+		if (!dgt_clk_ctl) {
+			pr_err("Failed to map DGT control base\n");
+			return;
+		}
+		writel_relaxed(DGT_CLK_CTL_DIV_4, dgt_clk_ctl);
+		iounmap(dgt_clk_ctl);
+	}
+
+	if (of_property_read_u32(np, "clock-frequency", &freq)) {
+		pr_err("Unknown frequency\n");
+		return;
+	}
+	of_node_put(np);
+
+	msm_timer_init(freq, 32, irq, !!percpu_offset);
+}
+
+struct sys_timer msm_dt_timer = {
+	.init = msm_dt_timer_init
+};
+#endif
+
 static int __init msm_timer_map(phys_addr_t event, phys_addr_t source)
 {
 	event_base = ioremap(event, SZ_64);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


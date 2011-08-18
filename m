Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab1HRR06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 13:26:58 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54632 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab1HRRZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 13:25:53 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6441"; a="111095113"
From: David Brown <davidb@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 3/4] ARM: msm: Add devicetree support for msm8660-surf
Date: Thu, 18 Aug 2011 10:25:44 -0700
Message-Id: <1313688345-17699-4-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313688345-17699-1-git-send-email-davidb@codeaurora.org>
References: <1313688345-17699-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for booting via device tree with a simple serial console.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/boot/dts/msm8660-surf.dts |   24 +++++++++++++++
 arch/arm/mach-msm/board-msm8x60.c  |   58 +++++++++++++++++++++++++++++++----
 2 files changed, 75 insertions(+), 7 deletions(-)
 create mode 100644 arch/arm/boot/dts/msm8660-surf.dts

diff --git a/arch/arm/boot/dts/msm8660-surf.dts b/arch/arm/boot/dts/msm8660-surf.dts
new file mode 100644
index 0000000..15ded0d
--- /dev/null
+++ b/arch/arm/boot/dts/msm8660-surf.dts
@@ -0,0 +1,24 @@
+/dts-v1/;
+
+/include/ "skeleton.dtsi"
+
+/ {
+	model = "Qualcomm MSM8660 SURF";
+	compatible = "qcom,msm8660-surf", "qcom,msm8660";
+	interrupt-parent = <&intc>;
+
+	intc: interrupt-controller@02080000 {
+		compatible = "qcom,msm-8660-qgic";
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		reg = < 0x02080000 0x1000 >,
+		      < 0x02081000 0x1000 >;
+	};
+
+	serial@19c400000 {
+		compatible = "qcom,msm-hsuart", "qcom,msm-uart";
+		reg = <0x19c40000 0x1000>,
+		      <0x19c00000 0x1000>;
+		interrupts = <195>;
+	};
+};
diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index 1163b6f..10fa8f6 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+/* Copyright (c) 2010, 2011, Code Aurora Forum. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
@@ -8,18 +8,16 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
- *
  */
 
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -64,6 +62,41 @@ static void __init msm8x60_init(void)
 {
 }
 
+#ifdef CONFIG_OF
+static struct of_dev_auxdata msm_auxdata_lookup[] __initdata = {
+	{}
+};
+
+static struct of_device_id msm_dt_gic_match[] __initdata = {
+	{ .compatible = "qcom,msm-8660-qgic", },
+	{}
+};
+
+static void __init msm8x60_dt_init(void)
+{
+	struct device_node *node;
+
+	node = of_find_matching_node_by_address(NULL, msm_dt_gic_match,
+			MSM8X60_QGIC_DIST_PHYS);
+	if (node)
+		irq_domain_add_simple(node, GIC_SPI_START);
+
+	if (of_machine_is_compatible("qcom,msm8660-surf")) {
+		printk(KERN_INFO "Init surf UART registers\n");
+		msm8x60_init_uart12dm();
+	}
+
+	of_platform_populate(NULL, of_default_bus_match_table,
+			msm_auxdata_lookup, NULL);
+}
+
+static const char *msm8x60_fluid_match[] __initdata = {
+	"qcom,msm8660-fluid",
+	"qcom,msm8660-surf",
+	NULL
+};
+#endif /* CONFIG_OF */
+
 MACHINE_START(MSM8X60_RUMI3, "QCT MSM8X60 RUMI3")
 	.map_io = msm8x60_map_io,
 	.init_irq = msm8x60_init_irq,
@@ -91,3 +124,14 @@ MACHINE_START(MSM8X60_FFA, "QCT MSM8X60 FFA")
 	.init_machine = msm8x60_init,
 	.timer = &msm_timer,
 MACHINE_END
+
+#ifdef CONFIG_OF
+/* TODO: General device tree support for all MSM. */
+DT_MACHINE_START(MSM_DT, "Qualcomm MSM (Flattened Device Tree)")
+	.map_io = msm8x60_map_io,
+	.init_irq = msm8x60_init_irq,
+	.init_machine = msm8x60_dt_init,
+	.timer = &msm_timer,
+	.dt_compat = msm8x60_fluid_match,
+MACHINE_END
+#endif /* CONFIG_OF */
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


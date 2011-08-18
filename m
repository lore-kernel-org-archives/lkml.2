Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab1HRR0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 13:26:39 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54632 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab1HRRZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 13:25:54 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6441"; a="111095118"
From: David Brown <davidb@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH v3 4/4] ARM: msm: Describe MSM 8660 SURF FPGA registers in DT
Date: Thu, 18 Aug 2011 10:25:45 -0700
Message-Id: <1313688345-17699-5-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313688345-17699-1-git-send-email-davidb@codeaurora.org>
References: <1313688345-17699-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MSM 8660 SURF development board contains a register-accessible
FPGA.  By default, this FPGA configures the first UART in output-only
mode.  On this target, reconfigure this FPGA to enable the UART to be
bidirectional.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/boot/dts/msm8660-surf.dts |    5 +++
 arch/arm/mach-msm/board-msm8x60.c  |   49 +++++++++++++++++++++++++++++++++---
 2 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/msm8660-surf.dts b/arch/arm/boot/dts/msm8660-surf.dts
index 15ded0d..3591c94 100644
--- a/arch/arm/boot/dts/msm8660-surf.dts
+++ b/arch/arm/boot/dts/msm8660-surf.dts
@@ -21,4 +21,9 @@
 		      <0x19c00000 0x1000>;
 		interrupts = <195>;
 	};
+
+	qcom,fpga@1d000000 {
+		compatible = "qcom,msm8660-surf-fpga";
+		reg = < 0x1d000000 0x1000 >;
+	};
 };
diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index 10fa8f6..f2dacfe 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -58,8 +58,52 @@ static void __init msm8x60_init_irq(void)
 	}
 }
 
+static void __init msm8660_surf_fpga_init(void __iomem *fpga_mem)
+{
+	/* Advanced mode */
+	writew(0xFFFF, fpga_mem + 0x15C);
+	/* FPGA_UART_SEL */
+	writew(0, fpga_mem + 0x172);
+	/* FPGA_GPIO_CONFIG_117 */
+	writew(1, fpga_mem + 0xEA);
+	/* FPGA_GPIO_CONFIG_118 */
+	writew(1, fpga_mem + 0xEC);
+	dmb();
+}
+
+static void __init msm8660_surf_fpga_init_platform(void)
+{
+	/* 0x1D000000 now belongs to EBI2:CS3 i.e. USB ISP Controller */
+	void __iomem *fpga_mem = ioremap(0x1D000000, SZ_4K);
+	msm8660_surf_fpga_init(fpga_mem);
+	iounmap(fpga_mem);
+}
+
+#ifdef CONFIG_OF
+static void __init msm8660_surf_fpga_init_dt(void)
+{
+	struct device_node *node;
+	void __iomem *fpga_mem;
+
+	node = of_find_compatible_node(NULL, NULL, "qcom,msm8660-surf-fpga");
+	if (!node)
+		return;
+
+	fpga_mem = of_iomap(node, 0);
+	of_node_put(node);
+	if (!fpga_mem) {
+		printk(KERN_ERR "%s: Can't map fpga registers\n", __func__);
+		return;
+	}
+
+	msm8660_surf_fpga_init(fpga_mem);
+	iounmap(fpga_mem);
+}
+#endif
+
 static void __init msm8x60_init(void)
 {
+	msm8660_surf_fpga_init_platform();
 }
 
 #ifdef CONFIG_OF
@@ -81,10 +125,7 @@ static void __init msm8x60_dt_init(void)
 	if (node)
 		irq_domain_add_simple(node, GIC_SPI_START);
 
-	if (of_machine_is_compatible("qcom,msm8660-surf")) {
-		printk(KERN_INFO "Init surf UART registers\n");
-		msm8x60_init_uart12dm();
-	}
+	msm8660_surf_fpga_init_dt();
 
 	of_platform_populate(NULL, of_default_bus_match_table,
 			msm_auxdata_lookup, NULL);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


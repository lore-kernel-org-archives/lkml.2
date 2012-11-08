Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab2KHT4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 14:56:55 -0500
Received: from mailserver6.natinst.com ([130.164.80.6]:51834 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab2KHTyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 14:54:14 -0500
Message-Id: <bbeb3c5478706e376a6a9fc02eee168b91035078.1352400580.git.josh.cartwright@ni.com>
In-Reply-To: <cover.1352400580.git.josh.cartwright@ni.com>
References: <cover.1352400580.git.josh.cartwright@ni.com>
From: Josh Cartwright <josh.cartwright@ni.com>
Date: Thu, 8 Nov 2012 12:04:26 -0600
Subject: [PATCH v2 3/5] ARM: zynq: use zynq clk bindings
To: Michal Simek <michal.simek@xilinx.com>, John Linn <john.linn@xilinx.com>,
        arm@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/08/2012 01:54:07 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/08/2012 01:54:07 PM,
	Serialize complete at 11/08/2012 01:54:07 PM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8185,1.0.431,0.0.0000
 definitions=2012-11-08_04:2012-11-08,2012-11-08,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the Zynq platform use the newly created zynq clk bindings.

Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
---
 arch/arm/Kconfig                 |  1 +
 arch/arm/boot/dts/zynq-7000.dtsi | 56 ++++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/zynq-zc702.dts |  4 +++
 arch/arm/mach-zynq/common.c      | 11 ++++++++
 drivers/clk/Makefile             |  1 +
 5 files changed, 73 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 21ed87b..ccfe0ab 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -959,6 +959,7 @@ config ARCH_ZYNQ
 	bool "Xilinx Zynq ARM Cortex A9 Platform"
 	select ARM_AMBA
 	select ARM_GIC
+	select COMMON_CLK
 	select CPU_V7
 	select GENERIC_CLOCKEVENTS
 	select ICST
diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 8b30e59..bb3085c 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -53,5 +53,61 @@
 			interrupts = <0 50 4>;
 			clock = <50000000>;
 		};
+
+		slcr: slcr@f8000000 {
+			compatible = "xlnx,zynq-slcr";
+			reg = <0xF8000000 0x1000>;
+
+			clocks {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				ps_clk: ps_clk {
+					#clock-cells = <0>;
+					compatible = "fixed-clock";
+					/* clock-frequency set in board-specific file */
+					clock-output-names = "ps_clk";
+				};
+				armpll: armpll {
+					#clock-cells = <0>;
+					compatible = "xlnx,zynq-pll";
+					clocks = <&ps_clk>;
+					reg = <0x100 0x110>;
+					clock-output-names = "armpll";
+				};
+				ddrpll: ddrpll {
+					#clock-cells = <0>;
+					compatible = "xlnx,zynq-pll";
+					clocks = <&ps_clk>;
+					reg = <0x104 0x114>;
+					clock-output-names = "ddrpll";
+				};
+				iopll: iopll {
+					#clock-cells = <0>;
+					compatible = "xlnx,zynq-pll";
+					clocks = <&ps_clk>;
+					reg = <0x108 0x118>;
+					clock-output-names = "iopll";
+				};
+				uart_clk: uart_clk {
+					#clock-cells = <1>;
+					compatible = "xlnx,zynq-periph-clock";
+					clocks = <&iopll &armpll &ddrpll>;
+					reg = <0x154>;
+					clock-output-names = "uart0_ref_clk",
+							     "uart1_ref_clk";
+				};
+				cpu_clk: cpu_clk {
+					#clock-cells = <1>;
+					compatible = "xlnx,zynq-cpu-clock";
+					clocks = <&iopll &armpll &ddrpll>;
+					reg = <0x120 0x1C4>;
+					clock-output-names = "cpu_6x4x",
+							     "cpu_3x2x",
+							     "cpu_2x",
+							     "cpu_1x";
+				};
+			};
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
index e25a307..86f44d5 100644
--- a/arch/arm/boot/dts/zynq-zc702.dts
+++ b/arch/arm/boot/dts/zynq-zc702.dts
@@ -28,3 +28,7 @@
 	};
 
 };
+
+&ps_clk {
+	clock-frequency = <33333330>;
+};
diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 5441323..79bf5fb 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -19,6 +19,8 @@
 #include <linux/cpumask.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
+#include <linux/clk/zynq.h>
+#include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/of.h>
@@ -96,6 +98,15 @@ static struct map_desc io_desc[] __initdata = {
 
 static void __init xilinx_zynq_timer_init(void)
 {
+	struct device_node *np;
+	void __iomem *slcr;
+
+	np = of_find_compatible_node(NULL, NULL, "xlnx,zynq-slcr");
+	slcr = of_iomap(np, 0);
+	WARN_ON(!slcr);
+
+	xilinx_zynq_clocks_init(slcr);
+
 	xttcpss_timer_init();
 }
 
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 71a25b9..d35a34c 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -19,6 +19,7 @@ endif
 obj-$(CONFIG_MACH_LOONGSON1)	+= clk-ls1x.o
 obj-$(CONFIG_ARCH_U8500)	+= ux500/
 obj-$(CONFIG_ARCH_VT8500)	+= clk-vt8500.o
+obj-$(CONFIG_ARCH_ZYNQ)		+= clk-zynq.o
 
 # Chip specific
 obj-$(CONFIG_COMMON_CLK_WM831X) += clk-wm831x.o
-- 
1.8.0



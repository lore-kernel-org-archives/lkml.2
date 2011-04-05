Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab1DES2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 14:28:51 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:36021
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754234Ab1DES2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 14:28:23 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzc8kzz1202hzz8275bhz2dh95h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
From: John Linn <john.linn@xilinx.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>, <jamie@jamieiles.com>, <arnd@arndb.de>,
        <nicolas.pitre@linaro.org>
CC: John Linn <john.linn@xilinx.com>
Subject: [PATCH V6 5/5] ARM: Xilinx: adding device tree support
Date: Tue, 5 Apr 2011 12:28:06 -0600
X-Mailer: git-send-email 1.5.4.7
In-Reply-To: <1302028086-17603-5-git-send-email-john.linn@xilinx.com>
References: <1302028086-17603-1-git-send-email-john.linn@xilinx.com>
 <1302028086-17603-2-git-send-email-john.linn@xilinx.com>
 <1302028086-17603-3-git-send-email-john.linn@xilinx.com>
 <1302028086-17603-4-git-send-email-john.linn@xilinx.com>
 <1302028086-17603-5-git-send-email-john.linn@xilinx.com>
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <2d99b4c0-d756-4e85-8d10-aeece18b2711@VA3EHSMHS013.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit is dependent on the device tree for ARM
work that Grant Likely has been doing. Minimal changes
are needed to support device tree.

Signed-off-by: John Linn <john.linn@xilinx.com>
---

This is new patch in the series starting at V6. It is an optional 
patch for those not using device tree yet.

 Documentation/devicetree/bindings/arm/xilinx.txt |    7 +++
 arch/arm/boot/dts/zynq-ep107.dts                 |   52 ++++++++++++++++++++++
 arch/arm/mach-zynq/board_ep107.c                 |    8 +++-
 arch/arm/mach-zynq/common.c                      |   12 +++++
 4 files changed, 78 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/xilinx.txt
 create mode 100755 arch/arm/boot/dts/zynq-ep107.dts

diff --git a/Documentation/devicetree/bindings/arm/xilinx.txt b/Documentation/devicetree/bindings/arm/xilinx.txt
new file mode 100644
index 0000000..6f1ed83
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/xilinx.txt
@@ -0,0 +1,7 @@
+Xilinx Zynq EP107 Emulation Platform board
+
+This board is an emulation platform for the Zynq product which is
+based on an ARM Cortex A9 processor.
+
+Required root node properties:
+    - compatible = "xlnx,zynq-ep107";
diff --git a/arch/arm/boot/dts/zynq-ep107.dts b/arch/arm/boot/dts/zynq-ep107.dts
new file mode 100755
index 0000000..fe2c0cc
--- /dev/null
+++ b/arch/arm/boot/dts/zynq-ep107.dts
@@ -0,0 +1,52 @@
+/*
+ *  Copyright (C) 2011 Xilinx
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/dts-v1/;
+/ {
+	model = "Xilinx Zynq EP107";
+	compatible = "xlnx,zynq-ep107";
+	#address-cells = <1>;
+	#size-cells = <1>;
+	interrupt-parent = <&intc>;
+
+	memory {
+		device_type = "memory";
+		reg = <0x0 0x10000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyDF0,9600 root=/dev/ram rw initrd=0x800000,8M earlyprintk";
+		linux,stdout-path = &uart0;
+	};
+
+	amba: amba@0 {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		intc: intc@F8F01000 {
+			interrupt-controller;
+			compatible = "arm,gic";
+			reg = <0xF8F01000 0x1000>;
+			#interrupt-cells = <2>;
+		};
+
+		uart0: uart@E0000000 {
+			compatible = "xlnx,xuartpss";
+			reg = <0xE0000000 0x1000>;
+			interrupts = <59 0>;
+			clock = <50000000>;
+		};
+	};
+};
diff --git a/arch/arm/mach-zynq/board_ep107.c b/arch/arm/mach-zynq/board_ep107.c
index 3d576d0..5284dcc 100644
--- a/arch/arm/mach-zynq/board_ep107.c
+++ b/arch/arm/mach-zynq/board_ep107.c
@@ -76,10 +76,16 @@ static void __init board_ep107_init(void)
 	platform_add_devices(&xilinx_pdevices[0], ARRAY_SIZE(xilinx_pdevices));
 }
 
-MACHINE_START(XILINX_EP107, "Xilinx EP107")
+static const char *xilinx_ep107_board_compat[] = {
+	"xlnx,zynq-ep107",
+	NULL
+};
+
+MACHINE_START(XILINX_EP107, "Xilinx Zynq EP107")
 	.boot_params    = PLAT_PHYS_OFFSET + 0x00000100,
 	.map_io         = xilinx_map_io,
 	.init_irq       = xilinx_irq_init,
 	.init_machine   = board_ep107_init,
 	.timer          = &xttcpss_sys_timer,
+	.dt_compat	= xilinx_ep107_board_compat,
 MACHINE_END
diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 9a626ba..4dd909b 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -20,6 +20,7 @@
 #include <linux/cpumask.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
+#include <linux/of_platform.h>
 
 #include <asm/mach/map.h>
 #include <asm/page.h>
@@ -30,6 +31,13 @@
 #include <mach/clkdev.h>
 #include "common.h"
 
+#ifdef CONFIG_OF
+static struct of_device_id zynq_of_bus_ids[] __initdata = {
+	{ .compatible = "simple-bus", },
+	{}
+};
+#endif
+
 /*
  * Clock function infrastructure.
  */
@@ -60,6 +68,10 @@ void __init xilinx_system_init(void)
 	 */
 	l2x0_init(PL310_L2CC_BASE, 0x02060000, 0xF0F0FFFF);
 #endif
+
+#ifdef CONFIG_OF
+	of_platform_bus_probe(NULL, zynq_of_bus_ids, NULL);
+#endif
 }
 
 /**
-- 
1.5.4.7



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.



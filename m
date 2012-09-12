Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760723Ab2ILRB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:01:59 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40226 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab2ILQ7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:59:44 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6832"; a="233521464"
From: David Brown <davidb@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 18/24] ARM: msm: Add DT support for 8960
Date: Wed, 12 Sep 2012 09:58:54 -0700
Message-Id: <1347469140-25069-19-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
References: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

Add basic support to boot 8960 with device tree. For now just
support a basic machine with a uart device.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
[davidb@codeaurora.org: Remove leading zeros]
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/boot/dts/msm8960-cdp.dts | 41 ++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/Kconfig         |  1 +
 arch/arm/mach-msm/Makefile        |  1 +
 arch/arm/mach-msm/Makefile.boot   |  1 +
 arch/arm/mach-msm/board-dt-8960.c | 49 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 93 insertions(+)
 create mode 100644 arch/arm/boot/dts/msm8960-cdp.dts
 create mode 100644 arch/arm/mach-msm/board-dt-8960.c

diff --git a/arch/arm/boot/dts/msm8960-cdp.dts b/arch/arm/boot/dts/msm8960-cdp.dts
new file mode 100644
index 0000000..9e621b5
--- /dev/null
+++ b/arch/arm/boot/dts/msm8960-cdp.dts
@@ -0,0 +1,41 @@
+/dts-v1/;
+
+/include/ "skeleton.dtsi"
+
+/ {
+	model = "Qualcomm MSM8960 CDP";
+	compatible = "qcom,msm8960-cdp", "qcom,msm8960";
+	interrupt-parent = <&intc>;
+
+	intc: interrupt-controller@2000000 {
+		compatible = "qcom,msm-qgic2";
+		interrupt-controller;
+		#interrupt-cells = <3>;
+		reg = < 0x02000000 0x1000 >,
+		      < 0x02002000 0x1000 >;
+	};
+
+	timer@200a004 {
+		compatible = "qcom,msm-gpt", "qcom,msm-timer";
+		interrupts = <1 2 0x301>;
+		reg = <0x0200a004 0x10>;
+		clock-frequency = <32768>;
+		cpu-offset = <0x80000>;
+	};
+
+	timer@200a024 {
+		compatible = "qcom,msm-dgt", "qcom,msm-timer";
+		interrupts = <1 1 0x301>;
+		reg = <0x0200a024 0x10>,
+		      <0x0200a034 0x4>;
+		clock-frequency = <6750000>;
+		cpu-offset = <0x80000>;
+	};
+
+	serial@19c400000 {
+		compatible = "qcom,msm-hsuart", "qcom,msm-uart";
+		reg = <0x16440000 0x1000>,
+		      <0x16400000 0x1000>;
+		interrupts = <0 154 0x0>;
+	};
+};
diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index cd78427..2e5a27e 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -56,6 +56,7 @@ config ARCH_MSM8960
 	select MSM_V2_TLMM
 	select MSM_GPIOMUX
 	select MSM_SCM if SMP
+	select USE_OF
 
 endchoice
 
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 8794148..cef0ad4 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_ARCH_MSM7X30) += board-msm7x30.o devices-msm7x30.o
 obj-$(CONFIG_ARCH_QSD8X50) += board-qsd8x50.o devices-qsd8x50.o
 obj-$(CONFIG_ARCH_MSM8X60) += board-dt-8660.o
 obj-$(CONFIG_ARCH_MSM8960) += board-msm8960.o devices-msm8960.o
+obj-$(CONFIG_ARCH_MSM8960) += board-dt-8960.o
 
 obj-$(CONFIG_ARCH_MSM7X30) += gpiomux-v1.o gpiomux.o
 obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o gpiomux-v1.o gpiomux.o
diff --git a/arch/arm/mach-msm/Makefile.boot b/arch/arm/mach-msm/Makefile.boot
index 8de0678..f7d6ae9 100644
--- a/arch/arm/mach-msm/Makefile.boot
+++ b/arch/arm/mach-msm/Makefile.boot
@@ -3,3 +3,4 @@ params_phys-y		:= 0x10000100
 initrd_phys-y		:= 0x10800000
 
 dtb-$(CONFIG_ARCH_MSM8X60) += msm8660-surf.dtb
+dtb-$(CONFIG_ARCH_MSM8960) += msm8960-cdp.dtb
diff --git a/arch/arm/mach-msm/board-dt-8960.c b/arch/arm/mach-msm/board-dt-8960.c
new file mode 100644
index 0000000..8df99b8f
--- /dev/null
+++ b/arch/arm/mach-msm/board-dt-8960.c
@@ -0,0 +1,49 @@
+/* Copyright (c) 2012, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+
+#include <asm/hardware/gic.h>
+#include <asm/mach/arch.h>
+
+#include "common.h"
+
+static const struct of_device_id msm_dt_gic_match[] __initconst = {
+	{ .compatible = "qcom,msm-qgic2", .data = gic_of_init },
+	{ }
+};
+
+static void __init msm_dt_init_irq(void)
+{
+	of_irq_init(msm_dt_gic_match);
+}
+
+static void __init msm_dt_init(void)
+{
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+}
+
+static const char * const msm8960_dt_match[] __initconst = {
+	"qcom,msm8960-cdp",
+	NULL
+};
+
+DT_MACHINE_START(MSM8960_DT, "Qualcomm MSM (Flattened Device Tree)")
+	.map_io = msm_map_msm8960_io,
+	.init_irq = msm_dt_init_irq,
+	.timer = &msm_dt_timer,
+	.init_machine = msm_dt_init,
+	.dt_compat = msm8960_dt_match,
+	.handle_irq = gic_handle_irq,
+MACHINE_END
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


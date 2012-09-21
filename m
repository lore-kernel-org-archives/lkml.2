Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab2IUC2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 22:28:37 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1205 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842Ab2IUC1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 22:27:39 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6841"; a="237156947"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH 09/10] ARM: msm: Make proc_comm clock control into a platform driver
Date: Thu, 20 Sep 2012 19:26:57 -0700
Message-Id: <1348194419-11486-10-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.1.382.gb0576a6
In-Reply-To: <1348194419-11486-1-git-send-email-sboyd@codeaurora.org>
References: <1348194419-11486-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To move closer to the generic struct clock framework move the
proc_comm based clock code to a platform driver. The data
describing the struct clks still live in the devices-$ARCH file,
but the clock initialization is done at driver binding time.

Cc: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/board-halibut.c      |  2 +-
 arch/arm/mach-msm/board-msm7x30.c      |  2 +-
 arch/arm/mach-msm/board-qsd8x50.c      |  2 +-
 arch/arm/mach-msm/board-trout.c        |  3 +--
 arch/arm/mach-msm/clock-pcom.c         | 23 +++++++++++++++++++++--
 arch/arm/mach-msm/clock-pcom.h         |  5 +++++
 arch/arm/mach-msm/clock.c              |  2 +-
 arch/arm/mach-msm/clock.h              |  3 +++
 arch/arm/mach-msm/devices-msm7x00.c    | 12 ++++++++++--
 arch/arm/mach-msm/devices-msm7x30.c    | 11 +++++++++--
 arch/arm/mach-msm/devices-qsd8x50.c    | 11 +++++++++--
 arch/arm/mach-msm/devices.h            | 15 +++------------
 arch/arm/mach-msm/include/mach/board.h |  5 -----
 13 files changed, 65 insertions(+), 31 deletions(-)

diff --git a/arch/arm/mach-msm/board-halibut.c b/arch/arm/mach-msm/board-halibut.c
index 6ce542e..3c8cfe4 100644
--- a/arch/arm/mach-msm/board-halibut.c
+++ b/arch/arm/mach-msm/board-halibut.c
@@ -59,6 +59,7 @@ static struct platform_device smc91x_device = {
 };
 
 static struct platform_device *devices[] __initdata = {
+	&msm_clock_7x01a,
 	&msm_device_uart3,
 	&msm_device_smd,
 	&msm_device_nand,
@@ -90,7 +91,6 @@ static void __init halibut_fixup(struct tag *tags, char **cmdline,
 static void __init halibut_map_io(void)
 {
 	msm_map_common_io();
-	msm_clock_init(msm_clocks_7x01a, msm_num_clocks_7x01a);
 }
 
 static void __init halibut_init_late(void)
diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-msm7x30.c
index effa6f4..22e267e 100644
--- a/arch/arm/mach-msm/board-msm7x30.c
+++ b/arch/arm/mach-msm/board-msm7x30.c
@@ -89,6 +89,7 @@ struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS] = {
 };
 
 static struct platform_device *devices[] __initdata = {
+	&msm_clock_7x30,
 #if defined(CONFIG_SERIAL_MSM) || defined(CONFIG_MSM_SERIAL_DEBUGGER)
         &msm_device_uart2,
 #endif
@@ -115,7 +116,6 @@ static void __init msm7x30_init(void)
 static void __init msm7x30_map_io(void)
 {
 	msm_map_msm7x30_io();
-	msm_clock_init(msm_clocks_7x30, msm_num_clocks_7x30);
 }
 
 static void __init msm7x30_init_late(void)
diff --git a/arch/arm/mach-msm/board-qsd8x50.c b/arch/arm/mach-msm/board-qsd8x50.c
index b16b71a..4d5d7ef 100644
--- a/arch/arm/mach-msm/board-qsd8x50.c
+++ b/arch/arm/mach-msm/board-qsd8x50.c
@@ -89,6 +89,7 @@ static struct msm_otg_platform_data msm_otg_pdata = {
 };
 
 static struct platform_device *devices[] __initdata = {
+	&msm_clock_8x50,
 	&msm_device_uart3,
 	&msm_device_smd,
 	&msm_device_otg,
@@ -171,7 +172,6 @@ static void __init qsd8x50_init_mmc(void)
 static void __init qsd8x50_map_io(void)
 {
 	msm_map_qsd8x50_io();
-	msm_clock_init(msm_clocks_8x50, msm_num_clocks_8x50);
 }
 
 static void __init qsd8x50_init_irq(void)
diff --git a/arch/arm/mach-msm/board-trout.c b/arch/arm/mach-msm/board-trout.c
index 4ba0800..c8352e7 100644
--- a/arch/arm/mach-msm/board-trout.c
+++ b/arch/arm/mach-msm/board-trout.c
@@ -36,6 +36,7 @@
 extern int trout_init_mmc(unsigned int);
 
 static struct platform_device *devices[] __initdata = {
+	&msm_clock_7x01a,
 	&msm_device_uart3,
 	&msm_device_smd,
 	&msm_device_nand,
@@ -93,8 +94,6 @@ static void __init trout_map_io(void)
 	/* route UART3 to the "H2W" extended usb connector */
 	writeb(0x80, TROUT_CPLD_BASE + 0x00);
 #endif
-
-	msm_clock_init(msm_clocks_7x01a, msm_num_clocks_7x01a);
 }
 
 static void __init trout_init_late(void)
diff --git a/arch/arm/mach-msm/clock-pcom.c b/arch/arm/mach-msm/clock-pcom.c
index bb75f8e..7c4c60a 100644
--- a/arch/arm/mach-msm/clock-pcom.c
+++ b/arch/arm/mach-msm/clock-pcom.c
@@ -14,8 +14,9 @@
  */
 
 #include <linux/err.h>
-#include <linux/ctype.h>
-#include <linux/stddef.h>
+#include <linux/platform_device.h>
+#include <linux/module.h>
+
 #include <mach/clk.h>
 
 #include "proc_comm.h"
@@ -126,3 +127,21 @@ struct clk_ops clk_ops_pcom = {
 	.round_rate = pc_clk_round_rate,
 	.is_local = pc_clk_is_local,
 };
+
+static int __devinit msm_clock_pcom_probe(struct platform_device *pdev)
+{
+	struct pcom_clk_pdata *pdata = pdev->dev.platform_data;
+	msm_clock_init(pdata->lookup, pdata->num_lookups);
+	return 0;
+}
+
+static struct platform_driver msm_clock_pcom_driver = {
+	.probe		= msm_clock_pcom_probe,
+	.driver		= {
+		.name	= "msm-clock-pcom",
+		.owner	= THIS_MODULE,
+	},
+};
+module_platform_driver(msm_clock_pcom_driver);
+
+MODULE_LICENSE("GPL v2");
diff --git a/arch/arm/mach-msm/clock-pcom.h b/arch/arm/mach-msm/clock-pcom.h
index 974d003..87406a3 100644
--- a/arch/arm/mach-msm/clock-pcom.h
+++ b/arch/arm/mach-msm/clock-pcom.h
@@ -123,6 +123,11 @@
 struct clk_ops;
 extern struct clk_ops clk_ops_pcom;
 
+struct pcom_clk_pdata {
+	struct clk_lookup *lookup;
+	u32 num_lookups;
+};
+
 int pc_clk_reset(unsigned id, enum clk_reset_action action);
 
 #define CLK_PCOM(clk_name, clk_id, clk_dev, clk_flags) {	\
diff --git a/arch/arm/mach-msm/clock.c b/arch/arm/mach-msm/clock.c
index 8d07b25..01af7a4 100644
--- a/arch/arm/mach-msm/clock.c
+++ b/arch/arm/mach-msm/clock.c
@@ -116,7 +116,7 @@ EXPORT_SYMBOL(clk_get_parent);
  */
 static struct clk *ebi1_clk;
 
-void __init msm_clock_init(struct clk_lookup *clock_tbl, unsigned num_clocks)
+void __devinit msm_clock_init(struct clk_lookup *clock_tbl, size_t num_clocks)
 {
 	unsigned n;
 
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index a25ff58..cc76bfe 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -63,4 +63,7 @@ static inline int __init clock_debug_init(void) { return 0; }
 static inline int __init clock_debug_add(struct clk *clock) { return 0; }
 #endif
 
+struct clk_lookup;
+void msm_clock_init(struct clk_lookup *clock_tbl, size_t num_clocks);
+
 #endif
diff --git a/arch/arm/mach-msm/devices-msm7x00.c b/arch/arm/mach-msm/devices-msm7x00.c
index 993780f..2e63a19 100644
--- a/arch/arm/mach-msm/devices-msm7x00.c
+++ b/arch/arm/mach-msm/devices-msm7x00.c
@@ -394,7 +394,7 @@ struct platform_device msm_device_mdp = {
 	.resource = resources_mdp,
 };
 
-struct clk_lookup msm_clocks_7x01a[] = {
+static struct clk_lookup msm_clocks_7x01a[] = {
 	CLK_PCOM("adm_clk",	ADM_CLK,	NULL, 0),
 	CLK_PCOM("adsp_clk",	ADSP_CLK,	NULL, 0),
 	CLK_PCOM("ebi1_clk",	EBI1_CLK,	NULL, 0),
@@ -438,4 +438,12 @@ struct clk_lookup msm_clocks_7x01a[] = {
 	CLK_PCOM("vfe_mdc_clk",	VFE_MDC_CLK,	NULL, OFF),
 };
 
-unsigned msm_num_clocks_7x01a = ARRAY_SIZE(msm_clocks_7x01a);
+static struct pcom_clk_pdata msm_clock_7x01a_pdata = {
+	.lookup = msm_clocks_7x01a,
+	.num_lookups = ARRAY_SIZE(msm_clocks_7x01a),
+};
+
+struct platform_device msm_clock_7x01a = {
+	.name = "msm-clock-pcom",
+	.dev.platform_data = &msm_clock_7x01a_pdata,
+};
diff --git a/arch/arm/mach-msm/devices-msm7x30.c b/arch/arm/mach-msm/devices-msm7x30.c
index 1597d43..a22f067 100644
--- a/arch/arm/mach-msm/devices-msm7x30.c
+++ b/arch/arm/mach-msm/devices-msm7x30.c
@@ -130,7 +130,7 @@ struct platform_device msm_device_hsusb_host = {
 	},
 };
 
-struct clk_lookup msm_clocks_7x30[] = {
+static struct clk_lookup msm_clocks_7x30[] = {
 	CLK_PCOM("adm_clk",	ADM_CLK,	NULL, 0),
 	CLK_PCOM("adsp_clk",	ADSP_CLK,	NULL, 0),
 	CLK_PCOM("cam_m_clk",	CAM_M_CLK,	NULL, 0),
@@ -204,5 +204,12 @@ struct clk_lookup msm_clocks_7x30[] = {
 	CLK_PCOM("csi_vfe_clk",	CSI0_VFE_CLK,	NULL, 0),
 };
 
-unsigned msm_num_clocks_7x30 = ARRAY_SIZE(msm_clocks_7x30);
+static struct pcom_clk_pdata msm_clock_7x30_pdata = {
+	.lookup = msm_clocks_7x30,
+	.num_lookups = ARRAY_SIZE(msm_clocks_7x30),
+};
 
+struct platform_device msm_clock_7x30 = {
+	.name = "msm-clock-pcom",
+	.dev.platform_data = &msm_clock_7x30_pdata,
+};
diff --git a/arch/arm/mach-msm/devices-qsd8x50.c b/arch/arm/mach-msm/devices-qsd8x50.c
index 131633b..b6c788e 100644
--- a/arch/arm/mach-msm/devices-qsd8x50.c
+++ b/arch/arm/mach-msm/devices-qsd8x50.c
@@ -291,7 +291,7 @@ int __init msm_add_sdcc(unsigned int controller,
 	return platform_device_register(pdev);
 }
 
-struct clk_lookup msm_clocks_8x50[] = {
+static struct clk_lookup msm_clocks_8x50[] = {
 	CLK_PCOM("adm_clk",	ADM_CLK,	NULL, 0),
 	CLK_PCOM("ce_clk",	CE_CLK,		NULL, 0),
 	CLK_PCOM("ebi1_clk",	EBI1_CLK,	NULL, CLK_MIN),
@@ -345,5 +345,12 @@ struct clk_lookup msm_clocks_8x50[] = {
 	CLK_PCOM("usb_phy_clk",	USB_PHY_CLK,	NULL, 0),
 };
 
-unsigned msm_num_clocks_8x50 = ARRAY_SIZE(msm_clocks_8x50);
+static struct pcom_clk_pdata msm_clock_8x50_pdata = {
+	.lookup = msm_clocks_8x50,
+	.num_lookups = ARRAY_SIZE(msm_clocks_8x50),
+};
 
+struct platform_device msm_clock_8x50 = {
+	.name = "msm-clock-pcom",
+	.dev.platform_data = &msm_clock_8x50_pdata,
+};
diff --git a/arch/arm/mach-msm/devices.h b/arch/arm/mach-msm/devices.h
index 9545c19..b53c96d 100644
--- a/arch/arm/mach-msm/devices.h
+++ b/arch/arm/mach-msm/devices.h
@@ -16,10 +16,6 @@
 #ifndef __ARCH_ARM_MACH_MSM_DEVICES_H
 #define __ARCH_ARM_MACH_MSM_DEVICES_H
 
-#include <linux/clkdev.h>
-
-#include "clock.h"
-
 extern struct platform_device msm_device_uart1;
 extern struct platform_device msm_device_uart2;
 extern struct platform_device msm_device_uart3;
@@ -46,13 +42,8 @@ extern struct platform_device msm_device_mddi0;
 extern struct platform_device msm_device_mddi1;
 extern struct platform_device msm_device_mdp;
 
-extern struct clk_lookup msm_clocks_7x01a[];
-extern unsigned msm_num_clocks_7x01a;
-
-extern struct clk_lookup msm_clocks_7x30[];
-extern unsigned msm_num_clocks_7x30;
-
-extern struct clk_lookup msm_clocks_8x50[];
-extern unsigned msm_num_clocks_8x50;
+extern struct platform_device msm_clock_7x01a;
+extern struct platform_device msm_clock_7x30;
+extern struct platform_device msm_clock_8x50;
 
 #endif
diff --git a/arch/arm/mach-msm/include/mach/board.h b/arch/arm/mach-msm/include/mach/board.h
index 0a0c393..71f19f6 100644
--- a/arch/arm/mach-msm/include/mach/board.h
+++ b/arch/arm/mach-msm/include/mach/board.h
@@ -20,16 +20,11 @@
 #include <linux/types.h>
 #include <mach/mmc.h>
 
-/* platform device data structures */
-
-struct clk_lookup;
-
 /* common init routines for use by arch/arm/mach-msm/board-*.c */
 
 void __init msm_add_devices(void);
 void __init msm_init_irq(void);
 void __init msm_init_gpio(void);
-void __init msm_clock_init(struct clk_lookup *clock_tbl, unsigned num_clocks);
 int __init msm_add_sdcc(unsigned int controller,
 			struct msm_mmc_platform_data *plat,
 			unsigned int stat_irq, unsigned long stat_irq_flags);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


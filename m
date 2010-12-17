Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab0LQAvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 19:51:35 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29783 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab0LQAuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 19:50:17 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6199"; a="67160040"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH 18/22] msm: clock: Migrate to clkdev
Date: Thu, 16 Dec 2010 16:50:02 -0800
Message-Id: <1292547006-19741-19-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd
In-Reply-To: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
References: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Migrating to clkdev has several advantages:

 * Less code in mach-msm/clock.c

 * A more robust clk_get() implementation

 * clk_add_alias() support

 * clk_get_sys() support

In general, this will help board authors setup clock aliases and
break the dependency on device pointers in the clock tables.

Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/Kconfig                        |    1 +
 arch/arm/mach-msm/clock-7x30.h          |   43 +++++++++++++++++-------------
 arch/arm/mach-msm/clock-8x60.h          |   16 ++++++-----
 arch/arm/mach-msm/clock-pcom.h          |   16 ++++++-----
 arch/arm/mach-msm/clock-voter.h         |   16 ++++++-----
 arch/arm/mach-msm/clock.c               |   37 +++++---------------------
 arch/arm/mach-msm/clock.h               |    2 +-
 arch/arm/mach-msm/devices-msm7x00.c     |   32 +++++++++++-----------
 arch/arm/mach-msm/devices-msm7x30.c     |   21 +++++++++------
 arch/arm/mach-msm/devices-msm8x60.c     |   19 ++++++++------
 arch/arm/mach-msm/devices-qsd8x50.c     |    5 ++-
 arch/arm/mach-msm/devices.h             |    8 +++---
 arch/arm/mach-msm/include/mach/board.h  |    4 ++-
 arch/arm/mach-msm/include/mach/clkdev.h |   23 ++++++++++++++++
 14 files changed, 133 insertions(+), 110 deletions(-)
 create mode 100644 arch/arm/mach-msm/include/mach/clkdev.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a19a526..fe25326 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -598,6 +598,7 @@ config ARCH_MSM
 	select HAVE_CLK
 	select GENERIC_CLOCKEVENTS
 	select ARCH_REQUIRE_GPIOLIB
+	select COMMON_CLKDEV
 	help
 	  Support for Qualcomm MSM/QSD based systems.  This runs on the
 	  apps processor of the MSM/QSD and depends on a shared memory
diff --git a/arch/arm/mach-msm/clock-7x30.h b/arch/arm/mach-msm/clock-7x30.h
index 01c49c7..bece8d1 100644
--- a/arch/arm/mach-msm/clock-7x30.h
+++ b/arch/arm/mach-msm/clock-7x30.h
@@ -154,31 +154,36 @@ extern int internal_pwr_rail_ctl_auto(unsigned rail_id, bool enable);
 
 extern struct clk_ops soc_clk_ops_7x30;
 #define CLK_7X30(clk_name, clk_id, clk_dev, clk_flags) {	\
-	.name = clk_name, \
-	.id = L_##clk_id, \
-	.remote_id = P_##clk_id, \
-	.flags = clk_flags, \
-	.dev = clk_dev, \
-	.dbg_name = #clk_id, \
+	.con_id = clk_name, \
+	.dev_id = clk_dev, \
+	.clk = &(struct clk){ \
+		.id = L_##clk_id, \
+		.remote_id = P_##clk_id, \
+		.flags = clk_flags, \
+		.dbg_name = #clk_id, \
+	}, \
 	}
 
 #define CLK_7X30S(clk_name, l_id, r_id, clk_dev, clk_flags) {	\
-	.name = clk_name, \
-	.id = L_##l_id, \
-	.remote_id = P_##r_id, \
-	.flags = clk_flags, \
-	.dev = clk_dev, \
-	.dbg_name = #l_id, \
+	.con_id = clk_name, \
+	.dev_id = clk_dev, \
+	.clk = &(struct clk){ \
+		.id = L_##l_id, \
+		.remote_id = P_##r_id, \
+		.flags = clk_flags, \
+		.dbg_name = #l_id, \
+	}, \
 	}
 
 #define CLK_7X30L(clk_name, l_id, clk_dev, clk_flags) {	\
-	.name = clk_name, \
-	.id = L_##l_id, \
-	.flags = clk_flags, \
-	.dev = clk_dev, \
-	.dbg_name = #l_id, \
-	.ops = &soc_clk_ops_7x30, \
+	.con_id = clk_name, \
+	.dev_id = clk_dev, \
+	.clk = &(struct clk){ \
+		.id = L_##l_id, \
+		.flags = clk_flags, \
+		.dbg_name = #l_id, \
+		.ops = &soc_clk_ops_7x30, \
+	}, \
 	}
 
 #endif
-
diff --git a/arch/arm/mach-msm/clock-8x60.h b/arch/arm/mach-msm/clock-8x60.h
index 2019add..c6e2244 100644
--- a/arch/arm/mach-msm/clock-8x60.h
+++ b/arch/arm/mach-msm/clock-8x60.h
@@ -203,13 +203,15 @@ struct pll_rate {
 
 extern struct clk_ops soc_clk_ops_8x60;
 #define CLK_8X60(clk_name, clk_id, clk_dev, clk_flags) {	\
-	.name = clk_name, \
-	.id = L_##clk_id, \
-	.remote_id = L_##clk_id, \
-	.ops = &soc_clk_ops_8x60, \
-	.flags = clk_flags, \
-	.dev = clk_dev, \
-	.dbg_name = #clk_id, \
+	.con_id = clk_name, \
+	.dev_id = clk_dev, \
+	.clk = &(struct clk){ \
+		.id = L_##clk_id, \
+		.remote_id = L_##clk_id, \
+		.ops = &soc_clk_ops_8x60, \
+		.flags = clk_flags, \
+		.dbg_name = #clk_id, \
+	}, \
 	}
 
 #endif
diff --git a/arch/arm/mach-msm/clock-pcom.h b/arch/arm/mach-msm/clock-pcom.h
index e2bca82..ef07632 100644
--- a/arch/arm/mach-msm/clock-pcom.h
+++ b/arch/arm/mach-msm/clock-pcom.h
@@ -144,13 +144,15 @@ extern struct clk_ops clk_ops_pcom_div2;
 int pc_clk_reset(unsigned id, enum clk_reset_action action);
 
 #define CLK_PCOM(clk_name, clk_id, clk_dev, clk_flags) {	\
-	.name = clk_name, \
-	.id = P_##clk_id, \
-	.remote_id = P_##clk_id, \
-	.ops = &clk_ops_pcom, \
-	.flags = clk_flags, \
-	.dev = clk_dev, \
-	.dbg_name = #clk_id, \
+	.con_id = clk_name, \
+	.dev_id = clk_dev, \
+	.clk = &(struct clk){ \
+		.id = P_##clk_id, \
+		.remote_id = P_##clk_id, \
+		.ops = &clk_ops_pcom, \
+		.flags = clk_flags, \
+		.dbg_name = #clk_id, \
+	}, \
 	}
 
 #endif
diff --git a/arch/arm/mach-msm/clock-voter.h b/arch/arm/mach-msm/clock-voter.h
index 84bc0b3..d62e35d 100644
--- a/arch/arm/mach-msm/clock-voter.h
+++ b/arch/arm/mach-msm/clock-voter.h
@@ -40,13 +40,15 @@ struct clk_ops;
 extern struct clk_ops clk_ops_voter;
 
 #define CLK_VOTER(clk_name, clk_id, agg_name, clk_dev, clk_flags) {	\
-	.name = clk_name, \
-	.id = V_##clk_id, \
-	.flags = clk_flags | CLKFLAG_HANDLE, \
-	.dev = clk_dev, \
-	.aggregator = agg_name, \
-	.dbg_name = clk_name, \
-	.ops = &clk_ops_voter, \
+	.con_id = clk_name, \
+	.dev_id = clk_dev, \
+	.clk = &(struct clk){ \
+		.id = V_##clk_id, \
+		.flags = clk_flags | CLKFLAG_HANDLE, \
+		.aggregator = agg_name, \
+		.dbg_name = clk_name, \
+		.ops = &clk_ops_voter, \
+	}, \
 	}
 
 #endif
diff --git a/arch/arm/mach-msm/clock.c b/arch/arm/mach-msm/clock.c
index c505e30..ca2805a 100644
--- a/arch/arm/mach-msm/clock.c
+++ b/arch/arm/mach-msm/clock.c
@@ -23,6 +23,8 @@
 #include <linux/string.h>
 #include <linux/module.h>
 
+#include <asm/clkdev.h>
+
 #include "clock.h"
 
 static DEFINE_MUTEX(clocks_mutex);
@@ -31,32 +33,6 @@ static LIST_HEAD(clocks);
 /*
  * Standard clock functions defined in include/linux/clk.h
  */
-struct clk *clk_get(struct device *dev, const char *id)
-{
-	struct clk *clk;
-
-	mutex_lock(&clocks_mutex);
-
-	list_for_each_entry(clk, &clocks, list)
-		if (!strcmp(id, clk->name) && clk->dev == dev)
-			goto found_it;
-
-	list_for_each_entry(clk, &clocks, list)
-		if (!strcmp(id, clk->name) && clk->dev == NULL)
-			goto found_it;
-
-	clk = ERR_PTR(-ENOENT);
-found_it:
-	mutex_unlock(&clocks_mutex);
-	return clk;
-}
-EXPORT_SYMBOL(clk_get);
-
-void clk_put(struct clk *clk)
-{
-}
-EXPORT_SYMBOL(clk_put);
-
 int clk_enable(struct clk *clk)
 {
 	return clk->ops->enable(clk->id);
@@ -142,7 +118,7 @@ int clk_set_flags(struct clk *clk, unsigned long flags)
 }
 EXPORT_SYMBOL(clk_set_flags);
 
-void __init msm_clock_init(struct clk *clock_tbl, unsigned num_clocks)
+void __init msm_clock_init(struct clk_lookup *clock_tbl, unsigned num_clocks)
 {
 	unsigned n;
 	struct clk *clk;
@@ -152,13 +128,14 @@ void __init msm_clock_init(struct clk *clock_tbl, unsigned num_clocks)
 
 	mutex_lock(&clocks_mutex);
 	for (n = 0; n < num_clocks; n++) {
-		msm_clk_soc_set_ops(&clock_tbl[n]);
-		list_add_tail(&clock_tbl[n].list, &clocks);
+		msm_clk_soc_set_ops(clock_tbl[n].clk);
+		clkdev_add(&clock_tbl[n]);
+		list_add_tail(&clock_tbl[n].clk->list, &clocks);
 	}
 	mutex_unlock(&clocks_mutex);
 
 	for (n = 0; n < num_clocks; n++) {
-		clk = &clock_tbl[n];
+		clk = clock_tbl[n].clk;
 		if (clk->flags & CLKFLAG_HANDLE) {
 			struct clk *agg_clk = clk_get(NULL, clk->aggregator);
 			BUG_ON(IS_ERR(agg_clk));
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index 9278c03..c7449a5 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -18,6 +18,7 @@
 #define __ARCH_ARM_MACH_MSM_CLOCK_H
 
 #include <linux/init.h>
+#include <linux/types.h>
 #include <linux/list.h>
 #include <mach/clk.h>
 
@@ -54,7 +55,6 @@ struct clk {
 	uint32_t id;
 	uint32_t remote_id;
 	uint32_t flags;
-	const char *name;
 	struct clk_ops *ops;
 	const char *dbg_name;
 	struct list_head list;
diff --git a/arch/arm/mach-msm/devices-msm7x00.c b/arch/arm/mach-msm/devices-msm7x00.c
index fb548a8..c3f7c06 100644
--- a/arch/arm/mach-msm/devices-msm7x00.c
+++ b/arch/arm/mach-msm/devices-msm7x00.c
@@ -18,13 +18,13 @@
 
 #include <mach/irqs.h>
 #include <mach/msm_iomap.h>
+#include <asm/clkdev.h>
 #include "devices.h"
 
 #include <asm/mach/flash.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
 
-
 #include "clock.h"
 #include <mach/mmc.h>
 
@@ -414,7 +414,7 @@ struct platform_device msm_device_mdp = {
 	.resource = resources_mdp,
 };
 
-struct clk msm_clocks_7x01a[] = {
+struct clk_lookup msm_clocks_7x01a[] = {
 	CLK_PCOM("adm_clk",	ADM_CLK,	NULL, 0),
 	CLK_PCOM("adsp_clk",	ADSP_CLK,	NULL, 0),
 	CLK_PCOM("ebi1_clk",	EBI1_CLK,	NULL, 0),
@@ -423,7 +423,7 @@ struct clk msm_clocks_7x01a[] = {
 	CLK_PCOM("emdh_clk",	EMDH_CLK,	NULL, OFF),
 	CLK_PCOM("gp_clk",		GP_CLK,		NULL, 0),
 	CLK_PCOM("grp_clk",	GRP_3D_CLK,	NULL, OFF),
-	CLK_PCOM("i2c_clk",	I2C_CLK,	&msm_device_i2c.dev, 0),
+	CLK_PCOM("i2c_clk",	I2C_CLK,	"msm_i2c.0", 0),
 	CLK_PCOM("icodec_rx_clk",	ICODEC_RX_CLK,	NULL, 0),
 	CLK_PCOM("icodec_tx_clk",	ICODEC_TX_CLK,	NULL, 0),
 	CLK_PCOM("imem_clk",	IMEM_CLK,	NULL, OFF),
@@ -433,25 +433,25 @@ struct clk msm_clocks_7x01a[] = {
 	CLK_PCOM("pcm_clk",	PCM_CLK,	NULL, 0),
 	CLK_PCOM("mddi_clk",	PMDH_CLK,	NULL, OFF | CLK_MINMAX),
 	CLK_PCOM("sdac_clk",	SDAC_CLK,	NULL, OFF),
-	CLK_PCOM("sdc_clk",	SDC1_CLK,	&msm_device_sdc1.dev, OFF),
-	CLK_PCOM("sdc_pclk",	SDC1_P_CLK,	&msm_device_sdc1.dev, OFF),
-	CLK_PCOM("sdc_clk",	SDC2_CLK,	&msm_device_sdc2.dev, OFF),
-	CLK_PCOM("sdc_pclk",	SDC2_P_CLK,	&msm_device_sdc2.dev, OFF),
-	CLK_PCOM("sdc_clk",	SDC3_CLK,	&msm_device_sdc3.dev, OFF),
-	CLK_PCOM("sdc_pclk",	SDC3_P_CLK,	&msm_device_sdc3.dev, OFF),
-	CLK_PCOM("sdc_clk",	SDC4_CLK,	&msm_device_sdc4.dev, OFF),
-	CLK_PCOM("sdc_pclk",	SDC4_P_CLK,	&msm_device_sdc4.dev, OFF),
+	CLK_PCOM("sdc_clk",	SDC1_CLK,	"msm_sdcc.1", OFF),
+	CLK_PCOM("sdc_pclk",	SDC1_P_CLK,	"msm_sdcc.1", OFF),
+	CLK_PCOM("sdc_clk",	SDC2_CLK,	"msm_sdcc.2", OFF),
+	CLK_PCOM("sdc_pclk",	SDC2_P_CLK,	"msm_sdcc.2", OFF),
+	CLK_PCOM("sdc_clk",	SDC3_CLK,	"msm_sdcc.3", OFF),
+	CLK_PCOM("sdc_pclk",	SDC3_P_CLK,	"msm_sdcc.3", OFF),
+	CLK_PCOM("sdc_clk",	SDC4_CLK,	"msm_sdcc.4", OFF),
+	CLK_PCOM("sdc_pclk",	SDC4_P_CLK,	"msm_sdcc.4", OFF),
 	CLK_PCOM("tsif_clk",	TSIF_CLK,	NULL, 0),
 	CLK_PCOM("tsif_ref_clk",	TSIF_REF_CLK,	NULL, 0),
 	CLK_PCOM("tv_dac_clk",	TV_DAC_CLK,	NULL, 0),
 	CLK_PCOM("tv_enc_clk",	TV_ENC_CLK,	NULL, 0),
-	CLK_PCOM("uart_clk",	UART1_CLK,	&msm_device_uart1.dev, OFF),
-	CLK_PCOM("uart_clk",	UART2_CLK,	&msm_device_uart2.dev, 0),
-	CLK_PCOM("uart_clk",	UART3_CLK,	&msm_device_uart3.dev, OFF),
+	CLK_PCOM("uart_clk",	UART1_CLK,	"msm_serial.0", OFF),
+	CLK_PCOM("uart_clk",	UART2_CLK,	"msm_serial.1", 0),
+	CLK_PCOM("uart_clk",	UART3_CLK,	"msm_serial.2", OFF),
 	CLK_PCOM("uart1dm_clk",	UART1DM_CLK,	NULL, OFF),
 	CLK_PCOM("uart2dm_clk",	UART2DM_CLK,	NULL, 0),
-	CLK_PCOM("usb_hs_clk",	USB_HS_CLK,	&msm_device_hsusb.dev, OFF),
-	CLK_PCOM("usb_hs_pclk",	USB_HS_P_CLK,	&msm_device_hsusb.dev, OFF),
+	CLK_PCOM("usb_hs_clk",	USB_HS_CLK,	"msm_hsusb", OFF),
+	CLK_PCOM("usb_hs_pclk",	USB_HS_P_CLK,	"msm_hsusb", OFF),
 	CLK_PCOM("usb_otg_clk",	USB_OTG_CLK,	NULL, 0),
 	CLK_PCOM("vdc_clk",	VDC_CLK,	NULL, OFF ),
 	CLK_PCOM("vfe_clk",	VFE_CLK,	NULL, OFF),
diff --git a/arch/arm/mach-msm/devices-msm7x30.c b/arch/arm/mach-msm/devices-msm7x30.c
index f18d86b..359b427 100644
--- a/arch/arm/mach-msm/devices-msm7x30.c
+++ b/arch/arm/mach-msm/devices-msm7x30.c
@@ -17,10 +17,12 @@
 #include <linux/platform_device.h>
 
 #include <linux/dma-mapping.h>
+#include <asm/clkdev.h>
 #include <mach/irqs.h>
 #include <mach/msm_iomap.h>
 #include <mach/dma.h>
 #include <mach/board.h>
+#include <asm/clkdev.h>
 
 #include "devices.h"
 #include "clock-voter.h"
@@ -58,7 +60,8 @@ struct platform_device msm_device_smd = {
 	.id     = -1,
 };
 
-struct clk msm_clocks_7x30[] = {
+struct clk_lookup msm_clocks_7x30[] = {
+	CLK_PCOM("adm_clk",	ADM_CLK,	NULL, 0),
 	CLK_PCOM("adsp_clk",	ADSP_CLK,	NULL, 0),
 	CLK_PCOM("cam_m_clk",	CAM_M_CLK,	NULL, 0),
 	CLK_PCOM("camif_pad_pclk",	CAMIF_PAD_P_CLK,	NULL, OFF),
@@ -70,12 +73,14 @@ struct clk msm_clocks_7x30[] = {
 	CLK_PCOM("usb_phy_clk",	USB_PHY_CLK,	NULL, 0),
 	CLK_PCOM("vdc_clk",	VDC_CLK,	NULL, OFF | CLK_MIN),
 	{
-		.name = "pbus_clk",
-		.id = P_PBUS_CLK,
-		.remote_id = P_PBUS_CLK,
-		.ops = &clk_ops_pcom_div2,
-		.flags = CLK_MIN,
-		.dbg_name = "pbus_clk",
+		.con_id = "pbus_clk",
+		.clk = &(struct clk){
+			.id = P_PBUS_CLK,
+			.remote_id = P_PBUS_CLK,
+			.ops = &clk_ops_pcom_div2,
+			.flags = CLK_MIN,
+			.dbg_name = "pbus_clk",
+		}
 	},
 
 	CLK_7X30("adm_clk",	ADM_CLK,	NULL, 0),
@@ -137,7 +142,7 @@ struct clk msm_clocks_7x30[] = {
 	CLK_7X30("tv_enc_clk",	TV_ENC_CLK,	NULL, 0),
 	CLK_7X30S("tv_src_clk",	TV_CLK,		TV_ENC_CLK,	NULL, 0),
 	CLK_7X30("uart_clk",	UART1_CLK,	NULL, OFF),
-	CLK_7X30("uart_clk",	UART2_CLK,	&msm_device_uart2.dev, 0),
+	CLK_7X30("uart_clk",	UART2_CLK,	"msm_serial.1", 0),
 	CLK_7X30("uartdm_clk",	UART1DM_CLK,	NULL, OFF),
 	CLK_7X30L("uartdm_pclk", UART1DM_P_CLK,	NULL, 0),
 	CLK_7X30("uartdm_clk",	UART2DM_CLK,	NULL, 0),
diff --git a/arch/arm/mach-msm/devices-msm8x60.c b/arch/arm/mach-msm/devices-msm8x60.c
index 1f2b189..8842465 100644
--- a/arch/arm/mach-msm/devices-msm8x60.c
+++ b/arch/arm/mach-msm/devices-msm8x60.c
@@ -18,11 +18,14 @@
 
 #include <linux/kernel.h>
 #include <linux/clk.h>
+#include <linux/list.h>
+
+#include <asm/clkdev.h>
 
 #include "clock.h"
 #include "clock-8x60.h"
 
-struct clk msm_clocks_8x60[] = {
+struct clk_lookup msm_clocks_8x60[] = {
 	CLK_8X60("ce_clk",		CE2_CLK,		NULL, OFF),
 	CLK_8X60("gsbi_uart_clk",	GSBI1_UART_CLK,		NULL, OFF),
 	CLK_8X60("gsbi_uart_clk",	GSBI2_UART_CLK,		NULL, OFF),
@@ -167,13 +170,13 @@ struct clk msm_clocks_8x60[] = {
 	CLK_8X60("i2s_spkr_osr_clk",	SPARE_I2S_SPKR_OSR_CLK,	NULL, OFF),
 	CLK_8X60("i2s_spkr_bit_clk",	SPARE_I2S_SPKR_BIT_CLK,	NULL, OFF),
 	CLK_8X60("pcm_clk",		PCM_CLK,		NULL, OFF),
-	CLK_8X60("iommu_clk",           JPEGD_AXI_CLK, NULL, 0),
-	CLK_8X60("iommu_clk",           VFE_AXI_CLK, NULL, 0),
-	CLK_8X60("iommu_clk",           VCODEC_AXI_CLK, NULL, 0),
-	CLK_8X60("iommu_clk",           VCODEC_AXI_CLK, NULL, 0),
-	CLK_8X60("iommu_clk",           GFX3D_CLK, NULL, 0),
-	CLK_8X60("iommu_clk",           GFX2D0_CLK, NULL, 0),
-	CLK_8X60("iommu_clk",           GFX2D1_CLK, NULL, 0),
+	CLK_8X60("iommu_clk",           JPEGD_AXI_CLK, "msm_iommu.0", 0),
+	CLK_8X60("iommu_clk",           VFE_AXI_CLK, "msm_iommu.6", 0),
+	CLK_8X60("iommu_clk",           VCODEC_AXI_CLK, "msm_iommu.7", 0),
+	CLK_8X60("iommu_clk",           VCODEC_AXI_CLK, "msm_iommu.8", 0),
+	CLK_8X60("iommu_clk",           GFX3D_CLK, "msm_iommu.9", 0),
+	CLK_8X60("iommu_clk",           GFX2D0_CLK, "msm_iommu.10", 0),
+	CLK_8X60("iommu_clk",           GFX2D1_CLK, "msm_iommu.11", 0),
 };
 
 unsigned msm_num_clocks_8x60 = ARRAY_SIZE(msm_clocks_8x60);
diff --git a/arch/arm/mach-msm/devices-qsd8x50.c b/arch/arm/mach-msm/devices-qsd8x50.c
index 3b11d28..33a9d13 100644
--- a/arch/arm/mach-msm/devices-qsd8x50.c
+++ b/arch/arm/mach-msm/devices-qsd8x50.c
@@ -17,6 +17,7 @@
 #include <linux/platform_device.h>
 
 #include <linux/dma-mapping.h>
+#include <asm/clkdev.h>
 #include <mach/irqs.h>
 #include <mach/msm_iomap.h>
 #include <mach/dma.h>
@@ -55,7 +56,7 @@ struct platform_device msm_device_smd = {
 	.id     = -1,
 };
 
-struct clk msm_clocks_8x50[] = {
+struct clk_lookup msm_clocks_8x50[] = {
 	CLK_PCOM("adm_clk",	ADM_CLK,	NULL, 0),
 	CLK_PCOM("ce_clk",	CE_CLK,		NULL, 0),
 	CLK_PCOM("ebi1_clk",	EBI1_CLK,	NULL, CLK_MIN),
@@ -92,7 +93,7 @@ struct clk msm_clocks_8x50[] = {
 	CLK_PCOM("tv_enc_clk",	TV_ENC_CLK,	NULL, 0),
 	CLK_PCOM("uart_clk",	UART1_CLK,	NULL, OFF),
 	CLK_PCOM("uart_clk",	UART2_CLK,	NULL, 0),
-	CLK_PCOM("uart_clk",	UART3_CLK,	&msm_device_uart3.dev, OFF),
+	CLK_PCOM("uart_clk",	UART3_CLK,	"msm_serial.2", OFF),
 	CLK_PCOM("uartdm_clk",	UART1DM_CLK,	NULL, OFF),
 	CLK_PCOM("uartdm_clk",	UART2DM_CLK,	NULL, 0),
 	CLK_PCOM("usb_hs_clk",	USB_HS_CLK,	NULL, OFF),
diff --git a/arch/arm/mach-msm/devices.h b/arch/arm/mach-msm/devices.h
index 81d2b5d8..72405cf 100644
--- a/arch/arm/mach-msm/devices.h
+++ b/arch/arm/mach-msm/devices.h
@@ -39,16 +39,16 @@ extern struct platform_device msm_device_mddi0;
 extern struct platform_device msm_device_mddi1;
 extern struct platform_device msm_device_mdp;
 
-extern struct clk msm_clocks_7x01a[];
+extern struct clk_lookup msm_clocks_7x01a[];
 extern unsigned msm_num_clocks_7x01a;
 
-extern struct clk msm_clocks_7x30[];
+extern struct clk_lookup msm_clocks_7x30[];
 extern unsigned msm_num_clocks_7x30;
 
-extern struct clk msm_clocks_8x50[];
+extern struct clk_lookup msm_clocks_8x50[];
 extern unsigned msm_num_clocks_8x50;
 
-extern struct clk msm_clocks_8x60[];
+extern struct clk_lookup msm_clocks_8x60[];
 extern unsigned msm_num_clocks_8x60;
 
 #endif
diff --git a/arch/arm/mach-msm/include/mach/board.h b/arch/arm/mach-msm/include/mach/board.h
index 6abf4a6..8652037 100644
--- a/arch/arm/mach-msm/include/mach/board.h
+++ b/arch/arm/mach-msm/include/mach/board.h
@@ -20,6 +20,8 @@
 #include <linux/types.h>
 #include <mach/mmc.h>
 
+#include <asm/clkdev.h>
+
 /* platform device data structures */
 
 struct msm_acpu_clock_platform_data
@@ -41,7 +43,7 @@ void __init msm_add_devices(void);
 void __init msm_map_common_io(void);
 void __init msm_init_irq(void);
 void __init msm_init_gpio(void);
-void __init msm_clock_init(struct clk *clock_tbl, unsigned num_clocks);
+void __init msm_clock_init(struct clk_lookup *clock_tbl, unsigned num_clocks);
 void __init msm_acpu_clock_init(struct msm_acpu_clock_platform_data *);
 int __init msm_add_sdcc(unsigned int controller,
 			struct msm_mmc_platform_data *plat,
diff --git a/arch/arm/mach-msm/include/mach/clkdev.h b/arch/arm/mach-msm/include/mach/clkdev.h
new file mode 100644
index 0000000..939b329
--- /dev/null
+++ b/arch/arm/mach-msm/include/mach/clkdev.h
@@ -0,0 +1,23 @@
+/*
+ * Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+#ifndef __ASM_ARCH_MSM_CLKDEV_H
+#define __ASM_ARCH_MSM_CLKDEV_H
+
+static inline int __clk_get(struct clk *clk) { return 1; }
+static inline void __clk_put(struct clk *clk) { }
+#endif
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


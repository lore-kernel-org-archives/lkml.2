Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab1BWRh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:37:58 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20035 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab1BWRhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:37:48 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6266"; a="76004351"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH 2/2] msm: clock: Migrate to clkdev
Date: Wed, 23 Feb 2011 09:37:42 -0800
Message-Id: <1298482662-27298-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1.55.gdca3d
In-Reply-To: <1298482662-27298-1-git-send-email-sboyd@codeaurora.org>
References: <1298482662-27298-1-git-send-email-sboyd@codeaurora.org>
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

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/Kconfig                        |    1 +
 arch/arm/mach-msm/board-msm7x30.c       |    1 +
 arch/arm/mach-msm/board-msm8960.c       |    1 +
 arch/arm/mach-msm/board-qsd8x50.c       |    1 +
 arch/arm/mach-msm/board-trout.c         |    1 +
 arch/arm/mach-msm/clock-7x30.h          |   31 +++++++++++++-----------
 arch/arm/mach-msm/clock-pcom.h          |   16 +++++++-----
 arch/arm/mach-msm/clock.c               |   39 ++++++++-----------------------
 arch/arm/mach-msm/clock.h               |    2 -
 arch/arm/mach-msm/devices-msm7x00.c     |   32 ++++++++++++------------
 arch/arm/mach-msm/devices-msm7x30.c     |    5 ++-
 arch/arm/mach-msm/devices-qsd8x50.c     |   23 +++++++++--------
 arch/arm/mach-msm/devices.h             |    8 ++++--
 arch/arm/mach-msm/include/mach/board.h  |    4 +-
 arch/arm/mach-msm/include/mach/clkdev.h |   19 +++++++++++++++
 15 files changed, 98 insertions(+), 86 deletions(-)
 create mode 100644 arch/arm/mach-msm/include/mach/clkdev.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5cff165..4d26650 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -619,6 +619,7 @@ config ARCH_MSM
 	select HAVE_CLK
 	select GENERIC_CLOCKEVENTS
 	select ARCH_REQUIRE_GPIOLIB
+	select CLKDEV_LOOKUP
 	help
 	  Support for Qualcomm MSM/QSD based systems.  This runs on the
 	  apps processor of the MSM/QSD and depends on a shared memory
diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-msm7x30.c
index dc9fac1..cf15889 100644
--- a/arch/arm/mach-msm/board-msm7x30.c
+++ b/arch/arm/mach-msm/board-msm7x30.c
@@ -23,6 +23,7 @@
 #include <linux/io.h>
 #include <linux/smsc911x.h>
 #include <linux/usb/msm_hsusb.h>
+#include <linux/clkdev.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/mach-msm/board-msm8960.c b/arch/arm/mach-msm/board-msm8960.c
index ef80f46..1993721 100644
--- a/arch/arm/mach-msm/board-msm8960.c
+++ b/arch/arm/mach-msm/board-msm8960.c
@@ -19,6 +19,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/irq.h>
+#include <linux/clkdev.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/mach-msm/board-qsd8x50.c b/arch/arm/mach-msm/board-qsd8x50.c
index b464d48..127ee6d 100644
--- a/arch/arm/mach-msm/board-qsd8x50.c
+++ b/arch/arm/mach-msm/board-qsd8x50.c
@@ -22,6 +22,7 @@
 #include <linux/delay.h>
 #include <linux/usb/msm_hsusb.h>
 #include <linux/err.h>
+#include <linux/clkdev.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/mach-msm/board-trout.c b/arch/arm/mach-msm/board-trout.c
index 8448687..8143867 100644
--- a/arch/arm/mach-msm/board-trout.c
+++ b/arch/arm/mach-msm/board-trout.c
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/clkdev.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/mach-msm/clock-7x30.h b/arch/arm/mach-msm/clock-7x30.h
index 43c8e27..8c876fa 100644
--- a/arch/arm/mach-msm/clock-7x30.h
+++ b/arch/arm/mach-msm/clock-7x30.h
@@ -147,23 +147,26 @@ void pll_disable(uint32_t pll);
 extern int internal_pwr_rail_ctl_auto(unsigned rail_id, bool enable);
 
 #define CLK_7X30(clk_name, clk_id, clk_dev, clk_flags) {	\
-	.name = clk_name, \
-	.id = L_7X30_##clk_id, \
-	.remote_id = P_##clk_id, \
-	.flags = clk_flags, \
-	.dev = clk_dev, \
-	.dbg_name = #clk_id, \
+	.con_id = clk_name, \
+	.dev_id = clk_dev, \
+	.clk = &(struct clk){ \
+		.id = L_7X30_##clk_id, \
+		.remote_id = P_##clk_id, \
+		.flags = clk_flags, \
+		.dbg_name = #clk_id, \
+	}, \
 	}
 
 #define CLK_7X30S(clk_name, l_id, r_id, clk_dev, clk_flags) {	\
-	.name = clk_name, \
-	.id = L_7X30_##l_id, \
-	.remote_id = P_##r_id, \
-	.flags = clk_flags, \
-	.dev = clk_dev, \
-	.dbg_name = #l_id, \
-	.ops = &clk_ops_pcom, \
+	.con_id = clk_name, \
+	.dev_id = clk_dev, \
+	.clk = &(struct clk){ \
+		.id = L_7X30_##l_id, \
+		.remote_id = P_##r_id, \
+		.flags = clk_flags, \
+		.dbg_name = #l_id, \
+		.ops = &clk_ops_pcom, \
+	}, \
 	}
 
 #endif
-
diff --git a/arch/arm/mach-msm/clock-pcom.h b/arch/arm/mach-msm/clock-pcom.h
index 2c813f1..f6b5989 100644
--- a/arch/arm/mach-msm/clock-pcom.h
+++ b/arch/arm/mach-msm/clock-pcom.h
@@ -143,13 +143,15 @@ extern struct clk_ops clk_ops_pcom;
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
diff --git a/arch/arm/mach-msm/clock.c b/arch/arm/mach-msm/clock.c
index e00f6a0..22a5376 100644
--- a/arch/arm/mach-msm/clock.c
+++ b/arch/arm/mach-msm/clock.c
@@ -19,6 +19,11 @@
 #include <linux/err.h>
 #include <linux/spinlock.h>
 #include <linux/pm_qos_params.h>
+#include <linux/mutex.h>
+#include <linux/clk.h>
+#include <linux/string.h>
+#include <linux/module.h>
+#include <linux/clkdev.h>
 
 #include "clock.h"
 
@@ -29,32 +34,6 @@ static LIST_HEAD(clocks);
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
 	unsigned long flags;
@@ -157,13 +136,15 @@ EXPORT_SYMBOL(clk_set_flags);
  */
 static struct clk *ebi1_clk;
 
-void __init msm_clock_init(struct clk *clock_tbl, unsigned num_clocks)
+void __init msm_clock_init(struct clk_lookup *clock_tbl, unsigned num_clocks)
 {
 	unsigned n;
 
 	mutex_lock(&clocks_mutex);
-	for (n = 0; n < num_clocks; n++)
-		list_add_tail(&clock_tbl[n].list, &clocks);
+	for (n = 0; n < num_clocks; n++) {
+		clkdev_add(&clock_tbl[n]);
+		list_add_tail(&clock_tbl[n].clk->list, &clocks);
+	}
 	mutex_unlock(&clocks_mutex);
 
 	ebi1_clk = clk_get(NULL, "ebi1_clk");
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index 8d302c7..2c007f6 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -51,11 +51,9 @@ struct clk {
 	uint32_t remote_id;
 	uint32_t count;
 	uint32_t flags;
-	const char *name;
 	struct clk_ops *ops;
 	const char *dbg_name;
 	struct list_head list;
-	struct device *dev;
 };
 
 #define OFF CLKFLAG_AUTO_OFF
diff --git a/arch/arm/mach-msm/devices-msm7x00.c b/arch/arm/mach-msm/devices-msm7x00.c
index ed62806..c4f5e26 100644
--- a/arch/arm/mach-msm/devices-msm7x00.c
+++ b/arch/arm/mach-msm/devices-msm7x00.c
@@ -15,6 +15,7 @@
 
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
+#include <linux/clkdev.h>
 
 #include <mach/irqs.h>
 #include <mach/msm_iomap.h>
@@ -24,7 +25,6 @@
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
 
-
 #include "clock.h"
 #include "clock-pcom.h"
 #include <mach/mmc.h>
@@ -418,7 +418,7 @@ struct platform_device msm_device_mdp = {
 	.resource = resources_mdp,
 };
 
-struct clk msm_clocks_7x01a[] = {
+struct clk_lookup msm_clocks_7x01a[] = {
 	CLK_PCOM("adm_clk",	ADM_CLK,	NULL, 0),
 	CLK_PCOM("adsp_clk",	ADSP_CLK,	NULL, 0),
 	CLK_PCOM("ebi1_clk",	EBI1_CLK,	NULL, 0),
@@ -427,7 +427,7 @@ struct clk msm_clocks_7x01a[] = {
 	CLK_PCOM("emdh_clk",	EMDH_CLK,	NULL, OFF),
 	CLK_PCOM("gp_clk",		GP_CLK,		NULL, 0),
 	CLK_PCOM("grp_clk",	GRP_3D_CLK,	NULL, OFF),
-	CLK_PCOM("i2c_clk",	I2C_CLK,	&msm_device_i2c.dev, 0),
+	CLK_PCOM("i2c_clk",	I2C_CLK,	"msm_i2c.0", 0),
 	CLK_PCOM("icodec_rx_clk",	ICODEC_RX_CLK,	NULL, 0),
 	CLK_PCOM("icodec_tx_clk",	ICODEC_TX_CLK,	NULL, 0),
 	CLK_PCOM("imem_clk",	IMEM_CLK,	NULL, OFF),
@@ -437,25 +437,25 @@ struct clk msm_clocks_7x01a[] = {
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
index cd4343b..09b4f14 100644
--- a/arch/arm/mach-msm/devices-msm7x30.c
+++ b/arch/arm/mach-msm/devices-msm7x30.c
@@ -17,6 +17,7 @@
 #include <linux/platform_device.h>
 
 #include <linux/dma-mapping.h>
+#include <linux/clkdev.h>
 #include <mach/irqs.h>
 #include <mach/msm_iomap.h>
 #include <mach/dma.h>
@@ -129,7 +130,7 @@ struct platform_device msm_device_hsusb_host = {
 	},
 };
 
-struct clk msm_clocks_7x30[] = {
+struct clk_lookup msm_clocks_7x30[] = {
 	CLK_PCOM("adm_clk",	ADM_CLK,	NULL, 0),
 	CLK_PCOM("adsp_clk",	ADSP_CLK,	NULL, 0),
 	CLK_PCOM("cam_m_clk",	CAM_M_CLK,	NULL, 0),
@@ -181,7 +182,7 @@ struct clk msm_clocks_7x30[] = {
 	CLK_7X30S("tv_src_clk",	TV_CLK, 	TV_ENC_CLK,	NULL, 0),
 	CLK_PCOM("tv_dac_clk",	TV_DAC_CLK,	NULL, 0),
 	CLK_PCOM("tv_enc_clk",	TV_ENC_CLK,	NULL, 0),
-	CLK_PCOM("uart_clk",	UART2_CLK,	&msm_device_uart2.dev, 0),
+	CLK_PCOM("uart_clk",	UART2_CLK,	"msm_serial.1", 0),
 	CLK_PCOM("usb_phy_clk",	USB_PHY_CLK,	NULL, 0),
 	CLK_PCOM("usb_hs_clk",		USB_HS_CLK,		NULL, OFF),
 	CLK_PCOM("usb_hs_pclk",		USB_HS_P_CLK,		NULL, OFF),
diff --git a/arch/arm/mach-msm/devices-qsd8x50.c b/arch/arm/mach-msm/devices-qsd8x50.c
index bd545f9..12d8deb 100644
--- a/arch/arm/mach-msm/devices-qsd8x50.c
+++ b/arch/arm/mach-msm/devices-qsd8x50.c
@@ -15,8 +15,9 @@
 
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
-
+#include <linux/clkdev.h>
 #include <linux/dma-mapping.h>
+
 #include <mach/irqs.h>
 #include <mach/msm_iomap.h>
 #include <mach/dma.h>
@@ -314,7 +315,7 @@ int __init msm_add_sdcc(unsigned int controller,
 	return platform_device_register(pdev);
 }
 
-struct clk msm_clocks_8x50[] = {
+struct clk_lookup msm_clocks_8x50[] = {
 	CLK_PCOM("adm_clk",	ADM_CLK,	NULL, 0),
 	CLK_PCOM("ce_clk",	CE_CLK,		NULL, 0),
 	CLK_PCOM("ebi1_clk",	EBI1_CLK,	NULL, CLK_MIN),
@@ -336,14 +337,14 @@ struct clk msm_clocks_8x50[] = {
 	CLK_PCOM("pbus_clk",	PBUS_CLK,	NULL, CLK_MIN),
 	CLK_PCOM("pcm_clk",	PCM_CLK,	NULL, 0),
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
 	CLK_PCOM("spi_clk",	SPI_CLK,	NULL, 0),
 	CLK_PCOM("tsif_clk",	TSIF_CLK,	NULL, 0),
 	CLK_PCOM("tsif_ref_clk",	TSIF_REF_CLK,	NULL, 0),
@@ -351,7 +352,7 @@ struct clk msm_clocks_8x50[] = {
 	CLK_PCOM("tv_enc_clk",	TV_ENC_CLK,	NULL, 0),
 	CLK_PCOM("uart_clk",	UART1_CLK,	NULL, OFF),
 	CLK_PCOM("uart_clk",	UART2_CLK,	NULL, 0),
-	CLK_PCOM("uart_clk",	UART3_CLK,	&msm_device_uart3.dev, OFF),
+	CLK_PCOM("uart_clk",	UART3_CLK,	"msm_serial.2", OFF),
 	CLK_PCOM("uartdm_clk",	UART1DM_CLK,	NULL, OFF),
 	CLK_PCOM("uartdm_clk",	UART2DM_CLK,	NULL, 0),
 	CLK_PCOM("usb_hs_clk",	USB_HS_CLK,	NULL, OFF),
diff --git a/arch/arm/mach-msm/devices.h b/arch/arm/mach-msm/devices.h
index e2643b3..9545c19 100644
--- a/arch/arm/mach-msm/devices.h
+++ b/arch/arm/mach-msm/devices.h
@@ -16,6 +16,8 @@
 #ifndef __ARCH_ARM_MACH_MSM_DEVICES_H
 #define __ARCH_ARM_MACH_MSM_DEVICES_H
 
+#include <linux/clkdev.h>
+
 #include "clock.h"
 
 extern struct platform_device msm_device_uart1;
@@ -44,13 +46,13 @@ extern struct platform_device msm_device_mddi0;
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
 
 #endif
diff --git a/arch/arm/mach-msm/include/mach/board.h b/arch/arm/mach-msm/include/mach/board.h
index 6abf4a6..2ce8f1f 100644
--- a/arch/arm/mach-msm/include/mach/board.h
+++ b/arch/arm/mach-msm/include/mach/board.h
@@ -31,7 +31,7 @@ struct msm_acpu_clock_platform_data
 	unsigned long wait_for_irq_khz;
 };
 
-struct clk;
+struct clk_lookup;
 
 extern struct sys_timer msm_timer;
 
@@ -41,7 +41,7 @@ void __init msm_add_devices(void);
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
index 0000000..f87a57b
--- /dev/null
+++ b/arch/arm/mach-msm/include/mach/clkdev.h
@@ -0,0 +1,19 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
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
+#ifndef __ASM_ARCH_MSM_CLKDEV_H
+#define __ASM_ARCH_MSM_CLKDEV_H
+
+struct clk;
+
+static inline int __clk_get(struct clk *clk) { return 1; }
+static inline void __clk_put(struct clk *clk) { }
+#endif
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


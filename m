Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab0I1OfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 10:35:05 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:45639 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756127Ab0I1Oed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 10:34:33 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <yuanyabin1978@sina.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 6/7] ARM: config RealViews PL011 PL022 for DMA v12
Date: Tue, 28 Sep 2010 16:34:00 +0200
Message-ID: <1285684441-21700-7-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1285684441-21700-6-git-send-email-linus.walleij@stericsson.com>
References: <1285684441-21700-1-git-send-email-linus.walleij@stericsson.com>
 <1285684441-21700-2-git-send-email-linus.walleij@stericsson.com>
 <1285684441-21700-3-git-send-email-linus.walleij@stericsson.com>
 <1285684441-21700-4-git-send-email-linus.walleij@stericsson.com>
 <1285684441-21700-5-git-send-email-linus.walleij@stericsson.com>
 <1285684441-21700-6-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the platform necessary to make the PL08x driver from the
async_tx tree probe successfully with the RealView boards (except
for the PB1176 which lacks a working DMAC) and thus makes the
memcpy channels available on all of them.

Further it implements the logic for muxing the two sets of device
(slave) DMA channels, so that devices can request their DMA
channels and have them muxed in on request.

Platform data for the PL022 and PL011 is supplied for the
PB11MPCore.

This was tested successfully on an PB11MPCore using DMA for the
PL022 SPI and PL011 UART simultaneously with the DMA engine test
client running memcpy on two of the channels. The slave transfers
bail out and switch to PIO mode on oversubscribed channels and
memcpy transfers queue if no physical channel is available.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-realview/core.c                  |  232 ++++++++++++++++++++++++
 arch/arm/mach-realview/core.h                  |    2 +
 arch/arm/mach-realview/include/mach/platform.h |    2 +
 arch/arm/mach-realview/realview_eb.c           |    3 +-
 arch/arm/mach-realview/realview_pb11mp.c       |   33 +++-
 arch/arm/mach-realview/realview_pba8.c         |    3 +-
 arch/arm/mach-realview/realview_pbx.c          |    3 +-
 7 files changed, 270 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-realview/core.c b/arch/arm/mach-realview/core.c
index 07c0815..2135fef 100644
--- a/arch/arm/mach-realview/core.c
+++ b/arch/arm/mach-realview/core.c
@@ -25,6 +25,8 @@
 #include <linux/interrupt.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/clcd.h>
+#include <linux/amba/pl08x.h>
+#include <linux/amba/serial.h>
 #include <linux/io.h>
 #include <linux/smsc911x.h>
 #include <linux/ata_platform.h>
@@ -46,6 +48,7 @@
 #include <asm/mach/map.h>
 
 #include <asm/hardware/gic.h>
+#include <asm/hardware/pl080.h>
 
 #include <mach/clkdev.h>
 #include <mach/platform.h>
@@ -619,6 +622,235 @@ struct clcd_board clcd_plat_data = {
 	.remove		= realview_clcd_remove,
 };
 
+
+/*
+ * DMA config
+ */
+
+/* State of the big DMA mux */
+static u32 current_mux = 0x00;
+static u32 mux_users = 0x00;
+static spinlock_t current_mux_lock = SPIN_LOCK_UNLOCKED;
+
+static int pl081_get_signal(struct pl08x_dma_chan *ch)
+{
+	struct pl08x_channel_data *cd = ch->cd;
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&current_mux_lock, flags);
+	/*
+	 * We're on the same mux so fine, go ahead!
+	 */
+	if (cd->muxval == current_mux) {
+		mux_users ++;
+		spin_unlock_irqrestore(&current_mux_lock, flags);
+		/* We still have to write it since it may be OFF by default */
+		val = readl(__io_address(REALVIEW_SYS_DMAPSR));
+		val &= 0xFFFFFFFCU;
+		val |= current_mux;
+		writel(val, __io_address(REALVIEW_SYS_DMAPSR));
+		return cd->min_signal;
+	}
+	/*
+	 * If we're not on the same mux and there are already
+	 * users on the other mux setting, tough luck, the client
+	 * can come back and retry or give up and fall back to
+	 * PIO mode.
+	 */
+	if (mux_users) {
+		spin_unlock_irqrestore(&current_mux_lock, flags);
+		return -EBUSY;
+	}
+
+	/* Switch mux setting */
+	current_mux = cd->muxval;
+
+	val = readl(__io_address(REALVIEW_SYS_DMAPSR));
+	val &= 0xFFFFFFFCU;
+	val |= cd->muxval;
+	writel(val, __io_address(REALVIEW_SYS_DMAPSR));
+
+	pr_info("%s: muxing in %s in bank %d writing value "
+		"%08x to register %08x\n",
+		__func__, ch->name, cd->muxval,
+		val, REALVIEW_SYS_DMAPSR);
+
+	spin_unlock_irqrestore(&current_mux_lock, flags);
+
+	return cd->min_signal;
+}
+
+static void pl081_put_signal(struct pl08x_dma_chan *ch)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&current_mux_lock, flags);
+	mux_users--;
+	spin_unlock_irqrestore(&current_mux_lock, flags);
+}
+
+#define PRIMECELL_DEFAULT_CCTL (PL080_BSIZE_8 << PL080_CONTROL_SB_SIZE_SHIFT | \
+				PL080_BSIZE_8 << PL080_CONTROL_DB_SIZE_SHIFT | \
+				PL080_WIDTH_32BIT << PL080_CONTROL_SWIDTH_SHIFT | \
+				PL080_WIDTH_32BIT << PL080_CONTROL_DWIDTH_SHIFT | \
+				PL080_CONTROL_PROT_SYS)
+
+/* Muxed channels as found in most RealViews */
+struct pl08x_channel_data realview_chan_data[] = {
+	/* Muxed on signal bank 0 */
+	[0] = {
+		.bus_id = "usb0",
+		.min_signal = 0,
+		.max_signal = 0,
+		.muxval = 0x00,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+	},
+	[1] = {
+		.bus_id = "usb1",
+		.min_signal = 1,
+		.max_signal = 1,
+		.muxval = 0x00,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+	},
+	[2] = {
+		.bus_id = "t1dmac0",
+		.min_signal = 2,
+		.max_signal = 2,
+		.muxval = 0x00,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+	},
+	[3] = {
+		.bus_id = "mci0",
+		.min_signal = 3,
+		.max_signal = 3,
+		.muxval = 0x00,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+	},
+	[4] = {
+		.bus_id = "aacitx",
+		.min_signal = 4,
+		.max_signal = 4,
+		.muxval = 0x00,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_MEM2PER << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[5] = {
+		.bus_id = "aacirx",
+		.min_signal = 5,
+		.max_signal = 5,
+		.muxval = 0x00,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_PER2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[6] = {
+		.bus_id = "scirx",
+		.min_signal = 6,
+		.max_signal = 6,
+		.muxval = 0x00,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_PER2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[7] = {
+		.bus_id = "scitx",
+		.min_signal = 7,
+		.max_signal = 7,
+		.muxval = 0x00,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_MEM2PER << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	/* Muxed on signal bank 1 */
+	[8] = {
+		.bus_id = "ssprx",
+		.min_signal = 0,
+		.max_signal = 0,
+		.muxval = 0x01,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_PER2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[9] = {
+		.bus_id = "ssptx",
+		.min_signal = 1,
+		.max_signal = 1,
+		.muxval = 0x01,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_MEM2PER << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[10] = {
+		.bus_id = "uart2rx",
+		.min_signal = 2,
+		.max_signal = 2,
+		.muxval = 0x01,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_PER2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[11] = {
+		.bus_id = "uart2tx",
+		.min_signal = 3,
+		.max_signal = 3,
+		.muxval = 0x01,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_MEM2PER << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[12] = {
+		.bus_id = "uart1rx",
+		.min_signal = 4,
+		.max_signal = 4,
+		.muxval = 0x01,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_PER2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[13] = {
+		.bus_id = "uart1tx",
+		.min_signal = 5,
+		.max_signal = 5,
+		.muxval = 0x01,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_MEM2PER << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[14] = {
+		.bus_id = "uart0rx",
+		.min_signal = 6,
+		.max_signal = 6,
+		.muxval = 0x01,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_PER2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[15] = {
+		.bus_id = "uart0tx",
+		.min_signal = 7,
+		.max_signal = 7,
+		.muxval = 0x01,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_MEM2PER << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+};
+
+struct pl08x_platform_data pl081_plat_data = {
+	.memcpy_channel = {
+		.bus_id = "memcpy",
+		/*
+		 * We pass in some optimal memcpy config, the
+		 * driver will augment it if need be. 256 byte
+		 * bursts and 32bit bus width.
+		 */
+		.cctl =
+		(PL080_BSIZE_256 << PL080_CONTROL_SB_SIZE_SHIFT |	\
+		 PL080_BSIZE_256 << PL080_CONTROL_DB_SIZE_SHIFT |	\
+		 PL080_WIDTH_32BIT << PL080_CONTROL_SWIDTH_SHIFT |	\
+		 PL080_WIDTH_32BIT << PL080_CONTROL_DWIDTH_SHIFT |	\
+		 PL080_CONTROL_PROT_BUFF |				\
+		 PL080_CONTROL_PROT_CACHE |				\
+		 PL080_CONTROL_PROT_SYS),
+		/* Flow control: DMAC controls this */
+		.ccfg = PL080_FLOW_MEM2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	.slave_channels = realview_chan_data,
+	.num_slave_channels = ARRAY_SIZE(realview_chan_data),
+	.get_signal = pl081_get_signal,
+	.put_signal = pl081_put_signal,
+};
+
 #ifdef CONFIG_LEDS
 #define VA_LEDS_BASE (__io_address(REALVIEW_SYS_BASE) + REALVIEW_SYS_LED_OFFSET)
 
diff --git a/arch/arm/mach-realview/core.h b/arch/arm/mach-realview/core.h
index 781bca6..af8427f 100644
--- a/arch/arm/mach-realview/core.h
+++ b/arch/arm/mach-realview/core.h
@@ -53,12 +53,14 @@ extern struct platform_device realview_i2c_device;
 extern struct mmci_platform_data realview_mmc0_plat_data;
 extern struct mmci_platform_data realview_mmc1_plat_data;
 extern struct clcd_board clcd_plat_data;
+extern struct pl08x_platform_data pl081_plat_data;
 extern void __iomem *gic_cpu_base_addr;
 extern void __iomem *timer0_va_base;
 extern void __iomem *timer1_va_base;
 extern void __iomem *timer2_va_base;
 extern void __iomem *timer3_va_base;
 
+extern void pl081_fixup(void);
 extern void realview_leds_event(led_event_t ledevt);
 extern void realview_timer_init(unsigned int timer_irq);
 extern int realview_flash_register(struct resource *res, u32 num);
diff --git a/arch/arm/mach-realview/include/mach/platform.h b/arch/arm/mach-realview/include/mach/platform.h
index 1b77a27..934c5c2 100644
--- a/arch/arm/mach-realview/include/mach/platform.h
+++ b/arch/arm/mach-realview/include/mach/platform.h
@@ -77,6 +77,7 @@
 #define REALVIEW_SYS_BOOTCS_OFFSET           0x58
 #define REALVIEW_SYS_24MHz_OFFSET            0x5C
 #define REALVIEW_SYS_MISC_OFFSET             0x60
+#define REALVIEW_SYS_DMAPSR_OFFSET           0x64
 #define REALVIEW_SYS_IOSEL_OFFSET            0x70
 #define REALVIEW_SYS_PROCID_OFFSET           0x84
 #define REALVIEW_SYS_TEST_OSC0_OFFSET        0xC0
@@ -111,6 +112,7 @@
 #define REALVIEW_SYS_BOOTCS                  (REALVIEW_SYS_BASE + REALVIEW_SYS_BOOTCS_OFFSET)
 #define REALVIEW_SYS_24MHz                   (REALVIEW_SYS_BASE + REALVIEW_SYS_24MHz_OFFSET)
 #define REALVIEW_SYS_MISC                    (REALVIEW_SYS_BASE + REALVIEW_SYS_MISC_OFFSET)
+#define REALVIEW_SYS_DMAPSR                  (REALVIEW_SYS_BASE + REALVIEW_SYS_DMAPSR_OFFSET)
 #define REALVIEW_SYS_IOSEL                   (REALVIEW_SYS_BASE + REALVIEW_SYS_IOSEL_OFFSET)
 #define REALVIEW_SYS_PROCID                  (REALVIEW_SYS_BASE + REALVIEW_SYS_PROCID_OFFSET)
 #define REALVIEW_SYS_TEST_OSC0               (REALVIEW_SYS_BASE + REALVIEW_SYS_TEST_OSC0_OFFSET)
diff --git a/arch/arm/mach-realview/realview_eb.c b/arch/arm/mach-realview/realview_eb.c
index 991c1f8..3117510 100644
--- a/arch/arm/mach-realview/realview_eb.c
+++ b/arch/arm/mach-realview/realview_eb.c
@@ -23,6 +23,7 @@
 #include <linux/platform_device.h>
 #include <linux/sysdev.h>
 #include <linux/amba/bus.h>
+#include <linux/amba/pl08x.h>
 #include <linux/amba/pl061.h>
 #include <linux/amba/mmci.h>
 #include <linux/amba/pl022.h>
@@ -209,7 +210,7 @@ AMBA_DEVICE(uart3, "fpga:uart3", EB_UART3, NULL);
 /* DevChip Primecells */
 AMBA_DEVICE(smc,   "dev:smc",   EB_SMC,   NULL);
 AMBA_DEVICE(clcd,  "dev:clcd",  EB_CLCD,  &clcd_plat_data);
-AMBA_DEVICE(dmac,  "dev:dmac",  DMAC,     NULL);
+AMBA_DEVICE(dmac,  "dev:dmac",  DMAC,     &pl081_plat_data);
 AMBA_DEVICE(sctl,  "dev:sctl",  SCTL,     NULL);
 AMBA_DEVICE(wdog,  "dev:wdog",  EB_WATCHDOG, NULL);
 AMBA_DEVICE(gpio0, "dev:gpio0", EB_GPIO0, &gpio0_plat_data);
diff --git a/arch/arm/mach-realview/realview_pb11mp.c b/arch/arm/mach-realview/realview_pb11mp.c
index d591bc0..ab36e83 100644
--- a/arch/arm/mach-realview/realview_pb11mp.c
+++ b/arch/arm/mach-realview/realview_pb11mp.c
@@ -23,9 +23,11 @@
 #include <linux/platform_device.h>
 #include <linux/sysdev.h>
 #include <linux/amba/bus.h>
+#include <linux/amba/pl08x.h>
 #include <linux/amba/pl061.h>
 #include <linux/amba/mmci.h>
 #include <linux/amba/pl022.h>
+#include <linux/amba/serial.h>
 #include <linux/io.h>
 
 #include <mach/hardware.h>
@@ -127,8 +129,29 @@ static struct pl061_platform_data gpio2_plat_data = {
 
 static struct pl022_ssp_controller ssp0_plat_data = {
 	.bus_id = 0,
-	.enable_dma = 0,
 	.num_chipselect = 1,
+	.enable_dma = 1,
+	.dma_filter = pl08x_filter_id,
+	.dma_rx_param = (void *) "ssprx",
+	.dma_tx_param = (void *) "ssptx",
+};
+
+static struct amba_pl011_data uart0_plat_data = {
+	.dma_filter = pl08x_filter_id,
+	.dma_rx_param = (void *) "uart0rx",
+	.dma_tx_param = (void *) "uart0tx",
+};
+
+static struct amba_pl011_data uart1_plat_data = {
+	.dma_filter = pl08x_filter_id,
+	.dma_rx_param = (void *) "uart1rx",
+	.dma_tx_param = (void *) "uart1tx",
+};
+
+static struct amba_pl011_data uart2_plat_data = {
+	.dma_filter = pl08x_filter_id,
+	.dma_rx_param = (void *) "uart2rx",
+	.dma_tx_param = (void *) "uart2tx",
 };
 
 /*
@@ -194,14 +217,14 @@ AMBA_DEVICE(gpio1,	"dev:gpio1",	GPIO1,		&gpio1_plat_data);
 AMBA_DEVICE(gpio2,	"dev:gpio2",	GPIO2,		&gpio2_plat_data);
 AMBA_DEVICE(rtc,	"dev:rtc",	PB11MP_RTC,	NULL);
 AMBA_DEVICE(sci0,	"dev:sci0",	SCI,		NULL);
-AMBA_DEVICE(uart0,	"dev:uart0",	PB11MP_UART0,	NULL);
-AMBA_DEVICE(uart1,	"dev:uart1",	PB11MP_UART1,	NULL);
-AMBA_DEVICE(uart2,	"dev:uart2",	PB11MP_UART2,	NULL);
+AMBA_DEVICE(uart0,	"dev:uart0",	PB11MP_UART0,	&uart0_plat_data);
+AMBA_DEVICE(uart1,	"dev:uart1",	PB11MP_UART1,	&uart1_plat_data);
+AMBA_DEVICE(uart2,	"dev:uart2",	PB11MP_UART2,	&uart2_plat_data);
 AMBA_DEVICE(ssp0,	"dev:ssp0",	PB11MP_SSP,	&ssp0_plat_data);
 
 /* Primecells on the NEC ISSP chip */
 AMBA_DEVICE(clcd,	"issp:clcd",	PB11MP_CLCD,	&clcd_plat_data);
-AMBA_DEVICE(dmac,	"issp:dmac",	DMAC,		NULL);
+AMBA_DEVICE(dmac,	"issp:dmac",	DMAC,		&pl081_plat_data);
 
 static struct amba_device *amba_devs[] __initdata = {
 	&dmac_device,
diff --git a/arch/arm/mach-realview/realview_pba8.c b/arch/arm/mach-realview/realview_pba8.c
index 6c37621..bafd457 100644
--- a/arch/arm/mach-realview/realview_pba8.c
+++ b/arch/arm/mach-realview/realview_pba8.c
@@ -23,6 +23,7 @@
 #include <linux/platform_device.h>
 #include <linux/sysdev.h>
 #include <linux/amba/bus.h>
+#include <linux/amba/pl08x.h>
 #include <linux/amba/pl061.h>
 #include <linux/amba/mmci.h>
 #include <linux/amba/pl022.h>
@@ -191,7 +192,7 @@ AMBA_DEVICE(ssp0,	"dev:ssp0",	PBA8_SSP,	&ssp0_plat_data);
 
 /* Primecells on the NEC ISSP chip */
 AMBA_DEVICE(clcd,	"issp:clcd",	PBA8_CLCD,	&clcd_plat_data);
-AMBA_DEVICE(dmac,	"issp:dmac",	DMAC,		NULL);
+AMBA_DEVICE(dmac,	"issp:dmac",	DMAC,		&pl081_plat_data);
 
 static struct amba_device *amba_devs[] __initdata = {
 	&dmac_device,
diff --git a/arch/arm/mach-realview/realview_pbx.c b/arch/arm/mach-realview/realview_pbx.c
index 9428eff..20c7eae 100644
--- a/arch/arm/mach-realview/realview_pbx.c
+++ b/arch/arm/mach-realview/realview_pbx.c
@@ -22,6 +22,7 @@
 #include <linux/platform_device.h>
 #include <linux/sysdev.h>
 #include <linux/amba/bus.h>
+#include <linux/amba/pl08x.h>
 #include <linux/amba/pl061.h>
 #include <linux/amba/mmci.h>
 #include <linux/amba/pl022.h>
@@ -213,7 +214,7 @@ AMBA_DEVICE(ssp0,	"dev:ssp0",	PBX_SSP,	&ssp0_plat_data);
 
 /* Primecells on the NEC ISSP chip */
 AMBA_DEVICE(clcd,	"issp:clcd",	PBX_CLCD,	&clcd_plat_data);
-AMBA_DEVICE(dmac,	"issp:dmac",	DMAC,		NULL);
+AMBA_DEVICE(dmac,	"issp:dmac",	DMAC,		&pl081_plat_data);
 
 static struct amba_device *amba_devs[] __initdata = {
 	&dmac_device,
-- 
1.6.3.3


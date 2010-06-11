Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890Ab0FKP2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 11:28:37 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:58287 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757889Ab0FKP22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 11:28:28 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
       <linux-arm-kernel@lists.infradead.org>, <yuanyabin1978@sina.com>
Cc: <linux-kernel@vger.kernel.org>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Peter Pearse <peter.pearse@arm.com>
Subject: [PATCH 12/13] ARM: RFC: PL08x platform data for the ARM RealView platforms
Date: Fri, 11 Jun 2010 17:28:03 +0200
Message-ID: <1276270083-1927-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds platform data for the RealViews, something here is
likely prohibiting the RealViews from doing proper DMA so I
need help to find out what.

Note that this will even activate DMA in the broken DMA controller
on the PB1176, so this will not be the final version. Sadly the
PB1176 is usually all I have available for testing.

Cc: Peter Pearse <peter.pearse@arm.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-realview/core.c                      |  375 +++++++++++++++++++-
 arch/arm/mach-realview/core.h                      |    2 +
 arch/arm/mach-realview/include/mach/board-pb1176.h |    1 +
 arch/arm/mach-realview/include/mach/platform.h     |    2 +
 arch/arm/mach-realview/realview_eb.c               |    2 +-
 arch/arm/mach-realview/realview_pb1176.c           |    7 +-
 arch/arm/mach-realview/realview_pb11mp.c           |   33 ++-
 arch/arm/mach-realview/realview_pba8.c             |    2 +-
 arch/arm/mach-realview/realview_pbx.c              |    2 +-
 9 files changed, 418 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-realview/core.c b/arch/arm/mach-realview/core.c
index 595be19..41ceb9e 100644
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
@@ -232,6 +235,19 @@ static unsigned int realview_mmc_status(struct device *dev)
 	struct amba_device *adev = container_of(dev, struct amba_device, dev);
 	u32 mask;
 
+	if (machine_is_realview_pb1176()) {
+		bool inserted = false;
+
+		/*
+		 * The PB1176 does not have the status register,
+		 * assume it is inserted at startup, then invert
+		 * for each call, assuming the call is done whenever
+		 * the card status changes.
+		 */
+		inserted = !inserted;
+		return inserted ? 0 : 1;
+	}
+
 	if (adev->res.start == REALVIEW_MMCI0_BASE)
 		mask = 1;
 	else
@@ -242,9 +258,14 @@ static unsigned int realview_mmc_status(struct device *dev)
 
 struct mmci_platform_data realview_mmc0_plat_data = {
 	.ocr_mask	= MMC_VDD_32_33|MMC_VDD_33_34,
-	.status		= realview_mmc_status,
+	.status		= realview_mmc_status, /* Not on the PB1176! */
 	.gpio_wp	= 17,
 	.gpio_cd	= 16,
+#ifdef CONFIG_AMBA_PL08X
+	.dma_filter = pl08x_filter_id,
+	.dma_rx_param = (void *) "mci0",
+	/* Don't specify a TX channel, this RX channel is bidirectional */
+#endif
 };
 
 struct mmci_platform_data realview_mmc1_plat_data = {
@@ -252,6 +273,11 @@ struct mmci_platform_data realview_mmc1_plat_data = {
 	.status		= realview_mmc_status,
 	.gpio_wp	= 19,
 	.gpio_cd	= 18,
+#ifdef CONFIG_AMBA_PL08X
+	.dma_filter = pl08x_filter_id,
+	.dma_rx_param = (void *) "mci1",
+	/* Don't specify a TX channel, this RX channel is bidirectional */
+#endif
 };
 
 /*
@@ -589,6 +615,352 @@ struct clcd_board clcd_plat_data = {
 	.remove		= realview_clcd_remove,
 };
 
+
+/*
+ * DMA config
+ */
+#ifdef CONFIG_AMBA_PL08X
+
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
+	printk(KERN_INFO "requesting DMA signal on channel %s\n", ch->name);
+
+	/* This one has statically assigned channels */
+	if (machine_is_realview_pb1176())
+		return cd->min_signal;
+
+	spin_lock_irqsave(&current_mux_lock, flags);
+	/*
+	 * We're on the same mux so fine, go ahead!
+	 */
+	if (cd->muxval == current_mux) {
+		mux_users ++;
+		spin_unlock_irqrestore(&current_mux_lock, flags);
+		/* We still have to write it since it's OFF  by default */
+		val = readl(__io_address(REALVIEW_SYS_DMAPSR));
+		val &= 0xFFFFFFC0U;
+		val |= current_mux;
+		val |= 0x80; /* That's how they do it on the Versatile */
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
+	val &= 0xFFFFFFC0U;
+	val |= cd->muxval;
+	val |= 0x80; /* That's how they do it on the Versatile */
+	writel(val, __io_address(REALVIEW_SYS_DMAPSR));
+
+	printk(KERN_INFO "%s: muxing in %s in bank %d writing value "
+	       "%08x to register %08x\n",
+	       __func__, ch->name, cd->muxval,
+	       val, REALVIEW_SYS_DMAPSR);
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
+	printk(KERN_INFO "release DMA signal on channel %s\n", ch->name);
+
+	/* This one has statically assigned channels */
+	if (machine_is_realview_pb1176())
+		return;
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
+/* The PB1176 has static channel assignments */
+struct pl08x_channel_data pb1176_chan_data[] = {
+	/* Muxed on signal bank 0 */
+	[0] = {
+		.bus_id = "aacirx",
+		.min_signal = 0,
+		.max_signal = 0,
+		.muxval = 0x00,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_PER2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[1] = {
+		.bus_id = "aacitx",
+		.min_signal = 1,
+		.max_signal = 1,
+		.muxval = 0x00,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_MEM2PER << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[2] = {
+		.bus_id = "mci0",
+		.min_signal = 2,
+		.max_signal = 2,
+		.muxval = 0x00,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+	},
+	[3] = {
+		.bus_id = "uart4rx",
+		.min_signal = 3,
+		.max_signal = 3,
+		.muxval = 0x00,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_PER2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[4] = {
+		.bus_id = "uart4tx",
+		.min_signal = 4,
+		.max_signal = 4,
+		.muxval = 0x00,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_MEM2PER << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[5] = {
+		.bus_id = "scirx",
+		.min_signal = 5,
+		.max_signal = 5,
+		.muxval = 0x00,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_PER2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[6] = {
+		.bus_id = "scitx",
+		.min_signal = 6,
+		.max_signal = 6,
+		.muxval = 0x00,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_MEM2PER << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[7] = {
+		.bus_id = "usbdc",
+		.min_signal = 7,
+		.max_signal = 7,
+		.muxval = 0x00,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+	},
+	[8] = {
+		.bus_id = "usbhc",
+		.min_signal = 8,
+		.max_signal = 8,
+		.muxval = 0x00,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+	},
+	[9] = {
+		.bus_id = "pismo",
+		.min_signal = 9,
+		.max_signal = 9,
+		.muxval = 0x00,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+	},
+};
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
+	.get_signal = pl081_get_signal,
+	.put_signal = pl081_put_signal,
+	.bus_bit_lli = 0,
+};
+
+void __init pl081_fixup(void)
+{
+	if (machine_is_realview_pb1176()) {
+		pl081_plat_data.slave_channels = pb1176_chan_data;
+		pl081_plat_data.num_slave_channels = ARRAY_SIZE(pb1176_chan_data);
+	} else {
+		pl081_plat_data.slave_channels = realview_chan_data;
+		pl081_plat_data.num_slave_channels = ARRAY_SIZE(realview_chan_data);
+	}
+}
+
+#else
+struct pl08x_platform_data pl081_plat_data = {
+};
+
+void __init pl081_fixup(void)
+{
+}
+#endif
+
+
 #ifdef CONFIG_LEDS
 #define VA_LEDS_BASE (__io_address(REALVIEW_SYS_BASE) + REALVIEW_SYS_LED_OFFSET)
 
@@ -685,4 +1057,5 @@ void realview_fixup(struct machine_desc *mdesc, struct tag *tags, char **from,
 	meminfo->bank[0].size = SZ_256M;
 	meminfo->nr_banks = 1;
 #endif
+	pl081_fixup();
 }
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
diff --git a/arch/arm/mach-realview/include/mach/board-pb1176.h b/arch/arm/mach-realview/include/mach/board-pb1176.h
index 2f5ccb2..73f37b9 100644
--- a/arch/arm/mach-realview/include/mach/board-pb1176.h
+++ b/arch/arm/mach-realview/include/mach/board-pb1176.h
@@ -26,6 +26,7 @@
 /*
  * Peripheral addresses
  */
+#define REALVIEW_PB1176_DMAC_BASE		0x10030000 /* DMAC */
 #define REALVIEW_PB1176_SCTL_BASE		0x10100000 /* System controller */
 #define REALVIEW_PB1176_SMC_BASE		0x10111000 /* SMC */
 #define REALVIEW_PB1176_DMC_BASE		0x10109000 /* DMC configuration */
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
index 422ccd7..87d43cb 100644
--- a/arch/arm/mach-realview/realview_eb.c
+++ b/arch/arm/mach-realview/realview_eb.c
@@ -201,7 +201,7 @@ AMBA_DEVICE(uart3, "fpga:uart3", EB_UART3, NULL);
 /* DevChip Primecells */
 AMBA_DEVICE(smc,   "dev:smc",   EB_SMC,   NULL);
 AMBA_DEVICE(clcd,  "dev:clcd",  EB_CLCD,  &clcd_plat_data);
-AMBA_DEVICE(dmac,  "dev:dmac",  DMAC,     NULL);
+AMBA_DEVICE(dmac,  "dev:dmac",  DMAC,     &pl081_plat_data);
 AMBA_DEVICE(sctl,  "dev:sctl",  SCTL,     NULL);
 AMBA_DEVICE(wdog,  "dev:wdog",  EB_WATCHDOG, NULL);
 AMBA_DEVICE(gpio0, "dev:gpio0", EB_GPIO0, &gpio0_plat_data);
diff --git a/arch/arm/mach-realview/realview_pb1176.c b/arch/arm/mach-realview/realview_pb1176.c
index 96568eb..d190f1e 100644
--- a/arch/arm/mach-realview/realview_pb1176.c
+++ b/arch/arm/mach-realview/realview_pb1176.c
@@ -143,7 +143,7 @@ static struct pl061_platform_data gpio2_plat_data = {
 #define MPMC_DMA	{ 0, 0 }
 #define PB1176_CLCD_IRQ	{ IRQ_DC1176_CLCD, NO_IRQ }
 #define PB1176_CLCD_DMA	{ 0, 0 }
-#define DMAC_IRQ	{ IRQ_PB1176_DMAC, NO_IRQ }
+#define PB1176_DMAC_IRQ	{ IRQ_PB1176_DMAC, NO_IRQ }
 #define DMAC_DMA	{ 0, 0 }
 #define SCTL_IRQ	{ NO_IRQ, NO_IRQ }
 #define SCTL_DMA	{ 0, 0 }
@@ -191,10 +191,10 @@ AMBA_DEVICE(ssp0,	"dev:ssp0",	PB1176_SSP,	NULL);
 
 /* Primecells on the NEC ISSP chip */
 AMBA_DEVICE(clcd,	"issp:clcd",	PB1176_CLCD,	&clcd_plat_data);
-//AMBA_DEVICE(dmac,	"issp:dmac",	PB1176_DMAC,	NULL);
+AMBA_DEVICE(dmac,	"issp:dmac",	PB1176_DMAC,	&pl081_plat_data);
 
 static struct amba_device *amba_devs[] __initdata = {
-//	&dmac_device,
+	&dmac_device,
 	&uart0_device,
 	&uart1_device,
 	&uart2_device,
@@ -320,6 +320,7 @@ static void realview_pb1176_fixup(struct machine_desc *mdesc,
 	meminfo->bank[0].start = 0;
 	meminfo->bank[0].size = SZ_128M;
 	meminfo->nr_banks = 1;
+	pl081_fixup();
 }
 
 static void __init realview_pb1176_init(void)
diff --git a/arch/arm/mach-realview/realview_pb11mp.c b/arch/arm/mach-realview/realview_pb11mp.c
index 7fbefbb..813026a 100644
--- a/arch/arm/mach-realview/realview_pb11mp.c
+++ b/arch/arm/mach-realview/realview_pb11mp.c
@@ -25,6 +25,8 @@
 #include <linux/amba/bus.h>
 #include <linux/amba/pl061.h>
 #include <linux/amba/mmci.h>
+#include <linux/amba/serial.h>
+#include <linux/amba/pl08x.h>
 #include <linux/io.h>
 
 #include <mach/hardware.h>
@@ -123,6 +125,30 @@ static struct pl061_platform_data gpio2_plat_data = {
 	.irq_base	= -1,
 };
 
+static struct amba_pl011_data uart0_plat_data = {
+#ifdef CONFIG_AMBA_PL08X
+	.dma_filter = pl08x_filter_id,
+	.dma_rx_param = (void *) "uart0rx",
+	.dma_tx_param = (void *) "uart0tx",
+#endif
+};
+
+static struct amba_pl011_data uart1_plat_data = {
+#ifdef CONFIG_AMBA_PL08X
+	.dma_filter = pl08x_filter_id,
+	.dma_rx_param = (void *) "uart1rx",
+	.dma_tx_param = (void *) "uart1tx",
+#endif
+};
+
+static struct amba_pl011_data uart2_plat_data = {
+#ifdef CONFIG_AMBA_PL08X
+	.dma_filter = pl08x_filter_id,
+	.dma_rx_param = (void *) "uart2rx",
+	.dma_tx_param = (void *) "uart2tx",
+#endif
+};
+
 /*
  * RealView PB11MPCore AMBA devices
  */
@@ -189,11 +215,16 @@ AMBA_DEVICE(sci0,	"dev:sci0",	SCI,		NULL);
 AMBA_DEVICE(uart0,	"dev:uart0",	PB11MP_UART0,	NULL);
 AMBA_DEVICE(uart1,	"dev:uart1",	PB11MP_UART1,	NULL);
 AMBA_DEVICE(uart2,	"dev:uart2",	PB11MP_UART2,	NULL);
+#if 0
+AMBA_DEVICE(uart0,	"dev:uart0",	PB11MP_UART0,	&uart0_plat_data);
+AMBA_DEVICE(uart1,	"dev:uart1",	PB11MP_UART1,	&uart1_plat_data);
+AMBA_DEVICE(uart2,	"dev:uart2",	PB11MP_UART2,	&uart2_plat_data);
+#endif
 AMBA_DEVICE(ssp0,	"dev:ssp0",	PB11MP_SSP,	NULL);
 
 /* Primecells on the NEC ISSP chip */
 AMBA_DEVICE(clcd,	"issp:clcd",	PB11MP_CLCD,	&clcd_plat_data);
-AMBA_DEVICE(dmac,	"issp:dmac",	DMAC,		NULL);
+AMBA_DEVICE(dmac,	"issp:dmac",	DMAC,		&pl081_plat_data);
 
 static struct amba_device *amba_devs[] __initdata = {
 	&dmac_device,
diff --git a/arch/arm/mach-realview/realview_pba8.c b/arch/arm/mach-realview/realview_pba8.c
index d3c113b..366969f 100644
--- a/arch/arm/mach-realview/realview_pba8.c
+++ b/arch/arm/mach-realview/realview_pba8.c
@@ -183,7 +183,7 @@ AMBA_DEVICE(ssp0,	"dev:ssp0",	PBA8_SSP,	NULL);
 
 /* Primecells on the NEC ISSP chip */
 AMBA_DEVICE(clcd,	"issp:clcd",	PBA8_CLCD,	&clcd_plat_data);
-AMBA_DEVICE(dmac,	"issp:dmac",	DMAC,		NULL);
+AMBA_DEVICE(dmac,	"issp:dmac",	DMAC,		&pl081_plat_data);
 
 static struct amba_device *amba_devs[] __initdata = {
 	&dmac_device,
diff --git a/arch/arm/mach-realview/realview_pbx.c b/arch/arm/mach-realview/realview_pbx.c
index a235ba3..ca16948 100644
--- a/arch/arm/mach-realview/realview_pbx.c
+++ b/arch/arm/mach-realview/realview_pbx.c
@@ -205,7 +205,7 @@ AMBA_DEVICE(ssp0,	"dev:ssp0",	PBX_SSP,	NULL);
 
 /* Primecells on the NEC ISSP chip */
 AMBA_DEVICE(clcd,	"issp:clcd",	PBX_CLCD,	&clcd_plat_data);
-AMBA_DEVICE(dmac,	"issp:dmac",	DMAC,		NULL);
+AMBA_DEVICE(dmac,	"issp:dmac",	DMAC,		&pl081_plat_data);
 
 static struct amba_device *amba_devs[] __initdata = {
 	&dmac_device,
-- 
1.6.3.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab0I1Oef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 10:34:35 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:52890 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756092Ab0I1Oeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 10:34:31 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <yuanyabin1978@sina.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 7/7] ARM: config Versatiles PL011 PL022 for DMA v12
Date: Tue, 28 Sep 2010 16:34:01 +0200
Message-ID: <1285684441-21700-8-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1285684441-21700-7-git-send-email-linus.walleij@stericsson.com>
References: <1285684441-21700-1-git-send-email-linus.walleij@stericsson.com>
 <1285684441-21700-2-git-send-email-linus.walleij@stericsson.com>
 <1285684441-21700-3-git-send-email-linus.walleij@stericsson.com>
 <1285684441-21700-4-git-send-email-linus.walleij@stericsson.com>
 <1285684441-21700-5-git-send-email-linus.walleij@stericsson.com>
 <1285684441-21700-6-git-send-email-linus.walleij@stericsson.com>
 <1285684441-21700-7-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the platform necessary to make the PL08x driver from the
async_tx tree probe successfully with the RealView boards (except
for the PB1176 which lacks a working DMAC) and thus makes the
memcpy channels available on all of them.

Further it implements the logic for muxing the FPGA off-chip
(slave) DMA channels, so that devices on the FPGA can request
their DMA channels and have them muxed in on request.

Platform data for the PL022 and PL011 is supplied.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-versatile/core.c                  |  506 ++++++++++++++++++++++-
 arch/arm/mach-versatile/include/mach/platform.h |    6 +
 arch/arm/mach-versatile/versatile_pb.c          |   17 +-
 3 files changed, 524 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index e38acb0..0890b22 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -25,6 +25,8 @@
 #include <linux/sysdev.h>
 #include <linux/interrupt.h>
 #include <linux/amba/bus.h>
+#include <linux/amba/pl08x.h>
+#include <linux/amba/serial.h>
 #include <linux/amba/clcd.h>
 #include <linux/amba/pl061.h>
 #include <linux/amba/mmci.h>
@@ -39,6 +41,7 @@
 #include <asm/hardware/arm_timer.h>
 #include <asm/hardware/icst.h>
 #include <asm/hardware/vic.h>
+#include <asm/hardware/pl080.h>
 #include <asm/mach-types.h>
 
 #include <asm/mach/arch.h>
@@ -717,6 +720,482 @@ static struct clcd_board clcd_plat_data = {
 	.remove		= versatile_clcd_remove,
 };
 
+/*
+ * DMA config
+ * The DMA channel routing is static on the PA926EJ-S
+ * and dynamic on the PB926EJ-S using SYS_DMAPSR0..SYS_DMAPSR2
+ */
+
+struct pb926ejs_dma_signal {
+	unsigned int id;
+	struct pl08x_dma_chan *user;
+	u32 ctrlreg;
+};
+
+/*
+ * The three first channels on ARM926EJ-S are muxed,
+ * but to make things simple we enable all channels
+ * to be muxed, however most of the channels will just
+ * me muxed on top of themselves.
+ */
+static struct pb926ejs_dma_signal pl080_muxtab[] = {
+	[0] = {
+		.id = 0,
+		.ctrlreg = VERSATILE_SYS_DMAPSR0,
+	},
+	[1] = {
+		.id = 1,
+		.ctrlreg = VERSATILE_SYS_DMAPSR1,
+	},
+	[2] = {
+		.id = 2,
+		.ctrlreg = VERSATILE_SYS_DMAPSR2,
+	},
+	[3] = {
+		.id = 3,
+	},
+	[4] = {
+		.id = 4,
+	},
+	[5] = {
+		.id = 5,
+	},
+	[6] = {
+		.id = 6,
+	},
+	[7] = {
+		.id = 7,
+	},
+	[8] = {
+		.id = 8,
+	},
+	[9] = {
+		.id = 9,
+	},
+	[10] = {
+		.id = 10,
+	},
+	[11] = {
+		.id = 11,
+	},
+	[12] = {
+		.id = 12,
+	},
+	[13] = {
+		.id = 13,
+	},
+	[14] = {
+		.id = 14,
+	},
+	[15] = {
+		.id = 15,
+	},
+};
+
+/* This is a lock for the above muxing array */
+static spinlock_t muxlock = SPIN_LOCK_UNLOCKED;
+
+static int pl080_get_signal(struct pl08x_dma_chan *ch)
+{
+	struct pl08x_channel_data *cd = ch->cd;
+
+	pr_debug("requesting DMA signal on channel %s\n", ch->name);
+
+	/*
+	 * The AB926EJ-S is simple - only static assignments
+	 * so the channel is already muxed in and ready to go.
+	 */
+	if (machine_is_versatile_ab())
+		return cd->min_signal;
+
+	/* The PB926EJ-S is hairier */
+	if (machine_is_versatile_pb()) {
+		unsigned long flags;
+		int i;
+
+		if (cd->min_signal > ARRAY_SIZE(pl080_muxtab) ||
+		    cd->max_signal > ARRAY_SIZE(pl080_muxtab) ||
+		    (cd->max_signal < cd->min_signal)) {
+			pr_err("%s: illegal muxing constraints for %s\n",
+			       __func__, ch->name);
+			return -EINVAL;
+		}
+		/* Try to find a signal to use */
+		spin_lock_irqsave(&muxlock, flags);
+		for (i = cd->min_signal; i <= cd->max_signal; i++) {
+			if (!pl080_muxtab[i].user) {
+				u32 val;
+
+				pl080_muxtab[i].user = ch;
+				/* If the channels need to be muxed in, mux them! */
+				if (pl080_muxtab[i].ctrlreg) {
+					val = readl(__io_address(pl080_muxtab[i].ctrlreg));
+					val &= 0xFFFFFF70U;
+					val |= 0x80; /* Turn on muxing */
+					val |= cd->muxval; /* Mux in the right peripheral */
+					writel(val, __io_address(pl080_muxtab[i].ctrlreg));
+					pr_debug("%s: muxing in %s at channel %d writing value "
+						 "%08x to register %08x\n",
+						 __func__, ch->name, i,
+						 val, pl080_muxtab[i].ctrlreg);
+				}
+				spin_unlock_irqrestore(&muxlock, flags);
+				return pl080_muxtab[i].id;
+			}
+		}
+		spin_unlock_irqrestore(&muxlock, flags);
+	}
+
+	return -EBUSY;
+}
+
+static void pl080_put_signal(struct pl08x_dma_chan *ch)
+{
+	struct pl08x_channel_data *cd = ch->cd;
+	unsigned long flags;
+	int i;
+
+	pr_debug("releasing DMA signal on channel %s\n", ch->name);
+	if (cd->min_signal > ARRAY_SIZE(pl080_muxtab) ||
+	    cd->max_signal > ARRAY_SIZE(pl080_muxtab) ||
+	    (cd->max_signal < cd->min_signal)) {
+		pr_err("%s: illegal muxing constraints for %s\n",
+		       __func__, ch->name);
+		return;
+	}
+	spin_lock_irqsave(&muxlock, flags);
+	for (i = cd->min_signal; i <= cd->max_signal; i++) {
+		if (pl080_muxtab[i].user == ch) {
+			pl080_muxtab[i].user = NULL;
+			if (pl080_muxtab[i].ctrlreg) {
+				u32 val;
+
+				val = readl(__io_address(pl080_muxtab[i].ctrlreg));
+				val &= 0xFFFFFF70U; /* Disable, select no channel */
+				writel(val, __io_address(pl080_muxtab[i].ctrlreg));
+				pr_debug("%s: muxing out %s at channel %d writing value "
+				       "%08x to register %08x\n",
+				       __func__, ch->name, i,
+				       val, pl080_muxtab[i].ctrlreg);
+			}
+			spin_unlock_irqrestore(&muxlock, flags);
+			return;
+		}
+	}
+	spin_unlock_irqrestore(&muxlock, flags);
+	pr_debug("%s: unable to release muxing on channel %s\n",
+	       __func__, ch->name);
+}
+
+struct pl08x_platform_data pl080_plat_data = {
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
+	.get_signal = pl080_get_signal,
+	.put_signal = pl080_put_signal,
+};
+
+#define PRIMECELL_DEFAULT_CCTL (PL080_BSIZE_8 << PL080_CONTROL_SB_SIZE_SHIFT | \
+			PL080_BSIZE_8 << PL080_CONTROL_DB_SIZE_SHIFT | \
+			PL080_WIDTH_32BIT << PL080_CONTROL_SWIDTH_SHIFT | \
+			PL080_WIDTH_32BIT << PL080_CONTROL_DWIDTH_SHIFT | \
+			PL080_CONTROL_PROT_SYS)
+
+static struct pl08x_channel_data ab926ejs_chan_data[] = {
+	[0] = {
+		.bus_id = "aacirx",
+		.min_signal = 0,
+		.max_signal = 0,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_PER2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[1] = {
+		.bus_id = "aacitx",
+		.min_signal = 1,
+		.max_signal = 1,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_MEM2PER << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[2] = {
+		.bus_id = "mci0",
+		.min_signal = 2,
+		.max_signal = 2,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+	},
+	[3] = {
+		.bus_id = "reserved",
+		.min_signal = 3,
+		.max_signal = 3,
+	},
+	[4] = {
+		.bus_id = "reserved",
+		.min_signal = 4,
+		.max_signal = 4,
+	},
+	[5] = {
+		.bus_id = "reserved",
+		.min_signal = 5,
+		.max_signal = 5,
+	},
+	[6] = {
+		.bus_id = "scirx",
+		.min_signal = 6,
+		.max_signal = 6,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_PER2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[7] = {
+		.bus_id = "scitx",
+		.min_signal = 7,
+		.max_signal = 7,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_MEM2PER << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[8] = {
+		.bus_id = "ssprx",
+		.min_signal = 8,
+		.max_signal = 8,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_PER2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[9] = {
+		.bus_id = "ssptx",
+		.min_signal = 9,
+		.max_signal = 9,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_MEM2PER << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[10] = {
+		.bus_id = "uart2rx",
+		.min_signal = 10,
+		.max_signal = 10,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_PER2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[11] = {
+		.bus_id = "uart2tx",
+		.min_signal = 11,
+		.max_signal = 11,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_MEM2PER << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[12] = {
+		.bus_id = "uart1rx",
+		.min_signal = 12,
+		.max_signal = 12,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_PER2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[13] = {
+		.bus_id = "uart1tx",
+		.min_signal = 13,
+		.max_signal = 13,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_MEM2PER << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[14] = {
+		.bus_id = "uart0rx",
+		.min_signal = 14,
+		.max_signal = 14,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_PER2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[15] = {
+		.bus_id = "uart0tx",
+		.min_signal = 15,
+		.max_signal = 15,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_MEM2PER << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+};
+
+/* For the PB926EJ-S we define some extra virtual channels */
+static struct pl08x_channel_data pb926ejs_chan_data[] = {
+	[0] = {
+		/* Muxed on channel 0-3 */
+		.bus_id = "aacitx",
+		.min_signal = 0,
+		.max_signal = 2,
+		.muxval = 0x00,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_MEM2PER << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[1] = {
+		/* Muxed on channel 0-3 */
+		.bus_id = "aacirx",
+		.min_signal = 0,
+		.max_signal = 2,
+		.muxval = 0x01,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_PER2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[2] = {
+		/* Muxed on channel 0-3 */
+		.bus_id = "usba",
+		.min_signal = 0,
+		.max_signal = 2,
+		.muxval = 0x02,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+	},
+	[3] = {
+		/* Muxed on channel 0-3 */
+		.bus_id = "usbb",
+		.min_signal = 0,
+		.max_signal = 2,
+		.muxval = 0x03,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+	},
+	[4] = {
+		/* Muxed on channel 0-3 */
+		.bus_id = "mci0",
+		.min_signal = 0,
+		.max_signal = 2,
+		.muxval = 0x04,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+	},
+	[5] = {
+		/* Muxed on channel 0-3 */
+		.bus_id = "mci1",
+		.min_signal = 0,
+		.max_signal = 2,
+		.muxval = 0x05,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+	},
+	[6] = {
+		/* Muxed on channel 0-3 */
+		.bus_id = "uart3tx",
+		.min_signal = 0,
+		.max_signal = 2,
+		.muxval = 0x06,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_MEM2PER << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[7] = {
+		/* Muxed on channel 0-3 */
+		.bus_id = "uart3rx",
+		.min_signal = 0,
+		.max_signal = 2,
+		.muxval = 0x07,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_PER2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[8] = {
+		/* Muxed on channel 0-3 */
+		.bus_id = "sciinta",
+		.min_signal = 0,
+		.max_signal = 2,
+		.muxval = 0x08,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+	},
+	[9] = {
+		/* Muxed on channel 0-3 */
+		.bus_id = "sciintb",
+		.min_signal = 0,
+		.max_signal = 2,
+		.muxval = 0x09,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+	},
+	[10] = {
+		.bus_id = "scirx",
+		.min_signal = 6,
+		.max_signal = 6,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_PER2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[11] = {
+		.bus_id = "scitx",
+		.min_signal = 7,
+		.max_signal = 7,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_MEM2PER << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[12] = {
+		.bus_id = "ssprx",
+		.min_signal = 8,
+		.max_signal = 8,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_PER2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[13] = {
+		.bus_id = "ssptx",
+		.min_signal = 9,
+		.max_signal = 9,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_MEM2PER << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[14] = {
+		.bus_id = "uart2rx",
+		.min_signal = 10,
+		.max_signal = 10,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_PER2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[15] = {
+		.bus_id = "uart2tx",
+		.min_signal = 11,
+		.max_signal = 11,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_MEM2PER << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[16] = {
+		.bus_id = "uart1rx",
+		.min_signal = 12,
+		.max_signal = 12,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_PER2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[17] = {
+		.bus_id = "uart1tx",
+		.min_signal = 13,
+		.max_signal = 13,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_MEM2PER << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[18] = {
+		.bus_id = "uart0rx",
+		.min_signal = 14,
+		.max_signal = 14,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_PER2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+	[19] = {
+		.bus_id = "uart0tx",
+		.min_signal = 15,
+		.max_signal = 15,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.ccfg = PL080_FLOW_MEM2PER << PL080_CONFIG_FLOW_CONTROL_SHIFT,
+	},
+};
+
+static void __init pl080_fixup(void)
+{
+	if (machine_is_versatile_ab()) {
+		pl080_plat_data.slave_channels = ab926ejs_chan_data;
+		pl080_plat_data.num_slave_channels =
+			ARRAY_SIZE(ab926ejs_chan_data);
+	}
+	if (machine_is_versatile_pb()) {
+		pl080_plat_data.slave_channels = pb926ejs_chan_data;
+		pl080_plat_data.num_slave_channels =
+			ARRAY_SIZE(pb926ejs_chan_data);
+	}
+}
+
 static struct pl061_platform_data gpio0_plat_data = {
 	.gpio_base	= 0,
 	.irq_base	= IRQ_GPIO0_START,
@@ -733,6 +1212,24 @@ static struct pl022_ssp_controller ssp0_plat_data = {
 	.num_chipselect = 1,
 };
 
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
+};
+
 #define AACI_IRQ	{ IRQ_AACI, NO_IRQ }
 #define AACI_DMA	{ 0x80, 0x81 }
 #define MMCI0_IRQ	{ IRQ_MMCI0A,IRQ_SIC_MMCI0B }
@@ -792,16 +1289,16 @@ AMBA_DEVICE(kmi1,  "fpga:07", KMI1,     NULL);
 AMBA_DEVICE(smc,   "dev:00",  SMC,      NULL);
 AMBA_DEVICE(mpmc,  "dev:10",  MPMC,     NULL);
 AMBA_DEVICE(clcd,  "dev:20",  CLCD,     &clcd_plat_data);
-AMBA_DEVICE(dmac,  "dev:30",  DMAC,     NULL);
+AMBA_DEVICE(dmac,  "dev:30",  DMAC,     &pl080_plat_data);
 AMBA_DEVICE(sctl,  "dev:e0",  SCTL,     NULL);
 AMBA_DEVICE(wdog,  "dev:e1",  WATCHDOG, NULL);
 AMBA_DEVICE(gpio0, "dev:e4",  GPIO0,    &gpio0_plat_data);
 AMBA_DEVICE(gpio1, "dev:e5",  GPIO1,    &gpio1_plat_data);
 AMBA_DEVICE(rtc,   "dev:e8",  RTC,      NULL);
 AMBA_DEVICE(sci0,  "dev:f0",  SCI,      NULL);
-AMBA_DEVICE(uart0, "dev:f1",  UART0,    NULL);
-AMBA_DEVICE(uart1, "dev:f2",  UART1,    NULL);
-AMBA_DEVICE(uart2, "dev:f3",  UART2,    NULL);
+AMBA_DEVICE(uart0, "dev:f1",  UART0,    &uart0_plat_data);
+AMBA_DEVICE(uart1, "dev:f2",  UART1,    &uart1_plat_data);
+AMBA_DEVICE(uart2, "dev:f3",  UART2,    &uart2_plat_data);
 AMBA_DEVICE(ssp0,  "dev:f4",  SSP,      &ssp0_plat_data);
 
 static struct amba_device *amba_devs[] __initdata = {
@@ -874,6 +1371,7 @@ void __init versatile_init(void)
 	platform_device_register(&versatile_i2c_device);
 	platform_device_register(&smc91x_device);
 	platform_device_register(&char_lcd_device);
+	pl080_fixup();
 
 	for (i = 0; i < ARRAY_SIZE(amba_devs); i++) {
 		struct amba_device *d = amba_devs[i];
diff --git a/arch/arm/mach-versatile/include/mach/platform.h b/arch/arm/mach-versatile/include/mach/platform.h
index ec08740..fa0907c 100644
--- a/arch/arm/mach-versatile/include/mach/platform.h
+++ b/arch/arm/mach-versatile/include/mach/platform.h
@@ -86,6 +86,9 @@
 #define VERSATILE_SYS_BOOTCS_OFFSET           0x58
 #define VERSATILE_SYS_24MHz_OFFSET            0x5C
 #define VERSATILE_SYS_MISC_OFFSET             0x60
+#define VERSATILE_SYS_DMAPSR0_OFFSET          0x64 /* Only on PB926EJ-S */
+#define VERSATILE_SYS_DMAPSR1_OFFSET          0x68 /* Only on PB926EJ-S */
+#define VERSATILE_SYS_DMAPSR2_OFFSET          0x6C /* Only on PB926EJ-S */
 #define VERSATILE_SYS_TEST_OSC0_OFFSET        0x80
 #define VERSATILE_SYS_TEST_OSC1_OFFSET        0x84
 #define VERSATILE_SYS_TEST_OSC2_OFFSET        0x88
@@ -124,6 +127,9 @@
 #define VERSATILE_SYS_BOOTCS                  (VERSATILE_SYS_BASE + VERSATILE_SYS_BOOTCS_OFFSET)
 #define VERSATILE_SYS_24MHz                   (VERSATILE_SYS_BASE + VERSATILE_SYS_24MHz_OFFSET)
 #define VERSATILE_SYS_MISC                    (VERSATILE_SYS_BASE + VERSATILE_SYS_MISC_OFFSET)
+#define VERSATILE_SYS_DMAPSR0                 (VERSATILE_SYS_BASE + VERSATILE_SYS_DMAPSR0_OFFSET) /* Only on PB926EJ-S */
+#define VERSATILE_SYS_DMAPSR1                 (VERSATILE_SYS_BASE + VERSATILE_SYS_DMAPSR1_OFFSET) /* Only on PB926EJ-S */
+#define VERSATILE_SYS_DMAPSR2                 (VERSATILE_SYS_BASE + VERSATILE_SYS_DMAPSR2_OFFSET) /* Only on PB926EJ-S */
 #define VERSATILE_SYS_TEST_OSC0               (VERSATILE_SYS_BASE + VERSATILE_SYS_TEST_OSC0_OFFSET)
 #define VERSATILE_SYS_TEST_OSC1               (VERSATILE_SYS_BASE + VERSATILE_SYS_TEST_OSC1_OFFSET)
 #define VERSATILE_SYS_TEST_OSC2               (VERSATILE_SYS_BASE + VERSATILE_SYS_TEST_OSC2_OFFSET)
diff --git a/arch/arm/mach-versatile/versatile_pb.c b/arch/arm/mach-versatile/versatile_pb.c
index 239cd30..ecb6bf6 100644
--- a/arch/arm/mach-versatile/versatile_pb.c
+++ b/arch/arm/mach-versatile/versatile_pb.c
@@ -25,6 +25,8 @@
 #include <linux/amba/bus.h>
 #include <linux/amba/pl061.h>
 #include <linux/amba/mmci.h>
+#include <linux/amba/serial.h>
+#include <linux/amba/pl08x.h>
 #include <linux/io.h>
 
 #include <mach/hardware.h>
@@ -46,6 +48,11 @@ static struct mmci_platform_data mmc1_plat_data = {
 	.status		= mmc_status,
 	.gpio_wp	= -1,
 	.gpio_cd	= -1,
+#ifdef CONFIG_AMBA_PL08X
+	.dma_filter = pl08x_filter_id,
+	.dma_rx_param = (void *) "mci1",
+	/* Don't specify a TX channel, this RX channel is bidirectional */
+#endif
 };
 
 static struct pl061_platform_data gpio2_plat_data = {
@@ -58,6 +65,14 @@ static struct pl061_platform_data gpio3_plat_data = {
 	.irq_base	= IRQ_GPIO3_START,
 };
 
+static struct amba_pl011_data uart3_plat_data = {
+#ifdef CONFIG_AMBA_PL08X
+	.dma_filter = pl08x_filter_id,
+	.dma_rx_param = (void *) "uart3rx",
+	.dma_tx_param = (void *) "uart3tx",
+#endif
+};
+
 #define UART3_IRQ	{ IRQ_SIC_UART3, NO_IRQ }
 #define UART3_DMA	{ 0x86, 0x87 }
 #define SCI1_IRQ	{ IRQ_SIC_SCI3, NO_IRQ }
@@ -78,7 +93,7 @@ static struct pl061_platform_data gpio3_plat_data = {
  */
 
 /* FPGA Primecells */
-AMBA_DEVICE(uart3, "fpga:09", UART3,    NULL);
+AMBA_DEVICE(uart3, "fpga:09", UART3,    &uart3_plat_data);
 AMBA_DEVICE(sci1,  "fpga:0a", SCI1,     NULL);
 AMBA_DEVICE(mmc1,  "fpga:0b", MMCI1,    &mmc1_plat_data);
 
-- 
1.6.3.3


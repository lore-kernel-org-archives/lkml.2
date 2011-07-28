Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab1G1W2C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 18:28:02 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:50324 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab1G1W17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 18:27:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAJe_ZheB0uKn=Rk-i2y1rn5ZHJUJJy7D_3Pb6d4ggjNDhh+6VA@mail.gmail.com>
References: <CAJe_ZhfYvd6mdUMtzdAKKk4o1ythCBm7rut7ZCWRTxiWLP__Tg@mail.gmail.com>
	<CABE8wwv2XQ_aJ8O2TUAz1LgJorBwDbgyQQv7jeAn06Q2AcqH+Q@mail.gmail.com>
	<CAJe_ZhcNM7m-eWA0nDUrOrHxeAhNS00gewf=txmvOFL_uOPhrw@mail.gmail.com>
	<1311740499.1536.56.camel@vkoul-udesk3>
	<CAJe_ZhfaPfobs5P+q+t-kRSK4fAvm-v_brYgqmco8fwOOBeT8A@mail.gmail.com>
	<1311757347.1536.103.camel@vkoul-udesk3>
	<20110727095909.GB16623@intel.com>
	<CAJe_ZhdkPpVSyCyiUsFhOUUms8=JSQOiC33ztFzriW8jQHaa_w@mail.gmail.com>
	<CABE8wwuAFMYHH67sjEuy7whiZD+QBmU6bvzUUzEqJQFaYpkgdQ@mail.gmail.com>
	<CAJe_Zhfm5k9gNPaTfpZdQ__cp9fKLZoiSvG0GPciVFbkkU=QCw@mail.gmail.com>
	<20110727202859.GA5028@flint.arm.linux.org.uk>
	<CAJe_ZheB0uKn=Rk-i2y1rn5ZHJUJJy7D_3Pb6d4ggjNDhh+6VA@mail.gmail.com>
Date: Fri, 29 Jul 2011 00:27:58 +0200
Message-ID: <CACRpkdbauudu_GXfsaB23sSepf=_rzt577Hb7pA9rRRrEFYj-w@mail.gmail.com>
Subject: Re: [PATCHv2] DMAEngine: Let dmac drivers to set chan_id
From: Linus Walleij <linus.walleij@linaro.org>
To: Jaswinder Singh <jaswinder.singh@linaro.org>
Cc: Russell King <rmk@arm.linux.org.uk>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, per.friden@stericsson.com,
        wei.zhang@freescale.com, ebony.zhu@freescale.com, iws@ovro.caltech.edu,
        s.hauer@pengutronix.de, maciej.sosnowski@intel.com, saeed@marvell.com,
        shawn.guo@freescale.com, yur@emcraft.com, agust@denx.de,
        iwamatsu.nobuhiro@renesas.com, per.forlin@stericsson.com,
        jonas.aberg@stericsson.com, anemo@mba.ocn.ne.jp
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 12:44 PM, Jaswinder Singh
<jaswinder.singh@linaro.org> wrote:

> {
> So far, I haven't assumed the capability of a DMAC to switch, say,
> the RequestSignal_7 from MMC to UART at _runtime_
> If you think such dmacs and platforms exist, please let me know.
> I will update the proposal.
> }

Such DMACs exist, in the ARM Versatile and RealView boards...
Check drivers/dma/amba-pl08x.c, notice callback functions named
int (*get_signal)(struct pl08x_dma_chan *);
void (*put_signal)(struct pl08x_dma_chan *);
from <linux/amba/pl08x.h>

These implement optional runtime muxing of the request signals,
and it is through these two callbacks because there is a mux
which is external to the pl08x itself that is used, and the muxing
is machine-specific and implemented in the platform. I have been
working on patches using it like the below (still being worked on).

The muxing is not guaranteed to always work - i.e. you may
request a DMA transfer and it may fail because there is no
free channel to mux in. And then the driver has to fall back to
PIO.

The reason the system looks like this is due to constructing it
with a mixture of silicon and FPGAs on different bus bridges
with a limited amount of pins routed (I think).

This is the platform-specific runtime muxing for mach-realview:

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
+#define PRIMECELL_DEFAULT_CCTL (PL080_BSIZE_8 <<
PL080_CONTROL_SB_SIZE_SHIFT | \
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
+		.periph_buses = PL08X_AHB1 | PL08X_AHB2,
+	},
+	[1] = {
+		.bus_id = "usb1",
+		.min_signal = 1,
+		.max_signal = 1,
+		.muxval = 0x00,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.periph_buses = PL08X_AHB1 | PL08X_AHB2,
+	},
+	[2] = {
+		.bus_id = "t1dmac0",
+		.min_signal = 2,
+		.max_signal = 2,
+		.muxval = 0x00,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.periph_buses = PL08X_AHB1 | PL08X_AHB2,
+	},
+	[3] = {
+		.bus_id = "mci0",
+		.min_signal = 3,
+		.max_signal = 3,
+		.muxval = 0x00,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.periph_buses = PL08X_AHB1 | PL08X_AHB2,
+	},
+	[4] = {
+		.bus_id = "aacitx",
+		.min_signal = 4,
+		.max_signal = 4,
+		.muxval = 0x00,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.periph_buses = PL08X_AHB1 | PL08X_AHB2,
+	},
+	[5] = {
+		.bus_id = "aacirx",
+		.min_signal = 5,
+		.max_signal = 5,
+		.muxval = 0x00,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.periph_buses = PL08X_AHB1 | PL08X_AHB2,
+	},
+	[6] = {
+		.bus_id = "scirx",
+		.min_signal = 6,
+		.max_signal = 6,
+		.muxval = 0x00,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.periph_buses = PL08X_AHB1 | PL08X_AHB2,
+	},
+	[7] = {
+		.bus_id = "scitx",
+		.min_signal = 7,
+		.max_signal = 7,
+		.muxval = 0x00,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.periph_buses = PL08X_AHB1 | PL08X_AHB2,
+	},
+	/* Muxed on signal bank 1 */
+	[8] = {
+		.bus_id = "ssprx",
+		.min_signal = 0,
+		.max_signal = 0,
+		.muxval = 0x01,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.periph_buses = PL08X_AHB1 | PL08X_AHB2,
+	},
+	[9] = {
+		.bus_id = "ssptx",
+		.min_signal = 1,
+		.max_signal = 1,
+		.muxval = 0x01,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.periph_buses = PL08X_AHB1 | PL08X_AHB2,
+	},
+	[10] = {
+		.bus_id = "uart2rx",
+		.min_signal = 2,
+		.max_signal = 2,
+		.muxval = 0x01,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.periph_buses = PL08X_AHB1 | PL08X_AHB2,
+	},
+	[11] = {
+		.bus_id = "uart2tx",
+		.min_signal = 3,
+		.max_signal = 3,
+		.muxval = 0x01,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.periph_buses = PL08X_AHB1 | PL08X_AHB2,
+	},
+	[12] = {
+		.bus_id = "uart1rx",
+		.min_signal = 4,
+		.max_signal = 4,
+		.muxval = 0x01,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.periph_buses = PL08X_AHB1 | PL08X_AHB2,
+	},
+	[13] = {
+		.bus_id = "uart1tx",
+		.min_signal = 5,
+		.max_signal = 5,
+		.muxval = 0x01,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.periph_buses = PL08X_AHB1 | PL08X_AHB2,
+	},
+	[14] = {
+		.bus_id = "uart0rx",
+		.min_signal = 6,
+		.max_signal = 6,
+		.muxval = 0x01,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.periph_buses = PL08X_AHB1 | PL08X_AHB2,
+	},
+	[15] = {
+		.bus_id = "uart0tx",
+		.min_signal = 7,
+		.max_signal = 7,
+		.muxval = 0x01,
+		.cctl = PRIMECELL_DEFAULT_CCTL,
+		.periph_buses = PL08X_AHB1 | PL08X_AHB2,
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
+		.periph_buses = PL08X_AHB1 | PL08X_AHB2,
+	},
+	.slave_channels = realview_chan_data,
+	.num_slave_channels = ARRAY_SIZE(realview_chan_data),
+	.get_signal = pl081_get_signal,
+	.put_signal = pl081_put_signal,
+};


This is the platform-specific runtime muxing for mach-versatile:


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
+#define PRIMECELL_DEFAULT_CCTL (PL080_BSIZE_8 <<
PL080_CONTROL_SB_SIZE_SHIFT | \
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


Thanks,
Linus Walleij

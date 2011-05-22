Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab1EVRFg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 13:05:36 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60243 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab1EVRF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 13:05:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=v9i0cVg4qMpPLkQ6sIEaUmtvUxrJf7Pjnzm7cDp+zXc0DCcbUdNF7Zz0TFHM/31sn3
         6e/R/7Xs2t/5pJPyHSqsfEMgiLwvYX7wGMbfQQ9VE4fW988toMC8WZdoGPPA4iu4LII7
         w+2CLXgti7etm2O4pUEg/f4hmKVbMrzTe/tSs=
From: Mika Westerberg <mika.westerberg@iki.fi>
To: linux-arm-kernel@lists.infradead.org
Cc: hsweeten@visionengravers.com, ryan@bluewatersys.com,
        linux-kernel@vger.kernel.org, Mika Westerberg <mika.westerberg@iki.fi>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 1/5] dmaengine: add ep93xx DMA support
Date: Sun, 22 May 2011 20:03:04 +0300
Message-Id: <e6777eb9f7228ee1dadec1f0c9f16c3afc44c307.1306082097.git.mika.westerberg@iki.fi>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <cover.1306082097.git.mika.westerberg@iki.fi>
References: <cover.1306082097.git.mika.westerberg@iki.fi>
In-Reply-To: <cover.1306082097.git.mika.westerberg@iki.fi>
References: <cover.1306082097.git.mika.westerberg@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ep93xx DMA controller has 10 independent memory to peripheral (M2P)
channels, and 2 dedicated memory to memory (M2M) channels. M2M channels can
also be used by SPI and IDE to perform DMA transfers to/from their memory
mapped FIFOs.

This driver supports both M2P and M2M channels with DMA_SLAVE, DMA_CYCLIC and
DMA_MEMCPY (M2M only) capabilities.

Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
---
 arch/arm/mach-ep93xx/include/mach/dma.h |   87 ++
 drivers/dma/Kconfig                     |    7 +
 drivers/dma/Makefile                    |    1 +
 drivers/dma/ep93xx_dma.c                | 1356 +++++++++++++++++++++++++++++++
 4 files changed, 1451 insertions(+), 0 deletions(-)
 create mode 100644 drivers/dma/ep93xx_dma.c

diff --git a/arch/arm/mach-ep93xx/include/mach/dma.h b/arch/arm/mach-ep93xx/include/mach/dma.h
index 5e31b2b..6e7049a 100644
--- a/arch/arm/mach-ep93xx/include/mach/dma.h
+++ b/arch/arm/mach-ep93xx/include/mach/dma.h
@@ -15,6 +15,8 @@
 
 #include <linux/list.h>
 #include <linux/types.h>
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
 
 /**
  * struct ep93xx_dma_buffer - Information about a buffer to be transferred
@@ -146,4 +148,89 @@ void ep93xx_dma_m2p_submit_recursive(struct ep93xx_dma_m2p_client *m2p,
  */
 void ep93xx_dma_m2p_flush(struct ep93xx_dma_m2p_client *m2p);
 
+/*
+ * M2P channels.
+ *
+ * Note that these values are also directly used for setting the PPALLOC
+ * register.
+ */
+#define EP93XX_DMA_I2S1		0
+#define EP93XX_DMA_I2S2		1
+#define EP93XX_DMA_AAC1		2
+#define EP93XX_DMA_AAC2		3
+#define EP93XX_DMA_AAC3		4
+#define EP93XX_DMA_I2S3		5
+#define EP93XX_DMA_UART1	6
+#define EP93XX_DMA_UART2	7
+#define EP93XX_DMA_UART3	8
+#define EP93XX_DMA_IRDA		9
+/* M2M channels */
+#define EP93XX_DMA_SSP		10
+#define EP93XX_DMA_IDE		11
+
+/**
+ * struct ep93xx_dma_data - configuration data for the EP93xx dmaengine
+ * @port: peripheral which is requesting the channel
+ * @direction: TX/RX channel
+ * @name: optional name for the channel, this is displayed in /proc/interrupts
+ *
+ * This information is passed as private channel parameter in a filter
+ * function. Note that this is only needed for slave/cyclic channels.  For
+ * memcpy channels %NULL data should be passed.
+ */
+struct ep93xx_dma_data {
+	int				port;
+	enum dma_data_direction		direction;
+	const char			*name;
+};
+
+/**
+ * struct ep93xx_dma_chan_data - platform specific data for a DMA channel
+ * @name: name of the channel, used for getting the right clock for the channel
+ * @base: mapped registers
+ * @irq: interrupt number used by this channel
+ */
+struct ep93xx_dma_chan_data {
+	const char			*name;
+	void __iomem			*base;
+	int				irq;
+};
+
+/**
+ * struct ep93xx_dma_platform_data - platform data for the dmaengine driver
+ * @channels: array of channels which are passed to the driver
+ * @num_channels: number of channels in the array
+ *
+ * This structure is passed to the DMA engine driver via platform data. For
+ * M2P channels, contract is that even channels are for TX and odd for RX.
+ * There is no requirement for the M2M channels.
+ */
+struct ep93xx_dma_platform_data {
+	struct ep93xx_dma_chan_data	*channels;
+	size_t				num_channels;
+};
+
+static inline bool ep93xx_dma_chan_is_m2p(struct dma_chan *chan)
+{
+	return !strcmp(dev_name(chan->device->dev), "ep93xx-dma-m2p");
+}
+
+/**
+ * ep93xx_dma_chan_direction - returns direction the channel can be used
+ * @chan: channel
+ *
+ * This function can be used in filter functions to find out whether the
+ * channel supports given DMA direction. Only M2P channels have such
+ * limitation, for M2M channels the direction is configurable.
+ */
+static inline enum dma_data_direction
+ep93xx_dma_chan_direction(struct dma_chan *chan)
+{
+	if (!ep93xx_dma_chan_is_m2p(chan))
+		return DMA_NONE;
+
+	/* even channels are for TX, odd for RX */
+	return (chan->chan_id % 2 == 0) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+}
+
 #endif /* __ASM_ARCH_DMA_H */
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index a572600..614ce7b 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -235,6 +235,13 @@ config MXS_DMA
 	  Support the MXS DMA engine. This engine including APBH-DMA
 	  and APBX-DMA is integrated into Freescale i.MX23/28 chips.
 
+config EP93XX_DMA
+	bool "Cirrus Logic EP93xx DMA support"
+	depends on ARCH_EP93XX
+	select DMA_ENGINE
+	help
+	  Enable support for the Cirrus Logic EP93xx M2P/M2M DMA controller.
+
 config DMA_ENGINE
 	bool
 
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 836095a..30cf3b1 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -25,3 +25,4 @@ obj-$(CONFIG_STE_DMA40) += ste_dma40.o ste_dma40_ll.o
 obj-$(CONFIG_PL330_DMA) += pl330.o
 obj-$(CONFIG_PCH_DMA) += pch_dma.o
 obj-$(CONFIG_AMBA_PL08X) += amba-pl08x.o
+obj-$(CONFIG_EP93XX_DMA) += ep93xx_dma.o
diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
new file mode 100644
index 0000000..7898e8c
--- /dev/null
+++ b/drivers/dma/ep93xx_dma.c
@@ -0,0 +1,1356 @@
+/*
+ * Driver for the Cirrus Logic EP93xx DMA Controller
+ *
+ * Copyright (C) 2011 Mika Westerberg
+ *
+ * DMA M2P implementation is based on the original
+ * arch/arm/mach-ep93xx/dma-m2p.c which has following copyrights:
+ *
+ *   Copyright (C) 2006 Lennert Buytenhek <buytenh@wantstofly.org>
+ *   Copyright (C) 2006 Applied Data Systems
+ *   Copyright (C) 2009 Ryan Mallon <ryan@bluewatersys.com>
+ *
+ * This driver is based on dw_dmac and amba-pl08x drivers.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/clk.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/dmaengine.h>
+#include <linux/moduleparam.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#include <mach/dma.h>
+
+/* M2P registers */
+#define M2P_CONTROL			0x0000
+#define M2P_CONTROL_STALLINT		BIT(0)
+#define M2P_CONTROL_NFBINT		BIT(1)
+#define M2P_CONTROL_CH_ERROR_INT	BIT(3)
+#define M2P_CONTROL_ENABLE		BIT(4)
+#define M2P_CONTROL_ICE			BIT(6)
+
+#define M2P_INTERRUPT			0x0004
+#define M2P_INTERRUPT_STALL		BIT(0)
+#define M2P_INTERRUPT_NFB		BIT(1)
+#define M2P_INTERRUPT_ERROR		BIT(3)
+
+#define M2P_PPALLOC			0x0008
+#define M2P_STATUS			0x000c
+
+#define M2P_MAXCNT0			0x0020
+#define M2P_BASE0			0x0024
+#define M2P_MAXCNT1			0x0030
+#define M2P_BASE1			0x0034
+
+#define M2P_STATE_IDLE			0
+#define M2P_STATE_STALL			1
+#define M2P_STATE_ON			2
+#define M2P_STATE_NEXT			3
+
+/* M2M registers */
+#define M2M_CONTROL			0x0000
+#define M2M_CONTROL_DONEINT		BIT(2)
+#define M2M_CONTROL_ENABLE		BIT(3)
+#define M2M_CONTROL_START		BIT(4)
+#define M2M_CONTROL_DAH			BIT(11)
+#define M2M_CONTROL_SAH			BIT(12)
+#define M2M_CONTROL_PW_SHIFT		9
+#define M2M_CONTROL_PW_8		(0 << M2M_CONTROL_PW_SHIFT)
+#define M2M_CONTROL_PW_16		(1 << M2M_CONTROL_PW_SHIFT)
+#define M2M_CONTROL_PW_32		(2 << M2M_CONTROL_PW_SHIFT)
+#define M2M_CONTROL_PW_MASK		(3 << M2M_CONTROL_PW_SHIFT)
+#define M2M_CONTROL_TM_SHIFT		13
+#define M2M_CONTROL_TM_TX		(1 << M2M_CONTROL_TM_SHIFT)
+#define M2M_CONTROL_TM_RX		(2 << M2M_CONTROL_TM_SHIFT)
+#define M2M_CONTROL_RSS_SHIFT		22
+#define M2M_CONTROL_RSS_SSPRX		(1 << M2M_CONTROL_RSS_SHIFT)
+#define M2M_CONTROL_RSS_SSPTX		(2 << M2M_CONTROL_RSS_SHIFT)
+#define M2M_CONTROL_RSS_IDE		(3 << M2M_CONTROL_RSS_SHIFT)
+#define M2M_CONTROL_NO_HDSK		BIT(24)
+#define M2M_CONTROL_PWSC_SHIFT		25
+
+#define M2M_INTERRUPT			0x0004
+#define M2M_INTERRUPT_DONEINT		BIT(1)
+
+#define M2M_BCR0			0x0010
+#define M2M_BCR1			0x0014
+#define M2M_SAR_BASE0			0x0018
+#define M2M_SAR_BASE1			0x001c
+#define M2M_DAR_BASE0			0x002c
+#define M2M_DAR_BASE1			0x0030
+
+#define DMA_MAX_CHAN_BYTES		0xffff
+#define DMA_MAX_CHAN_DESCRIPTORS	32
+
+struct ep93xx_dma_engine;
+
+/**
+ * struct ep93xx_dma_desc - EP93xx specific transaction descriptor
+ * @src_addr: source address of the transaction
+ * @dst_addr: destination address of the transaction
+ * @size: size of the transaction (in bytes)
+ * @complete: this descriptor is completed
+ * @txd: dmaengine API descriptor
+ * @tx_list: list of linked descriptors
+ * @node: link used for putting this into a channel queue
+ */
+struct ep93xx_dma_desc {
+	u32				src_addr;
+	u32				dst_addr;
+	size_t				size;
+	bool				complete;
+	struct dma_async_tx_descriptor	txd;
+	struct list_head		tx_list;
+	struct list_head		node;
+};
+
+/**
+ * struct ep93xx_dma_chan - an EP93xx DMA M2P/M2M channel
+ * @chan: dmaengine API channel
+ * @edma: pointer to to the engine device
+ * @regs: memory mapped registers
+ * @irq: interrupt number of the channel
+ * @clk: clock used by this channel
+ * @tasklet: channel specific tasklet used for callbacks
+ * @lock: lock protecting the fields following
+ * @flags: flags for the channel
+ * @buffer: which buffer to use next (0/1)
+ * @last_completed: last completed cookie value
+ * @active: flattened chain of descriptors currently being processed
+ * @queue: pending descriptors which are handled next
+ * @free_list: list of free descriptors which can be used
+ * @runtime_addr: physical address currently used as dest/src (M2M only). This
+ *                is set via %DMA_SLAVE_CONFIG before slave operation is
+ *                prepared
+ * @runtime_ctrl: M2M runtime values for the control register.
+ *
+ * As EP93xx DMA controller doesn't support real chained DMA descriptors we
+ * will have slightly different scheme here: @active points to a head of
+ * flattened DMA descriptor chain.
+ *
+ * @queue holds pending transactions. These are linked through the first
+ * descriptor in the chain. When a descriptor is moved to the @active queue,
+ * the first and chained descriptors are flattened into a single list.
+ *
+ * @chan.private holds pointer to &struct ep93xx_dma_data which contains
+ * necessary channel configuration information. For memcpy channels this must
+ * be %NULL.
+ */
+struct ep93xx_dma_chan {
+	struct dma_chan			chan;
+	const struct ep93xx_dma_engine	*edma;
+	void __iomem			*regs;
+	int				irq;
+	struct clk			*clk;
+	struct tasklet_struct		tasklet;
+	/* protects the fields following */
+	spinlock_t			lock;
+	unsigned long			flags;
+/* Channel is configured for cyclic transfers */
+#define EP93XX_DMA_IS_CYCLIC		0
+
+	int				buffer;
+	dma_cookie_t			last_completed;
+	struct list_head		active;
+	struct list_head		queue;
+	struct list_head		free_list;
+	u32				runtime_addr;
+	u32				runtime_ctrl;
+};
+
+/**
+ * struct ep93xx_dma_engine - the EP93xx DMA engine instance
+ * @dma_dev: holds the dmaengine device
+ * @m2m: is this an M2M or M2P device
+ * @hw_setup: method which sets the channel up for operation
+ * @hw_shutdown: shuts the channel down and flushes whatever is left
+ * @hw_submit: pushes active descriptor(s) to the hardware
+ * @hw_interrupt: handle the interrupt
+ * @num_channels: number of channels for this instance
+ * @channels: array of channels
+ *
+ * There is one instance of this struct for the M2P channels and one for the
+ * M2M channels. hw_xxx() methods are used to perform operations which are
+ * different on M2M and M2P channels. These methods are called with channel
+ * lock held and interrupts disabled so they cannot sleep.
+ */
+struct ep93xx_dma_engine {
+	struct dma_device	dma_dev;
+	bool			m2m;
+	int			(*hw_setup)(struct ep93xx_dma_chan *);
+	void			(*hw_shutdown)(struct ep93xx_dma_chan *);
+	void			(*hw_submit)(struct ep93xx_dma_chan *);
+	int			(*hw_interrupt)(struct ep93xx_dma_chan *);
+#define INTERRUPT_UNKNOWN	0
+#define INTERRUPT_DONE		1
+#define INTERRUPT_NEXT_BUFFER	2
+
+	size_t			num_channels;
+	struct ep93xx_dma_chan	channels[];
+};
+
+static inline struct device *chan2dev(struct ep93xx_dma_chan *edmac)
+{
+	return &edmac->chan.dev->device;
+}
+
+static struct ep93xx_dma_chan *to_ep93xx_dma_chan(struct dma_chan *chan)
+{
+	return container_of(chan, struct ep93xx_dma_chan, chan);
+}
+
+/**
+ * ep93xx_dma_set_active - set new active descriptor chain
+ * @edmac: channel
+ * @desc: head of the new active descriptor chain
+ *
+ * Sets @desc to be the head of the new active descriptor chain. This is the
+ * chain which is processed next. The active list must be empty before calling
+ * this function.
+ *
+ * Called with @edmac->lock held and interrupts disabled.
+ */
+static void ep93xx_dma_set_active(struct ep93xx_dma_chan *edmac,
+				  struct ep93xx_dma_desc *desc)
+{
+	BUG_ON(!list_empty(&edmac->active));
+
+	list_add_tail(&desc->node, &edmac->active);
+
+	/* Flatten the @desc->tx_list chain into @edmac->active list */
+	while (!list_empty(&desc->tx_list)) {
+		struct ep93xx_dma_desc *d = list_first_entry(&desc->tx_list,
+			struct ep93xx_dma_desc, node);
+
+		/*
+		 * We copy the callback parameters from the first descriptor
+		 * to all the chained descriptors. This way we can call the
+		 * callback without having to find out the first descriptor in
+		 * the chain. Useful for cyclic transfers.
+		 */
+		d->txd.callback = desc->txd.callback;
+		d->txd.callback_param = desc->txd.callback_param;
+
+		list_move_tail(&d->node, &edmac->active);
+	}
+}
+
+/* Called with @edmac->lock held and interrupts disabled */
+static struct ep93xx_dma_desc *
+ep93xx_dma_get_active(struct ep93xx_dma_chan *edmac)
+{
+	return list_first_entry(&edmac->active, struct ep93xx_dma_desc, node);
+}
+
+/**
+ * ep93xx_dma_advance_active - advances to the next active descriptor
+ * @edmac: channel
+ *
+ * Function advances active descriptor to the next in the @edmac->active and
+ * returns %true if we still have descriptors in the chain to process.
+ * Otherwise returns %false.
+ *
+ * When the channel is in cyclic mode always returns %true.
+ *
+ * Called with @edmac->lock held and interrupts disabled.
+ */
+static bool ep93xx_dma_advance_active(struct ep93xx_dma_chan *edmac)
+{
+	list_rotate_left(&edmac->active);
+
+	if (test_bit(EP93XX_DMA_IS_CYCLIC, &edmac->flags))
+		return true;
+
+	/*
+	 * If txd.cookie is set it means that we are back in the first
+	 * descriptor in the chain and hence done with it.
+	 */
+	return !ep93xx_dma_get_active(edmac)->txd.cookie;
+}
+
+/*
+ * M2P DMA implementation
+ */
+
+static void m2p_set_control(struct ep93xx_dma_chan *edmac, u32 control)
+{
+	writel(control, edmac->regs + M2P_CONTROL);
+	/*
+	 * EP93xx User's Guide states that we must perform a dummy read after
+	 * write to the control register.
+	 */
+	readl(edmac->regs + M2P_CONTROL);
+}
+
+static int m2p_hw_setup(struct ep93xx_dma_chan *edmac)
+{
+	struct ep93xx_dma_data *data = edmac->chan.private;
+	u32 control;
+
+	writel(data->port & 0xf, edmac->regs + M2P_PPALLOC);
+
+	control = M2P_CONTROL_CH_ERROR_INT | M2P_CONTROL_ICE
+		| M2P_CONTROL_ENABLE;
+	m2p_set_control(edmac, control);
+
+	return 0;
+}
+
+static inline u32 m2p_channel_state(struct ep93xx_dma_chan *edmac)
+{
+	return (readl(edmac->regs + M2P_STATUS) >> 4) & 0x3;
+}
+
+static void m2p_hw_shutdown(struct ep93xx_dma_chan *edmac)
+{
+	u32 control;
+
+	control = readl(edmac->regs + M2P_CONTROL);
+	control &= ~(M2P_CONTROL_STALLINT | M2P_CONTROL_NFBINT);
+	m2p_set_control(edmac, control);
+
+	while (m2p_channel_state(edmac) >= M2P_STATE_ON)
+		cpu_relax();
+
+	m2p_set_control(edmac, 0);
+
+	while (m2p_channel_state(edmac) == M2P_STATE_STALL)
+		cpu_relax();
+}
+
+static void m2p_fill_desc(struct ep93xx_dma_chan *edmac)
+{
+	struct ep93xx_dma_desc *desc = ep93xx_dma_get_active(edmac);
+	u32 bus_addr;
+
+	if (ep93xx_dma_chan_direction(&edmac->chan) == DMA_TO_DEVICE)
+		bus_addr = desc->src_addr;
+	else
+		bus_addr = desc->dst_addr;
+
+	if (edmac->buffer == 0) {
+		writel(desc->size, edmac->regs + M2P_MAXCNT0);
+		writel(bus_addr, edmac->regs + M2P_BASE0);
+	} else {
+		writel(desc->size, edmac->regs + M2P_MAXCNT1);
+		writel(bus_addr, edmac->regs + M2P_BASE1);
+	}
+
+	edmac->buffer ^= 1;
+}
+
+static void m2p_hw_submit(struct ep93xx_dma_chan *edmac)
+{
+	u32 control = readl(edmac->regs + M2P_CONTROL);
+
+	m2p_fill_desc(edmac);
+	control |= M2P_CONTROL_STALLINT;
+
+	if (ep93xx_dma_advance_active(edmac)) {
+		m2p_fill_desc(edmac);
+		control |= M2P_CONTROL_NFBINT;
+	}
+
+	m2p_set_control(edmac, control);
+}
+
+static int m2p_hw_interrupt(struct ep93xx_dma_chan *edmac)
+{
+	u32 irq_status = readl(edmac->regs + M2P_INTERRUPT);
+	u32 control;
+
+	if (irq_status & M2P_INTERRUPT_ERROR) {
+		struct ep93xx_dma_desc *desc = ep93xx_dma_get_active(edmac);
+
+		/* Clear the error interrupt */
+		writel(1, edmac->regs + M2P_INTERRUPT);
+
+		/*
+		 * It seems that there is no easy way of reporting errors back
+		 * to client so we just report the error here and continue as
+		 * usual.
+		 *
+		 * Revisit this when there is a mechanism to report back the
+		 * errors.
+		 */
+		dev_err(chan2dev(edmac),
+			"DMA transfer failed! Details:\n"
+			"\tcookie	: %d\n"
+			"\tsrc_addr	: 0x%08x\n"
+			"\tdst_addr	: 0x%08x\n"
+			"\tsize		: %zu\n",
+			desc->txd.cookie, desc->src_addr, desc->dst_addr,
+			desc->size);
+	}
+
+	switch (irq_status & (M2P_INTERRUPT_STALL | M2P_INTERRUPT_NFB)) {
+	case M2P_INTERRUPT_STALL:
+		/* Disable interrupts */
+		control = readl(edmac->regs + M2P_CONTROL);
+		control &= ~(M2P_CONTROL_STALLINT | M2P_CONTROL_NFBINT);
+		m2p_set_control(edmac, control);
+
+		return INTERRUPT_DONE;
+
+	case M2P_INTERRUPT_NFB:
+		if (ep93xx_dma_advance_active(edmac))
+			m2p_fill_desc(edmac);
+
+		return INTERRUPT_NEXT_BUFFER;
+	}
+
+	return INTERRUPT_UNKNOWN;
+}
+
+/*
+ * M2M DMA implementation
+ *
+ * For the M2M transfers we don't use NFB at all. This is because it simply
+ * doesn't work well with memcpy transfers. When you submit both buffers it is
+ * extremely unlikely that you get an NFB interrupt, but it instead reports
+ * DONE interrupt and both buffers are already transferred which means that we
+ * weren't able to update the next buffer.
+ *
+ * So for now we "simulate" NFB by just submitting buffer after buffer
+ * without double buffering.
+ */
+
+static int m2m_hw_setup(struct ep93xx_dma_chan *edmac)
+{
+	const struct ep93xx_dma_data *data = edmac->chan.private;
+	u32 control = 0;
+
+	if (!data) {
+		/* This is memcpy channel, nothing to configure */
+		writel(control, edmac->regs + M2M_CONTROL);
+		return 0;
+	}
+
+	switch (data->port) {
+	case EP93XX_DMA_SSP:
+		/*
+		 * This was found via experimenting - anything less than 5
+		 * causes the channel to perform only a partial transfer which
+		 * leads to problems since we don't get DONE interrupt then.
+		 */
+		control = (5 << M2M_CONTROL_PWSC_SHIFT);
+		control |= M2M_CONTROL_NO_HDSK;
+
+		if (data->direction == DMA_TO_DEVICE) {
+			control |= M2M_CONTROL_DAH;
+			control |= M2M_CONTROL_TM_TX;
+			control |= M2M_CONTROL_RSS_SSPTX;
+		} else {
+			control |= M2M_CONTROL_SAH;
+			control |= M2M_CONTROL_TM_RX;
+			control |= M2M_CONTROL_RSS_SSPRX;
+		}
+		break;
+
+	case EP93XX_DMA_IDE:
+		/*
+		 * This IDE part is totally untested. Values below are taken
+		 * from the EP93xx Users's Guide and might not be correct.
+		 */
+		control |= M2M_CONTROL_NO_HDSK;
+		control |= M2M_CONTROL_RSS_IDE;
+		control |= M2M_CONTROL_PW_16;
+
+		if (data->direction == DMA_TO_DEVICE) {
+			/* Worst case from the UG */
+			control = (3 << M2M_CONTROL_PWSC_SHIFT);
+			control |= M2M_CONTROL_DAH;
+			control |= M2M_CONTROL_TM_TX;
+		} else {
+			control = (2 << M2M_CONTROL_PWSC_SHIFT);
+			control |= M2M_CONTROL_SAH;
+			control |= M2M_CONTROL_TM_RX;
+		}
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	writel(control, edmac->regs + M2M_CONTROL);
+	return 0;
+}
+
+static void m2m_hw_shutdown(struct ep93xx_dma_chan *edmac)
+{
+	/* Just disable the channel */
+	writel(0, edmac->regs + M2M_CONTROL);
+}
+
+static void m2m_fill_desc(struct ep93xx_dma_chan *edmac)
+{
+	struct ep93xx_dma_desc *desc = ep93xx_dma_get_active(edmac);
+
+	if (edmac->buffer == 0) {
+		writel(desc->src_addr, edmac->regs + M2M_SAR_BASE0);
+		writel(desc->dst_addr, edmac->regs + M2M_DAR_BASE0);
+		writel(desc->size, edmac->regs + M2M_BCR0);
+	} else {
+		writel(desc->src_addr, edmac->regs + M2M_SAR_BASE1);
+		writel(desc->dst_addr, edmac->regs + M2M_DAR_BASE1);
+		writel(desc->size, edmac->regs + M2M_BCR1);
+	}
+
+	edmac->buffer ^= 1;
+}
+
+static void m2m_hw_submit(struct ep93xx_dma_chan *edmac)
+{
+	struct ep93xx_dma_data *data = edmac->chan.private;
+	u32 control = readl(edmac->regs + M2M_CONTROL);
+
+	/*
+	 * Since we allow clients to configure PW (peripheral width) we always
+	 * clear PW bits here and then set them according what is given in
+	 * the runtime configuration.
+	 */
+	control &= ~M2M_CONTROL_PW_MASK;
+	control |= edmac->runtime_ctrl;
+
+	m2m_fill_desc(edmac);
+	control |= M2M_CONTROL_DONEINT;
+
+	/*
+	 * Now we can finally enable the channel. For M2M channel this must be
+	 * done _after_ the BCRx registers are programmed.
+	 */
+	control |= M2M_CONTROL_ENABLE;
+	writel(control, edmac->regs + M2M_CONTROL);
+
+	if (!data) {
+		/*
+		 * For memcpy channels the software trigger must be asserted
+		 * in order to start the memcpy operation.
+		 */
+		control |= M2M_CONTROL_START;
+		writel(control, edmac->regs + M2M_CONTROL);
+	}
+}
+
+static int m2m_hw_interrupt(struct ep93xx_dma_chan *edmac)
+{
+	u32 control;
+
+	if (!(readl(edmac->regs + M2M_INTERRUPT) & M2M_INTERRUPT_DONEINT))
+		return INTERRUPT_UNKNOWN;
+
+	/* Clear the DONE bit */
+	writel(0, edmac->regs + M2M_INTERRUPT);
+
+	/* Disable interrupts and the channel */
+	control = readl(edmac->regs + M2M_CONTROL);
+	control &= ~(M2M_CONTROL_DONEINT | M2M_CONTROL_ENABLE);
+	writel(control, edmac->regs + M2M_CONTROL);
+
+	/*
+	 * Since we only get DONE interrupt we have to find out ourselves
+	 * whether there still is something to process. So we try to advance
+	 * the chain an see whether it succeeds.
+	 */
+	if (ep93xx_dma_advance_active(edmac)) {
+		edmac->edma->hw_submit(edmac);
+		return INTERRUPT_NEXT_BUFFER;
+	}
+
+	return INTERRUPT_DONE;
+}
+
+/*
+ * DMA engine API implementation
+ */
+
+static struct ep93xx_dma_desc *
+ep93xx_dma_desc_get(struct ep93xx_dma_chan *edmac)
+{
+	struct ep93xx_dma_desc *desc, *_desc;
+	struct ep93xx_dma_desc *ret = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&edmac->lock, flags);
+	list_for_each_entry_safe(desc, _desc, &edmac->free_list, node) {
+		if (async_tx_test_ack(&desc->txd)) {
+			list_del_init(&desc->node);
+
+			/* Re-initialize the descriptor */
+			desc->src_addr = 0;
+			desc->dst_addr = 0;
+			desc->size = 0;
+			desc->complete = false;
+			desc->txd.cookie = 0;
+			desc->txd.callback = NULL;
+			desc->txd.callback_param = NULL;
+
+			ret = desc;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&edmac->lock, flags);
+	return ret;
+}
+
+static void ep93xx_dma_desc_put(struct ep93xx_dma_chan *edmac,
+				struct ep93xx_dma_desc *desc)
+{
+	if (desc) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&edmac->lock, flags);
+		list_splice_init(&desc->tx_list, &edmac->free_list);
+		list_add(&desc->node, &edmac->free_list);
+		spin_unlock_irqrestore(&edmac->lock, flags);
+	}
+}
+
+/**
+ * ep93xx_dma_advance_work - start processing the next pending transaction
+ * @edmac: channel
+ *
+ * If we have pending transactions queued and we are currently idling, this
+ * function takes the next queued transaction from the @edmac->queue and
+ * pushes it to the hardware for execution.
+ */
+static void ep93xx_dma_advance_work(struct ep93xx_dma_chan *edmac)
+{
+	struct ep93xx_dma_desc *new;
+	unsigned long flags;
+
+	spin_lock_irqsave(&edmac->lock, flags);
+	if (!list_empty(&edmac->active) || list_empty(&edmac->queue)) {
+		spin_unlock_irqrestore(&edmac->lock, flags);
+		return;
+	}
+
+	/* Take the next descriptor from the pending queue */
+	new = list_first_entry(&edmac->queue, struct ep93xx_dma_desc, node);
+	list_del_init(&new->node);
+
+	ep93xx_dma_set_active(edmac, new);
+
+	/* Push it to the hardware */
+	edmac->edma->hw_submit(edmac);
+	spin_unlock_irqrestore(&edmac->lock, flags);
+}
+
+static void ep93xx_dma_unmap_buffers(struct ep93xx_dma_desc *desc)
+{
+	struct device *dev = desc->txd.chan->device->dev;
+
+	if (!(desc->txd.flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
+		if (desc->txd.flags & DMA_COMPL_SRC_UNMAP_SINGLE)
+			dma_unmap_single(dev, desc->src_addr, desc->size,
+					 DMA_TO_DEVICE);
+		else
+			dma_unmap_page(dev, desc->src_addr, desc->size,
+				       DMA_TO_DEVICE);
+	}
+	if (!(desc->txd.flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
+		if (desc->txd.flags & DMA_COMPL_DEST_UNMAP_SINGLE)
+			dma_unmap_single(dev, desc->dst_addr, desc->size,
+					 DMA_FROM_DEVICE);
+		else
+			dma_unmap_page(dev, desc->dst_addr, desc->size,
+				       DMA_FROM_DEVICE);
+	}
+}
+
+static void ep93xx_dma_tasklet(unsigned long data)
+{
+	struct ep93xx_dma_chan *edmac = (struct ep93xx_dma_chan *)data;
+	struct ep93xx_dma_desc *desc, *d;
+	dma_async_tx_callback callback;
+	void *callback_param;
+	LIST_HEAD(list);
+
+	spin_lock_irq(&edmac->lock);
+	desc = ep93xx_dma_get_active(edmac);
+	if (desc->complete) {
+		edmac->last_completed = desc->txd.cookie;
+		list_splice_init(&edmac->active, &list);
+	}
+	spin_unlock_irq(&edmac->lock);
+
+	/* Pick up the next descriptor from the queue */
+	ep93xx_dma_advance_work(edmac);
+
+	callback = desc->txd.callback;
+	callback_param = desc->txd.callback_param;
+
+	/* Now we can release all the chained descriptors */
+	list_for_each_entry_safe(desc, d, &list, node) {
+		/*
+		 * For the memcpy channels the API requires us to unmap the
+		 * buffers unless requested otherwise.
+		 */
+		if (!edmac->chan.private)
+			ep93xx_dma_unmap_buffers(desc);
+
+		ep93xx_dma_desc_put(edmac, desc);
+	}
+
+	if (callback)
+		callback(callback_param);
+}
+
+static irqreturn_t ep93xx_dma_interrupt(int irq, void *dev_id)
+{
+	struct ep93xx_dma_chan *edmac = dev_id;
+	irqreturn_t ret = IRQ_HANDLED;
+
+	spin_lock(&edmac->lock);
+
+	switch (edmac->edma->hw_interrupt(edmac)) {
+	case INTERRUPT_DONE:
+		ep93xx_dma_get_active(edmac)->complete = true;
+		tasklet_schedule(&edmac->tasklet);
+		break;
+
+	case INTERRUPT_NEXT_BUFFER:
+		if (test_bit(EP93XX_DMA_IS_CYCLIC, &edmac->flags))
+			tasklet_schedule(&edmac->tasklet);
+		break;
+
+	default:
+		dev_warn(chan2dev(edmac), "unknown interrupt!\n");
+		ret = IRQ_NONE;
+		break;
+	}
+
+	spin_unlock(&edmac->lock);
+	return ret;
+}
+
+/**
+ * ep93xx_dma_tx_submit - set the prepared descriptor(s) to be executed
+ * @tx: descriptor to be executed
+ *
+ * Function will execute given descriptor on the hardware or if the hardware
+ * is busy, queue the descriptor to be executed later on. Returns cookie which
+ * can be used to poll the status of the descriptor.
+ */
+static dma_cookie_t ep93xx_dma_tx_submit(struct dma_async_tx_descriptor *tx)
+{
+	struct ep93xx_dma_chan *edmac = to_ep93xx_dma_chan(tx->chan);
+	struct ep93xx_dma_desc *desc;
+	dma_cookie_t cookie;
+	unsigned long flags;
+
+	spin_lock_irqsave(&edmac->lock, flags);
+
+	cookie = edmac->chan.cookie;
+
+	if (++cookie < 0)
+		cookie = 1;
+
+	desc = container_of(tx, struct ep93xx_dma_desc, txd);
+
+	edmac->chan.cookie = cookie;
+	desc->txd.cookie = cookie;
+
+	/*
+	 * If nothing is currently prosessed, we push this descriptor
+	 * directly to the hardware. Otherwise we put the descriptor
+	 * to the pending queue.
+	 */
+	if (list_empty(&edmac->active)) {
+		ep93xx_dma_set_active(edmac, desc);
+		edmac->edma->hw_submit(edmac);
+	} else {
+		list_add_tail(&desc->node, &edmac->queue);
+	}
+
+	spin_unlock_irqrestore(&edmac->lock, flags);
+	return cookie;
+}
+
+/**
+ * ep93xx_dma_alloc_chan_resources - allocate resources for the channel
+ * @chan: channel to allocate resources
+ *
+ * Function allocates necessary resources for the given DMA channel and
+ * returns number of allocated descriptors for the channel. Negative errno
+ * is returned in case of failure.
+ */
+static int ep93xx_dma_alloc_chan_resources(struct dma_chan *chan)
+{
+	struct ep93xx_dma_chan *edmac = to_ep93xx_dma_chan(chan);
+	struct ep93xx_dma_data *data = chan->private;
+	const char *name = dma_chan_name(chan);
+	int ret, i;
+
+	/* Sanity check the channel parameters */
+	if (!edmac->edma->m2m) {
+		if (!data)
+			return -EINVAL;
+		if (data->port < EP93XX_DMA_I2S1 ||
+		    data->port > EP93XX_DMA_IRDA)
+			return -EINVAL;
+		if (data->direction != ep93xx_dma_chan_direction(chan))
+			return -EINVAL;
+	} else {
+		if (data) {
+			switch (data->port) {
+			case EP93XX_DMA_SSP:
+			case EP93XX_DMA_IDE:
+				if (data->direction != DMA_TO_DEVICE &&
+				    data->direction != DMA_FROM_DEVICE)
+					return -EINVAL;
+				break;
+			default:
+				return -EINVAL;
+			}
+		}
+	}
+
+	if (data && data->name)
+		name = data->name;
+
+	ret = clk_enable(edmac->clk);
+	if (ret)
+		return ret;
+
+	ret = request_irq(edmac->irq, ep93xx_dma_interrupt, 0, name, edmac);
+	if (ret)
+		goto fail_clk_disable;
+
+	spin_lock_irq(&edmac->lock);
+	edmac->last_completed = 1;
+	edmac->chan.cookie = 1;
+	ret = edmac->edma->hw_setup(edmac);
+	spin_unlock_irq(&edmac->lock);
+
+	if (ret)
+		goto fail_free_irq;
+
+	for (i = 0; i < DMA_MAX_CHAN_DESCRIPTORS; i++) {
+		struct ep93xx_dma_desc *desc;
+
+		desc = kzalloc(sizeof(*desc), GFP_KERNEL);
+		if (!desc) {
+			dev_warn(chan2dev(edmac), "not enough descriptors\n");
+			break;
+		}
+
+		INIT_LIST_HEAD(&desc->tx_list);
+
+		dma_async_tx_descriptor_init(&desc->txd, chan);
+		desc->txd.flags = DMA_CTRL_ACK;
+		desc->txd.tx_submit = ep93xx_dma_tx_submit;
+
+		ep93xx_dma_desc_put(edmac, desc);
+	}
+
+	return i;
+
+fail_free_irq:
+	free_irq(edmac->irq, edmac);
+fail_clk_disable:
+	clk_disable(edmac->clk);
+
+	return ret;
+}
+
+/**
+ * ep93xx_dma_free_chan_resources - release resources for the channel
+ * @chan: channel
+ *
+ * Function releases all the resources allocated for the given channel.
+ * The channel must be idle when this is called.
+ */
+static void ep93xx_dma_free_chan_resources(struct dma_chan *chan)
+{
+	struct ep93xx_dma_chan *edmac = to_ep93xx_dma_chan(chan);
+	struct ep93xx_dma_desc *desc, *d;
+	unsigned long flags;
+	LIST_HEAD(list);
+
+	BUG_ON(!list_empty(&edmac->active));
+	BUG_ON(!list_empty(&edmac->queue));
+
+	spin_lock_irqsave(&edmac->lock, flags);
+	edmac->edma->hw_shutdown(edmac);
+	edmac->runtime_addr = 0;
+	edmac->runtime_ctrl = 0;
+	edmac->buffer = 0;
+	list_splice_init(&edmac->free_list, &list);
+	spin_unlock_irqrestore(&edmac->lock, flags);
+
+	list_for_each_entry_safe(desc, d, &list, node)
+		kfree(desc);
+
+	clk_disable(edmac->clk);
+	free_irq(edmac->irq, edmac);
+}
+
+/**
+ * ep93xx_dma_prep_dma_memcpy - prepare a memcpy DMA operation
+ * @chan: channel
+ * @dest: destination bus address
+ * @src: source bus address
+ * @len: size of the transaction
+ * @flags: flags for the descriptor
+ *
+ * Returns a valid DMA descriptor or %NULL in case of failure.
+ */
+struct dma_async_tx_descriptor *
+ep93xx_dma_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest,
+			   dma_addr_t src, size_t len, unsigned long flags)
+{
+	struct ep93xx_dma_chan *edmac = to_ep93xx_dma_chan(chan);
+	struct ep93xx_dma_desc *desc, *first;
+	size_t bytes, offset;
+
+	first = NULL;
+	for (offset = 0; offset < len; offset += bytes) {
+		desc = ep93xx_dma_desc_get(edmac);
+		if (!desc) {
+			dev_warn(chan2dev(edmac), "couln't get descriptor\n");
+			goto fail;
+		}
+
+		bytes = min_t(size_t, len - offset, DMA_MAX_CHAN_BYTES);
+
+		desc->src_addr = src + offset;
+		desc->dst_addr = dest + offset;
+		desc->size = bytes;
+
+		if (!first)
+			first = desc;
+		else
+			list_add_tail(&desc->node, &first->tx_list);
+	}
+
+	first->txd.cookie = -EBUSY;
+	first->txd.flags = flags;
+
+	return &first->txd;
+fail:
+	ep93xx_dma_desc_put(edmac, first);
+	return NULL;
+}
+
+/**
+ * ep93xx_dma_prep_slave_sg - prepare a slave DMA operation
+ * @chan: channel
+ * @sgl: list of buffers to transfer
+ * @sg_len: number of entries in @sgl
+ * @dir: direction of tha DMA transfer
+ * @flags: flags for the descriptor
+ *
+ * Returns a valid DMA descriptor or %NULL in case of failure.
+ */
+static struct dma_async_tx_descriptor *
+ep93xx_dma_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
+			 unsigned int sg_len, enum dma_data_direction dir,
+			 unsigned long flags)
+{
+	struct ep93xx_dma_chan *edmac = to_ep93xx_dma_chan(chan);
+	struct ep93xx_dma_desc *desc, *first;
+	struct scatterlist *sg;
+	int i;
+
+	if (!edmac->edma->m2m && dir != ep93xx_dma_chan_direction(chan)) {
+		dev_warn(chan2dev(edmac),
+			 "channel was configured with different direction\n");
+		return NULL;
+	}
+
+	if (test_bit(EP93XX_DMA_IS_CYCLIC, &edmac->flags)) {
+		dev_warn(chan2dev(edmac),
+			 "channel is already used for cyclic transfers\n");
+		return NULL;
+	}
+
+	first = NULL;
+	for_each_sg(sgl, sg, sg_len, i) {
+		size_t sg_len = sg_dma_len(sg);
+
+		if (sg_len > DMA_MAX_CHAN_BYTES) {
+			dev_warn(chan2dev(edmac), "too big transfer size %d\n",
+				 sg_len);
+			goto fail;
+		}
+
+		desc = ep93xx_dma_desc_get(edmac);
+		if (!desc) {
+			dev_warn(chan2dev(edmac), "couln't get descriptor\n");
+			goto fail;
+		}
+
+		if (dir == DMA_TO_DEVICE) {
+			desc->src_addr = sg_dma_address(sg);
+			desc->dst_addr = edmac->runtime_addr;
+		} else {
+			desc->src_addr = edmac->runtime_addr;
+			desc->dst_addr = sg_dma_address(sg);
+		}
+		desc->size = sg_len;
+
+		if (!first)
+			first = desc;
+		else
+			list_add_tail(&desc->node, &first->tx_list);
+	}
+
+	first->txd.cookie = -EBUSY;
+	first->txd.flags = flags;
+
+	return &first->txd;
+
+fail:
+	ep93xx_dma_desc_put(edmac, first);
+	return NULL;
+}
+
+/**
+ * ep93xx_dma_prep_dma_cyclic - prepare a cyclic DMA operation
+ * @chan: channel
+ * @dma_addr: DMA mapped address of the buffer
+ * @buf_len: length of the buffer (in bytes)
+ * @period_len: lenght of a single period
+ * @dir: direction of the operation
+ *
+ * Prepares a descriptor for cyclic DMA operation. This means that once the
+ * descriptor is submitted, we will be submitting in a @period_len sized
+ * buffers and calling callback once the period has been elapsed. Transfer
+ * terminates only when client calls dmaengine_terminate_all() for this
+ * channel.
+ *
+ * Returns a valid DMA descriptor or %NULL in case of failure.
+ */
+static struct dma_async_tx_descriptor *
+ep93xx_dma_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t dma_addr,
+			   size_t buf_len, size_t period_len,
+			   enum dma_data_direction dir)
+{
+	struct ep93xx_dma_chan *edmac = to_ep93xx_dma_chan(chan);
+	struct ep93xx_dma_desc *desc, *first;
+	size_t offset = 0;
+
+	if (!edmac->edma->m2m && dir != ep93xx_dma_chan_direction(chan)) {
+		dev_warn(chan2dev(edmac),
+			 "channel was configured with different direction\n");
+		return NULL;
+	}
+
+	if (test_and_set_bit(EP93XX_DMA_IS_CYCLIC, &edmac->flags)) {
+		dev_warn(chan2dev(edmac),
+			 "channel is already used for cyclic transfers\n");
+		return NULL;
+	}
+
+	if (period_len > DMA_MAX_CHAN_BYTES) {
+		dev_warn(chan2dev(edmac), "too big period length %d\n",
+			 period_len);
+		return NULL;
+	}
+
+	/* Split the buffer into period size chunks */
+	first = NULL;
+	for (offset = 0; offset < buf_len; offset += period_len) {
+		desc = ep93xx_dma_desc_get(edmac);
+		if (!desc) {
+			dev_warn(chan2dev(edmac), "couln't get descriptor\n");
+			goto fail;
+		}
+
+		if (dir == DMA_TO_DEVICE) {
+			desc->src_addr = dma_addr + offset;
+			desc->dst_addr = edmac->runtime_addr;
+		} else {
+			desc->src_addr = edmac->runtime_addr;
+			desc->dst_addr = dma_addr + offset;
+		}
+
+		desc->size = period_len;
+
+		if (!first)
+			first = desc;
+		else
+			list_add_tail(&desc->node, &first->tx_list);
+	}
+
+	first->txd.cookie = -EBUSY;
+
+	return &first->txd;
+
+fail:
+	ep93xx_dma_desc_put(edmac, first);
+	return NULL;
+}
+
+/**
+ * ep93xx_dma_terminate_all - terminate all transactions
+ * @edmac: channel
+ *
+ * Stops all DMA transactions. All descriptors are put back to the
+ * @edmac->free_list and callbacks are _not_ called.
+ */
+static int ep93xx_dma_terminate_all(struct ep93xx_dma_chan *edmac)
+{
+	struct ep93xx_dma_desc *desc, *_d;
+	unsigned long flags;
+	LIST_HEAD(list);
+
+	spin_lock_irqsave(&edmac->lock, flags);
+	/* First we disable and flush the DMA channel */
+	edmac->edma->hw_shutdown(edmac);
+	clear_bit(EP93XX_DMA_IS_CYCLIC, &edmac->flags);
+	list_splice_init(&edmac->active, &list);
+	list_splice_init(&edmac->queue, &list);
+	/*
+	 * We then re-enable the channel. This way we can continue submitting
+	 * the descriptors by just calling ->hw_submit() again.
+	 */
+	edmac->edma->hw_setup(edmac);
+	spin_unlock_irqrestore(&edmac->lock, flags);
+
+	list_for_each_entry_safe(desc, _d, &list, node)
+		ep93xx_dma_desc_put(edmac, desc);
+
+	return 0;
+}
+
+static int ep93xx_dma_slave_config(struct ep93xx_dma_chan *edmac,
+				   struct dma_slave_config *config)
+{
+	enum dma_slave_buswidth width;
+	unsigned long flags;
+	u32 addr, ctrl;
+
+	if (!edmac->edma->m2m)
+		return -EINVAL;
+
+	switch (config->direction) {
+	case DMA_FROM_DEVICE:
+		width = config->src_addr_width;
+		addr = config->src_addr;
+		break;
+
+	case DMA_TO_DEVICE:
+		width = config->dst_addr_width;
+		addr = config->dst_addr;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	switch (width) {
+	case DMA_SLAVE_BUSWIDTH_1_BYTE:
+		ctrl = 0;
+		break;
+	case DMA_SLAVE_BUSWIDTH_2_BYTES:
+		ctrl = M2M_CONTROL_PW_16;
+		break;
+	case DMA_SLAVE_BUSWIDTH_4_BYTES:
+		ctrl = M2M_CONTROL_PW_32;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&edmac->lock, flags);
+	edmac->runtime_addr = addr;
+	edmac->runtime_ctrl = ctrl;
+	spin_unlock_irqrestore(&edmac->lock, flags);
+
+	return 0;
+}
+
+/**
+ * ep93xx_dma_control - manipulate all pending operations on a channel
+ * @chan: channel
+ * @cmd: control command to perform
+ * @arg: optional argument
+ *
+ * Controls the channel. Function returns %0 in case of success or negative
+ * error in case of failure.
+ */
+static int ep93xx_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
+			      unsigned long arg)
+{
+	struct ep93xx_dma_chan *edmac = to_ep93xx_dma_chan(chan);
+	struct dma_slave_config *config;
+
+	switch (cmd) {
+	case DMA_TERMINATE_ALL:
+		return ep93xx_dma_terminate_all(edmac);
+
+	case DMA_SLAVE_CONFIG:
+		config = (struct dma_slave_config *)arg;
+		return ep93xx_dma_slave_config(edmac, config);
+
+	default:
+		break;
+	}
+
+	return -ENOSYS;
+}
+
+/**
+ * ep93xx_dma_tx_status - check if a transaction is completed
+ * @chan: channel
+ * @cookie: transaction specific cookie
+ * @state: state of the transaction is stored here if given
+ *
+ * This function can be used to query state of a given transaction.
+ */
+static enum dma_status ep93xx_dma_tx_status(struct dma_chan *chan,
+					    dma_cookie_t cookie,
+					    struct dma_tx_state *state)
+{
+	struct ep93xx_dma_chan *edmac = to_ep93xx_dma_chan(chan);
+	dma_cookie_t last_used, last_completed;
+	enum dma_status ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&edmac->lock, flags);
+	last_used = chan->cookie;
+	last_completed = edmac->last_completed;
+	spin_unlock_irqrestore(&edmac->lock, flags);
+
+	ret = dma_async_is_complete(cookie, last_completed, last_used);
+	dma_set_tx_state(state, last_completed, last_used, 0);
+
+	return ret;
+}
+
+/**
+ * ep93xx_dma_issue_pending - push pending transactions to the hardware
+ * @chan: channel
+ *
+ * When this function is called, all pending transactions are pushed to the
+ * hardware and executed.
+ */
+static void ep93xx_dma_issue_pending(struct dma_chan *chan)
+{
+	ep93xx_dma_advance_work(to_ep93xx_dma_chan(chan));
+}
+
+static int __init ep93xx_dma_probe(struct platform_device *pdev)
+{
+	struct ep93xx_dma_platform_data *pdata = dev_get_platdata(&pdev->dev);
+	struct ep93xx_dma_engine *edma;
+	struct dma_device *dma_dev;
+	size_t edma_size;
+	int ret, i;
+
+	edma_size = pdata->num_channels * sizeof(struct ep93xx_dma_chan);
+	edma = kzalloc(sizeof(*edma) + edma_size, GFP_KERNEL);
+	if (!edma)
+		return -ENOMEM;
+
+	dma_dev = &edma->dma_dev;
+	edma->m2m = platform_get_device_id(pdev)->driver_data;
+	edma->num_channels = pdata->num_channels;
+
+	INIT_LIST_HEAD(&dma_dev->channels);
+	for (i = 0; i < pdata->num_channels; i++) {
+		const struct ep93xx_dma_chan_data *cdata = &pdata->channels[i];
+		struct ep93xx_dma_chan *edmac = &edma->channels[i];
+
+		edmac->chan.device = dma_dev;
+		edmac->regs = cdata->base;
+		edmac->irq = cdata->irq;
+		edmac->edma = edma;
+
+		edmac->clk = clk_get(NULL, cdata->name);
+		if (IS_ERR(edmac->clk)) {
+			dev_warn(&pdev->dev, "failed to get clock for %s\n",
+				 cdata->name);
+			continue;
+		}
+
+		spin_lock_init(&edmac->lock);
+		INIT_LIST_HEAD(&edmac->active);
+		INIT_LIST_HEAD(&edmac->queue);
+		INIT_LIST_HEAD(&edmac->free_list);
+		tasklet_init(&edmac->tasklet, ep93xx_dma_tasklet,
+			     (unsigned long)edmac);
+
+		list_add_tail(&edmac->chan.device_node,
+			      &dma_dev->channels);
+	}
+
+	dma_cap_zero(dma_dev->cap_mask);
+	dma_cap_set(DMA_SLAVE, dma_dev->cap_mask);
+	dma_cap_set(DMA_CYCLIC, dma_dev->cap_mask);
+
+	dma_dev->dev = &pdev->dev;
+	dma_dev->device_alloc_chan_resources = ep93xx_dma_alloc_chan_resources;
+	dma_dev->device_free_chan_resources = ep93xx_dma_free_chan_resources;
+	dma_dev->device_prep_slave_sg = ep93xx_dma_prep_slave_sg;
+	dma_dev->device_prep_dma_cyclic = ep93xx_dma_prep_dma_cyclic;
+	dma_dev->device_control = ep93xx_dma_control;
+	dma_dev->device_issue_pending = ep93xx_dma_issue_pending;
+	dma_dev->device_tx_status = ep93xx_dma_tx_status;
+
+	dma_set_max_seg_size(dma_dev->dev, DMA_MAX_CHAN_BYTES);
+
+	if (edma->m2m) {
+		dma_cap_set(DMA_MEMCPY, dma_dev->cap_mask);
+		dma_dev->device_prep_dma_memcpy = ep93xx_dma_prep_dma_memcpy;
+
+		edma->hw_setup = m2m_hw_setup;
+		edma->hw_shutdown = m2m_hw_shutdown;
+		edma->hw_submit = m2m_hw_submit;
+		edma->hw_interrupt = m2m_hw_interrupt;
+	} else {
+		dma_cap_set(DMA_PRIVATE, dma_dev->cap_mask);
+
+		edma->hw_setup = m2p_hw_setup;
+		edma->hw_shutdown = m2p_hw_shutdown;
+		edma->hw_submit = m2p_hw_submit;
+		edma->hw_interrupt = m2p_hw_interrupt;
+	}
+
+	ret = dma_async_device_register(dma_dev);
+	if (unlikely(ret)) {
+		for (i = 0; i < edma->num_channels; i++) {
+			struct ep93xx_dma_chan *edmac = &edma->channels[i];
+			if (!IS_ERR_OR_NULL(edmac->clk))
+				clk_put(edmac->clk);
+		}
+		kfree(edma);
+	} else {
+		dev_info(dma_dev->dev, "EP93xx M2%s DMA ready\n",
+			 edma->m2m ? "M" : "P");
+	}
+
+	return ret;
+}
+
+static struct platform_device_id ep93xx_dma_driver_ids[] = {
+	{ "ep93xx-dma-m2p", 0 },
+	{ "ep93xx-dma-m2m", 1 },
+	{ },
+};
+
+static struct platform_driver ep93xx_dma_driver = {
+	.driver		= {
+		.name	= "ep93xx-dma",
+	},
+	.id_table	= ep93xx_dma_driver_ids,
+};
+
+static int __init ep93xx_dma_module_init(void)
+{
+	return platform_driver_probe(&ep93xx_dma_driver, ep93xx_dma_probe);
+}
+subsys_initcall(ep93xx_dma_module_init);
+
+MODULE_AUTHOR("Mika Westerberg <mika.westerberg@iki.fi>");
+MODULE_DESCRIPTION("EP93xx DMA driver");
+MODULE_LICENSE("GPL");
-- 
1.7.4.4


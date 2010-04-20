Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab0DTQaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 12:30:09 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:51586 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab0DTQaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 12:30:05 -0400
X-Spam-Processed: digidescorp.com, Tue, 20 Apr 2010 11:29:58 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=17267f6802=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] Xilinx MPMC SDMA subsystem
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: Sergey Temerkhanov <temerkhanov@yandex.ru>
Cc: linuxppc-dev@lists.ozlabs.org, Grant Likely <grant.likely@secretlab.ca>,
       microblaze-uclinux@itee.uq.edu.au,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <201003292304.39657.temerkhanov@yandex.ru>
References: <201003172118.41559.temerkhanov@cifronik.ru>
	 <1269877373.6173.27.camel@iscandar.digidescorp.com>
	 <fa686aa41003290856t24a248a5j5dfda623ed2805c0@mail.gmail.com>
	 <201003292304.39657.temerkhanov@yandex.ru>
Content-Type: multipart/mixed; boundary="=-OhWFGnETH9EQeOfdCJBG"
Organization: Digital Design Corporation
Date: Tue, 20 Apr 2010 11:29:55 -0500
Message-Id: <1271780995.3067.79.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OhWFGnETH9EQeOfdCJBG
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Sergey,

I've only just started using this in earnest, sorry for not getting back
to you sooner. It's a nice encapsulation of the MPMC/SDMA functionality,
thanks for posting it.

In order to integrate this into my system, I refactored the bus
attachment code and added hooks for platform bus. I also removed some
dead code, reformatted some things to satisfy checkpatch, tweaked
#includes to fix Microblaze compilation, and fixed a potential bug where
sdma_set_coalesce() could return without releasing a spinlock. I also
optimized the sdma_desc_* functions by moving any byte swapping from
runtime to compile-time.

Some more controversial changes / items for discussion:

1. I dropped setting the tail descriptor in the sdma_[rt]x_init()
functions since that would start DMA, which is not what I think we want.

2. I made RX and TX interrupts optional. There are use cases (DMAing
while atomic) in which interrupts are not necessary. The DMA engine only
needs RX interrupts. There is an (obscure) mode in which it might also
want TX interrupts, and in that case it's only interested in error
interrupts - normal "done" interrupts are of no interest whatsoever.
Rather than try to adapt the sdma driver to fit that case, I think I
will drop that mode from the DMA engine driver.

2A. I will need, but haven't added yet, methods to know if a SDMA
channel has RX and TX IRQ resources. I'm assuming that a simple inline
accessor is preferred over snooping struct sdma directly.

3. I changed the user[4] field of struct sdma_desc to individually-named
fields app1 - app4, to match the MPMC datasheet. I found user[0]
confusing and already had to fix a bug where I had coded user[0]
thinking it was app0, when I really should have specified stat_ctl.

4. Why have sdma_[rt]x_submit() return a value if it is always zero?

5. I would like to see the 'virt' and 'flags' fields removed from struct
sdma_desc and SDMA_ALIGNMENT reduced from 0x40 to 0x20. Neither field is
used in the sdma driver itself. I understand why 'virt' is there, but
having it in the struct will make the DMA engine driver less efficient.
Because the DMA engine operates on 'loopback' SDMA channels it always
allocates descriptors in pairs. Also the DMA engine framework already
provides storage for the 'virt' pointer. Having a larger-than-necessary
structure would force the DMA engine to do larger allocations from its
DMA pool - instead of 64 bytes per dual descriptor, it would have to
allocate 128.

6. I'm concerned that there is no concept of "allocating" a channel,
something like a sdma_device_get() / sdma_device_put() pair that would
prevent concurrent access to a SDMA device by removing the device from
consideration by sdma_find_device().

7. In that same vein, I'm curious about the need for a list of
sdma_clients. Is there a use case for this in your systems?

8. It would probably make sense to have sdma_init() fail with -EEXIST if
a SDMA device with the specified phandle already exists (-1 being an
exception).

9. I didn't resolve the issue of what to name the files / API, assuming
'sdma' is a little too generic for things that are now publicly visible.
If we have to change it, some suggestions are 'mpmcsdma' (long, but
precise), 'xildma', 'xsdma', or 'xdma' (also perhaps too generic).

As time permits, I'll work on refactoring the DMA engine driver to use
the sdma driver - I'll post change requests for anything else I need
rather than modifying the sdma code directly.

Regards,
------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>

--=-OhWFGnETH9EQeOfdCJBG
Content-Disposition: attachment; filename="sdma2.patch"
Content-Type: text/x-patch; name="sdma2.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff -uprN a/drivers/dma/sdma.c b/drivers/dma/sdma.c
--- a/drivers/dma/sdma.c	1969-12-31 18:00:00.000000000 -0600
+++ b/drivers/dma/sdma.c	2010-04-20 11:17:30.000000000 -0500
@@ -0,0 +1,887 @@
+/*
+ * SDMA subsystem support for Xilinx MPMC.
+ *
+ * Author: Sergey Temerkhanov
+ * Platform Bus by Steven J. Magnani
+ *
+ * Copyright (c) 2008-2010 Cifronic ZAO
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ */
+
+#include <linux/delay.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/interrupt.h>
+#include <linux/mutex.h>
+#include <linux/wait.h>
+#include <linux/list.h>
+#include <linux/io.h>
+#include <linux/sdma.h>
+
+#include <linux/of_device.h>
+#include <linux/of_platform.h>
+
+#define DRV_VERSION "0.0.4"
+#define DRV_NAME "sdma"
+
+MODULE_AUTHOR("Sergey Temerkhanov <temerkhanov@cifronik.ru>");
+MODULE_DESCRIPTION("Xilinx SDMA driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
+
+LIST_HEAD(mpmc_devs);
+DEFINE_MUTEX(mpmc_devs_lock);
+
+enum {
+	SDMA_TX_REGS	= 0x00,	/* TX channel registers beginning */
+	SDMA_RX_REGS	= 0x20,	/* RX channel registers beginning */
+	SDMA_DMACR	= 0x40,	/* DMA control register */
+
+	SDMA_NDESCR	= 0x00,	/* Next descriptor address */
+	SDMA_BUFA	= 0x04,	/* Current buffer address */
+	SDMA_BUFL	= 0x08,	/* Current buffer length */
+	SDMA_CDESCR	= 0x0C,	/* Current descriptor address */
+	SDMA_TDESCR	= 0x10,	/* Tail descriptor address */
+	SDMA_CR		= 0x14,	/* Channel control */
+	SDMA_IRQ	= 0x18,	/* Interrupt register */
+	SDMA_SR		= 0x1C,	/* Status */
+};
+
+enum {
+	SDMA_CR_IRQ_TIMEOUT_MSK	  = (0xFF << 24),	/* Interrupt coalesce timeout */
+	SDMA_CR_IRQ_THRESHOLD_MSK = (0xFF << 16),	/* Interrupt coalesce count */
+	SDMA_CR_MSB_ADDR_MSK	  = (0xF << 12),	/* MSB for 36 bit addressing */
+	SDMA_CR_APP_EN		  = (1 << 11),	/* Application data mask enable */
+	SDMA_CR_1_BIT_CNT	  = (1 << 10),	/* All interrupt counters are 1-bit */
+	SDMA_CR_INT_ON_END	  = (1 << 9),	/* Interrupt-on-end */
+	SDMA_CR_LD_IRQ_CNT	  = (1 << 8),	/* Load IRQ_COUNT */
+	SDMA_CR_IRQ_EN		  = (1 << 7),	/* Master interrupt enable */
+	SDMA_CR_IRQ_ERROR	  = (1 << 2),	/* Error interrupt enable */
+	SDMA_CR_IRQ_TIMEOUT	  = (1 << 1),	/* Coalesce timeout interrupt enable */
+	SDMA_CR_IRQ_THRESHOLD	  = (1 << 0),	/* Coalesce threshold interrupt enable */
+
+	SDMA_CR_IRQ_ALL		  = SDMA_CR_IRQ_EN | SDMA_CR_IRQ_ERROR |
+					SDMA_CR_IRQ_TIMEOUT | SDMA_CR_IRQ_THRESHOLD,
+
+	SDMA_CR_IRQ_TIMEOUT_SH	 = 24,
+	SDMA_CR_IRQ_THRESHOLD_SH = 16,
+	SDMA_CR_MSB_ADDR_SH	 = 12,
+
+	SDMA_IRQ_WRQ_EMPTY	= (1 << 14),	/* Write Command Queue Empty (rx) */
+	SDMA_IRQ_PLB_RD_ERROR	= (1 << 4),	/* PLB Read Error IRQ */
+	SDMA_IRQ_PLB_WR_ERROR	= (1 << 3),	/* PLB Write Error IRQ */
+	SDMA_IRQ_ERROR		= (1 << 2),	/* Error IRQ */
+	SDMA_IRQ_TIMEOUT	= (1 << 1),	/* Coalesce timeout IRQ */
+	SDMA_IRQ_THRESHOLD	= (1 << 0),	/* Coalesce threshold IRQ */
+
+	SDMA_IRQ_ALL_ERR	= 0x1C,		/* All error interrupt */
+	SDMA_IRQ_ALL		= 0x1F,		/* All interrupt bits */
+	SDMA_IRQ_ALL_DONE	= 0x3,		/* All work complete interrupt bits */
+
+
+#define SDMA_IRQ_COALESCE_COUNT(x)	((x >> 10) & 0xF)
+#define SDMA_IRQ_DELAY_COUNT(x)		((x >> 8) & 0x3)
+
+	SDMA_SR_ERR_TDESCR	= (1 << 21),	/* Tail descriptor pointer is invalid */
+	SDMA_SR_ERR_CMPL	= (1 << 20),	/* Complete bit is set */
+	SDMA_SR_ERR_BUFA	= (1 << 19),	/* Buffer address is invalid */
+	SDMA_SR_ERR_NDESCR	= (1 << 18),	/* Next descriptor pointer is invalid */
+	SDMA_SR_ERR_CDESCR	= (1 << 17),	/* Current descriptor pointer is invalid */
+	SDMA_SR_ERR_BUSYWR	= (1 << 16),	/* Current descriptor modified */
+	SDMA_SR_ERROR		= (1 << 7),	/* Error IRQ has occurred */
+	SDMA_SR_IRQ_ON_END	= (1 << 6),	/* On-end IRQ has occurred */
+	SDMA_SR_STOP_ON_END	= (1 << 5), 	/* Stop on end has occurred */
+	SDMA_SR_COMPLETED	= (1 << 4),	/* BD completed */
+	SDMA_SR_SOP		= (1 << 3),	/* Current BD has SOP set */
+	SDMA_SR_EOP		= (1 << 2),	/* Current BD has EOP set */
+	SDMA_SR_ENGINE_BUSY	= (1 << 1),	/* Channel is busy */
+	
+
+	SDMA_DMACR_TX_PAUSE	= (1 << 29),	/* Pause TX channel */
+	SDMA_DMACR_RX_PAUSE	= (1 << 28),	/* Pause RX channel */
+	SDMA_DMACR_PLB_ERR_DIS	= (1 << 5),	/* Disable PLB error detection */
+	SDMA_DMACR_RX_OVF_DIS	= (1 << 4),	/* Disable error on RX coalesce counter overflows */
+	SDMA_DMACR_TX_OVF_DIS	= (1 << 3),	/* Disable error on TX coalesce counter overflows */
+	SDMA_DMACR_TAIL_PTR_EN	= (1 << 2),	/* Enable use of tail pointer register */
+	SDMA_DMACR_EN_ARB_HOLD	= (1 << 1),	/* Enable arbitration hold */
+	SDMA_DMACR_RESET	= (1 << 0),	/* Reset both channels */
+};
+
+static inline void sdma_write_cr(struct sdma_device *sdma, u32 value)
+{
+	out_be32(sdma->ioaddr + SDMA_DMACR, value);
+}
+
+static inline u32 sdma_read_cr(struct sdma_device *sdma)
+{
+	return in_be32(sdma->ioaddr + SDMA_DMACR);
+}
+
+static inline void sdma_tx_out32(struct sdma_device *sdma, int reg, u32 value)
+{
+	out_be32(sdma->ioaddr + reg + SDMA_TX_REGS, value);
+}
+
+static inline u32 sdma_tx_in32(struct sdma_device *sdma, int reg)
+{
+	return in_be32(sdma->ioaddr + reg + SDMA_TX_REGS);
+}
+
+static inline void sdma_rx_out32(struct sdma_device *sdma, int reg, u32 value)
+{
+	out_be32(sdma->ioaddr + reg + SDMA_RX_REGS, value);
+}
+
+static inline u32 sdma_rx_in32(struct sdma_device *sdma, int reg)
+{
+	return in_be32(sdma->ioaddr + reg + SDMA_RX_REGS);
+}
+
+void sdma_reset(struct sdma_device *sdma)
+{
+	u32 rx_cr, tx_cr, rx_irq, tx_irq;
+
+	unsigned long flags;
+	struct sdma_client *client, *tmp;
+
+	DEFINE_SDMA_COALESCE(coal);
+	spin_lock_irqsave(&sdma->lock, flags);
+
+	sdma_write_cr(sdma, SDMA_DMACR_RESET);
+
+	while (sdma_read_cr(sdma) & SDMA_DMACR_RESET)
+		udelay(100);
+
+	rx_cr = sdma_rx_in32(sdma, SDMA_CR);
+	tx_cr = sdma_tx_in32(sdma, SDMA_CR);
+
+	sdma_rx_out32(sdma, SDMA_CR, rx_cr & ~SDMA_CR_IRQ_ALL);
+	sdma_tx_out32(sdma, SDMA_CR, tx_cr & ~SDMA_CR_IRQ_ALL);
+
+	rx_irq = sdma_rx_in32(sdma, SDMA_IRQ);
+	tx_irq = sdma_tx_in32(sdma, SDMA_IRQ);
+
+	sdma_rx_out32(sdma, SDMA_IRQ, rx_irq);
+	sdma_tx_out32(sdma, SDMA_IRQ, tx_irq);
+
+	sdma_write_cr(sdma, SDMA_DMACR_TAIL_PTR_EN |
+		SDMA_DMACR_RX_OVF_DIS | SDMA_DMACR_TX_OVF_DIS);
+
+	if (sdma->rx_irq != NO_IRQ) {
+		sdma_rx_out32(sdma, SDMA_CR,
+			      rx_cr | (SDMA_CR_IRQ_ALL & ~SDMA_CR_IRQ_EN));
+
+		rx_cr = sdma_rx_in32(sdma, SDMA_CR);
+		sdma_rx_out32(sdma, SDMA_CR, rx_cr | SDMA_CR_IRQ_EN);
+	}
+
+	if (sdma->tx_irq != NO_IRQ) {
+		sdma_tx_out32(sdma, SDMA_CR,
+			      tx_cr | (SDMA_CR_IRQ_ALL & ~SDMA_CR_IRQ_EN));
+		tx_cr = sdma_tx_in32(sdma, SDMA_CR);
+		sdma_tx_out32(sdma, SDMA_CR, tx_cr | SDMA_CR_IRQ_EN);
+	}
+
+	spin_unlock_irqrestore(&sdma->lock, flags);
+
+	list_for_each_entry_safe(client, tmp, &sdma->clients, item)
+		if (likely(client->reset))
+			client->reset(client->data);
+
+	sdma_set_coalesce(sdma, &coal);
+}
+EXPORT_SYMBOL_GPL(sdma_reset);
+
+void sdma_tx_irq_enable(struct sdma_device *sdma)
+{
+	u32 tx_cr;
+	unsigned long flags;
+
+	BUG_ON(sdma->tx_irq == NO_IRQ);
+
+	spin_lock_irqsave(&sdma->lock, flags);
+	tx_cr = sdma_tx_in32(sdma, SDMA_CR);
+	sdma_tx_out32(sdma, SDMA_CR, tx_cr | SDMA_CR_IRQ_EN);
+	spin_unlock_irqrestore(&sdma->lock, flags);
+}
+EXPORT_SYMBOL_GPL(sdma_tx_irq_enable);
+
+void sdma_rx_irq_enable(struct sdma_device *sdma)
+{
+	u32 rx_cr;
+	unsigned long flags;
+
+	BUG_ON(sdma->rx_irq == NO_IRQ);
+
+	spin_lock_irqsave(&sdma->lock, flags);
+	rx_cr = sdma_rx_in32(sdma, SDMA_CR);
+	sdma_rx_out32(sdma, SDMA_CR, rx_cr | SDMA_CR_IRQ_EN);
+	spin_unlock_irqrestore(&sdma->lock, flags);
+}
+EXPORT_SYMBOL_GPL(sdma_rx_irq_enable);
+
+void sdma_tx_irq_disable(struct sdma_device *sdma)
+{
+	u32 tx_cr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sdma->lock, flags);
+	tx_cr = sdma_tx_in32(sdma, SDMA_CR);
+	sdma_tx_out32(sdma, SDMA_CR, tx_cr & ~SDMA_CR_IRQ_EN);
+	spin_unlock_irqrestore(&sdma->lock, flags);
+}
+EXPORT_SYMBOL_GPL(sdma_tx_irq_disable);
+
+void sdma_rx_irq_disable(struct sdma_device *sdma)
+{
+	u32 rx_cr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sdma->lock, flags);
+	rx_cr = sdma_rx_in32(sdma, SDMA_CR);
+	sdma_rx_out32(sdma, SDMA_CR, rx_cr & ~SDMA_CR_IRQ_EN);
+	spin_unlock_irqrestore(&sdma->lock, flags);
+}
+EXPORT_SYMBOL_GPL(sdma_rx_irq_disable);
+
+void sdma_tx_irq_ack(struct sdma_device *sdma)
+{
+	u32 irq_stat;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sdma->lock, flags);
+	irq_stat = sdma_tx_in32(sdma, SDMA_IRQ);
+	sdma_tx_out32(sdma, SDMA_IRQ, irq_stat & SDMA_IRQ_ALL_DONE);
+	spin_unlock_irqrestore(&sdma->lock, flags);
+}
+EXPORT_SYMBOL_GPL(sdma_tx_irq_ack);
+
+void sdma_rx_irq_ack(struct sdma_device *sdma)
+{
+	u32 irq_stat;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sdma->lock, flags);
+	irq_stat = sdma_rx_in32(sdma, SDMA_IRQ);
+	sdma_rx_out32(sdma, SDMA_IRQ, irq_stat & SDMA_IRQ_ALL_DONE);
+	spin_unlock_irqrestore(&sdma->lock, flags);
+}
+EXPORT_SYMBOL_GPL(sdma_rx_irq_ack);
+
+void sdma_pause(struct sdma_device *sdma)
+{
+	u32 dmacr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sdma->lock, flags);
+	dmacr = sdma_read_cr(sdma);
+	dmacr |= SDMA_DMACR_TX_PAUSE | SDMA_DMACR_RX_PAUSE;
+	sdma_write_cr(sdma, dmacr);
+	spin_unlock_irqrestore(&sdma->lock, flags);
+}
+EXPORT_SYMBOL_GPL(sdma_pause);
+
+void sdma_resume(struct sdma_device *sdma)
+{
+	u32 dmacr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sdma->lock, flags);
+	dmacr = sdma_read_cr(sdma);
+	dmacr &= ~(SDMA_DMACR_TX_PAUSE | SDMA_DMACR_RX_PAUSE);
+	sdma_write_cr(sdma, dmacr);
+	spin_unlock_irqrestore(&sdma->lock, flags);
+}
+EXPORT_SYMBOL_GPL(sdma_resume);
+
+int sdma_set_coalesce(struct sdma_device *sdma, struct sdma_coalesce *coal)
+{
+	u32 tx_cr, rx_cr;
+	unsigned long flags;
+
+	if (coal->tx_timeout > 255 ||
+	    coal->rx_timeout > 255 ||
+	    coal->tx_threshold > 255 ||
+	    coal->rx_threshold > 255)
+		return -EINVAL;
+
+	spin_lock_irqsave(&sdma->lock, flags);
+
+	if (sdma->rx_irq != NO_IRQ) {
+		rx_cr = sdma_rx_in32(sdma, SDMA_CR);
+
+		if (coal->rx_timeout == 0) {
+			coal->rx_timeout = 1;
+			rx_cr &= ~SDMA_CR_IRQ_TIMEOUT;
+		} else {
+			rx_cr |= SDMA_CR_IRQ_TIMEOUT;
+		}
+
+		rx_cr &= ~(SDMA_CR_IRQ_THRESHOLD_MSK | SDMA_CR_IRQ_TIMEOUT_SH);
+		rx_cr |= (coal->rx_threshold << SDMA_CR_IRQ_THRESHOLD_SH)
+			 & SDMA_CR_IRQ_THRESHOLD_MSK;
+		rx_cr |= (coal->rx_timeout << SDMA_CR_IRQ_TIMEOUT_SH)
+			 & SDMA_CR_IRQ_TIMEOUT_MSK;
+		rx_cr |= SDMA_CR_LD_IRQ_CNT;
+
+		sdma_rx_out32(sdma, SDMA_CR, rx_cr);
+	}
+
+	if (sdma->tx_irq != NO_IRQ) {
+		tx_cr = sdma_tx_in32(sdma, SDMA_CR);
+
+		if (coal->tx_timeout == 0) {
+			coal->tx_timeout = 1;
+			tx_cr &= ~SDMA_CR_IRQ_TIMEOUT;
+		} else {
+			tx_cr |= SDMA_CR_IRQ_TIMEOUT;
+		}
+
+		tx_cr &= ~(SDMA_CR_IRQ_THRESHOLD_MSK | SDMA_CR_IRQ_TIMEOUT_SH);
+		tx_cr |= (coal->tx_threshold << SDMA_CR_IRQ_THRESHOLD_SH)
+			 & SDMA_CR_IRQ_THRESHOLD_MSK;
+		tx_cr |= (coal->tx_timeout << SDMA_CR_IRQ_TIMEOUT_SH)
+			 & SDMA_CR_IRQ_TIMEOUT_MSK;
+		tx_cr |= SDMA_CR_LD_IRQ_CNT;
+
+		sdma_tx_out32(sdma, SDMA_CR, tx_cr);
+	}
+
+	spin_unlock_irqrestore(&sdma->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sdma_set_coalesce);
+
+int sdma_get_coalesce(struct sdma_device *sdma, struct sdma_coalesce *coal)
+{
+	u32 tx_cr, rx_cr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sdma->lock, flags);
+
+	tx_cr = sdma_tx_in32(sdma, SDMA_CR);
+	rx_cr = sdma_rx_in32(sdma, SDMA_CR);
+
+	coal->tx_threshold = (tx_cr & SDMA_CR_IRQ_THRESHOLD_MSK)
+			     >> SDMA_CR_IRQ_THRESHOLD_SH;
+	coal->tx_timeout = (tx_cr & SDMA_CR_IRQ_TIMEOUT_MSK)
+			   >> SDMA_CR_IRQ_TIMEOUT_SH;
+
+	coal->rx_threshold = (rx_cr & SDMA_CR_IRQ_THRESHOLD_MSK)
+			     >> SDMA_CR_IRQ_THRESHOLD_SH;
+	coal->rx_timeout = (rx_cr & SDMA_CR_IRQ_TIMEOUT_MSK)
+			     >> SDMA_CR_IRQ_TIMEOUT_SH;
+
+	if (!(tx_cr & SDMA_CR_IRQ_TIMEOUT))
+		coal->tx_timeout = 0;
+
+	if (!(rx_cr & SDMA_CR_IRQ_TIMEOUT))
+		coal->rx_timeout = 0;
+
+	spin_unlock_irqrestore(&sdma->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sdma_get_coalesce);
+
+int sdma_tx_submit(struct sdma_device *sdma, dma_addr_t desc)
+{
+	sdma_tx_out32(sdma, SDMA_TDESCR, desc);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sdma_tx_submit);
+
+int sdma_rx_submit(struct sdma_device *sdma, dma_addr_t desc)
+{
+	sdma_rx_out32(sdma, SDMA_TDESCR, desc);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sdma_rx_submit);
+
+void sdma_tx_init(struct sdma_device *sdma, dma_addr_t desc)
+{
+	sdma_tx_out32(sdma, SDMA_CDESCR, desc);
+}
+EXPORT_SYMBOL_GPL(sdma_tx_init);
+
+void sdma_rx_init(struct sdma_device *sdma, dma_addr_t desc)
+{
+	sdma_rx_out32(sdma, SDMA_CDESCR, desc);
+}
+EXPORT_SYMBOL_GPL(sdma_rx_init);
+
+struct sdma_device *sdma_find_device(int phandle)
+{
+	struct mpmc_device *mpmc;
+	struct sdma_device *sdma = NULL;
+	int found = 0;
+	mutex_lock(&mpmc_devs_lock);
+	list_for_each_entry(mpmc, &mpmc_devs, item) {
+		mutex_lock(&mpmc->devs_lock);
+		list_for_each_entry(sdma, &mpmc->sdma_devs, item) {
+			if (sdma->phandle == phandle) {
+				found = 1;
+				break;
+			}
+		}
+		mutex_unlock(&mpmc->devs_lock);
+		if (found)
+			break;
+		else
+			sdma = NULL;
+	}
+	mutex_unlock(&mpmc_devs_lock);
+	return sdma;
+}
+EXPORT_SYMBOL_GPL(sdma_find_device);
+
+static irqreturn_t sdma_rx_intr(int irq, void *dev_id)
+{
+	u32 irq_ack, status;
+	struct sdma_device *sdma = dev_id;
+	struct sdma_client *client, *tmp;
+
+	/* Read pending interrupts */
+	status = sdma_rx_in32(sdma, SDMA_IRQ);
+	irq_ack = status;
+	irq_ack &= sdma->rx_ack ? SDMA_IRQ_ALL : SDMA_IRQ_ALL_ERR;
+	sdma_rx_out32(sdma, SDMA_IRQ, irq_ack);
+
+	if (unlikely(status & SDMA_IRQ_ALL_ERR)) {
+		dev_err(sdma->dev, "%s: error status: %08x\n", __func__, 
+			status);
+		sdma_reset(sdma);
+		list_for_each_entry_safe(client, tmp, &sdma->clients, item)
+			if (likely(client->error))
+				client->error(client->data);
+		return IRQ_HANDLED;
+	}
+
+	if (likely(status & SDMA_IRQ_ALL_DONE)) {
+		list_for_each_entry_safe(client, tmp, &sdma->clients, item)
+			if (likely(client->rx_complete))
+				client->rx_complete(client->data);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t sdma_tx_intr(int irq, void *dev_id)
+{
+	u32 irq_ack, status;
+	struct sdma_device *sdma = dev_id;
+	struct sdma_client *client, *tmp;
+
+	/* Read pending interrupts */
+	status = sdma_tx_in32(sdma, SDMA_IRQ);
+	irq_ack = status;
+	irq_ack &= sdma->tx_ack ? SDMA_IRQ_ALL : SDMA_IRQ_ALL_ERR;
+	sdma_tx_out32(sdma, SDMA_IRQ, irq_ack);
+
+	if (unlikely(status & SDMA_IRQ_ALL_ERR)) {
+		dev_err(sdma->dev, "%s: error status: %08x\n", __func__, 
+			status);
+		sdma_reset(sdma);
+		list_for_each_entry_safe(client, tmp, &sdma->clients, item)
+			if (likely(client->error))
+				client->error(client->data);
+		return IRQ_HANDLED;
+	}
+
+	if (likely(status & SDMA_IRQ_ALL_DONE)) {
+		list_for_each_entry_safe(client, tmp, &sdma->clients, item)
+			if (likely(client->tx_complete))
+				client->tx_complete(client->data);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void sdma_dev_register(struct mpmc_device *mpmc,
+			      struct sdma_device *sdma)
+{
+	mutex_lock(&mpmc->devs_lock);
+	list_add(&sdma->item, &mpmc->sdma_devs);
+	mutex_unlock(&mpmc->devs_lock);
+}
+
+static void sdma_dev_unregister(struct sdma_device *sdma)
+{
+	struct mpmc_device *mpmc = sdma->parent;
+
+	mutex_lock(&mpmc->devs_lock);
+	list_del(&sdma->item);
+	mutex_unlock(&mpmc->devs_lock);
+}
+
+static void sdma_cleanup(struct device *dev)
+{
+	struct sdma_device *sdma = dev_get_drvdata(dev);
+
+	if (sdma->tx_irq)
+		free_irq(sdma->tx_irq, sdma);
+
+	if (sdma->rx_irq)
+		free_irq(sdma->rx_irq, sdma);
+
+	if (sdma->memregion.start)
+		release_mem_region(sdma->memregion.start,
+			sdma->memregion.end - sdma->memregion.start + 1);
+
+	if (sdma->ioaddr)
+		iounmap(sdma->ioaddr);
+
+	sdma_dev_unregister(sdma);
+	kfree(sdma);
+	dev_set_drvdata(dev, NULL);
+}
+
+static void mpmc_dev_register(struct mpmc_device *mpmc)
+{
+	mutex_lock(&mpmc_devs_lock);
+	list_add_tail(&mpmc->item, &mpmc_devs);
+	mutex_unlock(&mpmc_devs_lock);
+}
+
+static void mpmc_dev_unregister(struct mpmc_device *mpmc)
+{
+	mutex_lock(&mpmc_devs_lock);
+	list_del(&mpmc->item);
+	mutex_unlock(&mpmc_devs_lock);
+}
+
+static void mpmc_cleanup(struct device *dev)
+{
+	struct mpmc_device *mpmc = dev_get_drvdata(dev);
+
+	if (mpmc->registered)
+		mpmc_dev_unregister(mpmc);
+
+	kfree(mpmc);
+	dev_set_drvdata(dev, NULL);
+}
+
+static int __devinit sdma_init(struct device *dev, struct resource *rx_irq,
+			       struct resource *tx_irq, struct resource *mem,
+			       int phandle)
+{
+	struct sdma_device *sdma;
+	struct mpmc_device *mpmc;
+
+	resource_size_t region_size;
+	int res;
+
+	mpmc = dev_get_drvdata(dev->parent);
+
+	sdma = kzalloc(sizeof(struct sdma_device), GFP_KERNEL);
+	if (!sdma) {
+		dev_err(dev, "Cannot allocate SDMA device\n");
+		return -ENOMEM;
+	}
+	dev_set_drvdata(dev, sdma);
+	sdma->dev = dev;
+
+	spin_lock_init(&sdma->lock);
+	INIT_LIST_HEAD(&sdma->clients);
+	mutex_init(&sdma->clients_lock);
+	sdma->parent = mpmc;
+	sdma->phandle = phandle;
+
+	region_size = mem->end - mem->start + 1;
+	if (!request_mem_region(mem->start, region_size, DRV_NAME)) {
+		dev_err(dev, "I/O memory region at %p is busy\n",
+			(void *)mem->start);
+		return -EBUSY;
+	}
+	sdma->memregion = *mem;
+
+	sdma->ioaddr = ioremap(mem->start, region_size);
+	if (!sdma->ioaddr) {
+		dev_err(dev, "Cannot ioremap() I/O memory %p\n",
+			(void *)mem->start);
+		return -ENOMEM;
+	}
+
+	sdma_reset(sdma);
+
+	sdma->rx_irq = NO_IRQ;
+	if (rx_irq) {
+		res = request_irq(rx_irq->start, sdma_rx_intr,
+				IRQF_SHARED, "SDMA RX", sdma);
+		if (res) {
+			dev_err(dev, "Could not allocate RX interrupt %d.\n",
+				rx_irq->start);
+			return res;
+		}
+		sdma->rx_irq = rx_irq->start;
+	}
+
+	sdma->tx_irq = NO_IRQ;
+	if (tx_irq) {
+		res = request_irq(tx_irq->start, sdma_tx_intr,
+				IRQF_SHARED, "SDMA TX", sdma);
+		if (res) {
+			dev_err(dev, "Could not allocate TX interrupt %d.\n",
+				tx_irq->start);
+			return res;
+		}
+		sdma->tx_irq = tx_irq->start;
+	}
+
+	sdma->rx_ack = 1;
+	sdma->tx_ack = 1;
+	sdma_dev_register(mpmc, sdma);
+
+	return 0;
+}
+
+static int __devinit mpmc_init(struct device *dev)
+{
+	struct mpmc_device *mpmc;
+
+	mpmc = kzalloc(sizeof(struct mpmc_device), GFP_KERNEL);
+
+	if (!mpmc) {
+		dev_err(dev, "Cannot allocate MPMC device\n");
+		return -ENOMEM;
+	}
+
+	dev_set_drvdata(dev, mpmc);
+
+	INIT_LIST_HEAD(&mpmc->sdma_devs);
+	mutex_init(&mpmc->devs_lock);
+
+	mpmc_dev_register(mpmc);
+	mpmc->registered = 1;
+
+	return 0;
+}
+
+#ifdef CONFIG_OF
+static int sdma_of_remove(struct of_device *op)
+{
+	sdma_cleanup(&op->dev);
+	return 0;
+}
+
+/* Match table for of_platform binding */
+static struct of_device_id sdma_of_match[] = {
+	{ .compatible = "xlnx,ll-dma-1.00.a" },
+	{},
+};
+
+static int __devinit sdma_of_probe(struct of_device *op,
+				   const struct of_device_id *match)
+{
+	const int *prop;
+	int phandle;
+	struct resource rx_irq, tx_irq, mem;
+	struct resource *tx_irq_res = NULL;
+	struct resource *rx_irq_res = NULL;
+	int res;
+
+	res = of_address_to_resource(op->node, 0, &mem);
+	if (res) {
+		dev_err(&op->dev, "invalid address\n");
+		return res;
+	}
+
+	/* IRQ */
+	res = of_irq_to_resource(op->node, 0, &rx_irq);
+	if (res != NO_IRQ)
+		rx_irq_res = &rx_irq;
+
+	res = of_irq_to_resource(op->node, 1, &tx_irq);
+	if (res != NO_IRQ)
+		tx_irq_res = &tx_irq;
+
+	prop = of_get_property(op->node, "linux,phandle", NULL);
+	phandle = (prop) ? *prop : -1;
+
+	res = sdma_init(&op->dev, rx_irq_res, tx_irq_res, &mem, phandle);
+	if (res)
+		sdma_of_remove(op);
+
+	return res;
+}
+
+static struct of_platform_driver sdma_of_driver = {
+	.name		= "xilinx-sdma",
+	.match_table	= sdma_of_match,
+	.probe		= sdma_of_probe,
+	.remove		= sdma_of_remove,
+};
+
+int __init sdma_of_init(void)
+{
+	int ret;
+
+	ret = of_register_platform_driver(&sdma_of_driver);
+	if (ret) {
+		of_unregister_platform_driver(&sdma_of_driver);
+		printk(KERN_ERR "registering driver failed: err=%i", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+void sdma_of_exit(void)
+{
+	of_unregister_platform_driver(&sdma_of_driver);
+}
+
+static int mpmc_of_remove(struct of_device *op)
+{
+	struct device_node *node;
+	struct of_device *ofdev;
+
+	for_each_child_of_node(op->node, node) {
+		ofdev = of_find_device_by_node(node);
+		of_device_unregister(ofdev);
+		of_device_free(ofdev);
+	}
+
+	mpmc_cleanup(&op->dev);
+	return 0;
+}
+
+static int __devinit mpmc_of_probe(struct of_device *op,
+			const struct of_device_id *match)
+{
+	int err = mpmc_init(&op->dev);
+	if (err)
+		return err;
+
+	of_platform_bus_probe(op->node, sdma_of_match, &op->dev);
+	return 0;
+}
+
+static struct of_device_id  __devinitdata mpmc_of_match[] = {
+	{ .compatible = "xlnx,mpmc-4.01.a" },
+	{ .compatible = "xlnx,mpmc-4.03.a" },
+	{},
+};
+
+static struct of_platform_driver mpmc_of_driver = {
+	.name = "xilinx-mpmc",
+	.match_table = mpmc_of_match,
+	.probe = mpmc_of_probe,
+	.remove	= mpmc_of_remove,
+};
+
+int __init mpmc_of_init(void)
+{
+	return of_register_platform_driver(&mpmc_of_driver);
+}
+
+void mpmc_of_exit(void)
+{
+	of_unregister_platform_driver(&mpmc_of_driver);
+}
+
+subsys_initcall(mpmc_of_init);
+subsys_initcall(sdma_of_init);
+#else	/* CONFIG_OF */
+/*---------------------------------------------------------------------------
+ * Platform bus attachment
+ */
+
+static __devexit int sdma_plat_remove(struct platform_device *pdev)
+{
+	sdma_cleanup(&pdev->dev);
+	return 0;
+}
+
+static int __devinit sdma_plat_probe(struct platform_device *pdev)
+{
+	struct resource *rx_irq, *tx_irq, *mem;
+	int err = 0;
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem) {
+		dev_err(&pdev->dev, "invalid address\n");
+		err = -EINVAL;
+		goto fail;
+	}
+
+	/* RX interrupt is optional, and first */
+	rx_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+
+	/* TX interrupt is optional, and second */
+	tx_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 1);
+
+	err = sdma_init(&pdev->dev, rx_irq, tx_irq, mem, pdev->id);
+	if (err)
+		sdma_plat_remove(pdev);
+fail:
+	return err;
+}
+
+static struct platform_driver sdma_plat_driver = {
+	.probe = sdma_plat_probe,
+	.remove	= __devexit_p(sdma_plat_remove),
+	.driver = {
+		.owner = THIS_MODULE,
+		.name  = "xilinx-sdma",
+	},
+};
+
+int __init sdma_plat_init(void)
+{
+	int err = platform_driver_register(&sdma_plat_driver);
+	if (err) {
+		platform_driver_unregister(&sdma_plat_driver);
+		printk(KERN_ERR "registering driver failed: err=%i", err);
+		return err;
+	}
+
+	return 0;
+}
+subsys_initcall(sdma_plat_init);
+
+void sdma_plat_exit(void)
+{
+	platform_driver_unregister(&sdma_plat_driver);
+}
+
+static int mpmc_plat_probe(struct platform_device *pdev)
+{
+	return mpmc_init(&pdev->dev);
+}
+
+static int __devexit mpmc_plat_remove(struct platform_device *pdev)
+{
+	mpmc_cleanup(&pdev->dev);
+	return 0;
+}
+
+static struct platform_driver mpmc_plat_driver = {
+	.probe = mpmc_plat_probe,
+	.remove	= __devexit_p(mpmc_plat_remove),
+	.driver = {
+		.owner = THIS_MODULE,
+		.name  = "xilinx-mpmc",
+	},
+};
+
+int __init mpmc_plat_init(void)
+{
+	return platform_driver_register(&mpmc_plat_driver);
+}
+subsys_initcall(mpmc_plat_init);
+
+void mpmc_plat_exit(void)
+{
+	platform_driver_unregister(&mpmc_plat_driver);
+}
+#endif	/* CONFIG_OF */
diff -uprN a/include/linux/sdma.h b/include/linux/sdma.h
--- a/include/linux/sdma.h	1969-12-31 18:00:00.000000000 -0600
+++ b/include/linux/sdma.h	2010-04-20 11:18:55.000000000 -0500
@@ -0,0 +1,177 @@
+/*
+ * SDMA subsystem support for Xilinx MPMC.
+ *
+ * Author: Sergey Temerkhanov
+ *
+ * Copyright (c) 2008-2010 Cifronic ZAO
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ */
+
+#ifndef __SDMA_H__
+#define __SDMA_H__
+
+#include <linux/types.h>
+#include <linux/dma-mapping.h>
+
+#define SDMA_ALIGNMENT	0x40
+
+struct sdma_desc {
+	__be32 next;
+	__be32 address;
+	__be32 length;
+	__be32 stat_ctl;
+	__be32 app1;
+	__be32 app2;
+	__be32 app3;
+	__be32 app4;
+	void *virt;
+	u32 flags;
+} __attribute__((aligned(SDMA_ALIGNMENT)));
+
+
+enum {
+	SDMA_STSCTL_ERROR	= (1 << 31), /* DMA error */
+	SDMA_STSCTL_IOE		= (1 << 30), /* Interrupt on end */
+	SDMA_STSCTL_SOE		= (1 << 29), /* Stop on end */
+	SDMA_STSCTL_DONE	= (1 << 28), /* DMA completed */
+	SDMA_STSCTL_SOP		= (1 << 27), /* Start of packet */
+	SDMA_STSCTL_EOP		= (1 << 26), /* End of packet */
+	SDMA_STSCTL_BUSY	= (1 << 25), /* DMA busy */
+	SDMA_STSCTL_CSUM	= (1 << 0),  /* Checksum enable */
+
+	SDMA_STSCTL_MSK		= (0xFF << 24), /*Status/control field */
+};
+
+/* SDMA client operations */
+struct sdma_client {
+	void *data;
+	void (*tx_complete) (void *data);
+	void (*rx_complete) (void *data);
+	void (*error) (void *data);
+	void (*reset) (void *data);
+	struct list_head item;
+};
+
+struct sdma_coalesce {
+	int tx_threshold;
+	int tx_timeout;
+
+	int rx_threshold;
+	int rx_timeout;
+};
+
+#define DEFINE_SDMA_COALESCE(x) struct sdma_coalesce x = { \
+	.tx_timeout	= 0, \
+	.tx_threshold	= 1, \
+	.rx_timeout	= 0, \
+	.rx_threshold	= 1, };
+
+struct mpmc_device {
+	void __iomem		*ioaddr;
+
+	struct resource		memregion;
+	int			irq;
+
+	int			registered;
+	struct list_head	item;
+
+	struct mutex		devs_lock;
+	struct list_head	sdma_devs;
+};
+
+struct sdma_device {
+	struct device		*dev;
+	void __iomem		*ioaddr;
+	wait_queue_head_t 	wait;
+
+	spinlock_t		lock;
+
+	struct resource		memregion;
+	int			rx_irq;
+	int			tx_irq;
+	int			rx_ack;
+	int			tx_ack;
+	int			phandle;
+
+	int			registered;
+	struct mpmc_device	*parent;
+
+	struct sdma_coalesce	coal;
+	struct list_head	item;
+
+	struct mutex		clients_lock;
+	struct list_head	clients;
+};
+
+static inline void sdma_add_client(struct sdma_device *sdma,
+				   struct sdma_client *client)
+{
+	mutex_lock(&sdma->clients_lock);
+	list_add(&client->item, &sdma->clients);
+	mutex_unlock(&sdma->clients_lock);
+}
+
+static inline void sdma_del_client(struct sdma_device *sdma,
+				   struct sdma_client *client)
+{
+	mutex_lock(&sdma->clients_lock);
+	list_del(&client->item);
+	mutex_unlock(&sdma->clients_lock);
+}
+
+struct sdma_device *sdma_find_device(int phandle);
+void sdma_pause(struct sdma_device *sdma);
+void sdma_resume(struct sdma_device *sdma);
+void sdma_reset(struct sdma_device *sdma);
+void sdma_rx_init(struct sdma_device *sdma, dma_addr_t desc);
+void sdma_tx_init(struct sdma_device *sdma, dma_addr_t desc);
+
+int sdma_tx_submit(struct sdma_device *sdma, dma_addr_t desc);
+int sdma_rx_submit(struct sdma_device *sdma, dma_addr_t desc);
+
+void sdma_tx_irq_enable(struct sdma_device *sdma);
+void sdma_rx_irq_enable(struct sdma_device *sdma);
+void sdma_tx_irq_disable(struct sdma_device *sdma);
+void sdma_rx_irq_disable(struct sdma_device *sdma);
+void sdma_tx_irq_ack(struct sdma_device *sdma);
+void sdma_rx_irq_ack(struct sdma_device *sdma);
+
+int sdma_set_coalesce(struct sdma_device *sdma, struct sdma_coalesce *coal);
+int sdma_get_coalesce(struct sdma_device *sdma, struct sdma_coalesce *coal);
+
+static inline int sdma_desc_busy(struct sdma_desc *desc)
+{
+	return desc->stat_ctl & __constant_be32_to_cpu(SDMA_STSCTL_BUSY);
+}
+
+static inline int sdma_desc_done(struct sdma_desc *desc)
+{
+	return desc->stat_ctl & __constant_be32_to_cpu(SDMA_STSCTL_DONE);
+}
+
+static inline int sdma_desc_sop(struct sdma_desc *desc)
+{
+	return desc->stat_ctl & __constant_be32_to_cpu(SDMA_STSCTL_SOP);
+}
+
+static inline int sdma_desc_eop(struct sdma_desc *desc)
+{
+	return desc->stat_ctl & __constant_be32_to_cpu(SDMA_STSCTL_EOP);
+}
+
+static inline void sdma_set_ack(struct sdma_device *sdma, int rx_ack,
+				int tx_ack)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&sdma->lock, flags);
+	sdma->rx_ack = rx_ack;
+	sdma->tx_ack = tx_ack;
+	spin_unlock_irqrestore(&sdma->lock, flags);
+}
+
+#endif

--=-OhWFGnETH9EQeOfdCJBG--



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab1E2KMv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 06:12:51 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43018 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab1E2KMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 06:12:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=wmljlW0qvHv32LEWXwNAbBAOtlOcVYZqjpiHyrSilbbZZBDIvc97ms3svFF0XLiYp2
         i/y6FEzejRoxolZ0bEtF6T6gZussOeWcvc8RufpFNAdNEzvDGn6nHxckduo3v8sGqzPA
         epoJhAjxVj4CQh5VzxzjU+ry/INKeZE8PKq4k=
From: Mika Westerberg <mika.westerberg@iki.fi>
To: linux-arm-kernel@lists.infradead.org
Cc: hsweeten@visionengravers.com, rmallon@gmail.com, vinod.koul@intel.com,
        dan.j.williams@intel.com, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        Mika Westerberg <mika.westerberg@iki.fi>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/5] ep93xx: remove the old M2P DMA code
Date: Sun, 29 May 2011 13:10:05 +0300
Message-Id: <dbd5dc59c41c0c747d7d1e14d109d9c6323c2e21.1306662317.git.mika.westerberg@iki.fi>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <cover.1306662317.git.mika.westerberg@iki.fi>
References: <cover.1306662317.git.mika.westerberg@iki.fi>
In-Reply-To: <cover.1306662317.git.mika.westerberg@iki.fi>
References: <cover.1306662317.git.mika.westerberg@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we have converted all existing users of the old DMA API to use the DMA
engine API the old code can be dropped.

Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
Acked-by: Ryan Mallon <rmallon@gmail.com>
Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 arch/arm/mach-ep93xx/Makefile           |    2 +-
 arch/arm/mach-ep93xx/dma-m2p.c          |  411 -------------------------------
 arch/arm/mach-ep93xx/include/mach/dma.h |  143 -----------
 3 files changed, 1 insertions(+), 555 deletions(-)
 delete mode 100644 arch/arm/mach-ep93xx/dma-m2p.c

diff --git a/arch/arm/mach-ep93xx/Makefile b/arch/arm/mach-ep93xx/Makefile
index 4920f7a..21e721a 100644
--- a/arch/arm/mach-ep93xx/Makefile
+++ b/arch/arm/mach-ep93xx/Makefile
@@ -1,7 +1,7 @@
 #
 # Makefile for the linux kernel.
 #
-obj-y			:= core.o clock.o dma-m2p.o gpio.o
+obj-y			:= core.o clock.o gpio.o
 obj-m			:=
 obj-n			:=
 obj-			:=
diff --git a/arch/arm/mach-ep93xx/dma-m2p.c b/arch/arm/mach-ep93xx/dma-m2p.c
deleted file mode 100644
index a696d35..0000000
--- a/arch/arm/mach-ep93xx/dma-m2p.c
+++ /dev/null
@@ -1,411 +0,0 @@
-/*
- * arch/arm/mach-ep93xx/dma-m2p.c
- * M2P DMA handling for Cirrus EP93xx chips.
- *
- * Copyright (C) 2006 Lennert Buytenhek <buytenh@wantstofly.org>
- * Copyright (C) 2006 Applied Data Systems
- *
- * Copyright (C) 2009 Ryan Mallon <ryan@bluewatersys.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or (at
- * your option) any later version.
- */
-
-/*
- * On the EP93xx chip the following peripherals my be allocated to the 10
- * Memory to Internal Peripheral (M2P) channels (5 transmit + 5 receive).
- *
- *	I2S	contains 3 Tx and 3 Rx DMA Channels
- *	AAC	contains 3 Tx and 3 Rx DMA Channels
- *	UART1	contains 1 Tx and 1 Rx DMA Channels
- *	UART2	contains 1 Tx and 1 Rx DMA Channels
- *	UART3	contains 1 Tx and 1 Rx DMA Channels
- *	IrDA	contains 1 Tx and 1 Rx DMA Channels
- *
- * SSP and IDE use the Memory to Memory (M2M) channels and are not covered
- * with this implementation.
- */
-
-#define pr_fmt(fmt) "ep93xx " KBUILD_MODNAME ": " fmt
-
-#include <linux/kernel.h>
-#include <linux/clk.h>
-#include <linux/err.h>
-#include <linux/interrupt.h>
-#include <linux/module.h>
-#include <linux/io.h>
-
-#include <mach/dma.h>
-#include <mach/hardware.h>
-
-#define M2P_CONTROL			0x00
-#define  M2P_CONTROL_STALL_IRQ_EN	(1 << 0)
-#define  M2P_CONTROL_NFB_IRQ_EN		(1 << 1)
-#define  M2P_CONTROL_ERROR_IRQ_EN	(1 << 3)
-#define  M2P_CONTROL_ENABLE		(1 << 4)
-#define M2P_INTERRUPT			0x04
-#define  M2P_INTERRUPT_STALL		(1 << 0)
-#define  M2P_INTERRUPT_NFB		(1 << 1)
-#define  M2P_INTERRUPT_ERROR		(1 << 3)
-#define M2P_PPALLOC			0x08
-#define M2P_STATUS			0x0c
-#define M2P_REMAIN			0x14
-#define M2P_MAXCNT0			0x20
-#define M2P_BASE0			0x24
-#define M2P_MAXCNT1			0x30
-#define M2P_BASE1			0x34
-
-#define STATE_IDLE	0	/* Channel is inactive.  */
-#define STATE_STALL	1	/* Channel is active, no buffers pending.  */
-#define STATE_ON	2	/* Channel is active, one buffer pending.  */
-#define STATE_NEXT	3	/* Channel is active, two buffers pending.  */
-
-struct m2p_channel {
-	char				*name;
-	void __iomem			*base;
-	int				irq;
-
-	struct clk			*clk;
-	spinlock_t			lock;
-
-	void				*client;
-	unsigned			next_slot:1;
-	struct ep93xx_dma_buffer	*buffer_xfer;
-	struct ep93xx_dma_buffer	*buffer_next;
-	struct list_head		buffers_pending;
-};
-
-static struct m2p_channel m2p_rx[] = {
-	{"m2p1", EP93XX_DMA_BASE + 0x0040, IRQ_EP93XX_DMAM2P1},
-	{"m2p3", EP93XX_DMA_BASE + 0x00c0, IRQ_EP93XX_DMAM2P3},
-	{"m2p5", EP93XX_DMA_BASE + 0x0200, IRQ_EP93XX_DMAM2P5},
-	{"m2p7", EP93XX_DMA_BASE + 0x0280, IRQ_EP93XX_DMAM2P7},
-	{"m2p9", EP93XX_DMA_BASE + 0x0300, IRQ_EP93XX_DMAM2P9},
-	{NULL},
-};
-
-static struct m2p_channel m2p_tx[] = {
-	{"m2p0", EP93XX_DMA_BASE + 0x0000, IRQ_EP93XX_DMAM2P0},
-	{"m2p2", EP93XX_DMA_BASE + 0x0080, IRQ_EP93XX_DMAM2P2},
-	{"m2p4", EP93XX_DMA_BASE + 0x0240, IRQ_EP93XX_DMAM2P4},
-	{"m2p6", EP93XX_DMA_BASE + 0x02c0, IRQ_EP93XX_DMAM2P6},
-	{"m2p8", EP93XX_DMA_BASE + 0x0340, IRQ_EP93XX_DMAM2P8},
-	{NULL},
-};
-
-static void feed_buf(struct m2p_channel *ch, struct ep93xx_dma_buffer *buf)
-{
-	if (ch->next_slot == 0) {
-		writel(buf->size, ch->base + M2P_MAXCNT0);
-		writel(buf->bus_addr, ch->base + M2P_BASE0);
-	} else {
-		writel(buf->size, ch->base + M2P_MAXCNT1);
-		writel(buf->bus_addr, ch->base + M2P_BASE1);
-	}
-	ch->next_slot ^= 1;
-}
-
-static void choose_buffer_xfer(struct m2p_channel *ch)
-{
-	struct ep93xx_dma_buffer *buf;
-
-	ch->buffer_xfer = NULL;
-	if (!list_empty(&ch->buffers_pending)) {
-		buf = list_entry(ch->buffers_pending.next,
-				 struct ep93xx_dma_buffer, list);
-		list_del(&buf->list);
-		feed_buf(ch, buf);
-		ch->buffer_xfer = buf;
-	}
-}
-
-static void choose_buffer_next(struct m2p_channel *ch)
-{
-	struct ep93xx_dma_buffer *buf;
-
-	ch->buffer_next = NULL;
-	if (!list_empty(&ch->buffers_pending)) {
-		buf = list_entry(ch->buffers_pending.next,
-				 struct ep93xx_dma_buffer, list);
-		list_del(&buf->list);
-		feed_buf(ch, buf);
-		ch->buffer_next = buf;
-	}
-}
-
-static inline void m2p_set_control(struct m2p_channel *ch, u32 v)
-{
-	/*
-	 * The control register must be read immediately after being written so
-	 * that the internal state machine is correctly updated. See the ep93xx
-	 * users' guide for details.
-	 */
-	writel(v, ch->base + M2P_CONTROL);
-	readl(ch->base + M2P_CONTROL);
-}
-
-static inline int m2p_channel_state(struct m2p_channel *ch)
-{
-	return (readl(ch->base + M2P_STATUS) >> 4) & 0x3;
-}
-
-static irqreturn_t m2p_irq(int irq, void *dev_id)
-{
-	struct m2p_channel *ch = dev_id;
-	struct ep93xx_dma_m2p_client *cl;
-	u32 irq_status, v;
-	int error = 0;
-
-	cl = ch->client;
-
-	spin_lock(&ch->lock);
-	irq_status = readl(ch->base + M2P_INTERRUPT);
-
-	if (irq_status & M2P_INTERRUPT_ERROR) {
-		writel(M2P_INTERRUPT_ERROR, ch->base + M2P_INTERRUPT);
-		error = 1;
-	}
-
-	if ((irq_status & (M2P_INTERRUPT_STALL | M2P_INTERRUPT_NFB)) == 0) {
-		spin_unlock(&ch->lock);
-		return IRQ_NONE;
-	}
-
-	switch (m2p_channel_state(ch)) {
-	case STATE_IDLE:
-		pr_crit("dma interrupt without a dma buffer\n");
-		BUG();
-		break;
-
-	case STATE_STALL:
-		cl->buffer_finished(cl->cookie, ch->buffer_xfer, 0, error);
-		if (ch->buffer_next != NULL) {
-			cl->buffer_finished(cl->cookie, ch->buffer_next,
-					    0, error);
-		}
-		choose_buffer_xfer(ch);
-		choose_buffer_next(ch);
-		if (ch->buffer_xfer != NULL)
-			cl->buffer_started(cl->cookie, ch->buffer_xfer);
-		break;
-
-	case STATE_ON:
-		cl->buffer_finished(cl->cookie, ch->buffer_xfer, 0, error);
-		ch->buffer_xfer = ch->buffer_next;
-		choose_buffer_next(ch);
-		cl->buffer_started(cl->cookie, ch->buffer_xfer);
-		break;
-
-	case STATE_NEXT:
-		pr_crit("dma interrupt while next\n");
-		BUG();
-		break;
-	}
-
-	v = readl(ch->base + M2P_CONTROL) & ~(M2P_CONTROL_STALL_IRQ_EN |
-					      M2P_CONTROL_NFB_IRQ_EN);
-	if (ch->buffer_xfer != NULL)
-		v |= M2P_CONTROL_STALL_IRQ_EN;
-	if (ch->buffer_next != NULL)
-		v |= M2P_CONTROL_NFB_IRQ_EN;
-	m2p_set_control(ch, v);
-
-	spin_unlock(&ch->lock);
-	return IRQ_HANDLED;
-}
-
-static struct m2p_channel *find_free_channel(struct ep93xx_dma_m2p_client *cl)
-{
-	struct m2p_channel *ch;
-	int i;
-
-	if (cl->flags & EP93XX_DMA_M2P_RX)
-		ch = m2p_rx;
-	else
-		ch = m2p_tx;
-
-	for (i = 0; ch[i].base; i++) {
-		struct ep93xx_dma_m2p_client *client;
-
-		client = ch[i].client;
-		if (client != NULL) {
-			int port;
-
-			port = cl->flags & EP93XX_DMA_M2P_PORT_MASK;
-			if (port == (client->flags &
-				     EP93XX_DMA_M2P_PORT_MASK)) {
-				pr_warning("DMA channel already used by %s\n",
-					   cl->name ? : "unknown client");
-				return ERR_PTR(-EBUSY);
-			}
-		}
-	}
-
-	for (i = 0; ch[i].base; i++) {
-		if (ch[i].client == NULL)
-			return ch + i;
-	}
-
-	pr_warning("No free DMA channel for %s\n",
-		   cl->name ? : "unknown client");
-	return ERR_PTR(-ENODEV);
-}
-
-static void channel_enable(struct m2p_channel *ch)
-{
-	struct ep93xx_dma_m2p_client *cl = ch->client;
-	u32 v;
-
-	clk_enable(ch->clk);
-
-	v = cl->flags & EP93XX_DMA_M2P_PORT_MASK;
-	writel(v, ch->base + M2P_PPALLOC);
-
-	v = cl->flags & EP93XX_DMA_M2P_ERROR_MASK;
-	v |= M2P_CONTROL_ENABLE | M2P_CONTROL_ERROR_IRQ_EN;
-	m2p_set_control(ch, v);
-}
-
-static void channel_disable(struct m2p_channel *ch)
-{
-	u32 v;
-
-	v = readl(ch->base + M2P_CONTROL);
-	v &= ~(M2P_CONTROL_STALL_IRQ_EN | M2P_CONTROL_NFB_IRQ_EN);
-	m2p_set_control(ch, v);
-
-	while (m2p_channel_state(ch) >= STATE_ON)
-		cpu_relax();
-
-	m2p_set_control(ch, 0x0);
-
-	while (m2p_channel_state(ch) == STATE_STALL)
-		cpu_relax();
-
-	clk_disable(ch->clk);
-}
-
-int ep93xx_dma_m2p_client_register(struct ep93xx_dma_m2p_client *cl)
-{
-	struct m2p_channel *ch;
-	int err;
-
-	ch = find_free_channel(cl);
-	if (IS_ERR(ch))
-		return PTR_ERR(ch);
-
-	err = request_irq(ch->irq, m2p_irq, 0, cl->name ? : "dma-m2p", ch);
-	if (err)
-		return err;
-
-	ch->client = cl;
-	ch->next_slot = 0;
-	ch->buffer_xfer = NULL;
-	ch->buffer_next = NULL;
-	INIT_LIST_HEAD(&ch->buffers_pending);
-
-	cl->channel = ch;
-
-	channel_enable(ch);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ep93xx_dma_m2p_client_register);
-
-void ep93xx_dma_m2p_client_unregister(struct ep93xx_dma_m2p_client *cl)
-{
-	struct m2p_channel *ch = cl->channel;
-
-	channel_disable(ch);
-	free_irq(ch->irq, ch);
-	ch->client = NULL;
-}
-EXPORT_SYMBOL_GPL(ep93xx_dma_m2p_client_unregister);
-
-void ep93xx_dma_m2p_submit(struct ep93xx_dma_m2p_client *cl,
-			   struct ep93xx_dma_buffer *buf)
-{
-	struct m2p_channel *ch = cl->channel;
-	unsigned long flags;
-	u32 v;
-
-	spin_lock_irqsave(&ch->lock, flags);
-	v = readl(ch->base + M2P_CONTROL);
-	if (ch->buffer_xfer == NULL) {
-		ch->buffer_xfer = buf;
-		feed_buf(ch, buf);
-		cl->buffer_started(cl->cookie, buf);
-
-		v |= M2P_CONTROL_STALL_IRQ_EN;
-		m2p_set_control(ch, v);
-
-	} else if (ch->buffer_next == NULL) {
-		ch->buffer_next = buf;
-		feed_buf(ch, buf);
-
-		v |= M2P_CONTROL_NFB_IRQ_EN;
-		m2p_set_control(ch, v);
-	} else {
-		list_add_tail(&buf->list, &ch->buffers_pending);
-	}
-	spin_unlock_irqrestore(&ch->lock, flags);
-}
-EXPORT_SYMBOL_GPL(ep93xx_dma_m2p_submit);
-
-void ep93xx_dma_m2p_submit_recursive(struct ep93xx_dma_m2p_client *cl,
-				     struct ep93xx_dma_buffer *buf)
-{
-	struct m2p_channel *ch = cl->channel;
-
-	list_add_tail(&buf->list, &ch->buffers_pending);
-}
-EXPORT_SYMBOL_GPL(ep93xx_dma_m2p_submit_recursive);
-
-void ep93xx_dma_m2p_flush(struct ep93xx_dma_m2p_client *cl)
-{
-	struct m2p_channel *ch = cl->channel;
-
-	channel_disable(ch);
-	ch->next_slot = 0;
-	ch->buffer_xfer = NULL;
-	ch->buffer_next = NULL;
-	INIT_LIST_HEAD(&ch->buffers_pending);
-	channel_enable(ch);
-}
-EXPORT_SYMBOL_GPL(ep93xx_dma_m2p_flush);
-
-static int init_channel(struct m2p_channel *ch)
-{
-	ch->clk = clk_get(NULL, ch->name);
-	if (IS_ERR(ch->clk))
-		return PTR_ERR(ch->clk);
-
-	spin_lock_init(&ch->lock);
-	ch->client = NULL;
-
-	return 0;
-}
-
-static int __init ep93xx_dma_m2p_init(void)
-{
-	int i;
-	int ret;
-
-	for (i = 0; m2p_rx[i].base; i++) {
-		ret = init_channel(m2p_rx + i);
-		if (ret)
-			return ret;
-	}
-
-	for (i = 0; m2p_tx[i].base; i++) {
-		ret = init_channel(m2p_tx + i);
-		if (ret)
-			return ret;
-	}
-
-	pr_info("M2P DMA subsystem initialized\n");
-	return 0;
-}
-arch_initcall(ep93xx_dma_m2p_init);
diff --git a/arch/arm/mach-ep93xx/include/mach/dma.h b/arch/arm/mach-ep93xx/include/mach/dma.h
index 6e7049a..46d4d87 100644
--- a/arch/arm/mach-ep93xx/include/mach/dma.h
+++ b/arch/arm/mach-ep93xx/include/mach/dma.h
@@ -1,153 +1,10 @@
-/**
- * DOC: EP93xx DMA M2P memory to peripheral and peripheral to memory engine
- *
- * The EP93xx DMA M2P subsystem handles DMA transfers between memory and
- * peripherals. DMA M2P channels are available for audio, UARTs and IrDA.
- * See chapter 10 of the EP93xx users guide for full details on the DMA M2P
- * engine.
- *
- * See sound/soc/ep93xx/ep93xx-pcm.c for an example use of the DMA M2P code.
- *
- */
-
 #ifndef __ASM_ARCH_DMA_H
 #define __ASM_ARCH_DMA_H
 
-#include <linux/list.h>
 #include <linux/types.h>
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
 
-/**
- * struct ep93xx_dma_buffer - Information about a buffer to be transferred
- * using the DMA M2P engine
- *
- * @list: Entry in DMA buffer list
- * @bus_addr: Physical address of the buffer
- * @size: Size of the buffer in bytes
- */
-struct ep93xx_dma_buffer {
-	struct list_head	list;
-	u32			bus_addr;
-	u16			size;
-};
-
-/**
- * struct ep93xx_dma_m2p_client - Information about a DMA M2P client
- *
- * @name: Unique name for this client
- * @flags: Client flags
- * @cookie: User data to pass to callback functions
- * @buffer_started: Non NULL function to call when a transfer is started.
- * 			The arguments are the user data cookie and the DMA
- *			buffer which is starting.
- * @buffer_finished: Non NULL function to call when a transfer is completed.
- *			The arguments are the user data cookie, the DMA buffer
- *			which has completed, and a boolean flag indicating if
- *			the transfer had an error.
- */
-struct ep93xx_dma_m2p_client {
-	char			*name;
-	u8			flags;
-	void			*cookie;
-	void			(*buffer_started)(void *cookie,
-					struct ep93xx_dma_buffer *buf);
-	void			(*buffer_finished)(void *cookie,
-					struct ep93xx_dma_buffer *buf,
-					int bytes, int error);
-
-	/* private: Internal use only */
-	void			*channel;
-};
-
-/* DMA M2P ports */
-#define EP93XX_DMA_M2P_PORT_I2S1	0x00
-#define EP93XX_DMA_M2P_PORT_I2S2	0x01
-#define EP93XX_DMA_M2P_PORT_AAC1	0x02
-#define EP93XX_DMA_M2P_PORT_AAC2	0x03
-#define EP93XX_DMA_M2P_PORT_AAC3	0x04
-#define EP93XX_DMA_M2P_PORT_I2S3	0x05
-#define EP93XX_DMA_M2P_PORT_UART1	0x06
-#define EP93XX_DMA_M2P_PORT_UART2	0x07
-#define EP93XX_DMA_M2P_PORT_UART3	0x08
-#define EP93XX_DMA_M2P_PORT_IRDA	0x09
-#define EP93XX_DMA_M2P_PORT_MASK	0x0f
-
-/* DMA M2P client flags */
-#define EP93XX_DMA_M2P_TX		0x00	/* Memory to peripheral */
-#define EP93XX_DMA_M2P_RX		0x10	/* Peripheral to memory */
-
-/*
- * DMA M2P client error handling flags. See the EP93xx users guide
- * documentation on the DMA M2P CONTROL register for more details
- */
-#define EP93XX_DMA_M2P_ABORT_ON_ERROR	0x20	/* Abort on peripheral error */
-#define EP93XX_DMA_M2P_IGNORE_ERROR	0x40	/* Ignore peripheral errors */
-#define EP93XX_DMA_M2P_ERROR_MASK	0x60	/* Mask of error bits */
-
-/**
- * ep93xx_dma_m2p_client_register - Register a client with the DMA M2P
- * subsystem
- *
- * @m2p: Client information to register
- * returns 0 on success
- *
- * The DMA M2P subsystem allocates a channel and an interrupt line for the DMA
- * client
- */
-int ep93xx_dma_m2p_client_register(struct ep93xx_dma_m2p_client *m2p);
-
-/**
- * ep93xx_dma_m2p_client_unregister - Unregister a client from the DMA M2P
- * subsystem
- *
- * @m2p: Client to unregister
- *
- * Any transfers currently in progress will be completed in hardware, but
- * ignored in software.
- */
-void ep93xx_dma_m2p_client_unregister(struct ep93xx_dma_m2p_client *m2p);
-
-/**
- * ep93xx_dma_m2p_submit - Submit a DMA M2P transfer
- *
- * @m2p: DMA Client to submit the transfer on
- * @buf: DMA Buffer to submit
- *
- * If the current or next transfer positions are free on the M2P client then
- * the transfer is started immediately. If not, the transfer is added to the
- * list of pending transfers. This function must not be called from the
- * buffer_finished callback for an M2P channel.
- *
- */
-void ep93xx_dma_m2p_submit(struct ep93xx_dma_m2p_client *m2p,
-			   struct ep93xx_dma_buffer *buf);
-
-/**
- * ep93xx_dma_m2p_submit_recursive - Put a DMA transfer on the pending list
- * for an M2P channel
- *
- * @m2p: DMA Client to submit the transfer on
- * @buf: DMA Buffer to submit
- *
- * This function must only be called from the buffer_finished callback for an
- * M2P channel. It is commonly used to add the next transfer in a chained list
- * of DMA transfers.
- */
-void ep93xx_dma_m2p_submit_recursive(struct ep93xx_dma_m2p_client *m2p,
-				     struct ep93xx_dma_buffer *buf);
-
-/**
- * ep93xx_dma_m2p_flush - Flush all pending transfers on a DMA M2P client
- *
- * @m2p: DMA client to flush transfers on
- *
- * Any transfers currently in progress will be completed in hardware, but
- * ignored in software.
- *
- */
-void ep93xx_dma_m2p_flush(struct ep93xx_dma_m2p_client *m2p);
-
 /*
  * M2P channels.
  *
-- 
1.7.4.4


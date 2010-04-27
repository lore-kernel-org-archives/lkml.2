Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab0D0WHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 18:07:01 -0400
Received: from forward3.mail.yandex.net ([77.88.46.8]:54235 "EHLO
	forward3.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab0D0WHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 18:07:00 -0400
From: Sergey Temerkhanov <temerkhanov@yandex.ru>
To: linuxppc-dev@lists.ozlabs.org, Grant Likely <grant.likely@secretlab.ca>,
       microblaze-uclinux@itee.uq.edu.au,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCHv2] [RFC] Xilinx MPMC SDMA subsystem
Date: Wed, 28 Apr 2010 02:06:38 +0400
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-desktop; KDE/4.3.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_u/11LoShh+gaCF6"
Message-Id: <201004280206.38220.temerkhanov@yandex.ru>
X-Yandex-TimeMark: 1272406018
X-Yandex-Spam: 1
X-Yandex-Front: smtp3.mail.yandex.net
X-Yandex-Suid-Status: 1 0,1 0,1 0,1 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_u/11LoShh+gaCF6
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is the 2nd version of Xilinx MPMC LocalLink SDMA subsystem

Changelog v2:
* Changed the functions and struct definition prefix from sdma_ to xllsdma_
* Platform bus bindings and various changes by Steven J. Magnani.
* Moved source files from arch/powerpc/sysdev to global locations and added
  CONFIG_XLLSDMA option.

Regards, Sergey Temerkhanov,
Cifronic ZAO

--Boundary-00=_u/11LoShh+gaCF6
Content-Type: text/x-patch;
  charset="UTF-8";
  name="sdma.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="sdma.patch"

diff -r baced9e29ab5 drivers/dma/Kconfig
--- a/drivers/dma/Kconfig	Tue Apr 27 20:48:50 2010 +0400
+++ b/drivers/dma/Kconfig	Wed Apr 28 02:00:51 2010 +0400
@@ -97,6 +97,14 @@
 	  Support the TXx9 SoC internal DMA controller.  This can be
 	  integrated in chips such as the Toshiba TX4927/38/39.
 
+config XLLSDMA
+	bool "Xilinx MPMC DMA support"
+	depends on XILINX_VIRTEX || MICROBLAZE
+	select DMA_ENGINE
+	help
+	  Support fot Xilinx MPMC LocalLink SDMA. Virtex FPGA family
+	  has it integrated or fabric-based.
+
 config DMA_ENGINE
 	bool
 
@@ -133,3 +141,5 @@
 	  DMA Device driver.
 
 endif
+
+
diff -r baced9e29ab5 drivers/dma/Makefile
--- a/drivers/dma/Makefile	Tue Apr 27 20:48:50 2010 +0400
+++ b/drivers/dma/Makefile	Wed Apr 28 02:00:51 2010 +0400
@@ -10,3 +10,4 @@
 obj-$(CONFIG_AT_HDMAC) += at_hdmac.o
 obj-$(CONFIG_MX3_IPU) += ipu/
 obj-$(CONFIG_TXX9_DMAC) += txx9dmac.o
+obj-$(CONFIG_XLLSDMA) += xllsdma.o
diff -r baced9e29ab5 drivers/dma/xllsdma.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/drivers/dma/xllsdma.c	Wed Apr 28 02:00:51 2010 +0400
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
+#include <linux/xllsdma.h>
+
+#include <linux/of_device.h>
+#include <linux/of_platform.h>
+
+#define DRV_VERSION "0.1.0"
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
+	XLLSDMA_TX_REGS	= 0x00,	/* TX channel registers beginning */
+	XLLSDMA_RX_REGS	= 0x20,	/* RX channel registers beginning */
+	XLLSDMA_DMACR	= 0x40,	/* DMA control register */
+
+	XLLSDMA_NDESCR	= 0x00,	/* Next descriptor address */
+	XLLSDMA_BUFA	= 0x04,	/* Current buffer address */
+	XLLSDMA_BUFL	= 0x08,	/* Current buffer length */
+	XLLSDMA_CDESCR	= 0x0C,	/* Current descriptor address */
+	XLLSDMA_TDESCR	= 0x10,	/* Tail descriptor address */
+	XLLSDMA_CR	= 0x14,	/* Channel control */
+	XLLSDMA_IRQ	= 0x18,	/* Interrupt register */
+	XLLSDMA_SR	= 0x1C,	/* Status */
+};
+
+enum {
+	XLLSDMA_CR_IRQ_TIMEOUT_MSK   = (0xFF << 24),	/* Interrupt coalesce timeout */
+	XLLSDMA_CR_IRQ_THRESHOLD_MSK = (0xFF << 16),	/* Interrupt coalesce count */
+	XLLSDMA_CR_MSB_ADDR_MSK	     = (0xF << 12),	/* MSB for 36 bit addressing */
+	XLLSDMA_CR_APP_EN	  = (1 << 11),	/* Application data mask enable */
+	XLLSDMA_CR_1_BIT_CNT	  = (1 << 10),	/* All interrupt counters are 1-bit */
+	XLLSDMA_CR_INT_ON_END	  = (1 << 9),	/* Interrupt-on-end */
+	XLLSDMA_CR_LD_IRQ_CNT	  = (1 << 8),	/* Load IRQ_COUNT */
+	XLLSDMA_CR_IRQ_EN	  = (1 << 7),	/* Master interrupt enable */
+	XLLSDMA_CR_IRQ_ERROR	  = (1 << 2),	/* Error interrupt enable */
+	XLLSDMA_CR_IRQ_TIMEOUT	  = (1 << 1),	/* Coalesce timeout interrupt enable */
+	XLLSDMA_CR_IRQ_THRESHOLD  = (1 << 0),	/* Coalesce threshold interrupt enable */
+
+	XLLSDMA_CR_IRQ_ALL	  = XLLSDMA_CR_IRQ_EN | XLLSDMA_CR_IRQ_ERROR |
+					XLLSDMA_CR_IRQ_TIMEOUT | XLLSDMA_CR_IRQ_THRESHOLD,
+
+	XLLSDMA_CR_IRQ_TIMEOUT_SH   = 24,
+	XLLSDMA_CR_IRQ_THRESHOLD_SH = 16,
+	XLLSDMA_CR_MSB_ADDR_SH	    = 12,
+
+	XLLSDMA_IRQ_WRQ_EMPTY	 = (1 << 14),	/* Write Command Queue Empty (rx) */
+	XLLSDMA_IRQ_PLB_RD_ERROR = (1 << 4),	/* PLB Read Error IRQ */
+	XLLSDMA_IRQ_PLB_WR_ERROR = (1 << 3),	/* PLB Write Error IRQ */
+	XLLSDMA_IRQ_ERROR	 = (1 << 2),	/* Error IRQ */
+	XLLSDMA_IRQ_TIMEOUT	 = (1 << 1),	/* Coalesce timeout IRQ */
+	XLLSDMA_IRQ_THRESHOLD	 = (1 << 0),	/* Coalesce threshold IRQ */
+
+	XLLSDMA_IRQ_ALL_ERR	 = 0x1C,	/* All error interrupt */
+	XLLSDMA_IRQ_ALL		 = 0x1F,	/* All interrupt bits */
+	XLLSDMA_IRQ_ALL_DONE	 = 0x3,		/* All work complete interrupt bits */
+
+
+#define XLLSDMA_IRQ_COALESCE_COUNT(x)	((x >> 10) & 0xF)
+#define XLLSDMA_IRQ_DELAY_COUNT(x)		((x >> 8) & 0x3)
+
+	XLLSDMA_SR_ERR_TDESCR	 = (1 << 21),	/* Tail descriptor pointer is invalid */
+	XLLSDMA_SR_ERR_CMPL	 = (1 << 20),	/* Complete bit is set */
+	XLLSDMA_SR_ERR_BUFA	 = (1 << 19),	/* Buffer address is invalid */
+	XLLSDMA_SR_ERR_NDESCR	 = (1 << 18),	/* Next descriptor pointer is invalid */
+	XLLSDMA_SR_ERR_CDESCR	 = (1 << 17),	/* Current descriptor pointer is invalid */
+	XLLSDMA_SR_ERR_BUSYWR	 = (1 << 16),	/* Current descriptor modified */
+	XLLSDMA_SR_ERROR	 = (1 << 7),	/* Error IRQ has occurred */
+	XLLSDMA_SR_IRQ_ON_END	 = (1 << 6),	/* On-end IRQ has occurred */
+	XLLSDMA_SR_STOP_ON_END	 = (1 << 5), 	/* Stop on end has occurred */
+	XLLSDMA_SR_COMPLETED	 = (1 << 4),	/* BD completed */
+	XLLSDMA_SR_SOP		 = (1 << 3),	/* Current BD has SOP set */
+	XLLSDMA_SR_EOP		 = (1 << 2),	/* Current BD has EOP set */
+	XLLSDMA_SR_ENGINE_BUSY	 = (1 << 1),	/* Channel is busy */
+	
+
+	XLLSDMA_DMACR_TX_PAUSE	  = (1 << 29),	/* Pause TX channel */
+	XLLSDMA_DMACR_RX_PAUSE	  = (1 << 28),	/* Pause RX channel */
+	XLLSDMA_DMACR_PLB_ERR_DIS = (1 << 5),	/* Disable PLB error detection */
+	XLLSDMA_DMACR_RX_OVF_DIS  = (1 << 4),	/* Disable error on RX coalesce counter overflows */
+	XLLSDMA_DMACR_TX_OVF_DIS  = (1 << 3),	/* Disable error on TX coalesce counter overflows */
+	XLLSDMA_DMACR_TAIL_PTR_EN = (1 << 2),	/* Enable use of tail pointer register */
+	XLLSDMA_DMACR_EN_ARB_HOLD = (1 << 1),	/* Enable arbitration hold */
+	XLLSDMA_DMACR_RESET	  = (1 << 0),	/* Reset both channels */
+};
+
+static inline void xllsdma_write_cr(struct xllsdma_device *sdma, u32 value)
+{
+	out_be32(sdma->ioaddr + XLLSDMA_DMACR, value);
+}
+
+static inline u32 xllsdma_read_cr(struct xllsdma_device *sdma)
+{
+	return in_be32(sdma->ioaddr + XLLSDMA_DMACR);
+}
+
+static inline void xllsdma_tx_out32(struct xllsdma_device *sdma, int reg, u32 value)
+{
+	out_be32(sdma->ioaddr + reg + XLLSDMA_TX_REGS, value);
+}
+
+static inline u32 xllsdma_tx_in32(struct xllsdma_device *sdma, int reg)
+{
+	return in_be32(sdma->ioaddr + reg + XLLSDMA_TX_REGS);
+}
+
+static inline void xllsdma_rx_out32(struct xllsdma_device *sdma, int reg, u32 value)
+{
+	out_be32(sdma->ioaddr + reg + XLLSDMA_RX_REGS, value);
+}
+
+static inline u32 xllsdma_rx_in32(struct xllsdma_device *sdma, int reg)
+{
+	return in_be32(sdma->ioaddr + reg + XLLSDMA_RX_REGS);
+}
+
+void xllsdma_reset(struct xllsdma_device *sdma)
+{
+	u32 rx_cr, tx_cr, rx_irq, tx_irq;
+
+	unsigned long flags;
+	struct xllsdma_client *client, *tmp;
+
+	DEFINE_XLLSDMA_COALESCE(coal);
+	spin_lock_irqsave(&sdma->lock, flags);
+
+	xllsdma_write_cr(sdma, XLLSDMA_DMACR_RESET);
+
+	while (xllsdma_read_cr(sdma) & XLLSDMA_DMACR_RESET)
+		udelay(100);
+
+	rx_cr = xllsdma_rx_in32(sdma, XLLSDMA_CR);
+	tx_cr = xllsdma_tx_in32(sdma, XLLSDMA_CR);
+
+	xllsdma_rx_out32(sdma, XLLSDMA_CR, rx_cr & ~XLLSDMA_CR_IRQ_ALL);
+	xllsdma_tx_out32(sdma, XLLSDMA_CR, tx_cr & ~XLLSDMA_CR_IRQ_ALL);
+
+	rx_irq = xllsdma_rx_in32(sdma, XLLSDMA_IRQ);
+	tx_irq = xllsdma_tx_in32(sdma, XLLSDMA_IRQ);
+
+	xllsdma_rx_out32(sdma, XLLSDMA_IRQ, rx_irq);
+	xllsdma_tx_out32(sdma, XLLSDMA_IRQ, tx_irq);
+
+	xllsdma_write_cr(sdma, XLLSDMA_DMACR_TAIL_PTR_EN |
+		XLLSDMA_DMACR_RX_OVF_DIS | XLLSDMA_DMACR_TX_OVF_DIS);
+
+	if (sdma->rx_irq != NO_IRQ) {
+		xllsdma_rx_out32(sdma, XLLSDMA_CR,
+			      rx_cr | (XLLSDMA_CR_IRQ_ALL & ~XLLSDMA_CR_IRQ_EN));
+
+		rx_cr = xllsdma_rx_in32(sdma, XLLSDMA_CR);
+		xllsdma_rx_out32(sdma, XLLSDMA_CR, rx_cr | XLLSDMA_CR_IRQ_EN);
+	}
+
+	if (sdma->tx_irq != NO_IRQ) {
+		xllsdma_tx_out32(sdma, XLLSDMA_CR,
+			      tx_cr | (XLLSDMA_CR_IRQ_ALL & ~XLLSDMA_CR_IRQ_EN));
+		tx_cr = xllsdma_tx_in32(sdma, XLLSDMA_CR);
+		xllsdma_tx_out32(sdma, XLLSDMA_CR, tx_cr | XLLSDMA_CR_IRQ_EN);
+	}
+
+	spin_unlock_irqrestore(&sdma->lock, flags);
+
+	list_for_each_entry_safe(client, tmp, &sdma->clients, item)
+		if (likely(client->reset))
+			client->reset(client->data);
+
+	xllsdma_set_coalesce(sdma, &coal);
+}
+EXPORT_SYMBOL_GPL(xllsdma_reset);
+
+void xllsdma_tx_irq_enable(struct xllsdma_device *sdma)
+{
+	u32 tx_cr;
+	unsigned long flags;
+
+	BUG_ON(sdma->tx_irq == NO_IRQ);
+
+	spin_lock_irqsave(&sdma->lock, flags);
+	tx_cr = xllsdma_tx_in32(sdma, XLLSDMA_CR);
+	xllsdma_tx_out32(sdma, XLLSDMA_CR, tx_cr | XLLSDMA_CR_IRQ_EN);
+	spin_unlock_irqrestore(&sdma->lock, flags);
+}
+EXPORT_SYMBOL_GPL(xllsdma_tx_irq_enable);
+
+void xllsdma_rx_irq_enable(struct xllsdma_device *sdma)
+{
+	u32 rx_cr;
+	unsigned long flags;
+
+	BUG_ON(sdma->rx_irq == NO_IRQ);
+
+	spin_lock_irqsave(&sdma->lock, flags);
+	rx_cr = xllsdma_rx_in32(sdma, XLLSDMA_CR);
+	xllsdma_rx_out32(sdma, XLLSDMA_CR, rx_cr | XLLSDMA_CR_IRQ_EN);
+	spin_unlock_irqrestore(&sdma->lock, flags);
+}
+EXPORT_SYMBOL_GPL(xllsdma_rx_irq_enable);
+
+void xllsdma_tx_irq_disable(struct xllsdma_device *sdma)
+{
+	u32 tx_cr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sdma->lock, flags);
+	tx_cr = xllsdma_tx_in32(sdma, XLLSDMA_CR);
+	xllsdma_tx_out32(sdma, XLLSDMA_CR, tx_cr & ~XLLSDMA_CR_IRQ_EN);
+	spin_unlock_irqrestore(&sdma->lock, flags);
+}
+EXPORT_SYMBOL_GPL(xllsdma_tx_irq_disable);
+
+void xllsdma_rx_irq_disable(struct xllsdma_device *sdma)
+{
+	u32 rx_cr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sdma->lock, flags);
+	rx_cr = xllsdma_rx_in32(sdma, XLLSDMA_CR);
+	xllsdma_rx_out32(sdma, XLLSDMA_CR, rx_cr & ~XLLSDMA_CR_IRQ_EN);
+	spin_unlock_irqrestore(&sdma->lock, flags);
+}
+EXPORT_SYMBOL_GPL(xllsdma_rx_irq_disable);
+
+void xllsdma_tx_irq_ack(struct xllsdma_device *sdma)
+{
+	u32 irq_stat;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sdma->lock, flags);
+	irq_stat = xllsdma_tx_in32(sdma, XLLSDMA_IRQ);
+	xllsdma_tx_out32(sdma, XLLSDMA_IRQ, irq_stat & XLLSDMA_IRQ_ALL_DONE);
+	spin_unlock_irqrestore(&sdma->lock, flags);
+}
+EXPORT_SYMBOL_GPL(xllsdma_tx_irq_ack);
+
+void xllsdma_rx_irq_ack(struct xllsdma_device *sdma)
+{
+	u32 irq_stat;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sdma->lock, flags);
+	irq_stat = xllsdma_rx_in32(sdma, XLLSDMA_IRQ);
+	xllsdma_rx_out32(sdma, XLLSDMA_IRQ, irq_stat & XLLSDMA_IRQ_ALL_DONE);
+	spin_unlock_irqrestore(&sdma->lock, flags);
+}
+EXPORT_SYMBOL_GPL(xllsdma_rx_irq_ack);
+
+void xllsdma_pause(struct xllsdma_device *sdma)
+{
+	u32 dmacr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sdma->lock, flags);
+	dmacr = xllsdma_read_cr(sdma);
+	dmacr |= XLLSDMA_DMACR_TX_PAUSE | XLLSDMA_DMACR_RX_PAUSE;
+	xllsdma_write_cr(sdma, dmacr);
+	spin_unlock_irqrestore(&sdma->lock, flags);
+}
+EXPORT_SYMBOL_GPL(xllsdma_pause);
+
+void xllsdma_resume(struct xllsdma_device *sdma)
+{
+	u32 dmacr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sdma->lock, flags);
+	dmacr = xllsdma_read_cr(sdma);
+	dmacr &= ~(XLLSDMA_DMACR_TX_PAUSE | XLLSDMA_DMACR_RX_PAUSE);
+	xllsdma_write_cr(sdma, dmacr);
+	spin_unlock_irqrestore(&sdma->lock, flags);
+}
+EXPORT_SYMBOL_GPL(xllsdma_resume);
+
+int xllsdma_set_coalesce(struct xllsdma_device *sdma, struct xllsdma_coalesce *coal)
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
+		rx_cr = xllsdma_rx_in32(sdma, XLLSDMA_CR);
+
+		if (coal->rx_timeout == 0) {
+			coal->rx_timeout = 1;
+			rx_cr &= ~XLLSDMA_CR_IRQ_TIMEOUT;
+		} else {
+			rx_cr |= XLLSDMA_CR_IRQ_TIMEOUT;
+		}
+
+		rx_cr &= ~(XLLSDMA_CR_IRQ_THRESHOLD_MSK | XLLSDMA_CR_IRQ_TIMEOUT_SH);
+		rx_cr |= (coal->rx_threshold << XLLSDMA_CR_IRQ_THRESHOLD_SH)
+			 & XLLSDMA_CR_IRQ_THRESHOLD_MSK;
+		rx_cr |= (coal->rx_timeout << XLLSDMA_CR_IRQ_TIMEOUT_SH)
+			 & XLLSDMA_CR_IRQ_TIMEOUT_MSK;
+		rx_cr |= XLLSDMA_CR_LD_IRQ_CNT;
+
+		xllsdma_rx_out32(sdma, XLLSDMA_CR, rx_cr);
+	}
+
+	if (sdma->tx_irq != NO_IRQ) {
+		tx_cr = xllsdma_tx_in32(sdma, XLLSDMA_CR);
+
+		if (coal->tx_timeout == 0) {
+			coal->tx_timeout = 1;
+			tx_cr &= ~XLLSDMA_CR_IRQ_TIMEOUT;
+		} else {
+			tx_cr |= XLLSDMA_CR_IRQ_TIMEOUT;
+		}
+
+		tx_cr &= ~(XLLSDMA_CR_IRQ_THRESHOLD_MSK | XLLSDMA_CR_IRQ_TIMEOUT_SH);
+		tx_cr |= (coal->tx_threshold << XLLSDMA_CR_IRQ_THRESHOLD_SH)
+			 & XLLSDMA_CR_IRQ_THRESHOLD_MSK;
+		tx_cr |= (coal->tx_timeout << XLLSDMA_CR_IRQ_TIMEOUT_SH)
+			 & XLLSDMA_CR_IRQ_TIMEOUT_MSK;
+		tx_cr |= XLLSDMA_CR_LD_IRQ_CNT;
+
+		xllsdma_tx_out32(sdma, XLLSDMA_CR, tx_cr);
+	}
+
+	spin_unlock_irqrestore(&sdma->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xllsdma_set_coalesce);
+
+int xllsdma_get_coalesce(struct xllsdma_device *sdma, struct xllsdma_coalesce *coal)
+{
+	u32 tx_cr, rx_cr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sdma->lock, flags);
+
+	tx_cr = xllsdma_tx_in32(sdma, XLLSDMA_CR);
+	rx_cr = xllsdma_rx_in32(sdma, XLLSDMA_CR);
+
+	coal->tx_threshold = (tx_cr & XLLSDMA_CR_IRQ_THRESHOLD_MSK)
+			     >> XLLSDMA_CR_IRQ_THRESHOLD_SH;
+	coal->tx_timeout = (tx_cr & XLLSDMA_CR_IRQ_TIMEOUT_MSK)
+			   >> XLLSDMA_CR_IRQ_TIMEOUT_SH;
+
+	coal->rx_threshold = (rx_cr & XLLSDMA_CR_IRQ_THRESHOLD_MSK)
+			     >> XLLSDMA_CR_IRQ_THRESHOLD_SH;
+	coal->rx_timeout = (rx_cr & XLLSDMA_CR_IRQ_TIMEOUT_MSK)
+			     >> XLLSDMA_CR_IRQ_TIMEOUT_SH;
+
+	if (!(tx_cr & XLLSDMA_CR_IRQ_TIMEOUT))
+		coal->tx_timeout = 0;
+
+	if (!(rx_cr & XLLSDMA_CR_IRQ_TIMEOUT))
+		coal->rx_timeout = 0;
+
+	spin_unlock_irqrestore(&sdma->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xllsdma_get_coalesce);
+
+int xllsdma_tx_submit(struct xllsdma_device *sdma, dma_addr_t desc)
+{
+	xllsdma_tx_out32(sdma, XLLSDMA_TDESCR, desc);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xllsdma_tx_submit);
+
+int xllsdma_rx_submit(struct xllsdma_device *sdma, dma_addr_t desc)
+{
+	xllsdma_rx_out32(sdma, XLLSDMA_TDESCR, desc);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xllsdma_rx_submit);
+
+void xllsdma_tx_init(struct xllsdma_device *sdma, dma_addr_t desc)
+{
+	xllsdma_tx_out32(sdma, XLLSDMA_CDESCR, desc);
+}
+EXPORT_SYMBOL_GPL(xllsdma_tx_init);
+
+void xllsdma_rx_init(struct xllsdma_device *sdma, dma_addr_t desc)
+{
+	xllsdma_rx_out32(sdma, XLLSDMA_CDESCR, desc);
+}
+EXPORT_SYMBOL_GPL(xllsdma_rx_init);
+
+struct xllsdma_device *xllsdma_find_device(int phandle)
+{
+	struct mpmc_device *mpmc;
+	struct xllsdma_device *sdma = NULL;
+	int found = 0;
+	mutex_lock(&mpmc_devs_lock);
+	list_for_each_entry(mpmc, &mpmc_devs, item) {
+		mutex_lock(&mpmc->devs_lock);
+		list_for_each_entry(sdma, &mpmc->xllsdma_devs, item) {
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
+EXPORT_SYMBOL_GPL(xllsdma_find_device);
+
+static irqreturn_t xllsdma_rx_intr(int irq, void *dev_id)
+{
+	u32 irq_ack, status;
+	struct xllsdma_device *sdma = dev_id;
+	struct xllsdma_client *client, *tmp;
+
+	/* Read pending interrupts */
+	status = xllsdma_rx_in32(sdma, XLLSDMA_IRQ);
+	irq_ack = status;
+	irq_ack &= sdma->rx_ack ? XLLSDMA_IRQ_ALL : XLLSDMA_IRQ_ALL_ERR;
+	xllsdma_rx_out32(sdma, XLLSDMA_IRQ, irq_ack);
+
+	if (unlikely(status & XLLSDMA_IRQ_ALL_ERR)) {
+		dev_err(sdma->dev, "%s: error status: %08x\n", __func__, 
+			status);
+		xllsdma_reset(sdma);
+		list_for_each_entry_safe(client, tmp, &sdma->clients, item)
+			if (likely(client->error))
+				client->error(client->data);
+		return IRQ_HANDLED;
+	}
+
+	if (likely(status & XLLSDMA_IRQ_ALL_DONE)) {
+		list_for_each_entry_safe(client, tmp, &sdma->clients, item)
+			if (likely(client->rx_complete))
+				client->rx_complete(client->data);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t xllsdma_tx_intr(int irq, void *dev_id)
+{
+	u32 irq_ack, status;
+	struct xllsdma_device *sdma = dev_id;
+	struct xllsdma_client *client, *tmp;
+
+	/* Read pending interrupts */
+	status = xllsdma_tx_in32(sdma, XLLSDMA_IRQ);
+	irq_ack = status;
+	irq_ack &= sdma->tx_ack ? XLLSDMA_IRQ_ALL : XLLSDMA_IRQ_ALL_ERR;
+	xllsdma_tx_out32(sdma, XLLSDMA_IRQ, irq_ack);
+
+	if (unlikely(status & XLLSDMA_IRQ_ALL_ERR)) {
+		dev_err(sdma->dev, "%s: error status: %08x\n", __func__, 
+			status);
+		xllsdma_reset(sdma);
+		list_for_each_entry_safe(client, tmp, &sdma->clients, item)
+			if (likely(client->error))
+				client->error(client->data);
+		return IRQ_HANDLED;
+	}
+
+	if (likely(status & XLLSDMA_IRQ_ALL_DONE)) {
+		list_for_each_entry_safe(client, tmp, &sdma->clients, item)
+			if (likely(client->tx_complete))
+				client->tx_complete(client->data);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void xllsdma_dev_register(struct mpmc_device *mpmc,
+			      struct xllsdma_device *sdma)
+{
+	mutex_lock(&mpmc->devs_lock);
+	list_add(&sdma->item, &mpmc->xllsdma_devs);
+	mutex_unlock(&mpmc->devs_lock);
+}
+
+static void xllsdma_dev_unregister(struct xllsdma_device *sdma)
+{
+	struct mpmc_device *mpmc = sdma->parent;
+
+	mutex_lock(&mpmc->devs_lock);
+	list_del(&sdma->item);
+	mutex_unlock(&mpmc->devs_lock);
+}
+
+static void xllsdma_cleanup(struct device *dev)
+{
+	struct xllsdma_device *sdma = dev_get_drvdata(dev);
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
+	xllsdma_dev_unregister(sdma);
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
+static int __devinit xllsdma_init(struct device *dev, struct resource *rx_irq,
+			       struct resource *tx_irq, struct resource *mem,
+			       int phandle)
+{
+	struct xllsdma_device *sdma;
+	struct mpmc_device *mpmc;
+
+	resource_size_t region_size;
+	int res;
+
+	mpmc = dev_get_drvdata(dev->parent);
+
+	sdma = kzalloc(sizeof(struct xllsdma_device), GFP_KERNEL);
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
+	xllsdma_reset(sdma);
+
+	sdma->rx_irq = NO_IRQ;
+	if (rx_irq) {
+		res = request_irq(rx_irq->start, xllsdma_rx_intr,
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
+		res = request_irq(tx_irq->start, xllsdma_tx_intr,
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
+	xllsdma_dev_register(mpmc, sdma);
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
+	INIT_LIST_HEAD(&mpmc->xllsdma_devs);
+	mutex_init(&mpmc->devs_lock);
+
+	mpmc_dev_register(mpmc);
+	mpmc->registered = 1;
+
+	return 0;
+}
+
+#ifdef CONFIG_OF
+static int xllsdma_of_remove(struct of_device *op)
+{
+	xllsdma_cleanup(&op->dev);
+	return 0;
+}
+
+/* Match table for of_platform binding */
+static struct of_device_id xllsdma_of_match[] = {
+	{ .compatible = "xlnx,ll-dma-1.00.a" },
+	{},
+};
+
+static int __devinit xllsdma_of_probe(struct of_device *op,
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
+	res = xllsdma_init(&op->dev, rx_irq_res, tx_irq_res, &mem, phandle);
+	if (res)
+		xllsdma_of_remove(op);
+
+	return res;
+}
+
+static struct of_platform_driver xllsdma_of_driver = {
+	.name		= "xilinx-sdma",
+	.match_table	= xllsdma_of_match,
+	.probe		= xllsdma_of_probe,
+	.remove		= xllsdma_of_remove,
+};
+
+int __init xllsdma_of_init(void)
+{
+	int ret;
+
+	ret = of_register_platform_driver(&xllsdma_of_driver);
+	if (ret) {
+		of_unregister_platform_driver(&xllsdma_of_driver);
+		printk(KERN_ERR "registering driver failed: err=%i", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+void xllsdma_of_exit(void)
+{
+	of_unregister_platform_driver(&xllsdma_of_driver);
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
+	of_platform_bus_probe(op->node, xllsdma_of_match, &op->dev);
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
+subsys_initcall(xllsdma_of_init);
+#else	/* CONFIG_OF */
+/*---------------------------------------------------------------------------
+ * Platform bus attachment
+ */
+
+static __devexit int xllsdma_plat_remove(struct platform_device *pdev)
+{
+	xllsdma_cleanup(&pdev->dev);
+	return 0;
+}
+
+static int __devinit xllsdma_plat_probe(struct platform_device *pdev)
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
+	err = xllsdma_init(&pdev->dev, rx_irq, tx_irq, mem, pdev->id);
+	if (err)
+		xllsdma_plat_remove(pdev);
+fail:
+	return err;
+}
+
+static struct platform_driver xllsdma_plat_driver = {
+	.probe = xllsdma_plat_probe,
+	.remove	= __devexit_p(xllsdma_plat_remove),
+	.driver = {
+		.owner = THIS_MODULE,
+		.name  = "xilinx-sdma",
+	},
+};
+
+int __init xllsdma_plat_init(void)
+{
+	int err = platform_driver_register(&xllsdma_plat_driver);
+	if (err) {
+		platform_driver_unregister(&xllsdma_plat_driver);
+		printk(KERN_ERR "registering driver failed: err=%i", err);
+		return err;
+	}
+
+	return 0;
+}
+subsys_initcall(xllsdma_plat_init);
+
+void xllsdma_plat_exit(void)
+{
+	platform_driver_unregister(&xllsdma_plat_driver);
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
diff -r baced9e29ab5 include/linux/xllsdma.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/linux/xllsdma.h	Wed Apr 28 02:00:51 2010 +0400
@@ -0,0 +1,187 @@
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
+#ifndef __XLLSDMA_H__
+#define __XLLSDMA_H__
+
+#include <linux/types.h>
+#include <linux/dma-mapping.h>
+
+#define XLLSDMA_ALIGNMENT	0x40
+
+struct xllsdma_desc {
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
+} __attribute__((aligned(XLLSDMA_ALIGNMENT)));
+
+
+enum {
+	XLLSDMA_STSCTL_ERROR	= (1 << 31), /* DMA error */
+	XLLSDMA_STSCTL_IOE		= (1 << 30), /* Interrupt on end */
+	XLLSDMA_STSCTL_SOE		= (1 << 29), /* Stop on end */
+	XLLSDMA_STSCTL_DONE	= (1 << 28), /* DMA completed */
+	XLLSDMA_STSCTL_SOP		= (1 << 27), /* Start of packet */
+	XLLSDMA_STSCTL_EOP		= (1 << 26), /* End of packet */
+	XLLSDMA_STSCTL_BUSY	= (1 << 25), /* DMA busy */
+	XLLSDMA_STSCTL_CSUM	= (1 << 0),  /* Checksum enable */
+
+	XLLSDMA_STSCTL_MSK		= (0xFF << 24), /*Status/control field */
+};
+
+/* SDMA client operations */
+struct xllsdma_client {
+	void *data;
+	void (*tx_complete) (void *data);
+	void (*rx_complete) (void *data);
+	void (*error) (void *data);
+	void (*reset) (void *data);
+	struct list_head item;
+};
+
+struct xllsdma_coalesce {
+	int tx_threshold;
+	int tx_timeout;
+
+	int rx_threshold;
+	int rx_timeout;
+};
+
+#define DEFINE_XLLSDMA_COALESCE(x) struct xllsdma_coalesce x = { \
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
+	struct list_head	xllsdma_devs;
+};
+
+struct xllsdma_device {
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
+	struct xllsdma_coalesce	coal;
+	struct list_head	item;
+
+	struct mutex		clients_lock;
+	struct list_head	clients;
+};
+
+static inline void xllsdma_add_client(struct xllsdma_device *sdma,
+				   struct xllsdma_client *client)
+{
+	mutex_lock(&sdma->clients_lock);
+	list_add(&client->item, &sdma->clients);
+	mutex_unlock(&sdma->clients_lock);
+}
+
+static inline void xllsdma_del_client(struct xllsdma_device *sdma,
+				   struct xllsdma_client *client)
+{
+	mutex_lock(&sdma->clients_lock);
+	list_del(&client->item);
+	mutex_unlock(&sdma->clients_lock);
+}
+
+struct xllsdma_device *xllsdma_find_device(int phandle);
+void xllsdma_pause(struct xllsdma_device *sdma);
+void xllsdma_resume(struct xllsdma_device *sdma);
+void xllsdma_reset(struct xllsdma_device *sdma);
+void xllsdma_rx_init(struct xllsdma_device *sdma, dma_addr_t desc);
+void xllsdma_tx_init(struct xllsdma_device *sdma, dma_addr_t desc);
+
+int xllsdma_tx_submit(struct xllsdma_device *sdma, dma_addr_t desc);
+int xllsdma_rx_submit(struct xllsdma_device *sdma, dma_addr_t desc);
+
+void xllsdma_tx_irq_enable(struct xllsdma_device *sdma);
+void xllsdma_rx_irq_enable(struct xllsdma_device *sdma);
+void xllsdma_tx_irq_disable(struct xllsdma_device *sdma);
+void xllsdma_rx_irq_disable(struct xllsdma_device *sdma);
+void xllsdma_tx_irq_ack(struct xllsdma_device *sdma);
+void xllsdma_rx_irq_ack(struct xllsdma_device *sdma);
+
+int xllsdma_set_coalesce(struct xllsdma_device *sdma, struct xllsdma_coalesce *coal);
+int xllsdma_get_coalesce(struct xllsdma_device *sdma, struct xllsdma_coalesce *coal);
+
+static inline int xllsdma_has_tx_irq(struct xllsdma_device *sdma)
+{
+	return sdma->tx_irq != NO_IRQ;
+}
+
+static inline int xllsdma_has_rx_irq(struct xllsdma_device *sdma)
+{
+	return sdma->rx_irq != NO_IRQ;
+}
+
+static inline int xllsdma_desc_busy(struct xllsdma_desc *desc)
+{
+	return desc->stat_ctl & __constant_be32_to_cpu(XLLSDMA_STSCTL_BUSY);
+}
+
+static inline int xllsdma_desc_done(struct xllsdma_desc *desc)
+{
+	return desc->stat_ctl & __constant_be32_to_cpu(XLLSDMA_STSCTL_DONE);
+}
+
+static inline int xllsdma_desc_sop(struct xllsdma_desc *desc)
+{
+	return desc->stat_ctl & __constant_be32_to_cpu(XLLSDMA_STSCTL_SOP);
+}
+
+static inline int xllsdma_desc_eop(struct xllsdma_desc *desc)
+{
+	return desc->stat_ctl & __constant_be32_to_cpu(XLLSDMA_STSCTL_EOP);
+}
+
+static inline void xllsdma_set_ack(struct xllsdma_device *sdma, int rx_ack,
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

--Boundary-00=_u/11LoShh+gaCF6--

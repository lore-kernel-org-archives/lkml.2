Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031195Ab2CVVxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:53:51 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:65326 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276Ab2CVVxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:53:43 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-127.messagelabs.com!1332453202!1248668!13
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: dma: ep93xx: check for spurious interrupts
Date: Thu, 22 Mar 2012 14:53:23 -0700
User-Agent: KMail/1.9.9
CC: <mika.westerberg@iki.fi>, <dan.j.williams@intel.com>,
        <vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201203221453.23796.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ep93xx dma controller generates spurious interrupts on dmachan1
when used with the mmc_spi driver. These are causing random debug
noise like:

    dma dma1chan1: got interrupt while active list is empty

Catch these early by making sure there is an interrupt to actually
process.

This was exposed when ep93xx was changed to MULTI_IRQ_HANDLER with
the new handle_one_vic function that does a single read of the vic
status register and then handles all pending interrupts in order
from LSB first.

Note, we still will get the spurious interrupts due to the handle_one_vic.
But now they will not cause any unnecessary noise.  To see the spurious
interrupt count check /proc/irq/*/spurious.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Tested-by: Mika Westerberg <mika.westerberg@iki.fi>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>

---

diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
index e6f133b..001e089 100644
--- a/drivers/dma/ep93xx_dma.c
+++ b/drivers/dma/ep93xx_dma.c
@@ -38,7 +38,7 @@
 #define M2P_CONTROL_ENABLE		BIT(4)
 #define M2P_CONTROL_ICE			BIT(6)
 
-#define M2P_INTERRUPT			0x0004
+#define M2X_INTERRUPT			0x0004	/* M2P and M2M */
 #define M2P_INTERRUPT_STALL		BIT(0)
 #define M2P_INTERRUPT_NFB		BIT(1)
 #define M2P_INTERRUPT_ERROR		BIT(3)
@@ -78,7 +78,6 @@
 #define M2M_CONTROL_NO_HDSK		BIT(24)
 #define M2M_CONTROL_PWSC_SHIFT		25
 
-#define M2M_INTERRUPT			0x0004
 #define M2M_INTERRUPT_DONEINT		BIT(1)
 
 #define M2M_BCR0			0x0010
@@ -187,7 +186,8 @@ struct ep93xx_dma_engine {
 	int			(*hw_setup)(struct ep93xx_dma_chan *);
 	void			(*hw_shutdown)(struct ep93xx_dma_chan *);
 	void			(*hw_submit)(struct ep93xx_dma_chan *);
-	int			(*hw_interrupt)(struct ep93xx_dma_chan *);
+	int			(*hw_interrupt)(struct ep93xx_dma_chan *,
+						u32 irq_status);
 #define INTERRUPT_UNKNOWN	0
 #define INTERRUPT_DONE		1
 #define INTERRUPT_NEXT_BUFFER	2
@@ -376,16 +376,15 @@ static void m2p_hw_submit(struct ep93xx_dma_chan *edmac)
 	m2p_set_control(edmac, control);
 }
 
-static int m2p_hw_interrupt(struct ep93xx_dma_chan *edmac)
+static int m2p_hw_interrupt(struct ep93xx_dma_chan *edmac, u32 irq_status)
 {
-	u32 irq_status = readl(edmac->regs + M2P_INTERRUPT);
 	u32 control;
 
 	if (irq_status & M2P_INTERRUPT_ERROR) {
 		struct ep93xx_dma_desc *desc = ep93xx_dma_get_active(edmac);
 
 		/* Clear the error interrupt */
-		writel(1, edmac->regs + M2P_INTERRUPT);
+		writel(1, edmac->regs + M2X_INTERRUPT);
 
 		/*
 		 * It seems that there is no easy way of reporting errors back
@@ -560,15 +559,15 @@ static void m2m_hw_submit(struct ep93xx_dma_chan *edmac)
 	}
 }
 
-static int m2m_hw_interrupt(struct ep93xx_dma_chan *edmac)
+static int m2m_hw_interrupt(struct ep93xx_dma_chan *edmac, u32 irq_status)
 {
 	u32 control;
 
-	if (!(readl(edmac->regs + M2M_INTERRUPT) & M2M_INTERRUPT_DONEINT))
+	if (!(irq_status & M2M_INTERRUPT_DONEINT))
 		return INTERRUPT_UNKNOWN;
 
 	/* Clear the DONE bit */
-	writel(0, edmac->regs + M2M_INTERRUPT);
+	writel(0, edmac->regs + M2X_INTERRUPT);
 
 	/* Disable interrupts and the channel */
 	control = readl(edmac->regs + M2M_CONTROL);
@@ -735,6 +734,12 @@ static irqreturn_t ep93xx_dma_interrupt(int irq, void *dev_id)
 	struct ep93xx_dma_chan *edmac = dev_id;
 	struct ep93xx_dma_desc *desc;
 	irqreturn_t ret = IRQ_HANDLED;
+	u32 irq_status;
+
+	/* Make sure we actually have an interrupt to process */
+	irq_status = readl(edmac->regs + M2X_INTERRUPT);
+	if (!irq_status)
+		return IRQ_NONE;
 
 	spin_lock(&edmac->lock);
 
@@ -746,7 +751,7 @@ static irqreturn_t ep93xx_dma_interrupt(int irq, void *dev_id)
 		return IRQ_NONE;
 	}
 
-	switch (edmac->edma->hw_interrupt(edmac)) {
+	switch (edmac->edma->hw_interrupt(edmac, irq_status)) {
 	case INTERRUPT_DONE:
 		desc->complete = true;
 		tasklet_schedule(&edmac->tasklet);

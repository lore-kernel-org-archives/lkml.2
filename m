Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209Ab2CTIQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 04:16:21 -0400
Received: from metasoft.pl ([195.149.224.191]:50171 "EHLO smtp.metasoft.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756225Ab2CTIQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 04:16:15 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Mar 2012 04:16:14 EDT
X-clamdmail: clamdmail 0.18a
Message-ID: <4F683B36.8090101@metasoft.pl>
Date: Tue, 20 Mar 2012 09:09:26 +0100
From: Rafal Prylowski <prylowski@metasoft.pl>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        "rmallon@gmail.com" <rmallon@gmail.com>
Subject: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement double buffering for M2M DMA channels.

Signed-off-by: Rafal Prylowski <prylowski@metasoft.pl>

Index: slave-dma/drivers/dma/ep93xx_dma.c
===================================================================
--- slave-dma.orig/drivers/dma/ep93xx_dma.c
+++ slave-dma/drivers/dma/ep93xx_dma.c
@@ -69,6 +69,7 @@
 #define M2M_CONTROL_TM_SHIFT		13
 #define M2M_CONTROL_TM_TX		(1 << M2M_CONTROL_TM_SHIFT)
 #define M2M_CONTROL_TM_RX		(2 << M2M_CONTROL_TM_SHIFT)
+#define M2M_CONTROL_NFBINT		BIT(21)
 #define M2M_CONTROL_RSS_SHIFT		22
 #define M2M_CONTROL_RSS_SSPRX		(1 << M2M_CONTROL_RSS_SHIFT)
 #define M2M_CONTROL_RSS_SSPTX		(2 << M2M_CONTROL_RSS_SHIFT)
@@ -77,7 +78,23 @@
 #define M2M_CONTROL_PWSC_SHIFT		25
 
 #define M2M_INTERRUPT			0x0004
-#define M2M_INTERRUPT_DONEINT		BIT(1)
+#define M2M_INTERRUPT_MASK		6
+
+#define M2M_STATUS			0x000c
+#define M2M_STATUS_CTL_SHIFT		1
+#define M2M_STATUS_CTL_IDLE		(0 << M2M_STATUS_CTL_SHIFT)
+#define M2M_STATUS_CTL_STALL		(1 << M2M_STATUS_CTL_SHIFT)
+#define M2M_STATUS_CTL_MEMRD		(2 << M2M_STATUS_CTL_SHIFT)
+#define M2M_STATUS_CTL_MEMWR		(3 << M2M_STATUS_CTL_SHIFT)
+#define M2M_STATUS_CTL_BWCWAIT		(4 << M2M_STATUS_CTL_SHIFT)
+#define M2M_STATUS_CTL_MASK		(7 << M2M_STATUS_CTL_SHIFT)
+#define M2M_STATUS_BUF_SHIFT		4
+#define M2M_STATUS_BUF_NO		(0 << M2M_STATUS_BUF_SHIFT)
+#define M2M_STATUS_BUF_ON		(1 << M2M_STATUS_BUF_SHIFT)
+#define M2M_STATUS_BUF_NEXT		(2 << M2M_STATUS_BUF_SHIFT)
+#define M2M_STATUS_BUF_MASK		(3 << M2M_STATUS_BUF_SHIFT)
+#define M2M_STATUS_DONE			BIT(6)
+
 
 #define M2M_BCR0			0x0010
 #define M2M_BCR1			0x0014
@@ -426,15 +443,6 @@ static int m2p_hw_interrupt(struct ep93x
 
 /*
  * M2M DMA implementation
- *
- * For the M2M transfers we don't use NFB at all. This is because it simply
- * doesn't work well with memcpy transfers. When you submit both buffers it is
- * extremely unlikely that you get an NFB interrupt, but it instead reports
- * DONE interrupt and both buffers are already transferred which means that we
- * weren't able to update the next buffer.
- *
- * So for now we "simulate" NFB by just submitting buffer after buffer
- * without double buffering.
  */
 
 static int m2m_hw_setup(struct ep93xx_dma_chan *edmac)
@@ -543,6 +551,11 @@ static void m2m_hw_submit(struct ep93xx_
 	m2m_fill_desc(edmac);
 	control |= M2M_CONTROL_DONEINT;
 
+	if (ep93xx_dma_advance_active(edmac)) {
+		m2m_fill_desc(edmac);
+		control |= M2M_CONTROL_NFBINT;
+	}
+
 	/*
 	 * Now we can finally enable the channel. For M2M channel this must be
 	 * done _after_ the BCRx registers are programmed.
@@ -560,32 +573,85 @@ static void m2m_hw_submit(struct ep93xx_
 	}
 }
 
+/*
+ * According to EP93xx User's Guide, we should receive DONE interrupt when all
+ * M2M DMA controller transactions complete normally. This is not always the
+ * case - sometimes EP93xx M2M DMA asserts DONE interrupt when the DMA channel
+ * is still running (channel Buffer FSM in DMA_BUF_ON state, and channel
+ * Control FSM in DMA_MEM_RD state, observed at least in IDE-DMA operation).
+ * In effect, disabling the channel when only DONE bit is set could stop
+ * currently running DMA transfer. To avoid this, we use Buffer FSM and
+ * Control FSM to check current state of DMA channel.
+ */
 static int m2m_hw_interrupt(struct ep93xx_dma_chan *edmac)
 {
+	u32 status = readl(edmac->regs + M2M_STATUS);
+	u32 ctl_fsm = status & M2M_STATUS_CTL_MASK;
+	u32 buf_fsm = status & M2M_STATUS_BUF_MASK;
+	bool done = status & M2M_STATUS_DONE;
+	bool last;
 	u32 control;
 
-	if (!(readl(edmac->regs + M2M_INTERRUPT) & M2M_INTERRUPT_DONEINT))
+	/* Accept only DONE and NFB interrupts */
+	if (!(readl(edmac->regs + M2M_INTERRUPT) & M2M_INTERRUPT_MASK))
 		return INTERRUPT_UNKNOWN;
 
-	/* Clear the DONE bit */
-	writel(0, edmac->regs + M2M_INTERRUPT);
+	if (done)
+		/* Clear the DONE bit */
+		writel(0, edmac->regs + M2M_INTERRUPT);
 
-	/* Disable interrupts and the channel */
-	control = readl(edmac->regs + M2M_CONTROL);
-	control &= ~(M2M_CONTROL_DONEINT | M2M_CONTROL_ENABLE);
-	writel(control, edmac->regs + M2M_CONTROL);
+	/*
+	 * Check whether we are done with descriptors or not. This, together
+	 * with DMA channel state, determines action to take in interrupt.
+	 */
+	last = list_first_entry(edmac->active.next,
+		struct ep93xx_dma_desc, node)->txd.cookie;
 
 	/*
-	 * Since we only get DONE interrupt we have to find out ourselves
-	 * whether there still is something to process. So we try to advance
-	 * the chain an see whether it succeeds.
+	 * Use M2M DMA Buffer FSM and Control FSM to check current state of
+	 * DMA channel. Using DONE and NFB bits from channel status register
+	 * or bits from channel interrupt register was proven not to be
+	 * reliable.
 	 */
-	if (ep93xx_dma_advance_active(edmac)) {
-		edmac->edma->hw_submit(edmac);
+	if (!last &&
+	    (buf_fsm == M2M_STATUS_BUF_NO ||
+	     buf_fsm == M2M_STATUS_BUF_ON)) {
+		/*
+		 * Two buffers are ready for update when Buffer FSM is in
+		 * DMA_NO_BUF state. Only one buffer can be prepared without
+		 * disabling the channel, or polling the DONE bit.
+		 * To simplify things, always prepare only one buffer.
+		 */
+		ep93xx_dma_advance_active(edmac);
+		m2m_fill_desc(edmac);
+		if (done && !edmac->chan.private) {
+			/* Software trigger for memcpy channel */
+			control = readl(edmac->regs + M2M_CONTROL);
+			control |= M2M_CONTROL_START;
+			writel(control, edmac->regs + M2M_CONTROL);
+		}
 		return INTERRUPT_NEXT_BUFFER;
 	}
 
-	return INTERRUPT_DONE;
+	/*
+	 * Disable the channel only when Buffer FSM is in DMA_NO_BUF state
+	 * and Control FSM is in DMA_STALL state.
+	 */
+	if (last &&
+	    buf_fsm == M2M_STATUS_BUF_NO &&
+	    ctl_fsm == M2M_STATUS_CTL_STALL) {
+		/* Disable interrupts and the channel */
+		control = readl(edmac->regs + M2M_CONTROL);
+		control &= ~(M2M_CONTROL_DONEINT | M2M_CONTROL_NFBINT
+			    | M2M_CONTROL_ENABLE);
+		writel(control, edmac->regs + M2M_CONTROL);
+		return INTERRUPT_DONE;
+	}
+
+	/*
+	 * Nothing to do this time.
+	 */
+	return INTERRUPT_NEXT_BUFFER;
 }
 
 /*

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab2DKHSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 03:18:54 -0400
Received: from metasoft.pl ([195.149.224.191]:56479 "EHLO smtp.metasoft.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799Ab2DKHSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 03:18:53 -0400
X-clamdmail: clamdmail 0.18a
Message-ID: <4F853053.7040800@metasoft.pl>
Date: Wed, 11 Apr 2012 09:18:43 +0200
From: Rafal Prylowski <prylowski@metasoft.pl>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Mika Westerberg <mika.westerberg@iki.fi>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "rmallon@gmail.com" <rmallon@gmail.com>
Subject: Re: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
References: <4F683B36.8090101@metasoft.pl> <20120321193836.GC3740@mwesterb-mobl.ger.corp.intel.com> <ADE657CA350FB648AAC2C43247A983F0020696D48E3E@AUSP01VMBX24.collaborationhost.net> <20120323070446.GC5812@mwesterb-mobl.ger.corp.intel.com> <ADE657CA350FB648AAC2C43247A983F0020696D48EEB@AUSP01VMBX24.collaborationhost.net> <20120410172853.GA25697@mwesterb-mobl> <ADE657CA350FB648AAC2C43247A983F00206986C01D4@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F00206986C01D4@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-10 19:55, H Hartley Sweeten wrote:
> On Tuesday, April 10, 2012 10:29 AM, Mika Westerberg wrote:
>> On Fri, Mar 23, 2012 at 11:09:50AM -0500, H Hartley Sweeten wrote:
>>
>> Now that the spurious interrupts thing with VIC has been sorted out, should we
>> revisit this patch? Hartley, do you have any objections merging this?
> 
> I have not had a chance to look at this with the VIC issue fixed.
> 
> Last time I tried testing the double buffering patch my system would not boot
> correctly. I'll try to test this again shortly.
> 
> Rafal,
> 
> Could you repost the latest version of the patch?
> 

Hi,

Here is the patch. It applies to current mainline (3.4rc2). The only thing that
has changed is additional call to ep93xx_dma_advance_active(..) before disabling
the channel.


Implement double buffering for M2M DMA channels.

Signed-off-by: Rafal Prylowski <prylowski@metasoft.pl>

Index: linux-2.6/drivers/dma/ep93xx_dma.c
===================================================================
--- linux-2.6.orig/drivers/dma/ep93xx_dma.c
+++ linux-2.6/drivers/dma/ep93xx_dma.c
@@ -71,6 +71,7 @@
 #define M2M_CONTROL_TM_SHIFT		13
 #define M2M_CONTROL_TM_TX		(1 << M2M_CONTROL_TM_SHIFT)
 #define M2M_CONTROL_TM_RX		(2 << M2M_CONTROL_TM_SHIFT)
+#define M2M_CONTROL_NFBINT		BIT(21)
 #define M2M_CONTROL_RSS_SHIFT		22
 #define M2M_CONTROL_RSS_SSPRX		(1 << M2M_CONTROL_RSS_SHIFT)
 #define M2M_CONTROL_RSS_SSPTX		(2 << M2M_CONTROL_RSS_SHIFT)
@@ -79,7 +80,23 @@
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
@@ -560,32 +573,86 @@ static void m2m_hw_submit(struct ep93xx_
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
+		ep93xx_dma_advance_active(edmac);
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

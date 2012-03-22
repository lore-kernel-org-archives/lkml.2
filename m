Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759156Ab2CVSxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 14:53:11 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:41242 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759084Ab2CVSxI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 14:53:08 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-160.messagelabs.com!1332442344!1902173!29
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Mika Westerberg <mika.westerberg@iki.fi>
CC: Rafal Prylowski <prylowski@metasoft.pl>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "rmallon@gmail.com" <rmallon@gmail.com>
Date: Thu, 22 Mar 2012 13:52:52 -0500
Subject: RE: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
Thread-Topic: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
Thread-Index: Ac0H/tBBStfDYhJbTECWGOc9k8UZtAAWiU+Q
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020696D48CAF@AUSP01VMBX24.collaborationhost.net>
References: <4F683B36.8090101@metasoft.pl>
 <ADE657CA350FB648AAC2C43247A983F0020696D488E3@AUSP01VMBX24.collaborationhost.net>
 <20120321193231.GA3740@mwesterb-mobl.ger.corp.intel.com>
 <ADE657CA350FB648AAC2C43247A983F0020696D48AB1@AUSP01VMBX24.collaborationhost.net>
 <20120322073750.GA637@mwesterb-mobl.ger.corp.intel.com>
In-Reply-To: <20120322073750.GA637@mwesterb-mobl.ger.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 22, 2012 12:38 AM, Mika Westerberg wrote:
> On Wed, Mar 21, 2012 at 07:47:52PM -0500, H Hartley Sweeten wrote:
>> Without this patch I get the "got interrupt while active list is empty" messages
>> but only occasionally. Other than the messages the mmc_spi driver seems to
>> be working ok with dma.
>> 
>> I hacked in a dump of the DMA Global Interrupt register when I get the
>> "got interrupt while active list is empty" messages and get this:
>> 
>> dma dma1chan1: got interrupt while active list is empty (00000000)

Mika,

I hacked this back to the handle_one_vic function. It looks like every time
I get the message above the stat read in that function shows an active
interrupt for DMAM2M0 (the dma rx channel) and DMAM2M1 (the dma
tx channel). Because of the way handle_one_vic processes the irq's, the
DMAM2M0 interrupt gets handled first. When it's done it must be clearing
the DMAM2M1 interrupt automatically for some reason. So, when it's
handled there is no interrupt pending so we get the message.

The "cleanest" fix I can think of is the following patch.  This is against
linux-next.

---

From: H Hartley Sweeten <hsweeten@visionengravers.com>

dma: ep93xx: check for spurious interrupts

The ep93xx dma controller generates spurious interrupts on dma1chan1 when
used with the mmc_spi driver. Catch these early by making sure there is an
interrupt to actually process.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
index e6f133b..3cfabe6 100644
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



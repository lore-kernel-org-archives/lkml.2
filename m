Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab1I1Whe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:37:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53430 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755326Ab1I1Wha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:37:30 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:27 2011
Message-Id: <20110928220127.343808878@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Per Forlin <per.forlin@linaro.org>, Felipe Balbi <balbi@ti.com>
Subject: [020/244] usb: musb: cppi: fix build errors due to DBG and missing musb variable
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Per Forlin <per.forlin@linaro.org>

commit f847a79ab3c1faca3022061045cd22e4678c1b1c upstream.

Replace DBG with dev_dbg and fix invalid access of musb->controller.
With this patch cppi_dma builds successfully.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/musb/cppi_dma.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

--- a/drivers/usb/musb/cppi_dma.c
+++ b/drivers/usb/musb/cppi_dma.c
@@ -226,8 +226,10 @@ static int cppi_controller_stop(struct d
 	struct cppi		*controller;
 	void __iomem		*tibase;
 	int			i;
+	struct musb		*musb;
 
 	controller = container_of(c, struct cppi, controller);
+	musb = controller->musb;
 
 	tibase = controller->tibase;
 	/* DISABLE INDIVIDUAL CHANNEL Interrupts */
@@ -289,9 +291,11 @@ cppi_channel_allocate(struct dma_control
 	u8			index;
 	struct cppi_channel	*cppi_ch;
 	void __iomem		*tibase;
+	struct musb		*musb;
 
 	controller = container_of(c, struct cppi, controller);
 	tibase = controller->tibase;
+	musb = controller->musb;
 
 	/* ep0 doesn't use DMA; remember cppi indices are 0..N-1 */
 	index = ep->epnum - 1;
@@ -339,7 +343,8 @@ static void cppi_channel_release(struct
 	c = container_of(channel, struct cppi_channel, channel);
 	tibase = c->controller->tibase;
 	if (!c->hw_ep)
-		dev_dbg(musb->controller, "releasing idle DMA channel %p\n", c);
+		dev_dbg(c->controller->musb->controller,
+			"releasing idle DMA channel %p\n", c);
 	else if (!c->transmit)
 		core_rxirq_enable(tibase, c->index + 1);
 
@@ -357,10 +362,11 @@ cppi_dump_rx(int level, struct cppi_chan
 
 	musb_ep_select(base, c->index + 1);
 
-	DBG(level, "RX DMA%d%s: %d left, csr %04x, "
-			"%08x H%08x S%08x C%08x, "
-			"B%08x L%08x %08x .. %08x"
-			"\n",
+	dev_dbg(c->controller->musb->controller,
+		"RX DMA%d%s: %d left, csr %04x, "
+		"%08x H%08x S%08x C%08x, "
+		"B%08x L%08x %08x .. %08x"
+		"\n",
 		c->index, tag,
 		musb_readl(c->controller->tibase,
 			DAVINCI_RXCPPI_BUFCNT0_REG + 4 * c->index),
@@ -387,10 +393,11 @@ cppi_dump_tx(int level, struct cppi_chan
 
 	musb_ep_select(base, c->index + 1);
 
-	DBG(level, "TX DMA%d%s: csr %04x, "
-			"H%08x S%08x C%08x %08x, "
-			"F%08x L%08x .. %08x"
-			"\n",
+	dev_dbg(c->controller->musb->controller,
+		"TX DMA%d%s: csr %04x, "
+		"H%08x S%08x C%08x %08x, "
+		"F%08x L%08x .. %08x"
+		"\n",
 		c->index, tag,
 		musb_readw(c->hw_ep->regs, MUSB_TXCSR),
 
@@ -1022,6 +1029,7 @@ static bool cppi_rx_scan(struct cppi *cp
 	int				i;
 	dma_addr_t			safe2ack;
 	void __iomem			*regs = rx->hw_ep->regs;
+	struct musb			*musb = cppi->musb;
 
 	cppi_dump_rx(6, rx, "/K");
 



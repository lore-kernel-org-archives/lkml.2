Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab1HCNjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:39:51 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:40763 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751070Ab1HCNjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:39:44 -0400
From: Per Forlin <per.forlin@stericsson.com>
To: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linaro-dev@lists.linaro.org>, <stable@kernel.org>,
        Per Forlin <per.forlin@linaro.org>
Subject: [PATCH] usb: musb: cppi: fix build errors due to DBG and missing musb variable
Date: Wed, 3 Aug 2011 15:39:15 +0200
Message-ID: <1312378755-7919-1-git-send-email-per.forlin@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Per Forlin <per.forlin@linaro.org>

Replace DBG with dev_dbg add fix invalid access of musb->controller.
With this patch cppi_dma builds successfully.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
Cc: <stable@kernel.org>
---
 drivers/usb/musb/cppi_dma.c |   26 +++++++++++++++++---------
 1 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/musb/cppi_dma.c b/drivers/usb/musb/cppi_dma.c
index 149f3f3..318fb4e 100644
--- a/drivers/usb/musb/cppi_dma.c
+++ b/drivers/usb/musb/cppi_dma.c
@@ -226,8 +226,10 @@ static int cppi_controller_stop(struct dma_controller *c)
 	struct cppi		*controller;
 	void __iomem		*tibase;
 	int			i;
+	struct musb		*musb;
 
 	controller = container_of(c, struct cppi, controller);
+	musb = controller->musb;
 
 	tibase = controller->tibase;
 	/* DISABLE INDIVIDUAL CHANNEL Interrupts */
@@ -289,9 +291,11 @@ cppi_channel_allocate(struct dma_controller *c,
 	u8			index;
 	struct cppi_channel	*cppi_ch;
 	void __iomem		*tibase;
+	struct musb		*musb;
 
 	controller = container_of(c, struct cppi, controller);
 	tibase = controller->tibase;
+	musb = controller->musb;
 
 	/* ep0 doesn't use DMA; remember cppi indices are 0..N-1 */
 	index = ep->epnum - 1;
@@ -339,7 +343,8 @@ static void cppi_channel_release(struct dma_channel *channel)
 	c = container_of(channel, struct cppi_channel, channel);
 	tibase = c->controller->tibase;
 	if (!c->hw_ep)
-		dev_dbg(musb->controller, "releasing idle DMA channel %p\n", c);
+		dev_dbg(c->controller->musb->controller,
+			"releasing idle DMA channel %p\n", c);
 	else if (!c->transmit)
 		core_rxirq_enable(tibase, c->index + 1);
 
@@ -357,10 +362,11 @@ cppi_dump_rx(int level, struct cppi_channel *c, const char *tag)
 
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
@@ -387,10 +393,11 @@ cppi_dump_tx(int level, struct cppi_channel *c, const char *tag)
 
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
 
@@ -1022,6 +1029,7 @@ static bool cppi_rx_scan(struct cppi *cppi, unsigned ch)
 	int				i;
 	dma_addr_t			safe2ack;
 	void __iomem			*regs = rx->hw_ep->regs;
+	struct musb			*musb = cppi->musb;
 
 	cppi_dump_rx(6, rx, "/K");
 
-- 
1.6.3.3


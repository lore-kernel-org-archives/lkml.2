Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab1FXL4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 07:56:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59288 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab1FXL4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 07:56:18 -0400
Date: Fri, 24 Jun 2011 13:56:15 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-sh@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Magnus Damm <damm@opensource.se>
Subject: [PATCH] serial: sh-sci: don't filter on DMA device, use only channel
 ID
Message-ID: <Pine.LNX.4.64.1106241354060.6014@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:HEtP+bLNvvBrsXT1RswFDJdI7Zn2cG4kFzOI/PLIJ9n
 /Hc7K+QS4FE0FfoUYVp+aZeGSn0/pwleXIM4Y2+UiEPjVDemnE
 91kAKOQMpDrWPKAfGYmh0/LO4bqXHUlN643j0dyuP6QX26on9I
 fPCT5kvV4VBkpfBuHBK4R04IXX2qGpxHaeDfvfiNunC0tuiFN9
 52qAo75nX6VX5Zl7Qm8RFMBr/KSDgMkOVwkWFfxaXM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some sh-mobile systems there are more than one DMA controllers, that
can be used for serial ports. Specifying a DMA device in sh-sci platform
data unnecessarily restricts the driver to only use one DMA controller.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/tty/serial/sh-sci.c |   25 ++++++++-----------------
 include/linux/serial_sci.h  |    2 --
 2 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index ebd8629..8711f4e 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1295,12 +1295,8 @@ static bool filter(struct dma_chan *chan, void *slave)
 	dev_dbg(chan->device->dev, "%s: slave ID %d\n", __func__,
 		param->slave_id);
 
-	if (param->dma_dev == chan->device->dev) {
-		chan->private = param;
-		return true;
-	} else {
-		return false;
-	}
+	chan->private = param;
+	return true;
 }
 
 static void rx_timer_fn(unsigned long arg)
@@ -1326,10 +1322,10 @@ static void sci_request_dma(struct uart_port *port)
 	dma_cap_mask_t mask;
 	int nent;
 
-	dev_dbg(port->dev, "%s: port %d DMA %p\n", __func__,
-		port->line, s->cfg->dma_dev);
+	dev_dbg(port->dev, "%s: port %d\n", __func__,
+		port->line);
 
-	if (!s->cfg->dma_dev)
+	if (s->cfg->dma_slave_tx <= 0 || s->cfg->dma_slave_rx <= 0)
 		return;
 
 	dma_cap_zero(mask);
@@ -1339,7 +1335,6 @@ static void sci_request_dma(struct uart_port *port)
 
 	/* Slave ID, e.g., SHDMA_SLAVE_SCIF0_TX */
 	param->slave_id = s->cfg->dma_slave_tx;
-	param->dma_dev = s->cfg->dma_dev;
 
 	s->cookie_tx = -EINVAL;
 	chan = dma_request_channel(mask, filter, param);
@@ -1368,7 +1363,6 @@ static void sci_request_dma(struct uart_port *port)
 
 	/* Slave ID, e.g., SHDMA_SLAVE_SCIF0_RX */
 	param->slave_id = s->cfg->dma_slave_rx;
-	param->dma_dev = s->cfg->dma_dev;
 
 	chan = dma_request_channel(mask, filter, param);
 	dev_dbg(port->dev, "%s: RX: got channel %p\n", __func__, chan);
@@ -1413,9 +1407,6 @@ static void sci_free_dma(struct uart_port *port)
 {
 	struct sci_port *s = to_sci_port(port);
 
-	if (!s->cfg->dma_dev)
-		return;
-
 	if (s->chan_tx)
 		sci_tx_dma_release(s, false);
 	if (s->chan_rx)
@@ -1790,9 +1781,9 @@ static int __devinit sci_init_single(struct platform_device *dev,
 	 */
 	port->irq		= p->irqs[SCIx_RXI_IRQ];
 
-	if (p->dma_dev)
-		dev_dbg(port->dev, "DMA device %p, tx %d, rx %d\n",
-			p->dma_dev, p->dma_slave_tx, p->dma_slave_rx);
+	if (p->dma_slave_tx > 0 && p->dma_slave_rx > 0)
+		dev_dbg(port->dev, "DMA tx %d, rx %d\n",
+			p->dma_slave_tx, p->dma_slave_rx);
 
 	return 0;
 }
diff --git a/include/linux/serial_sci.h b/include/linux/serial_sci.h
index a2afc9f..9d01ffa 100644
--- a/include/linux/serial_sci.h
+++ b/include/linux/serial_sci.h
@@ -56,8 +56,6 @@ struct plat_sci_port {
 	unsigned int	scbrr_algo_id;		/* SCBRR calculation algo */
 	unsigned int	scscr;			/* SCSCR initialization */
 
-	struct device	*dma_dev;
-
 	unsigned int	dma_slave_tx;
 	unsigned int	dma_slave_rx;
 };
-- 
1.7.2.5


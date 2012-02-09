Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602Ab2BIWSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 17:18:08 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50491 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758560Ab2BIWSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 17:18:05 -0500
Date: Thu, 9 Feb 2012 23:17:51 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-usb@vger.kernel.org
cc: Felipe Balbi <balbi@ti.com>,
        "Shimoda, Yoshihiro" <yoshihiro.shimoda.uh@renesas.com>,
        linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 2/2] usb: fix renesas_usbhs to not schedule in atomic context
In-Reply-To: <Pine.LNX.4.64.1202092313560.18719@axis700.grange>
Message-ID: <Pine.LNX.4.64.1202092316180.18719@axis700.grange>
References: <Pine.LNX.4.64.1202092313560.18719@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:QJ5cK6LfdIKnMQfaiKJQyo3d7JzoSBtaXrGyfPNTMOD
 cI2HN3CPnluQJ+UI2Skh6xRGnCJJI7SbK7+p2cEnPTRObItnFK
 NL5uAYIzw4no7ypkOnQHo36N42CEYF45qswR9v0NAdshlxiobY
 Gnf9fh0euDIy4CX+uyC20D95XA/0qC5m8YyBXWdf7U1d94kxxB
 RS04FYol0SfT3D5Nq7oM459iOdCk6IN+ALRqX8b8CbAbfFbfnq
 GcmH03vJekZAG9ExI8Ie2uLIlcfQbCg3wyLE/Oxcu2dH6l3rKL
 LFhuArcspJ06PV8vl/8+Y2kgKCpAcDG7daF+hrJb8PU+t5XBKB
 52ILJZ6SgrWkVzgBmhGwVILC7Y0jI6Aj07eCXWPDHJL+8n5C5t
 ORGFszG60f4qw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current renesas_usbhs driver triggers

BUG: scheduling while atomic: ksoftirqd/0/3/0x00000102

with enabled CONFIG_DEBUG_ATOMIC_SLEEP, by submitting DMA transfers from
an atomic (tasklet) context, which is not supported by the shdma dmaengine
driver. Fix it by switching to a work.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/usb/renesas_usbhs/fifo.c |   28 +++++++++++-----------------
 drivers/usb/renesas_usbhs/fifo.h |    3 ++-
 2 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/renesas_usbhs/fifo.c b/drivers/usb/renesas_usbhs/fifo.c
index 5d543e3..4d739ec 100644
--- a/drivers/usb/renesas_usbhs/fifo.c
+++ b/drivers/usb/renesas_usbhs/fifo.c
@@ -761,9 +761,9 @@ static int __usbhsf_dma_map_ctrl(struct usbhs_pkt *pkt, int map)
 }
 
 static void usbhsf_dma_complete(void *arg);
-static void usbhsf_dma_prepare_tasklet(unsigned long data)
+static void xfer_work(struct work_struct *work)
 {
-	struct usbhs_pkt *pkt = (struct usbhs_pkt *)data;
+	struct usbhs_pkt *pkt = container_of(work, struct usbhs_pkt, work);
 	struct usbhs_pipe *pipe = pkt->pipe;
 	struct usbhs_fifo *fifo = usbhs_pipe_to_fifo(pipe);
 	struct usbhs_priv *priv = usbhs_pipe_to_priv(pipe);
@@ -843,11 +843,8 @@ static int usbhsf_dma_prepare_push(struct usbhs_pkt *pkt, int *is_done)
 
 	pkt->trans = len;
 
-	tasklet_init(&fifo->tasklet,
-		     usbhsf_dma_prepare_tasklet,
-		     (unsigned long)pkt);
-
-	tasklet_schedule(&fifo->tasklet);
+	INIT_WORK(&pkt->work, xfer_work);
+	schedule_work(&pkt->work);
 
 	return 0;
 
@@ -937,11 +934,8 @@ static int usbhsf_dma_try_pop(struct usbhs_pkt *pkt, int *is_done)
 
 	pkt->trans = len;
 
-	tasklet_init(&fifo->tasklet,
-		     usbhsf_dma_prepare_tasklet,
-		     (unsigned long)pkt);
-
-	tasklet_schedule(&fifo->tasklet);
+	INIT_WORK(&pkt->work, xfer_work);
+	schedule_work(&pkt->work);
 
 	return 0;
 
@@ -997,7 +991,7 @@ static bool usbhsf_dma_filter(struct dma_chan *chan, void *param)
 	 *
 	 * usbhs doesn't recognize id = 0 as valid DMA
 	 */
-	if (0 == slave->slave_id)
+	if (0 == slave->simple_slave.slave_id)
 		return false;
 
 	chan->private = slave;
@@ -1176,8 +1170,8 @@ int usbhs_fifo_probe(struct usbhs_priv *priv)
 	fifo->port	= D0FIFO;
 	fifo->sel	= D0FIFOSEL;
 	fifo->ctr	= D0FIFOCTR;
-	fifo->tx_slave.slave_id	= usbhs_get_dparam(priv, d0_tx_id);
-	fifo->rx_slave.slave_id	= usbhs_get_dparam(priv, d0_rx_id);
+	fifo->tx_slave.simple_slave.slave_id	= usbhs_get_dparam(priv, d0_tx_id);
+	fifo->rx_slave.simple_slave.slave_id	= usbhs_get_dparam(priv, d0_rx_id);
 
 	/* D1FIFO */
 	fifo = usbhsf_get_d1fifo(priv);
@@ -1185,8 +1179,8 @@ int usbhs_fifo_probe(struct usbhs_priv *priv)
 	fifo->port	= D1FIFO;
 	fifo->sel	= D1FIFOSEL;
 	fifo->ctr	= D1FIFOCTR;
-	fifo->tx_slave.slave_id	= usbhs_get_dparam(priv, d1_tx_id);
-	fifo->rx_slave.slave_id	= usbhs_get_dparam(priv, d1_rx_id);
+	fifo->tx_slave.simple_slave.slave_id	= usbhs_get_dparam(priv, d1_tx_id);
+	fifo->rx_slave.simple_slave.slave_id	= usbhs_get_dparam(priv, d1_rx_id);
 
 	return 0;
 }
diff --git a/drivers/usb/renesas_usbhs/fifo.h b/drivers/usb/renesas_usbhs/fifo.h
index f68609c..c31731a 100644
--- a/drivers/usb/renesas_usbhs/fifo.h
+++ b/drivers/usb/renesas_usbhs/fifo.h
@@ -19,6 +19,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/sh_dma.h>
+#include <linux/workqueue.h>
 #include <asm/dma.h>
 #include "pipe.h"
 
@@ -31,7 +32,6 @@ struct usbhs_fifo {
 	u32 ctr;	/* xFIFOCTR */
 
 	struct usbhs_pipe	*pipe;
-	struct tasklet_struct	tasklet;
 
 	struct dma_chan		*tx_chan;
 	struct dma_chan		*rx_chan;
@@ -53,6 +53,7 @@ struct usbhs_pkt {
 	struct usbhs_pkt_handle *handler;
 	void (*done)(struct usbhs_priv *priv,
 		     struct usbhs_pkt *pkt);
+	struct work_struct work;
 	dma_addr_t dma;
 	void *buf;
 	int length;
-- 
1.7.2.5


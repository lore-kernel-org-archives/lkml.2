Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab2BPCoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 21:44:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61347 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756909Ab2BPCoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 21:44:13 -0500
MIME-Version: 1.0
Date: Thu, 16 Feb 2012 11:44:12 +0900
Message-ID: <CAOAMb1AVoJts+OVCm1L-n1t1mdyu=3eDxpC=+3Ums1BbHo4K3Q@mail.gmail.com>
Subject: [PATCH] amba-pl011/dma: Add check for the residue in DMA callback
From: Chanho Min <chanho0207@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In DMA-operated uart, I found that rx data can be taken by the UART
interrupts during
the DMA irq handler. pl011_int is occurred just before it goes inside
spin_lock_irq.
When it returns to the callback, DMA buffer already has been flushed.
Then, pl011_dma_rx_chars
gets invalid data. So I add check for the residue as the patch bellow.

Signed-off-by: Chanho Min <chanho.min@lge.com>
---
 drivers/tty/serial/amba-pl011.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 6800f5f..cc3ea06 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -827,7 +827,12 @@ static void pl011_dma_rx_callback(void *data)
 {
 	struct uart_amba_port *uap = data;
 	struct pl011_dmarx_data *dmarx = &uap->dmarx;
+	struct dma_chan *rxchan = dmarx->chan;
 	bool lastbuf = dmarx->use_buf_b;
+	struct pl011_sgbuf *sgbuf = dmarx->use_buf_b ?
+		&dmarx->sgbuf_b : &dmarx->sgbuf_a;
+	size_t pending;
+	struct dma_tx_state state;
 	int ret;

 	/*
@@ -838,11 +843,21 @@ static void pl011_dma_rx_callback(void *data)
 	 * we immediately trigger the next DMA job.
 	 */
 	spin_lock_irq(&uap->port.lock);
+	/*
+	 * Rx data can be taken by the UART interrupts during
+	 * the DMA irq handler. So we check the residue here.
+	 */
+	rxchan->device->device_tx_status(rxchan, dmarx->cookie, &state);
+	pending = sgbuf->sg.length - state.residue;
+	BUG_ON(pending > PL011_DMA_BUFFER_SIZE);
+	/* Then we terminate the transfer - we now know our residue */
+	dmaengine_terminate_all(rxchan);
+
 	uap->dmarx.running = false;
 	dmarx->use_buf_b = !lastbuf;
 	ret = pl011_dma_rx_trigger_dma(uap);

-	pl011_dma_rx_chars(uap, PL011_DMA_BUFFER_SIZE, lastbuf, false);
+	pl011_dma_rx_chars(uap, pending, lastbuf, false);
 	spin_unlock_irq(&uap->port.lock);
 	/*
 	 * Do this check after we picked the DMA chars so we don't
-- 
1.7.0.4

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212Ab1KWAks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:40:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757256Ab1KWAkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:40:45 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:06 2011
Message-Id: <20111123002406.394797983@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Alan Cox <alan@linux.intel.com>
Subject: [19/53] pch_uart: Fix DMA resource leak issue
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya.rohm@gmail.com>

commit 90f04c2926cfb5bf74533b0a7766bc896f6a0c0e upstream.

Changing UART mode PIO->DMA->PIO->DMA like below, pch_uart driver can't get
DMA channel resource.

setserial /dev/ttyPCH0 ^low_latency
setserial /dev/ttyPCH0 low_latency

CAUSE:
Changing mode using setserial command, ".startup" function which gets DMA
channel is called before ".verify_port" function which sets
dma-flag(use_dma/use_dma_flag) as 1.

PIO->DMA
  .startup: Since dma-flag is 0, DMA channel is not requested.
  .verify_port: dma-flag is set as 1.
  .shutdown: N/A

DMA->PIO
  .startup: Since dma-flag is 1, DMA channel is requested.
  .verify_port: dma-flag is set as 0.
  .shutdown: Since dma-flag is 0, DMA channel is not released.

This means DMA channel resource leak occurs.
Next time, this driver can't get DMA channel resource forever.

MODIFICATION:
  Currently, when release DMA channel resource, this driver checks dma-flag.
  However, this specification occurs the above issue.
  This driver must check whether dma_request_channel is executed or not.
  The values are saved in private data variable "chan_tx/chan_tx".
  These variables mean if the value is NULL, DMA channel is not requested,
  if not NULL, DMA channel is requested.

This patch fixes the issue.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/serial/pch_uart.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -625,6 +625,7 @@ static void pch_request_dma(struct uart_
 		dev_err(priv->port.dev, "%s:dma_request_channel FAILS(Rx)\n",
 			__func__);
 		dma_release_channel(priv->chan_tx);
+		priv->chan_tx = NULL;
 		return;
 	}
 
@@ -1212,8 +1213,7 @@ static void pch_uart_shutdown(struct uar
 		dev_err(priv->port.dev,
 			"pch_uart_hal_set_fifo Failed(ret=%d)\n", ret);
 
-	if (priv->use_dma_flag)
-		pch_free_dma(port);
+	pch_free_dma(port);
 
 	free_irq(priv->port.irq, priv);
 }



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab1KKB4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 20:56:30 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:39761 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149Ab1KKB42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 20:56:28 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Alan Cox <alan@linux.intel.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH] pch_uart: Fix DMA resource leak issue
Date: Fri, 11 Nov 2011 10:55:27 +0900
Message-Id: <1320976527-6142-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
X-Hosting-Pf: 0
X-NAI-Spam-Score: 2.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/tty/serial/pch_uart.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 21febef..284fa48 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -628,6 +628,7 @@ static void pch_request_dma(struct uart_port *port)
 		dev_err(priv->port.dev, "%s:dma_request_channel FAILS(Rx)\n",
 			__func__);
 		dma_release_channel(priv->chan_tx);
+		priv->chan_tx = NULL;
 		return;
 	}
 
@@ -1215,8 +1216,7 @@ static void pch_uart_shutdown(struct uart_port *port)
 		dev_err(priv->port.dev,
 			"pch_uart_hal_set_fifo Failed(ret=%d)\n", ret);
 
-	if (priv->use_dma_flag)
-		pch_free_dma(port);
+	pch_free_dma(port);
 
 	free_irq(priv->port.irq, priv);
 }
-- 
1.7.4.4


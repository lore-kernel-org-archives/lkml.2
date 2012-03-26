Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab2CZFn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 01:43:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52552 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab2CZFmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 01:42:38 -0400
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 7/7] pch_uart: Fix duplicate memory release issue
Date: Mon, 26 Mar 2012 14:43:06 +0900
Message-Id: <1332740586-28496-7-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332740586-28496-1-git-send-email-tomoya.rohm@gmail.com>
References: <1332740586-28496-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add initialize variable to prevent duplicate free memory.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/tty/serial/pch_uart.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 6e7f0ac..803847b 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -660,10 +660,13 @@ static void pch_free_dma(struct uart_port *port)
 		dma_release_channel(priv->chan_rx);
 		priv->chan_rx = NULL;
 	}
-	if (sg_dma_address(&priv->sg_rx))
-		dma_free_coherent(port->dev, port->fifosize,
-				  sg_virt(&priv->sg_rx),
-				  sg_dma_address(&priv->sg_rx));
+
+	if (priv->rx_buf_dma) {
+		dma_free_coherent(port->dev, port->fifosize, priv->rx_buf_virt,
+				  priv->rx_buf_dma);
+		priv->rx_buf_virt = NULL;
+		priv->rx_buf_dma = 0;
+	}
 
 	return;
 }
-- 
1.7.7.6


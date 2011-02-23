Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab1BWBFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:05:23 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:17340 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753737Ab1BWBEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:04:49 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Jesper Juhl <jj@chaosbits.net>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH linux-next 7/8] pch_uart: fix exclusive access issue
Date: Wed, 23 Feb 2011 10:03:18 +0900
Message-Id: <1298422999-4050-7-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1298422999-4050-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1298422999-4050-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/tty/serial/pch_uart.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index d937157..c525178 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -635,8 +635,7 @@ static void pch_dma_tx_complete(void *arg)
 	priv->tx_dma_use = 0;
 	priv->nent = 0;
 	kfree(priv->sg_tx_p);
-	if (uart_circ_chars_pending(xmit))
-		pch_uart_hal_enable_interrupt(priv, PCH_UART_HAL_TX_INT);
+	pch_uart_hal_enable_interrupt(priv, PCH_UART_HAL_TX_INT);
 }
 
 static int pop_tx(struct eg20t_port *priv, int size)
@@ -792,6 +791,14 @@ static unsigned int dma_handle_tx(struct eg20t_port *priv)
 		return 0;
 	}
 
+	if (priv->tx_dma_use) {
+		dev_dbg(priv->port.dev, "%s:Tx is not completed. (%lu)\n",
+			__func__, jiffies);
+		pch_uart_hal_disable_interrupt(priv, PCH_UART_HAL_TX_INT);
+		priv->tx_empty = 1;
+		return 0;
+	}
+
 	fifo_size = max(priv->fifo_size, 1);
 	tx_empty = 1;
 	if (pop_tx_x(priv, xmit->buf)) {
-- 
1.7.3.4


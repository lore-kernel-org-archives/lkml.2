Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab2C0IXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 04:23:16 -0400
Received: from smtp13.mail.ru ([94.100.176.90]:59963 "EHLO smtp13.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661Ab2C0IXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 04:23:08 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-arm-kernel@lists.infradead.org
Cc: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH] ARM: clps711x: serial driver hungs are a result of call disable_irq within ISR
Date: Tue, 27 Mar 2012 12:22:49 +0400
Message-Id: <1332836569-11726-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.7.3.4
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 2.6.30-rc1 clps711x serial driver hungs system. This is a result
of call disable_irq from ISR. synchronize_irq waits for end of interrupt
and goes to infinite loop. This patch fix this problem.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/tty/serial/clps711x.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/clps711x.c b/drivers/tty/serial/clps711x.c
index e6c3dbd..836fe273 100644
--- a/drivers/tty/serial/clps711x.c
+++ b/drivers/tty/serial/clps711x.c
@@ -154,10 +154,9 @@ static irqreturn_t clps711xuart_int_tx(int irq, void *dev_id)
 		port->x_char = 0;
 		return IRQ_HANDLED;
 	}
-	if (uart_circ_empty(xmit) || uart_tx_stopped(port)) {
-		clps711xuart_stop_tx(port);
-		return IRQ_HANDLED;
-	}
+
+	if (uart_circ_empty(xmit) || uart_tx_stopped(port))
+		goto disable_tx_irq;
 
 	count = port->fifosize >> 1;
 	do {
@@ -171,8 +170,11 @@ static irqreturn_t clps711xuart_int_tx(int irq, void *dev_id)
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(port);
 
-	if (uart_circ_empty(xmit))
-		clps711xuart_stop_tx(port);
+	if (uart_circ_empty(xmit)) {
+	disable_tx_irq:
+		disable_irq_nosync(TX_IRQ(port));
+		tx_enabled(port) = 0;
+	}
 
 	return IRQ_HANDLED;
 }
-- 
1.7.3.4


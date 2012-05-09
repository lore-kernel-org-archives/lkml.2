Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab2EIFwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:52:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38613 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079Ab2EIFwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:18 -0400
Message-Id: <20120509055030.317834781@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:50:34 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alexander Shiyan <shc_work@mail.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 005/167] [PATCH] ARM: clps711x: serial driver hungs are a result of call
 disable_irq within ISR
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shiyan <shc_work@mail.ru>

commit 7a6fbc9a887193a1e9f8658703881c528040afbc upstream.

Since 2.6.30-rc1 clps711x serial driver hungs system. This is a result
of call disable_irq from ISR. synchronize_irq waits for end of interrupt
and goes to infinite loop. This patch fix this problem.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/clps711x.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

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
1.7.10




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724Ab2DXWhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:37:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38637 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932686Ab2DXWhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:37:19 -0400
Message-Id: <20120424223253.891798385@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:32:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alexander Shiyan <shc_work@mail.ru>
Subject: [ 05/42] ARM: clps711x: serial driver hungs are a result of call disable_irq within ISR
In-Reply-To: <20120424223311.GA8456@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shiyan <shc_work@mail.ru>

commit 7a6fbc9a887193a1e9f8658703881c528040afbc upstream.

Since 2.6.30-rc1 clps711x serial driver hungs system. This is a result
of call disable_irq from ISR. synchronize_irq waits for end of interrupt
and goes to infinite loop. This patch fix this problem.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/clps711x.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/tty/serial/clps711x.c
+++ b/drivers/tty/serial/clps711x.c
@@ -154,10 +154,9 @@ static irqreturn_t clps711xuart_int_tx(i
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
@@ -171,8 +170,11 @@ static irqreturn_t clps711xuart_int_tx(i
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



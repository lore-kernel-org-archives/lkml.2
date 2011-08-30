Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab1H3Lxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 07:53:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37493 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab1H3Lxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 07:53:33 -0400
From: marcus.folkesson@gmail.com
To: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>
Subject: [PATCH] serial: pxa: work around for errata #20
Date: Tue, 30 Aug 2011 13:53:10 +0200
Message-Id: <1314705190-5819-2-git-send-email-marcus.folkesson@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314705190-5819-1-git-send-email-marcus.folkesson@gmail.com>
References: <y>
 <1314705190-5819-1-git-send-email-marcus.folkesson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcus Folkesson <marcus.folkesson@gmail.com>

Errata E20: UART: Character Timeout interrupt remains set under certain
software conditions.

Implication: The software servicing the UART can be trapped in an infinite loop.

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
---
 drivers/tty/serial/pxa.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/pxa.c b/drivers/tty/serial/pxa.c
index 531931c..5c8e3bb 100644
--- a/drivers/tty/serial/pxa.c
+++ b/drivers/tty/serial/pxa.c
@@ -100,6 +100,16 @@ static inline void receive_chars(struct uart_pxa_port *up, int *status)
 	int max_count = 256;
 
 	do {
+		/* work around Errata #20 according to
+		 * Intel(R) PXA27x Processor Family
+		 * Specification Update (May 2005)
+		 *
+		 * Step 2
+		 * Disable the Reciever Time Out Interrupt via IER[RTOEI]
+		 */
+		up->ier &= ~UART_IER_RTOIE;
+		serial_out(up, UART_IER, up->ier);
+
 		ch = serial_in(up, UART_RX);
 		flag = TTY_NORMAL;
 		up->port.icount.rx++;
@@ -156,6 +166,16 @@ static inline void receive_chars(struct uart_pxa_port *up, int *status)
 		*status = serial_in(up, UART_LSR);
 	} while ((*status & UART_LSR_DR) && (max_count-- > 0));
 	tty_flip_buffer_push(tty);
+
+	/* work around Errata #20 according to
+	 * Intel(R) PXA27x Processor Family
+	 * Specification Update (May 2005)
+	 *
+	 * Step 6:
+	 * No more data in FIFO: Re-enable RTO interrupt via IER[RTOIE]
+	 */
+	up->ier |= UART_IER_RTOIE;
+	serial_out(up, UART_IER, up->ier);
 }
 
 static void transmit_chars(struct uart_pxa_port *up)
-- 
1.7.4.1


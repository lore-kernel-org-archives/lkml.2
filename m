Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617Ab1KJDTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:19:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41549 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933598Ab1KJDTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:19:49 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:01 2011
Message-Id: <20111109212701.644148540@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:25:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Marcus Folkesson <marcus.folkesson@gmail.com>
Subject: [013/262] serial: pxa: work around for errata #20
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcus Folkesson <marcus.folkesson@gmail.com>

commit e44aabd649c80e8be16ede3ed3cbff6fb2561ca9 upstream.

Errata E20: UART: Character Timeout interrupt remains set under certain
software conditions.

Implication: The software servicing the UART can be trapped in an infinite loop.

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/serial/pxa.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/tty/serial/pxa.c
+++ b/drivers/tty/serial/pxa.c
@@ -100,6 +100,16 @@ static inline void receive_chars(struct
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
@@ -156,6 +166,16 @@ static inline void receive_chars(struct
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



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966380Ab2C3Veb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:34:31 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43653 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966322Ab2C3Vcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:32:50 -0400
X-Sasl-enc: 5ZQkPWkdeMDHECxBeh0j5HFQDaduKpiFn3hC6/FM8wvF 1333143169
X-Mailbox-Line: From gregkh@linuxfoundation.org Fri Mar 30 12:49:01 2012
Message-Id: <20120330194901.294070743@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:51:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Takashi Yoshii <takashi.yoshii.zj@renesas.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [ 175/175] serial: sh-sci: fix a race of DMA submit_tx on transfer
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yoshii Takashi <takashi.yoshii.zj@renesas.com>

commit 49d4bcaddca977fffdea8b0b71f6e5da96dac78e upstream.

When DMA is enabled, sh-sci transfer begins with
 uart_start()
  sci_start_tx()
    if (cookie_tx < 0) schedule_work()
Then, starts DMA when wq scheduled, -- (A)
 process_one_work()
  work_fn_rx()
   cookie_tx = desc->submit_tx()
And finishes when DMA transfer ends, -- (B)
 sci_dma_tx_complete()
  async_tx_ack()
  cookie_tx = -EINVAL
  (possible another schedule_work())

This A to B sequence is not reentrant, since controlling variables
(for example, cookie_tx above) are not queues nor lists. So, they
must be invoked as A B A B..., otherwise results in kernel crash.

To ensure the sequence, sci_start_tx() seems to test if cookie_tx < 0
(represents "not used") to call schedule_work().
But cookie_tx will not be set (to a cookie, also means "used") until
in the middle of work queue scheduled function work_fn_tx().

This gap between the test and set allows the breakage of the sequence
under the very frequently call of uart_start().
Another gap between async_tx_ack() and another schedule_work() results
in the same issue, too.

This patch introduces a new condition "cookie_tx == 0" just to mark
it is "busy" and assign it within spin-locked region to fill the gaps.

Signed-off-by: Takashi Yoshii <takashi.yoshii.zj@renesas.com>
Reviewed-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/sh-sci.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1229,17 +1229,20 @@ static void sci_dma_tx_complete(void *ar
 	port->icount.tx += sg_dma_len(&s->sg_tx);
 
 	async_tx_ack(s->desc_tx);
-	s->cookie_tx = -EINVAL;
 	s->desc_tx = NULL;
 
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(port);
 
 	if (!uart_circ_empty(xmit)) {
+		s->cookie_tx = 0;
 		schedule_work(&s->work_tx);
-	} else if (port->type == PORT_SCIFA || port->type == PORT_SCIFB) {
-		u16 ctrl = sci_in(port, SCSCR);
-		sci_out(port, SCSCR, ctrl & ~SCSCR_TIE);
+	} else {
+		s->cookie_tx = -EINVAL;
+		if (port->type == PORT_SCIFA || port->type == PORT_SCIFB) {
+			u16 ctrl = sci_in(port, SCSCR);
+			sci_out(port, SCSCR, ctrl & ~SCSCR_TIE);
+		}
 	}
 
 	spin_unlock_irqrestore(&port->lock, flags);
@@ -1501,8 +1504,10 @@ static void sci_start_tx(struct uart_por
 	}
 
 	if (s->chan_tx && !uart_circ_empty(&s->port.state->xmit) &&
-	    s->cookie_tx < 0)
+	    s->cookie_tx < 0) {
+		s->cookie_tx = 0;
 		schedule_work(&s->work_tx);
+	}
 #endif
 
 	if (!s->chan_tx || port->type == PORT_SCIFA || port->type == PORT_SCIFB) {



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab2BAVIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:08:43 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41102 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756088Ab2BAVIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:08:37 -0500
X-Sasl-enc: zG82SUpjY0ECusDQL8Epeho4nVI3F0QWu7T1DMmJnh13 1328130516
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:40 2012
Message-Id: <20120201205740.617324998@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:56:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Rabin Vincent <rabin.vincent@stericsson.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Bibek Basu <bibek.basu@stericsson.com>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [36/65] serial: amba-pl011: lock console writes against interrupts
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rabin Vincent <rabin.vincent@stericsson.com>

commit ef605fdb33883d687cff5ba75095a91b313b4966 upstream.

Protect against pl011_console_write() and the interrupt for
the console UART running concurrently on different CPUs.

Otherwise the console_write could spin for a long time
waiting for the UART to become not busy, while the other
CPU continuously services UART interrupts and keeps the
UART busy.

The checks for sysrq and oops_in_progress are taken
from 8250.c.

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Reviewed-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Reviewed-by: Bibek Basu <bibek.basu@stericsson.com>
Reviewed-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/amba-pl011.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1733,9 +1733,19 @@ pl011_console_write(struct console *co,
 {
 	struct uart_amba_port *uap = amba_ports[co->index];
 	unsigned int status, old_cr, new_cr;
+	unsigned long flags;
+	int locked = 1;
 
 	clk_enable(uap->clk);
 
+	local_irq_save(flags);
+	if (uap->port.sysrq)
+		locked = 0;
+	else if (oops_in_progress)
+		locked = spin_trylock(&uap->port.lock);
+	else
+		spin_lock(&uap->port.lock);
+
 	/*
 	 *	First save the CR then disable the interrupts
 	 */
@@ -1755,6 +1765,10 @@ pl011_console_write(struct console *co,
 	} while (status & UART01x_FR_BUSY);
 	writew(old_cr, uap->port.membase + UART011_CR);
 
+	if (locked)
+		spin_unlock(&uap->port.lock);
+	local_irq_restore(flags);
+
 	clk_disable(uap->clk);
 }
 



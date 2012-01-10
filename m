Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933792Ab2AJW7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 17:59:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52223 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933371Ab2AJW7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 17:59:17 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:46:19 2012
Message-Id: <20120110214619.771958676@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:45:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Claudio Scordino <claudio@evidence.eu.com>,
        Dave Bender <codehero@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Alan Cox <alan@linux.intel.com>
Subject: [18/40] atmel_serial: fix spinlock lockup in RS485 code
In-Reply-To: <20120110214630.GA14384@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudio Scordino <claudio@evidence.eu.com>

commit dbf1115d3f8c7052788aa4e6e46abd27f3b3eeba upstream.

Patch to fix a spinlock lockup in the driver that sometimes happens when the
tasklet starts.

Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
Signed-off-by: Dave Bender <codehero@gmail.com>
Tested-by: Dave Bender <codehero@gmail.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/serial/atmel_serial.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -199,8 +199,9 @@ void atmel_config_rs485(struct uart_port
 {
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	unsigned int mode;
+	unsigned long flags;
 
-	spin_lock(&port->lock);
+	spin_lock_irqsave(&port->lock, flags);
 
 	/* Disable interrupts */
 	UART_PUT_IDR(port, atmel_port->tx_done_mask);
@@ -231,7 +232,7 @@ void atmel_config_rs485(struct uart_port
 	/* Enable interrupts */
 	UART_PUT_IER(port, atmel_port->tx_done_mask);
 
-	spin_unlock(&port->lock);
+	spin_unlock_irqrestore(&port->lock, flags);
 
 }
 



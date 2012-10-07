Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab2JGXdX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:33:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38526 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754404Ab2JGXWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:55 -0400
Message-Id: <20121007225843.138318091@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:35 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Darren Hart <dvhart@linux.intel.com>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Feng Tang <feng.tang@intel.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 061/108] pch_uart: Add eg20t_port lock field, avoid recursive spinlocks
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darren Hart <dvhart@linux.intel.com>

commit 2588aba002d14e938c2f56d299ecf3e7ce1302a5 upstream.

pch_uart_interrupt() takes priv->port.lock which leads to two recursive
spinlock calls if low_latency==1 or CONFIG_PREEMPT_RT_FULL=y (one
otherwise):

pch_uart_interrupt
  spin_lock_irqsave(priv->port.lock, flags)
  case PCH_UART_IID_RDR_TO (data ready)
  handle_rx_to
    push_rx
      tty_port_tty_get
        spin_lock_irqsave(&port->lock, flags) <--- already hold this lock
        ...
      tty_flip_buffer_push
        ...
        flush_to_ldisc
          spin_lock_irqsave(&tty->buf.lock)
            spin_lock_irqsave(&tty->buf.lock)
            disc->ops->receive_buf(tty, char_buf)
              n_tty_receive_buf
                tty->ops->flush_chars()
                uart_flush_chars
                  uart_start
                    spin_lock_irqsave(&port->lock) <--- already hold this lock

Avoid this by using a dedicated lock to protect the eg20t_port structure
and IO access to its membase. This is more consistent with the 8250
driver.  Ensure priv->lock is always take prior to priv->port.lock when
taken at the same time.

V2: Remove inadvertent whitespace change.
V3: Account for oops_in_progress for the private lock in
    pch_console_write().

Note: Like the 8250 driver, if a printk is introduced anywhere inside
      the pch_console_write() critical section, the kernel will hang
      on a recursive spinlock on the private lock. The oops case is
      handled by using a trylock in the oops_in_progress case.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
CC: Tomoya MORINAGA <tomoya.rohm@gmail.com>
CC: Feng Tang <feng.tang@intel.com>
CC: Alexander Stein <alexander.stein@systec-electronic.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2:
 - Adjust context
 - Drop changes to pch_console_write()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/pch_uart.c |   38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -236,6 +236,9 @@ struct eg20t_port {
 	int				tx_dma_use;
 	void				*rx_buf_virt;
 	dma_addr_t			rx_buf_dma;
+
+	/* protect the eg20t_port private structure and io access to membase */
+	spinlock_t lock;
 };
 
 /**
@@ -964,7 +967,7 @@ static irqreturn_t pch_uart_interrupt(in
 	unsigned int iid;
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->port.lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 	handled = 0;
 	while ((iid = pch_uart_hal_get_iid(priv)) > 1) {
 		switch (iid) {
@@ -1017,7 +1020,7 @@ static irqreturn_t pch_uart_interrupt(in
 			priv->int_dis_flag = 0;
 	}
 
-	spin_unlock_irqrestore(&priv->port.lock, flags);
+	spin_unlock_irqrestore(&priv->lock, flags);
 	return IRQ_RETVAL(handled);
 }
 
@@ -1131,9 +1134,9 @@ static void pch_uart_break_ctl(struct ua
 	unsigned long flags;
 
 	priv = container_of(port, struct eg20t_port, port);
-	spin_lock_irqsave(&port->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 	pch_uart_hal_set_break(priv, ctl);
-	spin_unlock_irqrestore(&port->lock, flags);
+	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
 /* Grab any interrupt resources and initialise any low level driver state. */
@@ -1284,7 +1287,8 @@ static void pch_uart_set_termios(struct
 
 	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk / 16);
 
-	spin_lock_irqsave(&port->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock(&port->lock);
 
 	uart_update_timeout(port, termios->c_cflag, baud);
 	rtn = pch_uart_hal_set_line(priv, baud, parity, bits, stb);
@@ -1297,7 +1301,8 @@ static void pch_uart_set_termios(struct
 		tty_termios_encode_baud_rate(termios, baud, baud);
 
 out:
-	spin_unlock_irqrestore(&port->lock, flags);
+	spin_unlock(&port->lock);
+	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
 static const char *pch_uart_type(struct uart_port *port)
@@ -1449,6 +1454,8 @@ static struct eg20t_port *pch_uart_init_
 	pci_enable_msi(pdev);
 	pci_set_master(pdev);
 
+	spin_lock_init(&priv->lock);
+
 	iobase = pci_resource_start(pdev, 0);
 	mapbase = pci_resource_start(pdev, 1);
 	priv->mapbase = mapbase;



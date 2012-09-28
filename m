Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030940Ab2I1TMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:12:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33712 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030667Ab2I1TGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:06:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Darren Hart <dvhart@linux.intel.com>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Feng Tang <feng.tang@intel.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Alan Cox <alan@linux.intel.com>
Subject: [ 239/262] pch_uart: Add eg20t_port lock field, avoid recursive spinlocks
Date: Fri, 28 Sep 2012 11:52:48 -0700
Message-Id: <20120928183026.604479751@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/tty/serial/pch_uart.c |   38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -253,6 +253,9 @@ struct eg20t_port {
 	dma_addr_t			rx_buf_dma;
 
 	struct dentry	*debugfs;
+
+	/* protect the eg20t_port private structure and io access to membase */
+	spinlock_t lock;
 };
 
 /**
@@ -1060,7 +1063,7 @@ static irqreturn_t pch_uart_interrupt(in
 	int next = 1;
 	u8 msr;
 
-	spin_lock_irqsave(&priv->port.lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 	handled = 0;
 	while (next) {
 		iid = pch_uart_hal_get_iid(priv);
@@ -1120,7 +1123,7 @@ static irqreturn_t pch_uart_interrupt(in
 		handled |= (unsigned int)ret;
 	}
 
-	spin_unlock_irqrestore(&priv->port.lock, flags);
+	spin_unlock_irqrestore(&priv->lock, flags);
 	return IRQ_RETVAL(handled);
 }
 
@@ -1231,9 +1234,9 @@ static void pch_uart_break_ctl(struct ua
 	unsigned long flags;
 
 	priv = container_of(port, struct eg20t_port, port);
-	spin_lock_irqsave(&port->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 	pch_uart_hal_set_break(priv, ctl);
-	spin_unlock_irqrestore(&port->lock, flags);
+	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
 /* Grab any interrupt resources and initialise any low level driver state. */
@@ -1383,7 +1386,8 @@ static void pch_uart_set_termios(struct
 
 	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk / 16);
 
-	spin_lock_irqsave(&port->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock(&port->lock);
 
 	uart_update_timeout(port, termios->c_cflag, baud);
 	rtn = pch_uart_hal_set_line(priv, baud, parity, bits, stb);
@@ -1396,7 +1400,8 @@ static void pch_uart_set_termios(struct
 		tty_termios_encode_baud_rate(termios, baud, baud);
 
 out:
-	spin_unlock_irqrestore(&port->lock, flags);
+	spin_unlock(&port->lock);
+	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
 static const char *pch_uart_type(struct uart_port *port)
@@ -1545,8 +1550,9 @@ pch_console_write(struct console *co, co
 {
 	struct eg20t_port *priv;
 	unsigned long flags;
+	int priv_locked = 1;
+	int port_locked = 1;
 	u8 ier;
-	int locked = 1;
 
 	priv = pch_uart_ports[co->index];
 
@@ -1554,12 +1560,16 @@ pch_console_write(struct console *co, co
 
 	local_irq_save(flags);
 	if (priv->port.sysrq) {
-		/* serial8250_handle_port() already took the lock */
-		locked = 0;
+		spin_lock(&priv->lock);
+		/* serial8250_handle_port() already took the port lock */
+		port_locked = 0;
 	} else if (oops_in_progress) {
-		locked = spin_trylock(&priv->port.lock);
-	} else
+		priv_locked = spin_trylock(&priv->lock);
+		port_locked = spin_trylock(&priv->port.lock);
+	} else {
+		spin_lock(&priv->lock);
 		spin_lock(&priv->port.lock);
+	}
 
 	/*
 	 *	First save the IER then disable the interrupts
@@ -1577,8 +1587,10 @@ pch_console_write(struct console *co, co
 	wait_for_xmitr(priv, BOTH_EMPTY);
 	iowrite8(ier, priv->membase + UART_IER);
 
-	if (locked)
+	if (port_locked)
 		spin_unlock(&priv->port.lock);
+	if (priv_locked)
+		spin_unlock(&priv->lock);
 	local_irq_restore(flags);
 }
 
@@ -1676,6 +1688,8 @@ static struct eg20t_port *pch_uart_init_
 	pci_enable_msi(pdev);
 	pci_set_master(pdev);
 
+	spin_lock_init(&priv->lock);
+
 	iobase = pci_resource_start(pdev, 0);
 	mapbase = pci_resource_start(pdev, 1);
 	priv->mapbase = mapbase;



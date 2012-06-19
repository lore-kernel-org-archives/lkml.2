Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab2FSVAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 17:00:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48255 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab2FSVAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 17:00:37 -0400
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Feng Tang <feng.tang@intel.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: [PATCH V3] pch_uart: Add eg20t_port lock field, avoid recursive spinlocks
Date: Tue, 19 Jun 2012 14:00:18 -0700
Message-Id: <34b5e216a6dbd83d282dad22c2644136c652c34a.1340139586.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Alan Cox <alan@linux.intel.com>
CC: linux-serial@vger.kernel.org
---
 drivers/tty/serial/pch_uart.c |   38 ++++++++++++++++++++++++++------------
 1 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 4fdec6a..d291518 100644
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
@@ -1058,7 +1061,7 @@ static irqreturn_t pch_uart_interrupt(int irq, void *dev_id)
 	int next = 1;
 	u8 msr;
 
-	spin_lock_irqsave(&priv->port.lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 	handled = 0;
 	while (next) {
 		iid = pch_uart_hal_get_iid(priv);
@@ -1116,7 +1119,7 @@ static irqreturn_t pch_uart_interrupt(int irq, void *dev_id)
 		handled |= (unsigned int)ret;
 	}
 
-	spin_unlock_irqrestore(&priv->port.lock, flags);
+	spin_unlock_irqrestore(&priv->lock, flags);
 	return IRQ_RETVAL(handled);
 }
 
@@ -1226,9 +1229,9 @@ static void pch_uart_break_ctl(struct uart_port *port, int ctl)
 	unsigned long flags;
 
 	priv = container_of(port, struct eg20t_port, port);
-	spin_lock_irqsave(&port->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 	pch_uart_hal_set_break(priv, ctl);
-	spin_unlock_irqrestore(&port->lock, flags);
+	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
 /* Grab any interrupt resources and initialise any low level driver state. */
@@ -1376,7 +1379,8 @@ static void pch_uart_set_termios(struct uart_port *port,
 
 	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk / 16);
 
-	spin_lock_irqsave(&port->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock(&port->lock);
 
 	uart_update_timeout(port, termios->c_cflag, baud);
 	rtn = pch_uart_hal_set_line(priv, baud, parity, bits, stb);
@@ -1389,7 +1393,8 @@ static void pch_uart_set_termios(struct uart_port *port,
 		tty_termios_encode_baud_rate(termios, baud, baud);
 
 out:
-	spin_unlock_irqrestore(&port->lock, flags);
+	spin_unlock(&port->lock);
+	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
 static const char *pch_uart_type(struct uart_port *port)
@@ -1538,8 +1543,9 @@ pch_console_write(struct console *co, const char *s, unsigned int count)
 {
 	struct eg20t_port *priv;
 	unsigned long flags;
+	int priv_locked = 1;
+	int port_locked = 1;
 	u8 ier;
-	int locked = 1;
 
 	priv = pch_uart_ports[co->index];
 
@@ -1547,12 +1553,16 @@ pch_console_write(struct console *co, const char *s, unsigned int count)
 
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
@@ -1570,8 +1580,10 @@ pch_console_write(struct console *co, const char *s, unsigned int count)
 	wait_for_xmitr(priv, BOTH_EMPTY);
 	iowrite8(ier, priv->membase + UART_IER);
 
-	if (locked)
+	if (port_locked)
 		spin_unlock(&priv->port.lock);
+	if (priv_locked)
+		spin_unlock(&priv->lock);
 	local_irq_restore(flags);
 }
 
@@ -1669,6 +1681,8 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	pci_enable_msi(pdev);
 	pci_set_master(pdev);
 
+	spin_lock_init(&priv->lock);
+
 	iobase = pci_resource_start(pdev, 0);
 	mapbase = pci_resource_start(pdev, 1);
 	priv->mapbase = mapbase;
-- 
1.7.5.4


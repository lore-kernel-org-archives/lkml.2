Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028Ab2IFAE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 20:04:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:42659 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182Ab2IFAEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 20:04:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,377,1344236400"; 
   d="scan'208";a="218332977"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linux Stable <stable@vger.kernel.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Feng Tang <feng.tang@intel.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] pch_uart: Add eg20t_port lock field, avoid recursive spinlocks
Date: Wed,  5 Sep 2012 17:04:07 -0700
Message-Id: <422aa2054659680fb138d2153dcc852b2620b04d.1346889148.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch has been included in linux-next
(fe89def79c48e2149abdd1e816523e69a9067191) but has not yet landed in mainline
nor been queued for stable so far as I can determine. This patch addresses a
deadlock in mainline and is a prerequisite for an additional fix required by the
PREEMPT_RT kernel. Can we get this pulled into 3.4.11 please?  Perhaps I am
jumping the gun, but this patch was originally pulled on June 19, 2012.

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
 drivers/tty/serial/pch_uart.c | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index c2816f4..c4d8731 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -252,6 +252,9 @@ struct eg20t_port {
 	dma_addr_t			rx_buf_dma;
 
 	struct dentry	*debugfs;
+
+	/* protect the eg20t_port private structure and io access to membase */
+	spinlock_t lock;
 };
 
 /**
@@ -1056,7 +1059,7 @@ static irqreturn_t pch_uart_interrupt(int irq, void *dev_id)
 	unsigned int iid;
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->port.lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 	handled = 0;
 	while ((iid = pch_uart_hal_get_iid(priv)) > 1) {
 		switch (iid) {
@@ -1107,7 +1110,7 @@ static irqreturn_t pch_uart_interrupt(int irq, void *dev_id)
 			priv->int_dis_flag = 0;
 	}
 
-	spin_unlock_irqrestore(&priv->port.lock, flags);
+	spin_unlock_irqrestore(&priv->lock, flags);
 	return IRQ_RETVAL(handled);
 }
 
@@ -1218,9 +1221,9 @@ static void pch_uart_break_ctl(struct uart_port *port, int ctl)
 	unsigned long flags;
 
 	priv = container_of(port, struct eg20t_port, port);
-	spin_lock_irqsave(&port->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 	pch_uart_hal_set_break(priv, ctl);
-	spin_unlock_irqrestore(&port->lock, flags);
+	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
 /* Grab any interrupt resources and initialise any low level driver state. */
@@ -1368,7 +1371,8 @@ static void pch_uart_set_termios(struct uart_port *port,
 
 	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk / 16);
 
-	spin_lock_irqsave(&port->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock(&port->lock);
 
 	uart_update_timeout(port, termios->c_cflag, baud);
 	rtn = pch_uart_hal_set_line(priv, baud, parity, bits, stb);
@@ -1381,7 +1385,8 @@ static void pch_uart_set_termios(struct uart_port *port,
 		tty_termios_encode_baud_rate(termios, baud, baud);
 
 out:
-	spin_unlock_irqrestore(&port->lock, flags);
+	spin_unlock(&port->lock);
+	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
 static const char *pch_uart_type(struct uart_port *port)
@@ -1531,8 +1536,9 @@ pch_console_write(struct console *co, const char *s, unsigned int count)
 {
 	struct eg20t_port *priv;
 	unsigned long flags;
+	int priv_locked = 1;
+	int port_locked = 1;
 	u8 ier;
-	int locked = 1;
 
 	priv = pch_uart_ports[co->index];
 
@@ -1540,12 +1546,16 @@ pch_console_write(struct console *co, const char *s, unsigned int count)
 
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
@@ -1563,8 +1573,10 @@ pch_console_write(struct console *co, const char *s, unsigned int count)
 	wait_for_xmitr(priv, BOTH_EMPTY);
 	iowrite8(ier, priv->membase + UART_IER);
 
-	if (locked)
+	if (port_locked)
 		spin_unlock(&priv->port.lock);
+	if (priv_locked)
+		spin_unlock(&priv->lock);
 	local_irq_restore(flags);
 }
 
@@ -1662,6 +1674,8 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	pci_enable_msi(pdev);
 	pci_set_master(pdev);
 
+	spin_lock_init(&priv->lock);
+
 	iobase = pci_resource_start(pdev, 0);
 	mapbase = pci_resource_start(pdev, 1);
 	priv->mapbase = mapbase;
-- 
1.7.11.4


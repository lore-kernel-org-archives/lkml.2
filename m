Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954Ab2HVPTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:19:08 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57091 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab2HVPTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:19:00 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [RF CPATCH] tty: Split the serial_core helpers for setserial into two
To: greg@kroah.com, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 22 Aug 2012 16:36:26 +0100
Message-ID: <20120822144611.27192.38862.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the sysctl work we should I think do something like this. At that point the
sysctl helpers can get/set values via the existing driver interfaces

From: Alan Cox <alan@linux.intel.com>

We want them split so that we can call them from setserial functionality
where we copy to/from user space and do the locking, but also from sysfs
where in future we'll want to came them within a sysfs context.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/serial/serial_core.c |  158 +++++++++++++++++++++-----------------
 1 file changed, 87 insertions(+), 71 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 5b308c8..bb5f236 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -634,38 +634,44 @@ static void uart_unthrottle(struct tty_struct *tty)
 		uart_set_mctrl(port, TIOCM_RTS);
 }
 
-static int uart_get_info(struct uart_state *state,
-			 struct serial_struct __user *retinfo)
+static void uart_get_info(struct tty_port *port,
+                        struct uart_state *state,
+			struct serial_struct *retinfo)
 {
 	struct uart_port *uport = state->uart_port;
-	struct tty_port *port = &state->port;
-	struct serial_struct tmp;
-
-	memset(&tmp, 0, sizeof(tmp));
 
-	/* Ensure the state we copy is consistent and no hardware changes
-	   occur as we go */
-	mutex_lock(&port->mutex);
+	memset(retinfo, 0, sizeof(retinfo));
 
-	tmp.type	    = uport->type;
-	tmp.line	    = uport->line;
-	tmp.port	    = uport->iobase;
+	retinfo->type	    = uport->type;
+	retinfo->line	    = uport->line;
+	retinfo->port	    = uport->iobase;
 	if (HIGH_BITS_OFFSET)
-		tmp.port_high = (long) uport->iobase >> HIGH_BITS_OFFSET;
-	tmp.irq		    = uport->irq;
-	tmp.flags	    = uport->flags;
-	tmp.xmit_fifo_size  = uport->fifosize;
-	tmp.baud_base	    = uport->uartclk / 16;
-	tmp.close_delay	    = jiffies_to_msecs(port->close_delay) / 10;
-	tmp.closing_wait    = port->closing_wait == ASYNC_CLOSING_WAIT_NONE ?
+		retinfo->port_high = (long) uport->iobase >> HIGH_BITS_OFFSET;
+	retinfo->irq		    = uport->irq;
+	retinfo->flags	    = uport->flags;
+	retinfo->xmit_fifo_size  = uport->fifosize;
+	retinfo->baud_base	    = uport->uartclk / 16;
+	retinfo->close_delay	    = jiffies_to_msecs(port->close_delay) / 10;
+	retinfo->closing_wait    = port->closing_wait == ASYNC_CLOSING_WAIT_NONE ?
 				ASYNC_CLOSING_WAIT_NONE :
 				jiffies_to_msecs(port->closing_wait) / 10;
-	tmp.custom_divisor  = uport->custom_divisor;
-	tmp.hub6	    = uport->hub6;
-	tmp.io_type         = uport->iotype;
-	tmp.iomem_reg_shift = uport->regshift;
-	tmp.iomem_base      = (void *)(unsigned long)uport->mapbase;
+	retinfo->custom_divisor  = uport->custom_divisor;
+	retinfo->hub6	    = uport->hub6;
+	retinfo->io_type         = uport->iotype;
+	retinfo->iomem_reg_shift = uport->regshift;
+	retinfo->iomem_base      = (void *)(unsigned long)uport->mapbase;
+}
+
+static int uart_get_info_user(struct uart_state *state,
+			 struct serial_struct __user *retinfo)
+{
+	struct tty_port *port = &state->port;
+	struct serial_struct tmp;
 
+	/* Ensure the state we copy is consistent and no hardware changes
+	   occur as we go */
+	mutex_lock(&port->mutex);
+	uart_get_info(port, state, &tmp);
 	mutex_unlock(&port->mutex);
 
 	if (copy_to_user(retinfo, &tmp, sizeof(*retinfo)))
@@ -673,42 +679,30 @@ static int uart_get_info(struct uart_state *state,
 	return 0;
 }
 
-static int uart_set_info(struct tty_struct *tty, struct uart_state *state,
-			 struct serial_struct __user *newinfo)
+static int uart_set_info(struct tty_struct *tty, struct tty_port *port,
+			 struct uart_state *state,
+			 struct serial_struct *new_info)
 {
-	struct serial_struct new_serial;
 	struct uart_port *uport = state->uart_port;
-	struct tty_port *port = &state->port;
 	unsigned long new_port;
 	unsigned int change_irq, change_port, closing_wait;
 	unsigned int old_custom_divisor, close_delay;
 	upf_t old_flags, new_flags;
 	int retval = 0;
 
-	if (copy_from_user(&new_serial, newinfo, sizeof(new_serial)))
-		return -EFAULT;
-
-	new_port = new_serial.port;
+	new_port = new_info->port;
 	if (HIGH_BITS_OFFSET)
-		new_port += (unsigned long) new_serial.port_high << HIGH_BITS_OFFSET;
+		new_port += (unsigned long) new_info->port_high << HIGH_BITS_OFFSET;
 
-	new_serial.irq = irq_canonicalize(new_serial.irq);
-	close_delay = msecs_to_jiffies(new_serial.close_delay * 10);
-	closing_wait = new_serial.closing_wait == ASYNC_CLOSING_WAIT_NONE ?
+	new_info->irq = irq_canonicalize(new_info->irq);
+	close_delay = msecs_to_jiffies(new_info->close_delay * 10);
+	closing_wait = new_info->closing_wait == ASYNC_CLOSING_WAIT_NONE ?
 			ASYNC_CLOSING_WAIT_NONE :
-			msecs_to_jiffies(new_serial.closing_wait * 10);
+			msecs_to_jiffies(new_info->closing_wait * 10);
 
-	/*
-	 * This semaphore protects port->count.  It is also
-	 * very useful to prevent opens.  Also, take the
-	 * port configuration semaphore to make sure that a
-	 * module insertion/removal doesn't change anything
-	 * under us.
-	 */
-	mutex_lock(&port->mutex);
 
 	change_irq  = !(uport->flags & UPF_FIXED_PORT)
-		&& new_serial.irq != uport->irq;
+		&& new_info->irq != uport->irq;
 
 	/*
 	 * Since changing the 'type' of the port changes its resource
@@ -717,29 +711,29 @@ static int uart_set_info(struct tty_struct *tty, struct uart_state *state,
 	 */
 	change_port = !(uport->flags & UPF_FIXED_PORT)
 		&& (new_port != uport->iobase ||
-		    (unsigned long)new_serial.iomem_base != uport->mapbase ||
-		    new_serial.hub6 != uport->hub6 ||
-		    new_serial.io_type != uport->iotype ||
-		    new_serial.iomem_reg_shift != uport->regshift ||
-		    new_serial.type != uport->type);
+		    (unsigned long)new_info->iomem_base != uport->mapbase ||
+		    new_info->hub6 != uport->hub6 ||
+		    new_info->io_type != uport->iotype ||
+		    new_info->iomem_reg_shift != uport->regshift ||
+		    new_info->type != uport->type);
 
 	old_flags = uport->flags;
-	new_flags = new_serial.flags;
+	new_flags = new_info->flags;
 	old_custom_divisor = uport->custom_divisor;
 
 	if (!capable(CAP_SYS_ADMIN)) {
 		retval = -EPERM;
 		if (change_irq || change_port ||
-		    (new_serial.baud_base != uport->uartclk / 16) ||
+		    (new_info->baud_base != uport->uartclk / 16) ||
 		    (close_delay != port->close_delay) ||
 		    (closing_wait != port->closing_wait) ||
-		    (new_serial.xmit_fifo_size &&
-		     new_serial.xmit_fifo_size != uport->fifosize) ||
+		    (new_info->xmit_fifo_size &&
+		     new_info->xmit_fifo_size != uport->fifosize) ||
 		    (((new_flags ^ old_flags) & ~UPF_USR_MASK) != 0))
 			goto exit;
 		uport->flags = ((uport->flags & ~UPF_USR_MASK) |
 			       (new_flags & UPF_USR_MASK));
-		uport->custom_divisor = new_serial.custom_divisor;
+		uport->custom_divisor = new_info->custom_divisor;
 		goto check_and_exit;
 	}
 
@@ -747,10 +741,10 @@ static int uart_set_info(struct tty_struct *tty, struct uart_state *state,
 	 * Ask the low level driver to verify the settings.
 	 */
 	if (uport->ops->verify_port)
-		retval = uport->ops->verify_port(uport, &new_serial);
+		retval = uport->ops->verify_port(uport, new_info);
 
-	if ((new_serial.irq >= nr_irqs) || (new_serial.irq < 0) ||
-	    (new_serial.baud_base < 9600))
+	if ((new_info->irq >= nr_irqs) || (new_info->irq < 0) ||
+	    (new_info->baud_base < 9600))
 		retval = -EINVAL;
 
 	if (retval)
@@ -790,11 +784,11 @@ static int uart_set_info(struct tty_struct *tty, struct uart_state *state,
 			uport->ops->release_port(uport);
 
 		uport->iobase = new_port;
-		uport->type = new_serial.type;
-		uport->hub6 = new_serial.hub6;
-		uport->iotype = new_serial.io_type;
-		uport->regshift = new_serial.iomem_reg_shift;
-		uport->mapbase = (unsigned long)new_serial.iomem_base;
+		uport->type = new_info->type;
+		uport->hub6 = new_info->hub6;
+		uport->iotype = new_info->io_type;
+		uport->regshift = new_info->iomem_reg_shift;
+		uport->mapbase = (unsigned long)new_info->iomem_base;
 
 		/*
 		 * Claim and map the new regions
@@ -835,16 +829,16 @@ static int uart_set_info(struct tty_struct *tty, struct uart_state *state,
 	}
 
 	if (change_irq)
-		uport->irq      = new_serial.irq;
+		uport->irq      = new_info->irq;
 	if (!(uport->flags & UPF_FIXED_PORT))
-		uport->uartclk  = new_serial.baud_base * 16;
+		uport->uartclk  = new_info->baud_base * 16;
 	uport->flags            = (uport->flags & ~UPF_CHANGE_MASK) |
 				 (new_flags & UPF_CHANGE_MASK);
-	uport->custom_divisor   = new_serial.custom_divisor;
+	uport->custom_divisor   = new_info->custom_divisor;
 	port->close_delay     = close_delay;
 	port->closing_wait    = closing_wait;
-	if (new_serial.xmit_fifo_size)
-		uport->fifosize = new_serial.xmit_fifo_size;
+	if (new_info->xmit_fifo_size)
+		uport->fifosize = new_info->xmit_fifo_size;
 	if (port->tty)
 		port->tty->low_latency =
 			(uport->flags & UPF_LOW_LATENCY) ? 1 : 0;
@@ -873,6 +867,28 @@ static int uart_set_info(struct tty_struct *tty, struct uart_state *state,
 	} else
 		retval = uart_startup(tty, state, 1);
  exit:
+	return retval;
+}
+
+static int uart_set_info_user(struct tty_struct *tty, struct uart_state *state,
+			 struct serial_struct __user *newinfo)
+{
+	struct serial_struct new_serial;
+	struct tty_port *port = &state->port;
+	int retval;
+
+	if (copy_from_user(&new_serial, newinfo, sizeof(new_serial)))
+		return -EFAULT;
+
+	/*
+	 * This semaphore protects port->count.  It is also
+	 * very useful to prevent opens.  Also, take the
+	 * port configuration semaphore to make sure that a
+	 * module insertion/removal doesn't change anything
+	 * under us.
+	 */
+	mutex_lock(&port->mutex);
+	retval = uart_set_info(tty, port, state, &new_serial);
 	mutex_unlock(&port->mutex);
 	return retval;
 }
@@ -1115,11 +1131,11 @@ uart_ioctl(struct tty_struct *tty, unsigned int cmd,
 	 */
 	switch (cmd) {
 	case TIOCGSERIAL:
-		ret = uart_get_info(state, uarg);
+		ret = uart_get_info_user(state, uarg);
 		break;
 
 	case TIOCSSERIAL:
-		ret = uart_set_info(tty, state, uarg);
+		ret = uart_set_info_user(tty, state, uarg);
 		break;
 
 	case TIOCSERCONFIG:


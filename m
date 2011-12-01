Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab1LAXsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 18:48:35 -0500
Received: from mail.windriver.com ([147.11.1.11]:33229 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531Ab1LAXrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 18:47:52 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: gregkh@suse.de, alan@linux.intel.com, galak@kernel.crashing.org,
        scottwood@freescale.com
Cc: linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] serial: make bugs field not specific to 8250 type uarts.
Date: Thu,  1 Dec 2011 18:47:36 -0500
Message-Id: <1322783258-20443-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1322783258-20443-1-git-send-email-paul.gortmaker@windriver.com>
References: <1322783258-20443-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a struct uart_8250_port that is private to 8250.c
itself, and it had a bugs field.  But there is no reason to
assume that hardware bugs are unique to 8250 type UARTS.

Make the bugs field part of the globally visible struct
uart_port and remove the 8250 specific one.

The value in doing so is that it helps pave the way for
allowing arch or platform specific code to pass in information
to the specific uart drivers about uart bugs known to impact
certain platforms that would otherwise be hard to detect from
within the context of the driver itself.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/tty/serial/8250.c   |   25 ++++++++++++-------------
 include/linux/serial_core.h |    1 +
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index eeadf1b..7c94dbc 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -134,7 +134,6 @@ struct uart_8250_port {
 	struct timer_list	timer;		/* "no irq" timer */
 	struct list_head	list;		/* ports on this IRQ */
 	unsigned short		capabilities;	/* port capabilities */
-	unsigned short		bugs;		/* port bugs */
 	unsigned int		tx_loadsz;	/* transmit fifo load size */
 	unsigned char		acr;
 	unsigned char		ier;
@@ -828,7 +827,7 @@ static void autoconfig_has_efr(struct uart_8250_port *up)
 		 * when DLL is 0.
 		 */
 		if (id3 == 0x52 && rev == 0x01)
-			up->bugs |= UART_BUG_QUOT;
+			up->port.bugs |= UART_BUG_QUOT;
 		return;
 	}
 
@@ -1102,7 +1101,7 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 	spin_lock_irqsave(&up->port.lock, flags);
 
 	up->capabilities = 0;
-	up->bugs = 0;
+	up->port.bugs = 0;
 
 	if (!(up->port.flags & UPF_BUGGY_UART)) {
 		/*
@@ -1337,7 +1336,7 @@ static void serial8250_start_tx(struct uart_port *port)
 		up->ier |= UART_IER_THRI;
 		serial_out(up, UART_IER, up->ier);
 
-		if (up->bugs & UART_BUG_TXEN) {
+		if (port->bugs & UART_BUG_TXEN) {
 			unsigned char lsr;
 			lsr = serial_in(up, UART_LSR);
 			up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
@@ -1373,7 +1372,7 @@ static void serial8250_enable_ms(struct uart_port *port)
 		container_of(port, struct uart_8250_port, port);
 
 	/* no MSR capabilities */
-	if (up->bugs & UART_BUG_NOMSR)
+	if (port->bugs & UART_BUG_NOMSR)
 		return;
 
 	up->ier |= UART_IER_MSI;
@@ -2089,7 +2088,7 @@ static int serial8250_startup(struct uart_port *port)
 		 * kick the UART on a regular basis.
 		 */
 		if (!(iir1 & UART_IIR_NO_INT) && (iir & UART_IIR_NO_INT)) {
-			up->bugs |= UART_BUG_THRE;
+			port->bugs |= UART_BUG_THRE;
 			pr_debug("ttyS%d - using backup timer\n",
 				 serial_index(port));
 		}
@@ -2099,7 +2098,7 @@ static int serial8250_startup(struct uart_port *port)
 	 * The above check will only give an accurate result the first time
 	 * the port is opened so this value needs to be preserved.
 	 */
-	if (up->bugs & UART_BUG_THRE) {
+	if (port->bugs & UART_BUG_THRE) {
 		up->timer.function = serial8250_backup_timeout;
 		up->timer.data = (unsigned long)up;
 		mod_timer(&up->timer, jiffies +
@@ -2162,13 +2161,13 @@ static int serial8250_startup(struct uart_port *port)
 	serial_outp(up, UART_IER, 0);
 
 	if (lsr & UART_LSR_TEMT && iir & UART_IIR_NO_INT) {
-		if (!(up->bugs & UART_BUG_TXEN)) {
-			up->bugs |= UART_BUG_TXEN;
+		if (!(port->bugs & UART_BUG_TXEN)) {
+			port->bugs |= UART_BUG_TXEN;
 			pr_debug("ttyS%d - enabling bad tx status workarounds\n",
 				 serial_index(port));
 		}
 	} else {
-		up->bugs &= ~UART_BUG_TXEN;
+		port->bugs &= ~UART_BUG_TXEN;
 	}
 
 dont_test_tx_en:
@@ -2323,7 +2322,7 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 	/*
 	 * Oxford Semi 952 rev B workaround
 	 */
-	if (up->bugs & UART_BUG_QUOT && (quot & 0xff) == 0)
+	if (port->bugs & UART_BUG_QUOT && (quot & 0xff) == 0)
 		quot++;
 
 	if (up->capabilities & UART_CAP_FIFO && up->port.fifosize > 1) {
@@ -2390,7 +2389,7 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 	 * CTS flow control flag and modem status interrupts
 	 */
 	up->ier &= ~UART_IER_MSI;
-	if (!(up->bugs & UART_BUG_NOMSR) &&
+	if (!(port->bugs & UART_BUG_NOMSR) &&
 			UART_ENABLE_MS(&up->port, termios->c_cflag))
 		up->ier |= UART_IER_MSI;
 	if (up->capabilities & UART_CAP_UUE)
@@ -2666,7 +2665,7 @@ static void serial8250_config_port(struct uart_port *port, int flags)
 
 	/* if access method is AU, it is a 16550 with a quirk */
 	if (up->port.type == PORT_16550A && up->port.iotype == UPIO_AU)
-		up->bugs |= UART_BUG_NOMSR;
+		port->bugs |= UART_BUG_NOMSR;
 
 	if (up->port.type != PORT_UNKNOWN && flags & UART_CONFIG_IRQ)
 		autoconfig_irq(up);
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index eadf33d..791536c 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -323,6 +323,7 @@ struct uart_port {
 
 	unsigned int		read_status_mask;	/* driver specific */
 	unsigned int		ignore_status_mask;	/* driver specific */
+	unsigned short		bugs;			/* driver specific */
 	struct uart_state	*state;			/* pointer to parent state */
 	struct uart_icount	icount;			/* statistics */
 
-- 
1.7.7


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582Ab0HJWB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:01:29 -0400
Received: from kroah.org ([198.145.64.141]:45094 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933531Ab0HJWBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:01:04 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Philippe Langlais <philippe.langlais@stericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 68/68] U6715 16550A serial driver support
Date: Tue, 10 Aug 2010 14:59:30 -0700
Message-Id: <1281477570-18944-68-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100810214425.GB17385@kroah.com>
References: <20100810214425.GB17385@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Langlais <philippe.langlais@stericsson.com>

UART Features extract from STEricsson U6715 data-sheet (arm926 SoC for mobile phone):
* Fully compatible with industry standard 16C550 and 16C450 from various
manufacturers
* RX and TX 64 byte FIFO reduces CPU interrupts
* Full double buffering
* Modem control signals include CTS, RTS, (and DSR, DTR on UART1 only)
* Automatic baud rate selection
* Manual or automatic RTS/CTS smart hardware flow control
* Programmable serial characteristics:
– Baud rate generation (50 to 3.25M baud)
– 5, 6, 7 or 8-bit characters
– Even, odd or no-parity bit generation and detection
– 1, 1.5 or 2 stop bit generation
* Independent control of transmit, receive, line status, data set interrupts and FIFOs
* Full status-reporting capabilities
* Separate DMA signaling for RX and TX
* Timed interrupt to spread receive interrupt on known duration
* DMA time-out interrupt to allow detection of end of reception
* Carkit pulse coding and decoding compliant with USB carkit control interface [40]

In 16550A auto-configuration, if the fifo size is 64 then it's an U6 16550A port
Add set_termios hook & export serial8250_do_set_termios to change uart
clock following baudrate

Signed-off-by: Philippe Langlais <philippe.langlais@stericsson.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/8250.c       |   37 ++++++++++++++++++++++++++++++++++---
 include/linux/serial.h      |    3 ++-
 include/linux/serial_8250.h |    5 +++++
 include/linux/serial_core.h |    3 +++
 4 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 355148d..24110f6 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -300,6 +300,13 @@ static const struct serial8250_config uart_config[] = {
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_00,
 		.flags		= UART_CAP_FIFO | UART_CAP_AFE,
 	},
+	[PORT_U6_16550A] = {
+		.name		= "U6_16550A",
+		.fifo_size	= 64,
+		.tx_loadsz	= 64,
+		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
+		.flags		= UART_CAP_FIFO | UART_CAP_AFE,
+	},
 };
 
 #if defined(CONFIG_MIPS_ALCHEMY)
@@ -1070,6 +1077,15 @@ static void autoconfig_16550a(struct uart_8250_port *up)
 		DEBUG_AUTOCONF("Couldn't force IER_UUE to 0 ");
 	}
 	serial_outp(up, UART_IER, iersave);
+
+	/*
+	 * We distinguish between 16550A and U6 16550A by counting
+	 * how many bytes are in the FIFO.
+	 */
+	if (up->port.type == PORT_16550A && size_fifo(up) == 64) {
+		up->port.type = PORT_U6_16550A;
+		up->capabilities |= UART_CAP_AFE;
+	}
 }
 
 /*
@@ -2224,9 +2240,9 @@ static unsigned int serial8250_get_divisor(struct uart_port *port, unsigned int
 	return quot;
 }
 
-static void
-serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
-		       struct ktermios *old)
+void
+serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
+		          struct ktermios *old)
 {
 	struct uart_8250_port *up = (struct uart_8250_port *)port;
 	unsigned char cval, fcr = 0;
@@ -2402,6 +2418,17 @@ serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
 	if (tty_termios_baud_rate(termios))
 		tty_termios_encode_baud_rate(termios, baud, baud);
 }
+EXPORT_SYMBOL(serial8250_do_set_termios);
+
+static void
+serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
+		       struct ktermios *old)
+{
+	if (port->set_termios)
+		port->set_termios(port, termios, old);
+	else
+		serial8250_do_set_termios(port, termios, old);
+}
 
 static void
 serial8250_set_ldisc(struct uart_port *port, int new)
@@ -2982,6 +3009,7 @@ static int __devinit serial8250_probe(struct platform_device *dev)
 		port.type		= p->type;
 		port.serial_in		= p->serial_in;
 		port.serial_out		= p->serial_out;
+		port.set_termios	= p->set_termios;
 		port.dev		= &dev->dev;
 		port.irqflags		|= irqflag;
 		ret = serial8250_register_port(&port);
@@ -3145,6 +3173,9 @@ int serial8250_register_port(struct uart_port *port)
 			uart->port.serial_in = port->serial_in;
 		if (port->serial_out)
 			uart->port.serial_out = port->serial_out;
+		/*  Possibly override set_termios call */
+		if (port->set_termios)
+			uart->port.set_termios = port->set_termios;
 
 		ret = uart_add_one_port(&serial8250_reg, &uart->port);
 		if (ret == 0)
diff --git a/include/linux/serial.h b/include/linux/serial.h
index ef91406..1ebc694 100644
--- a/include/linux/serial.h
+++ b/include/linux/serial.h
@@ -77,7 +77,8 @@ struct serial_struct {
 #define PORT_16654	11
 #define PORT_16850	12
 #define PORT_RSA	13	/* RSA-DV II/S card */
-#define PORT_MAX	13
+#define PORT_U6_16550A	14
+#define PORT_MAX	14
 
 #define SERIAL_IO_PORT	0
 #define SERIAL_IO_HUB6	1
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index fb46aba..7638dea 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -32,6 +32,9 @@ struct plat_serial8250_port {
 	unsigned int	type;		/* If UPF_FIXED_TYPE */
 	unsigned int	(*serial_in)(struct uart_port *, int);
 	void		(*serial_out)(struct uart_port *, int, int);
+	void		(*set_termios)(struct uart_port *,
+			               struct ktermios *new,
+			               struct ktermios *old);
 };
 
 /*
@@ -71,5 +74,7 @@ extern int early_serial_setup(struct uart_port *port);
 extern int serial8250_find_port(struct uart_port *p);
 extern int serial8250_find_port_for_earlycon(void);
 extern int setup_early_serial8250_console(char *cmdline);
+extern void serial8250_do_set_termios(struct uart_port *port,
+		struct ktermios *termios, struct ktermios *old);
 
 #endif
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index f8fce35..8129ca2 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -282,6 +282,9 @@ struct uart_port {
 	unsigned char __iomem	*membase;		/* read/write[bwl] */
 	unsigned int		(*serial_in)(struct uart_port *, int);
 	void			(*serial_out)(struct uart_port *, int, int);
+	void			(*set_termios)(struct uart_port *,
+				               struct ktermios *new,
+				               struct ktermios *old);
 	unsigned int		irq;			/* irq number */
 	unsigned long		irqflags;		/* irq flags  */
 	unsigned int		uartclk;		/* base uart clock */
-- 
1.7.2


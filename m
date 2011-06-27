Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab1F0Vrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 17:47:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52414 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab1F0VqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 17:46:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Kiyokazu SUTO <suto@ks-and-ks.ne.jp>,
        linux-serial@vger.kernel.org
Subject: [PATCH 5/7] serial/8250: remove obsolete and broken PORT_RSA support
Date: Mon, 27 Jun 2011 23:45:18 +0200
Message-Id: <1309211120-2803-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309211120-2803-1-git-send-email-arnd@arndb.de>
References: <1309211120-2803-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Ba+LRxJ/ZJfZNNSmdiZEnAwy83zF6ceTc8ffcfBWub7
 AVn1FMbXOhOO4aGmAi1o8AOV+XGkdDcSnhyBcMpW6DID8hOoZ1
 0Tpc0vIBdUEpF+5SCyhRPpgH6LkqErovhQvZQg78c+AZqAio6h
 QNZEr7LaciCwF/OYU0JKnJ3f5YvwR4y1GkMDnGvRajmCBJUqRf
 TS6/bvIE2cGmgcfE0GAZg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For all I can tell, the RSA support in the 8250 driver
is not functional and has not been for a long time.

The RSA-DV II/S ISA card[1] was sold by IODATA in the
1990s as a faster alternative to regular ISA serial ports,
and it was discontinued in 2002. Linux support was added
by Kiyokazu SUTO in 2000.

The driver defines an I/O port base address of -8 (negative
eight), which should always get refused by request_region
on all architectures for being outside of the valid
resource range.

Further, it seems that a patch to setserial would be
required in order to set PORT_RSA when not using
autoconfiguration.

This patch removes all code related to the RSA support, with
the exception of the user-visible PORT_RSA definition.
Some of the code has been copied into the sunsu.c driver,
so remove it from there as well.

[1] http://translate.google.com/translate?hl=en&sl=ja&u=http://www.iodata.jp/products/network/rsadv2s.htm

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Kiyokazu SUTO <suto@ks-and-ks.ne.jp>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-serial@vger.kernel.org
---
 drivers/tty/serial/8250.c   |  200 ++-----------------------------------------
 drivers/tty/serial/Kconfig  |    6 --
 drivers/tty/serial/sunsu.c  |   93 --------------------
 include/linux/serial.h      |    2 +-
 include/linux/serial_core.h |    2 +-
 include/linux/serial_reg.h  |   51 -----------
 6 files changed, 10 insertions(+), 344 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index 5698157..0ddba34 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -116,13 +116,6 @@ static const struct old_serial_port old_serial_port[] = {
 
 #define UART_NR	CONFIG_SERIAL_8250_NR_UARTS
 
-#ifdef CONFIG_SERIAL_8250_RSA
-
-#define PORT_RSA_MAX 4
-static unsigned long probe_rsa[PORT_RSA_MAX];
-static unsigned int probe_rsa_count;
-#endif /* CONFIG_SERIAL_8250_RSA  */
-
 struct uart_8250_port {
 	struct uart_port	port;
 	struct timer_list	timer;		/* "no irq" timer */
@@ -246,13 +239,6 @@ static const struct serial8250_config uart_config[] = {
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
 		.flags		= UART_CAP_FIFO | UART_CAP_EFR | UART_CAP_SLEEP,
 	},
-	[PORT_RSA] = {
-		.name		= "RSA",
-		.fifo_size	= 2048,
-		.tx_loadsz	= 2048,
-		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_11,
-		.flags		= UART_CAP_FIFO,
-	},
 	[PORT_NS16550A] = {
 		.name		= "NS16550A",
 		.fifo_size	= 16,
@@ -488,75 +474,6 @@ static void serial8250_set_sleep(struct uart_8250_port *p, int sleep)
 	}
 }
 
-#ifdef CONFIG_SERIAL_8250_RSA
-/*
- * Attempts to turn on the RSA FIFO.  Returns zero on failure.
- * We set the port uart clock rate if we succeed.
- */
-static int __enable_rsa(struct uart_8250_port *up)
-{
-	unsigned char mode;
-	int result;
-
-	mode = serial_inp(up, UART_RSA_MSR);
-	result = mode & UART_RSA_MSR_FIFO;
-
-	if (!result) {
-		serial_outp(up, UART_RSA_MSR, mode | UART_RSA_MSR_FIFO);
-		mode = serial_inp(up, UART_RSA_MSR);
-		result = mode & UART_RSA_MSR_FIFO;
-	}
-
-	if (result)
-		up->port.uartclk = SERIAL_RSA_BAUD_BASE * 16;
-
-	return result;
-}
-
-static void enable_rsa(struct uart_8250_port *up)
-{
-	if (up->port.type == PORT_RSA) {
-		if (up->port.uartclk != SERIAL_RSA_BAUD_BASE * 16) {
-			spin_lock_irq(&up->port.lock);
-			__enable_rsa(up);
-			spin_unlock_irq(&up->port.lock);
-		}
-		if (up->port.uartclk == SERIAL_RSA_BAUD_BASE * 16)
-			serial_outp(up, UART_RSA_FRR, 0);
-	}
-}
-
-/*
- * Attempts to turn off the RSA FIFO.  Returns zero on failure.
- * It is unknown why interrupts were disabled in here.  However,
- * the caller is expected to preserve this behaviour by grabbing
- * the spinlock before calling this function.
- */
-static void disable_rsa(struct uart_8250_port *up)
-{
-	unsigned char mode;
-	int result;
-
-	if (up->port.type == PORT_RSA &&
-	    up->port.uartclk == SERIAL_RSA_BAUD_BASE * 16) {
-		spin_lock_irq(&up->port.lock);
-
-		mode = serial_inp(up, UART_RSA_MSR);
-		result = !(mode & UART_RSA_MSR_FIFO);
-
-		if (!result) {
-			serial_outp(up, UART_RSA_MSR, mode & ~UART_RSA_MSR_FIFO);
-			mode = serial_inp(up, UART_RSA_MSR);
-			result = !(mode & UART_RSA_MSR_FIFO);
-		}
-
-		if (result)
-			up->port.uartclk = SERIAL_RSA_BAUD_BASE_LO * 16;
-		spin_unlock_irq(&up->port.lock);
-	}
-}
-#endif /* CONFIG_SERIAL_8250_RSA */
-
 /*
  * This is a quickie test to see how big the FIFO is.
  * It doesn't work at all the time, more's the pity.
@@ -1042,23 +959,6 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 		break;
 	}
 
-#ifdef CONFIG_SERIAL_8250_RSA
-	/*
-	 * Only probe for RSA ports if we got the region.
-	 */
-	if (up->port.type == PORT_16550A && probeflags & PROBE_RSA) {
-		int i;
-
-		for (i = 0 ; i < probe_rsa_count; ++i) {
-			if (probe_rsa[i] == up->port.iobase &&
-			    __enable_rsa(up)) {
-				up->port.type = PORT_RSA;
-				break;
-			}
-		}
-	}
-#endif
-
 	serial_outp(up, UART_LCR, save_lcr);
 
 	if (up->capabilities != uart_config[up->port.type].flags) {
@@ -1078,10 +978,6 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 	/*
 	 * Reset the UART.
 	 */
-#ifdef CONFIG_SERIAL_8250_RSA
-	if (up->port.type == PORT_RSA)
-		serial_outp(up, UART_RSA_FRR, 0);
-#endif
 	serial_outp(up, UART_MCR, save_mcr);
 	serial8250_clear_fifos(up);
 	serial_in(up, UART_RX);
@@ -1836,14 +1732,6 @@ static int serial8250_startup(struct uart_port *port)
 		serial_outp(up, UART_LCR, 0);
 	}
 
-#ifdef CONFIG_SERIAL_8250_RSA
-	/*
-	 * If this is an RSA port, see if we can kick it up to the
-	 * higher speed clock.
-	 */
-	enable_rsa(up);
-#endif
-
 	/*
 	 * Clear the FIFO buffers and disable them.
 	 * (they will be reenabled in set_termios())
@@ -2067,13 +1955,6 @@ static void serial8250_shutdown(struct uart_port *port)
 	serial_out(up, UART_LCR, serial_inp(up, UART_LCR) & ~UART_LCR_SBC);
 	serial8250_clear_fifos(up);
 
-#ifdef CONFIG_SERIAL_8250_RSA
-	/*
-	 * Reset the RSA board back to 115kbps compat mode.
-	 */
-	disable_rsa(up);
-#endif
-
 	/*
 	 * Read data port to reset things, and then unlink from
 	 * the IRQ chain.
@@ -2344,8 +2225,10 @@ static unsigned int serial8250_port_size(struct uart_8250_port *pt)
 /*
  * Resource handling.
  */
-static int serial8250_request_std_resource(struct uart_8250_port *up)
+static int serial8250_request_port(struct uart_port *port)
 {
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
 	unsigned int size = serial8250_port_size(up);
 	int ret = 0;
 
@@ -2381,8 +2264,10 @@ static int serial8250_request_std_resource(struct uart_8250_port *up)
 	return ret;
 }
 
-static void serial8250_release_std_resource(struct uart_8250_port *up)
+static void serial8250_release_port(struct uart_port *port)
 {
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
 	unsigned int size = serial8250_port_size(up);
 
 	switch (up->port.iotype) {
@@ -2408,65 +2293,6 @@ static void serial8250_release_std_resource(struct uart_8250_port *up)
 	}
 }
 
-static int serial8250_request_rsa_resource(struct uart_8250_port *up)
-{
-	unsigned long start = UART_RSA_BASE << up->port.regshift;
-	unsigned int size = 8 << up->port.regshift;
-	int ret = -EINVAL;
-
-	switch (up->port.iotype) {
-	case UPIO_HUB6:
-	case UPIO_PORT:
-		start += up->port.iobase;
-		if (request_region(start, size, "serial-rsa"))
-			ret = 0;
-		else
-			ret = -EBUSY;
-		break;
-	}
-
-	return ret;
-}
-
-static void serial8250_release_rsa_resource(struct uart_8250_port *up)
-{
-	unsigned long offset = UART_RSA_BASE << up->port.regshift;
-	unsigned int size = 8 << up->port.regshift;
-
-	switch (up->port.iotype) {
-	case UPIO_HUB6:
-	case UPIO_PORT:
-		release_region(up->port.iobase + offset, size);
-		break;
-	}
-}
-
-static void serial8250_release_port(struct uart_port *port)
-{
-	struct uart_8250_port *up =
-		container_of(port, struct uart_8250_port, port);
-
-	serial8250_release_std_resource(up);
-	if (up->port.type == PORT_RSA)
-		serial8250_release_rsa_resource(up);
-}
-
-static int serial8250_request_port(struct uart_port *port)
-{
-	struct uart_8250_port *up =
-		container_of(port, struct uart_8250_port, port);
-	int ret = 0;
-
-	ret = serial8250_request_std_resource(up);
-	if (ret == 0 && up->port.type == PORT_RSA) {
-		ret = serial8250_request_rsa_resource(up);
-		if (ret < 0)
-			serial8250_release_std_resource(up);
-	}
-
-	return ret;
-}
-
 static void serial8250_config_port(struct uart_port *port, int flags)
 {
 	struct uart_8250_port *up =
@@ -2478,14 +2304,10 @@ static void serial8250_config_port(struct uart_port *port, int flags)
 	 * Find the region that we can probe for.  This in turn
 	 * tells us whether we can probe for the type of port.
 	 */
-	ret = serial8250_request_std_resource(up);
+	ret = serial8250_request_port(port);
 	if (ret < 0)
 		return;
 
-	ret = serial8250_request_rsa_resource(up);
-	if (ret < 0)
-		probeflags &= ~PROBE_RSA;
-
 	if (up->port.iotype != up->cur_iotype)
 		set_io_from_upio(port);
 
@@ -2499,10 +2321,8 @@ static void serial8250_config_port(struct uart_port *port, int flags)
 	if (up->port.type != PORT_UNKNOWN && flags & UART_CONFIG_IRQ)
 		autoconfig_irq(up);
 
-	if (up->port.type != PORT_RSA && probeflags & PROBE_RSA)
-		serial8250_release_rsa_resource(up);
 	if (up->port.type == PORT_UNKNOWN)
-		serial8250_release_std_resource(up);
+		serial8250_release_port(port);
 }
 
 static int
@@ -3198,8 +3018,4 @@ MODULE_PARM_DESC(nr_uarts, "Maximum number of UARTs supported. (1-" __MODULE_STR
 module_param(skip_txen_test, uint, 0644);
 MODULE_PARM_DESC(skip_txen_test, "Skip checking for the TXEN bug at init time");
 
-#ifdef CONFIG_SERIAL_8250_RSA
-module_param_array(probe_rsa, ulong, &probe_rsa_count, 0444);
-MODULE_PARM_DESC(probe_rsa, "Probe I/O ports for RSA");
-#endif
 MODULE_ALIAS_CHARDEV_MAJOR(TTY_MAJOR);
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index ea12815..3ec604f 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -235,12 +235,6 @@ config SERIAL_8250_DETECT_IRQ
 
 	  If unsure, say N.
 
-config SERIAL_8250_RSA
-	bool "Support RSA serial ports"
-	depends on SERIAL_8250_EXTENDED
-	help
-	  ::: To be written :::
-
 config SERIAL_8250_MCA
 	tristate "Support 8250-type ports on MCA buses"
 	depends on SERIAL_8250 != n && MCA
diff --git a/drivers/tty/serial/sunsu.c b/drivers/tty/serial/sunsu.c
index 92aa545..a52af85 100644
--- a/drivers/tty/serial/sunsu.c
+++ b/drivers/tty/serial/sunsu.c
@@ -75,7 +75,6 @@ static const struct serial_uart_config uart_config[PORT_MAX_8250+1] = {
 	{ "16C950/954",	128,	UART_CLEAR_FIFO | UART_USE_FIFO },
 	{ "ST16654",	64,	UART_CLEAR_FIFO | UART_USE_FIFO | UART_STARTECH },
 	{ "XR16850",	128,	UART_CLEAR_FIFO | UART_USE_FIFO | UART_STARTECH },
-	{ "RSA",	2048,	UART_CLEAR_FIFO | UART_USE_FIFO }
 };
 
 struct uart_sunsu_port {
@@ -179,75 +178,6 @@ static unsigned int serial_icr_read(struct uart_sunsu_port *up, int offset)
 }
 #endif
 
-#ifdef CONFIG_SERIAL_8250_RSA
-/*
- * Attempts to turn on the RSA FIFO.  Returns zero on failure.
- * We set the port uart clock rate if we succeed.
- */
-static int __enable_rsa(struct uart_sunsu_port *up)
-{
-	unsigned char mode;
-	int result;
-
-	mode = serial_inp(up, UART_RSA_MSR);
-	result = mode & UART_RSA_MSR_FIFO;
-
-	if (!result) {
-		serial_outp(up, UART_RSA_MSR, mode | UART_RSA_MSR_FIFO);
-		mode = serial_inp(up, UART_RSA_MSR);
-		result = mode & UART_RSA_MSR_FIFO;
-	}
-
-	if (result)
-		up->port.uartclk = SERIAL_RSA_BAUD_BASE * 16;
-
-	return result;
-}
-
-static void enable_rsa(struct uart_sunsu_port *up)
-{
-	if (up->port.type == PORT_RSA) {
-		if (up->port.uartclk != SERIAL_RSA_BAUD_BASE * 16) {
-			spin_lock_irq(&up->port.lock);
-			__enable_rsa(up);
-			spin_unlock_irq(&up->port.lock);
-		}
-		if (up->port.uartclk == SERIAL_RSA_BAUD_BASE * 16)
-			serial_outp(up, UART_RSA_FRR, 0);
-	}
-}
-
-/*
- * Attempts to turn off the RSA FIFO.  Returns zero on failure.
- * It is unknown why interrupts were disabled in here.  However,
- * the caller is expected to preserve this behaviour by grabbing
- * the spinlock before calling this function.
- */
-static void disable_rsa(struct uart_sunsu_port *up)
-{
-	unsigned char mode;
-	int result;
-
-	if (up->port.type == PORT_RSA &&
-	    up->port.uartclk == SERIAL_RSA_BAUD_BASE * 16) {
-		spin_lock_irq(&up->port.lock);
-
-		mode = serial_inp(up, UART_RSA_MSR);
-		result = !(mode & UART_RSA_MSR_FIFO);
-
-		if (!result) {
-			serial_outp(up, UART_RSA_MSR, mode & ~UART_RSA_MSR_FIFO);
-			mode = serial_inp(up, UART_RSA_MSR);
-			result = !(mode & UART_RSA_MSR_FIFO);
-		}
-
-		if (result)
-			up->port.uartclk = SERIAL_RSA_BAUD_BASE_LO * 16;
-		spin_unlock_irq(&up->port.lock);
-	}
-}
-#endif /* CONFIG_SERIAL_8250_RSA */
-
 static inline void __stop_tx(struct uart_sunsu_port *p)
 {
 	if (p->ier & UART_IER_THRI) {
@@ -626,14 +556,6 @@ static int sunsu_startup(struct uart_port *port)
 		serial_outp(up, UART_LCR, 0);
 	}
 
-#ifdef CONFIG_SERIAL_8250_RSA
-	/*
-	 * If this is an RSA port, see if we can kick it up to the
-	 * higher speed clock.
-	 */
-	enable_rsa(up);
-#endif
-
 	/*
 	 * Clear the FIFO buffers and disable them.
 	 * (they will be reenabled in set_termios())
@@ -748,13 +670,6 @@ static void sunsu_shutdown(struct uart_port *port)
 				  UART_FCR_CLEAR_XMIT);
 	serial_outp(up, UART_FCR, 0);
 
-#ifdef CONFIG_SERIAL_8250_RSA
-	/*
-	 * Reset the RSA board back to 115kbps compat mode.
-	 */
-	disable_rsa(up);
-#endif
-
 	/*
 	 * Read data port to reset things.
 	 */
@@ -810,10 +725,6 @@ sunsu_change_speed(struct uart_port *port, unsigned int cflag,
 	if (uart_config[up->port.type].flags & UART_USE_FIFO) {
 		if ((up->port.uartclk / quot) < (2400 * 16))
 			fcr = UART_FCR_ENABLE_FIFO | UART_FCR_TRIGGER_1;
-#ifdef CONFIG_SERIAL_8250_RSA
-		else if (up->port.type == PORT_RSA)
-			fcr = UART_FCR_ENABLE_FIFO | UART_FCR_TRIGGER_14;
-#endif
 		else
 			fcr = UART_FCR_ENABLE_FIFO | UART_FCR_TRIGGER_8;
 	}
@@ -1156,10 +1067,6 @@ static void sunsu_autoconfig(struct uart_sunsu_port *up)
 	/*
 	 * Reset the UART.
 	 */
-#ifdef CONFIG_SERIAL_8250_RSA
-	if (up->port.type == PORT_RSA)
-		serial_outp(up, UART_RSA_FRR, 0);
-#endif
 	serial_outp(up, UART_MCR, save_mcr);
 	serial_outp(up, UART_FCR, (UART_FCR_ENABLE_FIFO |
 				     UART_FCR_CLEAR_RCVR |
diff --git a/include/linux/serial.h b/include/linux/serial.h
index ef91406..7bf30a6 100644
--- a/include/linux/serial.h
+++ b/include/linux/serial.h
@@ -76,7 +76,7 @@ struct serial_struct {
 #define PORT_16C950	10	/* Oxford Semiconductor */
 #define PORT_16654	11
 #define PORT_16850	12
-#define PORT_RSA	13	/* RSA-DV II/S card */
+#define PORT_RSA	13	/* obsolete RSA-DV II/S card */
 #define PORT_MAX	13
 
 #define SERIAL_IO_PORT	0
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 598992f..f84c560 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -38,7 +38,7 @@
 #define PORT_16C950	10
 #define PORT_16654	11
 #define PORT_16850	12
-#define PORT_RSA	13
+/* #define PORT_RSA	13 */	/* was: RSA-DV II/S */
 #define PORT_NS16550A	14
 #define PORT_XSCALE	15
 /* #define PORT_RM9000	16 */	/* was: PMC-Sierra RM9xxx internal UART */
diff --git a/include/linux/serial_reg.h b/include/linux/serial_reg.h
index c75bda3..4fa3d59 100644
--- a/include/linux/serial_reg.h
+++ b/include/linux/serial_reg.h
@@ -284,57 +284,6 @@
 #define UART_ACR_ICRRD	0x40	/* ICR Read enable */
 #define UART_ACR_ASREN	0x80	/* Additional status enable */
 
-
-
-/*
- * These definitions are for the RSA-DV II/S card, from
- *
- * Kiyokazu SUTO <suto@ks-and-ks.ne.jp>
- */
-
-#define UART_RSA_BASE (-8)
-
-#define UART_RSA_MSR ((UART_RSA_BASE) + 0) /* I/O: Mode Select Register */
-
-#define UART_RSA_MSR_SWAP (1 << 0) /* Swap low/high 8 bytes in I/O port addr */
-#define UART_RSA_MSR_FIFO (1 << 2) /* Enable the external FIFO */
-#define UART_RSA_MSR_FLOW (1 << 3) /* Enable the auto RTS/CTS flow control */
-#define UART_RSA_MSR_ITYP (1 << 4) /* Level (1) / Edge triger (0) */
-
-#define UART_RSA_IER ((UART_RSA_BASE) + 1) /* I/O: Interrupt Enable Register */
-
-#define UART_RSA_IER_Rx_FIFO_H (1 << 0) /* Enable Rx FIFO half full int. */
-#define UART_RSA_IER_Tx_FIFO_H (1 << 1) /* Enable Tx FIFO half full int. */
-#define UART_RSA_IER_Tx_FIFO_E (1 << 2) /* Enable Tx FIFO empty int. */
-#define UART_RSA_IER_Rx_TOUT (1 << 3) /* Enable char receive timeout int */
-#define UART_RSA_IER_TIMER (1 << 4) /* Enable timer interrupt */
-
-#define UART_RSA_SRR ((UART_RSA_BASE) + 2) /* IN: Status Read Register */
-
-#define UART_RSA_SRR_Tx_FIFO_NEMP (1 << 0) /* Tx FIFO is not empty (1) */
-#define UART_RSA_SRR_Tx_FIFO_NHFL (1 << 1) /* Tx FIFO is not half full (1) */
-#define UART_RSA_SRR_Tx_FIFO_NFUL (1 << 2) /* Tx FIFO is not full (1) */
-#define UART_RSA_SRR_Rx_FIFO_NEMP (1 << 3) /* Rx FIFO is not empty (1) */
-#define UART_RSA_SRR_Rx_FIFO_NHFL (1 << 4) /* Rx FIFO is not half full (1) */
-#define UART_RSA_SRR_Rx_FIFO_NFUL (1 << 5) /* Rx FIFO is not full (1) */
-#define UART_RSA_SRR_Rx_TOUT (1 << 6) /* Character reception timeout occurred (1) */
-#define UART_RSA_SRR_TIMER (1 << 7) /* Timer interrupt occurred */
-
-#define UART_RSA_FRR ((UART_RSA_BASE) + 2) /* OUT: FIFO Reset Register */
-
-#define UART_RSA_TIVSR ((UART_RSA_BASE) + 3) /* I/O: Timer Interval Value Set Register */
-
-#define UART_RSA_TCR ((UART_RSA_BASE) + 4) /* OUT: Timer Control Register */
-
-#define UART_RSA_TCR_SWITCH (1 << 0) /* Timer on */
-
-/*
- * The RSA DSV/II board has two fixed clock frequencies.  One is the
- * standard rate, and the other is 8 times faster.
- */
-#define SERIAL_RSA_BAUD_BASE (921600)
-#define SERIAL_RSA_BAUD_BASE_LO (SERIAL_RSA_BAUD_BASE / 8)
-
 /*
  * Extra serial register definitions for the internal UARTs
  * in TI OMAP processors.
-- 
1.7.5.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626Ab2JZMQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 08:16:25 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50544 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336Ab2JZMQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 08:16:21 -0400
Date: Fri, 26 Oct 2012 15:10:32 +0300
From: Felipe Balbi <balbi@ti.com>
To: <Vineet.Gupta1@synopsys.com>
CC: <gregkh@linuxfoundation.org>, <alan@linux.intel.com>,
        <arc-linux-dev@synopsys.com>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] serial/arc-uart: Add new driver
Message-ID: <20121026121032.GD26342@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1351252996-28484-1-git-send-email-vgupta@synopsys.com>
 <1351252996-28484-2-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q0rSlbzrZN6k9QnT"
Content-Disposition: inline
In-Reply-To: <1351252996-28484-2-git-send-email-vgupta@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Q0rSlbzrZN6k9QnT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 26, 2012 at 05:33:16PM +0530, Vineet.Gupta1@synopsys.com wrote:
> From: Vineet Gupta <vgupta@synopsys.com>
>=20
> Driver for non-standard on-chip UART, instantiated in the ARC (Synopsys)
> FPGA Boards such as ARCAngel4/ML50x
>=20
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> ---
>  drivers/tty/serial/Kconfig       |   23 ++
>  drivers/tty/serial/Makefile      |    1 +
>  drivers/tty/serial/arc_uart.c    |  754 ++++++++++++++++++++++++++++++++=
++++++
>  include/uapi/linux/serial_core.h |    2 +
>  4 files changed, 780 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/tty/serial/arc_uart.c
>=20
> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> index 2a53be5..b176801 100644
> --- a/drivers/tty/serial/Kconfig
> +++ b/drivers/tty/serial/Kconfig
> @@ -1423,4 +1423,27 @@ config SERIAL_EFM32_UART_CONSOLE
>  	depends on SERIAL_EFM32_UART=3Dy
>  	select SERIAL_CORE_CONSOLE
> =20
> +config SERIAL_ARC
> +	tristate "ARC UART driver support"
> +	select SERIAL_CORE
> +	help
> +	  Driver for on-chip UART for ARC(Synopsys) for the legacy
> +	  FPGA Boards (ML50x/ARCAngel4)
> +
> +config SERIAL_ARC_CONSOLE
> +	bool "Console on ARC UART"
> +	depends on SERIAL_ARC=3Dy
> +	select SERIAL_CORE_CONSOLE
> +	help
> +	  Enable system Console on ARC UART
> +
> +config SERIAL_ARC_NR_PORTS
> +	int "Number of ARC UART ports"
> +	depends on SERIAL_ARC
> +	range 1 3
> +	default "1"
> +	help
> +	  Set this to the number of serial ports you want the driver
> +	  to support.
> +
>  endmenu
> diff --git a/drivers/tty/serial/Makefile b/drivers/tty/serial/Makefile
> index 4f694da..df1b998 100644
> --- a/drivers/tty/serial/Makefile
> +++ b/drivers/tty/serial/Makefile
> @@ -82,3 +82,4 @@ obj-$(CONFIG_SERIAL_XILINX_PS_UART) +=3D xilinx_uartps.o
>  obj-$(CONFIG_SERIAL_SIRFSOC) +=3D sirfsoc_uart.o
>  obj-$(CONFIG_SERIAL_AR933X)   +=3D ar933x_uart.o
>  obj-$(CONFIG_SERIAL_EFM32_UART) +=3D efm32-uart.o
> +obj-$(CONFIG_SERIAL_ARC)	+=3D arc_uart.o
> diff --git a/drivers/tty/serial/arc_uart.c b/drivers/tty/serial/arc_uart.c
> new file mode 100644
> index 0000000..c12efae
> --- /dev/null
> +++ b/drivers/tty/serial/arc_uart.c
> @@ -0,0 +1,754 @@
> +/*
> + * ARC On-Chip(fpga) UART Driver
> + *
> + * Copyright (C) 2010-2012 Synopsys, Inc. (www.synopsys.com)
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * vineetg: July 10th 2012
> + *  -Decoupled the driver from arch/arc
> + *    +Using platform_get_resource() for irq/membase (thx to bfin_uart.c)
> + *    +Using early_platform_xxx() for early console (thx to mach-shmobil=
e/xxx)
> + *
> + * Vineetg: Aug 21st 2010
> + *  -Is uart_tx_stopped() not done in tty write path as it has already b=
een
> + *   taken care of, in serial core
> + *
> + * Vineetg: Aug 18th 2010
> + *  -New Serial Core based ARC UART driver
> + *  -Derived largely from blackfin driver albiet with some major tweaks
> + *
> + * TODO:
> + *  -check if sysreq works
> + */
> +
> +#if defined(CONFIG_SERIAL_ARC_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
> +#define SUPPORT_SYSRQ
> +#endif
> +
> +#include <linux/module.h>
> +#include <linux/serial.h>
> +#include <linux/console.h>
> +#include <linux/sysrq.h>
> +#include <linux/platform_device.h>
> +#include <linux/tty.h>
> +#include <linux/tty_flip.h>
> +#include <linux/serial_core.h>
> +#include <linux/io.h>
> +
> +/*************************************
> + * ARC UART Hardware Specs
> + ************************************/
> +#define ARC_UART_TX_FIFO_SIZE  1
> +
> +/*
> + * UART Register set (this is not a Standards Compliant IP)
> + * Also each reg is Word aligned, but only 8 bits wide
> + */
> +#define R_ID0	0
> +#define R_ID1	4
> +#define R_ID2	8
> +#define R_ID3	12
> +#define R_DATA	16
> +#define R_STS	20
> +#define R_BAUDL	24
> +#define R_BAUDH	28
> +
> +/* Bits for UART Status Reg (R/W) */
> +#define RXIENB  0x04	/* Receive Interrupt Enable */
> +#define TXIENB  0x40	/* Transmit Interrupt Enable */
> +
> +#define RXEMPTY 0x20	/* Receive FIFO Empty: No char receivede */
> +#define TXEMPTY 0x80	/* Transmit FIFO Empty, thus char can be written in=
to */
> +
> +#define RXFULL  0x08	/* Receive FIFO full */
> +#define RXFULL1 0x10	/* Receive FIFO has space for 1 char (tot space=3D4=
) */
> +
> +#define RXFERR  0x01	/* Frame Error: Stop Bit not detected */
> +#define RXOERR  0x02	/* OverFlow Err: Char recv but RXFULL still set */
> +
> +/* Uart bit fiddling helpers: lowest level */
> +#define RBASE(uart, reg)      (uart->port.membase + reg)
> +#define UART_REG_SET(u, r, v) writeb((v), RBASE(u, r))
> +#define UART_REG_GET(u, r)    readb(RBASE(u, r))
> +
> +#define UART_REG_OR(u, r, v)  UART_REG_SET(u, r, UART_REG_GET(u, r) | (v=
))
> +#define UART_REG_CLR(u, r, v) UART_REG_SET(u, r, UART_REG_GET(u, r) & ~(=
v))
> +
> +/* Uart bit fiddling helpers: API level */
> +#define UART_SET_DATA(uart, val)   UART_REG_SET(uart, R_DATA, val)
> +#define UART_GET_DATA(uart)        UART_REG_GET(uart, R_DATA)
> +
> +#define UART_SET_BAUDH(uart, val)  UART_REG_SET(uart, R_BAUDH, val)
> +#define UART_SET_BAUDL(uart, val)  UART_REG_SET(uart, R_BAUDL, val)
> +
> +#define UART_CLR_STATUS(uart, val) UART_REG_CLR(uart, R_STS, val)
> +#define UART_GET_STATUS(uart)      UART_REG_GET(uart, R_STS)
> +
> +#define UART_ALL_IRQ_DISABLE(uart) UART_REG_CLR(uart, R_STS, RXIENB|TXIE=
NB)
> +#define UART_RX_IRQ_DISABLE(uart)  UART_REG_CLR(uart, R_STS, RXIENB)
> +#define UART_TX_IRQ_DISABLE(uart)  UART_REG_CLR(uart, R_STS, TXIENB)
> +
> +#define UART_ALL_IRQ_ENABLE(uart)  UART_REG_OR(uart, R_STS, RXIENB|TXIEN=
B)
> +#define UART_RX_IRQ_ENABLE(uart)   UART_REG_OR(uart, R_STS, RXIENB)
> +#define UART_TX_IRQ_ENABLE(uart)   UART_REG_OR(uart, R_STS, TXIENB)
> +
> +#define ARC_SERIAL_DEV_NAME	"ttyARC"
> +
> +struct arc_uart_port {
> +	struct uart_port port;
> +	unsigned long baud;
> +	int is_emulated;	/* H/w vs. Instruction Set Simulator */
> +};
> +
> +static struct arc_uart_port arc_uart_ports[CONFIG_SERIAL_ARC_NR_PORTS];
> +
> +#ifdef CONFIG_SERIAL_ARC_CONSOLE
> +static struct console arc_console;
> +#endif
> +
> +#define DRIVER_NAME	"arc-uart"
> +
> +static struct uart_driver arc_uart_driver =3D {
> +	.owner		=3D THIS_MODULE,
> +	.driver_name	=3D DRIVER_NAME,
> +	.dev_name	=3D ARC_SERIAL_DEV_NAME,
> +	.major		=3D 0,
> +	.minor		=3D 0,
> +	.nr		=3D CONFIG_SERIAL_ARC_NR_PORTS,
> +#ifdef CONFIG_SERIAL_ARC_CONSOLE
> +	.cons		=3D &arc_console,
> +#else
> +	.cons		=3D NULL,

else branch isn't necessary. The structure is declared static and
everything is initialized to zero unless overwritten by code.

> +#endif
> +};
> +
> +static void arc_serial_stop_rx(struct uart_port *port)
> +{
> +	struct arc_uart_port *uart =3D (struct arc_uart_port *)port;

I would suggest using container_of() here. It's very unlikely to happen,
but if another field is added before struct uart_port member in your
structure, this will break.

> +	UART_RX_IRQ_DISABLE(uart);
> +}
> +
> +static void arc_serial_stop_tx(struct uart_port *port)
> +{
> +	struct arc_uart_port *uart =3D (struct arc_uart_port *)port;
> +
> +	while (!(UART_GET_STATUS(uart) & TXEMPTY))
> +		cpu_relax();
> +
> +	UART_TX_IRQ_DISABLE(uart);
> +}
> +
> +/*
> + * Return TIOCSER_TEMT when transmitter is not busy.
> + */
> +static unsigned int arc_serial_tx_empty(struct uart_port *port)
> +{
> +	struct arc_uart_port *uart =3D (struct arc_uart_port *)port;
> +	unsigned int stat;
> +
> +	stat =3D UART_GET_STATUS(uart);
> +	if (stat & TXEMPTY)
> +		return TIOCSER_TEMT;
> +	else
> +		return 0;

else is unnecessary you can convert this into:

	if (stat & TXEMPTY)
		return TIOCSER_TEMT;

	return 0;

> +}
> +
> +/*
> + * Driver internal routine, used by both tty(serial core) as well as tx-=
isr
> + *  -Called under spinlock in either cases
> + *  -also tty->stopped / tty->hw_stopped has already been checked
> + *     =3D by uart_start( ) before calling us
> + *     =3D tx_ist checks that too before calling
> + */
> +static void arc_serial_tx_chars(struct arc_uart_port *uart)
> +{
> +	struct circ_buf *xmit =3D &uart->port.state->xmit;
> +	int sent =3D 0;
> +	unsigned char ch;
> +
> +	if (unlikely(uart->port.x_char)) {
> +		UART_SET_DATA(uart, uart->port.x_char);
> +		uart->port.icount.tx++;
> +		uart->port.x_char =3D 0;
> +		sent =3D 1;
> +	} else if (xmit->tail !=3D xmit->head) {	/* TODO: uart_circ_empty */
> +		ch =3D xmit->buf[xmit->tail];
> +		xmit->tail =3D (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
> +		uart->port.icount.tx++;
> +		while (!(UART_GET_STATUS(uart) & TXEMPTY))
> +			cpu_relax();
> +		UART_SET_DATA(uart, ch);
> +		sent =3D 1;
> +	}
> +
> +	/*
> +	 * If num chars in xmit buffer are too few, ask tty layer for more.
> +	 * By Hard ISR to schedule processing in software interrupt part
> +	 */
> +	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
> +		uart_write_wakeup(&uart->port);
> +
> +	if (sent)
> +		UART_TX_IRQ_ENABLE(uart);
> +}
> +
> +/*
> + * port is locked and interrupts are disabled
> + * uart_start( ) calls us under the port spinlock irqsave
> + */
> +static void arc_serial_start_tx(struct uart_port *port)
> +{
> +	struct arc_uart_port *uart =3D (struct arc_uart_port *)port;
> +
> +	arc_serial_tx_chars(uart);
> +}
> +
> +static void arc_serial_rx_chars(struct arc_uart_port *uart)
> +{
> +	struct tty_struct *tty =3D tty_port_tty_get(&uart->port.state->port);
> +	unsigned int status, ch, flg =3D 0;
> +
> +	if (!tty)
> +		return;

can this really happen ? why would you receive characters while tty is
NULL ?

> +	/*
> +	 * UART has 4 deep RX-FIFO. Driver's recongnition of this fact
> +	 * is very subtle. Here's how ...
> +	 * Upon getting a RX-Intr, such that RX-EMPTY=3D0, meaning data availab=
le,
> +	 * driver reads the DATA Reg and keeps doing that in a loop, until
> +	 * RX-EMPTY=3D1. Multiple chars being avail, with a single Interrupt,
> +	 * before RX-EMPTY=3D0, implies some sort of buffering going on in the
> +	 * controller, which is indeed the Rx-FIFO.
> +	 */
> +	while (!((status =3D UART_GET_STATUS(uart)) & RXEMPTY)) {
> +
> +		ch =3D UART_GET_DATA(uart);
> +		uart->port.icount.rx++;
> +
> +		if (unlikely(status & (RXOERR | RXFERR))) {
> +			if (status & RXOERR) {
> +				uart->port.icount.overrun++;
> +				flg =3D TTY_OVERRUN;
> +				UART_CLR_STATUS(uart, RXOERR);
> +			}
> +
> +			if (status & RXFERR) {
> +				uart->port.icount.frame++;
> +				flg =3D TTY_FRAME;
> +				UART_CLR_STATUS(uart, RXFERR);
> +			}
> +		} else
> +			flg =3D TTY_NORMAL;
> +
> +		if (unlikely(uart_handle_sysrq_char(&uart->port, ch)))
> +			goto done;
> +
> +		uart_insert_char(&uart->port, status, RXOERR, ch, flg);
> +
> +done:
> +		tty_flip_buffer_push(tty);
> +	}
> +
> +	tty_kref_put(tty);
> +}
> +
> +/*
> + * A note on the Interrupt handling state machine of this driver
> + *
> + * kernel printk writes funnel thru the console driver framework and in =
order
> + * to keep things simple as well as efficient, it writes to UART in poll=
ed
> + * mode, in one shot, and exits.
> + *
> + * OTOH, Userland output (via tty layer), uses interrupt based writes as=
 there
> + * can be undeterministic delay between char writes.
> + *
> + * Thus Rx-interrupts are always enabled, while tx-interrupts are by def=
ault
> + * disabled.
> + *
> + * When tty has some data to send out, serial core calls driver's start_=
tx
> + * which
> + *   -checks-if-tty-buffer-has-char-to-send
> + *   -writes-data-to-uart
> + *   -enable-tx-intr
> + *
> + * Once data bits are pushed out, controller raises the Tx-room-avail-In=
terrupt.
> + * The first thing Tx ISR does is disable further Tx interrupts (as this=
 could
> + * be the last char to send, before settling down into the quiet polled =
mode).
> + * It then calls the exact routine used by tty layer write to send out a=
ny
> + * more char in tty buffer. In case of sending, it re-enables Tx-intr. I=
n case
> + * of no data, it remains disabled.
> + * This is how the transmit state machine is dynamically switched on/off
> + */
> +
> +static irqreturn_t arc_serial_isr(int irq, void *dev_id)
> +{
> +	struct arc_uart_port *uart =3D dev_id;
> +	unsigned int status;
> +
> +	status =3D UART_GET_STATUS(uart);
> +
> +	/*
> +	 * Single IRQ for both Rx (data available) Tx (room available) Interrupt
> +	 * notifications from the UART Controller.
> +	 * To demultiplex between the two, we check the relevant bits
> +	 */
> +	if ((status & RXIENB) && !(status & RXEMPTY)) {
> +
> +		/* already in ISR, no need of xx_irqsave */
> +		spin_lock(&uart->port.lock);
> +		arc_serial_rx_chars(uart);
> +		spin_unlock(&uart->port.lock);
> +	}
> +
> +	if ((status & TXIENB) && (status & TXEMPTY)) {
> +
> +		/* Unconditionally disable further Tx-Interrupts.
> +		 * will be enabled by tx_chars() if needed.
> +		 */
> +		UART_TX_IRQ_DISABLE(uart);
> +
> +		spin_lock(&uart->port.lock);
> +
> +		if (!uart_tx_stopped(&uart->port))
> +			arc_serial_tx_chars(uart);
> +
> +		spin_unlock(&uart->port.lock);
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static unsigned int arc_serial_get_mctrl(struct uart_port *port)
> +{
> +	/*
> +	 * Pretend we have a Modem status reg and following bits are
> +	 *  always set, to satify the serial core state machine
> +	 *  (DSR) Data Set Ready
> +	 *  (CTS) Clear To Send
> +	 *  (CAR) Carrier Detect
> +	 */
> +	return TIOCM_CTS | TIOCM_DSR | TIOCM_CAR;
> +}
> +
> +static void arc_serial_set_mctrl(struct uart_port *port, unsigned int mc=
trl)
> +{
> +	/* MCR not present */
> +}
> +
> +/* Enable Modem Status Interrupts */
> +
> +static void arc_serial_enable_ms(struct uart_port *port)
> +{
> +	/* MSR not present */
> +}
> +
> +static void arc_serial_break_ctl(struct uart_port *port, int break_state)
> +{
> +	/* ARC UART doesn't support sending Break signal */
> +}
> +
> +static int arc_serial_startup(struct uart_port *port)
> +{
> +	struct arc_uart_port *uart =3D (struct arc_uart_port *)port;
> +
> +	/* Before we hook up the ISR, Disable all UART Interrupts */
> +	UART_ALL_IRQ_DISABLE(uart);
> +
> +	if (request_irq(uart->port.irq, arc_serial_isr, 0, "arc uart rx-tx",
> +			uart)) {
> +		pr_warn("Unable to attach ARC UART interrupt\n");
> +		return -EBUSY;
> +	}
> +
> +	UART_RX_IRQ_ENABLE(uart); /* Only Rx IRQ enabled to begin with */
> +
> +	return 0;
> +}
> +
> +/* This is not really needed */
> +static void arc_serial_shutdown(struct uart_port *port)
> +{
> +	struct arc_uart_port *uart =3D (struct arc_uart_port *)port;
> +	free_irq(uart->port.irq, uart);
> +}
> +
> +static void
> +arc_serial_set_termios(struct uart_port *port, struct ktermios *new,
> +		       struct ktermios *old)
> +{
> +	struct arc_uart_port *uart =3D (struct arc_uart_port *)port;
> +	unsigned int baud, uartl, uarth, hw_val;
> +	unsigned long flags;
> +
> +	/*
> +	 * Use the generic handler so that any specially encoded baud rates
> +	 * such as SPD_xx flags or "%B0" can be handled
> +	 * Max Baud I suppose will not be more than current 115K * 4
> +	 * Formula for ARC UART is: hw-val =3D ((CLK/(BAUD*4)) -1)
> +	 * spread over two 8-bit registers
> +	 */
> +	baud =3D uart_get_baud_rate(port, new, old, 0, 460800);
> +
> +	hw_val =3D port->uartclk / (uart->baud * 4) - 1;
> +	uartl =3D hw_val & 0xFF;
> +	uarth =3D (hw_val >> 8) & 0xFF;
> +
> +	/*
> +	 * UART ISS(Instruction Set simulator) emulation has a subtle bug:
> +	 * A existing value of Baudh =3D 0 is used as a indication to startup
> +	 * it's internal state machine.
> +	 * Thus if baudh is set to 0, 2 times, it chokes.
> +	 * This happens with BAUD=3D115200 and the formaula above
> +	 * Until that is fixed, when running on ISS, we will set baudh to !0
> +	 */
> +	if (uart->is_emulated)
> +		uarth =3D 1;
> +
> +	spin_lock_irqsave(&port->lock, flags);
> +
> +	UART_ALL_IRQ_DISABLE(uart);
> +
> +	UART_SET_BAUDL(uart, uartl);
> +	UART_SET_BAUDH(uart, uarth);
> +
> +	UART_RX_IRQ_ENABLE(uart);
> +
> +	/*
> +	 * UART doesn't support Parity/Hardware Flow Control;
> +	 * Only supports 8N1 character size
> +	 */
> +	new->c_cflag &=3D ~(CMSPAR|CRTSCTS|CSIZE);
> +	new->c_cflag |=3D CS8;
> +
> +	if (old)
> +		tty_termios_copy_hw(new, old);
> +
> +	/* Don't rewrite B0 */
> +	if (tty_termios_baud_rate(new))
> +		tty_termios_encode_baud_rate(new, baud, baud);
> +
> +	uart_update_timeout(port, new->c_cflag, baud);
> +
> +	spin_unlock_irqrestore(&port->lock, flags);
> +}
> +
> +static const char *arc_serial_type(struct uart_port *port)
> +{
> +	struct arc_uart_port *uart =3D (struct arc_uart_port *)port;
> +
> +	return uart->port.type =3D=3D PORT_ARC ? DRIVER_NAME : NULL;
> +}
> +
> +/*
> + * Release the memory region(s) being used by 'port'.
> + */
> +static void arc_serial_release_port(struct uart_port *port)
> +{
> +}
> +
> +/*
> + * Request the memory region(s) being used by 'port'.
> + */
> +static int arc_serial_request_port(struct uart_port *port)
> +{
> +	return 0;
> +}
> +
> +/*
> + * Verify the new serial_struct (for TIOCSSERIAL).
> + */
> +static int
> +arc_serial_verify_port(struct uart_port *port, struct serial_struct *ser)
> +{
> +	return 0;
> +}

why all these empty functions with wrong comments above them ??

> +/*
> + * Configure/autoconfigure the port.
> + */
> +static void arc_serial_config_port(struct uart_port *port, int flags)
> +{
> +	struct arc_uart_port *uart =3D (struct arc_uart_port *)port;
> +
> +	if (flags & UART_CONFIG_TYPE &&
> +	    arc_serial_request_port(&uart->port) =3D=3D 0)
> +		uart->port.type =3D PORT_ARC;
> +}
> +
> +#if defined(CONFIG_CONSOLE_POLL) || defined(CONFIG_SERIAL_ARC_CONSOLE)
> +
> +static void arc_serial_poll_putchar(struct uart_port *port, unsigned cha=
r chr)
> +{
> +	struct arc_uart_port *uart =3D (struct arc_uart_port *)port;
> +
> +	while (!(UART_GET_STATUS(uart) & TXEMPTY))
> +		cpu_relax();
> +
> +	UART_SET_DATA(uart, chr);
> +}
> +#endif
> +
> +#ifdef CONFIG_CONSOLE_POLL
> +static int arc_serial_poll_getchar(struct uart_port *port)
> +{
> +	struct arc_uart_port *uart =3D (struct arc_uart_port *)port;
> +	unsigned char chr;
> +
> +	while (!(UART_GET_STATUS(uart) & RXEMPTY))
> +		cpu_relax();
> +
> +	chr =3D UART_GET_DATA(uart);
> +	return chr;
> +}
> +#endif
> +
> +static struct uart_ops arc_serial_pops =3D {
> +	.tx_empty	=3D arc_serial_tx_empty,
> +	.set_mctrl	=3D arc_serial_set_mctrl,
> +	.get_mctrl	=3D arc_serial_get_mctrl,
> +	.stop_tx	=3D arc_serial_stop_tx,
> +	.start_tx	=3D arc_serial_start_tx,
> +	.stop_rx	=3D arc_serial_stop_rx,
> +	.enable_ms	=3D arc_serial_enable_ms,
> +	.break_ctl	=3D arc_serial_break_ctl,
> +	.startup	=3D arc_serial_startup,
> +	.shutdown	=3D arc_serial_shutdown,
> +	.set_termios	=3D arc_serial_set_termios,
> +	.type		=3D arc_serial_type,
> +	.release_port	=3D arc_serial_release_port,
> +	.request_port	=3D arc_serial_request_port,
> +	.config_port	=3D arc_serial_config_port,
> +	.verify_port	=3D arc_serial_verify_port,
> +#ifdef CONFIG_CONSOLE_POLL
> +	.poll_put_char =3D arc_serial_poll_putchar,
> +	.poll_get_char =3D arc_serial_poll_getchar,
> +#endif
> +};
> +
> +static int __devinit
> +arc_uart_init_one(struct platform_device *pdev, struct arc_uart_port *ua=
rt)
> +{
> +	struct resource *res, *res2;
> +	unsigned long *plat_data;
> +
> +	if (pdev->id < 0 || pdev->id >=3D CONFIG_SERIAL_ARC_NR_PORTS) {
> +		dev_err(&pdev->dev, "Wrong uart platform device id.\n");
> +		return -ENOENT;
> +	}
> +
> +	plat_data =3D ((unsigned long *)(pdev->dev.platform_data));
> +	uart->baud =3D plat_data[0];
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -ENODEV;
> +
> +	res2 =3D platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if (!res2)
> +		return -ENODEV;
> +
> +	uart->port.mapbase =3D res->start;
> +	uart->port.membase =3D ioremap_nocache(res->start, resource_size(res));
> +	if (!uart->port.membase)
> +		/* No point of pr_err since UART itself is hosed here */
> +		return -ENXIO;
> +
> +	uart->port.irq =3D res2->start;
> +	uart->port.dev =3D &pdev->dev;
> +	uart->port.iotype =3D UPIO_MEM;
> +	uart->port.flags =3D UPF_BOOT_AUTOCONF;
> +	uart->port.line =3D pdev->id;
> +	uart->port.ops =3D &arc_serial_pops;
> +
> +	uart->port.uartclk =3D plat_data[1];
> +	uart->port.fifosize =3D ARC_UART_TX_FIFO_SIZE;
> +
> +	/*
> +	 * uart_insert_char( ) uses it in decideding whether to ignore a
> +	 * char or not. Explicitly setting it here, removes the subtelty
> +	 */
> +	uart->port.ignore_status_mask =3D 0;
> +
> +	/* Real Hardware vs. emulated to work around a bug */
> +	uart->is_emulated =3D !!plat_data[2];
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_SERIAL_ARC_CONSOLE
> +
> +static int __devinit arc_serial_console_setup(struct console *co, char *=
options)
> +{
> +	struct uart_port *port;
> +	int baud =3D 115200;
> +	int bits =3D 8;
> +	int parity =3D 'n';
> +	int flow =3D 'n';
> +
> +	if (co->index < 0 || co->index >=3D CONFIG_SERIAL_ARC_NR_PORTS)
> +		return -ENODEV;
> +
> +	/*
> +	 * The uart port backing the console (e.g. ttyARC1) might not have been
> +	 * init yet. If so, defer the console setup to after the port.
> +	 */
> +	port =3D &arc_uart_ports[co->index].port;
> +	if (!port->membase)
> +		return -ENODEV;
> +
> +	if (options)
> +		uart_parse_options(options, &baud, &parity, &bits, &flow);
> +
> +	/*
> +	 * Serial core will call port->ops->set_termios( )
> +	 * which will set the baud reg
> +	 */
> +	return uart_set_options(port, co, baud, parity, bits, flow);
> +}
> +
> +static void arc_serial_console_putchar(struct uart_port *port, int ch)
> +{
> +	arc_serial_poll_putchar(port, (unsigned char)ch);
> +}
> +
> +/*
> + * Interrupts are disabled on entering
> + */
> +static void arc_serial_console_write(struct console *co, const char *s,
> +				     unsigned int count)
> +{
> +	struct uart_port *port =3D &arc_uart_ports[co->index].port;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&port->lock, flags);
> +	uart_console_write(port, s, count, arc_serial_console_putchar);
> +	spin_unlock_irqrestore(&port->lock, flags);
> +}
> +
> +static struct console arc_console =3D {
> +	.name	=3D ARC_SERIAL_DEV_NAME,
> +	.write	=3D arc_serial_console_write,
> +	.device	=3D uart_console_device,
> +	.setup	=3D arc_serial_console_setup,
> +	.flags	=3D CON_PRINTBUFFER,
> +	.index	=3D -1,
> +	.data	=3D &arc_uart_driver
> +};
> +
> +static __init void early_serial_write(struct console *con, const char *s,
> +					unsigned int n)
> +{
> +	struct uart_port *port =3D &arc_uart_ports[con->index].port;
> +	unsigned int i;
> +
> +	for (i =3D 0; i < n; i++, s++) {
> +		if (*s =3D=3D '\n')
> +			arc_serial_poll_putchar(port, '\r');
> +		arc_serial_poll_putchar(port, *s);
> +	}
> +}
> +
> +static struct __initdata console arc_early_serial_console =3D {
> +	.name =3D "early_ARCuart",
> +	.write =3D early_serial_write,
> +	.flags =3D CON_PRINTBUFFER | CON_BOOT,
> +	.index =3D -1
> +};
> +
> +static int __devinit arc_serial_probe_earlyprintk(struct platform_device=
 *pdev)
> +{
> +	arc_early_serial_console.index =3D pdev->id;
> +
> +	arc_uart_init_one(pdev, &arc_uart_ports[pdev->id]);
> +
> +	arc_serial_console_setup(&arc_early_serial_console, NULL);
> +
> +	register_console(&arc_early_serial_console);
> +	return 0;
> +}
> +#else
> +static int __devinit arc_serial_probe_earlyprintk(struct platform_device=
 *pdev)
> +{
> +	return -ENODEV;
> +}
> +#endif	/* CONFIG_SERIAL_ARC_CONSOLE */
> +
> +static int __devinit arc_serial_probe(struct platform_device *pdev)
> +{
> +	struct arc_uart_port *uart;
> +	int rc;
> +
> +	if (is_early_platform_device(pdev))
> +		return arc_serial_probe_earlyprintk(pdev);
> +
> +	uart =3D &arc_uart_ports[pdev->id];
> +	rc =3D arc_uart_init_one(pdev, uart);
> +	if (rc)
> +		return rc;
> +
> +	return uart_add_one_port(&arc_uart_driver, &uart->port);
> +}
> +
> +static int __devexit arc_serial_remove(struct platform_device *pdev)
> +{
> +	/* This will never be called */
> +	return 0;
> +}
> +
> +static struct platform_driver arc_platform_driver =3D {
> +	.probe =3D arc_serial_probe,
> +	.remove =3D __devexit_p(arc_serial_remove),
> +	.driver =3D {
> +		.name =3D DRIVER_NAME,
> +		.owner =3D THIS_MODULE,
> +	 },
> +};
> +
> +#ifdef CONFIG_SERIAL_ARC_CONSOLE
> +/*
> + * Register an early platform driver of "earlyprintk" class.
> + * ARCH platform code installs the driver and probes the early devices
> + * The installation could rely on user specifying earlyprintk=3Dxyx in c=
md line
> + * or it could be done independently, for all "earlyprintk" class driver=
s.
> + * [see arch/arc/plat-arcfpga/platform.c]
> + */
> +early_platform_init("earlyprintk", &arc_platform_driver);
> +
> +#endif  /* CONFIG_SERIAL_ARC_CONSOLE */
> +
> +static int __init arc_serial_init(void)
> +{
> +	int ret;
> +
> +	pr_info("Serial: ARC serial driver: platform register\n");

please remove this line, it's just useless IMHO.

--=20
balbi

--Q0rSlbzrZN6k9QnT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQin24AAoJEIaOsuA1yqREkZYQAIR52BSGvKa/y5vkXYmKL/UT
iwEYzYzFzf2scexNaCTBsF6z51YzeqYh4iVP9cJnARU+khe65LbMfFrFd+969vbV
bvXyUq+oIMOb+ZjonHZtwVs6lqgk1I85jYj4c9rAVYFaHOt6nEIr7XppLyV32LUn
ufKPvTYw1rr9to535kMcSOOMy++fm2lrw8sSf69KL4jfA4jUY77cAr66vKd0mkI/
sQeBkR2kF2k4ebgPLM5CJA1YWQuf6fW5NFJSLNO5uOEbzBmkNBJNORa7m0Npviu3
D+rjOeVRAnUVNOKxXigfffuQnmN4XA6LO2Wxcwxpm1DEuPiQvnxaSn50ses9T4O3
Er5AiwMS+cBAum4wrLH/e6jfr7pPl+MCRvBaypEwe8JZ0ZvJfzBmoAJTzFNcEVLV
MiQVCCoqvYOs3j8TYscOgAI6vouBM5C19cSA3Uv02zRXK+Tgw3eQdgTqXt/8Smo6
ncoSlFHJjcivxfRutFv+R0NktpmqNFqOXRlBcOONHIxZtuKVqPuVEtS6pMDzhpf/
KEqq6ryafs1IpWBFKJaFBBjsmLLkWzSadkp3WR/0UtxJtQ2Bkke//8SZSntSha5g
BNoAQKy1Vk4VGg9ydeMoR5UjPS4fUD40mvLQp1g51aCzNuWdNrs2KHs7GKjQkJ4u
WGJBy8BbUWI+YGo9uDgz
=OkaB
-----END PGP SIGNATURE-----

--Q0rSlbzrZN6k9QnT--

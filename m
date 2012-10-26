Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933105Ab2JZOAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:00:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34521 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932529Ab2JZOAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:00:41 -0400
Date: Fri, 26 Oct 2012 16:54:52 +0300
From: Felipe Balbi <balbi@ti.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <alan@linux.intel.com>,
        <arc-linux-dev@synopsys.com>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] serial/arc-uart: Add new driver
Message-ID: <20121026135452.GB27141@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1351252996-28484-1-git-send-email-vgupta@synopsys.com>
 <1351252996-28484-2-git-send-email-vgupta@synopsys.com>
 <20121026121032.GD26342@arwen.pp.htv.fi>
 <508A865E.6030903@synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tsOsTdHNUZQcU9Ye"
Content-Disposition: inline
In-Reply-To: <508A865E.6030903@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tsOsTdHNUZQcU9Ye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hi,

On Fri, Oct 26, 2012 at 06:17:26PM +0530, Vineet Gupta wrote:
> >> +#endif
> >> +};
> >> +
> >> +static void arc_serial_stop_rx(struct uart_port *port)
> >> +{
> >> +	struct arc_uart_port *uart =3D (struct arc_uart_port *)port;
> > I would suggest using container_of() here. It's very unlikely to happen,
> > but if another field is added before struct uart_port member in your
> > structure, this will break.
>=20
> I agree  that container_of() would make it future safe - but I don't
> foresee any significant changes to driver specially the arc_uart_port
> structure.

I would still do it. The way code is right now, container_of() will be
optmized into the same cast you have today, so no impacts there.

> >> +static void arc_serial_rx_chars(struct arc_uart_port *uart)
> >> +{
> >> +	struct tty_struct *tty =3D tty_port_tty_get(&uart->port.state->port);
> >> +	unsigned int status, ch, flg =3D 0;
> >> +
> >> +	if (!tty)
> >> +		return;
> > can this really happen ? why would you receive characters while tty is
> > NULL ?
>=20
> Since we are getting a ref to tty - it makes sense to check if the
> pointer is not NULL. Alan had pointed to a possible hangup race which
> could yield a NULL tty. But I'm not really an expert in serial core to
> be sure if at all this will happen - so added the check.

fair enough...

> >> +	/*
> >> +	 * UART has 4 deep RX-FIFO. Driver's recongnition of this fact
> >> +	 * is very subtle. Here's how ...
> >> +	 * Upon getting a RX-Intr, such that RX-EMPTY=3D0, meaning data avai=
lable,
> >> +	 * driver reads the DATA Reg and keeps doing that in a loop, until
> >> +	 * RX-EMPTY=3D1. Multiple chars being avail, with a single Interrupt,
> >> +	 * before RX-EMPTY=3D0, implies some sort of buffering going on in t=
he
> >> +	 * controller, which is indeed the Rx-FIFO.
> >> +	 */
> >> +	while (!((status =3D UART_GET_STATUS(uart)) & RXEMPTY)) {
> >> +
> >> +		ch =3D UART_GET_DATA(uart);
> >> +		uart->port.icount.rx++;
> >> +
> >> +		if (unlikely(status & (RXOERR | RXFERR))) {
> >> +			if (status & RXOERR) {
> >> +				uart->port.icount.overrun++;
> >> +				flg =3D TTY_OVERRUN;
> >> +				UART_CLR_STATUS(uart, RXOERR);
> >> +			}
> >> +
> >> +			if (status & RXFERR) {
> >> +				uart->port.icount.frame++;
> >> +				flg =3D TTY_FRAME;
> >> +				UART_CLR_STATUS(uart, RXFERR);
> >> +			}
> >> +		} else
> >> +			flg =3D TTY_NORMAL;
> >> +
> >> +		if (unlikely(uart_handle_sysrq_char(&uart->port, ch)))
> >> +			goto done;
> >> +
> >> +		uart_insert_char(&uart->port, status, RXOERR, ch, flg);
> >> +
> >> +done:
> >> +		tty_flip_buffer_push(tty);
> >> +	}
> >> +
> >> +	tty_kref_put(tty);
> >> +}
> >> +
> >> +/*
> >> + * A note on the Interrupt handling state machine of this driver
> >> + *
> >> + * kernel printk writes funnel thru the console driver framework and =
in order
> >> + * to keep things simple as well as efficient, it writes to UART in p=
olled
> >> + * mode, in one shot, and exits.
> >> + *
> >> + * OTOH, Userland output (via tty layer), uses interrupt based writes=
 as there
> >> + * can be undeterministic delay between char writes.
> >> + *
> >> + * Thus Rx-interrupts are always enabled, while tx-interrupts are by =
default
> >> + * disabled.
> >> + *
> >> + * When tty has some data to send out, serial core calls driver's sta=
rt_tx
> >> + * which
> >> + *   -checks-if-tty-buffer-has-char-to-send
> >> + *   -writes-data-to-uart
> >> + *   -enable-tx-intr
> >> + *
> >> + * Once data bits are pushed out, controller raises the Tx-room-avail=
-Interrupt.
> >> + * The first thing Tx ISR does is disable further Tx interrupts (as t=
his could
> >> + * be the last char to send, before settling down into the quiet poll=
ed mode).
> >> + * It then calls the exact routine used by tty layer write to send ou=
t any
> >> + * more char in tty buffer. In case of sending, it re-enables Tx-intr=
=2E In case
> >> + * of no data, it remains disabled.
> >> + * This is how the transmit state machine is dynamically switched on/=
off
> >> + */
> >> +
> >> +static irqreturn_t arc_serial_isr(int irq, void *dev_id)
> >> +{
> >> +	struct arc_uart_port *uart =3D dev_id;
> >> +	unsigned int status;
> >> +
> >> +	status =3D UART_GET_STATUS(uart);
> >> +
> >> +	/*
> >> +	 * Single IRQ for both Rx (data available) Tx (room available) Inter=
rupt
> >> +	 * notifications from the UART Controller.
> >> +	 * To demultiplex between the two, we check the relevant bits
> >> +	 */
> >> +	if ((status & RXIENB) && !(status & RXEMPTY)) {
> >> +
> >> +		/* already in ISR, no need of xx_irqsave */
> >> +		spin_lock(&uart->port.lock);
> >> +		arc_serial_rx_chars(uart);
> >> +		spin_unlock(&uart->port.lock);
> >> +	}
> >> +
> >> +	if ((status & TXIENB) && (status & TXEMPTY)) {
> >> +
> >> +		/* Unconditionally disable further Tx-Interrupts.
> >> +		 * will be enabled by tx_chars() if needed.
> >> +		 */
> >> +		UART_TX_IRQ_DISABLE(uart);
> >> +
> >> +		spin_lock(&uart->port.lock);
> >> +
> >> +		if (!uart_tx_stopped(&uart->port))
> >> +			arc_serial_tx_chars(uart);
> >> +
> >> +		spin_unlock(&uart->port.lock);
> >> +	}
> >> +
> >> +	return IRQ_HANDLED;
> >> +}
> >> +
> >> +static unsigned int arc_serial_get_mctrl(struct uart_port *port)
> >> +{
> >> +	/*
> >> +	 * Pretend we have a Modem status reg and following bits are
> >> +	 *  always set, to satify the serial core state machine
> >> +	 *  (DSR) Data Set Ready
> >> +	 *  (CTS) Clear To Send
> >> +	 *  (CAR) Carrier Detect
> >> +	 */
> >> +	return TIOCM_CTS | TIOCM_DSR | TIOCM_CAR;
> >> +}
> >> +
> >> +static void arc_serial_set_mctrl(struct uart_port *port, unsigned int=
 mctrl)
> >> +{
> >> +	/* MCR not present */
> >> +}
> >> +
> >> +/* Enable Modem Status Interrupts */
> >> +
> >> +static void arc_serial_enable_ms(struct uart_port *port)
> >> +{
> >> +	/* MSR not present */
> >> +}
> >> +
> >> +static void arc_serial_break_ctl(struct uart_port *port, int break_st=
ate)
> >> +{
> >> +	/* ARC UART doesn't support sending Break signal */
> >> +}
> >> +
> >> +static int arc_serial_startup(struct uart_port *port)
> >> +{
> >> +	struct arc_uart_port *uart =3D (struct arc_uart_port *)port;
> >> +
> >> +	/* Before we hook up the ISR, Disable all UART Interrupts */
> >> +	UART_ALL_IRQ_DISABLE(uart);
> >> +
> >> +	if (request_irq(uart->port.irq, arc_serial_isr, 0, "arc uart rx-tx",
> >> +			uart)) {
> >> +		pr_warn("Unable to attach ARC UART interrupt\n");
> >> +		return -EBUSY;
> >> +	}
> >> +
> >> +	UART_RX_IRQ_ENABLE(uart); /* Only Rx IRQ enabled to begin with */
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +/* This is not really needed */
> >> +static void arc_serial_shutdown(struct uart_port *port)
> >> +{
> >> +	struct arc_uart_port *uart =3D (struct arc_uart_port *)port;
> >> +	free_irq(uart->port.irq, uart);
> >> +}
> >> +
> >> +static void
> >> +arc_serial_set_termios(struct uart_port *port, struct ktermios *new,
> >> +		       struct ktermios *old)
> >> +{
> >> +	struct arc_uart_port *uart =3D (struct arc_uart_port *)port;
> >> +	unsigned int baud, uartl, uarth, hw_val;
> >> +	unsigned long flags;
> >> +
> >> +	/*
> >> +	 * Use the generic handler so that any specially encoded baud rates
> >> +	 * such as SPD_xx flags or "%B0" can be handled
> >> +	 * Max Baud I suppose will not be more than current 115K * 4
> >> +	 * Formula for ARC UART is: hw-val =3D ((CLK/(BAUD*4)) -1)
> >> +	 * spread over two 8-bit registers
> >> +	 */
> >> +	baud =3D uart_get_baud_rate(port, new, old, 0, 460800);
> >> +
> >> +	hw_val =3D port->uartclk / (uart->baud * 4) - 1;
> >> +	uartl =3D hw_val & 0xFF;
> >> +	uarth =3D (hw_val >> 8) & 0xFF;
> >> +
> >> +	/*
> >> +	 * UART ISS(Instruction Set simulator) emulation has a subtle bug:
> >> +	 * A existing value of Baudh =3D 0 is used as a indication to startup
> >> +	 * it's internal state machine.
> >> +	 * Thus if baudh is set to 0, 2 times, it chokes.
> >> +	 * This happens with BAUD=3D115200 and the formaula above
> >> +	 * Until that is fixed, when running on ISS, we will set baudh to !0
> >> +	 */
> >> +	if (uart->is_emulated)
> >> +		uarth =3D 1;
> >> +
> >> +	spin_lock_irqsave(&port->lock, flags);
> >> +
> >> +	UART_ALL_IRQ_DISABLE(uart);
> >> +
> >> +	UART_SET_BAUDL(uart, uartl);
> >> +	UART_SET_BAUDH(uart, uarth);
> >> +
> >> +	UART_RX_IRQ_ENABLE(uart);
> >> +
> >> +	/*
> >> +	 * UART doesn't support Parity/Hardware Flow Control;
> >> +	 * Only supports 8N1 character size
> >> +	 */
> >> +	new->c_cflag &=3D ~(CMSPAR|CRTSCTS|CSIZE);
> >> +	new->c_cflag |=3D CS8;
> >> +
> >> +	if (old)
> >> +		tty_termios_copy_hw(new, old);
> >> +
> >> +	/* Don't rewrite B0 */
> >> +	if (tty_termios_baud_rate(new))
> >> +		tty_termios_encode_baud_rate(new, baud, baud);
> >> +
> >> +	uart_update_timeout(port, new->c_cflag, baud);
> >> +
> >> +	spin_unlock_irqrestore(&port->lock, flags);
> >> +}
> >> +
> >> +static const char *arc_serial_type(struct uart_port *port)
> >> +{
> >> +	struct arc_uart_port *uart =3D (struct arc_uart_port *)port;
> >> +
> >> +	return uart->port.type =3D=3D PORT_ARC ? DRIVER_NAME : NULL;
> >> +}
> >> +
> >> +/*
> >> + * Release the memory region(s) being used by 'port'.
> >> + */
> >> +static void arc_serial_release_port(struct uart_port *port)
> >> +{
> >> +}
> >> +
> >> +/*
> >> + * Request the memory region(s) being used by 'port'.
> >> + */
> >> +static int arc_serial_request_port(struct uart_port *port)
> >> +{
> >> +	return 0;
> >> +}
> >> +
> >> +/*
> >> + * Verify the new serial_struct (for TIOCSSERIAL).
> >> + */
> >> +static int
> >> +arc_serial_verify_port(struct uart_port *port, struct serial_struct *=
ser)
> >> +{
> >> +	return 0;
> >> +}
> > why all these empty functions with wrong comments above them ??
>=20
> Copy/paste cruft. Empty functions deleted in next ver !
> Regarding verify_port, I'm not sure whether it needs to elaborately
> check for PORT_UNKNOWN -> PORT_ARC or can we simply continue to return
> 0. But IMHO the comment in there is right. No ?

nope, you say that you should verify the new serial_struct, but you
don't verify anything, just return.

> >> +/*
> >> + * Configure/autoconfigure the port.
> >> + */
> >> +static void arc_serial_config_port(struct uart_port *port, int flags)
> >> +{
> >> +	struct arc_uart_port *uart =3D (struct arc_uart_port *)port;
> >> +
> >> +	if (flags & UART_CONFIG_TYPE &&
> >> +	    arc_serial_request_port(&uart->port) =3D=3D 0)
> >> +		uart->port.type =3D PORT_ARC;
> >> +}
> >> +
> >> +#if defined(CONFIG_CONSOLE_POLL) || defined(CONFIG_SERIAL_ARC_CONSOLE)
> >> +
> >> +static void arc_serial_poll_putchar(struct uart_port *port, unsigned =
char chr)
> >> +{
> >> +	struct arc_uart_port *uart =3D (struct arc_uart_port *)port;
> >> +
> >> +	while (!(UART_GET_STATUS(uart) & TXEMPTY))
> >> +		cpu_relax();
> >> +
> >> +	UART_SET_DATA(uart, chr);
> >> +}
> >> +#endif
> >> +
> >> +#ifdef CONFIG_CONSOLE_POLL
> >> +static int arc_serial_poll_getchar(struct uart_port *port)
> >> +{
> >> +	struct arc_uart_port *uart =3D (struct arc_uart_port *)port;
> >> +	unsigned char chr;
> >> +
> >> +	while (!(UART_GET_STATUS(uart) & RXEMPTY))
> >> +		cpu_relax();
> >> +
> >> +	chr =3D UART_GET_DATA(uart);
> >> +	return chr;
> >> +}
> >> +#endif
> >> +
> >> +static struct uart_ops arc_serial_pops =3D {
> >> +	.tx_empty	=3D arc_serial_tx_empty,
> >> +	.set_mctrl	=3D arc_serial_set_mctrl,
> >> +	.get_mctrl	=3D arc_serial_get_mctrl,
> >> +	.stop_tx	=3D arc_serial_stop_tx,
> >> +	.start_tx	=3D arc_serial_start_tx,
> >> +	.stop_rx	=3D arc_serial_stop_rx,
> >> +	.enable_ms	=3D arc_serial_enable_ms,
> >> +	.break_ctl	=3D arc_serial_break_ctl,
> >> +	.startup	=3D arc_serial_startup,
> >> +	.shutdown	=3D arc_serial_shutdown,
> >> +	.set_termios	=3D arc_serial_set_termios,
> >> +	.type		=3D arc_serial_type,
> >> +	.release_port	=3D arc_serial_release_port,
> >> +	.request_port	=3D arc_serial_request_port,
> >> +	.config_port	=3D arc_serial_config_port,
> >> +	.verify_port	=3D arc_serial_verify_port,
> >> +#ifdef CONFIG_CONSOLE_POLL
> >> +	.poll_put_char =3D arc_serial_poll_putchar,
> >> +	.poll_get_char =3D arc_serial_poll_getchar,
> >> +#endif
> >> +};
> >> +
> >> +static int __devinit
> >> +arc_uart_init_one(struct platform_device *pdev, struct arc_uart_port =
*uart)
> >> +{
> >> +	struct resource *res, *res2;
> >> +	unsigned long *plat_data;
> >> +
> >> +	if (pdev->id < 0 || pdev->id >=3D CONFIG_SERIAL_ARC_NR_PORTS) {
> >> +		dev_err(&pdev->dev, "Wrong uart platform device id.\n");
> >> +		return -ENOENT;
> >> +	}
> >> +
> >> +	plat_data =3D ((unsigned long *)(pdev->dev.platform_data));
> >> +	uart->baud =3D plat_data[0];
> >> +
> >> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >> +	if (!res)
> >> +		return -ENODEV;
> >> +
> >> +	res2 =3D platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> >> +	if (!res2)
> >> +		return -ENODEV;
> >> +
> >> +	uart->port.mapbase =3D res->start;
> >> +	uart->port.membase =3D ioremap_nocache(res->start, resource_size(res=
));
> >> +	if (!uart->port.membase)
> >> +		/* No point of pr_err since UART itself is hosed here */
> >> +		return -ENXIO;
> >> +
> >> +	uart->port.irq =3D res2->start;
> >> +	uart->port.dev =3D &pdev->dev;
> >> +	uart->port.iotype =3D UPIO_MEM;
> >> +	uart->port.flags =3D UPF_BOOT_AUTOCONF;
> >> +	uart->port.line =3D pdev->id;
> >> +	uart->port.ops =3D &arc_serial_pops;
> >> +
> >> +	uart->port.uartclk =3D plat_data[1];
> >> +	uart->port.fifosize =3D ARC_UART_TX_FIFO_SIZE;
> >> +
> >> +	/*
> >> +	 * uart_insert_char( ) uses it in decideding whether to ignore a
> >> +	 * char or not. Explicitly setting it here, removes the subtelty
> >> +	 */
> >> +	uart->port.ignore_status_mask =3D 0;
> >> +
> >> +	/* Real Hardware vs. emulated to work around a bug */
> >> +	uart->is_emulated =3D !!plat_data[2];
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +#ifdef CONFIG_SERIAL_ARC_CONSOLE
> >> +
> >> +static int __devinit arc_serial_console_setup(struct console *co, cha=
r *options)
> >> +{
> >> +	struct uart_port *port;
> >> +	int baud =3D 115200;
> >> +	int bits =3D 8;
> >> +	int parity =3D 'n';
> >> +	int flow =3D 'n';
> >> +
> >> +	if (co->index < 0 || co->index >=3D CONFIG_SERIAL_ARC_NR_PORTS)
> >> +		return -ENODEV;
> >> +
> >> +	/*
> >> +	 * The uart port backing the console (e.g. ttyARC1) might not have b=
een
> >> +	 * init yet. If so, defer the console setup to after the port.
> >> +	 */
> >> +	port =3D &arc_uart_ports[co->index].port;
> >> +	if (!port->membase)
> >> +		return -ENODEV;
> >> +
> >> +	if (options)
> >> +		uart_parse_options(options, &baud, &parity, &bits, &flow);
> >> +
> >> +	/*
> >> +	 * Serial core will call port->ops->set_termios( )
> >> +	 * which will set the baud reg
> >> +	 */
> >> +	return uart_set_options(port, co, baud, parity, bits, flow);
> >> +}
> >> +
> >> +static void arc_serial_console_putchar(struct uart_port *port, int ch)
> >> +{
> >> +	arc_serial_poll_putchar(port, (unsigned char)ch);
> >> +}
> >> +
> >> +/*
> >> + * Interrupts are disabled on entering
> >> + */
> >> +static void arc_serial_console_write(struct console *co, const char *=
s,
> >> +				     unsigned int count)
> >> +{
> >> +	struct uart_port *port =3D &arc_uart_ports[co->index].port;
> >> +	unsigned long flags;
> >> +
> >> +	spin_lock_irqsave(&port->lock, flags);
> >> +	uart_console_write(port, s, count, arc_serial_console_putchar);
> >> +	spin_unlock_irqrestore(&port->lock, flags);
> >> +}
> >> +
> >> +static struct console arc_console =3D {
> >> +	.name	=3D ARC_SERIAL_DEV_NAME,
> >> +	.write	=3D arc_serial_console_write,
> >> +	.device	=3D uart_console_device,
> >> +	.setup	=3D arc_serial_console_setup,
> >> +	.flags	=3D CON_PRINTBUFFER,
> >> +	.index	=3D -1,
> >> +	.data	=3D &arc_uart_driver
> >> +};
> >> +
> >> +static __init void early_serial_write(struct console *con, const char=
 *s,
> >> +					unsigned int n)
> >> +{
> >> +	struct uart_port *port =3D &arc_uart_ports[con->index].port;
> >> +	unsigned int i;
> >> +
> >> +	for (i =3D 0; i < n; i++, s++) {
> >> +		if (*s =3D=3D '\n')
> >> +			arc_serial_poll_putchar(port, '\r');
> >> +		arc_serial_poll_putchar(port, *s);
> >> +	}
> >> +}
> >> +
> >> +static struct __initdata console arc_early_serial_console =3D {
> >> +	.name =3D "early_ARCuart",
> >> +	.write =3D early_serial_write,
> >> +	.flags =3D CON_PRINTBUFFER | CON_BOOT,
> >> +	.index =3D -1
> >> +};
> >> +
> >> +static int __devinit arc_serial_probe_earlyprintk(struct platform_dev=
ice *pdev)
> >> +{
> >> +	arc_early_serial_console.index =3D pdev->id;
> >> +
> >> +	arc_uart_init_one(pdev, &arc_uart_ports[pdev->id]);
> >> +
> >> +	arc_serial_console_setup(&arc_early_serial_console, NULL);
> >> +
> >> +	register_console(&arc_early_serial_console);
> >> +	return 0;
> >> +}
> >> +#else
> >> +static int __devinit arc_serial_probe_earlyprintk(struct platform_dev=
ice *pdev)
> >> +{
> >> +	return -ENODEV;
> >> +}
> >> +#endif	/* CONFIG_SERIAL_ARC_CONSOLE */
> >> +
> >> +static int __devinit arc_serial_probe(struct platform_device *pdev)
> >> +{
> >> +	struct arc_uart_port *uart;
> >> +	int rc;
> >> +
> >> +	if (is_early_platform_device(pdev))
> >> +		return arc_serial_probe_earlyprintk(pdev);
> >> +
> >> +	uart =3D &arc_uart_ports[pdev->id];
> >> +	rc =3D arc_uart_init_one(pdev, uart);
> >> +	if (rc)
> >> +		return rc;
> >> +
> >> +	return uart_add_one_port(&arc_uart_driver, &uart->port);
> >> +}
> >> +
> >> +static int __devexit arc_serial_remove(struct platform_device *pdev)
> >> +{
> >> +	/* This will never be called */
> >> +	return 0;
> >> +}
> >> +
> >> +static struct platform_driver arc_platform_driver =3D {
> >> +	.probe =3D arc_serial_probe,
> >> +	.remove =3D __devexit_p(arc_serial_remove),
> >> +	.driver =3D {
> >> +		.name =3D DRIVER_NAME,
> >> +		.owner =3D THIS_MODULE,
> >> +	 },
> >> +};
> >> +
> >> +#ifdef CONFIG_SERIAL_ARC_CONSOLE
> >> +/*
> >> + * Register an early platform driver of "earlyprintk" class.
> >> + * ARCH platform code installs the driver and probes the early devices
> >> + * The installation could rely on user specifying earlyprintk=3Dxyx i=
n cmd line
> >> + * or it could be done independently, for all "earlyprintk" class dri=
vers.
> >> + * [see arch/arc/plat-arcfpga/platform.c]
> >> + */
> >> +early_platform_init("earlyprintk", &arc_platform_driver);
> >> +
> >> +#endif  /* CONFIG_SERIAL_ARC_CONSOLE */
> >> +
> >> +static int __init arc_serial_init(void)
> >> +{
> >> +	int ret;
> >> +
> >> +	pr_info("Serial: ARC serial driver: platform register\n");
> > please remove this line, it's just useless IMHO.
>=20
> It has helped me enough in past when debugging the uncoupling of driver
> from ARC platform code. I'd rather keep it !

then make it a debugging print ;-)

--=20
balbi

--tsOsTdHNUZQcU9Ye
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQipYsAAoJEIaOsuA1yqREUGoQAKDuFs1XT5dy5FunLPKfl4pS
0O4JiN5qN/Wd0luIOzhif6a4IPFJxQt+XvMZKVXPkjG181j5fSzkOCEeUm9UtWEs
4mMGe/eAVdYiI3AHzaVNkzJrBFCqI8ta1W4qAoF4iQ4yn5hhwtcJf/lwEwm6LJ1G
5k9LE1LpxWHof4kuOOna2G681QRMLa+b8imKFEbu4W9GQBz3DlkbZPMNXvY2rtVr
BANQLeZrKDgVx3ZByFQIZVe5lOS4uGfU4EVj1GdRAWIuvhbUoAj5bPhd1XxLprNM
TRyYocfj3OG3yHheEZq7I7tVvltuQ3cMQ7oXRbwlwqEZkZ35hqJWW2Ax/Fri0/4q
VdB+Dnv2+sQQjAoQIRhRfgjPvKWcL1hT+kLKAKuHNVQSOmJGzwhjbuB29HAxcVku
49UGyrFLs4zgcjLvoRx30HHu4xSUo6S4GYsSMERfBA24Yu4Xx9XTPGUrNDCWi5Io
Hah8IBEvKyEls+WdWR5YlilOz1f3vEQzoUFzqj847NzSyEVWxwXq5T6YGi8B6cNo
r3rlksCEa82fSk32B2ucLNT9IsKYg4C5Av9c37Qbxs+gNanCzriAAbe/wAZxnhko
k37p4+cM8wFBPKbSr5lPjewcuiu6wCZgBhtYg91Fi3LkkvXOqFzi76PRrF0eGSAu
VK9srNcLv1gYaU40AlP5
=d4Z6
-----END PGP SIGNATURE-----

--tsOsTdHNUZQcU9Ye--

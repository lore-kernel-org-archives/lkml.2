Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab0GWHu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 03:50:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55758 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750877Ab0GWHuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 03:50:25 -0400
Date: Fri, 23 Jul 2010 09:01:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: <gregkh@suse.de>
Cc: philippe.langlais@stericsson.com, linux-kernel@vger.kernel.org,
        ludovic.barre@stericsson.com
Subject: Re: patch "U6715 8250 serial like driver" added to gregkh-2.6 tree
Message-ID: <20100723090119.5d63cfb7@lxorguk.ukuu.org.uk>
In-Reply-To: <12798430773066@site>
References: <1279531660-16317-1-git-send-email-philippe.langlais@stericsson.com>
	<12798430773066@site>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jul 2010 16:57:57 -0700
<gregkh@suse.de> wrote:

> 
> This is a note to let you know that I've just added the patch titled

NAK this

I've nakked several similar patches already from people trying to
convolute the 8250 driver even further, doubly so when the patch
redefines properties of existing chips according to a compile time option


>  	[PORT_16550A] = {
>  		.name		= "16550A",
> +#if defined(CONFIG_SERIAL_8250_U6XXX)
> +		.fifo_size	= 64,
> +		.tx_loadsz	= 64,
> +		.flags		= UART_CAP_FIFO | UART_CAP_AFE,
> +#else
>  		.fifo_size	= 16,
>  		.tx_loadsz	= 16,
> -		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
>  		.flags		= UART_CAP_FIFO,
> +#endif
> +		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
>  	},

Define yourself a new port type


> @@ -2268,6 +2274,13 @@ serial8250_set_termios(struct uart_port
>  	/*
>  	 * Ask the core to calculate the divisor for us.
>  	 */
> +#ifdef CONFIG_SERIAL_8250_CUSTOM_CLOCK
> +	baud = uart_get_baud_rate(port, termios, old, 0,
> +			CONFIG_SERIAL_8250_CUSTOM_MAX_BAUDRATE);
> +	/* Calculate the new uart clock frequency if it is tunable */
> +	port->uartclk = serial8250_get_custom_clock(port, baud);
> +#endif
> +
>  	baud = uart_get_baud_rate(port, termios, old,
>  				  port->uartclk / 16 / 0xffff,
>  				  port->uartclk / 16);


I think what you need to keep this clean is to create a
port->set_termios() for the 8250 port (akin to
port->serial_in/serial_out) which does the specials you need each end and
calls the standard serial8250_set_termios)

> @@ -2298,6 +2311,13 @@ serial8250_set_termios(struct uart_port
>  		up->mcr &= ~UART_MCR_AFE;
>  		if (termios->c_cflag & CRTSCTS)
>  			up->mcr |= UART_MCR_AFE;
> +#if defined(CONFIG_SERIAL_8250_U6XXX)
> +		/**
> +		 * When AFE is active, let the HW handle the stop/restart TX
> +		 * upon CTS change. It reacts much quicker than the SW driver.
> +		 */
> +		port->flags &= ~ASYNC_CTS_FLOW;
> +#endif

Why do you need to clear this flag when doing so ?




> +unsigned int serial8250_enable_clock(struct uart_port *port)
> +{
> +	struct u6_uart *uart_u6 = port->private_data;
> +
> +	if (!uart_u6)
> +		return uart_enable_clock(port);
> +
> +	if (IS_ERR(uart_u6->uartClk)) {
> +		printk(KERN_WARNING "%s - uart clock failed error:%ld\n",
> +		       __func__, PTR_ERR(uart_u6->uartClk));

pr_warn()

Also as the functions are specific to the u6175 can you use u6715_ names
so any printk, traceback and the like is obvious in where to look.


> +unsigned int serial8250_get_custom_clock(struct uart_port *port,
> +					 unsigned int baud)
> +{
> +	switch (baud) {
> +	case 3250000:
> +		return 52000000;
> +	case 2000000:
> +		return 32000000;
> +	case 1843200:
> +		return 29491200;
> +	case 921600:
> +		return 14745600;
> +	default:
> +		return 7372800;
> +	}
> +}

Baud rates are arbitary values, so surely this should doing range checks ?


> +config SERIAL_8250_CUSTOM_CLOCK
> +	bool "Support serial ports with tunable input clock frequency"
> +	depends on SERIAL_8250_EXTENDED && SERIAL_8250_U6XXX
> +	default y
> +	help
> +	  Say Y here if your platform has specific registers to change UART clock frequency.

Except the patch you've posted is actually a patch for a U6715 not
generic tunable input clock support, so this Kconfig option/help will
confuse people. Better to describe it as U6715 support.


> +#ifdef CONFIG_SERIAL_8250_CUSTOM_CLOCK
> +unsigned int serial8250_enable_clock(struct uart_port *port);
> +unsigned int serial8250_disable_clock(struct uart_port *port);
> +unsigned int serial8250_get_custom_clock(struct uart_port *port,
> +		unsigned int baud);
> +void serial8250_set_custom_clock(struct uart_port *port);
> +#endif

This shouldn't need ifdefs in the header


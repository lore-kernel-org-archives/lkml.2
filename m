Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab1DSVOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:14:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37112 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753732Ab1DSVOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:14:30 -0400
Date: Tue, 19 Apr 2011 22:15:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: John Linn <john.linn@xilinx.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>
Subject: Re: [PATCH] tty/serial: add support for Xilinx PS UART
Message-ID: <20110419221530.7370d013@lxorguk.ukuu.org.uk>
In-Reply-To: <e35578a9-909d-4594-bbe4-41d89b5f9b3e@VA3EHSMHS014.ehs.local>
References: <e35578a9-909d-4594-bbe4-41d89b5f9b3e@VA3EHSMHS014.ehs.local>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Apr 2011 14:14:52 -0600
John Linn <john.linn@xilinx.com> wrote:

> The Xilinx PS Uart is used on the new ARM based SoC. This
> UART is not compatible with others such that a seperate
> driver is required.

Joyous. I wish people would standardise.

> +		 213 = /dev/ttyPS0		Xilinx PS serial port 0
> +		 214 = /dev/ttyPS1		Xilinx PS serial port 1
> +		 215 = /dev/ttyPS2		Xilinx PS serial port 2
> +		 216 = /dev/ttyPS3		Xilinx PS serial port 3

Is there a specific reason you need fixed minor numbers ? If not please
use a dynamic range and keep Linus happy.

> +/**
> + * xuartps_isr - Interrupt handler
> + * @irq: Irq number
> + * @dev_id: Id of the port
> + *
> + * Returns IRQHANDLED
> + **/
> +static irqreturn_t xuartps_isr(int irq, void *dev_id)
> +{
> +	struct uart_port *port = (struct uart_port *)dev_id;
> +	struct tty_struct *tty = port->state->port.tty;
> +	unsigned long flags;
> +	unsigned int isrstatus, numbytes;
> +	unsigned int data;
> +	char status = TTY_NORMAL;
> +
> +	spin_lock_irqsave(&port->lock, flags);

The ttys are refcounting now and your locking subtly wrong if you want to
avoid it (you lookup port-> stuff before you lock it)

The best way to do this is

	tty = tty_port_tty_get(&port->state->port);

	/* Returns a tty with reference or NULL */

	Do stuff

	tty_kref_put(tty);



> +static void xuartps_set_termios(struct uart_port *port,
> +				struct ktermios *termios, struct ktermios *old)
> +{

> +	/* Min baud rate = 6bps and Max Baud Rate is 10Mbps for 100Mhz clk */
> +	baud = uart_get_baud_rate(port, termios, old, 0, 460800);
> +	xuartps_set_baud_rate(port, baud);

So why pass 460800 ?

> +	if (termios->c_iflag & INPCK)
> +		port->read_status_mask |= XUARTPS_IXR_PARITY |
> +		XUARTPS_IXR_FRAMING;
> +
> +	if (termios->c_iflag & IGNPAR)
> +		port->ignore_status_mask |= XUARTPS_IXR_PARITY |
> +			XUARTPS_IXR_FRAMING | XUARTPS_IXR_OVERRUN;
> +
> +	/* ignore all characters if CREAD is not set */
> +	if ((termios->c_cflag & CREAD) == 0)
> +		port->ignore_status_mask |= XUARTPS_IXR_RXTRIG |
> +			XUARTPS_IXR_TOUT | XUARTPS_IXR_PARITY |
> +			XUARTPS_IXR_FRAMING | XUARTPS_IXR_OVERRUN;
> +
> +	mode_reg = xuartps_readl(XUARTPS_MR_OFFSET);
> +
> +	/* Handling Data Size */
> +	switch (termios->c_cflag & CSIZE) {
> +	case CS6:
> +		cval |= XUARTPS_MR_CHARLEN_6_BIT;
> +		break;
> +	case CS7:
> +		cval |= XUARTPS_MR_CHARLEN_7_BIT;
> +		break;
> +	default:
> +	case CS8:
> +		cval |= XUARTPS_MR_CHARLEN_8_BIT;
> +		break;

You need to clear/set appropriately any flags for hardware requests you
cannot meet. So your default should be

	termios->c_cflag &= ~CSIZE;
	termios->c_cflag |= CS8;

to rewrite CS5

And set the baud rate (see 8250.c for an example). Note that the helper
functions know about mapping slight errors so if you are asked for 9600
and the hardware does 9575 it will report B9600 as you'd expect not do
something crazy.

> +	xuartps_set_baud_rate(port, 9600);

This seems a bit odd in the startup or is there a hardware need to do
this and then fix the rate ? Ditto some of the others


Otherwise looks fine.

Alan

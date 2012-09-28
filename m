Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab2I1NBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:01:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:32534 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756148Ab2I1NBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:01:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,502,1344236400"; 
   d="scan'208";a="198351826"
Date: Fri, 28 Sep 2012 14:02:48 +0100
From: Alan Cox <alan@linux.intel.com>
To: <Vineet.Gupta1@synopsys.com>
Cc: <gregkh@linuxfoundation.org>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial/arc-uart: Add new driver
Message-ID: <20120928140248.54a10d06@bob.linux.org.uk>
In-Reply-To: <1348835752-28426-1-git-send-email-vgupta@synopsys.com>
References: <1348835752-28426-1-git-send-email-vgupta@synopsys.com>
Organization: Intel
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.11; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +int __attribute__((weak)) running_on_iss;

Globals really ought to have sensible names, if they must exist at all.
Why is this needed ?

> +#define ARC_SERIAL_DEV_NAME	"ttyS"

ttyS is reserved by the 8250 driver. Use a different name

> /* ttySxx per Documentation/devices.txt */
> +#define ARC_SERIAL_MAJOR	4
> +#define ARC_SERIAL_MINOR	64

Use dynamic assignments

> +static void arc_serial_rx_chars(struct arc_uart_port *uart)
> +{
> +	struct tty_struct *tty = NULL;
> +	unsigned int status, ch, flg = 0;
> +
> +	tty = uart->port.state->port.tty;

Please get rid of the unneeded initialisers for things like tty - they
just hide bugs later.

For locking purposes you need to be doing

	tty = tty_port_tty_get(&uart->port.state->port);

	if (tty) {

		stuff

		tty_kref_put(tty);


so that the tty cannot vanish under you on a hangup. As you reference
it in several spots it might make sense to do that once if either
RXIENB/TXIENB is set and then pass it to the tx/rx handlers ?


> +static void arc_serial_break_ctl(struct uart_port *port, int
> break_state) +{
> +	/* ARC UART doesn't support sendind Break signal */

sending ..

> +static void arc_serial_set_ldisc(struct uart_port *port, int ld)
> +{
> +	/* this might need implementing for the touch driver */
> +}

Is this a left over comment or somehting else ?

> +static void
> +arc_serial_set_termios(struct uart_port *port, struct ktermios
> *termios,
> +		       struct ktermios *old)
> +{
> +	struct arc_uart_port *uart = (struct arc_uart_port *)port;
> +	unsigned int baud, uartl, uarth, hw_val;
> +	unsigned long flags;
> +

Two things here. Firstly you want to write the actual baud back to the
termios (tty_termios_encode_baud_rate) unless B0 is set.

Secondly if you don't support hardware flow control, character size
setting etc then you need to set those bits back so the caller knows.
Two ways to do that. Either initialise the default termios for the tty
type to the correct values and use tty_termios_copy_hw() or set them in
the termios handler.

Alan

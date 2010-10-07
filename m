Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab0JGU0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:26:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40809 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751721Ab0JGU0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:26:18 -0400
Date: Thu, 7 Oct 2010 21:50:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, "Hyok S. Choi" <hyok.choi@samsung.com>,
        Tony Lindgren <tony@atomide.com>, Jeff Ohlstein <johlstei@quicinc.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ben Dooks <ben-linux@fluff.org>,
        Alan Cox <alan@linux.intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Mike Frysinger <vapier@gentoo.org>, Feng Tang <feng.tang@intel.com>,
        Tobias Klauser <tklauser@distanz.ch>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>
Subject: Re: [PATCH] serial: DCC(JTAG) serial and console emulation support
Message-ID: <20101007215019.17b4a34a@lxorguk.ukuu.org.uk>
In-Reply-To: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
References: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +	  Say Y here if you want to install DCC driver as a normal serial port
> +	  /dev/ttyS0 (major 4, minor 64). Otherwise, it appears as /dev/ttyJ0
> +	  (major 4, minor 128) and can co-exist with other UARTs, such as
> +	  8250/16C550 compatibles.
> +

NAK to both

ttyJ0 is 204,186 for "JTAG1 DCC protocol based serial"

so there is an existing name and minor allocation, which as you won't be
using two of them should be quite usable.

If you want to be able to switch at runtime to pretend it is ttyS0 please
deal with that in your user space. The same rules apply to you as have
been applied to everyone else who has tried to implement this same crap
in their uart driver too (we'd have it in about 30 by now otherwise)

>
> +static inline void dcc_rx_chars(struct uart_port *port)
> +{
> +	unsigned char ch;
> +	struct tty_struct *tty = port->state->port.tty;

Not safe in the general case - you might get a hangup here then call
through a NULL pointer. Please use the proper tty_port helpers.


> +static inline void dcc_overrun_chars(struct uart_port *port)
> +{
> +	port->icount.overrun++;
> +}

Why make this a function?


> +static void
> +dcc_set_termios(struct uart_port *port, struct ktermios *termios,
> +		struct ktermios *old)
> +{
> +	unsigned int baud, quot;
> +
> +	/*
> +	 * We don't support parity, stop bits, or anything other
> +	 * than 8 bits, so clear these termios flags.
> +	 */
> +	termios->c_cflag &= ~(CSIZE | CSTOPB | PARENB | PARODD | CREAD);
> +	termios->c_cflag |= CS8;
> +
> +	/*
> +	 * We don't appear to support any error conditions either.
> +	 */
> +	termios->c_iflag &= ~(INPCK | IGNPAR | IGNBRK | BRKINT);

There is a helper function for keeping the hardware bits fixed. If your
hardware is fixed then please use it.

Alan

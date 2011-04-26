Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab1DZT5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:57:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35298 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754905Ab1DZT5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:57:17 -0400
Date: Tue, 26 Apr 2011 20:58:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: John Linn <john.linn@xilinx.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <michal.simek@petalogix.com>, <joe@perches.com>,
        <grant.likely@secretlab.ca>, <greg@kroah.com>
Subject: Re: [PATCH V3] tty/serial: add support for Xilinx PS UART
Message-ID: <20110426205809.39a96279@lxorguk.ukuu.org.uk>
In-Reply-To: <b33c1d76-c704-4b84-965b-97bc7e14f390@VA3EHSMHS030.ehs.local>
References: <b33c1d76-c704-4b84-965b-97bc7e14f390@VA3EHSMHS030.ehs.local>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O
> +	if (percent_err >= 3)
> +		dev_err(port->dev, "Error too large, baud rate not set\n");

So in this cause baud isn't the one the user asked. Also the user can
make it spew errors by continually generating wrong rates.

If the error is large go for the nearest you can and return it. The core
tty code will do all the rest including reporting to the user they didn't
get their wishes.

> +	else {
> +		/* Set the values for the new baud rate */
> +		xuartps_writel(brgr_val, XUARTPS_BAUDGEN_OFFSET);
> +		xuartps_writel(brdiv_val, XUARTPS_BAUDDIV_OFFSET);

and in this it may not be exact.

I suspect this routine needs to return the actual baud rate (or maybe
baudrate/error code)


> +	/* Min baud rate = 6bps and Max Baud Rate is 10Mbps for 100Mhz clk */
> +	baud = uart_get_baud_rate(port, termios, old, 0, 10000000);
> +	xuartps_set_baud_rate(port, baud);
> +	if (tty_termios_baud_rate(termios))
> +		tty_termios_encode_baud_rate(termios, baud, baud);

and this should do something like

	baud = xuartps_set_baud_rate(port baud);

> +
> +	/*
> +	 * Update the per-port timeout.
> +	 */
> +	uart_update_timeout(port, termios->c_cflag, baud);

[which would also fix this timeout!]

Otherwise looks ready to merge

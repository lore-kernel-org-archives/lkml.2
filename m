Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573Ab1C2Jdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 05:33:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34864 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751022Ab1C2Jd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 05:33:29 -0400
Date: Tue, 29 Mar 2011 10:33:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Uwe =?ISO-8859-14?B?S2xlaW5lLUv2bmln?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-serial@vger.kernel.org,
        torvalds@linux-foundation.org, kernel@pengutronix.de
Subject: Re: Wrong GIT author ? also bugs: serial: Add uart driver for
 i.MX23/28
Message-ID: <20110329103335.7a5ff37d@lxorguk.ukuu.org.uk>
In-Reply-To: <20110329091456.GI30938@pengutronix.de>
References: <201103180302.p2I326tA020159@hera.kernel.org>
	<20110318112920.07148450@lxorguk.ukuu.org.uk>
	<20110329091456.GI30938@pengutronix.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't understand how to do this and didn't find something like that in
> other drivers. (I checked amba-pl011.c and imx.c.) Also
> Documentation/serial/driver doesn't describe this. (It is also silent
> about CMSPAR and doesn't even advise to clear unsupported bits.)
> Can you be a bit more verbose here?

8250.c is the best place to look.

Basically on return from your routine the _hardware_ bits of the termios
struct should be the ones set.

So eg if you only supported 8bit characters you'd wipe the CSx bits and
set CS8.

For the speed there is a helper so you probably want

        /* Don't rewrite B0 */
        if (tty_termios_baud_rate(termios))
                tty_termios_encode_baud_rate(termios, baud, baud);

> @@ -286,6 +283,9 @@ static void mxs_auart_settermios(struct uart_port *u,
>  {
>  	u32 bm, ctrl, ctrl2, div;
>  	unsigned int cflag, baud;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&u->lock, flags);

Termios you don't need the lock - just the IRQ handler and you still
really want the tty_port_tty_get()/tty_kref_put() if that wasn't already
dealt with.

(You may not need it but its easier to put in than prove with the serial
layer at the moment)

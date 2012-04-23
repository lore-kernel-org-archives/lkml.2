Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab2DWKwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:52:22 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49481 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab2DWKwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:52:19 -0400
Date: Mon, 23 Apr 2012 11:54:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Chen, Bo" <Bo.Chen@atmel.com>
Cc: "alan@linux.intel.com" <alan@linux.intel.com>,
        "rick@efn.org" <rick@efn.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Query] serial: AT91:  Add SIM Driver
Message-ID: <20120423115440.5bb1c7eb@pyramind.ukuu.org.uk>
In-Reply-To: <7AD597EA49E297498E79AFA326C986BB0D317277@penmbx01>
References: <7AD597EA49E297498E79AFA326C986BB0D317277@penmbx01>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I mean to create a char driver which contains ioctl interface to control GPIOs connected to SIM card VCC and RESET.

We have a GPIO layer and existing GPIO interface support so the gpio side
if they are kept independent ought to be easy. However I wonder if the
separate gpio control will make the userspace side harder ?

> Thirdly, I want to use usual tty function (read / write) to implement the ATR / send or receive command / PPS.
> That means tty usual driver read or write will be called by user space application such as openct or else to realize the ATR and PPS.
> Openct may also call above char driver to realize the power or reset function.

That may be difficult to get right because of the tty object lifetime
and the locking rules. One way would be to make ISO7816 a line discipline
(the layer which sits about the tty).

Your user space interface would then be

	int ldisc = N_ISO7816;
	ioctl(tty_fd, TIOCSETD, &ldisc);

at which point the read/write/ioctl etc calls on your tty will also be
routed via your ldisc so you can manage them and provide ISO7816 sensible
interfaces.

You'd still need a way for the ldisc to ask the tty device to manage the
GPIO lines but I don't think that is too tricky to add.

That way it would at least keep everything in one place and avoid adding
new strange paths calling into the tty layer code via non tty devices.


Take a look at the gsmld_ parts of drivers/tty/n_gsm.c for a fairly full
example of a line discipline. You can ignore most of the rest of the code
there, the rest is implementing GSM mux and virtual ttys.

The two thing s it doesn't use are

tty_set_termios(tty, &whatever)

which is a helper for the ldisc or similar to set the terminal state
itself. 

and

tty->driver->ops->tiocmget/tiocmset/etc

for doing things like modem lines. One way to handle the gpios
transparently might be to map them to the nearest equivalent 'modem' line
when in ISO7816 mode.

The tty also sees the ldisc change via tty->ops->set_ldisc(). This is
used by some drivers already for things like automatically selecting IRDA
FIR mode when in IRDA modes.

In your case the driver would set/exit ISO7816 mode when it saw this.

Alan

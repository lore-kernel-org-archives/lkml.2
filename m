Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab0JVPfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 11:35:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46682 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755068Ab0JVPe7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 11:34:59 -0400
Date: Fri, 22 Oct 2010 16:33:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
Cc: linus.walleij@stericsson.com, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lukasz.Rymanowski@tieto.com
Subject: Re: [PATCH 5/9] mfd: Add UART support for the ST-Ericsson CG2900.
Message-ID: <20101022163359.5b22a61b@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTik-S50ZX6mFG+vWhBv0x_WmipP=t+4VqmAgssRC@mail.gmail.com>
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com>
	<20101022135130.617f0ce8@lxorguk.ukuu.org.uk>
	<AANLkTik-S50ZX6mFG+vWhBv0x_WmipP=t+4VqmAgssRC@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The existence of the callback is checked in the function
> uart_tty_open. If either break_ctl or tiocmget is NULL we do not allow
> sleep and this code will never run.

OK yes see this now.

> >> +             CG2900_ERR("Failed to alloc memory for uart_work_struct!");
> >
> > Please use the standard dev_dbg etc functionality - or pr_err etc when
> > you have no device pointer. The newest kernel tty object has a device
> > pointer added so you could use that.
> >
> 
> OK. I like the debug system we have now (using module parameter to set
> debug level in runtime), but I've received comments regarding this
> before so I assume we will have to switch to standard printouts.
> Is it OK to use defines or inline functions to add "CG2900" before and
> '\n' after (as BT_INFO in include/net/bluetooth/bluetooth.h)?

The pr_fmt bit will do what you want for a non dev_dbg type thing. See
include/linux/kernel.h

> >> + * unset_cts_irq() - Disable interrupt on CTS.
> >> + */
> >> +static void unset_cts_irq(void)
> >
> > And no ability to support multiple devices
> >
> 
> OK. We will try to fix this.

That may go away when you clean up the device side. The line discipline
can be attached to any device so must be multi-device aware, the hardware
driver can certainly be single device only if you can only ever have one

[Although its a good idea to design it so it can be fixed because you
 never know when you'll find your sales team just sold someone a two
 device solution ;) ]

> >> +             set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
> >> +             len = tty->ops->write(tty, skb->data, skb->len);
> >
> > A tty isn't required to have a write function
> 
> I don't quite understand your comment here. This particular code is
> inspired of the Bluetooth ldisc code and there it is used like. It
> seems to work fine so we do it the same way.

You copied a security hole from the bluetooth driver which we found a
couple of weeks ago

> How would you prefer it to be?

Check it is valid, in your case probably on open just refuse to attach to
a read only port.

> OK. We will try to figure out a new design.
> I'm not too happy about putting the ldisc part in Bluetooth though
> since it is only partly Bluetooth, it is also GPS and FM. Better could
> maybe be under char/?

Works for me - there is an ongoing "we must move tty ldiscs and core tty
code somewhere more sensible of their own" discussion, so if it is
dropped into char, it'll move with them just fine.

Alan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585Ab0FUOJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 10:09:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59533 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757764Ab0FUOJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 10:09:16 -0400
Date: Mon, 21 Jun 2010 15:13:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Luck <tony.luck@intel.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] serial: revert "Use block_til_ready helper"
Message-ID: <20100621151309.334f6645@lxorguk.ukuu.org.uk>
In-Reply-To: <201006202254.34530.arnd@arndb.de>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de>
	<201006192229.21971.arnd@arndb.de>
	<20100619225706.340eda52@lxorguk.ukuu.org.uk>
	<201006202254.34530.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The way that the output is garbled seems to be just missing characters,
> in a mostly reproducible way. Repeatedly writing the string
> abcdefghijklmnopqrstuvwxyz1234567890 into ttyS0 gives an output like
> 'akq7m3iy', where only every sixteenth character is shown, plus
> an extra character in the second position.

Ok this sort of makes sense. Something isn't getting initialised and both
getty and minicom will do a termios set which is sorting it out.


And this is occurring because the generic block_til_ready sets
ASYNCB_NORMAL_ACTIVE so the termios updating gets skipped.

Ok the quickfix for this kernel is to delete this

       /*
         * If this is the first open to succeed, adjust things to suit.
         */
        if (retval == 0 && !(port->flags & ASYNC_NORMAL_ACTIVE)) {
                set_bit(ASYNCB_NORMAL_ACTIVE, &port->flags);

                uart_update_termios(state);
        }

and paste it into

void tty_port_raise_dtr_rts(struct tty_port *port)
{
        if (port->ops->dtr_rts)
                port->ops->dtr_rts(port, 1);

		-->> HERE <<--
}


(the mutex is held by the caller)

That should cure it and then we can think about doing it more elegantly
by getting the serial layer to use tty_port_open, kfifo and the like and
removing the tons of repeated crap in all the drivers.

Alan

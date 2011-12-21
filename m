Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab1LUQWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 11:22:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:47831 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab1LUQWw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 11:22:52 -0500
Message-ID: <1324484554.10752.16.camel@twins>
Subject: Re: [RFC][PATCH 7/7] serial, 8250: Mostly avoid wakeups from under
 port->lock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 21 Dec 2011 17:22:34 +0100
In-Reply-To: <20111221160323.1084e954@pyramind.ukuu.org.uk>
References: <20111221105739.798864333@chello.nl>
	 <20111221111143.678537446@chello.nl>
	 <20111221160323.1084e954@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 16:03 +0000, Alan Cox wrote:

> > +	BUG_ON(!state);
> > +	tty = state->port.tty;
> > +	tty_kref_get(tty);
> > +	spin_unlock_irqrestore(&up->port.lock, flags);
> > +	tty_wakeup(tty);
> > +	tty_kref_put(tty);
> 
> driver innards shouldn't know this stuff and this makes it worse rather
> than cleaning it up

Fair enough, if I can push it into serial_core.c I can probably fix that
one weird case as well, I couldn't inside the 8250 driver because the
port lock was taken by the serial core code.

> The basic idea looks fine but I really don't want magic lock hackery in
> the 8250 driver. We need a way of generalising this so the code is
> cleaner and the locking internal knowledge stays out of the driver itself.
> 
> Also I think it's probably buggy - sending the x_char is forward progress
> so probably needs to cause a wakeup.

Could you explain that more, its not actually connecting with any
neurons..

> So for the moment NAK, but worthy of figuring out how to do it right

OK, will try and see if I can poke at it a level upwards.. 

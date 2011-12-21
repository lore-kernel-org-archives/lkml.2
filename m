Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab1LUQDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 11:03:11 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58197 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab1LUQDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 11:03:10 -0500
Date: Wed, 21 Dec 2011 16:03:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 7/7] serial, 8250: Mostly avoid wakeups from under
 port->lock
Message-ID: <20111221160323.1084e954@pyramind.ukuu.org.uk>
In-Reply-To: <20111221111143.678537446@chello.nl>
References: <20111221105739.798864333@chello.nl>
	<20111221111143.678537446@chello.nl>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011 11:57:46 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> While not a strict requirement (anymore), it is nice not to issue
> wakeups (or have them connected by locks) from console output.
> 
> This patch avoids doing most wakeups from under port->lock, which is
> connected to 8250console_write(). Only seriously challenged UARTs will
> still do the wakeup, but since I don't actually have such a creature,
> I'm less inclined to fix it up.

Gak..

> +	BUG_ON(!state);
> +	tty = state->port.tty;
> +	tty_kref_get(tty);
> +	spin_unlock_irqrestore(&up->port.lock, flags);
> +	tty_wakeup(tty);
> +	tty_kref_put(tty);

driver innards shouldn't know this stuff and this makes it worse rather
than cleaning it up

The basic idea looks fine but I really don't want magic lock hackery in
the 8250 driver. We need a way of generalising this so the code is
cleaner and the locking internal knowledge stays out of the driver itself.

Also I think it's probably buggy - sending the x_char is forward progress
so probably needs to cause a wakeup.

So for the moment NAK, but worthy of figuring out how to do it right

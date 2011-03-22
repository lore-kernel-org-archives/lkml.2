Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab1CVKfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 06:35:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46419 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752270Ab1CVKfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 06:35:18 -0400
Date: Tue, 22 Mar 2011 10:35:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Johan Hovold <jhovold@gmail.com>
Cc: Toby Gray <toby.gray@realvnc.com>, Oliver Neukum <oliver@neukum.name>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] USB: cdc-acm: Prevent data loss when filling tty
 buffer.
Message-ID: <20110322103534.2284099e@lxorguk.ukuu.org.uk>
In-Reply-To: <20110322100526.GB21343@localhost>
References: <1300722745-2404-1-git-send-email-toby.gray@realvnc.com>
	<1300730698-17099-1-git-send-email-toby.gray@realvnc.com>
	<20110322100526.GB21343@localhost>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> re-submitted. So the only way this will work is if it can be guaranteed
> that the line discipline will throttle and later unthrottle us. I
> doubt that is the case, but perhaps Alan can give a more definite
> answer?

If an ldisc throttles it should always later unthrottle. However flow
control is async so at high enough data rates it'll be too slow.

> I would also prefer a more generic solution to the problem so that we
> don't need to re-introduce driver buffering again. Since we already have
> the throttelling mechanism in place, if we could only be notified/find
> out that the tty buffers are say half-full, we could throttle (from

The tty layer actually knows this fact

> within the driver) but still push the remaining buffer still on the wire
> as they arrive. It would of course require a guarantee that such a
> throttle-is-about-to-happen notification is actually followed by (a
> throttle and) unthrottle. Thoughts on that?

tty throttling is at the ldisc layer, the tty buffers are below this. The
space left being 64K - tty->buf.memory_used

So you can certainly add the following routine

int tty_constipated(struct tty *t)
{
	if (tty->buf.memory_used > 49152)
		return 1;
	return 0;
}
EXPORT_SYMBOL_GPL(tty_constipated);

to drivers/tty/tty_buffer.c

The wakeup side is a bit trickier.

The down side of this of course is that you are likely to run at below
peak performance as you'll keep throttling back the hardware, whereas if
you have a tickless kernel with HZ set to 1000 it's probably sufficient
to bump the buffer sizes.

Right now (see tty_buffer.c) it's simply set to 64K as a sanity check
against throttled devices not stopping, but there isn't actually any
reason it couldn't be configurable at port setup time.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab1FJLdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 07:33:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43061 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755594Ab1FJLdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 07:33:36 -0400
Date: Fri, 10 Jun 2011 12:35:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: uart : lost characters when system is busy
Message-ID: <20110610123541.7d93a4fc@lxorguk.ukuu.org.uk>
In-Reply-To: <4DF1EC83.5070106@parrot.com>
References: <4DF1DCA9.9060604@parrot.com>
	<20110610102026.01f7da05@lxorguk.ukuu.org.uk>
	<4DF1EC83.5070106@parrot.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also I believe some virtual usb uart (3G dongle, cdc-acm) that use higher rate
> (more than 10 Mbps)  will have the same problem. They will fill the buffer very
> quickly.

PPP doesn't use throttling so those dongles which are use modem emulation
will flow control at the IP level which is probably better anyway.

> For example the "USB: cdc-acm: Prevent loss of data when filling tty buffer"
> patch may be changed to something like :
> 
>     /* throttle device if requested by tty */
>     spin_lock_irqsave(&acm->read_lock, flags);
>     acm->throttled = acm->throttle_req;
>     if (!acm->throttled && !acm->susp_count && !tty_is_throttled()) {
>         spin_unlock_irqrestore(&acm->read_lock, flags);
>         acm_submit_read_urb(acm, rb->index, GFP_ATOMIC);
>     } else {
>         spin_unlock_irqrestore(&acm->read_lock, flags);
>     }

Except this now races the handling in the throttle/unthrottle events. In
particular you could have an unthrottle queued to occur such that by the
time it occurs we've throttled again, plus the ldisc may be quite slack
in signalling it to the tty layer.

For that example a second approach would be to provide

static int tty_buffer_room(struct tty *tty)
{
	return 65536 - tty->buf.memory_used;
}

and you could then buffer against the queue size, which is easy to
monitor in IRQ state, but would mean that you'd need to be sure that you
always had some buffer posted or some way to recover from the no buffers
case (eg adding

	if (tty-ops->buffer_free)
		tty->ops->buffer_free(tty)

to tty_buffer_free())

At that point it is throttling against the queue that is handled in
interrupt space.

Care to prototype those bits in your tree and see if it sorts your use
case ?

Alan

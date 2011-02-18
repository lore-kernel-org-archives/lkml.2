Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab1BRJuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 04:50:13 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60686 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753971Ab1BRJuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 04:50:07 -0500
Date: Fri, 18 Feb 2011 09:50:48 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] tty: add TIOCVHANGUP: time for revoke() in f_ops ?
Message-ID: <20110218095048.4e9f1e1a@lxorguk.ukuu.org.uk>
In-Reply-To: <1297964368.2165.1.camel@yio>
References: <1297964368.2165.1.camel@yio>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Without this ioctl it would have to temporarily become the owner of
> the tty, then call vhangup() and then give it up again.

This is a hack - it's also unfortunately not actually sufficient or
complete which is why we didn't do it years ago. Sorry but if it was easy
it would have been in a long time back !


> +	case TIOCVHANGUP:
> +		if (!capable(CAP_SYS_ADMIN))

Is there any reason for not allowing revocation of a tty that you are
the owner of (ie one you could anyway take ownership of and hangup ?)


> +			return -EPERM;
> +		tty_vhangup(tty);

That raises a few locking questions. From a brief review of the code I
think its directly 1:1 equivalent to allowing a parallel vhangup and
carrier drop which we already do. The tty locks appear to cover this
correctly for the basic stuff although I further review of the ldisc
hangup area from someone with a strong stomache would be good.

You would still need to be very careful how you used it from the admin
side because the parallel

	CPU1					CPU2
	vhangup()				chmod()
	process vhangup
	return
	chown to user1
						chmod to 777
						syscall ends (fd
						revocation takes effect)

	Oops, 0wned

case is not handled by the paths you are using. So to actually do this
you need rather more infrastructure work to ensure the existing calls
have completed before returning.

At that point you've essentially provided revoke() for the tty layer so
it might well be implemented to be called as revoke() as well.

So I don't actually think the patch should be applied in this form,
because it simply adds an interface that will cause problems. Fixed to
return after the revocation is truely complete would be good though.

I'd guess you need to add a counter to the tty f_ops entry/exit points to
know when that occurs, and wake_up the revoke path when ready
(remembering two revokes in parallel shouldn't deadlock! so need
counting too)

In its current form the proposal isn't secure, so NAK, but I'd love to
see it resubmitted with the the other bits done to return at the right
moment.

Alan

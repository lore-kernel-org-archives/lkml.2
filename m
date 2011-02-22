Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab1BVXXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 18:23:49 -0500
Received: from kroah.org ([198.145.64.141]:47771 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339Ab1BVXXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 18:23:48 -0500
Date: Tue, 22 Feb 2011 15:15:36 -0800
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] tty: add TIOCVHANGUP: time for revoke() in f_ops ?
Message-ID: <20110222231536.GA18066@kroah.com>
References: <1297964368.2165.1.camel@yio>
 <20110218095048.4e9f1e1a@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110218095048.4e9f1e1a@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 09:50:48AM +0000, Alan Cox wrote:
> > Without this ioctl it would have to temporarily become the owner of
> > the tty, then call vhangup() and then give it up again.
> 
> This is a hack - it's also unfortunately not actually sufficient or
> complete which is why we didn't do it years ago. Sorry but if it was easy
> it would have been in a long time back !
> 
> 
> > +	case TIOCVHANGUP:
> > +		if (!capable(CAP_SYS_ADMIN))
> 
> Is there any reason for not allowing revocation of a tty that you are
> the owner of (ie one you could anyway take ownership of and hangup ?)

You could do that already today with the vhangup() syscall, right?

> > +			return -EPERM;
> > +		tty_vhangup(tty);
> 
> That raises a few locking questions. From a brief review of the code I
> think its directly 1:1 equivalent to allowing a parallel vhangup and
> carrier drop which we already do. The tty locks appear to cover this
> correctly for the basic stuff although I further review of the ldisc
> hangup area from someone with a strong stomache would be good.
> 
> You would still need to be very careful how you used it from the admin
> side because the parallel
> 
> 	CPU1					CPU2
> 	vhangup()				chmod()
> 	process vhangup
> 	return
> 	chown to user1
> 						chmod to 777
> 						syscall ends (fd
> 						revocation takes effect)
> 
> 	Oops, 0wned
> 
> case is not handled by the paths you are using. So to actually do this
> you need rather more infrastructure work to ensure the existing calls
> have completed before returning.

But wouldn't this race still happen no matter if vhangup() is in the mix
or not?  I don't see how adding this ioctl changes anything here, what
am I missing?

> At that point you've essentially provided revoke() for the tty layer so
> it might well be implemented to be called as revoke() as well.

It's not a "real" revoke, more like vhangup(file_descriptor) only.
revoke() involves a lot more than just this.

It would be great to have a real revoke() but that seems beyond this
need at the moment.

> So I don't actually think the patch should be applied in this form,
> because it simply adds an interface that will cause problems. Fixed to
> return after the revocation is truely complete would be good though.
> 
> I'd guess you need to add a counter to the tty f_ops entry/exit points to
> know when that occurs, and wake_up the revoke path when ready
> (remembering two revokes in parallel shouldn't deadlock! so need
> counting too)

Again, I'm confused, how does the locking differ from vhangup() today?

thanks,

greg k-h

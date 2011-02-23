Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab1BWAIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 19:08:00 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57210 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751451Ab1BWAH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 19:07:59 -0500
Date: Wed, 23 Feb 2011 00:09:58 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] tty: add TIOCVHANGUP: time for revoke() in f_ops ?
Message-ID: <20110223000958.7c18fdef@lxorguk.ukuu.org.uk>
In-Reply-To: <20110222231536.GA18066@kroah.com>
References: <1297964368.2165.1.camel@yio>
	<20110218095048.4e9f1e1a@lxorguk.ukuu.org.uk>
	<20110222231536.GA18066@kroah.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You could do that already today with the vhangup() syscall, right?

Yes - hence the permission checks are excessive right now.

> > You would still need to be very careful how you used it from the admin
> > side because the parallel
> > 
> > 	CPU1					CPU2
> > 	vhangup()				chmod()
> > 	process vhangup
> > 	return
> > 	chown to user1
> > 						chmod to 777
> > 						syscall ends (fd
> > 						revocation takes effect)
> > 
> > 	Oops, 0wned
> > 
> > case is not handled by the paths you are using. So to actually do this
> > you need rather more infrastructure work to ensure the existing calls
> > have completed before returning.
> 
> But wouldn't this race still happen no matter if vhangup() is in the mix
> or not?  I don't see how adding this ioctl changes anything here, what
> am I missing?

The current users actually handle this - mostly by accident partly by
their nature.

> It's not a "real" revoke, more like vhangup(file_descriptor) only.
> revoke() involves a lot more than just this.

Real revoke is no different. General purpose real revoke for arbitary
objects is a nightmare - but guess what *NO* Unixalike implements that.
 
> > I'd guess you need to add a counter to the tty f_ops entry/exit points to
> > know when that occurs, and wake_up the revoke path when ready
> > (remembering two revokes in parallel shouldn't deadlock! so need
> > counting too)
> 
> Again, I'm confused, how does the locking differ from vhangup() today?

Our vhangup users are not under the delusion that the interface is race
free. Really it wants fixing anyway, but exposing the race with an
inviting new way to screw up isn't good - and the usage model of
vhangup(fd) is such that you can't actually use the ABI for anything
interesting without fixing it.

Also vhangup(fd) with the bug fixed *IS* revoke() so lets stop pretending
it isn't. It's far better to add revoke to the VFS at this point and wire
that to the vhangup + race fixes code that has to be done anyway. In fact
I think it has to be done at that level ultimately to make sure any open
versus hangup races are caught.

It's a new file op to which everyone else (for now) says NULL = no can
do. Really for desktop switching we also want it for some other devices,
so the infrastructure is needed anyway.

revoke is hard, vhangup(fd) is revoke, the rest inevitably follows, but
once it's done then you can add it to a few other cdevs and do all the
nice desktop switching stuff right as well.

It's basically 3 things
- Lennarts bits for vhangup on an fd
- A revoke vfs op
- Counting people in and out of the tty syscalls - which is a hit but its
  not gigabit stuff so won't hurt. Again very easy to implement, and if
  it causes performance corner cases on 4000 CPU boxes smart people can
  fix it later for that. We should do this one anyway
- Ideally dealing with parallel open/revoke paths, which needs the cdev
  code involved

Its not a quick patch - that's why its not happened yet, vhangup(fd)
quickfix Lennart style is unfortunately a useless bodge job which like
most bodge jobs is simply going to spring leaks and need fixing again.

Alan

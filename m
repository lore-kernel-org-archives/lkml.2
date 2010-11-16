Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab0KPXqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 18:46:46 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58341 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755375Ab0KPXqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 18:46:45 -0500
Date: Tue, 16 Nov 2010 23:45:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Werner Fink <werner@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
Message-ID: <20101116234534.3dd669d7@lxorguk.ukuu.org.uk>
In-Reply-To: <20101116231023.GB27594@tango.0pointer.de>
References: <1289922400.1253.3.camel@yio.site>
	<20101116155717.6671e484@lxorguk.ukuu.org.uk>
	<AANLkTimn7zyEjLhmOmUVQGnLDfM-A_uEgWETsM3nsyuY@mail.gmail.com>
	<20101116171447.29336514@lxorguk.ukuu.org.uk>
	<AANLkTi=ju4fON7Hz=j_tFtqFGD0b-c=-Ou+HQwfYDgOy@mail.gmail.com>
	<20101116195538.7fa66b97@lxorguk.ukuu.org.uk>
	<20101116213622.GA17824@tango.0pointer.de>
	<20101116225619.5fa7ef8b@lxorguk.ukuu.org.uk>
	<20101116231023.GB27594@tango.0pointer.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Trivial enough to fix? No it isn't. We tried to come up with a sane fix
> for the current ioctl() iface, but it's not feasible. a) is unfixable
> anyway without some kind of additional fd, since the tty fd is not
> really something you want to overload with new POLLxxx events. For b)
> you either need a per-consumer queue, so that no events are lost. That
> is cumbersome, and would add a massive amount of code to the kernel. Or
> you need some kind of atomic extenstion a la "wait only if this
> information is still current". Which would work for our use case but
> still eat events that happen between the WAITEVENT calls. Or you would
> have to do this synchronous, which would basically allow userspace to
> block VT switches and the kernel indefinitely. Which is dangerous.

Any kernel interface with a queue will lose events or block, its a
mathematical limit. A bounded length per consumer queue is really trivial
to implement thanks to the kfifo code and its easy enough to have an
overflow event to say "you didn't keep up, sort out your context"

Agreed entirely it needs a separate fd.

I wouldn't have expected there to have been many live queues in a system
- one for your management daemon, and perhaps one for someone debugging.

> latest info available. And the POLLPRI makes sure that you will notice
> it isn't up-to-date the moment you enter poll() again. Race-free.

That's not the usual definition of race free. It merely means that you
can ask 'was the data I used obsolete', not race-free which is 'is the
data I have valid'. Trouble is by then you've used it. That's my concern
about whether it is being done right.

> > > Well, the suff it provides is purely informational. You cannot actually
> > > influence the TTY in anyway, you can just watch which VT is currently
> > > active.
> > 
> > Try that with "keystrokes" for example. its a bogus argument.
> 
> Jeez. Kay's interface does not expose keystrokes. Just a simple integer
> which tells yu which VT is current.

Stop acting dumb for a moment, I was pointing out the generality of the
argument was daft.

> > Describe this permission management you are doing please.
> 
> When two users A and B are logged in, on tty1 resp. tty2, then as long
> as tty1 is active user A should get access to the sound card, usb key,
> .... As soon as we switch to tty2 user B should.

So firstly you need to implement revoke.

That aside you still have the problem that you will lag in your
permission changes so if user B is quick they can get access to things
belonging to user A. No big deal for sound output but a bit bad for
reformatting his USB key.

We get what

	poll
	what tty
	tty1 - oh thats fred
	switch to tty2 bill

	set all the rights for fred
	Oh bugger while we've been remounting file systems (can take 30
	seconds easily) bill has been a bad boy (or just got fed up of
	the wrong music)

So yes it'll always run after the correct answer (which waitactive wont)
but I don't see how you can build a real permission model on it. I do see
how you can use it to get the right sound playing and the like which
waitactive can't do right. Furthermore you aren't going to be able to do
real permissions with it when you get revoke because at the point your
switching is actually a real permission boundary you need to be able to
have the daemon also lock the vt to stop changes. We do support that kind
of locking of vt switching, and in the past fifteen years it hasn't been
a big problem. In particular it does the relevant unlocking and the like
if the owner dies.

Your interface is also going to go castors up once we allow multiple
active vts at once belonging to multiple users. That's a limit which is
already becoming a bit of an embarrasment with the capabilities of the
current DRI.

I think I'd rather have a proper event kfifo device (which is a tiny bit
of code) and which can in future support multi-console stuff and which
integrates with the existing kernel vt switch locking when the user has
suitable rights and wants to do that.


Now if you got

	open /dev/vtmgr
	poll
	event structure

which behaved with the same behaviour as your magic sysfs hook off a
device file you would I assume be happy even though the data is just as
useless as your current scheme ?

It would however allow reporting of more things, allow us to go
multi-head without the API breaking (providing the messages are
sensibly designed) and support synchronous notification/approval which the
sysfs file won't and it would fix all the VT_WAITEVENT equivalent
functionality for all the potential users.

Not sure I'd want to allow more than one opener to do notify/approval
stuff.

Codewise its pretty trivial - misc device register, alloc a page sized
kfifo on open, free it on close, yank a kfifo entry on read, do poll
properly and stuff the messages posted down each open one.

Serious question - do we even need multiple openers. Your model for this
is a manager app which presumably can provide events to any other bit of
the desktop that cares and in fact probably should be the person doing
that so that it can sequence and control things cleanly ?

(we an always add multiple opener later)


Alan

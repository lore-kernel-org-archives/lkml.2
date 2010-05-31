Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab0EaUwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 16:52:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53016 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750Ab0EaUwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 16:52:11 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: James Bottomley <James.Bottomley@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: tytso@mit.edu, LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>, felipe.balbi@nokia.com
In-Reply-To: <1275156734.1645.496.camel@laptop>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	 <Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	 <20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	 <20100527220949.GB10602@srcf.ucam.org>
	 <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	 <20100527223605.GB11364@srcf.ucam.org>
	 <20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
	 <20100528043114.GC26177@thunk.org> <1275030704.32462.11.camel@laptop>
	 <AANLkTikEtlbkT4Ws3H2YGt_9QC46B5dr-b1oxJOcG4GN@mail.gmail.com>
	 <1275120618.27810.12699.camel@twins>
	 <1275149418.4503.128.camel@mulgrave.site>
	 <1275156734.1645.496.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 May 2010 15:52:04 -0500
Message-ID: <1275339124.2823.318.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-29 at 20:12 +0200, Peter Zijlstra wrote:
> On Sat, 2010-05-29 at 11:10 -0500, James Bottomley wrote:
> > > Correct, I strongly oppose using suspend. Not running runnable tasks is
> > > not a sane solution.
> > 
> > Look, this is getting into the realms of a pointless semantic quibble.
> > The problem is that untrusted tasks need to be forcibly suspended when
> > they have no legitimate work to do and the user hasn't authorised them
> > to continue even if the scheduler sees them as runnable.  Whether that's
> > achieved by suspending the entire system or forcibly idling the tasks
> > (using blocking states or freezers or something) so the scheduler can
> > suspend from idle is something to be discussed,
> 
> So what happens if you task is CPU bound and gets suspended and is
> holding a resource (lock, whatever) that is required by someone else
> that didn't get suspended?
> 
> That's the classic inversion problem, and is caused by not running
> runnable tasks.

OK ... but if the options are running and S3 for the entire platform,
then all tasks get suspended and this isn't a problem.  This is why the
current wakelock implementation on the android platform works flawlessly
today.

Inversion only becomes a problem if tasks get individually idled, so you
can see that, from the android point of view, we're creating a problem
which their implementation doesn't have.

In this view, S3 suspend does look elegant: it solves the inversion
problem by suspending everything, it controls rogue applications' power
consumption and it gets certain hardware into a lower power state than
is possible from suspend from idle.

The inelegance of the S3 suspend solution is the requirement to use
these suspend blockers through kernel and user space to get the whole
thing up again to respond to an event, which is an inelegance suspend
from idle doesn't have.

> >  but the net result is
> > that we have to stop a certain set of tasks in such a way that they can
> > still receive certain external events ... semantically, this is
> > equivalent to not running runnable tasks in my book.
> 
> Why would be care about external events? Clearly these apps are ill
> behaved, otherwise they would have listened to the environment telling
> them to idle.

That's not a correct characterisation.  Badly behaved apps from a power
point of view can do useful things for the user.  The object is to
contain the badness while still getting useful stuff done.

> Why would you try to let buggy apps work as intended instead of break
> them as hard as possible? Such policy promotes crappy code since people
> get away with it.
> 
> >  (Perhaps this whole
> > thing is because the word runnable means different things ... I'm
> > thinking a task that would consume power ... are you thinking in the
> > scheduler R state?)
> 
> Clearly I mean TASK_RUNNABLE, if not that the scheduler doesn't care.
> 
> > Realistically, the main thing we need to do is stop timers posted
> > against the task (which is likely polling in a main loop, that being the
> > usual form of easy to write but power crazy app behaviour) from waking
> > the task and bringing the system out of suspend (whether from idle or
> > forced).
> 
> Sure, that same main loop will probably receive a message along the
> lines of, 'hey, screen is off, we ought to go sleep'. If after that it
> doesn't listen, and more serious messages don't get responded to, simply
> kill the thing.
> 
> Again, there is no reason what so ever to tolerate broken apps, it only
> promotes crappy apps.

Actually, no, if this were a correct view, we wouldn't have the huge x86
hardware work around problem because we'd just be able to tell
manufacturers of shoddy or badly standards compliant stuff where to
stick it.

The great strength of the x86 commodity platform revolution was the fact
that the hardware became cheap, plentiful and outside the ambit of a
single walled garden manufacturer.  It's great weakness is integration
problems and shoddy hardware.  We tolerate the weakness because the
strength vastly outweighs it: and toleration to us in the kernel means
driver work arounds ... it also means that if a device doesn't work with
the kernel, we get blamed (rather than the manufacturer).

By the same token, the revolution in smart phones is driven in quite a
large part by the provision of third party applications.  This commodity
app view is almost the direct software analogue of the commodity
platform view that has been so successful in hardware; Therefore, fair
play seems to demand that we don't draw a hard line for software
applications that we wouldn't draw for hardware devices.

James



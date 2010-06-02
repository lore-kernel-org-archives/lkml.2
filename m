Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910Ab0FBXV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 19:21:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49595 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758834Ab0FBXVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 19:21:55 -0400
Date: Thu, 3 Jun 2010 09:21:39 +1000
From: Neil Brown <neilb@suse.de>
To: Florian Mickler <florian@mickler.org>
Cc: Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] - race-free suspend. Was: Re: [linux-pm] [PATCH 0/8] 
 Suspend block api (version 8)
Message-ID: <20100603092139.67c15891@notabene.brown>
In-Reply-To: <20100602210521.54b9cd9b@schatten.dmk.lab>
References: <Pine.LNX.4.44L0.1005271303190.3239-100000@iolanthe.rowland.org>
	<201006010005.19554.rjw@sisk.pl>
	<20100601090023.788cabf4@notabene.brown>
	<201006010232.20263.rjw@sisk.pl>
	<20100601113309.609349fd@notabene.brown>
	<alpine.LFD.2.00.1006010340160.2933@localhost.localdomain>
	<20100601122012.1edeaf48@notabene.brown>
	<alpine.LFD.2.00.1006011243350.2933@localhost.localdomain>
	<20100602153235.340a7852@notabene.brown>
	<AANLkTikVjAf5nHdMx2bcHRAUSkq99s-b5YZCECXIJJLy@mail.gmail.com>
	<20100602180614.729246ea@notabene.brown>
	<AANLkTimISbs4X2YR_Pal9A80mpkNyCy8laWBcOgR2Cl7@mail.gmail.com>
	<20100602210224.6ae2333f@notabene.brown>
	<20100602210521.54b9cd9b@schatten.dmk.lab>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010 21:05:21 +0200
Florian Mickler <florian@mickler.org> wrote:

> Could someone perhaps make a recap on what are the problems with the
> API? I have no clear eye (experience?) for that (or so it seems).

Good interface design is an acquired taste.  And it isn't always easy to
explain satisfactorily.  But let me try to explain what I see.

A key aspect of a good interface is unity, and sometimes uniformity.
For example, the file descriptor is a key element to the unity of the 
Unix (and hence Posix and Linux) interface.  "everything is a file" and
even when it isn't, everything is accessed via a file descriptor.
This is one of the reasons that signals cause so much problem when
programming in Unix - they aren't files, don't have file descriptors and
don't look them at all.  That is why signalfd was created, to try to tie
signals back in to the 'file descriptor' model.

So unity is important.  Adding new concepts is best done as an extension of
an existing concept.  That means that all the infrastructure, not only code
and design but also developer understanding, can be leveraged to help get the
new concept *right* first time.  It also means that using the new concept is
easier to learn.

So the problem with the wake-locks / suspend-blockers (and I've actually come
to like the first name much more) is that it introduces a new concept without
properly leveraging existing concepts.

The new concept is opportunistic suspend, though maybe a better name would be
automatic suspend - not sure.

There appear to be two ways you can get opportunistic suspend leveraging
already-existing concepts.

One is to leverage the current "power/state = mem" architecture and just let
userspace choose the opportune moment.  The user-space daemon that chooses
this moment would need full information about states of various things to do
this, but sysfs is good at providing full information about what is in the
kernel, and there are dozens of ways for user-space processes to communicate
their state to each other.  So this is all doable today without introducing
new design concepts.
Except there is a race between suspending and new events, so we just need to
fix the race. Hence my patch.

The other is to leverage the more general power management infrastructure.
We can already detect when the processor won't be needed for a while, and put
it into a low-power state.  We can already put devices to sleep when they
aren't being used.  We can just generalise this so that we can detect when
all devices are either unused, or capable of supporting an S3 transition, and
detect when the next timer interrupt is far enough in the future that S3
latency wont be a problem - set the rtc alarm to match the next timer and go
to S3.  All completely transparent.  (I admit I'm not entirely sure what the 
qos that is being discussed brings us, but I assume it is better quality
rather than correctness).

So there are at least two different ways that opportunistic suspend could be
integrated into existing infrastructure with virtually no change of interface
and no new concepts - just refining or extending existing concepts.

Yet the approach used and preferred by android is to create something
substantially new.  Yes, it does use the existing suspend infrastructure, but
in a very new and different way.  Suspend is now initiated by the kernel, but
in a completely different way to the ways that the kernel already initiates
power saving.  So we have two infrastructures for essentially one task.
Looked at the other way, it moves the initiation of suspend from user-space
into the kernel, and then allows user-space to tell the kernel not to suspend.
That to me is very ugly.
In general, the kernel should provide information to user-space, and provide
services to user-space, and user-space should use that information to decide
what services to request.  This is the essence the "policy lives in
user-space" maxim.
The Android code has user-space giving information to the kernel, so the
kernel can make a policy decision.  This approach is generally less flexible
and is best avoided.

Just as a bit of background, let's think about some of the areas in the
kernel where the kernel does make policy decisions based on user-space input.
 - the scheduler - based on 'nice' setting it decided who should run when
 - the VM - based on read-ahead settings, madvise/fadvise, recent-use
   heuristics, it tries to decide what to keep in memory and what to swap out.
I think those are the main ones.  There are other smaller fish like the
choice of IO scheduler and various ways to tune network connections.

But the two big ones are perfect examples of subsystems that have proven very
hard to get *right*, and have been substantially re-written more than once.
In each case, the difficulty wasn't how to perform the work, it was the
choice of what work to perform.  It probably also involved getting different
sorts of information about the current state.

That perspective leaves me very sceptical of any design that involves making
policy decisions in the kernel.  It is too easy to get wrong, then too hard
to change.
Admittedly the power subsystem does seem to make policy decisions in the
kernel, via the various governors.  Though I don't know much about how these
work, it seems significant that there is a pluggable infrastructure with
multiple governors, and one of them leaves the decisions to user-space.

So that is what I see as wrong with the android API : it doesn't bring unity
by simply leveraging existing infrastructure, and it makes policy decisions
in the kernel.


> 
> > It is a pity that this extra requirement was not clear from your introduction
> > to the "Opportunistic suspend support" patch.
> 
> I think that the main problem was that _all_ the requirements were
> not communicated well.  That caused everybody to think that their
> solution would be a better fit. You are not alone.
>  
> > If that be the case, I'll stop bothering you with suggestions that can never
> > work.
> > Thanks for your time,
> > NeilBrown
> 
> Don't be frustrated. What should Arve be?  :)
>

Sometimes appearing frustrated can elicit a different style of response to
appearing polite and constructive... can be helpful.
And yes:  I fully understand that Arve would be frustrated.  There seems to
be a big disconnect in perceptions of what problem is trying to be solved, and
thus disconnects in what the solution should look like, and I suspect that
would be very frustrating all around.

NeilBrown

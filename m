Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab2BLCFN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 21:05:13 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53864 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab2BLCFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 21:05:10 -0500
Date: Sat, 11 Feb 2012 18:05:07 -0800
From: mark gross <markgross@thegnar.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: NeilBrown <neilb@suse.de>, Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <greg@linuxfoundation.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 0/8] PM: Implement autosleep and "wake locks"
Message-ID: <20120212020507.GD18742@gs62>
Reply-To: markgross@thegnar.org
References: <201202070200.55505.rjw@sisk.pl>
 <20120209105736.027b1e0a@notabene.brown>
 <201202100144.11123.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201202100144.11123.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 01:44:10AM +0100, Rafael J. Wysocki wrote:
> Hi,
> 
> On Thursday, February 09, 2012, NeilBrown wrote:
> > On Tue, 7 Feb 2012 02:00:55 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > 
> > > All in all, it's not as much code as I thought it would be and it seems to be
> > > relatively simple (which rises the question why the Android people didn't
> > > even _try_ to do something like this instead of slapping the "real" wakelocks
> > > onto the kernel FWIW).  IMHO it doesn't add anything really new to the kernel,
> > > except for the user space interfaces that should be maintainable.  At least I
> > > think I should be able to maintain them. :-)
> > > 
> > > All of the above has been tested very briefly on my test-bed Mackerel board
> > > and it quite obviously requires more thorough testing, but first I need to know
> > > if it makes sense to spend any more time on it.
> > > 
> > > IOW, I need to know your opinions!
> > 
> > I've got opinions!!!
> 
> Good! :-)
> 
> It seems that no one else has.
I'm sorry I've been really bad this last year about my email latency.

> > I'll try to avoid the obvious bike-shedding about interface design...
> > 
> > The key point I want to make is that doing this in the kernel has one very
> > import difference to doing it in userspace (which, as you know, I prefer)
> > which may not be obvious to everyone at first sight.  So I will try to make it
> > apparent.
> > 
> > In the user-space solution that we have previously discussed, it is only
> > necessary for the kernel to hold a wakeup_source active until the event is
> > *visible* to user-space.  So a low level driver can queue e.g. an input event
> > and then deactivate their wakeup_source.  The event can remain in the input
> > queue without any wakeup_source being active and there is no risk of going to
> > sleep inappropriately.
> > This is because - in the user-space approach - user-space must effectively
> > poll every source of interesting wakeup events between the last wakeup_source
> > being deactivate and the next attempt to suspend.  This poll will notice the
> > event sitting in a queue so that a well-written user-space will not go to
> > sleep but will read the event.
> > (Note that this 'poll-of-every-device' need not be expensive.  It can be a
> > single 'poll' or 'select' or even 'read' on a pollfd).
> 
> So I see one little problem with that, which is that you'd need to teach user
> space developers what to do an how to do that correctly.
> 
> Also, when you say "user space", it isn't exactly clear whether you mean a
> power manager (that would carry out the attmepts to suspend) or applications
> (that would need to communicate with the power manager to let it know what
> they are doing).  This is important, because in general, before deactivating
> a wakeup source the kernel subsystem should know that the associated event
> has become visible not only to the "polling" application, but also (perhaps
> indirectly) to the power manager, so that it doesn't trigger suspend too
> early.

yup, an explicit user mode acknowledgment of the wake event would be
appropriate.

> > In the kernel based approach that you have presented this is not the case.
> > As the kernel will initiate suspend the moment the last wakeup_source is
> > released (with no polling of other queues), there must be an unbroken chain of
> > wakeup_sources from the initial interrupt all the way up to the user.
> > In particular, any subsystem (such as 'input') must hold a wakeup_source
> > active as long as any designated 'wakeup event' is in any of its queues.
> > This means that the subsystem must be able to differentiate wakeup events
> > from non-wakeup events.
> > This might be easy (maybe "all events are wakeup events" or "all events on
> > this queue are wakeup events") but it is not obvious to me that that is the
> > case.
> > 
> > To summarise: for this solution to be effective it also requires that
> >  1/ every subsystem that carries wakeup events must know about wakeup_sources
> >     and must activate/deactivate them as events are queued/dequeued.
> >  2/ these subsystems must be able to differentiate between wakeup events and
> >     non-wakeup events, and this must be a configurable decision.
> > 
> > Currently, understanding wakeup events is restricted to:
> >  - drivers that are capable of configuring wakeup
> >  - user-space which cares about wakeup
> > The proposed solution adds:
> >  - intermediate subsystems which might queue wakeup events
> > 
> > I think that is a significant addition to make and not one to be made
> > lightly.  It might end up adding more code than you thought it would be :-)
> 
> I'm aware of that and I expect people to come up with patches adding the
> handling of wakeup events to a number of subsystems (this is kind of needed
> regardless of autosleep if we want to be sure that user space has actually
> consumed events we want it to take from us before suspending).  However,
> I'm not expecting that to be a lot of code (I think we both can only speculate
> about that at this point) and those subsystems have maintainers and the
> decision whether or not to take that code is theirs.
> 
> That may be a long process, but at least we can see from Android what's
> needed and where.
> 
> Still, the point here is to give people something to start with so that they
> can take the Android user space, test it against the mainline and see what
> doesn't work and why and come up with fixes.  Perhaps they will have better
> ideas than we think right now, but surely nothing more is going to happen
> without this starting point.
> 
> I'd like us and Android to use the same low-level data structures for power
> management and the same API eventually, at least for drivers.  This is not
> the case at the moment and it's actively hurting us as a project quite a bit.
> If Android needs to add patches on top of whatever we have to get the desired
> functionality, I'm fine with that, as long as they don't require drivers to use
> APIs that are incompatible with the mainline.  Insisting that Android should
> use a user-space-based autosleep implementation wouldn't help at all, because
> realistically this isn't going to happen.

why not?  I don't think having the PMS explicitly acknowledge a wake
event is a big ask at all.

--mark

> > Thanks for the opportunity to comment,
> 
> No need to thank for that, it's Open Source after all ...
> 
> Thanks,
> Rafael

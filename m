Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab2BLByg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 20:54:36 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32952 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab2BLByf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 20:54:35 -0500
Date: Sat, 11 Feb 2012 17:54:32 -0800
From: mark gross <markgross@thegnar.org>
To: NeilBrown <neilb@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <greg@linuxfoundation.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 0/8] PM: Implement autosleep and "wake locks"
Message-ID: <20120212015431.GC18742@gs62>
Reply-To: markgross@thegnar.org
References: <201202070200.55505.rjw@sisk.pl>
 <20120209105736.027b1e0a@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120209105736.027b1e0a@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 10:57:36AM +1100, NeilBrown wrote:
> On Tue, 7 Feb 2012 02:00:55 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> 
> > All in all, it's not as much code as I thought it would be and it seems to be
> > relatively simple (which rises the question why the Android people didn't
> > even _try_ to do something like this instead of slapping the "real" wakelocks
> > onto the kernel FWIW).  IMHO it doesn't add anything really new to the kernel,
> > except for the user space interfaces that should be maintainable.  At least I
> > think I should be able to maintain them. :-)
> > 
> > All of the above has been tested very briefly on my test-bed Mackerel board
> > and it quite obviously requires more thorough testing, but first I need to know
> > if it makes sense to spend any more time on it.
> > 
> > IOW, I need to know your opinions!
> 
> I've got opinions!!!
> 
> I'll try to avoid the obvious bike-shedding about interface design...
> 
> The key point I want to make is that doing this in the kernel has one very
> import difference to doing it in userspace (which, as you know, I prefer)
> which may not be obvious to everyone at first sight.  So I will try to make it
> apparent.
> 
> In the user-space solution that we have previously discussed, it is only
> necessary for the kernel to hold a wakeup_source active until the event is
> *visible* to user-space.  So a low level driver can queue e.g. an input event
> and then deactivate their wakeup_source.  The event can remain in the input
> queue without any wakeup_source being active and there is no risk of going to
> sleep inappropriately.
> This is because - in the user-space approach - user-space must effectively
> poll every source of interesting wakeup events between the last wakeup_source
> being deactivate and the next attempt to suspend.  This poll will notice the
> event sitting in a queue so that a well-written user-space will not go to
> sleep but will read the event.
<sarcasm>
its on running on 100's of millions of devices today... It must be well
written.  Right?
</sarcasm>

> single 'poll' or 'select' or even 'read' on a pollfd).
> 
> In the kernel based approach that you have presented this is not the case.
> As the kernel will initiate suspend the moment the last wakeup_source is
> released (with no polling of other queues), there must be an unbroken chain of
> wakeup_sources from the initial interrupt all the way up to the user.
> In particular, any subsystem (such as 'input') must hold a wakeup_source
> active as long as any designated 'wakeup event' is in any of its queues.
> This means that the subsystem must be able to differentiate wakeup events
> from non-wakeup events.
> This might be easy (maybe "all events are wakeup events" or "all events on
> this queue are wakeup events") but it is not obvious to me that that is the
> case.
>
And this brings us to a wake acknowledgement of wake events from user
mode before re-suspending type of design.


> To summarise: for this solution to be effective it also requires that
>  1/ every subsystem that carries wakeup events must know about wakeup_sources
>     and must activate/deactivate them as events are queued/dequeued.
>  2/ these subsystems must be able to differentiate between wakeup events and
>     non-wakeup events, and this must be a configurable decision.
> 
> Currently, understanding wakeup events is restricted to:
>  - drivers that are capable of configuring wakeup
>  - user-space which cares about wakeup
> The proposed solution adds:
>  - intermediate subsystems which might queue wakeup events
> 
> I think that is a significant addition to make and not one to be made
> lightly.  It might end up adding more code than you thought it would be :-)
you mean wake lock-itis sprinkling time out wake locks all over the
place?

--mark

> Thanks for the opportunity to comment,
> NeilBrown



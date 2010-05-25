Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400Ab0EYWzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 18:55:54 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:54990 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab0EYWzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 18:55:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=O6ZXEgqSrQ7gBo4js/v3O5P5h374zBnLqY03NW4PqB//tv1j8abx5ogxnwkK0NjbYF
         dz1ysejX79PKpmuIXs6yrAd5UMtWle3x/zS7/VnC3o/Tb7fVPXQgiX4JWKUcsa5HZIqS
         hJpl+it0IuU3LIOQG/rg2k6ZBhi3011tV6LRA=
Date: Tue, 25 May 2010 15:55:44 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>, Ming Lei <tom.leiming@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
Message-ID: <20100525225544.GA5331@core.coreip.homeip.net>
References: <201005251124.58017.dmitry.torokhov@gmail.com>
 <Pine.LNX.4.44L0.1005251428090.1634-100000@iolanthe.rowland.org>
 <20100525184740.GA4248@core.coreip.homeip.net>
 <AANLkTik7eKNIqMFGVl6OzpqBnhvjet9puUQDCRkrabkg@mail.gmail.com>
 <20100525223220.GC4928@core.coreip.homeip.net>
 <AANLkTinnSH_egFYowkOQiYHL87QfIH332i1__OaTem-s@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinnSH_egFYowkOQiYHL87QfIH332i1__OaTem-s@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 03:37:48PM -0700, Arve Hjønnevåg wrote:
> 2010/5/25 Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> > On Tue, May 25, 2010 at 03:23:23PM -0700, Arve Hjønnevåg wrote:
> >> On Tue, May 25, 2010 at 11:47 AM, Dmitry Torokhov
> >> <dmitry.torokhov@gmail.com> wrote:
> >> > On Tue, May 25, 2010 at 02:35:17PM -0400, Alan Stern wrote:
> >> >> On Tue, 25 May 2010, Dmitry Torokhov wrote:
> >> >>
> >> >> > > Here's the scenario:
> >> >> > >
> >> >> > > The system is awake, and the user presses a key. The keyboard driver
> >> >> > > processes the keystroke and puts it in an input queue.  A user process
> >> >> > > reads it from the event queue, thereby emptying the queue.
> >> >> > >
> >> >> > > At that moment, the system decides to go into opportunistic suspend.
> >> >> > > Since the input queue is empty, there's nothing to stop it.  As the
> >> >> > > first step, userspace is frozen -- before the process has a chance to
> >> >> > > do anything with the keystroke it just read.  As a result, the system
> >> >> > > stays asleep until something else wakes it up, even though the
> >> >> > > keystroke was important and should have prevented it from sleeping.
> >> >> > >
> >> >> > > Suspend blockers protect against this scenario.  Here's how:
> >> >> > >
> >> >> > > The user process doesn't read the input queue directly; instead it
> >> >> > > does a select or poll.  When it sees there is data in the queue, it
> >> >> > > first acquires a suspend blocker and then reads the data.
> >> >> > >
> >> >> > > Now the system _can't_ go into opportunistic suspend, because a suspend
> >> >> > > blocker is active.  The user process can do whatever it wants with the
> >> >> > > keystroke.  When it is finished, it releases the suspend blocker and
> >> >> > > loops back to the select/poll call.
> >> >> > >
> >> >> >
> >> >> > What you describe can be done in userspace though, via a "suspend manager"
> >> >> > process. Tasks reading input events will post "busy" events to stop the
> >> >> > manager process from sending system into suspend. But this can be confined to
> >> >> > Android userspace, leaving the kernel as is (well, kernel needs to be modified
> >> >> > to not go into suspend with full queues, but that is using existing kernel
> >> >> > APIs).
> >> >>
> >> >> I think that could be made to work.  And it might remove the need for
> >> >> the userspace suspend-blocker API, which would be an advantage.  It
> >> >> could even remove the need for the opportunistic-suspend workqueue --
> >> >> opportunistic suspends would be initiated by the "suspend manager"
> >> >> process instead of by the kernel.
> >> >>
> >> >> However you still have the issue of modifying the kernel drivers to
> >> >> disallow opportunistic suspend if their queues are non-empty.  Doing
> >> >> that is more or less equivalent to implementing kernel-level suspend
> >> >> blockers.  (The suspend blocker approach is slightly more efficient,
> >> >> because it will prevent a suspend from starting if a queue is
> >> >> non-empty, instead of allowing the suspend to start and then aborting
> >> >> it partway through.)
> >> >>
> >> >> Maybe I'm missing something here...  No doubt someone will point it out
> >> >> if I am.
> >> >>
> >> >
> >> > Well, from my perspective that would limit changes to the evdev driver
> >> > (well, limited input core plumbing will be needed) but that is using the
> >> > current PM infrastructure. The HW driver changes will be limited to what
> >> > you described "type 2" in your other e-mail.
> >> >
> >> > Also, not suspending while events are in progress) is probably
> >> > beneficial for platforms other than Android as well. So unless I am
> >> > missing something this sounds like a win.
> >> >
> >>
> >> How would this limit the changes you need in the evdev driver? It need
> >> to block suspend when there are unprocessed events in some queues.
> >> Suspend blockers gives you an api to do this, without it, you check
> >> the queues in your suspend hook and abort suspend if they are not
> >> empty. Without suspend blockers you have no api to signal that it is
> >> OK to suspend again, so you are forcing the thread that tried to
> >> suspend to poll until you stop aborting suspend.
> >
> > No, you do not need to poll. You just set a timeout (short or long,
> > depending on your needs) and if no userspace task blocked suspend
> > durng that time you attempt to initiate suspend from your manager
> > process. If it succeeds - good, if not that means that more events came
> > your way and you have to do it later.
> >
> 
> How is that not polling? If the user is holding down a key, the keypad
> driver has to block suspend, and user space will try to suspend again
> and again and again...
> 

If your userpsace is that stupid - sure. However, you can:

1. Notify the suspend manager process that he rest of your userspace is
busy handling keystrokes so that it does not try to suspend while there
are events pending.

2. Wait a tiny bit after last application notified you that it finished
processing events.

So basically the difference is that with in-kernel suspend blockers,
there is a tiny window where we haven't started the suspend yet but are
about to the driver has a chance to prevent entire system from starting
sleep.

Without the blocker we may start suspending and will stop midcycle. We
may be even better off in the end since we could leave some devices
still powered down after aborting system-wide suspend.

-- 
Dmitry

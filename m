Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934964Ab0HFQAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 12:00:47 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48098 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932878Ab0HFQAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 12:00:44 -0400
Date: Fri, 6 Aug 2010 09:00:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
        david@lang.hm, Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100806160038.GF2432@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100801054816.GI2470@linux.vnet.ibm.com>
 <201008051734.06736.rjw@sisk.pl>
 <AANLkTi=kDx440MrLnQEcT46b3gkahU5ZGc0oWrWF-D2g@mail.gmail.com>
 <201008060141.46109.rjw@sisk.pl>
 <AANLkTinQD3ggLFVd2KvX95U2B_j=ZJquZgiBGieukJ+r@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinQD3ggLFVd2KvX95U2B_j=ZJquZgiBGieukJ+r@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 06:29:27PM -0700, Arve Hjønnevåg wrote:
> 2010/8/5 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Friday, August 06, 2010, Arve Hjønnevåg wrote:
> >> 2010/8/5 Rafael J. Wysocki <rjw@sisk.pl>:
> >> > On Thursday, August 05, 2010, Arve Hjønnevåg wrote:
> >> >> 2010/8/4 Rafael J. Wysocki <rjw@sisk.pl>:
> >> >> > On Thursday, August 05, 2010, Arve Hjønnevåg wrote:
> >> >> >> On Wed, Aug 4, 2010 at 1:56 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> >> >> >> > On Wed, Aug 04, 2010 at 10:51:07PM +0200, Rafael J. Wysocki wrote:
> >> >> >> >> On Wednesday, August 04, 2010, Matthew Garrett wrote:
> >> >> >> >> > No! And that's precisely the issue. Android's existing behaviour could
> >> >> >> >> > be entirely implemented in the form of binary that manually triggers
> >> >> >> >> > suspend when (a) the screen is off and (b) no userspace applications
> >> >> >> >> > have indicated that the system shouldn't sleep, except for the wakeup
> >> >> >> >> > event race. Imagine the following:
> >> >> >> >> >
> >> >> >> >> > 1) The policy timeout is about to expire. No applications are holding
> >> >> >> >> > wakelocks. The system will suspend providing nothing takes a wakelock.
> >> >> >> >> > 2) A network packet arrives indicating an incoming SIP call
> >> >> >> >> > 3) The VOIP application takes a wakelock and prevents the phone from
> >> >> >> >> > suspending while the call is in progress
> >> >> >> >> >
> >> >> >> >> > What stops the system going to sleep between (2) and (3)? cgroups don't,
> >> >> >> >> > because the voip app is an otherwise untrusted application that you've
> >> >> >> >> > just told the scheduler to ignore.
> >> >> >> >>
> >> >> >> >> I _think_ you can use the just-merged /sys/power/wakeup_count mechanism to
> >> >> >> >> avoid the race (if pm_wakeup_event() is called at 2)).
> >> >> >> >
> >> >> >> > Yes, I think that solves the problem. The only question then is whether
> >> >> >>
> >> >> >> How? By passing a timeout to pm_wakeup_event when the network driver
> >> >> >> gets the packet or by passing 0. If you pass a timeout it is the same
> >> >> >> as using a wakelock with a timeout and should work (assuming the
> >> >> >> timeout you picked is long enough). If you don't pass a timeout it
> >> >> >> does not work, since the packet may not be visible to user-space yet.
> >> >> >
> >> >> > Alternatively, pm_stay_awake() / pm_relax() can be used.
> >> >> >
> >> >>
> >> >> Which makes the driver and/or network stack changes identical to using
> >> >> wakelocks, right?
> >> >
> >> > Please refer to the Matthew's response.
> >> >
> >> >> >> > it's preferable to use cgroups or suspend fully, which is pretty much up
> >> >> >> > to the implementation. In other words, is there a reason we're still
> >> >> >>
> >> >> >> I have seen no proposed way to use cgroups that will work. If you
> >> >> >> leave some processes running while other processes are frozen you run
> >> >> >> into problems when a frozen process holds a resource that a running
> >> >> >> process needs.
> >> >> >>
> >> >> >>
> >> >> >> > having this conversation? :) It'd be good to have some feedback from
> >> >> >> > Google as to whether this satisfies their functional requirements.
> >> >> >> >
> >> >> >>
> >> >> >> That is "this"? The merged code? If so, no it does not satisfy our
> >> >> >> requirements. The in kernel api, while offering similar functionality
> >> >> >> to the wakelock interface, does not use any handles which makes it
> >> >> >> impossible to get reasonable stats (You don't know which pm_stay_awake
> >> >> >> request pm_relax is reverting).
> >> >> >
> >> >> > Why is that a problem (out of curiosity)?
> >> >> >
> >> >>
> >> >> Not having stats or not knowing what pm_relax is undoing? We need
> >> >> stats to be able to debug the system.
> >> >
> >> > You have the stats in struct device and they are available via sysfs.
> >> > I suppose they are insufficient, but I'd like to know why exactly.
> >> >
> >>
> >> Our wakelock stats currently have
> >> (name,)count,expire_count,wake_count,active_since,total_time,sleep_time,max_time
> >> and last_change. Not all of these are equally important (total_time is
> >> most important followed by active_since), but you only have count.
> >> Also as discussed before, many wakelocks/suspendblockers are not
> >> associated with a struct device.
> >
> > OK
> >
> > How much of that is used in practice and what for exactly?
> 
> count, tells you how many times the wakelock was activated. If a
> wakelock prevented suspend for a long time a large count tells you it
> handled a lot of events while a small count tells you it took a long
> time to process the events, or the wakelock was not released properly.

Got it!

> expire_count, tells you how many times the timeout expired. For the
> input event wakelock in the android kernel (which has a timeout) an
> expire count that matches the count tells you that someone opened an
> input device but is not reading from it (this has happened several
> times).

Ah, I hadn't considered that an power-oblivious application could take
this approach to waste power.  I now better understand the purpose of
the timeouts, and have added the corresponding requirement.  ;-)

> wake_count, tells you that this is the first wakelock that was
> acquired in the resume path. This is currently less useful than I
> would like on the Nexus One since it is usually "SMD_RPCCALL" which
> does not tell me a lot.

Got it!

> active_since, tells you how long a a still active wakelock has been
> active. If someone activated a wakelock and never released it, it will
> be obvious here.

This one is zero if the wakelock is not currently held, correct?

> total_time, total time the wake lock has been active. This one should
> be obvious.

Got it!

> sleep_time, total time the wake lock has been active when the screen was off.

Hmmm...  The statistics for apps are collected in userspace, correct?
If so, this would be collecting the total time that suspend blockers
that were acquired by some driver have been held while the screen was
powered off.  So if things were working properly, sleep_time should be
quite small -- with the exception of the suspend blocker that the
userspace daemon was using as a proxy for all of the userspace suspend
blockers.

Or am I confused about this?

> max_time, longest time the wakelock was active uninterrupted. This
> used less often, but the battery on a device was draining fast, but
> the problem went away before looking at the stats this will show if a
> wakelock was active for a long time.

Got it!

Thank you for this additional info, it really shines some light on
what you are trying to do.

One question: are these statistics enabled in production devices, are
is this a debug-only facility?

> > Do you _really_ have to debug the wakelocks in drivers that much?
> >
> 
> Wake locks in drivers sometimes need to be debugged. If the api has no
> accountability, then these problems would take forever to fix.

So there is a separate set of suspend-blocker statistics collected in
userspace, correct?  (The kernel probably doesn't need to care about this,
and I don't believe that I need anything more than a "yes" or "no" answer,
but just want to make sure I understand how these statistics are used.)

> >> >> If the system does not suspend
> >> >> at all or is awake for too long, the wakelock stats tells us which
> >> >> component is at fault. Since pm_stay_awake and pm_relax does not
> >> >> operate on a handle, you cannot determine how long it prevented
> >> >> suspend for.
> >> >
> >> > Well, if you need that, you can add a counter of "completed events" into
> >>
> >> We need more than that (see above).
> >>
> >> > struct dev_pm_info and a function similar to pm_relax() that
> >> > will update that counter.  I don't think anyone will object to that change.
> >> >
> >>
> >> What about adding a handle that is passed to all three functions?

The reason you want the handle is to allow the calling code to indicate
which calling points are dealing with the same suspend-blocker entity?

							Thaxn, Paul

> > I don't think that will fly at this point.
> >
> 
> Why not? I think allowing drivers to modify a global reference count
> with no accountability is a terrible idea.
> 
> >> >> >> The proposed in user-space interface
> >> >> >> of calling into every process that receives wakeup events before every
> >> >> >> suspend call
> >> >> >
> >> >> > Well,  you don't really need to do that.
> >> >> >
> >> >>
> >> >> Only if the driver blocks suspend until user-space has read the event.
> >> >> This means that for android to work we need to block suspend when
> >> >> input events are not processed, but a system using your scheme needs a
> >> >> pm_wakeup_event call when the input event is queued. How to you switch
> >> >> between them? Do we add separate ioctls in the input device to enable
> >> >> each scheme? If someone has a single threaded user space power manager
> >> >> that also reads input event it will deadlock if you block suspend
> >> >> until it reads the input events since you block when reading the wake
> >> >> count.
> >> >
> >> > Well, until someone actually tries to implement a power manager in user space
> >> > it's a bit vague.
> >> >
> >>
> >> Not having clear rules for what the drivers should do is a problem.
> >> The comments in your code seem to advocate using timeouts instead of
> >> overlapping pm_stay_awake/pm_relax sections. I find this
> >> recommendation strange given all the opposition to
> >> wakelock/suspendblocker timeouts.
> >
> > There's no recommendation either way.
> 
> I'm referring to this paragraph:
> 
>   * Second, a wakeup event may be detected by one functional unit and processed
>   * by another one.  In that case the unit that has detected it cannot really
>   * "close" the "no suspend" period associated with it, unless it knows in
>   * advance what's going to happen to the event during processing.  This
>   * knowledge, however, may not be available to it, so it can simply
> specify time
>   * to wait before the system can be suspended and pass it as the second
>   * argument of pm_wakeup_event().
> 
> >
> >> But more importantly, calling
> >> pm_wakeup_event with a timeout of 0 is incompatible with the android
> >> user space code,
> >
> > Which I don't find really relevant, sorry.
> >
> >> and I would prefer that the kernel interfaces would
> >> encourage drivers to block suspend until user space has consumed the
> >> event, which works for the android user space, instead of just long
> >> enough to work with a hypothetical user space power manager.
> >
> > Well, that are your personal preferences, which I respect.  I also have some
> > personal preferences that are not necessarily followed by the kernel code.
> >
> > Thanks,
> > Rafael
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> 
> 
> -- 
> Arve Hjønnevåg

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab0HDAK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 20:10:28 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48558 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757992Ab0HDAKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 20:10:20 -0400
Date: Tue, 3 Aug 2010 17:10:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: david@lang.hm
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Arjan van de Ven <arjan@infradead.org>, "Ted Ts'o" <tytso@mit.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        mjg59@srcf.ucam.org, pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100804001015.GJ2407@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100801210548.23f77ff6@infradead.org>
 <alpine.DEB.2.00.1008012153300.25170@asgard.lang.hm>
 <20100802140933.GB2405@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008021627290.29820@asgard.lang.hm>
 <AANLkTi=1kBuyPS_P+eNLcnRu1mJH6BzpzQW_sENZuL1L@mail.gmail.com>
 <alpine.DEB.2.00.1008022121430.6545@asgard.lang.hm>
 <AANLkTikhcYzNp8CPp8cqrV7Ey5CLMWu1sJTNxUtEi2as@mail.gmail.com>
 <alpine.DEB.2.00.1008022203470.6545@asgard.lang.hm>
 <AANLkTinFT5jq4nUhUpzS5S4TVDQGj0S7RtRgxNhsz2UF@mail.gmail.com>
 <alpine.DEB.2.00.1008031611100.6545@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.00.1008031611100.6545@asgard.lang.hm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 04:19:25PM -0700, david@lang.hm wrote:
> On Tue, 3 Aug 2010, Arve Hj?nnev?g wrote:
> 
> >2010/8/2  <david@lang.hm>:
> >>On Mon, 2 Aug 2010, Arve Hj?nnev?g wrote:
> >>
> >>>2010/8/2  <david@lang.hm>:
> >>>>
> >>>>On Mon, 2 Aug 2010, Arve Hj?nnev?g wrote:
> >>>>
> >>>>>On Mon, Aug 2, 2010 at 5:08 PM,  <david@lang.hm> wrote:
> >>>>>>
> >>>>>>On Mon, 2 Aug 2010, Paul E. McKenney wrote:
> >>>>>>
> >>>>>>
> >>>>>>you are close, but I think what I'm proposing is actually simpler
> >>>>>>(assuming
> >>>>>>that the scheduler can be configured to generate the appropriate stats)
> >>>>>>
> >>>>>>my thought was not to move applications between cgroups as they
> >>>>>>aquire/release the suspend-block lock, bur rather to say that any
> >>>>>>application that you would trust to get the suspend-block lock should
> >>>>>>be
> >>>>>>in
> >>>>>>cgroup A while all other applications are in cgroup B
> >>>>>>
> >>>>>>when you are deciding if the system shoudl go to sleep because it is
> >>>>>>idle,
> >>>>>>ignore the activity of all applications in cgroup B
> >>>>>>
> >>>>>>if cgroup A applications are busy, the system is not idle and should
> >>>>>>not
> >>>>>>suspend.
> >>>>>>
> >>>>>
> >>>>>Triggering suspend from idle has been suggested before. However, idle
> >>>>>is not a signal that it is safe to suspend since timers stop in
> >>>>>suspend (or the code could temporarily be waiting on a non-wakeup
> >>>>>interrupt). If you add suspend blockers or wakelocks to prevent
> >>>>>suspend while events you care about are pending, then it does not make
> >>>>>a lot of sense to prevent suspend just because the cpu is not idle.
> >>>>
> >>>>isn't this a matter of making the suspend decision look at what timers
> >>>>have
> >>>>been set to expire in the near future and/or tweaking how long the system
> >>>>needs to be idle before going to sleep?
> >>>>
> >>>
> >>>You are describing low power idle modes, not suspend. Most timers stop
> >>>in suspend, so a timer set 10 seconds from now when entering suspend
> >>>will go off 10 seconds after resume so it should have no impact on how
> >>>long you decide to stay in suspend.
> >>
> >>so what is the fundamental difference between deciding to go into low-power
> >>idle modes to wake up back up on a given point in the future and deciding
> >>that you are going to be idle for so long that you may as well suspend until
> >>there is user input?
> >>
> >
> >Low power idle modes are supposed to be transparent. Suspend stops the
> >monotonic clock, ignores ready threads and switches over to a separate
> >set of wakeup events/interrupts. We don't suspend until there is user
> >input, we suspend until there is a wakeup event (user-input, incoming
> >network data/phone-calls, alarms etc..).
> 
> s/user input/wakeup event/ and my question still stands.
> 
> low power modes are not transparent to the user in all cases (if the
> screen backlight dimms/shuts off a user reading something will
> notice, if the system switches to a lower clock speed it can impact
> user response time, etc) The system is making it's best guess as to
> how to best srve the user by sacraficing some capibilities to save
> power now so that the power can be available later.
> 
> as I see it, suspending until a wakeup event (button press, incoming
> call, alarm, etc) is just another datapoint along the same path.
> 
> If the system could not wake itself up to respond to user input,
> phone call, alarm, etc and needed the power button pressed to wake
> up (or shut down to the point where the battery could be removed and
> reinstalled a long time later), I would see things moving into a
> different category, but as long as the system has the ability to
> wake itself up later (and is still consuming power) I see the
> suspend as being in the same category as the other low-power modes
> (it's just more expensive to go in and out of)
> 
> 
> why should the suspend be put into a different category from the
> other low-power states?

OK, I'll bite...

>From an Android perspective, the differences are as follows:

1.	Deep idle states are entered only if there are no runnable tasks.
	In contrast, opportunistic suspend can happen even when there
	are tasks that are ready, willing, and able to run.

2.	There can be a set of input events that do not bring the system
	out of suspend, but which would bring the system out of a deep
	idle state.  For example, I believe that it was stated that one
	of the Android-based smartphones ignores touchscreen input while
	suspended, but pays attention to it while in deep idle states.

3.	The system comes out of a deep idle state when a timer
	expires.  In contrast, timers cannot expire while the
	system is suspended.  (This one is debatable: some people
	argue that timers are subject to jitter, and the suspend
	case for timers is the same as that for deep idle states,
	but with unbounded timer jitter.  Others disagree.  The
	resulting discussions have produced much heat, but little
	light.  Such is life.)

There may well be others.

Whether these distinctions are a good thing or a bad thing is one of
the topics of this discussion.  But the distinctions themselves are
certainly very real, from what I can see.

Or am I missing your point?

							Thanx, Paul

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab0HDScb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:32:31 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41107 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029Ab0HDSca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 14:32:30 -0400
Date: Wed, 4 Aug 2010 11:32:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: david@lang.hm, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        "Ted Ts'o" <tytso@mit.edu>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100804183225.GC24163@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100802140933.GB2405@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008021627290.29820@asgard.lang.hm>
 <AANLkTi=1kBuyPS_P+eNLcnRu1mJH6BzpzQW_sENZuL1L@mail.gmail.com>
 <alpine.DEB.2.00.1008022121430.6545@asgard.lang.hm>
 <AANLkTikhcYzNp8CPp8cqrV7Ey5CLMWu1sJTNxUtEi2as@mail.gmail.com>
 <alpine.DEB.2.00.1008022203470.6545@asgard.lang.hm>
 <AANLkTinFT5jq4nUhUpzS5S4TVDQGj0S7RtRgxNhsz2UF@mail.gmail.com>
 <alpine.DEB.2.00.1008031611100.6545@asgard.lang.hm>
 <20100804001015.GJ2407@linux.vnet.ibm.com>
 <20100803205758.21fcf372@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100803205758.21fcf372@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 08:57:58PM -0700, Arjan van de Ven wrote:
> On Tue, 3 Aug 2010 17:10:15 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > OK, I'll bite...
> > 
> > >From an Android perspective, the differences are as follows:
> > 
> > 1.	Deep idle states are entered only if there are no runnable
> > tasks. In contrast, opportunistic suspend can happen even when there
> > 	are tasks that are ready, willing, and able to run.
> 
> for "system suspend", this is an absolutely valid statement.
> for "use suspend as idle state", it's not so clearly valid.
> (but this is sort of a separate problem, basically the "when do we
> freeze the tasks that we don't like for power reasons" problem,
> which in first order is independent on what kind of idle power state
> you pick, and discussed extensively elsewhere in this thread)

>From what I can see, the Android folks are are using "suspend" in
the "system suspend" sense.

I agree that the proposals for freezing subsets of the tasks in the
system are independent of whether idle or suspend is being used.
Instead, such freezing depends on (for example) whether or not the
display is active.

That said, freezing subsets of tasks is a nice-to-have rather than a
hard requirement for Android.  Though I suspect that the appearance
of a reliable way of freezing subsets of tasks just might promote
this to a hard requirement.  ;-)

> > 2.	There can be a set of input events that do not bring the
> > system out of suspend, but which would bring the system out of a deep
> > 	idle state.  For example, I believe that it was stated that
> > one of the Android-based smartphones ignores touchscreen input while
> > 	suspended, but pays attention to it while in deep idle states.
> 
> I would argue that this is both a hardware specific issue, but also a
> policy issue. From the user point of view, screen off with idle and
> screen off with suspend aren't all that different (if my phone would
> decide to idle rather than suspend because some app blocks suspend... I
> wouldn't expect a difference in behavior when I touch the screen).
> "Screen off -> don't honor touch after a bit" is almost an independent,
> but very real, policy problem (and a forced one in suspend, I'll grant
> you that). I could even argue that the policy decision "we don't care
> about the touch screen input" is a pre-condition for entering suspend
> (or in android speak, caring for touch screen input/having the touch
> screen path active would be a suspend blocker)

I agree that the subset of input events that do not bring the system out
of suspend would be governed both by hardware capabilities and by policy.

> > 3.	The system comes out of a deep idle state when a timer
> > 	expires.  In contrast, timers cannot expire while the
> > 	system is suspended.  (This one is debatable: some people
> > 	argue that timers are subject to jitter, and the suspend
> > 	case for timers is the same as that for deep idle states,
> > 	but with unbounded timer jitter.  Others disagree.  The
> > 	resulting discussions have produced much heat, but little
> > 	light.  Such is life.)
> 
> I'll debate it even harder in that it's platform specific whether
> timers can get the system out of suspend or not. Clearly on the Android
> platform in question that's not the case, but for some of the Intel
> phone silicon for example, timers CAN be wake sources to get you out of
> suspend just fine. It just depend on which exact hw you talk about.
> Generally, even if the fast timers aren't wake up sources, there'll be
> some sort of alarm thing that you can pre-wake.. but yes you are right
> in saying that's rather lame. 
> Either way, it's not a general property of suspend, but a property of
> suspend on the specific platform in question.

Good point, I do need to emphasize the fact that whether or not timers
pull the system out of suspend also depends both on hardware and
on policy.  So I will change my statement to say something like "The
system comes out of a deep idle state when a timer expires.  In contrast,
timers do not necessarily expire while the system is suspended, depending
on both hardware support and platform/application policy."

							Thanx, Paul

> 
> 
> -- 
> Arjan van de Ven 	Intel Open Source Technology Centre
> For development, discussion and tips for power savings, 
> visit http://www.lesswatts.org

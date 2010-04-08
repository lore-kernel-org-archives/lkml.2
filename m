Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933821Ab0DHXKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 19:10:48 -0400
Received: from nat.nue.novell.com ([195.135.221.3]:33485 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933728Ab0DHXKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 19:10:46 -0400
Subject: Re: [PATCH 4/6] futex: Add FUTEX_LOCK with optional adaptive
 spinning
From: "Peter W. Morreale" <pmorreale@novell.com>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>, Rik van Riel <riel@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <4BBD4C92.8010701@us.ibm.com>
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com>
	 <1270499039-23728-5-git-send-email-dvhltc@us.ibm.com>
	 <alpine.LFD.2.00.1004061818250.32352@localhost.localdomain>
	 <4BBCC02C.5090000@us.ibm.com>
	 <alpine.LFD.2.00.1004072124250.32352@localhost.localdomain>
	 <4BBD4C92.8010701@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Novell Inc.
Date: Thu, 08 Apr 2010 17:10:33 -0600
Message-ID: <1270768233.6318.45.camel@hermosa.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-07 at 20:25 -0700, Darren Hart wrote:
> Thomas Gleixner wrote:
> > On Wed, 7 Apr 2010, Darren Hart wrote:
> >> Thomas Gleixner wrote:
> >>> On Mon, 5 Apr 2010, Darren Hart wrote:
> >>> Hmm. The order is weird. Why don't you do that simpler ?
> >>>
> >>> Get the uval, the tid and the thread_info pointer outside of the
> >>> loop. Also task_pid_vnr(current) just needs a one time lookup.
> >> Eeek. Having the owner in the loop is a good way to negate the benefits
> >> of adaptive spinning by spinning forever (unlikely, but it could
> >> certainly spin across multiple owners). Nice catch.
> >>
> >> As for the uval.... I'm not sure what you mean. You get curval below
> >> inside the loop, and there is no "uval" in the my version of the code.
> > 
> > Well, you need a first time lookup of owner and ownertid for which you
> > need the user space value (uval),
> > but thinking more about it it's not
> > even necessary. Just initialize ownertid to 0 so it will drop into the
> > lookup code when we did not acquire the futex in the cmpxchg.
> 
> No need for ownertid at all really. The cmpxchg always tries to go from 
> 0 to curtid. I've pushed the futex_owner() call outside the loop for a 
> one time lookup.
> 
> > 
> >> As for the order, I had put the initial spin prior to the cmpxchg to
> >> avoid doing too many cmpxchg's in a row as they are rather expensive.
> >> However, since this is (now) the first opportunity to do try and acquire
> >> the lock atomically after entering the futex syscall, I think you're
> >> right, it should be the first thing in the loop.
> >>
> >>> change the loop to do:
> >>>
> >>>        for (;;) {
> >>>        	   curval = cmpxchg_futex_value_locked(uaddr, 0, curtid);
> >>>   	   if (!curval)
> >>> 	      return 1;
> >> Single return point makes instrumentation so much easier. Unless folks
> >> _really_ object, I'll leave it as is until we're closer to merging.
> > 
> > I don't care either way. That was just example code.
> > 
> >>> 	   if ((curval & FUTEX_TID_MASK) != ownertid) {
> >>> 	      ownertid = curval & FUTEX_TID_MASK;
> >>> 	      owner = update_owner(ownertid);
> >>> 	   }
> >>
> >> Hrm... at this point the owner has changed... so we should break and go
> >> to sleep, not update the owner and start spinning again. The
> >> futex_spin_on_owner() will detect this and abort, so I'm not seeing the
> >> purpose of the above if() block.
> > 
> > Why ? If the owner has changed and the new owner is running on another
> > cpu then why not spin further ?
> 
> That's an interesting question, and I'm not sure what the right answer 
> is. The current approach of the adaptive spinning in the kernel is to 
> spin until the owner changes or deschedules, then stop and block. The 
> idea is that if you didn't get the lock before the owner changed, you 
> aren't going to get it in a very short period of time (you have at least 
> an entire critical section to wait through plus whatever time you've 
> already spent spinning). However, blocking just so another task can spin 
> doesn't really make sense either, and makes the lock less fair than it 
> could otherwise be.

Not only less fair, but potentially could cause starvation, no?  Perhaps
you could see this if you changed your model to allow all contended
tasks to spin instead of just one.  

If a spinning task blocks because of an owner change, and a new task
enters and starts spinning directly after the owner change, at what
point does the original task get woken up?  Its likely that the new
spinner will get the resource next, no?  Rinse/repeat with another task
and the original spinner is starved.  

(Or am I missing something?  My understanding was that unfairness was
built-in to this algo... If so, then the above is a possibility, right?)

Best,
-PWM

> 
> My goal in starting this is to provide a more intelligent mechanism than 
> sched_yield() for userspace to use to determine when to spin and when to 
> sleep. The current implementation allows for spinning up until the owner 
> changes, deschedules, or the timeslice expires. I believe these are much 
> better than spinning for some fixed number of cycles and then yield for 
> some unpredictable amount of time until CFS decides to schedule you back in.
> 
> Still, the criteria for breaking the spin are something that needs more 
> eyes, and more numbers before I can be confident in any approach.
> 
> > 
> >>>> +		hrtimer_init_sleeper(to, current);
> >>>> +		hrtimer_set_expires(&to->timer, *time);
> >>>> +	}
> >>>   Why setup all this _before_ trying the adaptive spin ?
> >>
> >> I placed the retry: label above the adaptive spin loop. This way if we wake a
> >> task and the lock is "stolen" it doesn't just go right back to sleep. This
> >> should aid in fairness and also performance in less contended cases. I didn't
> >> think it was worth a "if (first_time_through && time)" sort of block to be
> >> able to setup the timer after the spin loop.
> > 
> > Hmm, ok.
> > 
> >>> Do we really need all this code ? A simple owner->on_cpu (owner needs
> >>> to be the task_struct then) would be sufficient to figure that out,
> >>> wouldn't it?
> >> As Peter pointed out in IRC, p->oncpu isn't generic. I'll go trolling through
> >> the mutex_spin_on_owner() discussions to see if I can determine why that's the
> >> case.
> > 
> > AFAICT p->oncpu is the correct thing to use when CONFIG_SMP=y. All it
> > needs is a simple accessor function and you can keep all the futex
> > cruft in futex.c where it belongs.
> 
> Noted.
> 
> Thanks,



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab0DGUBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 16:01:25 -0400
Received: from www.tglx.de ([62.245.132.106]:58762 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab0DGUBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 16:01:23 -0400
Date: Wed, 7 Apr 2010 21:59:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 4/6] futex: Add FUTEX_LOCK with optional adaptive
 spinning
In-Reply-To: <4BBCC02C.5090000@us.ibm.com>
Message-ID: <alpine.LFD.2.00.1004072124250.32352@localhost.localdomain>
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com> <1270499039-23728-5-git-send-email-dvhltc@us.ibm.com> <alpine.LFD.2.00.1004061818250.32352@localhost.localdomain> <4BBCC02C.5090000@us.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Apr 2010, Darren Hart wrote:
> Thomas Gleixner wrote:
> > On Mon, 5 Apr 2010, Darren Hart wrote:
> > Hmm. The order is weird. Why don't you do that simpler ?
> > 
> > Get the uval, the tid and the thread_info pointer outside of the
> > loop. Also task_pid_vnr(current) just needs a one time lookup.
> 
> Eeek. Having the owner in the loop is a good way to negate the benefits
> of adaptive spinning by spinning forever (unlikely, but it could
> certainly spin across multiple owners). Nice catch.
> 
> As for the uval.... I'm not sure what you mean. You get curval below
> inside the loop, and there is no "uval" in the my version of the code.

Well, you need a first time lookup of owner and ownertid for which you
need the user space value (uval), but thinking more about it it's not
even necessary. Just initialize ownertid to 0 so it will drop into the
lookup code when we did not acquire the futex in the cmpxchg.
 
> As for the order, I had put the initial spin prior to the cmpxchg to
> avoid doing too many cmpxchg's in a row as they are rather expensive.
> However, since this is (now) the first opportunity to do try and acquire
> the lock atomically after entering the futex syscall, I think you're
> right, it should be the first thing in the loop.
> 
> > 
> > change the loop to do:
> > 
> >        for (;;) {
> >        	   curval = cmpxchg_futex_value_locked(uaddr, 0, curtid);
> >   	   if (!curval)
> > 	      return 1;
> 
> Single return point makes instrumentation so much easier. Unless folks
> _really_ object, I'll leave it as is until we're closer to merging.

I don't care either way. That was just example code.
 
> > 	   if ((curval & FUTEX_TID_MASK) != ownertid) {
> > 	      ownertid = curval & FUTEX_TID_MASK;
> > 	      owner = update_owner(ownertid);
> > 	   }
> 
> 
> Hrm... at this point the owner has changed... so we should break and go
> to sleep, not update the owner and start spinning again. The
> futex_spin_on_owner() will detect this and abort, so I'm not seeing the
> purpose of the above if() block.

Why ? If the owner has changed and the new owner is running on another
cpu then why not spin further ?

> > > +		hrtimer_init_sleeper(to, current);
> > > +		hrtimer_set_expires(&to->timer, *time);
> > > +	}
> > 
> >   Why setup all this _before_ trying the adaptive spin ?
> 
> 
> I placed the retry: label above the adaptive spin loop. This way if we wake a
> task and the lock is "stolen" it doesn't just go right back to sleep. This
> should aid in fairness and also performance in less contended cases. I didn't
> think it was worth a "if (first_time_through && time)" sort of block to be
> able to setup the timer after the spin loop.

Hmm, ok.
 
> > 
> > Do we really need all this code ? A simple owner->on_cpu (owner needs
> > to be the task_struct then) would be sufficient to figure that out,
> > wouldn't it?
> 
> As Peter pointed out in IRC, p->oncpu isn't generic. I'll go trolling through
> the mutex_spin_on_owner() discussions to see if I can determine why that's the
> case.

AFAICT p->oncpu is the correct thing to use when CONFIG_SMP=y. All it
needs is a simple accessor function and you can keep all the futex
cruft in futex.c where it belongs.

Thanks,

	tglx

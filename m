Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab0GLUnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:43:46 -0400
Received: from www.tglx.de ([62.245.132.106]:40908 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426Ab0GLUnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:43:45 -0400
Date: Mon, 12 Jul 2010 22:43:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 4/4] futex: convert hash_bucket locks to raw_spinlock_t
In-Reply-To: <alpine.LFD.2.00.1007122226230.3321@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1007122241540.3321@localhost.localdomain>
References: <1278714780-788-1-git-send-email-dvhltc@us.ibm.com> <1278714780-788-5-git-send-email-dvhltc@us.ibm.com> <1278790882.7352.101.camel@marge.simson.net> <4C3B68B9.5060404@us.ibm.com> <alpine.LFD.2.00.1007122226230.3321@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Jul 2010, Thomas Gleixner wrote:

> On Mon, 12 Jul 2010, Darren Hart wrote:
> > On 07/10/2010 12:41 PM, Mike Galbraith wrote:
> > > On Fri, 2010-07-09 at 15:33 -0700, Darren Hart wrote:
> > > > > Out of curiosity, what's wrong with holding his pi_lock across the
> > > > > wakeup?  He can _try_ to block, but can't until pi state is stable.
> > > > > 
> > > > > I presume there's a big fat gotcha that's just not obvious to futex
> > > > > locking newbie :)
> > 
> > Nor to some of us that have been engrossed in futexes for the last couple
> > years! I discussed the pi_lock across the wakeup issue with Thomas. While this
> > fixes the problem for this particular failure case, it doesn't protect
> > against:
> > 
> > <tglx> assume the following:
> > <tglx> t1 is on the condvar
> > <tglx> t2 does the requeue dance and t1 is now blocked on the outer futex
> > <tglx> t3 takes hb->lock for a futex in the same bucket
> > <tglx> t2 wakes due to signal/timeout
> > <tglx> t2 blocks on hb->lock
> > 
> > You are likely to have not hit the above scenario because you only had one
> > condvar, so the hash_buckets were not heavily shared and you weren't likely to
> > hit:
> > 
> > <tglx> t3 takes hb->lock for a futex in the same bucket
> > 
> > 
> > I'm going to roll up a patchset with your (Mike) spin_trylock patch and run it
> > through some tests. I'd still prefer a way to detect early wakeup without
> > having to grab the hb->lock(), but I haven't found it yet.
> > 
> > +	while(!spin_trylock(&hb->lock))
> > +		cpu_relax();
> >  	ret = handle_early_requeue_pi_wakeup(hb, &q, &key2, to);
> >  	spin_unlock(&hb->lock);
> 
> And this is nasty as it will create unbound priority inversion :(
> 
> We discussed another solution on IRC in meantime:
> 
> in futex_wait_requeue_pi()
> 
>    futex_wait_queue_me(hb, &q, to);
> 
>    raw_spin_lock(current->pi_lock);
>    if (current->pi_blocked_on) {
>       /*
>        * We know that we can only be blocked on the outer futex
>        * so we can skip the early wakeup check
>        */
>        raw_spin_unlock(current->pi_lock);
>        ret = 0;
>    } else {
>       current->pi_blocked_on = PI_WAKEUP_INPROGRESS;
>       raw_spin_unlock(current->pi_lock);
> 
>       spin_lock(&hb->lock);
>       ret = handle_early_requeue_pi_wakeup();
>       ....
>       spin_lock(&hb->lock);
>    }
> 
> Now in the rtmutex magic we need in task_blocks_on_rt_mutex():
> 
>    raw_spin_lock(task->pi_lock);
> 
>    /*
>     * Add big fat comment why this is only relevant to futex
>     * requeue_pi
>     */
> 
>    if (task != current && task->pi_blocked_on == PI_WAKEUP_INPROGRESS) {
>       raw_spin_lock(task->pi_lock);
> 
>       /*
>        * Returning 0 here is fine. the requeue code is just going to
>        * move the futex_q to the other bucket, but that'll be fixed
>        * up in handle_early_requeue_pi_wakeup()
>        */
> 
>       return 0;

We might also return a sensible error code here and just remove the
waiter from all queues, which needs to be handled in
handle_early_requeue_pi_wakeup() after acquiring hb->lock then.

Thanks,

	tglx

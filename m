Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab0GMDJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 23:09:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:48198 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753827Ab0GMDJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 23:09:13 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18PEQFRLZ8PYZh6OpnJexqz3gEuvwp5a48pMjLLGV
	CO0toF1aJMu++4
Subject: Re: [PATCH 4/4] futex: convert hash_bucket locks to raw_spinlock_t
From: Mike Galbraith <efault@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Darren Hart <dvhltc@us.ibm.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-rt-users@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1007122226230.3321@localhost.localdomain>
References: <1278714780-788-1-git-send-email-dvhltc@us.ibm.com>
	 <1278714780-788-5-git-send-email-dvhltc@us.ibm.com>
	 <1278790882.7352.101.camel@marge.simson.net> <4C3B68B9.5060404@us.ibm.com>
	 <alpine.LFD.2.00.1007122226230.3321@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 13 Jul 2010 05:09:20 +0200
Message-Id: <1278990560.7516.50.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-12 at 22:40 +0200, Thomas Gleixner wrote:
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

Oh ma gawd, _it's a train_ :>
 
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
>    }
> 
> Thanks,
> 
> 	tglx
> 
>     
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab1I2RME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 13:12:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:62886 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012Ab1I2RMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 13:12:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,461,1312182000"; 
   d="scan'208";a="57022459"
Subject: Re: [PATCH v1] sched: fix nohz idle load balancer issues
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>
Date: Thu, 29 Sep 2011 10:13:08 -0700
In-Reply-To: <1317284157.22581.1.camel@twins>
References: <20110926115049.GA22604@linux.vnet.ibm.com>
	 <CABeCy1YXKR89_uQm_XAyNJHPHkL+6JKxa-C+8Z_9ox7b_k2scQ@mail.gmail.com>
	 <1317167376.11592.53.camel@sbsiddha-desk.sc.intel.com>
	 <20110928041501.GH4357@linux.vnet.ibm.com>
	 <1317257264.11592.76.camel@sbsiddha-desk.sc.intel.com>
	 <1317284157.22581.1.camel@twins>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1317316389.11592.93.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 01:15 -0700, Peter Zijlstra wrote:
> I'd be interested in hearing more about that deadlock, because when
> allocating your own csd and not waiting for the result
> __smp_call_function_single() should be deadlock free.

Prarit Bhargava last week raised this issue with me. This is the
deadlock condition:

1. cpu-A did a generic_exec_single() to cpu-B and it took a timer
interrupt before sending the actual IPI.

        raw_spin_lock_irqsave(&dst->lock, flags);
        ipi = list_empty(&dst->list);
        list_add_tail(&data->list, &dst->list);
        raw_spin_unlock_irqrestore(&dst->lock, flags);

        /*
         * The list addition should be visible before sending the IPI
         * handler locks the list to pull the entry off it because of
         * normal cache coherency rules implied by spinlocks.
         *
         * If IPIs can go out of order to the cache coherency protocol
         * in an architecture, sufficient synchronisation should be added
         * to arch code to make it appear to obey cache coherency WRT
         * locking and barrier primitives. Generic code isn't really
         * equipped to do the right thing...
         */
====> got an interrupt here.
        if (ipi)
                arch_send_call_function_single_ipi(cpu);

2. As part of the timer interrupt handler, cpu-A decided to kick cpu-B
for the idle load balancing (sets cpu-B's rq->nohz_balance_kick to 1)
and __smp_call_function_single() with nowait will queue the csd to the
cpu-B's queue. But the generic_exec_single() won't send an IPI to cpu-B
as the queue was not empty (from the code snippet shown above in
generic_exec_single()).

3. cpu-A is busy with lot of interrupts

4. Meanwhile cpu-B is entering and exiting idle and noticed that it has
it's rq->nohz_balance_kick set to '1'. So it will go ahead and do the
idle load balancer and clear its rq->nohz_balance_kick.

5. As this point, csd queued as part of the step-2 above is still locked
and waiting to be serviced on cpu-B.

6. cpu-A is still busy with interrupt load and now it got another timer
interrupt and as part of it decided to kick cpu-B for another idle load
balancing (as it finds cpu-B's rq->nohz_balance_kick cleared in step-4
above) and does __smp_call_function_single() with the same csd that is
still locked.

7. And we get a deadlock waiting for the csd_lock() in the
__smp_call_function_single().

Main issue here is that cpu-B can service the idle load balancer kick
request from cpu-A even with out receiving the IPI and this lead to
doing multiple __smp_call_function_single() on the same csd leading to
deadlock.

We can certainly fix this by making sure that cpu-B will service the
idle load balancer kick request only after receiving the IPI. But as we
have the resched-IPI already, I thought it is cleaner to use that
instead of using generic smp call function IPI to do this kick.

> > @@ -2733,6 +2733,11 @@ void scheduler_ipi(void)
> >         struct rq *rq = this_rq();
> >         struct task_struct *list = xchg(&rq->wake_list, NULL);
> >  
> > +       if (unlikely((rq->idle == current) && rq->nohz_balance_kick)) {
> > +               rq->idle_balance = 1;
> > +               raise_softirq_irqoff(SCHED_SOFTIRQ);
> > +       } 
> 
> This can end up being outside of irq_enter()/irq_exit(), which is
> probably not what you want. See the somewhat large comment right below
> here.

Yep. I had that in the mind already and hence mentioned to Vatsa that I
was not 100% sure if I am doing the right thing in the scheduler_ipi().
I will fix it and post the patch along with the complete changelog.

thanks,
suresh


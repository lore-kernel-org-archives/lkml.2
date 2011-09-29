Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab1I2IQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 04:16:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:33576 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab1I2IQn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 04:16:43 -0400
Subject: Re: [PATCH v1] sched: fix nohz idle load balancer issues
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 29 Sep 2011 10:15:57 +0200
In-Reply-To: <1317257264.11592.76.camel@sbsiddha-desk.sc.intel.com>
References: <20110926115049.GA22604@linux.vnet.ibm.com>
	 <CABeCy1YXKR89_uQm_XAyNJHPHkL+6JKxa-C+8Z_9ox7b_k2scQ@mail.gmail.com>
	 <1317167376.11592.53.camel@sbsiddha-desk.sc.intel.com>
	 <20110928041501.GH4357@linux.vnet.ibm.com>
	 <1317257264.11592.76.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317284157.22581.1.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 17:47 -0700, Suresh Siddha wrote:
> So ended up with using kick_process() and the scheduler_ipi() context to
> trigger the SCHED_SOFTIRQ instead of using smp call function vector
> sequence (which has a deadlock scenario in the context of heavy
> interrupts which I can explain in detail when I send the complete
> changelog). And also I am explicitly requesting for idle balance to
> address the stale idle_at_tick condition.

I'd be interested in hearing more about that deadlock, because when
allocating your own csd and not waiting for the result
__smp_call_function_single() should be deadlock free.

> @@ -2733,6 +2733,11 @@ void scheduler_ipi(void)
>         struct rq *rq = this_rq();
>         struct task_struct *list = xchg(&rq->wake_list, NULL);
>  
> +       if (unlikely((rq->idle == current) && rq->nohz_balance_kick)) {
> +               rq->idle_balance = 1;
> +               raise_softirq_irqoff(SCHED_SOFTIRQ);
> +       } 

This can end up being outside of irq_enter()/irq_exit(), which is
probably not what you want. See the somewhat large comment right below
here.

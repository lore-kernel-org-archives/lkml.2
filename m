Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab1I0Xsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 19:48:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:47172 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab1I0Xsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 19:48:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,452,1312182000"; 
   d="scan'208";a="56367122"
Subject: Re: [PATCH v1] sched: fix nohz idle load balancer issues
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Venki Pallipadi <venki@google.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 27 Sep 2011 16:49:36 -0700
In-Reply-To: <CABeCy1YXKR89_uQm_XAyNJHPHkL+6JKxa-C+8Z_9ox7b_k2scQ@mail.gmail.com>
References: <20110926115049.GA22604@linux.vnet.ibm.com>
	 <CABeCy1YXKR89_uQm_XAyNJHPHkL+6JKxa-C+8Z_9ox7b_k2scQ@mail.gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1317167376.11592.53.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-27 at 12:53 -0700, Venki Pallipadi wrote:
> On Mon, Sep 26, 2011 at 4:50 AM, Srivatsa Vaddagiri
> <vatsa@linux.vnet.ibm.com> wrote:
> >
> > Reviewing idle load balancer code and testing it with some
> > trace_printk(), I observed the following:
> >
> > 1. I had put a trace_printk() in nohz_idle_balance() as below:
> >
> >        nohz_idle_balance()
> >        {
> >
> >        if (idle != CPU_IDLE || !this_rq->nohz_balance_kick)
> >                return;
> >
> >        ..
> >
> >                trace_printk("Running rebalance for %d\n", balance_cpu);
> >
> >                rebalance_domains(balance_cpu, CPU_IDLE);
> >        }
> >
> >    I *never* got that printed during the test. Further investigation
> >    revealed that ilb_cpu was bailing out early because idle =
> >    CPU_NOT_IDLE i.e ilb_cpu was no longer idle_at_tick by the time it
> >    got around to handle the kick. As a result, no one was truly
> >    doing a load balance on behalf of sleeping idle cpus.

One of the reasons why we saw lib_cpu not idle is probably because that
info was stale.

Consider this scenario.

a. got a tick when the cpu was busy, so idle_at_tick was not set
b. cpu went idle
c. same cpu got the kick IPI from other busy cpu
d. and as it has idle_at_tick not set, it couldn't proceed with the nohz
idle balance.

> > This patch is an attempt to solve above issues observed with idle load
> > balancer.
> >
> > - The patch causes a ilb_cpu (that was kicked) to kick another idle
> >  cpu in case it was found to be !idle_at_tick (so that another idle cpu
> >  can do load balance on behalf of idle cpus). This fixes issue #1
> 
> Some comments:
> 
> Another potential change here is to
> - either reverse the order of rebalance_domains() and
> nohz_idle_balance() in run_rebalance_domains()
> - or to kick another idle CPU in case of need_resched() in nohz_idle_balance.
> This should help with idle balance of tickless CPUs when ilb CPU gets
> a new task through load balance and hence aborts ilb.

I think we are mostly likely seeing the above mentioned scenario.

Also Vatsa, there is a deadlock associated by using
__smp_call_funciton_single() in the nohz_balancer_kick(). So I am
planning to remove the IPI that is used to kick the nohz balancer and
instead use the resched_cpu logic to kick the nohz balancer.

I will post this patch mostly tomorrow. That patch will not use the
idle_at_tick check in the nohz_idle_balance(). So that should address
your issue in some cases if not most.

thanks,
suresh


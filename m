Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab1FNNIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 09:08:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:45547 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab1FNNIT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 09:08:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,364,1304319600"; 
   d="scan'208";a="16043423"
From: "Shi, Alex" <alex.shi@intel.com>
To: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
CC: "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Date: Tue, 14 Jun 2011 21:07:24 +0800
Subject: RE: rcu: performance regression
Thread-Topic: rcu: performance regression
Thread-Index: Acwqk0y6QgJXT+BcR0ev2amb5+ZwAgAADmRA
Message-ID: <6E3BC7F7C9A4BF4286DD4C043110F30B5683F69ABC@shsmsx502.ccr.corp.intel.com>
References: <1308029185.15392.147.camel@sli10-conroe>
 <1308040388.21027.1847.camel@debian>
 <20110614130203.GF2264@linux.vnet.ibm.com>
In-Reply-To: <20110614130203.GF2264@linux.vnet.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Paul E. McKenney [mailto:paulmck@linux.vnet.ibm.com]
> Sent: Tuesday, June 14, 2011 9:02 PM
> To: Shi, Alex
> Cc: Li, Shaohua; Ingo Molnar; lkml; Chen, Tim C; peterz@infradead.org;
> rostedt@goodmis.org
> Subject: Re: rcu: performance regression
> 
> On Tue, Jun 14, 2011 at 04:33:08PM +0800, Alex,Shi wrote:
> > On Tue, 2011-06-14 at 13:26 +0800, Li, Shaohua wrote:
> > > Commit a26ac2455ffcf3(rcu: move TREE_RCU from softirq to kthread)
> > > introduced performance regression. In our AIM7 test, this commit caused
> > > about 40% regression.
> > > The commit runs rcu callbacks in a kthread instead of softirq. We
> > > observed high rate of context switch which is caused by this. Out test
> > > system has 64 CPUs and HZ is 1000, so we saw more than 64k context
> > > switch per second which is caused by the rcu thread.
> > > I also did trace and found when rcy thread is woken up, most time the
> > > thread doesn't handle any callbacks actually, it just initializes new gp
> > > or end one gp or similar.
> > > From my understanding, the purpose to make rcu runs in kthread is to
> > > speed up rcu callbacks run (with help of rtmutex PI), not for end gp and
> > > so on, which runs pretty fast actually and doesn't need boost.
> > > To verify my findings, I had below debug patch applied. It still handles
> > > rcu callbacks in kthread if there is any pending callbacks, but other
> > > things are still running in softirq. this completely solved our
> > > regression. I thought this can still boost callbacks run. but I'm not
> > > expert in the area, so please help.
> >
> > This commit also cause hackbench process mode performance dropping, and
> > Shaohua's patch do recovered this. But in hackbench testing, the vmstat
> > show context switch have some reduce. And perf tool show
> > root_domain->cpupri->prio_to_cpu[]->lock has contention with the commit.
> 
> Steven, Peter, would any of the recent fixes address this lock contention?

There is only one global root_domain.cpupri, and when do wake_up_process for RT process, the cpupri_set will be called to hold a global lock.
Seems this contention isn't triggered before. 
> 
> 							Thanx, Paul
> 
> >    11.53%        hackbench  [kernel]                   [k]
> >                   |
> >                   --- _raw_spin_lock_irqsave
> >                       cpupri_set
> >                       __enqueue_rt_entity
> >                       enqueue_rt_entity
> >                       enqueue_task_rt
> >                       enqueue_task
> >                       activate_task
> >                       ttwu_activate
> >                       ttwu_do_activate.clone.3
> >                       try_to_wake_up
> >                       wake_up_process
> >                       invoke_rcu_cpu_kthread
> >                       rcu_check_callbacks
> >                       update_process_times
> >                       tick_sched_timer
> >                       __run_hrtimer
> >

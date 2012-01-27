Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab2A0Jfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 04:35:36 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:50326 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab2A0Jfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 04:35:33 -0500
Date: Fri, 27 Jan 2012 15:05:14 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Indan Zupancic <indan@nul.nu>, Youquan Song <youquan.song@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC PATCH v1 1/2] sched: unified sched_powersavings sysfs
 tunable
Message-ID: <20120127093514.GD8897@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20120116161740.29759.4679.stgit@localhost>
 <20120116162241.29759.13220.stgit@localhost>
 <1327503181.2614.76.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1327503181.2614.76.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12012709-2674-0000-0000-00000323D917
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2012-01-25 15:53:01]:

> On Mon, 2012-01-16 at 21:52 +0530, Vaidyanathan Srinivasan wrote:
> > +++ b/block/blk.h
> > @@ -167,14 +167,15 @@ static inline int queue_congestion_off_threshold(struct request_queue *q)
> >  static inline int blk_cpu_to_group(int cpu)
> >  {
> >         int group = NR_CPUS;
> > -#ifdef CONFIG_SCHED_MC
> > -       const struct cpumask *mask = cpu_coregroup_mask(cpu);
> > -       group = cpumask_first(mask);
> > -#elif defined(CONFIG_SCHED_SMT)
> > -       group = cpumask_first(topology_thread_cpumask(cpu));
> > +#ifdef CONFIG_SCHED_POWERSAVE
> > +       if (smt_capable())
> > +               group = cpumask_first(topology_thread_cpumask(cpu));
> > +       else    
> > +               group = cpumask_first(cpu_coregroup_mask(cpu));
> >  #else
> >         return cpu;
> >  #endif
> > +       /* Possible dead code?? */
> >         if (likely(group < NR_CPUS))
> >                 return group;
> >         return cpu; 
> 
> After going, WTF is block doing! I had a closer look and this doesn't
> seem right at all. The old code would use coregroup_mask when SCHED_MC
> && SCHED_SMT, the new code does something else.
> 
> Jens, what is this thing trying to do?

I understood the requirement as get first cpu in the 'core' on
a hyper-threaded system and first cpu in the 'socket' on
a non-threaded system for best cache affinity.  Based on Jens
explanation and Peter's patch, identifying last-level shared cache
works best for this case.

--Vaidy


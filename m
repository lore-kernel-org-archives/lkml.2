Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab1KNTee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 14:34:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:20329 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448Ab1KNTed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 14:34:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,510,1315206000"; 
   d="scan'208";a="85068356"
Subject: Re: [Patch] Idle balancer: cache align nohz structure to improve
 idle load balancing scalability
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Venki Pallipadi <venki@google.com>, Andi Kleen <andi@firstfloor.org>,
        Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 14 Nov 2011 11:37:49 -0800
In-Reply-To: <1321263161.30500.7.camel@twins>
References: <1319060737.2604.38.camel@schen9-DESK>
	 <m2wrc0xpbg.fsf@firstfloor.org>
	 <CABeCy1a20npBt=4ee38zLH+6Fi7nfASd0dL3od6pOccV=LJDkA@mail.gmail.com>
	 <4FF5AC937153B0459463C1A88EB478F20135D6ECB5@orsmsx505.amr.corp.intel.com>
	 <1320191558.28097.44.camel@sbsiddha-desk.sc.intel.com>
	 <1321263161.30500.7.camel@twins>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1321299469.16760.5.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-14 at 01:32 -0800, Peter Zijlstra wrote:
> On Tue, 2011-11-01 at 16:52 -0700, Suresh Siddha wrote:
> > @@ -3317,6 +3317,7 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
> >  
> >         cpu_rq(cpu)->cpu_power = power;
> >         sdg->sgp->power = power;
> > +       atomic_set(&sdg->sgp->nr_busy_cpus, sdg->group_weight);
> >  }
> >  
> >  static void update_group_power(struct sched_domain *sd, int cpu)
> > @@ -3339,6 +3340,7 @@ static void update_group_power(struct sched_domain *sd, int cpu)
> >         } while (group != child->groups);
> >  
> >         sdg->sgp->power = power;
> > +       atomic_set(&sdg->sgp->nr_busy_cpus, sdg->group_weight);
> >  } 
> 
> So we run this rather frequently, and it will trample all over:
> 
> > +                */
> > +               for_each_domain(cpu, sd)
> > +                       atomic_dec(&sd->groups->sgp->nr_busy_cpus);
> 
> because I cannot see any serialization between those sites.

That was an overlook from myside. I moved the initialization of this to
init_sched_groups_power() now and there is no need to re-do this
everytime we call the update_group_power().

> Also, isn't it rather weird to just assume all cpus are busy in
> update_group_power()? If you would actually set the right value in
> update_cpu_power() you could use a straight sum in update_group_power()
> and get a more or less accurate number out.

I will post an updated patch soon (once we complete the performance
analysis of this patch with respect to other workloads) but the below
hunk gives an idea of what I am planning to do now.

@@ -7369,6 +7384,7 @@ static void init_sched_groups_power(int cpu, struct sched_
                return;
 
        update_group_power(sd, cpu);
+       atomic_set(&sg->sgp->nr_busy_cpus, sg->group_weight);
 }
 
 /*

thanks,
suresh


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab1KNJdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 04:33:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44995 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab1KNJdL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 04:33:11 -0500
Subject: Re: [Patch] Idle balancer: cache align nohz structure to improve
 idle load balancing scalability
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venki Pallipadi <venki@google.com>, Andi Kleen <andi@firstfloor.org>,
        Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 14 Nov 2011 10:32:41 +0100
In-Reply-To: <1320191558.28097.44.camel@sbsiddha-desk.sc.intel.com>
References: <1319060737.2604.38.camel@schen9-DESK>
	 <m2wrc0xpbg.fsf@firstfloor.org>
	 <CABeCy1a20npBt=4ee38zLH+6Fi7nfASd0dL3od6pOccV=LJDkA@mail.gmail.com>
	 <4FF5AC937153B0459463C1A88EB478F20135D6ECB5@orsmsx505.amr.corp.intel.com>
	 <1320191558.28097.44.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1321263161.30500.7.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-01 at 16:52 -0700, Suresh Siddha wrote:
> @@ -3317,6 +3317,7 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
>  
>         cpu_rq(cpu)->cpu_power = power;
>         sdg->sgp->power = power;
> +       atomic_set(&sdg->sgp->nr_busy_cpus, sdg->group_weight);
>  }
>  
>  static void update_group_power(struct sched_domain *sd, int cpu)
> @@ -3339,6 +3340,7 @@ static void update_group_power(struct sched_domain *sd, int cpu)
>         } while (group != child->groups);
>  
>         sdg->sgp->power = power;
> +       atomic_set(&sdg->sgp->nr_busy_cpus, sdg->group_weight);
>  } 

So we run this rather frequently, and it will trample all over:

> +                */
> +               for_each_domain(cpu, sd)
> +                       atomic_dec(&sd->groups->sgp->nr_busy_cpus);

because I cannot see any serialization between those sites.

Also, isn't it rather weird to just assume all cpus are busy in
update_group_power()? If you would actually set the right value in
update_cpu_power() you could use a straight sum in update_group_power()
and get a more or less accurate number out.



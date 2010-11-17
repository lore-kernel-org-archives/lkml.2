Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330Ab0KQBRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 20:17:00 -0500
Received: from mga14.intel.com ([143.182.124.37]:54881 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756816Ab0KQBQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 20:16:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,208,1288594800"; 
   d="scan'208";a="349689316"
Subject: Re: [performance bug] volanomark regression on 37-rc1
From: "Alex,Shi" <alex.shi@intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Nikhil Rao <ncrao@google.com>, Rakib Mullick <rakib.mullick@gmail.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Yan, Zheng Z" <zheng.z.yan@intel.com>
In-Reply-To: <1289928732.5169.211.camel@maggy.simson.net>
References: <1289900042.27424.253.camel@debian>
	 <AANLkTi=OK+B537S5D8H4=yV5zC8+RksnfYgoKsqEyk5+@mail.gmail.com>
	 <1289921196.5169.176.camel@maggy.simson.net>
	 <AANLkTinrtz36tDZT2C39aVRsws-wmRraLGsMZ8_zxFA+@mail.gmail.com>
	 <1289928732.5169.211.camel@maggy.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 09:17:19 +0800
Message-ID: <1289956639.27424.303.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> ---
>  kernel/sched_fair.c |    4 ----
>  1 file changed, 4 deletions(-)
> 
> Index: linux-2.6/kernel/sched_fair.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_fair.c
> +++ linux-2.6/kernel/sched_fair.c
> @@ -1758,10 +1758,6 @@ static void pull_task(struct rq *src_rq,
>  	set_task_cpu(p, this_cpu);
>  	activate_task(this_rq, p, 0);
>  	check_preempt_curr(this_rq, p, 0);
> -
> -	/* re-arm NEWIDLE balancing when moving tasks */
> -	src_rq->avg_idle = this_rq->avg_idle = 2*sysctl_sched_migration_cost;
> -	this_rq->idle_stamp = 0;
>  }
>  
>  /*
> 
> 
In the original source (.36 kernel) the rq->idle_stamp is set as zero
after task was pulled to this cpu in load_balance(). Nikhil move this
setting to pull_task(), that has same effect.
I don't know what the details effect of removing idle_stamp setting
instead of recovered it on idle_balance(). :) 

My machines are doing rc2 performance testing. I may try this patch
after testing finish. 

The following is part of Nikhil's old patch. 
===
@@ -3162,10 +3186,8 @@ static void idle_balance(int this_cpu, struct rq
*this_rq)
                interval = msecs_to_jiffies(sd->balance_interval);
                if (time_after(next_balance, sd->last_balance +
interval))
                        next_balance = sd->last_balance + interval;
-               if (pulled_task) {
-                       this_rq->idle_stamp = 0;
+               if (pulled_task)
                        break;
-               }
        }

Regards
Alex




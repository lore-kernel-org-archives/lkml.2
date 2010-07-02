Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278Ab0GBQki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 12:40:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:45162 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759255Ab0GBQkf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 12:40:35 -0400
Subject: Re: [PATCH] sched: Call update_group_power only for local_group
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Gautham R Shenoy <ego@in.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <AANLkTikcZhbbtgNjW-JDf9FVD1jbyIsQ_RxeOUVK8c7C@mail.gmail.com>
References: <1278025942-6750-1-git-send-email-venki@google.com>
	 <1278057944.32034.15085.camel@twins>
	 <AANLkTikcZhbbtgNjW-JDf9FVD1jbyIsQ_RxeOUVK8c7C@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 02 Jul 2010 18:40:16 +0200
Message-ID: <1278088816.1917.279.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-02 at 09:20 -0700, Venkatesh Pallipadi wrote:
> > Hrm,.. so Gautham removed that because for things like the NO_HZ
> > balancer the initial balance_cpu == this_cpu constraint doesn't hold.
> >
> > Not I don't think the local_group constraint holds for that either, so
> > the below would again break that..
> >
> > Should we perhaps have a conditional on this_rq->nohz_balance_kick or
> > so?
> 
> The thing is that update_group_power is only updating the power of
> local group (sd->groups).

Not quite, see nohz_idle_balance(), that iterates idle_cpus_mask, and
calls rebalance_domains(balance_cpu, CPU_IDLE), which then does
for_each_domain(balance_cpu, sd)

So sd need not be local at all, and sd->group will be the group of which
balance_cpu is part.

> It is getting called multiple times however for each group as
> update_sd_lb_stats loops
> through groups->next calling update_sg_lb_stats.

Sure I see how that's happening and why you would want to avoid that, no
argument there.

> If we really want to update the power of non-local groups,
> update_cpu_power has to change
> to take a groups parameter and non this_cpu as arguments and may have
> to access non-local
> rq etc. 

No, see above. All we need is to somehow allow nohz_idle_balance() to
update cpu_power as well.

So I think we want something like:

       if (local_group) {
               balance_cpu = group_first_cpu(group);                                                                
               if (balance_cpu == this_cpu || nohz_balance)
                       update_group_power(sd, this_cpu);
       }

Or am I totally missing something here?

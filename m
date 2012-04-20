Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab2DTOA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 10:00:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:46936 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2DTOAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 10:00:25 -0400
Subject: Re: load balancing regression since commit 367456c7
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Alex Shi <alex.shi@intel.com>,
        Ying <ying.huang@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1334681054.3796.28.camel@schen9-DESK>
References: <1334106376.19157.89.camel@schen9-DESK>
	 <1334664553.28150.87.camel@twins>  <1334681054.3796.28.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Apr 2012 16:00:21 +0200
Message-ID: <1334930421.2463.60.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-17 at 09:44 -0700, Tim Chen wrote:
> On Tue, 2012-04-17 at 14:09 +0200, Peter Zijlstra wrote:
> > On Tue, 2012-04-10 at 18:06 -0700, Tim Chen wrote:
> > >                   |--56.52%-- load_balance
> > >                   |          idle_balance
> > >                   |          __schedule
> > >                   |          schedule 
> > 
> > Ahh, I know why I didn't see it, I have a CONFIG_PREEMPT kernel and
> > idle_balancing stops once its gotten a single task over instead of
> > achieving proper balance.
> > 
> > And since hackbench generates insanely long runqueues and the patch that
> > caused your regression 'fixed' the lock-breaking it will now iterate the
> > entire runqueue if needed to achieve balance, which hurts.
> > 
> > I think the patch I send ought to work, let me try disabling
> > CONFIG_PREEMPT.
> > --
> 
> yes, CONFIG_PREEMPT is turned off on my side.  With the patch that you
> sent, the slowed down went from a factor of 4 down to a factor 2. 
> 
> So the run time is now twice as long vs four time as long vs v3.3
> kernel.

Ok, so I can't reproduce this on my WSM-EP.. even !PREEMPT kernels are
consistent with hackbench times with or without that patch.

Can you still send your full .config? Also, do you have cpu-cgroup muck
enabled and are you using that systemd shite?

What does the below patch (on top of the previous) do?

---
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -784,7 +784,7 @@ account_entity_enqueue(struct cfs_rq *cf
 		update_load_add(&rq_of(cfs_rq)->load, se->load.weight);
 #ifdef CONFIG_SMP
 	if (entity_is_task(se))
-		list_add_tail(&se->group_node, &rq_of(cfs_rq)->cfs_tasks);
+		list_add(&se->group_node, &rq_of(cfs_rq)->cfs_tasks);
 #endif
 	cfs_rq->nr_running++;
 }



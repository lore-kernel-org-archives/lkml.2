Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab0HTAvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 20:51:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:54730 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab0HTAvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 20:51:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,236,1280732400"; 
   d="scan'208";a="829955626"
Subject: Re: [patch 3/3] sched: move sched_avg_update() to update_cpu_load()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chris@frostnet.net" <chris@frostnet.net>,
        "debian00@aliceadsl.fr" <debian00@aliceadsl.fr>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jonathan.protzenko@gmail.com" <jonathan.protzenko@gmail.com>,
        "mans@mansr.com" <mans@mansr.com>,
        "psastudio@mail.ru" <psastudio@mail.ru>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "stephan.eicher@web.de" <stephan.eicher@web.de>,
        "sxxe@gmx.de" <sxxe@gmx.de>,
        "thomas@archlinux.org" <thomas@archlinux.org>,
        "venki@google.com" <venki@google.com>,
        "wonghow@gmail.com" <wonghow@gmail.com>
In-Reply-To: <1281987086.1926.1890.camel@laptop>
References: <20100813190539.410550989@sbsiddha-MOBL3.sc.intel.com>
	 <20100813193911.999833492@sbsiddha-MOBL3.sc.intel.com>
	 <1281945634.1926.968.camel@laptop>
	 <1281980769.2676.33.camel@sbsiddha-MOBL3.sc.intel.com>
	 <1281987086.1926.1890.camel@laptop>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 19 Aug 2010 17:51:18 -0700
Message-Id: <1282265478.10905.1.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 12:31 -0700, Peter Zijlstra wrote:
> On Mon, 2010-08-16 at 10:46 -0700, Suresh Siddha wrote:
> 
> > There is no guarantee that the original cpu won't be doing this in
> > parallel with nohz idle load balancing cpu.
> 
> Hmm, true.. bugger.
> 
> > > > Fix it by moving the sched_avg_update() to more appropriate update_cpu_load()
> > > > where the CFS load gets updated aswell.
> > > 
> > > Right, except it breaks things a bit, at the very least you really need
> > > that update right before reading it, otherwise you can end up with >100%
> > > fractions, which are odd indeed ;-)
> > 
> > with the patch, the update always happens before reading it. isn't it?
> > 
> > update now happens during the scheduler tick (or during nohz load
> > balancing tick). And the load balancer gets triggered with the tick.
> > So the update (at the tick) should happen before reading it (used by
> > load balancing triggered by the tick). Am I missing something?
> 
> We run the load-balancer in softirq context, on -rt that's a task, and
> we could have ran other (more important) RT tasks between the hardirq
> and the softirq running, which would increase the rt_avg and could thus
> result in >100%.
> 
> But I think we can simply retain the sched_avg_update(rq) in
> sched_rt_avg_update(), that is ran with rq->lock held and should be
> enough to avoid that case.
> 
> We can retain the other bit of you patch, moving sched_avg_update() from
> scale_rt_power() to update_cpu_load(), since that is only concerned with
> lowering the average when there is no actual activity.

Ok. Updated patch appended. Thanks.
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: sched: move sched_avg_update() to update_cpu_load()

Currently sched_avg_update() (which updates rt_avg stats in the rq) is getting
called from scale_rt_power() (in the load balance context) which doesn't take
rq->lock.

Fix it by moving the sched_avg_update() to more appropriate update_cpu_load()
where the CFS load gets updated aswell.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 kernel/sched.c      |    3 ++-
 kernel/sched_fair.c |    2 --
 2 files changed, 2 insertions(+), 3 deletions(-)

Index: tree/kernel/sched_fair.c
===================================================================
--- tree.orig/kernel/sched_fair.c
+++ tree/kernel/sched_fair.c
@@ -2268,8 +2268,6 @@ unsigned long scale_rt_power(int cpu)
 	struct rq *rq = cpu_rq(cpu);
 	u64 total, available;
 
-	sched_avg_update(rq);
-
 	total = sched_avg_period() + (rq->clock - rq->age_stamp);
 	available = total - rq->rt_avg;
 
Index: tree/kernel/sched.c
===================================================================
--- tree.orig/kernel/sched.c
+++ tree/kernel/sched.c
@@ -3182,6 +3182,8 @@ static void update_cpu_load(struct rq *t
 
 		this_rq->cpu_load[i] = (old_load * (scale - 1) + new_load) >> i;
 	}
+
+	sched_avg_update(this_rq);
 }
 
 static void update_cpu_load_active(struct rq *this_rq)



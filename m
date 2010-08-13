Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab0HMTpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 15:45:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:8057 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372Ab0HMTpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 15:45:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,365,1278313200"; 
   d="scan'208";a="544985775"
Message-Id: <20100813193911.999833492@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Fri, 13 Aug 2010 12:45:42 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: chris@frostnet.net, debian00@aliceadsl.fr, hpa@zytor.com,
        jonathan.protzenko@gmail.com, mans@mansr.com, psastudio@mail.ru,
        rjw@sisk.pl, stephan.eicher@web.de, sxxe@gmx.de, thomas@archlinux.org,
        venki@google.com, wonghow@gmail.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 3/3] sched: move sched_avg_update() to update_cpu_load()
References: <20100813190539.410550989@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=move_sched_avg_update.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
@@ -1281,7 +1281,6 @@ static void sched_avg_update(struct rq *
 static void sched_rt_avg_update(struct rq *rq, u64 rt_delta)
 {
 	rq->rt_avg += rt_delta;
-	sched_avg_update(rq);
 }
 
 #else /* !CONFIG_SMP */
@@ -3182,6 +3181,8 @@ static void update_cpu_load(struct rq *t
 
 		this_rq->cpu_load[i] = (old_load * (scale - 1) + new_load) >> i;
 	}
+
+	sched_avg_update(this_rq);
 }
 
 static void update_cpu_load_active(struct rq *this_rq)



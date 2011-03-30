Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367Ab1C3VHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:07:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:58267 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933439Ab1C3VHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411277550"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: suresh.b.siddha@intel.com, a.p.zijlstra@chello.nl, ak@linux.intel.com,
        mingo@elte.hu, efault@gmx.de, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [88/275] sched: Move sched_avg_update() to update_cpu_load()
Message-Id: <20110330210526.569A53E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
Commit: da2b71edd8a7db44fe1746261410a981f3e03632 upstream

Currently sched_avg_update() (which updates rt_avg stats in the rq)
is getting called from scale_rt_power() (in the load balance context)
which doesn't take rq->lock.

Fix it by moving the sched_avg_update() to more appropriate
update_cpu_load() where the CFS load gets updated as well.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <1282596171.2694.3.camel@sbsiddha-MOBL3>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c      |    6 ++++++
 kernel/sched_fair.c |    2 --
 2 files changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/kernel/sched.c
===================================================================
--- linux-2.6.35.y.orig/kernel/sched.c	2011-03-29 22:51:34.981828070 -0700
+++ linux-2.6.35.y/kernel/sched.c	2011-03-29 23:55:04.322356578 -0700
@@ -1270,6 +1270,10 @@
 static void sched_rt_avg_update(struct rq *rq, u64 rt_delta)
 {
 }
+
+static void sched_avg_update(struct rq *rq)
+{
+}
 #endif /* CONFIG_SMP */
 
 #if BITS_PER_LONG == 32
@@ -3152,6 +3156,8 @@
 	}
 
 	calc_load_account_active(this_rq);
+
+	sched_avg_update(this_rq);
 }
 
 #ifdef CONFIG_SMP
Index: linux-2.6.35.y/kernel/sched_fair.c
===================================================================
--- linux-2.6.35.y.orig/kernel/sched_fair.c	2011-03-29 22:51:34.981828070 -0700
+++ linux-2.6.35.y/kernel/sched_fair.c	2011-03-29 23:55:05.971314385 -0700
@@ -2268,8 +2268,6 @@
 	struct rq *rq = cpu_rq(cpu);
 	u64 total, available;
 
-	sched_avg_update(rq);
-
 	total = sched_avg_period() + (rq->clock - rq->age_stamp);
 	available = total - rq->rt_avg;
 

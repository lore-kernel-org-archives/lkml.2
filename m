Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab1BJMYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:24:42 -0500
Received: from cantor.suse.de ([195.135.220.2]:33706 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab1BJMYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:24:40 -0500
From: stable-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Date: Thu, 10 Feb 2011 09:52:07 +0100
Subject: [PATCH 03/28] sched: Move sched_avg_update() to update_cpu_load()
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Message-ID: <1297340643.5512.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit: da2b71edd8a7db44fe1746261410a981f3e03632 upstream
Author: Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon Aug 23 13:42:51 2010 -0700

Currently sched_avg_update() (which updates rt_avg stats in the rq)
is getting called from scale_rt_power() (in the load balance context)
which doesn't take rq->lock.

Fix it by moving the sched_avg_update() to more appropriate
update_cpu_load() where the CFS load gets updated as well.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1282596171.2694.3.camel@sbsiddha-MOBL3>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 4e6dcdd..511b3be 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1255,6 +1255,10 @@ static void resched_task(struct task_struct *p)
 static void sched_rt_avg_update(struct rq *rq, u64 rt_delta)
 {
 }
+
+static void sched_avg_update(struct rq *rq)
+{
+}
 #endif /* CONFIG_SMP */
 
 #if BITS_PER_LONG == 32
@@ -3102,6 +3106,8 @@ static void update_cpu_load(struct rq *this_rq)
 		this_rq->calc_load_update += LOAD_FREQ;
 		calc_load_account_active(this_rq);
 	}
+
+	sched_avg_update(this_rq);
 }
 
 #ifdef CONFIG_SMP
@@ -3653,8 +3659,6 @@ unsigned long scale_rt_power(int cpu)
 	struct rq *rq = cpu_rq(cpu);
 	u64 total, available;
 
-	sched_avg_update(rq);
-
 	total = sched_avg_period() + (rq->clock - rq->age_stamp);
 	available = total - rq->rt_avg;
 
-- 
1.7.4



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab0IITqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:46:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:40633 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718Ab0IITqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:46:18 -0400
Date: Thu, 9 Sep 2010 19:45:51 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1282596171.2694.3.camel@sbsiddha-MOBL3>
References: <1282596171.2694.3.camel@sbsiddha-MOBL3>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Move sched_avg_update() to update_cpu_load()
Message-ID: <tip-da2b71edd8a7db44fe1746261410a981f3e03632@git.kernel.org>
Git-Commit-ID: da2b71edd8a7db44fe1746261410a981f3e03632
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:45:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  da2b71edd8a7db44fe1746261410a981f3e03632
Gitweb:     http://git.kernel.org/tip/da2b71edd8a7db44fe1746261410a981f3e03632
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 23 Aug 2010 13:42:51 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Sep 2010 20:39:33 +0200

sched: Move sched_avg_update() to update_cpu_load()

Currently sched_avg_update() (which updates rt_avg stats in the rq)
is getting called from scale_rt_power() (in the load balance context)
which doesn't take rq->lock.

Fix it by moving the sched_avg_update() to more appropriate
update_cpu_load() where the CFS load gets updated as well.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1282596171.2694.3.camel@sbsiddha-MOBL3>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      |    6 ++++++
 kernel/sched_fair.c |    2 --
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 09b574e..ed09d4f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1294,6 +1294,10 @@ static void resched_task(struct task_struct *p)
 static void sched_rt_avg_update(struct rq *rq, u64 rt_delta)
 {
 }
+
+static void sched_avg_update(struct rq *rq)
+{
+}
 #endif /* CONFIG_SMP */
 
 #if BITS_PER_LONG == 32
@@ -3182,6 +3186,8 @@ static void update_cpu_load(struct rq *this_rq)
 
 		this_rq->cpu_load[i] = (old_load * (scale - 1) + new_load) >> i;
 	}
+
+	sched_avg_update(this_rq);
 }
 
 static void update_cpu_load_active(struct rq *this_rq)
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index ab661eb..f53ec75 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2268,8 +2268,6 @@ unsigned long scale_rt_power(int cpu)
 	struct rq *rq = cpu_rq(cpu);
 	u64 total, available;
 
-	sched_avg_update(rq);
-
 	total = sched_avg_period() + (rq->clock - rq->age_stamp);
 	available = total - rq->rt_avg;
 

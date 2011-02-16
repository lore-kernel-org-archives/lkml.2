Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591Ab1BPB7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:59:09 -0500
Received: from kroah.org ([198.145.64.141]:49228 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758547Ab1BPBvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:51:25 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:03 2011
Message-Id: <20110216014703.062582825@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:45:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Subject: [088/115] sched: Move sched_avg_update() to update_cpu_load()
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

Commit: da2b71edd8a7db44fe1746261410a981f3e03632 upstream

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1255,6 +1255,10 @@ static void resched_task(struct task_str
 static void sched_rt_avg_update(struct rq *rq, u64 rt_delta)
 {
 }
+
+static void sched_avg_update(struct rq *rq)
+{
+}
 #endif /* CONFIG_SMP */
 
 #if BITS_PER_LONG == 32
@@ -3102,6 +3106,8 @@ static void update_cpu_load(struct rq *t
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
 



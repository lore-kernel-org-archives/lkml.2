Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab0KLDcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 22:32:43 -0500
Received: from smtp-out.google.com ([216.239.44.51]:3860 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412Ab0KLDck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 22:32:40 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
	b=ujjucMa8tnaK85WSXVuliseSBsG2bp79t8zCZdwyTwr4o/K3LaAeVAHnjXcUdUOwO
	AqFNnt8tjrxtGMlWOVsWg==
Message-Id: <20101112032702.028843817@google.com>
References: <20101112032405.657789056@google.com>
User-Agent: quilt/0.46-1
Date: Thu, 11 Nov 2010 19:24:14 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>, Paul Turner <pjt@google.com>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Karl Rister <kmr@us.ibm.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>
Subject: [tg_shares_up rewrite v3 09/11] sched: demand based update_cfs_load()
Content-Disposition: inline; filename=sched-tg-demand_based_update_cfs_load.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the system is busy, dilation of rq->next_balance makes lb->update_shares()
insufficiently frequent for threads which don't sleep (no dequeue/enqueue
updates).  Adjust for this by making demand based updates based on the
accumulation of execution time sufficient to wrap our averaging window.

Signed-off-by: Paul Turner <pjt@google.com>

---
 kernel/sched.c      |    9 ++++++++-
 kernel/sched_fair.c |   12 ++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

Index: kernel/sched.c
===================================================================
--- kernel/sched.c.orig
+++ kernel/sched.c
@@ -355,9 +355,16 @@ struct cfs_rq {
 	 */
 	unsigned long h_load;
 
+	/*
+	 * Maintaining per-cpu shares distribution for group scheduling
+	 *
+	 * load_stamp is the last time we updated the load average
+	 * load_last is the last time we updated the load average and saw load
+	 * load_unacc_exec_time is currently unaccounted execution time
+	 */
 	u64 load_avg;
 	u64 load_period;
-	u64 load_stamp, load_last;
+	u64 load_stamp, load_last, load_unacc_exec_time;
 
 	unsigned long load_contribution;
 #endif
Index: kernel/sched_fair.c
===================================================================
--- kernel/sched_fair.c.orig
+++ kernel/sched_fair.c
@@ -539,6 +539,9 @@ static u64 sched_vslice(struct cfs_rq *c
 	return calc_delta_fair(sched_slice(cfs_rq, se), se);
 }
 
+static void update_cfs_load(struct cfs_rq *cfs_rq);
+static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta);
+
 /*
  * Update the current task's runtime statistics. Skip current tasks that
  * are not in our scheduling class.
@@ -558,6 +561,14 @@ __update_curr(struct cfs_rq *cfs_rq, str
 
 	curr->vruntime += delta_exec_weighted;
 	update_min_vruntime(cfs_rq);
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	cfs_rq->load_unacc_exec_time += delta_exec;
+	if (cfs_rq->load_unacc_exec_time > sysctl_sched_shares_window) {
+		update_cfs_load(cfs_rq);
+		update_cfs_shares(cfs_rq, 0);
+	}
+#endif
 }
 
 static void update_curr(struct cfs_rq *cfs_rq)
@@ -713,6 +724,7 @@ static void update_cfs_load(struct cfs_r
 	}
 
 	cfs_rq->load_stamp = now;
+	cfs_rq->load_unacc_exec_time = 0;
 	cfs_rq->load_period += delta;
 	if (load) {
 		cfs_rq->load_last = now;

-- 


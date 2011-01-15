Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab1AOCDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 21:03:00 -0500
Received: from smtp-out.google.com ([74.125.121.67]:56952 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab1AOCC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 21:02:58 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:
	content-disposition:x-system-of-record;
	b=hx+PSXYjUsZX0n1v84VLxKha8ToJNIUVUX+hBvc/fQaFbx9BQKkfgefoKs0/nHE2G
	6t33s7nRtRN5IeBEhjXQA==
Message-Id: <20110115015817.255632044@google.com>
User-Agent: quilt/0.48-1
Date: Fri, 14 Jan 2011 17:57:52 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Nick Piggin <npiggin@kernel.dk>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: [wake_afine fixes/improvements 3/3] sched: introduce sched_feat(NO_HOT_AFFINE)
References: <20110115015749.692623529@google.com>
Content-Disposition: inline; filename=task_hot_lazy.patch
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

re-introduce the cache-cold requirement for affine wake-up balancing.

A much more aggressive migration cost (currently 0.5ms) appears to have tilted
the needle towards favouring not performing affine migrations for cache_hot 
tasks.

Since the update_rq path is more expensive now (and the 'hot' window so small),
avoid hammering it in the common case where the (possibly slightly stale) 
rq->clock_task value has already advanced enough to invalidate hot-ness.

Signed-off-by: Paul Turner <pjt@google.com>

---
 kernel/sched_fair.c     |   20 +++++++++++++++++++-
 kernel/sched_features.h |    5 +++++
 2 files changed, 24 insertions(+), 1 deletion(-)

Index: tip3/kernel/sched_fair.c
===================================================================
--- tip3.orig/kernel/sched_fair.c
+++ tip3/kernel/sched_fair.c
@@ -1376,6 +1376,23 @@ task_hot(struct task_struct *p, u64 now)
 	return delta < (s64)sysctl_sched_migration_cost;
 }
 
+/*
+ * Since sched_migration_cost is (relatively) very small we only need to
+ * actually update the clock in the boundary case when determining whether a
+ * task is hot or not.
+ */
+static int task_hot_lazy(struct task_struct *p)
+{
+	struct rq *rq = task_rq(p);
+
+	if (!task_hot(p, rq->clock_task))
+		return 0;
+
+	update_rq_clock(rq);
+
+	return task_hot(p, rq->clock_task);
+}
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 /*
  * effective_load() calculates the load change as seen from the root_task_group
@@ -1664,7 +1681,8 @@ select_task_rq_fair(struct rq *rq, struc
 	int sync = wake_flags & WF_SYNC;
 
 	if (sd_flag & SD_BALANCE_WAKE) {
-		if (cpumask_test_cpu(cpu, &p->cpus_allowed))
+		if (cpumask_test_cpu(cpu, &p->cpus_allowed) &&
+		   (!sched_feat(NO_HOT_AFFINE) || !task_hot_lazy(p)))
 			want_affine = 1;
 		new_cpu = prev_cpu;
 	}
Index: tip3/kernel/sched_features.h
===================================================================
--- tip3.orig/kernel/sched_features.h
+++ tip3/kernel/sched_features.h
@@ -64,3 +64,8 @@ SCHED_FEAT(OWNER_SPIN, 1)
  * Decrement CPU power based on irq activity
  */
 SCHED_FEAT(NONIRQ_POWER, 1)
+
+/*
+ * Don't consider cache-hot tasks for affine wakeups
+ */
+SCHED_FEAT(NO_HOT_AFFINE, 1)



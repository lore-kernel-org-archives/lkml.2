Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629Ab0EMKtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 06:49:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:60619 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756757Ab0EMKtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 06:49:13 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] sched: consult online mask instead of active in select_fallback_rq()
Date: Thu, 13 May 2010 12:48:22 +0200
Message-Id: <1273747705-7829-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273747705-7829-1-git-send-email-tj@kernel.org>
References: <1273747705-7829-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 13 May 2010 10:48:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If called after sched_class chooses a CPU which isn't in a task's
cpus_allowed mask, select_fallback_rq() can end up migrating a task
which is bound to an !active but online cpu to an active cpu.  This is
dangerous because active is cleared before CPU_DOWN_PREPARE is called
and subsystems expect affinities of kthreads and other tasks to be
maintained till their CPU_DOWN_PREPARE callbacks are complete.

Consult cpu_online_mask instead.

This problem is triggered by cmwq.  During CPU_DOWN_PREPARE, hotplug
callback creates the trustee kthread and kthread_bind()s it to the
target cpu, and the trustee is expected to run on that cpu.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index b531d79..aca4a20 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2262,12 +2262,12 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 	const struct cpumask *nodemask = cpumask_of_node(cpu_to_node(cpu));
 
 	/* Look for allowed, online CPU in same node. */
-	for_each_cpu_and(dest_cpu, nodemask, cpu_active_mask)
+	for_each_cpu_and(dest_cpu, nodemask, cpu_online_mask)
 		if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
 			return dest_cpu;
 
 	/* Any allowed, online CPU? */
-	dest_cpu = cpumask_any_and(&p->cpus_allowed, cpu_active_mask);
+	dest_cpu = cpumask_any_and(&p->cpus_allowed, cpu_online_mask);
 	if (dest_cpu < nr_cpu_ids)
 		return dest_cpu;
 
-- 
1.6.4.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab1DULH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 07:07:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab1DULHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 07:07:55 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <dfeng@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH -tip] sched: more sched_domain iterations fix
Date: Thu, 21 Apr 2011 19:07:24 +0800
Message-Id: <1303384044-7646-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched_domain iterations needs to be protected by rcu_read_lock() now,
this patch adds another two places which needs the rcu lock.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched_rt.c    |    2 ++
 kernel/sched_stats.h |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 19ecb31..901ed2a 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1282,7 +1282,9 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
 	int cpu;
 
 	for (tries = 0; tries < RT_MAX_TRIES; tries++) {
+		rcu_read_lock();
 		cpu = find_lowest_rq(task);
+		rcu_read_unlock();
 
 		if ((cpu == -1) || (cpu == rq->cpu))
 			break;
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 48ddf43..d25c8c1 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -38,6 +38,7 @@ static int show_schedstat(struct seq_file *seq, void *v)
 #ifdef CONFIG_SMP
 		/* domain-specific stats */
 		preempt_disable();
+		rcu_read_lock();
 		for_each_domain(cpu, sd) {
 			enum cpu_idle_type itype;
 
@@ -64,6 +65,7 @@ static int show_schedstat(struct seq_file *seq, void *v)
 			    sd->ttwu_wake_remote, sd->ttwu_move_affine,
 			    sd->ttwu_move_balance);
 		}
+		rcu_read_unlock();
 		preempt_enable();
 #endif
 	}
-- 
1.7.1


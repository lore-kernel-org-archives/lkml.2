Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842Ab1DNIeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:34:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:47167 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756490Ab1DNIeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:34:03 -0400
Date: Thu, 14 Apr 2011 08:32:52 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-893633817f5b58f5227365d74344e0170a718213@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        frank.rowand@am.sony.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110405152728.866866929@chello.nl>
References: <20110405152728.866866929@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/locking] sched: Change the ttwu() success details
Git-Commit-ID: 893633817f5b58f5227365d74344e0170a718213
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Apr 2011 08:32:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  893633817f5b58f5227365d74344e0170a718213
Gitweb:     http://git.kernel.org/tip/893633817f5b58f5227365d74344e0170a718213
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 Apr 2011 17:23:42 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Apr 2011 08:52:34 +0200

sched: Change the ttwu() success details

try_to_wake_up() would only return a success when it would have to
place a task on a rq, change that to every time we change p->state to
TASK_RUNNING, because that's the real measure of wakeups.

This results in that success is always true for the tracepoints.

Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110405152728.866866929@chello.nl
---
 kernel/sched.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 81ab58e..3919aa4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2427,10 +2427,10 @@ static inline void ttwu_activate(struct task_struct *p, struct rq *rq,
 		wq_worker_waking_up(p, cpu_of(rq));
 }
 
-static inline void ttwu_post_activation(struct task_struct *p, struct rq *rq,
-					int wake_flags, bool success)
+static void
+ttwu_post_activation(struct task_struct *p, struct rq *rq, int wake_flags)
 {
-	trace_sched_wakeup(p, success);
+	trace_sched_wakeup(p, true);
 	check_preempt_curr(rq, p, wake_flags);
 
 	p->state = TASK_RUNNING;
@@ -2546,9 +2546,9 @@ out_activate:
 #endif /* CONFIG_SMP */
 	ttwu_activate(p, rq, wake_flags & WF_SYNC, orig_cpu != cpu,
 		      cpu == this_cpu, en_flags);
-	success = 1;
 out_running:
-	ttwu_post_activation(p, rq, wake_flags, success);
+	ttwu_post_activation(p, rq, wake_flags);
+	success = 1;
 out:
 	task_rq_unlock(rq, &flags);
 	put_cpu();
@@ -2567,7 +2567,6 @@ out:
 static void try_to_wake_up_local(struct task_struct *p)
 {
 	struct rq *rq = task_rq(p);
-	bool success = false;
 
 	BUG_ON(rq != this_rq());
 	BUG_ON(p == current);
@@ -2582,9 +2581,8 @@ static void try_to_wake_up_local(struct task_struct *p)
 			schedstat_inc(rq, ttwu_local);
 		}
 		ttwu_activate(p, rq, false, false, true, ENQUEUE_WAKEUP);
-		success = true;
 	}
-	ttwu_post_activation(p, rq, 0, success);
+	ttwu_post_activation(p, rq, 0);
 }
 
 /**
@@ -2747,7 +2745,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 
 	rq = task_rq_lock(p, &flags);
 	activate_task(rq, p, 0);
-	trace_sched_wakeup_new(p, 1);
+	trace_sched_wakeup_new(p, true);
 	check_preempt_curr(rq, p, WF_FORK);
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_woken)

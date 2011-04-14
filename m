Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547Ab1DNIiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:38:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:49758 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756490Ab1DNIiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:38:08 -0400
Date: Thu, 14 Apr 2011 08:37:46 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-8f42ced974df7d5af2de4cf5ea21fe978c7e4478@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        frank.rowand@am.sony.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110405152729.314204889@chello.nl>
References: <20110405152729.314204889@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/locking] sched: Drop rq->lock from sched_exec()
Git-Commit-ID: 8f42ced974df7d5af2de4cf5ea21fe978c7e4478
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Apr 2011 08:37:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f42ced974df7d5af2de4cf5ea21fe978c7e4478
Gitweb:     http://git.kernel.org/tip/8f42ced974df7d5af2de4cf5ea21fe978c7e4478
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 Apr 2011 17:23:53 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Apr 2011 08:52:39 +0200

sched: Drop rq->lock from sched_exec()

Since we can now call select_task_rq() and set_task_cpu() with only
p->pi_lock held, and sched_exec() load-balancing has always been
optimistic, drop all rq->lock usage.

Oleg also noted that need_migrate_task() will always be true for
current, so don't bother calling that at all.

Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110405152729.314204889@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 7c5494d..1be1a09 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3465,27 +3465,22 @@ void sched_exec(void)
 {
 	struct task_struct *p = current;
 	unsigned long flags;
-	struct rq *rq;
 	int dest_cpu;
 
-	rq = task_rq_lock(p, &flags);
+	raw_spin_lock_irqsave(&p->pi_lock, flags);
 	dest_cpu = p->sched_class->select_task_rq(p, SD_BALANCE_EXEC, 0);
 	if (dest_cpu == smp_processor_id())
 		goto unlock;
 
-	/*
-	 * select_task_rq() can race against ->cpus_allowed
-	 */
-	if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed) &&
-	    likely(cpu_active(dest_cpu)) && need_migrate_task(p)) {
+	if (likely(cpu_active(dest_cpu))) {
 		struct migration_arg arg = { p, dest_cpu };
 
-		task_rq_unlock(rq, p, &flags);
-		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
+		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+		stop_one_cpu(task_cpu(p), migration_cpu_stop, &arg);
 		return;
 	}
 unlock:
-	task_rq_unlock(rq, p, &flags);
+	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 }
 
 #endif

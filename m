Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323Ab1DNIkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:40:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:42558 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758607Ab1DNIkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:40:40 -0400
Date: Thu, 14 Apr 2011 08:40:19 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-bd8e7dded88a3e1c085c333f19ff31387616f71a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        oleg@redhat.com, frank.rowand@am.sony.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        oleg@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110405152729.556674812@chello.nl>
References: <20110405152729.556674812@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/locking] sched: Remove need_migrate_task()
Git-Commit-ID: bd8e7dded88a3e1c085c333f19ff31387616f71a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Apr 2011 08:40:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bd8e7dded88a3e1c085c333f19ff31387616f71a
Gitweb:     http://git.kernel.org/tip/bd8e7dded88a3e1c085c333f19ff31387616f71a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 Apr 2011 17:23:59 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Apr 2011 08:52:41 +0200

sched: Remove need_migrate_task()

Oleg noticed that need_migrate_task() doesn't need the ->on_cpu check
now that ttwu() doesn't do remote enqueues for !->on_rq && ->on_cpu,
so remove the helper and replace the single instance with a direct
->on_rq test.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110405152729.556674812@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   17 +----------------
 1 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 9e3ede1..cd597c7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2199,21 +2199,6 @@ struct migration_arg {
 static int migration_cpu_stop(void *data);
 
 /*
- * The task's runqueue lock must be held.
- * Returns true if you have to wait for migration thread.
- */
-static bool need_migrate_task(struct task_struct *p)
-{
-	/*
-	 * If the task is not on a runqueue (and not running), then
-	 * the next wake-up will properly place the task.
-	 */
-	bool running = p->on_rq || p->on_cpu;
-	smp_rmb(); /* finish_lock_switch() */
-	return running;
-}
-
-/*
  * wait_task_inactive - wait for a thread to unschedule.
  *
  * If @match_state is nonzero, it's the @p->state value just checked and
@@ -5985,7 +5970,7 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 		goto out;
 
 	dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
-	if (need_migrate_task(p)) {
+	if (p->on_rq) {
 		struct migration_arg arg = { p, dest_cpu };
 		/* Need help from migration thread: drop lock and wait. */
 		task_rq_unlock(rq, p, &flags);

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555Ab1DNIgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:36:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:49674 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436Ab1DNIgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:36:20 -0400
Date: Thu, 14 Apr 2011 08:35:59 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-a8e4f2eaecc9bfa4954adf79a04f4f22fddd829c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        frank.rowand@am.sony.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110405152729.151523907@chello.nl>
References: <20110405152729.151523907@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/locking] sched: Delay task_contributes_to_load()
Git-Commit-ID: a8e4f2eaecc9bfa4954adf79a04f4f22fddd829c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Apr 2011 08:35:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a8e4f2eaecc9bfa4954adf79a04f4f22fddd829c
Gitweb:     http://git.kernel.org/tip/a8e4f2eaecc9bfa4954adf79a04f4f22fddd829c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 Apr 2011 17:23:49 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Apr 2011 08:52:37 +0200

sched: Delay task_contributes_to_load()

In prepratation of having to call task_contributes_to_load() without
holding rq->lock, we need to store the result until we do and can
update the rq accounting accordingly.

Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110405152729.151523907@chello.nl
---
 include/linux/sched.h |    1 +
 kernel/sched.c        |   16 ++++------------
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7f5732f..25c5031 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1273,6 +1273,7 @@ struct task_struct {
 
 	/* Revert to default priority/policy when forking */
 	unsigned sched_reset_on_fork:1;
+	unsigned sched_contributes_to_load:1;
 
 	pid_t pid;
 	pid_t tgid;
diff --git a/kernel/sched.c b/kernel/sched.c
index 7a5eb26..fd32b78 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2519,18 +2519,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	if (unlikely(task_running(rq, p)))
 		goto out_activate;
 
-	/*
-	 * In order to handle concurrent wakeups and release the rq->lock
-	 * we put the task in TASK_WAKING state.
-	 *
-	 * First fix up the nr_uninterruptible count:
-	 */
-	if (task_contributes_to_load(p)) {
-		if (likely(cpu_online(orig_cpu)))
-			rq->nr_uninterruptible--;
-		else
-			this_rq()->nr_uninterruptible--;
-	}
+	p->sched_contributes_to_load = !!task_contributes_to_load(p);
 	p->state = TASK_WAKING;
 
 	if (p->sched_class->task_waking) {
@@ -2555,6 +2544,9 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	WARN_ON(task_cpu(p) != cpu);
 	WARN_ON(p->state != TASK_WAKING);
 
+	if (p->sched_contributes_to_load)
+		rq->nr_uninterruptible--;
+
 out_activate:
 #endif /* CONFIG_SMP */
 	ttwu_activate(rq, p, en_flags);

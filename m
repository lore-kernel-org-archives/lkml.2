Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525Ab1DNIgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:36:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:49650 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436Ab1DNIf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:35:59 -0400
Date: Thu, 14 Apr 2011 08:35:07 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-74f8e4b2335de45485b8d5b31a504747f13c8070@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        frank.rowand@am.sony.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110405152729.071474242@chello.nl>
References: <20110405152729.071474242@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/locking] sched: Remove rq argument to sched_class::task_waking()
Git-Commit-ID: 74f8e4b2335de45485b8d5b31a504747f13c8070
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Apr 2011 08:35:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  74f8e4b2335de45485b8d5b31a504747f13c8070
Gitweb:     http://git.kernel.org/tip/74f8e4b2335de45485b8d5b31a504747f13c8070
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 Apr 2011 17:23:47 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Apr 2011 08:52:36 +0200

sched: Remove rq argument to sched_class::task_waking()

In preparation of calling this without rq->lock held, remove the
dependency on the rq argument.

Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110405152729.071474242@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |   10 +++++++---
 kernel/sched.c        |    2 +-
 kernel/sched_fair.c   |    4 +++-
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ff4e2f9..7f5732f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1048,8 +1048,12 @@ struct sched_domain;
 #define WF_FORK		0x02		/* child wakeup after fork */
 
 #define ENQUEUE_WAKEUP		1
-#define ENQUEUE_WAKING		2
-#define ENQUEUE_HEAD		4
+#define ENQUEUE_HEAD		2
+#ifdef CONFIG_SMP
+#define ENQUEUE_WAKING		4	/* sched_class::task_waking was called */
+#else
+#define ENQUEUE_WAKING		0
+#endif
 
 #define DEQUEUE_SLEEP		1
 
@@ -1071,7 +1075,7 @@ struct sched_class {
 
 	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
 	void (*post_schedule) (struct rq *this_rq);
-	void (*task_waking) (struct rq *this_rq, struct task_struct *task);
+	void (*task_waking) (struct task_struct *task);
 	void (*task_woken) (struct rq *this_rq, struct task_struct *task);
 
 	void (*set_cpus_allowed)(struct task_struct *p,
diff --git a/kernel/sched.c b/kernel/sched.c
index d4b815d..46f42ca 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2531,7 +2531,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	p->state = TASK_WAKING;
 
 	if (p->sched_class->task_waking) {
-		p->sched_class->task_waking(rq, p);
+		p->sched_class->task_waking(p);
 		en_flags |= ENQUEUE_WAKING;
 	}
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 96b2c95..ad4c414f 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1372,11 +1372,13 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 
 #ifdef CONFIG_SMP
 
-static void task_waking_fair(struct rq *rq, struct task_struct *p)
+static void task_waking_fair(struct task_struct *p)
 {
 	struct sched_entity *se = &p->se;
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
+	lockdep_assert_held(&task_rq(p)->lock);
+
 	se->vruntime -= cfs_rq->min_vruntime;
 }
 

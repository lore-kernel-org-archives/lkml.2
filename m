Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564Ab1DNIgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:36:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:49664 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757199Ab1DNIgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:36:03 -0400
Date: Thu, 14 Apr 2011 08:35:34 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-3fe1698b7fe05aeb063564e71e40d09f28d8e80c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        frank.rowand@am.sony.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110405152729.111378493@chello.nl>
References: <20110405152729.111378493@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/locking] sched: Deal with non-atomic min_vruntime reads on 32bits
Git-Commit-ID: 3fe1698b7fe05aeb063564e71e40d09f28d8e80c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Apr 2011 08:35:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3fe1698b7fe05aeb063564e71e40d09f28d8e80c
Gitweb:     http://git.kernel.org/tip/3fe1698b7fe05aeb063564e71e40d09f28d8e80c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 Apr 2011 17:23:48 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Apr 2011 08:52:37 +0200

sched: Deal with non-atomic min_vruntime reads on 32bits

In order to avoid reading partial updated min_vruntime values on 32bit
implement a seqcount like solution.

Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110405152729.111378493@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      |    3 +++
 kernel/sched_fair.c |   19 +++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 46f42ca..7a5eb26 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -312,6 +312,9 @@ struct cfs_rq {
 
 	u64 exec_clock;
 	u64 min_vruntime;
+#ifndef CONFIG_64BIT
+	u64 min_vruntime_copy;
+#endif
 
 	struct rb_root tasks_timeline;
 	struct rb_node *rb_leftmost;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index ad4c414f..054cebb 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -358,6 +358,10 @@ static void update_min_vruntime(struct cfs_rq *cfs_rq)
 	}
 
 	cfs_rq->min_vruntime = max_vruntime(cfs_rq->min_vruntime, vruntime);
+#ifndef CONFIG_64BIT
+	smp_wmb();
+	cfs_rq->min_vruntime_copy = cfs_rq->min_vruntime;
+#endif
 }
 
 /*
@@ -1376,10 +1380,21 @@ static void task_waking_fair(struct task_struct *p)
 {
 	struct sched_entity *se = &p->se;
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+	u64 min_vruntime;
 
-	lockdep_assert_held(&task_rq(p)->lock);
+#ifndef CONFIG_64BIT
+	u64 min_vruntime_copy;
 
-	se->vruntime -= cfs_rq->min_vruntime;
+	do {
+		min_vruntime_copy = cfs_rq->min_vruntime_copy;
+		smp_rmb();
+		min_vruntime = cfs_rq->min_vruntime;
+	} while (min_vruntime != min_vruntime_copy);
+#else
+	min_vruntime = cfs_rq->min_vruntime;
+#endif
+
+	se->vruntime -= min_vruntime;
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED

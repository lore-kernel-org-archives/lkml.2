Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109Ab1DNIcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:32:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:47103 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373Ab1DNIcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:32:51 -0400
Date: Thu, 14 Apr 2011 08:32:28 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-c2f7115e2e52a6c187b8c1f54f0e4970bb677be0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tj@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tj@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/locking] sched: Move wq_worker_waking to the correct site
Git-Commit-ID: c2f7115e2e52a6c187b8c1f54f0e4970bb677be0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Apr 2011 08:32:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c2f7115e2e52a6c187b8c1f54f0e4970bb677be0
Gitweb:     http://git.kernel.org/tip/c2f7115e2e52a6c187b8c1f54f0e4970bb677be0
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 13 Apr 2011 13:28:56 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Apr 2011 08:52:33 +0200

sched: Move wq_worker_waking to the correct site

wq_worker_waking_up() needs to match wq_worker_sleeping(), since the
latter is only called on deactivate, move the former near activate.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/n/top-t3m7n70n9frmv4pv2n5fwmov@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 55cc503..81ab58e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2421,6 +2421,10 @@ static inline void ttwu_activate(struct task_struct *p, struct rq *rq,
 		schedstat_inc(p, se.statistics.nr_wakeups_remote);
 
 	activate_task(rq, p, en_flags);
+
+	/* if a worker is waking up, notify workqueue */
+	if (p->flags & PF_WQ_WORKER)
+		wq_worker_waking_up(p, cpu_of(rq));
 }
 
 static inline void ttwu_post_activation(struct task_struct *p, struct rq *rq,
@@ -2445,9 +2449,6 @@ static inline void ttwu_post_activation(struct task_struct *p, struct rq *rq,
 		rq->idle_stamp = 0;
 	}
 #endif
-	/* if a worker is waking up, notify workqueue */
-	if ((p->flags & PF_WQ_WORKER) && success)
-		wq_worker_waking_up(p, cpu_of(rq));
 }
 
 /**

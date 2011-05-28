Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab1E1Qfu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 12:35:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:32818 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab1E1Qft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 12:35:49 -0400
Date: Sat, 28 May 2011 16:35:30 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-1e876231785d82443a5ac8b6c660e9f51bc5dede@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, peterz@infradead.org,
        john.stultz@linaro.org, dima@android.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, efault@gmx.de,
        john.stultz@linaro.org, dima@android.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1305674470-23727-1-git-send-email-john.stultz@linaro.org>
References: <1305674470-23727-1-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix ->min_vruntime calculation in dequeue_entity()
Git-Commit-ID: 1e876231785d82443a5ac8b6c660e9f51bc5dede
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 28 May 2011 16:35:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e876231785d82443a5ac8b6c660e9f51bc5dede
Gitweb:     http://git.kernel.org/tip/1e876231785d82443a5ac8b6c660e9f51bc5dede
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 17 May 2011 16:21:10 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 28 May 2011 17:02:56 +0200

sched: Fix ->min_vruntime calculation in dequeue_entity()

Dima Zavin <dima@android.com> reported:

"After pulling the thread off the run-queue during a cgroup change,
the cfs_rq.min_vruntime gets recalculated. The dequeued thread's vruntime
then gets normalized to this new value. This can then lead to the thread
getting an unfair boost in the new group if the vruntime of the next
task in the old run-queue was way further ahead."

Reported-by: Dima Zavin <dima@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Recalls-having-tested-once-upon-a-time-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1305674470-23727-1-git-send-email-john.stultz@linaro.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index e32a9b7..433491c 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1076,8 +1076,6 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	se->on_rq = 0;
 	update_cfs_load(cfs_rq, 0);
 	account_entity_dequeue(cfs_rq, se);
-	update_min_vruntime(cfs_rq);
-	update_cfs_shares(cfs_rq);
 
 	/*
 	 * Normalize the entity after updating the min_vruntime because the
@@ -1086,6 +1084,9 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 */
 	if (!(flags & DEQUEUE_SLEEP))
 		se->vruntime -= cfs_rq->min_vruntime;
+
+	update_min_vruntime(cfs_rq);
+	update_cfs_shares(cfs_rq);
 }
 
 /*

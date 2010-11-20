Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab0KTCKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 21:10:04 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57518 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756567Ab0KTCJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 21:09:22 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Dima Zavin <dima@android.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 5/5] sched: use the old min_vruntime when normalizing on dequeue
Date: Fri, 19 Nov 2010 18:08:54 -0800
Message-Id: <1290218934-8544-6-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1290218934-8544-1-git-send-email-john.stultz@linaro.org>
References: <1290218934-8544-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dima Zavin <dima@android.com>

After pulling the thread off the run-queue during a cgroup change,
the cfs_rq.min_vruntime gets recalculated. The dequeued thread's vruntime
then gets normalized to this new value. This can then lead to the thread
getting an unfair boost in the new group if the vruntime of the next
task in the old run-queue was way further ahead.

CC: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>
Cc: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Dima Zavin <dima@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/sched_fair.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index f4f6a83..72f19ad 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -802,6 +802,8 @@ static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
 static void
 dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 {
+	u64 min_vruntime;
+
 	/*
 	 * Update run-time statistics of the 'current'.
 	 */
@@ -826,6 +828,8 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	if (se != cfs_rq->curr)
 		__dequeue_entity(cfs_rq, se);
 	account_entity_dequeue(cfs_rq, se);
+
+	min_vruntime = cfs_rq->min_vruntime;
 	update_min_vruntime(cfs_rq);
 
 	/*
@@ -834,7 +838,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * movement in our normalized position.
 	 */
 	if (!(flags & DEQUEUE_SLEEP))
-		se->vruntime -= cfs_rq->min_vruntime;
+		se->vruntime -= min_vruntime;
 }
 
 /*
-- 
1.7.3.2.146.gca209


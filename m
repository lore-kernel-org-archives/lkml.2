Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab0I2Gqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 02:46:37 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15627 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab0I2Gqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 02:46:35 -0400
From: Dima Zavin <dima@android.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Dima Zavin <dima@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH 2/2] sched: use the old min_vruntime when normalizing on dequeue
Date: Tue, 28 Sep 2010 23:46:14 -0700
Message-Id: <1285742774-5013-2-git-send-email-dima@android.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1285742774-5013-1-git-send-email-dima@android.com>
References: <1285742774-5013-1-git-send-email-dima@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After pulling the thread off the run-queue during a cgroup change,
the cfs_rq.min_vruntime gets recalculated. The dequeued thread's vruntime
then gets normalized to this new value. This can then lead to the thread
getting an unfair boost in the new group if the vruntime of the next
task in the old run-queue was way further ahead.

Cc: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Dima Zavin <dima@android.com>
---
 kernel/sched_fair.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 008fe57..cb24ddb 100644
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
1.6.6


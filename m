Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab1EQXVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 19:21:23 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:49204 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618Ab1EQXVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 19:21:22 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Dima Zavin <dima@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [RFC][PATCH] sched: Fix min_vruntime calculation in dequeue_entity
Date: Tue, 17 May 2011 16:21:10 -0700
Message-Id: <1305674470-23727-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

Peter had sent this patch out in response to a patch from Dima Zavin
<dima@android.com> which tried to address the following issue:

"After pulling the thread off the run-queue during a cgroup change,
the cfs_rq.min_vruntime gets recalculated. The dequeued thread's vruntime
then gets normalized to this new value. This can then lead to the thread
getting an unfair boost in the new group if the vruntime of the next
task in the old run-queue was way further ahead."

Peter suggested the following fix instead.

The full thread can be found here:
https://lkml.org/lkml/2010/11/20/34

While Dima never replied publicly, I bugged him a few weeks ago
and he said that this fix should address his original issue.

I just wanted to resend this patch out so the fix was not missed.

CC: Dima Zavin <dima@android.com>
CC: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/sched_fair.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 6fa833a..fb321dc 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1072,8 +1072,6 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	se->on_rq = 0;
 	update_cfs_load(cfs_rq, 0);
 	account_entity_dequeue(cfs_rq, se);
-	update_min_vruntime(cfs_rq);
-	update_cfs_shares(cfs_rq);
 
 	/*
 	 * Normalize the entity after updating the min_vruntime because the
@@ -1082,6 +1080,9 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 */
 	if (!(flags & DEQUEUE_SLEEP))
 		se->vruntime -= cfs_rq->min_vruntime;
+
+	update_min_vruntime(cfs_rq);
+	update_cfs_shares(cfs_rq);
 }
 
 /*
-- 
1.7.3.2.146.gca209


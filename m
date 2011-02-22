Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab1BVVEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:04:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:38728 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116Ab1BVVEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:04:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,207,1297065600"; 
   d="scan'208";a="711922422"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        richard.purdie@linuxfoundation.org, dvhart@linux.intel.com
Subject: [PATCH 1/2] sched: allow SCHED_BATCH to preempt SCHED_IDLE tasks
Date: Tue, 22 Feb 2011 13:04:33 -0800
Message-Id: <1298408674-3130-2-git-send-email-dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1298408674-3130-1-git-send-email-dvhart@linux.intel.com>
References: <1298408674-3130-1-git-send-email-dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perform the test for SCHED_IDLE before testing for SCHED_BATCH (and ensure idle
tasks don't preempt idle tasks) so the non-interactive, but still important,
SCHED_BATCH tasks will run in favor of the very low priority SCHED_IDLE tasks.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Richard Purdie <richard.purdie@linuxfoundation.org>
---
 kernel/sched_fair.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 0c26e2d..ff04bbd 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1857,16 +1857,18 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	if (test_tsk_need_resched(curr))
 		return;
 
+	/* Idle tasks are by definition preempted by non-idle tasks. */
+	if (unlikely(curr->policy == SCHED_IDLE) &&
+	    likely(p->policy != SCHED_IDLE))
+		goto preempt;
+
 	/*
-	 * Batch and idle tasks do not preempt (their preemption is driven by
-	 * the tick):
+	 * Batch and idle tasks do not preempt non-idle tasks (their preemption
+	 * is driven by the tick):
 	 */
 	if (unlikely(p->policy != SCHED_NORMAL))
 		return;
 
-	/* Idle tasks are by definition preempted by everybody. */
-	if (unlikely(curr->policy == SCHED_IDLE))
-		goto preempt;
 
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
-- 
1.7.1


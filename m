Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab3AHEz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 23:55:57 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41416 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab3AHEz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 23:55:56 -0500
From: Zhu Yanhai <gaoyang.zyh@taobao.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Zhu Yanhai <gaoyang.zyh@taobao.com>
Subject: [PATCH] sched: fix the broken sched_rr_get_interval()
Date: Tue,  8 Jan 2013 12:56:52 +0800
Message-Id: <1357621012-15039-1-git-send-email-gaoyang.zyh@taobao.com>
X-Mailer: git-send-email 1.8.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The caller of sched_sliced() should pass se.cfs_rq and se as the arguments, 
however in sched_rr_get_interval() we gave it rq.cfs_rq and se, which made
the following compution obviously wrong.

The change was introduced by commit 77034937, while it had been correct 'cfs_rq_of'
before the commit. Besides the change seems to be irrelevant to the commit
msg, which was to return a 0 timeslice for tasks that are on an idle runqueue.
So I believe that was just a plain typo.

Signed-off-by: Zhu Yanhai <gaoyang.zyh@taobao.com>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5eea870..a7a19ff 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6101,7 +6101,7 @@ static unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task
 	 * idle runqueue:
 	 */
 	if (rq->cfs.load.weight)
-		rr_interval = NS_TO_JIFFIES(sched_slice(&rq->cfs, se));
+		rr_interval = NS_TO_JIFFIES(sched_slice(cfs_rq_of(se), se));
 
 	return rr_interval;
 }
-- 
1.8.0.1


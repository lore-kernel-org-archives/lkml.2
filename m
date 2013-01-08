Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab3AHBHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 20:07:44 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:35890 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab3AHBHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 20:07:43 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] sched: Remove broken check for skip clock update
Date: Tue,  8 Jan 2013 02:07:34 +0100
Message-Id: <1357607254-511-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rq->skip_clock_update shouldn't be negative. Thus the check
in put_prev_task() is useless.

It was probably intended to do the following check:

	if (prev->on_rq && !rq->skip_clock_update)

We only want to update the clock if the current task is
not voluntarily sleeping: otherwise deactivate_task()
already did the rq clock update in schedule(). But we want
to ignore that update if a ttwu did it for us, in which case
rq->skip_clock_update is 1.

But update_rq_clock() already takes care of that so we
can just remove the broken condition.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 15ba35e..8dfc461 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2886,7 +2886,7 @@ static inline void schedule_debug(struct task_struct *prev)
 
 static void put_prev_task(struct rq *rq, struct task_struct *prev)
 {
-	if (prev->on_rq || rq->skip_clock_update < 0)
+	if (prev->on_rq)
 		update_rq_clock(rq);
 	prev->sched_class->put_prev_task(rq, prev);
 }
-- 
1.7.5.4


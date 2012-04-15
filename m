Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200Ab2DOToD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 15:44:03 -0400
Received: from forward9.mail.yandex.net ([77.88.61.48]:59484 "EHLO
	forward9.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab2DOToC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 15:44:02 -0400
Message-ID: <1334519122.8698.3.camel@hp>
Subject: [sched/rt] Optimization of function pull_rt_task()
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Sun, 15 Apr 2012 23:45:22 +0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The condition (src_rq->rt.rt_nr_running) is weak because it doesn't
consider the cases when src_rq has only processes bound to it (when
single cpu is allowed). It may be running kernel thread like
migration/x etc.

So it's better to use more stronger condition which is able to exclude
above conditions. The function has_pushable_tasks() complitely does
this. A task may be pullable for another cpu rq only if he is pushable
for his own queue.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
---
 kernel/sched/rt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index c5565c3..61e3086 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1729,7 +1729,7 @@ static int pull_rt_task(struct rq *this_rq)
 		/*
 		 * Are there still pullable RT tasks?
 		 */
-		if (src_rq->rt.rt_nr_running <= 1)
+		if (!has_pushable_tasks(src_rq))
 			goto skip;
 
 		p = pick_next_highest_task_rt(src_rq, this_cpu);



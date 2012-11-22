Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab2KVUgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:36:43 -0500
Received: from forward5h.mail.yandex.net ([84.201.186.23]:38587 "EHLO
	forward5h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617Ab2KVUgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:36:41 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Tkhai Kirill <tkhai@yandex.ru>
Subject: [PATCH]sched/rt.c: Don't pull tasks to throttled rt_rq's
MIME-Version: 1.0
Message-Id: <973291353616584@web24h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 23 Nov 2012 00:36:24 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The most probably, next after pull_rt_task action will be picking a task
from the rq. So it's useless to pull tasks whose (corresponding to rq)
rt_rq is throttled.

Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/rt.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 418feb0..10863e4 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1708,6 +1708,16 @@ static void push_rt_tasks(struct rq *rq)
 		;
 }
 
+static inline int remote_rt_rq_throttled(struct task_struct *p, int remote_cpu)
+{
+	struct rt_rq *rt_rq = rt_rq_of_se(&p->rt);
+	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
+
+	rt_rq = sched_rt_period_rt_rq(rt_b, remote_cpu);
+
+	return rt_rq_throttled(rt_rq);
+}
+
 static int pull_rt_task(struct rq *this_rq)
 {
 	int this_cpu = this_rq->cpu, ret = 0, cpu;
@@ -1768,6 +1778,9 @@ static int pull_rt_task(struct rq *this_rq)
 			if (p->prio < src_rq->curr->prio)
 				goto skip;
 
+			if (remote_rt_rq_throttled(p, this_cpu))
+				goto skip;
+
 			ret = 1;
 
 			deactivate_task(src_rq, p, 0);

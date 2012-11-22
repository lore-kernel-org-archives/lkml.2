Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab2KVUCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:02:35 -0500
Received: from forward15.mail.yandex.net ([95.108.130.119]:42114 "EHLO
	forward15.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965225Ab2KVUC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:02:29 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Tkhai Kirill <tkhai@yandex.ru>
Subject: [PATCH]sched/rt.c: Add reschedule to switched_from_rt()
MIME-Version: 1.0
Message-Id: <118761353614535@web28f.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 23 Nov 2012 00:02:15 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reschedule rq->curr if the first RT task has just been
pulled to the rq.

Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/rt.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 418feb0..29bda5b 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1889,8 +1889,11 @@ static void switched_from_rt(struct rq *rq, struct task_struct *p)
 	 * we may need to handle the pulling of RT tasks
 	 * now.
 	 */
-	if (p->on_rq && !rq->rt.rt_nr_running)
-		pull_rt_task(rq);
+	if (!p->on_rq || rq->rt.rt_nr_running)
+		return;
+
+	if (pull_rt_task(rq))
+		resched_task(rq->curr);
 }
 
 void init_sched_rt_class(void)

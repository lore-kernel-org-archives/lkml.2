Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab1FEJyI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 05:54:08 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64033 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab1FEJyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 05:54:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=dKx4Bf2e72yMxDKzvM48V2c4NChKb+HsZvISLUnB6Y+bdlkc8+iE6uDxXMGvzbMcQG
         FWxIlwIbSXknAtr3sILUaM9R+K2iGpc8QtYhR/91EALuPVFIosFMQoh/wa5pjLbi1Qdo
         LbDuL3fjPcCLzyh2HJq20nqj3EgnmFQiisEj0=
MIME-Version: 1.0
Date: Sun, 5 Jun 2011 17:54:04 +0800
Message-ID: <BANLkTint_00+oHVGpgV4n4E2A9W5O8nJxA@mail.gmail.com>
Subject: [PATCH] sched: update cpupri for runqueue when its priority changes
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the priority of runqueue changes, lower or higer, the info of cpupri
should be updated, in cases such as pick_next_task_rt() and switched_to_rt().

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---
 kernel/sched_rt.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 08e9374..9508168 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1158,6 +1158,8 @@ static struct task_struct
*pick_next_task_rt(struct rq *rq)
 	 * lock again later if there is no need to push
 	 */
 	rq->post_schedule = has_pushable_tasks(rq);
+
+	cpupri_set(&rq->rd->cpupri, rq->cpu, p == NULL ? MAX_RT_PRIO : p->prio);
 #endif

 	return p;
@@ -1673,6 +1675,8 @@ static void switched_to_rt(struct rq *rq, struct
task_struct *p)
 {
 	int check_resched = 1;

+	if (!p->on_rq)
+		return;
 	/*
 	 * If we are already running, then there's nothing
 	 * that needs to be done. But if we are not running
@@ -1680,7 +1684,7 @@ static void switched_to_rt(struct rq *rq, struct
task_struct *p)
 	 * If that current running task is also an RT task
 	 * then see if we can move to another run queue.
 	 */
-	if (p->on_rq && rq->curr != p) {
+	if (rq->curr != p) {
 #ifdef CONFIG_SMP
 		if (rq->rt.overloaded && push_rt_task(rq) &&
 		    /* Don't resched if we changed runqueues */
@@ -1690,6 +1694,11 @@ static void switched_to_rt(struct rq *rq,
struct task_struct *p)
 		if (check_resched && p->prio < rq->curr->prio)
 			resched_task(rq->curr);
 	}
+	else {
+#ifdef CONFIG_SMP
+		cpupri_set(&rq->rd->cpupri, rq->cpu, p->prio);
+#endif
+	}
 }

 /*

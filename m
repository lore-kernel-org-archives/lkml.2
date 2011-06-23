Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab1FWNnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 09:43:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65490 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab1FWNnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 09:43:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=ihsKRbNCp6xMSGdF/fAAHzKfdGJP5fMLNXuWEK0n4oLaTUek0ZVoQuzw8QK8uJN8nh
         18heSyLI7kVO1/MKWYtCeTxqABuhFG4knlKEmM6bk3SIwlj8XEWuMeganirSaujGswAz
         51SBNyl81SgD3IQJdpjs/oVF8J4NAySGqScC4=
MIME-Version: 1.0
Date: Thu, 23 Jun 2011 21:43:19 +0800
Message-ID: <BANLkTin8EF5ZpWmXKGwbZqTf5+GZBBFhfQ@mail.gmail.com>
Subject: [RFC] sched: update rto_mask for RT runqueue
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven

Since {de, en}queue_pushable_task() is not always accompanied with
{dec, inc}_rt_migration(), when the last pushable RT task on RQ is picked in
pick_next_task_rt(), we have to update rto_mask for the RQ in question, which
helps puller that is guided by rto_mask.

Thanks,

Hillf
---
 kernel/sched_rt.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index b03cd89..4daf0ae 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -96,6 +96,15 @@ static void update_rt_migration(struct rt_rq *rt_rq)
 	}
 }

+static void update_rt_migratory(struct rt_rq *rt_rq, int inc)
+{
+	if (inc)
+		rt_rq->rt_nr_migratory++;
+	else
+		rt_rq->rt_nr_migratory--;
+	update_rt_migration(rt_rq);
+}
+
 static void inc_rt_migration(struct sched_rt_entity *rt_se, struct
rt_rq *rt_rq)
 {
 	if (!rt_entity_is_task(rt_se))
@@ -1148,11 +1157,13 @@ static struct task_struct
*pick_next_task_rt(struct rq *rq)
 {
 	struct task_struct *p = _pick_next_task_rt(rq);

+#ifdef CONFIG_SMP
 	/* The running task is never eligible for pushing */
-	if (p)
+	if (p && p->rt.nr_cpus_allowed > 1) {
 		dequeue_pushable_task(rq, p);
+		update_rt_migratory(&rq->rt, 0);
+	}

-#ifdef CONFIG_SMP
 	/*
 	 * We detect this state here so that we can avoid taking the RQ
 	 * lock again later if there is no need to push
@@ -1168,12 +1179,16 @@ static void put_prev_task_rt(struct rq *rq,
struct task_struct *p)
 	update_curr_rt(rq);
 	p->se.exec_start = 0;

+#ifdef CONFIG_SMP
 	/*
 	 * The previous task needs to be made eligible for pushing
 	 * if it is still active
 	 */
-	if (on_rt_rq(&p->rt) && p->rt.nr_cpus_allowed > 1)
+	if (on_rt_rq(&p->rt) && p->rt.nr_cpus_allowed > 1) {
 		enqueue_pushable_task(rq, p);
+		update_rt_migratory(&rq->rt, 1);
+	}
+#endif
 }

 #ifdef CONFIG_SMP

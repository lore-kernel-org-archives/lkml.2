Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab2DHD5e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 23:57:34 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52454 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab2DHD5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 23:57:33 -0400
MIME-Version: 1.0
Date: Sun, 8 Apr 2012 11:57:31 +0800
Message-ID: <CAJd=RBBGDjV8TYEe8Ni01DHecO=FfpfqpWQKu_fgc9L2ZtWeMw@mail.gmail.com>
Subject: [PATCH] DLS: refactor pick_next_earliest_dl_task
From: Hillf Danton <dhillf@gmail.com>
To: Dario Faggioli <raistlin@linux.it>, Juri Lelli <juri.lelli@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dunno who created dmin for puller, it is great:)

Now it is expanded to change how to pick the next earliest task, and we end
up with pulling as less as possible.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched_dl.c	Sat Apr  7 15:00:28 2012
+++ b/kernel/sched_dl.c	Sun Apr  8 11:37:04 2012
@@ -569,11 +569,12 @@ static void update_curr_dl(struct rq *rq

 #ifdef CONFIG_SMP

-static struct task_struct *pick_next_earliest_dl_task(struct rq *rq, int cpu);
+static struct task_struct *pick_next_earliest_dl_task(struct rq *rq, int cpu,
+							u64 ref_deadline);

 static inline int next_deadline(struct rq *rq)
 {
-	struct task_struct *next = pick_next_earliest_dl_task(rq, rq->cpu);
+	struct task_struct *next = pick_next_earliest_dl_task(rq, rq->cpu, -1ULL);

 	if (next && dl_prio(next->prio))
 		return next->dl.deadline;
@@ -1033,18 +1034,25 @@ static int pick_dl_task(struct rq *rq, s
 }

 /* Returns the second earliest -deadline task, NULL otherwise */
-static struct task_struct *pick_next_earliest_dl_task(struct rq *rq, int cpu)
+static struct task_struct *pick_next_earliest_dl_task(struct rq *rq, int cpu,
+							u64 ref_deadline)
 {
 	struct rb_node *next_node = rq->dl.rb_leftmost;
 	struct sched_dl_entity *dl_se;
 	struct task_struct *p = NULL;

+	if (!next_node)
+		return NULL;
+
 next_node:
 	next_node = rb_next(next_node);
 	if (next_node) {
 		dl_se = rb_entry(next_node, struct sched_dl_entity, rb_node);
 		p = dl_task_of(dl_se);

+		if (!dl_time_before(p->dl.deadline, ref_deadline))
+			return NULL;
+
 		if (pick_dl_task(rq, p, cpu))
 			return p;

@@ -1320,7 +1328,7 @@ static int pull_dl_task(struct rq *this_
 		if (src_rq->dl.dl_nr_running <= 1)
 			goto skip;

-		p = pick_next_earliest_dl_task(src_rq, this_cpu);
+		p = pick_next_earliest_dl_task(src_rq, this_cpu, dmin);

 		/*
 		 * We found a task to be pulled if:
--

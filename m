Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab1GNNn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 09:43:58 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35855 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab1GNNn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 09:43:57 -0400
MIME-Version: 1.0
Date: Thu, 14 Jul 2011 21:43:55 +0800
Message-ID: <CAJd=RBCB-GZh9jtWMkuJHQ5wJRJkMyCONh5JGH=DMpfco5juYg@mail.gmail.com>
Subject: [Question] sched: migrate RT task on throttled leaf RT runqueue?
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven

When a non-boosted RT task is enqueued, if it is attached to task group, as
shown in the following diff format for clarity, and even if the RT runqueue
owned by the task group is throttled, the rt_rq is loaded up as leaf and the
task is added to pushable list if it is pushable.

Since RT tasks on throttled rt_runqueue will not be picked to be the next task
when scheduling, could they be migrated by pushing and pulling?

Thanks,

Hillf
---
 kernel/sched_rt.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 97540f0..8489953 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -882,6 +882,9 @@ static void __enqueue_rt_entity(struct
sched_rt_entity *rt_se, bool head)
 	if (group_rq && (rt_rq_throttled(group_rq) || !group_rq->rt_nr_running))
 		return;

+	/* if (rt_rq_throttled(rt_rq) && !rt_se_boosted(rt_se))
+		return; */
+
 	if (!rt_rq->rt_nr_running)
 		list_add_leaf_rt_rq(rt_rq);

@@ -1418,6 +1421,9 @@ retry:
 		return 0;
 	}

+	if (rt_rq_throttled(rt_rq_of_se(&next_task->rt)))
+		return 0;
+
 	/* We might release rq lock */
 	get_task_struct(next_task);

@@ -1519,6 +1525,9 @@ static int pull_rt_task(struct rq *this_rq)

 		p = pick_next_highest_task_rt(src_rq, this_cpu);

+		if (p && rt_rq_throttled(rt_rq_of_se(&p->rt)))
+			goto skip;
+
 		/*
 		 * Do we have an RT task that preempts
 		 * the to-be-scheduled task?

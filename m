Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab1FCOLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:11:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51490 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab1FCOL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:11:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=U+/xehy0YWOYPxlpXLE9e3WKnBUeWgAqmEuIWHCDS30qVqnjzbGgawgIm4a3nqOy8u
         3wc/Adid/SZl2Yv8/CkDvuBXg/hEuIXqnQsblc+UlNX0SrNiFZKHLww8mp8qR2ngwFuH
         EDrtnNuVzBk7hAQIrVPWsciNNaenAyJCKQKAo=
MIME-Version: 1.0
Date: Fri, 3 Jun 2011 22:11:27 +0800
Message-ID: <BANLkTikNYY3zKM+VUF3AbTTD0idZnt3w=Q@mail.gmail.com>
Subject: [PATCH] sched: find all lowest run-queues for RT task
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When finding the lowest run-queue for a given RT task, as seen in cases such as
select_task_rq_rt() and find_lock_lowest_rq(), RQs with no RT tasks are also
eligible for both RR and FIFO RT tasks.

Minor change is added, when initializing cpupri, to record non-RT RQs which are
upated automatically, due to the cool design and implementation of cpupri, when
RT RQs are set and unset. Then they could be included in the selected CPUs by
cpupri_find().

A call for cpupri_set() is also added when a RQ has no RT task to run.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---
 kernel/sched_cpupri.c |    4 +++-
 kernel/sched_rt.c     |    4 ++++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index 2722dc1..d4c0b46 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -181,8 +181,10 @@ int cpupri_init(struct cpupri *cp)
 			goto cleanup;
 	}

-	for_each_possible_cpu(i)
+	for_each_possible_cpu(i) {
 		cp->cpu_to_pri[i] = CPUPRI_INVALID;
+		cpupri_set(cp, i, MAX_RT_PRIO);
+	}
 	return 0;

 cleanup:
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 88725c9..4dd6e45 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1158,6 +1158,10 @@ static struct task_struct
*pick_next_task_rt(struct rq *rq)
 	 * lock again later if there is no need to push
 	 */
 	rq->post_schedule = has_pushable_tasks(rq);
+
+	/* this CPU is no longer RT if no task picked to feed it */
+	if (! p)
+		cpupri_set(&rq->rd->cpupri, rq->cpu, MAX_RT_PRIO);
 #endif

 	return p;

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab2DRVQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 17:16:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33580 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab2DRVQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 17:16:56 -0400
X-Authority-Analysis: v=2.0 cv=V/z/IJbi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=JomeGkWH5N8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=4gbOhSyqIKWju5T05RMA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334783815.28106.56.camel@gandalf.stny.rr.com>
Subject: Re: [sched/rt] Optimization of function pull_rt_task()
From: Steven Rostedt <rostedt@goodmis.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Date: Wed, 18 Apr 2012 17:16:55 -0400
In-Reply-To: <1334773976.28106.49.camel@gandalf.stny.rr.com>
References: <1334519122.8698.3.camel@hp>
	 <1334592379.28106.4.camel@gandalf.stny.rr.com>
	 <1334773976.28106.49.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-18 at 14:32 -0400, Steven Rostedt wrote:
> On Mon, 2012-04-16 at 12:06 -0400, Steven Rostedt wrote:
> > On Sun, 2012-04-15 at 23:45 +0400, Kirill Tkhai wrote:
> > > The condition (src_rq->rt.rt_nr_running) is weak because it doesn't
> > > consider the cases when src_rq has only processes bound to it (when
> > > single cpu is allowed). It may be running kernel thread like
> > > migration/x etc.
> > > 
> > > So it's better to use more stronger condition which is able to exclude
> > > above conditions. The function has_pushable_tasks() complitely does
> > > this. A task may be pullable for another cpu rq only if he is pushable
> > > for his own queue.
> > 
> > I considered this before, and for some reason I never did the change.
> > I'll have to think about it. It seems like this would be the obvious
> > case, but I think there was something not so obvious that caused issues.
> > But I don't remember what it was.
> > 
> > I'll have to rethink this again.
> 
> I can't find anything wrong with this change. Maybe things change, or I
> was thinking of another change.
> 
> I'll apply it and start running my tests against it.

Not only does this seem to work fine, I took it one step further :-)

Peter, do you see anything wrong with this patch?

-- Steve

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 61e3086..b44fd1b 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1416,39 +1416,15 @@ static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
 /* Return the second highest RT task, NULL otherwise */
 static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu)
 {
-	struct task_struct *next = NULL;
-	struct sched_rt_entity *rt_se;
-	struct rt_prio_array *array;
-	struct rt_rq *rt_rq;
-	int idx;
+	struct plist_head *head = &rq->rt.pushable_tasks;
+	struct task_struct *next;
 
-	for_each_leaf_rt_rq(rt_rq, rq) {
-		array = &rt_rq->active;
-		idx = sched_find_first_bit(array->bitmap);
-next_idx:
-		if (idx >= MAX_RT_PRIO)
-			continue;
-		if (next && next->prio <= idx)
-			continue;
-		list_for_each_entry(rt_se, array->queue + idx, run_list) {
-			struct task_struct *p;
-
-			if (!rt_entity_is_task(rt_se))
-				continue;
-
-			p = rt_task_of(rt_se);
-			if (pick_rt_task(rq, p, cpu)) {
-				next = p;
-				break;
-			}
-		}
-		if (!next) {
-			idx = find_next_bit(array->bitmap, MAX_RT_PRIO, idx+1);
-			goto next_idx;
-		}
+	plist_for_each_entry(next, head, pushable_tasks) {
+		if (pick_rt_task(rq, next, cpu))
+			return next;
 	}
 
-	return next;
+	return NULL;
 }
 
 static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask);



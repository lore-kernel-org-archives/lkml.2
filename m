Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab2LRKnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 05:43:47 -0500
Received: from forward5h.mail.yandex.net ([84.201.186.23]:57559 "EHLO
	forward5h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab2LRKnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 05:43:45 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: Steven Rostedt <rostedt@goodmis.org>, Yong Zhang <yong.zhang0@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1353011758.18025.123.camel@gandalf.local.home>
References: <1334519122.8698.3.camel@hp>
	 <1334592379.28106.4.camel@gandalf.stny.rr.com>
	 <1334773976.28106.49.camel@gandalf.stny.rr.com>
	 <1334783815.28106.56.camel@gandalf.stny.rr.com> <20120419085440.GC3963@zhy>
	 <69791338569116@web3f.yandex.ru> <20120604052755.GA28710@zhy> <1353011758.18025.123.camel@gandalf.local.home>
Subject: Re: [sched/rt] Optimization of function pull_rt_task()
MIME-Version: 1.0
Message-Id: <1675831355827421@web30h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 18 Dec 2012 14:43:41 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



16.11.2012, 00:36, "Steven Rostedt" <rostedt@goodmis.org>:
> Doing my INBOX maintenance (clean up), I've stumbled on this thread
> again. I'm not sure the changes here are hopeless.
>
> On Mon, 2012-06-04 at 13:27 +0800, Yong Zhang wrote:
>
>> šOn Fri, Jun 01, 2012 at 08:45:16PM +0400, Kirill Tkhai wrote:
>>> š19.04.2012, 12:54, "Yong Zhang" <yong.zhang0@gmail.com>:
>>>> šOn Wed, Apr 18, 2012 at 05:16:55PM -0400, Steven Rostedt wrote:
>>>>> š?On Wed, 2012-04-18 at 14:32 -0400, Steven Rostedt wrote:
>>>>>> š?On Mon, 2012-04-16 at 12:06 -0400, Steven Rostedt wrote:
>>>>>>> š?On Sun, 2012-04-15 at 23:45 +0400, Kirill Tkhai wrote:
>>>>>>>> š?The condition (src_rq->rt.rt_nr_running) is weak because it doesn't
>>>>>>>> š?consider the cases when src_rq has only processes bound to it (when
>>>>>>>> š?single cpu is allowed). It may be running kernel thread like
>>>>>>>> š?migration/x etc.
>>>>>>>>
>>>>>>>> š?So it's better to use more stronger condition which is able to exclude
>>>>>>>> š?above conditions. The function has_pushable_tasks() complitely does
>>>>>>>> š?this. A task may be pullable for another cpu rq only if he is pushable
>>>>>>>> š?for his own queue.
>>>>>>> š?I considered this before, and for some reason I never did the change.
>>>>>>> š?I'll have to think about it. It seems like this would be the obvious
>>>>>>> š?case, but I think there was something not so obvious that caused issues.
>>>>>>> š?But I don't remember what it was.
>>>>>>>
>>>>>>> š?I'll have to rethink this again.
>>>>>> š?I can't find anything wrong with this change. Maybe things change, or I
>>>>>> š?was thinking of another change.
>>>>>>
>>>>>> š?I'll apply it and start running my tests against it.
>>>>> š?Not only does this seem to work fine, I took it one step further :-)
>>>> šHmm... throttle doesn't handle the pushable list, so we may find a
>>>> šthrottled task by pick_next_pushable_task().
>>>>
>>>> šThanks,
>>>> šYong
>>> šI don't complitelly understand throttle logic.
>>>
>>> šIs the source patch not-appliable the same reason?
>> šI guess so.
>>
>> šYour patch will change the semantic of pick_next_pushable_task().
>
> Looking at the original patch, I don't see how it changes the semantics
> (although mine may have). The original patch was:
>
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1729,7 +1729,7 @@ static int pull_rt_task(struct rq *this_rq)
> šššššššššššššššš/*
> ššššššššššššššššš* Are there still pullable RT tasks?
> ššššššššššššššššš*/
> - ššššššššššššššif (src_rq->rt.rt_nr_running <= 1)
> + ššššššššššššššif (!has_pushable_tasks(src_rq))
> ššššššššššššššššššššššššgoto skip;
>
> ššššššššššššššššp = pick_next_highest_task_rt(src_rq, this_cpu);
>
> And I still don't see a problem with this. If a rq has no pushable
> tasks, then we shouldn't bother trying to pull from it (no task can
> migrate).
>
> Thus, the original patch, I believe should be applied without question.
>
> Now, about my patch, the one that made pick_next_highest_task_rt into
> just:
>
> static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu)
> {
> šššššššstruct plist_head *head = &rq->rt.pushable_tasks;
> šššššššstruct task_struct *next;
>
> šššššššplist_for_each_entry(next, head, pushable_tasks) {
> ššššššššššššššif (pick_rt_task(rq, next, cpu))
> ššššššššššššššššššššššreturn next;
> ššššššš}
>
> šššššššreturn NULL;
> }
>
> You said could pick a task from a throttled rq. I'm not sure that is
> different than what we have now. As the current
> pick_next_highest_task_rt() just does a loop over the leaf_rt_rqs which
> includes throttled rqs. That's because a throttled rq will not dequeue
> the rt_rq from the leaf_rt_rq list if the rt_rq has rt_nr_running != 0.

Yes, there is no connection between logic of pushable tasks and throttling at the moment.
These activities are independent. ( I tried to connect them at the patch:
http://lkml.indiana.edu/hypermail/linux/kernel/1211.2/03750.html )

I think, there is no problem.

Kirill

>
> I'm still thinking about adding both patches.
>
> -- Steve
>
>> šThanks,
>> šYong
>>> šKirill
>>>>> š?Peter, do you see anything wrong with this patch?
>>>>>
>>>>> š?-- Steve
>>>>>
>>>>> š?diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
>>>>> š?index 61e3086..b44fd1b 100644
>>>>> š?--- a/kernel/sched/rt.c
>>>>> š?+++ b/kernel/sched/rt.c
>>>>> š?@@ -1416,39 +1416,15 @@ static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
>>>>> š??/* Return the second highest RT task, NULL otherwise */
>>>>> š??static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu)
>>>>> š??{
>>>>> š?- struct task_struct *next = NULL;
>>>>> š?- struct sched_rt_entity *rt_se;
>>>>> š?- struct rt_prio_array *array;
>>>>> š?- struct rt_rq *rt_rq;
>>>>> š?- int idx;
>>>>> š?+ struct plist_head *head = &rq->rt.pushable_tasks;
>>>>> š?+ struct task_struct *next;
>>>>>
>>>>> š?- for_each_leaf_rt_rq(rt_rq, rq) {
>>>>> š?- array = &rt_rq->active;
>>>>> š?- idx = sched_find_first_bit(array->bitmap);
>>>>> š?-next_idx:
>>>>> š?- if (idx >= MAX_RT_PRIO)
>>>>> š?- continue;
>>>>> š?- if (next && next->prio <= idx)
>>>>> š?- continue;
>>>>> š?- list_for_each_entry(rt_se, array->queue + idx, run_list) {
>>>>> š?- struct task_struct *p;
>>>>> š?-
>>>>> š?- if (!rt_entity_is_task(rt_se))
>>>>> š?- continue;
>>>>> š?-
>>>>> š?- p = rt_task_of(rt_se);
>>>>> š?- if (pick_rt_task(rq, p, cpu)) {
>>>>> š?- next = p;
>>>>> š?- break;
>>>>> š?- }
>>>>> š?- }
>>>>> š?- if (!next) {
>>>>> š?- idx = find_next_bit(array->bitmap, MAX_RT_PRIO, idx+1);
>>>>> š?- goto next_idx;
>>>>> š?- }
>>>>> š?+ plist_for_each_entry(next, head, pushable_tasks) {
>>>>> š?+ if (pick_rt_task(rq, next, cpu))
>>>>> š?+ return next;
>>>>> š??????????}
>>>>>
>>>>> š?- return next;
>>>>> š?+ return NULL;
>>>>> š??}
>>>>>
>>>>> š??static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask);
>>>>>
>>>>> š?--
>>>>> š?To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>>>> š?the body of a message to majordomo@vger.kernel.org
>>>>> š?More majordomo info at ?http://vger.kernel.org/majordomo-info.html
>>>>> š?Please read the FAQ at ?http://www.tux.org/lkml/
>>>> š--
>>>> šOnly stand for myself
>>> š--
>>> šTo unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> šthe body of a message to majordomo@vger.kernel.org
>>> šMore majordomo info at šhttp://vger.kernel.org/majordomo-info.html
>>> šPlease read the FAQ at šhttp://www.tux.org/lkml/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965565Ab2FAQzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 12:55:19 -0400
Received: from forward14.mail.yandex.net ([95.108.130.92]:47954 "EHLO
	forward14.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965541Ab2FAQzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 12:55:17 -0400
X-Greylist: delayed 596 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Jun 2012 12:55:16 EDT
From: Kirill Tkhai <tkhai@yandex.ru>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20120419085440.GC3963@zhy>
References: <1334519122.8698.3.camel@hp>
 <1334592379.28106.4.camel@gandalf.stny.rr.com>
 <1334773976.28106.49.camel@gandalf.stny.rr.com>
 <1334783815.28106.56.camel@gandalf.stny.rr.com> <20120419085440.GC3963@zhy>
Subject: Re: [sched/rt] Optimization of function pull_rt_task()
MIME-Version: 1.0
Message-Id: <69791338569116@web3f.yandex.ru>
Date: Fri, 01 Jun 2012 20:45:16 +0400
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



19.04.2012, 12:54, "Yong Zhang" <yong.zhang0@gmail.com>:
> On Wed, Apr 18, 2012 at 05:16:55PM -0400, Steven Rostedt wrote:
>
>> šOn Wed, 2012-04-18 at 14:32 -0400, Steven Rostedt wrote:
>>> šOn Mon, 2012-04-16 at 12:06 -0400, Steven Rostedt wrote:
>>>> šOn Sun, 2012-04-15 at 23:45 +0400, Kirill Tkhai wrote:
>>>>> šThe condition (src_rq->rt.rt_nr_running) is weak because it doesn't
>>>>> šconsider the cases when src_rq has only processes bound to it (when
>>>>> šsingle cpu is allowed). It may be running kernel thread like
>>>>> šmigration/x etc.
>>>>>
>>>>> šSo it's better to use more stronger condition which is able to exclude
>>>>> šabove conditions. The function has_pushable_tasks() complitely does
>>>>> šthis. A task may be pullable for another cpu rq only if he is pushable
>>>>> šfor his own queue.
>>>> šI considered this before, and for some reason I never did the change.
>>>> šI'll have to think about it. It seems like this would be the obvious
>>>> šcase, but I think there was something not so obvious that caused issues.
>>>> šBut I don't remember what it was.
>>>>
>>>> šI'll have to rethink this again.
>>> šI can't find anything wrong with this change. Maybe things change, or I
>>> šwas thinking of another change.
>>>
>>> šI'll apply it and start running my tests against it.
>> šNot only does this seem to work fine, I took it one step further :-)
>
> Hmm... throttle doesn't handle the pushable list, so we may find a
> throttled task by pick_next_pushable_task().
>
> Thanks,
> Yong

I don't complitelly understand throttle logic.

Is the source patch not-appliable the same reason?

Kirill

>
>> šPeter, do you see anything wrong with this patch?
>>
>> š-- Steve
>>
>> šdiff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
>> šindex 61e3086..b44fd1b 100644
>> š--- a/kernel/sched/rt.c
>> š+++ b/kernel/sched/rt.c
>> š@@ -1416,39 +1416,15 @@ static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
>> šš/* Return the second highest RT task, NULL otherwise */
>> ššstatic struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu)
>> šš{
>> š- struct task_struct *next = NULL;
>> š- struct sched_rt_entity *rt_se;
>> š- struct rt_prio_array *array;
>> š- struct rt_rq *rt_rq;
>> š- int idx;
>> š+ struct plist_head *head = &rq->rt.pushable_tasks;
>> š+ struct task_struct *next;
>>
>> š- for_each_leaf_rt_rq(rt_rq, rq) {
>> š- array = &rt_rq->active;
>> š- idx = sched_find_first_bit(array->bitmap);
>> š-next_idx:
>> š- if (idx >= MAX_RT_PRIO)
>> š- continue;
>> š- if (next && next->prio <= idx)
>> š- continue;
>> š- list_for_each_entry(rt_se, array->queue + idx, run_list) {
>> š- struct task_struct *p;
>> š-
>> š- if (!rt_entity_is_task(rt_se))
>> š- continue;
>> š-
>> š- p = rt_task_of(rt_se);
>> š- if (pick_rt_task(rq, p, cpu)) {
>> š- next = p;
>> š- break;
>> š- }
>> š- }
>> š- if (!next) {
>> š- idx = find_next_bit(array->bitmap, MAX_RT_PRIO, idx+1);
>> š- goto next_idx;
>> š- }
>> š+ plist_for_each_entry(next, head, pushable_tasks) {
>> š+ if (pick_rt_task(rq, next, cpu))
>> š+ return next;
>> šššššššššš}
>>
>> š- return next;
>> š+ return NULL;
>> šš}
>>
>> ššstatic DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask);
>>
>> š--
>> šTo unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> šthe body of a message to majordomo@vger.kernel.org
>> šMore majordomo info at šhttp://vger.kernel.org/majordomo-info.html
>> šPlease read the FAQ at šhttp://www.tux.org/lkml/
> --
> Only stand for myself

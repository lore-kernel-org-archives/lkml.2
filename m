Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab2FDF2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 01:28:14 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40106 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab2FDF2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 01:28:13 -0400
Date: Mon, 4 Jun 2012 13:27:55 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [sched/rt] Optimization of function pull_rt_task()
Message-ID: <20120604052755.GA28710@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1334519122.8698.3.camel@hp>
 <1334592379.28106.4.camel@gandalf.stny.rr.com>
 <1334773976.28106.49.camel@gandalf.stny.rr.com>
 <1334783815.28106.56.camel@gandalf.stny.rr.com>
 <20120419085440.GC3963@zhy>
 <69791338569116@web3f.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <69791338569116@web3f.yandex.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 08:45:16PM +0400, Kirill Tkhai wrote:
> 
> 
> 19.04.2012, 12:54, "Yong Zhang" <yong.zhang0@gmail.com>:
> > On Wed, Apr 18, 2012 at 05:16:55PM -0400, Steven Rostedt wrote:
> >
> >> ?On Wed, 2012-04-18 at 14:32 -0400, Steven Rostedt wrote:
> >>> ?On Mon, 2012-04-16 at 12:06 -0400, Steven Rostedt wrote:
> >>>> ?On Sun, 2012-04-15 at 23:45 +0400, Kirill Tkhai wrote:
> >>>>> ?The condition (src_rq->rt.rt_nr_running) is weak because it doesn't
> >>>>> ?consider the cases when src_rq has only processes bound to it (when
> >>>>> ?single cpu is allowed). It may be running kernel thread like
> >>>>> ?migration/x etc.
> >>>>>
> >>>>> ?So it's better to use more stronger condition which is able to exclude
> >>>>> ?above conditions. The function has_pushable_tasks() complitely does
> >>>>> ?this. A task may be pullable for another cpu rq only if he is pushable
> >>>>> ?for his own queue.
> >>>> ?I considered this before, and for some reason I never did the change.
> >>>> ?I'll have to think about it. It seems like this would be the obvious
> >>>> ?case, but I think there was something not so obvious that caused issues.
> >>>> ?But I don't remember what it was.
> >>>>
> >>>> ?I'll have to rethink this again.
> >>> ?I can't find anything wrong with this change. Maybe things change, or I
> >>> ?was thinking of another change.
> >>>
> >>> ?I'll apply it and start running my tests against it.
> >> ?Not only does this seem to work fine, I took it one step further :-)
> >
> > Hmm... throttle doesn't handle the pushable list, so we may find a
> > throttled task by pick_next_pushable_task().
> >
> > Thanks,
> > Yong
> 
> I don't complitelly understand throttle logic.
> 
> Is the source patch not-appliable the same reason?

I guess so.

Your patch will change the semantic of pick_next_pushable_task().

Thanks,
Yong

> 
> Kirill
> 
> >
> >> ?Peter, do you see anything wrong with this patch?
> >>
> >> ?-- Steve
> >>
> >> ?diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> >> ?index 61e3086..b44fd1b 100644
> >> ?--- a/kernel/sched/rt.c
> >> ?+++ b/kernel/sched/rt.c
> >> ?@@ -1416,39 +1416,15 @@ static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
> >> ??/* Return the second highest RT task, NULL otherwise */
> >> ??static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu)
> >> ??{
> >> ?- struct task_struct *next = NULL;
> >> ?- struct sched_rt_entity *rt_se;
> >> ?- struct rt_prio_array *array;
> >> ?- struct rt_rq *rt_rq;
> >> ?- int idx;
> >> ?+ struct plist_head *head = &rq->rt.pushable_tasks;
> >> ?+ struct task_struct *next;
> >>
> >> ?- for_each_leaf_rt_rq(rt_rq, rq) {
> >> ?- array = &rt_rq->active;
> >> ?- idx = sched_find_first_bit(array->bitmap);
> >> ?-next_idx:
> >> ?- if (idx >= MAX_RT_PRIO)
> >> ?- continue;
> >> ?- if (next && next->prio <= idx)
> >> ?- continue;
> >> ?- list_for_each_entry(rt_se, array->queue + idx, run_list) {
> >> ?- struct task_struct *p;
> >> ?-
> >> ?- if (!rt_entity_is_task(rt_se))
> >> ?- continue;
> >> ?-
> >> ?- p = rt_task_of(rt_se);
> >> ?- if (pick_rt_task(rq, p, cpu)) {
> >> ?- next = p;
> >> ?- break;
> >> ?- }
> >> ?- }
> >> ?- if (!next) {
> >> ?- idx = find_next_bit(array->bitmap, MAX_RT_PRIO, idx+1);
> >> ?- goto next_idx;
> >> ?- }
> >> ?+ plist_for_each_entry(next, head, pushable_tasks) {
> >> ?+ if (pick_rt_task(rq, next, cpu))
> >> ?+ return next;
> >> ??????????}
> >>
> >> ?- return next;
> >> ?+ return NULL;
> >> ??}
> >>
> >> ??static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask);
> >>
> >> ?--
> >> ?To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> ?the body of a message to majordomo@vger.kernel.org
> >> ?More majordomo info at ?http://vger.kernel.org/majordomo-info.html
> >> ?Please read the FAQ at ?http://www.tux.org/lkml/
> > --
> > Only stand for myself
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Only stand for myself

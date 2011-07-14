Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab1GNO6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 10:58:11 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:35036 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280Ab1GNO6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 10:58:09 -0400
MIME-Version: 1.0
In-Reply-To: <1310652552.27864.25.camel@gandalf.stny.rr.com>
References: <CAJd=RBCB-GZh9jtWMkuJHQ5wJRJkMyCONh5JGH=DMpfco5juYg@mail.gmail.com>
	<1310652552.27864.25.camel@gandalf.stny.rr.com>
Date: Thu, 14 Jul 2011 22:58:07 +0800
Message-ID: <CAJd=RBC6O2KojRghA5gNWOmTeXaznr=UwKVonu482GcHqKxxQw@mail.gmail.com>
Subject: Re: [Question] sched: migrate RT task on throttled leaf RT runqueue?
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 10:09 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2011-07-14 at 21:43 +0800, Hillf Danton wrote:
>> Hi Steven
>>
>> When a non-boosted RT task is enqueued, if it is attached to task group, as
>> shown in the following diff format for clarity, and even if the RT runqueue
>> owned by the task group is throttled, the rt_rq is loaded up as leaf and the
>> task is added to pushable list if it is pushable.
>>
>> Since RT tasks on throttled rt_runqueue will not be picked to be the next task
>> when scheduling, could they be migrated by pushing and pulling?
>
> Note, run queues are not throttled, groups are. And tasks on a throttled
> group should not be touched by the push/pull algorithm.
>

Task group is one of the hard to understand in RT scheduler, according to the
following two functions, if task group is throttled, could say its ->rt_rq[cpu]
also throttled, where cpu could be anyone of the active_cpu_mask?

And how to relate rt_rq_throttled(p->rt.rt_rq) to throttled task group?

Thanks,
	Hillf

/* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
{
#ifdef CONFIG_FAIR_GROUP_SCHED
	p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
	p->se.parent = task_group(p)->se[cpu];
#endif

#ifdef CONFIG_RT_GROUP_SCHED
	p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
	p->rt.parent = task_group(p)->rt_se[cpu];
#endif
}

static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
{
	return rt_se->rt_rq;
}

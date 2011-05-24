Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab1EXNsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:48:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39534 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244Ab1EXNsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:48:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ojnBlDMbrb4GU0jqTqsnLtdpSulpdNr63YTDg/AjdKHymel7H8GPuW95r2ZBGGaEZx
         qMskhig54OaJhvfZU4vNnZLAqYJD7KYIiEouI/FV8F339PJ83ZLHP2LT3SO6zo2yAnQo
         IVdmhwi3N57r28DG8EPnonK9aYK8Qb3uANKEc=
MIME-Version: 1.0
In-Reply-To: <1306243872.1465.55.camel@gandalf.stny.rr.com>
References: <BANLkTimF2d93VVGKHDdFTn=V-1h9nWrs_w@mail.gmail.com>
	<1306243872.1465.55.camel@gandalf.stny.rr.com>
Date: Tue, 24 May 2011 21:48:50 +0800
Message-ID: <BANLkTi=zVEGS3m7rh8GtD+tX3vqJtNx5Sg@mail.gmail.com>
Subject: Re: [PATCH v0] sched: change how run-queue is selected for RT task
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 9:31 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Sat, 2011-05-21 at 23:28 +0800, Hillf Danton wrote:
>> When selecting run-queue for a given RT task, we have to take a few
>> factors, such as task priority and CPU cache affinity, into
>> consideration. In this work, a simpler method is proposed, which is
>> focusing on the relation between the current run-queue of the given
>> task and the given run-queue.
>>
>> If the current run-queue of task is the given run-queue, the run-queue
>> of task keeps unchanged, so the CPU cache affinities of both task and
>> the current task of run-queue remain unchanged. Then there are at
>> least two tasks competing one CPU, and in the worst case that both
>> competitors are RT tasks the victim will be selected and processed by
>> pusher later.
>>
>> On other hand, if the current run-queue of task is different from the
>> given run-queue, task is simply delivered to its current run-queue,
>> since pusher is always willing to do hard works.
>>
>> In summary, the burden of RT task is always processed first by the
>> pusher of its current run-queue.
>
> Why? Why should we preempt a high prio task to make it push off a task
> that has just woken up on its CPU? If we know that we are about to
> preempt a high prio RT task, why interrupt it, when we could simply make
> this task wake up on another CPU?
>
Hi Steve

Lets check what Peter did,

static int
select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
{
	struct task_struct *curr;
	struct rq *rq;
	int cpu;

	if (sd_flag != SD_BALANCE_WAKE)
		return smp_processor_id();

	cpu = task_cpu(p);
	rq = cpu_rq(cpu);

	rcu_read_lock();
	curr = ACCESS_ONCE(rq->curr); /* unlocked access */

	/*
	 * If the current task on @p's runqueue is an RT task, then
	 * try to see if we can wake this RT task up on another
	 * runqueue. Otherwise simply start this RT task
	 * on its current runqueue.
	 *
	 * We want to avoid overloading runqueues. If the woken
	 * task is a higher priority, then it will stay on this CPU
	 * and the lower prio task should be moved to another CPU.
	 * Even though this will probably make the lower prio task
	 * lose its cache, we do not want to bounce a higher task
	 * around just because it gave up its CPU, perhaps for a
	 * lock?
	 *
	 * For equal prio tasks, we just let the scheduler sort it out.
	 *
	 * Otherwise, just let it ride on the affined RQ and the
	 * post-schedule router will push the preempted task away
	 *
	 * This test is optimistic, if we get it wrong the load-balancer
	 * will have to sort it out.
	 */
	if (curr && unlikely(rt_task(curr)) &&
	    (curr->rt.nr_cpus_allowed < 2 ||
	     curr->prio < p->prio) &&
	    (p->rt.nr_cpus_allowed > 1)) {
		int target = find_lowest_rq(p);

		if (target != -1)
			cpu = target;

Here the priority of curr is check, why not further check the priority of
next task on RQ?
If target CPU is valid, why not push next task first if it is also pushable
and if its been waiting for a couple of weeks on RQ?

The key point seems to be starvation, am I right?

	}
	rcu_read_unlock();

	return cpu;
}

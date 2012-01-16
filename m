Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab2API1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 03:27:48 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35302 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab2API1r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 03:27:47 -0500
MIME-Version: 1.0
In-Reply-To: <4F13D77B.9070103@linux.vnet.ibm.com>
References: <CADZ9YHicin2YjGm_m9B0LMv3NW1Z3cb7HSCaqwycFmVfRpvpWA@mail.gmail.com>
	<1326302955.2442.174.camel@twins>
	<CADZ9YHiC8732D=D8KpkT0d+81_BNdAvj0ZJLwL5mhyq9OPLW0Q@mail.gmail.com>
	<1326353130.2442.177.camel@twins>
	<CADZ9YHiGjjGJjxKj4WKWydqAz0zxFwY5=LsYBKhEREuZm=bKpg@mail.gmail.com>
	<4F13D77B.9070103@linux.vnet.ibm.com>
Date: Mon, 16 Jan 2012 14:27:47 +0600
Message-ID: <CADZ9YHiNWddjLBGnvDO==Jpz9nQtPREmkFOX0P5ELOK2neW1=g@mail.gmail.com>
Subject: Re: [Question] sched: Should nr_uninterruptible be decremented in ttwu_do_activate()?
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 1:53 PM, Michael Wang
<wangyun@linux.vnet.ibm.com> wrote:
> On 01/13/2012 01:08 AM, Rakib Mullick wrote:
>
>> On Thu, Jan 12, 2012 at 1:25 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>>> On Thu, 2012-01-12 at 12:09 +0600, Rakib Mullick wrote:
>>>> On Wed, Jan 11, 2012 at 11:29 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>>>>> On Wed, 2012-01-11 at 23:22 +0600, Rakib Mullick wrote:
>>>>>> Hello all,
>>>>>>
>>>>>> In ttwu_do_activate(), we're decrementing nr_uninterruptible if
>>>>>> p->sched_contributes_to_load (for SMP=y). But, we're also decrementing
>>>>>> nr_uninterruptible from activate_task at the same path. Why we're
>>>>>> doing it twice for a single task activation path?
>>>>>
>>>>> activate_task() does:
>>>>>
>>>>>  if (task_contributes_to_load(p))
>>>>>   rq->nr_uninterruptible--;
>>>>>
>>>>> Now task_contributes_to_load() reads like:
>>>>>
>>>>> #define task_contributes_to_load(task)  \
>>>>>                                ((task->state & TASK_UNINTERRUPTIBLE) != 0 && \
>>>>>                                 (task->flags & PF_FREEZING) == 0)
>>>>>
>>>>> which will be false, since we've set TASK_WAKING.
>>>>
>>>> Enough confusing. TASK_WAKING will be set when called from
>>>> try_to_wake_up(). ttwu_do_activate() gets called from other places:
>>>> scheduler_ipi() and sched_ttwu_pending() (at the time of cpu goes
>>>> down). TASK_WAKING will be not set at that time,
>>>
>>> Yes it will be, the only way to get on that list is throught
>>> ttwu_queue_remote() at which point tasks are TASK_WAKING.
>>>
>>>>  moreover it is
>>>> possible that, task has p->sched_contributes_to_load is set and latter
>>>> on gets wake up by sched_ttwu_pending/scheduler_ipi() call.
>>>
>>> That's the entire point. But all ways to ttwu_queue_remote() explicitly
>>> set ->sched_contributes_to_load.
>>
>> That might be the case for scheduler_ipi(), but when
>> sched_ttwu_pending() gets called when a cpu goes down, all tasks from
>> wake_list of that cpu has been moved without TASK_WAKING is set. For a
>
>
> I think the task in rq->wake_list should already have state:TASK_WAKING,
> because it's a wake list.
>
But, what I got by means of TASK_WAKING is this task is about to RUN,
very soon it'll have TASK_RUNNING state. And, if I hadn't miss any
portion of code, then rq->wake_list doesn't have TASK_WAKING state.

Thanks,
Rakib

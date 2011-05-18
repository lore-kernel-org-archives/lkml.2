Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786Ab1ERCRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 22:17:38 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61145 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932703Ab1ERCRh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 22:17:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YPfYg4BXSnf9tM3PkEjdNg6NXNQvVzEE95K5HGqtvGZweT3BSnw6Kp6QUwsSoH7ZSY
         6A/L468YnES/zlAN2VisEaOMd5NQ+Mw2KD31x+NYK093gEVGQfSElrdwkrW8GglZdlEf
         eAx6m84VI3953n/KFFL6CIvKy3Xr+uloA+nQY=
MIME-Version: 1.0
In-Reply-To: <20110518011413.GA23940@home.goodmis.org>
References: <BANLkTikqKnQgyLr0OmL86iEHE95xB4Z50Q@mail.gmail.com>
	<BANLkTim=di8pbt1CzHjHYSC0SbtgJzbmkw@mail.gmail.com>
	<BANLkTimgmam0_yg+5a58T3R_NYM6RQLakQ@mail.gmail.com>
	<20110518011413.GA23940@home.goodmis.org>
Date: Wed, 18 May 2011 10:17:36 +0800
Message-ID: <BANLkTi=SKmLgobD4-KjM5GhUc0e+b7ONjg@mail.gmail.com>
Subject: Re: [PATCH] sched: fix priority leakage in pick_next_highest_task_rt()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hillf Danton <dhillf@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 9:14 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, May 17, 2011 at 10:53:22PM +0800, Hillf Danton wrote:
>> On Tue, May 17, 2011 at 10:28 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:
>> > On Mon, May 16, 2011 at 8:55 PM, Hillf Danton <dhillf@gmail.com> wrote:
>> >> When picking the second highest RT task for a given runqueue, if no
>> >> task found after scanning the queue of priority == idx, the next idx
>> >> should also be checked even in case that next is already existing, or
>> >> the window of priority leakage could be opened.
>> >
>> > I don't see what kind of problem you patch will fix.
>> > And mind explaining how priority leakage could happen?
>> >
>> Hi Yong
>>
>> If no task is found after scanning the list at array->queue + idx,
>> what should we operate on next?
>> And why is the list scanned?
>>
>
> The patch looks correct.
>
> The code looks like so:
>
>        for_each_leaf_rt_rq(rt_rq, rq) {
>                array = &rt_rq->active;
>                idx = sched_find_first_bit(array->bitmap);
> next_idx:
>                if (idx >= MAX_RT_PRIO)
>                        continue;
>                if (next && next->prio < idx)
>                        continue;
>                list_for_each_entry(rt_se, array->queue + idx, run_list) {
>                        struct task_struct *p;
>
>                        if (!rt_entity_is_task(rt_se))
>                                continue;
>
>                        p = rt_task_of(rt_se);
>                        if (pick_rt_task(rq, p, cpu)) {
>                                next = p;
>                                break;
>                        }
>                }
>                if (!next) {
>                        idx = find_next_bit(array->bitmap, MAX_RT_PRIO, idx+1);
>                        goto next_idx;
>                }
>        }
>
> What we are doing is looking for the next highest prio task that we can
> migrate. When we find the next highest priority task that can migrate,
> we pick it. But the issue comes with the cgroups. If we are looping
> through the cgroups, and we pick a task in one cgroup, but when we check
> the next cgroup, if it has a higher priority task, but that task can't
> migrate, but the next one, also of higher priority, can, that "if (!next)"
> wont catch it.

Yup, I misread the patch at the first time.

Now I think Hillf's patch is correct.

Thanks for your explanation Steven.

Thanks,
Yong

>
> Although, I don't know the cgroup code very well, and I wonder what it
> means to pull a task from a run queue onto another run queue that has
> dropped in priority.
>
> But, anyway, for the patch:
>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
>
> -- Steve
>
>



-- 
Only stand for myself

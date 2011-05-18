Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689Ab1ERBOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 21:14:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58321 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab1ERBOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 21:14:15 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=XYJHFtupD_QA:10 a=3O0Z2-0QvKMA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=uf42mgzF8abT2wY_PNEA:9 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Tue, 17 May 2011 21:14:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] sched: fix priority leakage in
 pick_next_highest_task_rt()
Message-ID: <20110518011413.GA23940@home.goodmis.org>
References: <BANLkTikqKnQgyLr0OmL86iEHE95xB4Z50Q@mail.gmail.com>
 <BANLkTim=di8pbt1CzHjHYSC0SbtgJzbmkw@mail.gmail.com>
 <BANLkTimgmam0_yg+5a58T3R_NYM6RQLakQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimgmam0_yg+5a58T3R_NYM6RQLakQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 10:53:22PM +0800, Hillf Danton wrote:
> On Tue, May 17, 2011 at 10:28 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> > On Mon, May 16, 2011 at 8:55 PM, Hillf Danton <dhillf@gmail.com> wrote:
> >> When picking the second highest RT task for a given runqueue, if no
> >> task found after scanning the queue of priority == idx, the next idx
> >> should also be checked even in case that next is already existing, or
> >> the window of priority leakage could be opened.
> >
> > I don't see what kind of problem you patch will fix.
> > And mind explaining how priority leakage could happen?
> >
> Hi Yong
> 
> If no task is found after scanning the list at array->queue + idx,
> what should we operate on next?
> And why is the list scanned?
> 

The patch looks correct.

The code looks like so:

	for_each_leaf_rt_rq(rt_rq, rq) {
		array = &rt_rq->active;
		idx = sched_find_first_bit(array->bitmap);
next_idx:
		if (idx >= MAX_RT_PRIO)
			continue;
		if (next && next->prio < idx)
			continue;
		list_for_each_entry(rt_se, array->queue + idx, run_list) {
			struct task_struct *p;

			if (!rt_entity_is_task(rt_se))
				continue;

			p = rt_task_of(rt_se);
			if (pick_rt_task(rq, p, cpu)) {
				next = p;
				break;
			}
		}
		if (!next) {
			idx = find_next_bit(array->bitmap, MAX_RT_PRIO, idx+1);
			goto next_idx;
		}
	}

What we are doing is looking for the next highest prio task that we can
migrate. When we find the next highest priority task that can migrate,
we pick it. But the issue comes with the cgroups. If we are looping
through the cgroups, and we pick a task in one cgroup, but when we check
the next cgroup, if it has a higher priority task, but that task can't
migrate, but the next one, also of higher priority, can, that "if (!next)"
wont catch it.

Although, I don't know the cgroup code very well, and I wonder what it
means to pull a task from a run queue onto another run queue that has
dropped in priority.

But, anyway, for the patch:

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


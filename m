Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab1KAICX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 04:02:23 -0400
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:40440 "EHLO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab1KAICT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 04:02:19 -0400
MIME-Version: 1.0
Date: Tue, 1 Nov 2011 16:02:15 +0800
Message-ID: <CAFf0ej7_cZEs29yYQSMP1dtk5Urs_OyfrWeeO7UOhgsYYJXLdg@mail.gmail.com>
Subject: question about kernel panic related to sched_rt.c
From: MING ZHOU <a17711@motorola.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  all,

 May I ask a question about scheduler (sched_rt.c)? I want to make
sure a patch related  in kernel-linux mailing list is valid or not.

 https://lkml.org/lkml/2011/8/14/71

 I encountered a kernel panic recently which caused by BUG_ON in
pick_next_pushable_task ( my kernel version is 2.6.35, on arm-omap
platform).

static struct task_struct *pick_next_pushable_task(struct rq *rq)
{
  ...
    BUG_ON(task_current(rq, p));  <------------ panic here!!!
  ...
}

<4>[17583.180664] [<c00a3888>] (pick_next_pushable_task+0x4c/0xa4)
from [<c00ae21c>] (push_rt_task+0x20/0x264)
<4>[17583.180725] [<c00ae21c>] (push_rt_task+0x20/0x264) from
[<c00ae554>] (post_schedule_rt+0x14/0x20)
<4>[17583.180816] [<c00ae554>] (post_schedule_rt+0x14/0x20) from
[<c069352c>] (schedule+0x738/0x7c8)


 I checked patch history related to push_rt_task, and I think the
following patch may be the reason, since if dequeue task improperly,
it may ruin task pointer by mistake.

 https://lkml.org/lkml/2011/8/14/71

Commit-ID:  311e800e16f63d909136a64ed17ca353a160be59
Author:     Hillf Danton <dhillf@gmail.com>

sched, rt: Fix rq->rt.pushable_tasks bug in push_rt_task()

Do not call dequeue_pushable_task() when failing to push an eligible
task, as it remains pushable, merely not at this particular moment.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Mike Galbraith <mgalbraith@gmx.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Yong Zhang <yong.zhang0@gmail.com>

And I also noticed in commit history of sched_rt.c, I found the
similar patch is submitted before at 2008.
However, it was not picked up in latest kernel code.  So, I am
wondering whether this patch is valid?

commit 1563513d34ed4b12ef32bc2adde4a53ce05701a1
Author: Gregory Haskins <ghaskins@novell.com>
Date:   Mon Dec 29 09:39:53 2008 -0500

RT: fix push_rt_task() to handle dequeue_pushable properly

 A panic was discovered by Chirag Jog where a BUG_ON sanity check
 in the new "pushable_task" logic would trigger a panic under
 certain circumstances:

 http://lkml.org/lkml/2008/9/25/189

 Gilles Carry discovered that the root cause was attributed to the
 pushable_tasks list getting corrupted in the push_rt_task logic.
 This was the result of a dropped rq lock in double_lock_balance
 allowing a task in the process of being pushed to potentially migrate
 away, and thus corrupt the pushable_tasks() list.

 I traced back the problem as introduced by the pushable_tasks patch
 that went in recently.   There is a "retry" path in push_rt_task()
 that actually had a compound conditional to decide whether to
 retry or exit.  I missed the meaning behind the rationale for the
 virtual "if(!task) goto out;" portion of the compound statement and
 thus did not handle it properly.  The new pushable_tasks logic
 actually creates three distinct conditions:

 1) an untouched and unpushable task should be dequeued
 2) a migrated task where more pushable tasks remain should be retried
 3) a migrated task where no more pushable tasks exist should exit

 The original logic mushed (1) and (3) together, resulting in the
 system dequeuing a migrated task (against an unlocked foreign run-queue
 nonetheless).

 To fix this, we get rid of the notion of "paranoid" and we support the
 three unique conditions properly.  The paranoid feature is no longer
 relevant with the new pushable logic (since pushable naturally limits
 the loop) anyway, so lets just remove it.

 Reported-By: Chirag Jog <chirag@linux.vnet.ibm.com>
 Found-by: Gilles Carry <gilles.carry@bull.net>
 Signed-off-by: Gregory Haskins <ghaskins@novell.com>


Best Regards,
Jane Zhou

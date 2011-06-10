Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab1FJOst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 10:48:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52515 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756366Ab1FJOsr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 10:48:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ovlTzeD3NrspKjl4BHq8KhEKCde9gfhpnq/Xm3kxyWguPlx4Ero7AlbW84uGHoRTvj
         f+S0Q7lboGkOK9Tocdnv1JNVddI7dqlI8a0c8+EZwfwBIwc1tdRv8MAkow5zPtvPXyn8
         3k3b0FqB1DLhWjeaWLDlirP3KnP2NwKj9y6V0=
MIME-Version: 1.0
In-Reply-To: <1307622863.9218.40.camel@gandalf.stny.rr.com>
References: <BANLkTimqWD=q6YnSDi-v9y=LMWecgEzEWg@mail.gmail.com>
	<BANLkTikoO5F5H4sEUoDPKX3qiahuehp=Mg@mail.gmail.com>
	<1307622863.9218.40.camel@gandalf.stny.rr.com>
Date: Fri, 10 Jun 2011 22:48:46 +0800
Message-ID: <BANLkTing2boYvDQqcxaqveYhbG2H1Zyvrw@mail.gmail.com>
Subject: Re: [PATCH] sched: remove resetting exec_start in put_prev_task_rt()
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 8:34 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2011-06-02 at 16:04 +0800, Yong Zhang wrote:
>> On Wed, Jun 1, 2011 at 10:03 PM, Hillf Danton <dhillf@gmail.com> wrote:
>> > Resetting exec_start, after updated in update_curr_rt(), could open window for
>> > messing up the subsequent computations of delta_exec of the given task.
>>
>> I can't see how could this happen. what kind of 'subsequent computations'
>> do you mean?
>
> I still don't see a race.
>
> Hilf, if you still believe there's a race here, can you explain it in
> detail. Do something like:
>
>        CPU0                    CPU1
>        ----                    ----
>   do_something;
>                                does_something_not_expected;
>   continue_something;
>
> Obviously changing what those "somethings" are. That way we can visually
> see what you are trying to say.
>
>>
>> But because exec_start will be reset by _pick_next_task_rt()/set_curr_task_rt(),
>> you patch is ok. IMHO it is not critical, it's just cleanup instead.
>
> I disagree. Yes the exec_start is reset there, but I like the fact that
> it's 0 when not running.
>

Hi Steve

Thank you a lot, and Peter as well, for your lessons on mutex_spin_on_owner:)

Resetting exec_start to zero has no negative functionality in RT scheduling,
as shown by Yong.

After put_prev_task() is called in schedule(),

	put_prev_task(rq, prev);
	next = pick_next_task(rq);
	clear_tsk_need_resched(prev);

next is picked. Lets assume that next is not prev, and prev is still on RQ,
then prev's sched_class is changed to CFS while it is waiting on RQ.
After sched_class switch, prev is under CFS charge, and the exec_start field
could be taken into other games.

In task_hot(), called when migrating task, zeroed exec_start is trapped as
the following.

btw, I could not locate where proc_sched_show_task() is called.

Again thanks all a lot, /Hillf

---
 kernel/sched.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index fd18f39..195bd4a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2184,6 +2184,7 @@ task_hot(struct task_struct *p, u64 now, struct
sched_domain *sd)
 	if (sysctl_sched_migration_cost == 0)
 		return 0;

+	BUG_ON(p->se.exec_start == 0);
 	delta = now - p->se.exec_start;

 	return delta < (s64)sysctl_sched_migration_cost;

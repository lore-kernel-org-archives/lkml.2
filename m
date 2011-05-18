Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab1ERNTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 09:19:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61654 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956Ab1ERNTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 09:19:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AlKjqQMJ69J9dYbyk5ozJ0niTUOf+LM1YhHXt7E9Djnr9VMqxutlQEslqUe5OLJAKv
         ZNN5KWCYxHFy5KieuRM1VQTMS/Vu9BBI2RjRn1/ynqgl7jh7nDA33n9heMm8FG3L9KsQ
         z4P3OUNm6200PGiE9GGFSKelkyJoWVNuduIEA=
MIME-Version: 1.0
In-Reply-To: <BANLkTikOW9t6F8jvTJ0uPvyYDy+mpXh-DA@mail.gmail.com>
References: <BANLkTikkeR_yf1HGhgq7WEO-kEvDGkV_tw@mail.gmail.com>
	<BANLkTim4n-WA_6nJpg4Nd99yuc3f+VWkcw@mail.gmail.com>
	<BANLkTikOecxhb8pZfAd19FLrPAPY4zacDQ@mail.gmail.com>
	<20110512120606.GA3639@zhy>
	<20110518013842.GD23940@home.goodmis.org>
	<BANLkTikOW9t6F8jvTJ0uPvyYDy+mpXh-DA@mail.gmail.com>
Date: Wed, 18 May 2011 21:19:44 +0800
Message-ID: <BANLkTikMdAG4HFmhiB9c3x97FH0N3PnpHA@mail.gmail.com>
Subject: Re: [PATCH] sched: correct how RT task is picked
From: Hillf Danton <dhillf@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 10:31 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Wed, May 18, 2011 at 9:38 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>> I think you can take a look at next_prio(), it just calculate the
>>> next highest task on the current cpu; in this case,
>>> cpumask_test_cpu(cpu, &p->cpus_allowed) will be true for the most
>>> of time, but maybe that task is bound to this cpu.
>>
>> I've been looking at the history here, and I think that '-1' is a relic.
>>
>> If you look at sched_rt.c in f65eda4f789168ba5ff3fa75546c29efeed19f58:
>>
>> $ git show f65eda4f:kernel/sched_rt.c
>>
>> You'll see that push_rt_task calls pick_next_highest_task_rt() with a
>> -1. That code has long been replaced.
>
> Yeah, the condition "cpu < 0" could be removed since we have no
> that kind of caller.
>
>>
>> I'm a bit nervous about taking Hillf's patch as is. But a little more
>> reviewing and testing may prove that it is legit.
>
> But another point is like I said before:
> 'cpumask_test_cpu(cpu, &p->cpus_allowed)' doesn't equal to
> 'p->rt.nr_cpus_allowed > 1' because we could have bounded
> task.
> So the condition 'if (cpumask_test_cpu(cpu, &p->cpus_allowed))'
> in Hillf's patch is not sufficient.
>

Hi all

The patch is prepared again, in which tests for both cpu and
nr_cpus_allowed are dropped.

The reason to drop nr_cpus_allowed is to make sure that the
returned value is correct for both case that cpu == rq->cpu and
case that cpu != rq->cpu.

thanks

Hillf
---

--- a/kernel/sched_rt.c	2011-04-27 11:48:50.000000000 +0800
+++ b/kernel/sched_rt.c	2011-05-18 21:16:22.000000000 +0800
@@ -1149,9 +1149,7 @@ static void deactivate_task(struct rq *r

 static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
 {
-	if (!task_running(rq, p) &&
-	    (cpu < 0 || cpumask_test_cpu(cpu, &p->cpus_allowed)) &&
-	    (p->rt.nr_cpus_allowed > 1))
+	if (!task_running(rq, p) && cpumask_test_cpu(cpu, &p->cpus_allowed))
 		return 1;
 	return 0;
 }

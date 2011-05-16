Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab1EPNO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 09:14:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35904 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab1EPNO6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 09:14:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ime7PRZozG/cGnJhCHtWh9PI4nerDA/TRRVjMHWhM1QOwIZEnAKiK96/D9co28vCRL
         7vrbY8CnJ9rlDLWX9S8GvWgLlzAvd7siHN2Kg3ALvgQQerUItj2UBeME7Xb/bfFY8R1D
         9WL6tikOshL7nlGBDpRe3Yk1d1bkg0huVbOVg=
MIME-Version: 1.0
In-Reply-To: <1305441316.7460.40.camel@marge.simson.net>
References: <BANLkTi=_gfo4bZjkoBsxspLxxWSPy=7J+Q@mail.gmail.com>
	<1305441316.7460.40.camel@marge.simson.net>
Date: Mon, 16 May 2011 21:14:56 +0800
Message-ID: <BANLkTino730kar=fEDJGCy8bCSVUe52aOw@mail.gmail.com>
Subject: Re: [PATCH] sched: avoid overpull when pulling RT task
From: Hillf Danton <dhillf@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 15, 2011 at 2:35 PM, Mike Galbraith <efault@gmx.de> wrote:
> On Sun, 2011-05-15 at 12:35 +0800, Hillf Danton wrote:
>> When pulling RT task for a given runqueue, pulling is continued even
>> after certain RT tasks get pulled, in case there are still higher
>> priority tasks on other runqueues, though it is low likelihood as the
>> comment says. The load of of this runqueue, on other hand, should also
>> be concerned. If it is overloaded, the low likelihood should be
>> abandoned to avoid overpull.
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>  kernel/sched_rt.c |    5 +++++
>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
>> index 14c764b..b425ca1 100644
>> --- a/kernel/sched_rt.c
>> +++ b/kernel/sched_rt.c
>> @@ -1508,6 +1508,11 @@ static int pull_rt_task(struct rq *this_rq)
>>               }
>>  skip:
>>               double_unlock_balance(this_rq, src_rq);
>> +
>> +             /* if pulled we have to also avoid overpull */
>> +             if (ret == 1)
>> +                     if (likely(rt_overloaded(this_rq)))
>> +                             break;
>>       }
>>
>>       return ret;
>
> Hm.
>
> It looks to me like you should remove the rt_overloaded() test (and
> function) entirely instead.  If you look at pull usage, the intent is
> that system wide, higher priority tasks run before lower.
>
> I don't think it matters much if we pull too much, since what we pull
> while traversing is ever increasing in priority _and waiting_ anyway.
> We may do a bit more work than strictly necessary on the way to the
> highest priority runnable task, but what matters most is that highest
> priority gets to the CPU first, which testing for overload can stymie.
>
> (seems pulling more than one could turn out either good or bad for any
> but the highest priority task though, lacking crystal ball)
>
Hi Mike

To win the crystal ball, I take another try.

In the following patch, pulling is played in two rounds. In the first round,
the highest priority task is determined with no pull operation. Pulling is
carried out in the second round, and if the highest priority task is pulled,
pulling could be stopped when overload detected, to relieve overpull.

Please review again, thanks.

Hillf
---

--- a/kernel/sched_rt.c	2011-04-27 11:48:50.000000000 +0800
+++ b/kernel/sched_rt.c	2011-05-16 20:42:18.000000000 +0800
@@ -1425,10 +1425,11 @@ static int pull_rt_task(struct rq *this_
 	int this_cpu = this_rq->cpu, ret = 0, cpu;
 	struct task_struct *p;
 	struct rq *src_rq;
+	int highest_prio = MAX_RT_PRIO;
+	int highest_pulled = 0;
+	int first_round = 1;

-	if (likely(!rt_overloaded(this_rq)))
-		return 0;
-
+again:
 	for_each_cpu(cpu, this_rq->rd->rto_mask) {
 		if (this_cpu == cpu)
 			continue;
@@ -1480,6 +1481,18 @@ static int pull_rt_task(struct rq *this_
 			if (p->prio < src_rq->curr->prio)
 				goto skip;

+			/*
+			 * To avoid overpull, we play pulling in two rounds,and
+			 * the highest task is determined in the first round.
+			 */
+			if (first_round) {
+				if (p->prio < highest_prio)
+					highest_prio = p->prio;
+				goto skip;
+			}
+			if (p->prio <= highest_prio)
+				highest_pulled = 1;
+
 			ret = 1;

 			deactivate_task(src_rq, p, 0);
@@ -1494,6 +1507,15 @@ static int pull_rt_task(struct rq *this_
 		}
 skip:
 		double_unlock_balance(this_rq, src_rq);
+
+		if (highest_pulled && rt_overloaded(this_rq))
+			break;
+	}
+
+	if (first_round && highest_prio != MAX_RT_PRIO) {
+		/* try to pull higher tasks on other RQs */
+		first_round = 0;
+		goto again;
 	}

 	return ret;

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab1EOLTA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 07:19:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39694 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182Ab1EOLS7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 07:18:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lpCmbjUrEUz8qZFdcG8AghcRGzScjhLtKEGXFZRITuxf/cYUJ+kWm1GiffvIsZr0GW
         t8bGqs07o+rfwR6UJ/LOQJ1Fs70thB10RBqXmMYM1TE9LlmC79Zbpk9nmHSmOuBwZH35
         mCEB8+0SX8dIn23Xd/mg2hKhE6iOT2q5YX3ds=
MIME-Version: 1.0
In-Reply-To: <1305441316.7460.40.camel@marge.simson.net>
References: <BANLkTi=_gfo4bZjkoBsxspLxxWSPy=7J+Q@mail.gmail.com>
	<1305441316.7460.40.camel@marge.simson.net>
Date: Sun, 15 May 2011 19:18:57 +0800
Message-ID: <BANLkTi=huV8r6tRqYt6OWj+8wgc-m2c_iw@mail.gmail.com>
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

It is solid reason that the highest priority should get CPU, and along
this direction the info about the highest priority is add in struct root_domain,
then the overpull looks relieved, though not cured, please review again.

thanks
Hillf
---

--- a/kernel/sched.c	2011-04-27 11:48:50.000000000 +0800
+++ b/kernel/sched.c	2011-05-15 18:54:28.000000000 +0800
@@ -426,6 +426,8 @@ struct root_domain {
 	 */
 	cpumask_var_t rto_mask;
 	atomic_t rto_count;
+	/* the highest prio in rto_mask */
+	int rto_prio;
 	struct cpupri cpupri;
 };

@@ -6634,6 +6636,8 @@ static int init_rootdomain(struct root_d

 	if (cpupri_init(&rd->cpupri) != 0)
 		goto free_rto_mask;
+
+	rd->rto_prio = MAX_RT_PRIO;
 	return 0;

 free_rto_mask:
--- b/kernel/sched_rt.c	2011-04-27 11:48:50.000000000 +0800
+++ b/kernel/sched_rt.c	2011-05-15 19:02:50.000000000 +0800
@@ -108,6 +108,10 @@ static void inc_rt_migration(struct sche
 		rt_rq->rt_nr_migratory++;

 	update_rt_migration(rt_rq);
+
+	if (rt_rq->overloaded &&
+	    rq_of_rt_rq(rt_rq)->rd->rto_prio > rt_task_of(rt_se)->prio)
+		rq_of_rt_rq(rt_rq)->rd->rto_prio = rt_task_of(rt_se)->prio;
 }

 static void dec_rt_migration(struct sched_rt_entity *rt_se, struct
rt_rq *rt_rq)
@@ -1425,9 +1429,7 @@ static int pull_rt_task(struct rq *this_
 	int this_cpu = this_rq->cpu, ret = 0, cpu;
 	struct task_struct *p;
 	struct rq *src_rq;
-
-	if (likely(!rt_overloaded(this_rq)))
-		return 0;
+	int rto_prio_pulled = 0;

 	for_each_cpu(cpu, this_rq->rd->rto_mask) {
 		if (this_cpu == cpu)
@@ -1481,6 +1483,8 @@ static int pull_rt_task(struct rq *this_
 				goto skip;

 			ret = 1;
+			if (p->prio <= this_rq->rd->rto_prio)
+				rto_prio_pulled = 1;

 			deactivate_task(src_rq, p, 0);
 			set_task_cpu(p, this_cpu);
@@ -1494,6 +1498,9 @@ static int pull_rt_task(struct rq *this_
 		}
 skip:
 		double_unlock_balance(this_rq, src_rq);
+
+		if (rto_prio_pulled)
+			break;
 	}

 	return ret;

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab2BQMd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 07:33:29 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51884 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab2BQMd0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 07:33:26 -0500
MIME-Version: 1.0
In-Reply-To: <1329348972.2293.189.camel@twins>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
 <20120202013826.20844.39042.stgit@kitami.mtv.corp.google.com> <1329348972.2293.189.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Fri, 17 Feb 2012 04:32:55 -0800
Message-ID: <CAPM31R+r0sjcFy2rTG1z2fOg=wTvfV35qZbSUHu89x=U3Os7yQ@mail.gmail.com>
Subject: Re: [RFC PATCH 08/14] sched: normalize tg load contributions against
 runnable time
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 3:36 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2012-02-01 at 17:38 -0800, Paul Turner wrote:
>> Entities of equal weight should receive equitable distribution of cpu time.
>> This is challenging in the case of a task_group's shares as execution may be
>> occurring on multiple cpus simultaneously.
>>
>> To handle this we divide up the shares into weights proportionate with the load
>> on each cfs_rq.  This does not however, account for the fact that the sum of
>> the parts may be less than one cpu and so we need to normalize:
>>   load(tg) = min(runnable_avg(tg), 1) * tg->shares
>> Where runnable_avg is the aggregate time in which the task_group had runnable
>> children.
>
>
>>  static inline void __update_group_entity_contrib(struct sched_entity *se)
>>  {
>>         struct cfs_rq *cfs_rq = group_cfs_rq(se);
>>         struct task_group *tg = cfs_rq->tg;
>> +       int runnable_avg;
>>
>>         se->avg.load_avg_contrib = (cfs_rq->tg_load_contrib * tg->shares);
>>         se->avg.load_avg_contrib /= atomic64_read(&tg->load_avg) + 1;
>> +
>> +       /*
>> +        * Unlike a task-entity, a group entity may be using >=1 cpu globally.
>> +        * However, in the case that it's using <1 cpu we need to form a
>> +        * correction term so that we contribute the same load as a task of
>> +        * equal weight. (Global runnable time is taken as a fraction over 2^12.)
>> +        */
>> +       runnable_avg = atomic_read(&tg->runnable_avg);
>> +       if (runnable_avg < (1<<12)) {
>> +               se->avg.load_avg_contrib *= runnable_avg;
>> +               se->avg.load_avg_contrib /= (1<<12);
>> +       }
>>  }
>
> This seems weird, and the comments don't explain anything.
>

So consider (on cpu_i):

  R_i
 /  \
t1  A_i
      \
      t2

Where weight(t1) = shares(A) = 1024

Now, if t1 is runnable 80% of the time we'd charge 80% of its weight
to R in the load-avg, or about 820

If t2, in A, is runnable the exact same proportion of time, then it
should make the same contribution to R.

*But* A is a group entity, so its contribution is then its load weight
as a fraction of the task_groups.  The catch is that if t2 is the only
task running then this is 1024/1024  * 1024 = 1024 != 820, we've lost
the fact that t2 in A was only actually runnable 80% of the time.  We
need to perform the same normalization against how much it actually
runs.. BUT

We can't just use A_i's runnable, since group entities are per-cpu and
thus completely wrong as t2 moves around.  We also can't easily carry
t2's contribution to A_i's runnability since there's no way to pull
the sum apart or account it into the new parenting tree efficiently.

But what we c an do is aggregate an estimation of whether the group as
a whole would contribute its full shares value if placed only on one
cpu and adjust appropriately.

I'll try to paraphrase the above into a more useful comment explaining this.

> Ah,.. you can count runnable multiple times (on each cpu), this also
> means that the number you're using (when below 1) can still be utter
> crap.

So, as an estimate it has the nice property that it's always a lower
bound on the true value.

Consider the two cases for runnable contributions across a pair of cpus:

Either they are disjoint by wall time, in which case they would have
accounted for the same amount were they actually on the same cpu.
Or they overlap, in which case that over-lap period would be an
additional run-delay incurred on one of them.

Then, the maximum amount we understate for a given overlap is n(n+1)/2
* k where k is the the width of the overlap and n is the number of
cpus we over-lapped on.

But then, n is bounded by num_cpus -- so on a small machine our error
is bounded (e.g. we can be no more  than 1/3 less than true on 2
cpus).  On a larger machine this term can be larger, however, if k is
of consequential size we know we accounted at least n*k so we're still
going to approach the ceiling of 1 very quickly at which point it
doesn't matter that we under-estimated.  The flip side on a larger
machine is that if k is of inconsequential size then n*2 * k is still
tiny relative to the size of the machine and the accuracy of the
approximation matters less.

>
> Neither the comment nor the changelog mention this, it should, it should
> also mention why it doesn't matter (does it?).

It doesn't and it should.  Although I'll take the liberty shortening
it a little to something like "unfortunately we cannot compute
runnable_avg(tg) directly, however, XXX is a reasonable
approximation."

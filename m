Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab2JISaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:30:12 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40116 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab2JISaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:30:05 -0400
MIME-Version: 1.0
In-Reply-To: <1349698485.7880.6.camel@twins>
References: <CAPM31R+mT+g0qTGOVgC1QYJk3Ju-u06UpkBwx-4tHxeh89kD3w@mail.gmail.com>
 <CAPM31RLKEZ0xzPXYQc-pMGUesfkviQ5i0LZaJipWC8oY=J5-kg@mail.gmail.com>
 <20121006073947.GA26538@gmail.com> <1349698485.7880.6.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Tue, 9 Oct 2012 11:29:34 -0700
Message-ID: <CAPM31R+V-EN8sEQMDx51Bn-Q_W-ysTV3_pQ-W9egBw2Hw5tY3Q@mail.gmail.com>
Subject: Re: sched: per-entity load-tracking
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Ben Segall <bsegall@google.com>,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 8, 2012 at 5:14 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Sat, 2012-10-06 at 09:39 +0200, Ingo Molnar wrote:
>
> Thanks Ingo! Paul,
>
>>  tip/kernel/sched/fair.c |   28 ++++++++++++++++++----------
>>  1 file changed, 18 insertions(+), 10 deletions(-)
>>
>> Index: tip/kernel/sched/fair.c
>> ===================================================================
>> --- tip.orig/kernel/sched/fair.c
>> +++ tip/kernel/sched/fair.c
>>
>> @@ -1151,7 +1156,7 @@ static inline void update_cfs_shares(str
>>   * Note: The tables below are dependent on this value.
>>   */
>>  #define LOAD_AVG_PERIOD 32
>> -#define LOAD_AVG_MAX 47765 /* maximum possible load avg */
>> +#define LOAD_AVG_MAX 47742 /* maximum possible load avg */
>>  #define LOAD_AVG_MAX_N 345 /* number of full periods to produce LOAD_MAX_AVG */
>>
>>  /* Precomputed fixed inverse multiplies for multiplication by y^n */
>> @@ -1203,7 +1208,8 @@ static __always_inline u64 decay_load(u6
>>       }
>>
>>       val *= runnable_avg_yN_inv[local_n];
>> -     return SRR(val, 32);
>> +     /* We don't use SRR here since we always want to round down. */
>> +     return val >> 32;
>>  }
>>
>>  /*
>
> This is from patches/sched-fast_decay.patch and I changed both the
> patch and the changelog to reflect your changes.
>

Yes.   To be sure here there's a similar correction to the table
generator in the changelog, so it's particularly relevant to make sure
that one's included.

I checked your stack and this looks correctly updated.

>
>>@@ -262,6 +262,9 @@ static inline struct cfs_rq *group_cfs_r
>>       return grp->my_q;
>>  }
>>
>> +static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq,
>> +                                    int force_update);
>> +
>>  static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
>>  {
>>       if (!cfs_rq->on_list) {
>> @@ -281,6 +284,8 @@ static inline void list_add_leaf_cfs_rq(
>>               }
>>
>>               cfs_rq->on_list = 1;
>> +             /* We should have no load, but we need to update last_decay. */
>> +             update_cfs_rq_blocked_load(cfs_rq, 0);
>>       }
>>  }
>
>
> This seems to have come from patches/sched-cfs_rq_blocked_load.patch, and I merged
> it in there. With subsequent updates in
> patches/sched-wakeup_load.patch. I didn't find any changes to the Changelogs for either.
>
>
>> @@ -4236,13 +4242,15 @@ static void __update_blocked_averages_cp
>>       if (se) {
>>               update_entity_load_avg(se, 1);
>>               /*
>> -              * We can pivot on the runnable average decaying to zero for
>> -              * list removal since the parent average will always be >=
>> -              * child.
>> +              * We pivot on our runnable average having decayed to zero for
>> +              * list removal.  This generally implies that all our children
>> +              * have also been removed (modulo rounding error or bandwidth
>> +              * control); however, such cases are rare and we can fix these
>> +              * at enqueue.
>> +              *
>> +              * TODO: fix up out-of-order children on enqueue.
>>                */
>> -             if (se->avg.runnable_avg_sum)
>> -                     update_cfs_shares(cfs_rq);
>> -             else
>> +             if (!se->avg.runnable_avg_sum && !cfs_rq->nr_running)
>>                       list_del_leaf_cfs_rq(cfs_rq);
>>       } else {
>>               struct rq *rq = rq_of(cfs_rq);
>
>
> This hunk seems to have come from
> patches/sched-swap_update_shares.patch, merged in there, no Changelog
> changes afaict.
>

>
> I've updated my queue (at the usual location:
> http://programming.kicks-ass.net/sekrit/patches.tar.bz2), Paul please
> verify I didn't miss anything.
>
>


Looks good, the only difference I see is:

sched-root_avg.patch
diff -u b/kernel/sched/fair.c b/kernel/sched/fair.c
--- b/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5594,10 +5594,10 @@
                entity_tick(cfs_rq, se, queued);
        }

+       update_rq_runnable_avg(rq, 1);
+
        if (sched_feat_numa(NUMA))
                task_tick_numa(rq, curr);
-
-       update_rq_runnable_avg(rq, 1);
 }


Which is a change I agree with; we want task_tick_numa to have
up-to-date stats available to it.


Thanks!

- Paul

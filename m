Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab2JBVK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 17:10:27 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62061 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab2JBVKW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 17:10:22 -0400
MIME-Version: 1.0
In-Reply-To: <5060B9C2.5040200@cs.tu-berlin.de>
References: <20120823141422.444396696@google.com> <20120823141507.200772172@google.com>
 <5060B9C2.5040200@cs.tu-berlin.de>
From: Paul Turner <pjt@google.com>
Date: Tue, 2 Oct 2012 14:09:51 -0700
Message-ID: <CAPM31RKbmvMt0mYXfTNvQSO3WEowZ3=h1ayYFCBN=rMzGDu8bQ@mail.gmail.com>
Subject: Re: [patch 13/16] sched: update_cfs_shares at period edge
To: =?ISO-8859-1?Q?Jan_H=2E_Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
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
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 12:51 PM, "Jan H. Schönherr"
<schnhrr@cs.tu-berlin.de> wrote:
> Am 23.08.2012 16:14, schrieb pjt@google.com:
>> From: Paul Turner <pjt@google.com>
>>
>> Now that our measurement intervals are small (~1ms) we can amortize the posting
>> of update_shares() to be about each period overflow.  This is a large cost
>> saving for frequently switching tasks.
>
> [snip]
>
>> @@ -1181,6 +1181,7 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
>>       }
>>
>>       __update_cfs_rq_tg_load_contrib(cfs_rq, force_update);
>> +     update_cfs_shares(cfs_rq);
>>  }
>
> Here a call to update_cfs_shares() gets added. Doesn't that make the call to
> update_cfs_shares() in __update_blocked_averages_cpu() superfluous?

Yes -- updated, Thanks.

>
>
> Function pasted here for reference:
>
> static void __update_blocked_averages_cpu(struct task_group *tg, int cpu)
> {
>         struct sched_entity *se = tg->se[cpu];
>         struct cfs_rq *cfs_rq = tg->cfs_rq[cpu];
>
>         /* throttled entities do not contribute to load */
>         if (throttled_hierarchy(cfs_rq))
>                 return;
>
>         update_cfs_rq_blocked_load(cfs_rq, 1);
>
>         if (se) {
>                 update_entity_load_avg(se, 1);
>                 /*
>                  * We can pivot on the runnable average decaying to zero for
>                  * list removal since the parent average will always be >=
>                  * child.
>                  */
>                 if (se->avg.runnable_avg_sum)
>                         update_cfs_shares(cfs_rq);
>                 else
>                         list_del_leaf_cfs_rq(cfs_rq);
>         } else {
>                 struct rq *rq = rq_of(cfs_rq);
>                 update_rq_runnable_avg(rq, rq->nr_running);
>         }
> }
>
>
> Regards
> Jan

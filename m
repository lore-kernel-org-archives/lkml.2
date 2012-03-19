Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212Ab2CSRJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:09:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758001Ab2CSRJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:09:35 -0400
Date: Mon, 19 Mar 2012 18:09:32 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] autonuma: fix typo in sched balance
Message-ID: <20120319170932.GF24602@redhat.com>
References: <CAJd=RBAhi6vmihBT4iZ2ELtix8vEtx-VM8gujb-q-cOjqqdcnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBAhi6vmihBT4iZ2ELtix8vEtx-VM8gujb-q-cOjqqdcnQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hillf,

Thanks a lot for starting looking into it despite I hadn't the time
yet to polish it in smaller commits.

On Mon, Mar 19, 2012 at 08:45:03PM +0800, Hillf Danton wrote:
> Hi Andrea
> 
> It is redefined to be safely used by set/test_bit(cpu, mm_mask).
> 
> Q-0: another case of mm_mask in struct rq?

You're right, we better move it to struct rq like I moved the other
arrays. I already moved those to rq, but one recent patch slipped off.

> Q-1: make sense to move NR_CPUS variable out of stack?

Absolutely. It should be ok in the latest autonuma branch (since Friday)

http://git.kernel.org/?p=linux/kernel/git/andrea/aa.git;a=commitdiff;h=c9effed1071202090cb9e09da814dabf1b9af409;hp=30ed50adf6cfe85f7feb12c4279359ec52f5f2cd

I committed it to aa.git last Friday, can you pull out again the
autonuma branch and verify?

> Q-2: for online mem node, cpumask_of_node(nid) implies cpu also online?
> 
> 	for_each_online_node(nid) {
> 		for_each_cpu_and(cpu, cpumask_of_node(nid), allowed) {
> 			struct rq *rq;
> 		+	if (!cpu_online(cpu))
> 		+		continue;
> 			rq = cpu_rq(cpu);
> 			if (rq->curr->mm == mm)
> 				nr_mm++;
> 		}
> 	}
> 
> where check needed for accessing rq->curr?

I need to check what is in rq->curr of a cpu that isn't online, idle
task maybe? At times cpu_online may be needed.


> 
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/kernel/sched/numa.c	Sat Mar 17 11:01:40 2012
> +++ b/kernel/sched/numa.c	Mon Mar 19 20:01:34 2012
> @@ -95,7 +95,7 @@ void sched_autonuma_balance(void)
>  	struct migration_arg arg;
>  	struct task_struct *p = current;
>  	struct sched_autonuma *sched_autonuma = p->sched_autonuma;
> -	DECLARE_BITMAP(mm_mask, MAX_NUMNODES);
> +	DECLARE_BITMAP(mm_mask, NR_CPUS);
> 
>  	if (!sched_autonuma || sched_autonuma->autonuma_stop_one_cpu || !p->mm)
>  		return;
> @@ -136,7 +136,7 @@ void sched_autonuma_balance(void)
>  		weight_current[nid] = p_w*AUTONUMA_BALANCE_SCALE/p_t;
>  	}
> 
> -	bitmap_zero(mm_mask, MAX_NUMNODES);
> +	bitmap_zero(mm_mask, NR_CPUS);
>  	for_each_online_node(nid) {
>  		if (nid == cpu_nid)
>  			continue;

Ouch thanks a lot. I need to rediff against
c9effed1071202090cb9e09da814dabf1b9af409 , it's now in the rq.

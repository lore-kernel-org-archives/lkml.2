Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930Ab2IXTpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 15:45:00 -0400
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:43209 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757778Ab2IXTo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 15:44:58 -0400
Message-ID: <5060B82B.1050206@cs.tu-berlin.de>
Date: Mon, 24 Sep 2012 21:44:43 +0200
From: =?ISO-8859-15?Q?=22Jan_H=2E_Sch=F6nherr=22?= 
	<schnhrr@cs.tu-berlin.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120324 Thunderbird/10.0.3
MIME-Version: 1.0
To: pjt@google.com
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
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
Subject: Re: [patch 11/16] sched: replace update_shares weight distribution
 with per-entity computation
References: <20120823141422.444396696@google.com> <20120823141507.061208672@google.com>
In-Reply-To: <20120823141507.061208672@google.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.08.2012 16:14, schrieb pjt@google.com:
> From: Paul Turner <pjt@google.com>
> 
> Now that the machinery in place is in place to compute contributed load in a
> bottom up fashion; replace the shares distribution code within update_shares()
> accordingly.

[snip]

>  static int update_shares_cpu(struct task_group *tg, int cpu)
>  {
> +	struct sched_entity *se;
>  	struct cfs_rq *cfs_rq;
>  	unsigned long flags;
>  	struct rq *rq;
>  
> -	if (!tg->se[cpu])
> -		return 0;
> -
>  	rq = cpu_rq(cpu);
> +	se = tg->se[cpu];
>  	cfs_rq = tg->cfs_rq[cpu];
>  
>  	raw_spin_lock_irqsave(&rq->lock, flags);
>  
>  	update_rq_clock(rq);
> -	update_cfs_load(cfs_rq, 1);
>  	update_cfs_rq_blocked_load(cfs_rq, 1);
>  
> -	/*
> -	 * We need to update shares after updating tg->load_weight in
> -	 * order to adjust the weight of groups with long running tasks.
> -	 */
> -	update_cfs_shares(cfs_rq);
> +	if (se) {
> +		update_entity_load_avg(se, 1);
> +		/*
> +		 * We can pivot on the runnable average decaying to zero for
> +		 * list removal since the parent average will always be >=
> +		 * child.
> +		 */
> +		if (se->avg.runnable_avg_sum)
> +			update_cfs_shares(cfs_rq);
> +		else
> +			list_del_leaf_cfs_rq(cfs_rq);

The blocked load, which we decay from this function, is not part of
se->avg.runnable_avg_sum. Is list removal a good idea while there might be
blocked load? We only get here, because we are on that list... don't we end up
with a wrong task group load then?

Regards
Jan

> +	} else {
> +		update_rq_runnable_avg(rq, rq->nr_running);
> +	}
>  
>  	raw_spin_unlock_irqrestore(&rq->lock, flags);
>  


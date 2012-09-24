Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab2IXTvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 15:51:50 -0400
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:43646 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260Ab2IXTvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 15:51:49 -0400
Message-ID: <5060B9C2.5040200@cs.tu-berlin.de>
Date: Mon, 24 Sep 2012 21:51:30 +0200
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
Subject: Re: [patch 13/16] sched: update_cfs_shares at period edge
References: <20120823141422.444396696@google.com> <20120823141507.200772172@google.com>
In-Reply-To: <20120823141507.200772172@google.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.08.2012 16:14, schrieb pjt@google.com:
> From: Paul Turner <pjt@google.com>
> 
> Now that our measurement intervals are small (~1ms) we can amortize the posting
> of update_shares() to be about each period overflow.  This is a large cost
> saving for frequently switching tasks.

[snip]

> @@ -1181,6 +1181,7 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
>  	}
>  
>  	__update_cfs_rq_tg_load_contrib(cfs_rq, force_update);
> +	update_cfs_shares(cfs_rq);
>  }

Here a call to update_cfs_shares() gets added. Doesn't that make the call to
update_cfs_shares() in __update_blocked_averages_cpu() superfluous?


Function pasted here for reference:

static void __update_blocked_averages_cpu(struct task_group *tg, int cpu)
{
	struct sched_entity *se = tg->se[cpu];
	struct cfs_rq *cfs_rq = tg->cfs_rq[cpu];

	/* throttled entities do not contribute to load */
	if (throttled_hierarchy(cfs_rq))
		return;

	update_cfs_rq_blocked_load(cfs_rq, 1);

	if (se) {
		update_entity_load_avg(se, 1);
		/*
		 * We can pivot on the runnable average decaying to zero for
		 * list removal since the parent average will always be >=
		 * child.
		 */
		if (se->avg.runnable_avg_sum)
			update_cfs_shares(cfs_rq);
		else
			list_del_leaf_cfs_rq(cfs_rq);
	} else {
		struct rq *rq = rq_of(cfs_rq);
		update_rq_runnable_avg(rq, rq->nr_running);
	}
}


Regards
Jan

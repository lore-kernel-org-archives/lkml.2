Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972Ab2IEXj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 19:39:59 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:40083 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab2IEXj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 19:39:57 -0400
Date: Wed, 5 Sep 2012 16:39:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, rakib.mullick@gmail.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Fix load avg vs cpu-hotplug
Message-ID: <20120905233951.GX3308@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1345454817.23018.27.camel@twins>
 <tip-f319da0c6894fcf55e21320e40506418a2aad629@git.kernel.org>
 <1346848616.2600.26.camel@twins>
 <20120905132939.GA3480@gmail.com>
 <1346864493.2600.27.camel@twins>
 <1346882630.2600.59.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346882630.2600.59.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090523-2398-0000-0000-00000A4D89E1
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000293; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00171632; UDB=6.00038928; UTC=2012-09-05
 23:39:56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 12:03:50AM +0200, Peter Zijlstra wrote:
> On Wed, 2012-09-05 at 19:01 +0200, Peter Zijlstra wrote:
> > > Please do a delta.
> 
> OK, so I suppose something like the below ought to do. Paul its slightly
> different than the one in your tree, given the changelog below, do you
> see anything wrong with it?
> 
> Rakib, again, sorry for getting your name wrong, and this time for
> getting it merged :/
> 
> ---
> Subject: sched: Fix load avg vs cpu-hotplug mk-II
> 
> Commit f319da0c68 ("sched: Fix load avg vs cpu-hotplug") was a known
> broken version that got in by accident.
> 
> In particular, the problem is that at the point it calls
> calc_load_migrate() nr_running := 1 (the stopper thread), so move the
> call to CPU_DEAD where we're sure that nr_running := 0.
> 
> Also note that we can call calc_load_migrate() without serialization, we
> know the state of rq is stable since its cpu is dead, and we modify the
> global state using appropriate atomic ops. 
> 
> Suggested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Given your point about atomic ops, my version was indeed overkill.

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  kernel/sched/core.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index c46a011..8c089cb 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5086,7 +5086,9 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  		migrate_tasks(cpu);
>  		BUG_ON(rq->nr_running != 1); /* the migration thread */
>  		raw_spin_unlock_irqrestore(&rq->lock, flags);
> +		break;
>  
> +	case CPU_DEAD:
>  		calc_load_migrate(rq);
>  		break;
>  #endif
> 


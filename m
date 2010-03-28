Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab0C1EQA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 00:16:00 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58820 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab0C1EP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 00:15:59 -0400
Date: Sat, 27 Mar 2010 21:15:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: move some code from macro to function
Message-ID: <20100328041554.GQ2343@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4BAEC91E.8000001@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAEC91E.8000001@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 28, 2010 at 11:12:30AM +0800, Lai Jiangshan wrote:
> 
> cleanup: move some code from macro to function

Nice!

I have queued this for RCU 2.6.35, with the following commit message:

	Shrink the RCU_INIT_FLAVOR() macro by moving all but the
	initialization of the ->rda[] array to rcu_init_one().
	The call to rcu_init_one() can then be moved to the end
	of the RCU_INIT_FLAVOR() macro, which is required because
	rcu_boot_init_percpu_data(), which is now called from
	rcu_init_one(), depends on the initialization of the ->rda[]
	array.

Seem reasonable?

							Thanx, Paul

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 3ec8160..112edb5 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1849,6 +1849,14 @@ static void __init rcu_init_one(struct rcu_state *rsp)
>  			INIT_LIST_HEAD(&rnp->blocked_tasks[3]);
>  		}
>  	}
> +
> +	rnp = rsp->level[NUM_RCU_LVLS - 1];
> +	for_each_possible_cpu(i) {
> +		if (i > rnp->grphi)
> +			rnp++;
> +		rsp->rda[i]->mynode = rnp;
> +		rcu_boot_init_percpu_data(i, rsp);
> +	}
>  }
> 
>  /*
> @@ -1859,19 +1867,11 @@ static void __init rcu_init_one(struct rcu_state *rsp)
>  #define RCU_INIT_FLAVOR(rsp, rcu_data) \
>  do { \
>  	int i; \
> -	int j; \
> -	struct rcu_node *rnp; \
>  	\
> -	rcu_init_one(rsp); \
> -	rnp = (rsp)->level[NUM_RCU_LVLS - 1]; \
> -	j = 0; \
>  	for_each_possible_cpu(i) { \
> -		if (i > rnp[j].grphi) \
> -			j++; \
> -		per_cpu(rcu_data, i).mynode = &rnp[j]; \
>  		(rsp)->rda[i] = &per_cpu(rcu_data, i); \
> -		rcu_boot_init_percpu_data(i, rsp); \
>  	} \
> +	rcu_init_one(rsp); \
>  } while (0)
> 
>  void __init rcu_init(void)
> 

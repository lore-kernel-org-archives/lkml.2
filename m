Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab2ICJa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 05:30:27 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:43408 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab2ICJaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 05:30:25 -0400
X-Originating-IP: 217.70.178.132
X-Originating-IP: 50.43.46.74
Date: Mon, 3 Sep 2012 02:30:16 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 13/23] rcu: Control grace-period duration
 from sysfs
Message-ID: <20120903093016.GA5574@leaf>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-13-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346350718-30937-13-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:18:28AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> Some uses of RCU benefit from shorter grace periods, while others benefit
> more from the greater efficiency provided by longer grace periods.
> Therefore, this commit allows the durations to be controlled from sysfs.
> There are two sysfs parameters, one named "jiffies_till_first_fqs" that
> specifies the delay in jiffies from the end of grace-period initialization
> until the first attempt to force quiescent states, and the other named
> "jiffies_till_next_fqs" that specifies the delay (again in jiffies)
> between subsequent attempts to force quiescent states.  They both default
> to three jiffies, which is compatible with the old hard-coded behavior.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Signed-off-by: Josh Triplett <josh@joshtriplett.org>

>  Documentation/kernel-parameters.txt |   11 +++++++++++
>  kernel/rcutree.c                    |   25 ++++++++++++++++++++++---
>  2 files changed, 33 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index ad7e2e5..55ada04 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2385,6 +2385,17 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  	rcutree.rcu_cpu_stall_timeout= [KNL,BOOT]
>  			Set timeout for RCU CPU stall warning messages.
>  
> +	rcutree.jiffies_till_first_fqs= [KNL,BOOT]
> +			Set delay from grace-period initialization to
> +			first attempt to force quiescent states.
> +			Units are jiffies, minimum value is zero,
> +			and maximum value is HZ.
> +
> +	rcutree.jiffies_till_next_fqs= [KNL,BOOT]
> +			Set delay between subsequent attempts to force
> +			quiescent states.  Units are jiffies, minimum
> +			value is one, and maximum value is HZ.
> +
>  	rcutorture.fqs_duration= [KNL,BOOT]
>  			Set duration of force_quiescent_state bursts.
>  
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index ed1be62..1d33240 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -226,6 +226,12 @@ int rcu_cpu_stall_timeout __read_mostly = CONFIG_RCU_CPU_STALL_TIMEOUT;
>  module_param(rcu_cpu_stall_suppress, int, 0644);
>  module_param(rcu_cpu_stall_timeout, int, 0644);
>  
> +static ulong jiffies_till_first_fqs = RCU_JIFFIES_TILL_FORCE_QS;
> +static ulong jiffies_till_next_fqs = RCU_JIFFIES_TILL_FORCE_QS;
> +
> +module_param(jiffies_till_first_fqs, ulong, 0644);
> +module_param(jiffies_till_next_fqs, ulong, 0644);
> +
>  static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *));
>  static void force_quiescent_state(struct rcu_state *rsp);
>  static int rcu_pending(int cpu);
> @@ -1193,6 +1199,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
>  static int rcu_gp_kthread(void *arg)
>  {
>  	int fqs_state;
> +	unsigned long j;
>  	int ret;
>  	struct rcu_state *rsp = arg;
>  	struct rcu_node *rnp = rcu_get_root(rsp);
> @@ -1213,14 +1220,18 @@ static int rcu_gp_kthread(void *arg)
>  
>  		/* Handle quiescent-state forcing. */
>  		fqs_state = RCU_SAVE_DYNTICK;
> +		j = jiffies_till_first_fqs;
> +		if (j > HZ) {
> +			j = HZ;
> +			jiffies_till_first_fqs = HZ;
> +		}
>  		for (;;) {
> -			rsp->jiffies_force_qs = jiffies +
> -						RCU_JIFFIES_TILL_FORCE_QS;
> +			rsp->jiffies_force_qs = jiffies + j;
>  			ret = wait_event_interruptible_timeout(rsp->gp_wq,
>  					(rsp->gp_flags & RCU_GP_FLAG_FQS) ||
>  					(!ACCESS_ONCE(rnp->qsmask) &&
>  					 !rcu_preempt_blocked_readers_cgp(rnp)),
> -					RCU_JIFFIES_TILL_FORCE_QS);
> +					j);
>  			/* If grace period done, leave loop. */
>  			if (!ACCESS_ONCE(rnp->qsmask) &&
>  			    !rcu_preempt_blocked_readers_cgp(rnp))
> @@ -1234,6 +1245,14 @@ static int rcu_gp_kthread(void *arg)
>  				cond_resched();
>  				flush_signals(current);
>  			}
> +			j = jiffies_till_next_fqs;
> +			if (j > HZ) {
> +				j = HZ;
> +				jiffies_till_next_fqs = HZ;
> +			} else if (j < 1) {
> +				j = 1;
> +				jiffies_till_next_fqs = 1;
> +			}
>  		}
>  
>  		/* Handle grace-period end. */
> -- 
> 1.7.8
> 

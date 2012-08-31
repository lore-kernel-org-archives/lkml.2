Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab2HaSP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 14:15:26 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43684 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab2HaSPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 14:15:25 -0400
X-Originating-IP: 217.70.178.130
X-Originating-IP: 173.246.103.110
Date: Fri, 31 Aug 2012 11:15:16 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 08/15] rcu: Apply for_each_rcu_flavor() to
 increment_cpu_stall_ticks()
Message-ID: <20120831181516.GF4259@jtriplet-mobl1>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352988-32444-8-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346352988-32444-8-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:56:21AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> The increment_cpu_stall_ticks() function listed each RCU flavor
> explicitly, with an ifdef to handle preemptible RCU.  This commit
> therefore applies for_each_rcu_flavor() to save a line of code.

And also mysteriously changes __get_cpu_var to __this_cpu_var without
documenting that (or the reason for it) in the commit message. :)

> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcutree_plugin.h |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 3ea60c9..139a803 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -2196,11 +2196,10 @@ static void zero_cpu_stall_ticks(struct rcu_data *rdp)
>  /* Increment ->ticks_this_gp for all flavors of RCU. */
>  static void increment_cpu_stall_ticks(void)
>  {
> -	__get_cpu_var(rcu_sched_data).ticks_this_gp++;
> -	__get_cpu_var(rcu_bh_data).ticks_this_gp++;
> -#ifdef CONFIG_TREE_PREEMPT_RCU
> -	__get_cpu_var(rcu_preempt_data).ticks_this_gp++;
> -#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> +	struct rcu_state *rsp;
> +
> +	for_each_rcu_flavor(rsp)
> +		__this_cpu_ptr(rsp->rda)->ticks_this_gp++;
>  }
>  
>  #else /* #ifdef CONFIG_RCU_CPU_STALL_INFO */
> -- 
> 1.7.8
> 

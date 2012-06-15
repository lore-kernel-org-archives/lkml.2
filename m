Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867Ab2FOUlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 16:41:00 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:53194 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757602Ab2FOUk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 16:40:59 -0400
X-Originating-IP: 217.70.178.130
X-Originating-IP: 50.43.46.74
Date: Fri, 15 Jun 2012 13:40:48 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 01/14] rcu: Fix detection of abruptly-ending
 stall
Message-ID: <20120615204048.GF31184@leaf>
References: <20120615201256.GA26120@linux.vnet.ibm.com>
 <1339791195-26389-1-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339791195-26389-1-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 01:13:02PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> The code that attempts to identify stalls that end just as we detect
> them is broken by both flavors of initialization failure.  This commit
> therefore properly initializes and computes the count of the number
> of reasons why the RCU grace period is stalled.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

This approach definitely seems more robust against future code changes.

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> ---
>  kernel/rcutree.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 0da7b88..0f04480 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -732,7 +732,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
>  	int cpu;
>  	long delta;
>  	unsigned long flags;
> -	int ndetected;
> +	int ndetected = 0;
>  	struct rcu_node *rnp = rcu_get_root(rsp);
>  
>  	/* Only let one CPU complain about others per time interval. */
> @@ -773,7 +773,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
>  	 */
>  	rnp = rcu_get_root(rsp);
>  	raw_spin_lock_irqsave(&rnp->lock, flags);
> -	ndetected = rcu_print_task_stall(rnp);
> +	ndetected += rcu_print_task_stall(rnp);
>  	raw_spin_unlock_irqrestore(&rnp->lock, flags);
>  
>  	print_cpu_stall_info_end();
> -- 
> 1.7.8
> 

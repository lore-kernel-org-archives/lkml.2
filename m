Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab1FHX0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 19:26:11 -0400
Received: from blu0-omc1-s33.blu0.hotmail.com ([65.55.116.44]:32734 "EHLO
	blu0-omc1-s33.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753269Ab1FHX0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 19:26:09 -0400
X-Originating-IP: [184.145.208.36]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP29B1180134E3F1B2FDBB7696620@phx.gbl>
Date: Wed, 8 Jun 2011 19:17:17 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 03/28] rcu: Streamline code produced by
	__rcu_read_unlock()
References: <20110608192943.GA13211@linux.vnet.ibm.com> <1307561407-13809-3-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1307561407-13809-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 19:12:35 up 427 days,  9:02,  5 users,  load average: 0.03, 0.08,
	0.13
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 08 Jun 2011 23:17:19.0366 (UTC) FILETIME=[36A14260:01CC2632]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> Given some common flag combinations, particularly -Os, gcc will inline
> rcu_read_unlock_special() despite its being in an unlikely() clause.
> Use noline to prohibit this misoptimization.

noline -> noinline

> 
> In addition, move the second barrier() in __rcu_read_unlock() so that
> it is not on the common-case code path.  This will allow the compiler to
> generate better code for the common-case path through __rcu_read_unlock().
> 
> Finally, fix up whitespace in kernel/lockdep.c to keep checkpatch happy.

This cleanup probably moved to a separate patch, but this comment line
did not follow.

Other than that, feel free to add my

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

> 
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcutree_plugin.h |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index ea2e2fb..40a6db7 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -284,7 +284,7 @@ static struct list_head *rcu_next_node_entry(struct task_struct *t,
>   * notify RCU core processing or task having blocked during the RCU
>   * read-side critical section.
>   */
> -static void rcu_read_unlock_special(struct task_struct *t)
> +static noinline void rcu_read_unlock_special(struct task_struct *t)
>  {
>  	int empty;
>  	int empty_exp;
> @@ -387,11 +387,11 @@ void __rcu_read_unlock(void)
>  	struct task_struct *t = current;
>  
>  	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutree.c */
> -	--t->rcu_read_lock_nesting;
> -	barrier();  /* decrement before load of ->rcu_read_unlock_special */
> -	if (t->rcu_read_lock_nesting == 0 &&
> -	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
> -		rcu_read_unlock_special(t);
> +	if (--t->rcu_read_lock_nesting == 0) {
> +		barrier();  /* decr before ->rcu_read_unlock_special load */
> +		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
> +			rcu_read_unlock_special(t);
> +	}
>  #ifdef CONFIG_PROVE_LOCKING
>  	WARN_ON_ONCE(ACCESS_ONCE(t->rcu_read_lock_nesting) < 0);
>  #endif /* #ifdef CONFIG_PROVE_LOCKING */
> -- 
> 1.7.3.2
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

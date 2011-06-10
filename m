Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1FJHOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 03:14:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57531 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab1FJHO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 03:14:29 -0400
Message-ID: <4DF1C455.2080706@cn.fujitsu.com>
Date: Fri, 10 Jun 2011 15:14:29 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 03/28] rcu: Streamline code produced by __rcu_read_unlock()
References: <20110608192943.GA13211@linux.vnet.ibm.com> <1307561407-13809-3-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1307561407-13809-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-10 15:14:09,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-10 15:14:13,
	Serialize complete at 2011-06-10 15:14:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2011 03:29 AM, Paul E. McKenney wrote:
> Given some common flag combinations, particularly -Os, gcc will inline
> rcu_read_unlock_special() despite its being in an unlikely() clause.
> Use noline to prohibit this misoptimization.
> 
> In addition, move the second barrier() in __rcu_read_unlock() so that
> it is not on the common-case code path.  This will allow the compiler to
> generate better code for the common-case path through __rcu_read_unlock().
> 
> Finally, fix up whitespace in kernel/lockdep.c to keep checkpatch happy.
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

Since ACCESS_ONCE() is used for loading ->rcu_read_unlock_special, is the previous
barrier() still needed?

> +		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
> +			rcu_read_unlock_special(t);
> +	}
>  #ifdef CONFIG_PROVE_LOCKING
>  	WARN_ON_ONCE(ACCESS_ONCE(t->rcu_read_lock_nesting) < 0);
>  #endif /* #ifdef CONFIG_PROVE_LOCKING */


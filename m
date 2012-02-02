Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab2BBA4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 19:56:12 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:52953 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab2BBA4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 19:56:10 -0500
X-Originating-IP: 217.70.178.138
X-Originating-IP: 50.43.15.19
Date: Wed, 1 Feb 2012 16:55:54 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 03/41] rcu: Add lockdep-RCU checks for
 simple self-deadlock
Message-ID: <20120202005553.GD29058@leaf>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-3-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328125319-5205-3-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 11:41:21AM -0800, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> It is illegal to have a grace period within a same-flavor RCU read-side
> critical section, so this commit adds lockdep-RCU checks to splat when
> such abuse is encountered.  This commit does not detect more elaborate
> RCU deadlock situations.  These situations might be a job for lockdep
> enhancements.

Since doing so also violates the prohibition on blocking within an RCU
read-side critical section, wouldn't it suffice to call might_sleep() or
equivalent, which also detects other problems?  (Obviously this doesn't
apply to SRCU, but it applies to the other variants of RCU.)

> --- a/kernel/rcutiny.c
> +++ b/kernel/rcutiny.c
> @@ -319,6 +319,9 @@ static void rcu_process_callbacks(struct softirq_action *unused)
>   */
>  void synchronize_sched(void)
>  {
> +	rcu_lockdep_assert(!lock_is_held(&rcu_sched_lock_map),
> +			   "Illegal grace period in RCU read-side "
> +			   "critical section");

This message doesn't seem entirely obvious to me.  A grace period didn't
occur; a synchronize call did, which tried to request a grace period
that can never happen.

> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1816,6 +1816,9 @@ EXPORT_SYMBOL_GPL(call_rcu_bh);
>   */
>  void synchronize_sched(void)
>  {
> +	rcu_lockdep_assert(!lock_is_held(&rcu_sched_lock_map),
> +			   "Illegal synchronize_sched() in RCU-sched "
> +			   "read-side critical section");
>  	if (rcu_blocking_is_gp())
>  		return;
>  	wait_rcu_gp(call_rcu_sched);
> @@ -1833,6 +1836,9 @@ EXPORT_SYMBOL_GPL(synchronize_sched);
>   */
>  void synchronize_rcu_bh(void)
>  {
> +	rcu_lockdep_assert(!lock_is_held(&rcu_bh_lock_map),
> +			   "Illegal synchronize_sched() in RCU-bh "
> +			   "read-side critical section");

Copy-paste problem here: this should say synchronize_sched_bh.  (Or
perhaps it should say __func__. :) )

> --- a/kernel/srcu.c
> +++ b/kernel/srcu.c
> @@ -172,6 +172,10 @@ static void __synchronize_srcu(struct srcu_struct *sp, void (*sync_func)(void))
>  {
>  	int idx;
>  
> +	rcu_lockdep_assert(!lock_is_held(&sp->dep_map),
> +			   "Illegal SRCU grace period in same-type "
> +			   "SRCU read-side critical section");

Same issue with the message: a grace period didn't occur, and it never
will; a call to synchronize_srcu requesting a grace period occurred.

- Josh Triplett

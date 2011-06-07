Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab1FGATP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 20:19:15 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57089 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab1FGATM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 20:19:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=c1RsIDNmRq3qJcDZ7eUC6RdcjV1ohl23eTDakNDmwSv+HNzJqk9b43h7744wZi+ASP
         eHaAW0YpPZYm0ioFnMR7SqaYimf85/u5OoOGkg8cKaf5y+atcsf56cO9duUb6RIJ5mkV
         3iR/n2bXjD8fYvzfeFjQnKcPmNOdAQ3n1EcX0=
Date: Tue, 7 Jun 2011 02:19:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Milton Miller <miltonm@bga.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [1/4] rcu: Detect uses of rcu read side in extended quiescent
 states
Message-ID: <20110607001905.GE17026@somewhere.redhat.com>
References: <1307329858-14999-3-git-send-email-fweisbec@gmail.com>
 <rcu-splat-split-printk@mdm.bga.com>
 <20110606181021.GL3066@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110606181021.GL3066@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 11:10:21AM -0700, Paul E. McKenney wrote:
> commit c15d76f26712bd5228aa0c6af7a7e7c492a812c9
> Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Date:   Tue May 24 08:31:09 2011 -0700
> 
>     rcu: Restore checks for blocking in RCU read-side critical sections
>     
>     Long ago, using TREE_RCU with PREEMPT would result in "scheduling
>     while atomic" diagnostics if you blocked in an RCU read-side critical
>     section.  However, PREEMPT now implies TREE_PREEMPT_RCU, which defeats
>     this diagnostic.  This commit therefore adds a replacement diagnostic
>     based on PROVE_RCU.
>     
>     Because rcu_lockdep_assert() and lockdep_rcu_dereference() are now being
>     used for things that have nothing to do with rcu_dereference(), rename
>     lockdep_rcu_dereference() to lockdep_rcu_suspicious() and add a third
>     argument that is a string indicating what is suspicious.  This third
>     argument is passed in from a new third argument to rcu_lockdep_assert().
>     Update all calls to rcu_lockdep_assert() to add an informative third
>     argument.
>     
>     Finally, add a pair of rcu_lockdep_assert() calls from within
>     rcu_note_context_switch(), one complaining if a context switch occurs
>     in an RCU-bh read-side critical section and another complaining if a
>     context switch occurs in an RCU-sched read-side critical section.
>     These are present only if the PROVE_RCU kernel parameter is enabled.
>     
>     Again, you must enable PROVE_RCU to see these new diagnostics.  But you
>     are enabling PROVE_RCU to check out new RCU uses in any case, aren't you?
>     
>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

A little comment about this patch:

<snip>
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 88547c8..8b4b3da 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -153,6 +153,12 @@ void rcu_bh_qs(int cpu)
>   */
>  void rcu_note_context_switch(int cpu)
>  {
> +	rcu_lockdep_assert(!lock_is_held(&rcu_bh_lock_map),
> +			   "Illegal context switch in RCU-bh"
> +			   " read-side critical section");
> +	rcu_lockdep_assert(!lock_is_held(&rcu_sched_lock_map),
> +			   "Illegal context switch in RCU-sched"
> +			   " read-side critical section");

This looks like more a check to make inside might_sleep().
It's better because might_sleep() triggers the check even if
we don't actually go to sleep.

In fact I believe might_sleep() already does the job fine:

If !PREEMPT, might_sleep() detects that preemption is disabled
by rcu_read_lock().

If PREEMPT, might_sleep() checks rcu_preempt_depth().

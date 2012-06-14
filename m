Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab2FNQv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:51:28 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:34926 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab2FNQv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:51:27 -0400
Date: Thu, 14 Jun 2012 09:47:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: rcu: endless stalls
Message-ID: <20120614164746.GG2458@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120611133953.GI2425@linux.vnet.ibm.com>
 <1339424543.7350.101.camel@marge.simpson.net>
 <1339435214.7358.43.camel@marge.simpson.net>
 <20120611180112.GD2521@linux.vnet.ibm.com>
 <1339438242.7358.62.camel@marge.simpson.net>
 <1339558508.7472.26.camel@marge.simpson.net>
 <alpine.LSU.2.00.1206122120460.5221@eggly.anvils>
 <1339566974.7472.45.camel@marge.simpson.net>
 <1339571575.7472.78.camel@marge.simpson.net>
 <1339659932.7347.76.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339659932.7347.76.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061416-7282-0000-0000-000009E8AD83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 09:45:32AM +0200, Mike Galbraith wrote:
> On Wed, 2012-06-13 at 09:12 +0200, Mike Galbraith wrote: 
> > On Wed, 2012-06-13 at 07:56 +0200, Mike Galbraith wrote:
> > 
> > > Question remains though.  Maybe the box hit some other problem that led
> > > to death by RCU gripage, but the info I received indicated the box was
> > > in the midst of a major spin-fest.
> > 
> > To (maybe) speak more clearly, since it's a mutex like any other mutex
> > that loads of CPUs can hit if you've got loads of CPUs, did huge box
> > driver do something that we don't expect so many CPUs to be doing, thus
> > instigate simultaneous exit trouble (ie shoot self in foot), or did that
> > mutex addition create the exit trouble which box appeared to be having?
> 
> Crickets chirping.. I know what _that_ means: "tsk tsk, you dummy" :)

In my case, it means that I suspect you would rather me continue working
on my series of patches to further reduce RCU grace-period-initialization
latencies on large systems than worry about this patch.

If I understand correctly, your patch did what you wanted in the
situation at hand.  I have some quibbles, please see below.

> I suspected that would happen, but asked anyway because I couldn't
> imagine even 4096 CPUs getting tangled up for an _eternity_ trying to go
> to sleep, but the lock which landed after 32-stable where these beasts
> earn their daily fuel rods was splattered all over the event.  Oh well.
> 
> So, I can forget that and just make the thing not gripe itself to death
> should a stall for whatever reason be encountered again.
> 
> Rather than mucking about with rcu_cpu_stall_suppress, how about adjust
> timeout as you proceed, and block report functions?  That way, there's
> no fiddling with things used elsewhere, and it shouldn't matter how
> badly console is being be hammered, you get a full report, and maybe
> even only one.

That sounds like a very good interim approach to me!

> Hm, maybe I should forget hoping to keep check_cpu_stall() happy too,
> and only silently ignore it when busy.

But this is a good way to accumulate a variety of stalls, so not
recommended.

							Thanx, Paul

> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 0da7b88..e9dd654 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -727,24 +727,29 @@ static void record_gp_stall_check_time(struct rcu_state *rsp)
>  	rsp->jiffies_stall = jiffies + jiffies_till_stall_check();
>  }
> 
> +int rcu_stall_report_in_progress;
> +
>  static void print_other_cpu_stall(struct rcu_state *rsp)
>  {
>  	int cpu;
>  	long delta;
>  	unsigned long flags;
>  	int ndetected;
> -	struct rcu_node *rnp = rcu_get_root(rsp);
> +	struct rcu_node *root = rcu_get_root(rsp);

s/root/rnp_root/, please -- consistency with other places in the code.
But see below.

> +	struct rcu_node *rnp;
> 
>  	/* Only let one CPU complain about others per time interval. */
> 
> -	raw_spin_lock_irqsave(&rnp->lock, flags);
> +	raw_spin_lock_irqsave(&root->lock, flags);

On a 4096-CPU system, I bet that this needs to be trylock, with
a bare "return" on failure to acquire the lock.

Of course, that fails if someone is holding this lock for some other
reason.  So I believe that you need a separate ->stalllock in the
rcu_state structure for this purpose.  You won't need to disable irqs
when acquiring the lock.

>  	delta = jiffies - rsp->jiffies_stall;
> -	if (delta < RCU_STALL_RAT_DELAY || !rcu_gp_in_progress(rsp)) {
> -		raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +	if (delta < RCU_STALL_RAT_DELAY || !rcu_gp_in_progress(rsp) ||
> +			rcu_stall_report_in_progress) {

If you conditionally acquire the new ->stalllock, you shouldn't need
this added check.

> +		raw_spin_unlock_irqrestore(&root->lock, flags);
>  		return;
>  	}
>  	rsp->jiffies_stall = jiffies + 3 * jiffies_till_stall_check() + 3;
> -	raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +	rcu_stall_report_in_progress++;

And with the new ->stalllock, rcu_stall_report_in_progress can go away.

> +	raw_spin_unlock_irqrestore(&root->lock, flags);
> 
>  	/*
>  	 * OK, time to rat on our buddy...
> @@ -765,16 +770,23 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
>  				print_cpu_stall_info(rsp, rnp->grplo + cpu);
>  				ndetected++;
>  			}
> +
> +		/*
> +		 * Push the timeout back as we go.  With a slow serial
> +		 * console on a large machine, this may take a while.
> +		 */ 
> +		raw_spin_lock_irqsave(&root->lock, flags);
> +		rsp->jiffies_stall = jiffies + 3 * jiffies_till_stall_check() + 3;
> +		raw_spin_unlock_irqrestore(&root->lock, flags);

And the separate ->stalllock should make this unnecessary as well.
However, updating rsp->jiffies_stall periodically is a good idea
in order to decrease cache thrashing on ->stalllock.

>  	}
> 
>  	/*
>  	 * Now rat on any tasks that got kicked up to the root rcu_node
>  	 * due to CPU offlining.
>  	 */
> -	rnp = rcu_get_root(rsp);
> -	raw_spin_lock_irqsave(&rnp->lock, flags);
> -	ndetected = rcu_print_task_stall(rnp);
> -	raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +	raw_spin_lock_irqsave(&root->lock, flags);
> +	ndetected = rcu_print_task_stall(root);
> +	raw_spin_unlock_irqrestore(&root->lock, flags);

And the separate lock makes this change unnecessary, also.

>  	print_cpu_stall_info_end();
>  	printk(KERN_CONT "(detected by %d, t=%ld jiffies)\n",
> @@ -784,6 +796,10 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
>  	else if (!trigger_all_cpu_backtrace())
>  		dump_stack();
> 
> +	raw_spin_lock_irqsave(&root->lock, flags);
> +	rcu_stall_report_in_progress--;
> +	raw_spin_unlock_irqrestore(&root->lock, flags);

Ditto here.

> +
>  	/* If so configured, complain about tasks blocking the grace period. */
> 
>  	rcu_print_detail_task_stall(rsp);
> @@ -796,6 +812,17 @@ static void print_cpu_stall(struct rcu_state *rsp)
>  	unsigned long flags;
>  	struct rcu_node *rnp = rcu_get_root(rsp);
> 
> +	raw_spin_lock_irqsave(&rnp->lock, flags);
> +	if (rcu_stall_report_in_progress) {
> +		raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +		return;
> +	}
> +
> +	/* Reset timeout, dump_stack() may take a while on large machines. */
> +	rsp->jiffies_stall = jiffies + 3 * jiffies_till_stall_check() + 3;
> +	rcu_stall_report_in_progress++;
> +	raw_spin_unlock_irqrestore(&rnp->lock, flags);

And do trylock (without disabling irqs) here as well.  No need for
rcu_stall_report_in_progress.  You can update rsp->jiffies_stall
to reduce cache thrashing on ->stalllock.

> +
>  	/*
>  	 * OK, time to rat on ourselves...
>  	 * See Documentation/RCU/stallwarn.txt for info on how to debug
> @@ -813,6 +840,7 @@ static void print_cpu_stall(struct rcu_state *rsp)
>  	if (ULONG_CMP_GE(jiffies, rsp->jiffies_stall))
>  		rsp->jiffies_stall = jiffies +
>  				     3 * jiffies_till_stall_check() + 3;
> +	rcu_stall_report_in_progress--;

And ->stalllock makes this unnecessary as well.

>  	raw_spin_unlock_irqrestore(&rnp->lock, flags);
> 
>  	set_need_resched();  /* kick ourselves to get things going. */
> 
> -Mike
> 


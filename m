Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab2ADVas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 16:30:48 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:33565 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839Ab2ADVap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 16:30:45 -0500
Date: Wed, 4 Jan 2012 13:30:35 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: Improve detection of illegal synchronize_rcu() call
 from RCU read side
Message-ID: <20120104213035.GF2448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1324901803.31721.4.camel@lappy>
 <20111226163148.GC2435@linux.vnet.ibm.com>
 <20111226163734.GF28309@somewhere.redhat.com>
 <20111226195656.GD2435@linux.vnet.ibm.com>
 <20120104190336.GC1143@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120104190336.GC1143@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12010421-1780-0000-0000-00000213E93D
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000244; HX=3.00000180; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00102110; UDB=6.00026052; UTC=2012-01-04
 21:30:43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 08:03:39PM +0100, Frederic Weisbecker wrote:
> On Mon, Dec 26, 2011 at 11:56:57AM -0800, Paul E. McKenney wrote:
> > On Mon, Dec 26, 2011 at 05:37:36PM +0100, Frederic Weisbecker wrote:
> > > On Mon, Dec 26, 2011 at 08:31:48AM -0800, Paul E. McKenney wrote:
> > > > On Mon, Dec 26, 2011 at 02:16:43PM +0200, Sasha Levin wrote:
> > > > > Hi Paul,
> > > > > 
> > > > > I've recently got the following panic which was caused by khungtask:
> > > > > 
> > > > > [ 1921.589512] INFO: task rcuc/0:7 blocked for more than 120 seconds.
> > > > > [ 1921.590370] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > > > [ 1921.597103] rcuc/0          D ffff880012f61630  4400     7      2 0x00000000
> > > > > [ 1921.598646]  ffff880012f6b980 0000000000000086 ffff880012f6bfd8 00000000001d4740
> > > > > [ 1921.600289]  ffff880012f6bfd8 ffff880012f61630 ffff880012f6bfd8 ffff880012f6a000
> > > > > [ 1921.601707]  00000000001d4800 ffff880012f6a000 ffff880012f6bfd8 00000000001d4800
> > > > > [ 1921.603258] Call Trace:
> > > > > [ 1921.603703]  [<ffffffff8255eefa>] schedule+0x3a/0x50
> > > > > [ 1921.605462]  [<ffffffff8255cd65>] schedule_timeout+0x255/0x4d0
> > > > > [ 1921.606540]  [<ffffffff8112a25e>] ? mark_held_locks+0x6e/0x130
> > > > > [ 1921.607633]  [<ffffffff811277b2>] ? lock_release_holdtime+0xb2/0x160
> > > > > [ 1921.608798]  [<ffffffff825602bb>] ? _raw_spin_unlock_irq+0x2b/0x70
> > > > > [ 1921.610154]  [<ffffffff8255f630>] wait_for_common+0x120/0x170
> > > > > [ 1921.617878]  [<ffffffff81104f30>] ? try_to_wake_up+0x2f0/0x2f0
> > > > > [ 1921.618949]  [<ffffffff811754d0>] ? __call_rcu+0x3c0/0x3c0
> > > > > [ 1921.621405]  [<ffffffff8255f728>] wait_for_completion+0x18/0x20
> > > > > [ 1921.623622]  [<ffffffff810ee0b9>] wait_rcu_gp+0x59/0x80
> > > > > [ 1921.626789]  [<ffffffff810ec0c0>] ? perf_trace_rcu_batch_end+0x120/0x120
> > > > > [ 1921.629440]  [<ffffffff8255f554>] ? wait_for_common+0x44/0x170
> > > > > [ 1921.632445]  [<ffffffff81179d3c>] synchronize_rcu+0x1c/0x20
> > > > > [ 1921.635455]  [<ffffffff810f8980>] atomic_notifier_chain_unregister+0x60/0x80
> > > > 
> > > > This called synchronize_rcu().
> > > > 
> > > > > [ 1921.638550]  [<ffffffff8111bab3>] task_handoff_unregister+0x13/0x20
> > > > > [ 1921.641271]  [<ffffffff8211342f>] task_notify_func+0x2f/0x40
> > > > > [ 1921.643894]  [<ffffffff810f8817>] notifier_call_chain+0x67/0x110
> > > > > [ 1921.646580]  [<ffffffff810f8a14>] __atomic_notifier_call_chain+0x74/0x110
> > > > 
> > > > This called rcu_read_lock().
> > > > 
> > > > Now, calling synchronize_rcu() from within an RCU read-side critical
> > > > section is grossly illegal.  This will result in either deadlock (for
> > > > preemptible RCU) or premature grace-period end and memory corruption
> > > > (for non-preemptible RCU).
> > > 
> > > Don't we have debugging checks for that? I can't seem to find any.
> > > May be worth having a WARN_ON_ONCE(rcu_read_lock_held()) in
> > > synchronize_rcu().
> > 
> > Indeed, my bad.  It should be possible to make lockdep do this.
> 
> Actually for the case of RCU, the wait_for_completion() called by synchronize_rcu()
> has a might_sleep() call that triggers a warning in this case.
> 
> But in the case of SMP with 1 online CPU, the rcu_blocking_is_gp()
> checks returns right away on rcutree. So probably we need this?

I modified this to push the might_sleep() down into the
rcu_blocking_is_gp() function, queued the result, and retained your
Signed-off-by.  (Please let me know if there is any problem with this.)

This does work for TREE_PREEMPT_RCU and for synchronize_rcu_bh() in
TREE_RCU, but not for synchronize_sched() in TREE_RCU.  This is because
rcu_read_lock() and rcu_read_unlock() are no-ops in the TREE_RCU case.

So I queued up a separate patch using rcu_lockdep_assert() to check for
illegal RCU grace period within the same-type RCU read-side critical
section, including for SRCU.  This is also a partial solution, as it
does not handle things like this:

	void foo(void)
	{
		mutex_lock(&my_mutex);
		. . .
		synchronize_srcu(&my_srcu);
		. . .
		mutex_unlock(&my_mutex);
	}

	void bar(void)
	{
		int idx;

		idx = rcu_read_lock(&m_srcu);
		. . .
		mutex_lock(&my_mutex);
		. . .
		mutex_unlock(&my_mutex);
		. . .
		srcu_read_unlock(&m_srcu, idx);
	}

This can be extended into a chain of locks and a chain of SRCU instances.
For an example of the latter, consider an SRCU-A read-side critical
section containing an SRCU-B grace period, an SRCU-B read-side critical
section containing an SRCU-C grace period, and so on, with the SRCU-Z
read-side critical section containing an RCU-A grace period.  But it
is OK to hold a mutex across one SRCU read-side critical section while
acquiring that same mutex within another same-flavor SRCU read-side
critical section.  So the analogy with reader-writer locking only goes
so far.

At the moment, a full solution seems to require some surgery on lockdep
itself, but perhaps there is a better way.

> rcutiny seems to be fine with the cond_resched() call, but srcu needs
> a special treatment.

For the moment, I just applied rcu_lockdep_assert() everywhere -- zero
cost on non-lockdep kernels, and fully handles all of the RCU simple
self-deadlock cases.

							Thanx, Paul

> ---
> >From 27b99308e034046df86bab9d57be082815d77762 Mon Sep 17 00:00:00 2001
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Wed, 4 Jan 2012 19:20:58 +0100
> Subject: [PATCH] rcu: Improve detection of illegal synchronize_rcu() call from RCU read side
> 
> In RCU tree, synchronize_{rcu,sched,rcu_bh} can detect illegal call from
> RCU read side critical section with might_sleep() called before waiting
> for the grace period completion.
> 
> But in RCU tree, the calls to synchronize_sched() and synchronize_rcu_bh()
> return immediately if only one CPU is running. In this case we are missing
> the checks for calls of these APIs from atomic sections (including RCU read
> side).
> 
> To cover every cases, put a might_sleep() call in the beginning of those
> two functions.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/rcutree.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 6c4a672..68cded7 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1816,6 +1816,12 @@ EXPORT_SYMBOL_GPL(call_rcu_bh);
>   */
>  void synchronize_sched(void)
>  {
> +	/*
> +	 * Detect we are not calling this while in RCU
> +	 * read side critical section, even with 1 online
> +	 * CPU.
> +	 */
> +	might_sleep();
>  	if (rcu_blocking_is_gp())
>  		return;
>  	wait_rcu_gp(call_rcu_sched);
> @@ -1833,6 +1839,12 @@ EXPORT_SYMBOL_GPL(synchronize_sched);
>   */
>  void synchronize_rcu_bh(void)
>  {
> +	/*
> +	 * Detect we are not calling this while in RCU
> +	 * read side critical section, even with 1 online
> +	 * CPU.
> +	 */
> +	might_sleep();
>  	if (rcu_blocking_is_gp())
>  		return;
>  	wait_rcu_gp(call_rcu_bh);
> -- 
> 1.7.0.4
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab1LZT5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 14:57:05 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:52051 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab1LZT5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 14:57:03 -0500
Date: Mon, 26 Dec 2011 11:56:57 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: INFO: task rcuc/0:7 blocked for more than 120 seconds.
Message-ID: <20111226195656.GD2435@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1324901803.31721.4.camel@lappy>
 <20111226163148.GC2435@linux.vnet.ibm.com>
 <20111226163734.GF28309@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111226163734.GF28309@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11122619-2398-0000-0000-000002FEE22A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 26, 2011 at 05:37:36PM +0100, Frederic Weisbecker wrote:
> On Mon, Dec 26, 2011 at 08:31:48AM -0800, Paul E. McKenney wrote:
> > On Mon, Dec 26, 2011 at 02:16:43PM +0200, Sasha Levin wrote:
> > > Hi Paul,
> > > 
> > > I've recently got the following panic which was caused by khungtask:
> > > 
> > > [ 1921.589512] INFO: task rcuc/0:7 blocked for more than 120 seconds.
> > > [ 1921.590370] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > [ 1921.597103] rcuc/0          D ffff880012f61630  4400     7      2 0x00000000
> > > [ 1921.598646]  ffff880012f6b980 0000000000000086 ffff880012f6bfd8 00000000001d4740
> > > [ 1921.600289]  ffff880012f6bfd8 ffff880012f61630 ffff880012f6bfd8 ffff880012f6a000
> > > [ 1921.601707]  00000000001d4800 ffff880012f6a000 ffff880012f6bfd8 00000000001d4800
> > > [ 1921.603258] Call Trace:
> > > [ 1921.603703]  [<ffffffff8255eefa>] schedule+0x3a/0x50
> > > [ 1921.605462]  [<ffffffff8255cd65>] schedule_timeout+0x255/0x4d0
> > > [ 1921.606540]  [<ffffffff8112a25e>] ? mark_held_locks+0x6e/0x130
> > > [ 1921.607633]  [<ffffffff811277b2>] ? lock_release_holdtime+0xb2/0x160
> > > [ 1921.608798]  [<ffffffff825602bb>] ? _raw_spin_unlock_irq+0x2b/0x70
> > > [ 1921.610154]  [<ffffffff8255f630>] wait_for_common+0x120/0x170
> > > [ 1921.617878]  [<ffffffff81104f30>] ? try_to_wake_up+0x2f0/0x2f0
> > > [ 1921.618949]  [<ffffffff811754d0>] ? __call_rcu+0x3c0/0x3c0
> > > [ 1921.621405]  [<ffffffff8255f728>] wait_for_completion+0x18/0x20
> > > [ 1921.623622]  [<ffffffff810ee0b9>] wait_rcu_gp+0x59/0x80
> > > [ 1921.626789]  [<ffffffff810ec0c0>] ? perf_trace_rcu_batch_end+0x120/0x120
> > > [ 1921.629440]  [<ffffffff8255f554>] ? wait_for_common+0x44/0x170
> > > [ 1921.632445]  [<ffffffff81179d3c>] synchronize_rcu+0x1c/0x20
> > > [ 1921.635455]  [<ffffffff810f8980>] atomic_notifier_chain_unregister+0x60/0x80
> > 
> > This called synchronize_rcu().
> > 
> > > [ 1921.638550]  [<ffffffff8111bab3>] task_handoff_unregister+0x13/0x20
> > > [ 1921.641271]  [<ffffffff8211342f>] task_notify_func+0x2f/0x40
> > > [ 1921.643894]  [<ffffffff810f8817>] notifier_call_chain+0x67/0x110
> > > [ 1921.646580]  [<ffffffff810f8a14>] __atomic_notifier_call_chain+0x74/0x110
> > 
> > This called rcu_read_lock().
> > 
> > Now, calling synchronize_rcu() from within an RCU read-side critical
> > section is grossly illegal.  This will result in either deadlock (for
> > preemptible RCU) or premature grace-period end and memory corruption
> > (for non-preemptible RCU).
> 
> Don't we have debugging checks for that? I can't seem to find any.
> May be worth having a WARN_ON_ONCE(rcu_read_lock_held()) in
> synchronize_rcu().

Indeed, my bad.  It should be possible to make lockdep do this.  The
potential advantage is that this would also detect more elaborate
scenarios, including:

	T1:
	i = srcu_read_lock(&myfirstsrcu);
	synchronize_srcu(&mysecondsrcu);
	srcu_read_unlock(&myfirstsrcu, i);

	T2:
	i = srcu_read_lock(&mysecondsrcu);
	synchronize_srcu(&myfirstsrcu);
	srcu_read_unlock(&mysecondsrcu, i);

Perhaps I should try telling lockdep that the RCU "locks" were
write-acquired and then immediately released in synchronize_rcu()
and friends.

Thoughts?

							Thanx, Paul


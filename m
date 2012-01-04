Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab2ADTDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 14:03:46 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55808 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab2ADTDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 14:03:44 -0500
Date: Wed, 4 Jan 2012 20:03:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] rcu: Improve detection of illegal synchronize_rcu() call
 from RCU read side
Message-ID: <20120104190336.GC1143@somewhere>
References: <1324901803.31721.4.camel@lappy>
 <20111226163148.GC2435@linux.vnet.ibm.com>
 <20111226163734.GF28309@somewhere.redhat.com>
 <20111226195656.GD2435@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111226195656.GD2435@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 26, 2011 at 11:56:57AM -0800, Paul E. McKenney wrote:
> On Mon, Dec 26, 2011 at 05:37:36PM +0100, Frederic Weisbecker wrote:
> > On Mon, Dec 26, 2011 at 08:31:48AM -0800, Paul E. McKenney wrote:
> > > On Mon, Dec 26, 2011 at 02:16:43PM +0200, Sasha Levin wrote:
> > > > Hi Paul,
> > > > 
> > > > I've recently got the following panic which was caused by khungtask:
> > > > 
> > > > [ 1921.589512] INFO: task rcuc/0:7 blocked for more than 120 seconds.
> > > > [ 1921.590370] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > > [ 1921.597103] rcuc/0          D ffff880012f61630  4400     7      2 0x00000000
> > > > [ 1921.598646]  ffff880012f6b980 0000000000000086 ffff880012f6bfd8 00000000001d4740
> > > > [ 1921.600289]  ffff880012f6bfd8 ffff880012f61630 ffff880012f6bfd8 ffff880012f6a000
> > > > [ 1921.601707]  00000000001d4800 ffff880012f6a000 ffff880012f6bfd8 00000000001d4800
> > > > [ 1921.603258] Call Trace:
> > > > [ 1921.603703]  [<ffffffff8255eefa>] schedule+0x3a/0x50
> > > > [ 1921.605462]  [<ffffffff8255cd65>] schedule_timeout+0x255/0x4d0
> > > > [ 1921.606540]  [<ffffffff8112a25e>] ? mark_held_locks+0x6e/0x130
> > > > [ 1921.607633]  [<ffffffff811277b2>] ? lock_release_holdtime+0xb2/0x160
> > > > [ 1921.608798]  [<ffffffff825602bb>] ? _raw_spin_unlock_irq+0x2b/0x70
> > > > [ 1921.610154]  [<ffffffff8255f630>] wait_for_common+0x120/0x170
> > > > [ 1921.617878]  [<ffffffff81104f30>] ? try_to_wake_up+0x2f0/0x2f0
> > > > [ 1921.618949]  [<ffffffff811754d0>] ? __call_rcu+0x3c0/0x3c0
> > > > [ 1921.621405]  [<ffffffff8255f728>] wait_for_completion+0x18/0x20
> > > > [ 1921.623622]  [<ffffffff810ee0b9>] wait_rcu_gp+0x59/0x80
> > > > [ 1921.626789]  [<ffffffff810ec0c0>] ? perf_trace_rcu_batch_end+0x120/0x120
> > > > [ 1921.629440]  [<ffffffff8255f554>] ? wait_for_common+0x44/0x170
> > > > [ 1921.632445]  [<ffffffff81179d3c>] synchronize_rcu+0x1c/0x20
> > > > [ 1921.635455]  [<ffffffff810f8980>] atomic_notifier_chain_unregister+0x60/0x80
> > > 
> > > This called synchronize_rcu().
> > > 
> > > > [ 1921.638550]  [<ffffffff8111bab3>] task_handoff_unregister+0x13/0x20
> > > > [ 1921.641271]  [<ffffffff8211342f>] task_notify_func+0x2f/0x40
> > > > [ 1921.643894]  [<ffffffff810f8817>] notifier_call_chain+0x67/0x110
> > > > [ 1921.646580]  [<ffffffff810f8a14>] __atomic_notifier_call_chain+0x74/0x110
> > > 
> > > This called rcu_read_lock().
> > > 
> > > Now, calling synchronize_rcu() from within an RCU read-side critical
> > > section is grossly illegal.  This will result in either deadlock (for
> > > preemptible RCU) or premature grace-period end and memory corruption
> > > (for non-preemptible RCU).
> > 
> > Don't we have debugging checks for that? I can't seem to find any.
> > May be worth having a WARN_ON_ONCE(rcu_read_lock_held()) in
> > synchronize_rcu().
> 
> Indeed, my bad.  It should be possible to make lockdep do this.

Actually for the case of RCU, the wait_for_completion() called by synchronize_rcu()
has a might_sleep() call that triggers a warning in this case.

But in the case of SMP with 1 online CPU, the rcu_blocking_is_gp()
checks returns right away on rcutree. So probably we need this?

rcutiny seems to be fine with the cond_resched() call, but srcu needs
a special treatment.

---
>From 27b99308e034046df86bab9d57be082815d77762 Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Wed, 4 Jan 2012 19:20:58 +0100
Subject: [PATCH] rcu: Improve detection of illegal synchronize_rcu() call from RCU read side

In RCU tree, synchronize_{rcu,sched,rcu_bh} can detect illegal call from
RCU read side critical section with might_sleep() called before waiting
for the grace period completion.

But in RCU tree, the calls to synchronize_sched() and synchronize_rcu_bh()
return immediately if only one CPU is running. In this case we are missing
the checks for calls of these APIs from atomic sections (including RCU read
side).

To cover every cases, put a might_sleep() call in the beginning of those
two functions.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/rcutree.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 6c4a672..68cded7 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1816,6 +1816,12 @@ EXPORT_SYMBOL_GPL(call_rcu_bh);
  */
 void synchronize_sched(void)
 {
+	/*
+	 * Detect we are not calling this while in RCU
+	 * read side critical section, even with 1 online
+	 * CPU.
+	 */
+	might_sleep();
 	if (rcu_blocking_is_gp())
 		return;
 	wait_rcu_gp(call_rcu_sched);
@@ -1833,6 +1839,12 @@ EXPORT_SYMBOL_GPL(synchronize_sched);
  */
 void synchronize_rcu_bh(void)
 {
+	/*
+	 * Detect we are not calling this while in RCU
+	 * read side critical section, even with 1 online
+	 * CPU.
+	 */
+	might_sleep();
 	if (rcu_blocking_is_gp())
 		return;
 	wait_rcu_gp(call_rcu_bh);
-- 
1.7.0.4

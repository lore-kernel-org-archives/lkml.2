Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab1EPHIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 03:08:55 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37410 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576Ab1EPHIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 03:08:54 -0400
Date: Mon, 16 May 2011 00:08:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
Message-ID: <20110516070849.GA20580@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4DCC52FB.6030500@kernel.org>
 <BANLkTin1haL+isnR0UUoHdNm99bnxYPt-g@mail.gmail.com>
 <20110514142621.GB2258@linux.vnet.ibm.com>
 <20110514153118.GA24311@linux.vnet.ibm.com>
 <20110514183453.GA32756@linux.vnet.ibm.com>
 <4DCF5322.7030305@kernel.org>
 <4DCF6789.70701@kernel.org>
 <4DCF696B.8020304@kernel.org>
 <20110515060415.GF2258@linux.vnet.ibm.com>
 <20110515065949.GA11330@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110515065949.GA11330@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 14, 2011 at 11:59:49PM -0700, Paul E. McKenney wrote:
> On Sat, May 14, 2011 at 11:04:15PM -0700, Paul E. McKenney wrote:
> > On Sat, May 14, 2011 at 10:49:31PM -0700, Yinghai Lu wrote:
> > > On 05/14/2011 10:41 PM, Yinghai Lu wrote:
> > > > On 05/14/2011 09:14 PM, Yinghai Lu wrote:
> > > >> On 05/14/2011 11:34 AM, Paul E. McKenney wrote:
> > > >>>> and do the inspection afterwards.
> > > >>>
> > > >>> And here is a lightly-tested patch, which applies on tip/core/rcu.
> > > >>>
> > > >>> This problem could account for both the long delays seen with e59fb312
> > > >>> (Decrease memory-barrier usage based on semi-formal proof) and the
> > > >>> shorter delays seen with a26ac245 (move TREE_RCU from softirq to kthread).
> > > >>
> > > >> yes. it fixes the problem.
> > > >>
> > > >> for 1024g system when hotadd mem enabled in kernel config
> > > >>
> > > >> [   31.814803] cpu_dev_init done
> > > >> [   35.437163] memory_dev_init done
> > > >>
> > > >> even it is with gcc from opensuse 11.3
> > > > 
> > > > got:
> > > > 
> > > > [   86.931217] Switched to NOHz mode on CPU #0
> > > > [   86.931272] Switched to NOHz mode on CPU #25
> > > > [   86.931278] ------------[ cut here ]------------
> > > > [   86.931290] WARNING: at kernel/rcutree.c:364 rcu_enter_nohz+0x44/0x76()
> > > > [   86.931294] Hardware name: Sun Fire X4800 M2 
> > > > [   86.931297] Modules linked in:
> > > > [   86.931303] Pid: 0, comm: swapper Not tainted 2.6.39-rc7-tip-yh-04836-g5e42dc2-dirty #3
> > > > [   86.931307] Call Trace:
> > > > [   86.931333]  [<ffffffff81080280>] warn_slowpath_common+0x85/0x9d
> > > > [   86.931338] Switched to NOHz mode on CPU #74
> > > > [   86.931346]  [<ffffffff810802b2>] warn_slowpath_null+0x1a/0x1c
> > > > [   86.931356]  [<ffffffff810d3615>] rcu_enter_nohz+0x44/0x76
> > > > [   86.931370]  [<ffffffff810ab3cb>] tick_nohz_stop_sched_tick+0x27d/0x366
> > > > [   86.931381]  [<ffffffff810391bc>] cpu_idle+0x7a/0xcc
> > > > [   86.931397]  [<ffffffff81bd1aa3>] rest_init+0xb7/0xbe
> > > > [   86.931408]  [<ffffffff81bd19ec>] ? csum_partial_copy_generic+0x16c/0x16c
> > > > [   86.931423]  [<ffffffff82738e39>] start_kernel+0x3b2/0x3bd
> > > > [   86.931428] Switched to NOHz mode on CPU #94
> > > > [   86.931436]  [<ffffffff827382cc>] x86_64_start_reservations+0x9c/0xa0
> > > > [   86.931446]  [<ffffffff827384a8>] x86_64_start_kernel+0x1d8/0x1e3
> > > > [   86.931463] ---[ end trace 2cfc591bf7de931f ]---
> > > > [   86.931598] Switched to NOHz mode on CPU #151
> > > > [   86.931613] Switched to NOHz mode on CPU #152
> > > 
> > > it seems gcc from Fedora 14 is not happy with this patch.
> > > 
> > > [   35.113696] cpu_dev_init done
> > > [  155.963662] memory_dev_init done
> > 
> > Hmmm...  It looks like my attempts to make RCU recover from misnesting are
> > not completely foolproof.  I will be especially happy to look into this
> > if you could look for the source of the irq_enter()/irq_exit() misnesting.
> > 
> > (And yes, it still might be a bug in my code -- I will be looking at that
> > yet again as well.)
> 
> And the way you can prove that it is my code rather than the arch
> code is to show that the warning happens on your system when the
> irq_enter()/irq_exit() calls are perfectly nested.

So I took another look at the RCU debugfs stats you provided earlier,
and realized that your system gets a lot more NMIs than do the ones
that I have access to.  So as a diagnostic patch, I ifdefed out the
body of rcu_nmi_enter() and rcu_nmi_exit().

If everything works perfectly with this patch applied, that would point
to a race in those two functions.  Please feel free to apply on top
of my earlier diagnostic patches or directly on tip/core/rcu -- either
would provide good information.

							Thanx, Paul

------------------------------------------------------------------------

 rcutree.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 4a9e4aa..0d4a5b5 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -430,6 +430,7 @@ void rcu_exit_nohz(void)
  */
 void rcu_nmi_enter(void)
 {
+#if 0
 	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
 
 	if (rdtp->dynticks_nmi_nesting == 0 &&
@@ -443,6 +444,7 @@ void rcu_nmi_enter(void)
 	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
 	smp_mb__after_atomic_inc();  /* See above. */
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
+#endif
 }
 
 /**
@@ -454,6 +456,7 @@ void rcu_nmi_enter(void)
  */
 void rcu_nmi_exit(void)
 {
+#if 0
 	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
 
 	if (rdtp->dynticks_nmi_nesting == 0 ||
@@ -466,6 +469,7 @@ void rcu_nmi_exit(void)
 	atomic_inc(&rdtp->dynticks);
 	smp_mb__after_atomic_inc();  /* Force delay to next write. */
 	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
+#endif
 }
 
 /**

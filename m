Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab1FZCLF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 22:11:05 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59812 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab1FZCLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 22:11:02 -0400
Date: Sat, 25 Jun 2011 19:10:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/3 v3] rcu: Detect rcu uses under extended quiescent
 state
Message-ID: <20110626021055.GO2266@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1308870760-14153-1-git-send-email-fweisbec@gmail.com>
 <20110624035311.GB2266@linux.vnet.ibm.com>
 <20110624112045.GF8058@somewhere.redhat.com>
 <20110626011315.GA27294@linux.vnet.ibm.com>
 <20110626015459.GA28035@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110626015459.GA28035@somewhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 26, 2011 at 03:55:03AM +0200, Frederic Weisbecker wrote:
> On Sat, Jun 25, 2011 at 06:13:15PM -0700, Paul E. McKenney wrote:
> > On Fri, Jun 24, 2011 at 01:20:49PM +0200, Frederic Weisbecker wrote:
> > > On Thu, Jun 23, 2011 at 08:53:11PM -0700, Paul E. McKenney wrote:
> > > > On Fri, Jun 24, 2011 at 01:12:37AM +0200, Frederic Weisbecker wrote:
> > > > > This time I have no current practical cases to fix. Those I fixed
> > > > > in previous versions were actually using rcu_dereference_raw(), which
> > > > > is legal in extended qs.
> > > > > 
> > > > > Frederic Weisbecker (3):
> > > > >   rcu: Detect illegal rcu dereference in extended quiescent state
> > > > >   rcu: Inform the user about dynticks idle mode on PROVE_RCU warning
> > > > >   rcu: Warn when rcu_read_lock() is used in extended quiescent state
> > > > > 
> > > > >  include/linux/rcupdate.h |   68 +++++++++++++++++++++++++++++++++++++++-------
> > > > >  kernel/lockdep.c         |    4 +++
> > > > >  kernel/rcupdate.c        |    4 +++
> > > > >  kernel/rcutiny.c         |   13 +++++++++
> > > > >  kernel/rcutree.c         |   14 +++++++++
> > > > >  5 files changed, 93 insertions(+), 10 deletions(-)
> > > > 
> > > > Queued, thank you, Frederic!
> > > > 
> > > > I have also applied your approach to SRCU, and I applied the following
> > > > to simplify the code a bit -- please let me know if there are any
> > > > problems with this approach.
> > > > 
> > > > 							Thanx, Paul
> > > > 
> > > > ------------------------------------------------------------------------
> > > > 
> > > > rcu: Remove one layer of abstraction from PROVE_RCU checking
> > > > 
> > > > Simplify things a bit by substituting the definitions of the single-line
> > > > rcu_read_acquire(), rcu_read_release(), rcu_read_acquire_bh(),
> > > > rcu_read_release_bh(), rcu_read_acquire_sched(), and
> > > > rcu_read_release_sched() functions at their call points.
> > > > 
> > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > 
> > > Yeah looks good. Thanks!
> > 
> > And I thought that you might be amused by the following.  Hmmm...  I wonder
> > how I am going to use event tracing for the portions of RCU that execute
> > while in dyntick-idle mode...
> > 
> > But first...  It turns out that rcu_check_extended_qs() is sometimes
> > called with preemption enabled (for example, in CONFIG_TREE_PREEMPT_RCU),
> > which causes smp_processor_id() to complain.  One way to fix this would be
> > to write rcu_check_extended_qs() as follows:
> > 
> > 	bool rcu_check_extended_qs(void)
> > 	{
> > 		struct rcu_dynticks *rdtp;
> > 
> > 		preempt_disable();
> > 		rdtp = &__get_cpu_var(rcu_dynticks);
> > 		if (atomic_read(&rdtp->dynticks) & 0x1) {
> > 			preempt_enable();
> > 			return false;
> > 		}
> > 		preempt_enable();
> > 		return true;
> > 	}
> > 	EXPORT_SYMBOL_GPL(rcu_check_extended_qs);
> > 
> > Does the above make sense, or is there a higher-level bug that should be
> > addressed in a different way?
> 
> Ah right. In fact rcu_read_lock_heald() shouldn't expect to have preemption
> disabled, at least not in PREEMPT_RCU.
> 
> So yeah, looks good.

OK, I am folding that into your original patch, then.

> > See below for the splat due to tracing while in dyntick-idle mode.
> > Might this explain some otherwise mysterious crashes when tracing is
> > enabled?
> 
> May be.
> 
> So this is using a tracepoint in dynticks idle mode. There are various
> ways to solve this:
> 
> - move the tracepoint call out of that place, in an rcu safe place
> - call rcu_exit_nohz() / rcu_enter_nohz() there. But we need to know if the
>   tracepoint if activated before that, or this will impact the tracing off case too.
> - split out the rcu extended qs from tick stop logic (https://patchwork.kernel.org/patch/850542/)
>   That looks like a big change just to fix such a bug but anyway it is going to be needed for the nohz
>   cpuset patches I'm working on. Once that's split, rcu_enter_nohz() can be called later after
>   the tick has been stopped, like right before we hlt the cpu.

This last sounds to me like the best approach.  And if I see some
mysterious crashes, I will try commenting out that trace point.
Though any mysterious crashes that I see are more likely due to my
messing something up.  ;-)


							Thanx, Paul

> > ------------------------------------------------------------------------
> > 
> > [    0.449600] ===============================
> > [    0.449605] [ INFO: suspicious RCU usage. ]
> > [    0.449610] -------------------------------
> > [    0.449616] /usr/local/autobench/var/tmp/build/arch/powerpc/include/asm/trace.h:122 suspicious rcu_dereference_check() usage!
> > [    0.449626] 
> > [    0.449627] other info that might help us debug this:
> > [    0.449628] 
> > [    0.449636] 
> > [    0.449637] rcu_scheduler_active = 1, debug_locks = 0
> > [    0.449644] rcu is in extended quiescent state!
> > [    0.449650] no locks held by kworker/0:0/0.
> > [    0.449655] 
> > [    0.449656] stack backtrace:
> > [    0.449662] Call Trace:
> > [    0.449671] [c0000000e66d7b20] [c00000000001352c] .show_stack+0x70/0x184 (unreliable)
> > [    0.449684] [c0000000e66d7bd0] [c0000000000b1ef0] .lockdep_rcu_suspicious+0xe8/0x110
> > [    0.449697] [c0000000e66d7c70] [c000000000044fc0] .__trace_hcall_exit+0x1e4/0x218
> > [    0.449709] [c0000000e66d7d20] [c000000000045c40] .plpar_hcall_norets+0xb4/0xd0
> > [    0.449720] [c0000000e66d7d90] [c000000000047cd4] .pseries_dedicated_idle_sleep+0x1b0/0x22c
> > [    0.449731] [c0000000e66d7e40] [c000000000016004] .cpu_idle+0x144/0x22c
> > [    0.449743] [c0000000e66d7ed0] [c0000000006572cc] .start_secondary+0x378/0x384
> > [    0.449754] [c0000000e66d7f90] [c000000000009268] .start_secondary_prolog+0x10/0x14
> > 

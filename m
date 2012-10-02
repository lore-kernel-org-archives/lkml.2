Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab2JBV1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 17:27:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47774 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932330Ab2JBV1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 17:27:13 -0400
Date: Tue, 2 Oct 2012 23:27:04 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org
Subject: Re: Lockdep complains about commit 1331e7a1bb ("rcu: Remove
 _rcu_barrier() dependency on __stop_machine()")
In-Reply-To: <20121002170149.GC2465@linux.vnet.ibm.com>
Message-ID: <alpine.LNX.2.00.1210022324050.23544@pobox.suse.cz>
References: <alpine.LNX.2.00.1210021810350.23544@pobox.suse.cz> <20121002170149.GC2465@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2012, Paul E. McKenney wrote:

> > 1331e7a1bbe1f11b19c4327ba0853bee2a606543 is the first bad commit
> > commit 1331e7a1bbe1f11b19c4327ba0853bee2a606543
> > Author: Paul E. McKenney <paul.mckenney@linaro.org>
> > Date:   Thu Aug 2 17:43:50 2012 -0700
> > 
> >     rcu: Remove _rcu_barrier() dependency on __stop_machine()
> >     
> >     Currently, _rcu_barrier() relies on preempt_disable() to prevent
> >     any CPU from going offline, which in turn depends on CPU hotplug's
> >     use of __stop_machine().
> >     
> >     This patch therefore makes _rcu_barrier() use get_online_cpus() to
> >     block CPU-hotplug operations.  This has the added benefit of removing
> >     the need for _rcu_barrier() to adopt callbacks:  Because CPU-hotplug
> >     operations are excluded, there can be no callbacks to adopt.  This
> >     commit simplifies the code accordingly.
> >     
> >     Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> >     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >     Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > ==
> > 
> > is causing lockdep to complain (see the full trace below). I haven't yet 
> > had time to analyze what exactly is happening, and probably will not have 
> > time to do so until tomorrow, so just sending this as a heads-up in case 
> > anyone sees the culprit immediately.
> 
> Hmmm...  Does the following patch help?  It swaps the order in which
> rcu_barrier() acquires the hotplug and rcu_barrier locks.

It changed the report slightly (see for example the change in possible 
unsafe locking scenario, rcu_sched_state.barrier_mutex vanished and it's 
now directly about cpu_hotplug.lock). With the patch applied I get



======================================================
[ INFO: possible circular locking dependency detected ]
3.6.0-03888-g3f99f3b #145 Not tainted
-------------------------------------------------------
kworker/u:3/43 is trying to acquire lock:
 (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff81049287>] get_online_cpus+0x37/0x50

but task is already holding lock:
 (slab_mutex){+.+.+.}, at: [<ffffffff81178175>] kmem_cache_destroy+0x45/0xe0

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (slab_mutex){+.+.+.}:
       [<ffffffff810aeb22>] validate_chain+0x632/0x720
       [<ffffffff810aef69>] __lock_acquire+0x359/0x580
       [<ffffffff810af2b1>] lock_acquire+0x121/0x190
       [<ffffffff8156130c>] __mutex_lock_common+0x5c/0x450
       [<ffffffff8156182e>] mutex_lock_nested+0x3e/0x50
       [<ffffffff8155cafa>] cpuup_callback+0x2f/0xbe
       [<ffffffff81568bc3>] notifier_call_chain+0x93/0x140
       [<ffffffff81077289>] __raw_notifier_call_chain+0x9/0x10
       [<ffffffff8155b1ac>] _cpu_up+0xc9/0x162
       [<ffffffff8155b301>] cpu_up+0xbc/0x11b
       [<ffffffff81ae1793>] smp_init+0x6b/0x9f
       [<ffffffff81ac57d6>] kernel_init+0x147/0x1dc
       [<ffffffff8156eca4>] kernel_thread_helper+0x4/0x10

-> #0 (cpu_hotplug.lock){+.+.+.}:
       [<ffffffff810ae48e>] check_prev_add+0x3de/0x440
       [<ffffffff810aeb22>] validate_chain+0x632/0x720
       [<ffffffff810aef69>] __lock_acquire+0x359/0x580
       [<ffffffff810af2b1>] lock_acquire+0x121/0x190
       [<ffffffff8156130c>] __mutex_lock_common+0x5c/0x450
       [<ffffffff8156182e>] mutex_lock_nested+0x3e/0x50
       [<ffffffff81049287>] get_online_cpus+0x37/0x50
       [<ffffffff810f3a92>] _rcu_barrier+0x22/0x1f0
       [<ffffffff810f3c70>] rcu_barrier_sched+0x10/0x20
       [<ffffffff810f3c89>] rcu_barrier+0x9/0x10
       [<ffffffff81178201>] kmem_cache_destroy+0xd1/0xe0
       [<ffffffffa0488154>] nf_conntrack_cleanup_net+0xe4/0x110 [nf_conntrack]
       [<ffffffffa04881aa>] nf_conntrack_cleanup+0x2a/0x70 [nf_conntrack]
       [<ffffffffa04892ce>] nf_conntrack_net_exit+0x5e/0x80 [nf_conntrack]
       [<ffffffff81458629>] ops_exit_list+0x39/0x60
       [<ffffffff81458c5b>] cleanup_net+0xfb/0x1b0
       [<ffffffff810691eb>] process_one_work+0x26b/0x4c0
       [<ffffffff8106a03e>] worker_thread+0x12e/0x320
       [<ffffffff8106f86e>] kthread+0xde/0xf0
       [<ffffffff8156eca4>] kernel_thread_helper+0x4/0x10

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(slab_mutex);
                               lock(cpu_hotplug.lock);
                               lock(slab_mutex);
  lock(cpu_hotplug.lock);

 *** DEADLOCK ***

4 locks held by kworker/u:3/43:
 #0:  (netns){.+.+.+}, at: [<ffffffff81069122>] process_one_work+0x1a2/0x4c0
 #1:  (net_cleanup_work){+.+.+.}, at: [<ffffffff81069122>] process_one_work+0x1a2/0x4c0
 #2:  (net_mutex){+.+.+.}, at: [<ffffffff81458be0>] cleanup_net+0x80/0x1b0
 #3:  (slab_mutex){+.+.+.}, at: [<ffffffff81178175>] kmem_cache_destroy+0x45/0xe0

stack backtrace:
Pid: 43, comm: kworker/u:3 Not tainted 3.6.0-03888-g3f99f3b #145
Call Trace:
 [<ffffffff810ac5cf>] print_circular_bug+0x10f/0x120
 [<ffffffff810ae48e>] check_prev_add+0x3de/0x440
 [<ffffffff810aeb22>] validate_chain+0x632/0x720
 [<ffffffff810aef69>] __lock_acquire+0x359/0x580
 [<ffffffff810af2b1>] lock_acquire+0x121/0x190
 [<ffffffff81049287>] ? get_online_cpus+0x37/0x50
 [<ffffffff8156130c>] __mutex_lock_common+0x5c/0x450
 [<ffffffff81049287>] ? get_online_cpus+0x37/0x50
 [<ffffffff810ada40>] ? mark_held_locks+0x80/0x120
 [<ffffffff81049287>] ? get_online_cpus+0x37/0x50
 [<ffffffff8156182e>] mutex_lock_nested+0x3e/0x50
 [<ffffffff81049287>] get_online_cpus+0x37/0x50
 [<ffffffff810f3a92>] _rcu_barrier+0x22/0x1f0
 [<ffffffff810f3c70>] rcu_barrier_sched+0x10/0x20
 [<ffffffff810f3c89>] rcu_barrier+0x9/0x10
 [<ffffffff81178201>] kmem_cache_destroy+0xd1/0xe0
 [<ffffffffa0488154>] nf_conntrack_cleanup_net+0xe4/0x110 [nf_conntrack]
 [<ffffffffa04881aa>] nf_conntrack_cleanup+0x2a/0x70 [nf_conntrack]
 [<ffffffffa04892ce>] nf_conntrack_net_exit+0x5e/0x80 [nf_conntrack]
 [<ffffffff81458629>] ops_exit_list+0x39/0x60
 [<ffffffff81458c5b>] cleanup_net+0xfb/0x1b0
 [<ffffffff810691eb>] process_one_work+0x26b/0x4c0
 [<ffffffff81069122>] ? process_one_work+0x1a2/0x4c0
 [<ffffffff81069f69>] ? worker_thread+0x59/0x320
 [<ffffffff81458b60>] ? net_drop_ns+0x40/0x40
 [<ffffffff8106a03e>] worker_thread+0x12e/0x320
 [<ffffffff81069f10>] ? manage_workers+0x1a0/0x1a0
 [<ffffffff8106f86e>] kthread+0xde/0xf0
 [<ffffffff8156eca4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81564b33>] ? retint_restore_args+0x13/0x13
 [<ffffffff8106f790>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff8156eca0>] ? gs_change+0x13/0x13

-- 
Jiri Kosina
SUSE Labs

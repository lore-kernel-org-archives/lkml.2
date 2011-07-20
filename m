Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab1GTBaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 21:30:15 -0400
Received: from mail001.aei.ca ([206.123.6.130]:34757 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395Ab1GTBaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 21:30:13 -0400
From: Ed Tomlinson <edt@aei.ca>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH rcu/urgent 0/6] Fixes for RCU/scheduler/irq-threads trainwreck
Date: Tue, 19 Jul 2011 21:30:00 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.39.1-crc+; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org, greearb@candelatech.com
References: <20110720001738.GA16369@linux.vnet.ibm.com>
In-Reply-To: <20110720001738.GA16369@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107192130.02080.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 July 2011 20:17:38 Paul E. McKenney wrote:

Paul,

Pulling this on top of master and rebuilding with boost enabled and booting with threadirqs does not
boot correctly here.  

 * Starting APC UPS daemon ...
[   46.007217]
[   46.007221] =================================
[   46.008013] [ INFO: inconsistent lock state ]
[   46.008013] 3.0.0-rc7-crc+ #340
[   46.008013] ---------------------------------
[   46.008013] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
[   46.008013] ip/2982 [HC0[0]:SC0[0]:HE1:SE1] takes:
[   46.008013]  (rcu_node_level_0){+.?...}, at: [<ffffffff810ba279>] rcu_report_exp_rnp+0x19/0x50
[   46.008013] {IN-SOFTIRQ-W} state was registered at:
[   46.008013]   [<ffffffff8108a1e5>] __lock_acquire+0x5a5/0x16a0
[   46.008013]   [<ffffffff8108b8d5>] lock_acquire+0x95/0x140
[   46.008013]   [<ffffffff815793a6>] _raw_spin_lock_irqsave+0x46/0x60
[   46.008013]   [<ffffffff810bbf80>] __rcu_process_callbacks+0x190/0x2a0
[   46.008013]   [<ffffffff810bc0ed>] rcu_process_callbacks+0x5d/0x60
[   46.008013]   [<ffffffff81052e14>] __do_softirq+0x194/0x300
[   46.008013]   [<ffffffff8105311d>] run_ksoftirqd+0x19d/0x240
[   46.008013]   [<ffffffff81071296>] kthread+0xb6/0xc0
[   46.008013]   [<ffffffff81582294>] kernel_thread_helper+0x4/0x10
[   46.008013] irq event stamp: 6802
[   46.008013] hardirqs last  enabled at (6801): [<ffffffff815776bd>] __mutex_unlock_slowpath+0x10d/0x1c0
[   46.008013] hardirqs last disabled at (6802): [<ffffffff8157937c>] _raw_spin_lock_irqsave+0x1c/0x60
[   46.008013] softirqs last  enabled at (6698): [<ffffffff814c274a>] sk_common_release+0x6a/0x120
[   46.008013] softirqs last disabled at (6696): [<ffffffff81579476>] _raw_write_lock_bh+0x16/0x50
[   46.008013]
[   46.008013] other info that might help us debug this:
[   46.008013]  Possible unsafe locking scenario:
[   46.008013]
[   46.008013]        CPU0
[   46.008013]        ----
[   46.008013]   lock(rcu_node_level_0);
[   46.008013]   <Interrupt>
[   46.008013]     lock(rcu_node_level_0);
[   46.008013]
[   46.008013]  *** DEADLOCK ***
[   46.008013]
[   46.008013] 3 locks held by ip/2982:
[   46.008013]  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff814e4fd7>] rtnl_lock+0x17/0x20
[   46.008013]  #1:  (sync_rcu_preempt_exp_mutex){+.+...}, at: [<ffffffff810bc9e7>] synchronize_rcu_expedited+0x37/0x210
[   46.008013]  #2:  (rcu_node_level_0){+.?...}, at: [<ffffffff810ba279>] rcu_report_exp_rnp+0x19/0x50
[   46.008013]
[   46.008013] stack backtrace:
[   46.008013] Pid: 2982, comm: ip Tainted: G        W   3.0.0-rc7-crc+ #340
[   46.008013] Call Trace:
[   46.008013]  [<ffffffff81088c33>] print_usage_bug+0x223/0x270
[   46.008013]  [<ffffffff81089558>] mark_lock+0x328/0x400
[   46.008013]  [<ffffffff8108969e>] mark_held_locks+0x6e/0xa0
[   46.008013]  [<ffffffff81579a5d>] ? _raw_spin_unlock_irqrestore+0x7d/0x90
[   46.008013]  [<ffffffff8108999d>] trace_hardirqs_on_caller+0x14d/0x190
[   46.008013]  [<ffffffff810899ed>] trace_hardirqs_on+0xd/0x10
[   46.008013]  [<ffffffff81579a5d>] _raw_spin_unlock_irqrestore+0x7d/0x90
[   46.008013]  [<ffffffff810bcb18>] synchronize_rcu_expedited+0x168/0x210
[   46.008013]  [<ffffffff8111a073>] ? might_fault+0x53/0xb0
[   46.008013]  [<ffffffff8125200a>] ? security_capable+0x2a/0x30
[   46.008013]  [<ffffffff814d0985>] synchronize_net+0x45/0x50
[   46.008013]  [<ffffffffa0359613>] ipip6_tunnel_ioctl+0x5f3/0x800 [sit]
[   46.008013]  [<ffffffffa0359020>] ? ipip6_tunnel_locate+0x2e0/0x2e0 [sit] 
[   46.008013]  [<ffffffff814d43ba>] dev_ifsioc+0x11a/0x2c0
[   46.008013]  [<ffffffff814d678a>] dev_ioctl+0x35a/0x810
[   46.008013]  [<ffffffff81089a8d>] ? debug_check_no_locks_freed+0x9d/0x150
[   46.008013]  [<ffffffff8108999d>] ? trace_hardirqs_on_caller+0x14d/0x190
[   46.008013]  [<ffffffff810899ed>] ? trace_hardirqs_on+0xd/0x10
[   46.008013]  [<ffffffff814bb83a>] sock_ioctl+0xea/0x2b0
[   46.008013]  [<ffffffff81162474>] do_vfs_ioctl+0xa4/0x5a0
[   46.008013]  [<ffffffff815799cc>] ? _raw_spin_unlock+0x5c/0x70
[   46.008013]  [<ffffffff8114c1cc>] ? fd_install+0x7c/0x90
[   46.008013]  [<ffffffff8158149c>] ? sysret_check+0x27/0x62
[   46.008013]  [<ffffffff81162a09>] sys_ioctl+0x99/0xa0
[   46.008013]  [<ffffffff8158146b>] system_call_fastpath+0x16/0x1b
[   46.786123] BUG: sleeping function called from invalid context at net/ipv4/route.c:757
[   46.799548] in_atomic(): 1, irqs_disabled(): 0, pid: 2982, name: ip
[   46.799553] INFO: lockdep is turned off.
[   46.799561] Pid: 2982, comm: ip Tainted: G        W   3.0.0-rc7-crc+ #340
[   46.799565] Call Trace:
[   46.799576]  [<ffffffff81036b39>] __might_sleep+0xf9/0x120
[   46.799586]  [<ffffffff814fea38>] rt_do_flush+0x178/0x1b0
[   46.799594]  [<ffffffff814feafc>] rt_cache_flush+0x5c/0x70
[   46.799606]  [<ffffffff81542d92>] fib_netdev_event+0x72/0xf0
[   46.799615]  [<ffffffff8157d576>] notifier_call_chain+0x56/0x80
[   46.799625]  [<ffffffff81077ff6>] raw_notifier_call_chain+0x16/0x20
[   46.799633]  [<ffffffff814d1cd4>] call_netdevice_notifiers+0x74/0x90
[   46.799642]  [<ffffffff814d2c37>] netdev_state_change+0x27/0x40
[   46.799653]  [<ffffffffa0359686>] ipip6_tunnel_ioctl+0x666/0x800 [sit]
[   46.799663]  [<ffffffffa0359020>] ? ipip6_tunnel_locate+0x2e0/0x2e0 [sit]
[   46.799673]  [<ffffffff814d43ba>] dev_ifsioc+0x11a/0x2c0
[   46.799682]  [<ffffffff814d678a>] dev_ioctl+0x35a/0x810
[   46.799690]  [<ffffffff81089a8d>] ? debug_check_no_locks_freed+0x9d/0x150
[   46.799700]  [<ffffffff8108999d>] ? trace_hardirqs_on_caller+0x14d/0x190
[   46.799707]  [<ffffffff810899ed>] ? trace_hardirqs_on+0xd/0x10
[   46.799718]  [<ffffffff814bb83a>] sock_ioctl+0xea/0x2b0
[   46.799726]  [<ffffffff81162474>] do_vfs_ioctl+0xa4/0x5a0
[   46.799735]  [<ffffffff815799cc>] ? _raw_spin_unlock+0x5c/0x70
[   46.799744]  [<ffffffff8114c1cc>] ? fd_install+0x7c/0x90
[   46.799752]  [<ffffffff8158149c>] ? sysret_check+0x27/0x62
[   46.799760]  [<ffffffff81162a09>] sys_ioctl+0x99/0xa0
[   46.799769]  [<ffffffff8158146b>] system_call_fastpath+0x16/0x1b

Followed by more BUGs and yielding a box that needed in interrupt button pressed to
force a reboot.   

I've previously tested with patches 5 and 6 from Peter Z with good results with threadirqs 
with boost disabled.

Ed

> This patch set contains fixes for a trainwreck involving RCU, the
> scheduler, and threaded interrupts.  This trainwreck involved RCU failing
> to properly protect one of its bit fields, use of RCU by the scheduler
> from portions of irq_exit() where in_irq() returns false, uses of the
> scheduler by RCU colliding with uses of RCU by the scheduler, threaded
> interrupts exercising the problematic portions of irq_exit() more heavily,
> and so on.  The patches are as follows:
> 
> 1.	Properly protect current->rcu_read_unlock_special().
> 	Lack of protection was causing RCU to recurse on itself, which
> 	in turn resulted in deadlocks involving RCU and the scheduler.
> 	This affects only RCU_BOOST=y configurations.
> 2.	Streamline code produced by __rcu_read_unlock().  This one is
> 	an innocent bystander that is being carried due to conflicts
> 	with other patches.  (A later version will likely merge it
> 	with #3 below.)
> 3.	Make __rcu_read_unlock() delay counting the per-task
> 	->rcu_read_lock_nesting variable to zero until all cleanup for the
> 	just-ended RCU read-side critical section has completed.  This
> 	prevents a number of other cases that could result in deadlock
> 	due to self recursion.	This affects only TREE_PREEMPT_RCU=y
> 	configurations.
> 4.	Make scheduler_ipi() correctly identify itself as being
> 	in_irq() when it needs to do anything that might involve RCU,
> 	thus enabling RCU to avoid yet another class of potential
> 	self-recursions and deadlocks.	This affects PREEMPT_RCU=y
> 	configurations.
> 5.	Make irq_exit() inform RCU when it is invoking the scheduler
> 	in situations where in_irq() would return false, thus
> 	allowing RCU to correctly avoid self-recursion.  This affects
> 	TREE_PREEMPT_RCU=y configurations.
> 6.	Make __lock_task_sighand() execute the entire RCU read-side
> 	critical section with irqs disabled.  (An experimental patch at
> 	http://marc.info/?l=linux-kernel&m=131110647222185 might possibly
> 	make it legal to have an RCU read-side critical section where
> 	the rcu_read_unlock() is executed with interrupts disabled,
> 	but where some protion of the RCU read-side critical section
> 	was preemptible.)  This affects TREE_PREEMPT_RCU=y configurations.
> 
> TINY_PREEMPT_RCU will also need a few of these changes, but in the
> meantime this patch stack helps organize things better for testing.
> These are also available from the following subject-to-rebase git branch:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
>  b/include/linux/sched.h   |    3 +++
>  b/kernel/rcutree_plugin.h |    3 ++-
>  b/kernel/sched.c          |   44 ++++++++++++++++++++++++++++++++++++++------
>  b/kernel/signal.c         |   16 +++++++++++-----
>  b/kernel/softirq.c        |   12 ++++++++++--
>  kernel/rcutree_plugin.h   |   45 ++++++++++++++++++++++++++++++++-------------
>  6 files changed, 96 insertions(+), 27 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

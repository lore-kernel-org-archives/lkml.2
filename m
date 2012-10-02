Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab2JBUkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 16:40:01 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:45397 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab2JBUj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 16:39:59 -0400
Message-ID: <506B50F1.8070907@linux.vnet.ibm.com>
Date: Wed, 03 Oct 2012 02:09:13 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Lockdep complains about commit 1331e7a1bb ("rcu: Remove _rcu_barrier()
 dependency on __stop_machine()")
References: <alpine.LNX.2.00.1210021810350.23544@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1210021810350.23544@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12100220-5816-0000-0000-000004B5ED89
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2012 09:44 PM, Jiri Kosina wrote:
> Hi,
> 
> this commit:
> 
> ==
> 1331e7a1bbe1f11b19c4327ba0853bee2a606543 is the first bad commit
> commit 1331e7a1bbe1f11b19c4327ba0853bee2a606543
> Author: Paul E. McKenney <paul.mckenney@linaro.org>
> Date:   Thu Aug 2 17:43:50 2012 -0700
> 
>     rcu: Remove _rcu_barrier() dependency on __stop_machine()
>     
>     Currently, _rcu_barrier() relies on preempt_disable() to prevent
>     any CPU from going offline, which in turn depends on CPU hotplug's
>     use of __stop_machine().
>     
>     This patch therefore makes _rcu_barrier() use get_online_cpus() to
>     block CPU-hotplug operations.  This has the added benefit of removing
>     the need for _rcu_barrier() to adopt callbacks:  Because CPU-hotplug
>     operations are excluded, there can be no callbacks to adopt.  This
>     commit simplifies the code accordingly.
>     
>     Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>     Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> ==
> 
> is causing lockdep to complain (see the full trace below). I haven't yet 
> had time to analyze what exactly is happening, and probably will not have 
> time to do so until tomorrow, so just sending this as a heads-up in case 
> anyone sees the culprit immediately.
> 
>  ======================================================
>  [ INFO: possible circular locking dependency detected ]
>  3.6.0-rc5-00004-g0d8ee37 #143 Not tainted
>  -------------------------------------------------------
>  kworker/u:2/40 is trying to acquire lock:
>   (rcu_sched_state.barrier_mutex){+.+...}, at: [<ffffffff810f2126>] _rcu_barrier+0x26/0x1e0
> 
>  but task is already holding lock:
>   (slab_mutex){+.+.+.}, at: [<ffffffff81176e15>] kmem_cache_destroy+0x45/0xe0
> 
>  which lock already depends on the new lock.
> 
> 
>  the existing dependency chain (in reverse order) is:
> 
>  -> #2 (slab_mutex){+.+.+.}:
>         [<ffffffff810ae1e2>] validate_chain+0x632/0x720
>         [<ffffffff810ae5d9>] __lock_acquire+0x309/0x530
>         [<ffffffff810ae921>] lock_acquire+0x121/0x190
>         [<ffffffff8155d4cc>] __mutex_lock_common+0x5c/0x450
>         [<ffffffff8155d9ee>] mutex_lock_nested+0x3e/0x50
>         [<ffffffff81558cb5>] cpuup_callback+0x2f/0xbe
>         [<ffffffff81564b83>] notifier_call_chain+0x93/0x140
>         [<ffffffff81076f89>] __raw_notifier_call_chain+0x9/0x10
>         [<ffffffff8155719d>] _cpu_up+0xba/0x14e
>         [<ffffffff815572ed>] cpu_up+0xbc/0x117
>         [<ffffffff81ae05e3>] smp_init+0x6b/0x9f
>         [<ffffffff81ac47d6>] kernel_init+0x147/0x1dc
>         [<ffffffff8156ab44>] kernel_thread_helper+0x4/0x10
> 
>  -> #1 (cpu_hotplug.lock){+.+.+.}:
>         [<ffffffff810ae1e2>] validate_chain+0x632/0x720
>         [<ffffffff810ae5d9>] __lock_acquire+0x309/0x530
>         [<ffffffff810ae921>] lock_acquire+0x121/0x190
>         [<ffffffff8155d4cc>] __mutex_lock_common+0x5c/0x450
>         [<ffffffff8155d9ee>] mutex_lock_nested+0x3e/0x50
>         [<ffffffff81049197>] get_online_cpus+0x37/0x50
>         [<ffffffff810f21bb>] _rcu_barrier+0xbb/0x1e0
>         [<ffffffff810f22f0>] rcu_barrier_sched+0x10/0x20
>         [<ffffffff810f2309>] rcu_barrier+0x9/0x10
>         [<ffffffff8118c129>] deactivate_locked_super+0x49/0x90
>         [<ffffffff8118cc01>] deactivate_super+0x61/0x70
>         [<ffffffff811aaaa7>] mntput_no_expire+0x127/0x180
>         [<ffffffff811ab49e>] sys_umount+0x6e/0xd0
>         [<ffffffff81569979>] system_call_fastpath+0x16/0x1b
> 
>  -> #0 (rcu_sched_state.barrier_mutex){+.+...}:
>         [<ffffffff810adb4e>] check_prev_add+0x3de/0x440
>         [<ffffffff810ae1e2>] validate_chain+0x632/0x720
>         [<ffffffff810ae5d9>] __lock_acquire+0x309/0x530
>         [<ffffffff810ae921>] lock_acquire+0x121/0x190
>         [<ffffffff8155d4cc>] __mutex_lock_common+0x5c/0x450
>         [<ffffffff8155d9ee>] mutex_lock_nested+0x3e/0x50
>         [<ffffffff810f2126>] _rcu_barrier+0x26/0x1e0
>         [<ffffffff810f22f0>] rcu_barrier_sched+0x10/0x20
>         [<ffffffff810f2309>] rcu_barrier+0x9/0x10
>         [<ffffffff81176ea1>] kmem_cache_destroy+0xd1/0xe0
>         [<ffffffffa04c3154>] nf_conntrack_cleanup_net+0xe4/0x110 [nf_conntrack]
>         [<ffffffffa04c31aa>] nf_conntrack_cleanup+0x2a/0x70 [nf_conntrack]
>         [<ffffffffa04c42ce>] nf_conntrack_net_exit+0x5e/0x80 [nf_conntrack]
>         [<ffffffff81454b79>] ops_exit_list+0x39/0x60
>         [<ffffffff814551ab>] cleanup_net+0xfb/0x1b0
>         [<ffffffff8106917b>] process_one_work+0x26b/0x4c0
>         [<ffffffff81069f3e>] worker_thread+0x12e/0x320
>         [<ffffffff8106f73e>] kthread+0x9e/0xb0
>         [<ffffffff8156ab44>] kernel_thread_helper+0x4/0x10
> 
>  other info that might help us debug this:
> 
>  Chain exists of:
>    rcu_sched_state.barrier_mutex --> cpu_hotplug.lock --> slab_mutex
> 
>   Possible unsafe locking scenario:
> 
>         CPU0                    CPU1
>         ----                    ----
>    lock(slab_mutex);
>                                 lock(cpu_hotplug.lock);
>                                 lock(slab_mutex);
>    lock(rcu_sched_state.barrier_mutex);
> 
>   *** DEADLOCK ***
> 
>  4 locks held by kworker/u:2/40:
>   #0:  (netns){.+.+.+}, at: [<ffffffff810690b2>] process_one_work+0x1a2/0x4c0
>   #1:  (net_cleanup_work){+.+.+.}, at: [<ffffffff810690b2>] process_one_work+0x1a2/0x4c0
>   #2:  (net_mutex){+.+.+.}, at: [<ffffffff81455130>] cleanup_net+0x80/0x1b0
>   #3:  (slab_mutex){+.+.+.}, at: [<ffffffff81176e15>] kmem_cache_destroy+0x45/0xe0
>

I don't see how this circular locking dependency can occur.. If you are using SLUB,
kmem_cache_destroy() releases slab_mutex before it calls rcu_barrier(). If you are
using SLAB, kmem_cache_destroy() wraps its whole operation inside get/put_online_cpus(),
which means, it cannot run concurrently with a hotplug operation such as cpu_up(). So, I'm
rather puzzled at this lockdep splat..

Regards,
Srivatsa S. Bhat
 
>  stack backtrace:
>  Pid: 40, comm: kworker/u:2 Not tainted 3.6.0-rc5-00004-g0d8ee37 #143
>  Call Trace:
>   [<ffffffff810ac85f>] print_circular_bug+0x10f/0x120
>   [<ffffffff810adb4e>] check_prev_add+0x3de/0x440
>   [<ffffffff810ad85a>] ? check_prev_add+0xea/0x440
>   [<ffffffff8102c72f>] ? flat_send_IPI_mask+0x7f/0xc0
>   [<ffffffff810ae1e2>] validate_chain+0x632/0x720
>   [<ffffffff810ae5d9>] __lock_acquire+0x309/0x530
>   [<ffffffff810ae921>] lock_acquire+0x121/0x190
>   [<ffffffff810f2126>] ? _rcu_barrier+0x26/0x1e0
>   [<ffffffff8155d4cc>] __mutex_lock_common+0x5c/0x450
>   [<ffffffff810f2126>] ? _rcu_barrier+0x26/0x1e0
>   [<ffffffff810b5e45>] ? on_each_cpu+0x65/0xc0
>   [<ffffffff810f2126>] ? _rcu_barrier+0x26/0x1e0
>   [<ffffffff8155d9ee>] mutex_lock_nested+0x3e/0x50
>   [<ffffffff810f2126>] _rcu_barrier+0x26/0x1e0
>   [<ffffffff810f22f0>] rcu_barrier_sched+0x10/0x20
>   [<ffffffff810f2309>] rcu_barrier+0x9/0x10
>   [<ffffffff81176ea1>] kmem_cache_destroy+0xd1/0xe0
>   [<ffffffffa04c3154>] nf_conntrack_cleanup_net+0xe4/0x110 [nf_conntrack]
>   [<ffffffffa04c31aa>] nf_conntrack_cleanup+0x2a/0x70 [nf_conntrack]
>   [<ffffffffa04c42ce>] nf_conntrack_net_exit+0x5e/0x80 [nf_conntrack]
>   [<ffffffff81454b79>] ops_exit_list+0x39/0x60
>   [<ffffffff814551ab>] cleanup_net+0xfb/0x1b0
>   [<ffffffff8106917b>] process_one_work+0x26b/0x4c0
>   [<ffffffff810690b2>] ? process_one_work+0x1a2/0x4c0
>   [<ffffffff81069e69>] ? worker_thread+0x59/0x320
>   [<ffffffff814550b0>] ? net_drop_ns+0x40/0x40
>   [<ffffffff81069f3e>] worker_thread+0x12e/0x320
>   [<ffffffff81069e10>] ? manage_workers+0x110/0x110
>   [<ffffffff8106f73e>] kthread+0x9e/0xb0
>   [<ffffffff8156ab44>] kernel_thread_helper+0x4/0x10
>   [<ffffffff81560b70>] ? retint_restore_args+0x13/0x13
>   [<ffffffff8106f6a0>] ? __init_kthread_worker+0x70/0x70
>   [<ffffffff8156ab40>] ? gs_change+0x13/0x13
> 
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab2EFUfe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 16:35:34 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35943 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab2EFUfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 16:35:32 -0400
Date: Sun, 6 May 2012 23:34:39 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>
Subject: Re: possible circular locking dependency
Message-ID: <20120506203439.GB3633@swordfish>
References: <20120503200259.GA3524@swordfish.minsk.epam.com>
 <4FA63C82.7030309@redhat.com>
 <20120506164209.GK2470@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120506164209.GK2470@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (05/06/12 09:42), Paul E. McKenney wrote:
> On Sun, May 06, 2012 at 11:55:30AM +0300, Avi Kivity wrote:
> > On 05/03/2012 11:02 PM, Sergey Senozhatsky wrote:
> > > Hello,
> > > 3.4-rc5
> > 
> > Whoa.
> > 
> > Looks like inconsistent locking between cpufreq and
> > synchronize_srcu_expedited().  kvm triggered this because it is one of
> > the few users of synchronize_srcu_expedited(), but I don't think it is
> > doing anything wrong directly.
> > 
> > Dave, Paul?
> 
> SRCU hasn't changed much in mainline for quite some time.  Holding
> the hotplug mutex across a synchronize_srcu() is a bad idea, though.
> 
> However, there is a reworked implementation (courtesy of Lai Jiangshan)
> in -rcu that does not acquire the hotplug mutex.  Could you try that out?
>

Paul, should I try solely -rcu or there are several commits to pick up and apply
on top of -linus tree?

	-ss

 
> 
> > > [32881.212463] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
> > > [32882.360505] 
> > > [32882.360509] ======================================================
> > > [32882.360511] [ INFO: possible circular locking dependency detected ]
> > > [32882.360515] 3.4.0-rc5-dbg-00932-gfabccd4-dirty #1107 Not tainted
> > > [32882.360517] -------------------------------------------------------
> > > [32882.360519] qemu-system-x86/15168 is trying to acquire lock:
> > > [32882.360521]  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff81033a60>] get_online_cpus+0x41/0x55
> > > [32882.360532] 
> > > [32882.360532] but task is already holding lock:
> > > [32882.360534]  (&sp->mutex){+.+...}, at: [<ffffffff81057f91>] __synchronize_srcu+0x9a/0x104
> > > [32882.360542] 
> > > [32882.360542] which lock already depends on the new lock.
> > > [32882.360543] 
> > > [32882.360545] 
> > > [32882.360545] the existing dependency chain (in reverse order) is:
> > > [32882.360547] 
> > > [32882.360547] -> #3 (&sp->mutex){+.+...}:
> > > [32882.360552]        [<ffffffff81085b36>] lock_acquire+0x148/0x1c3
> > > [32882.360557]        [<ffffffff814aa040>] mutex_lock_nested+0x6e/0x2d1
> > > [32882.360562]        [<ffffffff81057f91>] __synchronize_srcu+0x9a/0x104
> > > [32882.360566]        [<ffffffff81058027>] synchronize_srcu+0x15/0x17
> > > [32882.360569]        [<ffffffff810586e8>] srcu_notifier_chain_unregister+0x5b/0x69
> > > [32882.360573]        [<ffffffff813e3110>] cpufreq_unregister_notifier+0x22/0x3c
> > > [32882.360580]        [<ffffffff813e3e42>] cpufreq_governor_dbs+0x322/0x3ac
> > > [32882.360584]        [<ffffffff813e2075>] __cpufreq_governor+0x6b/0xa8
> > > [32882.360587]        [<ffffffff813e21a5>] __cpufreq_set_policy+0xf3/0x145
> > > [32882.360591]        [<ffffffff813e2def>] store_scaling_governor+0x173/0x1a9
> > > [32882.360594]        [<ffffffff813e1f71>] store+0x5a/0x86
> > > [32882.360597]        [<ffffffff81181e83>] sysfs_write_file+0xee/0x126
> > > [32882.360603]        [<ffffffff8111f6b1>] vfs_write+0xa3/0x14c
> > > [32882.360607]        [<ffffffff8111f959>] sys_write+0x43/0x73
> > > [32882.360610]        [<ffffffff814b432d>] system_call_fastpath+0x1a/0x1f
> > > [32882.360614] 
> > > [32882.360615] -> #2 (dbs_mutex){+.+.+.}:
> > > [32882.360619]        [<ffffffff81085b36>] lock_acquire+0x148/0x1c3
> > > [32882.360622]        [<ffffffff814aa040>] mutex_lock_nested+0x6e/0x2d1
> > > [32882.360625]        [<ffffffff813e3b9c>] cpufreq_governor_dbs+0x7c/0x3ac
> > > [32882.360629]        [<ffffffff813e2075>] __cpufreq_governor+0x6b/0xa8
> > > [32882.360632]        [<ffffffff813e21bb>] __cpufreq_set_policy+0x109/0x145
> > > [32882.360636]        [<ffffffff813e244e>] cpufreq_add_dev_interface+0x257/0x288
> > > [32882.360639]        [<ffffffff813e2889>] cpufreq_add_dev+0x40a/0x42a
> > > [32882.360643]        [<ffffffff81398694>] subsys_interface_register+0x9b/0xdc
> > > [32882.360648]        [<ffffffff813e1935>] cpufreq_register_driver+0xa0/0x14b
> > > [32882.360652]        [<ffffffffa00a1086>] store_up_threshold+0x3a/0x50 [cpufreq_ondemand]
> > > [32882.360657]        [<ffffffff8100020f>] do_one_initcall+0x7f/0x140
> > > [32882.360663]        [<ffffffff8109158c>] sys_init_module+0x1818/0x1aec
> > > [32882.360667]        [<ffffffff814b432d>] system_call_fastpath+0x1a/0x1f
> > > [32882.360671] 
> > > [32882.360671] -> #1 (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}:
> > > [32882.360675]        [<ffffffff81085b36>] lock_acquire+0x148/0x1c3
> > > [32882.360679]        [<ffffffff814aa661>] down_write+0x49/0x6c
> > > [32882.360682]        [<ffffffff813e1eaa>] lock_policy_rwsem_write+0x47/0x78
> > > [32882.360685]        [<ffffffff814a18c9>] cpufreq_cpu_callback+0x57/0x81
> > > [32882.360692]        [<ffffffff814b0643>] notifier_call_chain+0xac/0xd9
> > > [32882.360697]        [<ffffffff810582b6>] __raw_notifier_call_chain+0xe/0x10
> > > [32882.360701]        [<ffffffff81033950>] __cpu_notify+0x20/0x37
> > > [32882.360705]        [<ffffffff8149091c>] _cpu_down+0x7b/0x25d
> > > [32882.360709]        [<ffffffff81033b2f>] disable_nonboot_cpus+0x5f/0x10b
> > > [32882.360712]        [<ffffffff81072e61>] suspend_devices_and_enter+0x197/0x401
> > > [32882.360719]        [<ffffffff810731cf>] pm_suspend+0x104/0x1bd
> > > [32882.360722]        [<ffffffff8107213a>] state_store+0xa0/0xc9
> > > [32882.360726]        [<ffffffff8127115a>] kobj_attr_store+0xf/0x1b
> > > [32882.360730]        [<ffffffff81181e83>] sysfs_write_file+0xee/0x126
> > > [32882.360733]        [<ffffffff8111f6b1>] vfs_write+0xa3/0x14c
> > > [32882.360736]        [<ffffffff8111f959>] sys_write+0x43/0x73
> > > [32882.360739]        [<ffffffff814b432d>] system_call_fastpath+0x1a/0x1f
> > > [32882.360743] 
> > > [32882.360743] -> #0 (cpu_hotplug.lock){+.+.+.}:
> > > [32882.360747]        [<ffffffff81084e93>] __lock_acquire+0xf6b/0x1612
> > > [32882.360751]        [<ffffffff81085b36>] lock_acquire+0x148/0x1c3
> > > [32882.360754]        [<ffffffff814aa040>] mutex_lock_nested+0x6e/0x2d1
> > > [32882.360757]        [<ffffffff81033a60>] get_online_cpus+0x41/0x55
> > > [32882.360760]        [<ffffffff810ab15b>] synchronize_sched_expedited+0x26/0xfa
> > > [32882.360766]        [<ffffffff81057f9f>] __synchronize_srcu+0xa8/0x104
> > > [32882.360769]        [<ffffffff81058010>] synchronize_srcu_expedited+0x15/0x17
> > > [32882.360773]        [<ffffffffa01df109>] __kvm_set_memory_region+0x3d8/0x46a [kvm]
> > > [32882.360789]        [<ffffffffa01df1d2>] kvm_set_memory_region+0x37/0x50 [kvm]
> > > [32882.360798]        [<ffffffffa0258a89>] vmx_set_tss_addr+0x4c/0x200 [kvm_intel]
> > > [32882.360803]        [<ffffffffa01ef732>] kvm_arch_vm_ioctl+0x160/0x9df [kvm]
> > > [32882.360816]        [<ffffffffa01df571>] kvm_vm_ioctl+0x36a/0x39c [kvm]
> > > [32882.360825]        [<ffffffff8112fc68>] vfs_ioctl+0x24/0x2f
> > > [32882.360829]        [<ffffffff81130566>] do_vfs_ioctl+0x412/0x455
> > > [32882.360832]        [<ffffffff811305ff>] sys_ioctl+0x56/0x7b
> > > [32882.360835]        [<ffffffff814b432d>] system_call_fastpath+0x1a/0x1f
> > > [32882.360839] 
> > > [32882.360839] other info that might help us debug this:
> > > [32882.360840] 
> > > [32882.360842] Chain exists of:
> > > [32882.360842]   cpu_hotplug.lock --> dbs_mutex --> &sp->mutex
> > > [32882.360847] 
> > > [32882.360848]  Possible unsafe locking scenario:
> > > [32882.360849] 
> > > [32882.360851]        CPU0                    CPU1
> > > [32882.360852]        ----                    ----
> > > [32882.360854]   lock(&sp->mutex);
> > > [32882.360856]                                lock(dbs_mutex);
> > > [32882.360859]                                lock(&sp->mutex);
> > > [32882.360862]   lock(cpu_hotplug.lock);
> > > [32882.360865] 
> > > [32882.360865]  *** DEADLOCK ***
> > > [32882.360866] 
> > > [32882.360868] 2 locks held by qemu-system-x86/15168:
> > > [32882.360870]  #0:  (&kvm->slots_lock){+.+.+.}, at: [<ffffffffa01df1c4>] kvm_set_memory_region+0x29/0x50 [kvm]
> > > [32882.360882]  #1:  (&sp->mutex){+.+...}, at: [<ffffffff81057f91>] __synchronize_srcu+0x9a/0x104
> > > [32882.360888] 
> > > [32882.360889] stack backtrace:
> > > [32882.360892] Pid: 15168, comm: qemu-system-x86 Not tainted 3.4.0-rc5-dbg-00932-gfabccd4-dirty #1107
> > > [32882.360894] Call Trace:
> > > [32882.360898]  [<ffffffff814a3d1d>] print_circular_bug+0x29f/0x2b0
> > > [32882.360901]  [<ffffffff81084e93>] __lock_acquire+0xf6b/0x1612
> > > [32882.360905]  [<ffffffff81085b36>] lock_acquire+0x148/0x1c3
> > > [32882.360908]  [<ffffffff81033a60>] ? get_online_cpus+0x41/0x55
> > > [32882.360911]  [<ffffffff814aa040>] mutex_lock_nested+0x6e/0x2d1
> > > [32882.360914]  [<ffffffff81033a60>] ? get_online_cpus+0x41/0x55
> > > [32882.360917]  [<ffffffff810ab135>] ? synchronize_sched+0xa8/0xa8
> > > [32882.360921]  [<ffffffff81033a60>] get_online_cpus+0x41/0x55
> > > [32882.360923]  [<ffffffff810ab15b>] synchronize_sched_expedited+0x26/0xfa
> > > [32882.360927]  [<ffffffff810ab135>] ? synchronize_sched+0xa8/0xa8
> > > [32882.360930]  [<ffffffff81057f9f>] __synchronize_srcu+0xa8/0x104
> > > [32882.360933]  [<ffffffff81058010>] synchronize_srcu_expedited+0x15/0x17
> > > [32882.360942]  [<ffffffffa01df109>] __kvm_set_memory_region+0x3d8/0x46a [kvm]
> > > [32882.360945]  [<ffffffff81086268>] ? mark_held_locks+0xbe/0xea
> > > [32882.360954]  [<ffffffffa01df1d2>] kvm_set_memory_region+0x37/0x50 [kvm]
> > > [32882.360959]  [<ffffffffa0258a89>] vmx_set_tss_addr+0x4c/0x200 [kvm_intel]
> > > [32882.360971]  [<ffffffffa01ef732>] kvm_arch_vm_ioctl+0x160/0x9df [kvm]
> > > [32882.360980]  [<ffffffffa01df571>] kvm_vm_ioctl+0x36a/0x39c [kvm]
> > > [32882.360984]  [<ffffffff810855c5>] ? lock_release_non_nested+0x8b/0x241
> > > [32882.360987]  [<ffffffff8112fc68>] vfs_ioctl+0x24/0x2f
> > > [32882.360990]  [<ffffffff81130566>] do_vfs_ioctl+0x412/0x455
> > > [32882.360993]  [<ffffffff81120f8f>] ? fget_light+0x120/0x39b
> > > [32882.360996]  [<ffffffff811305ff>] sys_ioctl+0x56/0x7b
> > > [32882.360999]  [<ffffffff814b432d>] system_call_fastpath+0x1a/0x1f
> > >
> > >
> > >
> > > 	-ss
> > 
> > 
> > -- 
> > error compiling committee.c: too many arguments to function
> > 
> 

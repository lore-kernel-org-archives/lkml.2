Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933478Ab1IBK4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 06:56:33 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:59554 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933428Ab1IBK43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 06:56:29 -0400
Message-ID: <4E60B64E.6060907@linux.vnet.ibm.com>
Date: Fri, 02 Sep 2011 16:26:14 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-pm@lists.linux-foundation.org
Subject: [BUG] CPU hotplug, suspend: Possible circular locking dependency
 detected
Content-Type: multipart/mixed;
 boundary="------------090100060109080504070306"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090100060109080504070306
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

While running CPU hotplug stress test + kernel compilation + pm_test (at the core level),
unsafe locking scenarios are detected.

Kernel version : 3.1.0-rc2
A bug has been opened in the kernel bugzilla regarding this: 
https://bugzilla.kernel.org/show_bug.cgi?id=42242

The entire log has been attached with this mail.

 [  807.775666] =======================================================
 [  807.775994] [ INFO: possible circular locking dependency detected ]
 [  807.776253] 3.1.0-rc2 #1
 [  807.776364] -------------------------------------------------------
 [  807.776621] kworker/u:6/29543 is trying to acquire lock:
 [  807.776915]  (alc_key){..-...}, at: [<ffffffff81168fa9>] kmem_cache_free+0x1a9/0x240
 [  807.777415] 
 [  807.777417] but task is already holding lock:
 [  807.777816]  (&(&parent->list_lock)->rlock){-.-...}, at: [<ffffffff81169294>] __drain_alien_cache+0x64/0xa0
 [  807.778398] 
 [  807.778399] which lock already depends on the new lock.
 [  807.778401] 
 [  807.778975] 
 [  807.778976] the existing dependency chain (in reverse order) is:
 [  807.779425] 
 [  807.779426] -> #1 (&(&parent->list_lock)->rlock){-.-...}:
 [  807.779891]        [<ffffffff810ab50c>] validate_chain+0x6cc/0x7d0
 [  807.780227]        [<ffffffff810ab914>] __lock_acquire+0x304/0x500
 [  807.780557]        [<ffffffff810ac1d2>] lock_acquire+0xa2/0x130
 [  807.780877]        [<ffffffff815349b6>] _raw_spin_lock+0x36/0x70
 [  807.781208]        [<ffffffff81169294>] __drain_alien_cache+0x64/0xa0
 [  807.781548]        [<ffffffff811698cb>] kfree+0x1db/0x2a0
 [  807.781847]        [<ffffffff81169a21>] free_alien_cache+0x91/0xa0
 [  807.782178]        [<ffffffff8152e9b9>] cpuup_prepare+0x168/0x1a9
 [  807.782507]        [<ffffffff8152ea2f>] cpuup_callback+0x35/0xc5
 [  807.782829]        [<ffffffff815393a4>] notifier_call_chain+0x94/0xd0
 [  807.783173]        [<ffffffff8109770e>] __raw_notifier_call_chain+0xe/0x10
 [  807.783535]        [<ffffffff8106d000>] __cpu_notify+0x20/0x40
 [  807.783858]        [<ffffffff8152cf02>] _cpu_up+0x6e/0x10e
 [  807.784172]        [<ffffffff8152d07b>] cpu_up+0xd9/0xec
 [  807.784468]        [<ffffffff81e21bd6>] smp_init+0x41/0x96
 [  807.784771]        [<ffffffff81e03791>] kernel_init+0x1ef/0x2a6
 [  807.785092]        [<ffffffff81540184>] kernel_thread_helper+0x4/0x10
 [  807.785433] 
 [  807.785434] -> #0 (alc_key){..-...}:
 [  807.785824]        [<ffffffff810aae18>] check_prev_add+0x528/0x550
 [  807.786156]        [<ffffffff810ab50c>] validate_chain+0x6cc/0x7d0
 [  807.786488]        [<ffffffff810ab914>] __lock_acquire+0x304/0x500
 [  807.786823]        [<ffffffff810ac1d2>] lock_acquire+0xa2/0x130
 [  807.787143]        [<ffffffff815349b6>] _raw_spin_lock+0x36/0x70
 [  807.787467]        [<ffffffff81168fa9>] kmem_cache_free+0x1a9/0x240
 [  807.787802]        [<ffffffff81169094>] slab_destroy+0x54/0x80
 [  807.788123]        [<ffffffff8116911d>] free_block+0x5d/0x170
 [  807.788439]        [<ffffffff811692bc>] __drain_alien_cache+0x8c/0xa0
 [  807.788778]        [<ffffffff811698cb>] kfree+0x1db/0x2a0
 [  807.789087]        [<ffffffff8144aeb0>] skb_release_data+0xd0/0x100
 [  807.789426]        [<ffffffff8144aefe>] __kfree_skb+0x1e/0xa0
 [  807.789741]        [<ffffffff8144afb1>] consume_skb+0x31/0x80
 [  807.790058]        [<ffffffffa01d4e74>] bnx2_free_skbs+0x234/0x390 [bnx2]
 [  807.790416]        [<ffffffffa01d5096>] bnx2_suspend+0xc6/0xe0 [bnx2]
 [  807.790758]        [<ffffffff812978a6>] pci_legacy_suspend+0x46/0xe0
 [  807.791101]        [<ffffffff8129854d>] pci_pm_freeze+0xad/0xd0
 [  807.791422]        [<ffffffff8135e7f6>] pm_op+0x136/0x1a0
 [  807.791724]        [<ffffffff8135f18b>] __device_suspend+0x26b/0x2d0
 [  807.792063]        [<ffffffff8136016f>] async_suspend+0x1f/0xa0
 [  807.792384]        [<ffffffff81099634>] async_run_entry_fn+0x84/0x160
 [  807.792726]        [<ffffffff8108938a>] process_one_work+0x1aa/0x520
 [  807.793065]        [<ffffffff8108ba7b>] worker_thread+0x17b/0x3b0
 [  807.793394]        [<ffffffff81090af6>] kthread+0xb6/0xc0
 [  807.793698]        [<ffffffff81540184>] kernel_thread_helper+0x4/0x10
 [  807.794041] 
 [  807.794042] other info that might help us debug this:
 [  807.794043] 
 [  807.794602]  Possible unsafe locking scenario:
 [  807.794603] 
 [  807.794995]        CPU0                    CPU1
 [  807.795250]        ----                    ----
 [  807.795505]   lock(&(&parent->list_lock)->rlock);
 [  807.795789]                                lock(alc_key);
 [  807.796101]                                lock(&(&parent->list_lock)->rlock);
 [  807.796557]   lock(alc_key);
 [  807.796771] 
 [  807.796772]  *** DEADLOCK ***
 [  807.796773] 
 [  807.797252] 5 locks held by kworker/u:6/29543:
 [  807.797503]  #0:  (events_unbound){.+.+.+}, at: [<ffffffff8108931d>] process_one_work+0x13d/0x520
 [  807.798058]  #1:  ((&entry->work)){+.+.+.}, at: [<ffffffff8108931d>] process_one_work+0x13d/0x520
 [  807.798591]  #2:  (&__lockdep_no_validate__){......}, at: [<ffffffff8135efc3>] __device_suspend+0xa3/0x2d0
 [  807.799160]  #3:  (&(&nc->lock)->rlock){-.-...}, at: [<ffffffff811698b4>] kfree+0x1c4/0x2a0
 [  807.799672]  #4:  (&(&parent->list_lock)->rlock){-.-...}, at: [<ffffffff81169294>] __drain_alien_cache+0x64/0xa0
 [  807.800270] 
 [  807.800271] stack backtrace:
 [  807.800608] Pid: 29543, comm: kworker/u:6 Not tainted 3.1.0-rc2 #1
 [  807.800929] Call Trace:
 [  807.801115]  [<ffffffff810a8e39>] print_circular_bug+0x109/0x110
 [  807.801428]  [<ffffffff810aae18>] check_prev_add+0x528/0x550
 [  807.801728]  [<ffffffff810ab50c>] validate_chain+0x6cc/0x7d0
 [  807.802040]  [<ffffffff8101a3f9>] ? sched_clock+0x9/0x10
 [  807.802327]  [<ffffffff8109839d>] ? sched_clock_cpu+0xcd/0x110
 [  807.802635]  [<ffffffff810ab914>] __lock_acquire+0x304/0x500
 [  807.802938]  [<ffffffff810ac1d2>] lock_acquire+0xa2/0x130
 [  807.803230]  [<ffffffff81168fa9>] ? kmem_cache_free+0x1a9/0x240
 [  807.803541]  [<ffffffff815349b6>] _raw_spin_lock+0x36/0x70
 [  807.803835]  [<ffffffff81168fa9>] ? kmem_cache_free+0x1a9/0x240
 [  807.804147]  [<ffffffff81168fa9>] kmem_cache_free+0x1a9/0x240
 [  807.804453]  [<ffffffff81169094>] slab_destroy+0x54/0x80
 [  807.804740]  [<ffffffff8116911d>] free_block+0x5d/0x170
 [  807.805027]  [<ffffffff811692bc>] __drain_alien_cache+0x8c/0xa0
 [  807.805337]  [<ffffffff811698cb>] kfree+0x1db/0x2a0
 [  807.805610]  [<ffffffff8144aeb0>] skb_release_data+0xd0/0x100
 [  807.805916]  [<ffffffff8144aefe>] __kfree_skb+0x1e/0xa0
 [  807.806201]  [<ffffffff8144afb1>] consume_skb+0x31/0x80
 [  807.806487]  [<ffffffffa01d4e74>] bnx2_free_skbs+0x234/0x390 [bnx2]
 [  807.806813]  [<ffffffffa01d5096>] bnx2_suspend+0xc6/0xe0 [bnx2]
 [  807.807130]  [<ffffffff812978a6>] pci_legacy_suspend+0x46/0xe0
 [  807.807445]  [<ffffffff8129854d>] pci_pm_freeze+0xad/0xd0
 [  807.807736]  [<ffffffff8135e7f6>] pm_op+0x136/0x1a0
 [  807.808015]  [<ffffffff8135f18b>] __device_suspend+0x26b/0x2d0
 [  807.808334]  [<ffffffff8136016f>] async_suspend+0x1f/0xa0
 [  807.808625]  [<ffffffff81099634>] async_run_entry_fn+0x84/0x160
 [  807.808943]  [<ffffffff8108938a>] process_one_work+0x1aa/0x520
 [  807.809255]  [<ffffffff8108931d>] ? process_one_work+0x13d/0x520
 [  807.809568]  [<ffffffff810995b0>] ? async_schedule+0x20/0x20
 [  807.809870]  [<ffffffff8108ba7b>] worker_thread+0x17b/0x3b0
 [  807.810167]  [<ffffffff8108b900>] ? manage_workers+0x120/0x120
 [  807.810476]  [<ffffffff81090af6>] kthread+0xb6/0xc0
 [  807.810746]  [<ffffffff810aa5fd>] ? trace_hardirqs_on_caller+0x10d/0x1a0
 [  807.811092]  [<ffffffff81540184>] kernel_thread_helper+0x4/0x10
 [  807.811404]  [<ffffffff81535774>] ? retint_restore_args+0x13/0x13
 [  807.811723]  [<ffffffff81090a40>] ? __init_kthread_worker+0x70/0x70
 [  807.812053]  [<ffffffff81540180>] ? gs_change+0x13/0x13

-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab

--------------090100060109080504070306
Content-Type: text/plain;
 name="messages"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="messages"

Jun  6 09:08:54 istl-vmc-blade9 kernel: [   36.903286] kobject: 'state1' (ffff8801f1cc97a8): auto cleanup 'remove' event
Jun  6 09:08:54 istl-vmc-blade9 kernel: [   36.910556] kobject: 'state1' (ffff8801f1cc97a8): kobject_uevent_env
Jun  6 09:08:54 istl-vmc-blade9 kernel: [   36.917050] kobject: 'state1' (ffff8801f1cc97a8): fill_kobj_path: path = '/devices/system/cpu/cpu13/cpuidle/state1'
Jun  6 09:08:54 istl-vmc-blade9 kernel: [   36.927698] kobject: 'state1' (ffff8801f1cc97a8): auto cleanup kobject_del
Jun  6 09:08:54 istl-vmc-blade9 kernel: [   36.934717] kobject: 'state1' (ffff8801f1cc97a8): calling ktype release
Jun  6 09:08:54 istl-vmc-blade9 kernel: [   36.941463] kobject: 'state1': free name
Jun  6 09:09:02 istl-vmc-blade9 kernel: [   96.100066] kobject: 'vcsa4' (ffff8801f3787810): fill_kobj_path: path = '/devices/virtual/vc/vcsa4'
Jun  6 09:09:03 istl-vmc-blade9 kernel: [   97.213904] eth1: no IPv6 routers present
Jun  6 09:19:10 istl-vmc-blade9 kernel: [  704.108957] mv used greatest stack depth: 3232 bytes left
Jun  6 09:22:15 istl-vmc-blade9 kernel: [  888.479629] kobject: 'cpufreq' (ffff8801f28fb2a8): kobject_cleanup
Jun  6 09:22:15 istl-vmc-blade9 kernel: [  888.485949] kobject: 'cpufreq' (ffff8801f28fb2a8): auto cleanup 'remove' event
Jun  6 09:22:15 istl-vmc-blade9 kernel: [  888.493372] kobject: 'cpufreq' (ffff8801f28fb2a8): kobject_uevent_env
Jun  6 09:22:15 istl-vmc-blade9 kernel: [  888.499948] kobject: 'cpufreq' (ffff8801f28fb2a8): fill_kobj_path: path = '/devices/system/cpu/cpu1/cpufreq'
Jun  6 09:22:15 istl-vmc-blade9 kernel: [  888.510524] kobject: 'cpufreq' (ffff8801f28fb2a8): auto cleanup kobject_del
Jun  6 09:22:15 istl-vmc-blade9 kernel: [  888.523363] kobject: 'cpufreq' (ffff8801f28fb2a8): calling ktype release
Jun  6 09:22:15 istl-vmc-blade9 kernel: [  888.530283] kobject: 'cpufreq': free name
Jun  6 09:22:15 istl-vmc-blade9 kernel: [  888.542276] CPU 1 is now offline
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.547080] 
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.547082] =======================================================
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.555015] [ INFO: possible circular locking dependency detected ]
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.561383] 3.1.0-rc2 #1
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.564002] -------------------------------------------------------
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.570356] invert_cpu_stat/32192 is trying to acquire lock:
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.576101]  (alc_key){..-...}, at: [<ffffffff81168fa9>] kmem_cache_free+0x1a9/0x240
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.584101] 
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.584103] but task is already holding lock:
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.590127]  (&(&parent->list_lock)->rlock){-.-...}, at: [<ffffffff81169294>] __drain_alien_cache+0x64/0xa0
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.600121] 
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.600123] which lock already depends on the new lock.
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.600125] 
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.608587] 
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.608588] the existing dependency chain (in reverse order) is:
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.616259] 
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.616261] -> #1 (&(&parent->list_lock)->rlock){-.-...}:
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.623414]        [<ffffffff810ab50c>] validate_chain+0x6cc/0x7d0
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.629721]        [<ffffffff810ab914>] __lock_acquire+0x304/0x500
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.636020]        [<ffffffff810ac1d2>] lock_acquire+0xa2/0x130
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.642071]        [<ffffffff815349b6>] _raw_spin_lock+0x36/0x70
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.648203]        [<ffffffff81169294>] __drain_alien_cache+0x64/0xa0
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.654765]        [<ffffffff811698cb>] kfree+0x1db/0x2a0
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.660280]        [<ffffffff81169a21>] free_alien_cache+0x91/0xa0
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.666578]        [<ffffffff8152e9b9>] cpuup_prepare+0x168/0x1a9
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.672794]        [<ffffffff8152ea2f>] cpuup_callback+0x35/0xc5
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.678923]        [<ffffffff815393a4>] notifier_call_chain+0x94/0xd0
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.685483]        [<ffffffff8109770e>] __raw_notifier_call_chain+0xe/0x10
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.692485]        [<ffffffff8106d000>] __cpu_notify+0x20/0x40
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.698445]        [<ffffffff8152cf02>] _cpu_up+0x6e/0x10e
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.704061]        [<ffffffff8152d07b>] cpu_up+0xd9/0xec
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.709491]        [<ffffffff81e21bd6>] smp_init+0x41/0x96
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.715093]        [<ffffffff81e03791>] kernel_init+0x1ef/0x2a6
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.721138]        [<ffffffff81540184>] kernel_thread_helper+0x4/0x10
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.727703] 
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.727705] -> #0 (alc_key){..-...}:
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.733033]        [<ffffffff810aae18>] check_prev_add+0x528/0x550
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.741075]        [<ffffffff810ab50c>] validate_chain+0x6cc/0x7d0
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.747378]        [<ffffffff810ab914>] __lock_acquire+0x304/0x500
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.753678]        [<ffffffff810ac1d2>] lock_acquire+0xa2/0x130
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.759721]        [<ffffffff815349b6>] _raw_spin_lock+0x36/0x70
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.765843]        [<ffffffff81168fa9>] kmem_cache_free+0x1a9/0x240
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.772230]        [<ffffffff81169094>] slab_destroy+0x54/0x80
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.778184]        [<ffffffff8116911d>] free_block+0x5d/0x170
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.784046]        [<ffffffff811692bc>] __drain_alien_cache+0x8c/0xa0
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.790606]        [<ffffffff811698cb>] kfree+0x1db/0x2a0
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.796119]        [<ffffffff8152e6d4>] cpuup_canceled+0x146/0x1a3
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.802418]        [<ffffffff8152ea96>] cpuup_callback+0x9c/0xc5
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.808543]        [<ffffffff815393a4>] notifier_call_chain+0x94/0xd0
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.815103]        [<ffffffff8109770e>] __raw_notifier_call_chain+0xe/0x10
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.822093]        [<ffffffff8106d000>] __cpu_notify+0x20/0x40
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.828054]        [<ffffffff8106d035>] cpu_notify_nofail+0x15/0x30
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.834436]        [<ffffffff8151beed>] _cpu_down+0x12d/0x2b0
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.840303]        [<ffffffff8151c0a6>] cpu_down+0x36/0x50
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.845908]        [<ffffffff8151e571>] store_online+0x71/0xd0
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.851862]        [<ffffffff81355eb0>] sysdev_store+0x20/0x30
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.857813]        [<ffffffff811f3096>] sysfs_write_file+0xe6/0x170
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.864211]        [<ffffffff8117ee50>] vfs_write+0xd0/0x1a0
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.869990]        [<ffffffff8117f024>] sys_write+0x54/0xa0
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.875676]        [<ffffffff8153df02>] system_call_fastpath+0x16/0x1b
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.882333] 
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.882334] other info that might help us debug this:
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.882335] 
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.890623]  Possible unsafe locking scenario:
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.890625] 
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.896727]        CPU0                    CPU1
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.901339]        ----                    ----
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.905955]   lock(&(&parent->list_lock)->rlock);
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.910800]                                lock(alc_key);
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.916340]                                lock(&(&parent->list_lock)->rlock);
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.923779]   lock(alc_key);
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.926804] 
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.926805]  *** DEADLOCK ***
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.926806] 
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.933016] 8 locks held by invert_cpu_stat/32192:
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.937892]  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff811f2ff4>] sysfs_write_file+0x44/0x170
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.946931]  #1:  (s_active#68){.+.+.+}, at: [<ffffffff811f307d>] sysfs_write_file+0xcd/0x170
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.955720]  #2:  (x86_cpu_hotplug_driver_mutex){+.+.+.}, at: [<ffffffff810315f7>] cpu_hotplug_driver_lock+0x17/0x20
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.966508]  #3:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8106d067>] cpu_maps_update_begin+0x17/0x20
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.976324]  #4:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8106d0bc>] cpu_hotplug_begin+0x2c/0x60
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.985530]  #5:  (cache_chain_mutex){+.+.+.}, at: [<ffffffff8152ea8e>] cpuup_callback+0x94/0xc5
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  888.994565]  #6:  (&(&nc->lock)->rlock){..-...}, at: [<ffffffff811698b4>] kfree+0x1c4/0x2a0
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.003167]  #7:  (&(&parent->list_lock)->rlock){-.-...}, at: [<ffffffff81169294>] __drain_alien_cache+0x64/0xa0
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.013586] 
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.013588] stack backtrace:
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.018124] Pid: 32192, comm: invert_cpu_stat Not tainted 3.1.0-rc2 #1
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.024728] Call Trace:
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.027266]  [<ffffffff810a8e39>] print_circular_bug+0x109/0x110
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.033356]  [<ffffffff810aae18>] check_prev_add+0x528/0x550
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.039109]  [<ffffffff810ab50c>] validate_chain+0x6cc/0x7d0
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.044859]  [<ffffffff8101a3f9>] ? sched_clock+0x9/0x10
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.050261]  [<ffffffff8109839d>] ? sched_clock_cpu+0xcd/0x110
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.056179]  [<ffffffff810ab914>] __lock_acquire+0x304/0x500
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.061935]  [<ffffffff810ac1d2>] lock_acquire+0xa2/0x130
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.067421]  [<ffffffff81168fa9>] ? kmem_cache_free+0x1a9/0x240
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.073436]  [<ffffffff815349b6>] _raw_spin_lock+0x36/0x70
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.079003]  [<ffffffff81168fa9>] ? kmem_cache_free+0x1a9/0x240
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.085010]  [<ffffffff81168fa9>] kmem_cache_free+0x1a9/0x240
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.090843]  [<ffffffff81169094>] slab_destroy+0x54/0x80
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.096245]  [<ffffffff8116911d>] free_block+0x5d/0x170
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.101561]  [<ffffffff811692bc>] __drain_alien_cache+0x8c/0xa0
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.107567]  [<ffffffff811698cb>] kfree+0x1db/0x2a0
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.112533]  [<ffffffff8152e6d4>] cpuup_canceled+0x146/0x1a3
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.118278]  [<ffffffff8152ea96>] cpuup_callback+0x9c/0xc5
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.123849]  [<ffffffff815393a4>] notifier_call_chain+0x94/0xd0
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.129859]  [<ffffffff8109770e>] __raw_notifier_call_chain+0xe/0x10
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.136303]  [<ffffffff8106d000>] __cpu_notify+0x20/0x40
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.141703]  [<ffffffff8106d035>] cpu_notify_nofail+0x15/0x30
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.147549]  [<ffffffff8151beed>] _cpu_down+0x12d/0x2b0
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.152860]  [<ffffffff8151c0a6>] cpu_down+0x36/0x50
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.157909]  [<ffffffff8151e571>] store_online+0x71/0xd0
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.163309]  [<ffffffff81355eb0>] sysdev_store+0x20/0x30
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.168706]  [<ffffffff811f3096>] sysfs_write_file+0xe6/0x170
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.174539]  [<ffffffff8117ee50>] vfs_write+0xd0/0x1a0
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.179758]  [<ffffffff8117f024>] sys_write+0x54/0xa0
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.184893]  [<ffffffff8153df02>] system_call_fastpath+0x16/0x1b
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.191847] kobject: 'index0' (ffff88046e13cc00): kobject_cleanup
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.198069] kobject: 'index0' (ffff88046e13cc00): does not have a release() function, it is broken and must be fixed.
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.208854] kobject: 'index0' (ffff88046e13cc00): auto cleanup 'remove' event
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.216101] kobject: 'index0' (ffff88046e13cc00): kobject_uevent_env
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.222595] kobject: 'index0' (ffff88046e13cc00): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index0'
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.233183] kobject: 'index0' (ffff88046e13cc00): auto cleanup kobject_del
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.240366] kobject: 'index0': free name
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.244403] kobject: 'index1' (ffff88046e13cc48): kobject_cleanup
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.250605] kobject: 'index1' (ffff88046e13cc48): does not have a release() function, it is broken and must be fixed.
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.261403] kobject: 'index1' (ffff88046e13cc48): auto cleanup 'remove' event
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.268665] kobject: 'index1' (ffff88046e13cc48): kobject_uevent_env
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.275158] kobject: 'index1' (ffff88046e13cc48): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index1'
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.285700] kobject: 'index1' (ffff88046e13cc48): auto cleanup kobject_del
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.292724] kobject: 'index1': free name
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.296881] kobject: 'index2' (ffff88046e13cc90): kobject_cleanup
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.303092] kobject: 'index2' (ffff88046e13cc90): does not have a release() function, it is broken and must be fixed.
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.313903] kobject: 'index2' (ffff88046e13cc90): auto cleanup 'remove' event
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.321161] kobject: 'index2' (ffff88046e13cc90): kobject_uevent_env
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.327654] kobject: 'index2' (ffff88046e13cc90): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index2'
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.338195] kobject: 'index2' (ffff88046e13cc90): auto cleanup kobject_del
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.345243] kobject: 'index2': free name
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.349416] kobject: 'index3' (ffff88046e13ccd8): kobject_cleanup
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.355624] kobject: 'index3' (ffff88046e13ccd8): does not have a release() function, it is broken and must be fixed.
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.366417] kobject: 'index3' (ffff88046e13ccd8): auto cleanup 'remove' event
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.373662] kobject: 'index3' (ffff88046e13ccd8): kobject_uevent_env
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.380149] kobject: 'index3' (ffff88046e13ccd8): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index3'
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.390637] kobject: 'index3' (ffff88046e13ccd8): auto cleanup kobject_del
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.397658] kobject: 'index3': free name
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.401794] kobject: 'cache' (ffff8801f41e74c0): kobject_cleanup
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.407905] kobject: 'cache' (ffff8801f41e74c0): does not have a release() function, it is broken and must be fixed.
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.418608] kobject: 'cache' (ffff8801f41e74c0): auto cleanup 'remove' event
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.425763] kobject: 'cache' (ffff8801f41e74c0): kobject_uevent_env
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.432161] kobject: 'cache' (ffff8801f41e74c0): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache'
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.442012] kobject: 'cache' (ffff8801f41e74c0): auto cleanup kobject_del
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.448935] kobject: 'cache': free name
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.453079] kobject: 'machinecheck1' (ffff8801f880cff0): kobject_cleanup
Jun  6 09:22:16 istl-vmc-blade9 kernel: [  889.459890] kobject: 'machinecheck1' (ffff8801f880cff0): does not have a release() function, it is broken and must be fixed.
Jun  6 09:23:41 istl-vmc-blade9 kernel: [  951.612608] kobject: 'index3' (ffff8801f466d8d8): kobject_uevent_env
Jun  6 09:42:45 istl-vmc-blade9 kernel: [  672.711645] kobject: 'machinecheck1': free name
Jun  6 09:42:45 istl-vmc-blade9 kernel: [  672.724696] kobject: 'msr1' (ffff8801f22da810): kobject_uevent_env
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  672.749659] kobject: 'msr1' (ffff8801f22da810): fill_kobj_path: path = '/devices/virtual/msr/msr1'
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  672.791525] kobject: 'msr1' (ffff8801f22da810): kobject_cleanup
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  672.797639] kobject: 'msr1' (ffff8801f22da810): calling ktype release
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  672.804228] kobject: 'msr1': free name
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  672.824549] kobject: 'cpu1' (ffff88046f76b810): kobject_uevent_env
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  672.864412] kobject: 'cpu1' (ffff88046f76b810): fill_kobj_path: path = '/devices/virtual/cpuid/cpu1'
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  672.903379] kobject: 'cpu1' (ffff88046f76b810): kobject_cleanup
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  672.909491] kobject: 'cpu1' (ffff88046f76b810): calling ktype release
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  672.916103] kobject: 'cpu1': free name
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  672.944856] CPU 9 MCA banks CMCI:2 CMCI:3 CMCI:5
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  672.950142] kobject: 'cpu1' (ffff8801f880c338): kobject_uevent_env
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  672.956561] kobject: 'cpu1' (ffff8801f880c338): fill_kobj_path: path = '/devices/system/cpu/cpu1'
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.025515] kobject: 'cpufreq' (ffff8801f3bab4a8): kobject_cleanup
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.031892] kobject: 'cpufreq' (ffff8801f3bab4a8): auto cleanup 'remove' event
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.039381] kobject: 'cpufreq' (ffff8801f3bab4a8): kobject_uevent_env
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.054134] kobject: 'cpufreq' (ffff8801f3bab4a8): fill_kobj_path: path = '/devices/system/cpu/cpu2/cpufreq'
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.083822] kobject: 'cpufreq' (ffff8801f3bab4a8): auto cleanup kobject_del
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.107848] kobject: 'cpufreq' (ffff8801f3bab4a8): calling ktype release
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.114764] kobject: 'cpufreq': free name
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.150428] CPU 2 is now offline
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.166188] kobject: 'index0' (ffff88046e0e4400): kobject_cleanup
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.172453] kobject: 'index0' (ffff88046e0e4400): does not have a release() function, it is broken and must be fixed.
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.183328] kobject: 'index0' (ffff88046e0e4400): auto cleanup 'remove' event
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.190622] kobject: 'index0' (ffff88046e0e4400): kobject_uevent_env
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.197444] kobject: 'index0' (ffff88046e0e4400): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache/index0'
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.208348] kobject: 'index0' (ffff88046e0e4400): auto cleanup kobject_del
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.217089] kobject: 'index0': free name
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.221225] kobject: 'index1' (ffff88046e0e4448): kobject_cleanup
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.227517] kobject: 'index1' (ffff88046e0e4448): does not have a release() function, it is broken and must be fixed.
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.238412] kobject: 'index1' (ffff88046e0e4448): auto cleanup 'remove' event
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241124] 
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241125] =======================================================
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241128] [ INFO: possible circular locking dependency detected ]
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241130] 3.1.0-rc2 #1
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241131] -------------------------------------------------------
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241134] as/12971 is trying to acquire lock:
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241136]  (alc_key){..-...}, at: [<ffffffff81168fa9>] kmem_cache_free+0x1a9/0x240
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241145] 
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241146] but task is already holding lock:
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241148]  (&(&parent->list_lock)->rlock){-.-...}, at: [<ffffffff81169294>] __drain_alien_cache+0x64/0xa0
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241153] 
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241154] which lock already depends on the new lock.
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241155] 
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241157] 
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241157] the existing dependency chain (in reverse order) is:
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241160] 
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241160] -> #1 (&(&parent->list_lock)->rlock){-.-...}:
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241164]        [<ffffffff810ab50c>] validate_chain+0x6cc/0x7d0
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241169]        [<ffffffff810ab914>] __lock_acquire+0x304/0x500
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241173]        [<ffffffff810ac1d2>] lock_acquire+0xa2/0x130
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241176]        [<ffffffff815349b6>] _raw_spin_lock+0x36/0x70
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241183]        [<ffffffff81169294>] __drain_alien_cache+0x64/0xa0
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241186]        [<ffffffff811698cb>] kfree+0x1db/0x2a0
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241189]        [<ffffffff81169a21>] free_alien_cache+0x91/0xa0
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241192]        [<ffffffff8152e9b9>] cpuup_prepare+0x168/0x1a9
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241196]        [<ffffffff8152ea2f>] cpuup_callback+0x35/0xc5
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241200]        [<ffffffff815393a4>] notifier_call_chain+0x94/0xd0
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241204]        [<ffffffff8109770e>] __raw_notifier_call_chain+0xe/0x10
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241211]        [<ffffffff8106d000>] __cpu_notify+0x20/0x40
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241218]        [<ffffffff8152cf02>] _cpu_up+0x6e/0x10e
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241225]        [<ffffffff8152d07b>] cpu_up+0xd9/0xec
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241228]        [<ffffffff81e21bd6>] smp_init+0x41/0x96
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241234]        [<ffffffff81e03791>] kernel_init+0x1ef/0x2a6
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241240]        [<ffffffff81540184>] kernel_thread_helper+0x4/0x10
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241247] 
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241248] -> #0 (alc_key){..-...}:
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241250]        [<ffffffff810aae18>] check_prev_add+0x528/0x550
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241254]        [<ffffffff810ab50c>] validate_chain+0x6cc/0x7d0
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241256]        [<ffffffff810ab914>] __lock_acquire+0x304/0x500
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241260]        [<ffffffff810ac1d2>] lock_acquire+0xa2/0x130
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241263]        [<ffffffff815349b6>] _raw_spin_lock+0x36/0x70
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241267]        [<ffffffff81168fa9>] kmem_cache_free+0x1a9/0x240
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241270]        [<ffffffff81169094>] slab_destroy+0x54/0x80
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241273]        [<ffffffff8116911d>] free_block+0x5d/0x170
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241277]        [<ffffffff811692bc>] __drain_alien_cache+0x8c/0xa0
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241280]        [<ffffffff811698cb>] kfree+0x1db/0x2a0
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241283]        [<ffffffff810d8c6e>] audit_free_context+0x15e/0x1c0
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241287]        [<ffffffff810daf39>] audit_free+0x99/0xb0
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241290]        [<ffffffff810704ad>] do_exit+0x35d/0x480
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241294]        [<ffffffff8107062e>] do_group_exit+0x5e/0xd0
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241297]        [<ffffffff810706b7>] sys_exit_group+0x17/0x20
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241300]        [<ffffffff8153df02>] system_call_fastpath+0x16/0x1b
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241305] 
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241306] other info that might help us debug this:
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241307] 
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241309]  Possible unsafe locking scenario:
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241310] 
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241311]        CPU0                    CPU1
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241313]        ----                    ----
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241314]   lock(&(&parent->list_lock)->rlock);
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241317]                                lock(alc_key);
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241319]                                lock(&(&parent->list_lock)->rlock);
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241322]   lock(alc_key);
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241324] 
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241325]  *** DEADLOCK ***
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241326] 
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241328] 2 locks held by as/12971:
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241330]  #0:  (&(&nc->lock)->rlock){-.-...}, at: [<ffffffff811698b4>] kfree+0x1c4/0x2a0
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241335]  #1:  (&(&parent->list_lock)->rlock){-.-...}, at: [<ffffffff81169294>] __drain_alien_cache+0x64/0xa0
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241342] 
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241342] stack backtrace:
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241346] Pid: 12971, comm: as Not tainted 3.1.0-rc2 #1
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241349] Call Trace:
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241358]  [<ffffffff810a8e39>] print_circular_bug+0x109/0x110
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241362]  [<ffffffff810aae18>] check_prev_add+0x528/0x550
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241366]  [<ffffffff810ab50c>] validate_chain+0x6cc/0x7d0
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241374]  [<ffffffff8101a3f9>] ? sched_clock+0x9/0x10
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241380]  [<ffffffff8109839d>] ? sched_clock_cpu+0xcd/0x110
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241384]  [<ffffffff810ab914>] __lock_acquire+0x304/0x500
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241388]  [<ffffffff810ac1d2>] lock_acquire+0xa2/0x130
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241391]  [<ffffffff81168fa9>] ? kmem_cache_free+0x1a9/0x240
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241396]  [<ffffffff815349b6>] _raw_spin_lock+0x36/0x70
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241400]  [<ffffffff81168fa9>] ? kmem_cache_free+0x1a9/0x240
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241403]  [<ffffffff81168fa9>] kmem_cache_free+0x1a9/0x240
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241407]  [<ffffffff81169094>] slab_destroy+0x54/0x80
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241411]  [<ffffffff8116911d>] free_block+0x5d/0x170
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241414]  [<ffffffff811692bc>] __drain_alien_cache+0x8c/0xa0
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241418]  [<ffffffff811698cb>] kfree+0x1db/0x2a0
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241422]  [<ffffffff810d8c6e>] audit_free_context+0x15e/0x1c0
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241426]  [<ffffffff810daf39>] audit_free+0x99/0xb0
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241430]  [<ffffffff810704ad>] do_exit+0x35d/0x480
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241433]  [<ffffffff810aa5fd>] ? trace_hardirqs_on_caller+0x10d/0x1a0
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241437]  [<ffffffff8107062e>] do_group_exit+0x5e/0xd0
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241440]  [<ffffffff810706b7>] sys_exit_group+0x17/0x20
Jun  6 09:42:46 istl-vmc-blade9 kernel: [  673.241444]  [<ffffffff8153df02>] system_call_fastpath+0x16/0x1b
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  673.745649] kobject: 'index1' (ffff88046e0e4448): kobject_uevent_env
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  673.763042] kobject: 'index1' (ffff88046e0e4448): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache/index1'
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  673.780585] kobject: 'index1' (ffff88046e0e4448): auto cleanup kobject_del
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  673.790108] kobject: 'index1': free name
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  673.794218] kobject: 'index2' (ffff88046e0e4490): kobject_cleanup
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  673.800476] kobject: 'index2' (ffff88046e0e4490): does not have a release() function, it is broken and must be fixed.
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  673.811323] kobject: 'index2' (ffff88046e0e4490): auto cleanup 'remove' event
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  673.818624] kobject: 'index2' (ffff88046e0e4490): kobject_uevent_env
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  673.829306] kobject: 'index2' (ffff88046e0e4490): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache/index2'
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  673.842530] kobject: 'index2' (ffff88046e0e4490): auto cleanup kobject_del
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  673.852541] kobject: 'index2': free name
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  673.856655] kobject: 'index3' (ffff88046e0e44d8): kobject_cleanup
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  673.862910] kobject: 'index3' (ffff88046e0e44d8): does not have a release() function, it is broken and must be fixed.
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  673.873742] kobject: 'index3' (ffff88046e0e44d8): auto cleanup 'remove' event
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  673.881033] kobject: 'index3' (ffff88046e0e44d8): kobject_uevent_env
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  673.902829] kobject: 'index3' (ffff88046e0e44d8): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache/index3'
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  673.922805] kobject: 'index3' (ffff88046e0e44d8): auto cleanup kobject_del
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  673.929859] kobject: 'index3': free name
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  673.933944] kobject: 'cache' (ffff8801f21ef740): kobject_cleanup
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  673.940111] kobject: 'cache' (ffff8801f21ef740): does not have a release() function, it is broken and must be fixed.
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  673.950862] kobject: 'cache' (ffff8801f21ef740): auto cleanup 'remove' event
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  673.958067] kobject: 'cache' (ffff8801f21ef740): kobject_uevent_env
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  673.972723] kobject: 'cache' (ffff8801f21ef740): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache'
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  673.982504] kobject: 'cache' (ffff8801f21ef740): auto cleanup kobject_del
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  674.002671] kobject: 'cache': free name
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  674.006714] kobject: 'machinecheck2' (ffff8801f8a0cff0): kobject_cleanup
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  674.013580] kobject: 'machinecheck2' (ffff8801f8a0cff0): does not have a release() function, it is broken and must be fixed.
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  674.025032] kobject: 'machinecheck2' (ffff8801f8a0cff0): auto cleanup 'remove' event
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  674.032997] kobject: 'machinecheck2' (ffff8801f8a0cff0): kobject_uevent_env
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  674.052629] kobject: 'machinecheck2' (ffff8801f8a0cff0): fill_kobj_path: path = '/devices/system/machinecheck/machinecheck2'
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  674.072581] kobject: 'machinecheck2' (ffff8801f8a0cff0): auto cleanup kobject_del
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  674.080441] kobject: 'machinecheck2': free name
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  674.110514] kobject: 'msr2' (ffff8801f22da010): kobject_uevent_env
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  674.122486] kobject: 'msr2' (ffff8801f22da010): fill_kobj_path: path = '/devices/virtual/msr/msr2'
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  674.151451] kobject: 'msr2' (ffff8801f22da010): kobject_cleanup
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  674.157594] kobject: 'msr2' (ffff8801f22da010): calling ktype release
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  674.164195] kobject: 'msr2': free name
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  674.172436] kobject: 'cpu2' (ffff88046f773010): kobject_uevent_env
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  674.178784] kobject: 'cpu2' (ffff88046f773010): fill_kobj_path: path = '/devices/virtual/cpuid/cpu2'
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  674.189698] kobject: 'cpu2' (ffff88046f773010): kobject_cleanup
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  674.195808] kobject: 'cpu2' (ffff88046f773010): calling ktype release
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  674.202400] kobject: 'cpu2': free name
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  674.240281] CPU 10 MCA banks CMCI:2 CMCI:3 CMCI:5
Jun  6 09:42:47 istl-vmc-blade9 kernel: [  674.281242] kobject: 'cpu2' (ffff8801f8a0c338): kobject_uevent_env
Jun  6 09:51:51 istl-vmc-blade9 kernel: [   97.656018] kobject: 'vcsa4' (ffff8801f25e3010): kobject_add_internal: parent: 'vc', set: 'devices'
Jun  6 09:51:51 istl-vmc-blade9 kernel: [   97.656196] kobject: 'vcsa4' (ffff8801f25e3010): kobject_uevent_env
Jun  6 09:51:51 istl-vmc-blade9 kernel: [   97.656201] kobject: 'vcsa4' (ffff8801f25e3010): fill_kobj_path: path = '/devices/virtual/vc/vcsa4'
Jun  6 09:51:51 istl-vmc-blade9 kernel: [   97.706039] kobject: 'vcs6' (ffff8801f2bd3810): kobject_add_internal: parent: 'vc', set: 'devices'
Jun  6 09:51:51 istl-vmc-blade9 kernel: [   97.706262] kobject: 'vcs6' (ffff8801f2bd3810): kobject_uevent_env
Jun  6 09:51:51 istl-vmc-blade9 kernel: [   97.706274] kobject: 'vcs6' (ffff8801f2bd3810): fill_kobj_path: path = '/devices/virtual/vc/vcs6'
Jun  6 09:51:51 istl-vmc-blade9 kernel: [   97.706310] kobject: 'vcsa6' (ffff8801edaed810): kobject_add_internal: parent: 'vc', set: 'devices'
Jun  6 09:51:51 istl-vmc-blade9 kernel: [   97.706479] kobject: 'vcsa6' (ffff8801edaed810): kobject_uevent_env
Jun  6 09:51:51 istl-vmc-blade9 kernel: [   97.706483] kobject: 'vcsa6' (ffff8801edaed810): fill_kobj_path: path = '/devices/virtual/vc/vcsa6'
Jun  6 09:51:51 istl-vmc-blade9 kernel: [   97.756317] kobject: 'vcs5' (ffff8801f346d810): kobject_add_internal: parent: 'vc', set: 'devices'
Jun  6 09:51:51 istl-vmc-blade9 kernel: [   97.756512] kobject: 'vcs5' (ffff8801f346d810): kobject_uevent_env
Jun  6 09:51:51 istl-vmc-blade9 kernel: [   97.756524] kobject: 'vcs5' (ffff8801f346d810): fill_kobj_path: path = '/devices/virtual/vc/vcs5'
Jun  6 09:51:51 istl-vmc-blade9 kernel: [   97.756559] kobject: 'vcsa5' (ffff8801f346d010): kobject_add_internal: parent: 'vc', set: 'devices'
Jun  6 09:51:51 istl-vmc-blade9 kernel: [   97.756885] kobject: 'vcsa5' (ffff8801f346d010): kobject_uevent_env
Jun  6 09:51:51 istl-vmc-blade9 kernel: [   97.756889] kobject: 'vcsa5' (ffff8801f346d010): fill_kobj_path: path = '/devices/virtual/vc/vcsa5'
Jun  6 09:52:54 istl-vmc-blade9 kernel: [  161.323651] PM: Hibernation mode set to 'reboot'
Jun  6 09:53:01 istl-vmc-blade9 kernel: [  167.832299] kobject: 'vcs63' (ffff8801f124d810): kobject_add_internal: parent: 'vc', set: 'devices'
Jun  6 09:53:01 istl-vmc-blade9 kernel: [  167.836436] kobject: 'vcs63' (ffff8801f124d810): kobject_uevent_env
Jun  6 09:53:01 istl-vmc-blade9 kernel: [  167.836448] kobject: 'vcs63' (ffff8801f124d810): fill_kobj_path: path = '/devices/virtual/vc/vcs63'
Jun  6 09:53:01 istl-vmc-blade9 kernel: [  167.836568] kobject: 'vcsa63' (ffff8801f1e4f010): kobject_add_internal: parent: 'vc', set: 'devices'
Jun  6 09:53:01 istl-vmc-blade9 kernel: [  167.836735] kobject: 'vcsa63' (ffff8801f1e4f010): kobject_uevent_env
Jun  6 09:53:01 istl-vmc-blade9 kernel: [  167.836742] kobject: 'vcsa63' (ffff8801f1e4f010): fill_kobj_path: path = '/devices/virtual/vc/vcsa63'
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  167.889126] PM: Marking nosave pages: 000000000009c000 - 0000000000100000
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  167.889129] PM: Marking nosave pages: 000000007cdcd000 - 000000007ce91000
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  167.889134] PM: Marking nosave pages: 000000007d584000 - 000000007d634000
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  167.889137] PM: Marking nosave pages: 000000007f68f000 - 000000007f7ff000
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  167.889143] PM: Marking nosave pages: 000000007f800000 - 0000000100000000
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  167.890491] PM: Basic memory bitmaps created
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  167.890493] PM: Syncing filesystems ... done.
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  167.896729] Freezing user space processes ... (elapsed 0.01 seconds) done.
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  167.908030] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  167.920204] PM: Preallocating image memory... done (allocated 205859 pages)
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.512861] PM: Allocated 823436 kbytes in 0.59 seconds (1395.65 MB/s)
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.520079] sd 0:0:1:0: [sdb] Synchronizing SCSI cache
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.526969] sd 0:0:0:0: [sda] Synchronizing SCSI cache
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.546119] serial 00:08: disabled
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.546387] serial 00:07: disabled
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.547897] ACPI handle has no context!
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.548118] mptbase: ioc0: pci-suspend: pdev=0xffff8801f4626000, slot=0000:0b:00.0, Entering operating state [D3]
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.571642] 
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.571644] =======================================================
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.572083] [ INFO: possible circular locking dependency detected ]
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.572396] 3.1.0-rc2 #1
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.572563] -------------------------------------------------------
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.572876] kworker/u:3/431 is trying to acquire lock:
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.573222]  (alc_key){..-...}, at: [<ffffffff81168fa9>] kmem_cache_free+0x1a9/0x240
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.573946] 
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.573947] but task is already holding lock:
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.574455]  (&(&parent->list_lock)->rlock){-.-...}, at: [<ffffffff81169294>] __drain_alien_cache+0x64/0xa0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.575256] 
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.575257] which lock already depends on the new lock.
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.575258] 
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.575982] 
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.575983] the existing dependency chain (in reverse order) is:
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.576544] 
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.576545] -> #1 (&(&parent->list_lock)->rlock){-.-...}:
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.577284]        [<ffffffff810ab50c>] validate_chain+0x6cc/0x7d0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.577727]        [<ffffffff810ab914>] __lock_acquire+0x304/0x500
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.578172]        [<ffffffff810ac1d2>] lock_acquire+0xa2/0x130
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.578601]        [<ffffffff815349b6>] _raw_spin_lock+0x36/0x70
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.579037]        [<ffffffff81169294>] __drain_alien_cache+0x64/0xa0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.579487]        [<ffffffff811698cb>] kfree+0x1db/0x2a0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.579896]        [<ffffffff81169a21>] free_alien_cache+0x91/0xa0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.580333]        [<ffffffff8152e9b9>] cpuup_prepare+0x168/0x1a9
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.580766]        [<ffffffff8152ea2f>] cpuup_callback+0x35/0xc5
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.581199]        [<ffffffff815393a4>] notifier_call_chain+0x94/0xd0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.581646]        [<ffffffff8109770e>] __raw_notifier_call_chain+0xe/0x10
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.582116]        [<ffffffff8106d000>] __cpu_notify+0x20/0x40
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.582546]        [<ffffffff8152cf02>] _cpu_up+0x6e/0x10e
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.582964]        [<ffffffff8152d07b>] cpu_up+0xd9/0xec
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.583371]        [<ffffffff81e21bd6>] smp_init+0x41/0x96
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.583788]        [<ffffffff81e03791>] kernel_init+0x1ef/0x2a6
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.584225]        [<ffffffff81540184>] kernel_thread_helper+0x4/0x10
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.584678] 
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.584679] -> #0 (alc_key){..-...}:
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.585347]        [<ffffffff810aae18>] check_prev_add+0x528/0x550
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.585787]        [<ffffffff810ab50c>] validate_chain+0x6cc/0x7d0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.586227]        [<ffffffff810ab914>] __lock_acquire+0x304/0x500
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.586666]        [<ffffffff810ac1d2>] lock_acquire+0xa2/0x130
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.587096]        [<ffffffff815349b6>] _raw_spin_lock+0x36/0x70
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.587531]        [<ffffffff81168fa9>] kmem_cache_free+0x1a9/0x240
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.587976]        [<ffffffff81169094>] slab_destroy+0x54/0x80
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.588403]        [<ffffffff8116911d>] free_block+0x5d/0x170
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.588827]        [<ffffffff811692bc>] __drain_alien_cache+0x8c/0xa0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.589277]        [<ffffffff811698cb>] kfree+0x1db/0x2a0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.589687]        [<ffffffff8144aeb0>] skb_release_data+0xd0/0x100
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.590133]        [<ffffffff8144aefe>] __kfree_skb+0x1e/0xa0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.590557]        [<ffffffff8144afb1>] consume_skb+0x31/0x80
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.590983]        [<ffffffffa01d4e74>] bnx2_free_skbs+0x234/0x390 [bnx2]
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.591453]        [<ffffffffa01d5096>] bnx2_suspend+0xc6/0xe0 [bnx2]
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.591905]        [<ffffffff812978a6>] pci_legacy_suspend+0x46/0xe0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.592357]        [<ffffffff8129854d>] pci_pm_freeze+0xad/0xd0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.592789]        [<ffffffff8135e7f6>] pm_op+0x136/0x1a0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.593205]        [<ffffffff8135f18b>] __device_suspend+0x26b/0x2d0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.593650]        [<ffffffff8136016f>] async_suspend+0x1f/0xa0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.594080]        [<ffffffff81099634>] async_run_entry_fn+0x84/0x160
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.594528]        [<ffffffff8108938a>] process_one_work+0x1aa/0x520
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.594973]        [<ffffffff8108ba7b>] worker_thread+0x17b/0x3b0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.595407]        [<ffffffff81090af6>] kthread+0xb6/0xc0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.595817]        [<ffffffff81540184>] kernel_thread_helper+0x4/0x10
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.596273] 
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.596274] other info that might help us debug this:
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.596275] 
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.596994]  Possible unsafe locking scenario:
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.596995] 
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.597495]        CPU0                    CPU1
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.597806]        ----                    ----
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.598116]   lock(&(&parent->list_lock)->rlock);
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.598566]                                lock(alc_key);
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.599041]                                lock(&(&parent->list_lock)->rlock);
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.599658]   lock(alc_key);
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.600039] 
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.600040]  *** DEADLOCK ***
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.600041] 
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.600686] 5 locks held by kworker/u:3/431:
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.600989]  #0:  (events_unbound){.+.+.+}, at: [<ffffffff8108931d>] process_one_work+0x13d/0x520
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.601802]  #1:  ((&entry->work)){+.+.+.}, at: [<ffffffff8108931d>] process_one_work+0x13d/0x520
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.602613]  #2:  (&__lockdep_no_validate__){......}, at: [<ffffffff8135efc3>] __device_suspend+0xa3/0x2d0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.603459]  #3:  (&(&nc->lock)->rlock){-.-...}, at: [<ffffffff811698b4>] kfree+0x1c4/0x2a0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.604255]  #4:  (&(&parent->list_lock)->rlock){-.-...}, at: [<ffffffff81169294>] __drain_alien_cache+0x64/0xa0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.605119] 
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.605120] stack backtrace:
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.605564] Pid: 431, comm: kworker/u:3 Not tainted 3.1.0-rc2 #1
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.605932] Call Trace:
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.606172]  [<ffffffff810a8e39>] print_circular_bug+0x109/0x110
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.606542]  [<ffffffff810aae18>] check_prev_add+0x528/0x550
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.606901]  [<ffffffff810ab50c>] validate_chain+0x6cc/0x7d0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.607261]  [<ffffffff8101a3f9>] ? sched_clock+0x9/0x10
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.607605]  [<ffffffff8109839d>] ? sched_clock_cpu+0xcd/0x110
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.607971]  [<ffffffff810ab914>] __lock_acquire+0x304/0x500
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.608328]  [<ffffffff810ac1d2>] lock_acquire+0xa2/0x130
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.608672]  [<ffffffff81168fa9>] ? kmem_cache_free+0x1a9/0x240
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.609037]  [<ffffffff815349b6>] _raw_spin_lock+0x36/0x70
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.609385]  [<ffffffff81168fa9>] ? kmem_cache_free+0x1a9/0x240
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.609748]  [<ffffffff81168fa9>] kmem_cache_free+0x1a9/0x240
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.610105]  [<ffffffff81169094>] slab_destroy+0x54/0x80
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.610446]  [<ffffffff8116911d>] free_block+0x5d/0x170
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.610786]  [<ffffffff811692bc>] __drain_alien_cache+0x8c/0xa0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.611150]  [<ffffffff811698cb>] kfree+0x1db/0x2a0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.611475]  [<ffffffff8144aeb0>] skb_release_data+0xd0/0x100
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.611834]  [<ffffffff8144aefe>] __kfree_skb+0x1e/0xa0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.612172]  [<ffffffff8144afb1>] consume_skb+0x31/0x80
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.612515]  [<ffffffffa01d4e74>] bnx2_free_skbs+0x234/0x390 [bnx2]
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.612901]  [<ffffffffa01d5096>] bnx2_suspend+0xc6/0xe0 [bnx2]
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.613269]  [<ffffffff812978a6>] pci_legacy_suspend+0x46/0xe0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.613647]  [<ffffffff8129854d>] pci_pm_freeze+0xad/0xd0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.613993]  [<ffffffff8135e7f6>] pm_op+0x136/0x1a0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.614320]  [<ffffffff8135f18b>] __device_suspend+0x26b/0x2d0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.614682]  [<ffffffff8136016f>] async_suspend+0x1f/0xa0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.615035]  [<ffffffff81099634>] async_run_entry_fn+0x84/0x160
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.615401]  [<ffffffff8108938a>] process_one_work+0x1aa/0x520
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.615764]  [<ffffffff8108931d>] ? process_one_work+0x13d/0x520
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.616135]  [<ffffffff810995b0>] ? async_schedule+0x20/0x20
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.616491]  [<ffffffff8108ba7b>] worker_thread+0x17b/0x3b0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.616846]  [<ffffffff8108b900>] ? manage_workers+0x120/0x120
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.617209]  [<ffffffff81090af6>] kthread+0xb6/0xc0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.617536]  [<ffffffff810aa5fd>] ? trace_hardirqs_on_caller+0x10d/0x1a0
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.617935]  [<ffffffff81540184>] kernel_thread_helper+0x4/0x10
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.618307]  [<ffffffff81535774>] ? retint_restore_args+0x13/0x13
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.618684]  [<ffffffff81090a40>] ? __init_kthread_worker+0x70/0x70
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.619069]  [<ffffffff81540180>] ? gs_change+0x13/0x13
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.621684] ACPI handle has no context!
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.687750] mptsas 0000:0b:00.0: PCI INT A disabled
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.699033] PM: freeze of devices complete after 179.849 msecs
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.701477] PM: late freeze of devices complete after 2.079 msecs
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.701854] Disabling non-boot CPUs ...
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.702582] kobject: 'cpufreq' (ffff88046da36ea8): kobject_cleanup
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.702964] kobject: 'cpufreq' (ffff88046da36ea8): auto cleanup 'remove' event
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.703449] kobject: 'cpufreq' (ffff88046da36ea8): kobject_uevent_env
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.703845] kobject: 'cpufreq' (ffff88046da36ea8): fill_kobj_path: path = '/devices/system/cpu/cpu1/cpufreq'
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.704442] kobject: 'cpufreq' (ffff88046da36ea8): auto cleanup kobject_del
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.704866] kobject: 'cpufreq' (ffff88046da36ea8): calling ktype release
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.705260] kobject: 'cpufreq': free name
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.709025] CPU 1 is now offline
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.709749] kobject: 'index0' (ffff88046e138800): kobject_cleanup
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.710126] kobject: 'index0' (ffff88046e138800): does not have a release() function, it is broken and must be fixed.
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.710779] kobject: 'index0' (ffff88046e138800): auto cleanup 'remove' event
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.711188] kobject: 'index0' (ffff88046e138800): kobject_uevent_env
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.711572] kobject: 'index0' (ffff88046e138800): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index0'
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.712190] kobject: 'index0' (ffff88046e138800): auto cleanup kobject_del
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.712610] kobject: 'index0': free name
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.712900] kobject: 'index1' (ffff88046e138848): kobject_cleanup
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.713270] kobject: 'index1' (ffff88046e138848): does not have a release() function, it is broken and must be fixed.
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.713891] kobject: 'index1' (ffff88046e138848): auto cleanup 'remove' event
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.714301] kobject: 'index1' (ffff88046e138848): kobject_uevent_env
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.714689] kobject: 'index1' (ffff88046e138848): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index1'
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.715290] kobject: 'index1' (ffff88046e138848): auto cleanup kobject_del
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.715718] kobject: 'index1': free name
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.716014] kobject: 'index2' (ffff88046e138890): kobject_cleanup
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.716385] kobject: 'index2' (ffff88046e138890): does not have a release() function, it is broken and must be fixed.
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.717012] kobject: 'index2' (ffff88046e138890): auto cleanup 'remove' event
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.717423] kobject: 'index2' (ffff88046e138890): kobject_uevent_env
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.717824] kobject: 'index2' (ffff88046e138890): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index2'
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.718427] kobject: 'index2' (ffff88046e138890): auto cleanup kobject_del
Jun  6 09:53:24 istl-vmc-blade9 kernel: [  168.718846] kobject: 'index2': free name
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.308329] mptsas 0000:0b:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100047)
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.320701] PM: early restore of devices complete after 26.321 msecs
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.616587] ioatdma 0000:00:16.0: setting latency timer to 64
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.616953] ioatdma 0000:00:16.1: setting latency timer to 64
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.617318] ioatdma 0000:00:16.2: setting latency timer to 64
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.617673] ioatdma 0000:00:16.3: setting latency timer to 64
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.618037] ioatdma 0000:00:16.4: setting latency timer to 64
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.618394] ioatdma 0000:00:16.5: setting latency timer to 64
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.618744] ioatdma 0000:00:16.6: setting latency timer to 64
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.619097] ioatdma 0000:00:16.7: setting latency timer to 64
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.619447] uhci_hcd 0000:00:1a.0: setting latency timer to 64
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.619812] usb usb3: root hub lost power or was reset
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.620152] ehci_hcd 0000:00:1a.7: setting latency timer to 64
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.620594] usb usb1: root hub lost power or was reset
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.624789] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.625192] uhci_hcd 0000:00:1d.0: setting latency timer to 64
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.625561] usb usb4: root hub lost power or was reset
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.625900] uhci_hcd 0000:00:1d.1: setting latency timer to 64
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.626270] usb usb5: root hub lost power or was reset
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.626609] uhci_hcd 0000:00:1d.2: setting latency timer to 64
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.626981] usb usb6: root hub lost power or was reset
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.627319] ehci_hcd 0000:00:1d.7: setting latency timer to 64
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.627734] usb usb2: root hub lost power or was reset
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.631948] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.632355] mptbase: ioc0: pci-resume: pdev=0xffff8801f4626000, slot=0000:0b:00.0, Previous operating state [D0]
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.632944] mptsas 0000:0b:00.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.633388] mptbase: ioc0: pci-resume: ioc-state=0x1,doorbell=0x10000000
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.633801] qla2xxx 0000:24:00.0: setting latency timer to 64
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.634158] qla2xxx 0000:24:00.1: setting latency timer to 64
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.634515] pci 0000:06:00.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.634911] pci 0000:06:00.0: setting latency timer to 64
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.635805] pci 0000:00:1e.0: setting latency timer to 64
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.636470] serial 00:07: activated
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.636963] serial 00:08: activated
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.690658] Extended CMOS year: 2000
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.745958] bnx2 0000:10:00.1: eth1: NIC SerDes Link is Down
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  579.793675] bnx2 0000:10:00.1: eth1: NIC SerDes Link is Up, 1000 Mbps full duplex
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  580.089333] kobject: '(null)' (ffff880144a6a358): kobject_cleanup
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  580.140400] kobject: '(null)' (ffff880144a6a358): calling ktype release
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  580.247058] usb 2-3: reset high speed USB device number 2 using ehci_hcd
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  580.518580] usb 5-2: reset full speed USB device number 2 using uhci_hcd
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  580.759371] usb 2-3.2: reset high speed USB device number 4 using ehci_hcd
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  581.154754] usb 2-3.2.2: reset high speed USB device number 5 using ehci_hcd
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  581.552123] usb 2-3.2.2.3: reset high speed USB device number 6 using ehci_hcd
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  584.732116] mptbase: ioc0: Sending mpt_do_ioc_recovery
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  584.775197] mptbase: ioc0: Initiating bringup
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  584.950793] ioc0: LSISAS1064E: Capabilities={Initiator}
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  584.994972] mptsas 0000:0b:00.0: setting latency timer to 64
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  594.276837] mptbase: ioc0: pci-resume: success
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  594.314371] PM: restore of devices complete after 14720.622 msecs
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  594.365776] PM: Image restored successfully.
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  594.401567] Restarting tasks ... done.
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  594.722817] PM: Basic memory bitmaps freed
Jun  6 10:00:08 istl-vmc-blade9 kernel: [  595.028350] kobject: 'msr1' (ffff8801f1d0a810): kobject_add_internal: parent: 'msr', set: 'devices'
Jun  6 10:00:11 istl-vmc-blade9 kernel: [  597.666304] kobject: 'msr1' (ffff8801f1d0a810): kobject_uevent_env
Jun  6 10:00:13 istl-vmc-blade9 kernel: [  599.537440] kobject: 'msr1' (ffff8801f1d0a810): fill_kobj_path: path = '/devices/virtual/msr/msr1'
Jun  6 10:00:16 istl-vmc-blade9 kernel: [  602.245985] kobject: 'cpu1' (ffff8801ed94d810): kobject_add_internal: parent: 'cpuid', set: 'devices'
Jun  6 10:00:18 istl-vmc-blade9 kernel: [  605.148964] kobject: 'cpu1' (ffff8801ed94d810): kobject_uevent_env
Jun  6 10:00:20 istl-vmc-blade9 kernel: [  607.154779] kobject: 'cpu1' (ffff8801ed94d810): fill_kobj_path: path = '/devices/virtual/cpuid/cpu1'
Jun  6 10:00:22 istl-vmc-blade9 kernel: [  608.427954] PM: Marking nosave pages: 000000000009c000 - 0000000000100000
Jun  6 10:00:22 istl-vmc-blade9 kernel: [  608.484922] PM: Marking nosave pages: 000000007cdcd000 - 000000007ce91000
Jun  6 10:00:22 istl-vmc-blade9 kernel: [  608.541835] PM: Marking nosave pages: 000000007d584000 - 000000007d634000
Jun  6 10:00:22 istl-vmc-blade9 kernel: [  608.598743] PM: Marking nosave pages: 000000007f68f000 - 000000007f7ff000
Jun  6 10:00:22 istl-vmc-blade9 kernel: [  608.655659] PM: Marking nosave pages: 000000007f800000 - 0000000100000000
Jun  6 10:00:22 istl-vmc-blade9 kernel: [  608.713909] PM: Basic memory bitmaps created
Jun  6 10:00:24 istl-vmc-blade9 kernel: [  608.749730] PM: Syncing filesystems ... lockdep: fixing up alternatives.
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  611.295446] done.
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  611.311672] Freezing user space processes ... 
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  611.348553] SMP alternatives: switching to SMP code
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  611.396125] Booting Node 0 Processor 1 APIC 0x2
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  611.434113] smpboot cpu 1: start_ip = 97000
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  611.480285] Calibrating delay loop (skipped) already calibrated this CPU
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  611.556087] Switched to NOHz mode on CPU #1
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  611.592758] NMI watchdog enabled, takes one hw-pmu counter.
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  611.639641] kobject: 'cache' (ffff8801f25eddc0): kobject_add_internal: parent: 'cpu1', set: '<NULL>'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  611.716291] kobject: 'index0' (ffff8801f253f200): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  611.794412] kobject: 'index0' (ffff8801f253f200): kobject_uevent_env
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  611.847657] kobject: 'index0' (ffff8801f253f200): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index0'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  611.932966] kobject: 'index1' (ffff8801f253f248): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  612.011004] kobject: 'index1' (ffff8801f253f248): kobject_uevent_env
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  612.064241] kobject: 'index1' (ffff8801f253f248): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index1'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  612.149543] kobject: 'index2' (ffff8801f253f290): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  612.227590] kobject: 'index2' (ffff8801f253f290): kobject_uevent_env
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  612.280825] kobject: 'index2' (ffff8801f253f290): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index2'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  612.366127] kobject: 'index3' (ffff8801f253f2d8): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  612.444165] kobject: 'index3' (ffff8801f253f2d8): kobject_uevent_env
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  612.497402] kobject: 'index3' (ffff8801f253f2d8): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index3'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  612.582701] kobject: 'cache' (ffff8801f25eddc0): kobject_uevent_env
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  612.635211] kobject: 'cache' (ffff8801f25eddc0): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  612.714699] kobject: 'machinecheck1' (ffff8801f880cff0): kobject_add_internal: parent: 'machinecheck', set: 'machinecheck'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  612.807284] kobject: 'machinecheck1' (ffff8801f880cff0): kobject_uevent_env
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  612.865609] kobject: 'machinecheck1' (ffff8801f880cff0): fill_kobj_path: path = '/devices/system/machinecheck/machinecheck1'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  612.959857] microcode: CPU1 sig=0x206c2, pf=0x1, revision=0x13
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  613.008739] ------------[ cut here ]------------
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  613.047439] WARNING: at drivers/base/firmware_class.c:524 _request_firmware+0x279/0x2c0()
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  613.116014] Hardware name: BladeCenter HS22V -[7871G2A]-
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  613.160525] Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log microcode serio_raw pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core shpchp ioatdma dca i7core_edac edac_core bnx2 sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif usb_storage qla2xxx scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: scsi_wait_scan]
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  613.594617] Pid: 4836, comm: invert_cpu_stat Not tainted 3.1.0-rc2 #1
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  613.648583] Call Trace:
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  613.669105]  [<ffffffff8106af6f>] warn_slowpath_common+0x7f/0xc0
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  613.719439]  [<ffffffff8106afca>] warn_slowpath_null+0x1a/0x20
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  613.768315]  [<ffffffff813645a9>] _request_firmware+0x279/0x2c0
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  613.817912]  [<ffffffff81364686>] request_firmware+0x16/0x20
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  613.865336]  [<ffffffffa01f3da0>] request_microcode_fw+0x70/0xf0 [microcode]
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  613.924387]  [<ffffffffa01f3390>] microcode_init_cpu+0xc0/0x100 [microcode]
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  613.982709]  [<ffffffffa01f44b4>] mc_cpu_callback+0x7c/0x11f [microcode]
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  614.038854]  [<ffffffff815393a4>] notifier_call_chain+0x94/0xd0
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  614.088453]  [<ffffffff8109770e>] __raw_notifier_call_chain+0xe/0x10
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  614.141691]  [<ffffffff8106d000>] __cpu_notify+0x20/0x40
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  614.186205]  [<ffffffff8152cf5b>] _cpu_up+0xc7/0x10e
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  614.227809]  [<ffffffff8152d07b>] cpu_up+0xd9/0xec
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  614.267969]  [<ffffffff8151e599>] store_online+0x99/0xd0
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  614.312483]  [<ffffffff81355eb0>] sysdev_store+0x20/0x30
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  614.356996]  [<ffffffff811f3096>] sysfs_write_file+0xe6/0x170
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  614.405140]  [<ffffffff8117ee50>] vfs_write+0xd0/0x1a0
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  614.448195]  [<ffffffff8117f024>] sys_write+0x54/0xa0
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  614.490527]  [<ffffffff8153df02>] system_call_fastpath+0x16/0x1b
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  614.540853] ---[ end trace 79417b0d74e88b06 ]---
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  614.579548] platform microcode: firmware: intel-ucode/06-2c-02 will not be loaded
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  614.642491] kobject: 'cpufreq' (ffff8801f2e624a8): kobject_add_internal: parent: 'cpu1', set: '<NULL>'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  614.720611] kobject: 'cpufreq' (ffff8801f2e624a8): kobject_uevent_env
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  614.774584] kobject: 'cpufreq' (ffff8801f2e624a8): fill_kobj_path: path = '/devices/system/cpu/cpu1/cpufreq'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  614.857043] kobject: 'cpu1' (ffff8801f880c338): kobject_uevent_env
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  614.908844] kobject: 'cpu1' (ffff8801f880c338): fill_kobj_path: path = '/devices/system/cpu/cpu1'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  614.983966] (elapsed 3.64 seconds) done.
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  615.016946] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  615.089744] PM: Preallocating image memory... done (allocated 793542 pages)
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  615.754575] PM: Allocated 3174168 kbytes in 0.60 seconds (5290.28 MB/s)
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  615.810231] sd 0:0:1:0: [sdb] Synchronizing SCSI cache
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  615.854445] sd 0:0:0:0: [sda] Synchronizing SCSI cache
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  615.911553] serial 00:08: disabled
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  615.911868] serial 00:07: disabled
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  615.919547] ACPI handle has no context!
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  615.919835] mptbase: ioc0: pci-suspend: pdev=0xffff8801f4626000, slot=0000:0b:00.0, Entering operating state [D3]
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  615.937693] ACPI handle has no context!
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.058293] mptsas 0000:0b:00.0: PCI INT A disabled
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.069470] PM: freeze of devices complete after 259.869 msecs
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.072272] PM: late freeze of devices complete after 2.440 msecs
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.072646] Disabling non-boot CPUs ...
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.073213] kobject: 'cpufreq' (ffff8801f2e624a8): kobject_cleanup
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.073593] kobject: 'cpufreq' (ffff8801f2e624a8): auto cleanup 'remove' event
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.074080] kobject: 'cpufreq' (ffff8801f2e624a8): kobject_uevent_env
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.074487] kobject: 'cpufreq' (ffff8801f2e624a8): fill_kobj_path: path = '/devices/system/cpu/cpu1/cpufreq'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.075084] kobject: 'cpufreq' (ffff8801f2e624a8): auto cleanup kobject_del
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.075502] kobject: 'cpufreq' (ffff8801f2e624a8): calling ktype release
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.075892] kobject: 'cpufreq': free name
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.077641] CPU 1 is now offline
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.077918] lockdep: fixing up alternatives.
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.078620] kobject: 'index0' (ffff8801f253f200): kobject_cleanup
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.078994] kobject: 'index0' (ffff8801f253f200): does not have a release() function, it is broken and must be fixed.
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.079619] kobject: 'index0' (ffff8801f253f200): auto cleanup 'remove' event
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.080030] kobject: 'index0' (ffff8801f253f200): kobject_uevent_env
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.080423] kobject: 'index0' (ffff8801f253f200): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index0'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.081045] kobject: 'index0' (ffff8801f253f200): auto cleanup kobject_del
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.081524] kobject: 'index0': free name
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.081813] kobject: 'index1' (ffff8801f253f248): kobject_cleanup
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.082187] kobject: 'index1' (ffff8801f253f248): does not have a release() function, it is broken and must be fixed.
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.082814] kobject: 'index1' (ffff8801f253f248): auto cleanup 'remove' event
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.083238] kobject: 'index1' (ffff8801f253f248): kobject_uevent_env
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.083623] kobject: 'index1' (ffff8801f253f248): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index1'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.084250] kobject: 'index1' (ffff8801f253f248): auto cleanup kobject_del
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.084651] kobject: 'index1': free name
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.084933] kobject: 'index2' (ffff8801f253f290): kobject_cleanup
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.085381] kobject: 'index2' (ffff8801f253f290): does not have a release() function, it is broken and must be fixed.
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.085981] kobject: 'index2' (ffff8801f253f290): auto cleanup 'remove' event
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.086385] kobject: 'index2' (ffff8801f253f290): kobject_uevent_env
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.086755] kobject: 'index2' (ffff8801f253f290): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index2'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.087345] kobject: 'index2' (ffff8801f253f290): auto cleanup kobject_del
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.087739] kobject: 'index2': free name
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.088021] kobject: 'index3' (ffff8801f253f2d8): kobject_cleanup
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.088386] kobject: 'index3' (ffff8801f253f2d8): does not have a release() function, it is broken and must be fixed.
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.088984] kobject: 'index3' (ffff8801f253f2d8): auto cleanup 'remove' event
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.089420] kobject: 'index3' (ffff8801f253f2d8): kobject_uevent_env
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.089788] kobject: 'index3' (ffff8801f253f2d8): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index3'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.090410] kobject: 'index3' (ffff8801f253f2d8): auto cleanup kobject_del
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.090800] kobject: 'index3': free name
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.091079] kobject: 'cache' (ffff8801f25eddc0): kobject_cleanup
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.091439] kobject: 'cache' (ffff8801f25eddc0): does not have a release() function, it is broken and must be fixed.
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.092036] kobject: 'cache' (ffff8801f25eddc0): auto cleanup 'remove' event
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.092432] kobject: 'cache' (ffff8801f25eddc0): kobject_uevent_env
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.092801] kobject: 'cache' (ffff8801f25eddc0): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.093372] kobject: 'cache' (ffff8801f25eddc0): auto cleanup kobject_del
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.093762] kobject: 'cache': free name
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.094057] kobject: 'machinecheck1' (ffff8801f880cff0): kobject_cleanup
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.094519] kobject: 'machinecheck1' (ffff8801f880cff0): does not have a release() function, it is broken and must be fixed.
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.095145] kobject: 'machinecheck1' (ffff8801f880cff0): auto cleanup 'remove' event
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.095638] kobject: 'machinecheck1' (ffff8801f880cff0): kobject_uevent_env
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.096037] kobject: 'machinecheck1' (ffff8801f880cff0): fill_kobj_path: path = '/devices/system/machinecheck/machinecheck1'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.096702] kobject: 'machinecheck1' (ffff8801f880cff0): auto cleanup kobject_del
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.097196] kobject: 'machinecheck1': free name
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.097647] Extended CMOS year: 2000
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  616.098030] hibernation debug: Waiting for 5 seconds.
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.090948] Extended CMOS year: 2000
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.091231] Enabling non-boot CPUs ...
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.091851] lockdep: fixing up alternatives.
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.092146] Booting Node 0 Processor 1 APIC 0x2
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.092500] smpboot cpu 1: start_ip = 97000
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.105669] Calibrating delay loop (skipped) already calibrated this CPU
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.126310] NMI watchdog enabled, takes one hw-pmu counter.
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.126380] Switched to NOHz mode on CPU #1
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.127282] kobject: 'cache' (ffff8801b9397440): kobject_add_internal: parent: 'cpu1', set: '<NULL>'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.127935] kobject: 'index0' (ffff8801f3a1b800): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.128530] kobject: 'index0' (ffff8801f3a1b800): kobject_uevent_env
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.128916] kobject: 'index0' (ffff8801f3a1b800): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index0'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.129543] kobject: 'index1' (ffff8801f3a1b848): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.130124] kobject: 'index1' (ffff8801f3a1b848): kobject_uevent_env
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.130511] kobject: 'index1' (ffff8801f3a1b848): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index1'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.131121] kobject: 'index2' (ffff8801f3a1b890): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.131706] kobject: 'index2' (ffff8801f3a1b890): kobject_uevent_env
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.132088] kobject: 'index2' (ffff8801f3a1b890): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index2'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.132700] kobject: 'index3' (ffff8801f3a1b8d8): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.133271] kobject: 'index3' (ffff8801f3a1b8d8): kobject_uevent_env
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.133708] kobject: 'index3' (ffff8801f3a1b8d8): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index3'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.134307] kobject: 'cache' (ffff8801b9397440): kobject_uevent_env
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.134692] kobject: 'cache' (ffff8801b9397440): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.135277] kobject: 'machinecheck1' (ffff8801f880cff0): kobject_add_internal: parent: 'machinecheck', set: 'machinecheck'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.135919] kobject: 'machinecheck1' (ffff8801f880cff0): kobject_uevent_env
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.136330] kobject: 'machinecheck1' (ffff8801f880cff0): fill_kobj_path: path = '/devices/system/machinecheck/machinecheck1'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.137192] kobject: 'cpufreq' (ffff8801f22470a8): kobject_add_internal: parent: 'cpu1', set: '<NULL>'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.137861] kobject: 'cpufreq' (ffff8801f22470a8): kobject_uevent_env
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.138249] kobject: 'cpufreq' (ffff8801f22470a8): fill_kobj_path: path = '/devices/system/cpu/cpu1/cpufreq'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.138848] CPU1 is up
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.153392] mptsas 0000:0b:00.0: BAR 0: set to [io  0x2000-0x20ff] (PCI address [0x2000-0x20ff])
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.153952] mptsas 0000:0b:00.0: BAR 1: set to [mem 0x97a10000-0x97a13fff 64bit] (PCI address [0x97a10000-0x97a13fff])
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.154646] mptsas 0000:0b:00.0: BAR 3: set to [mem 0x97a00000-0x97a0ffff 64bit] (PCI address [0x97a00000-0x97a0ffff])
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.155309] mptsas 0000:0b:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100047)
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.167689] PM: early restore of devices complete after 26.943 msecs
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.375940] ioatdma 0000:00:16.0: setting latency timer to 64
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.376069] ioatdma 0000:00:16.1: setting latency timer to 64
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.376079] ioatdma 0000:00:16.2: setting latency timer to 64
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.376088] ioatdma 0000:00:16.3: setting latency timer to 64
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.376096] ioatdma 0000:00:16.4: setting latency timer to 64
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.376105] ioatdma 0000:00:16.5: setting latency timer to 64
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.376113] ioatdma 0000:00:16.6: setting latency timer to 64
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.376121] ioatdma 0000:00:16.7: setting latency timer to 64
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.376130] uhci_hcd 0000:00:1a.0: setting latency timer to 64
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.376161] usb usb3: root hub lost power or was reset
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.376180] ehci_hcd 0000:00:1a.7: setting latency timer to 64
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.376284] usb usb1: root hub lost power or was reset
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.380165] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.380182] uhci_hcd 0000:00:1d.0: setting latency timer to 64
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.380211] usb usb4: root hub lost power or was reset
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.380225] uhci_hcd 0000:00:1d.1: setting latency timer to 64
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.380254] usb usb5: root hub lost power or was reset
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.380270] uhci_hcd 0000:00:1d.2: setting latency timer to 64
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.380299] usb usb6: root hub lost power or was reset
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.380315] ehci_hcd 0000:00:1d.7: setting latency timer to 64
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.380390] usb usb2: root hub lost power or was reset
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.384278] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.384433] pci 0000:00:1e.0: setting latency timer to 64
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.384445] mptbase: ioc0: pci-resume: pdev=0xffff8801f4626000, slot=0000:0b:00.0, Previous operating state [D0]
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.384457] mptsas 0000:0b:00.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.384516] mptbase: ioc0: pci-resume: ioc-state=0x1,doorbell=0x10000000
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.386549] qla2xxx 0000:24:00.0: setting latency timer to 64
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.386590] qla2xxx 0000:24:00.1: setting latency timer to 64
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.386608] pci 0000:06:00.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.386618] pci 0000:06:00.0: setting latency timer to 64
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.387120] serial 00:07: activated
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.387368] serial 00:08: activated
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.398598] Extended CMOS year: 2000
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.646806] bnx2 0000:10:00.1: eth1: NIC SerDes Link is Down
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.694603] bnx2 0000:10:00.1: eth1: NIC SerDes Link is Up, 1000 Mbps full duplex
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  621.976193] kobject: '(null)' (ffff8801ed260358): kobject_cleanup
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  622.027314] kobject: '(null)' (ffff8801ed260358): calling ktype release
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  622.077992] usb 2-3: reset high speed USB device number 2 using ehci_hcd
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  622.293657] usb 5-2: reset full speed USB device number 2 using uhci_hcd
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  622.535342] usb 2-3.2: reset high speed USB device number 4 using ehci_hcd
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  622.930892] usb 2-3.2.2: reset high speed USB device number 5 using ehci_hcd
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  623.328117] usb 2-3.2.2.3: reset high speed USB device number 6 using ehci_hcd
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  626.482235] mptbase: ioc0: Sending mpt_do_ioc_recovery
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  626.525303] mptbase: ioc0: Initiating bringup
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  626.700877] ioc0: LSISAS1064E: Capabilities={Initiator}
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  626.745053] mptsas 0000:0b:00.0: setting latency timer to 64
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  636.027105] mptbase: ioc0: pci-resume: success
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  636.064825] PM: restore of devices complete after 14711.532 msecs
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  636.116241] PM: Image restored successfully.
Jun  6 10:00:50 istl-vmc-blade9 abrt: Kerneloops: Reported 1 kernel oopses to Abrt
Jun  6 10:00:50 istl-vmc-blade9 abrtd: Directory 'kerneloops-1970109050-2013-1' creation detected
Jun  6 10:00:50 istl-vmc-blade9 abrtd: Crash is in database already (dup of /var/spool/abrt/kerneloops-1969139477-1973-1)
Jun  6 10:00:50 istl-vmc-blade9 abrtd: Deleting crash kerneloops-1970109050-2013-1 (dup of kerneloops-1969139477-1973-1), sending dbus signal
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  636.152028] Restarting tasks ... done.
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  636.336480] PM: Basic memory bitmaps freed
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  636.416967] kobject: 'msr2' (ffff8801f3497010): kobject_add_internal: parent: 'msr', set: 'devices'
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  636.610880] kobject: 'msr2' (ffff8801f3497010): kobject_uevent_env
Jun  6 10:00:50 istl-vmc-blade9 kernel: [  636.753444] kobject: 'msr2' (ffff8801f3497010): fill_kobj_path: path = '/devices/virtual/msr/msr2'
Jun  6 10:00:51 istl-vmc-blade9 kernel: [  637.952101] kobject: 'cpu2' (ffff8801ed36e810): kobject_add_internal: parent: 'cpuid', set: 'devices'
Jun  6 10:00:53 istl-vmc-blade9 kernel: [  639.362486] kobject: 'cpu2' (ffff8801ed36e810): kobject_uevent_env
Jun  6 10:00:53 istl-vmc-blade9 kernel: [  639.631032] kobject: 'cpu2' (ffff8801ed36e810): fill_kobj_path: path = '/devices/virtual/cpuid/cpu2'
Jun  6 10:00:54 istl-vmc-blade9 kernel: [  641.023700] lockdep: fixing up alternatives.
Jun  6 10:00:55 istl-vmc-blade9 kernel: [  641.669629] Booting Node 0 Processor 2 APIC 0x12
Jun  6 10:00:55 istl-vmc-blade9 kernel: [  641.708415] smpboot cpu 2: start_ip = 97000
Jun  6 10:00:56 istl-vmc-blade9 kernel: [  641.754622] Calibrating delay loop (skipped) already calibrated this CPU
Jun  6 10:00:56 istl-vmc-blade9 kernel: [  642.428801] Switched to NOHz mode on CPU #2
Jun  6 10:00:56 istl-vmc-blade9 kernel: [  642.592531] PM: Marking nosave pages: 000000000009c000 - 0000000000100000
Jun  6 10:00:56 istl-vmc-blade9 kernel: [  642.649429] PM: Marking nosave pages: 000000007cdcd000 - 000000007ce91000
Jun  6 10:00:56 istl-vmc-blade9 kernel: [  642.706389] PM: Marking nosave pages: 000000007d584000 - 000000007d634000
Jun  6 10:00:56 istl-vmc-blade9 kernel: [  642.763276] PM: Marking nosave pages: 000000007f68f000 - 000000007f7ff000
Jun  6 10:00:56 istl-vmc-blade9 kernel: [  642.773479] NMI watchdog enabled, takes one hw-pmu counter.
Jun  6 10:00:56 istl-vmc-blade9 kernel: [  642.866914] PM: Marking nosave pages: 000000007f800000 - 0000000100000000
Jun  6 10:00:58 istl-vmc-blade9 kernel: [  642.902654] kobject: 'cache' (ffff880144a32dc0): kobject_add_internal: parent: 'cpu2', set: '<NULL>'
Jun  6 10:00:58 istl-vmc-blade9 kernel: [  642.902663] kobject: 'index0' (ffff8801f4485000): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:00:58 istl-vmc-blade9 kernel: [  642.902674] kobject: 'index0' (ffff8801f4485000): kobject_uevent_env
Jun  6 10:00:58 istl-vmc-blade9 kernel: [  642.902678] kobject: 'index0' (ffff8801f4485000): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache/index0'
Jun  6 10:00:58 istl-vmc-blade9 kernel: [  642.903366] kobject: 'index1' (ffff8801f4485048): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:00:58 istl-vmc-blade9 kernel: [  642.903377] kobject: 'index1' (ffff8801f4485048): kobject_uevent_env
Jun  6 10:00:58 istl-vmc-blade9 kernel: [  642.903380] kobject: 'index1' (ffff8801f4485048): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache/index1'
Jun  6 10:00:58 istl-vmc-blade9 kernel: [  642.903770] kobject: 'index2' (ffff8801f4485090): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:00:58 istl-vmc-blade9 kernel: [  642.903781] kobject: 'index2' (ffff8801f4485090): kobject_uevent_env
Jun  6 10:00:58 istl-vmc-blade9 kernel: [  642.903784] kobject: 'index2' (ffff8801f4485090): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache/index2'
Jun  6 10:00:58 istl-vmc-blade9 kernel: [  642.904194] kobject: 'index3' (ffff8801f44850d8): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:00:58 istl-vmc-blade9 kernel: [  642.904207] kobject: 'index3' (ffff8801f44850d8): kobject_uevent_env
Jun  6 10:00:58 istl-vmc-blade9 kernel: [  642.904210] kobject: 'index3' (ffff8801f44850d8): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache/index3'
Jun  6 10:00:58 istl-vmc-blade9 kernel: [  642.904218] kobject: 'cache' (ffff880144a32dc0): kobject_uevent_env
Jun  6 10:00:58 istl-vmc-blade9 kernel: [  642.904602] kobject: 'cache' (ffff880144a32dc0): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache'
Jun  6 10:00:58 istl-vmc-blade9 kernel: [  642.904975] kobject: 'machinecheck2' (ffff8801f8a0cff0): kobject_add_internal: parent: 'machinecheck', set: 'machinecheck'
Jun  6 10:00:58 istl-vmc-blade9 kernel: [  642.904980] kobject: 'machinecheck2' (ffff8801f8a0cff0): kobject_uevent_env
Jun  6 10:00:58 istl-vmc-blade9 kernel: [  642.904983] kobject: 'machinecheck2' (ffff8801f8a0cff0): fill_kobj_path: path = '/devices/system/machinecheck/machinecheck2'
Jun  6 10:00:58 istl-vmc-blade9 kernel: [  644.243485] microcode: CPU2 sig=0x206c2, pf=0x1, revision=0x13
Jun  6 10:00:58 istl-vmc-blade9 kernel: [  644.245079] PM: Basic memory bitmaps created
Jun  6 10:00:58 istl-vmc-blade9 kernel: [  644.245081] PM: Syncing filesystems ... 
Jun  6 10:00:58 istl-vmc-blade9 kernel: [  644.359524] ------------[ cut here ]------------
Jun  6 10:00:58 istl-vmc-blade9 kernel: [  644.399836] WARNING: at drivers/base/firmware_class.c:524 _request_firmware+0x279/0x2c0()
Jun  6 10:00:58 istl-vmc-blade9 kernel: [  644.468416] Hardware name: BladeCenter HS22V -[7871G2A]-
Jun  6 10:00:58 istl-vmc-blade9 kernel: [  644.512933] Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log microcode serio_raw pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core shpchp ioatdma dca i7core_edac edac_core bnx2 sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif usb_storage qla2xxx scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: scsi_wait_scan]
Jun  6 10:00:58 istl-vmc-blade9 kernel: [  644.947361] Pid: 4836, comm: invert_cpu_stat Tainted: G        W   3.1.0-rc2 #1
Jun  6 10:00:58 istl-vmc-blade9 kernel: [  645.008672] Call Trace:
Jun  6 10:00:59 istl-vmc-blade9 kernel: [  645.029212]  [<ffffffff8106af6f>] warn_slowpath_common+0x7f/0xc0
Jun  6 10:00:59 istl-vmc-blade9 kernel: [  645.079562]  [<ffffffff8106afca>] warn_slowpath_null+0x1a/0x20
Jun  6 10:00:59 istl-vmc-blade9 kernel: [  645.128452]  [<ffffffff813645a9>] _request_firmware+0x279/0x2c0
Jun  6 10:00:59 istl-vmc-blade9 kernel: [  645.178078]  [<ffffffff81364686>] request_firmware+0x16/0x20
Jun  6 10:00:59 istl-vmc-blade9 kernel: [  645.225516]  [<ffffffffa01f3da0>] request_microcode_fw+0x70/0xf0 [microcode]
Jun  6 10:00:59 istl-vmc-blade9 kernel: [  645.284592]  [<ffffffffa01f3390>] microcode_init_cpu+0xc0/0x100 [microcode]
Jun  6 10:00:59 istl-vmc-blade9 kernel: [  645.342934]  [<ffffffffa01f44b4>] mc_cpu_callback+0x7c/0x11f [microcode]
Jun  6 10:00:59 istl-vmc-blade9 kernel: [  645.399093]  [<ffffffff815393a4>] notifier_call_chain+0x94/0xd0
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  645.432192] done.
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  645.432195] Freezing user space processes ...  [<ffffffff8109770e>] __raw_notifier_call_chain+0xe/0x10
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  645.542969]  [<ffffffff8106d000>] __cpu_notify+0x20/0x40
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  645.587482]  [<ffffffff8152cf5b>] _cpu_up+0xc7/0x10e
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  645.629089]  [<ffffffff8152d07b>] cpu_up+0xd9/0xec
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  645.669244]  [<ffffffff8151e599>] store_online+0x99/0xd0
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  645.713757]  [<ffffffff81355eb0>] sysdev_store+0x20/0x30
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  645.758267]  [<ffffffff811f3096>] sysfs_write_file+0xe6/0x170
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  645.806411]  [<ffffffff8117ee50>] vfs_write+0xd0/0x1a0
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  645.849469]  [<ffffffff8117f024>] sys_write+0x54/0xa0
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  645.891797]  [<ffffffff8153df02>] system_call_fastpath+0x16/0x1b
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  645.942125] ---[ end trace 79417b0d74e88b07 ]---
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  645.980817] platform microcode: firmware: intel-ucode/06-2c-02 will not be loaded
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  646.043816] kobject: 'cpufreq' (ffff8801f21876a8): kobject_add_internal: parent: 'cpu2', set: '<NULL>'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  646.121919] kobject: 'cpufreq' (ffff8801f21876a8): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  646.175978] kobject: 'cpufreq' (ffff8801f21876a8): fill_kobj_path: path = '/devices/system/cpu/cpu2/cpufreq'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  646.258946] kobject: 'cpu2' (ffff8801f8a0c338): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  646.310785] kobject: 'cpu2' (ffff8801f8a0c338): fill_kobj_path: path = '/devices/system/cpu/cpu2'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  646.387884] (elapsed 0.95 seconds) done.
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  646.420967] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  646.493966] PM: Preallocating image memory... done (allocated 812844 pages)
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.146754] PM: Allocated 3251376 kbytes in 0.59 seconds (5510.80 MB/s)
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.202501] sd 0:0:1:0: [sdb] Synchronizing SCSI cache
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.246803] sd 0:0:0:0: [sda] Synchronizing SCSI cache
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.303474] serial 00:08: disabled
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.303784] serial 00:07: disabled
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.304549] ACPI handle has no context!
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.304839] mptbase: ioc0: pci-suspend: pdev=0xffff8801f4626000, slot=0000:0b:00.0, Entering operating state [D3]
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.330657] ACPI handle has no context!
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.443212] mptsas 0000:0b:00.0: PCI INT A disabled
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.454368] PM: freeze of devices complete after 252.541 msecs
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.457177] PM: late freeze of devices complete after 2.449 msecs
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.457537] Disabling non-boot CPUs ...
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.458425] kobject: 'cpufreq' (ffff8801f22470a8): kobject_cleanup
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.458794] kobject: 'cpufreq' (ffff8801f22470a8): auto cleanup 'remove' event
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.459276] kobject: 'cpufreq' (ffff8801f22470a8): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.459648] kobject: 'cpufreq' (ffff8801f22470a8): fill_kobj_path: path = '/devices/system/cpu/cpu1/cpufreq'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.460220] kobject: 'cpufreq' (ffff8801f22470a8): auto cleanup kobject_del
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.460615] kobject: 'cpufreq' (ffff8801f22470a8): calling ktype release
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.460992] kobject: 'cpufreq': free name
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.462711] CPU 1 is now offline
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.463665] kobject: 'index0' (ffff8801f3a1b800): kobject_cleanup
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.464054] kobject: 'index0' (ffff8801f3a1b800): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.464672] kobject: 'index0' (ffff8801f3a1b800): auto cleanup 'remove' event
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.465084] kobject: 'index0' (ffff8801f3a1b800): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.465476] kobject: 'index0' (ffff8801f3a1b800): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index0'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.466087] kobject: 'index0' (ffff8801f3a1b800): auto cleanup kobject_del
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.466497] kobject: 'index0': free name
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.466784] kobject: 'index1' (ffff8801f3a1b848): kobject_cleanup
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.467166] kobject: 'index1' (ffff8801f3a1b848): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.467780] kobject: 'index1' (ffff8801f3a1b848): auto cleanup 'remove' event
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.468194] kobject: 'index1' (ffff8801f3a1b848): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.468586] kobject: 'index1' (ffff8801f3a1b848): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index1'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.469178] kobject: 'index1' (ffff8801f3a1b848): auto cleanup kobject_del
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.469569] kobject: 'index1': free name
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.469847] kobject: 'index2' (ffff8801f3a1b890): kobject_cleanup
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.470209] kobject: 'index2' (ffff8801f3a1b890): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.470802] kobject: 'index2' (ffff8801f3a1b890): auto cleanup 'remove' event
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.471205] kobject: 'index2' (ffff8801f3a1b890): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.471574] kobject: 'index2' (ffff8801f3a1b890): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index2'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.472158] kobject: 'index2' (ffff8801f3a1b890): auto cleanup kobject_del
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.472552] kobject: 'index2': free name
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.472831] kobject: 'index3' (ffff8801f3a1b8d8): kobject_cleanup
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.473196] kobject: 'index3' (ffff8801f3a1b8d8): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.473790] kobject: 'index3' (ffff8801f3a1b8d8): auto cleanup 'remove' event
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.474233] kobject: 'index3' (ffff8801f3a1b8d8): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.474602] kobject: 'index3' (ffff8801f3a1b8d8): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index3'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.475181] kobject: 'index3' (ffff8801f3a1b8d8): auto cleanup kobject_del
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.475573] kobject: 'index3': free name
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.475853] kobject: 'cache' (ffff8801b9397440): kobject_cleanup
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.476213] kobject: 'cache' (ffff8801b9397440): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.476806] kobject: 'cache' (ffff8801b9397440): auto cleanup 'remove' event
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.477206] kobject: 'cache' (ffff8801b9397440): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.477576] kobject: 'cache' (ffff8801b9397440): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.478211] kobject: 'cache' (ffff8801b9397440): auto cleanup kobject_del
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.478596] kobject: 'cache': free name
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.478887] kobject: 'machinecheck1' (ffff8801f880cff0): kobject_cleanup
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.479272] kobject: 'machinecheck1' (ffff8801f880cff0): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.479886] kobject: 'machinecheck1' (ffff8801f880cff0): auto cleanup 'remove' event
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.480390] kobject: 'machinecheck1' (ffff8801f880cff0): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.480780] kobject: 'machinecheck1' (ffff8801f880cff0): fill_kobj_path: path = '/devices/system/machinecheck/machinecheck1'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.481408] kobject: 'machinecheck1' (ffff8801f880cff0): auto cleanup kobject_del
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.481889] kobject: 'machinecheck1': free name
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.482709] kobject: 'cpufreq' (ffff8801f21876a8): kobject_cleanup
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.483085] kobject: 'cpufreq' (ffff8801f21876a8): auto cleanup 'remove' event
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.483556] kobject: 'cpufreq' (ffff8801f21876a8): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.483928] kobject: 'cpufreq' (ffff8801f21876a8): fill_kobj_path: path = '/devices/system/cpu/cpu2/cpufreq'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.484505] kobject: 'cpufreq' (ffff8801f21876a8): auto cleanup kobject_del
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.484904] kobject: 'cpufreq' (ffff8801f21876a8): calling ktype release
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.485293] kobject: 'cpufreq': free name
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.486964] CPU 2 is now offline
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.487240] lockdep: fixing up alternatives.
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.487910] kobject: 'index0' (ffff8801f4485000): kobject_cleanup
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.489860] kobject: 'index0' (ffff8801f4485000): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.490506] kobject: 'index0' (ffff8801f4485000): auto cleanup 'remove' event
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.490907] kobject: 'index0' (ffff8801f4485000): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.491285] kobject: 'index0' (ffff8801f4485000): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache/index0'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.491871] kobject: 'index0' (ffff8801f4485000): auto cleanup kobject_del
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.492271] kobject: 'index0': free name
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.492550] kobject: 'index1' (ffff8801f4485048): kobject_cleanup
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.492908] kobject: 'index1' (ffff8801f4485048): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.493509] kobject: 'index1' (ffff8801f4485048): auto cleanup 'remove' event
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.493905] kobject: 'index1' (ffff8801f4485048): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.494367] kobject: 'index1' (ffff8801f4485048): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache/index1'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.494949] kobject: 'index1' (ffff8801f4485048): auto cleanup kobject_del
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.495345] kobject: 'index1': free name
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.495623] kobject: 'index2' (ffff8801f4485090): kobject_cleanup
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.495980] kobject: 'index2' (ffff8801f4485090): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.496581] kobject: 'index2' (ffff8801f4485090): auto cleanup 'remove' event
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.496977] kobject: 'index2' (ffff8801f4485090): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.497359] kobject: 'index2' (ffff8801f4485090): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache/index2'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.497947] kobject: 'index2' (ffff8801f4485090): auto cleanup kobject_del
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.498423] kobject: 'index2': free name
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.498701] kobject: 'index3' (ffff8801f44850d8): kobject_cleanup
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.499063] kobject: 'index3' (ffff8801f44850d8): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.499657] kobject: 'index3' (ffff8801f44850d8): auto cleanup 'remove' event
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.500056] kobject: 'index3' (ffff8801f44850d8): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.500424] kobject: 'index3' (ffff8801f44850d8): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache/index3'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.501010] kobject: 'index3' (ffff8801f44850d8): auto cleanup kobject_del
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.501402] kobject: 'index3': free name
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.501681] kobject: 'cache' (ffff880144a32dc0): kobject_cleanup
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.502116] kobject: 'cache' (ffff880144a32dc0): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.502710] kobject: 'cache' (ffff880144a32dc0): auto cleanup 'remove' event
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.503103] kobject: 'cache' (ffff880144a32dc0): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.503465] kobject: 'cache' (ffff880144a32dc0): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.504019] kobject: 'cache' (ffff880144a32dc0): auto cleanup kobject_del
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.504403] kobject: 'cache': free name
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.504694] kobject: 'machinecheck2' (ffff8801f8a0cff0): kobject_cleanup
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.505082] kobject: 'machinecheck2' (ffff8801f8a0cff0): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.505703] kobject: 'machinecheck2' (ffff8801f8a0cff0): auto cleanup 'remove' event
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.506239] kobject: 'machinecheck2' (ffff8801f8a0cff0): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.506631] kobject: 'machinecheck2' (ffff8801f8a0cff0): fill_kobj_path: path = '/devices/system/machinecheck/machinecheck2'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.507299] kobject: 'machinecheck2' (ffff8801f8a0cff0): auto cleanup kobject_del
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.507785] kobject: 'machinecheck2': free name
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.508275] Extended CMOS year: 2000
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  647.508660] hibernation debug: Waiting for 5 seconds.
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.500850] Extended CMOS year: 2000
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.501136] Enabling non-boot CPUs ...
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.501768] lockdep: fixing up alternatives.
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.502062] Booting Node 0 Processor 1 APIC 0x2
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.502366] smpboot cpu 1: start_ip = 97000
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.513804] Calibrating delay loop (skipped) already calibrated this CPU
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.534461] NMI watchdog enabled, takes one hw-pmu counter.
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.534533] Switched to NOHz mode on CPU #1
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.535419] kobject: 'cache' (ffff8801f4627140): kobject_add_internal: parent: 'cpu1', set: '<NULL>'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.536070] kobject: 'index0' (ffff8801f4565800): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.536654] kobject: 'index0' (ffff8801f4565800): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.537038] kobject: 'index0' (ffff8801f4565800): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index0'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.537668] kobject: 'index1' (ffff8801f4565848): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.538245] kobject: 'index1' (ffff8801f4565848): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.538634] kobject: 'index1' (ffff8801f4565848): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index1'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.539244] kobject: 'index2' (ffff8801f4565890): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.539823] kobject: 'index2' (ffff8801f4565890): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.540203] kobject: 'index2' (ffff8801f4565890): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index2'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.540813] kobject: 'index3' (ffff8801f45658d8): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.541390] kobject: 'index3' (ffff8801f45658d8): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.541832] kobject: 'index3' (ffff8801f45658d8): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index3'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.542436] kobject: 'cache' (ffff8801f4627140): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.542824] kobject: 'cache' (ffff8801f4627140): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.543403] kobject: 'machinecheck1' (ffff8801f880cff0): kobject_add_internal: parent: 'machinecheck', set: 'machinecheck'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.544039] kobject: 'machinecheck1' (ffff8801f880cff0): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.544444] kobject: 'machinecheck1' (ffff8801f880cff0): fill_kobj_path: path = '/devices/system/machinecheck/machinecheck1'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.545309] kobject: 'cpufreq' (ffff8801f22ba4a8): kobject_add_internal: parent: 'cpu1', set: '<NULL>'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.545979] kobject: 'cpufreq' (ffff8801f22ba4a8): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.546362] kobject: 'cpufreq' (ffff8801f22ba4a8): fill_kobj_path: path = '/devices/system/cpu/cpu1/cpufreq'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.546953] CPU1 is up
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.547904] lockdep: fixing up alternatives.
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.548211] Booting Node 0 Processor 2 APIC 0x12
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.548589] smpboot cpu 2: start_ip = 97000
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.560005] Calibrating delay loop (skipped) already calibrated this CPU
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.580817] NMI watchdog enabled, takes one hw-pmu counter.
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.581477] Switched to NOHz mode on CPU #2
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.581839] kobject: 'cache' (ffff8801f2e0d340): kobject_add_internal: parent: 'cpu2', set: '<NULL>'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.582399] kobject: 'index0' (ffff8801eaa29000): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.582970] kobject: 'index0' (ffff8801eaa29000): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.583341] kobject: 'index0' (ffff8801eaa29000): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache/index0'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.583937] kobject: 'index1' (ffff8801eaa29048): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.584499] kobject: 'index1' (ffff8801eaa29048): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.584869] kobject: 'index1' (ffff8801eaa29048): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache/index1'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.585500] kobject: 'index2' (ffff8801eaa29090): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.586062] kobject: 'index2' (ffff8801eaa29090): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.586439] kobject: 'index2' (ffff8801eaa29090): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache/index2'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.587027] kobject: 'index3' (ffff8801eaa290d8): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.587600] kobject: 'index3' (ffff8801eaa290d8): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.587972] kobject: 'index3' (ffff8801eaa290d8): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache/index3'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.588558] kobject: 'cache' (ffff8801f2e0d340): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.588921] kobject: 'cache' (ffff8801f2e0d340): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.589571] kobject: 'machinecheck2' (ffff8801f8a0cff0): kobject_add_internal: parent: 'machinecheck', set: 'machinecheck'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.590181] kobject: 'machinecheck2' (ffff8801f8a0cff0): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.590580] kobject: 'machinecheck2' (ffff8801f8a0cff0): fill_kobj_path: path = '/devices/system/machinecheck/machinecheck2'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.591388] kobject: 'cpufreq' (ffff8801f1e0baa8): kobject_add_internal: parent: 'cpu2', set: '<NULL>'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.591968] kobject: 'cpufreq' (ffff8801f1e0baa8): kobject_uevent_env
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.592344] kobject: 'cpufreq' (ffff8801f1e0baa8): fill_kobj_path: path = '/devices/system/cpu/cpu2/cpufreq'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.592920] CPU2 is up
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.607501] mptsas 0000:0b:00.0: BAR 0: set to [io  0x2000-0x20ff] (PCI address [0x2000-0x20ff])
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.608061] mptsas 0000:0b:00.0: BAR 1: set to [mem 0x97a10000-0x97a13fff 64bit] (PCI address [0x97a10000-0x97a13fff])
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.608749] mptsas 0000:0b:00.0: BAR 3: set to [mem 0x97a00000-0x97a0ffff 64bit] (PCI address [0x97a00000-0x97a0ffff])
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.609409] mptsas 0000:0b:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100047)
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.621853] PM: early restore of devices complete after 26.413 msecs
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.939062] ioatdma 0000:00:16.0: setting latency timer to 64
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.939067] ioatdma 0000:00:16.1: setting latency timer to 64
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.939083] ioatdma 0000:00:16.2: setting latency timer to 64
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.939097] ioatdma 0000:00:16.3: setting latency timer to 64
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.939110] ioatdma 0000:00:16.4: setting latency timer to 64
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.939123] ioatdma 0000:00:16.5: setting latency timer to 64
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.939136] ioatdma 0000:00:16.6: setting latency timer to 64
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.939148] ioatdma 0000:00:16.7: setting latency timer to 64
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.939161] uhci_hcd 0000:00:1a.0: setting latency timer to 64
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.939192] usb usb3: root hub lost power or was reset
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.939214] ehci_hcd 0000:00:1a.7: setting latency timer to 64
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.939333] usb usb1: root hub lost power or was reset
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.939460] uhci_hcd 0000:00:1d.0: setting latency timer to 64
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.939497] usb usb4: root hub lost power or was reset
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.939512] uhci_hcd 0000:00:1d.1: setting latency timer to 64
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.939564] usb usb5: root hub lost power or was reset
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.939587] uhci_hcd 0000:00:1d.2: setting latency timer to 64
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.939621] usb usb6: root hub lost power or was reset
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.939642] ehci_hcd 0000:00:1d.7: setting latency timer to 64
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.939724] usb usb2: root hub lost power or was reset
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.943220] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.943234] pci 0000:00:1e.0: setting latency timer to 64
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.943246] mptbase: ioc0: pci-resume: pdev=0xffff8801f4626000, slot=0000:0b:00.0, Previous operating state [D0]
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.943258] mptsas 0000:0b:00.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.943317] mptbase: ioc0: pci-resume: ioc-state=0x1,doorbell=0x10000000
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.943615] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.943628] qla2xxx 0000:24:00.0: setting latency timer to 64
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.943638] qla2xxx 0000:24:00.1: setting latency timer to 64
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.943649] pci 0000:06:00.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.943654] pci 0000:06:00.0: setting latency timer to 64
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.944051] serial 00:07: activated
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.944297] serial 00:08: activated
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  652.956556] Extended CMOS year: 2000
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  653.016005] bnx2 0000:10:00.1: eth1: NIC SerDes Link is Down
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  653.041419] bnx2 0000:10:00.1: eth1: NIC SerDes Link is Up, 1000 Mbps full duplex
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  653.355398] kobject: '(null)' (ffff8801f34ba358): kobject_cleanup
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  653.355402] kobject: '(null)' (ffff8801f34ba358): calling ktype release
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  653.610949] usb 2-3: reset high speed USB device number 2 using ehci_hcd
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  654.100316] usb 2-3.2: reset high speed USB device number 4 using ehci_hcd
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  654.437809] usb 2-3.2.2: reset high speed USB device number 5 using ehci_hcd
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  654.672348] usb 5-2: reset full speed USB device number 2 using uhci_hcd
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  654.914061] usb 2-3.2.2.3: reset high speed USB device number 6 using ehci_hcd
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  658.042195] mptbase: ioc0: Sending mpt_do_ioc_recovery
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  658.085270] mptbase: ioc0: Initiating bringup
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  658.260773] ioc0: LSISAS1064E: Capabilities={Initiator}
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  658.305149] mptsas 0000:0b:00.0: setting latency timer to 64
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  667.585878] mptbase: ioc0: pci-resume: success
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  667.623684] PM: restore of devices complete after 14707.384 msecs
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  667.675180] PM: Image restored successfully.
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  667.711077] Restarting tasks ... 
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  667.788181] kobject: 'msr3' (ffff8801b9a1d010): kobject_add_internal: parent: 'msr', set: 'devices'
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  667.820206] done.
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  667.820272] PM: Basic memory bitmaps freed
Jun  6 10:01:21 istl-vmc-blade9 kernel: [  667.922969] kobject: 'msr3' (ffff8801b9a1d010): kobject_uevent_env
Jun  6 10:01:22 istl-vmc-blade9 kernel: [  668.458217] kobject: 'msr3' (ffff8801b9a1d010): fill_kobj_path: path = '/devices/virtual/msr/msr3'
Jun  6 10:01:23 istl-vmc-blade9 kernel: [  669.406478] kobject: 'cpu3' (ffff8801f2712810): kobject_add_internal: parent: 'cpuid', set: 'devices'
Jun  6 10:01:23 istl-vmc-blade9 kernel: [  669.597406] kobject: 'cpu3' (ffff8801f2712810): kobject_uevent_env
Jun  6 10:01:23 istl-vmc-blade9 kernel: [  670.232436] kobject: 'cpu3' (ffff8801f2712810): fill_kobj_path: path = '/devices/virtual/cpuid/cpu3'
Jun  6 10:01:24 istl-vmc-blade9 kernel: [  671.111359] lockdep: fixing up alternatives.
Jun  6 10:01:24 istl-vmc-blade9 kernel: [  671.148224] Booting Node 0 Processor 3 APIC 0x14
Jun  6 10:01:24 istl-vmc-blade9 kernel: [  671.186948] smpboot cpu 3: start_ip = 97000
Jun  6 10:01:25 istl-vmc-blade9 kernel: [  671.233125] Calibrating delay loop (skipped) already calibrated this CPU
Jun  6 10:01:25 istl-vmc-blade9 kernel: [  671.615357] Switched to NOHz mode on CPU #3
Jun  6 10:01:25 istl-vmc-blade9 kernel: [  671.810290] NMI watchdog enabled, takes one hw-pmu counter.
Jun  6 10:01:25 istl-vmc-blade9 kernel: [  672.232387] kobject: 'cache' (ffff8801b9bd08c0): kobject_add_internal: parent: 'cpu3', set: '<NULL>'
Jun  6 10:01:26 istl-vmc-blade9 kernel: [  672.688688] kobject: 'index0' (ffff8801f3a1bc00): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:01:26 istl-vmc-blade9 kernel: [  673.341709] kobject: 'index0' (ffff8801f3a1bc00): kobject_uevent_env
Jun  6 10:01:27 istl-vmc-blade9 kernel: [  673.844929] kobject: 'index0' (ffff8801f3a1bc00): fill_kobj_path: path = '/devices/system/cpu/cpu3/cache/index0'
Jun  6 10:01:27 istl-vmc-blade9 kernel: [  674.040254] kobject: 'index1' (ffff8801f3a1bc48): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:01:28 istl-vmc-blade9 kernel: [  674.565824] kobject: 'index1' (ffff8801f3a1bc48): kobject_uevent_env
Jun  6 10:01:28 istl-vmc-blade9 kernel: [  675.005141] kobject: 'index1' (ffff8801f3a1bc48): fill_kobj_path: path = '/devices/system/cpu/cpu3/cache/index1'
Jun  6 10:01:29 istl-vmc-blade9 kernel: [  675.744629] kobject: 'index2' (ffff8801f3a1bc90): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:01:30 istl-vmc-blade9 kernel: [  676.470896] kobject: 'index2' (ffff8801f3a1bc90): kobject_uevent_env
Jun  6 10:01:30 istl-vmc-blade9 kernel: [  676.981874] kobject: 'index2' (ffff8801f3a1bc90): fill_kobj_path: path = '/devices/system/cpu/cpu3/cache/index2'
Jun  6 10:01:31 istl-vmc-blade9 kernel: [  677.767145] kobject: 'index3' (ffff8801f3a1bcd8): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:01:32 istl-vmc-blade9 kernel: [  678.429911] kobject: 'index3' (ffff8801f3a1bcd8): kobject_uevent_env
Jun  6 10:01:32 istl-vmc-blade9 kernel: [  678.899179] kobject: 'index3' (ffff8801f3a1bcd8): fill_kobj_path: path = '/devices/system/cpu/cpu3/cache/index3'
Jun  6 10:01:32 istl-vmc-blade9 kernel: [  679.063794] kobject: 'cache' (ffff8801b9bd08c0): kobject_uevent_env
Jun  6 10:01:32 istl-vmc-blade9 kernel: [  679.116528] kobject: 'cache' (ffff8801b9bd08c0): fill_kobj_path: path = '/devices/system/cpu/cpu3/cache'
Jun  6 10:01:33 istl-vmc-blade9 kernel: [  679.748567] kobject: 'machinecheck3' (ffff8801f8c0cff0): kobject_add_internal: parent: 'machinecheck', set: 'machinecheck'
Jun  6 10:01:34 istl-vmc-blade9 kernel: [  680.556649] kobject: 'machinecheck3' (ffff8801f8c0cff0): kobject_uevent_env
Jun  6 10:01:34 istl-vmc-blade9 kernel: [  680.690867] PM: Marking nosave pages: 000000000009c000 - 0000000000100000
Jun  6 10:01:34 istl-vmc-blade9 kernel: [  680.747794] PM: Marking nosave pages: 000000007cdcd000 - 000000007ce91000
Jun  6 10:01:34 istl-vmc-blade9 kernel: [  680.766326] kobject: 'machinecheck3' (ffff8801f8c0cff0): fill_kobj_path: path = '/devices/system/machinecheck/machinecheck3'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  680.898702] microcode: CPU3 sig=0x206c2, pf=0x1, revision=0x13
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  680.898730] PM: Marking nosave pages: 000000007d584000 - 000000007d634000
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  680.898734] PM: Marking nosave pages: 000000007f68f000 - 000000007f7ff000
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  680.898740] PM: Marking nosave pages: 000000007f800000 - 0000000100000000
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  680.900079] PM: Basic memory bitmaps created
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  680.900080] PM: Syncing filesystems ... 
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  681.185344] ------------[ cut here ]------------
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  681.200589] done.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  681.200592] Freezing user space processes ... 
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  681.277530] WARNING: at drivers/base/firmware_class.c:524 _request_firmware+0x279/0x2c0()
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  681.347719] Hardware name: BladeCenter HS22V -[7871G2A]-
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  681.392235] Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log microcode serio_raw pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core shpchp ioatdma dca i7core_edac edac_core bnx2 sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif usb_storage qla2xxx scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: scsi_wait_scan]
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  681.826320] Pid: 4836, comm: invert_cpu_stat Tainted: G        W   3.1.0-rc2 #1
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  681.887625] Call Trace:
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  681.908148]  [<ffffffff8106af6f>] warn_slowpath_common+0x7f/0xc0
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  681.958466]  [<ffffffff8106afca>] warn_slowpath_null+0x1a/0x20
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  682.007338]  [<ffffffff813645a9>] _request_firmware+0x279/0x2c0
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  682.056935]  [<ffffffff81364686>] request_firmware+0x16/0x20
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  682.104362]  [<ffffffffa01f3da0>] request_microcode_fw+0x70/0xf0 [microcode]
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  682.163420]  [<ffffffffa01f3390>] microcode_init_cpu+0xc0/0x100 [microcode]
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  682.221746]  [<ffffffffa01f44b4>] mc_cpu_callback+0x7c/0x11f [microcode]
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  682.277886]  [<ffffffff815393a4>] notifier_call_chain+0x94/0xd0
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  682.327480]  [<ffffffff8109770e>] __raw_notifier_call_chain+0xe/0x10
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  682.380720]  [<ffffffff8106d000>] __cpu_notify+0x20/0x40
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  682.425231]  [<ffffffff8152cf5b>] _cpu_up+0xc7/0x10e
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  682.466837]  [<ffffffff8152d07b>] cpu_up+0xd9/0xec
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  682.506982]  [<ffffffff8151e599>] store_online+0x99/0xd0
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  682.551492]  [<ffffffff81355eb0>] sysdev_store+0x20/0x30
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  682.596002]  [<ffffffff811f3096>] sysfs_write_file+0xe6/0x170
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  682.644145]  [<ffffffff8117ee50>] vfs_write+0xd0/0x1a0
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  682.687207]  [<ffffffff8117f024>] sys_write+0x54/0xa0
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  682.729541]  [<ffffffff8153df02>] system_call_fastpath+0x16/0x1b
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  682.779864] ---[ end trace 79417b0d74e88b08 ]---
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  682.818561] platform microcode: firmware: intel-ucode/06-2c-02 will not be loaded
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  682.881612] kobject: 'cpufreq' (ffff8801f25c0aa8): kobject_add_internal: parent: 'cpu3', set: '<NULL>'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  682.960095] kobject: 'cpufreq' (ffff8801f25c0aa8): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  683.014390] kobject: 'cpufreq' (ffff8801f25c0aa8): fill_kobj_path: path = '/devices/system/cpu/cpu3/cpufreq'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  683.096811] kobject: 'cpu3' (ffff8801f8c0c338): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  683.148630] kobject: 'cpu3' (ffff8801f8c0c338): fill_kobj_path: path = '/devices/system/cpu/cpu3'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  683.224745] (elapsed 2.02 seconds) done.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  683.257776] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  683.331659] PM: Preallocating image memory... done (allocated 816164 pages)
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.010374] PM: Allocated 3264656 kbytes in 0.62 seconds (5265.57 MB/s)
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.066075] sd 0:0:1:0: [sdb] Synchronizing SCSI cache
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.110399] sd 0:0:0:0: [sda] Synchronizing SCSI cache
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.167287] serial 00:08: disabled
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.167598] serial 00:07: disabled
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.168270] ACPI handle has no context!
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.168565] mptbase: ioc0: pci-suspend: pdev=0xffff8801f4626000, slot=0000:0b:00.0, Entering operating state [D3]
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.193450] ACPI handle has no context!
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.307028] mptsas 0000:0b:00.0: PCI INT A disabled
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.318209] PM: freeze of devices complete after 252.803 msecs
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.321018] PM: late freeze of devices complete after 2.447 msecs
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.321386] Disabling non-boot CPUs ...
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.322235] kobject: 'cpufreq' (ffff8801f22ba4a8): kobject_cleanup
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.322606] kobject: 'cpufreq' (ffff8801f22ba4a8): auto cleanup 'remove' event
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.323090] kobject: 'cpufreq' (ffff8801f22ba4a8): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.323465] kobject: 'cpufreq' (ffff8801f22ba4a8): fill_kobj_path: path = '/devices/system/cpu/cpu1/cpufreq'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.324052] kobject: 'cpufreq' (ffff8801f22ba4a8): auto cleanup kobject_del
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.324452] kobject: 'cpufreq' (ffff8801f22ba4a8): calling ktype release
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.324835] kobject: 'cpufreq': free name
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.326623] CPU 1 is now offline
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.327530] kobject: 'index0' (ffff8801f4565800): kobject_cleanup
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.327922] kobject: 'index0' (ffff8801f4565800): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.328556] kobject: 'index0' (ffff8801f4565800): auto cleanup 'remove' event
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.328969] kobject: 'index0' (ffff8801f4565800): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.329358] kobject: 'index0' (ffff8801f4565800): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index0'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.329968] kobject: 'index0' (ffff8801f4565800): auto cleanup kobject_del
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.330376] kobject: 'index0': free name
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.330660] kobject: 'index1' (ffff8801f4565848): kobject_cleanup
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.331035] kobject: 'index1' (ffff8801f4565848): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.331650] kobject: 'index1' (ffff8801f4565848): auto cleanup 'remove' event
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.332066] kobject: 'index1' (ffff8801f4565848): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.332463] kobject: 'index1' (ffff8801f4565848): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index1'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.333073] kobject: 'index1' (ffff8801f4565848): auto cleanup kobject_del
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.333481] kobject: 'index1': free name
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.333770] kobject: 'index2' (ffff8801f4565890): kobject_cleanup
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.334147] kobject: 'index2' (ffff8801f4565890): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.334760] kobject: 'index2' (ffff8801f4565890): auto cleanup 'remove' event
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.335177] kobject: 'index2' (ffff8801f4565890): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.335558] kobject: 'index2' (ffff8801f4565890): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index2'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.336168] kobject: 'index2' (ffff8801f4565890): auto cleanup kobject_del
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.336575] kobject: 'index2': free name
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.336881] kobject: 'index3' (ffff8801f45658d8): kobject_cleanup
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.337250] kobject: 'index3' (ffff8801f45658d8): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.337865] kobject: 'index3' (ffff8801f45658d8): auto cleanup 'remove' event
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.338282] kobject: 'index3' (ffff8801f45658d8): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.338666] kobject: 'index3' (ffff8801f45658d8): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index3'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.339273] kobject: 'index3' (ffff8801f45658d8): auto cleanup kobject_del
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.339681] kobject: 'index3': free name
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.339974] kobject: 'cache' (ffff8801f4627140): kobject_cleanup
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.340345] kobject: 'cache' (ffff8801f4627140): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.340967] kobject: 'cache' (ffff8801f4627140): auto cleanup 'remove' event
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.341373] kobject: 'cache' (ffff8801f4627140): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.341760] kobject: 'cache' (ffff8801f4627140): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.342341] kobject: 'cache' (ffff8801f4627140): auto cleanup kobject_del
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.342727] kobject: 'cache': free name
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.343025] kobject: 'machinecheck1' (ffff8801f880cff0): kobject_cleanup
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.343407] kobject: 'machinecheck1' (ffff8801f880cff0): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.344033] kobject: 'machinecheck1' (ffff8801f880cff0): auto cleanup 'remove' event
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.344522] kobject: 'machinecheck1' (ffff8801f880cff0): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.344916] kobject: 'machinecheck1' (ffff8801f880cff0): fill_kobj_path: path = '/devices/system/machinecheck/machinecheck1'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.345534] kobject: 'machinecheck1' (ffff8801f880cff0): auto cleanup kobject_del
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.346021] kobject: 'machinecheck1': free name
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.346894] kobject: 'cpufreq' (ffff8801f1e0baa8): kobject_cleanup
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.347269] kobject: 'cpufreq' (ffff8801f1e0baa8): auto cleanup 'remove' event
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.347755] kobject: 'cpufreq' (ffff8801f1e0baa8): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.348150] kobject: 'cpufreq' (ffff8801f1e0baa8): fill_kobj_path: path = '/devices/system/cpu/cpu2/cpufreq'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.348743] kobject: 'cpufreq' (ffff8801f1e0baa8): auto cleanup kobject_del
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.349165] kobject: 'cpufreq' (ffff8801f1e0baa8): calling ktype release
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.349560] kobject: 'cpufreq': free name
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.351313] CPU 2 is now offline
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.352166] kobject: 'index0' (ffff8801eaa29000): kobject_cleanup
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.352542] kobject: 'index0' (ffff8801eaa29000): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.353171] kobject: 'index0' (ffff8801eaa29000): auto cleanup 'remove' event
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.353581] kobject: 'index0' (ffff8801eaa29000): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.353975] kobject: 'index0' (ffff8801eaa29000): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache/index0'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.354582] kobject: 'index0' (ffff8801eaa29000): auto cleanup kobject_del
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.354998] kobject: 'index0': free name
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.355286] kobject: 'index1' (ffff8801eaa29048): kobject_cleanup
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.355657] kobject: 'index1' (ffff8801eaa29048): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.356385] kobject: 'index1' (ffff8801eaa29048): auto cleanup 'remove' event
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.356795] kobject: 'index1' (ffff8801eaa29048): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.357183] kobject: 'index1' (ffff8801eaa29048): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache/index1'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.357787] kobject: 'index1' (ffff8801eaa29048): auto cleanup kobject_del
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.358199] kobject: 'index1': free name
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.358486] kobject: 'index2' (ffff8801eaa29090): kobject_cleanup
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.358860] kobject: 'index2' (ffff8801eaa29090): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.359467] kobject: 'index2' (ffff8801eaa29090): auto cleanup 'remove' event
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.359941] kobject: 'index2' (ffff8801eaa29090): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.360324] kobject: 'index2' (ffff8801eaa29090): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache/index2'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.361035] kobject: 'index2' (ffff8801eaa29090): auto cleanup kobject_del
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.361438] kobject: 'index2': free name
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.361719] kobject: 'index3' (ffff8801eaa290d8): kobject_cleanup
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.362084] kobject: 'index3' (ffff8801eaa290d8): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.362684] kobject: 'index3' (ffff8801eaa290d8): auto cleanup 'remove' event
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.364833] kobject: 'index3' (ffff8801eaa290d8): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.365206] kobject: 'index3' (ffff8801eaa290d8): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache/index3'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.365842] kobject: 'index3' (ffff8801eaa290d8): auto cleanup kobject_del
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.366236] kobject: 'index3': free name
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.366518] kobject: 'cache' (ffff8801f2e0d340): kobject_cleanup
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.366916] kobject: 'cache' (ffff8801f2e0d340): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.367512] kobject: 'cache' (ffff8801f2e0d340): auto cleanup 'remove' event
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.367915] kobject: 'cache' (ffff8801f2e0d340): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.368284] kobject: 'cache' (ffff8801f2e0d340): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.368847] kobject: 'cache' (ffff8801f2e0d340): auto cleanup kobject_del
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.369233] kobject: 'cache': free name
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.369529] kobject: 'machinecheck2' (ffff8801f8a0cff0): kobject_cleanup
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.369917] kobject: 'machinecheck2' (ffff8801f8a0cff0): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.370535] kobject: 'machinecheck2' (ffff8801f8a0cff0): auto cleanup 'remove' event
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.371075] kobject: 'machinecheck2' (ffff8801f8a0cff0): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.371476] kobject: 'machinecheck2' (ffff8801f8a0cff0): fill_kobj_path: path = '/devices/system/machinecheck/machinecheck2'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.372141] kobject: 'machinecheck2' (ffff8801f8a0cff0): auto cleanup kobject_del
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.372618] kobject: 'machinecheck2': free name
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.373379] kobject: 'cpufreq' (ffff8801f25c0aa8): kobject_cleanup
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.373747] kobject: 'cpufreq' (ffff8801f25c0aa8): auto cleanup 'remove' event
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.374269] kobject: 'cpufreq' (ffff8801f25c0aa8): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.374643] kobject: 'cpufreq' (ffff8801f25c0aa8): fill_kobj_path: path = '/devices/system/cpu/cpu3/cpufreq'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.375222] kobject: 'cpufreq' (ffff8801f25c0aa8): auto cleanup kobject_del
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.375621] kobject: 'cpufreq' (ffff8801f25c0aa8): calling ktype release
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.376007] kobject: 'cpufreq': free name
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.377624] CPU 3 is now offline
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.377888] lockdep: fixing up alternatives.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.378621] kobject: 'index0' (ffff8801f3a1bc00): kobject_cleanup
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.378999] kobject: 'index0' (ffff8801f3a1bc00): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.379597] kobject: 'index0' (ffff8801f3a1bc00): auto cleanup 'remove' event
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.380001] kobject: 'index0' (ffff8801f3a1bc00): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.380376] kobject: 'index0' (ffff8801f3a1bc00): fill_kobj_path: path = '/devices/system/cpu/cpu3/cache/index0'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.381031] kobject: 'index0' (ffff8801f3a1bc00): auto cleanup kobject_del
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.381429] kobject: 'index0': free name
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.381715] kobject: 'index1' (ffff8801f3a1bc48): kobject_cleanup
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.382080] kobject: 'index1' (ffff8801f3a1bc48): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.382682] kobject: 'index1' (ffff8801f3a1bc48): auto cleanup 'remove' event
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.383084] kobject: 'index1' (ffff8801f3a1bc48): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.383453] kobject: 'index1' (ffff8801f3a1bc48): fill_kobj_path: path = '/devices/system/cpu/cpu3/cache/index1'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.384042] kobject: 'index1' (ffff8801f3a1bc48): auto cleanup kobject_del
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.384435] kobject: 'index1': free name
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.384721] kobject: 'index2' (ffff8801f3a1bc90): kobject_cleanup
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.385172] kobject: 'index2' (ffff8801f3a1bc90): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.385784] kobject: 'index2' (ffff8801f3a1bc90): auto cleanup 'remove' event
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.386182] kobject: 'index2' (ffff8801f3a1bc90): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.386555] kobject: 'index2' (ffff8801f3a1bc90): fill_kobj_path: path = '/devices/system/cpu/cpu3/cache/index2'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.387137] kobject: 'index2' (ffff8801f3a1bc90): auto cleanup kobject_del
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.387527] kobject: 'index2': free name
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.387808] kobject: 'index3' (ffff8801f3a1bcd8): kobject_cleanup
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.388166] kobject: 'index3' (ffff8801f3a1bcd8): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.388812] kobject: 'index3' (ffff8801f3a1bcd8): auto cleanup 'remove' event
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.389213] kobject: 'index3' (ffff8801f3a1bcd8): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.389586] kobject: 'index3' (ffff8801f3a1bcd8): fill_kobj_path: path = '/devices/system/cpu/cpu3/cache/index3'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.390221] kobject: 'index3' (ffff8801f3a1bcd8): auto cleanup kobject_del
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.390616] kobject: 'index3': free name
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.390903] kobject: 'cache' (ffff8801b9bd08c0): kobject_cleanup
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.391260] kobject: 'cache' (ffff8801b9bd08c0): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.391869] kobject: 'cache' (ffff8801b9bd08c0): auto cleanup 'remove' event
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.392265] kobject: 'cache' (ffff8801b9bd08c0): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.392639] kobject: 'cache' (ffff8801b9bd08c0): fill_kobj_path: path = '/devices/system/cpu/cpu3/cache'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.393248] kobject: 'cache' (ffff8801b9bd08c0): auto cleanup kobject_del
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.393634] kobject: 'cache': free name
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.393933] kobject: 'machinecheck3' (ffff8801f8c0cff0): kobject_cleanup
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.394315] kobject: 'machinecheck3' (ffff8801f8c0cff0): does not have a release() function, it is broken and must be fixed.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.394944] kobject: 'machinecheck3' (ffff8801f8c0cff0): auto cleanup 'remove' event
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.395443] kobject: 'machinecheck3' (ffff8801f8c0cff0): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.395839] kobject: 'machinecheck3' (ffff8801f8c0cff0): fill_kobj_path: path = '/devices/system/machinecheck/machinecheck3'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.396462] kobject: 'machinecheck3' (ffff8801f8c0cff0): auto cleanup kobject_del
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.397026] kobject: 'machinecheck3': free name
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.397477] Extended CMOS year: 2000
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  684.397862] hibernation debug: Waiting for 5 seconds.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.389918] Extended CMOS year: 2000
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.390249] Enabling non-boot CPUs ...
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.390830] lockdep: fixing up alternatives.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.391126] Booting Node 0 Processor 1 APIC 0x2
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.391480] smpboot cpu 1: start_ip = 97000
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.402884] Calibrating delay loop (skipped) already calibrated this CPU
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.423621] NMI watchdog enabled, takes one hw-pmu counter.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.424181] Switched to NOHz mode on CPU #1
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.424601] kobject: 'cache' (ffff8801f4417940): kobject_add_internal: parent: 'cpu1', set: '<NULL>'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.425247] kobject: 'index0' (ffff8801f319a800): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.425826] kobject: 'index0' (ffff8801f319a800): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.426218] kobject: 'index0' (ffff8801f319a800): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index0'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.426829] kobject: 'index1' (ffff8801f319a848): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.427430] kobject: 'index1' (ffff8801f319a848): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.427810] kobject: 'index1' (ffff8801f319a848): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index1'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.428422] kobject: 'index2' (ffff8801f319a890): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.429000] kobject: 'index2' (ffff8801f319a890): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.429388] kobject: 'index2' (ffff8801f319a890): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index2'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.429993] kobject: 'index3' (ffff8801f319a8d8): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.430573] kobject: 'index3' (ffff8801f319a8d8): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.430952] kobject: 'index3' (ffff8801f319a8d8): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index3'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.431609] kobject: 'cache' (ffff8801f4417940): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.431988] kobject: 'cache' (ffff8801f4417940): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.432575] kobject: 'machinecheck1' (ffff8801f880cff0): kobject_add_internal: parent: 'machinecheck', set: 'machinecheck'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.433216] kobject: 'machinecheck1' (ffff8801f880cff0): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.433622] kobject: 'machinecheck1' (ffff8801f880cff0): fill_kobj_path: path = '/devices/system/machinecheck/machinecheck1'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.434490] kobject: 'cpufreq' (ffff8801f20700a8): kobject_add_internal: parent: 'cpu1', set: '<NULL>'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.435090] kobject: 'cpufreq' (ffff8801f20700a8): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.435544] kobject: 'cpufreq' (ffff8801f20700a8): fill_kobj_path: path = '/devices/system/cpu/cpu1/cpufreq'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.436143] CPU1 is up
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.437077] lockdep: fixing up alternatives.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.437391] Booting Node 0 Processor 2 APIC 0x12
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.437705] smpboot cpu 2: start_ip = 97000
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.449201] Calibrating delay loop (skipped) already calibrated this CPU
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.470094] Switched to NOHz mode on CPU #2
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.470544] NMI watchdog enabled, takes one hw-pmu counter.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.471009] kobject: 'cache' (ffff8801f4417a40): kobject_add_internal: parent: 'cpu2', set: '<NULL>'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.471619] kobject: 'index0' (ffff8801f1f02e00): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.472191] kobject: 'index0' (ffff8801f1f02e00): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.472564] kobject: 'index0' (ffff8801f1f02e00): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache/index0'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.473153] kobject: 'index1' (ffff8801f1f02e48): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.473704] kobject: 'index1' (ffff8801f1f02e48): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.474073] kobject: 'index1' (ffff8801f1f02e48): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache/index1'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.474661] kobject: 'index2' (ffff8801f1f02e90): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.475233] kobject: 'index2' (ffff8801f1f02e90): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.475608] kobject: 'index2' (ffff8801f1f02e90): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache/index2'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.476199] kobject: 'index3' (ffff8801f1f02ed8): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.476759] kobject: 'index3' (ffff8801f1f02ed8): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.477136] kobject: 'index3' (ffff8801f1f02ed8): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache/index3'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.477724] kobject: 'cache' (ffff8801f4417a40): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.478095] kobject: 'cache' (ffff8801f4417a40): fill_kobj_path: path = '/devices/system/cpu/cpu2/cache'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.478658] kobject: 'machinecheck2' (ffff8801f8a0cff0): kobject_add_internal: parent: 'machinecheck', set: 'machinecheck'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.479282] kobject: 'machinecheck2' (ffff8801f8a0cff0): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.479675] kobject: 'machinecheck2' (ffff8801f8a0cff0): fill_kobj_path: path = '/devices/system/machinecheck/machinecheck2'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.480462] kobject: 'cpufreq' (ffff8801f1c0caa8): kobject_add_internal: parent: 'cpu2', set: '<NULL>'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.481040] kobject: 'cpufreq' (ffff8801f1c0caa8): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.481419] kobject: 'cpufreq' (ffff8801f1c0caa8): fill_kobj_path: path = '/devices/system/cpu/cpu2/cpufreq'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.481992] CPU2 is up
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.484753] lockdep: fixing up alternatives.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.485073] Booting Node 0 Processor 3 APIC 0x14
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.485389] smpboot cpu 3: start_ip = 97000
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.496805] Calibrating delay loop (skipped) already calibrated this CPU
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.517787] NMI watchdog enabled, takes one hw-pmu counter.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.518049] Switched to NOHz mode on CPU #3
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.518790] kobject: 'cache' (ffff880144a32e00): kobject_add_internal: parent: 'cpu3', set: '<NULL>'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.519356] kobject: 'index0' (ffff8801f25c0e00): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.519916] kobject: 'index0' (ffff8801f25c0e00): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.520291] kobject: 'index0' (ffff8801f25c0e00): fill_kobj_path: path = '/devices/system/cpu/cpu3/cache/index0'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.520884] kobject: 'index1' (ffff8801f25c0e48): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.521444] kobject: 'index1' (ffff8801f25c0e48): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.521813] kobject: 'index1' (ffff8801f25c0e48): fill_kobj_path: path = '/devices/system/cpu/cpu3/cache/index1'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.522443] kobject: 'index2' (ffff8801f25c0e90): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.523020] kobject: 'index2' (ffff8801f25c0e90): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.523392] kobject: 'index2' (ffff8801f25c0e90): fill_kobj_path: path = '/devices/system/cpu/cpu3/cache/index2'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.523985] kobject: 'index3' (ffff8801f25c0ed8): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.524544] kobject: 'index3' (ffff8801f25c0ed8): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.524914] kobject: 'index3' (ffff8801f25c0ed8): fill_kobj_path: path = '/devices/system/cpu/cpu3/cache/index3'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.525505] kobject: 'cache' (ffff880144a32e00): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.525872] kobject: 'cache' (ffff880144a32e00): fill_kobj_path: path = '/devices/system/cpu/cpu3/cache'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.526521] kobject: 'machinecheck3' (ffff8801f8c0cff0): kobject_add_internal: parent: 'machinecheck', set: 'machinecheck'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.527144] kobject: 'machinecheck3' (ffff8801f8c0cff0): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.527539] kobject: 'machinecheck3' (ffff8801f8c0cff0): fill_kobj_path: path = '/devices/system/machinecheck/machinecheck3'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.528354] kobject: 'cpufreq' (ffff8801f1da3ea8): kobject_add_internal: parent: 'cpu3', set: '<NULL>'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.528932] kobject: 'cpufreq' (ffff8801f1da3ea8): kobject_uevent_env
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.529313] kobject: 'cpufreq' (ffff8801f1da3ea8): fill_kobj_path: path = '/devices/system/cpu/cpu3/cpufreq'
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.529882] CPU3 is up
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.545074] mptsas 0000:0b:00.0: BAR 0: set to [io  0x2000-0x20ff] (PCI address [0x2000-0x20ff])
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.545631] mptsas 0000:0b:00.0: BAR 1: set to [mem 0x97a10000-0x97a13fff 64bit] (PCI address [0x97a10000-0x97a13fff])
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.546271] mptsas 0000:0b:00.0: BAR 3: set to [mem 0x97a00000-0x97a0ffff 64bit] (PCI address [0x97a00000-0x97a0ffff])
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.546928] mptsas 0000:0b:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100047)
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.559439] PM: early restore of devices complete after 26.262 msecs
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.883673] ioatdma 0000:00:16.0: setting latency timer to 64
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.883679] ioatdma 0000:00:16.1: setting latency timer to 64
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.883693] ioatdma 0000:00:16.2: setting latency timer to 64
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.883707] ioatdma 0000:00:16.3: setting latency timer to 64
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.883726] ioatdma 0000:00:16.5: setting latency timer to 64
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.883734] ioatdma 0000:00:16.4: setting latency timer to 64
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.883742] ioatdma 0000:00:16.6: setting latency timer to 64
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.883756] ioatdma 0000:00:16.7: setting latency timer to 64
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.883759] uhci_hcd 0000:00:1a.0: setting latency timer to 64
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.883777] ehci_hcd 0000:00:1a.7: setting latency timer to 64
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.883798] usb usb3: root hub lost power or was reset
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.883832] uhci_hcd 0000:00:1d.0: setting latency timer to 64
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.883865] usb usb4: root hub lost power or was reset
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.883883] uhci_hcd 0000:00:1d.1: setting latency timer to 64
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.883892] uhci_hcd 0000:00:1d.2: setting latency timer to 64
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.883921] usb usb5: root hub lost power or was reset
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.883929] usb usb6: root hub lost power or was reset
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.883940] usb usb1: root hub lost power or was reset
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.883946] ehci_hcd 0000:00:1d.7: setting latency timer to 64
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.883955] pci 0000:00:1e.0: setting latency timer to 64
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.883974] mptbase: ioc0: pci-resume: pdev=0xffff8801f4626000, slot=0000:0b:00.0, Previous operating state [D0]
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.883989] mptsas 0000:0b:00.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.884063] mptbase: ioc0: pci-resume: ioc-state=0x1,doorbell=0x10000000
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.884074] usb usb2: root hub lost power or was reset
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.887839] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.887874] qla2xxx 0000:24:00.0: setting latency timer to 64
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.887884] qla2xxx 0000:24:00.1: setting latency timer to 64
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.887895] pci 0000:06:00.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.887903] pci 0000:06:00.0: setting latency timer to 64
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.887957] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.888350] serial 00:07: activated
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.888611] serial 00:08: activated
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.901034] Extended CMOS year: 2000
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.956554] bnx2 0000:10:00.1: eth1: NIC SerDes Link is Down
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  689.982314] bnx2 0000:10:00.1: eth1: NIC SerDes Link is Up, 1000 Mbps full duplex
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  690.299976] kobject: '(null)' (ffff8801f32eab58): kobject_cleanup
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  690.299978] kobject: '(null)' (ffff8801f32eab58): calling ktype release
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  690.555502] usb 2-3: reset high speed USB device number 2 using ehci_hcd
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  691.044895] usb 2-3.2: reset high speed USB device number 4 using ehci_hcd
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  691.382395] usb 2-3.2.2: reset high speed USB device number 5 using ehci_hcd
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  691.631849] usb 5-2: reset full speed USB device number 2 using uhci_hcd
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  691.873632] usb 2-3.2.2.3: reset high speed USB device number 6 using ehci_hcd
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  694.982750] mptbase: ioc0: Sending mpt_do_ioc_recovery
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  695.025826] mptbase: ioc0: Initiating bringup
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  695.201368] ioc0: LSISAS1064E: Capabilities={Initiator}
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  695.245683] mptsas 0000:0b:00.0: setting latency timer to 64
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  704.526574] mptbase: ioc0: pci-resume: success
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  704.564588] PM: restore of devices complete after 14703.821 msecs
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  704.616189] PM: Image restored successfully.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  704.651981] Restarting tasks ... done.
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  704.721452] PM: Basic memory bitmaps freed
Jun  6 10:01:58 istl-vmc-blade9 kernel: [  704.803639] kobject: 'msr4' (ffff8801eabe2810): kobject_add_internal: parent: 'msr', set: 'devices'
Jun  6 10:01:59 istl-vmc-blade9 kernel: [  705.362738] kobject: 'msr4' (ffff8801eabe2810): kobject_uevent_env
Jun  6 10:01:59 istl-vmc-blade9 kernel: [  705.867999] kobject: 'msr4' (ffff8801eabe2810): fill_kobj_path: path = '/devices/virtual/msr/msr4'
Jun  6 10:02:00 istl-vmc-blade9 kernel: [  706.582918] kobject: 'cpu4' (ffff8801f1e32010): kobject_add_internal: parent: 'cpuid', set: 'devices'
Jun  6 10:02:01 istl-vmc-blade9 kernel: [  707.340295] kobject: 'cpu4' (ffff8801f1e32010): kobject_uevent_env
Jun  6 10:02:01 istl-vmc-blade9 kernel: [  707.757007] kobject: 'cpu4' (ffff8801f1e32010): fill_kobj_path: path = '/devices/virtual/cpuid/cpu4'
Jun  6 10:02:02 istl-vmc-blade9 kernel: [  708.474047] lockdep: fixing up alternatives.
Jun  6 10:02:02 istl-vmc-blade9 kernel: [  708.516937] Booting Node 1 Processor 4 APIC 0x20
Jun  6 10:02:02 istl-vmc-blade9 kernel: [  708.555754] smpboot cpu 4: start_ip = 97000
Jun  6 10:02:02 istl-vmc-blade9 kernel: [  708.601984] Calibrating delay loop (skipped) already calibrated this CPU
Jun  6 10:02:02 istl-vmc-blade9 kernel: [  708.934362] Switched to NOHz mode on CPU #4
Jun  6 10:02:02 istl-vmc-blade9 kernel: [  709.093370] NMI watchdog enabled, takes one hw-pmu counter.
Jun  6 10:02:02 istl-vmc-blade9 kernel: [  709.210501] kobject: 'cache' (ffff8801f2db99c0): kobject_add_internal: parent: 'cpu4', set: '<NULL>'
Jun  6 10:02:03 istl-vmc-blade9 kernel: [  709.703834] kobject: 'index0' (ffff8801f2bf9a00): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:02:03 istl-vmc-blade9 kernel: [  709.803391] kobject: 'index0' (ffff8801f2bf9a00): kobject_uevent_env
Jun  6 10:02:03 istl-vmc-blade9 kernel: [  709.903706] kobject: 'index0' (ffff8801f2bf9a00): fill_kobj_path: path = '/devices/system/cpu/cpu4/cache/index0'
Jun  6 10:02:04 istl-vmc-blade9 kernel: [  710.512317] kobject: 'index1' (ffff8801f2bf9a48): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:02:04 istl-vmc-blade9 kernel: [  710.676646] kobject: 'index1' (ffff8801f2bf9a48): kobject_uevent_env
Jun  6 10:02:04 istl-vmc-blade9 kernel: [  711.076171] kobject: 'index1' (ffff8801f2bf9a48): fill_kobj_path: path = '/devices/system/cpu/cpu4/cache/index1'
Jun  6 10:02:05 istl-vmc-blade9 kernel: [  711.333644] kobject: 'index2' (ffff8801f2bf9a90): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:02:05 istl-vmc-blade9 kernel: [  711.733033] kobject: 'index2' (ffff8801f2bf9a90): kobject_uevent_env
Jun  6 10:02:05 istl-vmc-blade9 kernel: [  712.038567] kobject: 'index2' (ffff8801f2bf9a90): fill_kobj_path: path = '/devices/system/cpu/cpu4/cache/index2'
Jun  6 10:02:06 istl-vmc-blade9 kernel: [  712.670596] kobject: 'index3' (ffff8801f2bf9ad8): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:02:06 istl-vmc-blade9 kernel: [  713.242948] kobject: 'index3' (ffff8801f2bf9ad8): kobject_uevent_env
Jun  6 10:02:07 istl-vmc-blade9 kernel: [  713.610578] kobject: 'index3' (ffff8801f2bf9ad8): fill_kobj_path: path = '/devices/system/cpu/cpu4/cache/index3'
Jun  6 10:02:07 istl-vmc-blade9 kernel: [  713.755947] kobject: 'cache' (ffff8801f2db99c0): kobject_uevent_env
Jun  6 10:02:07 istl-vmc-blade9 kernel: [  714.135352] kobject: 'cache' (ffff8801f2db99c0): fill_kobj_path: path = '/devices/system/cpu/cpu4/cache'
Jun  6 10:02:08 istl-vmc-blade9 kernel: [  714.301295] kobject: 'machinecheck4' (ffff88047e60cff0): kobject_add_internal: parent: 'machinecheck', set: 'machinecheck'
Jun  6 10:02:08 istl-vmc-blade9 kernel: [  714.730378] kobject: 'machinecheck4' (ffff88047e60cff0): kobject_uevent_env
Jun  6 10:02:08 istl-vmc-blade9 kernel: [  715.125467] kobject: 'machinecheck4' (ffff88047e60cff0): fill_kobj_path: path = '/devices/system/machinecheck/machinecheck4'
Jun  6 10:02:09 istl-vmc-blade9 kernel: [  715.325609] microcode: CPU4 sig=0x206c2, pf=0x1, revision=0x13
Jun  6 10:02:09 istl-vmc-blade9 kernel: [  715.858712] kobject: 'firmware' (ffff8801f24d6f40): kobject_add_internal: parent: 'microcode', set: '(null)'
Jun  6 10:02:10 istl-vmc-blade9 kernel: [  716.434827] kobject: 'microcode' (ffff8801b96a2910): kobject_add_internal: parent: 'firmware', set: 'devices'
Jun  6 10:02:10 istl-vmc-blade9 kernel: [  717.009963] kobject: 'microcode' (ffff8801b96a2910): kobject_uevent_env
Jun  6 10:02:10 istl-vmc-blade9 kernel: [  717.065542] kobject: 'microcode' (ffff8801b96a2910): kobject_uevent_env: uevent_suppress caused the event to drop!
Jun  6 10:02:11 istl-vmc-blade9 kernel: [  717.520183] kobject: 'microcode' (ffff8801b96a2910): kobject_uevent_env
Jun  6 10:02:11 istl-vmc-blade9 kernel: [  717.938526] kobject: 'microcode' (ffff8801b96a2910): fill_kobj_path: path = '/devices/platform/microcode/firmware/microcode'
Jun  6 10:02:12 istl-vmc-blade9 firmware.sh[8173]: Cannot find  firmware file 'intel-ucode/06-2c-02'
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.293922] PM: Marking nosave pages: 000000000009c000 - 0000000000100000
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.350863] PM: Marking nosave pages: 000000007cdcd000 - 000000007ce91000
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.407750] PM: Marking nosave pages: 000000007d584000 - 000000007d634000
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.464633] PM: Marking nosave pages: 000000007f68f000 - 000000007f7ff000
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.521511] PM: Marking nosave pages: 000000007f800000 - 0000000100000000
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.579740] PM: Basic memory bitmaps created
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.615538] PM: Syncing filesystems ... 
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.635496] kobject: 'microcode' (ffff8801b96a2910): kobject_uevent_env
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.635502] kobject: 'microcode' (ffff8801b96a2910): fill_kobj_path: path = '/devices/platform/microcode/firmware/microcode'
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.635520] kobject: 'firmware' (ffff8801f24d6f40): kobject_cleanup
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.635522] kobject: 'firmware' (ffff8801f24d6f40): auto cleanup kobject_del
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.635526] kobject: 'firmware' (ffff8801f24d6f40): calling ktype release
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.635528] kobject: 'firmware': free name
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.635529] kobject: 'microcode' (ffff8801b96a2910): kobject_cleanup
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.635531] kobject: 'microcode' (ffff8801b96a2910): calling ktype release
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.635534] kobject: 'microcode': free name
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.635690] kobject: 'cpufreq' (ffff8801f441baa8): kobject_add_internal: parent: 'cpu4', set: '<NULL>'
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.635717] kobject: 'cpufreq' (ffff8801f441baa8): kobject_uevent_env
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.635720] kobject: 'cpufreq' (ffff8801f441baa8): fill_kobj_path: path = '/devices/system/cpu/cpu4/cpufreq'
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.635727] kobject: 'cpu4' (ffff88047e60c338): kobject_uevent_env
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.635730] kobject: 'cpu4' (ffff88047e60c338): fill_kobj_path: path = '/devices/system/cpu/cpu4'
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.663434] kobject: 'msr5' (ffff880144b7c010): kobject_add_internal: parent: 'msr', set: 'devices'
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.663555] kobject: 'msr5' (ffff880144b7c010): kobject_uevent_env
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.663559] kobject: 'msr5' (ffff880144b7c010): fill_kobj_path: path = '/devices/virtual/msr/msr5'
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.664975] kobject: 'cpu5' (ffff8801eda65810): kobject_add_internal: parent: 'cpuid', set: 'devices'
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.665028] kobject: 'cpu5' (ffff8801eda65810): kobject_uevent_env
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.665031] kobject: 'cpu5' (ffff8801eda65810): fill_kobj_path: path = '/devices/virtual/cpuid/cpu5'
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.665052] lockdep: fixing up alternatives.
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.665056] Booting Node 1 Processor 5 APIC 0x22
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.665058] smpboot cpu 5: start_ip = 97000
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  718.676179] Calibrating delay loop (skipped) already calibrated this CPU
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  720.082288] Switched to NOHz mode on CPU #5
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  720.119007] NMI watchdog enabled, takes one hw-pmu counter.
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  720.166630] kobject: 'cache' (ffff88046cc84640): kobject_add_internal: parent: 'cpu5', set: '<NULL>'
Jun  6 10:02:13 istl-vmc-blade9 kernel: [  720.243333] kobject: 'index0' (ffff88046cc7f000): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:02:14 istl-vmc-blade9 kernel: [  720.322194] kobject: 'index0' (ffff88046cc7f000): kobject_uevent_env
Jun  6 10:02:14 istl-vmc-blade9 kernel: [  720.375540] kobject: 'index0' (ffff88046cc7f000): fill_kobj_path: path = '/devices/system/cpu/cpu5/cache/index0'
Jun  6 10:02:14 istl-vmc-blade9 kernel: [  720.466407] kobject: 'index1' (ffff88046cc7f048): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:02:14 istl-vmc-blade9 kernel: [  720.548969] kobject: 'index1' (ffff88046cc7f048): kobject_uevent_env
Jun  6 10:02:14 istl-vmc-blade9 kernel: [  720.609998] kobject: 'index1' (ffff88046cc7f048): fill_kobj_path: path = '/devices/system/cpu/cpu5/cache/index1'
Jun  6 10:02:14 istl-vmc-blade9 kernel: [  720.797711] done.
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  720.813896] Freezing user space processes ... 
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  720.850772] kobject: 'index2' (ffff88046cc7f090): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  720.930441] kobject: 'index2' (ffff88046cc7f090): kobject_uevent_env
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  720.983683] kobject: 'index2' (ffff88046cc7f090): fill_kobj_path: path = '/devices/system/cpu/cpu5/cache/index2'
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  721.069005] kobject: 'index3' (ffff88046cc7f0d8): kobject_add_internal: parent: 'cache', set: '<NULL>'
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  721.147040] kobject: 'index3' (ffff88046cc7f0d8): kobject_uevent_env
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  721.200278] kobject: 'index3' (ffff88046cc7f0d8): fill_kobj_path: path = '/devices/system/cpu/cpu5/cache/index3'
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  721.285615] kobject: 'cache' (ffff88046cc84640): kobject_uevent_env
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  721.338117] kobject: 'cache' (ffff88046cc84640): fill_kobj_path: path = '/devices/system/cpu/cpu5/cache'
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  721.417606] kobject: 'machinecheck5' (ffff88047e80cff0): kobject_add_internal: parent: 'machinecheck', set: 'machinecheck'
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  721.510183] kobject: 'machinecheck5' (ffff88047e80cff0): kobject_uevent_env
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  721.568507] kobject: 'machinecheck5' (ffff88047e80cff0): fill_kobj_path: path = '/devices/system/machinecheck/machinecheck5'
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  721.662823] microcode: CPU5 sig=0x206c2, pf=0x1, revision=0x13
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  721.711700] ------------[ cut here ]------------
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  721.750411] WARNING: at drivers/base/firmware_class.c:524 _request_firmware+0x279/0x2c0()
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  721.819040] Hardware name: BladeCenter HS22V -[7871G2A]-
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  721.863610] Modules linked in: sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log microcode serio_raw pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core shpchp ioatdma dca i7core_edac edac_core bnx2 sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif usb_storage qla2xxx scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: scsi_wait_scan]
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  722.300299] Pid: 4836, comm: invert_cpu_stat Tainted: G        W   3.1.0-rc2 #1
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  722.361608] Call Trace:
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  722.382194]  [<ffffffff8106af6f>] warn_slowpath_common+0x7f/0xc0
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  722.432571]  [<ffffffff8106afca>] warn_slowpath_null+0x1a/0x20
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  722.481451]  [<ffffffff813645a9>] _request_firmware+0x279/0x2c0
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  722.531097]  [<ffffffff81364686>] request_firmware+0x16/0x20
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  722.578568]  [<ffffffffa01f3da0>] request_microcode_fw+0x70/0xf0 [microcode]
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  722.637672]  [<ffffffffa01f3390>] microcode_init_cpu+0xc0/0x100 [microcode]
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  722.696048]  [<ffffffffa01f44b4>] mc_cpu_callback+0x7c/0x11f [microcode]
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  722.752270]  [<ffffffff815393a4>] notifier_call_chain+0x94/0xd0
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  722.801922]  [<ffffffff8109770e>] __raw_notifier_call_chain+0xe/0x10
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  722.855209]  [<ffffffff8106d000>] __cpu_notify+0x20/0x40
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  722.899782]  [<ffffffff8152cf5b>] _cpu_up+0xc7/0x10e
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  722.941436]  [<ffffffff8152d07b>] cpu_up+0xd9/0xec
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  722.981589]  [<ffffffff8151e599>] store_online+0x99/0xd0
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  723.026102]  [<ffffffff81355eb0>] sysdev_store+0x20/0x30
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  723.070666]  [<ffffffff811f3096>] sysfs_write_file+0xe6/0x170
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  723.118870]  [<ffffffff8117ee50>] vfs_write+0xd0/0x1a0
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  723.161981]  [<ffffffff8117f024>] sys_write+0x54/0xa0
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  723.204357]  [<ffffffff8153df02>] system_call_fastpath+0x16/0x1b
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  723.254739] ---[ end trace 79417b0d74e88b09 ]---
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  723.293436] platform microcode: firmware: intel-ucode/06-2c-02 will not be loaded
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  723.356443] kobject: 'cpufreq' (ffff88046ecb20a8): kobject_add_internal: parent: 'cpu5', set: '<NULL>'
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  723.434597] kobject: 'cpufreq' (ffff88046ecb20a8): kobject_uevent_env
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  723.488686] kobject: 'cpufreq' (ffff88046ecb20a8): fill_kobj_path: path = '/devices/system/cpu/cpu5/cpufreq'
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  723.571166] kobject: 'cpu5' (ffff88047e80c338): kobject_uevent_env
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  723.623000] kobject: 'cpu5' (ffff88047e80c338): fill_kobj_path: path = '/devices/system/cpu/cpu5'
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  723.698924] (elapsed 2.85 seconds) done.
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  723.731953] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  723.805642] PM: Preallocating image memory... done (allocated 817639 pages)
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  724.460690] PM: Allocated 3270556 kbytes in 0.59 seconds (5543.31 MB/s)
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  724.516371] sd 0:0:1:0: [sdb] Synchronizing SCSI cache
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  724.560632] sd 0:0:0:0: [sda] Synchronizing SCSI cache
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  724.616483] serial 00:08: disabled
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  724.616796] serial 00:07: disabled
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  724.617761] ACPI handle has no context!
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  724.618051] mptbase: ioc0: pci-suspend: pdev=0xffff8801f4626000, slot=0000:0b:00.0, Entering operating state [D3]
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  724.642649] ACPI handle has no context!
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  724.756225] mptsas 0000:0b:00.0: PCI INT A disabled
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  724.767543] PM: freeze of devices complete after 251.818 msecs
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  724.770478] PM: late freeze of devices complete after 2.574 msecs
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  724.770849] Disabling non-boot CPUs ...
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  724.771681] kobject: 'cpufreq' (ffff8801f20700a8): kobject_cleanup
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  724.772067] kobject: 'cpufreq' (ffff8801f20700a8): auto cleanup 'remove' event
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  724.772551] kobject: 'cpufreq' (ffff8801f20700a8): kobject_uevent_env
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  724.772938] kobject: 'cpufreq' (ffff8801f20700a8): fill_kobj_path: path = '/devices/system/cpu/cpu1/cpufreq'
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  724.773537] kobject: 'cpufreq' (ffff8801f20700a8): auto cleanup kobject_del
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  724.773953] kobject: 'cpufreq' (ffff8801f20700a8): calling ktype release
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  724.774352] kobject: 'cpufreq': free name
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  724.776538] CPU 1 is now offline
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  724.777426] kobject: 'index0' (ffff8801f319a800): kobject_cleanup
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  724.777802] kobject: 'index0' (ffff8801f319a800): does not have a release() function, it is broken and must be fixed.
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  724.778483] kobject: 'index0' (ffff8801f319a800): auto cleanup 'remove' event
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  724.778893] kobject: 'index0' (ffff8801f319a800): kobject_uevent_env
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  724.779366] kobject: 'index0' (ffff8801f319a800): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index0'
Jun  6 10:02:39 istl-vmc-blade9 kernel: [  724.779964] kobject: 'index0' (ffff8801f319a800): auto cleanup kobject_del
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.534170] kobject: '00:06' (ffff8801f479e010): fill_kobj_path: path = '/devices/pnp0/00:06'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.542995] kobject: '00:07' (ffff88046f703810): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.549403] kobject: '00:07' (ffff88046f703810): fill_kobj_path: path = '/devices/pnp0/00:07'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.558275] kobject: 'ttyS0' (ffff8801f1ca7010): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.564682] kobject: 'ttyS0' (ffff8801f1ca7010): fill_kobj_path: path = '/devices/pnp0/00:07/tty/ttyS0'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.574326] kobject: '00:08' (ffff8801f479e810): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.580727] kobject: '00:08' (ffff8801f479e810): fill_kobj_path: path = '/devices/pnp0/00:08'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.589509] kobject: 'ttyS1' (ffff8801f1ca7810): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.596001] kobject: 'ttyS1' (ffff8801f1ca7810): fill_kobj_path: path = '/devices/pnp0/00:08/tty/ttyS1'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.605648] kobject: '00:09' (ffff8801f47a9010): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.612051] kobject: '00:09' (ffff8801f47a9010): fill_kobj_path: path = '/devices/pnp0/00:09'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.620880] kobject: 'tpm0' (ffff8801f1cd1010): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.627200] kobject: 'tpm0' (ffff8801f1cd1010): fill_kobj_path: path = '/devices/pnp0/00:09/misc/tpm0'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.636857] kobject: '00:0a' (ffff88046f703010): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.643264] kobject: '00:0a' (ffff88046f703010): fill_kobj_path: path = '/devices/pnp0/00:0a'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.652129] kobject: '00:0b' (ffff88046f6fc810): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.658536] kobject: '00:0b' (ffff88046f6fc810): fill_kobj_path: path = '/devices/pnp0/00:0b'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.667310] kobject: '00:0c' (ffff8801f47a9810): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.673813] kobject: '00:0c' (ffff8801f47a9810): fill_kobj_path: path = '/devices/pnp0/00:0c'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.682598] kobject: '00:0d' (ffff8801f47ae010): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.689001] kobject: '00:0d' (ffff8801f47ae010): fill_kobj_path: path = '/devices/pnp0/00:0d'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.697764] kobject: 'software' (ffff8801f22f8810): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.704429] kobject: 'software' (ffff8801f22f8810): fill_kobj_path: path = '/devices/software'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.713377] kobject: 'tracepoint' (ffff8801f22f7010): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.720217] kobject: 'tracepoint' (ffff8801f22f7010): fill_kobj_path: path = '/devices/tracepoint'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.729524] kobject: '1:0' (ffff8801f1cdc010): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.735755] kobject: '1:0' (ffff8801f1cdc010): fill_kobj_path: path = '/devices/virtual/bdi/1:0'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.744915] kobject: '1:1' (ffff88046cb2b010): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.751191] kobject: '1:1' (ffff88046cb2b010): fill_kobj_path: path = '/devices/virtual/bdi/1:1'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.760325] kobject: '1:10' (ffff88046cb35010): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.766642] kobject: '1:10' (ffff88046cb35010): fill_kobj_path: path = '/devices/virtual/bdi/1:10'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.775946] kobject: '1:11' (ffff8801f1cfa010): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.782263] kobject: '1:11' (ffff8801f1cfa010): fill_kobj_path: path = '/devices/virtual/bdi/1:11'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.791481] kobject: '1:12' (ffff88046cb3c810): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.797893] kobject: '1:12' (ffff88046cb3c810): fill_kobj_path: path = '/devices/virtual/bdi/1:12'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.807113] kobject: '1:13' (ffff8801f1cfa810): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.813433] kobject: '1:13' (ffff8801f1cfa810): fill_kobj_path: path = '/devices/virtual/bdi/1:13'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.822734] kobject: '1:14' (ffff88046cb3c010): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.829052] kobject: '1:14' (ffff88046cb3c010): fill_kobj_path: path = '/devices/virtual/bdi/1:14'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.839988] kobject: '1:15' (ffff8801f1d04010): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.846310] kobject: '1:15' (ffff8801f1d04010): fill_kobj_path: path = '/devices/virtual/bdi/1:15'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.855606] kobject: '1:2' (ffff8801f1cdc810): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.861836] kobject: '1:2' (ffff8801f1cdc810): fill_kobj_path: path = '/devices/virtual/bdi/1:2'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.870878] kobject: '1:3' (ffff88046cb30810): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.877197] kobject: '1:3' (ffff88046cb30810): fill_kobj_path: path = '/devices/virtual/bdi/1:3'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.886235] kobject: '1:4' (ffff8801f1ce9010): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.892465] kobject: '1:4' (ffff8801f1ce9010): fill_kobj_path: path = '/devices/virtual/bdi/1:4'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.901504] kobject: '1:5' (ffff88046cb30010): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.907734] kobject: '1:5' (ffff88046cb30010): fill_kobj_path: path = '/devices/virtual/bdi/1:5'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.916863] kobject: '1:6' (ffff8801f1ce9810): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.923092] kobject: '1:6' (ffff8801f1ce9810): fill_kobj_path: path = '/devices/virtual/bdi/1:6'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.932135] kobject: '1:7' (ffff88046cb35810): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.938459] kobject: '1:7' (ffff88046cb35810): fill_kobj_path: path = '/devices/virtual/bdi/1:7'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.947501] kobject: '1:8' (ffff8801f1cf2010): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.953735] kobject: '1:8' (ffff8801f1cf2010): fill_kobj_path: path = '/devices/virtual/bdi/1:8'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.962861] kobject: '1:9' (ffff8801f1cf2810): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.969088] kobject: '1:9' (ffff8801f1cf2810): fill_kobj_path: path = '/devices/virtual/bdi/1:9'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.978133] kobject: '7:0' (ffff88046cb75810): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.984453] kobject: '7:0' (ffff88046cb75810): fill_kobj_path: path = '/devices/virtual/bdi/7:0'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.993520] kobject: '7:1' (ffff8801f1d04810): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   49.999760] kobject: '7:1' (ffff8801f1d04810): fill_kobj_path: path = '/devices/virtual/bdi/7:1'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   50.008897] kobject: '7:2' (ffff88046cb75010): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   50.015128] kobject: '7:2' (ffff88046cb75010): fill_kobj_path: path = '/devices/virtual/bdi/7:2'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   50.024167] kobject: '7:3' (ffff8801f1c46010): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   50.030489] kobject: '7:3' (ffff8801f1c46010): fill_kobj_path: path = '/devices/virtual/bdi/7:3'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   50.039520] kobject: '7:4' (ffff88046cb7a810): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   50.045751] kobject: '7:4' (ffff88046cb7a810): fill_kobj_path: path = '/devices/virtual/bdi/7:4'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   50.054882] kobject: '7:5' (ffff8801f1d17010): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   50.061111] kobject: '7:5' (ffff8801f1d17010): fill_kobj_path: path = '/devices/virtual/bdi/7:5'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   50.070283] kobject: '7:6' (ffff88046cb7a010): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   50.076516] kobject: '7:6' (ffff88046cb7a010): fill_kobj_path: path = '/devices/virtual/bdi/7:6'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   50.085556] kobject: '7:7' (ffff88046f77e010): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   50.091876] kobject: '7:7' (ffff88046f77e010): fill_kobj_path: path = '/devices/virtual/bdi/7:7'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   50.100914] kobject: 'default' (ffff88046ec4d810): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   50.107495] kobject: 'default' (ffff88046ec4d810): fill_kobj_path: path = '/devices/virtual/bdi/default'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   50.117225] kobject: 'mtd-romap' (ffff88046f77f010): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   50.123971] kobject: 'mtd-romap' (ffff88046f77f010): fill_kobj_path: path = '/devices/virtual/bdi/mtd-romap'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   50.134107] kobject: 'mtd-rwmap' (ffff88046f77f810): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   50.140949] kobject: 'mtd-rwmap' (ffff88046f77f810): fill_kobj_path: path = '/devices/virtual/bdi/mtd-rwmap'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   50.151040] kobject: 'mtd-unmap' (ffff88046f77e810): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   50.157883] kobject: 'mtd-unmap' (ffff88046f77e810): fill_kobj_path: path = '/devices/virtual/bdi/mtd-unmap'
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   50.167962] kobject: 'loop0' (ffff88046cb44878): kobject_uevent_env
Jun  6 10:17:19 istl-vmc-blade9 kernel: [   50.174364] kobject: 'loop0' (ffff88046cb44878): fill_kobj_path: path = '/devices/virtual/block/loop0'
Jun  6 10:17:27 istl-vmc-blade9 kernel: [   97.375603] kobject: 'vcs3' (ffff88046aa22010): kobject_add_internal: parent: 'vc', set: 'devices'
Jun  6 10:17:27 istl-vmc-blade9 kernel: [   97.376135] kobject: 'vcs3' (ffff88046aa22010): kobject_uevent_env
Jun  6 10:17:27 istl-vmc-blade9 kernel: [   97.376141] kobject: 'vcs3' (ffff88046aa22010): fill_kobj_path: path = '/devices/virtual/vc/vcs3'
Jun  6 10:17:27 istl-vmc-blade9 kernel: [   97.376180] kobject: 'vcsa3' (ffff88046bf61010): kobject_add_internal: parent: 'vc', set: 'devices'
Jun  6 10:17:27 istl-vmc-blade9 kernel: [   97.376348] kobject: 'vcsa3' (ffff88046bf61010): kobject_uevent_env
Jun  6 10:17:27 istl-vmc-blade9 kernel: [   97.376355] kobject: 'vcsa3' (ffff88046bf61010): fill_kobj_path: path = '/devices/virtual/vc/vcsa3'
Jun  6 10:17:27 istl-vmc-blade9 kernel: [   97.425483] kobject: 'vcs5' (ffff88046c355810): kobject_add_internal: parent: 'vc', set: 'devices'
Jun  6 10:17:27 istl-vmc-blade9 kernel: [   97.425699] kobject: 'vcs5' (ffff88046c355810): kobject_uevent_env
Jun  6 10:17:27 istl-vmc-blade9 kernel: [   97.425711] kobject: 'vcs5' (ffff88046c355810): fill_kobj_path: path = '/devices/virtual/vc/vcs5'
Jun  6 10:17:27 istl-vmc-blade9 kernel: [   97.425749] kobject: 'vcsa5' (ffff88046a5aa810): kobject_add_internal: parent: 'vc', set: 'devices'
Jun  6 10:17:27 istl-vmc-blade9 kernel: [   97.426054] kobject: 'vcsa5' (ffff88046a5aa810): kobject_uevent_env
Jun  6 10:17:27 istl-vmc-blade9 kernel: [   97.426059] kobject: 'vcsa5' (ffff88046a5aa810): fill_kobj_path: path = '/devices/virtual/vc/vcsa5'
Jun  6 10:17:27 istl-vmc-blade9 kernel: [   97.475952] kobject: 'vcs4' (ffff8801f1d34810): kobject_add_internal: parent: 'vc', set: 'devices'
Jun  6 10:17:27 istl-vmc-blade9 kernel: [   97.476111] kobject: 'vcs4' (ffff8801f1d34810): kobject_uevent_env
Jun  6 10:17:27 istl-vmc-blade9 kernel: [   97.476121] kobject: 'vcs4' (ffff8801f1d34810): fill_kobj_path: path = '/devices/virtual/vc/vcs4'
Jun  6 10:17:27 istl-vmc-blade9 kernel: [   97.476160] kobject: 'vcsa4' (ffff8801f23b8810): kobject_add_internal: parent: 'vc', set: 'devices'
Jun  6 10:17:27 istl-vmc-blade9 kernel: [   97.476383] kobject: 'vcsa4' (ffff8801f23b8810): kobject_uevent_env
Jun  6 10:17:27 istl-vmc-blade9 kernel: [   97.476388] kobject: 'vcsa4' (ffff8801f23b8810): fill_kobj_path: path = '/devices/virtual/vc/vcsa4'
Jun  6 10:17:27 istl-vmc-blade9 kernel: [   97.526240] kobject: 'vcs6' (ffff88046d24e810): kobject_add_internal: parent: 'vc', set: 'devices'
Jun  6 10:17:27 istl-vmc-blade9 kernel: [   97.526371] kobject: 'vcs6' (ffff88046d24e810): kobject_uevent_env
Jun  6 10:17:27 istl-vmc-blade9 kernel: [   97.526382] kobject: 'vcs6' (ffff88046d24e810): fill_kobj_path: path = '/devices/virtual/vc/vcs6'
Jun  6 10:17:27 istl-vmc-blade9 kernel: [   97.526415] kobject: 'vcsa6' (ffff88046a809010): kobject_add_internal: parent: 'vc', set: 'devices'
Jun  6 10:17:27 istl-vmc-blade9 kernel: [   97.526552] kobject: 'vcsa6' (ffff88046a809010): kobject_uevent_env
Jun  6 10:17:27 istl-vmc-blade9 kernel: [   97.526558] kobject: 'vcsa6' (ffff88046a809010): fill_kobj_path: path = '/devices/virtual/vc/vcsa6'
Jun  6 10:29:16 istl-vmc-blade9 kernel: [  805.302406] PM: Hibernation mode set to 'reboot'
Jun  6 10:29:16 istl-vmc-blade9 kernel: [  805.349356] kobject: 'vcs63' (ffff8801f217e810): kobject_add_internal: parent: 'vc', set: 'devices'
Jun  6 10:29:16 istl-vmc-blade9 kernel: [  805.353651] kobject: 'vcs63' (ffff8801f217e810): kobject_uevent_env
Jun  6 10:29:16 istl-vmc-blade9 kernel: [  805.353663] kobject: 'vcs63' (ffff8801f217e810): fill_kobj_path: path = '/devices/virtual/vc/vcs63'
Jun  6 10:29:16 istl-vmc-blade9 kernel: [  805.353806] kobject: 'vcsa63' (ffff8801f2c46810): kobject_add_internal: parent: 'vc', set: 'devices'
Jun  6 10:29:16 istl-vmc-blade9 kernel: [  805.353937] kobject: 'vcsa63' (ffff8801f2c46810): kobject_uevent_env
Jun  6 10:29:16 istl-vmc-blade9 kernel: [  805.353942] kobject: 'vcsa63' (ffff8801f2c46810): fill_kobj_path: path = '/devices/virtual/vc/vcsa63'
Jun  6 10:29:16 istl-vmc-blade9 kernel: [  805.408176] PM: Marking nosave pages: 000000000009c000 - 0000000000100000
Jun  6 10:29:16 istl-vmc-blade9 kernel: [  805.408182] PM: Marking nosave pages: 000000007cdcd000 - 000000007ce91000
Jun  6 10:29:16 istl-vmc-blade9 kernel: [  805.408188] PM: Marking nosave pages: 000000007d584000 - 000000007d634000
Jun  6 10:29:16 istl-vmc-blade9 kernel: [  805.408194] PM: Marking nosave pages: 000000007f68f000 - 000000007f7ff000
Jun  6 10:29:16 istl-vmc-blade9 kernel: [  805.408203] PM: Marking nosave pages: 000000007f800000 - 0000000100000000
Jun  6 10:29:16 istl-vmc-blade9 kernel: [  805.410439] PM: Basic memory bitmaps created
Jun  6 10:29:18 istl-vmc-blade9 kernel: [  805.410442] PM: Syncing filesystems ... done.
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  806.735096] Freezing user space processes ... (elapsed 0.01 seconds) done.
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  806.755877] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  806.776388] PM: Preallocating image memory... done (allocated 888531 pages)
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.715879] PM: Allocated 3554124 kbytes in 0.93 seconds (3821.63 MB/s)
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.723330] sd 0:0:1:0: [sdb] Synchronizing SCSI cache
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.730096] sd 0:0:0:0: [sda] Synchronizing SCSI cache
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.749240] serial 00:08: disabled
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.749453] serial 00:07: disabled
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.750679] ACPI handle has no context!
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.750840] mptbase: ioc0: pci-suspend: pdev=0xffff8801f4626000, slot=0000:0b:00.0, Entering operating state [D3]
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.775663] 
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.775666] =======================================================
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.775994] [ INFO: possible circular locking dependency detected ]
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.776253] 3.1.0-rc2 #1
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.776364] -------------------------------------------------------
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.776621] kworker/u:6/29543 is trying to acquire lock:
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.776915]  (alc_key){..-...}, at: [<ffffffff81168fa9>] kmem_cache_free+0x1a9/0x240
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.777415] 
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.777417] but task is already holding lock:
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.777816]  (&(&parent->list_lock)->rlock){-.-...}, at: [<ffffffff81169294>] __drain_alien_cache+0x64/0xa0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.778398] 
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.778399] which lock already depends on the new lock.
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.778401] 
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.778975] 
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.778976] the existing dependency chain (in reverse order) is:
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.779425] 
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.779426] -> #1 (&(&parent->list_lock)->rlock){-.-...}:
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.779891]        [<ffffffff810ab50c>] validate_chain+0x6cc/0x7d0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.780227]        [<ffffffff810ab914>] __lock_acquire+0x304/0x500
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.780557]        [<ffffffff810ac1d2>] lock_acquire+0xa2/0x130
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.780877]        [<ffffffff815349b6>] _raw_spin_lock+0x36/0x70
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.781208]        [<ffffffff81169294>] __drain_alien_cache+0x64/0xa0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.781548]        [<ffffffff811698cb>] kfree+0x1db/0x2a0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.781847]        [<ffffffff81169a21>] free_alien_cache+0x91/0xa0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.782178]        [<ffffffff8152e9b9>] cpuup_prepare+0x168/0x1a9
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.782507]        [<ffffffff8152ea2f>] cpuup_callback+0x35/0xc5
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.782829]        [<ffffffff815393a4>] notifier_call_chain+0x94/0xd0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.783173]        [<ffffffff8109770e>] __raw_notifier_call_chain+0xe/0x10
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.783535]        [<ffffffff8106d000>] __cpu_notify+0x20/0x40
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.783858]        [<ffffffff8152cf02>] _cpu_up+0x6e/0x10e
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.784172]        [<ffffffff8152d07b>] cpu_up+0xd9/0xec
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.784468]        [<ffffffff81e21bd6>] smp_init+0x41/0x96
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.784771]        [<ffffffff81e03791>] kernel_init+0x1ef/0x2a6
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.785092]        [<ffffffff81540184>] kernel_thread_helper+0x4/0x10
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.785433] 
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.785434] -> #0 (alc_key){..-...}:
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.785824]        [<ffffffff810aae18>] check_prev_add+0x528/0x550
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.786156]        [<ffffffff810ab50c>] validate_chain+0x6cc/0x7d0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.786488]        [<ffffffff810ab914>] __lock_acquire+0x304/0x500
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.786823]        [<ffffffff810ac1d2>] lock_acquire+0xa2/0x130
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.787143]        [<ffffffff815349b6>] _raw_spin_lock+0x36/0x70
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.787467]        [<ffffffff81168fa9>] kmem_cache_free+0x1a9/0x240
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.787802]        [<ffffffff81169094>] slab_destroy+0x54/0x80
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.788123]        [<ffffffff8116911d>] free_block+0x5d/0x170
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.788439]        [<ffffffff811692bc>] __drain_alien_cache+0x8c/0xa0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.788778]        [<ffffffff811698cb>] kfree+0x1db/0x2a0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.789087]        [<ffffffff8144aeb0>] skb_release_data+0xd0/0x100
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.789426]        [<ffffffff8144aefe>] __kfree_skb+0x1e/0xa0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.789741]        [<ffffffff8144afb1>] consume_skb+0x31/0x80
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.790058]        [<ffffffffa01d4e74>] bnx2_free_skbs+0x234/0x390 [bnx2]
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.790416]        [<ffffffffa01d5096>] bnx2_suspend+0xc6/0xe0 [bnx2]
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.790758]        [<ffffffff812978a6>] pci_legacy_suspend+0x46/0xe0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.791101]        [<ffffffff8129854d>] pci_pm_freeze+0xad/0xd0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.791422]        [<ffffffff8135e7f6>] pm_op+0x136/0x1a0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.791724]        [<ffffffff8135f18b>] __device_suspend+0x26b/0x2d0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.792063]        [<ffffffff8136016f>] async_suspend+0x1f/0xa0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.792384]        [<ffffffff81099634>] async_run_entry_fn+0x84/0x160
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.792726]        [<ffffffff8108938a>] process_one_work+0x1aa/0x520
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.793065]        [<ffffffff8108ba7b>] worker_thread+0x17b/0x3b0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.793394]        [<ffffffff81090af6>] kthread+0xb6/0xc0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.793698]        [<ffffffff81540184>] kernel_thread_helper+0x4/0x10
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.794041] 
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.794042] other info that might help us debug this:
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.794043] 
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.794602]  Possible unsafe locking scenario:
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.794603] 
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.794995]        CPU0                    CPU1
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.795250]        ----                    ----
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.795505]   lock(&(&parent->list_lock)->rlock);
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.795789]                                lock(alc_key);
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.796101]                                lock(&(&parent->list_lock)->rlock);
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.796557]   lock(alc_key);
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.796771] 
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.796772]  *** DEADLOCK ***
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.796773] 
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.797252] 5 locks held by kworker/u:6/29543:
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.797503]  #0:  (events_unbound){.+.+.+}, at: [<ffffffff8108931d>] process_one_work+0x13d/0x520
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.798058]  #1:  ((&entry->work)){+.+.+.}, at: [<ffffffff8108931d>] process_one_work+0x13d/0x520
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.798591]  #2:  (&__lockdep_no_validate__){......}, at: [<ffffffff8135efc3>] __device_suspend+0xa3/0x2d0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.799160]  #3:  (&(&nc->lock)->rlock){-.-...}, at: [<ffffffff811698b4>] kfree+0x1c4/0x2a0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.799672]  #4:  (&(&parent->list_lock)->rlock){-.-...}, at: [<ffffffff81169294>] __drain_alien_cache+0x64/0xa0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.800270] 
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.800271] stack backtrace:
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.800608] Pid: 29543, comm: kworker/u:6 Not tainted 3.1.0-rc2 #1
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.800929] Call Trace:
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.801115]  [<ffffffff810a8e39>] print_circular_bug+0x109/0x110
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.801428]  [<ffffffff810aae18>] check_prev_add+0x528/0x550
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.801728]  [<ffffffff810ab50c>] validate_chain+0x6cc/0x7d0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.802040]  [<ffffffff8101a3f9>] ? sched_clock+0x9/0x10
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.802327]  [<ffffffff8109839d>] ? sched_clock_cpu+0xcd/0x110
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.802635]  [<ffffffff810ab914>] __lock_acquire+0x304/0x500
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.802938]  [<ffffffff810ac1d2>] lock_acquire+0xa2/0x130
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.803230]  [<ffffffff81168fa9>] ? kmem_cache_free+0x1a9/0x240
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.803541]  [<ffffffff815349b6>] _raw_spin_lock+0x36/0x70
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.803835]  [<ffffffff81168fa9>] ? kmem_cache_free+0x1a9/0x240
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.804147]  [<ffffffff81168fa9>] kmem_cache_free+0x1a9/0x240
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.804453]  [<ffffffff81169094>] slab_destroy+0x54/0x80
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.804740]  [<ffffffff8116911d>] free_block+0x5d/0x170
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.805027]  [<ffffffff811692bc>] __drain_alien_cache+0x8c/0xa0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.805337]  [<ffffffff811698cb>] kfree+0x1db/0x2a0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.805610]  [<ffffffff8144aeb0>] skb_release_data+0xd0/0x100
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.805916]  [<ffffffff8144aefe>] __kfree_skb+0x1e/0xa0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.806201]  [<ffffffff8144afb1>] consume_skb+0x31/0x80
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.806487]  [<ffffffffa01d4e74>] bnx2_free_skbs+0x234/0x390 [bnx2]
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.806813]  [<ffffffffa01d5096>] bnx2_suspend+0xc6/0xe0 [bnx2]
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.807130]  [<ffffffff812978a6>] pci_legacy_suspend+0x46/0xe0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.807445]  [<ffffffff8129854d>] pci_pm_freeze+0xad/0xd0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.807736]  [<ffffffff8135e7f6>] pm_op+0x136/0x1a0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.808015]  [<ffffffff8135f18b>] __device_suspend+0x26b/0x2d0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.808334]  [<ffffffff8136016f>] async_suspend+0x1f/0xa0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.808625]  [<ffffffff81099634>] async_run_entry_fn+0x84/0x160
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.808943]  [<ffffffff8108938a>] process_one_work+0x1aa/0x520
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.809255]  [<ffffffff8108931d>] ? process_one_work+0x13d/0x520
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.809568]  [<ffffffff810995b0>] ? async_schedule+0x20/0x20
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.809870]  [<ffffffff8108ba7b>] worker_thread+0x17b/0x3b0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.810167]  [<ffffffff8108b900>] ? manage_workers+0x120/0x120
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.810476]  [<ffffffff81090af6>] kthread+0xb6/0xc0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.810746]  [<ffffffff810aa5fd>] ? trace_hardirqs_on_caller+0x10d/0x1a0
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.811092]  [<ffffffff81540184>] kernel_thread_helper+0x4/0x10
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.811404]  [<ffffffff81535774>] ? retint_restore_args+0x13/0x13
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.811723]  [<ffffffff81090a40>] ? __init_kthread_worker+0x70/0x70
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.812053]  [<ffffffff81540180>] ? gs_change+0x13/0x13
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.814839] ACPI handle has no context!
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.888855] mptsas 0000:0b:00.0: PCI INT A disabled
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.900027] PM: freeze of devices complete after 177.790 msecs
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.902390] PM: late freeze of devices complete after 2.057 msecs
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.902708] Disabling non-boot CPUs ...
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.903439] kobject: 'cpufreq' (ffff8801f376c6a8): kobject_cleanup
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.903768] kobject: 'cpufreq' (ffff8801f376c6a8): auto cleanup 'remove' event
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.904200] kobject: 'cpufreq' (ffff8801f376c6a8): kobject_uevent_env
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.904530] kobject: 'cpufreq' (ffff8801f376c6a8): fill_kobj_path: path = '/devices/system/cpu/cpu1/cpufreq'
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.905076] kobject: 'cpufreq' (ffff8801f376c6a8): auto cleanup kobject_del
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.905434] kobject: 'cpufreq' (ffff8801f376c6a8): calling ktype release
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.905779] kobject: 'cpufreq': free name
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.909423] CPU 1 is now offline
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.910253] kobject: 'index0' (ffff88046e0e4600): kobject_cleanup
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.910570] kobject: 'index0' (ffff88046e0e4600): does not have a release() function, it is broken and must be fixed.
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.911136] kobject: 'index0' (ffff88046e0e4600): auto cleanup 'remove' event
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.911491] kobject: 'index0' (ffff88046e0e4600): kobject_uevent_env
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.911827] kobject: 'index0' (ffff88046e0e4600): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index0'
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.912379] kobject: 'index0' (ffff88046e0e4600): auto cleanup kobject_del
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.912740] kobject: 'index0': free name
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.912971] kobject: 'index1' (ffff88046e0e4648): kobject_cleanup
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.913282] kobject: 'index1' (ffff88046e0e4648): does not have a release() function, it is broken and must be fixed.
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.913840] kobject: 'index1' (ffff88046e0e4648): auto cleanup 'remove' event
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.914194] kobject: 'index1' (ffff88046e0e4648): kobject_uevent_env
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.914520] kobject: 'index1' (ffff88046e0e4648): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index1'
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.915079] kobject: 'index1' (ffff88046e0e4648): auto cleanup kobject_del
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.915434] kobject: 'index1': free name
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.915668] kobject: 'index2' (ffff88046e0e4690): kobject_cleanup
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.915988] kobject: 'index2' (ffff88046e0e4690): does not have a release() function, it is broken and must be fixed.
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.916552] kobject: 'index2' (ffff88046e0e4690): auto cleanup 'remove' event
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.916913] kobject: 'index2' (ffff88046e0e4690): kobject_uevent_env
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.917240] kobject: 'index2' (ffff88046e0e4690): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index2'
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.917807] kobject: 'index2' (ffff88046e0e4690): auto cleanup kobject_del
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.918162] kobject: 'index2': free name
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.918397] kobject: 'index3' (ffff88046e0e46d8): kobject_cleanup
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.918781] kobject: 'index3' (ffff88046e0e46d8): does not have a release() function, it is broken and must be fixed.
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.919339] kobject: 'index3' (ffff88046e0e46d8): auto cleanup 'remove' event
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.919698] kobject: 'index3' (ffff88046e0e46d8): kobject_uevent_env
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.920025] kobject: 'index3' (ffff88046e0e46d8): fill_kobj_path: path = '/devices/system/cpu/cpu1/cache/index3'
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.920572] kobject: 'index3' (ffff88046e0e46d8): auto cleanup kobject_del
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.920931] kobject: 'index3': free name
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.921165] kobject: 'cache' (ffff8801f21ef600): kobject_cleanup
Jun  6 10:29:40 istl-vmc-blade9 kernel: [  807.921476] kobject: 'cache' (ffff8801f21ef600): does not have a release() function, it is broken and must be fixed.

--------------090100060109080504070306--

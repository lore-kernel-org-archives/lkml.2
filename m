Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab2LTT0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:26:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab2LTT0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:26:25 -0500
Date: Thu, 20 Dec 2012 14:26:23 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: CPU hotplug lockdep trace during offline.
Message-ID: <20121220192623.GA7093@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From Linus' tree as of a half hour ago.

echo 0 > /sys/devices/system/cpu/cpu1/online



[   67.675171] ======================================================
[   67.676121] [ INFO: possible circular locking dependency detected ]
[   67.677084] 3.7.0+ #34 Not tainted
[   67.677641] -------------------------------------------------------
[   67.678614] bash/604 is trying to acquire lock:
[   67.679326] blocked:  (cgroup_mutex){+.+.+.}, instance: ffffffff81c38278, at: [<ffffffff810cef77>] cgroup_lock+0x17/0x20
[   67.681220] 
but task is already holding lock:
[   67.682115] held:     (cpu_hotplug.lock){+.+.+.}, instance: ffffffff81c1f700, at: [<ffffffff81049ddf>] cpu_hotplug_begin+0x2f/0x60
[   67.684087] 
which lock already depends on the new lock.

[   67.685316] 
the existing dependency chain (in reverse order) is:
[   67.686450] 
-> #2 (cpu_hotplug.lock){+.+.+.}:
[   67.687183]        [<ffffffff810b84e2>] lock_acquire+0x92/0x1d0
[   67.688165]        [<ffffffff816a7713>] mutex_lock_nested+0x73/0x3b0
[   67.689186]        [<ffffffff81049ddf>] cpu_hotplug_begin+0x2f/0x60
[   67.690217]        [<ffffffff816986df>] _cpu_up+0x29/0x14b
[   67.691134]        [<ffffffff8169884f>] cpu_up+0x4e/0x5e
[   67.692025]        [<ffffffff81edf551>] smp_init+0x82/0xa3
[   67.692950]        [<ffffffff8168d214>] kernel_init+0xd4/0x2d0
[   67.693924]        [<ffffffff816b2b5c>] ret_from_fork+0x7c/0xb0
[   67.694921] 
-> #1 (cpu_add_remove_lock){+.+.+.}:
[   67.695791]        [<ffffffff810b84e2>] lock_acquire+0x92/0x1d0
[   67.696770]        [<ffffffff816a7713>] mutex_lock_nested+0x73/0x3b0
[   67.697814]        [<ffffffff81049f47>] cpu_maps_update_begin+0x17/0x20
[   67.698897]        [<ffffffff8168e406>] register_cpu_notifier+0x16/0x40
[   67.699973]        [<ffffffff8168f450>] mem_cgroup_css_alloc+0x450/0x6a0
[   67.701071]        [<ffffffff81edfde7>] cgroup_init_subsys+0x5e/0xf8
[   67.702112]        [<ffffffff81ee00ad>] cgroup_init+0x46/0x129
[   67.703076]        [<ffffffff81ec8bd9>] start_kernel+0x3cb/0x413
[   67.704071]        [<ffffffff81ec832d>] x86_64_start_reservations+0x131/0x135
[   67.705206]        [<ffffffff81ec8409>] x86_64_start_kernel+0xd8/0xdc
[   67.706266] 
-> #0 (cgroup_mutex){+.+.+.}:
[   67.707091]        [<ffffffff810b7daf>] __lock_acquire+0x1a7f/0x1b30
[   67.708133]        [<ffffffff810b84e2>] lock_acquire+0x92/0x1d0
[   67.709111]        [<ffffffff816a7713>] mutex_lock_nested+0x73/0x3b0
[   67.710129]        [<ffffffff810cef77>] cgroup_lock+0x17/0x20
[   67.711081]        [<ffffffff810d9599>] cpuset_update_active_cpus+0x19/0x160
[   67.712225]        [<ffffffff810891e7>] cpuset_cpu_inactive+0x47/0x50
[   67.713286]        [<ffffffff816ae6d6>] notifier_call_chain+0x66/0x150
[   67.714358]        [<ffffffff81078a2e>] __raw_notifier_call_chain+0xe/0x10
[   67.715425]        [<ffffffff81049d70>] __cpu_notify+0x20/0x40
[   67.716389]        [<ffffffff8168e0bd>] _cpu_down+0x8d/0x330
[   67.717306]        [<ffffffff8168e396>] cpu_down+0x36/0x50
[   67.718230]        [<ffffffff81691b1d>] store_online+0x5d/0xd0
[   67.719194]        [<ffffffff8143b1b8>] dev_attr_store+0x18/0x30
[   67.720186]        [<ffffffff81238440>] sysfs_write_file+0xe0/0x150
[   67.721224]        [<ffffffff811b8fef>] vfs_write+0xaf/0x180
[   67.722163]        [<ffffffff811b9335>] sys_write+0x55/0xa0
[   67.723095]        [<ffffffff816b2c02>] system_call_fastpath+0x16/0x1b
[   67.724142] 
other info that might help us debug this:

[   67.725345] Chain exists of:
  cgroup_mutex --> cpu_add_remove_lock --> cpu_hotplug.lock

[   67.745352]  Possible unsafe locking scenario:

[   67.758710]        CPU0                    CPU1
[   67.765527]        ----                    ----
[   67.772259]   lock(cpu_hotplug.lock);
[   67.778901]                                lock(cpu_add_remove_lock);
[   67.785983]                                lock(cpu_hotplug.lock);
[   67.792943]   lock(cgroup_mutex);
[   67.799358] 
 *** DEADLOCK ***

[   67.816718] 5 locks on stack by bash/604:
[   67.822496]  #0: held:     (&buffer->mutex){+.+.+.}, instance: ffff880108886518, at: [<ffffffff812383a7>] sysfs_write_file+0x47/0x150
[   67.829905]  #1: blocked:  (s_active#69){.+.+.+}, instance: ffff88012ce6cd60, at: [<ffffffff81238428>] sysfs_write_file+0xc8/0x150
[   67.837370]  #2: held:     (x86_cpu_hotplug_driver_mutex){+.+.+.}, instance: ffffffff81c1aef8, at: [<ffffffff8101e4b7>] cpu_hotplug_driver_lock+0x17/0x20
[   67.845512]  #3: held:     (cpu_add_remove_lock){+.+.+.}, instance: ffffffff81c1f638, at: [<ffffffff81049f47>] cpu_maps_update_begin+0x17/0x20
[   67.853640]  #4: held:     (cpu_hotplug.lock){+.+.+.}, instance: ffffffff81c1f700, at: [<ffffffff81049ddf>] cpu_hotplug_begin+0x2f/0x60
[   67.861874] 
stack backtrace:
[   67.874926] Pid: 604, comm: bash Not tainted 3.7.0+ #34
[   67.881886] Call Trace:
[   67.888481]  [<ffffffff8169f49d>] print_circular_bug+0x1fe/0x20f
[   67.895623]  [<ffffffff810b7daf>] __lock_acquire+0x1a7f/0x1b30
[   67.902779]  [<ffffffff810b8e6e>] ? mark_held_locks+0xae/0x110
[   67.909957]  [<ffffffff810b2ffe>] ? put_lock_stats.isra.23+0xe/0x40
[   67.917206]  [<ffffffff816aacb5>] ? _raw_spin_unlock_irqrestore+0x65/0x80
[   67.924565]  [<ffffffff810b84e2>] lock_acquire+0x92/0x1d0
[   67.931733]  [<ffffffff810cef77>] ? cgroup_lock+0x17/0x20
[   67.938894]  [<ffffffff816a7713>] mutex_lock_nested+0x73/0x3b0
[   67.946061]  [<ffffffff810cef77>] ? cgroup_lock+0x17/0x20
[   67.953171]  [<ffffffff810b907d>] ? trace_hardirqs_on+0xd/0x10
[   67.960330]  [<ffffffff810cef77>] ? cgroup_lock+0x17/0x20
[   67.967439]  [<ffffffff8101df26>] ? native_send_call_func_single_ipi+0x36/0x40
[   67.974840]  [<ffffffff810c04c1>] ? generic_exec_single+0xb1/0xc0
[   67.982097]  [<ffffffff810cef77>] cgroup_lock+0x17/0x20
[   67.989262]  [<ffffffff810d9599>] cpuset_update_active_cpus+0x19/0x160
[   67.996640]  [<ffffffff810c3ff2>] ? __module_address+0xf2/0x130
[   68.003933]  [<ffffffff810b394e>] ? __lock_is_held+0x5e/0x90
[   68.011206]  [<ffffffff810891e7>] cpuset_cpu_inactive+0x47/0x50
[   68.018485]  [<ffffffff816ae6d6>] notifier_call_chain+0x66/0x150
[   68.025765]  [<ffffffff81078a2e>] __raw_notifier_call_chain+0xe/0x10
[   68.033047]  [<ffffffff81049d70>] __cpu_notify+0x20/0x40
[   68.040181]  [<ffffffff8168e0bd>] _cpu_down+0x8d/0x330
[   68.047281]  [<ffffffff8168e396>] cpu_down+0x36/0x50
[   68.054328]  [<ffffffff81691b1d>] store_online+0x5d/0xd0
[   68.061400]  [<ffffffff8143b1b8>] dev_attr_store+0x18/0x30
[   68.068489]  [<ffffffff81238440>] sysfs_write_file+0xe0/0x150
[   68.075618]  [<ffffffff811b8fef>] vfs_write+0xaf/0x180
[   68.082647]  [<ffffffff811b9335>] sys_write+0x55/0xa0
[   68.089623]  [<ffffffff816b2c02>] system_call_fastpath+0x16/0x1b


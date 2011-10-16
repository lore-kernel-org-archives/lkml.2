Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab1JPK5k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 06:57:40 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:64860 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab1JPK5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 06:57:37 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-users@vger.kernel.org, tglx@linutronix.de
Subject: [RFC] [PATCH -rt 5/5] cpufreq: get rid of get_online_cpus()/put_online_cpus()
Date: Sun, 16 Oct 2011 18:56:47 +0800
Message-Id: <1318762607-2261-6-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1318762607-2261-1-git-send-email-yong.zhang0@gmail.com>
References: <1318762607-2261-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below false positive (seems this is not a real deadlock scenario)
lockdep warning:

=======================================================
[ INFO: possible circular locking dependency detected ]
3.0.6-rt18-00293-g6f698ae-dirty #24
-------------------------------------------------------
bash/1709 is trying to acquire lock:
 (s_active#103){++++.+}, at: [<c02ab4a3>] sysfs_addrm_finish+0x33/0x60

but task is already holding lock:
 (cpu_hotplug.lock){+.+.+.}, at: [<c0150530>] cpu_hotplug_begin+0x20/0x50

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #2 (cpu_hotplug.lock){+.+.+.}:
       [<c018ba31>] validate_chain.clone.20+0x701/0x810
       [<c018e1c4>] __lock_acquire+0x3b4/0x8d0
       [<c018eda8>] lock_acquire+0x88/0x1b0
       [<c0736b48>] _mutex_lock+0x38/0x50
       [<c01506a1>] get_online_cpus+0x31/0x50
       [<c05ea533>] cpufreq_add_dev_interface+0x103/0x270
       [<c05ea9ac>] cpufreq_add_dev+0x30c/0x410
       [<c0524aa1>] sysdev_driver_register+0xb1/0x140
       [<c05e988e>] cpufreq_register_driver+0x8e/0x150
       [<c0a25e92>] acpi_cpufreq_init+0x78/0x8b
       [<c0101225>] do_one_initcall+0x35/0x170
       [<c09f5852>] kernel_init+0xb8/0x14e
       [<c073e742>] kernel_thread_helper+0x6/0x10

-> #1 (&(*({ do { const void *__vpp_verify = (typeof((&(cpu_policy_rwsem))))((void *)0); (void)__vpp_verify; } while (0); ({ unsigned long __ptr; __asm__ ("" : "=r"(__ptr) : "0"((typeof(*(&(cpu_policy_rwsem))) *)(&(cpu_policy_rwsem)))); (typeof((typeof(*(&(cpu_policy_rwsem))) *)(&(cpu_policy_rwsem)))) (__ptr + (((__per_cpu_offset[cpu])))); }); }))){+++++.}:
       [<c018ba31>] validate_chain.clone.20+0x701/0x810
       [<c018e1c4>] __lock_acquire+0x3b4/0x8d0
       [<c018eda8>] lock_acquire+0x88/0x1b0
       [<c0195f66>] __rt_down_read+0x36/0x60
       [<c0195faf>] rt_down_read+0xf/0x20
       [<c05e975f>] lock_policy_rwsem_read+0x3f/0x80
       [<c05ea3f4>] show+0x34/0x70
       [<c02a9fb7>] sysfs_read_file+0x87/0x130
       [<c024522f>] vfs_read+0x9f/0x170
       [<c0245348>] sys_read+0x48/0x80
       [<c073e15f>] sysenter_do_call+0x12/0x38

-> #0 (s_active#103){++++.+}:
       [<c018b2fa>] check_prev_add+0x5fa/0x630
       [<c018ba31>] validate_chain.clone.20+0x701/0x810
       [<c018e1c4>] __lock_acquire+0x3b4/0x8d0
       [<c018eda8>] lock_acquire+0x88/0x1b0
       [<c02aac85>] sysfs_deactivate+0xc5/0x120
       [<c02ab4a3>] sysfs_addrm_finish+0x33/0x60
       [<c02aba0a>] sysfs_remove_dir+0x6a/0x80
       [<c03bab3f>] kobject_del+0xf/0x30
       [<c03babbf>] kobject_release+0x5f/0x80
       [<c03bbf3d>] kref_put+0x2d/0x60
       [<c03baa7d>] kobject_put+0x1d/0x50
       [<c05eab6e>] __cpufreq_remove_dev+0xbe/0x260
       [<c07339f3>] cpufreq_cpu_callback+0x70/0x83
       [<c073ac5a>] notifier_call_chain+0x7a/0xa0
       [<c017a3fe>] __raw_notifier_call_chain+0x1e/0x30
       [<c0150494>] __cpu_notify+0x24/0x40
       [<c071b7c1>] _cpu_down+0x151/0x350
       [<c071b9f0>] cpu_down+0x30/0x50
       [<c071d550>] store_online+0x50/0xa7
       [<c052466a>] sysdev_store+0x2a/0x40
       [<c02a9ed4>] sysfs_write_file+0xa4/0x100
       [<c02450c2>] vfs_write+0xa2/0x170
       [<c02453c8>] sys_write+0x48/0x80
       [<c073e15f>] sysenter_do_call+0x12/0x38

other info that might help us debug this:

Chain exists of:
  s_active --> &(*({ do { const void *__vpp_verify = (typeof((&(cpu_policy_rwsem))))((void *)0); (void)__vpp_verify; } while (0); ({ unsigned long __ptr; __asm__ ("" : "=r"(__ptr) : "0"((typeof(*(&(cpu_policy_rwsem))) *)(&(cpu_policy_rwsem)))); (typeof((typeof(*(&(cpu_policy_rwsem))) *)(&(cpu_policy_rwsem)))) (__ptr + (((__per_cpu_offset[cpu])))); }); })) --> cpu_hotplug.lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(cpu_hotplug.lock);
                               lock(&(*({ do { const void *__vpp_verify = (typeof((&(cpu_policy_rwsem))))((void *)0); (void)__vpp_verify; } while (0); ({ unsigned long __ptr; __asm__ ("" : "=r"(__ptr) : "0"((typeof(*(&(cpu_policy_rwsem))) *)(&(cpu_policy_rwsem)))); (typeof((typeof(*(&(cpu_policy_rwsem))) *)(&(cpu_policy_rwsem)))) (__ptr + (((__per_cpu_offset[cpu])))); }); })));
                               lock(cpu_hotplug.lock);
  lock(s_active);

 *** DEADLOCK ***

5 locks held by bash/1709:
 #0:  (&buffer->mutex){+.+.+.}, at: [<c02a9e57>] sysfs_write_file+0x27/0x100
 #1:  (s_active#119){.+.+.+}, at: [<c02a9eb9>] sysfs_write_file+0x89/0x100
 #2:  (x86_cpu_hotplug_driver_mutex){+.+.+.}, at: [<c011dc42>] cpu_hotplug_driver_lock+0x12/0x20
 #3:  (cpu_add_remove_lock){+.+.+.}, at: [<c01506d2>] cpu_maps_update_begin+0x12/0x20
 #4:  (cpu_hotplug.lock){+.+.+.}, at: [<c0150530>] cpu_hotplug_begin+0x20/0x50

stack backtrace:
Pid: 1709, comm: bash Not tainted 3.0.6-rt18-00293-g6f698ae-dirty #24
Call Trace:
 [<c0733d94>] ? printk+0x1d/0x21
 [<c018a28f>] print_circular_bug+0xcf/0xe0
 [<c018b2fa>] check_prev_add+0x5fa/0x630
 [<c018bfd9>] ? mark_lock_irq+0xc9/0x270
 [<c018ba31>] validate_chain.clone.20+0x701/0x810
 [<c018e1c4>] __lock_acquire+0x3b4/0x8d0
 [<c018ef24>] ? lockdep_init_map+0x54/0x4e0
 [<c018eda8>] lock_acquire+0x88/0x1b0
 [<c02ab4a3>] ? sysfs_addrm_finish+0x33/0x60
 [<c02aac85>] sysfs_deactivate+0xc5/0x120
 [<c02ab4a3>] ? sysfs_addrm_finish+0x33/0x60
 [<c0234382>] ? unlock_slab_and_free_delayed.clone.25+0x92/0xc0
 [<c0234382>] ? unlock_slab_and_free_delayed.clone.25+0x92/0xc0
 [<c02ab4a3>] sysfs_addrm_finish+0x33/0x60
 [<c02aba0a>] sysfs_remove_dir+0x6a/0x80
 [<c03bab3f>] kobject_del+0xf/0x30
 [<c03babbf>] kobject_release+0x5f/0x80
 [<c03bab60>] ? kobject_del+0x30/0x30
 [<c03bbf3d>] kref_put+0x2d/0x60
 [<c03baa7d>] kobject_put+0x1d/0x50
 [<c073620d>] ? rt_mutex_unlock+0xd/0x10
 [<c01961f2>] ? rt_up_write+0x22/0x30
 [<c05e918d>] ? unlock_policy_rwsem_write+0x2d/0x40
 [<c05eab6e>] __cpufreq_remove_dev+0xbe/0x260
 [<c019614b>] ? rt_down_write_trylock+0x4b/0x60
 [<c07339f3>] cpufreq_cpu_callback+0x70/0x83
 [<c073ac5a>] notifier_call_chain+0x7a/0xa0
 [<c017a3fe>] __raw_notifier_call_chain+0x1e/0x30
 [<c0150494>] __cpu_notify+0x24/0x40
 [<c071b7c1>] _cpu_down+0x151/0x350
 [<c071b9f0>] cpu_down+0x30/0x50
 [<c071d550>] store_online+0x50/0xa7
 [<c071d500>] ? acpi_os_map_memory+0xf2/0xf2
 [<c052466a>] sysdev_store+0x2a/0x40
 [<c02a9ed4>] sysfs_write_file+0xa4/0x100
 [<c02450c2>] vfs_write+0xa2/0x170
 [<c02a9e30>] ? sysfs_poll+0x90/0x90
 [<c02453c8>] sys_write+0x48/0x80
 [<c073e15f>] sysenter_do_call+0x12/0x38

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 drivers/cpufreq/cpufreq.c |   20 +++++++-------------
 1 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 7741f0f..8561182 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -821,16 +821,14 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 			goto err_out_kobj_put;
 	}
 
-	get_online_cpus();
+	raw_spin_lock_irqsave(&cpufreq_driver_lock, flags);
 	for_each_cpu(j, policy->cpus) {
 		if (!cpu_online(j))
 			continue;
-		raw_spin_lock_irqsave(&cpufreq_driver_lock, flags);
 		per_cpu(cpufreq_cpu_data, j) = policy;
 		per_cpu(cpufreq_policy_cpu, j) = policy->cpu;
-		raw_spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 	}
-	put_online_cpus();
+	raw_spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	ret = cpufreq_add_dev_symlink(cpu, policy);
 	if (ret)
@@ -972,13 +970,11 @@ static int cpufreq_add_dev(struct sys_device *sys_dev)
 
 
 err_out_unregister:
-	get_online_cpus();
+	raw_spin_lock_irqsave(&cpufreq_driver_lock, flags);
 	for_each_cpu(j, policy->cpus) {
-		raw_spin_lock_irqsave(&cpufreq_driver_lock, flags);
 		per_cpu(cpufreq_cpu_data, j) = NULL;
-		raw_spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 	}
-	put_online_cpus();
+	raw_spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	kobject_put(&policy->kobj);
 	wait_for_completion(&policy->kobj_unregister);
@@ -1045,7 +1041,6 @@ static int __cpufreq_remove_dev(struct sys_device *sys_dev)
 	}
 #endif
 
-	raw_spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 #ifdef CONFIG_SMP
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -1058,17 +1053,14 @@ static int __cpufreq_remove_dev(struct sys_device *sys_dev)
 	 * per_cpu(cpufreq_cpu_data) while holding the lock, and remove
 	 * the sysfs links afterwards.
 	 */
-	get_online_cpus();
 	if (unlikely(cpumask_weight(data->cpus) > 1)) {
 		for_each_cpu(j, data->cpus) {
 			if (j == cpu)
 				continue;
-			raw_spin_lock_irqsave(&cpufreq_driver_lock, flags);
 			per_cpu(cpufreq_cpu_data, j) = NULL;
-			raw_spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 		}
 	}
-	put_online_cpus();
+	raw_spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	if (unlikely(cpumask_weight(data->cpus) > 1)) {
 		for_each_cpu(j, data->cpus) {
@@ -1087,6 +1079,8 @@ static int __cpufreq_remove_dev(struct sys_device *sys_dev)
 			cpufreq_cpu_put(data);
 		}
 	}
+#else
+	raw_spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 #endif
 
 	if (cpufreq_driver->target)
-- 
1.7.1


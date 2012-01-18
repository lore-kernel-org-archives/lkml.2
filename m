Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab2ARMOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 07:14:45 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54325 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab2ARMOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 07:14:43 -0500
Date: Wed, 18 Jan 2012 15:10:50 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] Sched fair: check that ilb cpu is online during
 nohz_balancer_kick()
Message-ID: <20120118121049.GA4258@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sched fair: check that ilb cpu is online during nohz_balancer_kick()

find_new_ilb() may return offlined cpu if trigger_load_balance() occurs while machine
suspending or resuming, hitting native_smp_send_reschedule() assertion failure:
[  108.473465] Disabling non-boot CPUs ...
[  108.477308] CPU 1 is now offline
[  108.477497] ------------[ cut here ]------------
[  108.477523] WARNING: at arch/x86/kernel/smp.c:120 native_smp_send_reschedule+0x25/0x56()
[  108.477724] Call Trace:
[  108.477736]  <IRQ>  [<ffffffff81030092>] warn_slowpath_common+0x7e/0x96
[  108.477772]  [<ffffffff810300bf>] warn_slowpath_null+0x15/0x17
[  108.477795]  [<ffffffff81018ff7>] native_smp_send_reschedule+0x25/0x56
[  108.477823]  [<ffffffff81067ffe>] trigger_load_balance+0x6ac/0x72e
[  108.477847]  [<ffffffff81067bfd>] ? trigger_load_balance+0x2ab/0x72e
[  108.477874]  [<ffffffff8105f05c>] scheduler_tick+0xe2/0xeb
[  108.477899]  [<ffffffff8103f6ac>] update_process_times+0x60/0x70
[  108.477926]  [<ffffffff8107c1e1>] tick_sched_timer+0x6d/0x96
[  108.477951]  [<ffffffff81053b3b>] __run_hrtimer+0x1c2/0x3a1
[  108.477974]  [<ffffffff8107c174>] ? tick_nohz_handler+0xdf/0xdf
[  108.477999]  [<ffffffff81054721>] hrtimer_interrupt+0xe6/0x1b0
[  108.478023]  [<ffffffff81019bdd>] smp_apic_timer_interrupt+0x80/0x93
[  108.478051]  [<ffffffff814a2f73>] apic_timer_interrupt+0x73/0x80
[  108.478072]  <EOI>  [<ffffffff8148f763>] ? slab_cpuup_callback+0xa8/0xdb
[  108.478108]  [<ffffffff8149f154>] notifier_call_chain+0x86/0xb3
[  108.478133]  [<ffffffff8147f09f>] ? spp_getpage+0x5f/0x5f
[  108.478157]  [<ffffffff810556d9>] __raw_notifier_call_chain+0x9/0xb
[  108.478182]  [<ffffffff81031857>] __cpu_notify+0x1b/0x2d
[  108.478204]  [<ffffffff81031962>] cpu_notify_nofail+0xe/0x16
[  108.478227]  [<ffffffff8147f1fd>] _cpu_down+0x130/0x249
[  108.478249]  [<ffffffff814920ef>] ? printk+0x4c/0x4e
[  108.478271]  [<ffffffff810319f6>] disable_nonboot_cpus+0x5a/0xfc
[  108.478297]  [<ffffffff8106f000>] suspend_devices_and_enter+0x19a/0x407
[  108.478323]  [<ffffffff8106f391>] enter_state+0x124/0x169
[  108.478346]  [<ffffffff8106e01b>] state_store+0xb7/0x101
[  108.478373]  [<ffffffff8126c82f>] kobj_attr_store+0x17/0x19
[  108.478399]  [<ffffffff8117e20c>] sysfs_write_file+0x103/0x13f
[  108.478425]  [<ffffffff8111f018>] vfs_write+0xad/0x13d
[  108.478447]  [<ffffffff8111f293>] sys_write+0x45/0x6c
[  108.478469]  [<ffffffff814a2439>] system_call_fastpath+0x16/0x1b
[  108.478492] ---[ end trace 991823fa9b0a0b79 ]---

Check that returned by find_new_ilb() cpu is online.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 84adb2d..070b8e0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4826,7 +4826,7 @@ unlock:
 	rcu_read_unlock();
 
 out_done:
-	if (ilb < nr_cpu_ids && idle_cpu(ilb))
+	if (likely(cpu_online(ilb)) && ilb < nr_cpu_ids && idle_cpu(ilb))
 		return ilb;
 
 	return nr_cpu_ids;


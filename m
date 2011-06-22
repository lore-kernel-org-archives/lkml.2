Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab1FVL5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 07:57:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757377Ab1FVL5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 07:57:12 -0400
Subject: [rfc patch] x86,apic: fix DEBUG_PREEMPT gripe when booting with
 threadirqs=1
From: Mike Galbraith <mgalbraith@suse.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 13:57:05 +0200
Message-ID: <1308743825.8568.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86,apic: fix DEBUG_PREEMPT gripe when booting with threadirqs=1

If CONFIG_PREEMPT and CONFIG_INTR_REMAP are both set, and a box is
booted with threadirqs, the gripe below is emitted.  It was suggested
that native_smp_prepare_cpus() shouldn't need to be run with preemption
disabled, and indeed, box boots with no hint of trouble.  Remove it.

[    0.131359] Enabled Interrupt-remapping
[    0.135197] Switched APIC routing to physical flat.
[    0.140350] BUG: scheduling while atomic: swapper/1/0x00000002
[    0.146179] Modules linked in:
[    0.146182] Pid: 1, comm: swapper Not tainted 3.0.0-tip-smp #3
[    0.146183] Call Trace:
[    0.146191]  [<ffffffff8107269c>] __schedule_bug+0x5c/0x60
[    0.146195]  [<ffffffff8173f812>] schedule+0x7e2/0xa80
[    0.146201]  [<ffffffff81401200>] ? wait_for_xmitr+0xa0/0xa0
[    0.146205]  [<ffffffff8134a3e0>] ? delay_tsc+0x90/0xe0
[    0.146208]  [<ffffffff817400e5>] schedule_timeout+0x1b5/0x210
[    0.146211]  [<ffffffff8106f7a0>] ? hrtick_update+0x30/0x40
[    0.146214]  [<ffffffff8173eef0>] wait_for_common+0xc0/0x150
[    0.146218]  [<ffffffff81077cc0>] ? try_to_wake_up+0x270/0x270
[    0.146221]  [<ffffffff8173f028>] wait_for_completion+0x18/0x20
[    0.146225]  [<ffffffff8109b3cf>] kthread_create_on_node+0x9f/0x120
[    0.146229]  [<ffffffff810d72b0>] ? irq_finalize_oneshot+0x120/0x120
[    0.146234]  [<ffffffff8134dcfe>] ? bitmap_find_next_zero_area+0x3e/0x90
[    0.146237]  [<ffffffff81741e02>] ? _raw_spin_lock_irqsave+0x22/0x50
[    0.146240]  [<ffffffff810d831d>] __setup_irq+0x15d/0x3e0
[    0.146243]  [<ffffffff810d9447>] ? __irq_set_handler+0x87/0x130
[    0.146248]  [<ffffffff81375ee0>] ? __dmar_enable_qi+0xf0/0xf0
[    0.146250]  [<ffffffff810d869c>] request_threaded_irq+0xfc/0x160
[    0.146254]  [<ffffffff8137705a>] dmar_set_interrupt+0x7a/0xd0
[    0.146257]  [<ffffffff81cd5ba8>] enable_drhd_fault_handling+0x1c/0x59
[    0.146262]  [<ffffffff81cb889c>] bsp_end_local_APIC_setup+0x17/0x19
[    0.146265]  [<ffffffff81cb6986>] native_smp_prepare_cpus+0x310/0x3f9
[    0.146268]  [<ffffffff81ca9bfa>] kernel_init+0x77/0x168
[    0.146273]  [<ffffffff817482d4>] kernel_thread_helper+0x4/0x10
[    0.146276]  [<ffffffff81ca9b83>] ? start_kernel+0x374/0x374
[    0.146279]  [<ffffffff817482d0>] ? gs_change+0xb/0xb

Signed-off-by: Mike Galbraith <efault@gmx.de>

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 9fd3137..5c81fd3 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1032,7 +1032,6 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 {
 	unsigned int i;
 
-	preempt_disable();
 	smp_cpu_index_default();
 
 	/*
@@ -1054,7 +1053,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	if (smp_sanity_check(max_cpus) < 0) {
 		printk(KERN_INFO "SMP disabled\n");
 		disable_smp();
-		goto out;
+		return;
 	}
 
 	default_setup_apic_routing();
@@ -1098,8 +1097,6 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 		uv_system_init();
 
 	set_mtrr_aps_delayed_init();
-out:
-	preempt_enable();
 }
 
 void arch_disable_nonboot_cpus_begin(void)



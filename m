Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab1DOL6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 07:58:05 -0400
Received: from blu0-omc1-s9.blu0.hotmail.com ([65.55.116.20]:31195 "EHLO
	blu0-omc1-s9.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754036Ab1DOL6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 07:58:04 -0400
Message-ID: <BLU157-w375975826B182E04BE379ADAAC0@phx.gbl>
X-Originating-IP: [121.0.29.243]
From: MaoXiaoyun <tinnycloud@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: [patch] x86, mm: avoid stale tlb entries by clearing prev
 mm_cpumask after switching mm
Date: Fri, 15 Apr 2011 19:58:02 +0800
Importance: Normal
In-Reply-To: <BLU157-w548B9D2F8EDD8CA9DB6CD3DAAC0@phx.gbl>
References: <BLU157-w495F35A445E063E33DC9E8DAAC0@phx.gbl>,<BLU157-w41A610FD3413183801060CDAAC0@phx.gbl>,<BLU157-w548B9D2F8EDD8CA9DB6CD3DAAC0@phx.gbl>
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-OriginalArrivalTime: 15 Apr 2011 11:58:02.0939 (UTC) FILETIME=[5F9988B0:01CBFB64]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org







Hi:

Recently I've met a kernel bug. 
Kernel version: 2.6.32.26, from git.kernel.org/?p=linux/kernel/git/jeremy/xen.git;a=commit;h=bb1a15e55ec665a64c8a9c6bd699b1f16ac01f
I think the crash might related to this patch.
Since now TLB state change to TLBSTATE_OK(mmu_context.h:40) is before cpumask_clear_cpu(line 49).
Could it possible that right after execute line 40 of mmu_context.h, 
CPU go to IPI interrupt to try to flush the mm, but find the TLB state happened to be TLBSTATE_OK.

Crash log attached. 
Thanks.

arch/x86/include/asm/mmu_context.h

33 static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
34 <+++<+++<+++ struct task_struct *tsk)
35 {
36 <+++unsigned cpu = smp_processor_id();
37 
38 <+++if (likely(prev != next)) {
39 #ifdef CONFIG_SMP
40 <+++<+++percpu_write(cpu_tlbstate.state, TLBSTATE_OK);
41 <+++<+++percpu_write(cpu_tlbstate.active_mm, next);
42 #endif
43 <+++<+++cpumask_set_cpu(cpu, mm_cpumask(next));
44 
45 <+++<+++/* Re-load page tables */
46 <+++<+++load_cr3(next->pgd);
47 
48 <+++<+++/* stop flush ipis for the previous mm */
49 <+++<+++cpumask_clear_cpu(cpu, mm_cpumask(prev)); 



===============crash log==========================
INIT: Id "s0" respawning too fast: disabled for 5 minutes
__ratelimit: 14 callbacks suppressed
blktap_sysfs_destroy
blktap_sysfs_destroy
------------[ cut here ]------------
kernel BUG at arch/x86/mm/tlb.c:61!
invalid opcode: 0000 [#1] SMP 
last sysfs file: /sys/devices/system/xen_memory/xen_memory0/info/current_kb
CPU 1 
Modules linked in: 8021q garp xen_netback xen_blkback blktap blkback_pagemap nbd bridge stp llc autofs4 ipmi_devintf ipmi_si ipmi_msghandler lockd sunrpc bonding ipv6 xenfs dm_multipath video output sbs sbshc parport_pc lp parport ses enclosure snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device serio_raw bnx2 snd_pcm_oss snd_mixer_oss snd_pcm snd_timer iTCO_wdt snd soundcore snd_page_alloc i2c_i801 iTCO_vendor_support i2c_core pcspkr pata_acpi ata_generic ata_piix shpchp mptsas mptscsih mptbase [last unloaded: freq_table]
Pid: 25581, comm: khelper Not tainted 2.6.32.36fixxen #1 Tecal RH2285 
RIP: e030:[<ffffffff8103a3cb>] [<ffffffff8103a3cb>] leave_mm+0x15/0x46
RSP: e02b:ffff88002805be48 EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffff88015f8e2da0
RDX: ffff88002805be78 RSI: 0000000000000000 RDI: 0000000000000001
RBP: ffff88002805be48 R08: ffff88009d662000 R09: dead000000200200
R10: dead000000100100 R11: ffffffff814472b2 R12: ffff88009bfc1880
R13: ffff880028063020 R14: 00000000000004f6 R15: 0000000000000000
FS: 00007f62362d66e0(0000) GS:ffff880028058000(0000) knlGS:0000000000000000
CS: e033 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003aabc11909 CR3: 000000009b8ca000 CR4: 0000000000002660
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khelper (pid: 25581, threadinfo ffff88007691e000, task ffff88009b92db40)
Stack:
ffff88002805be68 ffffffff8100e4ae 0000000000000001 ffff88009d733b88
<0> ffff88002805be98 ffffffff81087224 ffff88002805be78 ffff88002805be78
<0> ffff88015f808360 00000000000004f6 ffff88002805bea8 ffffffff81010108
Call Trace:
<IRQ> 
[<ffffffff8100e4ae>] drop_other_mm_ref+0x2a/0x53
[<ffffffff81087224>] generic_smp_call_function_single_interrupt+0xd8/0xfc
[<ffffffff81010108>] xen_call_function_single_interrupt+0x13/0x28
[<ffffffff810a936a>] handle_IRQ_event+0x66/0x120
[<ffffffff810aac5b>] handle_percpu_irq+0x41/0x6e
[<ffffffff8128c1c0>] __xen_evtchn_do_upcall+0x1ab/0x27d
[<ffffffff8128dd11>] xen_evtchn_do_upcall+0x33/0x46
[<ffffffff81013efe>] xen_do_hypervisor_callback+0x1e/0x30
<EOI> 
[<ffffffff814472b2>] ? _spin_unlock_irqrestore+0x15/0x17
[<ffffffff8100f8cf>] ? xen_restore_fl_direct_end+0x0/0x1
[<ffffffff81113f71>] ? flush_old_exec+0x3ac/0x500
[<ffffffff81150dc5>] ? load_elf_binary+0x0/0x17ef
[<ffffffff81150dc5>] ? load_elf_binary+0x0/0x17ef
[<ffffffff8115115d>] ? load_elf_binary+0x398/0x17ef
[<ffffffff81042fcf>] ? need_resched+0x23/0x2d
[<ffffffff811f4648>] ? process_measurement+0xc0/0xd7
[<ffffffff81150dc5>] ? load_elf_binary+0x0/0x17ef
[<ffffffff81113094>] ? search_binary_handler+0xc8/0x255
[<ffffffff81114362>] ? do_execve+0x1c3/0x29e
[<ffffffff8101155d>] ? sys_execve+0x43/0x5d
[<ffffffff8106fc45>] ? __call_usermodehelper+0x0/0x6f
[<ffffffff81013e28>] ? kernel_execve+0x68/0xd0
[<ffffffff8106fc45>] ? __call_usermodehelper+0x0/0x6f
[<ffffffff8100f8cf>] ? xen_restore_fl_direct_end+0x0/0x1
[<ffffffff8106fb64>] ? ____call_usermodehelper+0x113/0x11e
[<ffffffff81013daa>] ? child_rip+0xa/0x20
[<ffffffff8106fc45>] ? __call_usermodehelper+0x0/0x6f
[<ffffffff81012f91>] ? int_ret_from_sys_call+0x7/0x1b
[<ffffffff8101371d>] ? retint_restore_args+0x5/0x6
[<ffffffff81013da0>] ? child_rip+0x0/0x20
Code: 41 5e 41 5f c9 c3 55 48 89 e5 0f 1f 44 00 00 e8 17 ff ff ff c9 c3 55 48 89 e5 0f 1f 44 00 00 65 8b 04 25 c8 55 01 00 ff c8 75 04 <0f> 0b eb fe 65 48 8b 34 25 c0 55 01 00 48 81 c6 b8 02 00 00 e8 
RIP [<ffffffff8103a3cb>] leave_mm+0x15/0x46
RSP <ffff88002805be48>
---[ end trace ce9cee6832a9c503 ]---
Kernel panic - not syncing: Fatal exception in interrupt
Pid: 25581, comm: khelper Tainted: G D 2.6.32.36fixxen #1
Call Trace:
<IRQ> [<ffffffff8105682e>] panic+0xe0/0x19a
[<ffffffff8144008a>] ? init_amd+0x296/0x37a
[<ffffffff8100f17d>] ? xen_force_evtchn_callback+0xd/0xf
[<ffffffff8100f8e2>] ? check_events+0x12/0x20
[<ffffffff8100f8cf>] ? xen_restore_fl_direct_end+0x0/0x1
[<ffffffff81056487>] ? print_oops_end_marker+0x23/0x25
[<ffffffff81448185>] oops_end+0xb6/0xc6
[<ffffffff810166e5>] die+0x5a/0x63
[<ffffffff81447a5c>] do_trap+0x115/0x124
[<ffffffff810148e6>] do_invalid_op+0x9c/0xa5
[<ffffffff8103a3cb>] ? leave_mm+0x15/0x46
[<ffffffff8100f6fa>] ? xen_clocksource_read+0x21/0x23
[<ffffffff8100f26c>] ? HYPERVISOR_vcpu_op+0xf/0x11
[<ffffffff8100f767>] ? xen_vcpuop_set_next_event+0x52/0x67
[<ffffffff81080bfa>] ? clockevents_program_event+0x78/0x81
[<ffffffff81013b3b>] invalid_op+0x1b/0x20
[<ffffffff814472b2>] ? _spin_unlock_irqrestore+0x15/0x17
[<ffffffff8103a3cb>] ? leave_mm+0x15/0x46
[<ffffffff8100e4ae>] drop_other_mm_ref+0x2a/0x53
[<ffffffff81087224>] generic_smp_call_function_single_interrupt+0xd8/0xfc
[<ffffffff81010108>] xen_call_function_single_interrupt+0x13/0x28
[<ffffffff810a936a>] handle_IRQ_event+0x66/0x120
[<ffffffff810aac5b>] handle_percpu_irq+0x41/0x6e
[<ffffffff8128c1c0>] __xen_evtchn_do_upcall+0x1ab/0x27d
[<ffffffff8128dd11>] xen_evtchn_do_upcall+0x33/0x46
[<ffffffff81013efe>] xen_do_hypervisor_callback+0x1e/0x30
<EOI> [<ffffffff814472b2>] ? _spin_unlock_irqrestore+0x15/0x17
[<ffffffff8100f8cf>] ? xen_restore_fl_direct_end+0x0/0x1
[<ffffffff81113f71>] ? flush_old_exec+0x3ac/0x500
[<ffffffff81150dc5>] ? load_elf_binary+0x0/0x17ef
[<ffffffff81150dc5>] ? load_elf_binary+0x0/0x17ef
[<ffffffff8115115d>] ? load_elf_binary+0x398/0x17ef
[<ffffffff81042fcf>] ? need_resched+0x23/0x2d
[<ffffffff811f4648>] ? process_measurement+0xc0/0xd7
[<ffffffff81150dc5>] ? load_elf_binary+0x0/0x17ef
[<ffffffff81113094>] ? search_binary_handler+0xc8/0x255
[<ffffffff81114362>] ? do_execve+0x1c3/0x29e
[<ffffffff8101155d>] ? sys_execve+0x43/0x5d
[<ffffffff8106fc45>] ? __call_usermodehelper+0x0/0x6f
[<ffffffff81013e28>] ? kernel_execve+0x68/0xd0
[<ffffffff8106fc45>] ? __call_usermodehelper+0x0/0x6f
[<ffffffff8100f8cf>] ? xen_restore_fl_direct_end+0x0/0x1
[<ffffffff8106fb64>] ? ____call_usermodehelper+0x113/0x11e
[<ffffffff81013daa>] ? child_rip+0xa/0x20
[<ffffffff8106fc45>] ? __call_usermodehelper+0x0/0x6f
[<ffffffff81012f91>] ? int_ret_from_sys_call+0x7/0x1b
[<ffffffff8101371d>] ? retint_restore_args+0x5/0x6
[<ffffffff81013da0>] ? child_rip+0x0/0x20 		 	   		  

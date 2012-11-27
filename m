Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab2K0XUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 18:20:19 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:42712 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab2K0XUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 18:20:13 -0500
MIME-Version: 1.0
In-Reply-To: <20121127145505.GA14805@redhat.com>
References: <CAGXD9OfAMUmrdFBap3aOYXOhXE6=i8qL7=+SsJYnrdEr3kyMKw@mail.gmail.com>
	<20121127145505.GA14805@redhat.com>
Date: Tue, 27 Nov 2012 15:20:11 -0800
Message-ID: <CAGXD9OeokxUx_2WdpkYthyrYc52SCvne=H9vi45p_6ovo6EGpQ@mail.gmail.com>
Subject: Re: vmalloc_sync_all(), 64bit kernel, patches 9c48f1c629ecfa114850c03f875c6691003214de,
 a79e53d85683c6dd9f99c90511028adc2043031f
From: Prasad Koya <prasad.koya@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: aarcange@redhat.com, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In one of our test cases that test if we are properly entering
craskkernel, I'm seeing lockup inside sync_global_pgds(). This is with
2.6.38.8. sync_global_pgds() is called by vmalloc_sync_all(). Here is
the call chain:

machine_crash_shutdown -> native_machine_crash_shutdown ->
nmi_shootdown_cpus -> register_die_notifier -> vmalloc_sync_all. Below
is the backtrace with 2.6.38 with the issue reproduced.

There are no virtual machines involved. I'm suspecting if
sync_global_pgds() is trying to spin on page_table_lock that is taken
inside handle_pte_fault().


ame=SCSI_DISPATCH_CMD cpoint_type=LOOP cpoint_count=1smod /tmp/lkdtm.ko cpoint_n
/mnt/flash/DELIBERATE KERNEL CRASH
cat /mnt/usb/text > /dev/null
-bash-4.1# [  142.124878] Call Trace:
[  142.128009] [<ffffffffa007a14d>] ? lkdtm_do_action+0x12/0x198 [lkdtm]
cat /mnt/flash/E[  142.128009] [<ffffffff8102b74b>] ? get_parent_ip+0x11/0x41
[  142.128009] [<ffffffffa007a438>] ? lkdtm_handler+0x70/0x7e [lkdtm]
[  142.128009] [<ffffffffa007a44f>] ? jp_scsi_dispatch_cmd+0x9/0x12 [lkdtm]
[  142.128009] [<ffffffff811d2b52>] ? scsi_request_fn+0x3c1/0x3ed
[  142.128009] [<ffffffff81073fa0>] ? sync_page+0x0/0x37
[  142.128009] [<ffffffff81175261>] ? __generic_unplug_device+0x35/0x3a
[  142.128009] [<ffffffff81175291>] ? generic_unplug_device+0x2b/0x3b
[  142.128009] [<ffffffff81173221>] ? blk_unplug+0x12/0x14
[  142.128009] [<ffffffff81173230>] ? blk_backing_dev_unplug+0xd/0xf
[  142.128009] [<ffffffff810bd6e0>] ? block_sync_page+0x31/0x33
[  142.128009] [<ffffffff81073fce>] ? sync_page+0x2e/0x37
[  142.128009] [<ffffffff81347cf1>] ? __wait_on_bit_lock+0x41/0x8a
[  142.128009] [<ffffffff81073f8c>] ? __lock_page+0x61/0x68
[  142.128009] [<ffffffff81048a8d>] ? wake_bit_function+0x0/0x2e
[  142.128009] [<ffffffff810bbe2a>] ? __generic_file_splice_read+0x281/0x448
[  142.128009] [<ffffffff8102ddf5>] ? load_balance+0xbb/0x5e4
[  142.128009] [<ffffffff810ba637>] ? spd_release_page+0x0/0x14
[  142.128009] [<ffffffff810bc038>] ? generic_file_splice_read+0x47/0x73
[  142.128009] [<ffffffff810ba6ba>] ? do_splice_to+0x6f/0x7c
[  142.128009] [<ffffffff810ba78b>] ? splice_direct_to_actor+0xc4/0x18f
[  142.128009] [<ffffffff811cc5d4>] ? lo_direct_splice_actor+0x0/0x12
[  142.128009] [<ffffffff811cc33a>] ? do_bio_filebacked+0x22f/0x289
[  142.128009] [<ffffffff8102b74b>] ? get_parent_ip+0x11/0x41
[  142.128009] [<ffffffff8102b74b>] ? get_parent_ip+0x11/0x41
[  142.128009] [<ffffffff811cc59a>] ? loop_thread+0x206/0x240
[  142.128009] [<ffffffff811cc394>] ? loop_thread+0x0/0x240
[  142.128009] [<ffffffff81048a59>] ? autoremove_wake_function+0x0/0x34
[  142.128009] [<ffffffff811cc394>] ? loop_thread+0x0/0x240
[  142.128009] [<ffffffff81048697>] ? kthread+0x7d/0x85
[  142.128009] [<ffffffff810036d4>] ? kernel_thread_helper+0x4/0x10
[  142.128009] [<ffffffff8104861a>] ? kthread+0x0/0x85
[  142.128009] [<ffffffff810036d0>] ? kernel_thread_helper+0x0/0x10
[  142.128009] lkdtm_do_action: jiffies 4294928414 inirq 0 ininterrupt
0 preemptcount 1 cpu 0
ll
[  142.128009] Kernel panic - not syncing: Watchdog detected hard
LOCKUP on cpu 0
[  142.128009] Call Trace:
[  142.128009]  <NMI>
[  142.128009] [<ffffffff81346abd>] ? panic+0x83/0x190
[  142.128009] [<ffffffff81061eb6>] ? watchdog_overflow_callback+0x7b/0xa2
[  142.128009] [<ffffffff810717b4>] ? __perf_event_overflow+0x139/0x1b3
[  142.128009] [<ffffffff8106c876>] ? perf_event_update_userpage+0xc5/0xca
[  142.128009] [<ffffffff810719a8>] ? perf_event_overflow+0x14/0x16
[  142.128009] [<ffffffff81010f0b>] ? x86_pmu_handle_irq+0xd0/0x10b
[  142.128009] [<ffffffff8134b0e0>] ? perf_event_nmi_handler+0x58/0xa2
[  142.128009] [<ffffffff8134c838>] ? notifier_call_chain+0x32/0x5e
[  142.128009] [<ffffffff8134c89c>] ? __atomic_notifier_call_chain+0x38/0x4a
[  142.128009] [<ffffffff8134c8bd>] ? atomic_notifier_call_chain+0xf/0x11
[  142.128009] [<ffffffff8134c8ed>] ? notify_die+0x2e/0x30
[  142.128009] [<ffffffff8134a7d6>] ? do_nmi+0x67/0x210
[  142.128009] [<ffffffff8134a2ea>] ? nmi+0x1a/0x20
[  142.128009] [<ffffffffa007a207>] ? lkdtm_do_action+0xcc/0x198 [lkdtm]
[  142.128009]  <<EOE>>
[  142.128009] [<ffffffff8102b74b>] ? get_parent_ip+0x11/0x41
[  142.128009] [<ffffffffa007a438>] ? lkdtm_handler+0x70/0x7e [lkdtm]
[  142.128009] [<ffffffffa007a44f>] ? jp_scsi_dispatch_cmd+0x9/0x12 [lkdtm]
[  142.128009] [<ffffffff811d2b52>] ? scsi_request_fn+0x3c1/0x3ed
[  142.128009] [<ffffffff81073fa0>] ? sync_page+0x0/0x37
[  142.128009] [<ffffffff81175261>] ? __generic_unplug_device+0x35/0x3a
[  142.128009] [<ffffffff81175291>] ? generic_unplug_device+0x2b/0x3b
[  142.128009] [<ffffffff81173221>] ? blk_unplug+0x12/0x14
[  142.128009] [<ffffffff81173230>] ? blk_backing_dev_unplug+0xd/0xf
[  142.128009] [<ffffffff810bd6e0>] ? block_sync_page+0x31/0x33
[  142.128009] [<ffffffff81073fce>] ? sync_page+0x2e/0x37
[  142.128009] [<ffffffff81347cf1>] ? __wait_on_bit_lock+0x41/0x8a
[  142.128009] [<ffffffff81073f8c>] ? __lock_page+0x61/0x68
[  142.128009] [<ffffffff81048a8d>] ? wake_bit_function+0x0/0x2e
[  142.128009] [<ffffffff810bbe2a>] ? __generic_file_splice_read+0x281/0x448
[  142.128009] [<ffffffff8102ddf5>] ? load_balance+0xbb/0x5e4
[  142.128009] [<ffffffff810ba637>] ? spd_release_page+0x0/0x14
[  142.128009] [<ffffffff810bc038>] ? generic_file_splice_read+0x47/0x73
[  142.128009] [<ffffffff810ba6ba>] ? do_splice_to+0x6f/0x7c
[  142.128009] [<ffffffff810ba78b>] ? splice_direct_to_actor+0xc4/0x18f
[  142.128009] [<ffffffff811cc5d4>] ? lo_direct_splice_actor+0x0/0x12
[  142.128009] [<ffffffff811cc33a>] ? do_bio_filebacked+0x22f/0x289
[  142.128009] [<ffffffff8102b74b>] ? get_parent_ip+0x11/0x41
[  142.128009] [<ffffffff8102b74b>] ? get_parent_ip+0x11/0x41
[  142.128009] [<ffffffff811cc59a>] ? loop_thread+0x206/0x240
[  142.128009] [<ffffffff811cc394>] ? loop_thread+0x0/0x240
[  142.128009] [<ffffffff81048a59>] ? autoremove_wake_function+0x0/0x34
[  142.128009] [<ffffffff811cc394>] ? loop_thread+0x0/0x240
[  142.128009] [<ffffffff81048697>] ? kthread+0x7d/0x85
[  142.128009] [<ffffffff810036d4>] ? kernel_thread_helper+0x4/0x10
[  142.128009] [<ffffffff8104861a>] ? kthread+0x0/0x85
[  142.128009] [<ffffffff810036d0>] ? kernel_thread_helper+0x0/0x10
[  168.272021] BUG: soft lockup - CPU#1 stuck for 22s! [bash:2779]
[  168.272143] Stack:
[  168.272160] Call Trace:
[  168.272166] [<ffffffff81022c34>] flush_tlb_page+0x78/0xa3
[  168.272171] [<ffffffff81021ffa>] ptep_set_access_flags+0x22/0x28
[  168.272176] [<ffffffff81088906>] handle_pte_fault+0x5dd/0xa11
[  168.272181] [<ffffffff81089f82>] handle_mm_fault+0x134/0x14a
[  168.272186] [<ffffffff8134c689>] do_page_fault+0x449/0x46e
[  168.272192] [<ffffffff8102b74b>] ? get_parent_ip+0x11/0x41
[  168.272196] [<ffffffff8134c740>] ? sub_preempt_count+0x92/0xa6
[  168.272200] [<ffffffff813499d0>] ? _raw_spin_unlock+0x13/0x2e
[  168.272205] [<ffffffff81099575>] ? fd_install+0x54/0x5d
[  168.272209] [<ffffffff810a2515>] ? do_pipe_flags+0x8a/0xc7
[  168.272214] [<ffffffff8134a08f>] page_fault+0x1f/0x30
[  168.272217] Code: 85 c0 49 89 84 24 78 2a 6f 81 74 21 48 8b 05 32
bd 63 00 41 8d b7 f0 00 00 00 4c 89 f7 ff 90 e0 00 00 00 eb 02 f3 90
41 f6 06 03 <75> f8 4c 89 ef 49 c7 84 24 40 2a 6f 81 00 00 00 00 49 c7
84 24
[  168.272300] Kernel panic - not syncing: softlockup: hung tasks
[  168.272306] Call Trace:
[  168.272308]  <IRQ>
[  168.272313] [<ffffffff81346abd>] ? panic+0x83/0x190
[  168.272318] [<ffffffff81005f0d>] ? show_trace_log_lvl+0x44/0x4b
[  168.272323] [<ffffffff81061c8f>] ? watchdog_timer_fn+0x139/0x15d
[  168.272326] [<ffffffff81061b56>] ? watchdog_timer_fn+0x0/0x15d
[  168.272332] [<ffffffff8104b7ba>] ? __run_hrtimer+0x52/0xb4
[  168.272336] [<ffffffff8104ba51>] ? hrtimer_interrupt+0xc9/0x1c5
[  168.272342] [<ffffffff81017fb5>] ? smp_apic_timer_interrupt+0x82/0x95
[  168.272346] [<ffffffff81003293>] ? apic_timer_interrupt+0x13/0x20
[  168.272348]  <EOI>
[  168.272353] [<ffffffff81022a86>] ? flush_tlb_others_ipi+0xad/0xde
[  168.272357] [<ffffffff81022a7e>] ? flush_tlb_others_ipi+0xa5/0xde
[  168.272362] [<ffffffff81022c34>] ? flush_tlb_page+0x78/0xa3
[  168.272366] [<ffffffff81021ffa>] ? ptep_set_access_flags+0x22/0x28
[  168.272370] [<ffffffff81088906>] ? handle_pte_fault+0x5dd/0xa11
[  168.272374] [<ffffffff81089f82>] ? handle_mm_fault+0x134/0x14a
[  168.272379] [<ffffffff8134c689>] ? do_page_fault+0x449/0x46e
[  168.272383] [<ffffffff8102b74b>] ? get_parent_ip+0x11/0x41
[  168.272387] [<ffffffff8134c740>] ? sub_preempt_count+0x92/0xa6
[  168.272391] [<ffffffff813499d0>] ? _raw_spin_unlock+0x13/0x2e
[  168.272394] [<ffffffff81099575>] ? fd_install+0x54/0x5d
[  168.272398] [<ffffffff810a2515>] ? do_pipe_flags+0x8a/0xc7
[  168.272402] [<ffffffff8134a08f>] ? page_fault+0x1f/0x30
[  168.276002] Rebooting in 60 seconds..


I'm definitely seeing above lockup with 2.6.38.8. In 3.2 and up kernel
nmi_shootdown_cpus() replaced register_die_notifier() with
register_nmi_handler() which doesn't call vmalloc_sync_all. If I patch
my 2.6.38.8 so it behaves as 3.2 in this regard ie., skip
vmalloc_sync_all, I don't see any issue.

So my question is, is it safe to bypass calling vmalloc_sync_all() as
part of setting up NMI handler? Maybe with a patch like below:

--- linux-2.6.38.orig/kernel/notifier.c
+++ linux-2.6.38/kernel/notifier.c
@@ -574,7 +574,8 @@ int notrace __kprobes notify_die(enum di

 int register_die_notifier(struct notifier_block *nb)
 {
-       vmalloc_sync_all();
+       if (!oops_in_progress)
+               vmalloc_sync_all();
        return atomic_notifier_chain_register(&die_chain, nb);
 }
 EXPORT_SYMBOL_GPL(register_die_notifier);

thank you.

On Tue, Nov 27, 2012 at 6:55 AM, Don Zickus <dzickus@redhat.com> wrote:
> On Mon, Nov 26, 2012 at 03:06:53PM -0800, Prasad Koya wrote:
>> Hi
>>
>> Before going into crashkernel, nmi_shootdown_cpus() calls
>> register_die_notifier(), which calls vmalloc_sync_all(). I'm seeing
>> lockup in sync_global_pgds() (init_64.c). From 3.2 and up,
>> register_die_notifier() is replaced with register_nmi_handler() (patch
>> 9c48f1c629ecfa114850c03f875c6691003214de), which doesn't call
>> vmalloc_sync_all(). Is it ok to skip vmalloc_sync_all() in this path?
>> I see sync_global_pgds() was touched by this patch:
>> a79e53d85683c6dd9f99c90511028adc2043031f. There are no virtual
>> machines involved and I see lockups at times.
>
> What problems are you seeing?  What are you trying to solve?
>
> Cheers,
> Don
>
>>
>> thank you.
>> Prasad
>>
>> /* Halt all other CPUs, calling the specified function on each of them
>>   *
>>   * This function can be used to halt all other CPUs on crash
>> @@ -794,7 +784,8 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)
>>
>>         atomic_set(&waiting_for_crash_ipi, num_online_cpus() - 1);
>>         /* Would it be better to replace the trap vector here? */
>> -       if (register_die_notifier(&crash_nmi_nb))
>> +       if (register_nmi_handler(NMI_LOCAL, crash_nmi_callback,
>> +                                NMI_FLAG_FIRST, "crash"))
>>                 return;         /* return what? */

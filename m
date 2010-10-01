Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab0JAG0L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 02:26:11 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55655 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab0JAG0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 02:26:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=mW27mfjibxRrMU0E6UmSjR13gly/0G2aeZc/ptP6dc5amdext9bgfQn1ivAG9dOPrQ
         kLzjisYhePYf30jc9Lj6gGe2wZ0gyqf/gNBx8XVBap/pNAN3eDK2kk6vzz62CEfSPHrD
         lPHK1GdzpnJNyxokyMIvAs6Fxl+L3Wm+l9RI8=
MIME-Version: 1.0
Date: Fri, 1 Oct 2010 14:26:08 +0800
Message-ID: <AANLkTinzDRkVZNv_119BYCMFv9SyM4dr30XLVJW48Dn+@mail.gmail.com>
Subject: Seeking helps to confirm the deadlock issue on SMP
From: Andrew Yan-Pai Chen <yanpai.chen@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

We try to verify our dual-core processor (armv5te ISA with extra
coprocessor instructions implemented for exclusive accesses) by LTP tests.
But there seems to be some deadlocks existed in the following case. We
are seeking helps to confirm this issue or experience sharing.

This issue is also posted on linux-arm-kernel mailing list. Please refer to
http://lists.infradead.org/pipermail/linux-arm-kernel/2010-September/
026377.html

The kernel we use is v2.6.28 and is configured with CONFIG_SMP and
CONFIG_PREEMPT set. Here is my scenario:

Assuming that an IPI is required in some path of system calls and then
generic_exec_single() is invoked. It will check if the list is empty, adding
CSDs into the list, sending an IPI to another processor. But in the case
that the list is not empty, it WON'T send the IPI.

Right after some CSDs are added into the list (and the spinlock is
released), an interrupt for packets available occurs. Then softirq
(net_rx_action) is scheduled to pick up the packets, in this path
smp_flush_tlb_kernel_page() will eventually be called and try to flush the
tlb of another processor via IPIs. That is, generic_exec_single() will be
called again. But this time when it checks the list, it gets the list is not
empty so actually it won't send any IPI.

smp_flush_tlb_kernel_page() sends the IPI with CSD_FLAG_WAIT set,
however, CPU1 never receives any IPI. Therefore CPU0 loops indefinitely
in csd_flag_wait().

I did some workaround to force sending IPI requests of which
CSF_FALGS_WAIT is set. It works for we don't get this problem anymore.
But we are seeking for a better one.

--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -78,7 +78,7 @@ static void generic_exec_single(int cpu, struct
call_single_data *data)
         */
        smp_mb();

-       if (ipi)
+       if (ipi || wait)
                arch_send_call_function_single_ipi(cpu);

        if (wait)


Here is the backtrace we got. Please refer to it for the details.

Pid: 20347, comm:                  pan
CPU: 0    Not tainted  (2.6.28-arm1-g898b37a-dirty #12)
PC is at generic_exec_single+0x8c/0xa4
LR is at _spin_unlock_irqrestore+0x20/0x40
pc : [<c01ff5f8>]    lr : [<c0378b58>]    psr: 20000013
sp : cb2775e8  ip : cb2775d0  fp : cb27761c
r10: 00000001  r9 : 80000013  r8 : 003f2000
r7 : c05b2914  r6 : cb277624  r5 : cb277bb4  r4 : c05b290c
r3 : 00000001  r2 : cb2775d0  r1 : 80000013  r0 : 0000010f
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0000397f  Table: 1b23c000  DAC: 00000015
[<c01c71e0>] (show_regs+0x0/0x50) from [<c0205a14>]
(softlockup_tick+0x154/0x1ac)
 r4:cb2775a0 r3:00000002
[<c02058c0>] (softlockup_tick+0x0/0x1ac) from [<c01e7698>]
(run_local_timers+0x1c/0x20)
[<c01e767c>] (run_local_timers+0x0/0x20) from [<c01e7720>]
(update_process_times+0x38/0x68)
[<c01e76e8>] (update_process_times+0x0/0x68) from [<c01fc294>]
(tick_periodic+0xd4/0x100)
 r6:c05ae000 r5:00001f4b r4:24f47300 r3:20000013
[<c01fc1c0>] (tick_periodic+0x0/0x100) from [<c01fc2e0>]
(tick_handle_periodic+0x20/0xf8)
 r5:cb2774a4 r4:00000000
[<c01fc2c0>] (tick_handle_periodic+0x0/0xf8) from [<c01fc63c>]
(tick_do_periodic_broadcast+0x84/0xd8)
[<c01fc5b8>] (tick_do_periodic_broadcast+0x0/0xd8) from [<c01fc6a8>]
(tick_handle_periodic_broadcast+0x18/0xb0)
 r5:00000000 r4:c0402a00
[<c01fc690>] (tick_handle_periodic_broadcast+0x0/0xb0) from
[<c01cfc40>] (fttmr010_clockevent_interrupt+0x38/0x44)
[<c01cfc08>] (fttmr010_clockevent_interrupt+0x0/0x44) from
[<c0205d58>] (handle_IRQ_event+0x44/0x84)
[<c0205d14>] (handle_IRQ_event+0x0/0x84) from [<c02076f8>]
(handle_edge_irq+0x134/0x188)
 r7:c041a30c r6:c03fe834 r5:00000113 r4:c03fe800
[<c02075c4>] (handle_edge_irq+0x0/0x188) from [<c01cfa40>]
(ftintc010_handle_cascade_irq+0xc0/0xdc)
 r8:0000010f r7:c0411218 r6:00080000 r5:c040350c r4:0000001f
r3:c03fe800
[<c01cf980>] (ftintc010_handle_cascade_irq+0x0/0xdc) from [<c01c4c74>]
(__exception_text_start+0x74/0xa4)
 r7:00000110 r6:cb2775a0 r5:0000001f r4:cb277b18
[<c01c4c00>] (__exception_text_start+0x0/0xa4) from [<c01c582c>]
(__irq_svc+0x4c/0xbc)
Exception stack(0xcb2775a0 to 0xcb2775e8)
75a0: 0000010f 80000013 cb2775d0 00000001 c05b290c cb277bb4 cb277624 c05b2914
75c0: 003f2000 80000013 00000001 cb27761c cb2775d0 cb2775e8 c0378b58 c01ff5f8
75e0: 20000013 ffffffff
 r6:0000001f r5:f9100100 r4:ffffffff r3:20000013
[<c01ff56c>] (generic_exec_single+0x0/0xa4) from [<c01ff76c>]
(smp_call_function_single+0x10c/0x15c)
[<c01ff660>] (smp_call_function_single+0x0/0x15c) from [<c01ff84c>]
(smp_call_function_mask+0x90/0x1dc)
 r8:00000001 r7:0000007c r6:00000001 r5:cb27772c r4:c01ca880
[<c01ff7bc>] (smp_call_function_mask+0x0/0x1dc) from [<c01ff9d0>]
(smp_call_function+0x38/0x6c)
[<c01ff998>] (smp_call_function+0x0/0x6c) from [<c01e2138>]
(on_each_cpu+0x30/0x80)
 r6:00000001 r5:cb27772c r4:c01ca880 r3:cb276000
[<c01e2108>] (on_each_cpu+0x0/0x80) from [<c01cae00>]
(smp_flush_tlb_kernel_page+0x24/0x30)
 r6:c961b848 r5:00065420 r4:ffff4000 r3:00000000
[<c01caddc>] (smp_flush_tlb_kernel_page+0x0/0x30) from [<c01cd408>]
(flush_pfn_alias+0x70/0xa0)
[<c01cd398>] (flush_pfn_alias+0x0/0xa0) from [<c01cd4d8>]
(__flush_dcache_page+0x54/0x5c)
 r4:c041a514 r3:c0426000
[<c01cd484>] (__flush_dcache_page+0x0/0x5c) from [<c01cd55c>]
(flush_dcache_page+0x34/0x4c)
 r6:cb1d22fc r5:00020000 r4:c961b848 r3:00000021
[<c01cd528>] (flush_dcache_page+0x0/0x4c) from [<c0361ee8>]
(xdr_partial_copy_from_skb+0x178/0x1fc)
 r4:00001000 r3:00000524
[<c0361d70>] (xdr_partial_copy_from_skb+0x0/0x1fc) from [<c0364b18>]
(xs_tcp_data_recv+0x2b4/0x4d8)
[<c0364864>] (xs_tcp_data_recv+0x0/0x4d8) from [<c0329ea8>]
(tcp_read_sock+0x74/0x1ec)
[<c0329e34>] (tcp_read_sock+0x0/0x1ec) from [<c0364840>]
(xs_tcp_data_ready+0x70/0x94)
[<c03647d0>] (xs_tcp_data_ready+0x0/0x94) from [<c0330de8>]
(tcp_data_queue+0x60c/0xe7c)
 r7:cb214e7c r6:00000000 r5:c368d2c0 r4:cb214a40
[<c03307dc>] (tcp_data_queue+0x0/0xe7c) from [<c03323b8>]
(tcp_rcv_established+0x708/0x948)
[<c0331cb0>] (tcp_rcv_established+0x0/0x948) from [<c0339894>]
(tcp_v4_do_rcv+0x30/0x1d0)
[<c0339864>] (tcp_v4_do_rcv+0x0/0x1d0) from [<c0339e68>]
(tcp_v4_rcv+0x434/0x748)
 r7:c041f51c r6:cb214a6c r5:cb214a40 r4:c368d2c0
[<c0339a34>] (tcp_v4_rcv+0x0/0x748) from [<c031e134>]
(ip_local_deliver+0x108/0x244)
[<c031e02c>] (ip_local_deliver+0x0/0x244) from [<c031dfe0>] (ip_rcv+0x5d4/0x620)
 r7:00000000 r6:c041e29c r5:c3478020 r4:c368d2c0
[<c031da0c>] (ip_rcv+0x0/0x620) from [<c0304750>]
(netif_receive_skb+0x27c/0x2d8)
 r8:00000008 r7:00000000 r6:c041e29c r5:cb13a000 r4:c368d2c0
[<c03044d4>] (netif_receive_skb+0x0/0x2d8) from [<bf00091c>]
(ftmac100_poll+0x384/0x46c [ftmac100])
[<bf000598>] (ftmac100_poll+0x0/0x46c [ftmac100]) from [<c03030c4>]
(net_rx_action+0xa4/0x1c4)
[<c0303020>] (net_rx_action+0x0/0x1c4) from [<c01e27a0>]
(__do_softirq+0x80/0x150)
[<c01e2720>] (__do_softirq+0x0/0x150) from [<c01e28bc>] (irq_exit+0x4c/0x60)
[<c01e2870>] (irq_exit+0x0/0x60) from [<c01c4c78>]
(__exception_text_start+0x78/0xa4)
[<c01c4c00>] (__exception_text_start+0x0/0xa4) from [<c01c582c>]
(__irq_svc+0x4c/0xbc)
Exception stack(0xcb277b18 to 0xcb277b60)
7b00:                                                       c05b2914 80000013
7b20: 00000000 00000000 80000013 c05b290c cb277bb4 c05b2914 003f2000 80000013
7b40: 00000001 cb277b74 cb277b60 cb277b60 c0378b4c c0378b50 60000013 ffffffff
 r6:0000001f r5:f9100100 r4:ffffffff r3:60000013
[<c0378b38>] (_spin_unlock_irqrestore+0x0/0x40) from [<c01ff5cc>]
(generic_exec_single+0x60/0xa4)
 r4:c05b290c r3:00000000
[<c01ff56c>] (generic_exec_single+0x0/0xa4) from [<c01ff76c>]
(smp_call_function_single+0x10c/0x15c)
[<c01ff660>] (smp_call_function_single+0x0/0x15c) from [<c01ff84c>]
(smp_call_function_mask+0x90/0x1dc)
 r8:00000001 r7:00000050 r6:00000001 r5:cb277cbc r4:c01ca880
[<c01ff7bc>] (smp_call_function_mask+0x0/0x1dc) from [<c01ff9d0>]
(smp_call_function+0x38/0x6c)
[<c01ff998>] (smp_call_function+0x0/0x6c) from [<c01e2138>]
(on_each_cpu+0x30/0x80)
 r6:00000001 r5:cb277cbc r4:c01ca880 r3:cb276000
[<c01e2108>] (on_each_cpu+0x0/0x80) from [<c01cae00>]
(smp_flush_tlb_kernel_page+0x24/0x30)
 r6:cb426118 r5:00164de0 r4:ffff4000 r3:00000000
[<c01caddc>] (smp_flush_tlb_kernel_page+0x0/0x30) from [<c01cd408>]
(flush_pfn_alias+0x70/0xa0)
[<c01cd398>] (flush_pfn_alias+0x0/0xa0) from [<c01cd4d8>]
(__flush_dcache_page+0x54/0x5c)
 r4:c041a514 r3:c0426000
[<c01cd484>] (__flush_dcache_page+0x0/0x5c) from [<c01cd55c>]
(flush_dcache_page+0x34/0x4c)
 r6:cba75220 r5:00000050 r4:cb426118 r3:0010003d
[<c01cd528>] (flush_dcache_page+0x0/0x4c) from [<c020b858>]
(generic_file_buffered_write+0x14c/0x2d8)
 r4:00000000 r3:00000000
[<c020b70c>] (generic_file_buffered_write+0x0/0x2d8) from [<c020c0cc>]
(__generic_file_aio_write_nolock+0x460/0x4a8)
[<c020bc6c>] (__generic_file_aio_write_nolock+0x0/0x4a8) from
[<c020c3e0>] (generic_file_aio_write+0x74/0xe4)
[<c020c36c>] (generic_file_aio_write+0x0/0xe4) from [<c022ffa8>]
(do_sync_write+0xc0/0x10c)
[<c022fee8>] (do_sync_write+0x0/0x10c) from [<c0230970>] (vfs_write+0xb8/0x148)
[<c02308b8>] (vfs_write+0x0/0x148) from [<c0230ac4>] (sys_write+0x44/0x70)
 r7:00000004 r6:00000050 r5:40020050 r4:cba75220
[<c0230a80>] (sys_write+0x0/0x70) from [<c01c5c40>] (ret_fast_syscall+0x0/0x28)
 r9:cb276000 r8:c01c5de8 r6:00000050 r5:00096140 r4:00000050


-- 
BR,
Andrew

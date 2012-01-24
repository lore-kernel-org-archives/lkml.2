Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab2AXSSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 13:18:00 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60194 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab2AXSR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 13:17:58 -0500
MIME-Version: 1.0
From: Sagar Borikar <sagar.borikar@gmail.com>
Date: Tue, 24 Jan 2012 10:17:37 -0800
Message-ID: <CAFwMWxt084yU1ddXNkidtaaZEpOiaae9BO0Xdz7H9vizR7ccYw@mail.gmail.com>
Subject: BUG: soft lockup in kernel
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Before I get started, pardon me for the pretty old kernel i.e. 2.6.23
but this is in the field now so can't upgrade right away.
This is x86_64 system

This issue happens intermittently when the faulting cpu is in the
interrupt context.

Here is the bug trace:

11798 (E3)[     35423.211033] BUG: soft lockup - CPU#16 stuck for 21s!
[swapper:0]
11799 (E4)[     35423.211057] CPU 16:
11800 (E4)[     35423.211060] Modules linked in: ipv6 mptctl 8021q
ipmi_si ipmi_devintf ipmi_msghandler usbcore dd_raid_driver(P) bnx2x
zlib_inflate tg3_115j dm_round_robin dm_e
11801 (E4)[     35423.211089] Pid: 0, comm: swapper Tainted: P
2.6.23-ddr279999 #1
11802 (E4)[     35423.211091] RIP: 0010:[<ffffffff80253663>]
[<ffffffff80253663>] handle_IRQ_event+0x1a/0x55
11803 (E4)[     35423.211099] RSP: 0018:ffffc2001832bf38  EFLAGS: 00000246
11804 (E4)[     35423.211101] RAX: ffff8129dd133400 RBX:
0000000000002038 RCX: ffffc2001f68005a
11805 (E4)[     35423.211103] RDX: 0000000000000005 RSI:
ffff8129cf31cc40 RDI: 0000000000002038
11806 (E4)[     35423.211105] RBP: ffffc2001832beb0 R08:
0000000000000002 R09: 0000000000000087
11807 (E4)[     35423.211114] R10: 0000000000000000 R11:
ffffffff80b7af50 R12: ffffffff8020c946
11808 (E4)[     35423.211117] R13: ffffc2001832beb0 R14:
ffff8129cf31cc40 R15: 0000000000000002
11809 (E4)[     35423.211119] FS:  0000000000000000(0000)
GS:ffff8117d29014c0(0000) knlGS:0000000000000000
11810 (E4)[     35423.211122] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
11811 (E4)[     35423.211123] CR2: 00002acc8f8fe0e0 CR3:
0000000000201000 CR4: 00000000000006e0
11812 (E4)[     35423.211125] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
11813 (E4)[     35423.211127] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
11814 (E4)[     35423.211129]
11815 (E4)[     35423.211129] Call Trace:
11816 (E4)[     35423.211132]  <IRQ>
11817 (E4)[     35423.211138]  [<ffffffff80254b2a>] handle_edge_irq+0xe1/0x129
11818 (E4)[     35423.211142]  [<ffffffff8020cf0c>] call_softirq+0x1c/0x28
11819 (E4)[     35423.211146]  [<ffffffff8020e18b>] do_IRQ+0x96/0x147
11820 (E4)[     35423.211149]  [<ffffffff8020a046>] default_idle+0x0/0x3d
11821 (E4)[     35423.211152]  [<ffffffff8020c1b1>] ret_from_intr+0x0/0xa
11822 (E4)[     35423.211153]  <EOI>
11823 (E4)[     35423.211156]  [<ffffffff8020a004>] mwait_idle+0x0/0x42
11824 (E4)[     35423.211159]  [<ffffffff8020a043>] mwait_idle+0x3f/0x42
11825 (E4)[     35423.211162]  [<ffffffff8020a303>] cpu_idle+0x53/0x72

cpu 16 has following stats:


259 $21 = {
260   pcurrent = 0xffff8117d290c700,
261   data_offset = 18446604437888671744,
262   kernelstack = 18446604641154777048,
263   oldrsp = 0,
264   irqcount = 1, --------------------------> already in interrupt context.
265   cpunumber = 16,
266   irqstackptr = 0xffffc2001832bfc0 "",
267   nodenumber = 0,
268   __softirq_pending = 106, ----------------------> soft irqs are
not serviced for long
269   __nmi_count = 4056,
270   mmu_state = 2,
271   isidle = 0,
272   active_mm = 0xffff8129da963040,
273   apic_timer_irqs = 30131629
274 }

Added few variables to check the number of interrupts serviced on this
cpu and the count is unusually high


kernel stat for cpu 16:

struct kernel_stat {
  cpustat = {
    user = 812750,
    nice = 0,
    system = 530976,
    softirq = 1640,
    irq = 49125,
    idle = 28617557,
    iowait = 119581,
    steal = 0
  },
  irqs = {4027, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...},
  softlkup_touchtime = {0, 0, 3, 13961, 6, 0, 1, 0, 3, 0, 1, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  soft_lkup_wdog_time = {
    soft_lkup_wdog_after_rec_thresh = 1,
    soft_lkup_wdog_rec_thresh = 0
  },
  sft_lkup_wdog_last_queued = 35400678034425,
  sft_lkup_wdog_cur_time = 35400678035927,
  do_irq_count = 707196, -------------------------------> Note the
number of interrupts serviced on this cpu
  softirq_count = 3134,
  do_softirq_tot_count = 2040

this number is high compared to other cpus at the time of lockup.

Strangely, at the time of lockup, the irq stack frame says that cpu_idle
routine was getting executed.

The CPU 16 stack trace is as below:


 49 CPU 16 IRQ STACK:
  50
  51   KERNEL-MODE EXCEPTION FRAME AT: ffffc2001832bbf8
  52     [exception RIP: handle_IRQ_event+26]
  53     RIP: ffffffff80253663  RSP: ffffc2001832bf38  RFLAGS: 00000246
  54     RAX: ffff8129dd133400  RBX: 0000000000002038  RCX: ffffc2001f68005a
  55     RDX: 0000000000000005  RSI: ffff8129cf31cc40  RDI: 0000000000002038
  56     RBP: ffffc2001832beb0   R8: 0000000000000002   R9: 0000000000000087
  57     R10: 0000000000000000  R11: ffffffff80b7af50  R12: ffffffff8020c946
  58     R13: ffffc2001832beb0  R14: ffff8129cf31cc40  R15: 0000000000000002
  59     ORIG_RAX: ffffffffffffff10  CS: 0010  SS: 0018
  60
  61   KERNEL-MODE EXCEPTION FRAME AT: ffffc2001832be88
  62     [exception RIP: handle_IRQ_event+26]
  63     RIP: ffffffff80253663  RSP: ffffc2001832bf38  RFLAGS: 00000246
  64     RAX: ffff8129dd133400  RBX: 0000000000002038  RCX: ffffc2001f68005a
  65     RDX: 0000000000000005  RSI: ffff8129cf31cc40  RDI: 0000000000002038
  66     RBP: ffffc2001832beb0   R8: 0000000000000002   R9: 0000000000000087
  67     R10: 0000000000000000  R11: ffffffff80b7af50  R12: ffffffff8020c946
  68     R13: ffffc2001832beb0  R14: ffff8129cf31cc40  R15: 0000000000000002
  69     ORIG_RAX: ffffffffffffff10  CS: 0010  SS: 0018

The crash tool doesn't provide the correct stack dump:
On CPU 16:

 #1 [ffffc2001832be20] softlockup_tick at ffffffff802531c6
 #2 [ffffc2001832be50] update_process_times at ffffffff8023a2e1
 #3 [ffffc2001832be70] smp_local_timer_interrupt at ffffffff8021b56d
 #4 [ffffc2001832be80] smp_apic_timer_interrupt at ffffffff8021b657
 #5 [ffffc2001832bea0] apic_timer_interrupt at ffffffff8020c946
 #6 [ffffc2001832bf08] handle_IRQ_event at ffffffff80253663
 #7 [ffffc2001832bf60] handle_edge_irq at ffffffff80254b2a
 #8 [ffffc2001832bf90] do_IRQ at ffffffff8020e18b
--- <IRQ stack> ---
 #9 [ffff812fd41a3eb0] ret_from_intr at ffffffff8020c1b1
    [exception RIP: cpu_idle+83]
    RIP: ffffffff8020a303  RSP: 0000000000000000  RFLAGS: 00000000
    RAX: ffffffffffffff20  RBX: 0000000000000000  RCX: ffffffff8020a043
    RDX: 0000000000000010  RSI: 0000000000000246  RDI: ffff812fd41a3f30
    RBP: 0000000000000000   R8: 0000000000000000   R9: 0000000000000001
    R10: 0000000000000000  R11: 0000000000000000  R12: 0000000000000000
    R13: 000000004351ccd8  R14: 0000000000000206  R15: ffffffff8020a004
    ORIG_RAX: 0000000000000018  CS: 0000  SS: 0000
bt: WARNING: possibly bogus exception frame --------------------->
Don't know what is happening here.


Whereas nmi exception stack refers to tg3 driver context.


 668   KERNEL-MODE EXCEPTION FRAME AT: ffff812fd41b0f58
 669     [exception RIP: tg3_msi_1shot+62]
 670     RIP: ffffffff881a1ee4  RSP: ffffc2001832bf28  RFLAGS: 00000203
 671     RAX: 0000000000000026  RBX: ffff8129cf31cc40  RCX: ffff81115f2c0000
 672     RDX: ffff812fabe7c740  RSI: ffff812fabe7c7c0  RDI: ffff812fabe7c000
 673     RBP: 0000000000000000   R8: 0000000000000002   R9: 0000000000000087
 674     R10: 0000000000000000  R11: ffffffff80b7af80  R12: 0000000000000000
 675     R13: 0000000000002038  R14: 0000000000000000  R15: 0000000000000000
 676     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018

I don't know whether this is correct backtrace but don't know what is
going wrong here. None of the dump refers to any clue at least to me
:)
Any ideas?

Thanks
Sagar

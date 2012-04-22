Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab2DVVdN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 17:33:13 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:51871 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586Ab2DVVdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 17:33:11 -0400
Date: Mon, 23 Apr 2012 00:33:07 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
        sparclinux@vger.kernel.org
Subject: 3.4.0-rc4: ksoftirqd crash on sparc64 after IO errors and RCU
 stalls
Message-ID: <alpine.SOC.1.00.1204222352580.16791@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetest 3.4.0-rc4 on Sun Fire V240 (SMP sparc64). First the disk got may 
IO errors, the RCU soft lockup warning kicked in, mthen any more IO 
errors - up to this point the kernel behaviour seems OK. But finally, an 
oops from ksoftirqd happened.

Kernel unaligned access at TPC[42c0dc] arch_trigger_all_cpu_backtrace+0x13c/0x1c0
seems to be the culprit for me.

I do not know if this is a new behaviour - hitting IO errors is not a 
normal test case for me. V210 with same type of mainbaord and storage 
worked fine with 3.4-rc4 but it did not hit any IO errors either.

Can not get the start of the log - that's all I have in backlog and the 
disk is quite dead so the machine does not boot up any more.

[  332.200524] Buffer I/O error on device sda2, logical block 128273
[  332.280695] BUG: soft lockup - CPU#1 stuck for 22s! [ksoftirqd/1:3]
[  332.363121] Modules linked in: loop ohci_hcd ehci_hcd usbcore i2c_ali15x3 i2c_ali1535 usb_common flash nls_base i2c_core pata_ali libata tg3
[  332.528952] irq event stamp: 293355
[  332.574710] hardirqs last  enabled at (293354): [<0000000000457de4>] vprintk+0x244/0x4a0
[  332.681088] hardirqs last disabled at (293355): [<0000000000426b50>] valid_addr_bitmap_patch+0xb0/0x260
[  332.804619] softirqs last  enabled at (285672): [<000000000045e57c>] __do_softirq+0x11c/0x160
[  332.916706] softirqs last disabled at (285677): [<000000000045e6f4>] run_ksoftirqd+0x134/0x200
[  333.029944] TSTATE: 0000004480001606 TPC: 0000000000457df4 TNPC: 0000000000457df8 Y: 00000000    Not tainted
[  333.159206] TPC: <vprintk+0x254/0x4a0>
[  333.208470] g0: 0000000000990ed8 g1: 0000000000000000 g2: 0000000000000000 g3: 0000000000000001
[  333.322865] g4: fffff8101f071ec0 g5: fffff80000bf8000 g6: fffff8101f08c000 g7: 0000000000000720
[  333.437348] o0: 0000000000990e80 o1: 0000000000a31344 o2: 0000000000a31348 o3: ffffffffffffffb8
[  333.551829] o4: 000000000000000e o5: 0000000000990e80 sp: fffff8101f08ea61 ret_pc: 0000000000457de4
[  333.670887] RPC: <vprintk+0x244/0x4a0>
[  333.720155] l0: 0000000000a51360 l1: 0000000000990c00 l2: 0000000000990c00 l3: 000000003b9aca00
[  333.834548] l4: 0000000000000001 l5: 0000000000990c00 l6: 0000000000000001 l7: 0000000000000000
[  333.949031] i0: 000000000000004b i1: fffff8101f08f330 i2: 0000000000000003 i3: 0000000000990ecc
[  334.063512] i4: 0000000000a51399 i5: 0000000000a51363 i6: fffff8101f08eb71 i7: 00000000008061f4
[  334.178005] I7: <printk+0x24/0x38>
[  334.222686] Call Trace:
[  334.254713]  [00000000008061f4] printk+0x24/0x38
[  334.315342]  [00000000005af0fc] ext4_end_bio+0x1dc/0x240
[  334.385117]  [0000000000563cc8] bio_endio+0x28/0x60
[  334.449167]  [000000000060e894] req_bio_endio+0x74/0xe0
[  334.517789]  [000000000060ea0c] blk_update_request+0x10c/0x3a0
[  334.594423]  [000000000060fbb0] blk_update_bidi_request+0x10/0x80
[  334.674490]  [0000000000610bf4] blk_end_bidi_request+0x14/0x60
[  334.751122]  [0000000000610c50] blk_end_request+0x10/0x40
[  334.822035]  [0000000000610ca0] blk_end_request_err+0x20/0x60
[  334.897530]  [00000000006aaa30] scsi_io_completion+0x350/0x620
[  334.974166]  [00000000006a1728] scsi_finish_command+0xa8/0x120
[  335.050791]  [00000000006aa5a8] scsi_softirq_done+0x108/0x160
[  335.126282]  [000000000061728c] blk_done_softirq+0x6c/0xa0
[  335.198337]  [000000000045e510] __do_softirq+0xb0/0x160
[  335.266962]  [000000000045e6f4] run_ksoftirqd+0x134/0x200
[  335.337881]  [00000000004792ec] kthread+0x6c/0x80
... (lots of IO errors)
[  366.185589] EXT4-fs warning (device sda2): ext4_end_bio:250: I/O error writing to inode 1441884 (offset 11534336 size 528384 starting block 154017)
[  366.361847] sd 0:0:0:0: [sda] Unhandled sense code
[  366.424852] sd 0:0:0:0: [sda]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  366.519982] sd 0:0:0:0: [sda]  Sense Key : Hardware Error [current]
[  366.603668] Info fld=0x12ea56
[  366.642566] sd 0:0:0:0: [sda]  Add. Sense: Peripheral device write fault
[  366.730838] sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 00 12 e9 0c 00 04 00 00
[  366.822444] end_request: critical target error, dev sda, sector 1239638
[  366.909501] Buffer I/O error on device sda2, logical block 130816
...
[  375.567682] Buffer I/O error on device sda2, logical block 130924
[  375.647843] Buffer I/O error on device sda2, logical block 130925
[  375.727997] INFO: rcu_sched self-detected stall on CPU
[  375.730097] INFO: rcu_sched detected stalls on CPUs/tasks:
[  375.730122]  1: (286 ticks this GP) idle=8e1/140000000000001/0
[  375.730129]  (detected by 0, t=16253 jiffies)
[  375.730136] INFO: Stall ended before state dump start
[  376.068827]
[  376.088267]  1: (286 ticks this GP) idle=8e1/140000000000001/0
[  376.166048]   (t=16253 jiffies)
[  376.207537] Kernel unaligned access at TPC[42c0dc] arch_trigger_all_cpu_backtrace+0x13c/0x1c0
[  376.319655] Unable to handle kernel paging request in mna handler
[  376.397504]  at virtual address 000007f300000001
[  376.460414] current->{active_,}mm->context = 000000000000086f
[  376.535905] current->{active_,}mm->pgd = fffff8101d5d0000
[  376.606819]               \|/ ____ \|/
[  376.606822]               "@'/ .. \`@"
[  376.606825]               /_| \__/ |_\
[  376.606828]                  \__U_/
[  376.800115] ksoftirqd/1(3): Oops [#1]
[  376.848157] TSTATE: 0000009980e01600 TPC: 000000000042c0dc TNPC: 000000000042c0e0 Y: 00000000    Not tainted
[  376.977422] TPC: <arch_trigger_all_cpu_backtrace+0x13c/0x1c0>
[  377.052999] g0: 0000000000000001 g1: ffffffffffffffff g2: 00000000008f5060 g3: 000007f300000001
[  377.167387] g4: fffff8101f071ec0 g5: fffff80000bf8000 g6: fffff8101f08c000 g7: 0000000000000003
[  377.281766] o0: 000000000000000c o1: 0000000000000020 o2: 0000000000000000 o3: 0000004411001603
[  377.396248] o4: 000000000064e920 o5: 000000000064e924 sp: fffff8101f08e2b1 ret_pc: 000000000042c0a0
[  377.515306] RPC: <arch_trigger_all_cpu_backtrace+0x100/0x1c0>
[  377.590781] l0: 000000000000000e l1: 00000000008f50b0 l2: 00000000008f50e0 l3: 00000000008f5068
[  377.705171] l4: 00000000008f5000 l5: 0000000000a0cfc0 l6: 0000000000000000 l7: 0000000000000000
[  377.819550] i0: 0000000000000001 i1: 0000000000983680 i2: 00000000009847bc i3: 000000000098ac00
[  377.934032] i4: 0000000000a0cfc0 i5: 0000000000000000 i6: fffff8101f08e381 i7: 00000000004cf3b4
[  378.048522] I7: <print_cpu_stall+0x54/0x120>
[  378.104643] Call Trace:
[  378.136671]  [00000000004cf3b4] print_cpu_stall+0x54/0x120
[  378.208735]  [00000000004d0794] __rcu_pending+0xf4/0x220
[  378.278504]  [00000000004d13b0] rcu_check_callbacks+0x130/0x160
[  378.356289]  [0000000000465964] update_process_times+0x24/0x80
[  378.432922]  [00000000004a4c3c] tick_sched_timer+0x5c/0xc0
[  378.504977]  [000000000047dcac] __run_hrtimer.isra.15+0x4c/0x140
[  378.583897]  [000000000047e33c] hrtimer_interrupt+0xbc/0x200
[  378.658242]  [000000000042f7e4] timer_interrupt+0xa4/0xe0
[  378.729154]  [0000000000426b5c] valid_addr_bitmap_patch+0xbc/0x260
[  378.810366]  [0000000000457df4] vprintk+0x254/0x4a0
[  378.874417]  [00000000008061f4] printk+0x24/0x38
[  378.935032]  [00000000005af0fc] ext4_end_bio+0x1dc/0x240
[  379.004805]  [0000000000563cc8] bio_endio+0x28/0x60
[  379.068856]  [000000000060e894] req_bio_endio+0x74/0xe0
[  379.137482]  [000000000060ea0c] blk_update_request+0x10c/0x3a0
[  379.214117]  [000000000060fbb0] blk_update_bidi_request+0x10/0x80
[  379.294179] Disabling lock debugging due to kernel taint
[  379.363951] Caller[00000000004cf3b4]: print_cpu_stall+0x54/0x120
[  379.442872] Caller[00000000004d0794]: __rcu_pending+0xf4/0x220
[  379.519503] Caller[00000000004d13b0]: rcu_check_callbacks+0x130/0x160
[  379.604146] Caller[0000000000465964]: update_process_times+0x24/0x80
[  379.687642] Caller[00000000004a4c3c]: tick_sched_timer+0x5c/0xc0
[  379.766562] Caller[000000000047dcac]: __run_hrtimer.isra.15+0x4c/0x140
[  379.852346] Caller[000000000047e33c]: hrtimer_interrupt+0xbc/0x200
[  379.933553] Caller[000000000042f7e4]: timer_interrupt+0xa4/0xe0
[  380.011329] Caller[0000000000426b5c]: valid_addr_bitmap_patch+0xbc/0x260
[  380.099400] Caller[0000000000457de4]: vprintk+0x244/0x4a0
[  380.170313] Caller[00000000008061f4]: printk+0x24/0x38
[  380.237794] Caller[00000000005af0fc]: ext4_end_bio+0x1dc/0x240
[  380.314431] Caller[0000000000563cc8]: bio_endio+0x28/0x60
[  380.385342] Caller[000000000060e894]: req_bio_endio+0x74/0xe0
[  380.460834] Caller[000000000060ea0c]: blk_update_request+0x10c/0x3a0
[  380.544330] Caller[000000000060fbb0]: blk_update_bidi_request+0x10/0x80
[  380.631258] Caller[0000000000610bf4]: blk_end_bidi_request+0x14/0x60
[  380.714754] Caller[0000000000610c50]: blk_end_request+0x10/0x40
[  380.792528] Caller[0000000000610ca0]: blk_end_request_err+0x20/0x60
[  380.874883] Caller[00000000006aaa30]: scsi_io_completion+0x350/0x620
[  380.958379] Caller[00000000006a1728]: scsi_finish_command+0xa8/0x120
[  381.041872] Caller[00000000006aa5a8]: scsi_softirq_done+0x108/0x160
[  381.124225] Caller[000000000061728c]: blk_done_softirq+0x6c/0xa0
[  381.203145] Caller[000000000045e510]: __do_softirq+0xb0/0x160
[  381.278632] Caller[000000000045e6f4]: run_ksoftirqd+0x134/0x200
[  381.356410] Caller[00000000004792ec]: kthread+0x6c/0x80
[  381.425037] Caller[000000000042b830]: kernel_thread+0x30/0x60
[  381.500527] Caller[000000000047962c]: kthreadd+0x10c/0x180
[  381.572579] Instruction DUMP: d85d6008  02c0c007  da5d6010 <c658c000> 02c0c005  83386000  c200e274  8400e420  83386000 
[  381.714400] Kernel panic - not syncing: Aiee, killing interrupt handler!

-- 
Meelis Roos (mroos@linux.ee)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169Ab1F3EJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 00:09:24 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:37752 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab1F3EJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 00:09:16 -0400
MIME-Version: 1.0
Date: Thu, 30 Jun 2011 12:09:15 +0800
Message-ID: <BANLkTimfF3_R5VS4xOriGp+-3j-r7V0W0w@mail.gmail.com>
Subject: PROBLEM: ARM-dma-mapping-fix-for-speculative-prefetching cause OOPS
From: Qin Dehua <qindehua@gmail.com>
To: rmk+kernel@arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: santosh.shilimkar@ti.com, dan.j.williams@intel.com, neilb@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 2.6.38.8 Kernel make our IOP 341 XScale processor based RAID6 crashes.

After doing a bisection, We found commit
2ffe2da3e71652d4f4cae19539b5c78c2a239136 cause the problem.

That commit is only for ARMv6 and ARMv7 CPUs, so we revert it on
2.6.38.8 Kernel, and then our raid box runs OK.

Following are some kernel messages when the system crashes:

	* The kernel config has CONFIG_ASYNC_PQ=y CONFIG_RAID6_PQ=y

Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = 80004000
[00000000] *pgd=00000000
Internal error: Oops: 817 [#1]
last sysfs file: /sys/block/md1/md/metadata_version
Modules linked in: e1000 mon
CPU: 0    Not tainted  (2.6.32 #140)
PC is at raid5d+0x580/0x58c
LR is at raid5d+0x46c/0x58c
pc : [<80241f20>]    lr : [<80241e0c>]    psr: 20000093
sp : f0fbdf40  ip : f1129a4c  fp : 00000000
r10: 00000000  r9 : 00000000  r8 : 00000000
r7 : f114b2c8  r6 : f0fbc000  r5 : 7fffffff  r4 : f12364a0
r3 : 00000000  r2 : 60000093  r1 : 60000093  r0 : f1129a54
Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 0400397f  Table: 6d1b8018  DAC: 00000035
Process md1_raid6 (pid: 1339, stack limit = 0xf0fbc278)
Stack: (0xf0fbdf40 to 0xf0fbe000)
df40: 803d4780 7fffffff 7fffffff f0fbc000 f114b2c8 f0fbdf74 f1129a54 f1129a4c
df60: f0c60c00 f1129a00 802d985c 802d9264 f0fbc000 f114b2c8 f0fbdfac 00000000
df80: 00000000 f114b2c0 7fffffff f0fbc000 f114b2c8 f0fbdfac 00000000 00000000
dfa0: 00000000 8024ff4c f0fbdfd4 00000000 f0c39800 8004876c f0fbdfb8 f0fbdfb8
dfc0: f0cbfc20 f114b2c0 8024fefc 00000000 00000000 800484d8 00000000 00000000
dfe0: f0fbdfe0 f0fbdfe0 00000000 00000000 00000000 80025888 00000000 00000000
[<80241f20>] (raid5d+0x580/0x58c) from [<8024ff4c>] (md_thread+0x50/0x11c)
[<8024ff4c>] (md_thread+0x50/0x11c) from [<800484d8>] (kthread+0x7c/0x84)
[<800484d8>] (kthread+0x7c/0x84) from [<80025888>] (kernel_thread_exit+0x0/0x8)
Code: ebfff1bc e28dd044 e8bd8ff0 e3a03000 (e5833000)
---[ end trace 21e2ce0d28cdd11a ]---
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = f0dd4000
[00000000] *pgd=70d2b031, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#2]
last sysfs file: /sys/block/md1/md/metadata_version
Modules linked in: e1000 mon
CPU: 0    Tainted: G      D     (2.6.32 #140)
PC is at __release_stripe+0x1e4/0x200
LR is at release_stripe+0x1c/0x24
pc : [<8023c188>]    lr : [<8023c1c0>]    psr: 80000093
sp : f0d61dd0  ip : 00000004  fp : 00000000
r10: 00042000  r9 : 00000000  r8 : eb441bb8
r7 : 00004000  r6 : f12366f8  r5 : f1129a00  r4 : f12366f0
r3 : 00000000  r2 : 20000093  r1 : 00000000  r0 : f1129a00
Flags: Nzcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0400397f  Table: 70dd4018  DAC: 00000015
Process syslogd (pid: 623, stack limit = 0xf0d60278)
Stack: (0xf0d61dd0 to 0xf0d62000)
1dc0:                                     8002d7a4 20000013 f1236b10 f12368c0
1de0: 00004000 8023c1c0 00001000 800a4af4 00004000 8019b350 00000001 00000000
1e00: f19b0000 00000000 00000000 eb441bb8 00000000 eb441bb8 00000000 f105c4a8
1e20: 00000000 8019b6d0 0000001c eb441bb8 eb441bb8 00000000 00000000 8019c200
1e40: 00000002 eb441bb8 f0fb9c80 00000000 00000000 8019c258 f1408920 801f2d68
1e60: 00000000 f1994310 00000000 f105c4a8 00000bb8 00000005 00046000 f0d61ea0
1e80: 00000001 804df75c 00000010 00000100 0000000a f0d60000 804df720 801a0960
1ea0: f0d61ea0 f0d61ea0 00000004 80039998 f1501690 803cfab0 0000006b 0000006b
1ec0: 803d4780 00000000 f1501690 803d0dcc 00000002 00000000 f1501690 80024044
1ee0: ffffffff f0d61f24 000001ad 80024adc f1501690 803d0dcc f1501690 00000000
1f00: 00000020 f1501690 00000020 f1501690 803d0dcc 00000002 00000000 f1501690
1f20: 00000000 f0d61f38 8007e2c4 800ac004 60000013 ffffffff f0d61e38 00020d42
1f40: 00000180 eb419c80 00000004 00000000 00000000 f1507600 00000000 00000020
1f60: f1501690 f0d07000 00000004 eb419c80 f0d60000 00000000 7ecb9724 8007e2c4
1f80: 00000000 00000000 00000123 00000d41 7ecb9f08 00000000 00000005 80025044
1fa0: 2ac90000 80024ea0 00000d41 7ecb9f08 7ecb9f08 00020d41 00000180 00000000
1fc0: 00000d41 7ecb9f08 00000000 00000005 7ecb9f08 00000038 2ac90000 7ecb9724
1fe0: 000b1aa8 7ecb9218 2ac41a9c 2ac2949c 60000010 7ecb9f08 00000000 00000000
[<8023c188>] (__release_stripe+0x1e4/0x200) from [<8023c1c0>]
(release_stripe+0x1c/0x24)
[<8023c1c0>] (release_stripe+0x1c/0x24) from [<800a4af4>] (bio_endio+0x48/0x64)
[<800a4af4>] (bio_endio+0x48/0x64) from [<8019b350>]
(blk_update_request+0x8c/0x3f4)
[<8019b350>] (blk_update_request+0x8c/0x3f4) from [<8019b6d0>]
(blk_update_bidi_request+0x18/0x60)
[<8019b6d0>] (blk_update_bidi_request+0x18/0x60) from [<8019c200>]
(blk_end_bidi_request+0x14/0x5c)
[<8019c200>] (blk_end_bidi_request+0x14/0x5c) from [<8019c258>]
(blk_end_request+0x10/0x18)
[<8019c258>] (blk_end_request+0x10/0x18) from [<801f2d68>]
(scsi_io_completion+0x74/0x4c0)
[<801f2d68>] (scsi_io_completion+0x74/0x4c0) from [<801a0960>]
(blk_done_softirq+0x80/0x98)
[<801a0960>] (blk_done_softirq+0x80/0x98) from [<80039998>]
(__do_softirq+0x88/0x11c)
[<80039998>] (__do_softirq+0x88/0x11c) from [<80024044>] (asm_do_IRQ+0x44/0x8c)
[<80024044>] (asm_do_IRQ+0x44/0x8c) from [<80024adc>] (__irq_svc+0x3c/0x80)
Exception stack(0xf0d61ef0 to 0xf0d61f38)
1ee0:                                     f1501690 803d0dcc f1501690 00000000
1f00: 00000020 f1501690 00000020 f1501690 803d0dcc 00000002 00000000 f1501690
1f20: 00000000 f0d61f38 8007e2c4 800ac004 60000013 ffffffff
[<80024adc>] (__irq_svc+0x3c/0x80) from [<800ac004>] (fsnotify+0x124/0x170)
[<800ac004>] (fsnotify+0x124/0x170) from [<8007e2c4>] (do_sys_open+0xac/0xe4)
[<8007e2c4>] (do_sys_open+0xac/0xe4) from [<80024ea0>]
(ret_fast_syscall+0x0/0x38)
Code: e59300f0 eb002b2f eaffffe2 e1a03001 (e5833000)
---[ end trace 21e2ce0d28cdd11b ]---
Kernel panic - not syncing: Fatal exception in interrupt

Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = 80004000
[00000000] *pgd=00000000
Internal error: Oops: 817 [#1]
last sysfs file: /sys/block/md1/md/metadata_version
Modules linked in: e1000 mon
CPU: 0    Not tainted  (2.6.32 #140)
PC is at get_active_stripe+0x5a4/0x66c
LR is at sync_request+0xe4/0xea4
pc : [<8023edac>]    lr : [<80242fc4>]    psr: 40000093
sp : eb2dddb0  ip : 00000000  fp : f11292dc
r10: 00012bd0  r9 : 00000000  r8 : 00012bd0
r7 : 00000000  r6 : f0cee940  r5 : eb2dc000  r4 : f1129200
r3 : 00000000  r2 : f1330008  r1 : 00000000  r0 : f0cee940
Flags: nZcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 0400397f  Table: 6ac1c018  DAC: 00000035
Process md1_resync (pid: 3698, stack limit = 0xeb2dc278)
Stack: (0xeb2dddb0 to 0xeb2de000)
dda0:                                     00000000 00000001 00000000 00000000
ddc0: 00000000 00000000 00000000 000005e8 00000000 00000000 00000001 00000001
dde0: 000000e8 00000000 00000002 f1129200 00000001 00000000 00000001 eb2dde94
de00: 00000000 00012bd0 f0c3cc00 80242fc4 00000000 00000001 00000000 00000000
de20: f10c15c0 802090f0 f19b0000 80209404 ebbfd000 80000013 00012bd0 00000000
de40: f1981000 f105c4a8 f1981000 8019bf84 f10880c0 f1088000 f1981000 f1088000
de60: 00000008 00000000 f0c3cc00 f105c4a8 00000003 f1129200 00000004 f0c3cc00
de80: 00012b00 8019c740 f1053d80 8019ce1c 8003181c 00000400 00000000 000001a8
dea0: 00000000 0000155c f0c3cc00 00012bd0 00000000 00012bd0 00000000 802508a8
dec0: eb2ddf7c 00000001 eb2dc000 f0c3cc2c 00018680 00000000 f0c1cc00 00000002
dee0: 00012b00 00000000 eb40d830 8037fa40 00000000 00000000 000060d8 00000000
df00: 0000f460 00000000 00000000 00000000 00000000 00000000 00000000 00000000
df20: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
df40: 0000e689 0000e7bd 0000e8ea 0000e689 0000e689 0000e689 0000e689 0000e689
df60: 0000e689 0000e689 00000000 eb40d800 8004876c eb2ddf74 eb2ddf74 00000000
df80: edfa601c f10eb3a0 7fffffff eb2dc000 f10eb3a8 eb2ddfac 00000000 00000000
dfa0: 00000000 8024ff4c eb2ddfd4 f0fb5ed0 f10eb3a0 8024fefc 00000000 00000000
dfc0: f0fb5ed0 f10eb3a0 8024fefc 00000000 00000000 800484d8 00000000 00000000
dfe0: eb2ddfe0 eb2ddfe0 00000000 00000000 00000000 80025888 00000000 00000000
[<8023edac>] (get_active_stripe+0x5a4/0x66c) from [<80242fc4>]
(sync_request+0xe4/0xea4)
[<80242fc4>] (sync_request+0xe4/0xea4) from [<802508a8>]
(md_do_sync+0x890/0xd6c)
[<802508a8>] (md_do_sync+0x890/0xd6c) from [<8024ff4c>] (md_thread+0x50/0x11c)
[<8024ff4c>] (md_thread+0x50/0x11c) from [<800484d8>] (kthread+0x7c/0x84)
[<800484d8>] (kthread+0x7c/0x84) from [<80025888>] (kernel_thread_exit+0x0/0x8)
Code: e5903028 e3130c02 1affff56 e3a03000 (e5833000)
---[ end trace 21e2ce0d28cdd11a ]---

Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = 80004000
[00000000] *pgd=00000000
Internal error: Oops: 817 [#1]
last sysfs file: /sys/block/md1/md/metadata_version
Modules linked in: e1000 mon
CPU: 0    Not tainted  (2.6.32 #140)
PC is at raid5d+0x580/0x58c
LR is at raid5d+0x46c/0x58c
pc : [<80241f20>]    lr : [<80241e0c>]    psr: 20000093
sp : f0fa9f40  ip : f0c22c4c  fp : 00000000
r10: 00000000  r9 : 00000000  r8 : 00000000
r7 : f1155468  r6 : f0fa8000  r5 : 7fffffff  r4 : f0e864a0
r3 : 00000000  r2 : 60000093  r1 : 60000093  r0 : f0c22c54
Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 0400397f  Table: 6b740018  DAC: 00000035
Process md1_raid6 (pid: 1296, stack limit = 0xf0fa8278)
Stack: (0xf0fa9f40 to 0xf0faa000)
9f40: 00000000 7fffffff 7fffffff f0fa8000 f1155468 f0fa9f74 f0c22c54 f0c22c4c
9f60: f0ddec00 f0c22c00 802d985c 802d9264 f1155460 7fffffff f0fa8000 f1155468
9f80: f0fa9fac f1155460 7fffffff f0fa8000 f1155468 f0fa9fac 00000000 00000000
9fa0: 00000000 8024ff4c f0fa9fd4 00000000 f0c40c00 8004876c f0fa9fb8 f0fa9fb8
9fc0: f0ccbc20 f1155460 8024fefc 00000000 00000000 800484d8 00000000 00000000
9fe0: f0fa9fe0 f0fa9fe0 00000000 00000000 00000000 80025888 00000000 00000000
[<80241f20>] (raid5d+0x580/0x58c) from [<8024ff4c>] (md_thread+0x50/0x11c)
[<8024ff4c>] (md_thread+0x50/0x11c) from [<800484d8>] (kthread+0x7c/0x84)
[<800484d8>] (kthread+0x7c/0x84) from [<80025888>] (kernel_thread_exit+0x0/0x8)
Code: ebfff1bc e28dd044 e8bd8ff0 e3a03000 (e5833000)
---[ end trace aa8b689e041c4730 ]---


Regards,
QinDehua

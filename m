Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab1CEKqt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 05:46:49 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:58333 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752180Ab1CEKqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 05:46:47 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Daniel Willerud <daniel.willerud@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Karl Komierowski <karl.komierowski@stericsson.com>,
        Johan Palsson <johan.palsson@stericsson.com>,
        Arun Murthy <arun.murthy@stericsson.com>
Subject: [PATCH 0/5] ab8500 gpadc fixes
Date: Sat, 5 Mar 2011 11:45:35 +0100
Message-ID: <1299321935-6727-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

I have broken Daniels patch apart, fixed the GPADC fetch
interface as agreed with Sam, added the proper authorship of
the calibration patch to Johan and also put a new patch from
Karl Komierowski to fix proper charging ADC on top.

I had to do this now beacue the current driver that is in the
tree makes my platform crash ([2/5] fixes that problem) like
this:

Unable to handle kernel NULL pointer dereference at virtual address 0000001c
pgd = c0004000
[0000001c] *pgd=00000000
Internal error: Oops: 805 [#1] PREEMPT SMP
last sysfs file: 
Modules linked in:
CPU: 0    Not tainted  (2.6.38-rc7-00104-ga0fdbad #9)
PC is at __mutex_init+0x8/0x28
LR is at ab8500_gpadc_probe+0xa4/0x15c
pc : [<c0210e88>]    lr : [<c0388bac>]    psr: 20000013
sp : cf833f38  ip : 00000000  fp : 00000000
r10: 00000000  r9 : 00000000  r8 : 00000000
r7 : cf8b7608  r6 : 00000000  r5 : c049b3a0  r4 : cf8e27c0
r3 : 00000001  r2 : 00000028  r1 : c0410131  r0 : 0000001c
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 10c5787f  Table: 0000404a  DAC: 00000015
Process swapper (pid: 1, stack limit = 0xcf8322f0)
Stack: (0xcf833f38 to 0xcf834000)
3f20:                                                       cf8b7600 00000001
3f40: cf8b7608 cf8b7608 c046de3c c046de3c 00000000 c03226ec c03226d8 c032183c
3f60: c046de3c cf8b7608 cf8b763c c046de3c 00000000 c0321970 c046de3c c0321910
3f80: 00000000 c0321084 cf82e040 cf8e0998 c046de3c cf8e64e0 c046cce0 c0320a3c
3fa0: c040fd8c c040fd8c 00000000 c046de3c c0008650 c001b050 00000000 c0321cc0
3fc0: 00000000 c001fce8 c0008650 c01d5570 c001fecc c001fce8 c0008650 c01dbb98
3fe0: 00000013 c0008430 cf832000 c00086a8 00000000 c01dbb98 10423a01 d53f6c9f
[<c0210e88>] (__mutex_init+0x8/0x28) from [<c0388bac>] (ab8500_gpadc_probe+0xa4/0x15c)
[<c0388bac>] (ab8500_gpadc_probe+0xa4/0x15c) from [<c03226ec>] (platform_drv_probe+0x14/0x18)
[<c03226ec>] (platform_drv_probe+0x14/0x18) from [<c032183c>] (really_probe+0x98/0x148)
[<c032183c>] (really_probe+0x98/0x148) from [<c0321970>] (__driver_attach+0x60/0x84)
[<c0321970>] (__driver_attach+0x60/0x84) from [<c0321084>] (bus_for_each_dev+0x48/0x74)
[<c0321084>] (bus_for_each_dev+0x48/0x74) from [<c0320a3c>] (bus_add_driver+0xa8/0x19c)
[<c0320a3c>] (bus_add_driver+0xa8/0x19c) from [<c0321cc0>] (driver_register+0xa8/0xe0)
[<c0321cc0>] (driver_register+0xa8/0xe0) from [<c01d5570>] (do_one_initcall+0x34/0xf8)
[<c01d5570>] (do_one_initcall+0x34/0xf8) from [<c0008430>] (do_initcalls+0x14/0x2c)
[<c0008430>] (do_initcalls+0x14/0x2c) from [<c00086a8>] (kernel_init+0x58/0xf0)
[<c00086a8>] (kernel_init+0x58/0xf0) from [<c01dbb98>] (kernel_thread_exit+0x0/0x8)
Code: e3e00005 eaffffad e3a03001 e280200c (e5803000) 
---[ end trace 1b75b31a2719ed1c ]---

The reason is that the mutex is initalized before the struct holding it
is allocated. Since Daniels patches also fixes this the path of least
resistance was to step in and just split this patchset and fix the
last interface change as agreed with Sam.

(Hope you don't mind Daniel.)

Daniel Willerud (3):
  mfd: move ab8500 gpadc header to subdir
  mfd: reentrance and revamp ab8500 gpadc fetching interface
  mfd: free dangling irq in ab8500 gpadc probe error path

Johan Palsson (1):
  mfd: calibrate ab8500 gpadc using OTP values

Karl Komierowski (1):
  mfd: fix ab8500-gpadc to measure charger current

 drivers/mfd/ab8500-gpadc.c              |  422 +++++++++++++++++++++++++++----
 include/linux/mfd/ab8500-gpadc.h        |   28 --
 include/linux/mfd/ab8500/ab8500-gpadc.h |   32 +++
 3 files changed, 402 insertions(+), 80 deletions(-)
 delete mode 100644 include/linux/mfd/ab8500-gpadc.h
 create mode 100644 include/linux/mfd/ab8500/ab8500-gpadc.h

-- 
1.7.3.2


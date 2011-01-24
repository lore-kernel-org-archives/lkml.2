Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab1AXJ3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 04:29:45 -0500
Received: from vwp2514.webpack.hosteurope.de ([87.230.42.24]:58470 "EHLO
	vwp2514.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751236Ab1AXJ3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 04:29:44 -0500
Subject: kernel NULL pointer dereference in pxa_pm_enter (2.6.38-rc2)
From: Sven Neumann <s.neumann@raumfeld.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>, Daniel Mack <daniel@caiaq.de>
Content-Type: text/plain; charset="UTF-8"
Organization: RAUMFELD GmbH
Date: Mon, 24 Jan 2011 10:29:39 +0100
Message-ID: <1295861380.2044.26.camel@sven>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;s.neumann@raumfeld.com;1295861383;a048aa10;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am still trying to get our Raumfeld platform working with kernels
newer than 2.6.36 and this morning I've updated to 2.6.38-rc2 to see if
any of the remaining problems with 2.6.37 have been fixed. Kernel boots
fine, but it crashes on suspend:

[   95.701660] PM: Syncing filesystems ... done.
[   95.749352] Freezing user space processes ... (elapsed 0.02 seconds) done.
[   95.776504] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[   95.797795] dac7512 spi0.2: ... can't suspend
[   95.803906] libertas: mmc0:0001:1: suspend: PM flags = 0x0
[   95.809362] libertas: Suspend without wake params -- powering down card.
[   95.816103] hub 1-0:1.0: hub_suspend
[   95.819873] usb usb1: bus suspend
[   95.823170] pxa27x-ohci pxa27x-ohci: suspend root hub
[   95.834919] mmc0: card 0001 removed
[   95.839158] PM: suspend of devices complete after 41.589 msecs
[   95.846167] PM: late suspend of devices complete after 1.111 msecs
[   95.852603] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[   95.860642] pgd = c6700000
[   95.863327] [00000000] *pgd=a67fb831, *pte=00000000, *ppte=00000000
[   95.869571] Internal error: Oops: 80000005 [#1]
[   95.874071] last sysfs file: /sys/power/state
[   95.878397] Modules linked in: eeti_ts libertas_sdio libertas pxamci ds2760_battery w1_ds2760 wire
[   95.887354] CPU: 0    Not tainted  (2.6.38-rc2+ #102)
[   95.892377] PC is at 0x0
[   95.894924] LR is at pxa_pm_enter+0x4c/0x120
[   95.899167] pc : [<00000000>]    lr : [<c0051dcc>]    psr: 20000093
[   95.899178] sp : c6749ee0  ip : 00000093  fp : 0003a490
[   95.910568] r10: 00000004  r9 : c681c458  r8 : c6832000
[   95.915756] r7 : 00000003  r6 : 00000000  r5 : c052f1a8  r4 : c052f1a4
[   95.922244] r3 : c0510778  r2 : a6700018  r1 : c63f4120  r0 : 00000010
[   95.928733] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
[   95.935908] Control: 0000397f  Table: a6700018  DAC: 00000015
[   95.941619] Process raumfeld-master (pid: 1246, stack limit = 0xc6748278)
[   95.948366] Stack: (0xc6749ee0 to 0xc674a000)
[   95.952701] 9ee0: c0383958 00000000 00000000 00000003 c0383958 c0086aa8 00000000 00000003
[   95.960832] 9f00: 00000003 c0086c04 00000101 c04936bc 00000003 c0086320 00016798 00000004
[   95.968966] 9f20: c60177e0 c681c440 c60167c0 c0413f54 c6749f80 c0196074 00000004 c00f7b78
[   95.977099] 9f40: c6742e80 00000004 00016798 c6749f80 00016798 c6748000 00020000 c00b4184
[   95.985231] 9f60: c527fa20 c6742e88 00000000 00000000 c6742e80 00000004 00016798 c00b42c8
[   95.993364] 9f80: 00000000 00000000 00010658 00000001 0000000b beca8baf 407c52f0 00000004
[   96.001496] 9fa0: c0049144 c0048fc0 0000000b beca8baf 0000000b 00016798 00000004 00000000
[   96.009630] 9fc0: 0000000b beca8baf 407c52f0 00000004 407c613c 00039ee0 00000000 0003a490
[   96.017763] 9fe0: 0001f9f8 beca8ba0 00010840 40802f84 20000010 0000000b 00000000 00000000
[   96.025932] [<c0051dcc>] (pxa_pm_enter+0x4c/0x120) from [<c0086aa8>] (suspend_devices_and_enter+0x100/0x1ac)
[   96.035714] [<c0086aa8>] (suspend_devices_and_enter+0x100/0x1ac) from [<c0086c04>] (enter_state+0xb0/0xf4)
[   96.045317] [<c0086c04>] (enter_state+0xb0/0xf4) from [<c0086320>] (state_store+0x94/0xc8)
[   96.053560] [<c0086320>] (state_store+0x94/0xc8) from [<c0196074>] (kobj_attr_store+0x1c/0x24)
[   96.062146] [<c0196074>] (kobj_attr_store+0x1c/0x24) from [<c00f7b78>] (sysfs_write_file+0x104/0x13c)
[   96.071341] [<c00f7b78>] (sysfs_write_file+0x104/0x13c) from [<c00b4184>] (vfs_write+0xac/0x138)
[   96.080084] [<c00b4184>] (vfs_write+0xac/0x138) from [<c00b42c8>] (sys_write+0x40/0x6c)
[   96.088072] [<c00b42c8>] (sys_write+0x40/0x6c) from [<c0048fc0>] (ret_fast_syscall+0x0/0x2c)
[   96.096467] Code: bad PC value
[   96.099501] ---[ end trace 99a4afc7272fd902 ]---


I've added some printk() statements and found that pxa_cpu_pm_fns->save
and pxa_cpu_pm_fns->restore are both NULL. As far as I can see pxa25x.c
and pxa27x.c both set the save and restore function pointers, pxa3xx.c
however doesn't. Is this functionality missing from pxa3xx.c or should 
pxa_pm_enter() check if the function pointers are set before using them?


Regards,
Sven



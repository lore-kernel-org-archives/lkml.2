Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab1KUKOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 05:14:44 -0500
Received: from vwp2514.webpack.hosteurope.de ([87.230.42.24]:42465 "EHLO
	vwp2514.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754442Ab1KUKOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:14:40 -0500
Message-ID: <1321870472.2085.12.camel@sven>
Subject: Re: Oops on suspend with libertas SDIO (Linux 3.2-rc2)
From: Sven Neumann <s.neumann@raumfeld.com>
To: Daniel Mack <zonque@gmail.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Chris Ball <cjb@laptop.org>, Daniel Drake <dsd@laptop.org>,
        Dan Williams <dcbw@redhat.com>, linux-mmc@vger.kernel.org,
        libertas-dev@lists.infradead.org, linux-kernel@vger.kernel.org,
        "linux-pm >> Linux PM mailing list" <linux-pm@vger.kernel.org>
Date: Mon, 21 Nov 2011 11:14:32 +0100
In-Reply-To: <CACTFLANdc-PaaeR7CcAFsc7VztvPmGF+q4saqtA-UtuBvQxwkg@mail.gmail.com>
References: <1321544210.31090.6.camel@sven> <87zkfuhhpq.fsf@laptop.org>
	 <4EC55E34.3080503@linux.vnet.ibm.com>
	 <CACTFLANdc-PaaeR7CcAFsc7VztvPmGF+q4saqtA-UtuBvQxwkg@mail.gmail.com>
Organization: RAUMFELD GmbH
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-bounce-key: webpack.hosteurope.de;s.neumann@raumfeld.com;1321870480;d9dda341;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2011-11-18 at 15:02 +0100, Daniel Mack wrote:

> >> Looks like mmc_sdio_remove() calls mmc_remove_card() after the
> >> reset_card function has called mmc_remove_host() already.  Maybe
> >> if_sdio_reset_card_worker() should call mmc_free_host() as well?
> 
> >From a quick look is seems we need better housekeeping of the
> reset_host variable.
> 
> Does this (untested) patch help?

No, it still oopses with this patch applied:

[  102.965924] PM: Syncing filesystems ... done.
[  103.016139] Freezing user space processes ... (elapsed 0.02 seconds) done.
[  103.045535] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  103.069910] libertas_sdio mmc0:0001:1: mmc0:0001:1: suspend: PM flags = 0x0
[  103.076923] libertas_sdio mmc0:0001:1: Suspend without wake params -- powering down card
[  106.092767] libertas_sdio mmc0:0001:1: wlan0: command 0x0010 timed out
[  106.099330] libertas_sdio mmc0:0001:1: wlan0: Timeout submitting command 0x0010
[  106.106725] libertas_sdio: Resetting card...
[  106.110837] ------------[ cut here ]------------
[  106.115702] WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0x50/0x11c()
[  106.122748] sysfs group c05cb5c8 not found for kobject 'mmc0:0001:1'
[  106.129057] Modules linked in: libertas_sdio libertas pxamci
[  106.134783] [<c000dbb4>] (unwind_backtrace+0x0/0xec) from [<c001ca10>] (warn_slowpath_common+0x4c/0x64)
[  106.144158] [<c001ca10>] (warn_slowpath_common+0x4c/0x64) from [<c001cabc>] (warn_slowpath_fmt+0x30/0x40)
[  106.153711] [<c001cabc>] (warn_slowpath_fmt+0x30/0x40) from [<c00d36d4>] (sysfs_remove_group+0x50/0x11c)
[  106.163193] [<c00d36d4>] (sysfs_remove_group+0x50/0x11c) from [<c0202f04>] (device_del+0x3c/0x1a4)
[  106.172128] [<c0202f04>] (device_del+0x3c/0x1a4) from [<c0295e3c>] (sdio_remove_func+0x1c/0x2c)
[  106.180816] [<c0295e3c>] (sdio_remove_func+0x1c/0x2c) from [<c0295150>] (mmc_sdio_remove+0x44/0x78)
[  106.189852] [<c0295150>] (mmc_sdio_remove+0x44/0x78) from [<c028f124>] (mmc_stop_host+0xd0/0x22c)
[  106.198707] [<c028f124>] (mmc_stop_host+0xd0/0x22c) from [<c02905b8>] (mmc_remove_host+0x18/0x2c)
[  106.207587] [<c02905b8>] (mmc_remove_host+0x18/0x2c) from [<bf019470>] (if_sdio_reset_card_worker+0x18/0x2c [libertas_sdio])
[  106.218820] [<bf019470>] (if_sdio_reset_card_worker+0x18/0x2c [libertas_sdio]) from [<c00302fc>] (process_one_work+0x260/0x3c8)
[  106.230280] [<c00302fc>] (process_one_work+0x260/0x3c8) from [<c0030ac8>] (worker_thread+0x224/0x458)
[  106.239498] [<c0030ac8>] (worker_thread+0x224/0x458) from [<c0036a00>] (kthread+0x80/0x88)
[  106.247758] [<c0036a00>] (kthread+0x80/0x88) from [<c0009ca8>] (kernel_thread_exit+0x0/0x8)
[  106.256091] ---[ end trace ba085a5f8ea6593c ]---
[  106.260692] Unable to handle kernel NULL pointer dereference at virtual address 0000000c
[  106.268759] pgd = c0004000
[  106.271445] [0000000c] *pgd=00000000
[  106.275032] Internal error: Oops: 17 [#1] PREEMPT
[  106.279698] Modules linked in: libertas_sdio libertas pxamci
[  106.285348] CPU: 0    Tainted: G        W     (3.2.0-rc2 #1)
[  106.290999] PC is at klist_put+0x18/0x9c
[  106.294905] LR is at device_del+0x50/0x1a4
[  106.298978] pc : [<c03ca92c>]    lr : [<c0202f18>]    psr: a0000013
[  106.298989] sp : c656ff18  ip : 40000013  fp : c602e605
[  106.310379] r10: 00000000  r9 : bf019458  r8 : c602e600
[  106.315566] r7 : 00000000  r6 : c63ff408  r5 : c6461f70  r4 : 00000001
[  106.322054] r3 : 00000000  r2 : 00000200  r1 : 00000001  r0 : 00000001
[  106.328543] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[  106.335805] Control: 0000397f  Table: a665c018  DAC: 00000035
[  106.341507] Process kworker/0:2 (pid: 1196, stack limit = 0xc656e278)
[  106.347909] Stack: (0xc656ff18 to 0xc6570000)
[  106.352236] ff00:                                                       c64cef08 c63ff000
[  106.360368] ff20: c63ff408 c0202f18 c64cef08 c63ff000 00000084 c0295e3c 00000001 c0295150
[  106.368501] ff40: c64f1c00 c63ff000 60000013 00000000 00000009 c028f124 c63ff000 c63ff000
[  106.376635] ff60: c64f1c00 c02905b8 bf019c9c bf019470 bf019af0 c00302fc c05c1b38 c64f1c00
[  106.384767] ff80: c05c1b38 c05c1b38 00000009 c656e000 c64f1c10 c05c1b38 c64f1c10 c0030ac8
[  106.392899] ffa0: c607df14 c656ffd4 c607df14 c64f1c00 c00308a4 00000000 00000000 00000000
[  106.401032] ffc0: 00000000 c0036a00 c0009ca8 00000000 c64f1c00 00000000 c656ffd8 c656ffd8
[  106.409165] ffe0: 00000000 c607df14 c0036980 c0009ca8 00000013 c0009ca8 0340f30e 153b5900
[  106.417309] [<c03ca92c>] (klist_put+0x18/0x9c) from [<c0202f18>] (device_del+0x50/0x1a4)
[  106.425368] [<c0202f18>] (device_del+0x50/0x1a4) from [<c0295e3c>] (sdio_remove_func+0x1c/0x2c)
[  106.434025] [<c0295e3c>] (sdio_remove_func+0x1c/0x2c) from [<c0295150>] (mmc_sdio_remove+0x44/0x78)
[  106.443027] [<c0295150>] (mmc_sdio_remove+0x44/0x78) from [<c028f124>] (mmc_stop_host+0xd0/0x22c)
[  106.451847] [<c028f124>] (mmc_stop_host+0xd0/0x22c) from [<c02905b8>] (mmc_remove_host+0x18/0x2c)
[  106.460687] [<c02905b8>] (mmc_remove_host+0x18/0x2c) from [<bf019470>] (if_sdio_reset_card_worker+0x18/0x2c [libertas_sdio])
[  106.471864] [<bf019470>] (if_sdio_reset_card_worker+0x18/0x2c [libertas_sdio]) from [<c00302fc>] (process_one_work+0x260/0x3c8)
[  106.483283] [<c00302fc>] (process_one_work+0x260/0x3c8) from [<c0030ac8>] (worker_thread+0x224/0x458)
[  106.492456] [<c0030ac8>] (worker_thread+0x224/0x458) from [<c0036a00>] (kthread+0x80/0x88)
[  106.500684] [<c0036a00>] (kthread+0x80/0x88) from [<c0009ca8>] (kernel_thread_exit+0x0/0x8)
[  106.508991] Code: e1a05000 e3a00001 e3c33001 e1a04001 (e593600c) 
[  106.515109] ---[ end trace ba085a5f8ea6593d ]---
[  106.519881] Unable to handle kernel paging request at virtual address fffffffc
[  106.527056] pgd = c0004000
[  106.529742] [fffffffc] *pgd=a7ffe821, *pte=00000000, *ppte=00000000
[  106.535986] Internal error: Oops: 17 [#2] PREEMPT
[  106.540657] Modules linked in: libertas_sdio libertas pxamci
[  106.546306] CPU: 0    Tainted: G      D W     (3.2.0-rc2 #1)
[  106.551941] PC is at kthread_data+0x4/0xc
[  106.555928] LR is at wq_worker_sleeping+0xc/0xb4
[  106.560514] pc : [<c003648c>]    lr : [<c0032ee0>]    psr: 20000093
[  106.560525] sp : c656fd60  ip : c05bff98  fp : c656fd94
[  106.571916] r10: c659b6ec  r9 : c05bff98  r8 : c656e000
[  106.577104] r7 : c6032000  r6 : c659b768  r5 : c659b600  r4 : 00000000
[  106.583582] r3 : 00000000  r2 : c05bff98  r1 : 00000000  r0 : c659b600
[  106.590064] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
[  106.597239] Control: 0000397f  Table: a665c018  DAC: 00000015
[  106.602940] Process kworker/0:2 (pid: 1196, stack limit = 0xc656e278)
[  106.609333] Stack: (0xc656fd60 to 0xc6570000)
[  106.613670] fd60: 00000000 c03d278c 00000000 00000001 c656fd9c c659b600 c6032000 c659b6ec
[  106.621801] fd80: c659b5f8 c659b6ec 00000001 c656fd98 c0020acc c03d268c 00000000 c656fd9c
[  106.629935] fda0: c656fd9c c659b734 c602e605 c656fed0 c659b600 c656e000 00000000 c04ef7d8
[  106.638068] fdc0: 00000017 c656fed0 c602e605 c000c51c c656e278 0000000b 0000000c c656fed0
[  106.646200] fde0: 00000000 00000017 00000000 c000ee00 c05bbbcc c659b600 00000000 0000000c
[  106.654333] fe00: 0000000c c000effc c003b1ac c0015e8c c05bbbcc a0000013 00000017 c656fed0
[  106.662466] fe20: 0000000c bf019458 00000000 c000849c 00000025 c656fe65 c05fffaf c656fe48
[  106.670600] fe40: c001dc78 c0015e8c 00000000 80000013 c0036980 205b6a00 36303120 3635322e
[  106.678732] fe60: 5d313930 00000020 00000000 00000000 c656fff8 c0009ca8 00000000 c000c2dc
[  106.686865] fe80: c04eee5e c0036a00 00000004 0056fea8 c00d36d4 0000008a c04f71e0 c00d36d4
[  106.694998] fea0: c656fef0 00000009 bf019458 00000000 c602e605 c03d24dc c03ca92c a0000013
[  106.703130] fec0: ffffffff c656ff04 c602e600 c0008e98 00000001 00000001 00000200 00000000
[  106.711264] fee0: 00000001 c6461f70 c63ff408 00000000 c602e600 bf019458 00000000 c602e605
[  106.719397] ff00: 40000013 c656ff18 c0202f18 c03ca92c a0000013 ffffffff c64cef08 c63ff000
[  106.727530] ff20: c63ff408 c0202f18 c64cef08 c63ff000 00000084 c0295e3c 00000001 c0295150
[  106.735662] ff40: c64f1c00 c63ff000 60000013 00000000 00000009 c028f124 c63ff000 c63ff000
[  106.743796] ff60: c64f1c00 c02905b8 bf019c9c bf019470 bf019af0 c00302fc c05c1b38 c64f1c00
[  106.751929] ff80: c05c1b38 c05c1b38 00000009 c656e000 c64f1c10 c05c1b38 c64f1c10 c0030ac8
[  106.760060] ffa0: c607df14 c656ffd4 c607df14 c64f1c00 c00308a4 00000000 00000000 00000000
[  106.768194] ffc0: 00000000 c0036a00 c0009ca8 00000000 c64f1c00 00000001 c656ffd8 c656ffd8
[  106.776328] ffe0: 00000000 c607df14 c0036980 c0009ca8 00000013 c0009ca8 0340f30e 153b5900
[  106.784471] [<c003648c>] (kthread_data+0x4/0xc) from [<c0032ee0>] (wq_worker_sleeping+0xc/0xb4)
[  106.793132] [<c0032ee0>] (wq_worker_sleeping+0xc/0xb4) from [<c03d278c>] (__schedule+0x10c/0x3a8)
[  106.801975] [<c03d278c>] (__schedule+0x10c/0x3a8) from [<c0020acc>] (do_exit+0x668/0x694)
[  106.810120] [<c0020acc>] (do_exit+0x668/0x694) from [<c000c51c>] (die+0x1f0/0x220)
[  106.817658] [<c000c51c>] (die+0x1f0/0x220) from [<c000ee00>] (__do_kernel_fault+0x64/0x88)
[  106.825880] [<c000ee00>] (__do_kernel_fault+0x64/0x88) from [<c000effc>] (do_page_fault+0x1d8/0x1f0)
[  106.834968] [<c000effc>] (do_page_fault+0x1d8/0x1f0) from [<c000849c>] (do_DataAbort+0x34/0x94)
[  106.843621] [<c000849c>] (do_DataAbort+0x34/0x94) from [<c0008e98>] (__dabt_svc+0x38/0x60)
[  106.851830] Exception stack(0xc656fed0 to 0xc656ff18)
[  106.856848] fec0:                                     00000001 00000001 00000200 00000000
[  106.864979] fee0: 00000001 c6461f70 c63ff408 00000000 c602e600 bf019458 00000000 c602e605
[  106.873110] ff00: 40000013 c656ff18 c0202f18 c03ca92c a0000013 ffffffff
[  106.879705] [<c0008e98>] (__dabt_svc+0x38/0x60) from [<c03ca92c>] (klist_put+0x18/0x9c)
[  106.887679] [<c03ca92c>] (klist_put+0x18/0x9c) from [<c0202f18>] (device_del+0x50/0x1a4)
[  106.895743] [<c0202f18>] (device_del+0x50/0x1a4) from [<c0295e3c>] (sdio_remove_func+0x1c/0x2c)
[  106.904400] [<c0295e3c>] (sdio_remove_func+0x1c/0x2c) from [<c0295150>] (mmc_sdio_remove+0x44/0x78)
[  106.913400] [<c0295150>] (mmc_sdio_remove+0x44/0x78) from [<c028f124>] (mmc_stop_host+0xd0/0x22c)
[  106.922221] [<c028f124>] (mmc_stop_host+0xd0/0x22c) from [<c02905b8>] (mmc_remove_host+0x18/0x2c)
[  106.931063] [<c02905b8>] (mmc_remove_host+0x18/0x2c) from [<bf019470>] (if_sdio_reset_card_worker+0x18/0x2c [libertas_sdio])
[  106.942250] [<bf019470>] (if_sdio_reset_card_worker+0x18/0x2c [libertas_sdio]) from [<c00302fc>] (process_one_work+0x260/0x3c8)
[  106.953665] [<c00302fc>] (process_one_work+0x260/0x3c8) from [<c0030ac8>] (worker_thread+0x224/0x458)
[  106.962840] [<c0030ac8>] (worker_thread+0x224/0x458) from [<c0036a00>] (kthread+0x80/0x88)
[  106.971065] [<c0036a00>] (kthread+0x80/0x88) from [<c0009ca8>] (kernel_thread_exit+0x0/0x8)
[  106.979365] Code: e593313c e5130008 e12fff1e e590313c (e5130004) 
[  106.985555] ---[ end trace ba085a5f8ea6593e ]---
[  106.990144] Fixing recursive fault but reboot is needed!
[  106.995474] Unable to handle kernel paging request at virtual address fffffffc


Sven




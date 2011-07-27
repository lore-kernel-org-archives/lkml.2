Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab1G0J0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:26:53 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:47580 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab1G0J0w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:26:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAMzZzFGqPv6Nbw8J8JGNKcLA76sAs3oD6+hH9NPCjwA33fYpOQ@mail.gmail.com>
References: <CAMzZzFGqPv6Nbw8J8JGNKcLA76sAs3oD6+hH9NPCjwA33fYpOQ@mail.gmail.com>
Date: Wed, 27 Jul 2011 17:26:50 +0800
Message-ID: <CAMzZzFGpDiFAhsLAb+SQxjbGMzBoOStF_Lr7Eb3PT6Drcf=VdA@mail.gmail.com>
Subject: Oops when insmod rtl8192ce
From: hubert Liao <liao.hubertt@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
We got an oops when insmod rtl8192ce module (the board is an ARM soc),
accroding the oops message, find it's because in rtl_pci_probe()
called _rtl_pci_find_adapter(),
in this funcation, the  pdev->bus->self is a NULL pointer .
static boot _rtl_pci_find_adapter(strcut pci_dev *dev,
              struct ieee80211_hw *hw)
{
struct pci_dev *bridge_pdev = pdev->bus->self;   //line 1601
...
pcipriv->ndis_adapter.pcibridge_vendorid = bridge_pdev->vendor; <--
[oops here] line 1700
...
}
here, I just want to know why the bus->self  is NULL?
----
[  148.186632] Unable to handle kernel NULL pointer dereference at
virtual address 00000020
[  148.195255] pgd = cfb40000
[  148.198178] [00000020] *pgd=0e54d831, *pte=00000000, *ppte=00000000
[  148.204743] Internal error: Oops: 17 [#1] PREEMPT
[  148.209426] Modules linked in: rtl8192ce(+) rtl8192c_common rtlwifi
[  148.215702] CPU: 0    Not tainted  (3.0.0-05684-ge371d46 #34)
[  148.221453] PC is at rtl_pci_probe+0x398/0x1bd8 [rtlwifi]
[  148.226827] LR is at 0x4
[  148.229356] pc : [<bf00fdc0>]    lr : [<00000004>]    psr: 80000013
[  148.229364] sp : cfb37d10  ip : bf012606  fp : ce518dc0
[  148.240800] r10: ce51abbc  r9 : 00008178  r8 : cf807000
[  148.246001] r7 : 00004000  r6 : 00000000  r5 : 00000000  r4 : 1fff7fff
[  148.252498] r3 : 0000037c  r2 : 00000000  r1 : bf012584  r0 : 00000000
[  148.258997] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[  148.266108] Control: 0005397f  Table: 0fb40000  DAC: 00000015
[  148.271826] Process insmod (pid: 650, stack limit = 0xcfb36270)
[  148.277718] Stack: (0xcfb37d10 to 0xcfb38000)
[  148.282061] 7d00:                                     00000000
c018928c 00000000 ce54f870
[  148.290212] 7d20: 00000001 cf804680 bf012584 ce518240 ce518dc0
ce51abbc cf807060 000010ec
[  148.298368] 7d40: 00000000 ce54f810 cfb37d90 c00f2194 00000000
000012c7 cfb37d90 ce54f810
[  148.306524] 7d60: cfb37d90 c00f22f8 00000109 01000000 cfb37d90
bf043c80 cf807000 00000000
[  148.314672] 7d80: bf043c50 cfa7df00 c054ba00 bf043c80 bf049000
c01a8d80 bf043c80 c01a901c
[  148.322828] 7da0: cf807068 bf043c50 cf807000 bf0439b0 bf043c80
cf807060 cf807060 bf043c80
[  148.330984] 7dc0: c01dce54 c01dcd04 cf807060 cf807094 bf043c80
c01dce54 cfa7df00 c04bb780
[  148.339140] 7de0: 00000000 c01dcee0 00000000 cfb37df8 bf043c80
c01dc4f8 cf805c38 cf87c810
[  148.347296] 7e00: bf043c50 cf81cb00 bf043c80 bf043c80 c04a4f0c
c01dbd00 bf0437ac 00000000
[  148.355452] 7e20: bf043c50 bf043c50 bf043c80 bf043c80 c04a4f0c
cfb36000 c004e388 c01dd284
[  148.363609] 7e40: bf043c50 cfb0c540 bf043c80 c04a4f0c cfb36000
c01a92dc 00000001 cfb0c540
[  148.371765] 7e60: 00000001 bf04642c cfb36000 bf049014 00000001
c0008578 c004e460 c037204c
[  148.379920] 7e80: c049d93c 00000000 bf04642c ffffffff 00000001
c003d1f8 00000000 ce51e240
[  148.388069] 7ea0: 00000001 00000001 cfb0c540 00000001 bf04642c
00000010 bf046474 c004e388
[  148.396225] 7ec0: c004e460 c004f62c bf046438 00000001 cfb36000
bf046438 d0c0d6da d0bcbcfc
[  148.404381] 7ee0: bf046550 c03786cc d0ad7000 00136709 d0bcb554
d0bcb368 d0c0c554 cfa6a800
[  148.412536] 7f00: 0001156c 0001225c 00000000 00000000 00000031
00000032 00000018 00000000
[  148.420683] 7f20: 00000010 00000000 776c7472 00696669 00000000
00000000 00000000 00000000
[  148.428831] 7f40: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[  148.436978] 7f60: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 c009b170
[  148.445127] 7f80: 00000003 40085000 bedf0db4 00000069 00000080
c0008ec4 cfb36000 00000000
[  148.453283] 7fa0: 00000000 c0008d40 40085000 bedf0db4 40389008
00136709 000b72df 00000000
[  148.461439] 7fc0: 40085000 bedf0db4 00000069 00000080 bedf0db8
000b72df bedf0db8 00000000
[  148.469587] 7fe0: 00000001 bedf0a5c 0001c7e8 40326ac4 60000010
40389008 00000000 00000000
[  148.477783] [<bf00fdc0>] (rtl_pci_probe+0x398/0x1bd8 [rtlwifi])
from [<c01a8d80>] (local_pci_probe+0x18/0x1c)
[  148.487677] [<c01a8d80>] (local_pci_probe+0x18/0x1c) from
[<c01a901c>] (pci_device_probe+0x6c/0x90)
[  148.496701] [<c01a901c>] (pci_device_probe+0x6c/0x90) from
[<c01dcd04>] (driver_probe_device+0x80/0x1d0)
[  148.506156] [<c01dcd04>] (driver_probe_device+0x80/0x1d0) from
[<c01dcee0>] (__driver_attach+0x8c/0x90)
[  148.515521] [<c01dcee0>] (__driver_attach+0x8c/0x90) from
[<c01dc4f8>] (bus_for_each_dev+0x60/0x94)
[  148.524541] [<c01dc4f8>] (bus_for_each_dev+0x60/0x94) from
[<c01dbd00>] (bus_add_driver+0xa0/0x25c)
[  148.533561] [<c01dbd00>] (bus_add_driver+0xa0/0x25c) from
[<c01dd284>] (driver_register+0x6c/0x154)
[  148.542581] [<c01dd284>] (driver_register+0x6c/0x154) from
[<c01a92dc>] (__pci_register_driver+0x38/0xa8)
[  148.552148] [<c01a92dc>] (__pci_register_driver+0x38/0xa8) from
[<bf049014>] (rtl92ce_module_init+0x14/0x58 [rtl8192ce])
[  148.563007] [<bf049014>] (rtl92ce_module_init+0x14/0x58
[rtl8192ce]) from [<c0008578>] (do_one_initcall+0x34/0x19c)
[  148.573413] [<c0008578>] (do_one_initcall+0x34/0x19c) from
[<c004f62c>] (sys_init_module+0xf4/0x13a4)
[  148.582609] [<c004f62c>] (sys_init_module+0xf4/0x13a4) from
[<c0008d40>] (ret_fast_syscall+0x0/0x2c)
[  148.591713] Code: e598201c e2022007 e5ca2377 e59d0030 (e1d002b0)
[  148.602704] ---[ end trace be518a2fa6d9a905 ]---

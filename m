Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab2C3HF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 03:05:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:45650 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756321Ab2C3HFR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 03:05:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="83415850"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "Brown, Len" <len.brown@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "keir.xen@gmail.com" <keir.xen@gmail.com>,
        Jan Beulich <jbeulich@suse.com>, "Li, Shaohua" <shaohua.li@intel.com>,
        "lenb@kernel.org" <lenb@kernel.org>
Subject: RE: [Xen-devel] [PATCH 1/2] RFC: Prepare PAD for native and	xen
 platform
Thread-Topic: [Xen-devel] [PATCH 1/2] RFC: Prepare PAD for native and	xen
 platform
Thread-Index: AQHNDdb5qmcRrTC4dkmeB7vjruTwoZaCZ/Pw
Date: Fri, 30 Mar 2012 07:05:13 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335113E50@SHSMSX101.ccr.corp.intel.com>
References: <4F46530B020000780007F751@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC82923350AD9BB@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC82923350B2013@SHSMSX101.ccr.corp.intel.com>
 <20120226173458.GB18098@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923350B9496@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC82923350BAC09@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC8292335105EFA@SHSMSX101.ccr.corp.intel.com>
 <20120326164835.GE10236@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC829233510F52B@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC829233510F5C5@SHSMSX101.ccr.corp.intel.com>
 <20120329180842.GA14789@phenom.dumpdata.com>
In-Reply-To: <20120329180842.GA14789@phenom.dumpdata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
>>>> If it benefits other architectures (say ARM) then adding in hooks
>>>> there (in osl for example) makes sense - but I am not sure if ARM
>>>> has a form of _PUR code/calls it needs to do.
>>>> 
>>>> So with that in mind, neither of those options seems proper - as
>>>> all of them depend on changing something in drivers/acpi/*.
>>>> 
>>>> I've one or two suggestions of what could be done to still make
>>>> this work, but I need you to first see what happens if the native
>>>> acpi_pad runs under Xen with the latest upstream code (along with
>>>> three patches that are in a BZ I pointed you too).
>>> 
>>> Do you mean test the patch
>>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blobdiff;f=arch/x86/xen/enlighten.c;h=b132ade26f778f2cfec7c2d5c7b6db48afe424d5;hp=4172af8ceeb363d06912af15bf89e8508752b794;hb=d4c6fa73fe984e504d52f3d6bba291fd76fe49f7;hpb=aab008db8063364dc3c8ccf4981c21124866b395
> 
> Right.

OK, I test by simulated method (I don't have platform w/ _PUR), executed __monitor at dom0 kernel.
In the test, it in fact no need to use platform w/ _PUR since it only care mwait, and __monitor would generated UD no matter xen hypervisor exposing mwait or not (break cpuid law or CPL law).

As expected, UD not handled by hypervisor, then bounce back to the created bounce frame of dom0, then

[   82.282152] invalid opcode: 0000 [#1] SMP ^M
[   82.282170] CPU 0 ^M
[   82.282175] Modules linked in: monitor(O+) xen_gntdev [last unloaded: scsi_wait_scan]^M
[   82.282196] ^M
[   82.282203] Pid: 5315, comm: insmod Tainted: G           O 3.3.0-rc3+ #22 Intel Corporation S2600CP/S2600CP^M
[   82.282222] RIP: e030:[<ffffffffa0005019>]  [<ffffffffa0005019>] init_module+0x19/0x20 [monitor]^M
[   82.282243] RSP: e02b:ffff8807a6357e68  EFLAGS: 00010246^M
[   82.282251] RAX: ffffffffa0005068 RBX: 0000000001ab4010 RCX: 0000000000000000^M
[   82.282261] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffa0005000^M
[   82.282271] RBP: ffff8807a6357e68 R08: ffff8807bdee2c60 R09: ffff8807b9802700^M
[   82.282280] R10: ffffffff8111bd9c R11: 0000000000000000 R12: 0000000000000000^M
[   82.282289] R13: ffffffffa0005000 R14: 0000000000000000 R15: ffff8807a6357ee8^M
[   82.282307] FS:  00007fb88c33c700(0000) GS:ffff8807bdecd000(0000) knlGS:0000000000000000^M
[   82.282318] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b^M
[   82.282327] CR2: 00000035044d9380 CR3: 00000007a637d000 CR4: 0000000000042660^M
[   82.282370] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000^M
[   82.282389] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400^M
[   82.282394] Process insmod (pid: 5315, threadinfo ffff8807a6356000, task ffff8807b22aba80)^M
[   82.282399] Stack:^M
[   82.282402]  ffff8807a6357e98 ffffffff8100203d 0000000001ab4010 ffffffffa0005080^M
[   82.282411]  ffffffffa0007210 0000000000000000 ffff8807a6357f78 ffffffff8109f298^M
[   82.282420]  ffff8807b3815300 ffffc90013f29000 ffff880700000005 ffff880700000003^M
[   82.282429] Call Trace:^M
[   82.282440]  [<ffffffff8100203d>] do_one_initcall+0x3d/0x170^M
[   82.282450]  [<ffffffff8109f298>] sys_init_module+0x138/0x1720^M
[   82.282462]  [<ffffffff8174f039>] system_call_fastpath+0x16/0x1b^M
[   82.282466] Code: <0f> 01 c8 31 c0 c9 c3 55 48 c7 c7 58 50 00 a0 31 c0 48 89 e5 e8 44 ^M
[   82.282500] RIP  [<ffffffffa0005019>] init_module+0x19/0x20 [monitor]^M
[   82.282526]  RSP <ffff8807a6357e68>^M

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab2E3PJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:09:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:2589 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743Ab2E3PJQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:09:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="149513781"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: "'Konrad Rzeszutek Wilk'" <konrad.wilk@oracle.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>
Subject: RE: [PATCH 1/3] xen/mce: Add mcelog support for Xen platform (RFC)
Thread-Topic: [PATCH 1/3] xen/mce: Add mcelog support for Xen platform (RFC)
Thread-Index: AQHNPnYr38x3t8sIdUWVPx/os9fTyw==
Date: Wed, 30 May 2012 15:09:12 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923351FC452@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC82923351D6892@SHSMSX101.ccr.corp.intel.com>
 <20120522092354.GB18578@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351EC9B0@SHSMSX101.ccr.corp.intel.com>
 <20120524103023.GA27063@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351ED712@SHSMSX101.ccr.corp.intel.com>
 <20120524184947.GA28338@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351F0C4E@SHSMSX101.ccr.corp.intel.com>
 <20120525180102.GA27280@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351F0D53@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC82923351F44F3@SHSMSX101.ccr.corp.intel.com>
 <20120529133858.GD29157@aftab.osrc.amd.com>
In-Reply-To: <20120529133858.GD29157@aftab.osrc.amd.com>
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

> 
> Still no go, this is current linus with your patch applied. I'll look
> into it 
> later when there's time.

The root cause is,
1). at cpu/mcheck/mce.c, device_initcall_sync(mcheck_init_device) is *after* all device_initcall();
2). at cpu/mcheck/mce_amd.c, device_initcall(threshold_init_device) will
    threshold_init_device 
    --> threshold_create_device 
    --> threshold_create_bank
    --> kobject_create_and_add(name, &dev->kobj);
        // at this point, struct device *dev = per_cpu(mce_device, cpu), which is a NULL pointer.
        // mce_device is initialized at mcheck_init_device --> mce_device_create
3). so kernel panic

So our RFC patch would affect amd mce logic.

===========================

I have a thought about symlink approach, but seems it would bring more issues, e.g.
1). it need change more native mce code, like remove /dev/mcelog which created at native mce (under xen platform), or
2). it still need to change device_initcall(mcheck_init_device) to device_initcall_sync(mcheck_init_device), if it want to implicitly block native /dev/mcelog --> but that would panic amd mce logic.

IMO currently there are 2 options:
1). use the original approach (implicitly redirect /dev/mcelog to xen_mce_chrdev_device) --> what point of this approach do you think unreasonable? It just remove a 'static' from native mce code!
2). use another /dev/xen-mcelog interface, with another misc minor '226'

Your thoughts?

Thanks,
Jinsong

> 
> [    3.644961] initlevel:6=device, 250 registered initcalls
> [    3.652666] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000048 [    3.661186] IP: [<ffffffff811ced67>]
> kobject_get+0x11/0x34 [    3.667018] PGD 0
> [    3.669409] Oops: 0000 [#1] SMP
> [    3.672988] CPU 21
> [    3.675436] Modules linked in:
> [    3.678839]
> [    3.680710] Pid: 1, comm: swapper/0 Tainted: G        W    3.4.0+
> #1 AMD [    3.689103] RIP: 0010:[<ffffffff811ced67>] 
> [<ffffffff811ced67>] kobject_get+0x11/0x34 [    3.697665] RSP:
> 0000:ffff880425c67cd0  EFLAGS: 00010202 [    3.703322] RAX:
> ffff880425ff40b0 RBX: 0000000000000010 RCX: ffff880425c67c50 [   
> 3.710801] RDX: ffff880425ff4000 RSI: ffff8808259c5380 RDI:
> 0000000000000010 [    3.718302] RBP: ffff880425c67ce0 R08:
> 00000000fffffffe R09: 00000000ffffffff [    3.725780] R10:
> ffff8804a5c67e5f R11: 0000000000000000 R12: 0000000000000010 [   
> 3.733258] R13: 00000000fffffffe R14: 000000000000cbf8 R15:
> 0000000000011ec0 [    3.740738] FS:  0000000000000000(0000)
> GS:ffff880c27cc0000(0000) knlGS:0000000000000000 [    3.749472] CS: 
> 0010 DS: 0000 ES: 0000 CR0: 000000008005003b [    3.755564] CR2:
> 0000000000000048 CR3: 0000000001a0b000 CR4: 00000000000007e0 [   
> 3.763044] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000 [    3.770549] DR3: 0000000000000000 DR6:
> 00000000ffff0ff0 DR7: 0000000000000400 [    3.778026] Process
> swapper/0 (pid: 1, threadinfo ffff880425c66000, task
> ffff880425c78000) [    3.786934] Stack: [    3.789326] 
> ffff880425c67d20 ffff8808259c5380 ffff880425c67d40 ffffffff811cedeb [
> 3.797368]  ffff880425c67d70 ffff880425c67da0 ffff8808259c5380
> ffff8808259c5380 [    3.805411]  0000000000000000 ffff8808259c5380
> 0000000000000010 0000000000000000 [    3.813453] Call Trace: [   
> 3.816253]  [<ffffffff811cedeb>] kobject_add_internal+0x61/0x249 [   
> 3.822693]  [<ffffffff811cf3ca>] kobject_add+0x91/0xa2 [    3.828290] 
> [<ffffffff811cf5a9>] kobject_create_and_add+0x37/0x68 [    3.834821] 
> [<ffffffff8144b91a>] threshold_create_device+0x1e5/0x342 [   
> 3.841633]  [<ffffffff814549c5>] ? mutex_lock+0x16/0x37 [    3.847295]
> [<ffffffff81031894>] ? cpu_maps_update_done+0x15/0x2d [    3.853824] 
> [<ffffffff81ad0b0e>] threshold_init_device+0x1b/0x4f [    3.860265] 
> [<ffffffff81ad0af3>] ? severities_debugfs_init+0x3b/0x3b [   
> 3.867054]  [<ffffffff810002f9>] do_one_initcall+0x7f/0x136 [   
> 3.873062]  [<ffffffff81ac8bca>] kernel_init+0x165/0x1fd [   
> 3.878807]  [<ffffffff81ac8495>] ? loglevel+0x31/0x31 [    3.884321] 
> [<ffffffff8145e8d4>] kernel_thread_helper+0x4/0x10 [    3.890590] 
> [<ffffffff81456d86>] ? retint_restore_args+0xe/0xe [    3.896885] 
> [<ffffffff81ac8a65>] ? start_kernel+0x2ee/0x2ee [    3.902893] 
> [<ffffffff8145e8d0>] ? gs_change+0xb/0xb [    3.908322] Code: aa 81
> 31 c0 e8 ac 90 01 00 4c 89 f7 e8 c5 42 f2 ff 5b 41 5c 41 5d 41 5e c9
> c3 55 48 89 e5 53 48 89 fb 48 83 ec 08 48 85 ff 74 1c <8b> 47 38 85
> c0 75 11 be 29 00 00 00 48 c7 c7 16 87 79 81 e8 95 [    3.928115] RIP
> [<ffffffff811ced67>] kobject_get+0x11/0x34 [    3.934032]  RSP
> <ffff880425c67cd0> [    3.937870] CR2: 0000000000000048 [   
> 3.941548] ---[ end trace 4eaa2a86a8e2da23 ]--- [    3.946581] Kernel
> panic - not syncing: Attempted to kill init! exitcode=0x00000009 [   
> 3.946581]     


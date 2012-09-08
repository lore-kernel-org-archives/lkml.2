Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab2IHS4a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 14:56:30 -0400
Received: from mail.digium.com ([216.207.245.2]:33702 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227Ab2IHS41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 14:56:27 -0400
Date: Sat, 8 Sep 2012 13:49:29 -0500
From: Shaun Ruffell <sruffell@digium.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix edac_mc crash in e7xxx_edac error path.
Message-ID: <20120908184929.GA28918@digium.com>
References: <20120810092223.GA27375@localhost>
 <1345349484-31552-1-git-send-email-sruffell@digium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345349484-31552-1-git-send-email-sruffell@digium.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a friendly reminder that I'm still seeing this NULL pointer
dereference on boot with 3.6-rc4.

On Sat, Aug 18, 2012 at 11:11:21PM -0500, Shaun Ruffell wrote:
> With kernel version 3.6-rc2 on a Dell Poweredge 2600 I experienced a NULL
> pointer dereference that did not occur with on 3.5. I believe the error is
> related to commit de3910eb79a "edac: change the mem allocation scheme to make
> Documentation/kobject.txt happy" [1] and the fact that my system is going
> through an error path in the e7xxx_edac driver.
> 
> [1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=de3910eb79ac8c0f29a11224661c0ebaaf813039
> 
> This is the OOPS:
> 
>  [  36.703479] BUG: unable to handle kernel NULL pointer dereference at   (null)
>  [  36.703479] IP: [<c045e195>] __wake_up_common+0x1a/0x6a
>  [  36.703479] *pde = 7f0c6067 
>  [  36.703479] Oops: 0000 [#1] SMP 
>  [  36.703479] Modules linked in: parport_pc parport floppy e7xxx_edac(+) ide_cd_mod edac_core intel_rng cdrom microcode(+) dm_snapshot dm_zero dm_mirror dm_region_hash d
>  [  36.703479] Pid: 933, comm: modprobe Tainted: G        W    3.6.0-rc2-00111-gc1999ee #12 Dell Computer Corporation PowerEdge 2600             /0F0364
>  [  36.703479] EIP: 0060:[<c045e195>] EFLAGS: 00010093 CPU: 3
>  [  36.703479] EIP is at __wake_up_common+0x1a/0x6a
>  [  36.703479] EAX: f47b0984 EBX: fffffff4 ECX: 00000000 EDX: 00000003
>  [  36.703479] ESI: f47b0984 EDI: 00000282 EBP: f3dc7d38 ESP: f3dc7d1c
>  [  36.703479]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>  [  36.703479] CR0: 8005003b CR2: 00000000 CR3: 347d4000 CR4: 000007d0
>  [  36.703479] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
>  [  36.703479] DR6: ffff0ff0 DR7: 00000400
>  [  36.703479] Process modprobe (pid: 933, ti=f3dc6000 task=f3db9520 task.ti=f3dc6000)
>  [  36.703479] Stack:
>  [  36.703479]  00000000 00000000 00000003 c046701a f47b0980 f47b0984 00000282 f3dc7d54
>  [  36.703479]  c046703f 00000000 00000000 f47b08b0 f47b08b0 00000000 f3dc7d74 c06961ce
>  [  36.703479]  f3dc7d74 f3dc7d80 c05e2837 c094c4cc f47b08b0 f47b08b0 f3dc7d88 c068d56d
>  [  36.703479] Call Trace:
>  [  36.703479]  [<c046701a>] ? complete_all+0x1a/0x50
>  [  36.703479]  [<c046703f>] complete_all+0x3f/0x50
>  [  36.703479]  [<c06961ce>] device_pm_remove+0x23/0xa2
>  [  36.703479]  [<c05e2837>] ? kobject_put+0x5b/0x5d
>  [  36.703479]  [<c068d56d>] device_del+0x34/0x142
>  [  36.703479]  [<f8547884>] edac_unregister_sysfs+0x3b/0x5c [edac_core]
>  [  36.703479]  [<f8545041>] edac_mc_free+0x29/0x2f [edac_core]
>  [  36.703479]  [<f860163f>] e7xxx_probe1+0x268/0x311 [e7xxx_edac]
>  [  36.703479]  [<c0603d00>] ? __pci_enable_device_flags+0x8f/0xd3
>  [  36.703479]  [<f8601b0b>] e7xxx_init_one+0x56/0x61 [e7xxx_edac]
>  [  36.703479]  [<c0604f85>] local_pci_probe+0x13/0x15
>  [  36.703479]  [<c0605115>] pci_call_probe+0x1c/0x1e
>  [  36.703479]  [<c0605158>] __pci_device_probe+0x41/0x4e
>  [  36.703479]  [<c060579c>] pci_device_probe+0x26/0x39
>  [  36.703479]  [<c06901ed>] really_probe+0x101/0x2a1
>  [  36.703479]  [<c0690680>] ? __driver_attach+0x3d/0x6e
>  [  36.703479]  [<c0690680>] ? __driver_attach+0x3d/0x6e
>  [  36.703479]  [<c07e0000>] ? quirk_usb_disable_ehci+0xa3/0x141
>  [  36.703479]  [<c06903c2>] driver_probe_device+0x35/0x79
>  [  36.703479]  [<c06906af>] __driver_attach+0x6c/0x6e
>  [  36.703479]  [<c068eb25>] bus_for_each_dev+0x44/0x62
>  [  36.703479]  [<c068ff00>] driver_attach+0x1e/0x20
>  [  36.703479]  [<c0690643>] ? device_attach+0x98/0x98
>  [  36.703479]  [<c068fa12>] bus_add_driver+0xc5/0x1c8
>  [  36.703479]  [<c0605beb>] ? store_new_id+0xfa/0xfa
>  [  36.703479]  [<c0690bfb>] driver_register+0x52/0xd6
>  [  36.703479]  [<f8604000>] ? 0xf8603fff
>  [  36.703479]  [<c0605a30>] __pci_register_driver+0x4b/0x73
>  [  36.703479]  [<f8604000>] ? 0xf8603fff
>  [  36.703479]  [<f8604055>] e7xxx_init+0x55/0x57 [e7xxx_edac]
>  [  36.703479]  [<c040120e>] do_one_initcall+0xa3/0xe0
>  [  36.703479]  [<c0491023>] sys_init_module+0x70/0x1af
>  [  36.703479]  [<c04823a9>] ? trace_hardirqs_on_caller+0x56/0xf9
>  [  36.703479]  [<c05ec7e8>] ? trace_hardirqs_on_thunk+0xc/0x10
>  [  36.703479]  [<c07f678c>] sysenter_do_call+0x12/0x32
>  [  36.703479] Code: 5d c3 55 89 e5 3e 8d 74 26 00 e8 8f ff ff ff 5d c3 55 89 e5 57 56 53 83 ec 10 3e 8d 74 26 00 89 55 ec 89 4d e8 8b 58 28 83 eb 0c <8b> 53 0c 83 c0 28
>  [  36.703479] EIP: [<c045e195>] __wake_up_common+0x1a/0x6a SS:ESP 0068:f3dc7d1c
>  [  36.703479] CR2: 0000000000000000
>  [  36.703479] ---[ end trace 6fcfddc0eef7bbd8 ]---
> 
> When I enabled edac debugging I saw the following printed to the kernel log
> prior to the above BUG:
> 
>   EDAC MC: Ver: 3.0.0
>   EDAC DEBUG: edac_mc_sysfs_init: device mc created
>   EDAC DEBUG: e7xxx_init_one:
>   EDAC DEBUG: e7xxx_probe1: mci
>   EDAC DEBUG: edac_mc_alloc: errcount layer 0 size 8
>   EDAC DEBUG: edac_mc_alloc: errcount layer 1 size 16
>   EDAC DEBUG: edac_mc_alloc: allocating 48 error counters
>   EDAC DEBUG: edac_mc_alloc: allocating 1068 bytes for mci data (16 ranks, 16 csrows/channels)
>   EDAC DEBUG: e7xxx_probe1: init mci
>   EDAC DEBUG: e7xxx_probe1: init pvt
>   EDAC e7xxx: error reporting device not found:vendor 8086 device 0x2541 (broken BIOS?)
>   EDAC DEBUG: edac_mc_free:
>   Floppy drive(s): fd0 is 1.44M
>   EDAC DEBUG: edac_unregister_sysfs: Unregistering device (null)
> 
> There are probably better ways to accomplish what the following patches are
> doing but I thought I would send along what I had if only to motivate any
> discussion. I also have resent Fengguang Wu's patch in this series since I found
> that it was required as well.
> 
> Shaun Ruffell (2):
>   edac: Remove invalid kfree in error path of edac_mc_allocate().
>   edac: edac_mc_free() cannot assume mem_ctl_info is registered in
>     sysfs.
> 
>  drivers/edac/edac_mc.c | 60 +++++++++++++++++++++++++++++---------------------
>  1 file changed, 35 insertions(+), 25 deletions(-)

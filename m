Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab2IUSwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:52:42 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:46598 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757625Ab2IUSwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:52:39 -0400
Date: Fri, 21 Sep 2012 14:41:23 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Oliver Chick <oliver.chick@citrix.com>
Cc: xen-devel@lists.xen.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Persistent grant maps for xen blk drivers
Message-ID: <20120921184123.GA27502@phenom.dumpdata.com>
References: <1348242767-23732-1-git-send-email-oliver.chick@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348242767-23732-1-git-send-email-oliver.chick@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 04:52:47PM +0100, Oliver Chick wrote:
> This patch implements persistent grants for the xen-blk{front,back}
> mechanism. The effect of this change is to reduce the number of unmap
> operations performed, since they cause a (costly) TLB shootdown. This
> allows the I/O performance to scale better when a large number of VMs
> are performing I/O.

So I applied your patch to my #linux-next and I got this (the dom0 is the
same as the domU)
I get this when using an PVHVM (*)and PV guest:
# fdisk /dev/xvda
[   28.594049] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[   28.595028] IP: [<ffffffffa003fe9a>] blkif_interrupt+0x3aa/0x5d0 [xen_blkfront]
[   28.595028] PGD dcaf0067 PUD 7fb5e067 PMD 0 
[   28.595028] Oops: 0000 [#1] SMP 
[   28.595028] Modules linked in: iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi libcrc32c crc32c sg sr_mod cdrom ata_generic ata_piix crc32c_intel libata scsi_mod xen_blkfront xen_netfront fb_sys_fops sysimgblt sysfillrect syscopyarea xen_kbdfront xenfs xen_privcmd [last unloaded: dump_dma]
[   28.595028] CPU 0 
[   28.595028] Pid: 0, comm: swapper/0 Tainted: G           O 3.6.0-rc6upstream-00196-ge45cba2 #1 Xen HVM domU
[   28.595028] RIP: 0010:[<ffffffffa003fe9a>]  [<ffffffffa003fe9a>] blkif_interrupt+0x3aa/0x5d0 [xen_blkfront]
[   28.595028] RSP: 0018:ffff88010fc03da8  EFLAGS: 00010002
[   28.595028] RAX: 0000000000000000 RBX: ffffffff81a00000 RCX: ffff88010af5f140
[   28.595028] RDX: ffff88010af5f080 RSI: ffff8800dbbf8210 RDI: ffff8800dc679c00
[   28.595028] RBP: ffff88010fc03e28 R08: 0000000000000001 R09: 0000000000000011
[   28.595028] R10: 0000000000000000 R11: 0000000000000000 R12: 6db6db6db6db6db7
[   28.595028] R13: ffff88010af5f1a8 R14: 0000000000000004 R15: 0000000000000000
[   28.595028] FS:  0000000000000000(0000) GS:ffff88010fc00000(0000) knlGS:0000000000000000
[   28.595028] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   28.595028] CR2: 0000000000000008 CR3: 00000000d4ac0000 CR4: 00000000000006f0
[   28.595028] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   28.595028] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   28.595028] Process swapper/0 (pid: 0, threadinfo ffffffff81a00000, task ffffffff81a13420)
[   28.595028] Stack:
[   28.595028]  0000000000000086 ffff8800d9951060 ffff8800d9953000 0000000881376d09
[   28.595028]  0000000000000008 0000000a81376f2d 0000000000000000 ffff8800dbbf8210
[   28.595028]  ffff8800dbbf8000 ffff88010af5f140 ffff88010fc03e08 ffff8800dcc4e3c0
[   28.595028] Call Trace:
[   28.595028]  <IRQ> 
[   28.595028]  [<ffffffff8110dcdc>] handle_irq_event_percpu+0x7c/0x240
[   28.595028]  [<ffffffff8110df02>] handle_irq_event+0x62/0x90
[   28.595028]  [<ffffffff8111178e>] handle_edge_irq+0x8e/0x160
[   28.595028]  [<ffffffff81376ac4>] __xen_evtchn_do_upcall+0x1c4/0x2a0
[   28.595028]  [<ffffffff813775ba>] xen_evtchn_do_upcall+0x2a/0x40
[   28.595028]  [<ffffffff816314ba>] xen_hvm_callback_vector+0x6a/0x70
[   28.595028]  <EOI> 
[   28.595028]  [<ffffffff8107b3a6>] ? native_safe_halt+0x6/0x10
[   28.595028]  [<ffffffff810555da>] default_idle+0x4a/0x210
[   28.595028]  [<ffffffff81054d79>] cpu_idle+0x99/0xe0
[   28.595028]  [<ffffffff816015da>] rest_init+0x8a/0xa0
[   28.595028]  [<ffffffff81abcd72>] start_kernel+0x383/0x390
[   28.595028]  [<ffffffff81abc80d>] ? kernel_init+0x1e8/0x1e8
[   28.595028]  [<ffffffff81abc356>] x86_64_start_reservations+0x131/0x136
[   28.595028]  [<ffffffff81abc45e>] x86_64_start_kernel+0x103/0x112
[   28.595028] Code: 00 49 83 c5 10 41 8b 45 08 41 03 45 0c 3d 00 10 00 00 0f 87 7e 01 00 00 48 8b 75 b8 49 63 c6 41 83 c6 01 48 8b 84 c6 d0 00 00 00 <48> 8b 40 08 83 43 1c 01 48 8d 14 c5 00 00 00 00 48 c1 e0 06 48 
[   28.595028] RIP  [<ffffffffa003fe9a>] blkif_interrupt+0x3aa/0x5d0 [xen_blkfront]
[   28.595028]  RSP <ffff88010fc03da8>
[   28.595028] CR2: 0000000000000008
[   28.595028] ---[ end trace 49f5630a34777570 ]---
[   28.595028] Kernel panic - not syncing: Fatal exception in interrupt
[   28.595028] Rebooting in 60 seconds..

*: With a PVHVM guest I get

[  261.927218] privcmd_fault: vma=ffff88002a31dce8 7f4edc095000-7f4edc195000, pgoff=c8, uv=00007f4edc15d000

thought if I applied your patch on top of v3.6-rc6 I didn't see the privcmd_fault but
I did see the guest crash.

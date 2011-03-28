Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab1C1RwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 13:52:25 -0400
Received: from mail4.comsite.net ([205.238.176.238]:35519 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab1C1RwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 13:52:23 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
To: Amit Shah <amit.shah@redhat.com>
From: Milton Miller <miltonm@bga.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, greg@kroah.com, linuxppc-dev@ozlabs.org
Subject: Re: hvc_console: Don't access hvc_task if not initialised
Message-ID: <hvc-kick-notask-2@mdm.bga.com>
References: <df8ea6d65c1ceeb25b0a3fdfc66995b8a8273ea5.1300951793.git.amit.shah@redhat.com>
 <hvc-kick-notask@mdm.bga.com>
 <20110325084714.GA28356@amit-x200.redhat.com>
In-Reply-To: <20110325084714.GA28356@amit-x200.redhat.com>
Date: Mon, 28 Mar 2011 11:52:05 -0600
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Mar 2011 about 14:17:14 +0530, Amit Shah wrote:
> On (Thu) 24 Mar 2011 [08:58:04], Milton Miller wrote:
> > On Thu, 24 Mar 2011 07:29:58 -0000, Amit Shah wrote:
> > > hvc_open() can be called without having any backing device.  This
> > > results in a call to hvc_kick() which calls wake_up_process on a NULL
> > > pointer.  
> > 
> > How is hvc_open called without a hvc_driver registered to the tty layer?
> 
> This gets reproduced in a couple of scenarios, I'm trying to get more
> information.
> 
> > > Ensure hvc is initialised by checking for a non-NULL hvc_task
> > > before waking up the hvc thread.
> > 
> > No if the task is missing the subsystem is really stuck.  Put a check
> > in open and refuse to open.

Just wanted to add emphasis.  Making hvc_kick a do nothing is not acceptable.

> >
> > > 
> > > This was found by an autotest run for virtio_console without having a
> > > console backend.

Are you sure? the virtio_console module was loaded.

> > > 
> > 
> > stack trace please
> 
> Yes, should have included that:
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> IP: [<ffffffff8104fef2>] task_rq_lock+0x42/0xa0
> PGD 1d66a067 PUD 1d598067 PMD 0 
> Oops: 0000 [#1] SMP 
> last sysfs file: /sys/devices/pci0000:00/0000:00:04.0/virtio1/virtio-ports/vport0p0/name
> CPU 0 
> Modules linked in: virtio_console virtio_net i2c_piix4 i2c_core ext4
> mbcache jbd2 sr_mod cdrom virtio_blk pata_acpi ata_generic ata_piix
> virtio_pci virtio_ring virtio dm_mod [last unloaded: scsi_wait_scan]
> 
> Modules linked in: virtio_console virtio_net i2c_piix4 i2c_core ext4
> mbcache jbd2 sr_mod cdrom virtio_blk pata_acpi ata_generic ata_piix
> virtio_pci virtio_ring virtio dm_mod [last unloaded: scsi_wait_scan]
> Pid: 672, comm: console_check Not tainted 2.6.32-125.el6.x86_64 #1 KVM

So 2.6.32-125.el6.x86_64, not mainline.   Please check for any patches
affecting hvc_task and/or hvc_driver.

> RIP: 0010:[<ffffffff8104fef2>]  [<ffffffff8104fef2>] task_rq_lock+0x42/0xa0
> RSP: 0018:ffff880017cbbb98  EFLAGS: 00010082
> RAX: 0000000000000282 RBX: 0000000000015f40 RCX: 0000000000000002
> RDX: 0000000000000282 RSI: ffff880017cbbbf0 RDI: 0000000000000000
> RBP: ffff880017cbbbb8 R08: ffff88001bf39208 R09: ffff88001d67a000
> R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
> R13: ffff880017cbbbf0 R14: 0000000000000000 R15: 000000000000000f
> FS:  00007f3592683700(0000) GS:ffff880002000000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000008 CR3: 000000001d595000 CR4: 00000000000006f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

so seems to be x86_64

> Process console_check (pid: 672, threadinfo ffff880017cba000, task ffff88001f5fe100)
> Stack:
>  0000000000000000 ffff88001bf39000 0000000000000000 0000000000000000
> <0> ffff880017cbbc28 ffffffff8105c74c ffff88001d5966a0 0000000000008800
> <0> ffff880017cbbbe8 ffffffff813081c1 ffff880017cbbc28 0000000000000282
> Call Trace:
>  [<ffffffff8105c74c>] try_to_wake_up+0x3c/0x400
>  [<ffffffff813081c1>] ? tty_ldisc_enable+0x31/0x40
>  [<ffffffff8105cb65>] wake_up_process+0x15/0x20
>  [<ffffffff8131a10f>] hvc_kick+0x1f/0x30
>  [<ffffffff8131a58a>] hvc_open+0xca/0x120
>  [<ffffffff81302ba1>] tty_open+0x211/0x510
>  [<ffffffff811754b5>] chrdev_open+0x125/0x230
>  [<ffffffff81175390>] ? chrdev_open+0x0/0x230
>  [<ffffffff8116e70a>] __dentry_open+0x10a/0x360
>  [<ffffffff8120d022>] ? selinux_inode_permission+0x72/0xb0
>  [<ffffffff812050ff>] ? security_inode_permission+0x1f/0x30
>  [<ffffffff8116ea74>] nameidata_to_filp+0x54/0x70
>  [<ffffffff811816b0>] do_filp_open+0x700/0xd90
>  [<ffffffff810cfd42>] ? audit_alloc_name+0x62/0x100
>  [<ffffffff8118fd20>] ? mntput_no_expire+0x30/0x110
>  [<ffffffff8118dd12>] ? alloc_fd+0x92/0x160
>  [<ffffffff8116e4b9>] do_sys_open+0x69/0x140
>  [<ffffffff8116e5d0>] sys_open+0x20/0x30
>  [<ffffffff8100b172>] system_call_fastpath+0x16/0x1b
> Code: 89 74 24 18 0f 1f 44 00 00 48 c7 c3 40 5f 01 00 49 89 fc 49 89
> f5 9c 58 0f 1f 44 00 00 48 89 c2 fa 66 0f 1f 44 00 00 49 89 55 00 <49>
> 8b 44 24 08 49 89 de 8b 40 18 4c 03 34 c5 40 46 b9 81 4c 89
> RIP  [<ffffffff8104fef2>] task_rq_lock+0x42/0xa0
>  RSP <ffff880017cbbb98>
> CR2: 0000000000000008
> ---[ end trace a6f40a29150796da ]---
> 
> 		Amit

Looking at 2.6.38+ without taking the time to audit my assumptions
about the tty code, it would appear that we wait to register the driver
until hvc_task is checked for IS_ERR(), and we only set hvc_driver
after setting hvc_task.  If it was some loosely ordered architecture
I would worry about barriers.  I also did a quick scan of patches
from 2.6.32 to 38.


I see several potential problems such as hvc_task is left IS_ERR, and we
kill hvc_task before unregistering the tty, and we could end up with no
kick with hvc_console backend registered (that should be ok, as there
is still no tty driver to be called), but I don't see hvc_console in
your module list and the only code to kill hvc_task and zero once its
set is in the module exit.

milton

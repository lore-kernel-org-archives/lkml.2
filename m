Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab0JEQlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 12:41:24 -0400
Received: from www.tglx.de ([62.245.132.106]:46945 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307Ab0JEQlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 12:41:23 -0400
Date: Tue, 5 Oct 2010 18:40:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Rusty Russell <rusty@rustcorp.com.au>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>, Brandon Philips <brandon@ifup.org>
Subject: Re: [BUG 2.6.36-rc6] list corruption in module_bug_finalize
In-Reply-To: <AANLkTino8StCF7OZvzxeFrs0a4JVnxRK-deJ4XUU41Ef@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1010051816260.2556@localhost6.localdomain6>
References: <alpine.LFD.2.00.1010032141410.14550@localhost6.localdomain6> <201010041300.15234.arnd@arndb.de> <alpine.LFD.2.00.1010050026170.2556@localhost6.localdomain6> <201010051544.52269.rusty@rustcorp.com.au> <alpine.LFD.2.00.1010050927450.2556@localhost6.localdomain6>
 <AANLkTino8StCF7OZvzxeFrs0a4JVnxRK-deJ4XUU41Ef@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-905798006-1286296838=:2556"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-905798006-1286296838=:2556
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

Linus,

On Tue, 5 Oct 2010, Linus Torvalds wrote:

> On Tue, Oct 5, 2010 at 12:30 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Tue, 5 Oct 2010, Rusty Russell wrote:
> >
> >> On Tue, 5 Oct 2010 09:13:38 am Thomas Gleixner wrote:
> >> > The patch below cures it.
> >>
> >> Using module_mutex here is just lazy...  Here's 5c, go buy your own lock :)
> >
> > I'm lazy. :) My evil plan of sending a crap patch so it gets replaced
> > by a nice one worked well :)
> 
> Can you test the one I sent out (the second one with the trivial
> module unload fix)? My own testing would be pretty pointless, since I
> don't use modules myself (I've compile-tested it, and it all looks
> sane, but...)

Hmm, with this patch the corruption triggers at every boot (5 of
5). Without it it's just happening randomly (1 of 10)

Digging further. Dammit, I fear my evil plan fires back now due to
some even more lazy person who doesn't use modules. :)

Thanks,

	tglx

------------[ cut here ]------------
WARNING: at /home/tglx/work/kernel/rt-new/linux-2.6-tip/lib/list_debug.c:26 __list_add+0x3f/0x83()
Hardware name:
list_add corruption. next->prev should be prev (ffffffff81a4c460), but was 0f000000a8838948. (next=ffffffffa00091a8).
Modules linked in: firewire_ohci floppy sata_sil firewire_core crc_itu_t radeon ttm drm_kms_helper drm hwmon i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
Pid: 421, comm: modprobe Not tainted 2.6.36-rc5+ #96
Call Trace:
 [<ffffffff81049c25>] warn_slowpath_common+0x85/0x9d
 [<ffffffff81049ce0>] warn_slowpath_fmt+0x46/0x48
 [<ffffffff810795b1>] ? verify_export_symbols+0x16/0x126
 [<ffffffff811fb820>] __list_add+0x3f/0x83
 [<ffffffff811edb03>] module_bug_finalize+0xb9/0xca
 [<ffffffff8107abac>] load_module+0x1038/0x1798
 [<ffffffff8107b356>] sys_init_module+0x4a/0x1e0
 [<ffffffff81009cd2>] system_call_fastpath+0x16/0x1b
---[ end trace f5f118a264676de3 ]---
calling  raid_init+0x0/0x12 [raid1] @ 421
md: raid1 personality registered for level 1
initcall raid_init+0x0/0x12 [raid1] returned 0 after 1 usecs
invalid opcode: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/dev
CPU 1
Modules linked in: raid1 firewire_ohci floppy sata_sil firewire_core crc_itu_t radeon ttm drm_kms_helper drm hwmon i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]

Pid: 409, comm: mdadm Tainted: G        W   2.6.36-rc5+ #96 D975XBX/
RIP: 0010:[<ffffffffa00091b1>]  [<ffffffffa00091b1>] setup_conf+0xc2/0x294 [raid1]
RSP: 0018:ffff880078fe3c40  EFLAGS: 00010282
RAX: ffff880078fe3c58 RBX: ffff88007844a300 RCX: ffff880078702d40
RDX: 0000000000000100 RSI: ffff880078a3e800 RDI: 00000000000000ff
RBP: ffff880078fe3c58 R08: 00000000000080d0 R09: ffff880001e20940
R10: ffff88007fbb9c00 R11: 0000000000000060 R12: ffff880078b81000
R13: 00000000fffffff4 R14: ffff880078b81018 R15: ffff880078fe3ca8
FS:  00007f532de28700(0000) GS:ffff880002080000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000041a078 CR3: 00000000784c2000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mdadm (pid: 409, threadinfo ffff880078fe2000, task ffff880078ab0080)
Stack:
 ffff880078b81000 0000000000000000 ffff880078b81018 ffff880078fe3c88
<0> ffffffffa000c00b ffff880078b81000 ffff880078b81018 ffff880078b81018
<0> ffff880078b81018 ffff880078fe3d28 ffffffff8133ca1b 0000000000000000
Call Trace:
 [<ffffffffa000c00b>] run+0x89/0x248 [raid1]
 [<ffffffff8133ca1b>] md_run+0x57c/0x84a
 [<ffffffff8133ccfd>] do_md_run+0x14/0x67
 [<ffffffff8133ea62>] md_ioctl+0xdf9/0x1074
 [<ffffffff811bc355>] ? inode_has_perm+0x7a/0x90
 [<ffffffff811bc682>] ? dentry_has_perm+0x5a/0x70
 [<ffffffff811e33a4>] __blkdev_driver_ioctl+0x28/0x2a
 [<ffffffff811e3c29>] blkdev_ioctl+0x5bd/0x5fc
 [<ffffffff811bc40f>] ? file_has_perm+0xa4/0xc6
 [<ffffffff8111886c>] block_ioctl+0x37/0x3b
 [<ffffffff810fe119>] do_vfs_ioctl+0x4b9/0x508
 [<ffffffff810fe1be>] sys_ioctl+0x56/0x79
 [<ffffffff81009cd2>] system_call_fastpath+0x16/0x1b
Code: 24 e0 00 00 00 48 c7 c6 54 b1 00 a0 bf 00 01 00 00 89 50 08 48 8b 8b 98 00 00 00 48 c7 c2 31 90 00 a0 e8 34 f5 0a e1 48 85 c0 58 <d4> 00 a0 ff ff ff ff 84 b2 01 00 00 48 8b 83 98 00 00 00 49 8d
RIP  [<ffffffffa00091b1>] setup_conf+0xc2/0x294 [raid1]
 RSP <ffff880078fe3c40>
---[ end trace f5f118a264676de4 ]---
Segmentation fault
calling  wait_scan_init+0x0/0x12 [scsi_wait_scan] @ 435
initcall wait_scan_init+0x0/0x12 [scsi_wait_scan] returned 0 after 0 usecs
dracut: Autoassembling MD Raid

---1463795968-905798006-1286296838=:2556--

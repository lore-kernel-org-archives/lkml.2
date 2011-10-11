Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab1JKNeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 09:34:50 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55602
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752888Ab1JKNet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 09:34:49 -0400
Date: Tue, 11 Oct 2011 09:34:48 -0400
From: Christoph Hellwig <hch@infradead.org>
To: linux-kernel@vger.kernel.org, aradford@gmail.com
Cc: xfs@oss.sgi.com
Subject: Re: 2.6.38.8 kernel bug in XFS or megaraid driver with heavy I/O load
Message-ID: <20111011133448.GA10692@infradead.org>
References: <20111011091757.GA32589@otto.nzcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111011091757.GA32589@otto.nzcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 11:17:57AM +0200, Anders Ossowicki wrote:
> We seem to have hit a bug on our brand-new disk with an XFS filesystem on the
> 2.6.38.8 kernel. The disk is 2 Dell MD1220 enclosures with Intel SSDs daisy
> chained behind an LSI MegaRAID SAS 9285-8e raid controller. It was under heavy
> I/O load, 1-200 MB/s r/w from postgres for about a week before the bug showed
> up. The system itself is a Dell PowerEdge R815 with 32 cpu cores and 256G
> memory. 
> 
> Support for the 9285-8e controller was introduced as part of a series of
> patches for drivers/scsi/megaraid in 2.6.38 (0d49016b..cd50ba8e). Given that
> the megaraid driver support for the 9285-8e controller is so new it might be
> the real source of the issue, but this is pure speculation on my part. Any
> suggestions would be most welcome.
> 
> The full dmesg is available at
> http://dev.exherbo.org/~arkanoid/kat-dmesg-2011-10.txt
> 
> BUG: unable to handle kernel paging request at 000000000040403c
> IP: [<ffffffff810f8d71>] find_get_pages+0x61/0x110
> PGD 0 
> Oops: 0000 [#1] SMP  
> last sysfs file: /sys/devices/system/cpu/cpu31/cache/index2/shared_cpu_map
> CPU 11 
> Modules linked in: btrfs zlib_deflate crc32c libcrc32c ufs qnx4 hfsplus hfs
>  minix ntfs vfat msdos fat jfs xfs reiserfs nfsd exportfs nfs lockd nfs_acl
>  auth_rpcgss sunrpc autofs4 psmouse serio_raw joydev ixgbe lp amd64_edac_mod
>  i2c_piix4 dca parport edac_core bnx2 power_meter dcdbas mdio edac_mce_amd ses
>  enclosure usbhid hid ahci mpt2sas libahci scsi_transport_sas megaraid_sas
>  raid_class 
> 
> Pid: 27512, comm: flush-8:32 Tainted: G        W   2.6.38.8 #1 Dell Inc.
>  PowerEdge R815/04Y8PT
> RIP: 0010:[<ffffffff810f8d71>]  [<ffffffff810f8d71>] find_get_pages+0x61/0x110

This is core VM code, and operates purely on on-stack variables except
for the page cache radix tree nodes / pages.  So this either could be a
core VM bug that no one has noticed yet, or memory corruption.  Can you
run memtest86 on the box?

> RSP: 0018:ffff881fdee55800  EFLAGS: 00010246
> RAX: ffff8814a66d7000 RBX: ffff881fdee558c0 RCX: 000000000000000e
> RDX: 0000000000000005 RSI: 0000000000000001 RDI: 0000000000404034
> RBP: ffff881fdee55850 R08: 0000000000000001 R09: 0000000000000002
> R10: ffffea00a0ff7788 R11: ffff88129306ac88 R12: 0000000000031535
> R13: 000000000000000e R14: ffff881fdee558e8 R15: 0000000000000005
> FS:  00007fec9ce13720(0000) GS:ffff88181fc80000(0000) knlGS:00000000f744d6d0
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 000000000040403c CR3: 0000000001a03000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process flush-8:32 (pid: 27512, threadinfo ffff881fdee54000, task ffff881fdf4adb80)
> Stack:
>  0000000000000000 0000000000000000 0000000000000000 ffff8832e7edf6e0
>  0000000000000000 ffff881fdee558b0 ffffea008b443c18 0000000000031535
>  ffff8832e7edf590 ffff881fdee55d20 ffff881fdee55870 ffffffff81101f92
> Call Trace:
>  [<ffffffff81101f92>] pagevec_lookup+0x22/0x30
>  [<ffffffffa033e00d>] xfs_cluster_write+0xad/0x180 [xfs]
>  [<ffffffffa033e4f4>] xfs_vm_writepage+0x414/0x4f0 [xfs]
>  [<ffffffff810ffb77>] __writepage+0x17/0x40 
>  [<ffffffff81100d95>] write_cache_pages+0x1c5/0x4a0
>  [<ffffffff810ffb60>] ? __writepage+0x0/0x40
>  [<ffffffff81101094>] generic_writepages+0x24/0x30
>  [<ffffffffa033d5dd>] xfs_vm_writepages+0x5d/0x80 [xfs]
>  [<ffffffff811010c1>] do_writepages+0x21/0x40
>  [<ffffffff811730bf>] writeback_single_inode+0x9f/0x250
>  [<ffffffff8117370b>] writeback_sb_inodes+0xcb/0x170
>  [<ffffffff81174174>] writeback_inodes_wb+0xa4/0x170
>  [<ffffffff8117450b>] wb_writeback+0x2cb/0x440
>  [<ffffffff81035bb9>] ? default_spin_lock_flags+0x9/0x10
>  [<ffffffff8158b3af>] ? _raw_spin_lock_irqsave+0x2f/0x40
>  [<ffffffff811748ac>] wb_do_writeback+0x22c/0x280
>  [<ffffffff811749aa>] bdi_writeback_thread+0xaa/0x260
>  [<ffffffff81174900>] ? bdi_writeback_thread+0x0/0x260
>  [<ffffffff81081b76>] kthread+0x96/0xa0
>  [<ffffffff8100cda4>] kernel_thread_helper+0x4/0x10
>  [<ffffffff81081ae0>] ? kthread+0x0/0xa0
>  [<ffffffff8100cda0>] ? kernel_thread_helper+0x0/0x10
> Code: 4e 1c 00 85 c0 89 c1 0f 84 a7 00 00 00 49 89 de 45 31 ff 31 d2 0f 1f 44
>  00 00 49 8b 06 48 8b 38 48 85 ff 74 3d 40 f6 c7 01 75 54 <44> 8b 47 08 4c 8d 57
>  08 45 85 c0 74 e5 45 8d 48 01 44 89 c0 f0  
> RIP  [<ffffffff810f8d71>] find_get_pages+0x61/0x110
> RSP <ffff881fdee55800>
> CR2: 000000000040403c
> ---[ end trace 84193c2a431ae14b ]--- 

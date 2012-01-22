Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab2AVLiU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 06:38:20 -0500
Received: from trent.utfs.org ([194.246.123.103]:50432 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab2AVLiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 06:38:19 -0500
Date: Sun, 22 Jan 2012 03:38:11 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Jens Axboe <axboe@kernel.dk>
cc: LKML <linux-kernel@vger.kernel.org>, peterz@infradead.org,
        dm-devel@redhat.com
Subject: Re: BUG: spinlock trylock failure on UP on CPU#0, vgchange/936
In-Reply-To: <alpine.DEB.2.01.1201220233260.2895@trent.utfs.org>
Message-ID: <alpine.DEB.2.01.1201220329150.2895@trent.utfs.org>
References: <alpine.DEB.2.01.1201180009520.2895@trent.utfs.org> <alpine.DEB.2.01.1201210341430.2895@trent.utfs.org> <4F1AB392.20604@kernel.dk> <alpine.DEB.2.01.1201211430340.2895@trent.utfs.org> <4F1BE548.3000800@kernel.dk>
 <alpine.DEB.2.01.1201220233260.2895@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jan 2012 at 02:36, Christian Kujau wrote:
> On Sun, 22 Jan 2012 at 11:30, Jens Axboe wrote:
> > What about with this on top?
> 
> Will try. A compile on this box takes almost two hours (PowerBook G4, 
> throttled to 70MHz), would it be enough to remove the block/*.o files and 
> continue from there?

OK, I did that. With the pull from linux-block.git ("for-linus") and your 
diff[0], the BUG is still there:

[   15.048991] BUG: spinlock trylock failure on UP on CPU#0, vgchange/911
[   15.050579]  lock: ef32a9f8, .magic: dead4ead, .owner: vgchange/911, .owner_cpu: 0
[   15.052081] Call Trace:
[   15.053561] [eecaf9e0] [c0009de4] show_stack+0x70/0x1bc (unreliable)
[   15.055078] [eecafa20] [c0326d64] spin_dump+0x70/0xe0
[   15.056576] [eecafa30] [c0326f48] do_raw_spin_trylock+0x58/0x70
[   15.058052] [eecafa40] [c0512b88] _raw_spin_trylock+0x34/0xa0
[   15.059496] [eecafa60] [c02f53f4] put_io_context+0xd8/0x184
[   15.060953] [eecafa80] [c030343c] __cfq_slice_expired+0x1e4/0x43c
[   15.062426] [eecafac0] [c03053bc] cfq_insert_request+0x234/0x558
[   15.063908] [eecafae0] [c02edc00] __elv_add_request+0x1a4/0x2d4
[   15.065371] [eecafaf0] [c02f0f14] blk_flush_plug_list+0x22c/0x270
[   15.066833] [eecafb20] [c051133c] io_schedule+0x74/0xec
[   15.068270] [eecafb30] [c0110f1c] dio_await_completion+0x60/0xf4
[   15.069692] [eecafb50] [c0112ca0] __blockdev_direct_IO+0x1b80/0x3574
[   15.071110] [eecafd70] [c010f438] blkdev_direct_IO+0x54/0x64
[   15.072512] [eecafd90] [c009a424] generic_file_aio_read+0x7b8/0x808
[   15.073890] [eecafe40] [c00d4f68] do_sync_read+0xb8/0x144
[   15.075254] [eecafef0] [c00d6168] vfs_read+0xcc/0x1c0
[   15.076610] [eecaff10] [c00d6394] sys_read+0x58/0xc8
[   15.077958] [eecaff40] [c00127a0] ret_from_syscall+0x0/0x38
[   15.079299] --- Exception: c01 at 0xfe52b90
[   15.079302]     LR = 0x1003e834


As I said before, I do have lvm2 tools installed, but I'm not actually 
using LVM. Grepping through the initscripts, the lvm2 init script 
seems to be doing the following during bootup:

  do_start()
  {
        modprobe dm-mod 2> /dev/null || :
        /sbin/vgscan --ignorelockingfailure --mknodes || :
        /sbin/vgchange -aly --ignorelockingfailure || return 2
  }


Running "vgchange -aly --ignorelockingfailure" again (that is, after 
the machine finished booting and printed the BUG already) does not print 
the BUG again, I guess that's intentional.

Thanks,
Christian.

[0] http://nerdbynature.de/bits/3.2.0/block-axboe-1.diff
-- 
BOFH excuse #262:

Our POP server was kidnapped by a weasel.

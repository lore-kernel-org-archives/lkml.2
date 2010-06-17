Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724Ab0FQUsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:48:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750705Ab0FQUsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:48:06 -0400
Date: Thu, 17 Jun 2010 13:47:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sage Weil <sage@newdream.net>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org, hch@lst.de, bfields@citi.umich.edu,
       Neil Brown <neilb@suse.de>
Subject: Re: weird umem vs nfsd regression
Message-Id: <20100617134706.6c5ad7f1.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.1006171305320.8387@cobra.newdream.net>
References: <Pine.LNX.4.64.1006171305320.8387@cobra.newdream.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010 13:21:36 -0700 (PDT)
Sage Weil <sage@newdream.net> wrote:

> Hi,
> 
> I started seeing a hang during bootup of a machine with a umem 
> (micromemory nvram) card.  I bisected it and narrowed it down to commit 
> b95a5680 which merged a couple nfsd changes, although strangely reverting 
> just b160fdab ('nfsd: nfsd_setattr needs to call commit_metadata') is 
> sufficient to make the problem go away.
> 
> I'm not quite sure what to make of it.  I don't see how the nfsd change 
> would affect the umem driver initialization.  The machine _is_ netbooting 
> (kernel via PXE, nfs root), though.

gee, who maintains umem?  Neil wrote it eight years ago ;)

> When it hangs, I see
> 
> [    1.069553] v2.3 : Micro Memory(tm) PCI memory board block driver
> [    1.075780] umem 0000:02:01.0: can't find IRQ for PCI INT C; probably buggy MP table
> [    1.083633] umem 0000:02:01.0: Micro Memory(tm) controller found (PCI Mem Module (Battery Backup))
> [    1.092762] umem 0000:02:01.0: CSR 0xfc9ffc00 -> 0xffffc90001466c00 (0x100)
> [    1.099880] umem 0000:02:01.0: Size 1048576 KB, Battery 1 Disabled (FAILURE), Battery 2 Disabled (FAILURE)
> [    1.109745] umem 0000:02:01.0: Window size 16777216 bytes, IRQ 9
> [    1.115842] umem 0000:02:01.0: memory NOT initialized. Consider over-writing whole device.
> [    1.125778]  umema:
> [  240.886560] INFO: task swapper:1 blocked for more than 120 seconds.
> [  240.893186] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  240.901115] swapper       D 0000000000000001     0     1      0 0x00000000
> [  240.908231]  ffff8800f8da1b50 0000000000000046 ffff8800f8da1ac0 ffff8800f8da1fd8
> [  240.916027]  ffff8800f8d80050 0000000000004000 0000000000004000 00000000001d2180
> [  240.923819]  00000000001d2180 ffff8800f8da1fd8 ffff8800f8da1fd8 00000000001d2180
> [  240.931611] Call Trace:
> [  240.934133]  [<ffffffff8144f96d>] ? _raw_spin_unlock_irqrestore+0x4c/0x68
> [  240.941011]  [<ffffffff812a99ab>] ? mm_unplug_device+0x47/0x50
> [  240.946929]  [<ffffffff8144cb84>] io_schedule+0x38/0x4d
> [  240.952238]  [<ffffffff810802d0>] sync_page+0x4c/0x50
> [  240.957370]  [<ffffffff8144cf9b>] __wait_on_bit_lock+0x42/0x8b
> [  240.963288]  [<ffffffff81080284>] ? sync_page+0x0/0x50
> [  240.968508]  [<ffffffff81080270>] __lock_page+0x64/0x6b
> [  240.973821]  [<ffffffff8104b500>] ? wake_bit_function+0x0/0x2a
> [  240.979741]  [<ffffffff81080796>] do_read_cache_page+0xd3/0x135
> [  240.985745]  [<ffffffff810da132>] ? blkdev_readpage+0x0/0x15
> [  240.991492]  [<ffffffff81080834>] read_cache_page_async+0x17/0x19
> [  240.997671]  [<ffffffff8108083f>] read_cache_page+0x9/0x13
> [  241.003244]  [<ffffffff81102a7b>] read_dev_sector+0x2e/0x93
> [  241.008903]  [<ffffffff8110397c>] ? adfspart_check_ICS+0x0/0x19c
> [  241.014997]  [<ffffffff811039b6>] adfspart_check_ICS+0x3a/0x19c
> [  241.021001]  [<ffffffff81432011>] ? kmemleak_alloc+0x5b/0xa2
> [  241.026748]  [<ffffffff810ab6d9>] ? kmem_cache_alloc+0x14f/0x17d
> [  241.032842]  [<ffffffff8110397c>] ? adfspart_check_ICS+0x0/0x19c
> [  241.038934]  [<ffffffff81103778>] rescan_partitions+0x196/0x39a
> [  241.044940]  [<ffffffff8121a24e>] ? disk_get_part+0x74/0xbc
> [  241.050600]  [<ffffffff810da63a>] __blkdev_get+0x271/0x365
> [  241.056172]  [<ffffffff81222b14>] ? kobject_put+0x47/0x4c
> [  241.061658]  [<ffffffff810da739>] blkdev_get+0xb/0xd
> [  241.066708]  [<ffffffff81103121>] register_disk+0xbd/0x11f
> [  241.072274]  [<ffffffff8121a3be>] add_disk+0xb8/0x116
> [  241.077414]  [<ffffffff8193abbf>] mm_init+0x126/0x19e
> [  241.082556]  [<ffffffff8193aa99>] ? mm_init+0x0/0x19e
> [  241.087693]  [<ffffffff810001f0>] do_one_initcall+0x5a/0x14f
> [  241.093440]  [<ffffffff81914908>] kernel_init+0x148/0x1d2
> [  241.098925]  [<ffffffff81003794>] kernel_thread_helper+0x4/0x10
> [  241.104933]  [<ffffffff8102cd00>] ? can_nice+0x19/0x3a
> [  241.110157]  [<ffffffff8144fcc0>] ? restore_args+0x0/0x30
> [  241.115644]  [<ffffffff819147c0>] ? kernel_init+0x0/0x1d2
> [  241.121128]  [<ffffffff81003790>] ? kernel_thread_helper+0x0/0x10
> [  241.127300] 1 lock held by swapper/1:
> [  241.131046]  #0:  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff810da428>] __blkdev_get+0x5f/0x365
> 
> and with the above commit reverted, I get a 'normal' umem driver init (the 
> umem errors/warnings are normal.. the batteries aren't connected and the 
> card isn't being used):

Given that the kernel is still running initcalls, nfsd hasn't done
anything yet.  So it might be a weird ordering thing, or someone has
scribbled on some memory somewhere and shuffling things around in nfsd
is what caused the memory scribble to scrible on something which
someone cares about.

Ugly.  Perhaps try enabling every kernel debug option you can lay your
hands on?



> Jun 17 12:49:58 ceph3 kernel: [    2.270121] v2.3 : Micro Memory(tm) PCI memory board block driver
> Jun 17 12:49:58 ceph3 kernel: [    2.276360] umem 0000:02:01.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> Jun 17 12:49:58 ceph3 kernel: [    2.283237] umem 0000:02:01.0: Micro Memory(tm) controller found (PCI Mem Module (Battery Backup))
> Jun 17 12:49:58 ceph3 kernel: [    2.292366] umem 0000:02:01.0: CSR 0xfc9ffc00 -> 0xffffc90001478c00 (0x100)
> Jun 17 12:49:58 ceph3 kernel: [    2.299476] umem 0000:02:01.0: Size 1048576 KB, Battery 1 Disabled (FAILURE), Battery 2 Disabled (FAILURE)
> Jun 17 12:49:58 ceph3 kernel: [    2.309507] umem 0000:02:01.0: Window size 16777216 bytes, IRQ 20
> Jun 17 12:49:58 ceph3 kernel: [    2.315691] umem 0000:02:01.0: memory NOT initialized. Consider over-writing whole device.
> Jun 17 12:49:58 ceph3 kernel: [    2.325697]  umema:
> Jun 17 12:49:58 ceph3 kernel: [    2.328102] umem 0000:02:01.0: DMAstat - ANY_ERR MBE_ERR CHAIN_COMPLETE DMA_COMPLETE 
> Jun 17 12:49:58 ceph3 kernel: [    2.328239] umem 0000:02:01.0: Memory access error detected (err count 0)
> Jun 17 12:49:58 ceph3 kernel: [    2.328239] umem 0000:02:01.0: Multi-bit EDC error
> Jun 17 12:49:58 ceph3 kernel: [    2.328239] umem 0000:02:01.0: Fault Address 0x0000000ff8, Fault Data 0xfff7fffdffffffff
> Jun 17 12:49:58 ceph3 kernel: [    2.328239] umem 0000:02:01.0: Fault Check 0x00, Fault Syndrome 0x00
> Jun 17 12:49:58 ceph3 kernel: [    2.354756] umem 0000:02:01.0: I/O error on sector 0/4096
> Jun 17 12:49:58 ceph3 kernel: [    2.360235] umem 0000:02:01.0: DMAstat - ANY_ERR MBE_ERR CHAIN_COMPLETE DMA_COMPLETE 
> Jun 17 12:49:58 ceph3 kernel: [    2.360248] Buffer I/O error on device umema, logical block 0
> Jun 17 12:49:58 ceph3 kernel: [    2.366169] umem 0000:02:01.0: DMAstat - ANY_ERR MBE_ERR CHAIN_COMPLETE DMA_COMPLETE 
> Jun 17 12:49:58 ceph3 kernel: [    2.366175] umem 0000:02:01.0: Memory access error detected (err count 0)
> Jun 17 12:49:58 ceph3 kernel: [    2.370075] umem 0000:02:01.0: Multi-bit EDC error

There may also be bugs in the umem driver.  Even if the IO errors are
bogus, the kernel shouldn't hang up waiting for IO completion as it's
doing here.



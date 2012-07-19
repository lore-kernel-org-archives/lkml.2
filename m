Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab2GSC1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 22:27:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab2GSC1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 22:27:30 -0400
Date: Wed, 18 Jul 2012 22:27:13 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, "Alasdair G. Kergon" <agk@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dm-devel@redhat.com, lwoodman@redhat.com,
        Andrea Arcangeli <aarcange@redhat.com>, kosaki.motohiro@jp.fujitsu.com
Subject: Re: Crash when IO is being submitted and block size is changed
In-Reply-To: <x49ipdmyz4q.fsf@segfault.boston.devel.redhat.com>
Message-ID: <Pine.LNX.4.64.1207181512530.10923@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com>
 <20120628111541.GB17515@quack.suse.cz> <Pine.LNX.4.64.1207152051490.4240@file.rdu.redhat.com>
 <x49ipdmyz4q.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jul 2012, Jeff Moyer wrote:

> Mikulas Patocka <mpatocka@redhat.com> writes:
> 
> > On Thu, 28 Jun 2012, Jan Kara wrote:
> >
> >> On Wed 27-06-12 23:04:09, Mikulas Patocka wrote:
> >> > The kernel crashes when IO is being submitted to a block device and block 
> >> > size of that device is changed simultaneously.
> >>   Nasty ;-)
> >> 
> >> > To reproduce the crash, apply this patch:
> >> > 
> >> > --- linux-3.4.3-fast.orig/fs/block_dev.c 2012-06-27 20:24:07.000000000 +0200
> >> > +++ linux-3.4.3-fast/fs/block_dev.c 2012-06-27 20:28:34.000000000 +0200
> >> > @@ -28,6 +28,7 @@
> >> >  #include <linux/log2.h>
> >> >  #include <linux/cleancache.h>
> >> >  #include <asm/uaccess.h> 
> >> > +#include <linux/delay.h>
> >> >  #include "internal.h"
> >> >  struct bdev_inode {
> >> > @@ -203,6 +204,7 @@ blkdev_get_blocks(struct inode *inode, s
> >> >  
> >> >  	bh->b_bdev = I_BDEV(inode);
> >> >  	bh->b_blocknr = iblock;
> >> > +	msleep(1000);
> >> >  	bh->b_size = max_blocks << inode->i_blkbits;
> >> >  	if (max_blocks)
> >> >  		set_buffer_mapped(bh);
> >> > 
> >> > Use some device with 4k blocksize, for example a ramdisk.
> >> > Run "dd if=/dev/ram0 of=/dev/null bs=4k count=1 iflag=direct"
> >> > While it is sleeping in the msleep function, run "blockdev --setbsz 2048 
> >> > /dev/ram0" on the other console.
> >> > You get a BUG at fs/direct-io.c:1013 - BUG_ON(this_chunk_bytes == 0);
> >> > 
> >> > 
> >> > One may ask "why would anyone do this - submit I/O and change block size 
> >> > simultaneously?" - the problem is that udev and lvm can scan and read all 
> >> > block devices anytime - so anytime you change block device size, there may 
> >> > be some i/o to that device in flight and the crash may happen. That BUG 
> >> > actually happened in production environment because of lvm scanning block 
> >> > devices and some other software changing block size at the same time.
> >> > 
> >>   Yeah, it's nasty and neither solution looks particularly appealing. One
> >> idea that came to my mind is: I'm trying to solve some races between direct
> >> IO, buffered IO, hole punching etc. by a new mapping interval lock. I'm not
> >> sure if it will go anywhere yet but if it does, we can fix the above race
> >> by taking the mapping lock for the whole block device around setting block
> >> size thus effectivelly disallowing any IO to it.
> >> 
> >> 								Honza
> >> -- 
> >> Jan Kara <jack@suse.cz>
> >> SUSE Labs, CR
> >> 
> >
> > Hi
> >
> > This is the patch that fixes this crash: it takes a rw-semaphore around 
> > all direct-IO path.
> >
> > (note that if someone is concerned about performance, the rw-semaphore 
> > could be made per-cpu --- take it for read on the current CPU and take it 
> > for write on all CPUs).
> 
> Here we go again.  :-)  I believe we had at one point tried taking a rw
> semaphore around GUP inside of the direct I/O code path to fix the fork
> vs. GUP race (that still exists today).  When testing that, the overhead
> of the semaphore was *way* too high to be considered an acceptable
> solution.  I've CC'd Larry Woodman, Andrea, and Kosaki Motohiro who all
> worked on that particular bug.  Hopefully they can give better
> quantification of the slowdown than my poor memory.
> 
> Cheers,
> Jeff

Both down_read and up_read together take 82 ticks on Core2, 69 ticks on 
AMD K10, 62 ticks on UltraSparc2 if the target is in L1 cache. So, if 
percpu rw_semaphores were used, it would slow down only by this amount.

I hope that Linux developers are not so obsessed with performance that 
they want a fast crashing kernel rather than a slow reliable kernel. Note 
that anything that changes a device block size (for example mounting a 
filesystem with non-default block size) may trigger a crash if lvm or udev 
reads the device simultaneously; the crash really happened in business 
environment).

Mikulas

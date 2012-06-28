Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab2F1LPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 07:15:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59834 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab2F1LPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 07:15:43 -0400
Date: Thu, 28 Jun 2012 13:15:41 +0200
From: Jan Kara <jack@suse.cz>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        "Alasdair G. Kergon" <agk@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: Crash when IO is being submitted and block size is changed
Message-ID: <20120628111541.GB17515@quack.suse.cz>
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 27-06-12 23:04:09, Mikulas Patocka wrote:
> The kernel crashes when IO is being submitted to a block device and block 
> size of that device is changed simultaneously.
  Nasty ;-)

> To reproduce the crash, apply this patch:
> 
> --- linux-3.4.3-fast.orig/fs/block_dev.c 2012-06-27 20:24:07.000000000 +0200
> +++ linux-3.4.3-fast/fs/block_dev.c 2012-06-27 20:28:34.000000000 +0200
> @@ -28,6 +28,7 @@
>  #include <linux/log2.h>
>  #include <linux/cleancache.h>
>  #include <asm/uaccess.h> 
> +#include <linux/delay.h>
>  #include "internal.h"
>  struct bdev_inode {
> @@ -203,6 +204,7 @@ blkdev_get_blocks(struct inode *inode, s
>  
>  	bh->b_bdev = I_BDEV(inode);
>  	bh->b_blocknr = iblock;
> +	msleep(1000);
>  	bh->b_size = max_blocks << inode->i_blkbits;
>  	if (max_blocks)
>  		set_buffer_mapped(bh);
> 
> Use some device with 4k blocksize, for example a ramdisk.
> Run "dd if=/dev/ram0 of=/dev/null bs=4k count=1 iflag=direct"
> While it is sleeping in the msleep function, run "blockdev --setbsz 2048 
> /dev/ram0" on the other console.
> You get a BUG at fs/direct-io.c:1013 - BUG_ON(this_chunk_bytes == 0);
> 
> 
> One may ask "why would anyone do this - submit I/O and change block size 
> simultaneously?" - the problem is that udev and lvm can scan and read all 
> block devices anytime - so anytime you change block device size, there may 
> be some i/o to that device in flight and the crash may happen. That BUG 
> actually happened in production environment because of lvm scanning block 
> devices and some other software changing block size at the same time.
> 
> 
> I would like to know, what is your opinion on fixing this crash? There are 
> several possibilities:
> 
> * we could potentially read i_blkbits once, store it in the direct i/o 
> structure and never read it again - direct i/o could be maybe modified for 
> this (it reads i_blkbits only at a few places). But what about non-direct 
> i/o? Non-direct i/o is reading i_blkbits much more often and the code was 
> obviously written without consideration that it may change - for block 
> devices, i_blkbits is essentially a random value that can change anytime 
> you read it and the code of block_read_full_page, __block_write_begin, 
> __block_write_full_page and others doesn't seem to take it into account.
> 
> * put some rw-lock arond all I/Os on block device. The rw-lock would be 
> taken for read on all I/O paths and it would be taken for write when 
> changing the block device size. The downside would be a possible 
> performance hit of the rw-lock. The rw-lock could be made per-cpu to avoid 
> cache line bouncing (take the rw-lock belonging to the current cpu for 
> read; for write take all cpus' locks).
> 
> * allow changing block size only if the device is open only once and the 
> process is singlethreaded? (so there couldn't be any outstanding I/Os). I 
> don't know if this could be tested reliably... Another question: what to 
> do if the device is open multiple times?
> 
> Do you have any other ideas what to do with it?
  Yeah, it's nasty and neither solution looks particularly appealing. One
idea that came to my mind is: I'm trying to solve some races between direct
IO, buffered IO, hole punching etc. by a new mapping interval lock. I'm not
sure if it will go anywhere yet but if it does, we can fix the above race
by taking the mapping lock for the whole block device around setting block
size thus effectivelly disallowing any IO to it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

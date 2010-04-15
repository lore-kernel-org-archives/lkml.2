Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab0DOKES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 06:04:18 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:54039 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab0DOKER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 06:04:17 -0400
Date: Thu, 15 Apr 2010 12:04:15 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Anton Blanchard <anton@samba.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix regression in O_DIRECT|O_SYNC writes to block
	devices
Message-ID: <20100415100415.GU27497@kernel.dk>
References: <20100415044039.GJ11751@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100415044039.GJ11751@kryten>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15 2010, Anton Blanchard wrote:
> 
> We are seeing a large regression in database performance on recent kernels.
> The database opens a block device with O_DIRECT|O_SYNC and a number of threads
> write to different regions of the file at the same time.
> 
> A simple test case is below. I haven't defined DEVICE to anything since getting
> it wrong will destroy your data :) On an 3 disk LVM with a 64k chunk size we
> see about 17MB/sec and only a few threads in IO wait:
> 
> procs  -----io---- -system-- -----cpu------
>  r  b     bi    bo   in   cs us sy id wa st
>  0  3      0 16170  656 2259  0  0 86 14  0
>  0  2      0 16704  695 2408  0  0 92  8  0
>  0  2      0 17308  744 2653  0  0 86 14  0
>  0  2      0 17933  759 2777  0  0 89 10  0
> 
> Most threads are blocking in vfs_fsync_range, which has:
> 
>         mutex_lock(&mapping->host->i_mutex);
>         err = fop->fsync(file, dentry, datasync);
>         if (!ret)
>                 ret = err;
>         mutex_unlock(&mapping->host->i_mutex);
> 
> Commit 148f948ba877f4d3cdef036b1ff6d9f68986706a (vfs: Introduce new helpers for
> syncing after writing to O_SYNC file or IS_SYNC inode) offers some explanation
> of what is going on:
> 
>     Use these new helpers for syncing from generic VFS functions. This makes
>     O_SYNC writes to block devices acquire i_mutex for syncing. If we really
>     care about this, we can make block_fsync() drop the i_mutex and reacquire
>     it before it returns.
> 
> Thanks Jan for such a good commit message! The patch below drops the i_mutex
> in blkdev_fsync as suggested. With it the testcase improves from 17MB/s to
> 68M/sec:
> 
> procs  -----io---- -system-- -----cpu------
>  r  b     bi    bo   in   cs us sy id wa st
>  0  7      0 65536 1000 3878  0  0 70 30  0
>  0 34      0 69632 1016 3921  0  1 46 53  0
>  0 57      0 69632 1000 3921  0  0 55 45  0
>  0 53      0 69640  754 4111  0  0 81 19  0
> 
> I'd appreciate any comments from the I/O guys on if this is the right approach.

Looks good to me, I see Jan already made a few style suggestions.

-- 
Jens Axboe


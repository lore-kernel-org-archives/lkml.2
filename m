Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab1HHSnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 14:43:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583Ab1HHSnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:43:49 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 11/11] DIO: optimize cache misses in the submission path
References: <1312259893-4548-1-git-send-email-andi@firstfloor.org>
	<1312259893-4548-12-git-send-email-andi@firstfloor.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 08 Aug 2011 14:43:38 -0400
In-Reply-To: <1312259893-4548-12-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Mon, 1 Aug 2011 21:38:13 -0700")
Message-ID: <x49zkjjg2w5.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> From: Andi Kleen <ak@linux.intel.com>
>
> Some investigation of a transaction processing workload showed that
> a major consumer of cycles in __blockdev_direct_IO is the cache miss
> while accessing the block size. This is because it has to walk
> the chain from block_dev to gendisk to queue.
>
> The block size is needed early on to check alignment and sizes.
> It's only done if the check for the inode block size fails.
> But the costly block device state is unconditionally fetched.
>
> - Reorganize the code to only fetch block dev state when actually
> needed.
>
> Then do a prefetch on the block dev early on in the direct IO
> path. This is worth it, because there is substantial code run
> before we actually touch the block dev now.
>
> - I also added some unlikelies to make it clear the compiler
> that block device fetch code is not normally executed.
>
> This gave a small, but measurable improvement on a large database
> benchmark (about 0.3%)
>
> BTW the check code looks somewhat dubious to me: why is the block size
> blk size only checked when the inode size check fails? Can
> someone explain the difference between all these different block
> sizes? Are they cheaper in a dozen?

There are two block sizes, the block size of the file system (typically
PAGE_SHIFT), and the logical block size of the underlying storage.  The
dio blkfactor represents the number of dio blocks in a single fs block.
Alignment to the fs block means that you don't have to do any sub-block
zeroing.  It also means you don't have to do as much math in converting
between dio blocks and fs blocks (big deal, right?).

I bet we could default to using the smaller block size all the time, and
still be able to detect when we don't have to do the sub-block zeroing.
Maybe that would be a good follow-on patch.

> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  fs/direct-io.c |   47 +++++++++++++++++++++++++++++++++++++----------
>  1 files changed, 37 insertions(+), 10 deletions(-)
>
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 03bcc6f..c424b88 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -1086,8 +1086,8 @@ static inline int drop_refcount(struct dio *dio)
>   * individual fields and will generate much worse code. 
>   * This is important for the whole file.
>   */
> -ssize_t
> -__blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
> +static inline ssize_t
> +do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
>  	struct block_device *bdev, const struct iovec *iov, loff_t offset, 
>  	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
>  	dio_submit_t submit_io,	int flags)
> @@ -1096,7 +1096,6 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
>  	size_t size;
>  	unsigned long addr;
>  	unsigned blkbits = inode->i_blkbits;
> -	unsigned bdev_blkbits = 0;
>  	unsigned blocksize_mask = (1 << blkbits) - 1;
>  	ssize_t retval = -EINVAL;
>  	loff_t end = offset;
> @@ -1109,12 +1108,14 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
>  	if (rw & WRITE)
>  		rw = WRITE_ODIRECT;
>  
> -	if (bdev)
> -		bdev_blkbits = blksize_bits(bdev_logical_block_size(bdev));
> +	/* 
> +	 * Avoid references to bdev if not absolutely needed to give
> +	 * the early prefetch in the caller enough time.
> +	 */
>  
> -	if (offset & blocksize_mask) {
> +	if (unlikely(offset & blocksize_mask)) {

You can't make this assumption.  Userspace controls what size/alignment
of blocks to send in.

> @@ -1312,6 +1315,30 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
>  out:
>  	return retval;
>  }
> +
> +ssize_t
> +__blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
> +	struct block_device *bdev, const struct iovec *iov, loff_t offset, 
> +	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
> +	dio_submit_t submit_io,	int flags)
> +{
> +	/* 
> +	 * The block device state is needed in the end to finally
> +	 * submit everything.  Since it's likely to be cache cold
> +	 * prefetch it here as first thing to hide some of the
> +	 * latency.
> +	 * 
> +	 * Attempt to prefetch the pieces we likely need later.
> +	 */
> +	prefetch(&bdev->bd_disk->part_tbl);
> +	prefetch(bdev->bd_queue);
> +	prefetch((char *)bdev->bd_queue + SMP_CACHE_BYTES);
> +
> +	return do_blockdev_direct_IO(rw, iocb, inode, bdev, iov, offset,
> +				     nr_segs, get_block, end_io,
> +				     submit_io, flags);
> +}
> +
>  EXPORT_SYMBOL(__blockdev_direct_IO);

Heh... you broke direct_io_worker out again (kind of).  ;-)

Cheers,
Jeff

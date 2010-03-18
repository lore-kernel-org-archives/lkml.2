Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab0CRWws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 18:52:48 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:53780 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab0CRWwr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 18:52:47 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Phillip Lougher <phillip.lougher@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Subject: Re: RFC: direct MTD support for SquashFS
References: <87vdcwv139.fsf@tac.ki.iif.hu>
	<87ljdsibqe.fsf@macbook.be.48ers.dk> <87r5nhziss.fsf@tac.ki.iif.hu>
	<bffbecbb1003181440kc78f4dbvd25d4e2ea17b52e5@mail.gmail.com>
Date: Thu, 18 Mar 2010 23:52:43 +0100
In-Reply-To: <bffbecbb1003181440kc78f4dbvd25d4e2ea17b52e5@mail.gmail.com>
	(Phillip Lougher's message of "Thu, 18 Mar 2010 21:40:45 +0000")
Message-ID: <87tysduts4.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Lougher <phillip.lougher@gmail.com> writes:

> On Thu, Mar 18, 2010 at 4:38 PM, Ferenc Wagner <wferi@niif.hu> wrote:
>
>> I could only compare apples to oranges before porting the patch to the
>> LZMA variant.  So I refrain from that for a couple of days yet.  But
>> meanwhile I started adding a pluggable backend framework to SquashFS,
>> and would much appreciate some comments about the applicability of this
>> idea.  The patch is (intended to be) a no-op, applies on top of current
>> git (a3d3203e4bb40f253b1541e310dc0f9305be7c84).
>
> This looks promising, making the backend pluggable (like the new
> compressor framework) is far better and cleaner than scattering the
> code full of #ifdef's.  Far better than the previous patch :-)

Yeah, the previous patch was only a little bit more than a proof that I
can make SquashFS work on an MTD device.  The MTD access part is
probably the only thing to criticize there: maybe it would be better
done in blocks of some particular size, via a different interface.

> +static void *bdev_init(struct squashfs_sb_info *msblk, u64 index,
> size_t length)
> +{
> +	struct squashfs_bdev *bdev = msblk->backend_data;
> +	struct buffer_head *bh;
> +
> +	bh = kcalloc((msblk->block_size >> bdev->devblksize_log2) + 1,
> +			sizeof(*bh), GFP_KERNEL);
>
> You should alloc against the larger of msblk->block_size and
> METADATA_SIZE (8 Kbytes).  Block_size could be 4 Kbytes only.

Hmm, okay.  Though this code is a verbatim copy of that in block.c.

> +static int fill_bdev_super(struct super_block *sb, void *data, int silent)
> +{
> +	struct squashfs_sb_info *msblk;
> +	struct squashfs_bdev *bdev;
> +	int err = squashfs_fill_super2(sb, data, silent, &squashfs_bdev_ops);
> +	if (err)
> +		return err;
> +
> +	bdev = kzalloc(sizeof(*bdev), GFP_KERNEL);
> +	if (!bdev)
> +		return -ENOMEM;
> +
> +	bdev->devblksize = sb_min_blocksize(sb, BLOCK_SIZE);
> +	bdev->devblksize_log2 = ffz(~bdev->devblksize);
> +
> +	msblk = sb->s_fs_info;
> +	msblk->backend_data = bdev;
> +	return 0;
> +}
>
> This function looks rather 'back-to-front' to me.  I'm assuming that
> squashfs_fill_super2() will be the current fill superblock function?

Yes, with the extra parameter added.

> This function wants to read data off the filesystem through the
> backend, and yet the backend (bdev, mblk->backend_data) hasn't been
> initialised when it's called...

It can't be, because msblk = sb->s_fs_info is allocated by
squashfs_fill_super().  Now it will be passed the ops, so after
allocating msblk it can also fill out the ops.  After that it can read,
and squashfs_read_data() will call the init, read and free operations of
the backend.  The backend itself has no persistent state between calls
to squashfs_read_data().  Btw. struct super_block has fields named
s_blocksize and s_blocksize_bits, aren't those the same as devblksize
and devblksize_log in squashfs_sb_info?  (They are being moved into
backend_data by the above.) If yes, shouldn't they be used instead?

While we're at it: is it really worth submitting all the buffer heads
at the beginning, instead of submitting them one at a time as needed by
the decompression process and letting the IO scheduler do readahead and
request coalescing as it sees fit?  At the very least, that would
require less memory, while possibly not hurting performance too much.

On the other hand, would it be possible to avoid the memory copy of
uncompressed blocks by doing a straight (DMA) transfer from the device
into the page cache?

LZMA support is not in mainline yet, but I saw that unlzma is done in a
single step, which requires block-sized input and output buffers.  Is
there any particular reason it's done this way, not chunk-by-chunk as
inflate?  This easily costs hundreds of kilobytes of virtual memory,
which isn't negligible on embedded systems.
-- 
Thanks for your comments,
Feri.

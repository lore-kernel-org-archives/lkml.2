Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab2FSRnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 13:43:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab2FSRni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 13:43:38 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: Kernel 3.3.8 breaks accidental ext3 mount of extended partition
References: <4FDEC3C2.4060909@secunet.com>
	<x49fw9smohy.fsf@segfault.boston.devel.redhat.com>
	<4FE0155A.6010404@secunet.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 19 Jun 2012 13:43:26 -0400
In-Reply-To: <4FE0155A.6010404@secunet.com> (Torsten Hilbrich's message of
	"Tue, 19 Jun 2012 07:59:54 +0200")
Message-ID: <x49ehpbjiyp.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Torsten Hilbrich <torsten.hilbrich@secunet.com> writes:

> The system where I reproduced the problem upstream is an amd64 based
> ubuntu 12.04 installation. I used both v3.3.8 and v3.4 for reproducing.
>
> The partition layout is the following:
>
> ======================================================================
>
> Disk /dev/sda: 120.0 GB, 120034123776 bytes
> 255 heads, 63 sectors/track, 14593 cylinders, total 234441648 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x1669c708
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sda1   *          63    86285114    43142526   83  Linux
> /dev/sda2       216797175   234436544     8819685   82  Linux swap / Solaris
> /dev/sda3        86285115    87088364      401625   83  Linux
> /dev/sda4        87088426   216797174    64854374+   5  Extended
> /dev/sda5        87088428    91104614     2008093+  83  Linux
> /dev/sda6        91104678   216797174    62846248+  8e  Linux LVM
>
> Partition table entries are not in disk order

OK, got it to reproduce, thanks for the info.  The attached patch fixed
the problem for me.

Note, though, that the patch doesn't make sense to me.  blkdev_max_block
returns i_size_read(blkdev_inode) >> block_size.  This should be the
*size* of the block device, not the max block.  The code in
fs/block_device.c uses the return value in two different ways!

static int
blkdev_get_block(struct inode *inode, sector_t iblock,
                struct buffer_head *bh, int create)
{
        if (iblock >= blkdev_max_block(I_BDEV(inode))) {

Here, the return value from blkdev_max_block is interpreted as the size
of the device, so actually max_block + 1.

static int
blkdev_get_blocks(struct inode *inode, sector_t iblock,
                struct buffer_head *bh, int create)
{
        sector_t end_block = blkdev_max_block(I_BDEV(inode));
        unsigned long max_blocks = bh->b_size >> inode->i_blkbits;

        if ((iblock + max_blocks) > end_block) {

Here, the return value is treated as the maximum addressable block
number.  Given the fact that I had to modify init_page_buffers to treat
the return value from blkdev_max_block as the maximum addressable block,
I clearly have something wrong with my logic.  Nick, Jens, care to set
my head straight?

Cheers,
Jeff

diff --git a/fs/buffer.c b/fs/buffer.c
index 838a9cf..769b30b 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -930,7 +930,7 @@ init_page_buffers(struct page *page, struct block_device *bdev,
 			bh->b_blocknr = block;
 			if (uptodate)
 				set_buffer_uptodate(bh);
-			if (block < end_block)
+			if (block <= end_block)
 				set_buffer_mapped(bh);
 		}
 		block++;

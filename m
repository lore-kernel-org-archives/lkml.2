Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab0GZBve (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 21:51:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56576 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215Ab0GZBvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 21:51:18 -0400
Date: Mon, 26 Jul 2010 11:51:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, David Chinner <david@fromorbit.com>,
        xfs-masters@oss.sgi.com
Subject: linux-next: manual merge of the vfs tree with the xfs tree
Message-Id: <20100726115116.1e6de038.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

[These became irrelevant when I reverted the xfs tree for a build error,
but will be done when the xfs tree is fixed.]

Today's linux-next merge of the vfs tree got a conflict in
fs/xfs/linux-2.6/xfs_aops.c between commit
7346e1197eb76e22199b6b4625f129331e0fd7ac ("xfs simplify and speed up
direct I/O completions") from the xfs tree and commit
b682ce06449c35a85dc5e63fcaab7dba2ba6df9b ("sort out blockdev_direct_IO
variants") from the vfs tree.

Also between commit 6f6b39eb706f5617750cf02952e4e6d7470c40bf ("xfs: use
GFP_NOFS for page cache allocation") from the xfs tree and commit
4478b21470275454f9eb6f590dfe7cc54d643978 ("get rid of
block_write_begin_newtrunc") from the vfs tree.

I fixed them up (I think - see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/xfs/linux-2.6/xfs_aops.c
index d24e78f,77a9ecc..0000000
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@@ -1471,26 -1655,22 +1471,26 @@@ xfs_vm_direct_IO
  	loff_t			offset,
  	unsigned long		nr_segs)
  {
 -	struct file	*file = iocb->ki_filp;
 -	struct inode	*inode = file->f_mapping->host;
 -	struct block_device *bdev;
 -	ssize_t		ret;
 -
 -	bdev = xfs_find_bdev_for_inode(inode);
 -
 -	iocb->private = xfs_alloc_ioend(inode, rw == WRITE ?
 -					IO_UNWRITTEN : IO_READ);
 -
 -	ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iov, offset,
 -				   nr_segs, xfs_get_blocks_direct,
 -				   xfs_end_io_direct, NULL, 0);
 +	struct inode		*inode = iocb->ki_filp->f_mapping->host;
 +	struct block_device	*bdev = xfs_find_bdev_for_inode(inode);
 +	ssize_t			ret;
 +
 +	if (rw & WRITE) {
 +		iocb->private = xfs_alloc_ioend(inode, IO_NEW);
 +
- 		ret = blockdev_direct_IO_no_locking(rw, iocb, inode, bdev, iov,
- 						    offset, nr_segs,
- 						    xfs_get_blocks_direct,
- 						    xfs_end_io_direct_write);
++		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iov,
++					   offset, nr_segs,
++					   xfs_get_blocks_direct,
++					   xfs_end_io_direct_write, NULL, 0);
 +		if (ret != -EIOCBQUEUED && iocb->private)
 +			xfs_destroy_ioend(iocb->private);
 +	} else {
- 		ret = blockdev_direct_IO_no_locking(rw, iocb, inode, bdev, iov,
- 						    offset, nr_segs,
- 						    xfs_get_blocks_direct,
- 						    NULL);
++		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iov,
++					   offset, nr_segs,
++					   xfs_get_blocks_direct,
++					   NULL, NULL, 0);
 +	}
  
 -	if (unlikely(ret != -EIOCBQUEUED && iocb->private))
 -		xfs_destroy_ioend(iocb->private);
  	return ret;
  }
  
@@@ -1504,9 -1700,31 +1520,31 @@@ xfs_vm_write_begin
  	struct page		**pagep,
  	void			**fsdata)
  {
- 	*pagep = NULL;
- 	return block_write_begin(file, mapping, pos, len, flags | AOP_FLAG_NOFS,
- 				 pagep, fsdata, xfs_get_blocks);
+ 	int			ret;
+ 
 -	ret = block_write_begin(mapping, pos, len, flags, pagep,
++	ret = block_write_begin(mapping, pos, len, flags | AOP_FLAG_NOFS, pagep,
+ 				xfs_get_blocks);
+ 	if (unlikely(ret))
+ 		xfs_vm_write_failed(mapping, pos + len);
+ 	return ret;
+ }
+ 
+ STATIC int
+ xfs_vm_write_end(
+ 	struct file		*file,
+ 	struct address_space	*mapping,
+ 	loff_t			pos,
+ 	unsigned		len,
+ 	unsigned		copied,
+ 	struct page		*page,
+ 	void			*fsdata)
+ {
+ 	int			ret;
+ 
+ 	ret = generic_write_end(file, mapping, pos, len, copied, page, fsdata);
+ 	if (unlikely(ret < len))
+ 		xfs_vm_write_failed(mapping, pos + len);
+ 	return ret;
  }
  
  STATIC sector_t

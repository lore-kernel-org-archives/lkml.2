Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab2K2R0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 12:26:44 -0500
Received: from mx2.fusionio.com ([66.114.96.31]:36976 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575Ab2K2R0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 12:26:42 -0500
X-ASG-Debug-ID: 1354210001-0421b52b7d4a520001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Thu, 29 Nov 2012 12:26:39 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] Introduce a method to catch mmap_region (was: Recent
 kernel "mount" slow)
Message-ID: <20121129172639.GA30094@shiny>
X-ASG-Orig-Subj: Re: [PATCH] Introduce a method to catch mmap_region (was: Recent
 kernel "mount" slow)
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Jeff Chua <jeff.chua.linux@gmail.com>,
	Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <Pine.LNX.4.64.1211281422360.26389@file.rdu.redhat.com>
 <CA+55aFyXdtVJ=SG9bU4qfggCR6DPvz4vOFYxKJZx_WdyFv+3Fw@mail.gmail.com>
 <CA+55aFyXS0nkDB95c3pcdg1ctrNnUGO8aDuRNhKSEg3JrOqWhA@mail.gmail.com>
 <Pine.LNX.4.64.1211281540200.5283@file.rdu.redhat.com>
 <CA+55aFwbnQsvpsOLS6w_G35d4w+Ezv5tOx2SE7dShJhX4iP_0Q@mail.gmail.com>
 <Pine.LNX.4.64.1211281904010.3957@file.rdu.redhat.com>
 <CA+55aFz1Wv2S+3XVmZE1cfiN0TZ4gNA8yWbNgufDLTMc8sKf2A@mail.gmail.com>
 <CA+55aFxYCxsRM==WMGihQGOA7f5u2X_8boJypsxS2v=WMnr70g@mail.gmail.com>
 <CA+55aFxrkX_=4yNQ1TwjqU9=pkRY=ud+Kw3YnADJMJxA-ZqQUg@mail.gmail.com>
 <20121129141249.GB30766@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121129141249.GB30766@shiny>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1354210001
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.115616
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 07:12:49AM -0700, Chris Mason wrote:
> On Wed, Nov 28, 2012 at 11:16:21PM -0700, Linus Torvalds wrote:
> > On Wed, Nov 28, 2012 at 6:58 PM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > But the fact that the code wants to do things like
> > >
> > >         block = (sector_t)page->index << (PAGE_CACHE_SHIFT - bbits);
> > >
> > > seriously seems to be the main thing that keeps us using
> > > 'inode->i_blkbits'. Calculating bbits from bh->b_size is just costly
> > > enough to hurt (not everywhere, but on some machines).
> > >
> > > Very annoying.
> > 
> > Hmm. Here's a patch that does that anyway. I'm not 100% happy with the
> > whole ilog2 thing, but at the same time, in other cases it actually
> > seems to improve code generation (ie gets rid of the whole unnecessary
> > two dereferences through page->mapping->host just to get the block
> > size, when we have it in the buffer-head that we have to touch
> > *anyway*).
> > 
> > Comments? Again, untested.
> 
> Jumping in based on Linus original patch, which is doing something like
> this:
> 
> set_blocksize() {
> 	block new calls to writepage, prepare/commit_write
> 	set the block size
> 	unblock
> 
> 	< --- can race in here and find bad buffers --->
> 
> 	sync_blockdev()
> 	kill_bdev() 
> 	
> 	< --- now we're safe --- >
> }
> 
> We could add a second semaphore and a page_mkwrite call:
> 
> set_blocksize() {
> 
> 	block new calls to prepare/commit_write and page_mkwrite(), but
> 	leave writepage unblocked.
> 
> 	sync_blockev()
> 
> 	<--- now we're safe.  There are no dirty pages and no ways to
> 	make new ones ---> 
> 
> 	block new calls to readpage (writepage too for good luck?)
> 
> 	kill_bdev()

Whoops, kill_bdev needs the page lock, which sends us into ABBA when
readpage does the down_read.  So, slight modification, unblock
readpage/writepage before the kill_bdev.  We'd need to change readpage
to discard buffers with the wrong size.  The risk is that readpage can
find buffers with the wrong size, and would need to be changed to
discard them.

The patch below is based on Linus' original and doesn't deal with the
readpage race.  But it does get the rest of the idea across.  It boots
and survives banging no blockdev --setbsz with mkfs, but I definitely
wouldn't trust it.

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 1a1e5e3..1377171 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -116,8 +116,6 @@ EXPORT_SYMBOL(invalidate_bdev);
 
 int set_blocksize(struct block_device *bdev, int size)
 {
-	struct address_space *mapping;
-
 	/* Size must be a power of two, and between 512 and PAGE_SIZE */
 	if (size > PAGE_SIZE || size < 512 || !is_power_of_2(size))
 		return -EINVAL;
@@ -126,28 +124,40 @@ int set_blocksize(struct block_device *bdev, int size)
 	if (size < bdev_logical_block_size(bdev))
 		return -EINVAL;
 
-	/* Prevent starting I/O or mapping the device */
-	percpu_down_write(&bdev->bd_block_size_semaphore);
-
-	/* Check that the block device is not memory mapped */
-	mapping = bdev->bd_inode->i_mapping;
-	mutex_lock(&mapping->i_mmap_mutex);
-	if (mapping_mapped(mapping)) {
-		mutex_unlock(&mapping->i_mmap_mutex);
-		percpu_up_write(&bdev->bd_block_size_semaphore);
-		return -EBUSY;
-	}
-	mutex_unlock(&mapping->i_mmap_mutex);
-
 	/* Don't change the size if it is same as current */
 	if (bdev->bd_block_size != size) {
+		/* block all modifications via writing and page_mkwrite */
+		percpu_down_write(&bdev->bd_block_size_semaphore);
+
+		/* write everything that was dirty */
 		sync_blockdev(bdev);
+
+		/* block readpage and writepage */
+		percpu_down_write(&bdev->bd_page_semaphore);
+
 		bdev->bd_block_size = size;
 		bdev->bd_inode->i_blkbits = blksize_bits(size);
+
+		/* we can't call kill_bdev with the page_semaphore down
+		 * because we'll deadlock against readpage.
+		 * The block_size_semaphore should prevent any new
+		 * pages from being dirty, but readpage can jump
+		 * in once we up the bd_page_sem and find a
+		 * page with buffers from the old size.
+		 *
+		 * The kill_bdev call below is going to get rid
+		 * of those buffers, but we do have a race here.
+		 * readpage needs to deal with it and verify
+		 * any buffers on the page are the right size
+		 */
+		percpu_up_write(&bdev->bd_page_semaphore);
+
+		/* drop all the pages and all the buffers */
 		kill_bdev(bdev);
-	}
 
-	percpu_up_write(&bdev->bd_block_size_semaphore);
+		/* open the gates and let everyone back in */
+		percpu_up_write(&bdev->bd_block_size_semaphore);
+	}
 
 	return 0;
 }
@@ -233,9 +243,14 @@ blkdev_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
+	struct block_device *bdev = I_BDEV(inode);
+	ssize_t ret;
 
-	return __blockdev_direct_IO(rw, iocb, inode, I_BDEV(inode), iov, offset,
+	percpu_down_read(&bdev->bd_block_size_semaphore);
+	ret = __blockdev_direct_IO(rw, iocb, inode, I_BDEV(inode), iov, offset,
 				    nr_segs, blkdev_get_blocks, NULL, NULL, 0);
+	percpu_up_read(&bdev->bd_block_size_semaphore);
+	return ret;
 }
 
 int __sync_blockdev(struct block_device *bdev, int wait)
@@ -358,20 +373,48 @@ EXPORT_SYMBOL(thaw_bdev);
 
 static int blkdev_writepage(struct page *page, struct writeback_control *wbc)
 {
-	return block_write_full_page(page, blkdev_get_block, wbc);
+	int ret;
+	struct inode *inode = page_mapping(page)->host;
+	struct block_device *bdev = I_BDEV(inode);
+
+	percpu_down_read(&bdev->bd_page_semaphore);
+	ret = block_write_full_page(page, blkdev_get_block, wbc);
+	percpu_up_read(&bdev->bd_page_semaphore);
+
+	return ret;
 }
 
 static int blkdev_readpage(struct file * file, struct page * page)
 {
-	return block_read_full_page(page, blkdev_get_block);
+	int ret;
+	struct inode *inode = page_mapping(page)->host;
+	struct block_device *bdev = I_BDEV(inode);
+
+	percpu_down_read(&bdev->bd_page_semaphore);
+	ret = block_read_full_page(page, blkdev_get_block);
+	percpu_up_read(&bdev->bd_page_semaphore);
+
+	return ret;
 }
 
 static int blkdev_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
 {
-	return block_write_begin(mapping, pos, len, flags, pagep,
+	int ret;
+	struct inode *inode = mapping->host;
+	struct block_device *bdev = I_BDEV(inode);
+
+	percpu_down_read(&bdev->bd_block_size_semaphore);
+	ret = block_write_begin(mapping, pos, len, flags, pagep,
 				 blkdev_get_block);
+	/*
+	 * If we had an error, we need to release the size
+	 * semaphore, because write_end() will never be called.
+	 */
+	if (ret)
+		percpu_up_read(&bdev->bd_block_size_semaphore);
+	return ret;
 }
 
 static int blkdev_write_end(struct file *file, struct address_space *mapping,
@@ -379,8 +422,11 @@ static int blkdev_write_end(struct file *file, struct address_space *mapping,
 			struct page *page, void *fsdata)
 {
 	int ret;
-	ret = block_write_end(file, mapping, pos, len, copied, page, fsdata);
+	struct inode *inode = mapping->host;
+	struct block_device *bdev = I_BDEV(inode);
 
+	ret = block_write_end(file, mapping, pos, len, copied, page, fsdata);
+	percpu_up_read(&bdev->bd_block_size_semaphore);
 	unlock_page(page);
 	page_cache_release(page);
 
@@ -464,6 +510,11 @@ static struct inode *bdev_alloc_inode(struct super_block *sb)
 		kmem_cache_free(bdev_cachep, ei);
 		return NULL;
 	}
+	if (unlikely(percpu_init_rwsem(&ei->bdev.bd_page_semaphore))) {
+		percpu_free_rwsem(&ei->bdev.bd_block_size_semaphore);
+		kmem_cache_free(bdev_cachep, ei);
+		return NULL;
+	}
 
 	return &ei->vfs_inode;
 }
@@ -474,6 +525,7 @@ static void bdev_i_callback(struct rcu_head *head)
 	struct bdev_inode *bdi = BDEV_I(inode);
 
 	percpu_free_rwsem(&bdi->bdev.bd_block_size_semaphore);
+	percpu_free_rwsem(&bdi->bdev.bd_page_semaphore);
 
 	kmem_cache_free(bdev_cachep, bdi);
 }
@@ -1596,16 +1648,7 @@ static long block_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 ssize_t blkdev_aio_read(struct kiocb *iocb, const struct iovec *iov,
 			unsigned long nr_segs, loff_t pos)
 {
-	ssize_t ret;
-	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
-
-	percpu_down_read(&bdev->bd_block_size_semaphore);
-
-	ret = generic_file_aio_read(iocb, iov, nr_segs, pos);
-
-	percpu_up_read(&bdev->bd_block_size_semaphore);
-
-	return ret;
+	return generic_file_aio_read(iocb, iov, nr_segs, pos);
 }
 EXPORT_SYMBOL_GPL(blkdev_aio_read);
 
@@ -1620,7 +1663,6 @@ ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
 			 unsigned long nr_segs, loff_t pos)
 {
 	struct file *file = iocb->ki_filp;
-	struct block_device *bdev = I_BDEV(file->f_mapping->host);
 	struct blk_plug plug;
 	ssize_t ret;
 
@@ -1628,8 +1670,6 @@ ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
 
 	blk_start_plug(&plug);
 
-	percpu_down_read(&bdev->bd_block_size_semaphore);
-
 	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
 	if (ret > 0 || ret == -EIOCBQUEUED) {
 		ssize_t err;
@@ -1639,61 +1679,42 @@ ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
 			ret = err;
 	}
 
-	percpu_up_read(&bdev->bd_block_size_semaphore);
-
 	blk_finish_plug(&plug);
 
 	return ret;
 }
 EXPORT_SYMBOL_GPL(blkdev_aio_write);
 
-static int blkdev_mmap(struct file *file, struct vm_area_struct *vma)
+int blkdev_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
+	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
+	struct block_device *bdev = I_BDEV(inode);
 	int ret;
-	struct block_device *bdev = I_BDEV(file->f_mapping->host);
 
 	percpu_down_read(&bdev->bd_block_size_semaphore);
-
-	ret = generic_file_mmap(file, vma);
-
+	ret = filemap_page_mkwrite(vma, vmf);
 	percpu_up_read(&bdev->bd_block_size_semaphore);
-
 	return ret;
 }
 
-static ssize_t blkdev_splice_read(struct file *file, loff_t *ppos,
-				  struct pipe_inode_info *pipe, size_t len,
-				  unsigned int flags)
-{
-	ssize_t ret;
-	struct block_device *bdev = I_BDEV(file->f_mapping->host);
-
-	percpu_down_read(&bdev->bd_block_size_semaphore);
-
-	ret = generic_file_splice_read(file, ppos, pipe, len, flags);
-
-	percpu_up_read(&bdev->bd_block_size_semaphore);
-
-	return ret;
-}
+static const struct vm_operations_struct blk_vm_ops = {
+	.fault          = filemap_fault,
+	.page_mkwrite   = blkdev_page_mkwrite,
+	.remap_pages	= generic_file_remap_pages,
+};
 
-static ssize_t blkdev_splice_write(struct pipe_inode_info *pipe,
-				   struct file *file, loff_t *ppos, size_t len,
-				   unsigned int flags)
+static int blkdev_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	ssize_t ret;
-	struct block_device *bdev = I_BDEV(file->f_mapping->host);
-
-	percpu_down_read(&bdev->bd_block_size_semaphore);
+	struct address_space *mapping = file->f_mapping;
 
-	ret = generic_file_splice_write(pipe, file, ppos, len, flags);
-
-	percpu_up_read(&bdev->bd_block_size_semaphore);
+	if (!mapping->a_ops->readpage)
+		return -ENOEXEC;
 
-	return ret;
+	file_accessed(file);
+	vma->vm_ops = &blk_vm_ops;
+	return 0;
 }
 
-
 /*
  * Try to release a page associated with block device when the system
  * is under memory pressure.
@@ -1708,6 +1729,8 @@ static int blkdev_releasepage(struct page *page, gfp_t wait)
 	return try_to_free_buffers(page);
 }
 
+
+
 static const struct address_space_operations def_blk_aops = {
 	.readpage	= blkdev_readpage,
 	.writepage	= blkdev_writepage,
@@ -1732,8 +1755,8 @@ const struct file_operations def_blk_fops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= compat_blkdev_ioctl,
 #endif
-	.splice_read	= blkdev_splice_read,
-	.splice_write	= blkdev_splice_write,
+	.splice_read	= generic_file_splice_read,
+	.splice_write	= generic_file_splice_write,
 };
 
 int ioctl_by_bdev(struct block_device *bdev, unsigned cmd, unsigned long arg)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b33cfc9..4f0043d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -463,6 +463,7 @@ struct block_device {
 	/* Mutex for freeze */
 	struct mutex		bd_fsfreeze_mutex;
 	/* A semaphore that prevents I/O while block size is being changed */
+	struct percpu_rw_semaphore	bd_page_semaphore;
 	struct percpu_rw_semaphore	bd_block_size_semaphore;
 };
 

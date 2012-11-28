Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab2K1WCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 17:02:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755673Ab2K1WCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 17:02:42 -0500
Date: Wed, 28 Nov 2012 17:01:50 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v2] Do a proper locking for mmap and block size change
In-Reply-To: <20121128194314.GF4939@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.1211281630150.5283@file.rdu.redhat.com>
References: <CAAJw_ZvUqRmCCQ5-2PdFPRyfdzZMuphGU=hgAjUOHGk=n9Mheg@mail.gmail.com>
 <CAAJw_ZuJXnAz1ukBwQa3xNbQaL1KUBSrbQMK2hn-7D6Ar1p3fQ@mail.gmail.com>
 <50B46E05.70906@kernel.dk> <CAAJw_ZsYuLCwCTc6U=ELO_PvyjnVKQdkPke2enfzm6zOeWAqjA@mail.gmail.com>
 <50B4B313.3030707@kernel.dk> <Pine.LNX.4.64.1211272252260.18338@file.rdu.redhat.com>
 <50B5CC5A.8060607@kernel.dk> <Pine.LNX.4.64.1211281222410.11599@file.rdu.redhat.com>
 <CA+55aFx4zYnEsUyGJurBjB0XZ0AgmyKqW-+KWVDvma3w6csnHQ@mail.gmail.com>
 <20121128194314.GF4939@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 28 Nov 2012, Al Viro wrote:

> On Wed, Nov 28, 2012 at 11:15:12AM -0800, Linus Torvalds wrote:
> > No, this is crap.
> > 
> > We don't introduce random hooks like this just because the block layer
> > has shit-for-brains and cannot be bothered to do things right.
> > 
> > The fact is, the whole locking in the block layer open routine is
> > total and utter crap. It doesn't lock the right thing, even with your
> > change *anyway* (or with the change Jens had). Absolutely nothing in
> > "mmap_region()" cares at all about the block-size anywhere - it's
> > generic, after all - so locking around it is f*cking pointless. There
> > is no way in hell that the caller of ->mmap can *ever* care about the
> > block size, since it never even looks at it.
> > 
> > Don't do random crap like this.
> > 
> > Why does the code think that mmap matters so much anyway? As you say,
> > the mmap itself does *nothing*. It has no impact for the block size.
> 
> ... and here I was, trying to massage a reply into form that would be
> at least borderline printable...  Anyway, this is certainly the wrong
> way to go.  We want to catch if the damn thing is mapped and mapping_mapped()
> leaves a race?  Fine, so let's not use mapping_mapped() at all.  Have a
> private vm_operations - a copy of generic_file_vm_ops with ->open()/->close()
> added to it.  Incrementing/decrementing a per-block_device atomic counter,
> with increment side done under your rwsem, to make sure that 0->positive
> transition doesn't change in critical section of set_blocksize().  And don't
> use generic_file_mmap(), just do file_accessed() and set ->vm_ops to that
> local copy.

This sounds sensible. I'm sending this patch.

Mikulas

---

Do a proper locking for mmap and block size change

For block devices, we must prevent the device from being mapped while
block size is being changed.

This was implemented by catching the mmap method and taking
bd_block_size_semaphore in it.

The problem is that the generic_file_mmap method does almost nothing, it
only sets vma->vm_ops = &generic_file_vm_ops, all the hard work is done
by the caller, mmap_region. Consequently, locking the mmap method is
insufficient, to prevent the race condition. The race condition can
happen for example this way:

process 1:
Starts mapping a block device, it goes to mmap_region, calls
file->f_op->mmap (blkdev_mmap - that acquires and releases
bd_block_size_semaphore), and reschedule happens just after blkdev_mmap
returns.

process 2:
Changes block device size, goes into set_blocksize, acquires
percpu_down_write, calls mapping_mapped to test if the device is mapped
(it still isn't). Then, it reschedules.

process 1:
Continues in mmap_region, successfully finishes the mapping.

process 2:
Continues in set_blocksize, changes the block size while the block
device is mapped. (which is incorrect and may result in a crash or
misbehavior).

To fix this possible race condition, we introduce a counter
bd_mmap_count that counts the number of vmas that maps the block device.
bd_mmap_count is incremented in blkdev_mmap and in blkdev_vm_open, it is
decremented in blkdev_vm_close. We don't allow changing block size while
bd_mmap_count is non-zero.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 fs/block_dev.c     |   49 ++++++++++++++++++++++++++++++++-----------------
 include/linux/fs.h |    3 +++
 2 files changed, 35 insertions(+), 17 deletions(-)

Index: linux-3.7-rc7/fs/block_dev.c
===================================================================
--- linux-3.7-rc7.orig/fs/block_dev.c	2012-11-28 21:13:12.000000000 +0100
+++ linux-3.7-rc7/fs/block_dev.c	2012-11-28 21:33:23.000000000 +0100
@@ -35,6 +35,7 @@ struct bdev_inode {
 	struct inode vfs_inode;
 };
 
+static const struct vm_operations_struct def_blk_vm_ops;
 static const struct address_space_operations def_blk_aops;
 
 static inline struct bdev_inode *BDEV_I(struct inode *inode)
@@ -114,16 +115,6 @@ void invalidate_bdev(struct block_device
 }
 EXPORT_SYMBOL(invalidate_bdev);
 
-static int is_bdev_mapped(struct block_device *bdev)
-{
-	int ret_val;
-	struct address_space *mapping = bdev->bd_inode->i_mapping;
-	mutex_lock(&mapping->i_mmap_mutex);
-	ret_val = mapping_mapped(mapping);
-	mutex_unlock(&mapping->i_mmap_mutex);
-	return ret_val;
-}
-
 int set_blocksize(struct block_device *bdev, int size)
 {
 	/* Size must be a power of two, and between 512 and PAGE_SIZE */
@@ -136,16 +127,16 @@ int set_blocksize(struct block_device *b
 
 	/*
 	 * If the block size doesn't change, don't take the write lock.
-	 * We check for is_bdev_mapped anyway, for consistent behavior.
+	 * We check for bd_mmap_count anyway, for consistent behavior.
 	 */
 	if (size == bdev->bd_block_size)
-		return is_bdev_mapped(bdev) ? -EBUSY : 0;
+		return atomic_read(&bdev->bd_mmap_count) ? -EBUSY : 0;
 
 	/* Prevent starting I/O or mapping the device */
 	percpu_down_write(&bdev->bd_block_size_semaphore);
 
 	/* Check that the block device is not memory mapped */
-	if (is_bdev_mapped(bdev)) {
+	if (atomic_read(&bdev->bd_mmap_count)) {
 		percpu_up_write(&bdev->bd_block_size_semaphore);
 		return -EBUSY;
 	}
@@ -491,6 +482,7 @@ static void bdev_i_callback(struct rcu_h
 
 static void bdev_destroy_inode(struct inode *inode)
 {
+	BUG_ON(atomic_read(&I_BDEV(inode)->bd_mmap_count));
 	call_rcu(&inode->i_rcu, bdev_i_callback);
 }
 
@@ -507,6 +499,7 @@ static void init_once(void *foo)
 	INIT_LIST_HEAD(&bdev->bd_holder_disks);
 #endif
 	inode_init_once(&ei->vfs_inode);
+	atomic_set(&bdev->bd_mmap_count, 0);
 	/* Initialize mutex for freeze. */
 	mutex_init(&bdev->bd_fsfreeze_mutex);
 }
@@ -1660,16 +1653,28 @@ EXPORT_SYMBOL_GPL(blkdev_aio_write);
 
 static int blkdev_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	int ret;
 	struct block_device *bdev = I_BDEV(file->f_mapping->host);
 
+	file_accessed(file);
+	vma->vm_ops = &def_blk_vm_ops;
+
 	percpu_down_read(&bdev->bd_block_size_semaphore);
+	atomic_inc(&bdev->bd_mmap_count);
+	percpu_up_read(&bdev->bd_block_size_semaphore);
 
-	ret = generic_file_mmap(file, vma);
+	return 0;
+}
 
-	percpu_up_read(&bdev->bd_block_size_semaphore);
+static void blkdev_vm_open(struct vm_area_struct *area)
+{
+	struct block_device *bdev = I_BDEV(area->vm_file->f_mapping->host);
+	atomic_inc(&bdev->bd_mmap_count);
+}
 
-	return ret;
+static void blkdev_vm_close(struct vm_area_struct *area)
+{
+	struct block_device *bdev = I_BDEV(area->vm_file->f_mapping->host);
+	atomic_dec(&bdev->bd_mmap_count);
 }
 
 static ssize_t blkdev_splice_read(struct file *file, loff_t *ppos,
@@ -1719,6 +1724,16 @@ static int blkdev_releasepage(struct pag
 	return try_to_free_buffers(page);
 }
 
+static const struct vm_operations_struct def_blk_vm_ops = {
+	.open		= blkdev_vm_open,
+	.close		= blkdev_vm_close,
+#ifdef CONFIG_MMU
+	.fault		= filemap_fault,
+	.page_mkwrite	= filemap_page_mkwrite,
+	.remap_pages	= generic_file_remap_pages,
+#endif
+};
+
 static const struct address_space_operations def_blk_aops = {
 	.readpage	= blkdev_readpage,
 	.writepage	= blkdev_writepage,
Index: linux-3.7-rc7/include/linux/fs.h
===================================================================
--- linux-3.7-rc7.orig/include/linux/fs.h	2012-11-28 21:15:42.000000000 +0100
+++ linux-3.7-rc7/include/linux/fs.h	2012-11-28 21:17:59.000000000 +0100
@@ -458,6 +458,9 @@ struct block_device {
 	 */
 	unsigned long		bd_private;
 
+	/* The number of vmas */
+	atomic_t		bd_mmap_count;
+
 	/* The counter of freeze processes */
 	int			bd_fsfreeze_count;
 	/* Mutex for freeze */

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab2K1R0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:26:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008Ab2K1R0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:26:34 -0500
Date: Wed, 28 Nov 2012 12:25:43 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Jens Axboe <axboe@kernel.dk>
cc: Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH] Introduce a method to catch mmap_region (was: Recent kernel
 "mount" slow)
In-Reply-To: <50B5CC5A.8060607@kernel.dk>
Message-ID: <Pine.LNX.4.64.1211281222410.11599@file.rdu.redhat.com>
References: <CAAJw_ZtbhE5Jtd4PsWx8a23QdFTW7aMrKBmRf-bo5Wrean9Xhg@mail.gmail.com>
 <20121120180949.GG1408@quack.suse.cz> <CAAJw_ZsQdLO5qLdGPzmPf+N2D6CZw+S-4mvRGnxfARL71LuRaw@mail.gmail.com>
 <CAAJw_ZsAyB0z0TF1mqPz1Z+H+tg7W6LVzNLKf0BkuF3u8TTMuQ@mail.gmail.com>
 <CA+55aFyvT3R3kgwJzp9mY5eE1fwMnzXnmBpHSbqjd-eJRVDkJw@mail.gmail.com>
 <50AF7901.20401@kernel.dk> <CAAJw_ZvXGKcjfOAS_tRdXJ9SjpCKw1t7rNt+Q=ieCkVJwN2qcg@mail.gmail.com>
 <Pine.LNX.4.64.1211241555470.4300@file.rdu.redhat.com>
 <CAAJw_ZvUqRmCCQ5-2PdFPRyfdzZMuphGU=hgAjUOHGk=n9Mheg@mail.gmail.com>
 <CAAJw_ZuJXnAz1ukBwQa3xNbQaL1KUBSrbQMK2hn-7D6Ar1p3fQ@mail.gmail.com>
 <50B46E05.70906@kernel.dk> <CAAJw_ZsYuLCwCTc6U=ELO_PvyjnVKQdkPke2enfzm6zOeWAqjA@mail.gmail.com>
 <50B4B313.3030707@kernel.dk> <Pine.LNX.4.64.1211272252260.18338@file.rdu.redhat.com>
 <50B5CC5A.8060607@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 28 Nov 2012, Jens Axboe wrote:

> On 2012-11-28 04:57, Mikulas Patocka wrote:
> > 
> > This patch is wrong because you must check if the device is mapped while 
> > holding bdev->bd_block_size_semaphore (because 
> > bdev->bd_block_size_semaphore prevents new mappings from being created)
> 
> No it doesn't. If you read the patch, that was moved to i_mmap_mutex.

Hmm, it was wrong before the patch and it is wrong after the patch too.

The problem is that ->mmap method doesn't do the actual mapping, the 
caller of ->mmap (mmap_region) does it. So we must actually catch 
mmap_region and protect it with the lock, not ->mmap.

Mikulas

---

Introduce a method to catch mmap_region

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

To fix this possible race condition, we need to catch the function that
does real mapping - mmap_region. This patch adds a new method,
file_operations->mmap_region. mmap_region calls the method
file_operations->mmap_region if it is non-NULL, otherwise, it calls
generic_mmap_region.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 fs/block_dev.c     |   12 ++++++++----
 include/linux/fs.h |    4 ++++
 include/linux/mm.h |    3 +++
 mm/mmap.c          |   10 ++++++++++
 4 files changed, 25 insertions(+), 4 deletions(-)

Index: linux-3.7-rc7/include/linux/fs.h
===================================================================
--- linux-3.7-rc7.orig/include/linux/fs.h	2012-11-28 17:45:55.000000000 +0100
+++ linux-3.7-rc7/include/linux/fs.h	2012-11-28 18:02:45.000000000 +0100
@@ -27,6 +27,7 @@
 #include <linux/lockdep.h>
 #include <linux/percpu-rwsem.h>
 #include <linux/blk_types.h>
+#include <linux/mm_types.h>
 
 #include <asm/byteorder.h>
 #include <uapi/linux/fs.h>
@@ -1528,6 +1529,9 @@ struct file_operations {
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
+	unsigned long (*mmap_region)(struct file *, unsigned long,
+				     unsigned long, unsigned long, vm_flags_t,
+				     unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
 	int (*open) (struct inode *, struct file *);
 	int (*flush) (struct file *, fl_owner_t id);
Index: linux-3.7-rc7/include/linux/mm.h
===================================================================
--- linux-3.7-rc7.orig/include/linux/mm.h	2012-11-28 17:45:55.000000000 +0100
+++ linux-3.7-rc7/include/linux/mm.h	2012-11-28 17:47:12.000000000 +0100
@@ -1444,6 +1444,9 @@ extern unsigned long get_unmapped_area(s
 extern unsigned long mmap_region(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long flags,
 	vm_flags_t vm_flags, unsigned long pgoff);
+extern unsigned long generic_mmap_region(struct file *file, unsigned long addr,
+	unsigned long len, unsigned long flags,
+	vm_flags_t vm_flags, unsigned long pgoff);
 extern unsigned long do_mmap_pgoff(struct file *, unsigned long,
         unsigned long, unsigned long,
         unsigned long, unsigned long);
Index: linux-3.7-rc7/mm/mmap.c
===================================================================
--- linux-3.7-rc7.orig/mm/mmap.c	2012-11-28 17:45:55.000000000 +0100
+++ linux-3.7-rc7/mm/mmap.c	2012-11-28 17:57:40.000000000 +0100
@@ -1244,6 +1244,16 @@ unsigned long mmap_region(struct file *f
 			  unsigned long len, unsigned long flags,
 			  vm_flags_t vm_flags, unsigned long pgoff)
 {
+	if (file && file->f_op->mmap_region)
+		return file->f_op->mmap_region(file, addr, len, flags, vm_flags,
+					       pgoff);
+	return generic_mmap_region(file, addr, len, flags, vm_flags, pgoff);
+}
+
+unsigned long generic_mmap_region(struct file *file, unsigned long addr,
+				  unsigned long len, unsigned long flags,
+				  vm_flags_t vm_flags, unsigned long pgoff)
+{
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev;
 	int correct_wcount = 0;
Index: linux-3.7-rc7/fs/block_dev.c
===================================================================
--- linux-3.7-rc7.orig/fs/block_dev.c	2012-11-28 17:45:56.000000000 +0100
+++ linux-3.7-rc7/fs/block_dev.c	2012-11-28 17:47:12.000000000 +0100
@@ -1658,14 +1658,17 @@ ssize_t blkdev_aio_write(struct kiocb *i
 }
 EXPORT_SYMBOL_GPL(blkdev_aio_write);
 
-static int blkdev_mmap(struct file *file, struct vm_area_struct *vma)
+static unsigned long blkdev_mmap_region(struct file *file, unsigned long addr,
+					unsigned long len, unsigned long flags,
+					vm_flags_t vm_flags,
+					unsigned long pgoff)
 {
-	int ret;
+	unsigned long ret;
 	struct block_device *bdev = I_BDEV(file->f_mapping->host);
 
 	percpu_down_read(&bdev->bd_block_size_semaphore);
 
-	ret = generic_file_mmap(file, vma);
+	ret = generic_mmap_region(file, addr, len, flags, vm_flags, pgoff);
 
 	percpu_up_read(&bdev->bd_block_size_semaphore);
 
@@ -1737,7 +1740,8 @@ const struct file_operations def_blk_fop
 	.write		= do_sync_write,
   	.aio_read	= blkdev_aio_read,
 	.aio_write	= blkdev_aio_write,
-	.mmap		= blkdev_mmap,
+	.mmap_region	= blkdev_mmap_region,
+	.mmap		= generic_file_mmap,
 	.fsync		= blkdev_fsync,
 	.unlocked_ioctl	= block_ioctl,
 #ifdef CONFIG_COMPAT

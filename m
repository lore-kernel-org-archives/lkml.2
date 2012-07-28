Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab2G1Qmq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 12:42:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829Ab2G1Qmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 12:42:44 -0400
Date: Sat, 28 Jul 2012 12:42:34 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, "Alasdair G. Kergon" <agk@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dm-devel@redhat.com, lwoodman@redhat.com,
        Andrea Arcangeli <aarcange@redhat.com>, kosaki.motohiro@jp.fujitsu.com
Subject: [PATCH 3/3] blockdev: turn a rw semaphore into a percpu rw semaphore
In-Reply-To: <Pine.LNX.4.64.1207281240270.30415@file.rdu.redhat.com>
Message-ID: <Pine.LNX.4.64.1207281242000.30415@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com>
 <20120628111541.GB17515@quack.suse.cz> <Pine.LNX.4.64.1207152051490.4240@file.rdu.redhat.com>
 <x49ipdmyz4q.fsf@segfault.boston.devel.redhat.com>
 <Pine.LNX.4.64.1207181512530.10923@file.rdu.redhat.com>
 <x49k3xzq3jc.fsf@segfault.boston.devel.redhat.com>
 <Pine.LNX.4.64.1207281236230.30415@file.rdu.redhat.com>
 <Pine.LNX.4.64.1207281240270.30415@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blockdev: turn a rw semaphore into a percpu rw semaphore

This avoids cache line bouncing when many processes lock the semaphore
for read.

Partially based on a patch by Jeff Moyer <jmoyer@redhat.com>.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 fs/block_dev.c     |   30 ++++++++++++++++++++----------
 include/linux/fs.h |    3 ++-
 2 files changed, 22 insertions(+), 11 deletions(-)

Index: linux-3.5-fast/fs/block_dev.c
===================================================================
--- linux-3.5-fast.orig/fs/block_dev.c	2012-07-28 18:32:10.000000000 +0200
+++ linux-3.5-fast/fs/block_dev.c	2012-07-28 18:32:12.000000000 +0200
@@ -127,7 +127,7 @@ int set_blocksize(struct block_device *b
 		return -EINVAL;
 
 	/* Prevent starting I/O or mapping the device */
-	down_write(&bdev->bd_block_size_semaphore);
+	percpu_down_write(&bdev->bd_block_size_semaphore);
 
 	/* Check that the block device is not memory mapped */
 	mapping = bdev->bd_inode->i_mapping;
@@ -135,7 +135,7 @@ int set_blocksize(struct block_device *b
 	if (!prio_tree_empty(&mapping->i_mmap) ||
 	    !list_empty(&mapping->i_mmap_nonlinear)) {
 		mutex_unlock(&mapping->i_mmap_mutex);
-		up_write(&bdev->bd_block_size_semaphore);
+		percpu_up_write(&bdev->bd_block_size_semaphore);
 		return -EBUSY;
 	}
 	mutex_unlock(&mapping->i_mmap_mutex);
@@ -148,7 +148,7 @@ int set_blocksize(struct block_device *b
 		kill_bdev(bdev);
 	}
 
-	up_write(&bdev->bd_block_size_semaphore);
+	percpu_up_write(&bdev->bd_block_size_semaphore);
 
 	return 0;
 }
@@ -460,6 +460,12 @@ static struct inode *bdev_alloc_inode(st
 	struct bdev_inode *ei = kmem_cache_alloc(bdev_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
+
+	if (unlikely(percpu_init_rwsem(&ei->bdev.bd_block_size_semaphore))) {
+		kmem_cache_free(bdev_cachep, ei);
+		return NULL;
+	}
+
 	return &ei->vfs_inode;
 }
 
@@ -468,6 +474,8 @@ static void bdev_i_callback(struct rcu_h
 	struct inode *inode = container_of(head, struct inode, i_rcu);
 	struct bdev_inode *bdi = BDEV_I(inode);
 
+	percpu_free_rwsem(&bdi->bdev.bd_block_size_semaphore);
+
 	kmem_cache_free(bdev_cachep, bdi);
 }
 
@@ -491,7 +499,6 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 	/* Initialize mutex for freeze. */
 	mutex_init(&bdev->bd_fsfreeze_mutex);
-	init_rwsem(&bdev->bd_block_size_semaphore);
 }
 
 static inline void __bd_forget(struct inode *inode)
@@ -1592,12 +1599,13 @@ ssize_t blkdev_aio_read(struct kiocb *io
 {
 	ssize_t ret;
 	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
+	percpu_rwsem_ptr p;
 
-	down_read(&bdev->bd_block_size_semaphore);
+	p = percpu_down_read(&bdev->bd_block_size_semaphore);
 
 	ret = generic_file_aio_read(iocb, iov, nr_segs, pos);
 
-	up_read(&bdev->bd_block_size_semaphore);
+	percpu_up_read(&bdev->bd_block_size_semaphore, p);
 
 	return ret;
 }
@@ -1616,10 +1624,11 @@ ssize_t blkdev_aio_write(struct kiocb *i
 	struct file *file = iocb->ki_filp;
 	struct block_device *bdev = I_BDEV(file->f_mapping->host);
 	ssize_t ret;
+	percpu_rwsem_ptr p;
 
 	BUG_ON(iocb->ki_pos != pos);
 
-	down_read(&bdev->bd_block_size_semaphore);
+	p = percpu_down_read(&bdev->bd_block_size_semaphore);
 
 	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
 	if (ret > 0 || ret == -EIOCBQUEUED) {
@@ -1630,7 +1639,7 @@ ssize_t blkdev_aio_write(struct kiocb *i
 			ret = err;
 	}
 
-	up_read(&bdev->bd_block_size_semaphore);
+	percpu_up_read(&bdev->bd_block_size_semaphore, p);
 
 	return ret;
 }
@@ -1640,12 +1649,13 @@ int blkdev_mmap(struct file *file, struc
 {
 	int ret;
 	struct block_device *bdev = I_BDEV(file->f_mapping->host);
+	percpu_rwsem_ptr p;
 
-	down_read(&bdev->bd_block_size_semaphore);
+	p = percpu_down_read(&bdev->bd_block_size_semaphore);
 
 	ret = generic_file_mmap(file, vma);
 
-	up_read(&bdev->bd_block_size_semaphore);
+	percpu_up_read(&bdev->bd_block_size_semaphore, p);
 
 	return ret;
 }
Index: linux-3.5-fast/include/linux/fs.h
===================================================================
--- linux-3.5-fast.orig/include/linux/fs.h	2012-07-28 18:32:10.000000000 +0200
+++ linux-3.5-fast/include/linux/fs.h	2012-07-28 18:32:12.000000000 +0200
@@ -10,6 +10,7 @@
 #include <linux/ioctl.h>
 #include <linux/blk_types.h>
 #include <linux/types.h>
+#include <linux/percpu-rwsem.h>
 
 /*
  * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
@@ -714,7 +715,7 @@ struct block_device {
 	/* Mutex for freeze */
 	struct mutex		bd_fsfreeze_mutex;
 	/* A semaphore that prevents I/O while block size is being changed */
-	struct rw_semaphore	bd_block_size_semaphore;
+	struct percpu_rw_semaphore	bd_block_size_semaphore;
 };
 
 /*


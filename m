Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab2HaSnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 14:43:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620Ab2HaSnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 14:43:21 -0400
Date: Fri, 31 Aug 2012 14:43:10 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Jens Axboe <axboe@kernel.dk>, Andrea Arcangeli <aarcange@redhat.com>,
        Jan Kara <jack@suse.cz>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org,
        lwoodman@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
Subject: [PATCH 3/4] blockdev: turn a rw semaphore into a percpu rw semaphore
In-Reply-To: <Pine.LNX.4.64.1208311441210.2212@file.rdu.redhat.com>
Message-ID: <Pine.LNX.4.64.1208311442190.2212@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com> 
 <20120628111541.GB17515@quack.suse.cz>  <Pine.LNX.4.64.1207152051490.4240@file.rdu.redhat.com>
  <x49ipdmyz4q.fsf@segfault.boston.devel.redhat.com> 
 <Pine.LNX.4.64.1207181512530.10923@file.rdu.redhat.com> 
 <x49k3xzq3jc.fsf@segfault.boston.devel.redhat.com> 
 <Pine.LNX.4.64.1207281236230.30415@file.rdu.redhat.com> 
 <Pine.LNX.4.64.1207281240270.30415@file.rdu.redhat.com> 
 <1343508252.2626.13184.camel@edumazet-glaptop> 
 <Pine.LNX.4.64.1207290107460.29910@file.rdu.redhat.com> 
 <1343556630.2626.13257.camel@edumazet-glaptop> <1343586962.2626.13266.camel@edumazet-glaptop>
 <Pine.LNX.4.64.1208011601280.21832@file.rdu.redhat.com>
 <Pine.LNX.4.64.1208311433480.2212@file.rdu.redhat.com>
 <Pine.LNX.4.64.1208311440350.2212@file.rdu.redhat.com>
 <Pine.LNX.4.64.1208311441210.2212@file.rdu.redhat.com>
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
Introduce percpu rw semaphores

When many CPUs are locking a rw semaphore for read concurrently, cache
line bouncing occurs. When a CPU acquires rw semaphore for read, the
CPU writes to the cache line holding the semaphore. Consequently, the
cache line is being moved between CPUs and this slows down semaphore
acquisition.

This patch introduces new percpu rw semaphores. They are functionally
identical to existing rw semaphores, but locking the percpu rw semaphore
for read is faster and locking for write is slower.

The percpu rw semaphore is implemented as a percpu array of rw
semaphores, each semaphore for one CPU. When some thread needs to lock
the semaphore for read, only semaphore on the current CPU is locked for
read. When some thread needs to lock the semaphore for write, semaphores
for all CPUs are locked for write. This avoids cache line bouncing.

Note that the thread that is locking percpu rw semaphore may be
rescheduled, it doesn't cause bug, but cache line bouncing occurs in
this case.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 include/linux/percpu-rwsem.h |   77 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

Index: linux-3.5-fast/include/linux/percpu-rwsem.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-3.5-fast/include/linux/percpu-rwsem.h	2012-07-28 18:41:05.000000000 +0200
@@ -0,0 +1,77 @@
+#ifndef _LINUX_PERCPU_RWSEM_H
+#define _LINUX_PERCPU_RWSEM_H
+
+#include <linux/rwsem.h>
+#include <linux/percpu.h>
+
+#ifndef CONFIG_SMP
+
+#define percpu_rw_semaphore	rw_semaphore
+#define percpu_rwsem_ptr	int
+#define percpu_down_read(x)	(down_read(x), 0)
+#define percpu_up_read(x, y)	up_read(x)
+#define percpu_down_write	down_write
+#define percpu_up_write		up_write
+#define percpu_init_rwsem(x)	(({init_rwsem(x);}), 0)
+#define percpu_free_rwsem(x)	do { } while (0)
+
+#else
+
+struct percpu_rw_semaphore {
+	struct rw_semaphore __percpu *s;
+};
+
+typedef struct rw_semaphore *percpu_rwsem_ptr;
+
+static inline percpu_rwsem_ptr percpu_down_read(struct percpu_rw_semaphore *sem)
+{
+	struct rw_semaphore *s = __this_cpu_ptr(sem->s);
+	down_read(s);
+	return s;
+}
+
+static inline void percpu_up_read(struct percpu_rw_semaphore *sem, percpu_rwsem_ptr s)
+{
+	up_read(s);
+}
+
+static inline void percpu_down_write(struct percpu_rw_semaphore *sem)
+{
+	int cpu;
+	for_each_possible_cpu(cpu) {
+		struct rw_semaphore *s = per_cpu_ptr(sem->s, cpu);
+		down_write(s);
+	}
+}
+
+static inline void percpu_up_write(struct percpu_rw_semaphore *sem)
+{
+	int cpu;
+	for_each_possible_cpu(cpu) {
+		struct rw_semaphore *s = per_cpu_ptr(sem->s, cpu);
+		up_write(s);
+	}
+}
+
+static inline int percpu_init_rwsem(struct percpu_rw_semaphore *sem)
+{
+	int cpu;
+	sem->s = alloc_percpu(struct rw_semaphore);
+	if (unlikely(!sem->s))
+		return -ENOMEM;
+	for_each_possible_cpu(cpu) {
+		struct rw_semaphore *s = per_cpu_ptr(sem->s, cpu);
+		init_rwsem(s);
+	}
+	return 0;
+}
+
+static inline void percpu_free_rwsem(struct percpu_rw_semaphore *sem)
+{
+	free_percpu(sem->s);
+	sem->s = NULL;		/* catch use after free bugs */
+}
+
+#endif
+
+#endif


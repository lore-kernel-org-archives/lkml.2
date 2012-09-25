Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab2IYWuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 18:50:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab2IYWuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 18:50:20 -0400
Date: Tue, 25 Sep 2012 18:50:00 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Jens Axboe <axboe@kernel.dk>
cc: Jeff Moyer <jmoyer@redhat.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org,
        lwoodman@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
Subject: [PATCH 2/2] Fix a crash when block device is read and block size is
 changed at the same time
In-Reply-To: <5061F3D2.6050502@kernel.dk>
Message-ID: <Pine.LNX.4.64.1209251849310.21075@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com>
 <Pine.LNX.4.64.1207181512530.10923@file.rdu.redhat.com>
 <x49k3xzq3jc.fsf@segfault.boston.devel.redhat.com>
 <Pine.LNX.4.64.1207281236230.30415@file.rdu.redhat.com>
 <Pine.LNX.4.64.1207281240270.30415@file.rdu.redhat.com>
 <1343508252.2626.13184.camel@edumazet-glaptop>
 <Pine.LNX.4.64.1207290107460.29910@file.rdu.redhat.com>
 <1343556630.2626.13257.camel@edumazet-glaptop> <1343586962.2626.13266.camel@edumazet-glaptop>
 <Pine.LNX.4.64.1208011601280.21832@file.rdu.redhat.com>
 <Pine.LNX.4.64.1208311433480.2212@file.rdu.redhat.com>
 <Pine.LNX.4.64.1208311518340.16960@file.rdu.redhat.com>
 <x49liguyg6r.fsf@segfault.boston.devel.redhat.com>
 <x49wqzswdn3.fsf@segfault.boston.devel.redhat.com>
 <Pine.LNX.4.64.1209181257410.11735@file.rdu.redhat.com>
 <x49ehlzrt01.fsf@segfault.boston.devel.redhat.com>
 <x49sja6ouv4.fsf@segfault.boston.devel.redhat.com> <5061F0E6.5000403@kernel.dk>
 <5061F3D2.6050502@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blockdev: turn a rw semaphore into a percpu rw semaphore

This avoids cache line bouncing when many processes lock the semaphore
for read.

New percpu lock implementation

The lock consists of an array of percpu unsigned integers, a boolean
variable and a mutex.

When we take the lock for read, we enter rcu read section, check for a
"locked" variable. If it is false, we increase a percpu counter on the
current cpu and exit the rcu section. If "locked" is true, we exit the
rcu section, take the mutex and drop it (this waits until a writer
finished) and retry.

Unlocking for read just decreases percpu variable. Note that we can
unlock on a difference cpu than where we locked, in this case the
counter underflows. The sum of all percpu counters represents the number
of processes that hold the lock for read.

When we need to lock for write, we take the mutex, set "locked" variable
to true and synchronize rcu. Since RCU has been synchronized, no
processes can create new read locks. We wait until the sum of percpu
counters is zero - when it is, there are no readers in the critical
section.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 Documentation/percpu-rw-semaphore.txt |   27 ++++++++++
 fs/block_dev.c                        |   27 ++++++----
 include/linux/fs.h                    |    3 -
 include/linux/percpu-rwsem.h          |   89 ++++++++++++++++++++++++++++++++++
 4 files changed, 135 insertions(+), 11 deletions(-)

---

Index: linux-2.6-copy/fs/block_dev.c
===================================================================
--- linux-2.6-copy.orig/fs/block_dev.c	2012-09-26 00:42:49.000000000 +0200
+++ linux-2.6-copy/fs/block_dev.c	2012-09-26 00:45:29.000000000 +0200
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
@@ -1593,11 +1600,11 @@ ssize_t blkdev_aio_read(struct kiocb *io
 	ssize_t ret;
 	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
 
-	down_read(&bdev->bd_block_size_semaphore);
+	percpu_down_read(&bdev->bd_block_size_semaphore);
 
 	ret = generic_file_aio_read(iocb, iov, nr_segs, pos);
 
-	up_read(&bdev->bd_block_size_semaphore);
+	percpu_up_read(&bdev->bd_block_size_semaphore);
 
 	return ret;
 }
@@ -1622,7 +1629,7 @@ ssize_t blkdev_aio_write(struct kiocb *i
 
 	blk_start_plug(&plug);
 
-	down_read(&bdev->bd_block_size_semaphore);
+	percpu_down_read(&bdev->bd_block_size_semaphore);
 
 	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
 	if (ret > 0 || ret == -EIOCBQUEUED) {
@@ -1633,7 +1640,7 @@ ssize_t blkdev_aio_write(struct kiocb *i
 			ret = err;
 	}
 
-	up_read(&bdev->bd_block_size_semaphore);
+	percpu_up_read(&bdev->bd_block_size_semaphore);
 
 	blk_finish_plug(&plug);
 
@@ -1646,11 +1653,11 @@ int blkdev_mmap(struct file *file, struc
 	int ret;
 	struct block_device *bdev = I_BDEV(file->f_mapping->host);
 
-	down_read(&bdev->bd_block_size_semaphore);
+	percpu_down_read(&bdev->bd_block_size_semaphore);
 
 	ret = generic_file_mmap(file, vma);
 
-	up_read(&bdev->bd_block_size_semaphore);
+	percpu_up_read(&bdev->bd_block_size_semaphore);
 
 	return ret;
 }
Index: linux-2.6-copy/include/linux/fs.h
===================================================================
--- linux-2.6-copy.orig/include/linux/fs.h	2012-09-26 00:41:07.000000000 +0200
+++ linux-2.6-copy/include/linux/fs.h	2012-09-26 00:45:29.000000000 +0200
@@ -10,6 +10,7 @@
 #include <linux/ioctl.h>
 #include <linux/blk_types.h>
 #include <linux/types.h>
+#include <linux/percpu-rwsem.h>
 
 /*
  * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
@@ -725,7 +726,7 @@ struct block_device {
 	/* Mutex for freeze */
 	struct mutex		bd_fsfreeze_mutex;
 	/* A semaphore that prevents I/O while block size is being changed */
-	struct rw_semaphore	bd_block_size_semaphore;
+	struct percpu_rw_semaphore	bd_block_size_semaphore;
 };
 
 /*
Index: linux-2.6-copy/include/linux/percpu-rwsem.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-copy/include/linux/percpu-rwsem.h	2012-09-26 00:45:29.000000000 +0200
@@ -0,0 +1,89 @@
+#ifndef _LINUX_PERCPU_RWSEM_H
+#define _LINUX_PERCPU_RWSEM_H
+
+#include <linux/mutex.h>
+#include <linux/percpu.h>
+#include <linux/rcupdate.h>
+#include <linux/delay.h>
+
+struct percpu_rw_semaphore {
+	unsigned __percpu *counters;
+	bool locked;
+	struct mutex mtx;
+};
+
+static inline void percpu_down_read(struct percpu_rw_semaphore *p)
+{
+	rcu_read_lock();
+	if (unlikely(p->locked)) {
+		rcu_read_unlock();
+		mutex_lock(&p->mtx);
+		this_cpu_inc(*p->counters);
+		mutex_unlock(&p->mtx);
+		return;
+	}
+	this_cpu_inc(*p->counters);
+	rcu_read_unlock();
+}
+
+static inline void percpu_up_read(struct percpu_rw_semaphore *p)
+{
+	/*
+	 * On X86, write operation in this_cpu_dec serves as a memory unlock
+	 * barrier (i.e. memory accesses may be moved before the write, but
+	 * no memory accesses are moved past the write).
+	 * On other architectures this may not be the case, so we need smp_mb()
+	 * there.
+	 */
+#if defined(CONFIG_X86) && (!defined(CONFIG_X86_PPRO_FENCE) && !defined(CONFIG_X86_OOSTORE))
+	barrier();
+#else
+	smp_mb();
+#endif
+	this_cpu_dec(*p->counters);
+}
+
+static inline unsigned __percpu_count(unsigned __percpu *counters)
+{
+	unsigned total = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		total += ACCESS_ONCE(*per_cpu_ptr(counters, cpu));
+
+	return total;
+}
+
+static inline void percpu_down_write(struct percpu_rw_semaphore *p)
+{
+	mutex_lock(&p->mtx);
+	p->locked = true;
+	synchronize_rcu();
+	while (__percpu_count(p->counters))
+		msleep(1);
+	smp_rmb(); /* paired with smp_mb() in percpu_sem_up_read() */
+}
+
+static inline void percpu_up_write(struct percpu_rw_semaphore *p)
+{
+	p->locked = false;
+	mutex_unlock(&p->mtx);
+}
+
+static inline int percpu_init_rwsem(struct percpu_rw_semaphore *p)
+{
+	p->counters = alloc_percpu(unsigned);
+	if (unlikely(!p->counters))
+		return -ENOMEM;
+	p->locked = false;
+	mutex_init(&p->mtx);
+	return 0;
+}
+
+static inline void percpu_free_rwsem(struct percpu_rw_semaphore *p)
+{
+	free_percpu(p->counters);
+	p->counters = NULL; /* catch use after free bugs */
+}
+
+#endif
Index: linux-2.6-copy/Documentation/percpu-rw-semaphore.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-copy/Documentation/percpu-rw-semaphore.txt	2012-09-26 00:45:29.000000000 +0200
@@ -0,0 +1,27 @@
+Percpu rw semaphores
+--------------------
+
+Percpu rw semaphores is a new read-write semaphore design that is
+optimized for locking for reading.
+
+The problem with traditional read-write semaphores is that when multiple
+cores take the lock for reading, the cache line containing the semaphore
+is bouncing between L1 caches of the cores, causing performance
+degradation.
+
+Locking for reading it very fast, it uses RCU and it avoids any atomic
+instruction in the lock and unlock path. On the other hand, locking for
+writing is very expensive, it calls synchronize_rcu() that can take
+hundreds of microseconds.
+
+The lock is declared with "struct percpu_rw_semaphore" type.
+The lock is initialized percpu_init_rwsem, it returns 0 on success and
+-ENOMEM on allocation failure.
+The lock must be freed with percpu_free_rwsem to avoid memory leak.
+
+The lock is locked for read with percpu_down_read, percpu_up_read and
+for write with percpu_down_write, percpu_up_write.
+
+The idea of using RCU for optimized rw-lock was introduced by
+Eric Dumazet <eric.dumazet@gmail.com>.
+The code was written by Mikulas Patocka <mpatocka@redhat.com>


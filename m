Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab2HaSnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 14:43:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275Ab2HaSnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 14:43:51 -0400
Date: Fri, 31 Aug 2012 14:43:39 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Jens Axboe <axboe@kernel.dk>, Andrea Arcangeli <aarcange@redhat.com>,
        Jan Kara <jack@suse.cz>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org,
        lwoodman@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
Subject: [PATCH 4/4] New percpu lock implementation
In-Reply-To: <Pine.LNX.4.64.1208311442190.2212@file.rdu.redhat.com>
Message-ID: <Pine.LNX.4.64.1208311443170.2212@file.rdu.redhat.com>
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
 <Pine.LNX.4.64.1208311442190.2212@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New percpu lock implementation

An alternative percpu lock implementation. The original idea by
Eric Dumazet <eric.dumazet@gmail.com>

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
 fs/block_dev.c               |   15 ++----
 include/linux/percpu-rwsem.h |   95 +++++++++++++++++++++----------------------
 2 files changed, 54 insertions(+), 56 deletions(-)

Index: linux-3.5.2-fast/fs/block_dev.c
===================================================================
--- linux-3.5.2-fast.orig/fs/block_dev.c	2012-08-18 01:23:32.000000000 +0200
+++ linux-3.5.2-fast/fs/block_dev.c	2012-08-18 01:23:32.000000000 +0200
@@ -1599,13 +1599,12 @@ ssize_t blkdev_aio_read(struct kiocb *io
 {
 	ssize_t ret;
 	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
-	percpu_rwsem_ptr p;
 
-	p = percpu_down_read(&bdev->bd_block_size_semaphore);
+	percpu_down_read(&bdev->bd_block_size_semaphore);
 
 	ret = generic_file_aio_read(iocb, iov, nr_segs, pos);
 
-	percpu_up_read(&bdev->bd_block_size_semaphore, p);
+	percpu_up_read(&bdev->bd_block_size_semaphore);
 
 	return ret;
 }
@@ -1624,11 +1623,10 @@ ssize_t blkdev_aio_write(struct kiocb *i
 	struct file *file = iocb->ki_filp;
 	struct block_device *bdev = I_BDEV(file->f_mapping->host);
 	ssize_t ret;
-	percpu_rwsem_ptr p;
 
 	BUG_ON(iocb->ki_pos != pos);
 
-	p = percpu_down_read(&bdev->bd_block_size_semaphore);
+	percpu_down_read(&bdev->bd_block_size_semaphore);
 
 	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
 	if (ret > 0 || ret == -EIOCBQUEUED) {
@@ -1639,7 +1637,7 @@ ssize_t blkdev_aio_write(struct kiocb *i
 			ret = err;
 	}
 
-	percpu_up_read(&bdev->bd_block_size_semaphore, p);
+	percpu_up_read(&bdev->bd_block_size_semaphore);
 
 	return ret;
 }
@@ -1649,13 +1647,12 @@ int blkdev_mmap(struct file *file, struc
 {
 	int ret;
 	struct block_device *bdev = I_BDEV(file->f_mapping->host);
-	percpu_rwsem_ptr p;
 
-	p = percpu_down_read(&bdev->bd_block_size_semaphore);
+	percpu_down_read(&bdev->bd_block_size_semaphore);
 
 	ret = generic_file_mmap(file, vma);
 
-	percpu_up_read(&bdev->bd_block_size_semaphore, p);
+	percpu_up_read(&bdev->bd_block_size_semaphore);
 
 	return ret;
 }
Index: linux-3.5.2-fast/include/linux/percpu-rwsem.h
===================================================================
--- linux-3.5.2-fast.orig/include/linux/percpu-rwsem.h	2012-08-18 01:23:32.000000000 +0200
+++ linux-3.5.2-fast/include/linux/percpu-rwsem.h	2012-08-18 01:26:08.000000000 +0200
@@ -1,77 +1,78 @@
 #ifndef _LINUX_PERCPU_RWSEM_H
 #define _LINUX_PERCPU_RWSEM_H
 
-#include <linux/rwsem.h>
+#include <linux/mutex.h>
 #include <linux/percpu.h>
-
-#ifndef CONFIG_SMP
-
-#define percpu_rw_semaphore	rw_semaphore
-#define percpu_rwsem_ptr	int
-#define percpu_down_read(x)	(down_read(x), 0)
-#define percpu_up_read(x, y)	up_read(x)
-#define percpu_down_write	down_write
-#define percpu_up_write		up_write
-#define percpu_init_rwsem(x)	(({init_rwsem(x);}), 0)
-#define percpu_free_rwsem(x)	do { } while (0)
-
-#else
+#include <linux/rcupdate.h>
+#include <linux/delay.h>
 
 struct percpu_rw_semaphore {
-	struct rw_semaphore __percpu *s;
+	unsigned __percpu *counters;
+	bool locked;
+	struct mutex mtx;
 };
 
-typedef struct rw_semaphore *percpu_rwsem_ptr;
-
-static inline percpu_rwsem_ptr percpu_down_read(struct percpu_rw_semaphore *sem)
+static inline void percpu_down_read(struct percpu_rw_semaphore *p)
 {
-	struct rw_semaphore *s = __this_cpu_ptr(sem->s);
-	down_read(s);
-	return s;
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
 }
 
-static inline void percpu_up_read(struct percpu_rw_semaphore *sem, percpu_rwsem_ptr s)
+static inline void percpu_up_read(struct percpu_rw_semaphore *p)
 {
-	up_read(s);
+	smp_wmb();
+	this_cpu_dec(*p->counters);
 }
 
-static inline void percpu_down_write(struct percpu_rw_semaphore *sem)
+static inline unsigned int percpu_count(unsigned __percpu *counters)
 {
+	unsigned total = 0;
 	int cpu;
-	for_each_possible_cpu(cpu) {
-		struct rw_semaphore *s = per_cpu_ptr(sem->s, cpu);
-		down_write(s);
-	}
+
+	for_each_possible_cpu(cpu)
+		total += ACCESS_ONCE(*per_cpu_ptr(counters, cpu));
+
+	return total;
 }
 
-static inline void percpu_up_write(struct percpu_rw_semaphore *sem)
+static inline void percpu_down_write(struct percpu_rw_semaphore *p)
 {
-	int cpu;
-	for_each_possible_cpu(cpu) {
-		struct rw_semaphore *s = per_cpu_ptr(sem->s, cpu);
-		up_write(s);
-	}
+	mutex_lock(&p->mtx);
+	p->locked = true;
+	synchronize_rcu();
+	while (percpu_count(p->counters))
+		msleep(1);
+	smp_rmb(); /* paired with smp_wmb() in percpu_sem_up_read() */
 }
 
-static inline int percpu_init_rwsem(struct percpu_rw_semaphore *sem)
+static inline void percpu_up_write(struct percpu_rw_semaphore *p)
 {
-	int cpu;
-	sem->s = alloc_percpu(struct rw_semaphore);
-	if (unlikely(!sem->s))
+	p->locked = false;
+	mutex_unlock(&p->mtx);
+}
+
+static inline int percpu_init_rwsem(struct percpu_rw_semaphore *p)
+{
+	p->counters = alloc_percpu(unsigned);
+	if (unlikely(!p->counters))
 		return -ENOMEM;
-	for_each_possible_cpu(cpu) {
-		struct rw_semaphore *s = per_cpu_ptr(sem->s, cpu);
-		init_rwsem(s);
-	}
+	p->locked = false;
+	mutex_init(&p->mtx);
 	return 0;
 }
 
-static inline void percpu_free_rwsem(struct percpu_rw_semaphore *sem)
+static inline void percpu_free_rwsem(struct percpu_rw_semaphore *p)
 {
-	free_percpu(sem->s);
-	sem->s = NULL;		/* catch use after free bugs */
+	free_percpu(p->counters);
+	p->counters = NULL; /* catch use after free bugs */
 }
 
 #endif
-
-#endif


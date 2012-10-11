Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab2JKF6D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 01:58:03 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:39017 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313Ab2JKF54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 01:57:56 -0400
X-AuditID: b753bd60-91ec3ba0000047ca-50-50765f5e17c6
X-AuditID: b753bd60-91ec3ba0000047ca-50-50765f5e17c6
From: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
Subject: [RFC PATCH 3/3 V3] livedump: Add memory dumping functionality
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "Vivek Goyal" <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Cc: "Al Viro" <viro@zeniv.linux.org.uk>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Andy Lutomirski" <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Ingo Molnar" <mingo@redhat.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Prarit Bhargava" <prarit@redhat.com>,
        "Srikar Dronamraju" <srikar@linux.vnet.ibm.com>,
        "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, "Khalid Aziz" <khalid.aziz@hp.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Thu, 11 Oct 2012 14:53:57 +0900
Message-ID: <20121011055356.6719.74225.stgit@t3500.sdl.hitachi.co.jp>
In-Reply-To: <20121011055356.6719.46214.stgit@t3500.sdl.hitachi.co.jp>
References: <20121011055356.6719.46214.stgit@t3500.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements memory dumping of kernel space. Faulting pages are
temporarily pushed into kfifo and they are poped and dumped by kthread
dedicated to livedump. At the moment, supported target is only block
device like /dev/sdb.

Memory dumping is executed as follows:
(1)The handler function is invoked and:
  - It pops a buffer page from the kfifo "pool".
  - It copies a faulting page into the buffer page.
  - It pushes the buffer page into the kfifo "pend".
(2)The kthread pops the buffer page from the kfifo "pend" and submits
   bio to dump it.
(3)The endio returns the buffer page back to the kfifo "pool".

At the step (1), if the kfifo "pool" is empty, processing varies depending
on whether tha handler function is called in the sweep phase or not.
If it's in the sweep phase, the handler function waits until the kfifo
"pool" becomes available.
If not, the livedump simply fails.

Signed-off-by: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
---

 kernel/Makefile           |    2 
 kernel/livedump-memdump.c |  445 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/livedump-memdump.h |   32 +++
 kernel/livedump.c         |   24 ++
 tools/livedump/livedump   |   16 +-
 5 files changed, 508 insertions(+), 11 deletions(-)
 create mode 100644 kernel/livedump-memdump.c
 create mode 100644 kernel/livedump-memdump.h

diff --git a/kernel/Makefile b/kernel/Makefile
index c8bd09b..e009578 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -110,7 +110,7 @@ obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
 obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
 obj-$(CONFIG_JUMP_LABEL) += jump_label.o
-obj-$(CONFIG_LIVEDUMP) += livedump.o
+obj-$(CONFIG_LIVEDUMP) += livedump.o livedump-memdump.o
 
 $(obj)/configs.o: $(obj)/config_data.h
 
diff --git a/kernel/livedump-memdump.c b/kernel/livedump-memdump.c
new file mode 100644
index 0000000..13a9413
--- /dev/null
+++ b/kernel/livedump-memdump.c
@@ -0,0 +1,445 @@
+/* livedump-memdump.c - Live Dump's memory dumping management
+ * Copyright (C) 2012 Hitachi, Ltd.
+ * Author: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
+ * MA  02110-1301, USA.
+ */
+
+#include "livedump-memdump.h"
+#include <asm/wrprotect.h>
+
+#include <linux/kthread.h>
+#include <linux/slab.h>
+#include <linux/kfifo.h>
+#include <linux/delay.h>
+#include <linux/bio.h>
+
+#define MEMDUMP_KFIFO_SIZE 16384 /* in pages */
+#define SECTOR_SHIFT 9
+static const char THREAD_NAME[] = "livedump";
+static struct block_device *memdump_bdev;
+
+/***** State machine *****/
+enum MEMDUMP_STATE {
+	_MEMDUMP_INIT,
+	MEMDUMP_INACTIVE = _MEMDUMP_INIT,
+	MEMDUMP_ACTIVATING,
+	MEMDUMP_ACTIVE,
+	MEMDUMP_INACTIVATING,
+	_MEMDUMP_OVERFLOW,
+};
+
+static struct memdump_state {
+	atomic_t val;
+	atomic_t count;
+	spinlock_t lock;
+} __aligned(PAGE_SIZE) memdump_state = {
+	ATOMIC_INIT(_MEMDUMP_INIT),
+	ATOMIC_INIT(0),
+	__SPIN_LOCK_INITIALIZER(memdump_state.lock),
+};
+
+/* memdump_state_inc
+ *
+ * Increments ACTIVE state refcount.
+ * The refcount must be zero to transit to next state (INACTIVATING).
+ */
+static bool memdump_state_inc(void)
+{
+	bool ret;
+
+	spin_lock(&memdump_state.lock);
+	ret = (atomic_read(&memdump_state.val) == MEMDUMP_ACTIVE);
+	if (ret)
+		atomic_inc(&memdump_state.count);
+	spin_unlock(&memdump_state.lock);
+	return ret;
+}
+
+/* memdump_state_dec
+ *
+ * Decrements ACTIVE state refcount
+ */
+static void memdump_state_dec(void)
+{
+	atomic_dec(&memdump_state.count);
+}
+
+/* memdump_state_transit
+ *
+ * Transit to next state.
+ * If current state isn't assumed state, transition fails.
+ */
+static bool memdump_state_transit(enum MEMDUMP_STATE assumed)
+{
+	bool ret;
+
+	spin_lock(&memdump_state.lock);
+	ret = (atomic_read(&memdump_state.val) == assumed &&
+		atomic_read(&memdump_state.count) == 0);
+	if (ret) {
+		atomic_inc(&memdump_state.val);
+		if (atomic_read(&memdump_state.val) == _MEMDUMP_OVERFLOW)
+			atomic_set(&memdump_state.val, _MEMDUMP_INIT);
+	}
+	spin_unlock(&memdump_state.lock);
+	return ret;
+}
+
+static void memdump_state_transit_back(void)
+{
+	atomic_dec(&memdump_state.val);
+}
+
+/***** Request queue *****/
+
+/*
+ * Request queue consists of 2 kfifos: pend, pool
+ *
+ * Processing between the two kfifos:
+ *  (1)handle_page READs one request from POOL.
+ *  (2)handle_page makes the request and WRITEs it to PEND.
+ *  (3)kthread READs the request from PEND and submits bio.
+ *  (4)endio WRITEs the request to POOL.
+ *
+ * kfifo permits parallel access by 1 reader and 1 writer.
+ * Therefore, (1), (2) and (4) must be serialized.
+ * (3) need not be protected since livedump uses only one kthread.
+ *
+ * (1) is protected by pool_r_lock.
+ * (2) is protected by pend_w_lock.
+ * (4) is protected by pool_w_lock.
+ */
+
+struct memdump_request {
+	void *p; /* pointing to buffer (one page) */
+	unsigned long pfn;
+};
+
+static struct memdump_request_queue {
+	void *pages[MEMDUMP_KFIFO_SIZE];
+	STRUCT_KFIFO(struct memdump_request, MEMDUMP_KFIFO_SIZE) pool;
+	STRUCT_KFIFO(struct memdump_request, MEMDUMP_KFIFO_SIZE) pend;
+	spinlock_t pool_w_lock;
+	spinlock_t pool_r_lock;
+	spinlock_t pend_w_lock;
+} __aligned(PAGE_SIZE) memdump_req_queue, memdump_req_queue_for_sweep;
+
+static void free_req_queue(void)
+{
+	int i;
+
+	for (i = 0; i < MEMDUMP_KFIFO_SIZE; i++) {
+		if (memdump_req_queue.pages[i]) {
+			free_page((unsigned long)memdump_req_queue.pages[i]);
+			memdump_req_queue.pages[i] = NULL;
+		}
+	}
+	for (i = 0; i < MEMDUMP_KFIFO_SIZE; i++) {
+		if (memdump_req_queue_for_sweep.pages[i]) {
+			free_page((unsigned long)memdump_req_queue_for_sweep.
+					pages[i]);
+			memdump_req_queue_for_sweep.pages[i] = NULL;
+		}
+	}
+}
+
+static long alloc_req_queue(void)
+{
+	long ret;
+	int i;
+	struct memdump_request req;
+
+	/* initialize spinlocks */
+	spin_lock_init(&memdump_req_queue.pool_w_lock);
+	spin_lock_init(&memdump_req_queue.pool_r_lock);
+	spin_lock_init(&memdump_req_queue.pend_w_lock);
+	spin_lock_init(&memdump_req_queue_for_sweep.pool_w_lock);
+	spin_lock_init(&memdump_req_queue_for_sweep.pool_r_lock);
+	spin_lock_init(&memdump_req_queue_for_sweep.pend_w_lock);
+
+	/* initialize kfifos */
+	INIT_KFIFO(memdump_req_queue.pend);
+	INIT_KFIFO(memdump_req_queue.pool);
+	INIT_KFIFO(memdump_req_queue_for_sweep.pend);
+	INIT_KFIFO(memdump_req_queue_for_sweep.pool);
+
+	/* allocate pages and push pages into pool */
+	for (i = 0; i < MEMDUMP_KFIFO_SIZE; i++) {
+		/* for normal queue */
+		memdump_req_queue.pages[i]
+			= (void *)__get_free_page(GFP_KERNEL);
+		if (!memdump_req_queue.pages[i]) {
+			ret = -ENOMEM;
+			goto err;
+		}
+
+		req.p = memdump_req_queue.pages[i];
+		ret = kfifo_put(&memdump_req_queue.pool, &req);
+		BUG_ON(!ret);
+
+		/* for sweep queue */
+		memdump_req_queue_for_sweep.pages[i]
+			= (void *)__get_free_page(GFP_KERNEL);
+		if (!memdump_req_queue_for_sweep.pages[i]) {
+			ret = -ENOMEM;
+			goto err;
+		}
+
+		req.p = memdump_req_queue_for_sweep.pages[i];
+		ret = kfifo_put(&memdump_req_queue_for_sweep.pool, &req);
+		BUG_ON(!ret);
+	}
+
+	return 0;
+
+err:
+	free_req_queue();
+	return ret;
+}
+
+/***** Kernel thread *****/
+static struct memdump_thread {
+	struct task_struct *tsk;
+	bool is_active;
+	struct completion completion;
+	wait_queue_head_t waiters;
+} __aligned(PAGE_SIZE) memdump_thread;
+
+static int memdump_thread_func(void *);
+
+static long start_memdump_thread(void)
+{
+	memdump_thread.is_active = true;
+	init_completion(&memdump_thread.completion);
+	init_waitqueue_head(&memdump_thread.waiters);
+	memdump_thread.tsk = kthread_run(
+			memdump_thread_func, NULL, THREAD_NAME);
+	if (IS_ERR(memdump_thread.tsk))
+		return PTR_ERR(memdump_thread.tsk);
+	return 0;
+}
+
+static void stop_memdump_thread(void)
+{
+	memdump_thread.is_active = false;
+	wait_for_completion(&memdump_thread.completion);
+}
+
+static void memdump_endio(struct bio *bio, int error)
+{
+	struct memdump_request req = { .p = page_address(bio_page(bio)) };
+	struct memdump_request_queue *queue = (bio->bi_private ?
+			&memdump_req_queue_for_sweep : &memdump_req_queue);
+
+	spin_lock(&queue->pool_w_lock);
+	kfifo_put(&queue->pool, &req);
+	spin_unlock(&queue->pool_w_lock);
+
+	wake_up(&memdump_thread.waiters);
+}
+
+static int memdump_thread_func(void *_)
+{
+	do {
+		struct memdump_request req;
+
+		/* Process request */
+		while (kfifo_get(&memdump_req_queue.pend, &req)) {
+			struct bio *bio;
+
+			bio = bio_alloc(GFP_KERNEL, 1);
+			if (WARN_ON(!bio)) {
+				spin_lock(&memdump_req_queue.pool_w_lock);
+				kfifo_put(&memdump_req_queue.pool, &req);
+				spin_unlock(&memdump_req_queue.pool_w_lock);
+				continue;
+			}
+
+			bio->bi_bdev = memdump_bdev;
+			bio->bi_end_io = memdump_endio;
+			bio->bi_sector = req.pfn << (PAGE_SHIFT - SECTOR_SHIFT);
+			bio_add_page(bio, virt_to_page(req.p), PAGE_SIZE, 0);
+
+			submit_bio(REQ_WRITE, bio);
+		}
+
+		/* Process request for sweep*/
+		while (kfifo_get(&memdump_req_queue_for_sweep.pend, &req)) {
+			struct bio *bio;
+
+			bio = bio_alloc(GFP_KERNEL, 1);
+			if (WARN_ON(!bio)) {
+				spin_lock(&memdump_req_queue_for_sweep.
+						pool_w_lock);
+				kfifo_put(&memdump_req_queue_for_sweep.pool,
+						&req);
+				spin_unlock(&memdump_req_queue_for_sweep.
+						pool_w_lock);
+				continue;
+			}
+
+			bio->bi_bdev = memdump_bdev;
+			bio->bi_end_io = memdump_endio;
+			bio->bi_sector = req.pfn << (PAGE_SHIFT - SECTOR_SHIFT);
+			bio->bi_private = (void *)1; /* for sweep */
+			bio_add_page(bio, virt_to_page(req.p), PAGE_SIZE, 0);
+
+			submit_bio(REQ_WRITE, bio);
+		}
+
+		msleep(20);
+	} while (memdump_thread.is_active);
+
+	complete(&memdump_thread.completion);
+	return 0;
+}
+
+static int select_pages(unsigned long *pgbmp);
+
+int livedump_memdump_init(unsigned long *pgbmp, const char *bdevpath)
+{
+	long ret;
+
+	if (WARN(!memdump_state_transit(MEMDUMP_INACTIVE),
+				"livedump: memdump is already initialized.\n"))
+		return -EBUSY;
+
+	/* Get bdev */
+	ret = -ENOENT;
+	memdump_bdev = blkdev_get_by_path(bdevpath, FMODE_EXCL, &memdump_bdev);
+	if (!memdump_bdev)
+		goto err;
+
+	/* Allocate request queue */
+	ret = alloc_req_queue();
+	if (ret)
+		goto err_bdev;
+
+	/* Start thread */
+	ret = start_memdump_thread();
+	if (ret)
+		goto err_freeq;
+
+	/* Select target pages */
+	select_pages(pgbmp);
+
+	memdump_state_transit(MEMDUMP_ACTIVATING); /* always succeeds */
+	return 0;
+
+err_freeq:
+	free_req_queue();
+err_bdev:
+	blkdev_put(memdump_bdev, FMODE_EXCL);
+err:
+	memdump_state_transit_back();
+	return ret;
+}
+
+void livedump_memdump_uninit(void)
+{
+	if (!memdump_state_transit(MEMDUMP_ACTIVE))
+		return;
+
+	/* Stop thread */
+	stop_memdump_thread();
+
+	/* Free request queue */
+	free_req_queue();
+
+	/* Put bdev */
+	blkdev_put(memdump_bdev, FMODE_EXCL);
+
+	memdump_state_transit(MEMDUMP_INACTIVATING); /* always succeeds */
+	return;
+}
+
+void livedump_memdump_handle_page(unsigned long pfn, int for_sweep)
+{
+	int ret;
+	unsigned long flags;
+	struct memdump_request req;
+	struct memdump_request_queue *queue =
+		(for_sweep ? &memdump_req_queue_for_sweep : &memdump_req_queue);
+
+	if (!memdump_state_inc())
+		return;
+
+	/* Get buffer */
+retry_after_wait:
+	spin_lock_irqsave(&queue->pool_r_lock, flags);
+	ret = kfifo_get(&queue->pool, &req);
+	spin_unlock_irqrestore(&queue->pool_r_lock, flags);
+
+	if (!ret) {
+		if (WARN_ON_ONCE(!for_sweep))
+			goto err;
+		else {
+			DEFINE_WAIT(wait);
+			prepare_to_wait(&memdump_thread.waiters, &wait,
+					TASK_UNINTERRUPTIBLE);
+			schedule();
+			finish_wait(&memdump_thread.waiters, &wait);
+			goto retry_after_wait;
+		}
+	}
+
+	/* Make request */
+	req.pfn = pfn;
+	memcpy(req.p, pfn_to_kaddr(pfn), PAGE_SIZE);
+
+	/* Queue request */
+	spin_lock_irqsave(&queue->pend_w_lock, flags);
+	kfifo_put(&queue->pend, &req);
+	spin_unlock_irqrestore(&queue->pend_w_lock, flags);
+
+err:
+	memdump_state_dec();
+	return;
+}
+
+/* select_pages
+ *
+ * Eliminate pages that contain memdump's stuffs from bitmap.
+ */
+static int select_pages(unsigned long *pgbmp)
+{
+	unsigned long i;
+
+	/* Essential area for executing crash with livedump */
+	bitmap_set(pgbmp, 0, (CONFIG_X86_RESERVE_LOW << 10) >> PAGE_SHIFT);
+
+	/* Unselect memdump stuffs */
+	wrprotect_unselect_pages(pgbmp,
+			(unsigned long)&memdump_state, sizeof(memdump_state));
+	wrprotect_unselect_pages(pgbmp,
+			(unsigned long)&memdump_req_queue,
+			sizeof(memdump_req_queue));
+	wrprotect_unselect_pages(pgbmp,
+			(unsigned long)&memdump_req_queue_for_sweep,
+			sizeof(memdump_req_queue_for_sweep));
+	wrprotect_unselect_pages(pgbmp,
+			(unsigned long)&memdump_thread, sizeof(memdump_thread));
+	for (i = 0; i < MEMDUMP_KFIFO_SIZE; i++) {
+		clear_bit(__pa(memdump_req_queue.pages[i]) >> PAGE_SHIFT,
+				pgbmp);
+		clear_bit(__pa(memdump_req_queue_for_sweep.pages[i])
+				>> PAGE_SHIFT, pgbmp);
+		cond_resched();
+	}
+
+	return 0;
+}
diff --git a/kernel/livedump-memdump.h b/kernel/livedump-memdump.h
new file mode 100644
index 0000000..ac2f922
--- /dev/null
+++ b/kernel/livedump-memdump.h
@@ -0,0 +1,32 @@
+/* livedump-memdump.h - Live Dump's memory dumping management
+ * Copyright (C) 2012 Hitachi, Ltd.
+ * Author: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
+ * MA  02110-1301, USA.
+ */
+
+#ifndef _LIVEDUMP_MEMDUMP_H
+#define _LIVEDUMP_MEMDUMP_H
+
+#include <linux/fs.h>
+
+extern int livedump_memdump_init(unsigned long *pgbmp, const char *bdevpath);
+
+extern void livedump_memdump_uninit(void);
+
+extern void livedump_memdump_handle_page(unsigned long pfn, int for_sweep);
+
+#endif /* _LIVEDUMP_MEMDUMP_H */
diff --git a/kernel/livedump.c b/kernel/livedump.c
index 3cf0f53..96167c8 100644
--- a/kernel/livedump.c
+++ b/kernel/livedump.c
@@ -18,10 +18,12 @@
  * MA  02110-1301, USA.
  */
 
+#include "livedump-memdump.h"
 #include <asm/wrprotect.h>
 
 #include <linux/kernel.h>
 #include <linux/fs.h>
+#include <linux/uaccess.h>
 #include <linux/miscdevice.h>
 #include <linux/reboot.h>
 
@@ -38,13 +40,14 @@ unsigned long *pgbmp;
 static void do_uninit(void)
 {
 	wrprotect_uninit();
+	livedump_memdump_uninit();
 	if (pgbmp) {
 		wrprotect_destroy_page_bitmap(pgbmp);
 		pgbmp = NULL;
 	}
 }
 
-static int do_init(void)
+static int do_init(const char *bdevpath)
 {
 	int ret;
 
@@ -53,7 +56,11 @@ static int do_init(void)
 	if (!pgbmp)
 		goto err;
 
-	ret = wrprotect_init(pgbmp, NULL);
+	ret = livedump_memdump_init(pgbmp, bdevpath);
+	if (WARN(ret, "livedump: Failed to initialize Dump manager.\n"))
+		goto err;
+
+	ret = wrprotect_init(pgbmp, livedump_memdump_handle_page);
 	if (WARN(ret, "livedump: Failed to initialize Protection manager.\n"))
 		goto err;
 
@@ -63,16 +70,23 @@ err:
 	return ret;
 }
 
-static long livedump_ioctl(
-		struct file *file, unsigned int cmd, unsigned long arg)
+static long livedump_ioctl(struct file *_, unsigned int cmd, unsigned long arg)
 {
+	long ret;
+	char *path;
+
 	switch (cmd) {
 	case LIVEDUMP_IOC_START:
 		return wrprotect_start();
 	case LIVEDUMP_IOC_SWEEP:
 		return wrprotect_sweep();
 	case LIVEDUMP_IOC_INIT:
-		return do_init();
+		path = getname((char __user *)arg);
+		if (IS_ERR(path))
+			return PTR_ERR(path);
+		ret = do_init(path);
+		putname(path);
+		return ret;
 	case LIVEDUMP_IOC_UNINIT:
 		do_uninit();
 		return 0;
diff --git a/tools/livedump/livedump b/tools/livedump/livedump
index 2025fc4..79d9cdc 100755
--- a/tools/livedump/livedump
+++ b/tools/livedump/livedump
@@ -3,8 +3,8 @@
 import sys
 import fcntl
 
-def ioctl_init(f):
-	fcntl.ioctl(f, 0xff64)
+def ioctl_init(f, path):
+	fcntl.ioctl(f, 0xff64, path)
 
 def ioctl_uninit(f):
 	fcntl.ioctl(f, 0xff65)
@@ -20,9 +20,15 @@ if __name__ == '__main__':
 	f = open('/dev/livedump')
 	# execute subcommand
 	subcmd = sys.argv[1]
-	if 'init' == subcmd:
-		ioctl_init(f)
-	elif 'uninit' == subcmd:
+	if 'dump' == subcmd or 'init' == subcmd:
+		dumpdisk = sys.argv[2]
+	if 'dump' == subcmd:
+		ioctl_init(f, dumpdisk)
+		ioctl_start(f)
+		ioctl_sweep(f)
+	elif 'init' == subcmd:
+		ioctl_init(f, dumpdisk)
+	elif 'uninit' == subcmd or 'release' == subcmd:
 		ioctl_uninit(f)
 	elif 'start' == subcmd:
 		ioctl_start(f)



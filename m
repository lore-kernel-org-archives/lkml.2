Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab2GJK6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 06:58:30 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53636 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab2GJK6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 06:58:10 -0400
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Subject: [RFC PATCH 1/8] dma-buf-mgr: Try 2
Date: Tue, 10 Jul 2012 12:57:44 +0200
Message-Id: <1341917871-2512-2-git-send-email-m.b.lankhorst@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341917871-2512-1-git-send-email-m.b.lankhorst@gmail.com>
References: <1341917871-2512-1-git-send-email-m.b.lankhorst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maarten Lankhorst <maarten.lankhorst@canonical.com>

Core code based on ttm_bo and ttm_execbuf_util

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

---
 drivers/base/Makefile         |    2 +-
 drivers/base/dma-buf-mgr-eu.c |  263 +++++++++++++++++++++++++++++++++++++++++
 drivers/base/dma-buf-mgr.c    |  149 +++++++++++++++++++++++
 drivers/base/dma-buf.c        |    4 +
 include/linux/dma-buf-mgr.h   |  150 +++++++++++++++++++++++
 include/linux/dma-buf.h       |   24 ++++
 6 files changed, 591 insertions(+), 1 deletion(-)
 create mode 100644 drivers/base/dma-buf-mgr-eu.c
 create mode 100644 drivers/base/dma-buf-mgr.c
 create mode 100644 include/linux/dma-buf-mgr.h

diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 5aa2d70..86e7598 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_CMA) += dma-contiguous.o
 obj-y			+= power/
 obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
 obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
-obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o
+obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o dma-buf-mgr.o dma-buf-mgr-eu.o
 obj-$(CONFIG_ISA)	+= isa.o
 obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
 obj-$(CONFIG_NUMA)	+= node.o
diff --git a/drivers/base/dma-buf-mgr-eu.c b/drivers/base/dma-buf-mgr-eu.c
new file mode 100644
index 0000000..ed5e01c
--- /dev/null
+++ b/drivers/base/dma-buf-mgr-eu.c
@@ -0,0 +1,263 @@
+/*
+ * Copyright (C) 2012 Canonical Ltd
+ *
+ * Based on ttm_bo.c which bears the following copyright notice,
+ * but is dual licensed:
+ *
+ * Copyright (c) 2006-2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+
+#include <linux/dma-buf-mgr.h>
+#include <linux/sched.h>
+#include <linux/export.h>
+
+static void dmabufmgr_eu_backoff_reservation_locked(struct list_head *list)
+{
+	struct dmabufmgr_validate *entry;
+
+	list_for_each_entry(entry, list, head) {
+		struct dma_buf *bo = entry->bo;
+		if (!entry->reserved)
+			continue;
+		entry->reserved = false;
+
+		bo->sync_buf = entry->sync_buf;
+		entry->sync_buf = NULL;
+
+		atomic_set(&bo->reserved, 0);
+		wake_up_all(&bo->event_queue);
+	}
+}
+
+static int
+dmabufmgr_eu_wait_unreserved_locked(struct list_head *list,
+				    struct dma_buf *bo)
+{
+	int ret;
+
+	spin_unlock(&dmabufmgr.lru_lock);
+	ret = dmabufmgr_bo_wait_unreserved(bo, true);
+	spin_lock(&dmabufmgr.lru_lock);
+	if (unlikely(ret != 0))
+		dmabufmgr_eu_backoff_reservation_locked(list);
+	return ret;
+}
+
+void
+dmabufmgr_eu_backoff_reservation(struct list_head *list)
+{
+	if (list_empty(list))
+		return;
+
+	spin_lock(&dmabufmgr.lru_lock);
+	dmabufmgr_eu_backoff_reservation_locked(list);
+	spin_unlock(&dmabufmgr.lru_lock);
+}
+EXPORT_SYMBOL_GPL(dmabufmgr_eu_backoff_reservation);
+
+int
+dmabufmgr_eu_reserve_buffers(struct list_head *list)
+{
+	struct dmabufmgr_validate *entry;
+	int ret;
+	u32 val_seq;
+
+	if (list_empty(list))
+		return 0;
+
+	list_for_each_entry(entry, list, head) {
+		entry->reserved = false;
+		entry->sync_buf = NULL;
+	}
+
+retry:
+	spin_lock(&dmabufmgr.lru_lock);
+	val_seq = dmabufmgr.counter++;
+
+	list_for_each_entry(entry, list, head) {
+		struct dma_buf *bo = entry->bo;
+
+retry_this_bo:
+		ret = dmabufmgr_bo_reserve_locked(bo, true, true, true, val_seq);
+		switch (ret) {
+		case 0:
+			break;
+		case -EBUSY:
+			ret = dmabufmgr_eu_wait_unreserved_locked(list, bo);
+			if (unlikely(ret != 0)) {
+				spin_unlock(&dmabufmgr.lru_lock);
+				return ret;
+			}
+			goto retry_this_bo;
+		case -EAGAIN:
+			dmabufmgr_eu_backoff_reservation_locked(list);
+			spin_unlock(&dmabufmgr.lru_lock);
+			ret = dmabufmgr_bo_wait_unreserved(bo, true);
+			if (unlikely(ret != 0))
+				return ret;
+			goto retry;
+		default:
+			dmabufmgr_eu_backoff_reservation_locked(list);
+			spin_unlock(&dmabufmgr.lru_lock);
+			return ret;
+		}
+
+		entry->reserved = true;
+		entry->sync_buf = bo->sync_buf;
+		entry->sync_ofs = bo->sync_ofs;
+		entry->sync_val = bo->sync_val;
+		bo->sync_buf = NULL;
+	}
+	spin_unlock(&dmabufmgr.lru_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dmabufmgr_eu_reserve_buffers);
+
+static int
+dmabufmgr_eu_wait_single(struct dmabufmgr_validate *val, bool intr, bool lazy, unsigned long timeout)
+{
+	uint32_t *map, *seq, ofs;
+	unsigned long sleep_time = NSEC_PER_MSEC / 1000;
+	size_t start;
+	int ret = 0;
+
+	if (!val->sync_buf)
+		return 0;
+
+	start = val->sync_ofs & PAGE_MASK;
+	ofs = val->sync_ofs & ~PAGE_MASK;
+
+	ret = dma_buf_begin_cpu_access(val->sync_buf, start,
+				       start + PAGE_SIZE,
+				       DMA_FROM_DEVICE);
+	if (ret)
+		return ret;
+
+	map = dma_buf_kmap(val->sync_buf, val->sync_ofs >> PAGE_SHIFT);
+	seq = &map[ofs/4];
+
+	while (1) {
+		val->retval = *seq;
+		if (val->retval - val->sync_val < 0x80000000U)
+			break;
+
+		if (time_after_eq(jiffies, timeout)) {
+			ret = -EBUSY;
+			break;
+		}
+
+		set_current_state(intr ? TASK_INTERRUPTIBLE : TASK_UNINTERRUPTIBLE);
+
+		if (lazy) {
+			ktime_t t = ktime_set(0, sleep_time);
+			schedule_hrtimeout(&t, HRTIMER_MODE_REL);
+			if (sleep_time < NSEC_PER_MSEC)
+				sleep_time *= 2;
+		} else
+			cpu_relax();
+
+		if (intr && signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			break;
+		}
+	}
+
+	set_current_state(TASK_RUNNING);
+
+	dma_buf_kunmap(val->sync_buf, val->sync_ofs >> PAGE_SHIFT, map);
+	dma_buf_end_cpu_access(val->sync_buf, start,
+			       start + PAGE_SIZE,
+			       DMA_FROM_DEVICE);
+
+	val->waited = !ret;
+	if (!ret) {
+		dma_buf_put(val->sync_buf);
+		val->sync_buf = NULL;
+	}
+	return ret;
+}
+
+int
+dmabufmgr_eu_wait_completed_cpu(struct list_head *list, bool intr, bool lazy)
+{
+	struct dmabufmgr_validate *entry;
+	unsigned long timeout = jiffies + 4 * HZ;
+	int ret;
+
+	list_for_each_entry(entry, list, head) {
+		ret = dmabufmgr_eu_wait_single(entry, intr, lazy, timeout);
+		if (ret && ret != -ERESTARTSYS)
+			pr_err("waiting returns %i %08x(exp %08x)\n",
+			      ret, entry->retval, entry->sync_val);
+		if (ret)
+			goto err;
+	}
+	return 0;
+
+err:
+	list_for_each_entry_continue(entry, list, head) {
+		entry->waited = false;
+		entry->retval = -1;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dmabufmgr_eu_wait_completed_cpu);
+
+void
+dmabufmgr_eu_fence_buffer_objects(struct dma_buf *sync_buf, u32 ofs, u32 seq, struct list_head *list)
+{
+	struct dmabufmgr_validate *entry;
+	struct dma_buf *bo;
+
+	if (list_empty(list) || WARN_ON(!sync_buf))
+		return;
+
+	/* Don't use put with lock held, since the free function can
+	 * deadlock, this might be alleviated whendeferred fput hits mainline
+	 */
+	list_for_each_entry(entry, list, head) {
+		if (entry->sync_buf)
+			dma_buf_put(entry->sync_buf);
+		entry->sync_buf = NULL;
+		entry->reserved = false;
+	}
+
+	spin_lock(&dmabufmgr.lru_lock);
+
+	list_for_each_entry(entry, list, head) {
+		bo = entry->bo;
+
+		get_dma_buf(sync_buf);
+		bo->sync_buf = sync_buf;
+		bo->sync_ofs = ofs;
+		bo->sync_val = seq;
+
+		dmabufmgr_bo_unreserve_locked(bo);
+	}
+
+	spin_unlock(&dmabufmgr.lru_lock);
+}
+EXPORT_SYMBOL_GPL(dmabufmgr_eu_fence_buffer_objects);
diff --git a/drivers/base/dma-buf-mgr.c b/drivers/base/dma-buf-mgr.c
new file mode 100644
index 0000000..14756ff
--- /dev/null
+++ b/drivers/base/dma-buf-mgr.c
@@ -0,0 +1,149 @@
+/*
+ * Copyright (C) 2012 Canonical Ltd
+ *
+ * Based on ttm_bo.c which bears the following copyright notice,
+ * but is dual licensed:
+ *
+ * Copyright (c) 2006-2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thellstrom-at-vmware-dot-com>
+ */
+
+
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/dma-buf-mgr.h>
+#include <linux/anon_inodes.h>
+#include <linux/export.h>
+#include <linux/sched.h>
+#include <linux/list.h>
+
+/* Based on ttm_bo.c with vm_lock and fence_lock removed
+ * lru_lock takes care of fence_lock as well
+ */
+struct dmabufmgr dmabufmgr = {
+	.lru_lock = __SPIN_LOCK_UNLOCKED(dmabufmgr.lru_lock),
+	.counter = 1,
+};
+
+int
+dmabufmgr_bo_reserve_locked(struct dma_buf *bo,
+			    bool interruptible, bool no_wait,
+			    bool use_sequence, u32 sequence)
+{
+	int ret;
+
+	while (unlikely(atomic_cmpxchg(&bo->reserved, 0, 1) != 0)) {
+		/**
+		 * Deadlock avoidance for multi-bo reserving.
+		 */
+		if (use_sequence && bo->seq_valid) {
+			/**
+			 * We've already reserved this one.
+			 */
+			if (unlikely(sequence == bo->val_seq))
+				return -EDEADLK;
+			/**
+			 * Already reserved by a thread that will not back
+			 * off for us. We need to back off.
+			 */
+			if (unlikely(sequence - bo->val_seq < (1 << 31)))
+				return -EAGAIN;
+		}
+
+		if (no_wait)
+			return -EBUSY;
+
+		spin_unlock(&dmabufmgr.lru_lock);
+		ret = dmabufmgr_bo_wait_unreserved(bo, interruptible);
+		spin_lock(&dmabufmgr.lru_lock);
+
+		if (unlikely(ret))
+			return ret;
+	}
+
+	if (use_sequence) {
+		/**
+		 * Wake up waiters that may need to recheck for deadlock,
+		 * if we decreased the sequence number.
+		 */
+		if (unlikely((bo->val_seq - sequence < (1 << 31))
+			     || !bo->seq_valid))
+			wake_up_all(&bo->event_queue);
+
+		bo->val_seq = sequence;
+		bo->seq_valid = true;
+	} else {
+		bo->seq_valid = false;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dmabufmgr_bo_reserve_locked);
+
+int
+dmabufmgr_bo_reserve(struct dma_buf *bo,
+		     bool interruptible, bool no_wait,
+		     bool use_sequence, u32 sequence)
+{
+	int ret;
+
+	spin_lock(&dmabufmgr.lru_lock);
+	ret = dmabufmgr_bo_reserve_locked(bo, interruptible, no_wait,
+					  use_sequence, sequence);
+	spin_unlock(&dmabufmgr.lru_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dmabufmgr_bo_reserve);
+
+int
+dmabufmgr_bo_wait_unreserved(struct dma_buf *bo, bool interruptible)
+{
+	if (interruptible) {
+		return wait_event_interruptible(bo->event_queue,
+					       atomic_read(&bo->reserved) == 0);
+	} else {
+		wait_event(bo->event_queue, atomic_read(&bo->reserved) == 0);
+		return 0;
+	}
+}
+EXPORT_SYMBOL_GPL(dmabufmgr_bo_wait_unreserved);
+
+void dmabufmgr_bo_unreserve_locked(struct dma_buf *bo)
+{
+	atomic_set(&bo->reserved, 0);
+	wake_up_all(&bo->event_queue);
+}
+EXPORT_SYMBOL_GPL(dmabufmgr_bo_unreserve_locked);
+
+void dmabufmgr_bo_unreserve(struct dma_buf *bo)
+{
+	spin_lock(&dmabufmgr.lru_lock);
+	dmabufmgr_bo_unreserve_locked(bo);
+	spin_unlock(&dmabufmgr.lru_lock);
+}
+EXPORT_SYMBOL_GPL(dmabufmgr_bo_unreserve);
diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index 24e88fe..01c4f71 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -40,6 +40,9 @@ static int dma_buf_release(struct inode *inode, struct file *file)
 	dmabuf = file->private_data;
 
 	dmabuf->ops->release(dmabuf);
+	BUG_ON(waitqueue_active(&dmabuf->event_queue));
+	if (dmabuf->sync_buf)
+		dma_buf_put(dmabuf->sync_buf);
 	kfree(dmabuf);
 	return 0;
 }
@@ -119,6 +122,7 @@ struct dma_buf *dma_buf_export(void *priv, const struct dma_buf_ops *ops,
 
 	mutex_init(&dmabuf->lock);
 	INIT_LIST_HEAD(&dmabuf->attachments);
+	init_waitqueue_head(&dmabuf->event_queue);
 
 	return dmabuf;
 }
diff --git a/include/linux/dma-buf-mgr.h b/include/linux/dma-buf-mgr.h
new file mode 100644
index 0000000..8caadc8
--- /dev/null
+++ b/include/linux/dma-buf-mgr.h
@@ -0,0 +1,150 @@
+/*
+ * Header file for dma buffer sharing framework.
+ *
+ * Copyright(C) 2011 Linaro Limited. All rights reserved.
+ * Author: Sumit Semwal <sumit.semwal@ti.com>
+ *
+ * Many thanks to linaro-mm-sig list, and specially
+ * Arnd Bergmann <arnd@arndb.de>, Rob Clark <rob@ti.com> and
+ * Daniel Vetter <daniel@ffwll.ch> for their support in creation and
+ * refining of this idea.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __DMA_BUF_MGR_H__
+#define __DMA_BUF_MGR_H__
+
+#include <linux/dma-buf.h>
+#include <linux/list.h>
+
+struct dmabufmgr {
+	spinlock_t lru_lock;
+
+	u32 counter;
+};
+extern struct dmabufmgr dmabufmgr;
+
+/** execbuf util support for reservations
+ * based on ttm_execbuf_util
+ */
+struct dmabufmgr_validate {
+	struct list_head head;
+	struct dma_buf *bo;
+	bool reserved;
+	void *priv;
+
+	/** synchronization dma_buf + ofs/val to wait on */
+	struct dma_buf *sync_buf;
+	u32 sync_ofs, sync_val;
+
+	/** status returned from dmabufmgr_eu_wait_completed_cpu */
+	bool waited;
+	u32 retval;
+};
+
+#ifdef CONFIG_DMA_SHARED_BUFFER
+
+extern int
+dmabufmgr_bo_reserve_locked(struct dma_buf *bo,
+			    bool interruptible, bool no_wait,
+			    bool use_sequence, u32 sequence);
+
+extern int
+dmabufmgr_bo_reserve(struct dma_buf *bo,
+		     bool interruptible, bool no_wait,
+		     bool use_sequence, u32 sequence);
+
+extern void
+dmabufmgr_bo_unreserve_locked(struct dma_buf *bo);
+
+extern void
+dmabufmgr_bo_unreserve(struct dma_buf *bo);
+
+extern int
+dmabufmgr_bo_wait_unreserved(struct dma_buf *bo, bool interruptible);
+
+/** reserve a linked list of struct dmabufmgr_validate entries */
+extern int
+dmabufmgr_eu_reserve_buffers(struct list_head *list);
+
+/** Undo reservation */
+extern void
+dmabufmgr_eu_backoff_reservation(struct list_head *list);
+
+/** Commit reservation */
+extern void
+dmabufmgr_eu_fence_buffer_objects(struct dma_buf *sync_buf, u32 ofs, u32 val, struct list_head *list);
+
+/** Wait for completion on cpu
+ * intr: interruptible wait
+ * lazy: try once every tick instead of busywait
+ */
+extern int
+dmabufmgr_eu_wait_completed_cpu(struct list_head *list, bool intr, bool lazy);
+
+#else /* CONFIG_DMA_SHARED_BUFFER */
+
+static inline int
+dmabufmgr_bo_reserve_locked(struct dma_buf *bo,
+			    bool interruptible, bool no_wait,
+			    bool use_sequence, u32 sequence)
+{
+	return -ENODEV;
+}
+
+static inline int
+dmabufmgr_bo_reserve(struct dma_buf *bo,
+		     bool interruptible, bool no_wait,
+		     bool use_sequence, u32 sequence)
+{
+	return -ENODEV;
+}
+
+static inline void
+dmabufmgr_bo_unreserve_locked(struct dma_buf *bo)
+{}
+
+static inline void
+dmabufmgr_bo_unreserve(struct dma_buf *bo)
+{}
+
+static inline int
+dmabufmgr_bo_wait_unreserved(struct dma_buf *bo, bool interruptible)
+{}
+
+/** reserve a linked list of struct dmabufmgr_validate entries */
+static inline int
+dmabufmgr_eu_reserve_buffers(struct list_head *list)
+{
+	return list_empty(list) ? 0 : -ENODEV;
+}
+
+/** Undo reservation */
+static inline void
+dmabufmgr_eu_backoff_reservation(struct list_head *list)
+{}
+
+/** Commit reservation */
+static inline void
+dmabufmgr_eu_fence_buffer_objects(struct dma_buf *sync_buf, u32 ofs, u32 val, struct list_head *list)
+{}
+
+static inline int
+dmabufmgr_eu_wait_completed_cpu(struct list_head *list, bool intr, bool lazy)
+{
+	return list_empty(list) ? 0 : -ENODEV;
+}
+
+#endif /* CONFIG_DMA_SHARED_BUFFER */
+
+#endif /* __DMA_BUF_MGR_H__ */
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index eb48f38..544644d 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -113,6 +113,8 @@ struct dma_buf_ops {
  * @attachments: list of dma_buf_attachment that denotes all devices attached.
  * @ops: dma_buf_ops associated with this buffer object.
  * @priv: exporter specific private data for this buffer object.
+ * @bufmgr_entry: used by dmabufmgr
+ * @bufdev: used by dmabufmgr
  */
 struct dma_buf {
 	size_t size;
@@ -122,6 +124,28 @@ struct dma_buf {
 	/* mutex to serialize list manipulation and attach/detach */
 	struct mutex lock;
 	void *priv;
+
+	/** dmabufmgr members */
+	wait_queue_head_t event_queue;
+
+	/**
+	 * dmabufmgr members protected by the dmabufmgr::lru_lock.
+	 */
+	u32 val_seq;
+	bool seq_valid;
+
+	/** sync_buf can be set to 0 with just dmabufmgr::lru_lock held,
+	 * but can only be set to non-null when unreserving with
+	 * dmabufmgr::lru_lock held
+	 */
+	struct dma_buf *sync_buf;
+	u32 sync_ofs, sync_val;
+
+	/**
+	 * dmabufmgr members protected by the dmabufmgr::lru_lock
+	 * only when written to.
+	 */
+	atomic_t reserved;
 };
 
 /**
-- 
1.7.9.5


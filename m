Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab2HVLua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 07:50:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35333 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab2HVLu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 07:50:26 -0400
Message-ID: <5034C77C.9050501@canonical.com>
Date: Wed, 22 Aug 2012 13:50:20 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: sumit.semwal@linaro.org, rob.clark@linaro.org,
        Daniel Vetter <daniel@ffwll.ch>, thellstrom@vmware.com,
        jakob@vmware.com
CC: linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: [RFC patch 4/4] Re: dma-buf-mgr: multiple dma-buf synchronization
 (v3)
References: <20120810145728.5490.44707.stgit@patser.local> <20120810145804.5490.14858.stgit@patser.local> <20120815231246.GI5533@phenom.ffwll.local>
In-Reply-To: <20120815231246.GI5533@phenom.ffwll.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Dan,

Op 16-08-12 01:12, Daniel Vetter schreef:
> Hi Maarten,
>
> Ok, here comes the promised review (finally!), but it's rather a
> high-level thingy. I've mostly thought about how we could create a neat
> api with the following points. For a bit of clarity, I've grouped the
> different considerations a bit.
> <snip>

Thanks, I have significantly reworked the api based on your comments.

Documentation is currently lacking, and will get updated again for the final version.

Full patch series also includes some ttm changes to make use of dma-reservation,
with the intention of moving out fencing from ttm too, but that requires more work.

For the full series see:
http://cgit.freedesktop.org/~mlankhorst/linux/log/?h=v10-wip

My plan is to add a pointer for dma_reservation to a dma-buf,
so all users of dma-reservation can perform reservations across
multiple devices as well. Since the default for ttm likely will
mean only a few buffers are shared I didn't want to complicate
the abi for ttm much further so only added a pointer that can be
null to use ttm's reservation_object structure.

The major difference with ttm is that each reservation object
gets its own lock for fencing and reservations, but they can
be merged:

spin_lock(obj->resv)
__dma_object_reserve()
grab a ref to all obj->fences
spin_unlock(obj->resv)

spin_lock(obj->resv)
assign new fence to obj->fences
__dma_object_unreserve()
spin_unlock(obj->resv)

There's only one thing about fences I haven't been able to map
yet properly. vmwgfx has sync_obj_flush, but as far as I can
tell it has not much to do with sync objects, but is rather a
generic 'flush before release'. Maybe one of the vmwgfx devs
could confirm whether that call is really needed there? And if
so, if there could be some other way do that, because it seems
to be the ttm_bo_wait call before that would be enough, if not
it might help more to move the flush to some other call.

PS: For ttm devs some of the code may look familiar, I don't know
if the kernel accepts I-told-you-so tag or not, but if it does
you might want to add them now. :-)

PPS: I'm aware that I still need to add a signaled op to fences

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 030f705..7da9637 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -129,6 +129,8 @@ X!Edrivers/base/interface.c
 !Edrivers/base/dma-fence.c
 !Iinclude/linux/dma-fence.h
 !Iinclude/linux/dma-seqno-fence.h
+!Edrivers/base/dma-reservation.c
+!Iinclude/linux/dma-reservation.h
 !Edrivers/base/dma-coherent.c
 !Edrivers/base/dma-mapping.c
      </sect1>
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 6e9f217..b26e639 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_CMA) += dma-contiguous.o
 obj-y			+= power/
 obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
 obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
-obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o dma-fence.o
+obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o dma-fence.o dma-reservation.o
 obj-$(CONFIG_ISA)	+= isa.o
 obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
 obj-$(CONFIG_NUMA)	+= node.o
diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index 24e88fe..3c84ead 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -25,8 +25,10 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-fence.h>
 #include <linux/anon_inodes.h>
 #include <linux/export.h>
+#include <linux/dma-reservation.h>
 
 static inline int is_dma_buf_file(struct file *);
 
@@ -40,6 +42,9 @@ static int dma_buf_release(struct inode *inode, struct file *file)
 	dmabuf = file->private_data;
 
 	dmabuf->ops->release(dmabuf);
+
+	if (dmabuf->resv == (struct dma_reservation_object*)&dmabuf[1])
+		dma_reservation_object_fini(dmabuf->resv);
 	kfree(dmabuf);
 	return 0;
 }
@@ -94,6 +99,8 @@ struct dma_buf *dma_buf_export(void *priv, const struct dma_buf_ops *ops,
 {
 	struct dma_buf *dmabuf;
 	struct file *file;
+	size_t alloc_size = sizeof(struct dma_buf);
+	alloc_size += sizeof(struct dma_reservation_object);
 
 	if (WARN_ON(!priv || !ops
 			  || !ops->map_dma_buf
@@ -105,13 +112,15 @@ struct dma_buf *dma_buf_export(void *priv, const struct dma_buf_ops *ops,
 		return ERR_PTR(-EINVAL);
 	}
 
-	dmabuf = kzalloc(sizeof(struct dma_buf), GFP_KERNEL);
+	dmabuf = kzalloc(alloc_size, GFP_KERNEL);
 	if (dmabuf == NULL)
 		return ERR_PTR(-ENOMEM);
 
 	dmabuf->priv = priv;
 	dmabuf->ops = ops;
 	dmabuf->size = size;
+	dmabuf->resv = (struct dma_reservation_object*)&dmabuf[1];
+	dma_reservation_object_init(dmabuf->resv);
 
 	file = anon_inode_getfile("dmabuf", &dma_buf_fops, dmabuf, flags);
 
diff --git a/drivers/base/dma-reservation.c b/drivers/base/dma-reservation.c
new file mode 100644
index 0000000..e7cf4fa
--- /dev/null
+++ b/drivers/base/dma-reservation.c
@@ -0,0 +1,321 @@
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
+#include <linux/dma-fence.h>
+#include <linux/dma-reservation.h>
+#include <linux/export.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+
+atomic64_t dma_reservation_counter = ATOMIC64_INIT(0);
+EXPORT_SYMBOL_GPL(dma_reservation_counter);
+
+int
+__dma_object_reserve(struct dma_reservation_object *obj, bool intr,
+		     bool no_wait, dma_reservation_ticket_t *ticket)
+{
+	int ret;
+	u64 sequence = ticket ? ticket->seqno : 0;
+
+	while (unlikely(atomic_cmpxchg(&obj->reserved, 0, 1) != 0)) {
+		/**
+		 * Deadlock avoidance for multi-dmabuf reserving.
+		 */
+		if (sequence && obj->sequence) {
+			/**
+			 * We've already reserved this one.
+			 */
+			if (unlikely(sequence == obj->sequence))
+				return -EDEADLK;
+			/**
+			 * Already reserved by a thread that will not back
+			 * off for us. We need to back off.
+			 */
+			if (unlikely(sequence - obj->sequence < (1ULL << 63)))
+				return -EAGAIN;
+		}
+
+		if (no_wait)
+			return -EBUSY;
+
+		spin_unlock(&obj->lock);
+		ret = dma_object_wait_unreserved(obj, intr);
+		spin_lock(&obj->lock);
+
+		if (unlikely(ret))
+			return ret;
+	}
+
+	/**
+	 * Wake up waiters that may need to recheck for deadlock,
+	 * if we decreased the sequence number.
+	 */
+	if (sequence && unlikely((obj->sequence - sequence < (1ULL << 63)) ||
+	    !obj->sequence))
+		wake_up_all(&obj->event_queue);
+
+	obj->sequence = sequence;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__dma_object_reserve);
+
+int
+dma_object_reserve(struct dma_reservation_object *obj, bool intr,
+		   bool no_wait, dma_reservation_ticket_t *ticket)
+{
+	int ret;
+
+	spin_lock(&obj->lock);
+	ret = __dma_object_reserve(obj, intr, no_wait, ticket);
+	spin_unlock(&obj->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dma_object_reserve);
+
+int
+dma_object_wait_unreserved(struct dma_reservation_object *obj, bool intr)
+{
+	if (intr) {
+		return wait_event_interruptible(obj->event_queue,
+				atomic_read(&obj->reserved) == 0);
+	} else {
+		wait_event(obj->event_queue,
+			   atomic_read(&obj->reserved) == 0);
+		return 0;
+	}
+}
+EXPORT_SYMBOL_GPL(dma_object_wait_unreserved);
+
+void
+__dma_object_unreserve(struct dma_reservation_object *obj,
+		       dma_reservation_ticket_t *ticket)
+{
+	atomic_set(&obj->reserved, 0);
+	wake_up_all(&obj->event_queue);
+}
+EXPORT_SYMBOL_GPL(__dma_object_unreserve);
+
+void
+dma_object_unreserve(struct dma_reservation_object *obj,
+		     dma_reservation_ticket_t *ticket)
+{
+	spin_lock(&obj->lock);
+	__dma_object_unreserve(obj, ticket);
+	spin_unlock(&obj->lock);
+}
+EXPORT_SYMBOL_GPL(dma_object_unreserve);
+
+/**
+ * dma_ticket_backoff - cancel a reservation
+ * @ticket:	[in] a dma_reservation_ticket
+ * @entries:	[in] the list list of dma_reservation_entry entries to unreserve
+ *
+ * This function cancels a previous reservation done by
+ * dma_ticket_reserve. This is useful in case something
+ * goes wrong between reservation and committing.
+ *
+ * This should only be called after dma_ticket_reserve returns success.
+ *
+ * Please read Documentation/dma-buf-synchronization.txt
+ */
+void
+dma_ticket_backoff(struct dma_reservation_ticket *ticket, struct list_head *entries)
+{
+	struct list_head *cur;
+
+	if (list_empty(entries))
+		return;
+
+	list_for_each(cur, entries) {
+		struct dma_reservation_object *obj;
+
+		dma_reservation_entry_get(cur, &obj, NULL);
+
+		dma_object_unreserve(obj, ticket);
+	}
+	dma_reservation_ticket_fini(ticket);
+}
+EXPORT_SYMBOL_GPL(dma_ticket_backoff);
+
+static void
+dma_ticket_backoff_early(struct dma_reservation_ticket *ticket,
+			 struct list_head *list,
+			 struct dma_reservation_entry *entry)
+{
+	list_for_each_entry_continue_reverse(entry, list, head) {
+		struct dma_reservation_object *obj;
+
+		dma_reservation_entry_get(&entry->head, &obj, NULL);
+		dma_object_unreserve(obj, ticket);
+	}
+	dma_reservation_ticket_fini(ticket);
+}
+
+/**
+ * dma_ticket_reserve - reserve a list of dma_reservation_entry
+ * @ticket:	[out]	a dma_reservation_ticket
+ * @entries:	[in]	a list of entries to reserve.
+ *
+ * Do not initialize ticket, it will be initialized by this function.
+ *
+ * XXX: Nuke rest
+ * The caller will have to queue waits on those fences before calling
+ * dmabufmgr_fence_buffer_objects, with either hardware specific methods,
+ * dma_fence_add_callback will, or dma_fence_wait.
+ *
+ * As such, by incrementing refcount on dma_reservation_entry before calling
+ * dma_fence_add_callback, and making the callback decrement refcount on
+ * dma_reservation_entry, or releasing refcount if dma_fence_add_callback
+ * failed, the dma_reservation_entry will be freed when all the fences
+ * have been signaled, and only after the last ref is released, which should
+ * be after dmabufmgr_fence_buffer_objects. With proper locking, when the
+ * list_head holding the list of dma_reservation_entry's becomes empty it
+ * indicates all fences for all dma-bufs have been signaled.
+ *
+ * Please read Documentation/dma-buf-synchronization.txt
+ */
+int
+dma_ticket_reserve(struct dma_reservation_ticket *ticket,
+		   struct list_head *entries)
+{
+	struct list_head *cur;
+	int ret;
+
+	if (list_empty(entries))
+		return 0;
+
+retry:
+	dma_reservation_ticket_init(ticket);
+
+	list_for_each(cur, entries) {
+		struct dma_reservation_entry *entry;
+		struct dma_reservation_object *bo;
+		bool shared;
+
+		entry = dma_reservation_entry_get(cur, &bo, &shared);
+
+		ret = dma_object_reserve(bo, true, false, ticket);
+		switch (ret) {
+		case 0:
+			break;
+		case -EAGAIN:
+			dma_ticket_backoff_early(ticket, entries, entry);
+			ret = dma_object_wait_unreserved(bo, true);
+			if (unlikely(ret != 0))
+				return ret;
+			goto retry;
+		default:
+			dma_ticket_backoff_early(ticket, entries, entry);
+			return ret;
+		}
+
+		if (shared &&
+		    bo->fence_shared_count == DMA_BUF_MAX_SHARED_FENCE) {
+			WARN_ON_ONCE(1);
+			dma_ticket_backoff_early(ticket, entries, entry);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dma_ticket_reserve);
+
+/**
+ * dma_ticket_commit - commit a reservation with a new fence
+ * @ticket:	[in]	the dma_reservation_ticket returned by
+ * dma_ticket_reserve
+ * @entries:	[in]	a linked list of struct dma_reservation_entry
+ * @fence:	[in]	the fence that indicates completion
+ *
+ * This function will call dma_reservation_ticket_fini, no need
+ * to do it manually.
+ *
+ * This function should be called after a hardware command submission is
+ * completed succesfully. The fence is used to indicate completion of
+ * those commands.
+ *
+ * Please read Documentation/dma-buf-synchronization.txt
+ */
+void
+dma_ticket_commit(struct dma_reservation_ticket *ticket,
+		  struct list_head *entries, struct dma_fence *fence)
+{
+	struct list_head *cur;
+
+	if (list_empty(entries))
+		return;
+
+	if (WARN_ON(!fence)) {
+		dma_ticket_backoff(ticket, entries);
+		return;
+	}
+
+	list_for_each(cur, entries) {
+		struct dma_reservation_object *bo;
+		bool shared;
+
+		dma_reservation_entry_get(cur, &bo, &shared);
+
+		spin_lock(&bo->lock);
+
+		if (!shared) {
+			int i;
+			for (i = 0; i < bo->fence_shared_count; ++i) {
+				dma_fence_put(bo->fence_shared[i]);
+				bo->fence_shared[i] = NULL;
+			}
+			bo->fence_shared_count = 0;
+			if (bo->fence_excl)
+				dma_fence_put(bo->fence_excl);
+
+			bo->fence_excl = fence;
+		} else {
+			if (WARN_ON(bo->fence_shared_count >=
+				    ARRAY_SIZE(bo->fence_shared))) {
+				spin_unlock(&bo->lock);
+				continue;
+			}
+
+			bo->fence_shared[bo->fence_shared_count++] = fence;
+		}
+		dma_fence_get(fence);
+
+		__dma_object_unreserve(bo, ticket);
+		spin_unlock(&bo->lock);
+	}
+	dma_reservation_ticket_fini(ticket);
+}
+EXPORT_SYMBOL_GPL(dma_ticket_commit);
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index bd2e52c..dee44dd 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -122,6 +122,7 @@ struct dma_buf {
 	/* mutex to serialize list manipulation and attach/detach */
 	struct mutex lock;
 	void *priv;
+	struct dma_reservation_object *resv;
 };
 
 /**
diff --git a/include/linux/dma-reservation.h b/include/linux/dma-reservation.h
new file mode 100644
index 0000000..b8798c1
--- /dev/null
+++ b/include/linux/dma-reservation.h
@@ -0,0 +1,170 @@
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
+#ifndef __DMA_RESERVATION_H__
+#define __DMA_RESERVATION_H__
+
+#define DMA_BUF_MAX_SHARED_FENCE 8
+
+#include <linux/dma-fence.h>
+
+extern atomic64_t dma_reservation_counter;
+
+struct dma_reservation_object {
+	wait_queue_head_t event_queue;
+	spinlock_t lock;
+
+	atomic_t reserved;
+
+	u64 sequence;
+	u32 fence_shared_count;
+	struct dma_fence *fence_excl;
+	struct dma_fence *fence_shared[DMA_BUF_MAX_SHARED_FENCE];
+};
+
+typedef struct dma_reservation_ticket {
+	u64 seqno;
+} dma_reservation_ticket_t;
+
+/**
+ * struct dma_reservation_entry - reservation structure for a
+ * dma_reservation_object
+ * @head:	list entry
+ * @obj_shared:	pointer to a dma_reservation_object to reserve
+ *
+ * Bit 0 of obj_shared is set to bool shared, as such pointer has to be
+ * converted back, which can be done with dma_reservation_entry_get.
+ */
+struct dma_reservation_entry {
+	struct list_head head;
+	unsigned long obj_shared;
+};
+
+
+static inline void
+__dma_reservation_object_init(struct dma_reservation_object *obj)
+{
+	init_waitqueue_head(&obj->event_queue);
+	spin_lock_init(&obj->lock);
+}
+
+static inline void
+dma_reservation_object_init(struct dma_reservation_object *obj)
+{
+	memset(obj, 0, sizeof(*obj));
+	__dma_reservation_object_init(obj);
+}
+
+static inline void
+dma_reservation_object_fini(struct dma_reservation_object *obj)
+{
+	int i;
+
+	BUG_ON(waitqueue_active(&obj->event_queue));
+	BUG_ON(atomic_read(&obj->reserved));
+
+	if (obj->fence_excl)
+		dma_fence_put(obj->fence_excl);
+	for (i = 0; i < obj->fence_shared_count; ++i)
+		dma_fence_put(obj->fence_shared[i]);
+}
+
+static inline void
+dma_reservation_ticket_init(struct dma_reservation_ticket *t)
+{
+	do {
+		t->seqno = atomic64_inc_return(&dma_reservation_counter);
+	} while (unlikely(!t->seqno));
+}
+
+/**
+ * dma_reservation_ticket_fini - end a reservation ticket
+ * @t:	[in]	dma_reservation_ticket that completed all reservations
+ *
+ * This currently does nothing, but should be called after all reservations
+ * made with this ticket have been unreserved. It is likely that in the future
+ * it will be hooked up to perf events, or aid in debugging in other ways.
+ */
+static inline void
+dma_reservation_ticket_fini(struct dma_reservation_ticket *t)
+{ }
+
+/**
+ * dma_reservation_entry_init - initialize and append a dma_reservation_entry
+ * to the list
+ * @entry:	entry to initialize
+ * @list:	list to append to
+ * @obj:	dma_reservation_object to initialize the entry with
+ * @shared:	whether shared or exclusive access is requested
+ */
+static inline void
+dma_reservation_entry_init(struct dma_reservation_entry *entry,
+			   struct list_head *list,
+			   struct dma_reservation_object *obj, bool shared)
+{
+	entry->obj_shared = (unsigned long)obj | !!shared;
+}
+
+static inline struct dma_reservation_entry *
+dma_reservation_entry_get(struct list_head *list,
+			  struct dma_reservation_object **obj, bool *shared)
+{
+	struct dma_reservation_entry *e = container_of(list, struct dma_reservation_entry, head);
+	unsigned long val = e->obj_shared;
+
+	if (obj)
+		*obj = (struct dma_reservation_object*)(val & ~1);
+	if (shared)
+		*shared = val & 1;
+	return e;
+}
+
+extern int
+__dma_object_reserve(struct dma_reservation_object *obj,
+				 bool intr, bool no_wait,
+				 dma_reservation_ticket_t *ticket);
+
+extern int
+dma_object_reserve(struct dma_reservation_object *obj,
+			       bool intr, bool no_wait,
+			       dma_reservation_ticket_t *ticket);
+
+extern void
+__dma_object_unreserve(struct dma_reservation_object *,
+				 dma_reservation_ticket_t *ticket);
+
+extern void
+dma_object_unreserve(struct dma_reservation_object *,
+				 dma_reservation_ticket_t *ticket);
+
+extern int
+dma_object_wait_unreserved(struct dma_reservation_object *, bool intr);
+
+extern int dma_ticket_reserve(struct dma_reservation_ticket *,
+					  struct list_head *entries);
+extern void dma_ticket_backoff(struct dma_reservation_ticket *,
+			       struct list_head *entries);
+extern void dma_ticket_commit(struct dma_reservation_ticket *,
+			      struct list_head *entries, struct dma_fence *);
+
+#endif /* __DMA_BUF_MGR_H__ */


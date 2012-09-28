Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab2I1NEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:04:39 -0400
Received: from adelie.canonical.com ([91.189.90.139]:52420 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757695Ab2I1NDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:03:14 -0400
Subject: [PATCH 4/5] reservation: cross-device reservation support
To: jakob@vmware.com, thellstrom@vmware.com, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
        linux-media@vger.kernel.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 28 Sep 2012 14:43:13 +0200
Message-ID: <20120928124313.14366.44686.stgit@patser.local>
In-Reply-To: <20120928124148.14366.21063.stgit@patser.local>
References: <20120928124148.14366.21063.stgit@patser.local>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for a generic reservations framework that can be
hooked up to ttm and dma-buf and allows easy sharing of reservations
across devices.

The idea is that a dma-buf and ttm object both will get a pointer
to a struct reservation_object, which has to be reserved before
anything is done with the buffer.

Some followup patches are needed in ttm so the lru_lock is no longer
taken during the reservation step. This makes the lockdep annotation
patch a lot more useful, and the assumption that the lru lock protects
atomic removal off the lru list will fail soon, anyway.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 Documentation/DocBook/device-drivers.tmpl |    2 
 drivers/base/Makefile                     |    2 
 drivers/base/reservation.c                |  285 +++++++++++++++++++++++++++++
 include/linux/reservation.h               |  179 ++++++++++++++++++
 4 files changed, 467 insertions(+), 1 deletion(-)
 create mode 100644 drivers/base/reservation.c
 create mode 100644 include/linux/reservation.h

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index ad14396..24e6e80 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -129,6 +129,8 @@ X!Edrivers/base/interface.c
 !Edrivers/base/fence.c
 !Iinclude/linux/fence.h
 !Iinclude/linux/seqno-fence.h
+!Edrivers/base/reservation.c
+!Iinclude/linux/reservation.h
 !Edrivers/base/dma-coherent.c
 !Edrivers/base/dma-mapping.c
      </sect1>
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 0026563..f6f731d 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_CMA) += dma-contiguous.o
 obj-y			+= power/
 obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
 obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
-obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o fence.o
+obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o fence.o reservation.o
 obj-$(CONFIG_ISA)	+= isa.o
 obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
 obj-$(CONFIG_NUMA)	+= node.o
diff --git a/drivers/base/reservation.c b/drivers/base/reservation.c
new file mode 100644
index 0000000..93e2d9f
--- /dev/null
+++ b/drivers/base/reservation.c
@@ -0,0 +1,285 @@
+/*
+ * Copyright (C) 2012 Canonical Ltd
+ *
+ * Based on bo.c which bears the following copyright notice,
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
+#include <linux/fence.h>
+#include <linux/reservation.h>
+#include <linux/export.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+
+atomic64_t reservation_counter = ATOMIC64_INIT(1);
+EXPORT_SYMBOL(reservation_counter);
+
+int
+object_reserve(struct reservation_object *obj, bool intr, bool no_wait,
+	       reservation_ticket_t *ticket)
+{
+	int ret;
+	u64 sequence = ticket ? ticket->seqno : 1;
+	u64 oldseq;
+
+	while (unlikely(oldseq = atomic64_cmpxchg(&obj->reserved, 0, sequence))) {
+
+		/**
+		 * Deadlock avoidance for multi-obj reserving.
+		 */
+		if (sequence > 1 && oldseq > 1) {
+			/**
+			 * We've already reserved this one.
+			 */
+			if (unlikely(sequence == oldseq))
+				return -EDEADLK;
+			/**
+			 * Already reserved by a thread that will not back
+			 * off for us. We need to back off.
+			 */
+			if (unlikely(sequence - oldseq < (1ULL << 63)))
+				return -EAGAIN;
+		}
+
+		if (no_wait)
+			return -EBUSY;
+
+		ret = object_wait_unreserved(obj, intr);
+
+		if (unlikely(ret))
+			return ret;
+	}
+
+	/**
+	 * Wake up waiters that may need to recheck for deadlock,
+	 * if we decreased the sequence number.
+	 */
+	wake_up_all(&obj->event_queue);
+
+	return 0;
+}
+EXPORT_SYMBOL(object_reserve);
+
+int
+object_wait_unreserved(struct reservation_object *obj, bool intr)
+{
+	if (intr) {
+		return wait_event_interruptible(obj->event_queue,
+				!object_is_reserved(obj));
+	} else {
+		wait_event(obj->event_queue,
+			   !object_is_reserved(obj));
+		return 0;
+	}
+}
+EXPORT_SYMBOL(object_wait_unreserved);
+
+void
+object_unreserve(struct reservation_object *obj,
+		 reservation_ticket_t *ticket)
+{
+	smp_mb();
+	atomic64_set(&obj->reserved, 0);
+	wake_up_all(&obj->event_queue);
+}
+EXPORT_SYMBOL(object_unreserve);
+
+/**
+ * ticket_backoff - cancel a reservation
+ * @ticket:	[in] a reservation_ticket
+ * @entries:	[in] the list list of reservation_entry entries to unreserve
+ *
+ * This function cancels a previous reservation done by
+ * ticket_reserve. This is useful in case something
+ * goes wrong between reservation and committing.
+ *
+ * This should only be called after ticket_reserve returns success.
+ */
+void
+ticket_backoff(struct reservation_ticket *ticket, struct list_head *entries)
+{
+	struct list_head *cur;
+
+	if (list_empty(entries))
+		return;
+
+	list_for_each(cur, entries) {
+		struct reservation_object *obj;
+
+		reservation_entry_get(cur, &obj, NULL);
+
+		object_unreserve(obj, ticket);
+	}
+	reservation_ticket_fini(ticket);
+}
+EXPORT_SYMBOL(ticket_backoff);
+
+static void
+ticket_backoff_early(struct reservation_ticket *ticket,
+			 struct list_head *list,
+			 struct reservation_entry *entry)
+{
+	list_for_each_entry_continue_reverse(entry, list, head) {
+		struct reservation_object *obj;
+
+		reservation_entry_get(&entry->head, &obj, NULL);
+		object_unreserve(obj, ticket);
+	}
+	reservation_ticket_fini(ticket);
+}
+
+/**
+ * ticket_reserve - reserve a list of reservation_entry
+ * @ticket:	[out]	a reservation_ticket
+ * @entries:	[in]	a list of entries to reserve.
+ *
+ * Do not initialize ticket, it will be initialized by this function.
+ *
+ * XXX: Nuke rest
+ * The caller will have to queue waits on those fences before calling
+ * ufmgr_fence_buffer_objects, with either hardware specific methods,
+ * fence_add_callback will, or fence_wait.
+ *
+ * As such, by incrementing refcount on reservation_entry before calling
+ * fence_add_callback, and making the callback decrement refcount on
+ * reservation_entry, or releasing refcount if fence_add_callback
+ * failed, the reservation_entry will be freed when all the fences
+ * have been signaled, and only after the last ref is released, which should
+ * be after ufmgr_fence_buffer_objects. With proper locking, when the
+ * list_head holding the list of reservation_entry's becomes empty it
+ * indicates all fences for all bufs have been signaled.
+ */
+int
+ticket_reserve(struct reservation_ticket *ticket,
+		   struct list_head *entries)
+{
+	struct list_head *cur;
+	int ret;
+
+	if (list_empty(entries))
+		return 0;
+
+retry:
+	reservation_ticket_init(ticket);
+
+	list_for_each(cur, entries) {
+		struct reservation_entry *entry;
+		struct reservation_object *bo;
+		bool shared;
+
+		entry = reservation_entry_get(cur, &bo, &shared);
+
+		ret = object_reserve(bo, true, false, ticket);
+		switch (ret) {
+		case 0:
+			break;
+		case -EAGAIN:
+			ticket_backoff_early(ticket, entries, entry);
+			ret = object_wait_unreserved(bo, true);
+			if (unlikely(ret != 0))
+				return ret;
+			goto retry;
+		default:
+			ticket_backoff_early(ticket, entries, entry);
+			return ret;
+		}
+
+		if (shared &&
+		    bo->fence_shared_count == BUF_MAX_SHARED_FENCE) {
+			WARN_ON_ONCE(1);
+			ticket_backoff_early(ticket, entries, entry);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ticket_reserve);
+
+/**
+ * ticket_commit - commit a reservation with a new fence
+ * @ticket:	[in]	the reservation_ticket returned by
+ * ticket_reserve
+ * @entries:	[in]	a linked list of struct reservation_entry
+ * @fence:	[in]	the fence that indicates completion
+ *
+ * This function will call reservation_ticket_fini, no need
+ * to do it manually.
+ *
+ * This function should be called after a hardware command submission is
+ * completed succesfully. The fence is used to indicate completion of
+ * those commands.
+ */
+void
+ticket_commit(struct reservation_ticket *ticket,
+		  struct list_head *entries, struct fence *fence)
+{
+	struct list_head *cur;
+
+	if (list_empty(entries))
+		return;
+
+	if (WARN_ON(!fence)) {
+		ticket_backoff(ticket, entries);
+		return;
+	}
+
+	list_for_each(cur, entries) {
+		struct reservation_object *bo;
+		bool shared;
+
+		reservation_entry_get(cur, &bo, &shared);
+
+		if (!shared) {
+			int i;
+			for (i = 0; i < bo->fence_shared_count; ++i) {
+				fence_put(bo->fence_shared[i]);
+				bo->fence_shared[i] = NULL;
+			}
+			bo->fence_shared_count = 0;
+			if (bo->fence_excl)
+				fence_put(bo->fence_excl);
+
+			bo->fence_excl = fence;
+		} else {
+			if (WARN_ON(bo->fence_shared_count >=
+				    ARRAY_SIZE(bo->fence_shared))) {
+				continue;
+			}
+
+			bo->fence_shared[bo->fence_shared_count++] = fence;
+		}
+		fence_get(fence);
+
+		object_unreserve(bo, ticket);
+	}
+	reservation_ticket_fini(ticket);
+}
+EXPORT_SYMBOL(ticket_commit);
diff --git a/include/linux/reservation.h b/include/linux/reservation.h
new file mode 100644
index 0000000..93280af
--- /dev/null
+++ b/include/linux/reservation.h
@@ -0,0 +1,179 @@
+/*
+ * Header file for reservations for dma-buf and ttm
+ *
+ * Copyright(C) 2011 Linaro Limited. All rights reserved.
+ * Copyright (C) 2012 Canonical Ltd
+ * Copyright (C) 2012 Texas Instruments
+ *
+ * Authors:
+ * Rob Clark <rob.clark@linaro.org>
+ * Maarten Lankhorst <maarten.lankhorst@canonical.com>
+ * Thomas Hellstrom <thellstrom-at-vmware-dot-com>
+ *
+ * Based on bo.c which bears the following copyright notice,
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
+ */
+#ifndef __RESERVATION_H__
+#define __RESERVATION_H__
+
+#define BUF_MAX_SHARED_FENCE 8
+
+#include <linux/fence.h>
+
+extern atomic64_t reservation_counter;
+
+struct reservation_object {
+	wait_queue_head_t event_queue;
+
+	atomic64_t reserved;
+
+	u32 fence_shared_count;
+	struct fence *fence_excl;
+	struct fence *fence_shared[BUF_MAX_SHARED_FENCE];
+};
+
+typedef struct reservation_ticket {
+	u64 seqno;
+} reservation_ticket_t;
+
+/**
+ * struct reservation_entry - reservation structure for a
+ * reservation_object
+ * @head:	list entry
+ * @obj_shared:	pointer to a reservation_object to reserve
+ *
+ * Bit 0 of obj_shared is set to bool shared, as such pointer has to be
+ * converted back, which can be done with reservation_entry_get.
+ */
+struct reservation_entry {
+	struct list_head head;
+	unsigned long obj_shared;
+};
+
+
+static inline void
+__reservation_object_init(struct reservation_object *obj)
+{
+	init_waitqueue_head(&obj->event_queue);
+}
+
+static inline void
+reservation_object_init(struct reservation_object *obj)
+{
+	memset(obj, 0, sizeof(*obj));
+	__reservation_object_init(obj);
+}
+
+static inline bool
+object_is_reserved(struct reservation_object *obj)
+{
+	return !!atomic64_read(&obj->reserved);
+}
+
+static inline void
+reservation_object_fini(struct reservation_object *obj)
+{
+	int i;
+
+	BUG_ON(waitqueue_active(&obj->event_queue));
+	BUG_ON(object_is_reserved(obj));
+
+	if (obj->fence_excl)
+		fence_put(obj->fence_excl);
+	for (i = 0; i < obj->fence_shared_count; ++i)
+		fence_put(obj->fence_shared[i]);
+}
+
+static inline void
+reservation_ticket_init(struct reservation_ticket *t)
+{
+	do {
+		t->seqno = atomic64_inc_return(&reservation_counter);
+	} while (unlikely(t->seqno < 2));
+}
+
+/**
+ * reservation_ticket_fini - end a reservation ticket
+ * @t:	[in]	reservation_ticket that completed all reservations
+ *
+ * This currently does nothing, but should be called after all reservations
+ * made with this ticket have been unreserved. It is likely that in the future
+ * it will be hooked up to perf events, or aid in debugging in other ways.
+ */
+static inline void
+reservation_ticket_fini(struct reservation_ticket *t)
+{ }
+
+/**
+ * reservation_entry_init - initialize and append a reservation_entry
+ * to the list
+ * @entry:	entry to initialize
+ * @list:	list to append to
+ * @obj:	reservation_object to initialize the entry with
+ * @shared:	whether shared or exclusive access is requested
+ */
+static inline void
+reservation_entry_init(struct reservation_entry *entry,
+			   struct list_head *list,
+			   struct reservation_object *obj, bool shared)
+{
+	entry->obj_shared = (unsigned long)obj | !!shared;
+}
+
+static inline struct reservation_entry *
+reservation_entry_get(struct list_head *list,
+			  struct reservation_object **obj, bool *shared)
+{
+	struct reservation_entry *e = container_of(list, struct reservation_entry, head);
+	unsigned long val = e->obj_shared;
+
+	if (obj)
+		*obj = (struct reservation_object*)(val & ~1);
+	if (shared)
+		*shared = val & 1;
+	return e;
+}
+
+extern int
+object_reserve(struct reservation_object *obj,
+			       bool intr, bool no_wait,
+			       reservation_ticket_t *ticket);
+
+extern void
+object_unreserve(struct reservation_object *,
+				 reservation_ticket_t *ticket);
+
+extern int
+object_wait_unreserved(struct reservation_object *, bool intr);
+
+extern int ticket_reserve(struct reservation_ticket *,
+					  struct list_head *entries);
+extern void ticket_backoff(struct reservation_ticket *,
+			       struct list_head *entries);
+extern void ticket_commit(struct reservation_ticket *,
+			      struct list_head *entries, struct fence *);
+
+#endif /* __BUF_MGR_H__ */


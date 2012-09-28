Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab2I1ND3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:03:29 -0400
Received: from adelie.canonical.com ([91.189.90.139]:52454 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757430Ab2I1NDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:03:23 -0400
Subject: [PATCH 2/5] fence: dma-buf cross-device synchronization (v9)
To: jakob@vmware.com, thellstrom@vmware.com, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
        linux-media@vger.kernel.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 28 Sep 2012 14:42:24 +0200
Message-ID: <20120928124224.14366.27842.stgit@patser.local>
In-Reply-To: <20120928124148.14366.21063.stgit@patser.local>
References: <20120928124148.14366.21063.stgit@patser.local>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A fence can be attached to a buffer which is being filled or consumed
by hw, to allow userspace to pass the buffer without waiting to another
device.  For example, userspace can call page_flip ioctl to display the
next frame of graphics after kicking the GPU but while the GPU is still
rendering.  The display device sharing the buffer with the GPU would
attach a callback to get notified when the GPU's rendering-complete IRQ
fires, to update the scan-out address of the display, without having to
wake up userspace.

A fence is transient, one-shot deal.  It is allocated and attached
to one or more dma-buf's.  When the one that attached it is done, with
the pending operation, it can signal the fence:
  + fence_signal()

To have a rough approximation whether a fence is fired, call:
  + fence_is_signaled()

The dma-buf-mgr handles tracking, and waiting on, the fences associated
with a dma-buf.

The one pending on the fence can add an async callback:
  + fence_add_callback()

The callback can optionally be cancelled with:
  + fence_remove_callback()

To wait synchronously, optionally with a timeout:
  + fence_wait()
  + fence_wait_timeout()

A default software-only implementation is provided, which can be used
by drivers attaching a fence to a buffer when they have no other means
for hw sync.  But a memory backed fence is also envisioned, because it
is common that GPU's can write to, or poll on some memory location for
synchronization.  For example:

  fence = custom_get_fence(...);
  if ((seqno_fence = to_seqno_fence(fence)) != NULL) {
    dma_buf *fence_buf = fence->sync_buf;
    get_dma_buf(fence_buf);

    ... tell the hw the memory location to wait ...
    custom_wait_on(fence_buf, fence->seqno_ofs, fence->seqno);
  } else {
    /* fall-back to sw sync * /
    fence_add_callback(fence, my_cb);
  }

On SoC platforms, if some other hw mechanism is provided for synchronizing
between IP blocks, it could be supported as an alternate implementation
with it's own fence ops in a similar way.

To facilitate other non-sw implementations, the enable_signaling callback
can be used to keep track if a device not supporting hw sync is waiting
on the fence, and in this case should arrange to call fence_signal()
at some point after the condition has changed, to notify other devices
waiting on the fence.  If there are no sw waiters, this can be skipped to
avoid waking the CPU unnecessarily. The handler of the enable_signaling
op should take a refcount until the fence is signaled, then release its ref.

The intention is to provide a userspace interface (presumably via eventfd)
later, to be used in conjunction with dma-buf's mmap support for sw access
to buffers (or for userspace apps that would prefer to do their own
synchronization).

v1: Original
v2: After discussion w/ danvet and mlankhorst on #dri-devel, we decided
    that dma-fence didn't need to care about the sw->hw signaling path
    (it can be handled same as sw->sw case), and therefore the fence->ops
    can be simplified and more handled in the core.  So remove the signal,
    add_callback, cancel_callback, and wait ops, and replace with a simple
    enable_signaling() op which can be used to inform a fence supporting
    hw->hw signaling that one or more devices which do not support hw
    signaling are waiting (and therefore it should enable an irq or do
    whatever is necessary in order that the CPU is notified when the
    fence is passed).
v3: Fix locking fail in attach_fence() and get_fence()
v4: Remove tie-in w/ dma-buf..  after discussion w/ danvet and mlankorst
    we decided that we need to be able to attach one fence to N dma-buf's,
    so using the list_head in dma-fence struct would be problematic.
v5: [ Maarten Lankhorst ] Updated for dma-bikeshed-fence and dma-buf-manager.
v6: [ Maarten Lankhorst ] I removed dma_fence_cancel_callback and some comments
    about checking if fence fired or not. This is broken by design.
    waitqueue_active during destruction is now fatal, since the signaller
    should be holding a reference in enable_signalling until it signalled
    the fence. Pass the original dma_fence_cb along, and call __remove_wait
    in the dma_fence_callback handler, so that no cleanup needs to be
    performed.
v7: [ Maarten Lankhorst ] Set cb->func and only enable sw signaling if
    fence wasn't signaled yet, for example for hardware fences that may
    choose to signal blindly.
v8: [ Maarten Lankhorst ] Tons of tiny fixes, moved __dma_fence_init to
    header and fixed include mess. dma-fence.h now includes dma-buf.h
    All members are now initialized, so kmalloc can be used for
    allocating a dma-fence. More documentation added.
v9: Change compiler bitfields to flags, change return type of
    enable_signaling to bool. Rework dma_fence_wait. Added
    dma_fence_is_signaled and dma_fence_wait_timeout.
    s/dma// and change exports to non GPL. Added fence_is_signaled and
    fence_enable_sw_signaling calls, add ability to override default
    wait operation.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 Documentation/DocBook/device-drivers.tmpl |    2 
 drivers/base/Makefile                     |    2 
 drivers/base/fence.c                      |  337 +++++++++++++++++++++++++++++
 include/linux/fence.h                     |  234 ++++++++++++++++++++
 4 files changed, 574 insertions(+), 1 deletion(-)
 create mode 100644 drivers/base/fence.c
 create mode 100644 include/linux/fence.h

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 7514dbf..6f53fc0 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -126,6 +126,8 @@ X!Edrivers/base/interface.c
      </sect1>
      <sect1><title>Device Drivers DMA Management</title>
 !Edrivers/base/dma-buf.c
+!Edrivers/base/fence.c
+!Iinclude/linux/fence.h
 !Edrivers/base/dma-coherent.c
 !Edrivers/base/dma-mapping.c
      </sect1>
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 5aa2d70..0026563 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_CMA) += dma-contiguous.o
 obj-y			+= power/
 obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
 obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
-obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o
+obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o fence.o
 obj-$(CONFIG_ISA)	+= isa.o
 obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
 obj-$(CONFIG_NUMA)	+= node.o
diff --git a/drivers/base/fence.c b/drivers/base/fence.c
new file mode 100644
index 0000000..b90a09e
--- /dev/null
+++ b/drivers/base/fence.c
@@ -0,0 +1,337 @@
+/*
+ * Fence mechanism for dma-buf and to allow for asynchronous dma access
+ *
+ * Copyright (C) 2012 Canonical Ltd
+ * Copyright (C) 2012 Texas Instruments
+ *
+ * Authors:
+ * Rob Clark <rob.clark@linaro.org>
+ * Maarten Lankhorst <maarten.lankhorst@canonical.com>
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
+
+#include <linux/slab.h>
+#include <linux/export.h>
+#include <linux/fence.h>
+
+static int __fence_signal(struct fence *fence)
+{
+	if (fence->flags & FENCE_FLAG_SIGNALED)
+		return -EINVAL;
+
+	fence->flags |= FENCE_FLAG_SIGNALED;
+	__wake_up_locked_key(&fence->event_queue, TASK_NORMAL,
+			     &fence->event_queue);
+	return 0;
+}
+
+/**
+ * fence_signal - signal completion of a fence
+ * @fence: the fence to signal
+ *
+ * Signal completion for software callbacks on a fence, this will unblock
+ * fence_wait() calls and run all the callbacks added with
+ * fence_add_callback(). Can be called multiple times, but since a fence
+ * can only go from unsignaled to signaled state, it will only be effective
+ * the first time.
+ */
+int fence_signal(struct fence *fence)
+{
+	unsigned long flags;
+	int ret;
+
+	if (WARN_ON(!fence))
+		return -EINVAL;
+
+	spin_lock_irqsave(&fence->event_queue.lock, flags);
+	ret = __fence_signal(fence);
+	spin_unlock_irqrestore(&fence->event_queue.lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(fence_signal);
+
+static void release_fence(struct kref *kref)
+{
+	struct fence *fence =
+			container_of(kref, struct fence, refcount);
+
+	BUG_ON(waitqueue_active(&fence->event_queue));
+
+	if (fence->ops->release)
+		fence->ops->release(fence);
+
+	kfree(fence);
+}
+
+/**
+ * fence_put - decreases refcount of the fence
+ * @fence:	[in]	fence to reduce refcount of
+ */
+void fence_put(struct fence *fence)
+{
+	if (WARN_ON(!fence))
+		return;
+	kref_put(&fence->refcount, release_fence);
+}
+EXPORT_SYMBOL(fence_put);
+
+/**
+ * fence_get - increases refcount of the fence
+ * @fence:	[in]	fence to increase refcount of
+ */
+void fence_get(struct fence *fence)
+{
+	if (WARN_ON(!fence))
+		return;
+	kref_get(&fence->refcount);
+}
+EXPORT_SYMBOL(fence_get);
+
+static int
+__fence_wake_func(wait_queue_t *wait, unsigned mode, int flags, void *key)
+{
+	struct fence_cb *cb =
+			container_of(wait, struct fence_cb, base);
+
+	__remove_wait_queue(key, wait);
+	return cb->func(cb, wait->private);
+}
+
+/**
+ * fence_enable_sw_signaling - enable signaling on fence
+ * @fence:	[in]	the fence to enable
+ *
+ * this will request for sw signaling to be enabled, to make the fence
+ * complete as soon as possible
+ */
+void fence_enable_sw_signaling(struct fence *fence)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&fence->event_queue.lock, flags);
+
+	if (!(fence->flags & (FENCE_FLAG_SIGNALED |
+			      FENCE_FLAG_NEED_SW_SIGNAL))) {
+		fence->flags |= FENCE_FLAG_NEED_SW_SIGNAL;
+
+		spin_unlock_irqrestore(&fence->event_queue.lock, flags);
+
+		if (!fence->ops->enable_signaling(fence))
+			fence_signal(fence);
+	} else
+		spin_unlock_irqrestore(&fence->event_queue.lock, flags);
+}
+EXPORT_SYMBOL(fence_enable_sw_signaling);
+
+/**
+ * fence_add_callback - add a callback to be called when the fence
+ * is signaled
+ * @fence:	[in]	the fence to wait on
+ * @cb:		[in]	the callback to register
+ * @func:	[in]	the function to call
+ * @priv:	[in]	the argument to pass to function
+ *
+ * cb will be initialized by fence_add_callback, no initialization
+ * by the caller is required. Any number of callbacks can be registered
+ * to a fence, but a callback can only be registered to one fence at a time.
+ *
+ * Note that the callback can be called from an atomic context.  If
+ * fence is already signaled, this function will return -ENOENT (and
+ * *not* call the callback)
+ *
+ * Add a software callback to the fence. Same restrictions apply to
+ * refcount as it does to fence_wait, however the caller doesn't need to
+ * keep a refcount to fence afterwards: when software access is enabled,
+ * the creator of the fence is required to keep the fence alive until
+ * after it signals with fence_signal. The callback itself can be called
+ * from irq context.
+ *
+ */
+int fence_add_callback(struct fence *fence, struct fence_cb *cb,
+		       fence_func_t func, void *priv)
+{
+	unsigned long flags;
+	int ret;
+
+	if (WARN_ON(!fence || !func))
+		return -EINVAL;
+
+	spin_lock_irqsave(&fence->event_queue.lock, flags);
+
+	if (!(fence->flags & (FENCE_FLAG_SIGNALED |
+			      FENCE_FLAG_NEED_SW_SIGNAL))) {
+		bool enabled;
+
+		fence->flags |= FENCE_FLAG_NEED_SW_SIGNAL;
+
+		/* Drop lock here, else there might be lock inversion when
+		 * enable_signaling takes a lock that's held when
+		 * fence_signal is called.
+		 */
+		spin_unlock_irqrestore(&fence->event_queue.lock, flags);
+		enabled = fence->ops->enable_signaling(fence);
+		spin_lock_irqsave(&fence->event_queue.lock, flags);
+
+		if (!enabled)
+			__fence_signal(fence);
+	}
+
+	if (fence->flags & FENCE_FLAG_SIGNALED)
+		ret = -ENOENT;
+	else {
+		ret = 0;
+
+		cb->base.flags = 0;
+		cb->base.func = __fence_wake_func;
+		cb->base.private = priv;
+		cb->fence = fence;
+		cb->func = func;
+		__add_wait_queue(&fence->event_queue, &cb->base);
+	}
+	spin_unlock_irqrestore(&fence->event_queue.lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(fence_add_callback);
+
+/**
+ * fence_remove_callback - remove a callback from the signaling list
+ * @fence:	[in]	the fence to wait on
+ * @cb:		[in]	the callback to remove
+ *
+ * Remove a previously queued callback from the fence. This function returns
+ * true is the callback is succesfully removed, or false if the fence has
+ * already been signaled.
+ *
+ * *WARNING*:
+ * Cancelling a callback should only be done if you really know what you're
+ * doing, since deadlocks and race conditions could occur all too easily. For
+ * this reason, it should only ever be done on hardware lockup recovery,
+ * with a reference held to the fence.
+ */
+bool
+fence_remove_callback(struct fence *fence, struct fence_cb *cb)
+{
+	unsigned long flags;
+	bool ret;
+
+	spin_lock_irqsave(&fence->event_queue.lock, flags);
+
+	ret = !(fence->flags & FENCE_FLAG_SIGNALED);
+	if (ret)
+		__remove_wait_queue(&fence->event_queue, &cb->base);
+	spin_unlock_irqrestore(&fence->event_queue.lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(fence_remove_callback);
+
+/**
+ * fence_default_wait - default sleep until the fence gets signaled
+ * or until timeout elapses
+ * @fence:	[in]	the fence to wait on
+ * @intr:	[in]	if true, do an interruptible wait
+ * @timeout:	[in]	timeout value in jiffies, or MAX_SCHEDULE_TIMEOUT
+ *
+ * Returns -ERESTARTSYS if interrupted, 0 if the wait timed out, or the
+ * remaining timeout in jiffies on success.
+ */
+long
+fence_default_wait(struct fence *fence, bool intr, signed long timeout)
+{
+	DECLARE_WAITQUEUE(wait, current);
+	unsigned long flags;
+	long ret = timeout;
+
+	spin_lock_irqsave(&fence->event_queue.lock, flags);
+
+	if (!(fence->flags & FENCE_FLAG_SIGNALED)) {
+		bool enable = false;
+
+		if (intr && signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			goto out;
+		}
+
+		if (!(fence->flags & FENCE_FLAG_NEED_SW_SIGNAL)) {
+			fence->flags |= FENCE_FLAG_NEED_SW_SIGNAL;
+			enable = true;
+		}
+
+		__add_wait_queue(&fence->event_queue, &wait);
+		while (!(fence->flags & FENCE_FLAG_SIGNALED) && ret > 0) {
+			if (intr)
+				set_current_state(TASK_INTERRUPTIBLE);
+			else
+				set_current_state(TASK_UNINTERRUPTIBLE);
+			spin_unlock_irqrestore(&fence->event_queue.lock,
+					       flags);
+
+			if (enable) {
+				if (!fence->ops->enable_signaling(fence))
+					fence_signal(fence);
+				enable = false;
+			}
+
+			ret = schedule_timeout(ret);
+
+			spin_lock_irqsave(&fence->event_queue.lock, flags);
+			if (ret > 0 && intr && signal_pending(current))
+				ret = -ERESTARTSYS;
+		}
+		__remove_wait_queue(&fence->event_queue, &wait);
+		__set_current_state(TASK_RUNNING);
+	}
+out:
+	spin_unlock_irqrestore(&fence->event_queue.lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL(fence_default_wait);
+
+static bool sw_enable_signaling(struct fence *fence)
+{
+	/* fence_create sets needs_sw_signal,
+	 * so this should never be called
+	 */
+	WARN_ON_ONCE(1);
+	return true;
+}
+
+static const struct fence_ops sw_fence_ops = {
+	.enable_signaling = sw_enable_signaling,
+};
+
+/**
+ * fence_create - create a simple sw-only fence
+ * @priv:	[in]	the value to use for the priv member
+ *
+ * This fence only supports signaling from/to CPU.  Other implementations
+ * of fence can be used to support hardware to hardware signaling, if
+ * supported by the hardware, and use the fence_helper_* functions for
+ * compatibility with other devices that only support sw signaling.
+ */
+struct fence *fence_create(void *priv)
+{
+	struct fence *fence;
+
+	fence = kmalloc(sizeof(struct fence), GFP_KERNEL);
+	if (!fence)
+		return NULL;
+
+	__fence_init(fence, &sw_fence_ops, priv);
+	fence->flags |= FENCE_FLAG_NEED_SW_SIGNAL;
+
+	return fence;
+}
+EXPORT_SYMBOL(fence_create);
diff --git a/include/linux/fence.h b/include/linux/fence.h
new file mode 100644
index 0000000..623af026
--- /dev/null
+++ b/include/linux/fence.h
@@ -0,0 +1,234 @@
+/*
+ * Fence mechanism for dma-buf to allow for asynchronous dma access
+ *
+ * Copyright (C) 2012 Canonical Ltd
+ * Copyright (C) 2012 Texas Instruments
+ *
+ * Authors:
+ * Rob Clark <rob.clark@linaro.org>
+ * Maarten Lankhorst <maarten.lankhorst@canonical.com>
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
+
+#ifndef __FENCE_H__
+#define __FENCE_H__
+
+#include <linux/err.h>
+#include <linux/wait.h>
+#include <linux/list.h>
+#include <linux/bitops.h>
+#include <linux/kref.h>
+#include <linux/sched.h>
+
+struct fence;
+struct fence_ops;
+struct fence_cb;
+
+/**
+ * struct fence - software synchronization primitive
+ * @refcount: refcount for this fence
+ * @ops: fence_ops associated with this fence
+ * @event_queue: event queue used for signaling fence
+ * @priv: fence specific private data
+ * @flags: A mask of FENCE_FLAG_* defined below
+ *
+ * FENCE_FLAG_NEED_SW_SIGNAL - enable_signaling has been called
+ * FENCE_FLAG_SIGNALED - fence is already signaled
+ */
+struct fence {
+	struct kref refcount;
+	const struct fence_ops *ops;
+	wait_queue_head_t event_queue;
+	void *priv;
+	unsigned long flags;
+};
+#define FENCE_FLAG_SIGNALED BIT(0)
+#define FENCE_FLAG_NEED_SW_SIGNAL BIT(1)
+
+typedef int (*fence_func_t)(struct fence_cb *cb, void *priv);
+
+/**
+ * struct fence_cb - callback for fence_add_callback
+ * @base: wait_queue_t added to event_queue
+ * @func: fence_func_t to call
+ * @fence: fence this fence_cb was used on
+ *
+ * This struct will be initialized by fence_add_callback, additional
+ * data can be passed along by embedding fence_cb in another struct.
+ */
+struct fence_cb {
+	wait_queue_t base;
+	fence_func_t func;
+	struct fence *fence;
+};
+
+/**
+ * struct fence_ops - operations implemented for fence
+ * @enable_signaling: enable software signaling of fence
+ * @signaled: [optional] peek whether the fence is signaled
+ * @release: [optional] called on destruction of fence
+ *
+ * Notes on enable_signaling:
+ * For fence implementations that have the capability for hw->hw
+ * signaling, they can implement this op to enable the necessary
+ * irqs, or insert commands into cmdstream, etc.  This is called
+ * in the first wait() or add_callback() path to let the fence
+ * implementation know that there is another driver waiting on
+ * the signal (ie. hw->sw case).
+ *
+ * This function can be called called from atomic context, but not
+ * from irq context, so normal spinlocks can be used.
+ *
+ * A return value of false indicates the fence already passed,
+ * or some failure occured that made it impossible to enable
+ * signaling. True indicates succesful enabling.
+ *
+ * Calling fence_signal before enable_signaling is called allows
+ * for a tiny race window in which enable_signaling is called during,
+ * before, or after fence_signal. To fight this, it is recommended
+ * that before enable_signaling returns true an extra reference is
+ * taken on the fence, to be released when the fence is signaled.
+ * This will mean fence_signal will still be called twice, but
+ * the second time will be a noop since it was already signaled.
+ *
+ * Notes on release:
+ * Can be NULL, this function allows additional commands to run on
+ * destruction of the fence. Can be called from irq context.
+ */
+
+struct fence_ops {
+	bool (*enable_signaling)(struct fence *fence);
+	bool (*signaled)(struct fence *fence);
+	long (*wait)(struct fence *fence, bool intr, signed long);
+	void (*release)(struct fence *fence);
+};
+
+struct fence *fence_create(void *priv);
+
+/**
+ * __fence_init - Initialize a custom fence.
+ * @fence:	[in]	the fence to initialize
+ * @ops:	[in]	the fence_ops for operations on this fence
+ * @priv:	[in]	the value to use for the priv member
+ *
+ * Initializes an allocated fence, the caller doesn't have to keep its
+ * refcount after committing with this fence, but it will need to hold a
+ * refcount again if fence_ops.enable_signaling gets called. This can
+ * be used for other implementing other types of fence.
+ */
+static inline void
+__fence_init(struct fence *fence, const struct fence_ops *ops, void *priv)
+{
+	WARN_ON(!ops || !ops->enable_signaling || !ops->wait);
+
+	kref_init(&fence->refcount);
+	fence->ops = ops;
+	fence->priv = priv;
+	fence->flags = 0UL;
+	init_waitqueue_head(&fence->event_queue);
+}
+
+void fence_get(struct fence *fence);
+void fence_put(struct fence *fence);
+
+int fence_signal(struct fence *fence);
+long fence_default_wait(struct fence *fence, bool intr, signed long);
+int fence_add_callback(struct fence *fence, struct fence_cb *cb,
+		       fence_func_t func, void *priv);
+bool fence_remove_callback(struct fence *fence, struct fence_cb *cb);
+void fence_enable_sw_signaling(struct fence *fence);
+
+/**
+ * fence_is_signaled - Return an indication if the fence is signaled yet.
+ * @fence:	[in]	the fence to check
+ *
+ * Returns true if the fence was already signaled, false if not. Since this
+ * function doesn't enable signaling, it is not guaranteed to ever return true
+ * If fence_add_callback, fence_wait or fence_enable_sw_signaling
+ * haven't been called before.
+ *
+ * It's recommended for seqno fences to call fence_signal when the
+ * operation is complete, it makes it possible to prevent issues from
+ * wraparound between time of issue and time of use by checking the return
+ * value of this function before calling hardware-specific wait instructions.
+ */
+static inline bool
+fence_is_signaled(struct fence *fence)
+{
+	rmb();
+
+	if (fence->flags & FENCE_FLAG_SIGNALED)
+		return true;
+
+	if (fence->ops->signaled && fence->ops->signaled(fence)) {
+		fence_signal(fence);
+		return true;
+	}
+
+	return false;
+}
+
+/**
+ * fence_wait_timeout - sleep until the fence gets signaled
+ * or until timeout elapses
+ * @fence:	[in]	the fence to wait on
+ * @intr:	[in]	if true, do an interruptible wait
+ * @timeout:	[in]	timeout value in jiffies, or MAX_SCHEDULE_TIMEOUT
+ *
+ * Returns -ERESTARTSYS if interrupted, 0 if the wait timed out, or the
+ * remaining timeout in jiffies on success. Other error values may be
+ * returned on custom implementations.
+ *
+ * Performs a synchronous wait on this fence. It is assumed the caller
+ * directly or indirectly (buf-mgr between reservation and committing)
+ * holds a reference to the fence, otherwise the fence might be
+ * freed before return, resulting in undefined behavior.
+ */
+static inline long
+fence_wait_timeout(struct fence *fence, bool intr, signed long timeout)
+{
+	if (WARN_ON(timeout < 0))
+		return -EINVAL;
+
+	return fence->ops->wait(fence, intr, timeout);
+}
+
+/**
+ * fence_wait - sleep until the fence gets signaled
+ * @fence:	[in]	the fence to wait on
+ * @intr:	[in]	if true, do an interruptible wait
+ *
+ * This function will return -ERESTARTSYS if interrupted by a signal,
+ * or 0 if the fence was signaled. Other error values may be
+ * returned on custom implementations.
+ *
+ * Performs a synchronous wait on this fence. It is assumed the caller
+ * directly or indirectly (buf-mgr between reservation and committing)
+ * holds a reference to the fence, otherwise the fence might be
+ * freed before return, resulting in undefined behavior.
+ */
+static inline long fence_wait(struct fence *fence, bool intr)
+{
+	long ret;
+
+	/* Since fence_wait_timeout cannot timeout with
+	 * MAX_SCHEDULE_TIMEOUT, only valid return values are
+	 * -ERESTARTSYS and MAX_SCHEDULE_TIMEOUT.
+	 */
+	ret = fence_wait_timeout(fence, intr, MAX_SCHEDULE_TIMEOUT);
+
+	return ret < 0 ? ret : 0;
+}
+
+#endif /* __FENCE_H__ */


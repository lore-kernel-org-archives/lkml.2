Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163071Ab2GMPij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 11:38:39 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46115 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161393Ab2GMPif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 11:38:35 -0400
From: Rob Clark <rob.clark@linaro.org>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org
Cc: patches@linaro.org, linux-kernel@vger.kernel.org,
        maarten.lankhorst@canonical.com, sumit.semwal@linaro.org,
        daniel.vetter@ffwll.ch, Rob Clark <rob@ti.com>
Subject: [RFC] dma-fence: dma-buf synchronization (v2)
Date: Fri, 13 Jul 2012 10:38:31 -0500
Message-Id: <1342193911-16157-1-git-send-email-rob.clark@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Clark <rob@ti.com>

A dma-fence can be attached to a buffer which is being filled or consumed
by hw, to allow userspace to pass the buffer without waiting to another
device.  For example, userspace can call page_flip ioctl to display the
next frame of graphics after kicking the GPU but while the GPU is still
rendering.  The display device sharing the buffer with the GPU would
attach a callback to get notified when the GPU's rendering-complete IRQ
fires, to update the scan-out address of the display, without having to
wake up userspace.

A dma-fence is transient, one-shot deal.  It is allocated and attached
to dma-buf's list of fences.  When the one that attached it is done,
with the pending operation, it can signal the fence removing it from the
dma-buf's list of fences:

  + dma_buf_attach_fence()
  + dma_fence_signal()

Other drivers can access the current fence on the dma-buf (if any),
which increment's the fences refcnt:

  + dma_buf_get_fence()
  + dma_fence_put()

The one pending on the fence can add an async callback (and optionally
cancel it.. for example, to recover from GPU hangs):

  + dma_fence_add_callback()
  + dma_fence_cancel_callback()

Or wait synchronously (optionally with timeout or from atomic context):

  + dma_fence_wait()

A default software-only implementation is provided, which can be used
by drivers attaching a fence to a buffer when they have no other means
for hw sync.  But a memory backed fence is also envisioned, because it
is common that GPU's can write to, or poll on some memory location for
synchronization.  For example:

  fence = dma_buf_get_fence(dmabuf);
  if (fence->ops == &mem_dma_fence_ops) {
    dma_buf *fence_buf;
    mem_dma_fence_get_buf(fence, &fence_buf, &offset);
    ... tell the hw the memory location to wait on ...
  } else {
    /* fall-back to sw sync * /
    dma_fence_add_callback(fence, my_cb);
  }

The memory location is itself backed by dma-buf, to simplify mapping
to the device's address space, an idea borrowed from Maarten Lankhorst.

NOTE: the memory location fence is not implemented yet, the above is
just for explaining how it would work.

On SoC platforms, if some other hw mechanism is provided for synchronizing
between IP blocks, it could be supported as an alternate implementation
with it's own fence ops in a similar way.

The other non-sw implementations would wrap the add/cancel_callback and
wait fence ops, so that they can keep track if a device not supporting
hw sync is waiting on the fence, and in this case should arrange to
call dma_fence_signal() at some point after the condition has changed,
to notify other devices waiting on the fence.  If there are no sw
waiters, this can be skipped to avoid waking the CPU unnecessarily.

The intention is to provide a userspace interface (presumably via eventfd)
later, to be used in conjunction with dma-buf's mmap support for sw access
to buffers (or for userspace apps that would prefer to do their own
synchronization).

v1: original
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
---
 drivers/base/Makefile     |    2 +-
 drivers/base/dma-buf.c    |    3 +
 drivers/base/dma-fence.c  |  364 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dma-buf.h   |    2 +
 include/linux/dma-fence.h |  128 ++++++++++++++++
 5 files changed, 498 insertions(+), 1 deletion(-)
 create mode 100644 drivers/base/dma-fence.c
 create mode 100644 include/linux/dma-fence.h

diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 5aa2d70..6e9f217 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_CMA) += dma-contiguous.o
 obj-y			+= power/
 obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
 obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
-obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o
+obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o dma-fence.o
 obj-$(CONFIG_ISA)	+= isa.o
 obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
 obj-$(CONFIG_NUMA)	+= node.o
diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index 24e88fe..b053236 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -39,6 +39,8 @@ static int dma_buf_release(struct inode *inode, struct file *file)
 
 	dmabuf = file->private_data;
 
+	WARN_ON(!list_empty(&dmabuf->fence_list));
+
 	dmabuf->ops->release(dmabuf);
 	kfree(dmabuf);
 	return 0;
@@ -119,6 +121,7 @@ struct dma_buf *dma_buf_export(void *priv, const struct dma_buf_ops *ops,
 
 	mutex_init(&dmabuf->lock);
 	INIT_LIST_HEAD(&dmabuf->attachments);
+	INIT_LIST_HEAD(&dmabuf->fence_list);
 
 	return dmabuf;
 }
diff --git a/drivers/base/dma-fence.c b/drivers/base/dma-fence.c
new file mode 100644
index 0000000..2bc25df
--- /dev/null
+++ b/drivers/base/dma-fence.c
@@ -0,0 +1,364 @@
+/*
+ * Fence mechanism for dma-buf to allow for asynchronous dma access
+ *
+ * Copyright (C) 2012 Texas Instruments
+ * Author: Rob Clark <rob.clark@linaro.org>
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
+#include <linux/sched.h>
+#include <linux/export.h>
+#include <linux/dma-fence.h>
+
+#define ATTACHED  (1 << 0)
+#define SIGNALED  (1 << 1)
+
+/**
+ * dma_buf_attach_fence - Attach a fence to a dma-buf.
+ *
+ * @buf: the dma-buf to attach to
+ * @fence: the fence to attach
+ *
+ * A fence can only be attached to a single dma-buf.  The dma-buf takes
+ * ownership of the fence, which is unref'd when the fence is signaled.
+ * The fence takes a reference to the dma-buf so the buffer will not be
+ * freed while there is a pending fence.
+ */
+int dma_buf_attach_fence(struct dma_buf *buf, struct dma_fence *fence)
+{
+	unsigned long flags;
+	int ret = -EINVAL;
+
+	if (WARN_ON(!buf || !fence))
+		return -EINVAL;
+
+	spin_lock_irqsave(&fence->event_queue.lock, flags);
+	if (!fence->attached) {
+		get_dma_buf(buf);
+		fence->attached = true;
+		list_add(&fence->list_node, &buf->fence_list);
+		ret = 0;
+	}
+	spin_unlock_irqrestore(&fence->event_queue.lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dma_buf_attach_fence);
+
+static void signal_fence(struct dma_fence *fence)
+{
+	list_del(&fence->list_node);
+	wake_up_all_locked(&fence->event_queue);
+}
+
+/**
+ * dma_fence_signal - Signal a fence.
+ *
+ * @fence:  The fence to signal
+ *
+ * All registered callbacks will be called directly (synchronously) and
+ * all blocked waters will be awoken.
+ *
+ * TODO: any value in adding a dma_fence_cancel(), for example to recov
+ * from hung gpu?  It would behave like dma_fence_signal() but return
+ * an error to waiters and cb's to let them know that the condition they
+ * are waiting for will never happen.
+ */
+int dma_fence_signal(struct dma_fence *fence)
+{
+	unsigned long flags;
+	int ret = -EINVAL;
+
+	if (WARN_ON(!fence))
+		return -EINVAL;
+
+	spin_lock_irqsave(&fence->event_queue.lock, flags);
+	if (fence->attached && !fence->signaled) {
+		fence->signaled = true;
+		signal_fence(fence);
+		ret = 0;
+	}
+	spin_unlock_irqrestore(&fence->event_queue.lock, flags);
+
+	dma_fence_put(fence);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dma_fence_signal);
+
+/**
+ * dma_buf_get_fence - Get the most recent pending fence attached to the
+ * dma-buf.
+ *
+ * @buf: the dma-buf whose fence to get
+ *
+ * If this returns NULL, there are no pending fences.  Otherwise this
+ * takes a reference to the returned fence, so the caller must later
+ * call dma_fence_put() to release the reference.
+ */
+struct dma_fence *dma_buf_get_fence(struct dma_buf *buf)
+{
+	struct dma_fence *fence = NULL;
+	unsigned long flags;
+
+	if (WARN_ON(!buf))
+		return ERR_PTR(-EINVAL);
+
+	spin_lock_irqsave(&fence->event_queue.lock, flags);
+	if (!list_empty(&buf->fence_list)) {
+		fence = list_first_entry(&buf->fence_list,
+				struct dma_fence, list_node);
+		dma_fence_get(fence);
+	}
+	spin_unlock_irqrestore(&fence->event_queue.lock, flags);
+
+	return fence;
+}
+EXPORT_SYMBOL_GPL(dma_buf_get_fence);
+
+static void release_fence(struct kref *kref)
+{
+	struct dma_fence *fence =
+			container_of(kref, struct dma_fence, refcount);
+
+	WARN_ON(waitqueue_active(&fence->event_queue));
+
+	kfree(fence);
+}
+
+/**
+ * dma_fence_put - Release a reference to the fence.
+ */
+void dma_fence_put(struct dma_fence *fence)
+{
+	WARN_ON(!fence);
+	kref_put(&fence->refcount, release_fence);
+}
+EXPORT_SYMBOL_GPL(dma_fence_put);
+
+/**
+ * dma_fence_get - Take a reference to the fence.
+ *
+ * In most cases this is used only internally by dma-fence.
+ */
+void dma_fence_get(struct dma_fence *fence)
+{
+	WARN_ON(!fence);
+	kref_get(&fence->refcount);
+}
+EXPORT_SYMBOL_GPL(dma_fence_get);
+
+static int check_signaling(struct dma_fence *fence)
+{
+	bool enable_signaling = false;
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&fence->event_queue.lock, flags);
+	if (!fence->needs_sw_signal && !fence->signaled)
+		enable_signaling = fence->needs_sw_signal = true;
+	spin_unlock_irqrestore(&fence->event_queue.lock, flags);
+
+	if (enable_signaling)
+		ret = fence->ops->enable_signaling(fence);
+
+	return ret;
+}
+
+/**
+ * dma_fence_add_callback - Add a callback to be called when the fence
+ * is signaled.
+ *
+ * @fence: The fence to wait on
+ * @cb: The callback to register
+ *
+ * Any number of callbacks can be registered to a fence, but a callback
+ * can only be registered to once fence at a time.
+ *
+ * Note that the callback can be called from an atomic context.  If
+ * fence is already signaled, this function will return -ENOENT (and
+ * *not* call the callback)
+ */
+int dma_fence_add_callback(struct dma_fence *fence,
+		struct dma_fence_cb *cb)
+{
+	unsigned long flags;
+	int ret;
+
+	if (WARN_ON(!fence || !cb))
+		return -EINVAL;
+
+	ret = check_signaling(fence);
+
+	spin_lock_irqsave(&fence->event_queue.lock, flags);
+	if (ret == -ENOENT) {
+		/* if state changed while we dropped the lock, dispatch now */
+		signal_fence(fence);
+	} else if (!fence->signaled && !ret) {
+		dma_fence_get(fence);
+		cb->fence = fence;
+		__add_wait_queue(&fence->event_queue, &cb->base);
+		ret = 0;
+	} else {
+		ret = -EINVAL;
+	}
+	spin_unlock_irqrestore(&fence->event_queue.lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dma_fence_add_callback);
+
+/**
+ * dma_fence_cancel_callback - Remove a previously registered callback.
+ *
+ * @cb: The callback to unregister
+ *
+ * The callback will not be called after this function returns, but could
+ * be called before this function returns.
+ */
+int dma_fence_cancel_callback(struct dma_fence_cb *cb)
+{
+	struct dma_fence *fence;
+	unsigned long flags;
+	int ret = -EINVAL;
+
+	if (WARN_ON(!cb))
+		return -EINVAL;
+
+	fence = cb->fence;
+
+	spin_lock_irqsave(&fence->event_queue.lock, flags);
+	if (fence) {
+		__remove_wait_queue(&fence->event_queue, &cb->base);
+		cb->fence = NULL;
+		dma_fence_put(fence);
+		ret = 0;
+	}
+	spin_unlock_irqrestore(&fence->event_queue.lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dma_fence_cancel_callback);
+
+/**
+ * dma_fence_wait - Wait for a fence to be signaled.
+ *
+ * @fence: The fence to wait on
+ * @interruptible: if true, do an interruptible wait
+ * @timeout: timeout, in jiffies
+ *
+ * Returns -ENOENT if the fence has already passed.
+ */
+int dma_fence_wait(struct dma_fence *fence, bool interruptible, long timeout)
+{
+	unsigned long flags;
+	int ret;
+
+	if (WARN_ON(!fence))
+		return -EINVAL;
+
+	ret = check_signaling(fence);
+	if (ret == -ENOENT) {
+		spin_lock_irqsave(&fence->event_queue.lock, flags);
+		signal_fence(fence);
+		spin_unlock_irqrestore(&fence->event_queue.lock, flags);
+		return ret;
+	}
+
+	if (ret)
+		return ret;
+
+	if (interruptible)
+		ret = wait_event_interruptible_timeout(fence->event_queue,
+				fence->signaled, timeout);
+	else
+		ret = wait_event_timeout(fence->event_queue,
+				fence->signaled, timeout);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dma_fence_wait);
+
+int __dma_fence_wake_func(wait_queue_t *wait, unsigned mode,
+		int flags, void *key)
+{
+	struct dma_fence_cb *cb =
+			container_of(wait, struct dma_fence_cb, base);
+	struct dma_fence *fence = cb->fence;
+	int ret;
+
+	ret = cb->func(cb, fence);
+	cb->fence = NULL;
+	dma_fence_put(fence);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__dma_fence_wake_func);
+
+/*
+ * Helpers intended to be used by the ops of the dma_fence implementation:
+ *
+ * NOTE: helpers and fxns intended to be used by other dma-fence
+ * implementations are not exported..  I'm not really sure if it makes
+ * sense to have a dma-fence implementation that is itself a module.
+ */
+
+void __dma_fence_init(struct dma_fence *fence, struct dma_fence_ops *ops)
+{
+	WARN_ON(!ops || !ops->enable_signaling);
+
+	kref_init(&fence->refcount);
+	fence->ops = ops;
+	init_waitqueue_head(&fence->event_queue);
+}
+
+/*
+ * Pure sw implementation for dma-fence.  The CPU always gets involved.
+ */
+
+static int sw_enable_signaling(struct dma_fence *fence)
+{
+	/*
+	 * pure sw, no irq's to enable, because the fence creator will
+	 * always call dma_fence_signal()
+	 */
+	return 0;
+}
+
+static struct dma_fence_ops sw_fence_ops = {
+		.enable_signaling = sw_enable_signaling,
+};
+
+/**
+ * dma_fence_create - Create a simple sw-only fence.
+ *
+ * This fence only supports signaling from/to CPU.  Other implementations
+ * of dma-fence can be used to support hardware to hardware signaling, if
+ * supported by the hardware, and use the dma_fence_helper_* functions for
+ * compatibility with other devices that only support sw signaling.
+ */
+struct dma_fence *dma_fence_create(void)
+{
+	struct dma_fence *fence;
+
+	fence = kzalloc(sizeof(struct dma_fence), GFP_KERNEL);
+	if (!fence)
+		return ERR_PTR(-ENOMEM);
+
+	__dma_fence_init(fence, &sw_fence_ops);
+
+	return fence;
+}
+EXPORT_SYMBOL_GPL(dma_fence_create);
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index eb48f38..ff4ec6c 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -122,6 +122,8 @@ struct dma_buf {
 	/* mutex to serialize list manipulation and attach/detach */
 	struct mutex lock;
 	void *priv;
+	/* list of pending dma_fence's */
+	struct list_head fence_list;
 };
 
 /**
diff --git a/include/linux/dma-fence.h b/include/linux/dma-fence.h
new file mode 100644
index 0000000..336afd2
--- /dev/null
+++ b/include/linux/dma-fence.h
@@ -0,0 +1,128 @@
+/*
+ * Fence mechanism for dma-buf to allow for asynchronous dma access
+ *
+ * Copyright (C) 2012 Texas Instruments
+ * Author: Rob Clark <rob.clark@linaro.org>
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
+#ifndef __DMA_FENCE_H__
+#define __DMA_FENCE_H__
+
+#include <linux/err.h>
+#include <linux/list.h>
+#include <linux/wait.h>
+#include <linux/list.h>
+#include <linux/dma-buf.h>
+
+struct dma_fence;
+struct dma_fence_ops;
+struct dma_fence_cb;
+
+struct dma_fence {
+	struct kref refcount;
+	struct dma_fence_ops *ops;
+	wait_queue_head_t event_queue;
+	struct list_head list_node;   /* for dmabuf's fence_list */
+
+	/* has this fence been attached to a dma-buf yet? */
+	bool attached : 1;
+
+	/* has this fence been signaled yet? */
+	bool signaled : 1;
+
+	/* do we have one or more waiters or callbacks? */
+	bool needs_sw_signal : 1;
+};
+
+typedef int (*dma_fence_func_t)(struct dma_fence_cb *cb,
+		struct dma_fence *fence);
+
+struct dma_fence_cb {
+	wait_queue_t base;
+	dma_fence_func_t func;
+
+	/*
+	 * This is initialized when the cb is added, and NULL'd when it
+	 * is canceled or expired, so can be used to for error checking
+	 * if the cb is already pending.  A dma_fence_cb can be pending
+	 * on at most one fence at a time.
+	 */
+	struct dma_fence *fence;
+};
+
+struct dma_fence_ops {
+	/**
+	 * For fence implementations that have the capability for hw->hw
+	 * signaling, they can implement this op to enable the necessary
+	 * irqs, or insert commands into cmdstream, etc.  This is called
+	 * in the first wait() or add_callback() path to let the fence
+	 * implementation know that there is another driver waiting on
+	 * the signal (ie. hw->sw case).
+	 *
+	 * A return value of -ENOENT will indicate that the fence has
+	 * already passed.
+	 */
+	int (*enable_signaling)(struct dma_fence *fence);
+};
+
+int __dma_fence_wake_func(wait_queue_t *wait, unsigned mode,
+		int flags, void *key);
+
+#define DMA_FENCE_CB_INITIALIZER(cb_func) {                \
+		.base = { .func = __dma_fence_wake_func },  \
+		.func = (cb_func),                          \
+	}
+
+#define DECLARE_DMA_FENCE(name, cb_func)                   \
+		struct dma_fence_cb name = DMA_FENCE_CB_INITIALIZER(cb_func)
+
+
+/*
+ * TODO does it make sense to be able to enable dma-fence without dma-buf,
+ * or visa versa?
+ */
+#ifdef CONFIG_DMA_SHARED_BUFFER
+
+int dma_buf_attach_fence(struct dma_buf *buf, struct dma_fence *fence);
+struct dma_fence *dma_buf_get_fence(struct dma_buf *buf);
+
+/* create a basic (pure sw) fence: */
+struct dma_fence *dma_fence_create(void);
+
+/* intended to be used by other dma_fence implementations: */
+void __dma_fence_init(struct dma_fence *fence, struct dma_fence_ops *ops);
+
+void dma_fence_get(struct dma_fence *fence);
+void dma_fence_put(struct dma_fence *fence);
+int dma_fence_signal(struct dma_fence *fence);
+
+int dma_fence_add_callback(struct dma_fence *fence,
+		struct dma_fence_cb *cb);
+int dma_fence_cancel_callback(struct dma_fence_cb *cb);
+int dma_fence_wait(struct dma_fence *fence, bool interruptible, long timeout);
+
+/* helpers intended to be used by the ops of the dma_fence implementation: */
+int dma_fence_helper_signal(struct dma_fence *fence);
+int dma_fence_helper_add_callback(struct dma_fence *fence,
+		struct dma_fence_cb *cb);
+int dma_fence_helper_cancel_callback(struct dma_fence_cb *cb);
+int dma_fence_helper_wait(struct dma_fence *fence, bool interruptible,
+		long timeout);
+
+#else
+// TODO
+#endif /* CONFIG_DMA_SHARED_BUFFER */
+
+#endif /* __DMA_FENCE_H__ */
-- 
1.7.9.5


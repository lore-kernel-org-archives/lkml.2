Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab2I1NDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:03:37 -0400
Received: from adelie.canonical.com ([91.189.90.139]:52469 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757430Ab2I1NDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:03:32 -0400
Subject: [PATCH 3/5] seqno-fence: Hardware dma-buf implementation of fencing
 (v3)
To: jakob@vmware.com, thellstrom@vmware.com, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
        linux-media@vger.kernel.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 28 Sep 2012 14:42:49 +0200
Message-ID: <20120928124248.14366.25140.stgit@patser.local>
In-Reply-To: <20120928124148.14366.21063.stgit@patser.local>
References: <20120928124148.14366.21063.stgit@patser.local>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This type of fence can be used with hardware synchronization for simple
hardware that can block execution until the condition
(dma_buf[offset] - value) >= 0 has been met.

A software fallback still has to be provided in case the fence is used
with a device that doesn't support this mechanism. It is useful to expose
this for graphics cards that have an op to support this.

Some cards like i915 can export those, but don't have an option to wait,
so they need the software fallback.

I extended the original patch by Rob Clark.

v1: Original
v2: Renamed from bikeshed to seqno, moved into dma-fence.c since
    not much was left of the file. Lots of documentation added.
v3: Use fence_ops instead of custom callbacks. Moved to own file
    to avoid circular dependency between dma-buf.h and fence.h

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 Documentation/DocBook/device-drivers.tmpl |    1 
 drivers/base/fence.c                      |   36 ++++++++++
 include/linux/seqno-fence.h               |  107 +++++++++++++++++++++++++++++
 3 files changed, 144 insertions(+)
 create mode 100644 include/linux/seqno-fence.h

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 6f53fc0..ad14396 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -128,6 +128,7 @@ X!Edrivers/base/interface.c
 !Edrivers/base/dma-buf.c
 !Edrivers/base/fence.c
 !Iinclude/linux/fence.h
+!Iinclude/linux/seqno-fence.h
 !Edrivers/base/dma-coherent.c
 !Edrivers/base/dma-mapping.c
      </sect1>
diff --git a/drivers/base/fence.c b/drivers/base/fence.c
index b90a09e..0a184b2 100644
--- a/drivers/base/fence.c
+++ b/drivers/base/fence.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/export.h>
 #include <linux/fence.h>
+#include <linux/seqno-fence.h>
 
 static int __fence_signal(struct fence *fence)
 {
@@ -335,3 +336,38 @@ struct fence *fence_create(void *priv)
 	return fence;
 }
 EXPORT_SYMBOL(fence_create);
+
+static bool seqno_enable_signaling(struct fence *fence)
+{
+	struct seqno_fence *seqno_fence = to_seqno_fence(fence);
+	return seqno_fence->ops->enable_signaling(fence);
+}
+
+static bool seqno_signaled(struct fence *fence)
+{
+	struct seqno_fence *seqno_fence = to_seqno_fence(fence);
+	return seqno_fence->ops->signaled && seqno_fence->ops->signaled(fence);
+}
+
+static void seqno_release(struct fence *fence)
+{
+	struct seqno_fence *f = to_seqno_fence(fence);
+
+	if (f->ops->release)
+		f->ops->release(fence);
+	dma_buf_put(f->sync_buf);
+}
+
+static long seqno_wait(struct fence *fence, bool intr, signed long timeout)
+{
+	struct seqno_fence *f = to_seqno_fence(fence);
+	return f->ops->wait(fence, intr, timeout);
+}
+
+const struct fence_ops seqno_fence_ops = {
+	.enable_signaling = seqno_enable_signaling,
+	.signaled = seqno_signaled,
+	.wait = seqno_wait,
+	.release = seqno_release
+};
+EXPORT_SYMBOL_GPL(seqno_fence_ops);
diff --git a/include/linux/seqno-fence.h b/include/linux/seqno-fence.h
new file mode 100644
index 0000000..971cebe
--- /dev/null
+++ b/include/linux/seqno-fence.h
@@ -0,0 +1,107 @@
+/*
+ * seqno-fence, using a dma-buf to synchronize fencing
+ *
+ * Copyright (C) 2012 Texas Instruments
+ * Copyright (C) 2012 Canonical Ltd
+ * Authors:
+ *   Rob Clark <rob.clark@linaro.org>
+ *   Maarten Lankhorst <maarten.lankhorst@canonical.com>
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
+#ifndef __SEQNO_FENCE_H__
+#define __SEQNO_FENCE_H__
+
+#include <linux/fence.h>
+#include <linux/dma-buf.h>
+
+struct seqno_fence {
+	struct fence base;
+
+	const struct fence_ops *ops;
+	struct dma_buf *sync_buf;
+	uint32_t seqno_ofs;
+	uint32_t seqno;
+};
+
+extern const struct fence_ops seqno_fence_ops;
+
+/**
+ * to_seqno_fence - cast a fence to a seqno_fence
+ * @fence: fence to cast to a seqno_fence
+ *
+ * Returns NULL if the fence is not a seqno_fence,
+ * or the seqno_fence otherwise.
+ */
+static inline struct seqno_fence *
+to_seqno_fence(struct fence *fence)
+{
+	if (fence->ops != &seqno_fence_ops)
+		return NULL;
+	return container_of(fence, struct seqno_fence, base);
+}
+
+/**
+ * seqno_fence_init - initialize a seqno fence
+ * @fence: seqno_fence to initialize
+ * @sync_buf: buffer containing the memory location to signal on
+ * @seqno_ofs: the offset within @sync_buf
+ * @seqno: the sequence # to signal on
+ * @priv: value of priv member
+ * @ops: the fence_ops for operations on this seqno fence
+ *
+ * This function initializes a struct seqno_fence with passed parameters,
+ * and takes a reference on sync_buf which is released on fence destruction.
+ *
+ * A seqno_fence is a dma_fence which can complete in software when
+ * enable_signaling is called, but it also completes when
+ * (s32)((sync_buf)[seqno_ofs] - seqno) >= 0 is true
+ *
+ * The seqno_fence will take a refcount on the sync_buf until it's
+ * destroyed, but actual lifetime of sync_buf may be longer if one of the
+ * callers take a reference to it.
+ *
+ * Certain hardware have instructions to insert this type of wait condition
+ * in the command stream, so no intervention from software would be needed.
+ * This type of fence can be destroyed before completed, however a reference
+ * on the sync_buf dma-buf can be taken. It is encouraged to re-use the same
+ * dma-buf for sync_buf, since mapping or unmapping the sync_buf to the
+ * device's vm can be expensive.
+ *
+ * It is recommended for creators of seqno_fence to call fence_signal
+ * before destruction. This will prevent possible issues from wraparound at
+ * time of issue vs time of check, since users can check fence_is_signaled
+ * before submitting instructions for the hardware to wait on the fence.
+ * However, when ops.enable_signaling is not called, it doesn't have to be
+ * done as soon as possible, just before there's any real danger of seqno
+ * wraparound.
+ */
+static inline void
+seqno_fence_init(struct seqno_fence *fence,
+			struct dma_buf *sync_buf,
+			uint32_t seqno_ofs, uint32_t seqno, void *priv,
+			const struct fence_ops *ops)
+{
+	BUG_ON(!fence || !sync_buf || !ops->enable_signaling || !ops->wait);
+
+	__fence_init(&fence->base, &seqno_fence_ops, priv);
+
+	get_dma_buf(sync_buf);
+	fence->ops = ops;
+	fence->sync_buf = sync_buf;
+	fence->seqno_ofs = seqno_ofs;
+	fence->seqno = seqno;
+}
+
+#endif /* __SEQNO_FENCE_H__ */


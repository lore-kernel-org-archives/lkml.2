Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946045Ab2JaWst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 18:48:49 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54318 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760954Ab2JaWrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 18:47:03 -0400
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur@brendeland.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        sjur@brendeland.net, dmitry.tarnyagin@stericsson.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFC virtio-next 1/4] virtio: Move definitions to header file vring.h
Date: Wed, 31 Oct 2012 23:46:51 +0100
Message-Id: <1351723614-4145-2-git-send-email-sjur@brendeland.net>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351723614-4145-1-git-send-email-sjur@brendeland.net>
References: <1351723614-4145-1-git-send-email-sjur@brendeland.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Move the vring_virtqueue structure, memory barrier and debug
macros out from virtio_ring.c to the new header file vring.h.
This is done in order to allow other kernel modules to access the
virtio internal data-structures.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
Tis patch triggers a couple of checkpatch warnings, but I've
chosen to do a clean copy and not do any corrections.

 drivers/virtio/virtio_ring.c |   96 +--------------------------------
 drivers/virtio/vring.h       |  121 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 122 insertions(+), 95 deletions(-)
 create mode 100644 drivers/virtio/vring.h

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index ffd7e7d..9027af6 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -23,101 +23,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/hrtimer.h>
-
-/* virtio guest is communicating with a virtual "device" that actually runs on
- * a host processor.  Memory barriers are used to control SMP effects. */
-#ifdef CONFIG_SMP
-/* Where possible, use SMP barriers which are more lightweight than mandatory
- * barriers, because mandatory barriers control MMIO effects on accesses
- * through relaxed memory I/O windows (which virtio-pci does not use). */
-#define virtio_mb(vq) \
-	do { if ((vq)->weak_barriers) smp_mb(); else mb(); } while(0)
-#define virtio_rmb(vq) \
-	do { if ((vq)->weak_barriers) smp_rmb(); else rmb(); } while(0)
-#define virtio_wmb(vq) \
-	do { if ((vq)->weak_barriers) smp_wmb(); else wmb(); } while(0)
-#else
-/* We must force memory ordering even if guest is UP since host could be
- * running on another CPU, but SMP barriers are defined to barrier() in that
- * configuration. So fall back to mandatory barriers instead. */
-#define virtio_mb(vq) mb()
-#define virtio_rmb(vq) rmb()
-#define virtio_wmb(vq) wmb()
-#endif
-
-#ifdef DEBUG
-/* For development, we want to crash whenever the ring is screwed. */
-#define BAD_RING(_vq, fmt, args...)				\
-	do {							\
-		dev_err(&(_vq)->vq.vdev->dev,			\
-			"%s:"fmt, (_vq)->vq.name, ##args);	\
-		BUG();						\
-	} while (0)
-/* Caller is supposed to guarantee no reentry. */
-#define START_USE(_vq)						\
-	do {							\
-		if ((_vq)->in_use)				\
-			panic("%s:in_use = %i\n",		\
-			      (_vq)->vq.name, (_vq)->in_use);	\
-		(_vq)->in_use = __LINE__;			\
-	} while (0)
-#define END_USE(_vq) \
-	do { BUG_ON(!(_vq)->in_use); (_vq)->in_use = 0; } while(0)
-#else
-#define BAD_RING(_vq, fmt, args...)				\
-	do {							\
-		dev_err(&_vq->vq.vdev->dev,			\
-			"%s:"fmt, (_vq)->vq.name, ##args);	\
-		(_vq)->broken = true;				\
-	} while (0)
-#define START_USE(vq)
-#define END_USE(vq)
-#endif
-
-struct vring_virtqueue
-{
-	struct virtqueue vq;
-
-	/* Actual memory layout for this queue */
-	struct vring vring;
-
-	/* Can we use weak barriers? */
-	bool weak_barriers;
-
-	/* Other side has made a mess, don't try any more. */
-	bool broken;
-
-	/* Host supports indirect buffers */
-	bool indirect;
-
-	/* Host publishes avail event idx */
-	bool event;
-
-	/* Head of free buffer list. */
-	unsigned int free_head;
-	/* Number we've added since last sync. */
-	unsigned int num_added;
-
-	/* Last used index we've seen. */
-	u16 last_used_idx;
-
-	/* How to notify other side. FIXME: commonalize hcalls! */
-	void (*notify)(struct virtqueue *vq);
-
-#ifdef DEBUG
-	/* They're supposed to lock for us. */
-	unsigned int in_use;
-
-	/* Figure out if their kicks are too delayed. */
-	bool last_add_time_valid;
-	ktime_t last_add_time;
-#endif
-
-	/* Tokens for callbacks. */
-	void *data[];
-};
-
-#define to_vvq(_vq) container_of(_vq, struct vring_virtqueue, vq)
+#include "vring.h"
 
 /* Set up an indirect table of descriptors and add it to the queue. */
 static int vring_add_indirect(struct vring_virtqueue *vq,
diff --git a/drivers/virtio/vring.h b/drivers/virtio/vring.h
new file mode 100644
index 0000000..b997fc3
--- /dev/null
+++ b/drivers/virtio/vring.h
@@ -0,0 +1,121 @@
+/* Virtio ring implementation.
+ *
+ *  Copyright 2007 Rusty Russell IBM Corporation
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef _LINUX_VIRTIO_RING_H_
+#define _LINUX_VIRTIO_RING_H_
+
+#include <linux/virtio_ring.h>
+#include <linux/virtio.h>
+
+struct vring_virtqueue
+{
+	struct virtqueue vq;
+
+	/* Actual memory layout for this queue */
+	struct vring vring;
+
+	/* Can we use weak barriers? */
+	bool weak_barriers;
+
+	/* Other side has made a mess, don't try any more. */
+	bool broken;
+
+	/* Host supports indirect buffers */
+	bool indirect;
+
+	/* Host publishes avail event idx */
+	bool event;
+
+	/* Number of free buffers */
+	unsigned int num_free;
+	/* Head of free buffer list. */
+	unsigned int free_head;
+	/* Number we've added since last sync. */
+	unsigned int num_added;
+
+	/* Last used index we've seen. */
+	u16 last_used_idx;
+
+	/* How to notify other side. FIXME: commonalize hcalls! */
+	void (*notify)(struct virtqueue *vq);
+
+#ifdef DEBUG
+	/* They're supposed to lock for us. */
+	unsigned int in_use;
+
+	/* Figure out if their kicks are too delayed. */
+	bool last_add_time_valid;
+	ktime_t last_add_time;
+#endif
+
+	/* Tokens for callbacks. */
+	void *data[];
+};
+#define to_vvq(_vq) container_of(_vq, struct vring_virtqueue, vq)
+
+/* virtio guest is communicating with a virtual "device" that actually runs on
+ * a host processor.  Memory barriers are used to control SMP effects. */
+#ifdef CONFIG_SMP
+/* Where possible, use SMP barriers which are more lightweight than mandatory
+ * barriers, because mandatory barriers control MMIO effects on accesses
+ * through relaxed memory I/O windows (which virtio-pci does not use). */
+#define virtio_mb(vq) \
+	do { if ((vq)->weak_barriers) smp_mb(); else mb(); } while(0)
+#define virtio_rmb(vq) \
+	do { if ((vq)->weak_barriers) smp_rmb(); else rmb(); } while(0)
+#define virtio_wmb(vq) \
+	do { if ((vq)->weak_barriers) smp_wmb(); else wmb(); } while(0)
+#else
+/* We must force memory ordering even if guest is UP since host could be
+ * running on another CPU, but SMP barriers are defined to barrier() in that
+ * configuration. So fall back to mandatory barriers instead. */
+#define virtio_mb(vq) mb()
+#define virtio_rmb(vq) rmb()
+#define virtio_wmb(vq) wmb()
+#endif
+
+#ifdef DEBUG
+/* For development, we want to crash whenever the ring is screwed. */
+#define BAD_RING(_vq, fmt, args...)				\
+	do {							\
+		dev_err(&(_vq)->vq.vdev->dev,			\
+			"%s:"fmt, (_vq)->vq.name, ##args);	\
+		BUG();						\
+	} while (0)
+/* Caller is supposed to guarantee no reentry. */
+#define START_USE(_vq)						\
+	do {							\
+		if ((_vq)->in_use)				\
+			panic("%s:in_use = %i\n",		\
+			      (_vq)->vq.name, (_vq)->in_use);	\
+		(_vq)->in_use = __LINE__;			\
+	} while (0)
+#define END_USE(_vq) \
+	do { BUG_ON(!(_vq)->in_use); (_vq)->in_use = 0; } while(0)
+#else
+#define BAD_RING(_vq, fmt, args...)				\
+	do {							\
+		dev_err(&_vq->vq.vdev->dev,			\
+			"%s:"fmt, (_vq)->vq.name, ##args);	\
+		(_vq)->broken = true;				\
+	} while (0)
+#define START_USE(vq)
+#define END_USE(vq)
+#endif
+
+#endif
-- 
1.7.9.5


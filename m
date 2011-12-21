Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab1LUBBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:01:50 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44470 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab1LUBBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:01:19 -0500
From: Minchan Kim <minchan@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>, Minchan Kim <minchan@redhat.com>
Subject: [PATCH 2/6] virtio: support unlocked queue kick
Date: Wed, 21 Dec 2011 10:00:50 +0900
Message-Id: <1324429254-28383-3-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1324429254-28383-1-git-send-email-minchan@kernel.org>
References: <1324429254-28383-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Split virtqueue_kick to be able to do the actual notification outside the
lock protecting the virtqueue.  This patch was originally done by
Stefan Hajnoczi, but I can't find the original one anymore and had to
recreated it from memory.  Pointers to the original or corrections for
the commit message are welcome.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Minchan Kim <minchan@redhat.com>
---
 drivers/virtio/virtio_ring.c |   33 ++++++++++++++++++++++++++-------
 include/linux/virtio.h       |   21 +++++++++++++++++++++
 2 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index c7a2c20..c5f0458 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -238,10 +238,12 @@ add_head:
 }
 EXPORT_SYMBOL_GPL(virtqueue_add_buf_gfp);
 
-void virtqueue_kick(struct virtqueue *_vq)
+bool virtqueue_kick_prepare(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 	u16 new, old;
+	bool needs_kick;
+
 	START_USE(vq);
 	/* Descriptors and available array need to be set before we expose the
 	 * new available array entries. */
@@ -254,13 +256,30 @@ void virtqueue_kick(struct virtqueue *_vq)
 	/* Need to update avail index before checking if we should notify */
 	virtio_mb();
 
-	if (vq->event ?
-	    vring_need_event(vring_avail_event(&vq->vring), new, old) :
-	    !(vq->vring.used->flags & VRING_USED_F_NO_NOTIFY))
-		/* Prod other side to tell it about changes. */
-		vq->notify(&vq->vq);
-
+	if (vq->event) {
+		needs_kick = vring_need_event(vring_avail_event(&vq->vring),
+					      new, old);
+	} else {
+		needs_kick = (!(vq->vring.used->flags & VRING_USED_F_NO_NOTIFY));
+	}
 	END_USE(vq);
+	return needs_kick;
+}
+EXPORT_SYMBOL_GPL(virtqueue_kick_prepare);
+
+void virtqueue_notify(struct virtqueue *_vq)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
+	/* Prod other side to tell it about changes. */
+	vq->notify(_vq);
+}
+EXPORT_SYMBOL_GPL(virtqueue_notify);
+
+void virtqueue_kick(struct virtqueue *vq)
+{
+	if (virtqueue_kick_prepare(vq))
+		virtqueue_notify(vq);
 }
 EXPORT_SYMBOL_GPL(virtqueue_kick);
 
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 4c069d8..722a35d 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -90,6 +90,27 @@ static inline int virtqueue_add_buf(struct virtqueue *vq,
 
 void virtqueue_kick(struct virtqueue *vq);
 
+/**
+ * virtqueue_kick_prepare - first half of split virtqueue_kick call.
+ * @vq: the struct virtqueue
+ *
+ * Instead of virtqueue_kick(), you can do:
+ *	if (virtqueue_kick_prepare(vq))
+ *		virtqueue_notify(vq);
+ *
+ * This is sometimes useful because the virtqueue_kick_prepare() needs
+ * to be serialized, but the actual virtqueue_notify() call does not.
+ */
+bool virtqueue_kick_prepare(struct virtqueue *vq);
+
+/**
+ * virtqueue_notify - second half of split virtqueue_kick call.
+ * @vq: the struct virtqueue
+ *
+ * This does not need to be serialized.
+ */
+void virtqueue_notify(struct virtqueue *vq);
+
 void *virtqueue_get_buf(struct virtqueue *vq, unsigned int *len);
 
 void virtqueue_disable_cb(struct virtqueue *vq);
-- 
1.7.6.4


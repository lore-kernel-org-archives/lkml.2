Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab1KCHnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 03:43:53 -0400
Received: from ozlabs.org ([203.10.76.45]:56371 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292Ab1KCHnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 03:43:49 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 5] virtio: support unlocked queue kick
X-Mercurial-Node: c0db93dbb414ab6dbcde9e120305596fb3ee4283
Message-Id: <c0db93dbb414ab6dbcde.1320306171@localhost6.localdomain6>
In-Reply-To: <patchbomb.1320306168@localhost6.localdomain6>
References: <patchbomb.1320306168@localhost6.localdomain6>
User-Agent: Mercurial-patchbomb/1.9.1
Date: Thu, 03 Nov 2011 18:12:51 +1030
From: Rusty Russell <rusty@rustcorp.com.au>
To: MichaelS.Tsirkist@redhat.com, Christoph Hellwig <hch@infradead.org>
Cc: virtualization <virtualization@lists.linux-foundation.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on patch by Christoph for virtio_blk speedup:

	Split virtqueue_kick to be able to do the actual notification
	outside the lock protecting the virtqueue.  This patch was
	originally done by Stefan Hajnoczi, but I can't find the
	original one anymore and had to recreated it from memory.
	Pointers to the original or corrections for the commit message
	are welcome.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -237,10 +237,12 @@ add_head:
 }
 EXPORT_SYMBOL_GPL(virtqueue_add_buf);
 
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
@@ -253,13 +255,30 @@ void virtqueue_kick(struct virtqueue *_v
 	/* Need to update avail index before checking if we should notify */
 	virtio_mb();
 
-	if (vq->event ?
-	    vring_need_event(vring_avail_event(&vq->vring), new, old) :
-	    !(vq->vring.used->flags & VRING_USED_F_NO_NOTIFY))
-		/* Prod other side to tell it about changes. */
-		vq->notify(&vq->vq);
+	if (vq->event) {
+		needs_kick = vring_need_event(vring_avail_event(&vq->vring),
+					      new, old);
+	} else {
+		needs_kick = (!(vq->vring.used->flags & VRING_USED_F_NO_NOTIFY));
+	}
+	END_USE(vq);
+	return needs_kick;
+}
+EXPORT_SYMBOL_GPL(virtqueue_kick_prepare);
 
-	END_USE(vq);
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
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -62,6 +62,27 @@ int virtqueue_add_buf(struct virtqueue *
 void virtqueue_kick(struct virtqueue *vq);
 
 /**
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
+/**
  * virtqueue_get_buf - get the next used buffer
  * @vq: the struct virtqueue we're talking about.
  * @len: the length written into the buffer



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935310Ab1JETzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 15:55:46 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55664
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934819Ab1JETzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:55:44 -0400
Message-Id: <20111005195529.964397366@bombadil.infradead.org>
User-Agent: quilt/0.48-1
Date: Wed, 05 Oct 2011 15:54:05 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] virtio: support unlocked queue kick
References: <20111005195403.407628164@bombadil.infradead.org>
Content-Disposition: inline; filename=unlocked-virtqueue-kick
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split virtqueue_kick to be able to do the actual notification outside the
lock protecting the virtqueue.  This patch was originally done by
Stefan Hajnoczi, but I can't find the original one anymore and had to
recreated it from memory.  Pointers to the original or corrections for
the commit message are welcome.

Index: linux-2.6/drivers/virtio/virtio_ring.c
===================================================================
--- linux-2.6.orig/drivers/virtio/virtio_ring.c	2011-09-15 15:28:55.891347016 +0200
+++ linux-2.6/drivers/virtio/virtio_ring.c	2011-10-03 18:45:32.492738431 +0200
@@ -237,9 +237,11 @@ add_head:
 }
 EXPORT_SYMBOL_GPL(virtqueue_add_buf_gfp);
 
-void virtqueue_kick(struct virtqueue *_vq)
+bool virtqueue_kick_prepare(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
+	bool need_kick = false;
+
 	u16 new, old;
 	START_USE(vq);
 	/* Descriptors and available array need to be set before we expose the
@@ -253,15 +255,32 @@ void virtqueue_kick(struct virtqueue *_v
 	/* Need to update avail index before checking if we should notify */
 	virtio_mb();
 
-	if (vq->event ?
-	    vring_need_event(vring_avail_event(&vq->vring), new, old) :
-	    !(vq->vring.used->flags & VRING_USED_F_NO_NOTIFY))
-		/* Prod other side to tell it about changes. */
-		vq->notify(&vq->vq);
-
+	if (vq->event) {
+		if (vring_need_event(vring_avail_event(&vq->vring), new, old))
+			need_kick = true;
+	} else {
+		if (!(vq->vring.used->flags & VRING_USED_F_NO_NOTIFY))
+			need_kick = true;
+	}
 	END_USE(vq);
+	return need_kick;
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
-EXPORT_SYMBOL_GPL(virtqueue_kick);
 
 static void detach_buf(struct vring_virtqueue *vq, unsigned int head)
 {
Index: linux-2.6/include/linux/virtio.h
===================================================================
--- linux-2.6.orig/include/linux/virtio.h	2011-09-15 15:28:57.078857804 +0200
+++ linux-2.6/include/linux/virtio.h	2011-10-03 18:41:07.309766531 +0200
@@ -86,6 +86,8 @@ static inline int virtqueue_add_buf(stru
 }
 
 void virtqueue_kick(struct virtqueue *vq);
+bool virtqueue_kick_prepare(struct virtqueue *vq);
+void virtqueue_notify(struct virtqueue *vq);
 
 void *virtqueue_get_buf(struct virtqueue *vq, unsigned int *len);
 


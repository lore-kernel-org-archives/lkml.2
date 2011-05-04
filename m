Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab1EDUxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:53:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755860Ab1EDUxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:53:12 -0400
Date: Wed, 4 May 2011 23:52:33 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Shirley Ma <xma@us.ibm.com>, lguest@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Krishna Kumar <krkumar2@in.ibm.com>,
        Tom Lendacky <tahm@linux.vnet.ibm.com>, steved@us.ibm.com,
        habanero@linux.vnet.ibm.com
Subject: [PATCH 14/18] virtio: add api for delayed callbacks
Message-ID: <64d47c628b3fdc0ac156aed4be182933d8bcc0db.1304541919.git.mst@redhat.com>
References: <cover.1304541918.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1304541918.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an API that tells the other side that callbacks
should be delayed until a lot of work has been done.
Implement using the new used_event feature.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_ring.c |   27 +++++++++++++++++++++++++++
 include/linux/virtio.h       |    9 +++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 262dfe6..3a70d70 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -397,6 +397,33 @@ bool virtqueue_enable_cb(struct virtqueue *_vq)
 }
 EXPORT_SYMBOL_GPL(virtqueue_enable_cb);
 
+bool virtqueue_enable_cb_delayed(struct virtqueue *_vq)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+	int bufs;
+
+	START_USE(vq);
+
+	/* We optimistically turn back on interrupts, then check if there was
+	 * more to do. */
+	/* Depending on the VIRTIO_RING_F_USED_EVENT_IDX feature, we need to
+	 * either clear the flags bit or point the event index at the next
+	 * entry. Always do both to keep code simple. */
+	vq->vring.avail->flags &= ~VRING_AVAIL_F_NO_INTERRUPT;
+	/* TODO: tune this threshold */
+	bufs = (vq->vring.avail->idx - vq->last_used_idx) * 3 / 4;
+	vring_used_event(&vq->vring) = vq->last_used_idx + bufs;
+	virtio_mb();
+	if (unlikely(vq->vring.used->idx - vq->last_used_idx > bufs)) {
+		END_USE(vq);
+		return false;
+	}
+
+	END_USE(vq);
+	return true;
+}
+EXPORT_SYMBOL_GPL(virtqueue_enable_cb_delayed);
+
 void *virtqueue_detach_unused_buf(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 718336b..5151fd1 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -51,6 +51,13 @@ struct virtqueue {
  *	This re-enables callbacks; it returns "false" if there are pending
  *	buffers in the queue, to detect a possible race between the driver
  *	checking for more work, and enabling callbacks.
+ * virtqueue_enable_cb_delayed: restart callbacks after disable_cb.
+ *	vq: the struct virtqueue we're talking about.
+ *	This re-enables callbacks but hints to the other side to delay
+ *	interrupts until most of the available buffers have been processed;
+ *	it returns "false" if there are many pending buffers in the queue,
+ *	to detect a possible race between the driver checking for more work,
+ *	and enabling callbacks.
  * virtqueue_detach_unused_buf: detach first unused buffer
  * 	vq: the struct virtqueue we're talking about.
  * 	Returns NULL or the "data" token handed to add_buf
@@ -86,6 +93,8 @@ void virtqueue_disable_cb(struct virtqueue *vq);
 
 bool virtqueue_enable_cb(struct virtqueue *vq);
 
+bool virtqueue_enable_cb_delayed(struct virtqueue *vq);
+
 void *virtqueue_detach_unused_buf(struct virtqueue *vq);
 
 /**
-- 
1.7.5.53.gc233e


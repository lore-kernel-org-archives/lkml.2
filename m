Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab1KCHoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 03:44:05 -0400
Received: from ozlabs.org ([203.10.76.45]:47599 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351Ab1KCHnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 03:43:49 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 5] virtio: document functions better
X-Mercurial-Node: 7ce2cceb12e0dd2a4c9981fce619d3dad22699bc
Message-Id: <7ce2cceb12e0dd2a4c99.1320306169@localhost6.localdomain6>
In-Reply-To: <patchbomb.1320306168@localhost6.localdomain6>
References: <patchbomb.1320306168@localhost6.localdomain6>
User-Agent: Mercurial-patchbomb/1.9.1
Date: Thu, 03 Nov 2011 18:12:49 +1030
From: Rusty Russell <rusty@rustcorp.com.au>
To: MichaelS.Tsirkist@redhat.com, Christoph Hellwig <hch@infradead.org>
Cc: virtualization <virtualization@lists.linux-foundation.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old documentation is left over from when we used a structure with
strategy pointers.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/virtio.h |  130 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 87 insertions(+), 43 deletions(-)

diff --git a/include/linux/virtio.h b/include/linux/virtio.h
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -26,52 +26,22 @@ struct virtqueue {
 };
 
 /**
- * operations for virtqueue
- * virtqueue_add_buf: expose buffer to other end
- *	vq: the struct virtqueue we're talking about.
- *	sg: the description of the buffer(s).
- *	out_num: the number of sg readable by other side
- *	in_num: the number of sg which are writable (after readable ones)
- *	data: the token identifying the buffer.
- *	gfp: how to do memory allocations (if necessary).
- *      Returns remaining capacity of queue (sg segments) or a negative error.
- * virtqueue_kick: update after add_buf
- *	vq: the struct virtqueue
- *	After one or more add_buf calls, invoke this to kick the other side.
- * virtqueue_get_buf: get the next used buffer
- *	vq: the struct virtqueue we're talking about.
- *	len: the length written into the buffer
- *	Returns NULL or the "data" token handed to add_buf.
- * virtqueue_disable_cb: disable callbacks
- *	vq: the struct virtqueue we're talking about.
- *	Note that this is not necessarily synchronous, hence unreliable and only
- *	useful as an optimization.
- * virtqueue_enable_cb: restart callbacks after disable_cb.
- *	vq: the struct virtqueue we're talking about.
- *	This re-enables callbacks; it returns "false" if there are pending
- *	buffers in the queue, to detect a possible race between the driver
- *	checking for more work, and enabling callbacks.
- * virtqueue_enable_cb_delayed: restart callbacks after disable_cb.
- *	vq: the struct virtqueue we're talking about.
- *	This re-enables callbacks but hints to the other side to delay
- *	interrupts until most of the available buffers have been processed;
- *	it returns "false" if there are many pending buffers in the queue,
- *	to detect a possible race between the driver checking for more work,
- *	and enabling callbacks.
- * virtqueue_detach_unused_buf: detach first unused buffer
- * 	vq: the struct virtqueue we're talking about.
- * 	Returns NULL or the "data" token handed to add_buf
- * virtqueue_get_vring_size: return the size of the virtqueue's vring
- *	vq: the struct virtqueue containing the vring of interest.
- *	Returns the size of the vring.
+ * virtqueue_add_buf_gfp - expose buffer to other end
+ * @vq: the struct virtqueue we're talking about.
+ * @sg: the description of the buffer(s).
+ * @out_num: the number of sg readable by other side
+ * @in_num: the number of sg which are writable (after readable ones)
+ * @data: the token identifying the buffer.
+ * @gfp: how to do memory allocations (if necessary).
  *
- * Locking rules are straightforward: the driver is responsible for
- * locking.  No two operations may be invoked simultaneously, with the exception
- * of virtqueue_disable_cb.
+ * Caller must ensure we don't call this with other virtqueue operations
+ * at the same time (except where noted).
  *
- * All operations can be called in any context.
+ * Returns remaining capacity of queue or a negative error
+ * (ie. ENOSPC).  Note that it only really makes sense to treat all
+ * positive return values as "available": indirect buffers mean that
+ * we can put an entire sg[] array inside a single queue entry.
  */
-
 int virtqueue_add_buf_gfp(struct virtqueue *vq,
 			  struct scatterlist sg[],
 			  unsigned int out_num,
@@ -88,18 +58,92 @@ static inline int virtqueue_add_buf(stru
 	return virtqueue_add_buf_gfp(vq, sg, out_num, in_num, data, GFP_ATOMIC);
 }
 
+/**
+ * virtqueue_kick - update after add_buf
+ * @vq: the struct virtqueue
+ *
+ * After one or more virtqueue_add_buf_gfp calls, invoke this to kick
+ * the other side.
+ *
+ * Caller must ensure we don't call this with other virtqueue
+ * operations at the same time (except where noted).
+ */
 void virtqueue_kick(struct virtqueue *vq);
 
+/**
+ * virtqueue_get_buf - get the next used buffer
+ * @vq: the struct virtqueue we're talking about.
+ * @len: the length written into the buffer
+ *
+ * If the driver wrote data into the buffer, @len will be set to the
+ * amount written.  This means you don't need to clear the buffer
+ * beforehand to ensure there's no data leakage in the case of short
+ * writes.
+ *
+ * Caller must ensure we don't call this with other virtqueue
+ * operations at the same time (except where noted).
+ *
+ * Returns NULL if there are no used buffers, or the "data" token
+ * handed to virtqueue_add_buf_gfp().
+ */
 void *virtqueue_get_buf(struct virtqueue *vq, unsigned int *len);
 
+/**
+ * virtqueue_disable_cb - disable callbacks
+ * @vq: the struct virtqueue we're talking about.
+ *
+ * Note that this is not necessarily synchronous, hence unreliable and only
+ * useful as an optimization.
+ *
+ * Unlike other operations, this need not be serialized.
+ */
 void virtqueue_disable_cb(struct virtqueue *vq);
 
+/**
+ * virtqueue_enable_cb - restart callbacks after disable_cb.
+ * @vq: the struct virtqueue we're talking about.
+ *
+ * This re-enables callbacks; it returns "false" if there are pending
+ * buffers in the queue, to detect a possible race between the driver
+ * checking for more work, and enabling callbacks.
+ *
+ * Caller must ensure we don't call this with other virtqueue
+ * operations at the same time (except where noted).
+ */
 bool virtqueue_enable_cb(struct virtqueue *vq);
 
+/**
+ * virtqueue_enable_cb_delayed - restart callbacks after disable_cb.
+ * @vq: the struct virtqueue we're talking about.
+ *
+ * This re-enables callbacks but hints to the other side to delay
+ * interrupts until most of the available buffers have been processed;
+ * it returns "false" if there are many pending buffers in the queue,
+ * to detect a possible race between the driver checking for more work,
+ * and enabling callbacks.
+ *
+ * Caller must ensure we don't call this with other virtqueue
+ * operations at the same time (except where noted).
+ */
 bool virtqueue_enable_cb_delayed(struct virtqueue *vq);
 
+/**
+ * virtqueue_detach_unused_buf - detach first unused buffer
+ * @vq: the struct virtqueue we're talking about.
+ *
+ * Returns NULL or the "data" token handed to virtqueue_add_buf_gfp().
+ * This is not valid on an active queue; it is useful only for device
+ * shutdown.
+ */
 void *virtqueue_detach_unused_buf(struct virtqueue *vq);
 
+/**
+ * virtqueue_get_vring_size - return the size of the virtqueue's vring
+ * @vq: the struct virtqueue containing the vring of interest.
+ *
+ * Returns the size of the vring.  This is mainly used for boasting to
+ * userspace.  Unlike other operations, this need not be serialized.
+ */
 unsigned int virtqueue_get_vring_size(struct virtqueue *vq);
 
 /**



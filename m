Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab0GWGSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 02:18:41 -0400
Received: from ozlabs.org ([203.10.76.45]:34030 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab0GWGSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 02:18:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] virtio: fix oops on OOM
Date: Fri, 23 Jul 2010 15:48:37 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-23-generic; KDE/4.4.2; i686; ; )
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Chris Mason <chris.mason@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007231548.38037.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>

virtio ring was changed to return an error code on OOM,
but one caller was missed and still checks for vq->vring.num.
The fix is just to check for <0 error code.

Long term it might make sense to change goto add_head to
just return an error on oom instead, but let's apply
a minimal fix for 2.6.35.

Reported-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Tested-by: Chris Mason <chris.mason@oracle.com>
---

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index dd35b34..bffec32 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -164,7 +164,8 @@ int virtqueue_add_buf_gfp(struct virtqueue *_vq,
 			  gfp_t gfp)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
-	unsigned int i, avail, head, uninitialized_var(prev);
+	unsigned int i, avail, uninitialized_var(prev);
+	int head;
 
 	START_USE(vq);
 
@@ -174,8 +175,8 @@ int virtqueue_add_buf_gfp(struct virtqueue *_vq,
 	 * buffers, then go indirect. FIXME: tune this threshold */
 	if (vq->indirect && (out + in) > 1 && vq->num_free) {
 		head = vring_add_indirect(vq, sg, out, in, gfp);
-		if (head != vq->vring.num)
+		if (likely(head >= 0))
 			goto add_head;
 	}
 
 	BUG_ON(out + in > vq->vring.num);

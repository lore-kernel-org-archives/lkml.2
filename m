Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab0GZHZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 03:25:44 -0400
Received: from ozlabs.org ([203.10.76.45]:59385 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576Ab0GZHZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 03:25:43 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: virtualization@lists.linux-foundation.org
Subject: [PATCH] virtio: fix oops on OOM
Date: Mon, 26 Jul 2010 16:55:30 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-23-generic; KDE/4.4.2; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        Chris Mason <chris.mason@oracle.com>
References: <201007231548.38037.rusty@rustcorp.com.au>
In-Reply-To: <201007231548.38037.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007261655.31257.rusty@rustcorp.com.au>
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
Cc: stable@kernel.org # .34.x
---
 drivers/virtio/virtio_ring.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

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

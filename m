Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933827Ab1ESXNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:13:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933236Ab1ESXM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:12:56 -0400
Date: Fri, 20 May 2011 02:12:19 +0300
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
Subject: [PATCHv2 11/14] virtio: don't delay avail index update
Message-ID: <33d7df119ccbedc9b54fbe4b674076b4f7ba3499.1305846412.git.mst@redhat.com>
References: <cover.1305846412.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1305846412.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update avail index immediately instead of upon kick:
for virtio-net RX this helps parallelism with the host.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_ring.c |   28 +++++++++++++++++++---------
 1 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index eed5f29..8218fe6 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -89,7 +89,7 @@ struct vring_virtqueue
 	unsigned int num_free;
 	/* Head of free buffer list. */
 	unsigned int free_head;
-	/* Number we've added since last sync. */
+	/* Number we've added since last kick. */
 	unsigned int num_added;
 
 	/* Last used index we've seen. */
@@ -174,6 +174,13 @@ int virtqueue_add_buf_gfp(struct virtqueue *_vq,
 
 	BUG_ON(data == NULL);
 
+	/* Prevent drivers from adding more than num bufs without a kick. */
+	if (vq->num_added == vq->vring.num) {
+		printk(KERN_ERR "gaaa!!!\n");
+		END_USE(vq);
+		return -ENOSPC;
+	}
+
 	/* If the host supports indirect descriptor tables, and we have multiple
 	 * buffers, then go indirect. FIXME: tune this threshold */
 	if (vq->indirect && (out + in) > 1 && vq->num_free) {
@@ -227,8 +234,14 @@ add_head:
 
 	/* Put entry in available array (but don't update avail->idx until they
 	 * do sync).  FIXME: avoid modulus here? */
-	avail = (vq->vring.avail->idx + vq->num_added++) % vq->vring.num;
+	avail = vq->vring.avail->idx % vq->vring.num;
 	vq->vring.avail->ring[avail] = head;
+	vq->num_added++;
+
+	/* Descriptors and available array need to be set before we expose the
+	 * new available array entries. */
+	virtio_wmb();
+	vq->vring.avail->idx++;
 
 	pr_debug("Added buffer head %i to %p\n", head, vq);
 	END_USE(vq);
@@ -242,17 +255,14 @@ void virtqueue_kick(struct virtqueue *_vq)
 	struct vring_virtqueue *vq = to_vvq(_vq);
 	u16 new, old;
 	START_USE(vq);
-	/* Descriptors and available array need to be set before we expose the
-	 * new available array entries. */
-	virtio_wmb();
-
-	old = vq->vring.avail->idx;
-	new = vq->vring.avail->idx = old + vq->num_added;
-	vq->num_added = 0;
 
 	/* Need to update avail index before checking if we should notify */
 	virtio_mb();
 
+	new = vq->vring.avail->idx;
+	old = new - vq->num_added;
+	vq->num_added = 0;
+
 	if (vq->event ?
 	    vring_need_event(vring_avail_event(&vq->vring), new, old) :
 	    !(vq->vring.used->flags & VRING_USED_F_NO_NOTIFY))
-- 
1.7.5.53.gc233e


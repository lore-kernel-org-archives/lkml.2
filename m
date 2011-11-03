Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab1KCHnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 03:43:55 -0400
Received: from ozlabs.org ([203.10.76.45]:59469 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab1KCHnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 03:43:49 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 4 of 5] virtio: avoid modulus operation
X-Mercurial-Node: 05de9ee25e222c5206f32b8438298d52cc8c7d0e
Message-Id: <05de9ee25e222c5206f3.1320306172@localhost6.localdomain6>
In-Reply-To: <patchbomb.1320306168@localhost6.localdomain6>
References: <patchbomb.1320306168@localhost6.localdomain6>
User-Agent: Mercurial-patchbomb/1.9.1
Date: Thu, 03 Nov 2011 18:12:52 +1030
From: Rusty Russell <rusty@rustcorp.com.au>
To: MichaelS.Tsirkist@redhat.com, Christoph Hellwig <hch@infradead.org>
Cc: virtualization <virtualization@lists.linux-foundation.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we know vq->vring.num is a power of 2, modulus is lazy (it's asserted
in vring_new_virtqueue()).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/virtio/virtio_ring.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -1420,7 +1420,7 @@ __init void lguest_init(void)
 	add_preferred_console("hvc", 0, NULL);
 
 	/* Register our very early console. */
-	virtio_cons_early_init(early_put_chars);
+//	virtio_cons_early_init(early_put_chars);
 
 	/*
 	 * Last of all, we set the power management poweroff hook to point to
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -226,8 +226,8 @@ add_head:
 	vq->data[head] = data;
 
 	/* Put entry in available array (but don't update avail->idx until they
-	 * do sync).  FIXME: avoid modulus here? */
-	avail = (vq->vring.avail->idx + vq->num_added++) % vq->vring.num;
+	 * do sync). */
+	avail = ((vq->vring.avail->idx + vq->num_added++) & (vq->vring.num-1));
 	vq->vring.avail->ring[avail] = head;
 
 	pr_debug("Added buffer head %i to %p\n", head, vq);
@@ -317,6 +317,7 @@ void *virtqueue_get_buf(struct virtqueue
 	struct vring_virtqueue *vq = to_vvq(_vq);
 	void *ret;
 	unsigned int i;
+	u16 last_used;
 
 	START_USE(vq);
 
@@ -334,8 +335,9 @@ void *virtqueue_get_buf(struct virtqueue
 	/* Only get used array entries after they have been exposed by host. */
 	virtio_rmb();
 
-	i = vq->vring.used->ring[vq->last_used_idx%vq->vring.num].id;
-	*len = vq->vring.used->ring[vq->last_used_idx%vq->vring.num].len;
+	last_used = (vq->last_used_idx & (vq->vring.num - 1));
+	i = vq->vring.used->ring[last_used].id;
+	*len = vq->vring.used->ring[last_used].len;
 
 	if (unlikely(i >= vq->vring.num)) {
 		BAD_RING(vq, "id %u out of range\n", i);



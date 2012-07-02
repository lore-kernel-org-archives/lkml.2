Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab2GBHc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 03:32:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147Ab2GBHc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 03:32:58 -0400
Date: Mon, 2 Jul 2012 10:33:08 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Rafael Aquini <aquini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>
Subject: [PATCH RFC] virtio-balloon: fix add/get API use
Message-ID: <20120702073308.GB8268@redhat.com>
References: <patchbomb.1320306168@localhost6.localdomain6>
 <f3831c1617c86a51d875.1320306173@localhost6.localdomain6>
 <20120701092051.GA4515@redhat.com>
 <87d34fx990.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d34fx990.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In virtio balloon virtqueue_get_buf might now run concurrently with
virtqueue_kick.  I audited both and this seems safe in practice but
this is not guaranteed by the API.
Additionally, a spurious interrupt might in theory make
virtqueue_get_buf run in parallel with virtqueue_add_buf, which is racy.

While we might try to protect against spurious callbacks it's
easier to fix the driver: balloon seems to be the only one
(mis)using the API like this, so let's just fix balloon.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

---

Warning: completely untested.

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index bfbc15c..a26eb4f 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -47,7 +47,7 @@ struct virtio_balloon
 	struct task_struct *thread;
 
 	/* Waiting for host to ack the pages we released. */
-	struct completion acked;
+	wait_queue_head_t acked;
 
 	/* Number of balloon pages we've told the Host we're not using. */
 	unsigned int num_pages;
@@ -89,29 +89,26 @@ static struct page *balloon_pfn_to_page(u32 pfn)
 
 static void balloon_ack(struct virtqueue *vq)
 {
-	struct virtio_balloon *vb;
-	unsigned int len;
+	struct virtio_balloon *vb = vq->vdev->priv;
 
-	vb = virtqueue_get_buf(vq, &len);
-	if (vb)
-		complete(&vb->acked);
+	wake_up(&vb->acked);
 }
 
 static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
 {
 	struct scatterlist sg;
+	unsigned int len;
+	void *buf;
 
 	sg_init_one(&sg, vb->pfns, sizeof(vb->pfns[0]) * vb->num_pfns);
 
-	init_completion(&vb->acked);
-
 	/* We should always be able to add one buffer to an empty queue. */
 	if (virtqueue_add_buf(vq, &sg, 1, 0, vb, GFP_KERNEL) < 0)
 		BUG();
 	virtqueue_kick(vq);
 
 	/* When host has read buffer, this completes via balloon_ack */
-	wait_for_completion(&vb->acked);
+	wait_event(vb->acked, virtqueue_get_buf(vq, &len));
 }
 
 static void set_page_pfns(u32 pfns[], struct page *page)
@@ -231,12 +228,8 @@ static void update_balloon_stats(struct virtio_balloon *vb)
  */
 static void stats_request(struct virtqueue *vq)
 {
-	struct virtio_balloon *vb;
-	unsigned int len;
+	struct virtio_balloon *vb = vq->vdev->priv;
 
-	vb = virtqueue_get_buf(vq, &len);
-	if (!vb)
-		return;
 	vb->need_stats_update = 1;
 	wake_up(&vb->config_change);
 }
@@ -245,11 +238,14 @@ static void stats_handle_request(struct virtio_balloon *vb)
 {
 	struct virtqueue *vq;
 	struct scatterlist sg;
+	unsigned int len;
 
 	vb->need_stats_update = 0;
 	update_balloon_stats(vb);
 
 	vq = vb->stats_vq;
+	if (!virtqueue_get_buf(vq, &len))
+		return;
 	sg_init_one(&sg, vb->stats, sizeof(vb->stats));
 	if (virtqueue_add_buf(vq, &sg, 1, 0, vb, GFP_KERNEL) < 0)
 		BUG();
@@ -358,6 +354,7 @@ static int virtballoon_probe(struct virtio_device *vdev)
 	INIT_LIST_HEAD(&vb->pages);
 	vb->num_pages = 0;
 	init_waitqueue_head(&vb->config_change);
+	init_waitqueue_head(&vb->acked);
 	vb->vdev = vdev;
 	vb->need_stats_update = 0;
 

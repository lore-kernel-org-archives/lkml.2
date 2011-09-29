Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab1I2P1E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:27:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932252Ab1I2P1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:27:00 -0400
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Amit Shah <amit.shah@redhat.com>
Subject: [PATCH 10/11] virtio: balloon: Move out vq initialization into separate function
Date: Thu, 29 Sep 2011 20:56:06 +0530
Message-Id: <c1aefbb62c7447563164f9dcbd00ee0bfb6d11b3.1317309123.git.amit.shah@redhat.com>
In-Reply-To: <cover.1317309123.git.amit.shah@redhat.com>
References: <cover.1317309123.git.amit.shah@redhat.com>
In-Reply-To: <cover.1317309123.git.amit.shah@redhat.com>
References: <cover.1317309123.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The probe and PM restore functions will share this code.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/virtio/virtio_balloon.c |   48 ++++++++++++++++++++++++--------------
 1 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index e058ace..571d443 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -274,32 +274,21 @@ static int balloon(void *_vballoon)
 	return 0;
 }
 
-static int virtballoon_probe(struct virtio_device *vdev)
+static int init_vqs(struct virtio_balloon *vb)
 {
-	struct virtio_balloon *vb;
 	struct virtqueue *vqs[3];
 	vq_callback_t *callbacks[] = { balloon_ack, balloon_ack, stats_request };
 	const char *names[] = { "inflate", "deflate", "stats" };
 	int err, nvqs;
 
-	vdev->priv = vb = kmalloc(sizeof(*vb), GFP_KERNEL);
-	if (!vb) {
-		err = -ENOMEM;
-		goto out;
-	}
-
-	INIT_LIST_HEAD(&vb->pages);
-	vb->num_pages = 0;
-	init_waitqueue_head(&vb->config_change);
-	vb->vdev = vdev;
-	vb->need_stats_update = 0;
-
-	/* We expect two virtqueues: inflate and deflate,
-	 * and optionally stat. */
+	/*
+	 * We expect two virtqueues: inflate and deflate, and
+	 * optionally stat.
+	 */
 	nvqs = virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ) ? 3 : 2;
-	err = vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names);
+	err = vb->vdev->config->find_vqs(vb->vdev, nvqs, vqs, callbacks, names);
 	if (err)
-		goto out_free_vb;
+		return err;
 
 	vb->inflate_vq = vqs[0];
 	vb->deflate_vq = vqs[1];
@@ -316,6 +305,29 @@ static int virtballoon_probe(struct virtio_device *vdev)
 			BUG();
 		virtqueue_kick(vb->stats_vq);
 	}
+	return 0;
+}
+
+static int virtballoon_probe(struct virtio_device *vdev)
+{
+	struct virtio_balloon *vb;
+	int err;
+
+	vdev->priv = vb = kmalloc(sizeof(*vb), GFP_KERNEL);
+	if (!vb) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	INIT_LIST_HEAD(&vb->pages);
+	vb->num_pages = 0;
+	init_waitqueue_head(&vb->config_change);
+	vb->vdev = vdev;
+	vb->need_stats_update = 0;
+
+	err = init_vqs(vb);
+	if (err)
+		goto out_free_vb;
 
 	vb->thread = kthread_run(balloon, vb, "vballoon");
 	if (IS_ERR(vb->thread)) {
-- 
1.7.6.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab1KQL6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 06:58:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757221Ab1KQL6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 06:58:32 -0500
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v3 10/11] virtio: balloon: Move out vq initialization into separate function
Date: Thu, 17 Nov 2011 17:27:41 +0530
Message-Id: <fdde281e044bfc433186abd1a120e1a6e0171a3f.1321530505.git.amit.shah@redhat.com>
In-Reply-To: <cover.1321530505.git.amit.shah@redhat.com>
References: <cover.1321530505.git.amit.shah@redhat.com>
In-Reply-To: <cover.1321530505.git.amit.shah@redhat.com>
References: <cover.1321530505.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The probe and PM restore functions will share this code.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/virtio/virtio_balloon.c |   48 ++++++++++++++++++++++++--------------
 1 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 94fd738..1ff3cf4 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -275,32 +275,21 @@ static int balloon(void *_vballoon)
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
@@ -317,6 +306,29 @@ static int virtballoon_probe(struct virtio_device *vdev)
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
1.7.7.1


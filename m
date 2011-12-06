Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab1LFTts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:49:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763Ab1LFTtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:49:45 -0500
From: Amit Shah <amit.shah@redhat.com>
To: Virtualization List <virtualization@lists.linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v4 05/12] virtio: blk: Move out vq initialization to separate function
Date: Wed,  7 Dec 2011 01:18:43 +0530
Message-Id: <aedbdea12e5c2f7a738b603b912aa4ede1fe17bc.1323199985.git.amit.shah@redhat.com>
In-Reply-To: <cover.1323199985.git.amit.shah@redhat.com>
References: <cover.1323199985.git.amit.shah@redhat.com>
In-Reply-To: <cover.1323199985.git.amit.shah@redhat.com>
References: <cover.1323199985.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The probe and PM restore functions will share this code.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/block/virtio_blk.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 4d0b70a..467f218 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -349,6 +349,18 @@ static void virtblk_config_changed(struct virtio_device *vdev)
 	queue_work(virtblk_wq, &vblk->config_work);
 }
 
+static int init_vq(struct virtio_blk *vblk)
+{
+	int err = 0;
+
+	/* We expect one virtqueue, for output. */
+	vblk->vq = virtio_find_single_vq(vblk->vdev, blk_done, "requests");
+	if (IS_ERR(vblk->vq))
+		err = PTR_ERR(vblk->vq);
+
+	return err;
+}
+
 static int __devinit virtblk_probe(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk;
@@ -390,12 +402,9 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 	sg_init_table(vblk->sg, vblk->sg_elems);
 	INIT_WORK(&vblk->config_work, virtblk_config_changed_work);
 
-	/* We expect one virtqueue, for output. */
-	vblk->vq = virtio_find_single_vq(vdev, blk_done, "requests");
-	if (IS_ERR(vblk->vq)) {
-		err = PTR_ERR(vblk->vq);
+	err = init_vq(vblk);
+	if (err)
 		goto out_free_vblk;
-	}
 
 	vblk->pool = mempool_create_kmalloc_pool(1,sizeof(struct virtblk_req));
 	if (!vblk->pool) {
-- 
1.7.7.3


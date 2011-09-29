Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004Ab1I2Pty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:49:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756992Ab1I2Ptw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:49:52 -0400
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v2 05/11] virtio: blk: Move out vq initialization to separate function
Date: Thu, 29 Sep 2011 21:19:38 +0530
Message-Id: <87a20e93e1b81a8d8761dc5f6552a16557d64169.1317311033.git.amit.shah@redhat.com>
In-Reply-To: <7bd7bd396c19237716cf47e53d558e3691f88ce5.1317311033.git.amit.shah@redhat.com>
References: <cover.1317309123.git.amit.shah@redhat.com>
 <7bd7bd396c19237716cf47e53d558e3691f88ce5.1317311033.git.amit.shah@redhat.com>
In-Reply-To: <cover.1317311033.git.amit.shah@redhat.com>
References: <cover.1317311033.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The probe and PM restore functions will share this code.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/block/virtio_blk.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 079c088..717664a 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -337,6 +337,18 @@ static void virtblk_config_changed(struct virtio_device *vdev)
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
@@ -375,12 +387,9 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
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
1.7.6.2


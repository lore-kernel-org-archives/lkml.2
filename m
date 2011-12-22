Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab1LVLah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 06:30:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217Ab1LVL25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 06:28:57 -0500
From: Amit Shah <amit.shah@redhat.com>
To: Virtualization List <virtualization@lists.linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v6 05/11] virtio: blk: Move vq initialization to separate function
Date: Thu, 22 Dec 2011 16:58:29 +0530
Message-Id: <4a2778050e36f8e6ddf6965cd1a45a62cdc13dfc.1324553223.git.amit.shah@redhat.com>
In-Reply-To: <cover.1324553223.git.amit.shah@redhat.com>
References: <cover.1324553223.git.amit.shah@redhat.com>
In-Reply-To: <cover.1324553223.git.amit.shah@redhat.com>
References: <cover.1324553223.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The probe and PM restore functions will share this code.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/block/virtio_blk.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 34633f3..86c9c5b 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -362,6 +362,18 @@ static void virtblk_config_changed(struct virtio_device *vdev)
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
@@ -405,12 +417,9 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 	INIT_WORK(&vblk->config_work, virtblk_config_changed_work);
 	vblk->config_enable = true;
 
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
1.7.7.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab1I2P0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:26:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932252Ab1I2P0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:26:53 -0400
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Amit Shah <amit.shah@redhat.com>
Subject: [PATCH 08/11] virtio: net: Move out vq and vq buf removal into separate function
Date: Thu, 29 Sep 2011 20:56:04 +0530
Message-Id: <3ad7c78efcb1a157424a512619723988dd2afe32.1317309123.git.amit.shah@redhat.com>
In-Reply-To: <cover.1317309123.git.amit.shah@redhat.com>
References: <cover.1317309123.git.amit.shah@redhat.com>
In-Reply-To: <cover.1317309123.git.amit.shah@redhat.com>
References: <cover.1317309123.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remove and PM freeze functions will share this code.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/net/virtio_net.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index da4c51a..dcd4b01 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1103,24 +1103,29 @@ static void free_unused_bufs(struct virtnet_info *vi)
 	BUG_ON(vi->num != 0);
 }
 
-static void __devexit virtnet_remove(struct virtio_device *vdev)
+static void remove_vq_common(struct virtnet_info *vi)
 {
-	struct virtnet_info *vi = vdev->priv;
-
-	/* Stop all the virtqueues. */
-	vdev->config->reset(vdev);
-
-
-	unregister_netdev(vi->dev);
 	cancel_delayed_work_sync(&vi->refill);
 
 	/* Free unused buffers in both send and recv, if any. */
 	free_unused_bufs(vi);
 
-	vdev->config->del_vqs(vi->vdev);
+	vi->vdev->config->del_vqs(vi->vdev);
 
 	while (vi->pages)
 		__free_pages(get_a_page(vi, GFP_KERNEL), 0);
+}
+
+static void __devexit virtnet_remove(struct virtio_device *vdev)
+{
+	struct virtnet_info *vi = vdev->priv;
+
+	/* Stop all the virtqueues. */
+	vdev->config->reset(vdev);
+
+	unregister_netdev(vi->dev);
+
+	remove_vq_common(vi);
 
 	free_percpu(vi->stats);
 	free_netdev(vi->dev);
-- 
1.7.6.2


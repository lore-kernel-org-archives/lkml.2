Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab1KQL6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 06:58:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757153Ab1KQL61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 06:58:27 -0500
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v3 07/11] virtio: net: Move out vq initialization into separate function
Date: Thu, 17 Nov 2011 17:27:38 +0530
Message-Id: <3ce663a2d2fd49fdfaf5b818631a788d2425beb3.1321530505.git.amit.shah@redhat.com>
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
 drivers/net/virtio_net.c |   47 +++++++++++++++++++++++++++------------------
 1 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 6ee8410..6baa563 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -954,15 +954,38 @@ static void virtnet_config_changed(struct virtio_device *vdev)
 	virtnet_update_status(vi);
 }
 
+static int init_vqs(struct virtnet_info *vi)
+{
+	struct virtqueue *vqs[3];
+	vq_callback_t *callbacks[] = { skb_recv_done, skb_xmit_done, NULL};
+	const char *names[] = { "input", "output", "control" };
+	int nvqs, err;
+
+	/* We expect two virtqueues, receive then send,
+	 * and optionally control. */
+	nvqs = virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ) ? 3 : 2;
+
+	err = vi->vdev->config->find_vqs(vi->vdev, nvqs, vqs, callbacks, names);
+	if (err)
+		return err;
+
+	vi->rvq = vqs[0];
+	vi->svq = vqs[1];
+
+	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ)) {
+		vi->cvq = vqs[2];
+
+		if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VLAN))
+			vi->dev->features |= NETIF_F_HW_VLAN_FILTER;
+	}
+	return 0;
+}
+
 static int virtnet_probe(struct virtio_device *vdev)
 {
 	int err;
 	struct net_device *dev;
 	struct virtnet_info *vi;
-	struct virtqueue *vqs[3];
-	vq_callback_t *callbacks[] = { skb_recv_done, skb_xmit_done, NULL};
-	const char *names[] = { "input", "output", "control" };
-	int nvqs;
 
 	/* Allocate ourselves a network device with room for our info */
 	dev = alloc_etherdev(sizeof(struct virtnet_info));
@@ -1034,24 +1057,10 @@ static int virtnet_probe(struct virtio_device *vdev)
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
 		vi->mergeable_rx_bufs = true;
 
-	/* We expect two virtqueues, receive then send,
-	 * and optionally control. */
-	nvqs = virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ) ? 3 : 2;
-
-	err = vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names);
+	err = init_vqs(vi);
 	if (err)
 		goto free_stats;
 
-	vi->rvq = vqs[0];
-	vi->svq = vqs[1];
-
-	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ)) {
-		vi->cvq = vqs[2];
-
-		if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VLAN))
-			dev->features |= NETIF_F_HW_VLAN_FILTER;
-	}
-
 	err = register_netdev(dev);
 	if (err) {
 		pr_debug("virtio_net: registering device failed\n");
-- 
1.7.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423162Ab2LGRNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 12:13:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423090Ab2LGRNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 12:13:21 -0500
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com, rusty@rustcorp.com.au, davem@davemloft.net,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: krkumar2@in.ibm.com, kvm@vger.kernel.org, bhutchings@solarflare.com,
        jwhan@filewood.snu.ac.kr, shiyer@redhat.com,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH net-next v3 3/3] virtio-net: support changing the number of queue pairs through ethtool
Date: Sat,  8 Dec 2012 01:04:57 +0800
Message-Id: <1354899897-10423-4-git-send-email-jasowang@redhat.com>
In-Reply-To: <1354899897-10423-1-git-send-email-jasowang@redhat.com>
References: <1354899897-10423-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the ethtool_{set|get}_channels method of virtio-net to
allow user to change the number of queues when the device is running on demand.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index c083048..a644eeb 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1075,10 +1075,53 @@ static void virtnet_get_drvinfo(struct net_device *dev,
 
 }
 
+/* TODO: Eliminate OOO packets during switching */
+static int virtnet_set_channels(struct net_device *dev,
+				struct ethtool_channels *channels)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	u16 queue_pairs = channels->combined_count;
+	int err;
+
+	/* We don't support separate rx/tx channels.
+	 * We don't allow setting 'other' channels.
+	 */
+	if (channels->rx_count || channels->tx_count || channels->other_count)
+		return -EINVAL;
+
+	if (queue_pairs > vi->max_queue_pairs)
+		return -EINVAL;
+
+	err = virtnet_set_queues(vi, queue_pairs);
+	if (!err) {
+		netif_set_real_num_tx_queues(dev, queue_pairs);
+		netif_set_real_num_rx_queues(dev, queue_pairs);
+
+		virtnet_set_affinity(vi, true);
+	}
+
+	return err;
+}
+
+static void virtnet_get_channels(struct net_device *dev,
+				 struct ethtool_channels *channels)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+
+	channels->combined_count = vi->curr_queue_pairs;
+	channels->max_combined = vi->max_queue_pairs;
+	channels->max_other = 0;
+	channels->rx_count = 0;
+	channels->tx_count = 0;
+	channels->other_count = 0;
+}
+
 static const struct ethtool_ops virtnet_ethtool_ops = {
 	.get_drvinfo = virtnet_get_drvinfo,
 	.get_link = ethtool_op_get_link,
 	.get_ringparam = virtnet_get_ringparam,
+	.set_channels = virtnet_set_channels,
+	.get_channels = virtnet_get_channels,
 };
 
 #define MIN_MTU 68
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab2K0KYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 05:24:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257Ab2K0KYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 05:24:42 -0500
From: Jason Wang <jasowang@redhat.com>
To: rusty@rustcorp.com.au, mst@redhat.com, krkumar2@in.ibm.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, bhutchings@solarflare.com, jwhan@filewood.snu.ac.kr,
        shiyer@redhat.com, Jason Wang <jasowang@redhat.com>
Subject: [net-next rfc v7 3/3] virtio-net: change the number of queues through ethtool
Date: Tue, 27 Nov 2012 18:16:00 +0800
Message-Id: <1354011360-39479-4-git-send-email-jasowang@redhat.com>
In-Reply-To: <1354011360-39479-1-git-send-email-jasowang@redhat.com>
References: <1354011360-39479-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implement the {set|get}_channels method of ethool to allow user to
change the number of queues dymaically when the device is running. This would
let the user to configure it on demand.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index bcaa6e5..f08ec2a 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1578,10 +1578,51 @@ static struct virtio_driver virtio_net_driver = {
 #endif
 };
 
+/* TODO: Eliminate OOO packets during switching */
+static int virtnet_set_channels(struct net_device *dev,
+				struct ethtool_channels *channels)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	u16 queue_pairs = channels->combined_count;
+
+	/* We don't support separate rx/tx channels.
+	 * We don't allow setting 'other' channels.
+	 */
+	if (channels->rx_count || channels->tx_count || channels->other_count)
+		return -EINVAL;
+
+	/* Only two modes were support currently */
+	if (queue_pairs != vi->max_queue_pairs && queue_pairs != 1)
+		return -EINVAL;
+
+	vi->curr_queue_pairs = queue_pairs;
+	BUG_ON(virtnet_set_queues(vi));
+
+	netif_set_real_num_tx_queues(dev, vi->curr_queue_pairs);
+	netif_set_real_num_rx_queues(dev, vi->curr_queue_pairs);
+
+	return 0;
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
 
 static int __init init(void)
-- 
1.7.1


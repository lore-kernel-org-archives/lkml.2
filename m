Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab2LZHG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 02:06:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:22238 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab2LZHGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 02:06:54 -0500
X-IronPort-AV: E=Sophos;i="4.84,355,1355068800"; 
   d="scan'208";a="6476827"
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [RFC PATCH] virtio-net: reset virtqueue affinity when doing cpu hotplug
Date: Wed, 26 Dec 2012 15:06:54 +0800
Message-Id: <1356505614-16683-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/26 15:06:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/26 15:06:41,
	Serialize complete at 2012/12/26 15:06:41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a cpu notifier to virtio-net, so that we can reset the
virtqueue affinity if the cpu hotplug happens. It improve
the performance through enabling or disabling the virtqueue
affinity after doing cpu hotplug.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: virtualization@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 drivers/net/virtio_net.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index a6fcf15..9710cf4 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -26,6 +26,7 @@
 #include <linux/scatterlist.h>
 #include <linux/if_vlan.h>
 #include <linux/slab.h>
+#include <linux/cpu.h>
 
 static int napi_weight = 128;
 module_param(napi_weight, int, 0444);
@@ -34,6 +35,8 @@ static bool csum = true, gso = true;
 module_param(csum, bool, 0444);
 module_param(gso, bool, 0444);
 
+static bool cpu_hotplug = false;
+
 /* FIXME: MTU in config. */
 #define MAX_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
 #define GOOD_COPY_LEN	128
@@ -1041,6 +1044,26 @@ static void virtnet_set_affinity(struct virtnet_info *vi, bool set)
 		vi->affinity_hint_set = false;
 }
 
+static int virtnet_cpu_callback(struct notifier_block *nfb,
+			       unsigned long action, void *hcpu)
+{
+	switch(action) {
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		cpu_hotplug = true;
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block virtnet_cpu_notifier = {
+	.notifier_call = virtnet_cpu_callback,
+};
+
 static void virtnet_get_ringparam(struct net_device *dev,
 				struct ethtool_ringparam *ring)
 {
@@ -1131,7 +1154,14 @@ static int virtnet_change_mtu(struct net_device *dev, int new_mtu)
  */
 static u16 virtnet_select_queue(struct net_device *dev, struct sk_buff *skb)
 {
-	int txq = skb_rx_queue_recorded(skb) ? skb_get_rx_queue(skb) :
+	int txq;
+
+	if (unlikely(cpu_hotplug == true)) {
+		virtnet_set_affinity(netdev_priv(dev), true);
+		cpu_hotplug = false;
+	}
+
+	txq = skb_rx_queue_recorded(skb) ? skb_get_rx_queue(skb) :
 		  smp_processor_id();
 
 	while (unlikely(txq >= dev->real_num_tx_queues))
@@ -1248,6 +1278,8 @@ static void virtnet_del_vqs(struct virtnet_info *vi)
 {
 	struct virtio_device *vdev = vi->vdev;
 
+	unregister_hotcpu_notifier(&virtnet_cpu_notifier);
+
 	virtnet_set_affinity(vi, false);
 
 	vdev->config->del_vqs(vdev);
@@ -1372,6 +1404,11 @@ static int init_vqs(struct virtnet_info *vi)
 		goto err_free;
 
 	virtnet_set_affinity(vi, true);
+
+	ret = register_hotcpu_notifier(&virtnet_cpu_notifier);
+	if (ret)
+		goto err_free;
+
 	return 0;
 
 err_free:
-- 
1.8.0


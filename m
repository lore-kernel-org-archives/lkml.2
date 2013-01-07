Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab3AGHPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 02:15:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:38609 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751600Ab3AGHOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 02:14:47 -0500
X-IronPort-AV: E=Sophos;i="4.84,422,1355068800"; 
   d="scan'208";a="6535599"
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Eric Dumazet <erdnetdev@gmail.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH V2 2/2] virtio-net: reset virtqueue affinity when doing cpu hotplug
Date: Mon, 7 Jan 2013 15:15:00 +0800
Message-Id: <1357542900-15557-2-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357542900-15557-1-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1357542900-15557-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/07 15:14:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/07 15:14:17,
	Serialize complete at 2013/01/07 15:14:17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a cpu notifier to virtio-net, so that we can reset the
virtqueue affinity if the cpu hotplug happens. It improve
the performance through enabling or disabling the virtqueue
affinity after doing cpu hotplug.
Adding the notifier block to virtnet_info is suggested by
Jason, thank you.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Eric Dumazet <erdnetdev@gmail.com>
Cc: virtualization@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 drivers/net/virtio_net.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index b483fb5..9547b4c 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -26,6 +26,7 @@
 #include <linux/scatterlist.h>
 #include <linux/if_vlan.h>
 #include <linux/slab.h>
+#include <linux/cpu.h>
 
 static int napi_weight = 128;
 module_param(napi_weight, int, 0444);
@@ -123,6 +124,9 @@ struct virtnet_info {
 
 	/* Does the affinity hint is set for virtqueues? */
 	bool affinity_hint_set;
+
+	/* CPU hot plug notifier */
+	struct notifier_block nb;
 };
 
 struct skb_vnet_hdr {
@@ -1051,6 +1055,23 @@ static void virtnet_set_affinity(struct virtnet_info *vi, bool set)
 	}
 }
 
+static int virtnet_cpu_callback(struct notifier_block *nfb,
+			        unsigned long action, void *hcpu)
+{
+	struct virtnet_info *vi = container_of(nfb, struct virtnet_info, nb);
+	switch(action) {
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		virtnet_set_affinity(vi, true);
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
 static void virtnet_get_ringparam(struct net_device *dev,
 				struct ethtool_ringparam *ring)
 {
@@ -1509,6 +1530,13 @@ static int virtnet_probe(struct virtio_device *vdev)
 		}
 	}
 
+	vi->nb.notifier_call = &virtnet_cpu_callback;
+	err = register_hotcpu_notifier(&vi->nb);
+	if (err) {
+		pr_debug("virtio_net: registering cpu notifier failed\n");
+		goto free_recv_bufs;
+	}
+
 	/* Assume link up if device can't report link status,
 	   otherwise get link status from config. */
 	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_STATUS)) {
@@ -1553,6 +1581,8 @@ static void virtnet_remove(struct virtio_device *vdev)
 {
 	struct virtnet_info *vi = vdev->priv;
 
+	unregister_hotcpu_notifier(&vi->nb);
+
 	/* Prevent config work handler from accessing the device. */
 	mutex_lock(&vi->config_lock);
 	vi->config_enable = false;
-- 
1.8.1


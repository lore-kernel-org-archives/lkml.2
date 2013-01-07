Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab3AGHOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 02:14:47 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:38609 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751274Ab3AGHOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 02:14:44 -0500
X-IronPort-AV: E=Sophos;i="4.84,422,1355068800"; 
   d="scan'208";a="6535598"
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Eric Dumazet <erdnetdev@gmail.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH V2 1/2] virtio-net: fix the set affinity bug when CPU IDs are not consecutive
Date: Mon, 7 Jan 2013 15:14:59 +0800
Message-Id: <1357542900-15557-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/07 15:14:12,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/07 15:14:13,
	Serialize complete at 2013/01/07 15:14:13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As M.S.T mentioned, set affinity will not work very well when
CPU IDs are not consecutive, this can happen with hot unplug.
Fix this bug by traversal the online CPUs.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Eric Dumazet <erdnetdev@gmail.com>
Cc: virtualization@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 drivers/net/virtio_net.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index a6fcf15..b483fb5 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1016,6 +1016,7 @@ static int virtnet_vlan_rx_kill_vid(struct net_device *dev, u16 vid)
 static void virtnet_set_affinity(struct virtnet_info *vi, bool set)
 {
 	int i;
+	int cpu;
 
 	/* In multiqueue mode, when the number of cpu is equal to the number of
 	 * queue pairs, we let the queue pairs to be private to one cpu by
@@ -1029,16 +1030,25 @@ static void virtnet_set_affinity(struct virtnet_info *vi, bool set)
 			return;
 	}
 
-	for (i = 0; i < vi->max_queue_pairs; i++) {
-		int cpu = set ? i : -1;
-		virtqueue_set_affinity(vi->rq[i].vq, cpu);
-		virtqueue_set_affinity(vi->sq[i].vq, cpu);
-	}
+	if (set) {
+		i = 0;
+		for_each_online_cpu(cpu) {
+			virtqueue_set_affinity(vi->rq[i].vq, cpu);
+			virtqueue_set_affinity(vi->sq[i].vq, cpu);
+			i++;
+			if (i >= vi->max_queue_pairs)
+				break;
+		}
 
-	if (set)
 		vi->affinity_hint_set = true;
-	else
+	} else {
+		for(i = 0; i < vi->max_queue_pairs; i++) {
+			virtqueue_set_affinity(vi->rq[i].vq, -1);
+			virtqueue_set_affinity(vi->sq[i].vq, -1);
+		}
+
 		vi->affinity_hint_set = false;
+	}
 }
 
 static void virtnet_get_ringparam(struct net_device *dev,
-- 
1.8.1


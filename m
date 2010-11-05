Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab0KEJmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 05:42:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab0KEJmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 05:42:39 -0400
Subject: [RESEND PATCH] virtio-net: init link state correctly
To: netdev@vger.kernel.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, davem@davemloft.net
From: Jason Wang <jasowang@redhat.com>
Cc: markmc@redhat.com, kvm@vger.kernel.org, mst@redhat.com
Date: Fri, 05 Nov 2010 17:47:18 +0800
Message-ID: <20101105094718.19101.58898.stgit@dhcp-91-158.nay.redhat.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For device that supports VIRTIO_NET_F_STATUS, there's no need to
assume the link is up and we need to call nerif_carrier_off() before
querying device status, otherwise we may get wrong operstate after
diver was loaded because the link watch event was not fired as
expected.

For device that does not support VIRITO_NET_F_STATUS, we could not get
its status through virtnet_update_status() and what we can only do is
always assuming the link is up.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index bb6b67f..b6d4028 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -986,9 +986,15 @@ static int virtnet_probe(struct virtio_device *vdev)
 		goto unregister;
 	}
 
-	vi->status = VIRTIO_NET_S_LINK_UP;
-	virtnet_update_status(vi);
-	netif_carrier_on(dev);
+	/* Assume link up if device can't report link status,
+	   otherwise get link status from config. */
+	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_STATUS)) {
+		netif_carrier_off(dev);
+		virtnet_update_status(vi);
+	} else {
+		vi->status = VIRTIO_NET_S_LINK_UP;
+		netif_carrier_on(dev);
+	}
 
 	pr_debug("virtnet: registered device %s\n", dev->name);
 	return 0;


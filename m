Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab0KECpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 22:45:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112Ab0KECpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 22:45:32 -0400
Subject: [V2 PATCH] virtio-net: init link state correctly
To: rusty@rustcorp.com.au, davem@davemloft.net
From: Jason Wang <jasowang@redhat.com>
Cc: markmc@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mst@redhat.com
Date: Fri, 05 Nov 2010 10:50:08 +0800
Message-ID: <20101105025008.3277.87697.stgit@dhcp-91-158.nay.redhat.com>
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


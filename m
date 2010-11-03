Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab0KCHED (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 03:04:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146Ab0KCHEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 03:04:01 -0400
Subject: [PATCH] virtio-net: init link state correctly
To: rusty@rustcorp.com.au, davem@davemloft.net
From: Jason Wang <jasowang@redhat.com>
Cc: markmc@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, mst@redhat.com
Date: Wed, 03 Nov 2010 15:08:17 +0800
Message-ID: <20101103070817.26272.31654.stgit@dhcp-91-158.nay.redhat.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need call netif_carrier_off() and do not assume VIRTIO_NET_S_LINKUP
before querying device state during probing, otherwise we may get
wrong operstate after driver was loaded because the link watch event
was not fired as expected.

Since the device state changed could be caught through interrupt, the
unconditional call to nerif_carrier_on() is also removed.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index bb6b67f..0a0cd35 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -986,9 +986,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 		goto unregister;
 	}
 
-	vi->status = VIRTIO_NET_S_LINK_UP;
+	netif_carrier_off(dev);
 	virtnet_update_status(vi);
-	netif_carrier_on(dev);
 
 	pr_debug("virtnet: registered device %s\n", dev->name);
 	return 0;


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab2E3QJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 12:09:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab2E3QJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 12:09:04 -0400
Date: Wed, 30 May 2012 17:21:29 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH repost] virtio-net: remove useless disable on freeze
Message-ID: <20120530142128.GA31299@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

disable_cb is just an optimization: it
can not guarantee that there are no callbacks.
In particular it doesn't have any effect when
event index is on.

Instead, detach, napi disable and reset on freeze ensure we don't run
concurrently with a callback.

Remove the useless calls so we get same behaviour
with and without event index.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Reposting a patch that seems to have fallen through cracks.

 drivers/net/virtio_net.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 9ce6995..5214b1e 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1231,11 +1231,6 @@ static int virtnet_freeze(struct virtio_device *vdev)
 	vi->config_enable = false;
 	mutex_unlock(&vi->config_lock);
 
-	virtqueue_disable_cb(vi->rvq);
-	virtqueue_disable_cb(vi->svq);
-	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ))
-		virtqueue_disable_cb(vi->cvq);
-
 	netif_device_detach(vi->dev);
 	cancel_delayed_work_sync(&vi->refill);
 
-- 
MST

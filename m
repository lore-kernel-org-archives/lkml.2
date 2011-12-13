Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab1LMImE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 03:42:04 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46711 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab1LMImB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 03:42:01 -0500
Message-ID: <1323765710.2436.2.camel@phoenix>
Subject: [PATCH RESEND] rpmsg: rename virtqueue_add_buf_gfp to
 virtqueue_add_buf
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ohad Ben-Cohen <ohad@wizery.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 13 Dec 2011 16:41:50 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 7bb7aef2 "virtio: rename virtqueue_add_buf_gfp to virtqueue_add_buf",
virtqueue_add_buf_gfp is already rename to virtqueue_add_buf now.

This patch fixes below build error:
  CC [M]  drivers/rpmsg/virtio_rpmsg_bus.o
drivers/rpmsg/virtio_rpmsg_bus.c: In function 'rpmsg_send_offchannel_raw':
drivers/rpmsg/virtio_rpmsg_bus.c:723: error: implicit declaration of function 'virtqueue_add_buf_gfp'
make[2]: *** [drivers/rpmsg/virtio_rpmsg_bus.o] Error 1
make[1]: *** [drivers/rpmsg] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
RESEND for Stephen.

I got the build error on linux-next 20111212.
So this patch is against linux-next.

Axel
 drivers/rpmsg/virtio_rpmsg_bus.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index 257683e..8980ac2 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -720,14 +720,14 @@ int rpmsg_send_offchannel_raw(struct rpmsg_channel *rpdev, u32 src, u32 dst,
 	mutex_lock(&vrp->tx_lock);
 
 	/* add message to the remote processor's virtqueue */
-	err = virtqueue_add_buf_gfp(vrp->svq, &sg, 1, 0, msg, GFP_KERNEL);
+	err = virtqueue_add_buf(vrp->svq, &sg, 1, 0, msg, GFP_KERNEL);
 	if (err < 0) {
 		/*
 		 * need to reclaim the buffer here, otherwise it's lost
 		 * (memory won't leak, but rpmsg won't use it again for TX).
 		 * this will wait for a buffer management overhaul.
 		 */
-		dev_err(dev, "virtqueue_add_buf_gfp failed: %d\n", err);
+		dev_err(dev, "virtqueue_add_buf failed: %d\n", err);
 		goto out;
 	}
 
@@ -777,7 +777,7 @@ static void rpmsg_recv_done(struct virtqueue *rvq)
 	sg_init_one(&sg, msg, sizeof(*msg) + len);
 
 	/* add the buffer back to the remote processor's virtqueue */
-	err = virtqueue_add_buf_gfp(vrp->rvq, &sg, 0, 1, msg, GFP_KERNEL);
+	err = virtqueue_add_buf(vrp->rvq, &sg, 0, 1, msg, GFP_KERNEL);
 	if (err < 0) {
 		dev_err(dev, "failed to add a virtqueue buffer: %d\n", err);
 		return;
@@ -907,7 +907,7 @@ static int rpmsg_probe(struct virtio_device *vdev)
 
 		sg_init_one(&sg, cpu_addr, RPMSG_BUF_SIZE);
 
-		err = virtqueue_add_buf_gfp(vrp->rvq, &sg, 0, 1, cpu_addr,
+		err = virtqueue_add_buf(vrp->rvq, &sg, 0, 1, cpu_addr,
 								GFP_KERNEL);
 		WARN_ON(err < 0); /* sanity check; this can't really happen */
 	}
-- 
1.7.5.4




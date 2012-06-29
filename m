Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab2F2QZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:25:48 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44468 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab2F2QZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:25:43 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 2/2] rpmsg: make sure inflight messages don't invoke just-removed callbacks
Date: Fri, 29 Jun 2012 19:25:20 +0300
Message-Id: <1340987120-10588-2-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1340987120-10588-1-git-send-email-ohad@wizery.com>
References: <1340987120-10588-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When inbound messages arrive, rpmsg core looks up their associated
endpoint (by destination address) and then invokes their callback.

We've made sure that endpoints will never be de-allocated after they
were found by rpmsg core, but we also need to protect against the
(rare) scenario where the rpmsg driver was just removed, and its
callback function isn't available anymore.

This is achieved by introducing a callback mutex, which must be taken
before the callback is invoked, and, obviously, before it is removed.

Reported-by: Fernando Guzman Lugo <fernando.lugo@ti.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/rpmsg/virtio_rpmsg_bus.c | 25 +++++++++++++++++++------
 include/linux/rpmsg.h            |  3 +++
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index d89fbc1..9057621 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -245,6 +245,7 @@ static struct rpmsg_endpoint *__rpmsg_create_ept(struct virtproc_info *vrp,
 	}
 
 	kref_init(&ept->refcount);
+	mutex_init(&ept->cb_lock);
 
 	ept->rpdev = rpdev;
 	ept->cb = cb;
@@ -342,10 +343,16 @@ EXPORT_SYMBOL(rpmsg_create_ept);
 static void
 __rpmsg_destroy_ept(struct virtproc_info *vrp, struct rpmsg_endpoint *ept)
 {
+	/* make sure new inbound messages can't find this ept anymore */
 	mutex_lock(&vrp->endpoints_lock);
 	idr_remove(&vrp->endpoints, ept->addr);
 	mutex_unlock(&vrp->endpoints_lock);
 
+	/* make sure in-flight inbound messages won't invoke cb anymore */
+	mutex_lock(&ept->cb_lock);
+	ept->cb = NULL;
+	mutex_unlock(&ept->cb_lock);
+
 	kref_put(&ept->refcount, __ept_release);
 }
 
@@ -839,14 +846,20 @@ static void rpmsg_recv_done(struct virtqueue *rvq)
 
 	mutex_unlock(&vrp->endpoints_lock);
 
-	if (ept && ept->cb)
-		ept->cb(ept->rpdev, msg->data, msg->len, ept->priv, msg->src);
-	else
-		dev_warn(dev, "msg received with no recepient\n");
+	if (ept) {
+		/* make sure ept->cb doesn't go away while we use it */
+		mutex_lock(&ept->cb_lock);
 
-	/* farewell, ept, we don't need you anymore */
-	if (ept)
+		if (ept->cb)
+			ept->cb(ept->rpdev, msg->data, msg->len, ept->priv,
+				msg->src);
+
+		mutex_unlock(&ept->cb_lock);
+
+		/* farewell, ept, we don't need you anymore */
 		kref_put(&ept->refcount, __ept_release);
+	} else
+		dev_warn(dev, "msg received with no recepient\n");
 
 	/* publish the real size of the buffer */
 	sg_init_one(&sg, msg, RPMSG_BUF_SIZE);
diff --git a/include/linux/rpmsg.h b/include/linux/rpmsg.h
index 50233e3..05d0bc8 100644
--- a/include/linux/rpmsg.h
+++ b/include/linux/rpmsg.h
@@ -39,6 +39,7 @@
 #include <linux/device.h>
 #include <linux/mod_devicetable.h>
 #include <linux/kref.h>
+#include <linux/mutex.h>
 
 /* The feature bitmap for virtio rpmsg */
 #define VIRTIO_RPMSG_F_NS	0 /* RP supports name service notifications */
@@ -123,6 +124,7 @@ typedef void (*rpmsg_rx_cb_t)(struct rpmsg_channel *, void *, int, void *, u32);
  * @rpdev: rpmsg channel device
  * @refcount: when this drops to zero, the ept is deallocated
  * @cb: rx callback handler
+ * @cb_lock: must be taken before accessing/changing @cb
  * @addr: local rpmsg address
  * @priv: private data for the driver's use
  *
@@ -144,6 +146,7 @@ struct rpmsg_endpoint {
 	struct rpmsg_channel *rpdev;
 	struct kref refcount;
 	rpmsg_rx_cb_t cb;
+	struct mutex cb_lock;
 	u32 addr;
 	void *priv;
 };
-- 
1.7.10.rc3.743.gaa3bb87


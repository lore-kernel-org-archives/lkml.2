Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485Ab2F2QZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:25:43 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50122 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285Ab2F2QZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:25:41 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 1/2] rpmsg: avoid premature deallocation of endpoints
Date: Fri, 29 Jun 2012 19:25:19 +0300
Message-Id: <1340987120-10588-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an inbound message arrives, the rpmsg core looks up its
associated endpoint and invokes the registered callback.

If a message arrives while its endpoint is being removed (because
the rpmsg driver was removed, or a recovery of a remote processor
has kicked in) we must ensure atomicity, i.e.:

- Either the ept is removed before it is found

or

- The ept is found but will not be freed until the callback returns

This is achieved by maintaining a per-ept reference count, which,
when drops to zero, will trigger deallocation of the ept.

With this in hand, it is now forbidden to directly deallocate
epts once they have been added to the endpoints idr.

Reported-by: Fernando Guzman Lugo <fernando.lugo@ti.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/rpmsg/virtio_rpmsg_bus.c | 36 ++++++++++++++++++++++++++++++++++--
 include/linux/rpmsg.h            |  3 +++
 2 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index 0af7fd3..d89fbc1 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -206,6 +206,26 @@ static int rpmsg_uevent(struct device *dev, struct kobj_uevent_env *env)
 					rpdev->id.name);
 }
 
+/**
+ * __ept_release() - deallocate an rpmsg endpoint
+ * @kref: the ept's reference count
+ *
+ * This function deallocates an ept, and is invoked when its @kref refcount
+ * drops to zero.
+ *
+ * Never invoke this function directly!
+ */
+static void __ept_release(struct kref *kref)
+{
+	struct rpmsg_endpoint *ept = container_of(kref, struct rpmsg_endpoint,
+						  refcount);
+	/*
+	 * At this point no one holds a reference to ept anymore,
+	 * so we can directly free it
+	 */
+	kfree(ept);
+}
+
 /* for more info, see below documentation of rpmsg_create_ept() */
 static struct rpmsg_endpoint *__rpmsg_create_ept(struct virtproc_info *vrp,
 		struct rpmsg_channel *rpdev, rpmsg_rx_cb_t cb,
@@ -224,6 +244,8 @@ static struct rpmsg_endpoint *__rpmsg_create_ept(struct virtproc_info *vrp,
 		return NULL;
 	}
 
+	kref_init(&ept->refcount);
+
 	ept->rpdev = rpdev;
 	ept->cb = cb;
 	ept->priv = priv;
@@ -256,7 +278,7 @@ rem_idr:
 	idr_remove(&vrp->endpoints, request);
 free_ept:
 	mutex_unlock(&vrp->endpoints_lock);
-	kfree(ept);
+	kref_put(&ept->refcount, __ept_release);
 	return NULL;
 }
 
@@ -324,7 +346,7 @@ __rpmsg_destroy_ept(struct virtproc_info *vrp, struct rpmsg_endpoint *ept)
 	idr_remove(&vrp->endpoints, ept->addr);
 	mutex_unlock(&vrp->endpoints_lock);
 
-	kfree(ept);
+	kref_put(&ept->refcount, __ept_release);
 }
 
 /**
@@ -808,7 +830,13 @@ static void rpmsg_recv_done(struct virtqueue *rvq)
 
 	/* use the dst addr to fetch the callback of the appropriate user */
 	mutex_lock(&vrp->endpoints_lock);
+
 	ept = idr_find(&vrp->endpoints, msg->dst);
+
+	/* let's make sure no one deallocates ept while we use it */
+	if (ept)
+		kref_get(&ept->refcount);
+
 	mutex_unlock(&vrp->endpoints_lock);
 
 	if (ept && ept->cb)
@@ -816,6 +844,10 @@ static void rpmsg_recv_done(struct virtqueue *rvq)
 	else
 		dev_warn(dev, "msg received with no recepient\n");
 
+	/* farewell, ept, we don't need you anymore */
+	if (ept)
+		kref_put(&ept->refcount, __ept_release);
+
 	/* publish the real size of the buffer */
 	sg_init_one(&sg, msg, RPMSG_BUF_SIZE);
 
diff --git a/include/linux/rpmsg.h b/include/linux/rpmsg.h
index 140fd67..50233e3 100644
--- a/include/linux/rpmsg.h
+++ b/include/linux/rpmsg.h
@@ -38,6 +38,7 @@
 #include <linux/types.h>
 #include <linux/device.h>
 #include <linux/mod_devicetable.h>
+#include <linux/kref.h>
 
 /* The feature bitmap for virtio rpmsg */
 #define VIRTIO_RPMSG_F_NS	0 /* RP supports name service notifications */
@@ -120,6 +121,7 @@ typedef void (*rpmsg_rx_cb_t)(struct rpmsg_channel *, void *, int, void *, u32);
 /**
  * struct rpmsg_endpoint - binds a local rpmsg address to its user
  * @rpdev: rpmsg channel device
+ * @refcount: when this drops to zero, the ept is deallocated
  * @cb: rx callback handler
  * @addr: local rpmsg address
  * @priv: private data for the driver's use
@@ -140,6 +142,7 @@ typedef void (*rpmsg_rx_cb_t)(struct rpmsg_channel *, void *, int, void *, u32);
  */
 struct rpmsg_endpoint {
 	struct rpmsg_channel *rpdev;
+	struct kref refcount;
 	rpmsg_rx_cb_t cb;
 	u32 addr;
 	void *priv;
-- 
1.7.10.rc3.743.gaa3bb87


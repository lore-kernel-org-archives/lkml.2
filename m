Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161824Ab2GLXjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:39:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54985 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759670Ab2GLWiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:38:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [ 056/187] rpmsg: avoid premature deallocation of endpoints
Date: Thu, 12 Jul 2012 15:33:32 -0700
Message-Id: <20120712191527.546476233@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ohad Ben-Cohen <ohad@wizery.com>

commit 5a081caa0414b9bbb82c17ffab9d6fe66edbb72f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rpmsg/virtio_rpmsg_bus.c |   36 ++++++++++++++++++++++++++++++++++--
 include/linux/rpmsg.h            |    3 +++
 2 files changed, 37 insertions(+), 2 deletions(-)

--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -188,6 +188,26 @@ static int rpmsg_uevent(struct device *d
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
@@ -206,6 +226,8 @@ static struct rpmsg_endpoint *__rpmsg_cr
 		return NULL;
 	}
 
+	kref_init(&ept->refcount);
+
 	ept->rpdev = rpdev;
 	ept->cb = cb;
 	ept->priv = priv;
@@ -238,7 +260,7 @@ rem_idr:
 	idr_remove(&vrp->endpoints, request);
 free_ept:
 	mutex_unlock(&vrp->endpoints_lock);
-	kfree(ept);
+	kref_put(&ept->refcount, __ept_release);
 	return NULL;
 }
 
@@ -306,7 +328,7 @@ __rpmsg_destroy_ept(struct virtproc_info
 	idr_remove(&vrp->endpoints, ept->addr);
 	mutex_unlock(&vrp->endpoints_lock);
 
-	kfree(ept);
+	kref_put(&ept->refcount, __ept_release);
 }
 
 /**
@@ -790,7 +812,13 @@ static void rpmsg_recv_done(struct virtq
 
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
@@ -798,6 +826,10 @@ static void rpmsg_recv_done(struct virtq
 	else
 		dev_warn(dev, "msg received with no recepient\n");
 
+	/* farewell, ept, we don't need you anymore */
+	if (ept)
+		kref_put(&ept->refcount, __ept_release);
+
 	/* publish the real size of the buffer */
 	sg_init_one(&sg, msg, RPMSG_BUF_SIZE);
 
--- a/include/linux/rpmsg.h
+++ b/include/linux/rpmsg.h
@@ -38,6 +38,7 @@
 #include <linux/types.h>
 #include <linux/device.h>
 #include <linux/mod_devicetable.h>
+#include <linux/kref.h>
 
 /* The feature bitmap for virtio rpmsg */
 #define VIRTIO_RPMSG_F_NS	0 /* RP supports name service notifications */
@@ -120,6 +121,7 @@ typedef void (*rpmsg_rx_cb_t)(struct rpm
 /**
  * struct rpmsg_endpoint - binds a local rpmsg address to its user
  * @rpdev: rpmsg channel device
+ * @refcount: when this drops to zero, the ept is deallocated
  * @cb: rx callback handler
  * @addr: local rpmsg address
  * @priv: private data for the driver's use
@@ -140,6 +142,7 @@ typedef void (*rpmsg_rx_cb_t)(struct rpm
  */
 struct rpmsg_endpoint {
 	struct rpmsg_channel *rpdev;
+	struct kref refcount;
 	rpmsg_rx_cb_t cb;
 	u32 addr;
 	void *priv;



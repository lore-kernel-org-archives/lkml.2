Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab2EZHg4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 03:36:56 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47170 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab2EZHgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 03:36:54 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>
Subject: [PATCH 2/2] remoteproc: remove the now-redundant kref
Date: Sat, 26 May 2012 10:36:31 +0300
Message-Id: <1338017791-9442-2-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1338017791-9442-1-git-send-email-ohad@wizery.com>
References: <1338017791-9442-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that every rproc instance contains a device, we don't need a
kref anymore to maintain the refcount of the rproc instances:
that's what device are good with!

This patch removes the now-redundant kref, and switches to
{get, put}_device instead of kref_{get, put}.

We also don't need the kref's release function anymore, and instead,
we just utilize the class's release handler (which is now responsible
for all memory de-allocations).

Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/remoteproc/remoteproc_core.c   |   59 +++++++++++---------------------
 drivers/remoteproc/remoteproc_virtio.c |    8 ++--
 include/linux/remoteproc.h             |    3 --
 3 files changed, 24 insertions(+), 46 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 9e3d4cf..7214393 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1269,42 +1269,12 @@ out:
 }
 EXPORT_SYMBOL(rproc_shutdown);
 
-/**
- * rproc_release() - completely deletes the existence of a remote processor
- * @kref: the rproc's kref
- *
- * This function should _never_ be called directly.
- *
- * The only reasonable location to use it is as an argument when kref_put'ing
- * @rproc's refcount.
- *
- * This way it will be called when no one holds a valid pointer to this @rproc
- * anymore (and obviously after it is removed from the rprocs klist).
- *
- * Note: this function is not static because rproc_vdev_release() needs it when
- * it decrements @rproc's refcount.
- */
-void rproc_release(struct kref *kref)
-{
-	struct rproc *rproc = container_of(kref, struct rproc, refcount);
-
-	dev_info(&rproc->dev, "removing %s\n", rproc->name);
-
-	rproc_delete_debug_dir(rproc);
-
-	/*
-	 * At this point no one holds a reference to rproc anymore,
-	 * so we can directly unroll rproc_alloc()
-	 */
-	rproc_free(rproc);
-}
-
 /* will be called when an rproc is added to the rprocs klist */
 static void klist_rproc_get(struct klist_node *n)
 {
 	struct rproc *rproc = container_of(n, struct rproc, node);
 
-	kref_get(&rproc->refcount);
+	get_device(&rproc->dev);
 }
 
 /* will be called when an rproc is removed from the rprocs klist */
@@ -1312,7 +1282,7 @@ static void klist_rproc_put(struct klist_node *n)
 {
 	struct rproc *rproc = container_of(n, struct rproc, node);
 
-	kref_put(&rproc->refcount, rproc_release);
+	put_device(&rproc->dev);
 }
 
 static struct rproc *next_rproc(struct klist_iter *i)
@@ -1354,7 +1324,7 @@ struct rproc *rproc_get_by_name(const char *name)
 	klist_iter_init(&rprocs, &i);
 	while ((rproc = next_rproc(&i)) != NULL)
 		if (!strcmp(rproc->name, name)) {
-			kref_get(&rproc->refcount);
+			get_device(&rproc->dev);
 			break;
 		}
 	klist_iter_exit(&i);
@@ -1367,7 +1337,7 @@ struct rproc *rproc_get_by_name(const char *name)
 
 	ret = rproc_boot(rproc);
 	if (ret < 0) {
-		kref_put(&rproc->refcount, rproc_release);
+		put_device(&rproc->dev);
 		return NULL;
 	}
 
@@ -1394,7 +1364,7 @@ void rproc_put(struct rproc *rproc)
 	rproc_shutdown(rproc);
 
 	/* downref rproc's refcount */
-	kref_put(&rproc->refcount, rproc_release);
+	put_device(&rproc->dev);
 }
 EXPORT_SYMBOL(rproc_put);
 
@@ -1462,10 +1432,23 @@ int rproc_register(struct rproc *rproc)
 }
 EXPORT_SYMBOL(rproc_register);
 
+/**
+ * rproc_class_release() - release a remote processor instance
+ * @dev: the rproc's device
+ *
+ * This function should _never_ be called directly.
+ *
+ * It will be called by the driver core when no one holds a valid pointer
+ * to @dev anymore.
+ */
 static void rproc_class_release(struct device *dev)
 {
 	struct rproc *rproc = container_of(dev, struct rproc, dev);
 
+	dev_info(&rproc->dev, "releasing %s\n", rproc->name);
+
+	rproc_delete_debug_dir(rproc);
+
 	idr_remove_all(&rproc->notifyids);
 	idr_destroy(&rproc->notifyids);
 
@@ -1531,8 +1514,6 @@ struct rproc *rproc_alloc(struct device *dev, const char *name,
 
 	atomic_set(&rproc->power, 0);
 
-	kref_init(&rproc->refcount);
-
 	mutex_init(&rproc->lock);
 
 	idr_init(&rproc->notifyids);
@@ -1603,8 +1584,8 @@ int rproc_unregister(struct rproc *rproc)
 
 	device_del(&rproc->dev);
 
-	/* the rproc will only be released after its refcount drops to zero */
-	kref_put(&rproc->refcount, rproc_release);
+	/* unroll rproc_alloc. TODO: we may want to let the users do that */
+	put_device(&rproc->dev);
 
 	return 0;
 }
diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index b662183..3541b44 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -225,7 +225,7 @@ static struct virtio_config_ops rproc_virtio_config_ops = {
 
 /*
  * This function is called whenever vdev is released, and is responsible
- * to decrement the remote processor's refcount taken when vdev was
+ * to decrement the remote processor's refcount which was taken when vdev was
  * added.
  *
  * Never call this function directly; it will be called by the driver
@@ -240,7 +240,7 @@ static void rproc_vdev_release(struct device *dev)
 	list_del(&rvdev->node);
 	kfree(rvdev);
 
-	kref_put(&rproc->refcount, rproc_release);
+	put_device(&rproc->dev);
 }
 
 /**
@@ -272,11 +272,11 @@ int rproc_add_virtio_dev(struct rproc_vdev *rvdev, int id)
 	 * Therefore we must increment the rproc refcount here, and decrement
 	 * it _only_ when the vdev is released.
 	 */
-	kref_get(&rproc->refcount);
+	get_device(&rproc->dev);
 
 	ret = register_virtio_device(vdev);
 	if (ret) {
-		kref_put(&rproc->refcount, rproc_release);
+		put_device(&rproc->dev);
 		dev_err(dev, "failed to register vdev: %d\n", ret);
 		goto out;
 	}
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index 0b835d3..c6e46fa 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -36,7 +36,6 @@
 #define REMOTEPROC_H
 
 #include <linux/types.h>
-#include <linux/kref.h>
 #include <linux/klist.h>
 #include <linux/mutex.h>
 #include <linux/virtio.h>
@@ -370,7 +369,6 @@ enum rproc_state {
  * @priv: private data which belongs to the platform-specific rproc module
  * @ops: platform-specific start/stop rproc handlers
  * @dev: underlying device
- * @refcount: refcount of users that have a valid pointer to this rproc
  * @power: refcount of users who need this rproc powered up
  * @state: state of the device
  * @lock: lock which protects concurrent manipulations of the rproc
@@ -393,7 +391,6 @@ struct rproc {
 	void *priv;
 	const struct rproc_ops *ops;
 	struct device dev;
-	struct kref refcount;
 	atomic_t power;
 	unsigned int state;
 	struct mutex lock;
-- 
1.7.5.4


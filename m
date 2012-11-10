Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab2KJN7m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 08:59:42 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35620 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab2KJN7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 08:59:37 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Yinghai Lu <yinghai@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>
Subject: [RFC PATCH 5/6] VFIO: simplify IOMMU group notification handler
Date: Sat, 10 Nov 2012 21:57:18 +0800
Message-Id: <1352555839-18961-5-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352555839-18961-1-git-send-email-jiang.liu@huawei.com>
References: <1352555839-18961-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From: Jiang Liu <jiang.liu@huawei.com>

Now we have a way to reject binding unsafe drivers to devices belonging
to active VFIO groups, so we could simplify IOMMU group notification
handler to only handle IOMMU_GROUP_NOTIFY_SOLICIT_BINDING event.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/vfio/vfio.c |   90 ++++-----------------------------------------------
 1 file changed, 6 insertions(+), 84 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 02da980..18714b9 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -538,57 +538,6 @@ static int vfio_dev_viable(struct device *dev, void *data)
 /**
  * Async device support
  */
-static int vfio_group_nb_add_dev(struct vfio_group *group, struct device *dev)
-{
-	struct vfio_device *device;
-
-	/* Do we already know about it?  We shouldn't */
-	device = vfio_group_get_device(group, dev);
-	if (WARN_ON_ONCE(device)) {
-		vfio_device_put(device);
-		return 0;
-	}
-
-	/* Nothing to do for idle groups */
-	if (!atomic_read(&group->container_users))
-		return 0;
-
-	WARN("Device %s added to live group %d!\n", dev_name(dev),
-	     iommu_group_id(group->iommu_group));
-
-	return 0;
-}
-
-static int vfio_group_nb_del_dev(struct vfio_group *group, struct device *dev)
-{
-	struct vfio_device *device;
-
-	/*
-	 * Expect to fall out here.  If a device was in use, it would
-	 * have been bound to a vfio sub-driver, which would have blocked
-	 * in .remove at vfio_del_group_dev.  Sanity check that we no
-	 * longer track the device, so it's safe to remove.
-	 */
-	device = vfio_group_get_device(group, dev);
-	if (likely(!device))
-		return 0;
-
-	WARN("Device %s removed from live group %d!\n", dev_name(dev),
-	     iommu_group_id(group->iommu_group));
-
-	vfio_device_put(device);
-	return 0;
-}
-
-static int vfio_group_nb_verify(struct vfio_group *group, struct device *dev)
-{
-	/* We don't care what happens when the group isn't in use */
-	if (!atomic_read(&group->container_users))
-		return 0;
-
-	return vfio_dev_viable(dev, group);
-}
-
 static int vfio_group_nb_solicit_binding(struct vfio_group *group,
 					 struct device *dev)
 {
@@ -614,6 +563,9 @@ static int vfio_iommu_group_notifier(struct notifier_block *nb,
 	struct vfio_group *group = container_of(nb, struct vfio_group, nb);
 	struct device *dev = data;
 
+	if (action != IOMMU_GROUP_NOTIFY_SOLICIT_BINDING)
+		return NOTIFY_DONE;
+
 	/*
 	 * Need to go through a group_lock lookup to get a reference or
 	 * we risk racing a group being removed.  Leave a WARN_ON for
@@ -624,41 +576,11 @@ static int vfio_iommu_group_notifier(struct notifier_block *nb,
 	if (WARN_ON(!group))
 		return NOTIFY_OK;
 
-	switch (action) {
-	case IOMMU_GROUP_NOTIFY_ADD_DEVICE:
-		vfio_group_nb_add_dev(group, dev);
-		break;
-	case IOMMU_GROUP_NOTIFY_DEL_DEVICE:
-		vfio_group_nb_del_dev(group, dev);
-		break;
-	case IOMMU_GROUP_NOTIFY_SOLICIT_BINDING:
-		if (vfio_group_nb_solicit_binding(group, dev))
-			ret = notifier_from_errno(-EBUSY);
-		break;
-	case IOMMU_GROUP_NOTIFY_BIND_DRIVER:
-		pr_debug("%s: Device %s, group %d binding to driver\n",
-			 __func__, dev_name(dev),
-			 iommu_group_id(group->iommu_group));
-		break;
-	case IOMMU_GROUP_NOTIFY_BOUND_DRIVER:
-		pr_debug("%s: Device %s, group %d bound to driver %s\n",
-			 __func__, dev_name(dev),
-			 iommu_group_id(group->iommu_group), dev->driver->name);
-		BUG_ON(vfio_group_nb_verify(group, dev));
-		break;
-	case IOMMU_GROUP_NOTIFY_UNBIND_DRIVER:
-		pr_debug("%s: Device %s, group %d unbinding from driver %s\n",
-			 __func__, dev_name(dev),
-			 iommu_group_id(group->iommu_group), dev->driver->name);
-		break;
-	case IOMMU_GROUP_NOTIFY_UNBOUND_DRIVER:
-		pr_debug("%s: Device %s, group %d unbound from driver\n",
-			 __func__, dev_name(dev),
-			 iommu_group_id(group->iommu_group));
-		break;
-	}
+	if (vfio_group_nb_solicit_binding(group, dev))
+		ret = notifier_from_errno(-EBUSY);
 
 	vfio_group_put(group);
+
 	return ret;
 }
 
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab2KJN70 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 08:59:26 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:47743 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab2KJN7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 08:59:22 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Yinghai Lu <yinghai@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>
Subject: [RFC PATCH 3/6] VFIO: unregister IOMMU notifier on error recovery path
Date: Sat, 10 Nov 2012 21:57:16 +0800
Message-Id: <1352555839-18961-3-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352555839-18961-1-git-send-email-jiang.liu@huawei.com>
References: <1352555839-18961-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From: Jiang Liu <jiang.liu@huawei.com>

On error recovery path in function vfio_create_group(), it should
unregister the IOMMU notifier for the new VFIO group. Otherwise it may
cause invalid memory access later when handling bus notifications.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/vfio/vfio.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 17830c9..3359ec2 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -191,6 +191,17 @@ static void vfio_container_put(struct vfio_container *container)
 	kref_put(&container->kref, vfio_container_release);
 }
 
+static void vfio_group_unlock_and_free(struct vfio_group *group)
+{
+	mutex_unlock(&vfio.group_lock);
+	/*
+	 * Unregister outside of lock.  A spurious callback is harmless now
+	 * that the group is no longer in vfio.group_list.
+	 */
+	iommu_group_unregister_notifier(group->iommu_group, &group->nb);
+	kfree(group);
+}
+
 /**
  * Group objects - create, release, get, put, search
  */
@@ -229,8 +240,7 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group)
 
 	minor = vfio_alloc_group_minor(group);
 	if (minor < 0) {
-		mutex_unlock(&vfio.group_lock);
-		kfree(group);
+		vfio_group_unlock_and_free(group);
 		return ERR_PTR(minor);
 	}
 
@@ -239,8 +249,7 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group)
 		if (tmp->iommu_group == iommu_group) {
 			vfio_group_get(tmp);
 			vfio_free_group_minor(minor);
-			mutex_unlock(&vfio.group_lock);
-			kfree(group);
+			vfio_group_unlock_and_free(group);
 			return tmp;
 		}
 	}
@@ -249,8 +258,7 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group)
 			    group, "%d", iommu_group_id(iommu_group));
 	if (IS_ERR(dev)) {
 		vfio_free_group_minor(minor);
-		mutex_unlock(&vfio.group_lock);
-		kfree(group);
+		vfio_group_unlock_and_free(group);
 		return (struct vfio_group *)dev; /* ERR_PTR */
 	}
 
@@ -274,16 +282,7 @@ static void vfio_group_release(struct kref *kref)
 	device_destroy(vfio.class, MKDEV(MAJOR(vfio.devt), group->minor));
 	list_del(&group->vfio_next);
 	vfio_free_group_minor(group->minor);
-
-	mutex_unlock(&vfio.group_lock);
-
-	/*
-	 * Unregister outside of lock.  A spurious callback is harmless now
-	 * that the group is no longer in vfio.group_list.
-	 */
-	iommu_group_unregister_notifier(group->iommu_group, &group->nb);
-
-	kfree(group);
+	vfio_group_unlock_and_free(group);
 }
 
 static void vfio_group_put(struct vfio_group *group)
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab2KJN7T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 08:59:19 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35620 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab2KJN7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 08:59:15 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Yinghai Lu <yinghai@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>
Subject: [RFC PATCH 2/6] iommu: pass on BUS_NOTIFY_QUERY_BINDING to iommu group notifier clients
Date: Sat, 10 Nov 2012 21:57:15 +0800
Message-Id: <1352555839-18961-2-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352555839-18961-1-git-send-email-jiang.liu@huawei.com>
References: <1352555839-18961-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From: Jiang Liu <jiang.liu@huawei.com>

Pass on BUS_NOTIFY_QUERY_BINDING event to iommu group notifier clients,
so notifier clients have a chance to reject device driver binding.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/iommu/iommu.c |   14 +++++++++-----
 include/linux/iommu.h |    1 +
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index ddbdaca..7fbe055 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -497,6 +497,7 @@ static int add_iommu_group(struct device *dev, void *data)
 static int iommu_bus_notifier(struct notifier_block *nb,
 			      unsigned long action, void *data)
 {
+	int ret = NOTIFY_DONE;
 	struct device *dev = data;
 	struct iommu_ops *ops = dev->bus->iommu_ops;
 	struct iommu_group *group;
@@ -512,7 +513,7 @@ static int iommu_bus_notifier(struct notifier_block *nb,
 	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
 		if (ops->remove_device && dev->iommu_group) {
 			ops->remove_device(dev);
-			return 0;
+			return NOTIFY_DONE;
 		}
 	}
 
@@ -522,9 +523,12 @@ static int iommu_bus_notifier(struct notifier_block *nb,
 	 */
 	group = iommu_group_get(dev);
 	if (!group)
-		return 0;
+		return NOTIFY_DONE;
 
 	switch (action) {
+	case BUS_NOTIFY_SOLICIT_BINDING:
+		group_action = IOMMU_GROUP_NOTIFY_SOLICIT_BINDING;
+		break;
 	case BUS_NOTIFY_BIND_DRIVER:
 		group_action = IOMMU_GROUP_NOTIFY_BIND_DRIVER;
 		break;
@@ -540,11 +544,11 @@ static int iommu_bus_notifier(struct notifier_block *nb,
 	}
 
 	if (group_action)
-		blocking_notifier_call_chain(&group->notifier,
-					     group_action, dev);
+		ret = blocking_notifier_call_chain(&group->notifier,
+						   group_action, dev);
 
 	iommu_group_put(group);
-	return 0;
+	return ret;
 }
 
 static struct notifier_block iommu_bus_nb = {
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 7e83370..366435b 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -109,6 +109,7 @@ struct iommu_ops {
 #define IOMMU_GROUP_NOTIFY_BOUND_DRIVER		4 /* Post Driver bind */
 #define IOMMU_GROUP_NOTIFY_UNBIND_DRIVER	5 /* Pre Driver unbind */
 #define IOMMU_GROUP_NOTIFY_UNBOUND_DRIVER	6 /* Post Driver unbind */
+#define IOMMU_GROUP_NOTIFY_SOLICIT_BINDING	7 /* Check for objections */
 
 extern int bus_set_iommu(struct bus_type *bus, struct iommu_ops *ops);
 extern bool iommu_present(struct bus_type *bus);
-- 
1.7.9.5


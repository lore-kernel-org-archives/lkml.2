Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab2D1FjU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 01:39:20 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:53941 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab2D1FjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 01:39:18 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        parav.pandit@emulex.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH] RDMA/ocrdma: Don't sleep in atomic notifier handler
Date: Sat, 28 Apr 2012 07:40:01 +0200
Message-Id: <1335591601-26473-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Events sent to ocrdma_inet6addr_event() are sent from an atomic context, therefore
we can't try to lock a mutex within the notifier callback.

We could just switch the mutex to a spinlock since all it does it protect a list,
but I've went ahead and switched the list to use RCU instead. I couldn't fully test
it since I don't have IB hardware, so if it doesn't fully work for some reason let
me know and I'll switch it back to using a spinlock.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h      |    1 +
 drivers/infiniband/hw/ocrdma/ocrdma_main.c |   38 ++++++++++++++++-----------
 2 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index d7a44b8..85a69c9 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -168,6 +168,7 @@ struct ocrdma_dev {
 	struct be_dev_info nic_info;
 
 	struct list_head entry;
+	struct rcu_head rcu;
 	int id;
 };
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index cee201e..bc9009f 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -47,7 +47,7 @@ MODULE_AUTHOR("Emulex Corporation");
 MODULE_LICENSE("GPL");
 
 static LIST_HEAD(ocrdma_dev_list);
-static DEFINE_MUTEX(ocrdma_devlist_lock);
+static DEFINE_SPINLOCK(ocrdma_devlist_lock);
 static DEFINE_IDR(ocrdma_dev_id);
 
 static union ib_gid ocrdma_zero_sgid;
@@ -221,14 +221,14 @@ static int ocrdma_inet6addr_event(struct notifier_block *notifier,
 		is_vlan = true;
 		vid = vlan_dev_vlan_id(event_netdev);
 	}
-	mutex_lock(&ocrdma_devlist_lock);
-	list_for_each_entry(dev, &ocrdma_dev_list, entry) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(dev, &ocrdma_dev_list, entry) {
 		if (dev->nic_info.netdev == netdev) {
 			found = true;
 			break;
 		}
 	}
-	mutex_unlock(&ocrdma_devlist_lock);
+	rcu_read_unlock();
 
 	if (!found)
 		return NOTIFY_DONE;
@@ -431,9 +431,9 @@ static struct ocrdma_dev *ocrdma_add(struct be_dev_info *dev_info)
 	if (status)
 		goto alloc_err;
 
-	mutex_lock(&ocrdma_devlist_lock);
-	list_add_tail(&dev->entry, &ocrdma_dev_list);
-	mutex_unlock(&ocrdma_devlist_lock);
+	spin_lock(&ocrdma_devlist_lock);
+	list_add_tail_rcu(&dev->entry, &ocrdma_dev_list);
+	spin_lock(&ocrdma_devlist_lock);
 	return dev;
 
 alloc_err:
@@ -448,16 +448,9 @@ idr_err:
 	return NULL;
 }
 
-static void ocrdma_remove(struct ocrdma_dev *dev)
+static void ocrdma_remove_free(struct rcu_head *rcu)
 {
-	/* first unregister with stack to stop all the active traffic
-	 * of the registered clients.
-	 */
-	ib_unregister_device(&dev->ibdev);
-
-	mutex_lock(&ocrdma_devlist_lock);
-	list_del(&dev->entry);
-	mutex_unlock(&ocrdma_devlist_lock);
+	struct ocrdma_dev *dev = container_of(rcu, struct ocrdma_dev, rcu);
 
 	ocrdma_free_resources(dev);
 	ocrdma_cleanup_hw(dev);
@@ -467,6 +460,19 @@ static void ocrdma_remove(struct ocrdma_dev *dev)
 	ib_dealloc_device(&dev->ibdev);
 }
 
+static void ocrdma_remove(struct ocrdma_dev *dev)
+{
+	/* first unregister with stack to stop all the active traffic
+	 * of the registered clients.
+	 */
+	ib_unregister_device(&dev->ibdev);
+
+	spin_lock(&ocrdma_devlist_lock);
+	list_del_rcu(&dev->entry);
+	spin_unlock(&ocrdma_devlist_lock);
+	call_rcu(&dev->rcu, ocrdma_remove_free);
+}
+
 static int ocrdma_open(struct ocrdma_dev *dev)
 {
 	struct ib_event port_event;
-- 
1.7.8.5


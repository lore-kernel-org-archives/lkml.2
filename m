Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760527Ab2D0PUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:20:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61293 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760514Ab2D0PUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:20:25 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v2 03/19] PCI: replace pci_remove_rescan_mutex with the PCI hotplug lock
Date: Fri, 27 Apr 2012 23:16:44 +0800
Message-Id: <1335539820-11232-4-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
References: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Replace pci_remove_rescan_mutex with the PCI hotplug lock, which is used to
globally serialize all PCI hotplug operations.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/pci-sysfs.c |  100 +++++++++++++++++++++++++++--------------------
 drivers/pci/remove.c    |    1 +
 2 files changed, 58 insertions(+), 43 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index a55e248..ecf197d 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -283,7 +283,31 @@ msi_bus_store(struct device *dev, struct device_attribute *attr,
 }
 
 #ifdef CONFIG_HOTPLUG
-static DEFINE_MUTEX(pci_remove_rescan_mutex);
+/*
+ * Schedule a device callback to avoid deadlock in case of
+ * 1) An attribute method tries to deregister the sysfs file itself
+ * 2) Another thread is trying to remove the sysfs file, which have
+ *    already held the PCI hotplug lock by invoking pci_hotplug_enter().
+ */
+static int schedule_hp_callback(struct device *dev,
+				const char *buf, size_t count,
+				void (*func)(struct device *))
+{
+	int ret = 0;
+	unsigned long val;
+
+	if (kstrtoul(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	if (val) {
+		ret = device_schedule_callback(dev, func);
+		if (ret)
+			count = ret;
+	}
+
+	return count;
+}
+
 static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf,
 				size_t count)
 {
@@ -294,10 +318,10 @@ static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf,
 		return -EINVAL;
 
 	if (val) {
-		mutex_lock(&pci_remove_rescan_mutex);
+		pci_hotplug_enter();
 		while ((b = pci_find_next_bus(b)) != NULL)
 			pci_rescan_bus(b);
-		mutex_unlock(&pci_remove_rescan_mutex);
+		pci_hotplug_exit();
 	}
 	return count;
 }
@@ -307,72 +331,62 @@ struct bus_attribute pci_bus_attrs[] = {
 	__ATTR_NULL
 };
 
-static ssize_t
-dev_rescan_store(struct device *dev, struct device_attribute *attr,
-		 const char *buf, size_t count)
+static void dev_rescan_callback(struct device *dev)
 {
-	unsigned long val;
 	struct pci_dev *pdev = to_pci_dev(dev);
 
-	if (strict_strtoul(buf, 0, &val) < 0)
-		return -EINVAL;
-
-	if (val) {
-		mutex_lock(&pci_remove_rescan_mutex);
+	pci_hotplug_enter();
+	/* Skip if the device has been stopped. */
+	if (pdev->is_added && pdev->bus)
 		pci_rescan_bus(pdev->bus);
-		mutex_unlock(&pci_remove_rescan_mutex);
-	}
-	return count;
+	pci_hotplug_exit();
+}
+
+static ssize_t
+dev_rescan_store(struct device *dev, struct device_attribute *attr,
+		 const char *buf, size_t count)
+{
+	return schedule_hp_callback(dev, buf, count, dev_rescan_callback);
 }
 
 static void remove_callback(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 
-	mutex_lock(&pci_remove_rescan_mutex);
-	pci_stop_and_remove_bus_device(pdev);
-	mutex_unlock(&pci_remove_rescan_mutex);
+	pci_hotplug_enter();
+	/* Skip if the bus has been removed. */
+	if (pdev->bus_list.next)
+		pci_stop_and_remove_bus_device(pdev);
+	pci_hotplug_exit();
 }
 
 static ssize_t
 remove_store(struct device *dev, struct device_attribute *dummy,
 	     const char *buf, size_t count)
 {
-	int ret = 0;
-	unsigned long val;
-
-	if (strict_strtoul(buf, 0, &val) < 0)
-		return -EINVAL;
-
-	/* An attribute cannot be unregistered by one of its own methods,
-	 * so we have to use this roundabout approach.
-	 */
-	if (val)
-		ret = device_schedule_callback(dev, remove_callback);
-	if (ret)
-		count = ret;
-	return count;
+	return schedule_hp_callback(dev, buf, count, remove_callback);
 }
 
-static ssize_t
-dev_bus_rescan_store(struct device *dev, struct device_attribute *attr,
-		 const char *buf, size_t count)
+static void dev_bus_rescan_callback(struct device *dev)
 {
-	unsigned long val;
 	struct pci_bus *bus = to_pci_bus(dev);
 
-	if (strict_strtoul(buf, 0, &val) < 0)
-		return -EINVAL;
-
-	if (val) {
-		mutex_lock(&pci_remove_rescan_mutex);
+	pci_hotplug_enter();
+	/* Skip if the bus has been stopped. */
+	if (bus->is_added) {
 		if (!pci_is_root_bus(bus) && list_empty(&bus->devices))
 			pci_rescan_bus_bridge_resize(bus->self);
 		else
 			pci_rescan_bus(bus);
-		mutex_unlock(&pci_remove_rescan_mutex);
 	}
-	return count;
+	pci_hotplug_exit();
+}
+
+static ssize_t
+dev_bus_rescan_store(struct device *dev, struct device_attribute *attr,
+		 const char *buf, size_t count)
+{
+	return schedule_hp_callback(dev, buf, count, dev_bus_rescan_callback);
 }
 
 #endif
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index fd77e2b..0b4342b 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -72,6 +72,7 @@ void pci_remove_bus(struct pci_bus *pci_bus)
 	if (!pci_bus->is_added)
 		return;
 
+	pci_bus->is_added = 0;
 	pci_remove_legacy_files(pci_bus);
 	device_unregister(&pci_bus->dev);
 }
-- 
1.7.5.4


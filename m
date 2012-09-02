Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab2IBVwv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:52:51 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:23565 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979Ab2IBVwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:52:47 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH part3 10/11] PCI: Rescan bus or bridge using callback method too
Date: Sun,  2 Sep 2012 14:52:20 -0700
Message-Id: <1346622741-30799-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346622741-30799-1-git-send-email-yinghai@kernel.org>
References: <1346622741-30799-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just like removal.

Because We could add new bus under the bridges...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/pci-sysfs.c |   43 +++++++++++++++++++++++++++++++------------
 1 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 60cb06b..7ebc764 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -327,21 +327,31 @@ dev_rescan_store(struct device *dev, struct device_attribute *attr,
 	return count;
 }
 
+static void bridge_rescan_callback(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	mutex_lock(&pci_remove_rescan_mutex);
+	pci_rescan_bus_bridge_resize(pdev);
+	mutex_unlock(&pci_remove_rescan_mutex);
+}
+
 static ssize_t
 dev_bridge_rescan_store(struct device *dev, struct device_attribute *attr,
 		 const char *buf, size_t count)
 {
+	int ret = 0;
 	unsigned long val;
-	struct pci_dev *pdev = to_pci_dev(dev);
 
 	if (kstrtoul(buf, 0, &val) < 0)
 		return -EINVAL;
 
-	if (val) {
-		mutex_lock(&pci_remove_rescan_mutex);
-		pci_rescan_bus_bridge_resize(pdev);
-		mutex_unlock(&pci_remove_rescan_mutex);
-	}
+	if (val)
+		ret = device_schedule_callback(dev, bridge_rescan_callback);
+
+	if (ret)
+		count = ret;
+
 	return count;
 }
 
@@ -377,21 +387,30 @@ remove_store(struct device *dev, struct device_attribute *dummy,
 	return count;
 }
 
+static void bus_rescan_callback(struct device *dev)
+{
+	struct pci_bus *bus = to_pci_bus(dev);
+
+	mutex_lock(&pci_remove_rescan_mutex);
+	pci_rescan_bus(bus);
+	mutex_unlock(&pci_remove_rescan_mutex);
+}
 static ssize_t
 dev_bus_rescan_store(struct device *dev, struct device_attribute *attr,
 		 const char *buf, size_t count)
 {
+	int ret = 0;
 	unsigned long val;
-	struct pci_bus *bus = to_pci_bus(dev);
 
 	if (strict_strtoul(buf, 0, &val) < 0)
 		return -EINVAL;
 
-	if (val) {
-		mutex_lock(&pci_remove_rescan_mutex);
-		pci_rescan_bus(bus);
-		mutex_unlock(&pci_remove_rescan_mutex);
-	}
+	if (val)
+		ret = device_schedule_callback(dev, bus_rescan_callback);
+
+	if (ret)
+		count = ret;
+
 	return count;
 }
 
-- 
1.7.7


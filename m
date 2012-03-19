Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161401Ab2CSGDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:03:37 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30606 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161167Ab2CSFrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:47:42 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 14/47] PCI: Rescan bus or bridge using callback method too
Date: Sun, 18 Mar 2012 22:46:03 -0700
Message-Id: <1332135996-13860-15-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090209.4F66C87C.0017,ss=1,re=0.000,fgs=0
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
index 2049b2f..1794508 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -325,21 +325,31 @@ dev_rescan_store(struct device *dev, struct device_attribute *attr,
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
 
@@ -375,21 +385,30 @@ remove_store(struct device *dev, struct device_attribute *dummy,
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


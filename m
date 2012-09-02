Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab2IBVxI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:53:08 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:19824 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab2IBVwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:52:49 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH part3 11/11] PCI, sysfs: Clean up rescan/remove with scheule_callback
Date: Sun,  2 Sep 2012 14:52:21 -0700
Message-Id: <1346622741-30799-12-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346622741-30799-1-git-send-email-yinghai@kernel.org>
References: <1346622741-30799-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change to use three return according to Bjorn.

Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/pci-sysfs.c |   37 ++++++++++++++++++++-----------------
 1 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 7ebc764..3601912 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -340,17 +340,17 @@ static ssize_t
 dev_bridge_rescan_store(struct device *dev, struct device_attribute *attr,
 		 const char *buf, size_t count)
 {
-	int ret = 0;
+	int err;
 	unsigned long val;
 
 	if (kstrtoul(buf, 0, &val) < 0)
 		return -EINVAL;
+	if (!val)
+		return count;
 
-	if (val)
-		ret = device_schedule_callback(dev, bridge_rescan_callback);
-
-	if (ret)
-		count = ret;
+	err = device_schedule_callback(dev, bridge_rescan_callback);
+	if (err)
+		return err;
 
 	return count;
 }
@@ -371,7 +371,7 @@ static ssize_t
 remove_store(struct device *dev, struct device_attribute *dummy,
 	     const char *buf, size_t count)
 {
-	int ret = 0;
+	int err;
 	unsigned long val;
 
 	if (strict_strtoul(buf, 0, &val) < 0)
@@ -380,10 +380,13 @@ remove_store(struct device *dev, struct device_attribute *dummy,
 	/* An attribute cannot be unregistered by one of its own methods,
 	 * so we have to use this roundabout approach.
 	 */
-	if (val)
-		ret = device_schedule_callback(dev, remove_callback);
-	if (ret)
-		count = ret;
+	if (!val)
+		return count;
+
+	err = device_schedule_callback(dev, remove_callback);
+	if (err)
+		return err;
+
 	return count;
 }
 
@@ -399,17 +402,17 @@ static ssize_t
 dev_bus_rescan_store(struct device *dev, struct device_attribute *attr,
 		 const char *buf, size_t count)
 {
-	int ret = 0;
+	int err;
 	unsigned long val;
 
 	if (strict_strtoul(buf, 0, &val) < 0)
 		return -EINVAL;
+	if (!val)
+		return count;
 
-	if (val)
-		ret = device_schedule_callback(dev, bus_rescan_callback);
-
-	if (ret)
-		count = ret;
+	err = device_schedule_callback(dev, bus_rescan_callback);
+	if (err)
+		return err;
 
 	return count;
 }
-- 
1.7.7


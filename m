Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab2CJHI2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 02:08:28 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:25631 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab2CJHC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 02:02:29 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 15/37] PCI, sysfs: Clean up rescan/remove with scheule_callback
Date: Fri,  9 Mar 2012 23:00:15 -0800
Message-Id: <1331362837-10740-16-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020203.4F5AFC82.00B3,ss=1,re=0.000,fgs=0
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
index 1794508..4697afe 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -338,17 +338,17 @@ static ssize_t
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
@@ -369,7 +369,7 @@ static ssize_t
 remove_store(struct device *dev, struct device_attribute *dummy,
 	     const char *buf, size_t count)
 {
-	int ret = 0;
+	int err;
 	unsigned long val;
 
 	if (strict_strtoul(buf, 0, &val) < 0)
@@ -378,10 +378,13 @@ remove_store(struct device *dev, struct device_attribute *dummy,
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
 
@@ -397,17 +400,17 @@ static ssize_t
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


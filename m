Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161275Ab2CSFrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:47:48 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30623 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030960Ab2CSFro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:47:44 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 15/47] PCI, sysfs: Clean up rescan/remove with scheule_callback
Date: Sun, 18 Mar 2012 22:46:04 -0700
Message-Id: <1332135996-13860-16-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4F66C87E.003E,ss=1,re=0.000,fgs=0
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


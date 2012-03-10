Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab2CJHJV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 02:09:21 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:39236 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab2CJHCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 02:02:13 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH v2 10/37] PCI, sysfs: create rescan_bridge under /sys/.../pci/devices/... for pci bridges
Date: Fri,  9 Mar 2012 23:00:10 -0800
Message-Id: <1331362837-10740-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090208.4F5AFC72.0044,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code will create rescan for every pci device under parent bus.
that is not right. the device is already there, there is no reason to rescan it.

We could have rescan for pci bridges. less confusing.

Need to move rescan attr to pci dev bridge attribute group.
And We should rescan bridge's secondary bus instead of primary bus.

-v3: Use device_type for pci dev.
-v4: Seperate pci device type change out
-v5: add rescan_bridge for bridge type, and still keep the old rescan.
	may remove the old rescan later.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-bus-pci |   10 ++++++++++
 drivers/pci/pci-sysfs.c                 |   24 ++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index 34f5110..95f0f37 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -111,6 +111,16 @@ Description:
 		from this part of the device tree.
 		Depends on CONFIG_HOTPLUG.
 
+What:		/sys/bus/pci/devices/.../rescan_bridge
+Date:		February 2012
+Contact:	Linux PCI developers <linux-pci@vger.kernel.org>
+Description:
+		Writing a non-zero value to this attribute will
+		force a rescan of the bridge and all child buses, and
+		re-discover devices removed earlier from this part of
+		the device tree.
+		Depends on CONFIG_HOTPLUG.
+
 What:		/sys/bus/pci/devices/.../reset
 Date:		July 2009
 Contact:	Michael S. Tsirkin <mst@redhat.com>
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 39d15e6..d5c8ffb 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -325,6 +325,27 @@ dev_rescan_store(struct device *dev, struct device_attribute *attr,
 	return count;
 }
 
+static ssize_t
+dev_bridge_rescan_store(struct device *dev, struct device_attribute *attr,
+		 const char *buf, size_t count)
+{
+	unsigned long val;
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (kstrtoul(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	if (val) {
+		mutex_lock(&pci_remove_rescan_mutex);
+		pci_rescan_bus(pdev->subordinate);
+		mutex_unlock(&pci_remove_rescan_mutex);
+	}
+	return count;
+}
+
+static struct device_attribute pci_dev_bridge_rescan_attr =
+	__ATTR(rescan_bridge, (S_IWUSR|S_IWGRP), NULL, dev_bridge_rescan_store);
+
 static void remove_callback(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -1337,6 +1358,9 @@ static int __init pci_sysfs_init(void)
 late_initcall(pci_sysfs_init);
 
 static struct attribute *pci_dev_bridge_attrs[] = {
+#ifdef CONFIG_HOTPLUG
+	&pci_dev_bridge_rescan_attr.attr,
+#endif
 	NULL,
 };
 
-- 
1.7.7


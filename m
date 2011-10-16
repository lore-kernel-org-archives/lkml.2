Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab1JPBcz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 21:32:55 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17227 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab1JPBcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 21:32:51 -0400
Message-ID: <4E9A3436.3010704@oracle.com>
Date: Sat, 15 Oct 2011 18:32:38 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/8] PCI, sys: only create rescan under /sys/.../pci/devices/...
 for pci bridges
References: <4E9A3092.4080309@oracle.com>
In-Reply-To: <4E9A3092.4080309@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4E9A3440.0085:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Current code will create rescan for every pci device,
that is not right. the device is already there, there is no reason to rescan it.

So only have rescan for pci bridges. less confusing

Need to add cond to be new member of device_attribute.
device_add_attrs will check cond to see if need to create the attr.

Also the rescan will rescan bridge's secondary bus instead of primary bus.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/base/bus.c      |    7 ++++++-
 drivers/pci/pci-sysfs.c |   16 ++++++++++++++--
 include/linux/device.h  |    1 +
 include/linux/sysfs.h   |    7 +++++++
 4 files changed, 28 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/base/bus.c
===================================================================
--- linux-2.6.orig/drivers/base/bus.c
+++ linux-2.6/drivers/base/bus.c
@@ -419,7 +419,12 @@ static int device_add_attrs(struct bus_t
 		return 0;
 
 	for (i = 0; attr_name(bus->dev_attrs[i]); i++) {
-		error = device_create_file(dev, &bus->dev_attrs[i]);
+		struct device_attribute *attr;
+
+		attr = &bus->dev_attrs[i];
+		if (attr->cond && !attr->cond(dev, attr))
+			continue;
+		error = device_create_file(dev, attr);
 		if (error) {
 			while (--i >= 0)
 				device_remove_file(dev, &bus->dev_attrs[i]);
Index: linux-2.6/drivers/pci/pci-sysfs.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-sysfs.c
+++ linux-2.6/drivers/pci/pci-sysfs.c
@@ -303,12 +303,23 @@ dev_rescan_store(struct device *dev, str
 
 	if (val) {
 		mutex_lock(&pci_remove_rescan_mutex);
-		pci_rescan_bus(pdev->bus);
+		pci_rescan_bus(pdev->subordinate);
 		mutex_unlock(&pci_remove_rescan_mutex);
 	}
 	return count;
 }
 
+static int
+dev_rescan_cond(struct device *dev, struct device_attribute *attr)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (pdev && pdev->subordinate)
+		return 1;
+
+	return 0;
+}
+
 static void remove_callback(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -383,7 +394,8 @@ struct device_attribute pci_dev_attrs[]
 	__ATTR(msi_bus, 0644, msi_bus_show, msi_bus_store),
 #ifdef CONFIG_HOTPLUG
 	__ATTR(remove, (S_IWUSR|S_IWGRP), NULL, remove_store),
-	__ATTR(rescan, (S_IWUSR|S_IWGRP), NULL, dev_rescan_store),
+	__ATTR_COND(rescan, (S_IWUSR|S_IWGRP), NULL, dev_rescan_store,
+			dev_rescan_cond),
 #endif
 	__ATTR_NULL,
 };
Index: linux-2.6/include/linux/device.h
===================================================================
--- linux-2.6.orig/include/linux/device.h
+++ linux-2.6/include/linux/device.h
@@ -427,6 +427,7 @@ struct device_attribute {
 			char *buf);
 	ssize_t (*store)(struct device *dev, struct device_attribute *attr,
 			 const char *buf, size_t count);
+	int (*cond)(struct device *dev, struct device_attribute *attr);
 };
 
 #define DEVICE_ATTR(_name, _mode, _show, _store) \
Index: linux-2.6/include/linux/sysfs.h
===================================================================
--- linux-2.6.orig/include/linux/sysfs.h
+++ linux-2.6/include/linux/sysfs.h
@@ -73,6 +73,13 @@ struct attribute_group {
 	.store	= _store,					\
 }
 
+#define __ATTR_COND(_name, _mode, _show, _store, _cond) { \
+	.attr = {.name = __stringify(_name), .mode = _mode },	\
+	.show	= _show,					\
+	.store	= _store,					\
+	.cond	= _cond,					\
+}
+
 #define __ATTR_RO(_name) { \
 	.attr	= { .name = __stringify(_name), .mode = 0444 },	\
 	.show	= _name##_show,					\

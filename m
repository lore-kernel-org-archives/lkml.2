Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161774Ab2CSFsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:48:36 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30896 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161690Ab2CSFsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:48:23 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org
Subject: [PATCH -v3 40/47] PCI: Add pci bus removal through /sys/.../pci_bus/.../remove
Date: Sun, 18 Mar 2012 22:46:29 -0700
Message-Id: <1332135996-13860-41-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090209.4F66C8A4.00E4,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it supports both pci root bus and pci bus under pci bridge.

-v2: Change to three returns way in dev_bus_remove_store.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
---
 Documentation/ABI/testing/sysfs-bus-pci |    8 ++++++++
 drivers/pci/pci-sysfs.c                 |   30 ++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index 95f0f37..22392de 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -92,6 +92,14 @@ Description:
 		hot-remove the PCI device and any of its children.
 		Depends on CONFIG_HOTPLUG.
 
+What:		/sys/bus/pci/devices/.../pci_bus/.../remove
+Date:		March 2012
+Contact:	Linux PCI developers <linux-pci@vger.kernel.org>
+Description:
+		Writing a non-zero value to this attribute will
+		hot-remove the PCI bus and any of its children.
+		Depends on CONFIG_HOTPLUG.
+
 What:		/sys/bus/pci/devices/.../pci_bus/.../rescan
 Date:		May 2011
 Contact:	Linux PCI developers <linux-pci@vger.kernel.org>
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index d33a1bc..afba77b 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -391,6 +391,35 @@ remove_store(struct device *dev, struct device_attribute *dummy,
 	return count;
 }
 
+static void bus_remove_callback(struct device *dev)
+{
+	struct pci_bus *bus = to_pci_bus(dev);
+
+	mutex_lock(&pci_remove_rescan_mutex);
+	pci_stop_and_remove_bus(bus);
+	mutex_unlock(&pci_remove_rescan_mutex);
+}
+static ssize_t
+dev_bus_remove_store(struct device *dev, struct device_attribute *attr,
+		 const char *buf, size_t count)
+{
+	int err;
+	unsigned long val;
+
+	if (kstrtoul(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	if (!val)
+		return count;
+
+	err = device_schedule_callback(dev, bus_remove_callback);
+
+	if (err)
+		return err;
+
+	return count;
+}
+
 static void bus_rescan_callback(struct device *dev)
 {
 	struct pci_bus *bus = to_pci_bus(dev);
@@ -450,6 +479,7 @@ struct device_attribute pci_dev_attrs[] = {
 struct device_attribute pcibus_dev_attrs[] = {
 #ifdef CONFIG_HOTPLUG
 	__ATTR(rescan, (S_IWUSR|S_IWGRP), NULL, dev_bus_rescan_store),
+	__ATTR(remove, (S_IWUSR|S_IWGRP), NULL, dev_bus_remove_store),
 #endif
 	__ATTR(cpuaffinity, S_IRUGO, pci_bus_show_cpumaskaffinity, NULL),
 	__ATTR(cpulistaffinity, S_IRUGO, pci_bus_show_cpulistaffinity, NULL),
-- 
1.7.7


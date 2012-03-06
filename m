Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553Ab2CFHQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 02:16:39 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:17311 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758294Ab2CFHQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 02:16:37 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Randy Dunlap <rdunlap@xenotime.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org
Subject: [PATCH 16/23] PCI: add pci bus removal through /sys/.../pci_bus/.../remove
Date: Mon,  5 Mar 2012 23:13:53 -0800
Message-Id: <1331018040-30725-17-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090206.4F55B9D2.009F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it supports both pci root bus and pci bus under pci bridge.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
---
 Documentation/ABI/testing/sysfs-bus-pci |    8 ++++++++
 drivers/pci/pci-sysfs.c                 |   28 ++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

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
index 1794508..f855b4b 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -385,6 +385,33 @@ remove_store(struct device *dev, struct device_attribute *dummy,
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
+	int ret = 0;
+	unsigned long val;
+
+	if (kstrtoul(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	if (val)
+		ret = device_schedule_callback(dev, bus_remove_callback);
+
+	if (ret)
+		count = ret;
+
+	return count;
+}
+
 static void bus_rescan_callback(struct device *dev)
 {
 	struct pci_bus *bus = to_pci_bus(dev);
@@ -444,6 +471,7 @@ struct device_attribute pci_dev_attrs[] = {
 struct device_attribute pcibus_dev_attrs[] = {
 #ifdef CONFIG_HOTPLUG
 	__ATTR(rescan, (S_IWUSR|S_IWGRP), NULL, dev_bus_rescan_store),
+	__ATTR(remove, (S_IWUSR|S_IWGRP), NULL, dev_bus_remove_store),
 #endif
 	__ATTR(cpuaffinity, S_IRUGO, pci_bus_show_cpumaskaffinity, NULL),
 	__ATTR(cpulistaffinity, S_IRUGO, pci_bus_show_cpulistaffinity, NULL),
-- 
1.7.7


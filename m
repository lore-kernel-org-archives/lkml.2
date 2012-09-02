Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab2IBV76 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:59:58 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:23536 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811Ab2IBVwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:52:39 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH part3 05/11] PCI, sysfs: Use device_type and attr_groups with pci dev
Date: Sun,  2 Sep 2012 14:52:15 -0700
Message-Id: <1346622741-30799-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346622741-30799-1-git-send-email-yinghai@kernel.org>
References: <1346622741-30799-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to create rescan in sys only for pci bridge instead of all pci dev.

We could use attribute_groups/is_visible method to do that.

Now pci dev does not use device type yet. So add pci_dev_type to take
attr_groups with it.

Add pci_dev_bridge_attrs_are_visible() to control attr_bridge_group only create
attr for bridge.

This is the framework related change, later could attr to bridge_attr_group,
to make those attr only show up on pci bridge device.

Also We could add more attr groups with is_visible to reduce messness in
	pci_create_sysfs_dev_files. ( at least for boot_vga one )

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/pci-sysfs.c |   30 ++++++++++++++++++++++++++++++
 drivers/pci/pci.h       |    1 +
 drivers/pci/probe.c     |    1 +
 3 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 6869009..e37a0e0 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1369,3 +1369,33 @@ static int __init pci_sysfs_init(void)
 }
 
 late_initcall(pci_sysfs_init);
+
+static struct attribute *pci_dev_bridge_attrs[] = {
+	NULL,
+};
+
+static umode_t pci_dev_bridge_attrs_are_visible(struct kobject *kobj,
+						struct attribute *a, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (!pdev->subordinate)
+		return 0;
+
+	return a->mode;
+}
+
+static struct attribute_group pci_dev_bridge_attr_group = {
+	.attrs = pci_dev_bridge_attrs,
+	.is_visible = pci_dev_bridge_attrs_are_visible,
+};
+
+static const struct attribute_group *pci_dev_attr_groups[] = {
+	&pci_dev_bridge_attr_group,
+	NULL,
+};
+
+struct device_type pci_dev_type = {
+	.groups = pci_dev_attr_groups,
+};
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index bacbcba..6f6cd14 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -157,6 +157,7 @@ static inline int pci_no_d1d2(struct pci_dev *dev)
 }
 extern struct device_attribute pci_dev_attrs[];
 extern struct device_attribute pcibus_dev_attrs[];
+extern struct device_type pci_dev_type;
 #ifdef CONFIG_HOTPLUG
 extern struct bus_attribute pci_bus_attrs[];
 #else
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index bc22308..d1796fe 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -970,6 +970,7 @@ int pci_setup_device(struct pci_dev *dev)
 	dev->sysdata = dev->bus->sysdata;
 	dev->dev.parent = dev->bus->bridge;
 	dev->dev.bus = &pci_bus_type;
+	dev->dev.type = &pci_dev_type;
 	dev->hdr_type = hdr_type & 0x7f;
 	dev->multifunction = !!(hdr_type & 0x80);
 	dev->error_state = pci_channel_io_normal;
-- 
1.7.7


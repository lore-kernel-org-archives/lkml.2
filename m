Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab1JQS2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:28:36 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:26349 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab1JQS2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:28:34 -0400
Message-ID: <4E9C7386.6090607@oracle.com>
Date: Mon, 17 Oct 2011 11:27:18 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH -v4 8_1/8] PCI, sys: Use device_type and attr_groups with
 pci dev
References: <4E9A3092.4080309@oracle.com> <4E9A3436.3010704@oracle.com> <20111016023943.GA3787@suse.de> <4E9A6CCB.4060101@oracle.com> <20111016155517.GA6421@suse.de> <4E9B6A2F.1080706@oracle.com> <20111017014527.GA7322@suse.de>
In-Reply-To: <20111017014527.GA7322@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4E9C73CD.00E3:SCFMA922111,ss=1,re=-4.000,fgs=0
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
 3 files changed, 32 insertions(+)

Index: linux-2.6/drivers/pci/pci-sysfs.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-sysfs.c
+++ linux-2.6/drivers/pci/pci-sysfs.c
@@ -1319,3 +1319,33 @@ static int __init pci_sysfs_init(void)
 }
 
 late_initcall(pci_sysfs_init);
+
+static struct attribute *pci_dev_bridge_attrs[] = {
+	NULL,
+};
+
+static mode_t pci_dev_bridge_attrs_are_visible(struct kobject *kobj,
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
Index: linux-2.6/drivers/pci/pci.h
===================================================================
--- linux-2.6.orig/drivers/pci/pci.h
+++ linux-2.6/drivers/pci/pci.h
@@ -159,6 +159,7 @@ static inline int pci_no_d1d2(struct pci
 }
 extern struct device_attribute pci_dev_attrs[];
 extern struct device_attribute pcibus_dev_attrs[];
+extern struct device_type pci_dev_type;
 #ifdef CONFIG_HOTPLUG
 extern struct bus_attribute pci_bus_attrs[];
 #else
Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -902,6 +902,7 @@ int pci_setup_device(struct pci_dev *dev
 	dev->sysdata = dev->bus->sysdata;
 	dev->dev.parent = dev->bus->bridge;
 	dev->dev.bus = &pci_bus_type;
+	dev->dev.type = &pci_dev_type;
 	dev->hdr_type = hdr_type & 0x7f;
 	dev->multifunction = !!(hdr_type & 0x80);
 	dev->error_state = pci_channel_io_normal;

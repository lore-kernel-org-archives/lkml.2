Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab1JPXfa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 19:35:30 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:20113 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab1JPXf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 19:35:29 -0400
Message-ID: <4E9B6A2F.1080706@oracle.com>
Date: Sun, 16 Oct 2011 16:35:11 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/8] PCI, sys: only create rescan under /sys/.../pci/devices/...
 for pci bridges
References: <4E9A3092.4080309@oracle.com> <4E9A3436.3010704@oracle.com> <20111016023943.GA3787@suse.de> <4E9A6CCB.4060101@oracle.com> <20111016155517.GA6421@suse.de>
In-Reply-To: <20111016155517.GA6421@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4E9B6A3D.008A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2011 08:55 AM, Greg KH wrote:

> On Sat, Oct 15, 2011 at 10:34:03PM -0700, Yinghai Lu wrote:
>> On 10/15/2011 07:39 PM, Greg KH wrote:
>>
>>>
>>> No, we already have a way to do this, this is not acceptable, sorry.
>>>
>>
>>
>> hope this one is ok...
> 
> Nope, not at all, don't use #ifdef in .c files.
> 
> Again, we have a way to do this, built into sysfs, that can dynamically
> know to add or not add, attributes when they are registered with the
> system.

thank you for the comments.

i got it. now introduce device type for pci dev.

please check if this one is what you want.

[PATCH -v3 8/8] PCI, sys: only create rescan under /sys/.../pci/devices/... for pci bridges

Current code will create rescan for every pci device,
that is not right. the device is already there, there is no reason to rescan it.

So only have rescan for pci bridges. less confusing

Also the rescan will rescan bridge's secondary bus instead of primary bus.

-v3: Use device_type for pci dev.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/pci-sysfs.c |   39 +++++++++++++++++++++++++++++++++++++--
 drivers/pci/pci.h       |    1 +
 drivers/pci/probe.c     |    1 +
 3 files changed, 39 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/pci/pci-sysfs.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-sysfs.c
+++ linux-2.6/drivers/pci/pci-sysfs.c
@@ -303,12 +303,15 @@ dev_rescan_store(struct device *dev, str
 
 	if (val) {
 		mutex_lock(&pci_remove_rescan_mutex);
-		pci_rescan_bus(pdev->bus);
+		pci_rescan_bus(pdev->subordinate);
 		mutex_unlock(&pci_remove_rescan_mutex);
 	}
 	return count;
 }
 
+static struct device_attribute pci_dev_bridge_rescan_attr =
+	__ATTR(rescan, (S_IWUSR|S_IWGRP), NULL, dev_rescan_store);
+
 static void remove_callback(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -358,8 +361,41 @@ dev_bus_rescan_store(struct device *dev,
 	}
 	return count;
 }
+#endif
+
 
+static struct attribute *pci_dev_bridge_attrs[] = {
+#ifdef CONFIG_HOTPLUG
+	&pci_dev_bridge_rescan_attr.attr,
 #endif
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
 
 struct device_attribute pci_dev_attrs[] = {
 	__ATTR_RO(resource),
@@ -383,7 +419,6 @@ struct device_attribute pci_dev_attrs[]
 	__ATTR(msi_bus, 0644, msi_bus_show, msi_bus_store),
 #ifdef CONFIG_HOTPLUG
 	__ATTR(remove, (S_IWUSR|S_IWGRP), NULL, remove_store),
-	__ATTR(rescan, (S_IWUSR|S_IWGRP), NULL, dev_rescan_store),
 #endif
 	__ATTR_NULL,
 };
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

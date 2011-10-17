Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab1JQS3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:29:19 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:61292 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab1JQS3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:29:18 -0400
Message-ID: <4E9C73EE.8050706@oracle.com>
Date: Mon, 17 Oct 2011 11:29:02 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH -v4 8_2/8] PCI, sys: only create rescan under /sys/.../pci/devices/...
 for pci bridges
References: <4E9A3092.4080309@oracle.com> <4E9A3436.3010704@oracle.com> <20111016023943.GA3787@suse.de> <4E9A6CCB.4060101@oracle.com> <20111016155517.GA6421@suse.de> <4E9B6A2F.1080706@oracle.com> <20111017014527.GA7322@suse.de>
In-Reply-To: <20111017014527.GA7322@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4E9C73F8.0150:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Current code will create rescan for every pci device,
that is not right. the device is already there, there is no reason to rescan it.

We could have rescan for pci bridges. less confusing.

Need to move rescan attr to pci dev bridge attribute group.
And We should rescan bridge's secondary bus instead of primary bus.

-v3: Use device_type for pci dev.
-v4: Seperate pci device type change out

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/pci-sysfs.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

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
@@ -383,7 +386,6 @@ struct device_attribute pci_dev_attrs[]
 	__ATTR(msi_bus, 0644, msi_bus_show, msi_bus_store),
 #ifdef CONFIG_HOTPLUG
 	__ATTR(remove, (S_IWUSR|S_IWGRP), NULL, remove_store),
-	__ATTR(rescan, (S_IWUSR|S_IWGRP), NULL, dev_rescan_store),
 #endif
 	__ATTR_NULL,
 };
@@ -1321,6 +1323,9 @@ static int __init pci_sysfs_init(void)
 late_initcall(pci_sysfs_init);
 
 static struct attribute *pci_dev_bridge_attrs[] = {
+#ifdef CONFIG_HOTPLUG
+	&pci_dev_bridge_rescan_attr.attr,
+#endif
 	NULL,
 };
 

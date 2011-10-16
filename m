Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab1JPFe3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 01:34:29 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:45817 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab1JPFe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 01:34:27 -0400
Message-ID: <4E9A6CCB.4060101@oracle.com>
Date: Sat, 15 Oct 2011 22:34:03 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/8] PCI, sys: only create rescan under /sys/.../pci/devices/...
 for pci bridges
References: <4E9A3092.4080309@oracle.com> <4E9A3436.3010704@oracle.com> <20111016023943.GA3787@suse.de>
In-Reply-To: <20111016023943.GA3787@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4E9A6CE0.0092:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2011 07:39 PM, Greg KH wrote:

> 
> No, we already have a way to do this, this is not acceptable, sorry.
> 


hope this one is ok...

[PATCH -v2 8/8] PCI, sys: only create rescan under /sys/.../pci/devices/... for pci bridges

Current code will create rescan for every pci device,
that is not right. the device is already there, there is no reason to rescan it.

So only have rescan for pci bridges. less confusing

Also the rescan will rescan bridge's secondary bus instead of primary bus.

-v2: don't add __ATTR_COND() as GregKH does not like it

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/pci-sysfs.c |   29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

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
 
+struct device_attribute bridge_rescan_attr =
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
@@ -1217,20 +1219,34 @@ int __must_check pci_create_sysfs_dev_fi
 			goto err_rom_file;
 	}
 
+#ifdef CONFIG_HOTPLUG
+	if (pdev->subordinate) {
+		retval = device_create_file(&pdev->dev, &bridge_rescan_attr);
+		if (retval)
+			goto err_vga_file;
+	}
+#endif
+
 	/* add platform-specific attributes */
 	retval = pcibios_add_platform_entries(pdev);
 	if (retval)
-		goto err_vga_file;
+		goto err_bridge_rescan_file;
 
 	/* add sysfs entries for various capabilities */
 	retval = pci_create_capabilities_sysfs(pdev);
 	if (retval)
-		goto err_vga_file;
+		goto err_bridge_rescan_file;
 
 	pci_create_firmware_label_files(pdev);
 
 	return 0;
 
+err_bridge_rescan_file:
+#ifdef CONFIG_HOTPLUG
+	if (pdev->subordinate)
+		device_remove_file(&pdev->dev, &bridge_rescan_attr);
+#endif
+
 err_vga_file:
 	if ((pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA)
 		device_remove_file(&pdev->dev, &vga_attr);
@@ -1297,6 +1313,11 @@ void pci_remove_sysfs_dev_files(struct p
 		kfree(pdev->rom_attr);
 	}
 
+#ifdef CONFIG_HOTPLUG
+	if (pdev->subordinate)
+		device_remove_file(&pdev->dev, &bridge_rescan_attr);
+#endif
+
 	pci_remove_firmware_label_files(pdev);
 
 }

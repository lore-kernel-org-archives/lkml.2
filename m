Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965440Ab2JCRwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 13:52:05 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34280 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965423Ab2JCRv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 13:51:58 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>, yuvalmin@broadcom.com,
        bhutchings@solarflare.com, gregory.v.rose@intel.com,
        davem@davemloft.net--no-chain-reply-to,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 2/5] PCI, sys: Use is_visable() with boot_vga attribute for pci_dev
Date: Wed,  3 Oct 2012 10:51:32 -0700
Message-Id: <1349286695-26713-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1349286695-26713-1-git-send-email-yinghai@kernel.org>
References: <506C3B11.9010009@redhat.com>
 <1349286695-26713-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That could let pci_create_sysfs_dev_files more simple.

also fix possible fix memleak during removing path.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/pci-sysfs.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 3d160aa..fbbb97f 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1303,29 +1303,20 @@ int __must_check pci_create_sysfs_dev_files (struct pci_dev *pdev)
 		pdev->rom_attr = attr;
 	}
 
-	if ((pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA) {
-		retval = device_create_file(&pdev->dev, &vga_attr);
-		if (retval)
-			goto err_rom_file;
-	}
-
 	/* add platform-specific attributes */
 	retval = pcibios_add_platform_entries(pdev);
 	if (retval)
-		goto err_vga_file;
+		goto err_rom_file;
 
 	/* add sysfs entries for various capabilities */
 	retval = pci_create_capabilities_sysfs(pdev);
 	if (retval)
-		goto err_vga_file;
+		goto err_rom_file;
 
 	pci_create_firmware_label_files(pdev);
 
 	return 0;
 
-err_vga_file:
-	if ((pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA)
-		device_remove_file(&pdev->dev, &vga_attr);
 err_rom_file:
 	if (rom_size) {
 		sysfs_remove_bin_file(&pdev->dev.kobj, pdev->rom_attr);
@@ -1413,12 +1404,20 @@ static int __init pci_sysfs_init(void)
 late_initcall(pci_sysfs_init);
 
 static struct attribute *pci_dev_dev_attrs[] = {
+	&vga_attr.attr,
 	NULL,
 };
 
 static umode_t pci_dev_attrs_are_visible(struct kobject *kobj,
 						struct attribute *a, int n)
 {
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (a == &vga_attr.attr)
+		if ((pdev->class >> 8) != PCI_CLASS_DISPLAY_VGA)
+			return 0;
+
 	return a->mode;
 }
 
-- 
1.7.7


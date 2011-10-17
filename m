Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab1JQSdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:33:31 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:17837 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab1JQSd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:33:29 -0400
Message-ID: <4E9C74ED.1090209@oracle.com>
Date: Mon, 17 Oct 2011 11:33:17 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH -v4 8_3/8] PCI, sys: Use is_visable() with boot_vga attribute
 for pci_dev
References: <4E9A3092.4080309@oracle.com> <4E9A3436.3010704@oracle.com> <20111016023943.GA3787@suse.de> <4E9A6CCB.4060101@oracle.com> <20111016155517.GA6421@suse.de> <4E9B6A2F.1080706@oracle.com> <20111017014527.GA7322@suse.de>
In-Reply-To: <20111017014527.GA7322@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E9C74F6.00DF:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


That could let pci_create_sysfs_dev_files more simple.

also fix possible fix memleak during removing path.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/pci-sysfs.c |   36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

Index: linux-2.6/drivers/pci/pci-sysfs.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-sysfs.c
+++ linux-2.6/drivers/pci/pci-sysfs.c
@@ -1213,29 +1213,20 @@ int __must_check pci_create_sysfs_dev_fi
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
@@ -1322,6 +1313,28 @@ static int __init pci_sysfs_init(void)
 
 late_initcall(pci_sysfs_init);
 
+static struct attribute *pci_dev_vga_attrs[] = {
+	&vga_attr.attr,
+	NULL,
+};
+
+static mode_t pci_dev_vga_attrs_are_visible(struct kobject *kobj,
+						struct attribute *a, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if ((pdev->class >> 8) != PCI_CLASS_DISPLAY_VGA)
+		return 0;
+
+	return a->mode;
+}
+
+static struct attribute_group pci_dev_vga_attr_group = {
+	.attrs = pci_dev_vga_attrs,
+	.is_visible = pci_dev_vga_attrs_are_visible,
+};
+
 static struct attribute *pci_dev_bridge_attrs[] = {
 #ifdef CONFIG_HOTPLUG
 	&pci_dev_bridge_rescan_attr.attr,
@@ -1348,6 +1361,7 @@ static struct attribute_group pci_dev_br
 
 static const struct attribute_group *pci_dev_attr_groups[] = {
 	&pci_dev_bridge_attr_group,
+	&pci_dev_vga_attr_group,
 	NULL,
 };
 

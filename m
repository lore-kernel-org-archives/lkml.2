Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab1FPHLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:11:30 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:50673 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756565Ab1FPHLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:11:20 -0400
X-Sasl-enc: 2kOLxw35JuIGeVMV9Wivxd0FHipCkZEFX4g0OavRBDMT 1308208278
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:10 2011
Message-Id: <20110616002910.665327088@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:29:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [68/85] x86/amd-iommu: Fix boot crash with hidden PCI devices
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit 26018874e3584f1658570d41d57d4c34f6a53aa0 upstream.

Some PCIe cards ship with a PCI-PCIe bridge which is not
visible as a PCI device in Linux. But the device-id of the
bridge is present in the IOMMU tables which causes a boot
crash in the IOMMU driver.
This patch fixes by removing these cards from the IOMMU
handling. This is a pure -stable fix, a real fix to handle
this situation appriatly will follow for the next merge
window.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/amd_iommu.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -154,6 +154,10 @@ static int iommu_init_device(struct devi
 	pdev = pci_get_bus_and_slot(PCI_BUS(alias), alias & 0xff);
 	if (pdev)
 		dev_data->alias = &pdev->dev;
+	else {
+		kfree(dev_data);
+		return -ENOTSUPP;
+	}
 
 	atomic_set(&dev_data->bind, 0);
 
@@ -163,6 +167,20 @@ static int iommu_init_device(struct devi
 	return 0;
 }
 
+static void iommu_ignore_device(struct device *dev)
+{
+	u16 devid, alias;
+
+	devid = get_device_id(dev);
+	alias = amd_iommu_alias_table[devid];
+
+	memset(&amd_iommu_dev_table[devid], 0, sizeof(struct dev_table_entry));
+	memset(&amd_iommu_dev_table[alias], 0, sizeof(struct dev_table_entry));
+
+	amd_iommu_rlookup_table[devid] = NULL;
+	amd_iommu_rlookup_table[alias] = NULL;
+}
+
 static void iommu_uninit_device(struct device *dev)
 {
 	kfree(dev->archdata.iommu);
@@ -192,7 +210,9 @@ int __init amd_iommu_init_devices(void)
 			continue;
 
 		ret = iommu_init_device(&pdev->dev);
-		if (ret)
+		if (ret == -ENOTSUPP)
+			iommu_ignore_device(&pdev->dev);
+		else if (ret)
 			goto out_free;
 	}
 



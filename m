Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab1FGKHC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:07:02 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:7099 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab1FGKGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:06:49 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bh8275dhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMF039-02-4NO-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/3] x86/amd-iommu: Fix boot crash with hidden PCI devices
Date: Tue, 7 Jun 2011 12:06:59 +0200
Message-ID: <1307441219-18202-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307441219-18202-1-git-send-email-joerg.roedel@amd.com>
References: <1307441219-18202-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some PCIe cards ship with a PCI-PCIe bridge which is not
visible as a PCI device in Linux. But the device-id of the
bridge is present in the IOMMU tables which causes a boot
crash in the IOMMU driver.
This patch fixes by removing these cards from the IOMMU
handling. This is a pure -stable fix, a real fix to handle
this situation appriatly will follow for the next merge
window.

Cc: stable@kernel.org	# > 2.6.32
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index b2c309b..7c3a95e 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -155,6 +155,10 @@ static int iommu_init_device(struct device *dev)
 	pdev = pci_get_bus_and_slot(PCI_BUS(alias), alias & 0xff);
 	if (pdev)
 		dev_data->alias = &pdev->dev;
+	else {
+		kfree(dev_data);
+		return -ENOTSUPP;
+	}
 
 	atomic_set(&dev_data->bind, 0);
 
@@ -164,6 +168,20 @@ static int iommu_init_device(struct device *dev)
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
@@ -193,7 +211,9 @@ int __init amd_iommu_init_devices(void)
 			continue;
 
 		ret = iommu_init_device(&pdev->dev);
-		if (ret)
+		if (ret == -ENOTSUPP)
+			iommu_ignore_device(&pdev->dev);
+		else if (ret)
 			goto out_free;
 	}
 
-- 
1.7.4.1



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab1FJMJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:09:14 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:26525
	"EHLO CH1EHSOBE016.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756180Ab1FJMJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:09:09 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMKPQ2-01-6LX-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 8/9] x86/amd-iommu: Search for existind dev_data before allocting a new one
Date: Fri, 10 Jun 2011 14:08:48 +0200
Message-ID: <1307707729-29767-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307707729-29767-1-git-send-email-joerg.roedel@amd.com>
References: <1307707729-29767-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Search for existing dev_data first will allow to switch
dev_data->alias to just store dev_data instead of struct
device.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   33 ++++++++++++++++++++++++++++++++-
 1 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 2d914a4..f647998 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -102,6 +102,37 @@ static void free_dev_data(struct iommu_dev_data *dev_data)
 	kfree(dev_data);
 }
 
+static struct iommu_dev_data *search_dev_data(u16 devid)
+{
+	struct iommu_dev_data *dev_data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev_data_list_lock, flags);
+	list_for_each_entry(dev_data, &dev_data_list, dev_data_list) {
+		if (dev_data->devid == devid)
+			goto out_unlock;
+	}
+
+	dev_data = NULL;
+
+out_unlock:
+	spin_unlock_irqrestore(&dev_data_list_lock, flags);
+
+	return dev_data;
+}
+
+static struct iommu_dev_data *find_dev_data(u16 devid)
+{
+	struct iommu_dev_data *dev_data;
+
+	dev_data = search_dev_data(devid);
+
+	if (dev_data == NULL)
+		dev_data = alloc_dev_data(devid);
+
+	return dev_data;
+}
+
 static inline u16 get_device_id(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -178,7 +209,7 @@ static int iommu_init_device(struct device *dev)
 	if (dev->archdata.iommu)
 		return 0;
 
-	dev_data = alloc_dev_data(get_device_id(dev));
+	dev_data = find_dev_data(get_device_id(dev));
 	if (!dev_data)
 		return -ENOMEM;
 
-- 
1.7.4.1



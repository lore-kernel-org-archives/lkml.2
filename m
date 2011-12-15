Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815Ab1LOKXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 05:23:51 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:3695 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758792Ab1LOKXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 05:23:37 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LW8Q77-01-29M-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/3] iommu/amd: Add invalidate-context call-back
Date: Thu, 15 Dec 2011 11:23:22 +0100
Message-ID: <1323944602-26155-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323944602-26155-1-git-send-email-joerg.roedel@amd.com>
References: <1323944602-26155-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This call-back is invoked when the task that is bound to a
pasid is about to exit. The driver can use it to shutdown
all context related to that context in a safe way.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_v2.c |   35 +++++++++++++++++++++++++++++++++++
 include/linux/amd-iommu.h    |   17 +++++++++++++++++
 2 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index fe812e2..8add9f1 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -63,6 +63,7 @@ struct device_state {
 	int pasid_levels;
 	int max_pasids;
 	amd_iommu_invalid_ppr_cb inv_ppr_cb;
+	amd_iommu_invalidate_ctx inv_ctx_cb;
 	spinlock_t lock;
 	wait_queue_head_t wq;
 };
@@ -637,6 +638,9 @@ again:
 		dev_state = pasid_state->device_state;
 		pasid     = pasid_state->pasid;
 
+		if (pasid_state->device_state->inv_ctx_cb)
+			dev_state->inv_ctx_cb(dev_state->pdev, pasid);
+
 		unbind_pasid(dev_state, pasid);
 
 		/* Task may be in the list multiple times */
@@ -881,6 +885,37 @@ out_unlock:
 }
 EXPORT_SYMBOL(amd_iommu_set_invalid_ppr_cb);
 
+int amd_iommu_set_invalidate_ctx_cb(struct pci_dev *pdev,
+				    amd_iommu_invalidate_ctx cb)
+{
+	struct device_state *dev_state;
+	unsigned long flags;
+	u16 devid;
+	int ret;
+
+	if (!amd_iommu_v2_supported())
+		return -ENODEV;
+
+	devid = device_id(pdev);
+
+	spin_lock_irqsave(&state_lock, flags);
+
+	ret = -EINVAL;
+	dev_state = state_table[devid];
+	if (dev_state == NULL)
+		goto out_unlock;
+
+	dev_state->inv_ctx_cb = cb;
+
+	ret = 0;
+
+out_unlock:
+	spin_unlock_irqrestore(&state_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(amd_iommu_set_invalidate_ctx_cb);
+
 static int __init amd_iommu_v2_init(void)
 {
 	size_t state_table_size;
diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
index c03c281..ef00610 100644
--- a/include/linux/amd-iommu.h
+++ b/include/linux/amd-iommu.h
@@ -145,6 +145,23 @@ struct amd_iommu_device_info {
 extern int amd_iommu_device_info(struct pci_dev *pdev,
 				 struct amd_iommu_device_info *info);
 
+/**
+ * amd_iommu_set_invalidate_ctx_cb() - Register a call-back for invalidating
+ *				       a pasid context. This call-back is
+ *				       invoked when the IOMMUv2 driver needs to
+ *				       invalidate a PASID context, for example
+ *				       because the task that is bound to that
+ *				       context is about to exit.
+ *
+ * @pdev: The PCI device the call-back should be registered for
+ * @cb: The call-back function
+ */
+
+typedef void (*amd_iommu_invalidate_ctx)(struct pci_dev *pdev, int pasid);
+
+extern int amd_iommu_set_invalidate_ctx_cb(struct pci_dev *pdev,
+					   amd_iommu_invalidate_ctx cb);
+
 #else
 
 static inline int amd_iommu_detect(void) { return -ENODEV; }
-- 
1.7.5.4



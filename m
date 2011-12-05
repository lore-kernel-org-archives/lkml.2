Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab1LENhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:37:17 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:54384
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932323Ab1LENfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:35:18 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVQGEM-02-AUW-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 22/22] iommu/amd: Add invalid_ppr callback
Date: Mon, 5 Dec 2011 14:34:37 +0100
Message-ID: <1323092077-25501-23-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
References: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This callback can be used to change the PRI response code
sent to a device when a PPR fault fails.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_v2.c |   57 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/amd-iommu.h    |   34 ++++++++++++++++++++++--
 2 files changed, 86 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index ffe85e0..7f63a4d 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -62,6 +62,7 @@ struct device_state {
 	struct iommu_domain *domain;
 	int pasid_levels;
 	int max_pasids;
+	amd_iommu_invalid_ppr_cb inv_ppr_cb;
 	spinlock_t lock;
 	wait_queue_head_t wq;
 };
@@ -504,10 +505,31 @@ static void do_fault(struct work_struct *work)
 	npages = get_user_pages(fault->state->task, fault->state->mm,
 				fault->address, 1, write, 0, &page, NULL);
 
-	if (npages == 1)
+	if (npages == 1) {
 		put_page(page);
-	else
+	} else if (fault->dev_state->inv_ppr_cb) {
+		int status;
+
+		status = fault->dev_state->inv_ppr_cb(fault->dev_state->pdev,
+						      fault->pasid,
+						      fault->address,
+						      fault->flags);
+		switch (status) {
+		case AMD_IOMMU_INV_PRI_RSP_SUCCESS:
+			set_pri_tag_status(fault->state, fault->tag, PPR_SUCCESS);
+			break;
+		case AMD_IOMMU_INV_PRI_RSP_INVALID:
+			set_pri_tag_status(fault->state, fault->tag, PPR_INVALID);
+			break;
+		case AMD_IOMMU_INV_PRI_RSP_FAIL:
+			set_pri_tag_status(fault->state, fault->tag, PPR_FAILURE);
+			break;
+		default:
+			BUG();
+		}
+	} else {
 		set_pri_tag_status(fault->state, fault->tag, PPR_INVALID);
+	}
 
 	finish_pri_tag(fault->dev_state, fault->state, fault->tag);
 
@@ -820,6 +842,37 @@ void amd_iommu_free_device(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL(amd_iommu_free_device);
 
+int amd_iommu_set_invalid_ppr_cb(struct pci_dev *pdev,
+				 amd_iommu_invalid_ppr_cb cb)
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
+	dev_state->inv_ppr_cb = cb;
+
+	ret = 0;
+
+out_unlock:
+	spin_unlock_irqrestore(&state_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(amd_iommu_set_invalid_ppr_cb);
+
 static int __init amd_iommu_v2_init(void)
 {
 	size_t state_table_size;
diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
index 23e21e1..06688c4 100644
--- a/include/linux/amd-iommu.h
+++ b/include/linux/amd-iommu.h
@@ -28,9 +28,6 @@ struct task_struct;
 struct pci_dev;
 
 extern int amd_iommu_detect(void);
-extern int amd_iommu_bind_pasid(struct pci_dev *pdev, int pasid,
-				struct task_struct *task);
-extern void amd_iommu_unbind_pasid(struct pci_dev *pdev, int pasid);
 
 
 /**
@@ -91,6 +88,37 @@ extern int amd_iommu_bind_pasid(struct pci_dev *pdev, int pasid,
  */
 extern void amd_iommu_unbind_pasid(struct pci_dev *pdev, int pasid);
 
+/**
+ * amd_iommu_set_invalid_ppr_cb() - Register a call-back for failed
+ *				    PRI requests
+ * @pdev: The PCI device the call-back should be registered for
+ * @cb: The call-back function
+ *
+ * The IOMMUv2 driver invokes this call-back when it is unable to
+ * successfully handle a PRI request. The device driver can then decide
+ * which PRI response the device should see. Possible return values for
+ * the call-back are:
+ *
+ * - AMD_IOMMU_INV_PRI_RSP_SUCCESS - Send SUCCESS back to the device
+ * - AMD_IOMMU_INV_PRI_RSP_INVALID - Send INVALID back to the device
+ * - AMD_IOMMU_INV_PRI_RSP_FAIL    - Send Failure back to the device,
+ *				     the device is required to disable
+ *				     PRI when it receives this response
+ *
+ * The function returns 0 on success or negative value on error.
+ */
+#define AMD_IOMMU_INV_PRI_RSP_SUCCESS	0
+#define AMD_IOMMU_INV_PRI_RSP_INVALID	1
+#define AMD_IOMMU_INV_PRI_RSP_FAIL	2
+
+typedef int (*amd_iommu_invalid_ppr_cb)(struct pci_dev *pdev,
+					int pasid,
+					unsigned long address,
+					u16);
+
+extern int amd_iommu_set_invalid_ppr_cb(struct pci_dev *pdev,
+					amd_iommu_invalid_ppr_cb cb);
+
 #else
 
 static inline int amd_iommu_detect(void) { return -ENODEV; }
-- 
1.7.5.4



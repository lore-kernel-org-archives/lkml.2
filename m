Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483Ab1LENif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:38:35 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:53378
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932397Ab1LENfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:35:14 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVQGEL-02-AUV-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 18/22] iommu/amd: Implement device aquisition code for IOMMUv2
Date: Mon, 5 Dec 2011 14:34:33 +0100
Message-ID: <1323092077-25501-19-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
References: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the amd_iommu_init_device() and
amd_iommu_free_device() functions which make a device and
the IOMMU ready for IOMMUv2 usage.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_v2.c |  213 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/amd-iommu.h    |   23 +++++-
 2 files changed, 235 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index a19e07d..e0ec952 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -16,20 +16,233 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
+#include <linux/amd-iommu.h>
+#include <linux/mm_types.h>
 #include <linux/module.h>
+#include <linux/iommu.h>
+#include <linux/pci.h>
+#include <linux/gfp.h>
+
+#include "amd_iommu_proto.h"
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Joerg Roedel <joerg.roedel@amd.com>");
 
+#define MAX_DEVICES		0x10000
+#define PRI_QUEUE_SIZE		512
+
+struct pri_queue {
+	atomic_t inflight;
+	bool finish;
+};
+
+struct pasid_state {
+	struct list_head list;			/* For global state-list */
+	atomic_t count;				/* Reference count */
+	struct task_struct *task;		/* Task bound to this PASID */
+	struct mm_struct *mm;			/* mm_struct for the faults */
+	struct pri_queue pri[PRI_QUEUE_SIZE];	/* PRI tag states */
+	struct device_state *device_state;	/* Link to our device_state */
+	int pasid;				/* PASID index */
+};
+
+struct device_state {
+	atomic_t count;
+	struct pci_dev *pdev;
+	struct pasid_state **states;
+	struct iommu_domain *domain;
+	int pasid_levels;
+	int max_pasids;
+	spinlock_t lock;
+};
+
+struct device_state **state_table;
+static spinlock_t state_lock;
+
+/* List and lock for all pasid_states */
+static LIST_HEAD(pasid_state_list);
+static DEFINE_SPINLOCK(ps_lock);
+
+static u16 device_id(struct pci_dev *pdev)
+{
+	u16 devid;
+
+	devid = pdev->bus->number;
+	devid = (devid << 8) | pdev->devfn;
+
+	return devid;
+}
+
+static struct device_state *get_device_state(u16 devid)
+{
+	struct device_state *dev_state;
+	unsigned long flags;
+
+	spin_lock_irqsave(&state_lock, flags);
+	dev_state = state_table[devid];
+	if (dev_state != NULL)
+		atomic_inc(&dev_state->count);
+	spin_unlock_irqrestore(&state_lock, flags);
+
+	return dev_state;
+}
+
+static void free_device_state(struct device_state *dev_state)
+{
+	iommu_detach_device(dev_state->domain, &dev_state->pdev->dev);
+	iommu_domain_free(dev_state->domain);
+	kfree(dev_state);
+}
+
+static void put_device_state(struct device_state *dev_state)
+{
+	if (atomic_dec_and_test(&dev_state->count))
+		free_device_state(dev_state);
+}
+
+int amd_iommu_init_device(struct pci_dev *pdev, int pasids)
+{
+	struct device_state *dev_state;
+	unsigned long flags;
+	int ret, tmp;
+	u16 devid;
+
+	might_sleep();
+
+	if (!amd_iommu_v2_supported())
+		return -ENODEV;
+
+	if (pasids <= 0 || pasids & ~PASID_MASK)
+		return -EINVAL;
+
+	devid = device_id(pdev);
+
+	dev_state = kzalloc(sizeof(*dev_state), GFP_KERNEL);
+	if (dev_state == NULL)
+		return -ENOMEM;
+
+	spin_lock_init(&dev_state->lock);
+	dev_state->pdev = pdev;
+
+	tmp = pasids;
+	while (tmp & ~0x1ff) {
+		dev_state->pasid_levels += 1;
+		tmp >>= 9;
+	}
+
+	atomic_set(&dev_state->count, 1);
+	dev_state->max_pasids = pasids;
+
+	ret = -ENOMEM;
+	dev_state->states = (void *)get_zeroed_page(GFP_KERNEL);
+	if (dev_state->states == NULL)
+		goto out_free_dev_state;
+
+	dev_state->domain = iommu_domain_alloc(&pci_bus_type);
+	if (dev_state->domain == NULL)
+		goto out_free_states;
+
+	amd_iommu_domain_direct_map(dev_state->domain);
+
+	ret = amd_iommu_domain_enable_v2(dev_state->domain, pasids);
+	if (ret)
+		goto out_free_domain;
+
+	ret = iommu_attach_device(dev_state->domain, &pdev->dev);
+	if (ret != 0)
+		goto out_free_domain;
+
+	spin_lock_irqsave(&state_lock, flags);
+
+	if (state_table[devid] != NULL) {
+		spin_unlock_irqrestore(&state_lock, flags);
+		ret = -EBUSY;
+		goto out_free_domain;
+	}
+
+	state_table[devid] = dev_state;
+
+	spin_unlock_irqrestore(&state_lock, flags);
+
+	return 0;
+
+out_free_domain:
+	iommu_domain_free(dev_state->domain);
+
+out_free_states:
+	free_page((unsigned long)dev_state->states);
+
+out_free_dev_state:
+	kfree(dev_state);
+
+	return ret;
+}
+EXPORT_SYMBOL(amd_iommu_init_device);
+
+void amd_iommu_free_device(struct pci_dev *pdev)
+{
+	struct device_state *dev_state;
+	unsigned long flags;
+	u16 devid;
+
+	if (!amd_iommu_v2_supported())
+		return;
+
+	devid = device_id(pdev);
+
+	spin_lock_irqsave(&state_lock, flags);
+
+	dev_state = state_table[devid];
+	if (dev_state == NULL) {
+		spin_unlock_irqrestore(&state_lock, flags);
+		return;
+	}
+
+	state_table[devid] = NULL;
+
+	spin_unlock_irqrestore(&state_lock, flags);
+
+	put_device_state(dev_state);
+}
+EXPORT_SYMBOL(amd_iommu_free_device);
+
 static int __init amd_iommu_v2_init(void)
 {
+	size_t state_table_size;
+
 	pr_info("AMD IOMMUv2 driver by Joerg Roedel <joerg.roedel@amd.com>");
 
+	spin_lock_init(&state_lock);
+
+	state_table_size = MAX_DEVICES * sizeof(struct device_state *);
+	state_table = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+					       get_order(state_table_size));
+	if (state_table == NULL)
+		return -ENOMEM;
+
 	return 0;
 }
 
 static void __exit amd_iommu_v2_exit(void)
 {
+	struct device_state *dev_state;
+	size_t state_table_size;
+	int i;
+
+	for (i = 0; i < MAX_DEVICES; ++i) {
+		dev_state = get_device_state(i);
+
+		if (dev_state == NULL)
+			continue;
+
+		WARN_ON_ONCE(1);
+
+		amd_iommu_free_device(dev_state->pdev);
+		put_device_state(dev_state);
+	}
+
+	state_table_size = MAX_DEVICES * sizeof(struct device_state *);
+	free_pages((unsigned long)state_table, get_order(state_table_size));
 }
 
 module_init(amd_iommu_v2_init);
diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
index 4152c30..e8c7a2e 100644
--- a/include/linux/amd-iommu.h
+++ b/include/linux/amd-iommu.h
@@ -20,10 +20,12 @@
 #ifndef _ASM_X86_AMD_IOMMU_H
 #define _ASM_X86_AMD_IOMMU_H
 
-#include <linux/irqreturn.h>
+#include <linux/types.h>
 
 #ifdef CONFIG_AMD_IOMMU
 
+struct pci_dev;
+
 extern int amd_iommu_detect(void);
 
 
@@ -33,6 +35,7 @@ extern int amd_iommu_detect(void);
  * @pdev: The PCI device the workaround is necessary for
  * @erratum: The erratum workaround to enable
  *
+ * The function needs to be called before amd_iommu_init_device().
  * Possible values for the erratum number are for now:
  * - AMD_PRI_DEV_ERRATUM_ENABLE_RESET - Reset PRI capability when PRI
  *					is enabled
@@ -44,6 +47,24 @@ extern int amd_iommu_detect(void);
 
 extern void amd_iommu_enable_device_erratum(struct pci_dev *pdev, u32 erratum);
 
+/**
+ * amd_iommu_init_device() - Init device for use with IOMMUv2 driver
+ * @pdev: The PCI device to initialize
+ * @pasids: Number of PASIDs to support for this device
+ *
+ * This function does all setup for the device pdev so that it can be
+ * used with IOMMUv2.
+ * Returns 0 on success or negative value on error.
+ */
+extern int amd_iommu_init_device(struct pci_dev *pdev, int pasids);
+
+/**
+ * amd_iommu_free_device() - Free all IOMMUv2 related device resources
+ *			     and disable IOMMUv2 usage for this device
+ * @pdev: The PCI device to disable IOMMUv2 usage for'
+ */
+extern void amd_iommu_free_device(struct pci_dev *pdev);
+
 #else
 
 static inline int amd_iommu_detect(void) { return -ENODEV; }
-- 
1.7.5.4



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab1LENhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:37:19 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:42016
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932311Ab1LENfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:35:18 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVQGEJ-01-IPZ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 19/22] iommu/amd: Add routines to bind/unbind a pasid
Date: Mon, 5 Dec 2011 14:34:34 +0100
Message-ID: <1323092077-25501-20-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
References: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds routines to bind a specific process
address-space to a given PASID.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_v2.c |  301 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/amd-iommu.h    |   26 ++++
 2 files changed, 327 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index e0ec952..f54b991 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -19,6 +19,7 @@
 #include <linux/amd-iommu.h>
 #include <linux/mm_types.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/iommu.h>
 #include <linux/pci.h>
 #include <linux/gfp.h>
@@ -63,6 +64,9 @@ static spinlock_t state_lock;
 static LIST_HEAD(pasid_state_list);
 static DEFINE_SPINLOCK(ps_lock);
 
+static void free_pasid_states(struct device_state *dev_state);
+static void unbind_pasid(struct device_state *dev_state, int pasid);
+
 static u16 device_id(struct pci_dev *pdev)
 {
 	u16 devid;
@@ -89,8 +93,16 @@ static struct device_state *get_device_state(u16 devid)
 
 static void free_device_state(struct device_state *dev_state)
 {
+	/*
+	 * First detach device from domain - No more PRI requests will arrive
+	 * from that device after it is unbound from the IOMMUv2 domain.
+	 */
 	iommu_detach_device(dev_state->domain, &dev_state->pdev->dev);
+
+	/* Everything is down now, free the IOMMUv2 domain */
 	iommu_domain_free(dev_state->domain);
+
+	/* Finally get rid of the device-state */
 	kfree(dev_state);
 }
 
@@ -100,6 +112,292 @@ static void put_device_state(struct device_state *dev_state)
 		free_device_state(dev_state);
 }
 
+static void link_pasid_state(struct pasid_state *pasid_state)
+{
+	spin_lock(&ps_lock);
+	list_add_tail(&pasid_state->list, &pasid_state_list);
+	spin_unlock(&ps_lock);
+}
+
+static void __unlink_pasid_state(struct pasid_state *pasid_state)
+{
+	list_del(&pasid_state->list);
+}
+
+static void unlink_pasid_state(struct pasid_state *pasid_state)
+{
+	spin_lock(&ps_lock);
+	__unlink_pasid_state(pasid_state);
+	spin_unlock(&ps_lock);
+}
+
+/* Must be called under dev_state->lock */
+static struct pasid_state **__get_pasid_state_ptr(struct device_state *dev_state,
+						  int pasid, bool alloc)
+{
+	struct pasid_state **root, **ptr;
+	int level, index;
+
+	level = dev_state->pasid_levels;
+	root  = dev_state->states;
+
+	while (true) {
+
+		index = (pasid >> (9 * level)) & 0x1ff;
+		ptr   = &root[index];
+
+		if (level == 0)
+			break;
+
+		if (*ptr == NULL) {
+			if (!alloc)
+				return NULL;
+
+			*ptr = (void *)get_zeroed_page(GFP_ATOMIC);
+			if (*ptr == NULL)
+				return NULL;
+		}
+
+		root   = (struct pasid_state **)*ptr;
+		level -= 1;
+	}
+
+	return ptr;
+}
+
+static int set_pasid_state(struct device_state *dev_state,
+			   struct pasid_state *pasid_state,
+			   int pasid)
+{
+	struct pasid_state **ptr;
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&dev_state->lock, flags);
+	ptr = __get_pasid_state_ptr(dev_state, pasid, true);
+
+	ret = -ENOMEM;
+	if (ptr == NULL)
+		goto out_unlock;
+
+	ret = -ENOMEM;
+	if (*ptr != NULL)
+		goto out_unlock;
+
+	*ptr = pasid_state;
+
+	ret = 0;
+
+out_unlock:
+	spin_unlock_irqrestore(&dev_state->lock, flags);
+
+	return ret;
+}
+
+static void clear_pasid_state(struct device_state *dev_state, int pasid)
+{
+	struct pasid_state **ptr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev_state->lock, flags);
+	ptr = __get_pasid_state_ptr(dev_state, pasid, true);
+
+	if (ptr == NULL)
+		goto out_unlock;
+
+	*ptr = NULL;
+
+out_unlock:
+	spin_unlock_irqrestore(&dev_state->lock, flags);
+}
+
+static struct pasid_state *get_pasid_state(struct device_state *dev_state,
+					   int pasid)
+{
+	struct pasid_state **ptr, *ret = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev_state->lock, flags);
+	ptr = __get_pasid_state_ptr(dev_state, pasid, false);
+
+	if (ptr == NULL)
+		goto out_unlock;
+
+	ret = *ptr;
+	if (ret)
+		atomic_inc(&ret->count);
+
+out_unlock:
+	spin_unlock_irqrestore(&dev_state->lock, flags);
+
+	return ret;
+}
+
+static void free_pasid_state(struct pasid_state *pasid_state)
+{
+	kfree(pasid_state);
+}
+
+static void put_pasid_state(struct pasid_state *pasid_state)
+{
+	if (atomic_dec_and_test(&pasid_state->count)) {
+		put_device_state(pasid_state->device_state);
+		free_pasid_state(pasid_state);
+	}
+}
+
+static void unbind_pasid(struct device_state *dev_state, int pasid)
+{
+	struct pasid_state *pasid_state;
+
+	pasid_state = get_pasid_state(dev_state, pasid);
+	if (pasid_state == NULL)
+		return;
+
+	unlink_pasid_state(pasid_state);
+
+	amd_iommu_domain_clear_gcr3(dev_state->domain, pasid);
+	clear_pasid_state(dev_state, pasid);
+
+	put_pasid_state(pasid_state); /* Reference taken in this function */
+	put_pasid_state(pasid_state); /* Reference taken in bind() function */
+}
+
+static void free_pasid_states_level1(struct pasid_state **tbl)
+{
+	int i;
+
+	for (i = 0; i < 512; ++i) {
+		if (tbl[i] == NULL)
+			continue;
+
+		free_page((unsigned long)tbl[i]);
+	}
+}
+
+static void free_pasid_states_level2(struct pasid_state **tbl)
+{
+	struct pasid_state **ptr;
+	int i;
+
+	for (i = 0; i < 512; ++i) {
+		if (tbl[i] == NULL)
+			continue;
+
+		ptr = (struct pasid_state **)tbl[i];
+		free_pasid_states_level1(ptr);
+	}
+}
+
+static void free_pasid_states(struct device_state *dev_state)
+{
+	struct pasid_state *pasid_state;
+	int i;
+
+	for (i = 0; i < dev_state->max_pasids; ++i) {
+		pasid_state = get_pasid_state(dev_state, i);
+		if (pasid_state == NULL)
+			continue;
+
+		unbind_pasid(dev_state, i);
+		put_pasid_state(pasid_state);
+	}
+
+	if (dev_state->pasid_levels == 2)
+		free_pasid_states_level2(dev_state->states);
+	else if (dev_state->pasid_levels == 1)
+		free_pasid_states_level1(dev_state->states);
+	else if (dev_state->pasid_levels != 0)
+		BUG();
+
+	free_page((unsigned long)dev_state->states);
+}
+
+int amd_iommu_bind_pasid(struct pci_dev *pdev, int pasid,
+			 struct task_struct *task)
+{
+	struct pasid_state *pasid_state;
+	struct device_state *dev_state;
+	u16 devid;
+	int ret;
+
+	might_sleep();
+
+	if (!amd_iommu_v2_supported())
+		return -ENODEV;
+
+	devid     = device_id(pdev);
+	dev_state = get_device_state(devid);
+
+	if (dev_state == NULL)
+		return -EINVAL;
+
+	ret = -EINVAL;
+	if (pasid < 0 || pasid >= dev_state->max_pasids)
+		goto out;
+
+	ret = -ENOMEM;
+	pasid_state = kzalloc(sizeof(*pasid_state), GFP_KERNEL);
+	if (pasid_state == NULL)
+		goto out;
+
+	atomic_set(&pasid_state->count, 1);
+	pasid_state->task         = task;
+	pasid_state->mm           = task->mm;
+	pasid_state->device_state = dev_state;
+	pasid_state->pasid        = pasid;
+
+	ret = set_pasid_state(dev_state, pasid_state, pasid);
+	if (ret)
+		goto out_free;
+
+	ret = amd_iommu_domain_set_gcr3(dev_state->domain, pasid,
+					__pa(pasid_state->mm->pgd));
+	if (ret)
+		goto out_clear_state;
+
+	link_pasid_state(pasid_state);
+
+	return 0;
+
+out_clear_state:
+	clear_pasid_state(dev_state, pasid);
+
+out_free:
+	put_pasid_state(pasid_state);
+
+out:
+	put_device_state(dev_state);
+
+	return ret;
+}
+EXPORT_SYMBOL(amd_iommu_bind_pasid);
+
+void amd_iommu_unbind_pasid(struct pci_dev *pdev, int pasid)
+{
+	struct device_state *dev_state;
+	u16 devid;
+
+	might_sleep();
+
+	if (!amd_iommu_v2_supported())
+		return;
+
+	devid = device_id(pdev);
+	dev_state = get_device_state(devid);
+	if (dev_state == NULL)
+		return;
+
+	if (pasid < 0 || pasid >= dev_state->max_pasids)
+		goto out;
+
+	unbind_pasid(dev_state, pasid);
+
+out:
+	put_device_state(dev_state);
+}
+EXPORT_SYMBOL(amd_iommu_unbind_pasid);
+
 int amd_iommu_init_device(struct pci_dev *pdev, int pasids)
 {
 	struct device_state *dev_state;
@@ -202,6 +500,9 @@ void amd_iommu_free_device(struct pci_dev *pdev)
 
 	spin_unlock_irqrestore(&state_lock, flags);
 
+	/* Get rid of any remaining pasid states */
+	free_pasid_states(dev_state);
+
 	put_device_state(dev_state);
 }
 EXPORT_SYMBOL(amd_iommu_free_device);
diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
index e8c7a2e..23e21e1 100644
--- a/include/linux/amd-iommu.h
+++ b/include/linux/amd-iommu.h
@@ -24,9 +24,13 @@
 
 #ifdef CONFIG_AMD_IOMMU
 
+struct task_struct;
 struct pci_dev;
 
 extern int amd_iommu_detect(void);
+extern int amd_iommu_bind_pasid(struct pci_dev *pdev, int pasid,
+				struct task_struct *task);
+extern void amd_iommu_unbind_pasid(struct pci_dev *pdev, int pasid);
 
 
 /**
@@ -65,6 +69,28 @@ extern int amd_iommu_init_device(struct pci_dev *pdev, int pasids);
  */
 extern void amd_iommu_free_device(struct pci_dev *pdev);
 
+/**
+ * amd_iommu_bind_pasid() - Bind a given task to a PASID on a device
+ * @pdev: The PCI device to bind the task to
+ * @pasid: The PASID on the device the task should be bound to
+ * @task: the task to bind
+ *
+ * The function returns 0 on success or a negative value on error.
+ */
+extern int amd_iommu_bind_pasid(struct pci_dev *pdev, int pasid,
+				struct task_struct *task);
+
+/**
+ * amd_iommu_unbind_pasid() - Unbind a PASID from its task on
+ *			      a device
+ * @pdev: The device of the PASID
+ * @pasid: The PASID to unbind
+ *
+ * When this function returns the device is no longer using the PASID
+ * and the PASID is no longer bound to its task.
+ */
+extern void amd_iommu_unbind_pasid(struct pci_dev *pdev, int pasid);
+
 #else
 
 static inline int amd_iommu_detect(void) { return -ENODEV; }
-- 
1.7.5.4



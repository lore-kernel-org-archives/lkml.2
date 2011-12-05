Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab1LENiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:38:15 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:46271
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932311Ab1LENiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:38:12 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVQGEK-02-AUU-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 20/22] iommu/amd: Implement IO page-fault handler
Date: Mon, 5 Dec 2011 14:34:35 +0100
Message-ID: <1323092077-25501-21-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
References: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register the notifier for PPR faults and handle them as
necessary.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_v2.c |  200 ++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 194 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index f54b991..0f2ffff 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -21,9 +21,11 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/iommu.h>
+#include <linux/wait.h>
 #include <linux/pci.h>
 #include <linux/gfp.h>
 
+#include "amd_iommu_types.h"
 #include "amd_iommu_proto.h"
 
 MODULE_LICENSE("GPL v2");
@@ -35,6 +37,7 @@ MODULE_AUTHOR("Joerg Roedel <joerg.roedel@amd.com>");
 struct pri_queue {
 	atomic_t inflight;
 	bool finish;
+	int status;
 };
 
 struct pasid_state {
@@ -45,6 +48,8 @@ struct pasid_state {
 	struct pri_queue pri[PRI_QUEUE_SIZE];	/* PRI tag states */
 	struct device_state *device_state;	/* Link to our device_state */
 	int pasid;				/* PASID index */
+	spinlock_t lock;			/* Protect pri_queues */
+	wait_queue_head_t wq;			/* To wait for count == 0 */
 };
 
 struct device_state {
@@ -55,6 +60,20 @@ struct device_state {
 	int pasid_levels;
 	int max_pasids;
 	spinlock_t lock;
+	wait_queue_head_t wq;
+};
+
+struct fault {
+	struct work_struct work;
+	struct device_state *dev_state;
+	struct pasid_state *state;
+	struct mm_struct *mm;
+	u64 address;
+	u16 devid;
+	u16 pasid;
+	u16 tag;
+	u16 finish;
+	u16 flags;
 };
 
 struct device_state **state_table;
@@ -64,6 +83,8 @@ static spinlock_t state_lock;
 static LIST_HEAD(pasid_state_list);
 static DEFINE_SPINLOCK(ps_lock);
 
+static struct workqueue_struct *iommu_wq;
+
 static void free_pasid_states(struct device_state *dev_state);
 static void unbind_pasid(struct device_state *dev_state, int pasid);
 
@@ -109,9 +130,20 @@ static void free_device_state(struct device_state *dev_state)
 static void put_device_state(struct device_state *dev_state)
 {
 	if (atomic_dec_and_test(&dev_state->count))
-		free_device_state(dev_state);
+		wake_up(&dev_state->wq);
 }
 
+static void put_device_state_wait(struct device_state *dev_state)
+{
+	DEFINE_WAIT(wait);
+
+	prepare_to_wait(&dev_state->wq, &wait, TASK_UNINTERRUPTIBLE);
+	if (!atomic_dec_and_test(&dev_state->count))
+		schedule();
+	finish_wait(&dev_state->wq, &wait);
+
+	free_device_state(dev_state);
+}
 static void link_pasid_state(struct pasid_state *pasid_state)
 {
 	spin_lock(&ps_lock);
@@ -242,10 +274,25 @@ static void put_pasid_state(struct pasid_state *pasid_state)
 {
 	if (atomic_dec_and_test(&pasid_state->count)) {
 		put_device_state(pasid_state->device_state);
-		free_pasid_state(pasid_state);
+		wake_up(&pasid_state->wq);
 	}
 }
 
+static void put_pasid_state_wait(struct pasid_state *pasid_state)
+{
+	DEFINE_WAIT(wait);
+
+	prepare_to_wait(&pasid_state->wq, &wait, TASK_UNINTERRUPTIBLE);
+
+	if (atomic_dec_and_test(&pasid_state->count))
+		put_device_state(pasid_state->device_state);
+	else
+		schedule();
+
+	finish_wait(&pasid_state->wq, &wait);
+	free_pasid_state(pasid_state);
+}
+
 static void unbind_pasid(struct device_state *dev_state, int pasid)
 {
 	struct pasid_state *pasid_state;
@@ -260,7 +307,7 @@ static void unbind_pasid(struct device_state *dev_state, int pasid)
 	clear_pasid_state(dev_state, pasid);
 
 	put_pasid_state(pasid_state); /* Reference taken in this function */
-	put_pasid_state(pasid_state); /* Reference taken in bind() function */
+	put_pasid_state_wait(pasid_state); /* Reference from bind() function */
 }
 
 static void free_pasid_states_level1(struct pasid_state **tbl)
@@ -299,8 +346,8 @@ static void free_pasid_states(struct device_state *dev_state)
 		if (pasid_state == NULL)
 			continue;
 
-		unbind_pasid(dev_state, i);
 		put_pasid_state(pasid_state);
+		unbind_pasid(dev_state, i);
 	}
 
 	if (dev_state->pasid_levels == 2)
@@ -313,6 +360,120 @@ static void free_pasid_states(struct device_state *dev_state)
 	free_page((unsigned long)dev_state->states);
 }
 
+static void set_pri_tag_status(struct pasid_state *pasid_state,
+			       u16 tag, int status)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&pasid_state->lock, flags);
+	pasid_state->pri[tag].status = status;
+	spin_unlock_irqrestore(&pasid_state->lock, flags);
+}
+
+static void finish_pri_tag(struct device_state *dev_state,
+			   struct pasid_state *pasid_state,
+			   u16 tag)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&pasid_state->lock, flags);
+	if (atomic_dec_and_test(&pasid_state->pri[tag].inflight) &&
+	    pasid_state->pri[tag].finish) {
+		amd_iommu_complete_ppr(dev_state->pdev, pasid_state->pasid,
+				       pasid_state->pri[tag].status, tag);
+		pasid_state->pri[tag].finish = false;
+		pasid_state->pri[tag].status = PPR_SUCCESS;
+	}
+	spin_unlock_irqrestore(&pasid_state->lock, flags);
+}
+
+static void do_fault(struct work_struct *work)
+{
+	struct fault *fault = container_of(work, struct fault, work);
+	int npages, write;
+	struct page *page;
+
+	write = !!(fault->flags & PPR_FAULT_WRITE);
+
+	npages = get_user_pages(fault->state->task, fault->state->mm,
+				fault->address, 1, write, 0, &page, NULL);
+
+	if (npages == 1)
+		put_page(page);
+	else
+		set_pri_tag_status(fault->state, fault->tag, PPR_INVALID);
+
+	finish_pri_tag(fault->dev_state, fault->state, fault->tag);
+
+	put_pasid_state(fault->state);
+
+	kfree(fault);
+}
+
+static int ppr_notifier(struct notifier_block *nb, unsigned long e, void *data)
+{
+	struct amd_iommu_fault *iommu_fault;
+	struct pasid_state *pasid_state;
+	struct device_state *dev_state;
+	unsigned long flags;
+	struct fault *fault;
+	bool finish;
+	u16 tag;
+	int ret;
+
+	iommu_fault = data;
+	tag         = iommu_fault->tag & 0x1ff;
+	finish      = (iommu_fault->tag >> 9) & 1;
+
+	ret = NOTIFY_DONE;
+	dev_state = get_device_state(iommu_fault->device_id);
+	if (dev_state == NULL)
+		goto out;
+
+	pasid_state = get_pasid_state(dev_state, iommu_fault->pasid);
+	if (pasid_state == NULL) {
+		/* We know the device but not the PASID -> send INVALID */
+		amd_iommu_complete_ppr(dev_state->pdev, iommu_fault->pasid,
+				       PPR_INVALID, tag);
+		goto out_drop_state;
+	}
+
+	spin_lock_irqsave(&pasid_state->lock, flags);
+	atomic_inc(&pasid_state->pri[tag].inflight);
+	if (finish)
+		pasid_state->pri[tag].finish = true;
+	spin_unlock_irqrestore(&pasid_state->lock, flags);
+
+	fault = kzalloc(sizeof(*fault), GFP_ATOMIC);
+	if (fault == NULL) {
+		/* We are OOM - send success and let the device re-fault */
+		finish_pri_tag(dev_state, pasid_state, tag);
+		goto out_drop_state;
+	}
+
+	fault->dev_state = dev_state;
+	fault->address   = iommu_fault->address;
+	fault->state     = pasid_state;
+	fault->tag       = tag;
+	fault->finish    = finish;
+	fault->flags     = iommu_fault->flags;
+	INIT_WORK(&fault->work, do_fault);
+
+	queue_work(iommu_wq, &fault->work);
+
+	ret = NOTIFY_OK;
+
+out_drop_state:
+	put_device_state(dev_state);
+
+out:
+	return ret;
+}
+
+static struct notifier_block ppr_nb = {
+	.notifier_call = ppr_notifier,
+};
+
 int amd_iommu_bind_pasid(struct pci_dev *pdev, int pasid,
 			 struct task_struct *task)
 {
@@ -342,6 +503,7 @@ int amd_iommu_bind_pasid(struct pci_dev *pdev, int pasid,
 		goto out;
 
 	atomic_set(&pasid_state->count, 1);
+	init_waitqueue_head(&pasid_state->wq);
 	pasid_state->task         = task;
 	pasid_state->mm           = task->mm;
 	pasid_state->device_state = dev_state;
@@ -420,6 +582,7 @@ int amd_iommu_init_device(struct pci_dev *pdev, int pasids)
 		return -ENOMEM;
 
 	spin_lock_init(&dev_state->lock);
+	init_waitqueue_head(&dev_state->wq);
 	dev_state->pdev = pdev;
 
 	tmp = pasids;
@@ -503,13 +666,14 @@ void amd_iommu_free_device(struct pci_dev *pdev)
 	/* Get rid of any remaining pasid states */
 	free_pasid_states(dev_state);
 
-	put_device_state(dev_state);
+	put_device_state_wait(dev_state);
 }
 EXPORT_SYMBOL(amd_iommu_free_device);
 
 static int __init amd_iommu_v2_init(void)
 {
 	size_t state_table_size;
+	int ret;
 
 	pr_info("AMD IOMMUv2 driver by Joerg Roedel <joerg.roedel@amd.com>");
 
@@ -521,7 +685,21 @@ static int __init amd_iommu_v2_init(void)
 	if (state_table == NULL)
 		return -ENOMEM;
 
+	ret = -ENOMEM;
+	iommu_wq = create_workqueue("amd_iommu_v2");
+	if (iommu_wq == NULL) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	amd_iommu_register_ppr_notifier(&ppr_nb);
+
 	return 0;
+
+out_free:
+	free_pages((unsigned long)state_table, get_order(state_table_size));
+
+	return ret;
 }
 
 static void __exit amd_iommu_v2_exit(void)
@@ -530,6 +708,14 @@ static void __exit amd_iommu_v2_exit(void)
 	size_t state_table_size;
 	int i;
 
+	amd_iommu_unregister_ppr_notifier(&ppr_nb);
+
+	flush_workqueue(iommu_wq);
+
+	/*
+	 * The loop below might call flush_workqueue(), so call
+	 * destroy_workqueue() after it
+	 */
 	for (i = 0; i < MAX_DEVICES; ++i) {
 		dev_state = get_device_state(i);
 
@@ -538,10 +724,12 @@ static void __exit amd_iommu_v2_exit(void)
 
 		WARN_ON_ONCE(1);
 
-		amd_iommu_free_device(dev_state->pdev);
 		put_device_state(dev_state);
+		amd_iommu_free_device(dev_state->pdev);
 	}
 
+	destroy_workqueue(iommu_wq);
+
 	state_table_size = MAX_DEVICES * sizeof(struct device_state *);
 	free_pages((unsigned long)state_table, get_order(state_table_size));
 }
-- 
1.7.5.4



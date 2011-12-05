Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474Ab1LENf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:35:56 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:9339 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab1LENfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:35:22 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LVQGEC-02-AUG-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 21/22] iommu/amd: Implement notifiers for IOMMUv2
Date: Mon, 5 Dec 2011 14:34:36 +0100
Message-ID: <1323092077-25501-22-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
References: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since pages are not pinned anymore we need notifications
when the VMM changes the page-tables. Use mmu_notifiers for
that.
Also use the task_exit notifier from the profiling subsystem
to shutdown all contexts related to this task.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/Kconfig        |    3 +-
 drivers/iommu/amd_iommu_v2.c |  178 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 171 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index e608a36..6bea696 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -62,7 +62,8 @@ config AMD_IOMMU_STATS
 
 config AMD_IOMMU_V2
 	tristate "AMD IOMMU Version 2 driver (EXPERIMENTAL)"
-	depends on AMD_IOMMU && EXPERIMENTAL
+	depends on AMD_IOMMU && PROFILING && EXPERIMENTAL
+	select MMU_NOTIFIER
 	---help---
 	  This option enables support for the AMD IOMMUv2 features of the IOMMU
 	  hardware. Select this option if you want to use devices that support
diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 0f2ffff..ffe85e0 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -16,8 +16,10 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
+#include <linux/mmu_notifier.h>
 #include <linux/amd-iommu.h>
 #include <linux/mm_types.h>
+#include <linux/profile.h>
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/iommu.h>
@@ -45,6 +47,7 @@ struct pasid_state {
 	atomic_t count;				/* Reference count */
 	struct task_struct *task;		/* Task bound to this PASID */
 	struct mm_struct *mm;			/* mm_struct for the faults */
+	struct mmu_notifier mn;                 /* mmu_otifier handle */
 	struct pri_queue pri[PRI_QUEUE_SIZE];	/* PRI tag states */
 	struct device_state *device_state;	/* Link to our device_state */
 	int pasid;				/* PASID index */
@@ -85,8 +88,16 @@ static DEFINE_SPINLOCK(ps_lock);
 
 static struct workqueue_struct *iommu_wq;
 
+/*
+ * Empty page table - Used between
+ * mmu_notifier_invalidate_range_start and
+ * mmu_notifier_invalidate_range_end
+ */
+static u64 *empty_page_table;
+
 static void free_pasid_states(struct device_state *dev_state);
 static void unbind_pasid(struct device_state *dev_state, int pasid);
+static int task_exit(struct notifier_block *nb, unsigned long e, void *data);
 
 static u16 device_id(struct pci_dev *pdev)
 {
@@ -144,6 +155,11 @@ static void put_device_state_wait(struct device_state *dev_state)
 
 	free_device_state(dev_state);
 }
+
+static struct notifier_block profile_nb = {
+	.notifier_call = task_exit,
+};
+
 static void link_pasid_state(struct pasid_state *pasid_state)
 {
 	spin_lock(&ps_lock);
@@ -293,6 +309,23 @@ static void put_pasid_state_wait(struct pasid_state *pasid_state)
 	free_pasid_state(pasid_state);
 }
 
+static void __unbind_pasid(struct pasid_state *pasid_state)
+{
+	struct iommu_domain *domain;
+
+	domain = pasid_state->device_state->domain;
+
+	amd_iommu_domain_clear_gcr3(domain, pasid_state->pasid);
+	clear_pasid_state(pasid_state->device_state, pasid_state->pasid);
+
+	/* Make sure no more pending faults are in the queue */
+	flush_workqueue(iommu_wq);
+
+	mmu_notifier_unregister(&pasid_state->mn, pasid_state->mm);
+
+	put_pasid_state(pasid_state); /* Reference taken in bind() function */
+}
+
 static void unbind_pasid(struct device_state *dev_state, int pasid)
 {
 	struct pasid_state *pasid_state;
@@ -302,12 +335,8 @@ static void unbind_pasid(struct device_state *dev_state, int pasid)
 		return;
 
 	unlink_pasid_state(pasid_state);
-
-	amd_iommu_domain_clear_gcr3(dev_state->domain, pasid);
-	clear_pasid_state(dev_state, pasid);
-
-	put_pasid_state(pasid_state); /* Reference taken in this function */
-	put_pasid_state_wait(pasid_state); /* Reference from bind() function */
+	__unbind_pasid(pasid_state);
+	put_pasid_state_wait(pasid_state); /* Reference taken in this function */
 }
 
 static void free_pasid_states_level1(struct pasid_state **tbl)
@@ -360,6 +389,83 @@ static void free_pasid_states(struct device_state *dev_state)
 	free_page((unsigned long)dev_state->states);
 }
 
+static struct pasid_state *mn_to_state(struct mmu_notifier *mn)
+{
+	return container_of(mn, struct pasid_state, mn);
+}
+
+static void __mn_flush_page(struct mmu_notifier *mn,
+			    unsigned long address)
+{
+	struct pasid_state *pasid_state;
+	struct device_state *dev_state;
+
+	pasid_state = mn_to_state(mn);
+	dev_state   = pasid_state->device_state;
+
+	amd_iommu_flush_page(dev_state->domain, pasid_state->pasid, address);
+}
+
+static int mn_clear_flush_young(struct mmu_notifier *mn,
+				struct mm_struct *mm,
+				unsigned long address)
+{
+	__mn_flush_page(mn, address);
+
+	return 0;
+}
+
+static void mn_change_pte(struct mmu_notifier *mn,
+			  struct mm_struct *mm,
+			  unsigned long address,
+			  pte_t pte)
+{
+	__mn_flush_page(mn, address);
+}
+
+static void mn_invalidate_page(struct mmu_notifier *mn,
+			       struct mm_struct *mm,
+			       unsigned long address)
+{
+	__mn_flush_page(mn, address);
+}
+
+static void mn_invalidate_range_start(struct mmu_notifier *mn,
+				      struct mm_struct *mm,
+				      unsigned long start, unsigned long end)
+{
+	struct pasid_state *pasid_state;
+	struct device_state *dev_state;
+
+	pasid_state = mn_to_state(mn);
+	dev_state   = pasid_state->device_state;
+
+	amd_iommu_domain_set_gcr3(dev_state->domain, pasid_state->pasid,
+				  __pa(empty_page_table));
+}
+
+static void mn_invalidate_range_end(struct mmu_notifier *mn,
+				    struct mm_struct *mm,
+				    unsigned long start, unsigned long end)
+{
+	struct pasid_state *pasid_state;
+	struct device_state *dev_state;
+
+	pasid_state = mn_to_state(mn);
+	dev_state   = pasid_state->device_state;
+
+	amd_iommu_domain_set_gcr3(dev_state->domain, pasid_state->pasid,
+				  __pa(pasid_state->mm->pgd));
+}
+
+static struct mmu_notifier_ops iommu_mn = {
+	.clear_flush_young      = mn_clear_flush_young,
+	.change_pte             = mn_change_pte,
+	.invalidate_page        = mn_invalidate_page,
+	.invalidate_range_start = mn_invalidate_range_start,
+	.invalidate_range_end   = mn_invalidate_range_end,
+};
+
 static void set_pri_tag_status(struct pasid_state *pasid_state,
 			       u16 tag, int status)
 {
@@ -474,6 +580,47 @@ static struct notifier_block ppr_nb = {
 	.notifier_call = ppr_notifier,
 };
 
+static int task_exit(struct notifier_block *nb, unsigned long e, void *data)
+{
+	struct pasid_state *pasid_state;
+	struct task_struct *task;
+
+	task = data;
+
+	/*
+	 * Using this notifier is a hack - but there is no other choice
+	 * at the moment. What I really want is a sleeping notifier that
+	 * is called when an MM goes down. But such a notifier doesn't
+	 * exist yet. The notifier needs to sleep because it has to make
+	 * sure that the device does not use the PASID and the address
+	 * space anymore before it is destroyed. This includes waiting
+	 * for pending PRI requests to pass the workqueue. The
+	 * MMU-Notifiers would be a good fit, but they use RCU and so
+	 * they are not allowed to sleep. Lets see how we can solve this
+	 * in a more intelligent way in the future.
+	 */
+again:
+	spin_lock(&ps_lock);
+	list_for_each_entry(pasid_state, &pasid_state_list, list) {
+		if (pasid_state->task != task)
+			continue;
+
+		/* Found one - remove it from list */
+		__unlink_pasid_state(pasid_state);
+
+		/* Drop Lock and unbind */
+		spin_unlock(&ps_lock);
+
+		__unbind_pasid(pasid_state);
+
+		/* Task may be in the list multiple times */
+		goto again;
+	}
+	spin_unlock(&ps_lock);
+
+	return NOTIFY_OK;
+}
+
 int amd_iommu_bind_pasid(struct pci_dev *pdev, int pasid,
 			 struct task_struct *task)
 {
@@ -508,6 +655,9 @@ int amd_iommu_bind_pasid(struct pci_dev *pdev, int pasid,
 	pasid_state->mm           = task->mm;
 	pasid_state->device_state = dev_state;
 	pasid_state->pasid        = pasid;
+	pasid_state->mn.ops       = &iommu_mn;
+
+	mmu_notifier_register(&pasid_state->mn, pasid_state->mm);
 
 	ret = set_pasid_state(dev_state, pasid_state, pasid);
 	if (ret)
@@ -687,15 +837,22 @@ static int __init amd_iommu_v2_init(void)
 
 	ret = -ENOMEM;
 	iommu_wq = create_workqueue("amd_iommu_v2");
-	if (iommu_wq == NULL) {
-		ret = -ENOMEM;
+	if (iommu_wq == NULL)
 		goto out_free;
-	}
+
+	ret = -ENOMEM;
+	empty_page_table = (u64 *)get_zeroed_page(GFP_KERNEL);
+	if (empty_page_table == NULL)
+		goto out_destroy_wq;
 
 	amd_iommu_register_ppr_notifier(&ppr_nb);
+	profile_event_register(PROFILE_TASK_EXIT, &profile_nb);
 
 	return 0;
 
+out_destroy_wq:
+	destroy_workqueue(iommu_wq);
+
 out_free:
 	free_pages((unsigned long)state_table, get_order(state_table_size));
 
@@ -708,6 +865,7 @@ static void __exit amd_iommu_v2_exit(void)
 	size_t state_table_size;
 	int i;
 
+	profile_event_unregister(PROFILE_TASK_EXIT, &profile_nb);
 	amd_iommu_unregister_ppr_notifier(&ppr_nb);
 
 	flush_workqueue(iommu_wq);
@@ -732,6 +890,8 @@ static void __exit amd_iommu_v2_exit(void)
 
 	state_table_size = MAX_DEVICES * sizeof(struct device_state *);
 	free_pages((unsigned long)state_table, get_order(state_table_size));
+
+	free_page((unsigned long)empty_page_table);
 }
 
 module_init(amd_iommu_v2_init);
-- 
1.7.5.4



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab2JPOGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 10:06:21 -0400
Received: from mail.x86-64.org ([217.9.48.20]:45092 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123Ab2JPOGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 10:06:19 -0400
From: Borislav Petkov <bp@amd64.org>
To: Steffen Persvold <sp@numascale.com>,
        Daniel J Blueman <daniel@numascale-asia.com>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH] x86, AMD, NB: Cleanup and improve NB descriptors handling
Date: Tue, 16 Oct 2012 16:06:15 +0200
Message-Id: <1350396375-26896-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

First of all, the double loop of first counting the northbridges on
the system, then allocating them and then going over them again was
bugging me for a long time now. Fix it by moving the allocation of the
descriptors in the initial iteration path.

Then, modify the enclosing _info structure to contain two NB descriptor
structures: and array of 8 NB descs which contains the first 8 possible
NB descriptors for all single-board AMD systems out there. This is no
different from the current state of affairs and is done this way so that
lookup of those descriptors remains fast.

Then, there's a linked list of further NB descs which are for large,
confederated systems like NumaScale where more than 8 nodes are present
in the fabric and are visible to the single system Linux image. We keep
those unique by introducing the PCI domain ID into the node ID used for
descriptor lookup.

Rest of the code is cleanup and readability improvements.

Cc: Steffen Persvold <sp@numascale.com>
Cc: Daniel J Blueman <daniel@numascale-asia.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/amd_nb.h | 31 +++++++++++++++--
 arch/x86/kernel/amd_nb.c      | 79 +++++++++++++++++++++++++------------------
 drivers/edac/amd64_edac.c     |  6 ++--
 drivers/edac/amd64_edac.h     |  6 ----
 4 files changed, 78 insertions(+), 44 deletions(-)

diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index b3341e9cd8fd..14579f836c28 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -4,6 +4,8 @@
 #include <linux/ioport.h>
 #include <linux/pci.h>
 
+#define NUM_POSSIBLE_NBS	8
+
 struct amd_nb_bus_dev_range {
 	u8 bus;
 	u8 dev_base;
@@ -51,12 +53,22 @@ struct amd_northbridge {
 	struct pci_dev *link;
 	struct amd_l3_cache l3_cache;
 	struct threshold_bank *bank4;
+	u32 node;
+	struct list_head nbl;
 };
 
 struct amd_northbridge_info {
 	u16 num;
 	u64 flags;
-	struct amd_northbridge *nb;
+
+	/*
+	 * The first 8 elems are for fast lookup of NB descriptors on single-
+	 * system image setups, i.e. "normal" boxes. The nb_list, OTOH, is a
+	 * list of additional NB descriptors which exist on confederate systems
+	 * like NumaScale.
+	 */
+	struct amd_northbridge *nbs[NUM_POSSIBLE_NBS];
+	struct list_head nb_list;
 };
 extern struct amd_northbridge_info amd_northbridges;
 
@@ -78,7 +90,22 @@ static inline bool amd_nb_has_feature(unsigned feature)
 
 static inline struct amd_northbridge *node_to_amd_nb(int node)
 {
-	return (node < amd_northbridges.num) ? &amd_northbridges.nb[node] : NULL;
+	struct amd_northbridge_info *nbi = &amd_northbridges;
+	struct amd_northbridge *nb, *nb_tmp;
+
+	if (node < NUM_POSSIBLE_NBS && node < nbi->num)
+		return nbi->nbs[node];
+
+	list_for_each_entry_safe(nb, nb_tmp, &nbi->nb_list, nbl)
+		if (node == nb->node)
+			return nb;
+
+	return NULL;
+}
+
+static inline u32 amd_get_node_id(struct pci_dev *pdev)
+{
+	return (pci_domain_nr(pdev->bus) << 8) | (PCI_SLOT(pdev->devfn) - 0x18);
 }
 
 #else
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index aadf3359e2a7..85b47a907c91 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -50,58 +50,71 @@ static struct pci_dev *next_northbridge(struct pci_dev *dev,
 	return dev;
 }
 
-int amd_cache_northbridges(void)
+static int _alloc_nb_desc(struct pci_dev *misc)
 {
-	u16 i = 0;
+	struct amd_northbridge_info *nbi = &amd_northbridges;
 	struct amd_northbridge *nb;
-	struct pci_dev *misc, *link;
 
-	if (amd_nb_num())
-		return 0;
+	nb = kzalloc(sizeof(*nb), GFP_KERNEL);
+	if (!nb)
+		return -ENOMEM;
+
+	nb->misc = misc;
+	nb->link = next_northbridge(nb->link, amd_nb_link_ids);
+
+	if (nbi->num < NUM_POSSIBLE_NBS) {
+		nbi->nbs[nbi->num] = nb;
+	} else {
+		INIT_LIST_HEAD(&nb->nbl);
+		list_add_tail(&nb->nbl, &nbi->nb_list);
+	}
+
+	nb->node = amd_get_node_id(misc);
+	nbi->num++;
+
+	return 0;
+}
 
-	misc = NULL;
-	while ((misc = next_northbridge(misc, amd_nb_misc_ids)) != NULL)
-		i++;
+int amd_cache_northbridges(void)
+{
+	struct amd_northbridge_info *nbi = &amd_northbridges;
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+	struct pci_dev *misc = NULL;
 
-	if (i == 0)
+	if (amd_nb_num())
 		return 0;
 
-	nb = kzalloc(i * sizeof(struct amd_northbridge), GFP_KERNEL);
-	if (!nb)
-		return -ENOMEM;
+	INIT_LIST_HEAD(&nbi->nb_list);
 
-	amd_northbridges.nb = nb;
-	amd_northbridges.num = i;
+	do {
+		misc = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, misc);
+		if (!misc)
+			break;
 
-	link = misc = NULL;
-	for (i = 0; i != amd_nb_num(); i++) {
-		node_to_amd_nb(i)->misc = misc =
-			next_northbridge(misc, amd_nb_misc_ids);
-		node_to_amd_nb(i)->link = link =
-			next_northbridge(link, amd_nb_link_ids);
-        }
+		if (pci_match_id(amd_nb_misc_ids, misc)) {
+			if (_alloc_nb_desc(misc) < 0)
+				return -ENOMEM;
+		}
+	} while (misc);
 
 	/* some CPU families (e.g. family 0x11) do not support GART */
-	if (boot_cpu_data.x86 == 0xf || boot_cpu_data.x86 == 0x10 ||
-	    boot_cpu_data.x86 == 0x15)
-		amd_northbridges.flags |= AMD_NB_GART;
+	if (c->x86 == 0xf || c->x86 == 0x10 || c->x86 == 0x15)
+		nbi->flags |= AMD_NB_GART;
 
 	/*
 	 * Some CPU families support L3 Cache Index Disable. There are some
 	 * limitations because of E382 and E388 on family 0x10.
 	 */
-	if (boot_cpu_data.x86 == 0x10 &&
-	    boot_cpu_data.x86_model >= 0x8 &&
-	    (boot_cpu_data.x86_model > 0x9 ||
-	     boot_cpu_data.x86_mask >= 0x1))
-		amd_northbridges.flags |= AMD_NB_L3_INDEX_DISABLE;
+	if (c->x86 == 0x10 && c->x86_model >= 0x8 &&
+	    (c->x86_model > 0x9 || c->x86_mask >= 0x1))
+		nbi->flags |= AMD_NB_L3_INDEX_DISABLE;
 
-	if (boot_cpu_data.x86 == 0x15)
-		amd_northbridges.flags |= AMD_NB_L3_INDEX_DISABLE;
+	if (c->x86 == 0x15)
+		nbi->flags |= AMD_NB_L3_INDEX_DISABLE;
 
 	/* L3 cache partitioning is supported on family 0x15 */
-	if (boot_cpu_data.x86 == 0x15)
-		amd_northbridges.flags |= AMD_NB_L3_PARTITIONING;
+	if (c->x86 == 0x15)
+		nbi->flags |= AMD_NB_L3_PARTITIONING;
 
 	return 0;
 }
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 5a297a26211d..8a20f169fd6c 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2549,7 +2549,7 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 	struct mem_ctl_info *mci = NULL;
 	struct edac_mc_layer layers[2];
 	int err = 0, ret;
-	u8 nid = get_node_id(F2);
+	u8 nid = amd_get_node_id(F2);
 
 	ret = -ENOMEM;
 	pvt = kzalloc(sizeof(struct amd64_pvt), GFP_KERNEL);
@@ -2640,7 +2640,7 @@ err_ret:
 static int __devinit amd64_probe_one_instance(struct pci_dev *pdev,
 					     const struct pci_device_id *mc_type)
 {
-	u8 nid = get_node_id(pdev);
+	u8 nid = amd_get_node_id(pdev);
 	struct pci_dev *F3 = node_to_amd_nb(nid)->misc;
 	struct ecc_settings *s;
 	int ret = 0;
@@ -2690,7 +2690,7 @@ static void __devexit amd64_remove_one_instance(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 	struct amd64_pvt *pvt;
-	u8 nid = get_node_id(pdev);
+	u8 nid = amd_get_node_id(pdev);
 	struct pci_dev *F3 = node_to_amd_nb(nid)->misc;
 	struct ecc_settings *s = ecc_stngs[nid];
 
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 8d4804732bac..90cae61f9903 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -290,12 +290,6 @@
 /* MSRs */
 #define MSR_MCGCTL_NBE			BIT(4)
 
-/* AMD sets the first MC device at device ID 0x18. */
-static inline u8 get_node_id(struct pci_dev *pdev)
-{
-	return PCI_SLOT(pdev->devfn) - 0x18;
-}
-
 enum amd_families {
 	K8_CPUS = 0,
 	F10_CPUS,
-- 
1.8.0.rc0.18.gf84667d


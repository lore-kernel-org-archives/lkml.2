Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab2JCNYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 09:24:43 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36018 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab2JCNYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 09:24:42 -0400
From: Daniel J Blueman <daniel@numascale-asia.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel@numascale-asia.com>
Subject: [PATCH v2] Fix AMD Northbridge-ID contiguity assumptions
Date: Wed,  3 Oct 2012 21:21:14 +0800
Message-Id: <1349270474-28808-1-git-send-email-daniel@numascale-asia.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AMD Northbridge initialisation code and EDAC assume the Northbridge IDs
are contiguous, which no longer holds on federated systems with multiple
HyperTransport fabrics and multiple PCI domains.

Address this assumption by searching the Northbridge ID array, rather than
directly indexing it, using the upper bits for the PCI domain.

v2: Fix Northbridge entry initialisation

Tested on a single-socket system and 3-server federated system.

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
---
 arch/x86/include/asm/amd_nb.h |   23 +++++++++++++++++++++--
 arch/x86/kernel/amd_nb.c      |   16 +++++++++-------
 drivers/edac/amd64_edac.c     |   18 +++++++++---------
 drivers/edac/amd64_edac.h     |    6 ------
 4 files changed, 39 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index b3341e9..0fd2f0c 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -47,6 +47,7 @@ struct threshold_bank {
 };
 
 struct amd_northbridge {
+	u32 node;
 	struct pci_dev *misc;
 	struct pci_dev *link;
 	struct amd_l3_cache l3_cache;
@@ -76,15 +77,33 @@ static inline bool amd_nb_has_feature(unsigned feature)
 	return ((amd_northbridges.flags & feature) == feature);
 }
 
-static inline struct amd_northbridge *node_to_amd_nb(int node)
+static inline int node_to_amd_index(u32 node)
 {
-	return (node < amd_northbridges.num) ? &amd_northbridges.nb[node] : NULL;
+	int i;
+
+	for (i = 0; i < amd_northbridges.num; i++)
+		if (amd_northbridges.nb[i].node == node)
+			return i;
+
+	return 0;
+}
+
+static inline struct amd_northbridge *node_to_amd_nb(u32 node)
+{
+	return &amd_northbridges.nb[node_to_amd_index(node)];
+}
+
+/* AMD sets the first MC device at device ID 0x18 */
+static inline u32 get_node_id(struct pci_dev *pdev)
+{
+	return (pci_domain_nr(pdev->bus) << 8) | (PCI_SLOT(pdev->devfn) - 0x18);
 }
 
 #else
 
 #define amd_nb_num(x)		0
 #define amd_nb_has_feature(x)	false
+#define node_to_amd_index(x)	0
 #define node_to_amd_nb(x)	NULL
 
 #endif
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index aadf335..c29ce39 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -75,10 +75,10 @@ int amd_cache_northbridges(void)
 
 	link = misc = NULL;
 	for (i = 0; i != amd_nb_num(); i++) {
-		node_to_amd_nb(i)->misc = misc =
-			next_northbridge(misc, amd_nb_misc_ids);
-		node_to_amd_nb(i)->link = link =
-			next_northbridge(link, amd_nb_link_ids);
+		nb->misc = misc = next_northbridge(misc, amd_nb_misc_ids);
+		nb->node = get_node_id(misc);
+		nb->link = link = next_northbridge(link, amd_nb_link_ids);
+		nb++;
         }
 
 	/* some CPU families (e.g. family 0x11) do not support GART */
@@ -212,6 +212,7 @@ int amd_set_subcaches(int cpu, int mask)
 static int amd_cache_gart(void)
 {
 	u16 i;
+	struct amd_northbridge *nb = amd_northbridges.nb;
 
        if (!amd_nb_has_feature(AMD_NB_GART))
                return 0;
@@ -222,9 +223,10 @@ static int amd_cache_gart(void)
                return -ENOMEM;
        }
 
-       for (i = 0; i != amd_nb_num(); i++)
-               pci_read_config_dword(node_to_amd_nb(i)->misc, 0x9c,
-                                     &flush_words[i]);
+	for (i = 0; i != amd_nb_num(); i++) {
+		pci_read_config_dword(nb->misc, 0x9c, &flush_words[i]);
+		nb++;
+	}
 
        return 0;
 }
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 5a297a2..9c35565 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2549,7 +2549,7 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 	struct mem_ctl_info *mci = NULL;
 	struct edac_mc_layer layers[2];
 	int err = 0, ret;
-	u8 nid = get_node_id(F2);
+	u32 nid = get_node_id(F2);
 
 	ret = -ENOMEM;
 	pvt = kzalloc(sizeof(struct amd64_pvt), GFP_KERNEL);
@@ -2640,7 +2640,7 @@ err_ret:
 static int __devinit amd64_probe_one_instance(struct pci_dev *pdev,
 					     const struct pci_device_id *mc_type)
 {
-	u8 nid = get_node_id(pdev);
+	u32 nid = get_node_id(pdev);
 	struct pci_dev *F3 = node_to_amd_nb(nid)->misc;
 	struct ecc_settings *s;
 	int ret = 0;
@@ -2656,7 +2656,7 @@ static int __devinit amd64_probe_one_instance(struct pci_dev *pdev,
 	if (!s)
 		goto err_out;
 
-	ecc_stngs[nid] = s;
+	ecc_stngs[node_to_amd_index(nid)] = s;
 
 	if (!ecc_enabled(F3, nid)) {
 		ret = -ENODEV;
@@ -2680,7 +2680,7 @@ static int __devinit amd64_probe_one_instance(struct pci_dev *pdev,
 
 err_enable:
 	kfree(s);
-	ecc_stngs[nid] = NULL;
+	ecc_stngs[node_to_amd_index(nid)] = NULL;
 
 err_out:
 	return ret;
@@ -2690,9 +2690,9 @@ static void __devexit amd64_remove_one_instance(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 	struct amd64_pvt *pvt;
-	u8 nid = get_node_id(pdev);
+	u32 nid = get_node_id(pdev);
 	struct pci_dev *F3 = node_to_amd_nb(nid)->misc;
-	struct ecc_settings *s = ecc_stngs[nid];
+	struct ecc_settings *s = ecc_stngs[node_to_amd_index(nid)];
 
 	mci = find_mci_by_dev(&pdev->dev);
 	del_mc_sysfs_attrs(mci);
@@ -2711,12 +2711,12 @@ static void __devexit amd64_remove_one_instance(struct pci_dev *pdev)
 	amd_report_gart_errors(false);
 	amd_unregister_ecc_decoder(amd64_decode_bus_error);
 
-	kfree(ecc_stngs[nid]);
-	ecc_stngs[nid] = NULL;
+	kfree(ecc_stngs[node_to_amd_index(nid)]);
+	ecc_stngs[node_to_amd_index(nid)] = NULL;
 
 	/* Free the EDAC CORE resources */
 	mci->pvt_info = NULL;
-	mcis[nid] = NULL;
+	mcis[node_to_amd_index(nid)] = NULL;
 
 	kfree(pvt);
 	edac_mc_free(mci);
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 8d48047..90cae61 100644
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
1.7.9.5


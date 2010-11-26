Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab0KZTFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 14:05:33 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46324 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab0KZTF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:05:29 -0500
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 09/16] amd64_edac: Allocate driver instances dynamically
Date: Fri, 26 Nov 2010 20:04:16 +0100
Message-Id: <1290798263-13074-10-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1290798263-13074-1-git-send-email-bp@amd64.org>
References: <1290798263-13074-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Remove static allocation in favor of dynamically allocating space for as
many driver instances as northbridges present on the system.

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   45 +++++++++++++++++++++++++++++----------------
 drivers/edac/amd64_edac.h |    2 --
 2 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index d42d6d1..a7922da 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -15,10 +15,9 @@ module_param(ecc_enable_override, int, 0644);
 
 static struct msr __percpu *msrs;
 
-/* Lookup table for all possible MC control instances */
-struct amd64_pvt;
-static struct mem_ctl_info *mci_lookup[EDAC_MAX_NUMNODES];
-static struct amd64_pvt *pvt_lookup[EDAC_MAX_NUMNODES];
+/* Per-node driver instances */
+static struct mem_ctl_info **mcis;
+static struct amd64_pvt **pvts;
 
 /*
  * Address to DRAM bank mapping: see F2x80 for K8 and F2x[1,0]80 for Fam10 and
@@ -1446,7 +1445,7 @@ static int f10_lookup_addr_in_dct(u32 in_addr, u32 nid, u32 cs)
 	int cs_found = -EINVAL;
 	int csrow;
 
-	mci = mci_lookup[nid];
+	mci = mcis[nid];
 	if (!mci)
 		return cs_found;
 
@@ -1995,7 +1994,7 @@ static inline void __amd64_decode_bus_error(struct mem_ctl_info *mci,
 
 void amd64_decode_bus_error(int node_id, struct mce *m, u32 nbcfg)
 {
-	struct mem_ctl_info *mci = mci_lookup[node_id];
+	struct mem_ctl_info *mci = mcis[node_id];
 	struct err_regs regs;
 
 	regs.nbsl  = (u32) m->status;
@@ -2615,7 +2614,7 @@ static int amd64_probe_one_instance(struct pci_dev *F2)
 	 * Save the pointer to the private data for use in 2nd initialization
 	 * stage
 	 */
-	pvt_lookup[pvt->mc_node_id] = pvt;
+	pvts[pvt->mc_node_id] = pvt;
 
 	return 0;
 
@@ -2672,8 +2671,8 @@ static int amd64_init_2nd_stage(struct amd64_pvt *pvt)
 		goto err_add_mc;
 	}
 
-	mci_lookup[node_id] = mci;
-	pvt_lookup[node_id] = NULL;
+	mcis[node_id] = mci;
+	pvts[node_id] = NULL;
 
 	/* register stuff with EDAC MCE */
 	if (report_gart_errors)
@@ -2696,8 +2695,8 @@ err_exit:
 
 	amd64_free_mc_sibling_devices(pvt);
 
-	kfree(pvt_lookup[pvt->mc_node_id]);
-	pvt_lookup[node_id] = NULL;
+	kfree(pvts[pvt->mc_node_id]);
+	pvts[node_id] = NULL;
 
 	return ret;
 }
@@ -2746,7 +2745,7 @@ static void __devexit amd64_remove_one_instance(struct pci_dev *pdev)
 
 	/* Free the EDAC CORE resources */
 	mci->pvt_info = NULL;
-	mci_lookup[pvt->mc_node_id] = NULL;
+	mcis[pvt->mc_node_id] = NULL;
 
 	kfree(pvt);
 	edac_mc_free(mci);
@@ -2793,7 +2792,7 @@ static void amd64_setup_pci_device(void)
 	if (amd64_ctl_pci)
 		return;
 
-	mci = mci_lookup[0];
+	mci = mcis[0];
 	if (mci) {
 
 		pvt = mci->pvt_info;
@@ -2822,6 +2821,12 @@ static int __init amd64_edac_init(void)
 	if (amd_cache_northbridges() < 0)
 		goto err_ret;
 
+	err = -ENOMEM;
+	pvts = kzalloc(amd_nb_num() * sizeof(pvts[0]), GFP_KERNEL);
+	mcis = kzalloc(amd_nb_num() * sizeof(mcis[0]), GFP_KERNEL);
+	if (!(pvts && mcis))
+		goto err_ret;
+
 	msrs = msrs_alloc();
 	if (!msrs)
 		goto err_ret;
@@ -2831,16 +2836,16 @@ static int __init amd64_edac_init(void)
 		goto err_pci;
 
 	/*
-	 * At this point, the array 'pvt_lookup[]' contains pointers to alloc'd
+	 * At this point, the array 'pvts[]' contains pointers to alloc'd
 	 * amd64_pvt structs. These will be used in the 2nd stage init function
 	 * to finish initialization of the MC instances.
 	 */
 	err = -ENODEV;
 	for (nb = 0; nb < amd_nb_num(); nb++) {
-		if (!pvt_lookup[nb])
+		if (!pvts[nb])
 			continue;
 
-		err = amd64_init_2nd_stage(pvt_lookup[nb]);
+		err = amd64_init_2nd_stage(pvts[nb]);
 		if (err)
 			goto err_2nd_stage;
 
@@ -2854,9 +2859,11 @@ static int __init amd64_edac_init(void)
 
 err_2nd_stage:
 	pci_unregister_driver(&amd64_pci_driver);
+
 err_pci:
 	msrs_free(msrs);
 	msrs = NULL;
+
 err_ret:
 	return err;
 }
@@ -2868,6 +2875,12 @@ static void __exit amd64_edac_exit(void)
 
 	pci_unregister_driver(&amd64_pci_driver);
 
+	kfree(mcis);
+	mcis = NULL;
+
+	kfree(pvts);
+	pvts = NULL;
+
 	msrs_free(msrs);
 	msrs = NULL;
 }
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index f15e2b2..5538cc1 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -147,8 +147,6 @@
 #define EDAC_AMD64_VERSION		"v3.3.0"
 #define EDAC_MOD_STR			"amd64_edac"
 
-#define EDAC_MAX_NUMNODES		8
-
 /* Extended Model from CPUID, for CPU Revision numbers */
 #define K8_REV_D			1
 #define K8_REV_E			2
-- 
1.7.3.1.50.g1e633


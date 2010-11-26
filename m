Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab0KZTFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 14:05:43 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46354 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab0KZTFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:05:41 -0500
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 14/16] amd64_edac: Remove two-stage initialization
Date: Fri, 26 Nov 2010 20:04:21 +0100
Message-Id: <1290798263-13074-15-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1290798263-13074-1-git-send-email-bp@amd64.org>
References: <1290798263-13074-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Now that all prerequisites are in place, drop the two-stage driver
instances initialization in favor of the following simple init sequence:

1. Probe PCI device: we only test ECC capabilities here and if none exit
early.

2. If the hw supports ECC and it is/can be enabled, we init the per-node
instance.

Remove "amd64_" prefix from static functions touched, while at it.

There actually should be no visible functional change resulting from
this patch.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |  168 ++++++++++++++++++---------------------------
 1 files changed, 68 insertions(+), 100 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 2fe7725..4dcad97 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -15,9 +15,13 @@ module_param(ecc_enable_override, int, 0644);
 
 static struct msr __percpu *msrs;
 
+/*
+ * count successfully initialized driver instances for setup_pci_device()
+ */
+static atomic_t drv_instances = ATOMIC_INIT(0);
+
 /* Per-node driver instances */
 static struct mem_ctl_info **mcis;
-static struct amd64_pvt **pvts;
 static struct ecc_settings **ecc_stngs;
 
 /*
@@ -1993,8 +1997,7 @@ void amd64_decode_bus_error(int node_id, struct mce *m, u32 nbcfg)
  * Use pvt->F2 which contains the F2 CPU PCI device to get the related
  * F1 (AddrMap) and F3 (Misc) devices. Return negative value on error.
  */
-static int amd64_reserve_mc_sibling_devices(struct amd64_pvt *pvt, u16 f1_id,
-					    u16 f3_id)
+static int reserve_mc_sibling_devs(struct amd64_pvt *pvt, u16 f1_id, u16 f3_id)
 {
 	/* Reserve the ADDRESS MAP Device */
 	pvt->F1 = pci_get_related_function(pvt->F2->vendor, f1_id, pvt->F2);
@@ -2024,7 +2027,7 @@ static int amd64_reserve_mc_sibling_devices(struct amd64_pvt *pvt, u16 f1_id,
 	return 0;
 }
 
-static void amd64_free_mc_sibling_devices(struct amd64_pvt *pvt)
+static void free_mc_sibling_devs(struct amd64_pvt *pvt)
 {
 	pci_dev_put(pvt->F1);
 	pci_dev_put(pvt->F3);
@@ -2034,7 +2037,7 @@ static void amd64_free_mc_sibling_devices(struct amd64_pvt *pvt)
  * Retrieve the hardware registers of the memory controller (this includes the
  * 'Address Map' and 'Misc' device regs)
  */
-static void amd64_read_mc_registers(struct amd64_pvt *pvt)
+static void read_mc_regs(struct amd64_pvt *pvt)
 {
 	u64 msr_val;
 	u32 tmp;
@@ -2185,7 +2188,7 @@ static u32 amd64_csrow_nr_pages(int csrow_nr, struct amd64_pvt *pvt)
  * Initialize the array of csrow attribute instances, based on the values
  * from pci config hardware registers.
  */
-static int amd64_init_csrows(struct mem_ctl_info *mci)
+static int init_csrows(struct mem_ctl_info *mci)
 {
 	struct csrow_info *csrow;
 	struct amd64_pvt *pvt = mci->pvt_info;
@@ -2388,26 +2391,25 @@ static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
 	return ret;
 }
 
-static void amd64_restore_ecc_error_reporting(struct amd64_pvt *pvt)
+static void restore_ecc_error_reporting(struct ecc_settings *s, u8 nid,
+					struct pci_dev *F3)
 {
-	u8 nid = pvt->mc_node_id;
-	struct ecc_settings *s = ecc_stngs[nid];
 	u32 value, mask = K8_NBCTL_CECCEn | K8_NBCTL_UECCEn;
 
 	if (!s->nbctl_valid)
 		return;
 
-	amd64_read_pci_cfg(pvt->F3, K8_NBCTL, &value);
+	amd64_read_pci_cfg(F3, K8_NBCTL, &value);
 	value &= ~mask;
 	value |= s->old_nbctl;
 
-	pci_write_config_dword(pvt->F3, K8_NBCTL, value);
+	pci_write_config_dword(F3, K8_NBCTL, value);
 
 	/* restore previous BIOS DRAM ECC "off" setting we force-enabled */
 	if (!s->flags.nb_ecc_prev) {
-		amd64_read_pci_cfg(pvt->F3, K8_NBCFG, &value);
+		amd64_read_pci_cfg(F3, K8_NBCFG, &value);
 		value &= ~K8_NBCFG_ECC_ENABLE;
-		pci_write_config_dword(pvt->F3, K8_NBCFG, value);
+		pci_write_config_dword(F3, K8_NBCFG, value);
 	}
 
 	/* restore the NB Enable MCGCTL bit */
@@ -2457,7 +2459,7 @@ struct mcidev_sysfs_attribute sysfs_attrs[ARRAY_SIZE(amd64_dbg_attrs) +
 
 struct mcidev_sysfs_attribute terminator = { .attr = { .name = NULL } };
 
-static void amd64_set_mc_sysfs_attributes(struct mem_ctl_info *mci)
+static void set_mc_sysfs_attrs(struct mem_ctl_info *mci)
 {
 	unsigned int i = 0, j = 0;
 
@@ -2472,7 +2474,7 @@ static void amd64_set_mc_sysfs_attributes(struct mem_ctl_info *mci)
 	mci->mc_driver_sysfs_attributes = sysfs_attrs;
 }
 
-static void amd64_setup_mci_misc_attributes(struct mem_ctl_info *mci)
+static void setup_mci_misc_attrs(struct mem_ctl_info *mci)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
 
@@ -2538,14 +2540,16 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 {
 	struct amd64_pvt *pvt = NULL;
 	struct amd64_family_type *fam_type = NULL;
+	struct mem_ctl_info *mci = NULL;
 	int err = 0, ret;
+	u8 nid = get_node_id(F2);
 
 	ret = -ENOMEM;
 	pvt = kzalloc(sizeof(struct amd64_pvt), GFP_KERNEL);
 	if (!pvt)
-		goto err_exit;
+		goto err_ret;
 
-	pvt->mc_node_id	 = get_node_id(F2);
+	pvt->mc_node_id	= nid;
 	pvt->F2 = F2;
 
 	ret = -EINVAL;
@@ -2554,61 +2558,36 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 		goto err_free;
 
 	ret = -ENODEV;
-	err = amd64_reserve_mc_sibling_devices(pvt, fam_type->f1_id,
-						fam_type->f3_id);
+	err = reserve_mc_sibling_devs(pvt, fam_type->f1_id, fam_type->f3_id);
 	if (err)
 		goto err_free;
 
-	/*
-	 * Save the pointer to the private data for use in 2nd initialization
-	 * stage
-	 */
-	pvts[pvt->mc_node_id] = pvt;
-
-	return 0;
-
-err_free:
-	kfree(pvt);
-
-err_exit:
-	return ret;
-}
-
-/*
- * This is the finishing stage of the init code. Needs to be performed after all
- * MCs' hardware have been prepped for accessing extended config space.
- */
-static int amd64_init_2nd_stage(struct amd64_pvt *pvt)
-{
-	int node_id = pvt->mc_node_id;
-	struct mem_ctl_info *mci;
-	int ret = -ENODEV;
-
-	amd64_read_mc_registers(pvt);
+	read_mc_regs(pvt);
 
 	/*
 	 * We need to determine how many memory channels there are. Then use
 	 * that information for calculating the size of the dynamic instance
-	 * tables in the 'mci' structure
+	 * tables in the 'mci' structure.
 	 */
+	ret = -EINVAL;
 	pvt->channel_count = pvt->ops->early_channel_count(pvt);
 	if (pvt->channel_count < 0)
-		goto err_exit;
+		goto err_siblings;
 
 	ret = -ENOMEM;
-	mci = edac_mc_alloc(0, pvt->cs_count, pvt->channel_count, node_id);
+	mci = edac_mc_alloc(0, pvt->cs_count, pvt->channel_count, nid);
 	if (!mci)
-		goto err_exit;
+		goto err_siblings;
 
 	mci->pvt_info = pvt;
-
 	mci->dev = &pvt->F2->dev;
-	amd64_setup_mci_misc_attributes(mci);
 
-	if (amd64_init_csrows(mci))
+	setup_mci_misc_attrs(mci);
+
+	if (init_csrows(mci))
 		mci->edac_cap = EDAC_FLAG_NONE;
 
-	amd64_set_mc_sysfs_attributes(mci);
+	set_mc_sysfs_attrs(mci);
 
 	ret = -ENODEV;
 	if (edac_mc_add_mc(mci)) {
@@ -2616,34 +2595,31 @@ static int amd64_init_2nd_stage(struct amd64_pvt *pvt)
 		goto err_add_mc;
 	}
 
-	mcis[node_id] = mci;
-	pvts[node_id] = NULL;
-
 	/* register stuff with EDAC MCE */
 	if (report_gart_errors)
 		amd_report_gart_errors(true);
 
 	amd_register_ecc_decoder(amd64_decode_bus_error);
 
+	mcis[nid] = mci;
+
+	atomic_inc(&drv_instances);
+
 	return 0;
 
 err_add_mc:
 	edac_mc_free(mci);
 
-err_exit:
-	debugf0("failure to init 2nd stage: ret=%d\n", ret);
+err_siblings:
+	free_mc_sibling_devs(pvt);
 
-	amd64_restore_ecc_error_reporting(pvt);
-
-	amd64_free_mc_sibling_devices(pvt);
-
-	kfree(pvts[pvt->mc_node_id]);
-	pvts[node_id] = NULL;
+err_free:
+	kfree(pvt);
 
+err_ret:
 	return ret;
 }
 
-
 static int __devinit amd64_probe_one_instance(struct pci_dev *pdev,
 					     const struct pci_device_id *mc_type)
 {
@@ -2678,8 +2654,10 @@ static int __devinit amd64_probe_one_instance(struct pci_dev *pdev,
 	}
 
 	ret = amd64_init_one_instance(pdev);
-	if (ret < 0)
+	if (ret < 0) {
 		amd64_err("Error probing instance: %d\n", nid);
+		restore_ecc_error_reporting(s, nid, F3);
+	}
 
 	return ret;
 
@@ -2695,6 +2673,9 @@ static void __devexit amd64_remove_one_instance(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 	struct amd64_pvt *pvt;
+	u8 nid = get_node_id(pdev);
+	struct pci_dev *F3 = node_to_amd_nb(nid)->misc;
+	struct ecc_settings *s = ecc_stngs[nid];
 
 	/* Remove from EDAC CORE tracking list */
 	mci = edac_mc_del_mc(&pdev->dev);
@@ -2703,20 +2684,20 @@ static void __devexit amd64_remove_one_instance(struct pci_dev *pdev)
 
 	pvt = mci->pvt_info;
 
-	amd64_restore_ecc_error_reporting(pvt);
+	restore_ecc_error_reporting(s, nid, F3);
 
-	amd64_free_mc_sibling_devices(pvt);
+	free_mc_sibling_devs(pvt);
 
 	/* unregister from EDAC MCE */
 	amd_report_gart_errors(false);
 	amd_unregister_ecc_decoder(amd64_decode_bus_error);
 
-	kfree(ecc_stngs[pvt->mc_node_id]);
-	ecc_stngs[pvt->mc_node_id] = NULL;
+	kfree(ecc_stngs[nid]);
+	ecc_stngs[nid] = NULL;
 
 	/* Free the EDAC CORE resources */
 	mci->pvt_info = NULL;
-	mcis[pvt->mc_node_id] = NULL;
+	mcis[nid] = NULL;
 
 	kfree(pvt);
 	edac_mc_free(mci);
@@ -2755,7 +2736,7 @@ static struct pci_driver amd64_pci_driver = {
 	.id_table	= amd64_pci_table,
 };
 
-static void amd64_setup_pci_device(void)
+static void setup_pci_device(void)
 {
 	struct mem_ctl_info *mci;
 	struct amd64_pvt *pvt;
@@ -2782,8 +2763,7 @@ static void amd64_setup_pci_device(void)
 
 static int __init amd64_edac_init(void)
 {
-	int nb, err = -ENODEV;
-	bool load_ok = false;
+	int err = -ENODEV;
 
 	edac_printk(KERN_INFO, EDAC_MOD_STR, EDAC_AMD64_VERSION "\n");
 
@@ -2793,49 +2773,40 @@ static int __init amd64_edac_init(void)
 		goto err_ret;
 
 	err = -ENOMEM;
-	pvts	  = kzalloc(amd_nb_num() * sizeof(pvts[0]), GFP_KERNEL);
 	mcis	  = kzalloc(amd_nb_num() * sizeof(mcis[0]), GFP_KERNEL);
 	ecc_stngs = kzalloc(amd_nb_num() * sizeof(ecc_stngs[0]), GFP_KERNEL);
-	if (!(pvts && mcis && ecc_stngs))
+	if (!(mcis && ecc_stngs))
 		goto err_ret;
 
 	msrs = msrs_alloc();
 	if (!msrs)
-		goto err_ret;
+		goto err_free;
 
 	err = pci_register_driver(&amd64_pci_driver);
 	if (err)
 		goto err_pci;
 
-	/*
-	 * At this point, the array 'pvts[]' contains pointers to alloc'd
-	 * amd64_pvt structs. These will be used in the 2nd stage init function
-	 * to finish initialization of the MC instances.
-	 */
 	err = -ENODEV;
-	for (nb = 0; nb < amd_nb_num(); nb++) {
-		if (!pvts[nb])
-			continue;
-
-		err = amd64_init_2nd_stage(pvts[nb]);
-		if (err)
-			goto err_2nd_stage;
-
-		load_ok = true;
-	}
+	if (!atomic_read(&drv_instances))
+		goto err_no_instances;
 
-	if (load_ok) {
-		amd64_setup_pci_device();
-		return 0;
-	}
+	setup_pci_device();
+	return 0;
 
-err_2nd_stage:
+err_no_instances:
 	pci_unregister_driver(&amd64_pci_driver);
 
 err_pci:
 	msrs_free(msrs);
 	msrs = NULL;
 
+err_free:
+	kfree(mcis);
+	mcis = NULL;
+
+	kfree(ecc_stngs);
+	ecc_stngs = NULL;
+
 err_ret:
 	return err;
 }
@@ -2853,9 +2824,6 @@ static void __exit amd64_edac_exit(void)
 	kfree(mcis);
 	mcis = NULL;
 
-	kfree(pvts);
-	pvts = NULL;
-
 	msrs_free(msrs);
 	msrs = NULL;
 }
-- 
1.7.3.1.50.g1e633


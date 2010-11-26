Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab0KZTGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 14:06:17 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46357 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab0KZTFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:05:43 -0500
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 13/16] amd64_edac: Check ECC capabilities initially
Date: Fri, 26 Nov 2010 20:04:20 +0100
Message-Id: <1290798263-13074-14-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1290798263-13074-1-git-send-email-bp@amd64.org>
References: <1290798263-13074-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Rework the code to check the hardware ECC capabilities at PCI probing
time. We do all further initialization only if we actually can/have ECC
enabled.

While at it:
0. Fix function naming.
1. Simplify/clarify debug output.
2. Remove amd64_ prefix from the static functions
3. Reorganize code.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |  141 ++++++++++++++++++++++++---------------------
 1 files changed, 75 insertions(+), 66 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 2388bb9..2fe7725 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2188,18 +2188,19 @@ static u32 amd64_csrow_nr_pages(int csrow_nr, struct amd64_pvt *pvt)
 static int amd64_init_csrows(struct mem_ctl_info *mci)
 {
 	struct csrow_info *csrow;
-	struct amd64_pvt *pvt;
+	struct amd64_pvt *pvt = mci->pvt_info;
 	u64 input_addr_min, input_addr_max, sys_addr;
+	u32 val;
 	int i, empty = 1;
 
-	pvt = mci->pvt_info;
+	amd64_read_pci_cfg(pvt->F3, K8_NBCFG, &val);
 
-	amd64_read_pci_cfg(pvt->F3, K8_NBCFG, &pvt->nbcfg);
+	pvt->nbcfg = val;
+	pvt->ctl_error_info.nbcfg = val;
 
-	debugf0("NBCFG= 0x%x  CHIPKILL= %s DRAM ECC= %s\n", pvt->nbcfg,
-		(pvt->nbcfg & K8_NBCFG_CHIPKILL) ? "Enabled" : "Disabled",
-		(pvt->nbcfg & K8_NBCFG_ECC_ENABLE) ? "Enabled" : "Disabled"
-		);
+	debugf0("node %d, NBCFG=0x%08x[ChipKillEccCap: %d|DramEccEn: %d]\n",
+		pvt->mc_node_id, val,
+		!!(val & K8_NBCFG_CHIPKILL), !!(val & K8_NBCFG_ECC_ENABLE));
 
 	for (i = 0; i < pvt->cs_count; i++) {
 		csrow = &mci->csrows[i];
@@ -2294,7 +2295,7 @@ out:
 	return ret;
 }
 
-static int amd64_toggle_ecc_err_reporting(struct ecc_settings *s, u8 nid, bool on)
+static int toggle_ecc_err_reporting(struct ecc_settings *s, u8 nid, bool on)
 {
 	cpumask_var_t cmask;
 	int cpu;
@@ -2332,30 +2333,31 @@ static int amd64_toggle_ecc_err_reporting(struct ecc_settings *s, u8 nid, bool o
 	return 0;
 }
 
-static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
+static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
+				       struct pci_dev *F3)
 {
-	struct amd64_pvt *pvt = mci->pvt_info;
-	u8 nid = pvt->mc_node_id;
-	struct ecc_settings *s = ecc_stngs[nid];
+	bool ret = true;
 	u32 value, mask = K8_NBCTL_CECCEn | K8_NBCTL_UECCEn;
 
-	amd64_read_pci_cfg(pvt->F3, K8_NBCTL, &value);
+	if (toggle_ecc_err_reporting(s, nid, ON)) {
+		amd64_warn("Error enabling ECC reporting over MCGCTL!\n");
+		return false;
+	}
+
+	amd64_read_pci_cfg(F3, K8_NBCTL, &value);
 
 	/* turn on UECCEn and CECCEn bits */
 	s->old_nbctl   = value & mask;
 	s->nbctl_valid = true;
 
 	value |= mask;
-	pci_write_config_dword(pvt->F3, K8_NBCTL, value);
+	pci_write_config_dword(F3, K8_NBCTL, value);
 
-	if (amd64_toggle_ecc_err_reporting(s, nid, ON))
-		amd64_warn("Error enabling ECC reporting over MCGCTL!\n");
+	amd64_read_pci_cfg(F3, K8_NBCFG, &value);
 
-	amd64_read_pci_cfg(pvt->F3, K8_NBCFG, &value);
-
-	debugf0("NBCFG(1)= 0x%x  CHIPKILL= %s ECC_ENABLE= %s\n", value,
-		(value & K8_NBCFG_CHIPKILL) ? "Enabled" : "Disabled",
-		(value & K8_NBCFG_ECC_ENABLE) ? "Enabled" : "Disabled");
+	debugf0("1: node %d, NBCFG=0x%08x[ChipKillEccCap: %d|DramEccEn: %d]\n",
+		nid, value,
+		!!(value & K8_NBCFG_CHIPKILL), !!(value & K8_NBCFG_ECC_ENABLE));
 
 	if (!(value & K8_NBCFG_ECC_ENABLE)) {
 		amd64_warn("DRAM ECC disabled on this node, enabling...\n");
@@ -2364,13 +2366,14 @@ static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 
 		/* Attempt to turn on DRAM ECC Enable */
 		value |= K8_NBCFG_ECC_ENABLE;
-		pci_write_config_dword(pvt->F3, K8_NBCFG, value);
+		pci_write_config_dword(F3, K8_NBCFG, value);
 
-		amd64_read_pci_cfg(pvt->F3, K8_NBCFG, &value);
+		amd64_read_pci_cfg(F3, K8_NBCFG, &value);
 
 		if (!(value & K8_NBCFG_ECC_ENABLE)) {
 			amd64_warn("Hardware rejected DRAM ECC enable,"
 				   "check memory DIMM configuration.\n");
+			ret = false;
 		} else {
 			amd64_info("Hardware accepted DRAM ECC Enable\n");
 		}
@@ -2378,11 +2381,11 @@ static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 		s->flags.nb_ecc_prev = 1;
 	}
 
-	debugf0("NBCFG(2)= 0x%x  CHIPKILL= %s ECC_ENABLE= %s\n", value,
-		(value & K8_NBCFG_CHIPKILL) ? "Enabled" : "Disabled",
-		(value & K8_NBCFG_ECC_ENABLE) ? "Enabled" : "Disabled");
+	debugf0("2: node %d, NBCFG=0x%08x[ChipKillEccCap: %d|DramEccEn: %d]\n",
+		nid, value,
+		!!(value & K8_NBCFG_CHIPKILL), !!(value & K8_NBCFG_ECC_ENABLE));
 
-	pvt->ctl_error_info.nbcfg = value;
+	return ret;
 }
 
 static void amd64_restore_ecc_error_reporting(struct amd64_pvt *pvt)
@@ -2408,15 +2411,15 @@ static void amd64_restore_ecc_error_reporting(struct amd64_pvt *pvt)
 	}
 
 	/* restore the NB Enable MCGCTL bit */
-	if (amd64_toggle_ecc_err_reporting(s, nid, OFF))
+	if (toggle_ecc_err_reporting(s, nid, OFF))
 		amd64_warn("Error restoring NB MCGCTL settings!\n");
 }
 
 /*
- * EDAC requires that the BIOS have ECC enabled before taking over the
- * processing of ECC errors. This is because the BIOS can properly initialize
- * the memory system completely. A command line option allows to force-enable
- * hardware ECC later in amd64_enable_ecc_error_reporting().
+ * EDAC requires that the BIOS have ECC enabled before
+ * taking over the processing of ECC errors. A command line
+ * option allows to force-enable hardware ECC later in
+ * enable_ecc_error_reporting().
  */
 static const char *ecc_msg =
 	"ECC disabled in the BIOS or no ECC capability, module will not load.\n"
@@ -2424,33 +2427,28 @@ static const char *ecc_msg =
 	"'ecc_enable_override'.\n"
 	" (Note that use of the override may cause unknown side effects.)\n";
 
-static int amd64_check_ecc_enabled(struct amd64_pvt *pvt)
+static bool ecc_enabled(struct pci_dev *F3, u8 nid)
 {
 	u32 value;
-	u8 ecc_enabled = 0;
+	u8 ecc_en = 0;
 	bool nb_mce_en = false;
 
-	amd64_read_pci_cfg(pvt->F3, K8_NBCFG, &value);
+	amd64_read_pci_cfg(F3, K8_NBCFG, &value);
 
-	ecc_enabled = !!(value & K8_NBCFG_ECC_ENABLE);
-	amd64_info("DRAM ECC %s.\n", (ecc_enabled ? "enabled" : "disabled"));
+	ecc_en = !!(value & K8_NBCFG_ECC_ENABLE);
+	amd64_info("DRAM ECC %s.\n", (ecc_en ? "enabled" : "disabled"));
 
-	nb_mce_en = amd64_nb_mce_bank_enabled_on_node(pvt->mc_node_id);
+	nb_mce_en = amd64_nb_mce_bank_enabled_on_node(nid);
 	if (!nb_mce_en)
-		amd64_notice("NB MCE bank disabled, "
-			     "set MSR 0x%08x[4] on node %d to enable.\n",
-			     MSR_IA32_MCG_CTL, pvt->mc_node_id);
-
-	if (!ecc_enabled || !nb_mce_en) {
-		if (!ecc_enable_override) {
-			amd64_notice("%s", ecc_msg);
-			return -ENODEV;
-		} else {
-			amd64_warn("Forcing ECC on!\n");
-		}
-	}
+		amd64_notice("NB MCE bank disabled, set MSR "
+			     "0x%08x[4] on node %d to enable.\n",
+			     MSR_IA32_MCG_CTL, nid);
 
-	return 0;
+	if (!ecc_en || !nb_mce_en) {
+		amd64_notice("%s", ecc_msg);
+		return false;
+	}
+	return true;
 }
 
 struct mcidev_sysfs_attribute sysfs_attrs[ARRAY_SIZE(amd64_dbg_attrs) +
@@ -2536,7 +2534,7 @@ static struct amd64_family_type *amd64_per_family_init(struct amd64_pvt *pvt)
 	return fam_type;
 }
 
-static int amd64_probe_one_instance(struct pci_dev *F2)
+static int amd64_init_one_instance(struct pci_dev *F2)
 {
 	struct amd64_pvt *pvt = NULL;
 	struct amd64_family_type *fam_type = NULL;
@@ -2561,11 +2559,6 @@ static int amd64_probe_one_instance(struct pci_dev *F2)
 	if (err)
 		goto err_free;
 
-	ret = -EINVAL;
-	err = amd64_check_ecc_enabled(pvt);
-	if (err)
-		goto err_put;
-
 	/*
 	 * Save the pointer to the private data for use in 2nd initialization
 	 * stage
@@ -2574,9 +2567,6 @@ static int amd64_probe_one_instance(struct pci_dev *F2)
 
 	return 0;
 
-err_put:
-	amd64_free_mc_sibling_devices(pvt);
-
 err_free:
 	kfree(pvt);
 
@@ -2618,7 +2608,6 @@ static int amd64_init_2nd_stage(struct amd64_pvt *pvt)
 	if (amd64_init_csrows(mci))
 		mci->edac_cap = EDAC_FLAG_NONE;
 
-	amd64_enable_ecc_error_reporting(mci);
 	amd64_set_mc_sysfs_attributes(mci);
 
 	ret = -ENODEV;
@@ -2655,12 +2644,13 @@ err_exit:
 }
 
 
-static int __devinit amd64_init_one_instance(struct pci_dev *pdev,
+static int __devinit amd64_probe_one_instance(struct pci_dev *pdev,
 					     const struct pci_device_id *mc_type)
 {
-	int ret = 0;
 	u8 nid = get_node_id(pdev);
+	struct pci_dev *F3 = node_to_amd_nb(nid)->misc;
 	struct ecc_settings *s;
+	int ret = 0;
 
 	ret = pci_enable_device(pdev);
 	if (ret < 0) {
@@ -2671,15 +2661,34 @@ static int __devinit amd64_init_one_instance(struct pci_dev *pdev,
 	ret = -ENOMEM;
 	s = kzalloc(sizeof(struct ecc_settings), GFP_KERNEL);
 	if (!s)
-		return ret;
+		goto err_out;
 
 	ecc_stngs[nid] = s;
 
-	ret = amd64_probe_one_instance(pdev);
+	if (!ecc_enabled(F3, nid)) {
+		ret = -ENODEV;
+
+		if (!ecc_enable_override)
+			goto err_enable;
+
+		amd64_warn("Forcing ECC on!\n");
+
+		if (!enable_ecc_error_reporting(s, nid, F3))
+			goto err_enable;
+	}
+
+	ret = amd64_init_one_instance(pdev);
 	if (ret < 0)
 		amd64_err("Error probing instance: %d\n", nid);
 
 	return ret;
+
+err_enable:
+	kfree(s);
+	ecc_stngs[nid] = NULL;
+
+err_out:
+	return ret;
 }
 
 static void __devexit amd64_remove_one_instance(struct pci_dev *pdev)
@@ -2741,7 +2750,7 @@ MODULE_DEVICE_TABLE(pci, amd64_pci_table);
 
 static struct pci_driver amd64_pci_driver = {
 	.name		= EDAC_MOD_STR,
-	.probe		= amd64_init_one_instance,
+	.probe		= amd64_probe_one_instance,
 	.remove		= __devexit_p(amd64_remove_one_instance),
 	.id_table	= amd64_pci_table,
 };
-- 
1.7.3.1.50.g1e633


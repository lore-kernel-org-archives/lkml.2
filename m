Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab0KZTFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 14:05:32 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46329 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab0KZTFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:05:30 -0500
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 08/16] amd64_edac: Rework printk macros
Date: Fri, 26 Nov 2010 20:04:15 +0100
Message-Id: <1290798263-13074-9-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1290798263-13074-1-git-send-email-bp@amd64.org>
References: <1290798263-13074-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add a macro per printk level, shorten up error messages. Add relevant
information to KERN_INFO level. No functional change.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c     |  145 ++++++++++++++++-------------------------
 drivers/edac/amd64_edac.h     |   29 ++++++--
 drivers/edac/amd64_edac_inj.c |   13 +---
 drivers/edac/edac_core.h      |    3 +-
 drivers/edac/edac_mc.c        |    4 +-
 5 files changed, 87 insertions(+), 107 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index aa57853..d42d6d1 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -62,7 +62,7 @@ static int ddr3_dbam[] = { [0]		= -1,
 			   [5 ... 6]	= 1024,
 			   [7 ... 8]	= 2048,
 			   [9 ... 10]	= 4096,
-			   [11]	= 8192,
+			   [11]		= 8192,
 };
 
 /*
@@ -148,11 +148,10 @@ static int __amd64_set_scrub_rate(struct pci_dev *ctl, u32 new_bw, u32 min_rate)
 
 	scrubval = scrubrates[i].scrubval;
 	if (scrubval)
-		edac_printk(KERN_DEBUG, EDAC_MC,
-			    "Setting scrub rate bandwidth: %u\n",
-			    scrubrates[i].bandwidth);
+		amd64_info("Setting scrub rate bandwidth: %u\n",
+			   scrubrates[i].bandwidth);
 	else
-		edac_printk(KERN_DEBUG, EDAC_MC, "Turning scrubbing off.\n");
+		amd64_info("Turning scrubbing off.\n");
 
 	pci_write_bits32(ctl, K8_SCRCTRL, scrubval, 0x001F);
 
@@ -176,8 +175,7 @@ static int amd64_get_scrub_rate(struct mem_ctl_info *mci, u32 *bw)
 
 	scrubval = scrubval & 0x001F;
 
-	edac_printk(KERN_DEBUG, EDAC_MC,
-		    "pci-read, sdram scrub control value: %d \n", scrubval);
+	amd64_debug("pci-read, sdram scrub control value: %d\n", scrubval);
 
 	for (i = 0; i < ARRAY_SIZE(scrubrates); i++) {
 		if (scrubrates[i].scrubval == scrubval) {
@@ -296,9 +294,7 @@ static struct mem_ctl_info *find_mc_by_sys_addr(struct mem_ctl_info *mci,
 	if (unlikely((intlv_en != 0x01) &&
 		     (intlv_en != 0x03) &&
 		     (intlv_en != 0x07))) {
-		amd64_printk(KERN_WARNING, "junk value of 0x%x extracted from "
-			     "IntlvEn field of DRAM Base Register for node 0: "
-			     "this probably indicates a BIOS bug.\n", intlv_en);
+		amd64_warn("DRAM Base[IntlvEn] junk value: 0x%x, BIOS bug?\n", intlv_en);
 		return NULL;
 	}
 
@@ -314,11 +310,9 @@ static struct mem_ctl_info *find_mc_by_sys_addr(struct mem_ctl_info *mci,
 
 	/* sanity test for sys_addr */
 	if (unlikely(!amd64_base_limit_match(pvt, sys_addr, node_id))) {
-		amd64_printk(KERN_WARNING,
-			     "%s(): sys_addr 0x%llx falls outside base/limit "
-			     "address range for node %d with node interleaving "
-			     "enabled.\n",
-			     __func__, sys_addr, node_id);
+		amd64_warn("%s: sys_addr 0x%llx falls outside base/limit address"
+			   "range for node %d with node interleaving enabled.\n",
+			   __func__, sys_addr, node_id);
 		return NULL;
 	}
 
@@ -770,9 +764,8 @@ static int sys_addr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr)
 	csrow = input_addr_to_csrow(mci, sys_addr_to_input_addr(mci, sys_addr));
 
 	if (csrow == -1)
-		amd64_mc_printk(mci, KERN_ERR,
-			     "Failed to translate InputAddr to csrow for "
-			     "address 0x%lx\n", (unsigned long)sys_addr);
+		amd64_mc_err(mci, "Failed to translate InputAddr to csrow for "
+				  "address 0x%lx\n", (unsigned long)sys_addr);
 	return csrow;
 }
 
@@ -860,8 +853,7 @@ static void amd64_dump_misc_regs(struct amd64_pvt *pvt)
 		return;
 	}
 
-	amd64_printk(KERN_INFO, "using %s syndromes.\n",
-		     ((pvt->syn_type == 8) ? "x8" : "x4"));
+	amd64_info("using %s syndromes.\n", ((pvt->syn_type == 8) ? "x8" : "x4"));
 
 	/* Only if NOT ganged does dclr1 have valid info */
 	if (!dct_ganging_enabled(pvt))
@@ -983,7 +975,7 @@ static void amd64_read_dct_base_mask(struct amd64_pvt *pvt)
 	}
 }
 
-static enum mem_type amd64_determine_memory_type(struct amd64_pvt *pvt)
+static enum mem_type amd64_determine_memory_type(struct amd64_pvt *pvt, int cs)
 {
 	enum mem_type type;
 
@@ -996,7 +988,7 @@ static enum mem_type amd64_determine_memory_type(struct amd64_pvt *pvt)
 		type = (pvt->dclr0 & BIT(18)) ? MEM_DDR : MEM_RDDR;
 	}
 
-	debugf1("  Memory type is: %s\n", edac_mem_types[type]);
+	amd64_info("CS%d: %s\n", cs, edac_mem_types[type]);
 
 	return type;
 }
@@ -1087,9 +1079,8 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
 			 * 2 DIMMs is in error. So we need to ID 'both' of them
 			 * as suspect.
 			 */
-			amd64_mc_printk(mci, KERN_WARNING,
-					"unknown syndrome 0x%04x - possible "
-					"error reporting race\n", syndrome);
+			amd64_mc_warn(mci, "unknown syndrome 0x%04x - possible "
+					   "error reporting race\n", syndrome);
 			edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
 			return;
 		}
@@ -1111,8 +1102,7 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
 	 */
 	src_mci = find_mc_by_sys_addr(mci, sys_addr);
 	if (!src_mci) {
-		amd64_mc_printk(mci, KERN_ERR,
-			     "failed to map error address 0x%lx to a node\n",
+		amd64_mc_err(mci, "failed to map error addr 0x%lx to a node\n",
 			     (unsigned long)sys_addr);
 		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
 		return;
@@ -1194,7 +1184,7 @@ static int f10_early_channel_count(struct amd64_pvt *pvt)
 	if (channels > 2)
 		channels = 2;
 
-	debugf0("MCT channel count: %d\n", channels);
+	amd64_info("MCT channel count: %d\n", channels);
 
 	return channels;
 
@@ -1698,9 +1688,9 @@ static void amd64_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt)
 		if (dcsb[dimm*2 + 1] & K8_DCSB_CS_ENABLE)
 			size1 = pvt->ops->dbam_to_cs(pvt, DBAM_DIMM(dimm, dbam));
 
-		edac_printk(KERN_DEBUG, EDAC_MC, " %d: %5dMB %d: %5dMB\n",
-			    dimm * 2,     size0 << factor,
-			    dimm * 2 + 1, size1 << factor);
+		amd64_info(EDAC_MC ": %d: %5dMB %d: %5dMB\n",
+				dimm * 2,     size0 << factor,
+				dimm * 2 + 1, size1 << factor);
 	}
 }
 
@@ -1906,8 +1896,7 @@ static int get_channel_from_ecc_syndrome(struct mem_ctl_info *mci, u16 syndrome)
 					  ARRAY_SIZE(x4_vectors),
 					  pvt->syn_type);
 	else {
-		amd64_printk(KERN_WARNING, "%s: Illegal syndrome type: %u\n",
-					   __func__, pvt->syn_type);
+		amd64_warn("Illegal syndrome type: %u\n", pvt->syn_type);
 		return err_sym;
 	}
 
@@ -1925,17 +1914,15 @@ static void amd64_handle_ce(struct mem_ctl_info *mci,
 	u64 sys_addr;
 
 	/* Ensure that the Error Address is VALID */
-	if ((info->nbsh & K8_NBSH_VALID_ERROR_ADDR) == 0) {
-		amd64_mc_printk(mci, KERN_ERR,
-			"HW has no ERROR_ADDRESS available\n");
+	if (!(info->nbsh & K8_NBSH_VALID_ERROR_ADDR)) {
+		amd64_mc_err(mci, "HW has no ERROR_ADDRESS available\n");
 		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
 		return;
 	}
 
 	sys_addr = pvt->ops->get_error_address(mci, info);
 
-	amd64_mc_printk(mci, KERN_ERR,
-		"CE ERROR_ADDRESS= 0x%llx\n", sys_addr);
+	amd64_mc_err(mci, "CE ERROR_ADDRESS= 0x%llx\n", sys_addr);
 
 	pvt->ops->map_sysaddr_to_csrow(mci, info, sys_addr);
 }
@@ -1952,9 +1939,8 @@ static void amd64_handle_ue(struct mem_ctl_info *mci,
 
 	log_mci = mci;
 
-	if ((info->nbsh & K8_NBSH_VALID_ERROR_ADDR) == 0) {
-		amd64_mc_printk(mci, KERN_CRIT,
-			"HW has no ERROR_ADDRESS available\n");
+	if (!(info->nbsh & K8_NBSH_VALID_ERROR_ADDR)) {
+		amd64_mc_err(mci, "HW has no ERROR_ADDRESS available\n");
 		edac_mc_handle_ue_no_info(log_mci, EDAC_MOD_STR);
 		return;
 	}
@@ -1967,9 +1953,8 @@ static void amd64_handle_ue(struct mem_ctl_info *mci,
 	 */
 	src_mci = find_mc_by_sys_addr(mci, sys_addr);
 	if (!src_mci) {
-		amd64_mc_printk(mci, KERN_CRIT,
-			"ERROR ADDRESS (0x%lx) value NOT mapped to a MC\n",
-			(unsigned long)sys_addr);
+		amd64_mc_err(mci, "ERROR ADDRESS (0x%lx) NOT mapped to a MC\n",
+				  (unsigned long)sys_addr);
 		edac_mc_handle_ue_no_info(log_mci, EDAC_MOD_STR);
 		return;
 	}
@@ -1978,9 +1963,8 @@ static void amd64_handle_ue(struct mem_ctl_info *mci,
 
 	csrow = sys_addr_to_csrow(log_mci, sys_addr);
 	if (csrow < 0) {
-		amd64_mc_printk(mci, KERN_CRIT,
-			"ERROR_ADDRESS (0x%lx) value NOT mapped to 'csrow'\n",
-			(unsigned long)sys_addr);
+		amd64_mc_err(mci, "ERROR_ADDRESS (0x%lx) NOT mapped to CS\n",
+				  (unsigned long)sys_addr);
 		edac_mc_handle_ue_no_info(log_mci, EDAC_MOD_STR);
 	} else {
 		error_address_to_page_and_offset(sys_addr, &page, &offset);
@@ -2044,9 +2028,9 @@ static int amd64_reserve_mc_sibling_devices(struct amd64_pvt *pvt, u16 f1_id,
 	/* Reserve the ADDRESS MAP Device */
 	pvt->F1 = pci_get_related_function(pvt->F2->vendor, f1_id, pvt->F2);
 	if (!pvt->F1) {
-		amd64_printk(KERN_ERR, "error address map device not found: "
-				       "vendor %x device 0x%x (broken BIOS?)\n",
-				       PCI_VENDOR_ID_AMD, f1_id);
+		amd64_err("error address map device not found: "
+			  "vendor %x device 0x%x (broken BIOS?)\n",
+			  PCI_VENDOR_ID_AMD, f1_id);
 		return -ENODEV;
 	}
 
@@ -2056,9 +2040,9 @@ static int amd64_reserve_mc_sibling_devices(struct amd64_pvt *pvt, u16 f1_id,
 		pci_dev_put(pvt->F1);
 		pvt->F1 = NULL;
 
-		amd64_printk(KERN_ERR, "error F3 device not found: "
-				       "vendor %x device 0x%x (broken BIOS?)\n",
-				       PCI_VENDOR_ID_AMD, f3_id);
+		amd64_err("error F3 device not found: "
+			  "vendor %x device 0x%x (broken BIOS?)\n",
+			  PCI_VENDOR_ID_AMD, f3_id);
 
 		return -ENODEV;
 	}
@@ -2268,7 +2252,7 @@ static int amd64_init_csrows(struct mem_ctl_info *mci)
 		csrow->page_mask = ~mask_from_dct_mask(pvt, i);
 		/* 8 bytes of resolution */
 
-		csrow->mtype = amd64_determine_memory_type(pvt);
+		csrow->mtype = amd64_determine_memory_type(pvt, i);
 
 		debugf1("  for MC node %d csrow %d:\n", pvt->mc_node_id, i);
 		debugf1("    input_addr_min: 0x%lx input_addr_max: 0x%lx\n",
@@ -2313,8 +2297,7 @@ static bool amd64_nb_mce_bank_enabled_on_node(int nid)
 	bool ret = false;
 
 	if (!zalloc_cpumask_var(&mask, GFP_KERNEL)) {
-		amd64_printk(KERN_WARNING, "%s: error allocating mask\n",
-			     __func__);
+		amd64_warn("%s: Error allocating mask\n", __func__);
 		return false;
 	}
 
@@ -2346,8 +2329,7 @@ static int amd64_toggle_ecc_err_reporting(struct amd64_pvt *pvt, bool on)
 	int cpu;
 
 	if (!zalloc_cpumask_var(&cmask, GFP_KERNEL)) {
-		amd64_printk(KERN_WARNING, "%s: error allocating mask\n",
-			     __func__);
+		amd64_warn("%s: error allocating mask\n", __func__);
 		return false;
 	}
 
@@ -2394,8 +2376,7 @@ static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 	pci_write_config_dword(pvt->F3, K8_NBCTL, value);
 
 	if (amd64_toggle_ecc_err_reporting(pvt, ON))
-		amd64_printk(KERN_WARNING, "Error enabling ECC reporting over "
-					   "MCGCTL!\n");
+		amd64_warn("Error enabling ECC reporting over MCGCTL!\n");
 
 	amd64_read_pci_cfg(pvt->F3, K8_NBCFG, &value);
 
@@ -2404,9 +2385,7 @@ static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 		(value & K8_NBCFG_ECC_ENABLE) ? "Enabled" : "Disabled");
 
 	if (!(value & K8_NBCFG_ECC_ENABLE)) {
-		amd64_printk(KERN_WARNING,
-			"This node reports that DRAM ECC is "
-			"currently Disabled; ENABLING now\n");
+		amd64_warn("DRAM ECC disabled on this node, enabling...\n");
 
 		pvt->flags.nb_ecc_prev = 0;
 
@@ -2417,12 +2396,10 @@ static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 		amd64_read_pci_cfg(pvt->F3, K8_NBCFG, &value);
 
 		if (!(value & K8_NBCFG_ECC_ENABLE)) {
-			amd64_printk(KERN_WARNING,
-				"Hardware rejects Enabling DRAM ECC checking\n"
-				"Check memory DIMM configuration\n");
+			amd64_warn("Hardware rejected DRAM ECC enable,"
+				   "check memory DIMM configuration.\n");
 		} else {
-			amd64_printk(KERN_DEBUG,
-				"Hardware accepted DRAM ECC Enable\n");
+			amd64_info("Hardware accepted DRAM ECC Enable\n");
 		}
 	} else {
 		pvt->flags.nb_ecc_prev = 1;
@@ -2457,7 +2434,7 @@ static void amd64_restore_ecc_error_reporting(struct amd64_pvt *pvt)
 
 	/* restore the NB Enable MCGCTL bit */
 	if (amd64_toggle_ecc_err_reporting(pvt, OFF))
-		amd64_printk(KERN_WARNING, "Error restoring NB MCGCTL settings!\n");
+		amd64_warn("Error restoring NB MCGCTL settings!\n");
 }
 
 /*
@@ -2481,25 +2458,20 @@ static int amd64_check_ecc_enabled(struct amd64_pvt *pvt)
 	amd64_read_pci_cfg(pvt->F3, K8_NBCFG, &value);
 
 	ecc_enabled = !!(value & K8_NBCFG_ECC_ENABLE);
-	if (!ecc_enabled)
-		amd64_printk(KERN_NOTICE, "This node reports that Memory ECC "
-			     "is currently disabled, set F3x%x[22] (%s).\n",
-			     K8_NBCFG, pci_name(pvt->F3));
-	else
-		amd64_printk(KERN_INFO, "ECC is enabled by BIOS.\n");
+	amd64_info("DRAM ECC %s.\n", (ecc_enabled ? "enabled" : "disabled"));
 
 	nb_mce_en = amd64_nb_mce_bank_enabled_on_node(pvt->mc_node_id);
 	if (!nb_mce_en)
-		amd64_printk(KERN_NOTICE, "NB MCE bank disabled, set MSR "
-			     "0x%08x[4] on node %d to enable.\n",
+		amd64_notice("NB MCE bank disabled, "
+			     "set MSR 0x%08x[4] on node %d to enable.\n",
 			     MSR_IA32_MCG_CTL, pvt->mc_node_id);
 
 	if (!ecc_enabled || !nb_mce_en) {
 		if (!ecc_enable_override) {
-			amd64_printk(KERN_NOTICE, "%s", ecc_msg);
+			amd64_notice("%s", ecc_msg);
 			return -ENODEV;
 		} else {
-			amd64_printk(KERN_WARNING, "Forcing ECC checking on!\n");
+			amd64_warn("Forcing ECC on!\n");
 		}
 	}
 
@@ -2575,17 +2547,17 @@ static struct amd64_family_type *amd64_per_family_init(struct amd64_pvt *pvt)
 		break;
 
 	default:
-		amd64_printk(KERN_ERR, "Unsupported family!\n");
+		amd64_err("Unsupported family!\n");
 		return NULL;
 	}
 
 	pvt->ext_model = boot_cpu_data.x86_model >> 4;
 
-	amd64_printk(KERN_INFO, "%s %s detected.\n", pvt->ctl_name,
+	amd64_info("%s %sdetected (node %d).\n", pvt->ctl_name,
 		     (fam == 0xf ?
-				(pvt->ext_model >= K8_REV_F  ? "revF or later"
-							     : "revE or earlier")
-				 : ""));
+				(pvt->ext_model >= K8_REV_F  ? "revF or later "
+							     : "revE or earlier ")
+				 : ""), pvt->mc_node_id);
 	return fam_type;
 }
 
@@ -2736,8 +2708,6 @@ static int __devinit amd64_init_one_instance(struct pci_dev *pdev,
 {
 	int ret = 0;
 
-	debugf0("(MC node=%d)\n", get_node_id(pdev));
-
 	ret = pci_enable_device(pdev);
 	if (ret < 0) {
 		debugf0("ret=%d\n", ret);
@@ -2746,8 +2716,7 @@ static int __devinit amd64_init_one_instance(struct pci_dev *pdev,
 
 	ret = amd64_probe_one_instance(pdev);
 	if (ret < 0)
-		amd64_printk(KERN_ERR, "Error probing instance: %d\n",
-					get_node_id(pdev));
+		amd64_err("Error probing instance: %d\n", get_node_id(pdev));
 
 	return ret;
 }
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 76760a8..f15e2b2 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -74,11 +74,26 @@
 #include "edac_core.h"
 #include "mce_amd.h"
 
-#define amd64_printk(level, fmt, arg...) \
-	edac_printk(level, "amd64", fmt, ##arg)
+#define amd64_debug(fmt, arg...) \
+	edac_printk(KERN_DEBUG, "amd64", fmt, ##arg)
 
-#define amd64_mc_printk(mci, level, fmt, arg...) \
-	edac_mc_chipset_printk(mci, level, "amd64", fmt, ##arg)
+#define amd64_info(fmt, arg...) \
+	edac_printk(KERN_INFO, "amd64", fmt, ##arg)
+
+#define amd64_notice(fmt, arg...) \
+	edac_printk(KERN_NOTICE, "amd64", fmt, ##arg)
+
+#define amd64_warn(fmt, arg...) \
+	edac_printk(KERN_WARNING, "amd64", fmt, ##arg)
+
+#define amd64_err(fmt, arg...) \
+	edac_printk(KERN_ERR, "amd64", fmt, ##arg)
+
+#define amd64_mc_warn(mci, fmt, arg...) \
+	edac_mc_chipset_printk(mci, KERN_WARNING, "amd64", fmt, ##arg)
+
+#define amd64_mc_err(mci, fmt, arg...) \
+	edac_mc_chipset_printk(mci, KERN_ERR, "amd64", fmt, ##arg)
 
 /*
  * Throughout the comments in this code, the following terms are used:
@@ -129,7 +144,7 @@
  *         sections 3.5.4 and 3.5.5 for more information.
  */
 
-#define EDAC_AMD64_VERSION		" Ver: 3.3.0 " __DATE__
+#define EDAC_AMD64_VERSION		"v3.3.0"
 #define EDAC_MOD_STR			"amd64_edac"
 
 #define EDAC_MAX_NUMNODES		8
@@ -527,8 +542,8 @@ static inline int amd64_read_pci_cfg_dword(struct pci_dev *pdev, int offset,
 
 	err = pci_read_config_dword(pdev, offset, val);
 	if (err)
-		amd64_printk(KERN_WARNING, "%s: error reading F%dx%x.\n",
-			     func, PCI_FUNC(pdev->devfn), offset);
+		amd64_warn("%s: error reading F%dx%x.\n",
+			   func, PCI_FUNC(pdev->devfn), offset);
 
 	return err;
 }
diff --git a/drivers/edac/amd64_edac_inj.c b/drivers/edac/amd64_edac_inj.c
index 523ce4a..688478d 100644
--- a/drivers/edac/amd64_edac_inj.c
+++ b/drivers/edac/amd64_edac_inj.c
@@ -23,9 +23,7 @@ static ssize_t amd64_inject_section_store(struct mem_ctl_info *mci,
 	if (ret != -EINVAL) {
 
 		if (value > 3) {
-			amd64_printk(KERN_WARNING,
-				     "%s: invalid section 0x%lx\n",
-				     __func__, value);
+			amd64_warn("%s: invalid section 0x%lx\n", __func__, value);
 			return -EINVAL;
 		}
 
@@ -58,9 +56,7 @@ static ssize_t amd64_inject_word_store(struct mem_ctl_info *mci,
 	if (ret != -EINVAL) {
 
 		if (value > 8) {
-			amd64_printk(KERN_WARNING,
-				     "%s: invalid word 0x%lx\n",
-				     __func__, value);
+			amd64_warn("%s: invalid word 0x%lx\n", __func__, value);
 			return -EINVAL;
 		}
 
@@ -92,9 +88,8 @@ static ssize_t amd64_inject_ecc_vector_store(struct mem_ctl_info *mci,
 	if (ret != -EINVAL) {
 
 		if (value & 0xFFFF0000) {
-			amd64_printk(KERN_WARNING,
-				     "%s: invalid EccVector: 0x%lx\n",
-				     __func__, value);
+			amd64_warn("%s: invalid EccVector: 0x%lx\n",
+				   __func__, value);
 			return -EINVAL;
 		}
 
diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index d7ca43a..050f9ee 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -68,9 +68,10 @@
 #define EDAC_PCI "PCI"
 #define EDAC_DEBUG "DEBUG"
 
+extern const char *edac_mem_types[];
+
 #ifdef CONFIG_EDAC_DEBUG
 extern int edac_debug_level;
-extern const char *edac_mem_types[];
 
 #define edac_debug_printk(level, fmt, arg...)                           \
 	do {                                                            \
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index ba6586a..4ab9480 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -76,6 +76,8 @@ static void edac_mc_dump_mci(struct mem_ctl_info *mci)
 	debugf3("\tpvt_info = %p\n\n", mci->pvt_info);
 }
 
+#endif				/* CONFIG_EDAC_DEBUG */
+
 /*
  * keep those in sync with the enum mem_type
  */
@@ -100,8 +102,6 @@ const char *edac_mem_types[] = {
 };
 EXPORT_SYMBOL_GPL(edac_mem_types);
 
-#endif				/* CONFIG_EDAC_DEBUG */
-
 /* 'ptr' points to a possibly unaligned item X such that sizeof(X) is 'size'.
  * Adjust 'ptr' so that its alignment is at least as stringent as what the
  * compiler would provide for X and return the aligned result.
-- 
1.7.3.1.50.g1e633


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab0KZTHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 14:07:34 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46318 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab0KZTFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:05:25 -0500
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 07/16] amd64_edac: Rename CPU PCI devices
Date: Fri, 26 Nov 2010 20:04:14 +0100
Message-Id: <1290798263-13074-8-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1290798263-13074-1-git-send-email-bp@amd64.org>
References: <1290798263-13074-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Rename variables representing PCI devices to their BKDG names for faster
search and shorter, clearer code.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c     |  153 +++++++++++++++++++----------------------
 drivers/edac/amd64_edac.h     |    7 +--
 drivers/edac/amd64_edac_inj.c |   12 +--
 3 files changed, 77 insertions(+), 95 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 9370812..aa57853 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -163,7 +163,7 @@ static int amd64_set_scrub_rate(struct mem_ctl_info *mci, u32 bw)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
 
-	return __amd64_set_scrub_rate(pvt->misc_f3_ctl, bw, pvt->min_scrubrate);
+	return __amd64_set_scrub_rate(pvt->F3, bw, pvt->min_scrubrate);
 }
 
 static int amd64_get_scrub_rate(struct mem_ctl_info *mci, u32 *bw)
@@ -172,7 +172,7 @@ static int amd64_get_scrub_rate(struct mem_ctl_info *mci, u32 *bw)
 	u32 scrubval = 0;
 	int status = -1, i;
 
-	amd64_read_pci_cfg(pvt->misc_f3_ctl, K8_SCRCTRL, &scrubval);
+	amd64_read_pci_cfg(pvt->F3, K8_SCRCTRL, &scrubval);
 
 	scrubval = scrubval & 0x001F;
 
@@ -882,10 +882,10 @@ static void amd64_dump_misc_regs(struct amd64_pvt *pvt)
 /* Read in both of DBAM registers */
 static void amd64_read_dbam_reg(struct amd64_pvt *pvt)
 {
-	amd64_read_pci_cfg(pvt->dram_f2_ctl, DBAM0, &pvt->dbam0);
+	amd64_read_pci_cfg(pvt->F2, DBAM0, &pvt->dbam0);
 
 	if (boot_cpu_data.x86 >= 0x10)
-		amd64_read_pci_cfg(pvt->dram_f2_ctl, DBAM1, &pvt->dbam1);
+		amd64_read_pci_cfg(pvt->F2, DBAM1, &pvt->dbam1);
 }
 
 /*
@@ -948,14 +948,14 @@ static void amd64_read_dct_base_mask(struct amd64_pvt *pvt)
 
 	for (cs = 0; cs < pvt->cs_count; cs++) {
 		reg = K8_DCSB0 + (cs * 4);
-		if (!amd64_read_pci_cfg(pvt->dram_f2_ctl, reg, &pvt->dcsb0[cs]))
+		if (!amd64_read_pci_cfg(pvt->F2, reg, &pvt->dcsb0[cs]))
 			debugf0("  DCSB0[%d]=0x%08x reg: F2x%x\n",
 				cs, pvt->dcsb0[cs], reg);
 
 		/* If DCT are NOT ganged, then read in DCT1's base */
 		if (boot_cpu_data.x86 >= 0x10 && !dct_ganging_enabled(pvt)) {
 			reg = F10_DCSB1 + (cs * 4);
-			if (!amd64_read_pci_cfg(pvt->dram_f2_ctl, reg,
+			if (!amd64_read_pci_cfg(pvt->F2, reg,
 						&pvt->dcsb1[cs]))
 				debugf0("  DCSB1[%d]=0x%08x reg: F2x%x\n",
 					cs, pvt->dcsb1[cs], reg);
@@ -966,14 +966,14 @@ static void amd64_read_dct_base_mask(struct amd64_pvt *pvt)
 
 	for (cs = 0; cs < pvt->num_dcsm; cs++) {
 		reg = K8_DCSM0 + (cs * 4);
-		if (!amd64_read_pci_cfg(pvt->dram_f2_ctl, reg, &pvt->dcsm0[cs]))
+		if (!amd64_read_pci_cfg(pvt->F2, reg, &pvt->dcsm0[cs]))
 			debugf0("    DCSM0[%d]=0x%08x reg: F2x%x\n",
 				cs, pvt->dcsm0[cs], reg);
 
 		/* If DCT are NOT ganged, then read in DCT1's mask */
 		if (boot_cpu_data.x86 >= 0x10 && !dct_ganging_enabled(pvt)) {
 			reg = F10_DCSM1 + (cs * 4);
-			if (!amd64_read_pci_cfg(pvt->dram_f2_ctl, reg,
+			if (!amd64_read_pci_cfg(pvt->F2, reg,
 						&pvt->dcsm1[cs]))
 				debugf0("    DCSM1[%d]=0x%08x reg: F2x%x\n",
 					cs, pvt->dcsm1[cs], reg);
@@ -1014,7 +1014,7 @@ static int k8_early_channel_count(struct amd64_pvt *pvt)
 {
 	int flag, err = 0;
 
-	err = amd64_read_pci_cfg(pvt->dram_f2_ctl, F10_DCLR_0, &pvt->dclr0);
+	err = amd64_read_pci_cfg(pvt->F2, F10_DCLR_0, &pvt->dclr0);
 	if (err)
 		return err;
 
@@ -1050,14 +1050,14 @@ static void k8_read_dram_base_limit(struct amd64_pvt *pvt, int dram)
 	u32 low;
 	u32 off = dram << 3;	/* 8 bytes between DRAM entries */
 
-	amd64_read_pci_cfg(pvt->addr_f1_ctl, K8_DRAM_BASE_LOW + off, &low);
+	amd64_read_pci_cfg(pvt->F1, K8_DRAM_BASE_LOW + off, &low);
 
 	/* Extract parts into separate data entries */
 	pvt->dram_base[dram] = ((u64) low & 0xFFFF0000) << 8;
 	pvt->dram_IntlvEn[dram] = (low >> 8) & 0x7;
 	pvt->dram_rw_en[dram] = (low & 0x3);
 
-	amd64_read_pci_cfg(pvt->addr_f1_ctl, K8_DRAM_LIMIT_LOW + off, &low);
+	amd64_read_pci_cfg(pvt->F1, K8_DRAM_LIMIT_LOW + off, &low);
 
 	/*
 	 * Extract parts into separate data entries. Limit is the HIGHEST memory
@@ -1180,7 +1180,7 @@ static int f10_early_channel_count(struct amd64_pvt *pvt)
 	 * both controllers since DIMMs can be placed in either one.
 	 */
 	for (i = 0; i < ARRAY_SIZE(dbams); i++) {
-		if (amd64_read_pci_cfg(pvt->dram_f2_ctl, dbams[i], &dbam))
+		if (amd64_read_pci_cfg(pvt->F2, dbams[i], &dbam))
 			goto err_reg;
 
 		for (j = 0; j < 4; j++) {
@@ -1220,11 +1220,11 @@ static void amd64_setup(struct amd64_pvt *pvt)
 {
 	u32 reg;
 
-	amd64_read_pci_cfg(pvt->misc_f3_ctl, F10_NB_CFG_HIGH, &reg);
+	amd64_read_pci_cfg(pvt->F3, F10_NB_CFG_HIGH, &reg);
 
 	pvt->flags.cf8_extcfg = !!(reg & F10_NB_CFG_LOW_ENABLE_EXT_CFG);
 	reg |= F10_NB_CFG_LOW_ENABLE_EXT_CFG;
-	pci_write_config_dword(pvt->misc_f3_ctl, F10_NB_CFG_HIGH, reg);
+	pci_write_config_dword(pvt->F3, F10_NB_CFG_HIGH, reg);
 }
 
 /* Restore the extended configuration access via 0xCF8 feature */
@@ -1232,12 +1232,12 @@ static void amd64_teardown(struct amd64_pvt *pvt)
 {
 	u32 reg;
 
-	amd64_read_pci_cfg(pvt->misc_f3_ctl, F10_NB_CFG_HIGH, &reg);
+	amd64_read_pci_cfg(pvt->F3, F10_NB_CFG_HIGH, &reg);
 
 	reg &= ~F10_NB_CFG_LOW_ENABLE_EXT_CFG;
 	if (pvt->flags.cf8_extcfg)
 		reg |= F10_NB_CFG_LOW_ENABLE_EXT_CFG;
-	pci_write_config_dword(pvt->misc_f3_ctl, F10_NB_CFG_HIGH, reg);
+	pci_write_config_dword(pvt->F3, F10_NB_CFG_HIGH, reg);
 }
 
 static u64 f10_get_error_address(struct mem_ctl_info *mci,
@@ -1261,10 +1261,10 @@ static void f10_read_dram_base_limit(struct amd64_pvt *pvt, int dram)
 	high_offset = F10_DRAM_BASE_HIGH + (dram << 3);
 
 	/* read the 'raw' DRAM BASE Address register */
-	amd64_read_pci_cfg(pvt->addr_f1_ctl, low_offset, &low_base);
+	amd64_read_pci_cfg(pvt->F1, low_offset, &low_base);
 
 	/* Read from the ECS data register */
-	amd64_read_pci_cfg(pvt->addr_f1_ctl, high_offset, &high_base);
+	amd64_read_pci_cfg(pvt->F1, high_offset, &high_base);
 
 	/* Extract parts into separate data entries */
 	pvt->dram_rw_en[dram] = (low_base & 0x3);
@@ -1281,10 +1281,10 @@ static void f10_read_dram_base_limit(struct amd64_pvt *pvt, int dram)
 	high_offset = F10_DRAM_LIMIT_HIGH + (dram << 3);
 
 	/* read the 'raw' LIMIT registers */
-	amd64_read_pci_cfg(pvt->addr_f1_ctl, low_offset, &low_limit);
+	amd64_read_pci_cfg(pvt->F1, low_offset, &low_limit);
 
 	/* Read from the ECS data register for the HIGH portion */
-	amd64_read_pci_cfg(pvt->addr_f1_ctl, high_offset, &high_limit);
+	amd64_read_pci_cfg(pvt->F1, high_offset, &high_limit);
 
 	pvt->dram_DstNode[dram] = (low_limit & 0x7);
 	pvt->dram_IntlvSel[dram] = (low_limit >> 8) & 0x7;
@@ -1301,7 +1301,7 @@ static void f10_read_dram_base_limit(struct amd64_pvt *pvt, int dram)
 static void f10_read_dram_ctl_register(struct amd64_pvt *pvt)
 {
 
-	if (!amd64_read_pci_cfg(pvt->dram_f2_ctl, F10_DCTL_SEL_LOW,
+	if (!amd64_read_pci_cfg(pvt->F2, F10_DCTL_SEL_LOW,
 				&pvt->dram_ctl_select_low)) {
 		debugf0("F2x110 (DCTL Sel. Low): 0x%08x, "
 			"High range addresses at: 0x%x\n",
@@ -1327,7 +1327,7 @@ static void f10_read_dram_ctl_register(struct amd64_pvt *pvt)
 			dct_sel_interleave_addr(pvt));
 	}
 
-	amd64_read_pci_cfg(pvt->dram_f2_ctl, F10_DCTL_SEL_HIGH,
+	amd64_read_pci_cfg(pvt->F2, F10_DCTL_SEL_HIGH,
 			   &pvt->dram_ctl_select_high);
 }
 
@@ -1707,8 +1707,8 @@ static void amd64_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt)
 static struct amd64_family_type amd64_family_types[] = {
 	[K8_CPUS] = {
 		.ctl_name = "K8",
-		.addr_f1_ctl = PCI_DEVICE_ID_AMD_K8_NB_ADDRMAP,
-		.misc_f3_ctl = PCI_DEVICE_ID_AMD_K8_NB_MISC,
+		.f1_id = PCI_DEVICE_ID_AMD_K8_NB_ADDRMAP,
+		.f3_id = PCI_DEVICE_ID_AMD_K8_NB_MISC,
 		.ops = {
 			.early_channel_count	= k8_early_channel_count,
 			.get_error_address	= k8_get_error_address,
@@ -1719,8 +1719,8 @@ static struct amd64_family_type amd64_family_types[] = {
 	},
 	[F10_CPUS] = {
 		.ctl_name = "F10h",
-		.addr_f1_ctl = PCI_DEVICE_ID_AMD_10H_NB_MAP,
-		.misc_f3_ctl = PCI_DEVICE_ID_AMD_10H_NB_MISC,
+		.f1_id = PCI_DEVICE_ID_AMD_10H_NB_MAP,
+		.f3_id = PCI_DEVICE_ID_AMD_10H_NB_MISC,
 		.ops = {
 			.early_channel_count	= f10_early_channel_count,
 			.get_error_address	= f10_get_error_address,
@@ -2035,53 +2035,44 @@ void amd64_decode_bus_error(int node_id, struct mce *m, u32 nbcfg)
 }
 
 /*
- * Use pvt->dram_f2_ctl which contains the F2 CPU PCI device to get the related
+ * Use pvt->F2 which contains the F2 CPU PCI device to get the related
  * F1 (AddrMap) and F3 (Misc) devices. Return negative value on error.
  */
 static int amd64_reserve_mc_sibling_devices(struct amd64_pvt *pvt, u16 f1_id,
 					    u16 f3_id)
 {
 	/* Reserve the ADDRESS MAP Device */
-	pvt->addr_f1_ctl = pci_get_related_function(pvt->dram_f2_ctl->vendor,
-						    f1_id,
-						    pvt->dram_f2_ctl);
-
-	if (!pvt->addr_f1_ctl) {
+	pvt->F1 = pci_get_related_function(pvt->F2->vendor, f1_id, pvt->F2);
+	if (!pvt->F1) {
 		amd64_printk(KERN_ERR, "error address map device not found: "
-			     "vendor %x device 0x%x (broken BIOS?)\n",
-			     PCI_VENDOR_ID_AMD, f1_id);
+				       "vendor %x device 0x%x (broken BIOS?)\n",
+				       PCI_VENDOR_ID_AMD, f1_id);
 		return -ENODEV;
 	}
 
 	/* Reserve the MISC Device */
-	pvt->misc_f3_ctl = pci_get_related_function(pvt->dram_f2_ctl->vendor,
-						    f3_id,
-						    pvt->dram_f2_ctl);
+	pvt->F3 = pci_get_related_function(pvt->F2->vendor, f3_id, pvt->F2);
+	if (!pvt->F3) {
+		pci_dev_put(pvt->F1);
+		pvt->F1 = NULL;
 
-	if (!pvt->misc_f3_ctl) {
-		pci_dev_put(pvt->addr_f1_ctl);
-		pvt->addr_f1_ctl = NULL;
+		amd64_printk(KERN_ERR, "error F3 device not found: "
+				       "vendor %x device 0x%x (broken BIOS?)\n",
+				       PCI_VENDOR_ID_AMD, f3_id);
 
-		amd64_printk(KERN_ERR, "error miscellaneous device not found: "
-			     "vendor %x device 0x%x (broken BIOS?)\n",
-			     PCI_VENDOR_ID_AMD, f3_id);
 		return -ENODEV;
 	}
-
-	debugf1("    Addr Map device PCI Bus ID:\t%s\n",
-		pci_name(pvt->addr_f1_ctl));
-	debugf1("    DRAM MEM-CTL PCI Bus ID:\t%s\n",
-		pci_name(pvt->dram_f2_ctl));
-	debugf1("    Misc device PCI Bus ID:\t%s\n",
-		pci_name(pvt->misc_f3_ctl));
+	debugf1("F1: %s\n", pci_name(pvt->F1));
+	debugf1("F2: %s\n", pci_name(pvt->F2));
+	debugf1("F3: %s\n", pci_name(pvt->F3));
 
 	return 0;
 }
 
 static void amd64_free_mc_sibling_devices(struct amd64_pvt *pvt)
 {
-	pci_dev_put(pvt->addr_f1_ctl);
-	pci_dev_put(pvt->misc_f3_ctl);
+	pci_dev_put(pvt->F1);
+	pci_dev_put(pvt->F3);
 }
 
 /*
@@ -2109,7 +2100,7 @@ static void amd64_read_mc_registers(struct amd64_pvt *pvt)
 	} else
 		debugf0("  TOP_MEM2 disabled.\n");
 
-	amd64_read_pci_cfg(pvt->misc_f3_ctl, K8_NBCAP, &pvt->nbcap);
+	amd64_read_pci_cfg(pvt->F3, K8_NBCAP, &pvt->nbcap);
 
 	if (pvt->ops->read_dram_ctl_register)
 		pvt->ops->read_dram_ctl_register(pvt);
@@ -2146,21 +2137,20 @@ static void amd64_read_mc_registers(struct amd64_pvt *pvt)
 
 	amd64_read_dct_base_mask(pvt);
 
-	amd64_read_pci_cfg(pvt->addr_f1_ctl, K8_DHAR, &pvt->dhar);
+	amd64_read_pci_cfg(pvt->F1, K8_DHAR, &pvt->dhar);
 	amd64_read_dbam_reg(pvt);
 
-	amd64_read_pci_cfg(pvt->misc_f3_ctl,
-			   F10_ONLINE_SPARE, &pvt->online_spare);
+	amd64_read_pci_cfg(pvt->F3, F10_ONLINE_SPARE, &pvt->online_spare);
 
-	amd64_read_pci_cfg(pvt->dram_f2_ctl, F10_DCLR_0, &pvt->dclr0);
-	amd64_read_pci_cfg(pvt->dram_f2_ctl, F10_DCHR_0, &pvt->dchr0);
+	amd64_read_pci_cfg(pvt->F2, F10_DCLR_0, &pvt->dclr0);
+	amd64_read_pci_cfg(pvt->F2, F10_DCHR_0, &pvt->dchr0);
 
 	if (boot_cpu_data.x86 >= 0x10) {
 		if (!dct_ganging_enabled(pvt)) {
-			amd64_read_pci_cfg(pvt->dram_f2_ctl, F10_DCLR_1, &pvt->dclr1);
-			amd64_read_pci_cfg(pvt->dram_f2_ctl, F10_DCHR_1, &pvt->dchr1);
+			amd64_read_pci_cfg(pvt->F2, F10_DCLR_1, &pvt->dclr1);
+			amd64_read_pci_cfg(pvt->F2, F10_DCHR_1, &pvt->dchr1);
 		}
-		amd64_read_pci_cfg(pvt->misc_f3_ctl, EXT_NB_MCA_CFG, &tmp);
+		amd64_read_pci_cfg(pvt->F3, EXT_NB_MCA_CFG, &tmp);
 	}
 
 	if (boot_cpu_data.x86 == 0x10 &&
@@ -2249,7 +2239,7 @@ static int amd64_init_csrows(struct mem_ctl_info *mci)
 
 	pvt = mci->pvt_info;
 
-	amd64_read_pci_cfg(pvt->misc_f3_ctl, K8_NBCFG, &pvt->nbcfg);
+	amd64_read_pci_cfg(pvt->F3, K8_NBCFG, &pvt->nbcfg);
 
 	debugf0("NBCFG= 0x%x  CHIPKILL= %s DRAM ECC= %s\n", pvt->nbcfg,
 		(pvt->nbcfg & K8_NBCFG_CHIPKILL) ? "Enabled" : "Disabled",
@@ -2394,20 +2384,20 @@ static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 	struct amd64_pvt *pvt = mci->pvt_info;
 	u32 value, mask = K8_NBCTL_CECCEn | K8_NBCTL_UECCEn;
 
-	amd64_read_pci_cfg(pvt->misc_f3_ctl, K8_NBCTL, &value);
+	amd64_read_pci_cfg(pvt->F3, K8_NBCTL, &value);
 
 	/* turn on UECCn and CECCEn bits */
 	pvt->old_nbctl = value & mask;
 	pvt->nbctl_mcgctl_saved = 1;
 
 	value |= mask;
-	pci_write_config_dword(pvt->misc_f3_ctl, K8_NBCTL, value);
+	pci_write_config_dword(pvt->F3, K8_NBCTL, value);
 
 	if (amd64_toggle_ecc_err_reporting(pvt, ON))
 		amd64_printk(KERN_WARNING, "Error enabling ECC reporting over "
 					   "MCGCTL!\n");
 
-	amd64_read_pci_cfg(pvt->misc_f3_ctl, K8_NBCFG, &value);
+	amd64_read_pci_cfg(pvt->F3, K8_NBCFG, &value);
 
 	debugf0("NBCFG(1)= 0x%x  CHIPKILL= %s ECC_ENABLE= %s\n", value,
 		(value & K8_NBCFG_CHIPKILL) ? "Enabled" : "Disabled",
@@ -2422,9 +2412,9 @@ static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 
 		/* Attempt to turn on DRAM ECC Enable */
 		value |= K8_NBCFG_ECC_ENABLE;
-		pci_write_config_dword(pvt->misc_f3_ctl, K8_NBCFG, value);
+		pci_write_config_dword(pvt->F3, K8_NBCFG, value);
 
-		amd64_read_pci_cfg(pvt->misc_f3_ctl, K8_NBCFG, &value);
+		amd64_read_pci_cfg(pvt->F3, K8_NBCFG, &value);
 
 		if (!(value & K8_NBCFG_ECC_ENABLE)) {
 			amd64_printk(KERN_WARNING,
@@ -2452,17 +2442,17 @@ static void amd64_restore_ecc_error_reporting(struct amd64_pvt *pvt)
 	if (!pvt->nbctl_mcgctl_saved)
 		return;
 
-	amd64_read_pci_cfg(pvt->misc_f3_ctl, K8_NBCTL, &value);
+	amd64_read_pci_cfg(pvt->F3, K8_NBCTL, &value);
 	value &= ~mask;
 	value |= pvt->old_nbctl;
 
-	pci_write_config_dword(pvt->misc_f3_ctl, K8_NBCTL, value);
+	pci_write_config_dword(pvt->F3, K8_NBCTL, value);
 
 	/* restore previous BIOS DRAM ECC "off" setting which we force-enabled */
 	if (!pvt->flags.nb_ecc_prev) {
-		amd64_read_pci_cfg(pvt->misc_f3_ctl, K8_NBCFG, &value);
+		amd64_read_pci_cfg(pvt->F3, K8_NBCFG, &value);
 		value &= ~K8_NBCFG_ECC_ENABLE;
-		pci_write_config_dword(pvt->misc_f3_ctl, K8_NBCFG, value);
+		pci_write_config_dword(pvt->F3, K8_NBCFG, value);
 	}
 
 	/* restore the NB Enable MCGCTL bit */
@@ -2488,13 +2478,13 @@ static int amd64_check_ecc_enabled(struct amd64_pvt *pvt)
 	u8 ecc_enabled = 0;
 	bool nb_mce_en = false;
 
-	amd64_read_pci_cfg(pvt->misc_f3_ctl, K8_NBCFG, &value);
+	amd64_read_pci_cfg(pvt->F3, K8_NBCFG, &value);
 
 	ecc_enabled = !!(value & K8_NBCFG_ECC_ENABLE);
 	if (!ecc_enabled)
 		amd64_printk(KERN_NOTICE, "This node reports that Memory ECC "
 			     "is currently disabled, set F3x%x[22] (%s).\n",
-			     K8_NBCFG, pci_name(pvt->misc_f3_ctl));
+			     K8_NBCFG, pci_name(pvt->F3));
 	else
 		amd64_printk(KERN_INFO, "ECC is enabled by BIOS.\n");
 
@@ -2554,7 +2544,7 @@ static void amd64_setup_mci_misc_attributes(struct mem_ctl_info *mci)
 	mci->mod_name		= EDAC_MOD_STR;
 	mci->mod_ver		= EDAC_AMD64_VERSION;
 	mci->ctl_name		= pvt->ctl_name;
-	mci->dev_name		= pci_name(pvt->dram_f2_ctl);
+	mci->dev_name		= pci_name(pvt->F2);
 	mci->ctl_page_to_phys	= NULL;
 
 	/* memory scrubber interface */
@@ -2611,7 +2601,7 @@ static struct amd64_family_type *amd64_per_family_init(struct amd64_pvt *pvt)
  * later come back in a finish-setup function to perform that final
  * initialization. See also amd64_init_2nd_stage() for that.
  */
-static int amd64_probe_one_instance(struct pci_dev *dram_f2_ctl)
+static int amd64_probe_one_instance(struct pci_dev *F2)
 {
 	struct amd64_pvt *pvt = NULL;
 	struct amd64_family_type *fam_type = NULL;
@@ -2622,8 +2612,8 @@ static int amd64_probe_one_instance(struct pci_dev *dram_f2_ctl)
 	if (!pvt)
 		goto err_exit;
 
-	pvt->mc_node_id	 = get_node_id(dram_f2_ctl);
-	pvt->dram_f2_ctl = dram_f2_ctl;
+	pvt->mc_node_id	 = get_node_id(F2);
+	pvt->F2 = F2;
 
 	ret = -EINVAL;
 	fam_type = amd64_per_family_init(pvt);
@@ -2631,8 +2621,8 @@ static int amd64_probe_one_instance(struct pci_dev *dram_f2_ctl)
 		goto err_free;
 
 	ret = -ENODEV;
-	err = amd64_reserve_mc_sibling_devices(pvt, fam_type->addr_f1_ctl,
-					       fam_type->misc_f3_ctl);
+	err = amd64_reserve_mc_sibling_devices(pvt, fam_type->f1_id,
+						fam_type->f3_id);
 	if (err)
 		goto err_free;
 
@@ -2695,7 +2685,7 @@ static int amd64_init_2nd_stage(struct amd64_pvt *pvt)
 
 	mci->pvt_info = pvt;
 
-	mci->dev = &pvt->dram_f2_ctl->dev;
+	mci->dev = &pvt->F2->dev;
 	amd64_setup_mci_misc_attributes(mci);
 
 	if (amd64_init_csrows(mci))
@@ -2839,8 +2829,7 @@ static void amd64_setup_pci_device(void)
 
 		pvt = mci->pvt_info;
 		amd64_ctl_pci =
-			edac_pci_create_generic_ctl(&pvt->dram_f2_ctl->dev,
-						    EDAC_MOD_STR);
+			edac_pci_create_generic_ctl(&pvt->F2->dev, EDAC_MOD_STR);
 
 		if (!amd64_ctl_pci) {
 			pr_warning("%s(): Unable to create PCI control\n",
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 007b68a..76760a8 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -386,9 +386,7 @@ struct amd64_pvt {
 	struct low_ops *ops;
 
 	/* pci_device handles which we utilize */
-	struct pci_dev *addr_f1_ctl;
-	struct pci_dev *dram_f2_ctl;
-	struct pci_dev *misc_f3_ctl;
+	struct pci_dev *F1, *F2, *F3;
 
 	int mc_node_id;		/* MC index of this MC node */
 	int ext_model;		/* extended model value of this node */
@@ -518,8 +516,7 @@ struct low_ops {
 
 struct amd64_family_type {
 	const char *ctl_name;
-	u16 addr_f1_ctl;
-	u16 misc_f3_ctl;
+	u16 f1_id, f3_id;
 	struct low_ops ops;
 };
 
diff --git a/drivers/edac/amd64_edac_inj.c b/drivers/edac/amd64_edac_inj.c
index 29f1f7a..523ce4a 100644
--- a/drivers/edac/amd64_edac_inj.c
+++ b/drivers/edac/amd64_edac_inj.c
@@ -122,15 +122,13 @@ static ssize_t amd64_inject_read_store(struct mem_ctl_info *mci,
 		/* Form value to choose 16-byte section of cacheline */
 		section = F10_NB_ARRAY_DRAM_ECC |
 				SET_NB_ARRAY_ADDRESS(pvt->injection.section);
-		pci_write_config_dword(pvt->misc_f3_ctl,
-					F10_NB_ARRAY_ADDR, section);
+		pci_write_config_dword(pvt->F3, F10_NB_ARRAY_ADDR, section);
 
 		word_bits = SET_NB_DRAM_INJECTION_READ(pvt->injection.word,
 						pvt->injection.bit_map);
 
 		/* Issue 'word' and 'bit' along with the READ request */
-		pci_write_config_dword(pvt->misc_f3_ctl,
-					F10_NB_ARRAY_DATA, word_bits);
+		pci_write_config_dword(pvt->F3, F10_NB_ARRAY_DATA, word_bits);
 
 		debugf0("section=0x%x word_bits=0x%x\n", section, word_bits);
 
@@ -157,15 +155,13 @@ static ssize_t amd64_inject_write_store(struct mem_ctl_info *mci,
 		/* Form value to choose 16-byte section of cacheline */
 		section = F10_NB_ARRAY_DRAM_ECC |
 				SET_NB_ARRAY_ADDRESS(pvt->injection.section);
-		pci_write_config_dword(pvt->misc_f3_ctl,
-					F10_NB_ARRAY_ADDR, section);
+		pci_write_config_dword(pvt->F3, F10_NB_ARRAY_ADDR, section);
 
 		word_bits = SET_NB_DRAM_INJECTION_WRITE(pvt->injection.word,
 						pvt->injection.bit_map);
 
 		/* Issue 'word' and 'bit' along with the READ request */
-		pci_write_config_dword(pvt->misc_f3_ctl,
-					F10_NB_ARRAY_DATA, word_bits);
+		pci_write_config_dword(pvt->F3, F10_NB_ARRAY_DATA, word_bits);
 
 		debugf0("section=0x%x word_bits=0x%x\n", section, word_bits);
 
-- 
1.7.3.1.50.g1e633


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab1BJRP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:15:28 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44573 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1BJRPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:15:23 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 02/30] amd64_edac: Add support for F15h DCT PCI config accesses
Date: Thu, 10 Feb 2011 18:15:05 +0100
Message-Id: <1297358133-14320-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

F15h "multiplexes" between the configuration space of the two DRAM
controllers by toggling D18F1x10C[DctCfgSel] while F10h has a different
set of registers for DCT0, and DCT1 in extended PCI config space.

Add DCT configuration space accessors per family thus wrapping all the
different access prerequisites. Clean up code while at it, shorten
names.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c     |  164 +++++++++++++++++++++++++++++------------
 drivers/edac/amd64_edac.h     |   49 ++++++------
 drivers/edac/amd64_edac_inj.c |    8 +-
 3 files changed, 146 insertions(+), 75 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 23e0355..ae5adac 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -107,6 +107,79 @@ struct scrubrate {
 	{ 0x00, 0UL},        /* scrubbing off */
 };
 
+static int __amd64_read_pci_cfg_dword(struct pci_dev *pdev, int offset,
+				      u32 *val, const char *func)
+{
+	int err = 0;
+
+	err = pci_read_config_dword(pdev, offset, val);
+	if (err)
+		amd64_warn("%s: error reading F%dx%03x.\n",
+			   func, PCI_FUNC(pdev->devfn), offset);
+
+	return err;
+}
+
+int __amd64_write_pci_cfg_dword(struct pci_dev *pdev, int offset,
+				u32 val, const char *func)
+{
+	int err = 0;
+
+	err = pci_write_config_dword(pdev, offset, val);
+	if (err)
+		amd64_warn("%s: error writing to F%dx%03x.\n",
+			   func, PCI_FUNC(pdev->devfn), offset);
+
+	return err;
+}
+
+/*
+ *
+ * Depending on the family, F2 DCT reads need special handling:
+ *
+ * K8: has a single DCT only
+ *
+ * F10h: each DCT has its own set of regs
+ *	DCT0 -> F2x040..
+ *	DCT1 -> F2x140..
+ *
+ * F15h: we select which DCT we access using F1x10C[DctCfgSel]
+ *
+ */
+static int k8_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
+			       const char *func)
+{
+	if (addr >= 0x100)
+		return -EINVAL;
+
+	return __amd64_read_pci_cfg_dword(pvt->F2, addr, val, func);
+}
+
+static int f10_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
+				 const char *func)
+{
+	return __amd64_read_pci_cfg_dword(pvt->F2, addr, val, func);
+}
+
+static int f15_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
+				 const char *func)
+{
+	u32 reg = 0;
+	u8 dct  = 0;
+
+	if (addr >= 0x140 && addr <= 0x1a0) {
+		dct   = 1;
+		addr -= 0x100;
+	}
+
+	amd64_read_pci_cfg(pvt->F1, DCT_CFG_SEL, &reg);
+	reg &= 0xfffffffe;
+	reg |= dct;
+	amd64_write_pci_cfg(pvt->F1, DCT_CFG_SEL, reg);
+
+	return __amd64_read_pci_cfg_dword(pvt->F2, addr, val, func);
+}
+
 /*
  * Memory scrubber control interface. For K8, memory scrubbing is handled by
  * hardware and can involve L2 cache, dcache as well as the main memory. With
@@ -824,7 +897,7 @@ static void amd64_dump_dramcfg_low(u32 dclr, int chan)
 }
 
 /* Display and decode various NB registers for debug purposes. */
-static void amd64_dump_misc_regs(struct amd64_pvt *pvt)
+static void dump_misc_regs(struct amd64_pvt *pvt)
 {
 	debugf1("F3xE8 (NB Cap): 0x%08x\n", pvt->nbcap);
 
@@ -864,13 +937,10 @@ static void amd64_dump_misc_regs(struct amd64_pvt *pvt)
 		amd64_dump_dramcfg_low(pvt->dclr1, 1);
 }
 
-/* Read in both of DBAM registers */
 static void amd64_read_dbam_reg(struct amd64_pvt *pvt)
 {
-	amd64_read_pci_cfg(pvt->F2, DBAM0, &pvt->dbam0);
-
-	if (boot_cpu_data.x86 >= 0x10)
-		amd64_read_pci_cfg(pvt->F2, DBAM1, &pvt->dbam1);
+	amd64_read_dct_pci_cfg(pvt, DBAM0, &pvt->dbam0);
+	amd64_read_dct_pci_cfg(pvt, DBAM1, &pvt->dbam1);
 }
 
 /*
@@ -925,7 +995,7 @@ static void amd64_set_dct_base_and_mask(struct amd64_pvt *pvt)
 /*
  * Function 2 Offset F10_DCSB0; read in the DCS Base and DCS Mask hw registers
  */
-static void amd64_read_dct_base_mask(struct amd64_pvt *pvt)
+static void read_dct_base_mask(struct amd64_pvt *pvt)
 {
 	int cs, reg;
 
@@ -933,37 +1003,33 @@ static void amd64_read_dct_base_mask(struct amd64_pvt *pvt)
 
 	for (cs = 0; cs < pvt->cs_count; cs++) {
 		reg = K8_DCSB0 + (cs * 4);
-		if (!amd64_read_pci_cfg(pvt->F2, reg, &pvt->dcsb0[cs]))
+
+		if (!amd64_read_dct_pci_cfg(pvt, reg, &pvt->dcsb0[cs]))
 			debugf0("  DCSB0[%d]=0x%08x reg: F2x%x\n",
 				cs, pvt->dcsb0[cs], reg);
 
-		/* If DCT are NOT ganged, then read in DCT1's base */
-		if (boot_cpu_data.x86 >= 0x10 && !dct_ganging_enabled(pvt)) {
+		if (!dct_ganging_enabled(pvt)) {
 			reg = F10_DCSB1 + (cs * 4);
-			if (!amd64_read_pci_cfg(pvt->F2, reg,
-						&pvt->dcsb1[cs]))
+
+			if (!amd64_read_dct_pci_cfg(pvt, reg, &pvt->dcsb1[cs]))
 				debugf0("  DCSB1[%d]=0x%08x reg: F2x%x\n",
 					cs, pvt->dcsb1[cs], reg);
-		} else {
-			pvt->dcsb1[cs] = 0;
 		}
 	}
 
 	for (cs = 0; cs < pvt->num_dcsm; cs++) {
 		reg = K8_DCSM0 + (cs * 4);
-		if (!amd64_read_pci_cfg(pvt->F2, reg, &pvt->dcsm0[cs]))
+
+		if (!amd64_read_dct_pci_cfg(pvt, reg, &pvt->dcsm0[cs]))
 			debugf0("    DCSM0[%d]=0x%08x reg: F2x%x\n",
 				cs, pvt->dcsm0[cs], reg);
 
-		/* If DCT are NOT ganged, then read in DCT1's mask */
-		if (boot_cpu_data.x86 >= 0x10 && !dct_ganging_enabled(pvt)) {
+		if (!dct_ganging_enabled(pvt)) {
 			reg = F10_DCSM1 + (cs * 4);
-			if (!amd64_read_pci_cfg(pvt->F2, reg,
-						&pvt->dcsm1[cs]))
+
+			if (!amd64_read_dct_pci_cfg(pvt, reg, &pvt->dcsm1[cs]))
 				debugf0("    DCSM1[%d]=0x%08x reg: F2x%x\n",
 					cs, pvt->dcsm1[cs], reg);
-		} else {
-			pvt->dcsm1[cs] = 0;
 		}
 	}
 }
@@ -999,7 +1065,7 @@ static int k8_early_channel_count(struct amd64_pvt *pvt)
 {
 	int flag, err = 0;
 
-	err = amd64_read_pci_cfg(pvt->F2, F10_DCLR_0, &pvt->dclr0);
+	err = amd64_read_dct_pci_cfg(pvt, F10_DCLR_0, &pvt->dclr0);
 	if (err)
 		return err;
 
@@ -1163,7 +1229,7 @@ static int f10_early_channel_count(struct amd64_pvt *pvt)
 	 * both controllers since DIMMs can be placed in either one.
 	 */
 	for (i = 0; i < ARRAY_SIZE(dbams); i++) {
-		if (amd64_read_pci_cfg(pvt->F2, dbams[i], &dbam))
+		if (amd64_read_dct_pci_cfg(pvt, dbams[i], &dbam))
 			goto err_reg;
 
 		for (j = 0; j < 4; j++) {
@@ -1255,12 +1321,9 @@ static void f10_read_dram_base_limit(struct amd64_pvt *pvt, int dram)
 static void f10_read_dram_ctl_register(struct amd64_pvt *pvt)
 {
 
-	if (!amd64_read_pci_cfg(pvt->F2, F10_DCTL_SEL_LOW,
-				&pvt->dram_ctl_select_low)) {
-		debugf0("F2x110 (DCTL Sel. Low): 0x%08x, "
-			"High range addresses at: 0x%x\n",
-			pvt->dram_ctl_select_low,
-			dct_sel_baseaddr(pvt));
+	if (!amd64_read_dct_pci_cfg(pvt, F10_DCTL_SEL_LOW, &pvt->dct_sel_low)) {
+		debugf0("F2x110 (DCTL Sel. Low): 0x%08x, High range addrs at: 0x%x\n",
+			pvt->dct_sel_low, dct_sel_baseaddr(pvt));
 
 		debugf0("  DCT mode: %s, All DCTs on: %s\n",
 			(dct_ganging_enabled(pvt) ? "ganged" : "unganged"),
@@ -1281,8 +1344,7 @@ static void f10_read_dram_ctl_register(struct amd64_pvt *pvt)
 			dct_sel_interleave_addr(pvt));
 	}
 
-	amd64_read_pci_cfg(pvt->F2, F10_DCTL_SEL_HIGH,
-			   &pvt->dram_ctl_select_high);
+	amd64_read_dct_pci_cfg(pvt, F10_DCTL_SEL_HIGH, &pvt->dct_sel_hi);
 }
 
 /*
@@ -1292,7 +1354,7 @@ static void f10_read_dram_ctl_register(struct amd64_pvt *pvt)
 static u32 f10_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
 				int hi_range_sel, u32 intlv_en)
 {
-	u32 cs, temp, dct_sel_high = (pvt->dram_ctl_select_low >> 1) & 1;
+	u32 cs, temp, dct_sel_high = (pvt->dct_sel_low >> 1) & 1;
 
 	if (dct_ganging_enabled(pvt))
 		cs = 0;
@@ -1481,7 +1543,7 @@ static int f10_match_to_this_node(struct amd64_pvt *pvt, int dram_range,
 	 */
 	hole_off = (pvt->dhar & 0x0000FF80);
 	hole_valid = (pvt->dhar & 0x1);
-	dct_sel_base_off = (pvt->dram_ctl_select_high & 0xFFFFFC00) << 16;
+	dct_sel_base_off = (pvt->dct_sel_hi & 0xFFFFFC00) << 16;
 
 	debugf1("   HoleOffset=0x%x  HoleValid=0x%x IntlvSel=0x%x\n",
 			hole_off, hole_valid, intlv_sel);
@@ -1668,6 +1730,7 @@ static struct amd64_family_type amd64_family_types[] = {
 			.read_dram_base_limit	= k8_read_dram_base_limit,
 			.map_sysaddr_to_csrow	= k8_map_sysaddr_to_csrow,
 			.dbam_to_cs		= k8_dbam_to_chip_select,
+			.read_dct_pci_cfg	= k8_read_dct_pci_cfg,
 		}
 	},
 	[F10_CPUS] = {
@@ -1681,6 +1744,13 @@ static struct amd64_family_type amd64_family_types[] = {
 			.read_dram_ctl_register	= f10_read_dram_ctl_register,
 			.map_sysaddr_to_csrow	= f10_map_sysaddr_to_csrow,
 			.dbam_to_cs		= f10_dbam_to_chip_select,
+			.read_dct_pci_cfg	= f10_read_dct_pci_cfg,
+		}
+	},
+	[F15_CPUS] = {
+		.ctl_name = "F15h",
+		.ops = {
+			.read_dct_pci_cfg	= f15_read_dct_pci_cfg,
 		}
 	},
 };
@@ -2081,24 +2151,24 @@ static void read_mc_regs(struct amd64_pvt *pvt)
 		}
 	}
 
-	amd64_read_dct_base_mask(pvt);
+	read_dct_base_mask(pvt);
 
 	amd64_read_pci_cfg(pvt->F1, K8_DHAR, &pvt->dhar);
 	amd64_read_dbam_reg(pvt);
 
 	amd64_read_pci_cfg(pvt->F3, F10_ONLINE_SPARE, &pvt->online_spare);
 
-	amd64_read_pci_cfg(pvt->F2, F10_DCLR_0, &pvt->dclr0);
-	amd64_read_pci_cfg(pvt->F2, F10_DCHR_0, &pvt->dchr0);
+	amd64_read_dct_pci_cfg(pvt, F10_DCLR_0, &pvt->dclr0);
+	amd64_read_dct_pci_cfg(pvt, F10_DCHR_0, &pvt->dchr0);
 
-	if (boot_cpu_data.x86 >= 0x10) {
-		if (!dct_ganging_enabled(pvt)) {
-			amd64_read_pci_cfg(pvt->F2, F10_DCLR_1, &pvt->dclr1);
-			amd64_read_pci_cfg(pvt->F2, F10_DCHR_1, &pvt->dchr1);
-		}
-		amd64_read_pci_cfg(pvt->F3, EXT_NB_MCA_CFG, &tmp);
+	if (!dct_ganging_enabled(pvt)) {
+		amd64_read_dct_pci_cfg(pvt, F10_DCLR_1, &pvt->dclr1);
+		amd64_read_dct_pci_cfg(pvt, F10_DCHR_1, &pvt->dchr1);
 	}
 
+	if (boot_cpu_data.x86 >= 0x10)
+		amd64_read_pci_cfg(pvt->F3, EXT_NB_MCA_CFG, &tmp);
+
 	if (boot_cpu_data.x86 == 0x10 &&
 	    boot_cpu_data.x86_model > 7 &&
 	    /* F3x180[EccSymbolSize]=1 => x8 symbols */
@@ -2107,7 +2177,7 @@ static void read_mc_regs(struct amd64_pvt *pvt)
 	else
 		pvt->syn_type = 4;
 
-	amd64_dump_misc_regs(pvt);
+	dump_misc_regs(pvt);
 }
 
 /*
@@ -2342,7 +2412,7 @@ static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
 	s->nbctl_valid = true;
 
 	value |= mask;
-	pci_write_config_dword(F3, K8_NBCTL, value);
+	amd64_write_pci_cfg(F3, K8_NBCTL, value);
 
 	amd64_read_pci_cfg(F3, K8_NBCFG, &value);
 
@@ -2357,7 +2427,7 @@ static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
 
 		/* Attempt to turn on DRAM ECC Enable */
 		value |= K8_NBCFG_ECC_ENABLE;
-		pci_write_config_dword(F3, K8_NBCFG, value);
+		amd64_write_pci_cfg(F3, K8_NBCFG, value);
 
 		amd64_read_pci_cfg(F3, K8_NBCFG, &value);
 
@@ -2391,13 +2461,13 @@ static void restore_ecc_error_reporting(struct ecc_settings *s, u8 nid,
 	value &= ~mask;
 	value |= s->old_nbctl;
 
-	pci_write_config_dword(F3, K8_NBCTL, value);
+	amd64_write_pci_cfg(F3, K8_NBCTL, value);
 
 	/* restore previous BIOS DRAM ECC "off" setting we force-enabled */
 	if (!s->flags.nb_ecc_prev) {
 		amd64_read_pci_cfg(F3, K8_NBCFG, &value);
 		value &= ~K8_NBCFG_ECC_ENABLE;
-		pci_write_config_dword(F3, K8_NBCFG, value);
+		amd64_write_pci_cfg(F3, K8_NBCFG, value);
 	}
 
 	/* restore the NB Enable MCGCTL bit */
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 613ec72..91c266b 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -184,6 +184,7 @@
 					/* NOTE: Extra mask bit vs K8 */
 #define f10_dhar_offset(dhar)		((dhar & F10_DHAR_OFFSET_MASK) << 16)
 
+#define DCT_CFG_SEL			0x10C
 
 /* F10 High BASE/LIMIT registers */
 #define F10_DRAM_BASE_HIGH		0x140
@@ -257,14 +258,14 @@
 
 
 #define F10_DCTL_SEL_LOW		0x110
-#define dct_sel_baseaddr(pvt)		((pvt->dram_ctl_select_low) & 0xFFFFF800)
-#define dct_sel_interleave_addr(pvt)	(((pvt->dram_ctl_select_low) >> 6) & 0x3)
-#define dct_high_range_enabled(pvt)	(pvt->dram_ctl_select_low & BIT(0))
-#define dct_interleave_enabled(pvt)	(pvt->dram_ctl_select_low & BIT(2))
-#define dct_ganging_enabled(pvt)	(pvt->dram_ctl_select_low & BIT(4))
-#define dct_data_intlv_enabled(pvt)	(pvt->dram_ctl_select_low & BIT(5))
-#define dct_dram_enabled(pvt)		(pvt->dram_ctl_select_low & BIT(8))
-#define dct_memory_cleared(pvt)		(pvt->dram_ctl_select_low & BIT(10))
+#define dct_sel_baseaddr(pvt)		((pvt->dct_sel_low) & 0xFFFFF800)
+#define dct_sel_interleave_addr(pvt)	(((pvt->dct_sel_low) >> 6) & 0x3)
+#define dct_high_range_enabled(pvt)	(pvt->dct_sel_low & BIT(0))
+#define dct_interleave_enabled(pvt)	(pvt->dct_sel_low & BIT(2))
+#define dct_ganging_enabled(pvt)	(pvt->dct_sel_low & BIT(4))
+#define dct_data_intlv_enabled(pvt)	(pvt->dct_sel_low & BIT(5))
+#define dct_dram_enabled(pvt)		(pvt->dct_sel_low & BIT(8))
+#define dct_memory_cleared(pvt)		(pvt->dct_sel_low & BIT(10))
 
 #define F10_DCTL_SEL_HIGH		0x114
 
@@ -380,9 +381,11 @@ static inline int get_node_id(struct pci_dev *pdev)
 	return PCI_SLOT(pdev->devfn) - 0x18;
 }
 
-enum amd64_chipset_families {
+enum amd_families {
 	K8_CPUS = 0,
 	F10_CPUS,
+	F15_CPUS,
+	NUM_FAMILIES,
 };
 
 /* Error injection control structure */
@@ -448,9 +451,9 @@ struct amd64_pvt {
 	u64 top_mem;		/* top of memory below 4GB */
 	u64 top_mem2;		/* top of memory above 4GB */
 
-	u32 dram_ctl_select_low;	/* DRAM Controller Select Low Reg */
-	u32 dram_ctl_select_high;	/* DRAM Controller Select High Reg */
-	u32 online_spare;               /* On-Line spare Reg */
+	u32 dct_sel_low;	/* DRAM Controller Select Low Reg */
+	u32 dct_sel_hi;		/* DRAM Controller Select High Reg */
+	u32 online_spare;	/* On-Line spare Reg */
 
 	/* x4 or x8 syndromes in use */
 	u8 syn_type;
@@ -519,6 +522,8 @@ struct low_ops {
 	void (*map_sysaddr_to_csrow)	(struct mem_ctl_info *mci,
 					 struct err_regs *info, u64 SystemAddr);
 	int (*dbam_to_cs)		(struct amd64_pvt *pvt, int cs_mode);
+	int (*read_dct_pci_cfg)		(struct amd64_pvt *pvt, int offset,
+					 u32 *val, const char *func);
 };
 
 struct amd64_family_type {
@@ -527,21 +532,17 @@ struct amd64_family_type {
 	struct low_ops ops;
 };
 
-static inline int amd64_read_pci_cfg_dword(struct pci_dev *pdev, int offset,
-					   u32 *val, const char *func)
-{
-	int err = 0;
+int __amd64_write_pci_cfg_dword(struct pci_dev *pdev, int offset,
+				u32 val, const char *func);
 
-	err = pci_read_config_dword(pdev, offset, val);
-	if (err)
-		amd64_warn("%s: error reading F%dx%x.\n",
-			   func, PCI_FUNC(pdev->devfn), offset);
+#define amd64_read_pci_cfg(pdev, offset, val)	\
+	__amd64_read_pci_cfg_dword(pdev, offset, val, __func__)
 
-	return err;
-}
+#define amd64_write_pci_cfg(pdev, offset, val)	\
+	__amd64_write_pci_cfg_dword(pdev, offset, val, __func__)
 
-#define amd64_read_pci_cfg(pdev, offset, val)	\
-	amd64_read_pci_cfg_dword(pdev, offset, val, __func__)
+#define amd64_read_dct_pci_cfg(pvt, offset, val) \
+	pvt->ops->read_dct_pci_cfg(pvt, offset, val, __func__)
 
 /*
  * For future CPU versions, verify the following as new 'slow' rates appear and
diff --git a/drivers/edac/amd64_edac_inj.c b/drivers/edac/amd64_edac_inj.c
index 688478d..303f10e 100644
--- a/drivers/edac/amd64_edac_inj.c
+++ b/drivers/edac/amd64_edac_inj.c
@@ -117,13 +117,13 @@ static ssize_t amd64_inject_read_store(struct mem_ctl_info *mci,
 		/* Form value to choose 16-byte section of cacheline */
 		section = F10_NB_ARRAY_DRAM_ECC |
 				SET_NB_ARRAY_ADDRESS(pvt->injection.section);
-		pci_write_config_dword(pvt->F3, F10_NB_ARRAY_ADDR, section);
+		amd64_write_pci_cfg(pvt->F3, F10_NB_ARRAY_ADDR, section);
 
 		word_bits = SET_NB_DRAM_INJECTION_READ(pvt->injection.word,
 						pvt->injection.bit_map);
 
 		/* Issue 'word' and 'bit' along with the READ request */
-		pci_write_config_dword(pvt->F3, F10_NB_ARRAY_DATA, word_bits);
+		amd64_write_pci_cfg(pvt->F3, F10_NB_ARRAY_DATA, word_bits);
 
 		debugf0("section=0x%x word_bits=0x%x\n", section, word_bits);
 
@@ -150,13 +150,13 @@ static ssize_t amd64_inject_write_store(struct mem_ctl_info *mci,
 		/* Form value to choose 16-byte section of cacheline */
 		section = F10_NB_ARRAY_DRAM_ECC |
 				SET_NB_ARRAY_ADDRESS(pvt->injection.section);
-		pci_write_config_dword(pvt->F3, F10_NB_ARRAY_ADDR, section);
+		amd64_write_pci_cfg(pvt->F3, F10_NB_ARRAY_ADDR, section);
 
 		word_bits = SET_NB_DRAM_INJECTION_WRITE(pvt->injection.word,
 						pvt->injection.bit_map);
 
 		/* Issue 'word' and 'bit' along with the READ request */
-		pci_write_config_dword(pvt->F3, F10_NB_ARRAY_DATA, word_bits);
+		amd64_write_pci_cfg(pvt->F3, F10_NB_ARRAY_DATA, word_bits);
 
 		debugf0("section=0x%x word_bits=0x%x\n", section, word_bits);
 
-- 
1.7.4.rc2


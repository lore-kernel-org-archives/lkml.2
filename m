Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab1BJRPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:15:39 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44597 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699Ab1BJRPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:15:32 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 05/30] amd64_edac: Cleanup chipselect handling
Date: Thu, 10 Feb 2011 18:15:08 +0100
Message-Id: <1297358133-14320-6-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add a struct representing the DRAM chip select base/limit register
pairs. Concentrate all CS handling in a single function. Also, add CS
looping macros for cleaner, more readable code. While at it, adjust code
to F15h. Finally, do smaller macro names cleanups (remove family names
from register macros) and debug messages clarification.

No functional change.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |  293 +++++++++++++++++----------------------------
 drivers/edac/amd64_edac.h |   81 ++++---------
 2 files changed, 136 insertions(+), 238 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 62b4ae9..3068508 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -265,37 +265,6 @@ static int amd64_get_scrub_rate(struct mem_ctl_info *mci)
 	return retval;
 }
 
-/* Map from a CSROW entry to the mask entry that operates on it */
-static inline u32 amd64_map_to_dcs_mask(struct amd64_pvt *pvt, int csrow)
-{
-	if (boot_cpu_data.x86 == 0xf && pvt->ext_model < K8_REV_F)
-		return csrow;
-	else
-		return csrow >> 1;
-}
-
-/* return the 'base' address the i'th CS entry of the 'dct' DRAM controller */
-static u32 amd64_get_dct_base(struct amd64_pvt *pvt, int dct, int csrow)
-{
-	if (dct == 0)
-		return pvt->dcsb0[csrow];
-	else
-		return pvt->dcsb1[csrow];
-}
-
-/*
- * Return the 'mask' address the i'th CS entry. This function is needed because
- * there number of DCSM registers on Rev E and prior vs Rev F and later is
- * different.
- */
-static u32 amd64_get_dct_mask(struct amd64_pvt *pvt, int dct, int csrow)
-{
-	if (dct == 0)
-		return pvt->dcsm0[amd64_map_to_dcs_mask(pvt, csrow)];
-	else
-		return pvt->dcsm1[amd64_map_to_dcs_mask(pvt, csrow)];
-}
-
 /*
  * returns true if the SysAddr given by sys_addr matches the
  * DRAM base/limit associated with node_id
@@ -386,37 +355,47 @@ err_no_match:
 }
 
 /*
- * Extract the DRAM CS base address from selected csrow register.
+ * compute the CS base address of the @csrow on the DRAM controller @dct.
+ * For details see F2x[5C:40] in the processor's BKDG
  */
-static u64 base_from_dct_base(struct amd64_pvt *pvt, int csrow)
+static void get_cs_base_and_mask(struct amd64_pvt *pvt, int csrow, u8 dct,
+				 u64 *base, u64 *mask)
 {
-	return ((u64) (amd64_get_dct_base(pvt, 0, csrow) & pvt->dcsb_base)) <<
-				pvt->dcs_shift;
-}
+	u64 csbase, csmask, base_bits, mask_bits;
+	u8 addr_shift;
 
-/*
- * Extract the mask from the dcsb0[csrow] entry in a CPU revision-specific way.
- */
-static u64 mask_from_dct_mask(struct amd64_pvt *pvt, int csrow)
-{
-	u64 dcsm_bits, other_bits;
-	u64 mask;
-
-	/* Extract bits from DRAM CS Mask. */
-	dcsm_bits = amd64_get_dct_mask(pvt, 0, csrow) & pvt->dcsm_mask;
+	if (boot_cpu_data.x86 == 0xf && pvt->ext_model < K8_REV_F) {
+		csbase		= pvt->csels[dct].csbases[csrow];
+		csmask		= pvt->csels[dct].csmasks[csrow];
+		base_bits	= GENMASK(21, 31) | GENMASK(9, 15);
+		mask_bits	= GENMASK(21, 29) | GENMASK(9, 15);
+		addr_shift	= 4;
+	} else {
+		csbase		= pvt->csels[dct].csbases[csrow];
+		csmask		= pvt->csels[dct].csmasks[csrow >> 1];
+		addr_shift	= 8;
 
-	other_bits = pvt->dcsm_mask;
-	other_bits = ~(other_bits << pvt->dcs_shift);
+		if (boot_cpu_data.x86 == 0x15)
+			base_bits = mask_bits = GENMASK(19,30) | GENMASK(5,13);
+		else
+			base_bits = mask_bits = GENMASK(19,28) | GENMASK(5,13);
+	}
 
-	/*
-	 * The extracted bits from DCSM belong in the spaces represented by
-	 * the cleared bits in other_bits.
-	 */
-	mask = (dcsm_bits << pvt->dcs_shift) | other_bits;
+	*base  = (csbase & base_bits) << addr_shift;
 
-	return mask;
+	*mask  = ~0ULL;
+	/* poke holes for the csmask */
+	*mask &= ~(mask_bits << addr_shift);
+	/* OR them in */
+	*mask |= (csmask & mask_bits) << addr_shift;
 }
 
+#define for_each_chip_select(i, dct, pvt) \
+	for (i = 0; i < pvt->csels[dct].b_cnt; i++)
+
+#define for_each_chip_select_mask(i, dct, pvt) \
+	for (i = 0; i < pvt->csels[dct].m_cnt; i++)
+
 /*
  * @input_addr is an InputAddr associated with the node given by mci. Return the
  * csrow that input_addr maps to, or -1 on failure (no csrow claims input_addr).
@@ -429,19 +408,13 @@ static int input_addr_to_csrow(struct mem_ctl_info *mci, u64 input_addr)
 
 	pvt = mci->pvt_info;
 
-	/*
-	 * Here we use the DRAM CS Base and DRAM CS Mask registers. For each CS
-	 * base/mask register pair, test the condition shown near the start of
-	 * section 3.5.4 (p. 84, BKDG #26094, K8, revA-E).
-	 */
-	for (csrow = 0; csrow < pvt->cs_count; csrow++) {
-
-		/* This DRAM chip select is disabled on this node */
-		if ((pvt->dcsb0[csrow] & K8_DCSB_CS_ENABLE) == 0)
+	for_each_chip_select(csrow, 0, pvt) {
+		if (!csrow_enabled(csrow, 0, pvt))
 			continue;
 
-		base = base_from_dct_base(pvt, csrow);
-		mask = ~mask_from_dct_mask(pvt, csrow);
+		get_cs_base_and_mask(pvt, csrow, 0, &base, &mask);
+
+		mask = ~mask;
 
 		if ((input_addr & mask) == (base & mask)) {
 			debugf2("InputAddr 0x%lx matches csrow %d (node %d)\n",
@@ -451,7 +424,6 @@ static int input_addr_to_csrow(struct mem_ctl_info *mci, u64 input_addr)
 			return csrow;
 		}
 	}
-
 	debugf2("no matching csrow for InputAddr 0x%lx (MC node %d)\n",
 		(unsigned long)input_addr, pvt->mc_node_id);
 
@@ -779,13 +751,12 @@ static void find_csrow_limits(struct mem_ctl_info *mci, int csrow,
 	u64 base, mask;
 
 	pvt = mci->pvt_info;
-	BUG_ON((csrow < 0) || (csrow >= pvt->cs_count));
+	BUG_ON((csrow < 0) || (csrow >= pvt->csels[0].b_cnt));
 
-	base = base_from_dct_base(pvt, csrow);
-	mask = mask_from_dct_mask(pvt, csrow);
+	get_cs_base_and_mask(pvt, csrow, 0, &base, &mask);
 
 	*input_addr_min = base & ~mask;
-	*input_addr_max = base | mask | pvt->dcs_mask_notused;
+	*input_addr_max = base | mask;
 }
 
 /* Map the Error address to a PAGE and PAGE OFFSET. */
@@ -913,93 +884,62 @@ static void amd64_read_dbam_reg(struct amd64_pvt *pvt)
 }
 
 /*
- * NOTE: CPU Revision Dependent code: Rev E and Rev F
- *
- * Set the DCSB and DCSM mask values depending on the CPU revision value. Also
- * set the shift factor for the DCSB and DCSM values.
- *
- * ->dcs_mask_notused, RevE:
- *
- * To find the max InputAddr for the csrow, start with the base address and set
- * all bits that are "don't care" bits in the test at the start of section
- * 3.5.4 (p. 84).
- *
- * The "don't care" bits are all set bits in the mask and all bits in the gaps
- * between bit ranges [35:25] and [19:13]. The value REV_E_DCS_NOTUSED_BITS
- * represents bits [24:20] and [12:0], which are all bits in the above-mentioned
- * gaps.
- *
- * ->dcs_mask_notused, RevF and later:
- *
- * To find the max InputAddr for the csrow, start with the base address and set
- * all bits that are "don't care" bits in the test at the start of NPT section
- * 4.5.4 (p. 87).
- *
- * The "don't care" bits are all set bits in the mask and all bits in the gaps
- * between bit ranges [36:27] and [21:13].
- *
- * The value REV_F_F1Xh_DCS_NOTUSED_BITS represents bits [26:22] and [12:0],
- * which are all bits in the above-mentioned gaps.
+ * see BKDG, F2x[1,0][5C:40], F2[1,0][6C:60]
  */
-static void amd64_set_dct_base_and_mask(struct amd64_pvt *pvt)
+static void prep_chip_selects(struct amd64_pvt *pvt)
 {
-
 	if (boot_cpu_data.x86 == 0xf && pvt->ext_model < K8_REV_F) {
-		pvt->dcsb_base		= REV_E_DCSB_BASE_BITS;
-		pvt->dcsm_mask		= REV_E_DCSM_MASK_BITS;
-		pvt->dcs_mask_notused	= REV_E_DCS_NOTUSED_BITS;
-		pvt->dcs_shift		= REV_E_DCS_SHIFT;
-		pvt->cs_count		= 8;
-		pvt->num_dcsm		= 8;
+		pvt->csels[0].b_cnt = pvt->csels[1].b_cnt = 8;
+		pvt->csels[0].m_cnt = pvt->csels[1].m_cnt = 8;
 	} else {
-		pvt->dcsb_base		= REV_F_F1Xh_DCSB_BASE_BITS;
-		pvt->dcsm_mask		= REV_F_F1Xh_DCSM_MASK_BITS;
-		pvt->dcs_mask_notused	= REV_F_F1Xh_DCS_NOTUSED_BITS;
-		pvt->dcs_shift		= REV_F_F1Xh_DCS_SHIFT;
-		pvt->cs_count		= 8;
-		pvt->num_dcsm		= 4;
+		pvt->csels[0].b_cnt = pvt->csels[1].b_cnt = 8;
+		pvt->csels[0].m_cnt = pvt->csels[1].m_cnt = 4;
 	}
 }
 
 /*
- * Function 2 Offset F10_DCSB0; read in the DCS Base and DCS Mask hw registers
+ * Function 2 Offset F10_DCSB0; read in the DCS Base and DCS Mask registers
  */
 static void read_dct_base_mask(struct amd64_pvt *pvt)
 {
-	int cs, reg;
+	int cs;
 
-	amd64_set_dct_base_and_mask(pvt);
+	prep_chip_selects(pvt);
 
-	for (cs = 0; cs < pvt->cs_count; cs++) {
-		reg = K8_DCSB0 + (cs * 4);
+	for_each_chip_select(cs, 0, pvt) {
+		u32 reg0   = DCSB0 + (cs * 4);
+		u32 reg1   = DCSB1 + (cs * 4);
+		u32 *base0 = &pvt->csels[0].csbases[cs];
+		u32 *base1 = &pvt->csels[1].csbases[cs];
 
-		if (!amd64_read_dct_pci_cfg(pvt, reg, &pvt->dcsb0[cs]))
+		if (!amd64_read_dct_pci_cfg(pvt, reg0, base0))
 			debugf0("  DCSB0[%d]=0x%08x reg: F2x%x\n",
-				cs, pvt->dcsb0[cs], reg);
+				cs, *base0, reg0);
 
-		if (!dct_ganging_enabled(pvt)) {
-			reg = F10_DCSB1 + (cs * 4);
+		if (boot_cpu_data.x86 == 0xf || dct_ganging_enabled(pvt))
+			continue;
 
-			if (!amd64_read_dct_pci_cfg(pvt, reg, &pvt->dcsb1[cs]))
-				debugf0("  DCSB1[%d]=0x%08x reg: F2x%x\n",
-					cs, pvt->dcsb1[cs], reg);
-		}
+		if (!amd64_read_dct_pci_cfg(pvt, reg1, base1))
+			debugf0("  DCSB1[%d]=0x%08x reg: F2x%x\n",
+				cs, *base1, reg1);
 	}
 
-	for (cs = 0; cs < pvt->num_dcsm; cs++) {
-		reg = K8_DCSM0 + (cs * 4);
+	for_each_chip_select_mask(cs, 0, pvt) {
+		u32 reg0   = DCSM0 + (cs * 4);
+		u32 reg1   = DCSM1 + (cs * 4);
+		u32 *mask0 = &pvt->csels[0].csmasks[cs];
+		u32 *mask1 = &pvt->csels[1].csmasks[cs];
 
-		if (!amd64_read_dct_pci_cfg(pvt, reg, &pvt->dcsm0[cs]))
+		if (!amd64_read_dct_pci_cfg(pvt, reg0, mask0))
 			debugf0("    DCSM0[%d]=0x%08x reg: F2x%x\n",
-				cs, pvt->dcsm0[cs], reg);
+				cs, *mask0, reg0);
 
-		if (!dct_ganging_enabled(pvt)) {
-			reg = F10_DCSM1 + (cs * 4);
+		if (boot_cpu_data.x86 == 0xf || dct_ganging_enabled(pvt))
+			continue;
 
-			if (!amd64_read_dct_pci_cfg(pvt, reg, &pvt->dcsm1[cs]))
-				debugf0("    DCSM1[%d]=0x%08x reg: F2x%x\n",
-					cs, pvt->dcsm1[cs], reg);
-		}
+		if (!amd64_read_dct_pci_cfg(pvt, reg1, mask1))
+			debugf0("    DCSM1[%d]=0x%08x reg: F2x%x\n",
+				cs, *mask1, reg1);
 	}
 }
 
@@ -1261,10 +1201,11 @@ static void f10_read_dram_ctl_register(struct amd64_pvt *pvt)
  * determine channel based on the interleaving mode: F10h BKDG, 2.8.9 Memory
  * Interleaving Modes.
  */
-static u32 f10_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
+static u8 f10_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
 				int hi_range_sel, u32 intlv_en)
 {
-	u32 cs, temp, dct_sel_high = (pvt->dct_sel_low >> 1) & 1;
+	u32 temp, dct_sel_high = (pvt->dct_sel_low >> 1) & 1;
+	u8 cs;
 
 	if (dct_ganging_enabled(pvt))
 		cs = 0;
@@ -1345,14 +1286,13 @@ static inline u64 f10_get_base_addr_offset(u64 sys_addr, int hi_range_sel,
  * checks if the csrow passed in is marked as SPARED, if so returns the new
  * spare row
  */
-static inline int f10_process_possible_spare(int csrow,
-				u32 cs, struct amd64_pvt *pvt)
+static int f10_process_possible_spare(struct amd64_pvt *pvt, u8 dct, int csrow)
 {
 	u32 swap_done;
 	u32 bad_dram_cs;
 
 	/* Depending on channel, isolate respective SPARING info */
-	if (cs) {
+	if (dct) {
 		swap_done = F10_ONLINE_SPARE_SWAPDONE1(pvt->online_spare);
 		bad_dram_cs = F10_ONLINE_SPARE_BADDRAM_CS1(pvt->online_spare);
 		if (swap_done && (csrow == bad_dram_cs))
@@ -1374,11 +1314,11 @@ static inline int f10_process_possible_spare(int csrow,
  *	-EINVAL:  NOT FOUND
  *	0..csrow = Chip-Select Row
  */
-static int f10_lookup_addr_in_dct(u32 in_addr, u32 nid, u32 cs)
+static int f10_lookup_addr_in_dct(u64 in_addr, u32 nid, u8 dct)
 {
 	struct mem_ctl_info *mci;
 	struct amd64_pvt *pvt;
-	u32 cs_base, cs_mask;
+	u64 cs_base, cs_mask;
 	int cs_found = -EINVAL;
 	int csrow;
 
@@ -1388,39 +1328,25 @@ static int f10_lookup_addr_in_dct(u32 in_addr, u32 nid, u32 cs)
 
 	pvt = mci->pvt_info;
 
-	debugf1("InputAddr=0x%x  channelselect=%d\n", in_addr, cs);
-
-	for (csrow = 0; csrow < pvt->cs_count; csrow++) {
+	debugf1("input addr: 0x%llx, DCT: %d\n", in_addr, dct);
 
-		cs_base = amd64_get_dct_base(pvt, cs, csrow);
-		if (!(cs_base & K8_DCSB_CS_ENABLE))
+	for_each_chip_select(csrow, dct, pvt) {
+		if (!csrow_enabled(csrow, dct, pvt))
 			continue;
 
-		/*
-		 * We have an ENABLED CSROW, Isolate just the MASK bits of the
-		 * target: [28:19] and [13:5], which map to [36:27] and [21:13]
-		 * of the actual address.
-		 */
-		cs_base &= REV_F_F1Xh_DCSB_BASE_BITS;
-
-		/*
-		 * Get the DCT Mask, and ENABLE the reserved bits: [18:16] and
-		 * [4:0] to become ON. Then mask off bits [28:0] ([36:8])
-		 */
-		cs_mask = amd64_get_dct_mask(pvt, cs, csrow);
+		get_cs_base_and_mask(pvt, csrow, dct, &cs_base, &cs_mask);
 
-		debugf1("    CSROW=%d CSBase=0x%x RAW CSMask=0x%x\n",
-				csrow, cs_base, cs_mask);
+		debugf1("    CSROW=%d CSBase=0x%llx CSMask=0x%llx\n",
+			csrow, cs_base, cs_mask);
 
-		cs_mask = (cs_mask | 0x0007C01F) & 0x1FFFFFFF;
+		cs_mask = ~cs_mask;
 
-		debugf1("              Final CSMask=0x%x\n", cs_mask);
-		debugf1("    (InputAddr & ~CSMask)=0x%x "
-				"(CSBase & ~CSMask)=0x%x\n",
-				(in_addr & ~cs_mask), (cs_base & ~cs_mask));
+		debugf1("    (InputAddr & ~CSMask)=0x%llx "
+			"(CSBase & ~CSMask)=0x%llx\n",
+			(in_addr & cs_mask), (cs_base & cs_mask));
 
-		if ((in_addr & ~cs_mask) == (cs_base & ~cs_mask)) {
-			cs_found = f10_process_possible_spare(csrow, cs, pvt);
+		if ((in_addr & cs_mask) == (cs_base & cs_mask)) {
+			cs_found = f10_process_possible_spare(pvt, dct, csrow);
 
 			debugf1(" MATCH csrow=%d\n", cs_found);
 			break;
@@ -1434,10 +1360,11 @@ static int f10_match_to_this_node(struct amd64_pvt *pvt, int range,
 				  u64 sys_addr, int *nid, int *chan_sel)
 {
 	int cs_found = -EINVAL, high_range = 0;
-	u32 intlv_shift;
-	u64 hole_off;
-	u32 hole_valid, tmp, dct_sel_base, channel;
 	u64 chan_addr, dct_sel_base_off;
+	u64 hole_off;
+	u32 hole_valid, tmp, dct_sel_base;
+	u32 intlv_shift;
+	u8 channel;
 
 	u8 node_id    = dram_dst_node(pvt, range);
 	u32 intlv_en  = dram_intlv_en(pvt, range);
@@ -1499,10 +1426,9 @@ static int f10_match_to_this_node(struct amd64_pvt *pvt, int range,
 		}
 	}
 
-	debugf1("   (ChannelAddrLong=0x%llx) >> 8 becomes InputAddr=0x%x\n",
-		chan_addr, (u32)(chan_addr >> 8));
+	debugf1("   (ChannelAddrLong=0x%llx)\n", chan_addr);
 
-	cs_found = f10_lookup_addr_in_dct(chan_addr >> 8, node_id, channel);
+	cs_found = f10_lookup_addr_in_dct(chan_addr, node_id, channel);
 
 	if (cs_found >= 0) {
 		*nid = node_id;
@@ -1603,7 +1529,8 @@ static void amd64_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt)
 	}
 
 	dbam = (ctrl && !dct_ganging_enabled(pvt)) ? pvt->dbam1 : pvt->dbam0;
-	dcsb = (ctrl && !dct_ganging_enabled(pvt)) ? pvt->dcsb1 : pvt->dcsb0;
+	dcsb = (ctrl && !dct_ganging_enabled(pvt)) ? pvt->csels[1].csbases
+						   : pvt->csels[0].csbases;
 
 	debugf1("F2x%d80 (DRAM Bank Address Mapping): 0x%08x\n", ctrl, dbam);
 
@@ -1613,11 +1540,11 @@ static void amd64_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt)
 	for (dimm = 0; dimm < 4; dimm++) {
 
 		size0 = 0;
-		if (dcsb[dimm*2] & K8_DCSB_CS_ENABLE)
+		if (dcsb[dimm*2] & DCSB_CS_ENABLE)
 			size0 = pvt->ops->dbam_to_cs(pvt, DBAM_DIMM(dimm, dbam));
 
 		size1 = 0;
-		if (dcsb[dimm*2 + 1] & K8_DCSB_CS_ENABLE)
+		if (dcsb[dimm*2 + 1] & DCSB_CS_ENABLE)
 			size1 = pvt->ops->dbam_to_cs(pvt, DBAM_DIMM(dimm, dbam));
 
 		amd64_info(EDAC_MC ": %d: %5dMB %d: %5dMB\n",
@@ -2082,7 +2009,7 @@ static void read_mc_regs(struct amd64_pvt *pvt)
  * NOTE: CPU Revision Dependent code
  *
  * Input:
- *	@csrow_nr ChipSelect Row Number (0..pvt->cs_count-1)
+ *	@csrow_nr ChipSelect Row Number (0..NUM_CHIPSELECTS-1)
  *	k8 private pointer to -->
  *			DRAM Bank Address mapping register
  *			node_id
@@ -2148,7 +2075,7 @@ static int init_csrows(struct mem_ctl_info *mci)
 {
 	struct csrow_info *csrow;
 	struct amd64_pvt *pvt = mci->pvt_info;
-	u64 input_addr_min, input_addr_max, sys_addr;
+	u64 input_addr_min, input_addr_max, sys_addr, base, mask;
 	u32 val;
 	int i, empty = 1;
 
@@ -2161,10 +2088,10 @@ static int init_csrows(struct mem_ctl_info *mci)
 		pvt->mc_node_id, val,
 		!!(val & K8_NBCFG_CHIPKILL), !!(val & K8_NBCFG_ECC_ENABLE));
 
-	for (i = 0; i < pvt->cs_count; i++) {
+	for_each_chip_select(i, 0, pvt) {
 		csrow = &mci->csrows[i];
 
-		if ((pvt->dcsb0[i] & K8_DCSB_CS_ENABLE) == 0) {
+		if (!csrow_enabled(i, 0, pvt)) {
 			debugf1("----CSROW %d EMPTY for node %d\n", i,
 				pvt->mc_node_id);
 			continue;
@@ -2180,7 +2107,9 @@ static int init_csrows(struct mem_ctl_info *mci)
 		csrow->first_page = (u32) (sys_addr >> PAGE_SHIFT);
 		sys_addr = input_addr_to_sys_addr(mci, input_addr_max);
 		csrow->last_page = (u32) (sys_addr >> PAGE_SHIFT);
-		csrow->page_mask = ~mask_from_dct_mask(pvt, i);
+
+		get_cs_base_and_mask(pvt, i, 0, &base, &mask);
+		csrow->page_mask = ~mask;
 		/* 8 bytes of resolution */
 
 		csrow->mtype = amd64_determine_memory_type(pvt, i);
@@ -2532,7 +2461,7 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 		goto err_siblings;
 
 	ret = -ENOMEM;
-	mci = edac_mc_alloc(0, pvt->cs_count, pvt->channel_count, nid);
+	mci = edac_mc_alloc(0, pvt->csels[0].b_cnt, pvt->channel_count, nid);
 	if (!mci)
 		goto err_siblings;
 
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index a2bc9a6..1964f89 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -160,6 +160,14 @@
 #define OFF false
 
 /*
+ * Create a contiguous bitmask starting at bit position @lo and ending at
+ * position @hi. For example
+ *
+ * GENMASK(21, 39) gives us the 64bit vector 0x000000ffffe00000.
+ */
+#define GENMASK(lo, hi)			(((1ULL << ((hi) - (lo) + 1)) - 1) << (lo))
+
+/*
  * PCI-defined configuration space registers
  */
 
@@ -198,45 +206,14 @@
 /*
  * Function 2 - DRAM controller
  */
-#define K8_DCSB0			0x40
-#define F10_DCSB1			0x140
-
-#define K8_DCSB_CS_ENABLE		BIT(0)
-#define K8_DCSB_NPT_SPARE		BIT(1)
-#define K8_DCSB_NPT_TESTFAIL		BIT(2)
-
-/*
- * REV E: select [31:21] and [15:9] from DCSB and the shift amount to form
- * the address
- */
-#define REV_E_DCSB_BASE_BITS		(0xFFE0FE00ULL)
-#define REV_E_DCS_SHIFT			4
-
-#define REV_F_F1Xh_DCSB_BASE_BITS	(0x1FF83FE0ULL)
-#define REV_F_F1Xh_DCS_SHIFT		8
-
-/*
- * REV F and later: selects [28:19] and [13:5] from DCSB and the shift amount
- * to form the address
- */
-#define REV_F_DCSB_BASE_BITS		(0x1FF83FE0ULL)
-#define REV_F_DCS_SHIFT			8
-
-/* DRAM CS Mask Registers */
-#define K8_DCSM0			0x60
-#define F10_DCSM1			0x160
-
-/* REV E: select [29:21] and [15:9] from DCSM */
-#define REV_E_DCSM_MASK_BITS		0x3FE0FE00
-
-/* unused bits [24:20] and [12:0] */
-#define REV_E_DCS_NOTUSED_BITS		0x01F01FFF
+#define DCSB0				0x40
+#define DCSB1				0x140
+#define DCSB_CS_ENABLE			BIT(0)
 
-/* REV F and later: select [28:19] and [13:5] from DCSM */
-#define REV_F_F1Xh_DCSM_MASK_BITS	0x1FF83FE0
+#define DCSM0				0x60
+#define DCSM1				0x160
 
-/* unused bits [26:22] and [12:0] */
-#define REV_F_F1Xh_DCS_NOTUSED_BITS	0x07C01FFF
+#define csrow_enabled(i, dct, pvt)	((pvt)->csels[(dct)].csbases[(i)] & DCSB_CS_ENABLE)
 
 #define DBAM0				0x80
 #define DBAM1				0x180
@@ -412,6 +389,15 @@ struct dram_range {
 	struct reg_pair lim;
 };
 
+/* A DCT chip selects collection */
+struct chip_select {
+	u32 csbases[NUM_CHIPSELECTS];
+	u8 b_cnt;
+
+	u32 csmasks[NUM_CHIPSELECTS];
+	u8 m_cnt;
+};
+
 struct amd64_pvt {
 	struct low_ops *ops;
 
@@ -434,29 +420,12 @@ struct amd64_pvt {
 	u32 dbam0;		/* DRAM Base Address Mapping reg for DCT0 */
 	u32 dbam1;		/* DRAM Base Address Mapping reg for DCT1 */
 
-	/* DRAM CS Base Address Registers F2x[1,0][5C:40] */
-	u32 dcsb0[NUM_CHIPSELECTS];
-	u32 dcsb1[NUM_CHIPSELECTS];
-
-	/* DRAM CS Mask Registers F2x[1,0][6C:60] */
-	u32 dcsm0[NUM_CHIPSELECTS];
-	u32 dcsm1[NUM_CHIPSELECTS];
+	/* one for each DCT */
+	struct chip_select csels[2];
 
 	/* DRAM base and limit pairs F1x[78,70,68,60,58,50,48,40] */
 	struct dram_range ranges[DRAM_RANGES];
 
-	/*
-	 * The following fields are set at (load) run time, after CPU revision
-	 * has been determined, since the dct_base and dct_mask registers vary
-	 * based on revision
-	 */
-	u32 dcsb_base;		/* DCSB base bits */
-	u32 dcsm_mask;		/* DCSM mask bits */
-	u32 cs_count;		/* num chip selects (== num DCSB registers) */
-	u32 num_dcsm;		/* Number of DCSM registers */
-	u32 dcs_mask_notused;	/* DCSM notused mask bits */
-	u32 dcs_shift;		/* DCSB and DCSM shift value */
-
 	u64 top_mem;		/* top of memory below 4GB */
 	u64 top_mem2;		/* top of memory above 4GB */
 
-- 
1.7.4.rc2


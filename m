Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab1BJRVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:21:48 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44584 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679Ab1BJRP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:15:27 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 03/30] amd64_edac: Remove DRAM base/limit subfields caching
Date: Thu, 10 Feb 2011 18:15:06 +0100
Message-Id: <1297358133-14320-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add a struct representing the DRAM base/limit range pairs and remove all
cached subfields. Replace them with accessor functions, which actually
saves us some space:

   text    data     bss     dec     hex filename
  14712    1577     336   16625    40f1 drivers/edac/amd64_edac_mod.o.after
  14831    1609     336   16776    4188 drivers/edac/amd64_edac_mod.o.before

Also, it simplifies the code a lot allowing to merge the K8 and F10h
routines.

No functional change.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |  230 +++++++++++++--------------------------------
 drivers/edac/amd64_edac.h |   73 ++++++++++-----
 2 files changed, 115 insertions(+), 188 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index ae5adac..683fd3c 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -296,32 +296,13 @@ static u32 amd64_get_dct_mask(struct amd64_pvt *pvt, int dct, int csrow)
 		return pvt->dcsm1[amd64_map_to_dcs_mask(pvt, csrow)];
 }
 
-
 /*
- * In *base and *limit, pass back the full 40-bit base and limit physical
- * addresses for the node given by node_id.  This information is obtained from
- * DRAM Base (section 3.4.4.1) and DRAM Limit (section 3.4.4.2) registers. The
- * base and limit addresses are of type SysAddr, as defined at the start of
- * section 3.4.4 (p. 70).  They are the lowest and highest physical addresses
- * in the address range they represent.
+ * returns true if the SysAddr given by sys_addr matches the
+ * DRAM base/limit associated with node_id
  */
-static void amd64_get_base_and_limit(struct amd64_pvt *pvt, int node_id,
-			       u64 *base, u64 *limit)
+static bool amd64_base_limit_match(struct amd64_pvt *pvt, u64 sys_addr, int nid)
 {
-	*base = pvt->dram_base[node_id];
-	*limit = pvt->dram_limit[node_id];
-}
-
-/*
- * Return 1 if the SysAddr given by sys_addr matches the base/limit associated
- * with node_id
- */
-static int amd64_base_limit_match(struct amd64_pvt *pvt,
-					u64 sys_addr, int node_id)
-{
-	u64 base, limit, addr;
-
-	amd64_get_base_and_limit(pvt, node_id, &base, &limit);
+	u64 addr;
 
 	/* The K8 treats this as a 40-bit value.  However, bits 63-40 will be
 	 * all ones if the most significant implemented address bit is 1.
@@ -331,7 +312,8 @@ static int amd64_base_limit_match(struct amd64_pvt *pvt,
 	 */
 	addr = sys_addr & 0x000000ffffffffffull;
 
-	return (addr >= base) && (addr <= limit);
+	return ((addr >= get_dram_base(pvt, nid)) &&
+		(addr <= get_dram_limit(pvt, nid)));
 }
 
 /*
@@ -358,10 +340,10 @@ static struct mem_ctl_info *find_mc_by_sys_addr(struct mem_ctl_info *mci,
 	 * registers.  Therefore we arbitrarily choose to read it from the
 	 * register for node 0.
 	 */
-	intlv_en = pvt->dram_IntlvEn[0];
+	intlv_en = dram_intlv_en(pvt, 0);
 
 	if (intlv_en == 0) {
-		for (node_id = 0; node_id < DRAM_REG_COUNT; node_id++) {
+		for (node_id = 0; node_id < DRAM_RANGES; node_id++) {
 			if (amd64_base_limit_match(pvt, sys_addr, node_id))
 				goto found;
 		}
@@ -378,10 +360,10 @@ static struct mem_ctl_info *find_mc_by_sys_addr(struct mem_ctl_info *mci,
 	bits = (((u32) sys_addr) >> 12) & intlv_en;
 
 	for (node_id = 0; ; ) {
-		if ((pvt->dram_IntlvSel[node_id] & intlv_en) == bits)
+		if ((dram_intlv_sel(pvt, node_id) & intlv_en) == bits)
 			break;	/* intlv_sel field matches */
 
-		if (++node_id >= DRAM_REG_COUNT)
+		if (++node_id >= DRAM_RANGES)
 			goto err_no_match;
 	}
 
@@ -477,19 +459,6 @@ static int input_addr_to_csrow(struct mem_ctl_info *mci, u64 input_addr)
 }
 
 /*
- * Return the base value defined by the DRAM Base register for the node
- * represented by mci.  This function returns the full 40-bit value despite the
- * fact that the register only stores bits 39-24 of the value. See section
- * 3.4.4.1 (BKDG #26094, K8, revA-E)
- */
-static inline u64 get_dram_base(struct mem_ctl_info *mci)
-{
-	struct amd64_pvt *pvt = mci->pvt_info;
-
-	return pvt->dram_base[pvt->mc_node_id];
-}
-
-/*
  * Obtain info from the DRAM Hole Address Register (section 3.4.8, pub #26094)
  * for the node represented by mci. Info is passed back in *hole_base,
  * *hole_offset, and *hole_size.  Function returns 0 if info is valid or 1 if
@@ -598,10 +567,11 @@ EXPORT_SYMBOL_GPL(amd64_get_dram_hole_info);
  */
 static u64 sys_addr_to_dram_addr(struct mem_ctl_info *mci, u64 sys_addr)
 {
+	struct amd64_pvt *pvt = mci->pvt_info;
 	u64 dram_base, hole_base, hole_offset, hole_size, dram_addr;
 	int ret = 0;
 
-	dram_base = get_dram_base(mci);
+	dram_base = get_dram_base(pvt, pvt->mc_node_id);
 
 	ret = amd64_get_dram_hole_info(mci, &hole_base, &hole_offset,
 				      &hole_size);
@@ -665,7 +635,7 @@ static u64 dram_addr_to_input_addr(struct mem_ctl_info *mci, u64 dram_addr)
 	 * See the start of section 3.4.4 (p. 70, BKDG #26094, K8, revA-E)
 	 * concerning translating a DramAddr to an InputAddr.
 	 */
-	intlv_shift = num_node_interleave_bits(pvt->dram_IntlvEn[0]);
+	intlv_shift = num_node_interleave_bits(dram_intlv_en(pvt, 0));
 	input_addr = ((dram_addr >> intlv_shift) & 0xffffff000ull) +
 	    (dram_addr & 0xfff);
 
@@ -717,7 +687,7 @@ static u64 input_addr_to_dram_addr(struct mem_ctl_info *mci, u64 input_addr)
 	node_id = pvt->mc_node_id;
 	BUG_ON((node_id < 0) || (node_id > 7));
 
-	intlv_shift = num_node_interleave_bits(pvt->dram_IntlvEn[0]);
+	intlv_shift = num_node_interleave_bits(dram_intlv_en(pvt, 0));
 
 	if (intlv_shift == 0) {
 		debugf1("    InputAddr 0x%lx translates to DramAddr of "
@@ -729,7 +699,7 @@ static u64 input_addr_to_dram_addr(struct mem_ctl_info *mci, u64 input_addr)
 	bits = ((input_addr & 0xffffff000ull) << intlv_shift) +
 	    (input_addr & 0xfff);
 
-	intlv_sel = pvt->dram_IntlvSel[node_id] & ((1 << intlv_shift) - 1);
+	intlv_sel = dram_intlv_sel(pvt, node_id) & ((1 << intlv_shift) - 1);
 	dram_addr = bits + (intlv_sel << 12);
 
 	debugf1("InputAddr 0x%lx translates to DramAddr 0x%lx "
@@ -746,7 +716,7 @@ static u64 input_addr_to_dram_addr(struct mem_ctl_info *mci, u64 input_addr)
 static u64 dram_addr_to_sys_addr(struct mem_ctl_info *mci, u64 dram_addr)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
-	u64 hole_base, hole_offset, hole_size, base, limit, sys_addr;
+	u64 hole_base, hole_offset, hole_size, base, sys_addr;
 	int ret = 0;
 
 	ret = amd64_get_dram_hole_info(mci, &hole_base, &hole_offset,
@@ -764,7 +734,7 @@ static u64 dram_addr_to_sys_addr(struct mem_ctl_info *mci, u64 dram_addr)
 		}
 	}
 
-	amd64_get_base_and_limit(pvt, pvt->mc_node_id, &base, &limit);
+	base     = get_dram_base(pvt, pvt->mc_node_id);
 	sys_addr = dram_addr + base;
 
 	/*
@@ -1090,33 +1060,21 @@ static u64 k8_get_error_address(struct mem_ctl_info *mci,
 			(info->nbeal & ~0x03);
 }
 
-/*
- * Read the Base and Limit registers for K8 based Memory controllers; extract
- * fields from the 'raw' reg into separate data fields
- *
- * Isolates: BASE, LIMIT, IntlvEn, IntlvSel, RW_EN
- */
-static void k8_read_dram_base_limit(struct amd64_pvt *pvt, int dram)
+static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
 {
-	u32 low;
-	u32 off = dram << 3;	/* 8 bytes between DRAM entries */
+	u32 off = range << 3;
 
-	amd64_read_pci_cfg(pvt->F1, K8_DRAM_BASE_LOW + off, &low);
+	amd64_read_pci_cfg(pvt->F1, DRAM_BASE_LO + off,  &pvt->ranges[range].base.lo);
+	amd64_read_pci_cfg(pvt->F1, DRAM_LIMIT_LO + off, &pvt->ranges[range].lim.lo);
 
-	/* Extract parts into separate data entries */
-	pvt->dram_base[dram] = ((u64) low & 0xFFFF0000) << 8;
-	pvt->dram_IntlvEn[dram] = (low >> 8) & 0x7;
-	pvt->dram_rw_en[dram] = (low & 0x3);
+	if (boot_cpu_data.x86 == 0xf)
+		return;
 
-	amd64_read_pci_cfg(pvt->F1, K8_DRAM_LIMIT_LOW + off, &low);
+	if (!dram_rw(pvt, range))
+		return;
 
-	/*
-	 * Extract parts into separate data entries. Limit is the HIGHEST memory
-	 * location of the region, so lower 24 bits need to be all ones
-	 */
-	pvt->dram_limit[dram] = (((u64) low & 0xFFFF0000) << 8) | 0x00FFFFFF;
-	pvt->dram_IntlvSel[dram] = (low >> 8) & 0x7;
-	pvt->dram_DstNode[dram] = (low & 0x7);
+	amd64_read_pci_cfg(pvt->F1, DRAM_BASE_HI + off,  &pvt->ranges[range].base.hi);
+	amd64_read_pci_cfg(pvt->F1, DRAM_LIMIT_HI + off, &pvt->ranges[range].lim.hi);
 }
 
 static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
@@ -1271,53 +1229,6 @@ static u64 f10_get_error_address(struct mem_ctl_info *mci,
 			(info->nbeal & ~0x01);
 }
 
-/*
- * Read the Base and Limit registers for F10 based Memory controllers. Extract
- * fields from the 'raw' reg into separate data fields.
- *
- * Isolates: BASE, LIMIT, IntlvEn, IntlvSel, RW_EN.
- */
-static void f10_read_dram_base_limit(struct amd64_pvt *pvt, int dram)
-{
-	u32 high_offset, low_offset, high_base, low_base, high_limit, low_limit;
-
-	low_offset = K8_DRAM_BASE_LOW + (dram << 3);
-	high_offset = F10_DRAM_BASE_HIGH + (dram << 3);
-
-	/* read the 'raw' DRAM BASE Address register */
-	amd64_read_pci_cfg(pvt->F1, low_offset, &low_base);
-	amd64_read_pci_cfg(pvt->F1, high_offset, &high_base);
-
-	/* Extract parts into separate data entries */
-	pvt->dram_rw_en[dram] = (low_base & 0x3);
-
-	if (pvt->dram_rw_en[dram] == 0)
-		return;
-
-	pvt->dram_IntlvEn[dram] = (low_base >> 8) & 0x7;
-
-	pvt->dram_base[dram] = (((u64)high_base & 0x000000FF) << 40) |
-			       (((u64)low_base  & 0xFFFF0000) << 8);
-
-	low_offset = K8_DRAM_LIMIT_LOW + (dram << 3);
-	high_offset = F10_DRAM_LIMIT_HIGH + (dram << 3);
-
-	/* read the 'raw' LIMIT registers */
-	amd64_read_pci_cfg(pvt->F1, low_offset, &low_limit);
-	amd64_read_pci_cfg(pvt->F1, high_offset, &high_limit);
-
-	pvt->dram_DstNode[dram] = (low_limit & 0x7);
-	pvt->dram_IntlvSel[dram] = (low_limit >> 8) & 0x7;
-
-	/*
-	 * Extract address values and form a LIMIT address. Limit is the HIGHEST
-	 * memory location of the region, so low 24 bits need to be all ones.
-	 */
-	pvt->dram_limit[dram] = (((u64)high_limit & 0x000000FF) << 40) |
-				(((u64) low_limit & 0xFFFF0000) << 8) |
-				0x00FFFFFF;
-}
-
 static void f10_read_dram_ctl_register(struct amd64_pvt *pvt)
 {
 
@@ -1520,22 +1431,21 @@ static int f10_lookup_addr_in_dct(u32 in_addr, u32 nid, u32 cs)
 }
 
 /* For a given @dram_range, check if @sys_addr falls within it. */
-static int f10_match_to_this_node(struct amd64_pvt *pvt, int dram_range,
+static int f10_match_to_this_node(struct amd64_pvt *pvt, int range,
 				  u64 sys_addr, int *nid, int *chan_sel)
 {
-	int node_id, cs_found = -EINVAL, high_range = 0;
-	u32 intlv_en, intlv_sel, intlv_shift, hole_off;
+	int cs_found = -EINVAL, high_range = 0;
+	u32 intlv_shift, hole_off;
 	u32 hole_valid, tmp, dct_sel_base, channel;
-	u64 dram_base, chan_addr, dct_sel_base_off;
-
-	dram_base = pvt->dram_base[dram_range];
-	intlv_en = pvt->dram_IntlvEn[dram_range];
+	u64 chan_addr, dct_sel_base_off;
 
-	node_id = pvt->dram_DstNode[dram_range];
-	intlv_sel = pvt->dram_IntlvSel[dram_range];
+	u8 node_id    = dram_dst_node(pvt, range);
+	u32 intlv_en  = dram_intlv_en(pvt, range);
+	u32 intlv_sel = dram_intlv_sel(pvt, range);
+	u64 dram_base = get_dram_base(pvt, range);
 
-	debugf1("(dram=%d) Base=0x%llx SystemAddr= 0x%llx Limit=0x%llx\n",
-		dram_range, dram_base, sys_addr, pvt->dram_limit[dram_range]);
+	debugf1("(range %d) Base=0x%llx SystemAddr= 0x%llx Limit=0x%llx\n",
+		range, dram_base, sys_addr, get_dram_limit(pvt, range));
 
 	/*
 	 * This assumes that one node's DHAR is the same as all the other
@@ -1604,20 +1514,17 @@ static int f10_match_to_this_node(struct amd64_pvt *pvt, int dram_range,
 static int f10_translate_sysaddr_to_cs(struct amd64_pvt *pvt, u64 sys_addr,
 				       int *node, int *chan_sel)
 {
-	int dram_range, cs_found = -EINVAL;
-	u64 dram_base, dram_limit;
+	int range, cs_found = -EINVAL;
 
-	for (dram_range = 0; dram_range < DRAM_REG_COUNT; dram_range++) {
+	for (range = 0; range < DRAM_RANGES; range++) {
 
-		if (!pvt->dram_rw_en[dram_range])
+		if (!dram_rw(pvt, range))
 			continue;
 
-		dram_base = pvt->dram_base[dram_range];
-		dram_limit = pvt->dram_limit[dram_range];
+		if ((get_dram_base(pvt, range)  <= sys_addr) &&
+		    (get_dram_limit(pvt, range) >= sys_addr)) {
 
-		if ((dram_base <= sys_addr) && (sys_addr <= dram_limit)) {
-
-			cs_found = f10_match_to_this_node(pvt, dram_range,
+			cs_found = f10_match_to_this_node(pvt, range,
 							  sys_addr, node,
 							  chan_sel);
 			if (cs_found >= 0)
@@ -1727,7 +1634,6 @@ static struct amd64_family_type amd64_family_types[] = {
 		.ops = {
 			.early_channel_count	= k8_early_channel_count,
 			.get_error_address	= k8_get_error_address,
-			.read_dram_base_limit	= k8_read_dram_base_limit,
 			.map_sysaddr_to_csrow	= k8_map_sysaddr_to_csrow,
 			.dbam_to_cs		= k8_dbam_to_chip_select,
 			.read_dct_pci_cfg	= k8_read_dct_pci_cfg,
@@ -1740,7 +1646,6 @@ static struct amd64_family_type amd64_family_types[] = {
 		.ops = {
 			.early_channel_count	= f10_early_channel_count,
 			.get_error_address	= f10_get_error_address,
-			.read_dram_base_limit	= f10_read_dram_base_limit,
 			.read_dram_ctl_register	= f10_read_dram_ctl_register,
 			.map_sysaddr_to_csrow	= f10_map_sysaddr_to_csrow,
 			.dbam_to_cs		= f10_dbam_to_chip_select,
@@ -2099,7 +2004,7 @@ static void read_mc_regs(struct amd64_pvt *pvt)
 {
 	u64 msr_val;
 	u32 tmp;
-	int dram;
+	int range;
 
 	/*
 	 * Retrieve TOP_MEM and TOP_MEM2; no masking off of reserved bits since
@@ -2121,34 +2026,27 @@ static void read_mc_regs(struct amd64_pvt *pvt)
 	if (pvt->ops->read_dram_ctl_register)
 		pvt->ops->read_dram_ctl_register(pvt);
 
-	for (dram = 0; dram < DRAM_REG_COUNT; dram++) {
-		/*
-		 * Call CPU specific READ function to get the DRAM Base and
-		 * Limit values from the DCT.
-		 */
-		pvt->ops->read_dram_base_limit(pvt, dram);
+	for (range = 0; range < DRAM_RANGES; range++) {
+		u8 rw;
 
-		/*
-		 * Only print out debug info on rows with both R and W Enabled.
-		 * Normal processing, compiler should optimize this whole 'if'
-		 * debug output block away.
-		 */
-		if (pvt->dram_rw_en[dram] != 0) {
-			debugf1("  DRAM-BASE[%d]: 0x%016llx "
-				"DRAM-LIMIT:  0x%016llx\n",
-				dram,
-				pvt->dram_base[dram],
-				pvt->dram_limit[dram]);
-
-			debugf1("        IntlvEn=%s %s %s "
-				"IntlvSel=%d DstNode=%d\n",
-				pvt->dram_IntlvEn[dram] ?
-					"Enabled" : "Disabled",
-				(pvt->dram_rw_en[dram] & 0x2) ? "W" : "!W",
-				(pvt->dram_rw_en[dram] & 0x1) ? "R" : "!R",
-				pvt->dram_IntlvSel[dram],
-				pvt->dram_DstNode[dram]);
-		}
+		/* read settings for this DRAM range */
+		read_dram_base_limit_regs(pvt, range);
+
+		rw = dram_rw(pvt, range);
+		if (!rw)
+			continue;
+
+		debugf1("  DRAM range[%d], base: 0x%016llx; limit: 0x%016llx\n",
+			range,
+			get_dram_base(pvt, range),
+			get_dram_limit(pvt, range));
+
+		debugf1("   IntlvEn=%s; Range access: %s%s IntlvSel=%d DstNode=%d\n",
+			dram_intlv_en(pvt, range) ? "Enabled" : "Disabled",
+			(rw & 0x1) ? "R" : "-",
+			(rw & 0x2) ? "W" : "-",
+			dram_intlv_sel(pvt, range),
+			dram_dst_node(pvt, range));
 	}
 
 	read_dct_base_mask(pvt);
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 91c266b..93af357 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -153,8 +153,8 @@
 #define K8_REV_F			4
 
 /* Hardware limit on ChipSelect rows per MC and processors per system */
-#define MAX_CS_COUNT			8
-#define DRAM_REG_COUNT			8
+#define NUM_CHIPSELECTS			8
+#define DRAM_RANGES			8
 
 #define ON true
 #define OFF false
@@ -167,8 +167,14 @@
 /*
  * Function 1 - Address Map
  */
-#define K8_DRAM_BASE_LOW		0x40
-#define K8_DRAM_LIMIT_LOW		0x44
+#define DRAM_BASE_LO			0x40
+#define DRAM_LIMIT_LO			0x44
+
+#define dram_intlv_en(pvt, i)		((pvt->ranges[i].base.lo >> 8) & 0x7)
+#define dram_rw(pvt, i)			(pvt->ranges[i].base.lo & 0x3)
+#define dram_intlv_sel(pvt, i)		((pvt->ranges[i].lim.lo >> 8) & 0x7)
+#define dram_dst_node(pvt, i)		(pvt->ranges[i].lim.lo & 0x7)
+
 #define K8_DHAR				0xf0
 
 #define DHAR_VALID			BIT(0)
@@ -186,9 +192,8 @@
 
 #define DCT_CFG_SEL			0x10C
 
-/* F10 High BASE/LIMIT registers */
-#define F10_DRAM_BASE_HIGH		0x140
-#define F10_DRAM_LIMIT_HIGH		0x144
+#define DRAM_BASE_HI			0x140
+#define DRAM_LIMIT_HI			0x144
 
 
 /*
@@ -395,6 +400,19 @@ struct error_injection {
 	u32	bit_map;
 };
 
+/* low and high part of PCI config space regs */
+struct reg_pair {
+	u32 lo, hi;
+};
+
+/*
+ * See F1x[1, 0][7C:40] DRAM Base/Limit Registers
+ */
+struct dram_range {
+	struct reg_pair base;
+	struct reg_pair lim;
+};
+
 struct amd64_pvt {
 	struct low_ops *ops;
 
@@ -418,23 +436,15 @@ struct amd64_pvt {
 	u32 dbam1;		/* DRAM Base Address Mapping reg for DCT1 */
 
 	/* DRAM CS Base Address Registers F2x[1,0][5C:40] */
-	u32 dcsb0[MAX_CS_COUNT];
-	u32 dcsb1[MAX_CS_COUNT];
+	u32 dcsb0[NUM_CHIPSELECTS];
+	u32 dcsb1[NUM_CHIPSELECTS];
 
 	/* DRAM CS Mask Registers F2x[1,0][6C:60] */
-	u32 dcsm0[MAX_CS_COUNT];
-	u32 dcsm1[MAX_CS_COUNT];
+	u32 dcsm0[NUM_CHIPSELECTS];
+	u32 dcsm1[NUM_CHIPSELECTS];
 
-	/*
-	 * Decoded parts of DRAM BASE and LIMIT Registers
-	 * F1x[78,70,68,60,58,50,48,40]
-	 */
-	u64 dram_base[DRAM_REG_COUNT];
-	u64 dram_limit[DRAM_REG_COUNT];
-	u8  dram_IntlvSel[DRAM_REG_COUNT];
-	u8  dram_IntlvEn[DRAM_REG_COUNT];
-	u8  dram_DstNode[DRAM_REG_COUNT];
-	u8  dram_rw_en[DRAM_REG_COUNT];
+	/* DRAM base and limit pairs F1x[78,70,68,60,58,50,48,40] */
+	struct dram_range ranges[DRAM_RANGES];
 
 	/*
 	 * The following fields are set at (load) run time, after CPU revision
@@ -472,6 +482,26 @@ struct amd64_pvt {
 
 };
 
+static inline u64 get_dram_base(struct amd64_pvt *pvt, unsigned i)
+{
+	u64 addr = ((u64)pvt->ranges[i].base.lo & 0xffff0000) << 8;
+
+	if (boot_cpu_data.x86 == 0xf)
+		return addr;
+
+	return (((u64)pvt->ranges[i].base.hi & 0x000000ff) << 40) | addr;
+}
+
+static inline u64 get_dram_limit(struct amd64_pvt *pvt, unsigned i)
+{
+	u64 lim = (((u64)pvt->ranges[i].lim.lo & 0xffff0000) << 8) | 0x00ffffff;
+
+	if (boot_cpu_data.x86 == 0xf)
+		return lim;
+
+	return (((u64)pvt->ranges[i].lim.hi & 0x000000ff) << 40) | lim;
+}
+
 /*
  * per-node ECC settings descriptor
  */
@@ -517,7 +547,6 @@ struct low_ops {
 
 	u64 (*get_error_address)	(struct mem_ctl_info *mci,
 					 struct err_regs *info);
-	void (*read_dram_base_limit)	(struct amd64_pvt *pvt, int dram);
 	void (*read_dram_ctl_register)	(struct amd64_pvt *pvt);
 	void (*map_sysaddr_to_csrow)	(struct mem_ctl_info *mci,
 					 struct err_regs *info, u64 SystemAddr);
-- 
1.7.4.rc2


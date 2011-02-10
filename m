Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab1BJRP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:15:29 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44576 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647Ab1BJRPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:15:23 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 04/30] amd64_edac: Cleanup DHAR handling
Date: Thu, 10 Feb 2011 18:15:07 +0100
Message-Id: <1297358133-14320-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Adjust to F15h, simplify code, fixup macros.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   36 ++++++++++++++++++------------------
 drivers/edac/amd64_edac.h |   11 +++++------
 2 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 683fd3c..62b4ae9 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -487,9 +487,9 @@ int amd64_get_dram_hole_info(struct mem_ctl_info *mci, u64 *hole_base,
 		return 1;
 	}
 
-	/* only valid for Fam10h */
-	if (boot_cpu_data.x86 == 0x10 &&
-	    (pvt->dhar & F10_DRAM_MEM_HOIST_VALID) == 0) {
+	/* valid for Fam10h and above */
+	if (boot_cpu_data.x86 >= 0x10 &&
+	    (pvt->dhar & DRAM_MEM_HOIST_VALID) == 0) {
 		debugf1("  Dram Memory Hoisting is DISABLED on this system\n");
 		return 1;
 	}
@@ -518,15 +518,15 @@ int amd64_get_dram_hole_info(struct mem_ctl_info *mci, u64 *hole_base,
 	 * addresses in the hole so that they start at 0x100000000.
 	 */
 
-	base = dhar_base(pvt->dhar);
+	base = dhar_base(pvt);
 
 	*hole_base = base;
 	*hole_size = (0x1ull << 32) - base;
 
 	if (boot_cpu_data.x86 > 0xf)
-		*hole_offset = f10_dhar_offset(pvt->dhar);
+		*hole_offset = f10_dhar_offset(pvt);
 	else
-		*hole_offset = k8_dhar_offset(pvt->dhar);
+		*hole_offset = k8_dhar_offset(pvt);
 
 	debugf1("  DHAR info for node %d base 0x%lx offset 0x%lx size 0x%lx\n",
 		pvt->mc_node_id, (unsigned long)*hole_base,
@@ -884,10 +884,9 @@ static void dump_misc_regs(struct amd64_pvt *pvt)
 
 	debugf1("F1xF0 (DRAM Hole Address): 0x%08x, base: 0x%08x, "
 			"offset: 0x%08x\n",
-			pvt->dhar,
-			dhar_base(pvt->dhar),
-			(boot_cpu_data.x86 == 0xf) ? k8_dhar_offset(pvt->dhar)
-						   : f10_dhar_offset(pvt->dhar));
+			pvt->dhar, dhar_base(pvt),
+			(boot_cpu_data.x86 == 0xf) ? k8_dhar_offset(pvt)
+						   : f10_dhar_offset(pvt));
 
 	debugf1("  DramHoleValid: %s\n",
 		(pvt->dhar & DHAR_VALID) ? "yes" : "no");
@@ -1316,7 +1315,7 @@ static inline u32 f10_map_intlv_en_to_shift(u32 intlv_en)
 static inline u64 f10_get_base_addr_offset(u64 sys_addr, int hi_range_sel,
 						 u32 dct_sel_base_addr,
 						 u64 dct_sel_base_off,
-						 u32 hole_valid, u32 hole_off,
+						 u32 hole_valid, u64 hole_off,
 						 u64 dram_base)
 {
 	u64 chan_off;
@@ -1324,12 +1323,12 @@ static inline u64 f10_get_base_addr_offset(u64 sys_addr, int hi_range_sel,
 	if (hi_range_sel) {
 		if (!(dct_sel_base_addr & 0xFFFF0000) &&
 		   hole_valid && (sys_addr >= 0x100000000ULL))
-			chan_off = hole_off << 16;
+			chan_off = hole_off;
 		else
 			chan_off = dct_sel_base_off;
 	} else {
 		if (hole_valid && (sys_addr >= 0x100000000ULL))
-			chan_off = hole_off << 16;
+			chan_off = hole_off;
 		else
 			chan_off = dram_base & 0xFFFFF8000000ULL;
 	}
@@ -1435,7 +1434,8 @@ static int f10_match_to_this_node(struct amd64_pvt *pvt, int range,
 				  u64 sys_addr, int *nid, int *chan_sel)
 {
 	int cs_found = -EINVAL, high_range = 0;
-	u32 intlv_shift, hole_off;
+	u32 intlv_shift;
+	u64 hole_off;
 	u32 hole_valid, tmp, dct_sel_base, channel;
 	u64 chan_addr, dct_sel_base_off;
 
@@ -1451,11 +1451,11 @@ static int f10_match_to_this_node(struct amd64_pvt *pvt, int range,
 	 * This assumes that one node's DHAR is the same as all the other
 	 * nodes' DHAR.
 	 */
-	hole_off = (pvt->dhar & 0x0000FF80);
-	hole_valid = (pvt->dhar & 0x1);
+	hole_off = f10_dhar_offset(pvt);
+	hole_valid = (pvt->dhar & DHAR_VALID);
 	dct_sel_base_off = (pvt->dct_sel_hi & 0xFFFFFC00) << 16;
 
-	debugf1("   HoleOffset=0x%x  HoleValid=0x%x IntlvSel=0x%x\n",
+	debugf1("   HoleOffset=0x%016llx  HoleValid=%d IntlvSel=0x%x\n",
 			hole_off, hole_valid, intlv_sel);
 
 	if (intlv_en &&
@@ -2051,7 +2051,7 @@ static void read_mc_regs(struct amd64_pvt *pvt)
 
 	read_dct_base_mask(pvt);
 
-	amd64_read_pci_cfg(pvt->F1, K8_DHAR, &pvt->dhar);
+	amd64_read_pci_cfg(pvt->F1, DHAR, &pvt->dhar);
 	amd64_read_dbam_reg(pvt);
 
 	amd64_read_pci_cfg(pvt->F3, F10_ONLINE_SPARE, &pvt->online_spare);
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 93af357..a2bc9a6 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -175,20 +175,19 @@
 #define dram_intlv_sel(pvt, i)		((pvt->ranges[i].lim.lo >> 8) & 0x7)
 #define dram_dst_node(pvt, i)		(pvt->ranges[i].lim.lo & 0x7)
 
-#define K8_DHAR				0xf0
-
+#define DHAR				0xf0
 #define DHAR_VALID			BIT(0)
-#define F10_DRAM_MEM_HOIST_VALID	BIT(1)
+#define DRAM_MEM_HOIST_VALID		BIT(1)
 
 #define DHAR_BASE_MASK			0xff000000
-#define dhar_base(dhar)			(dhar & DHAR_BASE_MASK)
+#define dhar_base(pvt)			((pvt)->dhar & DHAR_BASE_MASK)
 
 #define K8_DHAR_OFFSET_MASK		0x0000ff00
-#define k8_dhar_offset(dhar)		((dhar & K8_DHAR_OFFSET_MASK) << 16)
+#define k8_dhar_offset(pvt)		(((pvt)->dhar & K8_DHAR_OFFSET_MASK) << 16)
 
 #define F10_DHAR_OFFSET_MASK		0x0000ff80
 					/* NOTE: Extra mask bit vs K8 */
-#define f10_dhar_offset(dhar)		((dhar & F10_DHAR_OFFSET_MASK) << 16)
+#define f10_dhar_offset(pvt)		(((pvt)->dhar & F10_DHAR_OFFSET_MASK) << 16)
 
 #define DCT_CFG_SEL			0x10C
 
-- 
1.7.4.rc2


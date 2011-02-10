Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab1BJRV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:21:28 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44604 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709Ab1BJRPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:15:34 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 07/30] amd64_edac: Sanitize f10_get_base_addr_offset
Date: Thu, 10 Feb 2011 18:15:10 +0100
Message-Id: <1297358133-14320-8-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This function maps the system address to the normalized DCT address.
Document what the code does for more clarity and wrap insane bitmasks in
a more understandable macro which generates them. Also, reduce number of
arguments passed to the function. Finally, rename this function to what
it actually does.

No functional change.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   83 ++++++++++++++++++++++++--------------------
 drivers/edac/amd64_edac.h |   15 +++-----
 2 files changed, 50 insertions(+), 48 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index d9e951c..32e3231 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -460,13 +460,12 @@ int amd64_get_dram_hole_info(struct mem_ctl_info *mci, u64 *hole_base,
 	}
 
 	/* valid for Fam10h and above */
-	if (boot_cpu_data.x86 >= 0x10 &&
-	    (pvt->dhar & DRAM_MEM_HOIST_VALID) == 0) {
+	if (boot_cpu_data.x86 >= 0x10 && !dhar_mem_hoist_valid(pvt)) {
 		debugf1("  Dram Memory Hoisting is DISABLED on this system\n");
 		return 1;
 	}
 
-	if ((pvt->dhar & DHAR_VALID) == 0) {
+	if (!dhar_valid(pvt)) {
 		debugf1("  Dram Memory Hoisting is DISABLED on this node %d\n",
 			pvt->mc_node_id);
 		return 1;
@@ -859,8 +858,7 @@ static void dump_misc_regs(struct amd64_pvt *pvt)
 			(boot_cpu_data.x86 == 0xf) ? k8_dhar_offset(pvt)
 						   : f10_dhar_offset(pvt));
 
-	debugf1("  DramHoleValid: %s\n",
-		(pvt->dhar & DHAR_VALID) ? "yes" : "no");
+	debugf1("  DramHoleValid: %s\n", dhar_valid(pvt) ? "yes" : "no");
 
 	amd64_debug_display_dimm_sizes(0, pvt);
 
@@ -1238,30 +1236,53 @@ static u8 f10_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
 	return 0;
 }
 
-/* See F10h BKDG, 2.8.10.2 DctSelBaseOffset Programming */
-static inline u64 f10_get_base_addr_offset(u64 sys_addr, bool hi_range_sel,
-						 u32 dct_sel_base_addr,
-						 u64 dct_sel_base_off,
-						 u32 hole_valid, u64 hole_off,
-						 u64 dram_base)
+/* Convert the sys_addr to the normalized DCT address */
+static u64 f10_get_norm_dct_addr(struct amd64_pvt *pvt, int range,
+				 u64 sys_addr, bool hi_rng,
+				 u32 dct_sel_base_addr)
 {
 	u64 chan_off;
+	u64 dram_base		= get_dram_base(pvt, range);
+	u64 hole_off		= f10_dhar_offset(pvt);
+	u32 hole_valid		= dhar_valid(pvt);
+	u64 dct_sel_base_off	= (pvt->dct_sel_hi & 0xFFFFFC00) << 16;
 
-	if (hi_range_sel) {
-		if (!(dct_sel_base_addr & 0xFFFF0000) &&
-		   hole_valid && (sys_addr >= 0x100000000ULL))
+	if (hi_rng) {
+		/*
+		 * if
+		 * base address of high range is below 4Gb
+		 * (bits [47:27] at [31:11])
+		 * DRAM address space on this DCT is hoisted above 4Gb	&&
+		 * sys_addr > 4Gb
+		 *
+		 *	remove hole offset from sys_addr
+		 * else
+		 *	remove high range offset from sys_addr
+		 */
+		if ((!(dct_sel_base_addr >> 16) ||
+		     dct_sel_base_addr < dhar_base(pvt)) &&
+		    hole_valid &&
+		    (sys_addr >= BIT_64(32)))
 			chan_off = hole_off;
 		else
 			chan_off = dct_sel_base_off;
 	} else {
-		if (hole_valid && (sys_addr >= 0x100000000ULL))
+		/*
+		 * if
+		 * we have a valid hole		&&
+		 * sys_addr > 4Gb
+		 *
+		 *	remove hole
+		 * else
+		 *	remove dram base to normalize to DCT address
+		 */
+		if (hole_valid && (sys_addr >= BIT_64(32)))
 			chan_off = hole_off;
 		else
-			chan_off = dram_base & 0xFFFFF8000000ULL;
+			chan_off = dram_base;
 	}
 
-	return (sys_addr & 0x0000FFFFFFFFFFC0ULL) -
-			(chan_off & 0x0000FFFFFF800000ULL);
+	return (sys_addr & GENMASK(6,47)) - (chan_off & GENMASK(23,47));
 }
 
 /* Hack for the time being - Can we get this from BIOS?? */
@@ -1346,30 +1367,17 @@ static int f10_match_to_this_node(struct amd64_pvt *pvt, int range,
 				  u64 sys_addr, int *nid, int *chan_sel)
 {
 	int cs_found = -EINVAL;
-	u64 chan_addr, dct_sel_base_off;
-	u64 hole_off;
-	u32 hole_valid, tmp, dct_sel_base;
+	u64 chan_addr;
+	u32 tmp, dct_sel_base;
 	u8 channel;
 	bool high_range = false;
 
 	u8 node_id    = dram_dst_node(pvt, range);
 	u8 intlv_en   = dram_intlv_en(pvt, range);
 	u32 intlv_sel = dram_intlv_sel(pvt, range);
-	u64 dram_base = get_dram_base(pvt, range);
-
-	debugf1("(range %d) Base=0x%llx SystemAddr= 0x%llx Limit=0x%llx\n",
-		range, dram_base, sys_addr, get_dram_limit(pvt, range));
-
-	/*
-	 * This assumes that one node's DHAR is the same as all the other
-	 * nodes' DHAR.
-	 */
-	hole_off = f10_dhar_offset(pvt);
-	hole_valid = (pvt->dhar & DHAR_VALID);
-	dct_sel_base_off = (pvt->dct_sel_hi & 0xFFFFFC00) << 16;
 
-	debugf1("   HoleOffset=0x%016llx  HoleValid=%d IntlvSel=0x%x\n",
-			hole_off, hole_valid, intlv_sel);
+	debugf1("(range %d) SystemAddr= 0x%llx Limit=0x%llx\n",
+		range, sys_addr, get_dram_limit(pvt, range));
 
 	if (intlv_en &&
 	    (intlv_sel != ((sys_addr >> 12) & intlv_en)))
@@ -1388,9 +1396,8 @@ static int f10_match_to_this_node(struct amd64_pvt *pvt, int range,
 
 	channel = f10_determine_channel(pvt, sys_addr, high_range, intlv_en);
 
-	chan_addr = f10_get_base_addr_offset(sys_addr, high_range, dct_sel_base,
-					     dct_sel_base_off, hole_valid,
-					     hole_off, dram_base);
+	chan_addr = f10_get_norm_dct_addr(pvt, range, sys_addr,
+					  high_range, dct_sel_base);
 
 	/* remove Node ID (in case of memory interleaving) */
 	tmp = chan_addr & 0xFC0;
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 1964f89..ba18183 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -184,18 +184,13 @@
 #define dram_dst_node(pvt, i)		(pvt->ranges[i].lim.lo & 0x7)
 
 #define DHAR				0xf0
-#define DHAR_VALID			BIT(0)
-#define DRAM_MEM_HOIST_VALID		BIT(1)
+#define dhar_valid(pvt)			((pvt)->dhar & BIT(0))
+#define dhar_mem_hoist_valid(pvt)	((pvt)->dhar & BIT(1))
+#define dhar_base(pvt)			((pvt)->dhar & 0xff000000)
+#define k8_dhar_offset(pvt)		(((pvt)->dhar & 0x0000ff00) << 16)
 
-#define DHAR_BASE_MASK			0xff000000
-#define dhar_base(pvt)			((pvt)->dhar & DHAR_BASE_MASK)
-
-#define K8_DHAR_OFFSET_MASK		0x0000ff00
-#define k8_dhar_offset(pvt)		(((pvt)->dhar & K8_DHAR_OFFSET_MASK) << 16)
-
-#define F10_DHAR_OFFSET_MASK		0x0000ff80
 					/* NOTE: Extra mask bit vs K8 */
-#define f10_dhar_offset(pvt)		(((pvt)->dhar & F10_DHAR_OFFSET_MASK) << 16)
+#define f10_dhar_offset(pvt)		(((pvt)->dhar & 0x0000ff80) << 16)
 
 #define DCT_CFG_SEL			0x10C
 
-- 
1.7.4.rc2


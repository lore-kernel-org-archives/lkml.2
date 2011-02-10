Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab1BJRPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:15:37 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44594 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647Ab1BJRPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:15:31 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 06/30] amd64_edac: Sanitize channel extraction
Date: Thu, 10 Feb 2011 18:15:09 +0100
Message-Id: <1297358133-14320-7-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Cleanup and simplify f10_determine_channel(); make it more readable.
Also drop f10_map_intlv_en_to_shift() in favor of simply counting the
bits in F1x124[DramIntlvEn] which is equivalent.

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   84 ++++++++++++++++++--------------------------
 1 files changed, 34 insertions(+), 50 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 3068508..d9e951c 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1198,62 +1198,48 @@ static void f10_read_dram_ctl_register(struct amd64_pvt *pvt)
 }
 
 /*
- * determine channel based on the interleaving mode: F10h BKDG, 2.8.9 Memory
+ * Determine channel (DCT) based on the interleaving mode: F10h BKDG, 2.8.9 Memory
  * Interleaving Modes.
  */
 static u8 f10_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
-				int hi_range_sel, u32 intlv_en)
+				bool hi_range_sel, u8 intlv_en)
 {
-	u32 temp, dct_sel_high = (pvt->dct_sel_low >> 1) & 1;
-	u8 cs;
+	u32 dct_sel_high = (pvt->dct_sel_low >> 1) & 1;
 
 	if (dct_ganging_enabled(pvt))
-		cs = 0;
-	else if (hi_range_sel)
-		cs = dct_sel_high;
-	else if (dct_interleave_enabled(pvt)) {
-		/*
-		 * see F2x110[DctSelIntLvAddr] - channel interleave mode
-		 */
-		if (dct_sel_interleave_addr(pvt) == 0)
-			cs = sys_addr >> 6 & 1;
-		else if ((dct_sel_interleave_addr(pvt) >> 1) & 1) {
-			temp = hweight_long((u32) ((sys_addr >> 16) & 0x1F)) % 2;
-
-			if (dct_sel_interleave_addr(pvt) & 1)
-				cs = (sys_addr >> 9 & 1) ^ temp;
-			else
-				cs = (sys_addr >> 6 & 1) ^ temp;
-		} else if (intlv_en & 4)
-			cs = sys_addr >> 15 & 1;
-		else if (intlv_en & 2)
-			cs = sys_addr >> 14 & 1;
-		else if (intlv_en & 1)
-			cs = sys_addr >> 13 & 1;
-		else
-			cs = sys_addr >> 12 & 1;
-	} else if (dct_high_range_enabled(pvt) && !dct_ganging_enabled(pvt))
-		cs = ~dct_sel_high & 1;
-	else
-		cs = 0;
+		return 0;
 
-	return cs;
-}
+	if (hi_range_sel)
+		return dct_sel_high;
 
-static inline u32 f10_map_intlv_en_to_shift(u32 intlv_en)
-{
-	if (intlv_en == 1)
-		return 1;
-	else if (intlv_en == 3)
-		return 2;
-	else if (intlv_en == 7)
-		return 3;
+	/*
+	 * see F2x110[DctSelIntLvAddr] - channel interleave mode
+	 */
+	if (dct_interleave_enabled(pvt)) {
+		u8 intlv_addr = dct_sel_interleave_addr(pvt);
+
+		/* return DCT select function: 0=DCT0, 1=DCT1 */
+		if (!intlv_addr)
+			return sys_addr >> 6 & 1;
+
+		if (intlv_addr & 0x2) {
+			u8 shift = intlv_addr & 0x1 ? 9 : 6;
+			u32 temp = hweight_long((u32) ((sys_addr >> 16) & 0x1F)) % 2;
+
+			return ((sys_addr >> shift) & 1) ^ temp;
+		}
+
+		return (sys_addr >> (12 + hweight8(intlv_en))) & 1;
+	}
+
+	if (dct_high_range_enabled(pvt))
+		return ~dct_sel_high & 1;
 
 	return 0;
 }
 
 /* See F10h BKDG, 2.8.10.2 DctSelBaseOffset Programming */
-static inline u64 f10_get_base_addr_offset(u64 sys_addr, int hi_range_sel,
+static inline u64 f10_get_base_addr_offset(u64 sys_addr, bool hi_range_sel,
 						 u32 dct_sel_base_addr,
 						 u64 dct_sel_base_off,
 						 u32 hole_valid, u64 hole_off,
@@ -1359,15 +1345,15 @@ static int f10_lookup_addr_in_dct(u64 in_addr, u32 nid, u8 dct)
 static int f10_match_to_this_node(struct amd64_pvt *pvt, int range,
 				  u64 sys_addr, int *nid, int *chan_sel)
 {
-	int cs_found = -EINVAL, high_range = 0;
+	int cs_found = -EINVAL;
 	u64 chan_addr, dct_sel_base_off;
 	u64 hole_off;
 	u32 hole_valid, tmp, dct_sel_base;
-	u32 intlv_shift;
 	u8 channel;
+	bool high_range = false;
 
 	u8 node_id    = dram_dst_node(pvt, range);
-	u32 intlv_en  = dram_intlv_en(pvt, range);
+	u8 intlv_en   = dram_intlv_en(pvt, range);
 	u32 intlv_sel = dram_intlv_sel(pvt, range);
 	u64 dram_base = get_dram_base(pvt, range);
 
@@ -1398,7 +1384,7 @@ static int f10_match_to_this_node(struct amd64_pvt *pvt, int range,
 	if (dct_high_range_enabled(pvt) &&
 	   !dct_ganging_enabled(pvt) &&
 	   ((sys_addr >> 27) >= (dct_sel_base >> 11)))
-		high_range = 1;
+		high_range = true;
 
 	channel = f10_determine_channel(pvt, sys_addr, high_range, intlv_en);
 
@@ -1406,12 +1392,10 @@ static int f10_match_to_this_node(struct amd64_pvt *pvt, int range,
 					     dct_sel_base_off, hole_valid,
 					     hole_off, dram_base);
 
-	intlv_shift = f10_map_intlv_en_to_shift(intlv_en);
-
 	/* remove Node ID (in case of memory interleaving) */
 	tmp = chan_addr & 0xFC0;
 
-	chan_addr = ((chan_addr >> intlv_shift) & 0xFFFFFFFFF000ULL) | tmp;
+	chan_addr = ((chan_addr >> hweight8(intlv_en)) & 0xFFFFFFFFF000ULL) | tmp;
 
 	/* remove channel interleave and hash */
 	if (dct_interleave_enabled(pvt) &&
-- 
1.7.4.rc2


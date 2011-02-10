Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab1BJRQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:16:07 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44669 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab1BJRQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:16:02 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 24/30] amd64_edac: Adjust sys_addr to chip select conversion routine to F15h
Date: Thu, 10 Feb 2011 18:15:27 +0100
Message-Id: <1297358133-14320-25-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

F15h sys_addr to chip select mapping is almost identical to F10h's so
reuse that. Rename functions on that path accordingly.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   29 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index e4ad091..1cd82f9 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1171,7 +1171,7 @@ static void f10_read_dram_ctl_register(struct amd64_pvt *pvt)
  * Determine channel (DCT) based on the interleaving mode: F10h BKDG, 2.8.9 Memory
  * Interleaving Modes.
  */
-static u8 f10_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
+static u8 f1x_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
 				bool hi_range_sel, u8 intlv_en)
 {
 	u32 dct_sel_high = (pvt->dct_sel_lo >> 1) & 1;
@@ -1209,7 +1209,7 @@ static u8 f10_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
 }
 
 /* Convert the sys_addr to the normalized DCT address */
-static u64 f10_get_norm_dct_addr(struct amd64_pvt *pvt, int range,
+static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, int range,
 				 u64 sys_addr, bool hi_rng,
 				 u32 dct_sel_base_addr)
 {
@@ -1286,7 +1286,7 @@ static int f10_process_possible_spare(struct amd64_pvt *pvt, u8 dct, int csrow)
  *	-EINVAL:  NOT FOUND
  *	0..csrow = Chip-Select Row
  */
-static int f10_lookup_addr_in_dct(u64 in_addr, u32 nid, u8 dct)
+static int f1x_lookup_addr_in_dct(u64 in_addr, u32 nid, u8 dct)
 {
 	struct mem_ctl_info *mci;
 	struct amd64_pvt *pvt;
@@ -1332,7 +1332,7 @@ static int f10_lookup_addr_in_dct(u64 in_addr, u32 nid, u8 dct)
  * swapped with a region located at the bottom of memory so that the GPU can use
  * the interleaved region and thus two channels.
  */
-static u64 f10_swap_interleaved_region(struct amd64_pvt *pvt, u64 sys_addr)
+static u64 f1x_swap_interleaved_region(struct amd64_pvt *pvt, u64 sys_addr)
 {
 	u32 swap_reg, swap_base, swap_limit, rgn_size, tmp_addr;
 
@@ -1364,7 +1364,7 @@ static u64 f10_swap_interleaved_region(struct amd64_pvt *pvt, u64 sys_addr)
 }
 
 /* For a given @dram_range, check if @sys_addr falls within it. */
-static int f10_match_to_this_node(struct amd64_pvt *pvt, int range,
+static int f1x_match_to_this_node(struct amd64_pvt *pvt, int range,
 				  u64 sys_addr, int *nid, int *chan_sel)
 {
 	int cs_found = -EINVAL;
@@ -1395,7 +1395,7 @@ static int f10_match_to_this_node(struct amd64_pvt *pvt, int range,
 		return -EINVAL;
 	}
 
-	sys_addr = f10_swap_interleaved_region(pvt, sys_addr);
+	sys_addr = f1x_swap_interleaved_region(pvt, sys_addr);
 
 	dct_sel_base = dct_sel_baseaddr(pvt);
 
@@ -1408,9 +1408,9 @@ static int f10_match_to_this_node(struct amd64_pvt *pvt, int range,
 	   ((sys_addr >> 27) >= (dct_sel_base >> 11)))
 		high_range = true;
 
-	channel = f10_determine_channel(pvt, sys_addr, high_range, intlv_en);
+	channel = f1x_determine_channel(pvt, sys_addr, high_range, intlv_en);
 
-	chan_addr = f10_get_norm_dct_addr(pvt, range, sys_addr,
+	chan_addr = f1x_get_norm_dct_addr(pvt, range, sys_addr,
 					  high_range, dct_sel_base);
 
 	/* Remove node interleaving, see F1x120 */
@@ -1440,7 +1440,7 @@ static int f10_match_to_this_node(struct amd64_pvt *pvt, int range,
 
 	debugf1("   Normalized DCT addr: 0x%llx\n", chan_addr);
 
-	cs_found = f10_lookup_addr_in_dct(chan_addr, node_id, channel);
+	cs_found = f1x_lookup_addr_in_dct(chan_addr, node_id, channel);
 
 	if (cs_found >= 0) {
 		*nid = node_id;
@@ -1449,7 +1449,7 @@ static int f10_match_to_this_node(struct amd64_pvt *pvt, int range,
 	return cs_found;
 }
 
-static int f10_translate_sysaddr_to_cs(struct amd64_pvt *pvt, u64 sys_addr,
+static int f1x_translate_sysaddr_to_cs(struct amd64_pvt *pvt, u64 sys_addr,
 				       int *node, int *chan_sel)
 {
 	int range, cs_found = -EINVAL;
@@ -1462,7 +1462,7 @@ static int f10_translate_sysaddr_to_cs(struct amd64_pvt *pvt, u64 sys_addr,
 		if ((get_dram_base(pvt, range)  <= sys_addr) &&
 		    (get_dram_limit(pvt, range) >= sys_addr)) {
 
-			cs_found = f10_match_to_this_node(pvt, range,
+			cs_found = f1x_match_to_this_node(pvt, range,
 							  sys_addr, node,
 							  chan_sel);
 			if (cs_found >= 0)
@@ -1479,14 +1479,14 @@ static int f10_translate_sysaddr_to_cs(struct amd64_pvt *pvt, u64 sys_addr,
  * The @sys_addr is usually an error address received from the hardware
  * (MCX_ADDR).
  */
-static void f10_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
+static void f1x_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 				     u16 syndrome)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
 	u32 page, offset;
 	int nid, csrow, chan = 0;
 
-	csrow = f10_translate_sysaddr_to_cs(pvt, sys_addr, &nid, &chan);
+	csrow = f1x_translate_sysaddr_to_cs(pvt, sys_addr, &nid, &chan);
 
 	if (csrow < 0) {
 		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
@@ -1580,7 +1580,7 @@ static struct amd64_family_type amd64_family_types[] = {
 		.ops = {
 			.early_channel_count	= f1x_early_channel_count,
 			.read_dram_ctl_register	= f10_read_dram_ctl_register,
-			.map_sysaddr_to_csrow	= f10_map_sysaddr_to_csrow,
+			.map_sysaddr_to_csrow	= f1x_map_sysaddr_to_csrow,
 			.dbam_to_cs		= f10_dbam_to_chip_select,
 			.read_dct_pci_cfg	= f10_read_dct_pci_cfg,
 		}
@@ -1589,6 +1589,7 @@ static struct amd64_family_type amd64_family_types[] = {
 		.ctl_name = "F15h",
 		.ops = {
 			.early_channel_count	= f1x_early_channel_count,
+			.map_sysaddr_to_csrow	= f1x_map_sysaddr_to_csrow,
 			.read_dct_pci_cfg	= f15_read_dct_pci_cfg,
 		}
 	},
-- 
1.7.4.rc2


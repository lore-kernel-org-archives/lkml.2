Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab1BJRVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:21:11 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44607 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712Ab1BJRPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:15:34 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 08/30] amd64_edac: Replace huge bitmasks with a macro
Date: Thu, 10 Feb 2011 18:15:11 +0100
Message-Id: <1297358133-14320-9-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Replace hard to read hex constants with a continuous masks macro.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 32e3231..aed7f7b 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -570,7 +570,7 @@ static u64 sys_addr_to_dram_addr(struct mem_ctl_info *mci, u64 sys_addr)
 	 * section 3.4.2 of AMD publication 24592: AMD x86-64 Architecture
 	 * Programmer's Manual Volume 1 Application Programming.
 	 */
-	dram_addr = (sys_addr & 0xffffffffffull) - dram_base;
+	dram_addr = (sys_addr & GENMASK(0, 39)) - dram_base;
 
 	debugf2("using DRAM Base register to translate SysAddr 0x%lx to "
 		"DramAddr 0x%lx\n", (unsigned long)sys_addr,
@@ -607,8 +607,8 @@ static u64 dram_addr_to_input_addr(struct mem_ctl_info *mci, u64 dram_addr)
 	 * concerning translating a DramAddr to an InputAddr.
 	 */
 	intlv_shift = num_node_interleave_bits(dram_intlv_en(pvt, 0));
-	input_addr = ((dram_addr >> intlv_shift) & 0xffffff000ull) +
-	    (dram_addr & 0xfff);
+	input_addr = ((dram_addr >> intlv_shift) & GENMASK(12, 35)) +
+		      (dram_addr & 0xfff);
 
 	debugf2("  Intlv Shift=%d DramAddr=0x%lx maps to InputAddr=0x%lx\n",
 		intlv_shift, (unsigned long)dram_addr,
@@ -667,8 +667,8 @@ static u64 input_addr_to_dram_addr(struct mem_ctl_info *mci, u64 input_addr)
 		return input_addr;
 	}
 
-	bits = ((input_addr & 0xffffff000ull) << intlv_shift) +
-	    (input_addr & 0xfff);
+	bits = ((input_addr & GENMASK(12, 35)) << intlv_shift) +
+		(input_addr & 0xfff);
 
 	intlv_sel = dram_intlv_sel(pvt, node_id) & ((1 << intlv_shift) - 1);
 	dram_addr = bits + (intlv_sel << 12);
@@ -1399,21 +1399,20 @@ static int f10_match_to_this_node(struct amd64_pvt *pvt, int range,
 	chan_addr = f10_get_norm_dct_addr(pvt, range, sys_addr,
 					  high_range, dct_sel_base);
 
-	/* remove Node ID (in case of memory interleaving) */
+	/* remove Node ID (in case of node interleaving) */
 	tmp = chan_addr & 0xFC0;
 
-	chan_addr = ((chan_addr >> hweight8(intlv_en)) & 0xFFFFFFFFF000ULL) | tmp;
+	chan_addr = ((chan_addr >> hweight8(intlv_en)) & GENMASK(12, 47)) | tmp;
 
 	/* remove channel interleave and hash */
 	if (dct_interleave_enabled(pvt) &&
 	   !dct_high_range_enabled(pvt) &&
 	   !dct_ganging_enabled(pvt)) {
 		if (dct_sel_interleave_addr(pvt) != 1)
-			chan_addr = (chan_addr >> 1) & 0xFFFFFFFFFFFFFFC0ULL;
+			chan_addr = (chan_addr >> 1) & GENMASK(6, 63);
 		else {
 			tmp = chan_addr & 0xFC0;
-			chan_addr = ((chan_addr & 0xFFFFFFFFFFFFC000ULL) >> 1)
-					| tmp;
+			chan_addr = ((chan_addr & GENMASK(14, 63)) >> 1) | tmp;
 		}
 	}
 
-- 
1.7.4.rc2


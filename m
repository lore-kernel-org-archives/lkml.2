Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab1BJRPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:15:46 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44624 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699Ab1BJRPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:15:41 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 11/30] amd64_edac: Cleanup DCT Select Low/High code
Date: Thu, 10 Feb 2011 18:15:14 +0100
Message-Id: <1297358133-14320-12-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Shorten macro names, remove family name from macros, fix macro
arguments, shorten debug strings.

No functionality change.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   20 ++++++++++----------
 drivers/edac/amd64_edac.h |   24 ++++++++++++------------
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 079f5b8..495b4d5 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1148,11 +1148,11 @@ static u64 f10_get_error_address(struct mem_ctl_info *mci,
 static void f10_read_dram_ctl_register(struct amd64_pvt *pvt)
 {
 
-	if (!amd64_read_dct_pci_cfg(pvt, F10_DCTL_SEL_LOW, &pvt->dct_sel_low)) {
-		debugf0("F2x110 (DCTL Sel. Low): 0x%08x, High range addrs at: 0x%x\n",
-			pvt->dct_sel_low, dct_sel_baseaddr(pvt));
+	if (!amd64_read_dct_pci_cfg(pvt, DCT_SEL_LO, &pvt->dct_sel_lo)) {
+		debugf0("F2x110 (DCTSelLow): 0x%08x, High range addrs at: 0x%x\n",
+			pvt->dct_sel_lo, dct_sel_baseaddr(pvt));
 
-		debugf0("  DCT mode: %s, All DCTs on: %s\n",
+		debugf0("  mode: %s, All DCTs on: %s\n",
 			(dct_ganging_enabled(pvt) ? "ganged" : "unganged"),
 			(dct_dram_enabled(pvt) ? "yes"   : "no"));
 
@@ -1160,18 +1160,18 @@ static void f10_read_dram_ctl_register(struct amd64_pvt *pvt)
 			debugf0("  Address range split per DCT: %s\n",
 				(dct_high_range_enabled(pvt) ? "yes" : "no"));
 
-		debugf0("  DCT data interleave for ECC: %s, "
+		debugf0("  data interleave for ECC: %s, "
 			"DRAM cleared since last warm reset: %s\n",
 			(dct_data_intlv_enabled(pvt) ? "enabled" : "disabled"),
 			(dct_memory_cleared(pvt) ? "yes" : "no"));
 
-		debugf0("  DCT channel interleave: %s, "
-			"DCT interleave bits selector: 0x%x\n",
+		debugf0("  channel interleave: %s, "
+			"interleave bits selector: 0x%x\n",
 			(dct_interleave_enabled(pvt) ? "enabled" : "disabled"),
 			dct_sel_interleave_addr(pvt));
 	}
 
-	amd64_read_dct_pci_cfg(pvt, F10_DCTL_SEL_HIGH, &pvt->dct_sel_hi);
+	amd64_read_dct_pci_cfg(pvt, DCT_SEL_HI, &pvt->dct_sel_hi);
 }
 
 /*
@@ -1181,7 +1181,7 @@ static void f10_read_dram_ctl_register(struct amd64_pvt *pvt)
 static u8 f10_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
 				bool hi_range_sel, u8 intlv_en)
 {
-	u32 dct_sel_high = (pvt->dct_sel_low >> 1) & 1;
+	u32 dct_sel_high = (pvt->dct_sel_lo >> 1) & 1;
 
 	if (dct_ganging_enabled(pvt))
 		return 0;
@@ -1955,7 +1955,7 @@ static void read_mc_regs(struct amd64_pvt *pvt)
 	amd64_read_dct_pci_cfg(pvt, DCLR0, &pvt->dclr0);
 	amd64_read_dct_pci_cfg(pvt, DCHR0, &pvt->dchr0);
 
-	if (!dct_ganging_enabled(pvt) && boot_cpu_data.x86 > 0xf) {
+	if (!dct_ganging_enabled(pvt)) {
 		amd64_read_dct_pci_cfg(pvt, DCLR1, &pvt->dclr1);
 		amd64_read_dct_pci_cfg(pvt, DCHR1, &pvt->dchr1);
 	}
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 7323f1b..0244c61 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -227,19 +227,19 @@
 #define DCHR1				0x194
 #define DDR3_MODE			BIT(8)
 
-#define F10_DCTL_SEL_LOW		0x110
-#define dct_sel_baseaddr(pvt)		((pvt->dct_sel_low) & 0xFFFFF800)
-#define dct_sel_interleave_addr(pvt)	(((pvt->dct_sel_low) >> 6) & 0x3)
-#define dct_high_range_enabled(pvt)	(pvt->dct_sel_low & BIT(0))
-#define dct_interleave_enabled(pvt)	(pvt->dct_sel_low & BIT(2))
+#define DCT_SEL_LO			0x110
+#define dct_sel_baseaddr(pvt)		((pvt)->dct_sel_lo & 0xFFFFF800)
+#define dct_sel_interleave_addr(pvt)	(((pvt)->dct_sel_lo >> 6) & 0x3)
+#define dct_high_range_enabled(pvt)	((pvt)->dct_sel_lo & BIT(0))
+#define dct_interleave_enabled(pvt)	((pvt)->dct_sel_lo & BIT(2))
 
-#define dct_ganging_enabled(pvt)	((boot_cpu_data.x86 == 0x10) && ((pvt)->dct_sel_low & BIT(4)))
+#define dct_ganging_enabled(pvt)	((boot_cpu_data.x86 == 0x10) && ((pvt)->dct_sel_lo & BIT(4)))
 
-#define dct_data_intlv_enabled(pvt)	(pvt->dct_sel_low & BIT(5))
-#define dct_dram_enabled(pvt)		(pvt->dct_sel_low & BIT(8))
-#define dct_memory_cleared(pvt)		(pvt->dct_sel_low & BIT(10))
+#define dct_data_intlv_enabled(pvt)	((pvt)->dct_sel_lo & BIT(5))
+#define dct_dram_enabled(pvt)		((pvt)->dct_sel_lo & BIT(8))
+#define dct_memory_cleared(pvt)		((pvt)->dct_sel_lo & BIT(10))
 
-#define F10_DCTL_SEL_HIGH		0x114
+#define DCT_SEL_HI			0x114
 
 /*
  * Function 3 - Misc Control
@@ -419,8 +419,8 @@ struct amd64_pvt {
 	u64 top_mem;		/* top of memory below 4GB */
 	u64 top_mem2;		/* top of memory above 4GB */
 
-	u32 dct_sel_low;	/* DRAM Controller Select Low Reg */
-	u32 dct_sel_hi;		/* DRAM Controller Select High Reg */
+	u32 dct_sel_lo;		/* DRAM Controller Select Low */
+	u32 dct_sel_hi;		/* DRAM Controller Select High */
 	u32 online_spare;	/* On-Line spare Reg */
 
 	/* x4 or x8 syndromes in use */
-- 
1.7.4.rc2


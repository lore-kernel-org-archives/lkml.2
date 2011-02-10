Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab1BJRUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:20:39 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44617 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724Ab1BJRPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:15:38 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 10/30] amd64_edac: Cleanup Dram Configuration registers handling
Date: Thu, 10 Feb 2011 18:15:13 +0100
Message-Id: <1297358133-14320-11-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

* Restrict DCT ganged mode check since only Fam10h supports it
* Adjust DRAM type detection for BD since it only supports DDR3
* Remove second and thus unneeded DCLR read in k8_early_channel_count() - we do
  that in read_mc_regs()
* Cleanup comments and remove family names from register macros
* Remove unused defines

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   42 +++++++++++++++++-------------------------
 drivers/edac/amd64_edac.h |   19 +++++++------------
 2 files changed, 24 insertions(+), 37 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 9fd3c2d..079f5b8 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -799,7 +799,7 @@ static u16 extract_syndrome(struct err_regs *err)
  */
 static enum edac_type amd64_determine_edac_cap(struct amd64_pvt *pvt)
 {
-	int bit;
+	u8 bit;
 	enum dev_type edac_cap = EDAC_FLAG_NONE;
 
 	bit = (boot_cpu_data.x86 > 0xf || pvt->ext_model >= K8_REV_F)
@@ -826,8 +826,9 @@ static void amd64_dump_dramcfg_low(u32 dclr, int chan)
 	debugf1("  PAR/ERR parity: %s\n",
 		(dclr & BIT(8)) ?  "enabled" : "disabled");
 
-	debugf1("  DCT 128bit mode width: %s\n",
-		(dclr & BIT(11)) ?  "128b" : "64b");
+	if (boot_cpu_data.x86 == 0x10)
+		debugf1("  DCT 128bit mode width: %s\n",
+			(dclr & BIT(11)) ?  "128b" : "64b");
 
 	debugf1("  x4 logical DIMMs present: L0: %s L1: %s L2: %s L3: %s\n",
 		(dclr & BIT(12)) ?  "yes" : "no",
@@ -939,7 +940,10 @@ static enum mem_type amd64_determine_memory_type(struct amd64_pvt *pvt, int cs)
 {
 	enum mem_type type;
 
-	if (boot_cpu_data.x86 >= 0x10 || pvt->ext_model >= K8_REV_F) {
+	/* F15h supports only DDR3 */
+	if (boot_cpu_data.x86 >= 0x15)
+		type = (pvt->dclr0 & BIT(16)) ?	MEM_DDR3 : MEM_RDDR3;
+	else if (boot_cpu_data.x86 == 0x10 || pvt->ext_model >= K8_REV_F) {
 		if (pvt->dchr0 & DDR3_MODE)
 			type = (pvt->dclr0 & BIT(16)) ?	MEM_DDR3 : MEM_RDDR3;
 		else
@@ -953,22 +957,10 @@ static enum mem_type amd64_determine_memory_type(struct amd64_pvt *pvt, int cs)
 	return type;
 }
 
-/*
- * Read the DRAM Configuration Low register. It differs between CG, D & E revs
- * and the later RevF memory controllers (DDR vs DDR2)
- *
- * Return:
- *      number of memory channels in operation
- * Pass back:
- *      contents of the DCL0_LOW register
- */
+/* Get the number of DCT channels the memory controller is using. */
 static int k8_early_channel_count(struct amd64_pvt *pvt)
 {
-	int flag, err = 0;
-
-	err = amd64_read_dct_pci_cfg(pvt, F10_DCLR_0, &pvt->dclr0);
-	if (err)
-		return err;
+	int flag;
 
 	if (pvt->ext_model >= K8_REV_F)
 		/* RevF (NPT) and later */
@@ -983,7 +975,7 @@ static int k8_early_channel_count(struct amd64_pvt *pvt)
 	return (flag) ? 2 : 1;
 }
 
-/* extract the ERROR ADDRESS for the K8 CPUs */
+/* Extract the ERROR ADDRESS for the K8 CPUs */
 static u64 k8_get_error_address(struct mem_ctl_info *mci,
 				struct err_regs *info)
 {
@@ -1486,7 +1478,7 @@ static void f10_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
 
 /*
  * debug routine to display the memory sizes of all logical DIMMs and its
- * CSROWs as well
+ * CSROWs
  */
 static void amd64_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt)
 {
@@ -1960,12 +1952,12 @@ static void read_mc_regs(struct amd64_pvt *pvt)
 
 	amd64_read_pci_cfg(pvt->F3, F10_ONLINE_SPARE, &pvt->online_spare);
 
-	amd64_read_dct_pci_cfg(pvt, F10_DCLR_0, &pvt->dclr0);
-	amd64_read_dct_pci_cfg(pvt, F10_DCHR_0, &pvt->dchr0);
+	amd64_read_dct_pci_cfg(pvt, DCLR0, &pvt->dclr0);
+	amd64_read_dct_pci_cfg(pvt, DCHR0, &pvt->dchr0);
 
-	if (!dct_ganging_enabled(pvt)) {
-		amd64_read_dct_pci_cfg(pvt, F10_DCLR_1, &pvt->dclr1);
-		amd64_read_dct_pci_cfg(pvt, F10_DCHR_1, &pvt->dchr1);
+	if (!dct_ganging_enabled(pvt) && boot_cpu_data.x86 > 0xf) {
+		amd64_read_dct_pci_cfg(pvt, DCLR1, &pvt->dclr1);
+		amd64_read_dct_pci_cfg(pvt, DCHR1, &pvt->dchr1);
 	}
 
 	if (boot_cpu_data.x86 >= 0x10) {
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index ba18183..7323f1b 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -218,27 +218,23 @@
 
 #define DBAM_MAX_VALUE			11
 
-
-#define F10_DCLR_0			0x90
-#define F10_DCLR_1			0x190
+#define DCLR0				0x90
+#define DCLR1				0x190
 #define REVE_WIDTH_128			BIT(16)
 #define F10_WIDTH_128			BIT(11)
 
-
-#define F10_DCHR_0			0x94
-#define F10_DCHR_1			0x194
-
-#define F10_DCHR_FOUR_RANK_DIMM		BIT(18)
+#define DCHR0				0x94
+#define DCHR1				0x194
 #define DDR3_MODE			BIT(8)
-#define F10_DCHR_MblMode		BIT(6)
-
 
 #define F10_DCTL_SEL_LOW		0x110
 #define dct_sel_baseaddr(pvt)		((pvt->dct_sel_low) & 0xFFFFF800)
 #define dct_sel_interleave_addr(pvt)	(((pvt->dct_sel_low) >> 6) & 0x3)
 #define dct_high_range_enabled(pvt)	(pvt->dct_sel_low & BIT(0))
 #define dct_interleave_enabled(pvt)	(pvt->dct_sel_low & BIT(2))
-#define dct_ganging_enabled(pvt)	(pvt->dct_sel_low & BIT(4))
+
+#define dct_ganging_enabled(pvt)	((boot_cpu_data.x86 == 0x10) && ((pvt)->dct_sel_low & BIT(4)))
+
 #define dct_data_intlv_enabled(pvt)	(pvt->dct_sel_low & BIT(5))
 #define dct_dram_enabled(pvt)		(pvt->dct_sel_low & BIT(8))
 #define dct_memory_cleared(pvt)		(pvt->dct_sel_low & BIT(10))
@@ -262,7 +258,6 @@
 
 #define K8_NBSL				0x48
 
-
 /* Family F10h: Normalized Extended Error Codes */
 #define F10_NBSL_EXT_ERR_RES		0x0
 #define F10_NBSL_EXT_ERR_ECC		0x8
-- 
1.7.4.rc2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab1BJRQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:16:12 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44675 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180Ab1BJRQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:16:06 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 26/30] amd64_edac: Improve DRAM address mapping
Date: Thu, 10 Feb 2011 18:15:29 +0100
Message-Id: <1297358133-14320-27-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Drop static tables which map the bits in F2x80 to a chip select size in
favor of functions doing the mapping with some bit fiddling. Also, add
F15 support.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |  149 ++++++++++++++++++++++++--------------------
 drivers/edac/amd64_edac.h |    4 +-
 2 files changed, 83 insertions(+), 70 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index b85487d..eb6b6ba 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -25,59 +25,12 @@ static struct mem_ctl_info **mcis;
 static struct ecc_settings **ecc_stngs;
 
 /*
- * Address to DRAM bank mapping: see F2x80 for K8 and F2x[1,0]80 for Fam10 and
- * later.
- */
-static int ddr2_dbam_revCG[] = {
-			   [0]		= 32,
-			   [1]		= 64,
-			   [2]		= 128,
-			   [3]		= 256,
-			   [4]		= 512,
-			   [5]		= 1024,
-			   [6]		= 2048,
-};
-
-static int ddr2_dbam_revD[] = {
-			   [0]		= 32,
-			   [1]		= 64,
-			   [2 ... 3]	= 128,
-			   [4]		= 256,
-			   [5]		= 512,
-			   [6]		= 256,
-			   [7]		= 512,
-			   [8 ... 9]	= 1024,
-			   [10]		= 2048,
-};
-
-static int ddr2_dbam[] = { [0]		= 128,
-			   [1]		= 256,
-			   [2 ... 4]	= 512,
-			   [5 ... 6]	= 1024,
-			   [7 ... 8]	= 2048,
-			   [9 ... 10]	= 4096,
-			   [11]		= 8192,
-};
-
-static int ddr3_dbam[] = { [0]		= -1,
-			   [1]		= 256,
-			   [2]		= 512,
-			   [3 ... 4]	= -1,
-			   [5 ... 6]	= 1024,
-			   [7 ... 8]	= 2048,
-			   [9 ... 10]	= 4096,
-			   [11]		= 8192,
-};
-
-/*
  * Valid scrub rates for the K8 hardware memory scrubber. We map the scrubbing
  * bandwidth to a valid bit pattern. The 'set' operation finds the 'matching-
  * or higher value'.
  *
  *FIXME: Produce a better mapping/linearisation.
  */
-
-
 struct scrubrate {
        u32 scrubval;           /* bit pattern for scrub rate */
        u32 bandwidth;          /* bandwidth consumed (bytes/sec) */
@@ -962,7 +915,7 @@ static int k8_early_channel_count(struct amd64_pvt *pvt)
 
 	if (pvt->ext_model >= K8_REV_F)
 		/* RevF (NPT) and later */
-		flag = pvt->dclr0 & F10_WIDTH_128;
+		flag = pvt->dclr0 & WIDTH_128;
 	else
 		/* RevE and earlier */
 		flag = pvt->dclr0 & REVE_WIDTH_128;
@@ -1062,18 +1015,41 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 	}
 }
 
-static int k8_dbam_to_chip_select(struct amd64_pvt *pvt, int cs_mode)
+static int ddr2_cs_size(unsigned i, bool dct_width)
 {
-	int *dbam_map;
+	unsigned shift = 0;
 
-	if (pvt->ext_model >= K8_REV_F)
-		dbam_map = ddr2_dbam;
-	else if (pvt->ext_model >= K8_REV_D)
-		dbam_map = ddr2_dbam_revD;
+	if (i <= 2)
+		shift = i;
+	else if (!(i & 0x1))
+		shift = i >> 1;
 	else
-		dbam_map = ddr2_dbam_revCG;
+		shift = (i + 1) >> 1;
+
+	return 128 << (shift + !!dct_width);
+}
+
+static int k8_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
+				  unsigned cs_mode)
+{
+	u32 dclr = dct ? pvt->dclr1 : pvt->dclr0;
+
+	if (pvt->ext_model >= K8_REV_F) {
+		WARN_ON(cs_mode > 11);
+		return ddr2_cs_size(cs_mode, dclr & WIDTH_128);
+	}
+	else if (pvt->ext_model >= K8_REV_D) {
+		WARN_ON(cs_mode > 10);
 
-	return dbam_map[cs_mode];
+		if (cs_mode == 3 || cs_mode == 8)
+			return 32 << (cs_mode - 1);
+		else
+			return 32 << cs_mode;
+	}
+	else {
+		WARN_ON(cs_mode > 6);
+		return 32 << cs_mode;
+	}
 }
 
 /*
@@ -1089,7 +1065,7 @@ static int f1x_early_channel_count(struct amd64_pvt *pvt)
 	int i, j, channels = 0;
 
 	/* On F10h, if we are in 128 bit mode, then we are using 2 channels */
-	if (boot_cpu_data.x86 == 0x10 && (pvt->dclr0 & F10_WIDTH_128))
+	if (boot_cpu_data.x86 == 0x10 && (pvt->dclr0 & WIDTH_128))
 		return 2;
 
 	/*
@@ -1126,16 +1102,50 @@ static int f1x_early_channel_count(struct amd64_pvt *pvt)
 	return channels;
 }
 
-static int f10_dbam_to_chip_select(struct amd64_pvt *pvt, int cs_mode)
+static int ddr3_cs_size(unsigned i, bool dct_width)
+{
+	unsigned shift = 0;
+	int cs_size = 0;
+
+	if (i == 0 || i == 3 || i == 4)
+		cs_size = -1;
+	else if (i <= 2)
+		shift = i;
+	else if (i == 12)
+		shift = 7;
+	else if (!(i & 0x1))
+		shift = i >> 1;
+	else
+		shift = (i + 1) >> 1;
+
+	if (cs_size != -1)
+		cs_size = (128 * (1 << !!dct_width)) << shift;
+
+	return cs_size;
+}
+
+static int f10_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
+				   unsigned cs_mode)
 {
-	int *dbam_map;
+	u32 dclr = dct ? pvt->dclr1 : pvt->dclr0;
+
+	WARN_ON(cs_mode > 11);
 
 	if (pvt->dchr0 & DDR3_MODE || pvt->dchr1 & DDR3_MODE)
-		dbam_map = ddr3_dbam;
+		return ddr3_cs_size(cs_mode, dclr & WIDTH_128);
 	else
-		dbam_map = ddr2_dbam;
+		return ddr2_cs_size(cs_mode, dclr & WIDTH_128);
+}
+
+/*
+ * F15h supports only 64bit DCT interfaces
+ */
+static int f15_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
+				   unsigned cs_mode)
+{
+	WARN_ON(cs_mode > 12);
 
-	return dbam_map[cs_mode];
+	return ddr3_cs_size(cs_mode, false);
 }
 
 static void read_dram_ctl_register(struct amd64_pvt *pvt)
@@ -1528,7 +1538,7 @@ static void amd64_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt)
 	u32 dbam  = ctrl ? pvt->dbam1 : pvt->dbam0;
 
 	if (boot_cpu_data.x86 == 0xf) {
-		if (pvt->dclr0 & F10_WIDTH_128)
+		if (pvt->dclr0 & WIDTH_128)
 			factor = 1;
 
 		/* K8 families < revF not supported yet */
@@ -1551,11 +1561,13 @@ static void amd64_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt)
 
 		size0 = 0;
 		if (dcsb[dimm*2] & DCSB_CS_ENABLE)
-			size0 = pvt->ops->dbam_to_cs(pvt, DBAM_DIMM(dimm, dbam));
+			size0 = pvt->ops->dbam_to_cs(pvt, ctrl,
+						     DBAM_DIMM(dimm, dbam));
 
 		size1 = 0;
 		if (dcsb[dimm*2 + 1] & DCSB_CS_ENABLE)
-			size1 = pvt->ops->dbam_to_cs(pvt, DBAM_DIMM(dimm, dbam));
+			size1 = pvt->ops->dbam_to_cs(pvt, ctrl,
+						     DBAM_DIMM(dimm, dbam));
 
 		amd64_info(EDAC_MC ": %d: %5dMB %d: %5dMB\n",
 				dimm * 2,     size0 << factor,
@@ -1591,6 +1603,7 @@ static struct amd64_family_type amd64_family_types[] = {
 		.ops = {
 			.early_channel_count	= f1x_early_channel_count,
 			.map_sysaddr_to_csrow	= f1x_map_sysaddr_to_csrow,
+			.dbam_to_cs		= f15_dbam_to_chip_select,
 			.read_dct_pci_cfg	= f15_read_dct_pci_cfg,
 		}
 	},
@@ -2030,7 +2043,7 @@ static void read_mc_regs(struct amd64_pvt *pvt)
  *	encompasses
  *
  */
-static u32 amd64_csrow_nr_pages(int csrow_nr, struct amd64_pvt *pvt)
+static u32 amd64_csrow_nr_pages(struct amd64_pvt *pvt, u8 dct, int csrow_nr)
 {
 	u32 cs_mode, nr_pages;
 
@@ -2043,7 +2056,7 @@ static u32 amd64_csrow_nr_pages(int csrow_nr, struct amd64_pvt *pvt)
 	 */
 	cs_mode = (pvt->dbam0 >> ((csrow_nr / 2) * 4)) & 0xF;
 
-	nr_pages = pvt->ops->dbam_to_cs(pvt, cs_mode) << (20 - PAGE_SHIFT);
+	nr_pages = pvt->ops->dbam_to_cs(pvt, dct, cs_mode) << (20 - PAGE_SHIFT);
 
 	/*
 	 * If dual channel then double the memory size of single channel.
@@ -2091,7 +2104,7 @@ static int init_csrows(struct mem_ctl_info *mci)
 			i, pvt->mc_node_id);
 
 		empty = 0;
-		csrow->nr_pages = amd64_csrow_nr_pages(i, pvt);
+		csrow->nr_pages = amd64_csrow_nr_pages(pvt, 0, i);
 		find_csrow_limits(mci, i, &input_addr_min, &input_addr_max);
 		sys_addr = input_addr_to_sys_addr(mci, input_addr_min);
 		csrow->first_page = (u32) (sys_addr >> PAGE_SHIFT);
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index e14a8d0..8e431ab 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -221,7 +221,7 @@
 #define DCLR0				0x90
 #define DCLR1				0x190
 #define REVE_WIDTH_128			BIT(16)
-#define F10_WIDTH_128			BIT(11)
+#define WIDTH_128			BIT(11)
 
 #define DCHR0				0x94
 #define DCHR1				0x194
@@ -445,7 +445,7 @@ struct low_ops {
 	int (*early_channel_count)	(struct amd64_pvt *pvt);
 	void (*map_sysaddr_to_csrow)	(struct mem_ctl_info *mci, u64 sys_addr,
 					 u16 syndrome);
-	int (*dbam_to_cs)		(struct amd64_pvt *pvt, int cs_mode);
+	int (*dbam_to_cs)		(struct amd64_pvt *pvt, u8 dct, unsigned cs_mode);
 	int (*read_dct_pci_cfg)		(struct amd64_pvt *pvt, int offset,
 					 u32 *val, const char *func);
 };
-- 
1.7.4.rc2


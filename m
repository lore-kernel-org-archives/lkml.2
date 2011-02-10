Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab1BJRUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:20:51 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44614 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647Ab1BJRPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:15:38 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 09/30] amd64_edac: Cleanup DBAM handling
Date: Thu, 10 Feb 2011 18:15:12 +0100
Message-Id: <1297358133-14320-10-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Do not read DBAM regs twice and simplify code around them.

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   27 ++++++++-------------------
 1 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index aed7f7b..9fd3c2d 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -875,12 +875,6 @@ static void dump_misc_regs(struct amd64_pvt *pvt)
 		amd64_dump_dramcfg_low(pvt->dclr1, 1);
 }
 
-static void amd64_read_dbam_reg(struct amd64_pvt *pvt)
-{
-	amd64_read_dct_pci_cfg(pvt, DBAM0, &pvt->dbam0);
-	amd64_read_dct_pci_cfg(pvt, DBAM1, &pvt->dbam1);
-}
-
 /*
  * see BKDG, F2x[1,0][5C:40], F2[1,0][6C:60]
  */
@@ -1098,9 +1092,7 @@ static int k8_dbam_to_chip_select(struct amd64_pvt *pvt, int cs_mode)
  */
 static int f10_early_channel_count(struct amd64_pvt *pvt)
 {
-	int dbams[] = { DBAM0, DBAM1 };
 	int i, j, channels = 0;
-	u32 dbam;
 
 	/* If we are in 128 bit mode, then we are using 2 channels */
 	if (pvt->dclr0 & F10_WIDTH_128) {
@@ -1123,9 +1115,8 @@ static int f10_early_channel_count(struct amd64_pvt *pvt)
 	 * is more than just one DIMM present in unganged mode. Need to check
 	 * both controllers since DIMMs can be placed in either one.
 	 */
-	for (i = 0; i < ARRAY_SIZE(dbams); i++) {
-		if (amd64_read_dct_pci_cfg(pvt, dbams[i], &dbam))
-			goto err_reg;
+	for (i = 0; i < 2; i++) {
+		u32 dbam = (i ? pvt->dbam1 : pvt->dbam0);
 
 		for (j = 0; j < 4; j++) {
 			if (DBAM_DIMM(j, dbam) > 0) {
@@ -1141,10 +1132,6 @@ static int f10_early_channel_count(struct amd64_pvt *pvt)
 	amd64_info("MCT channel count: %d\n", channels);
 
 	return channels;
-
-err_reg:
-	return -1;
-
 }
 
 static int f10_dbam_to_chip_select(struct amd64_pvt *pvt, int cs_mode)
@@ -1504,8 +1491,8 @@ static void f10_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
 static void amd64_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt)
 {
 	int dimm, size0, size1, factor = 0;
-	u32 dbam;
-	u32 *dcsb;
+	u32 *dcsb = ctrl ? pvt->csels[1].csbases : pvt->csels[0].csbases;
+	u32 dbam  = ctrl ? pvt->dbam1 : pvt->dbam0;
 
 	if (boot_cpu_data.x86 == 0xf) {
 		if (pvt->dclr0 & F10_WIDTH_128)
@@ -1969,7 +1956,7 @@ static void read_mc_regs(struct amd64_pvt *pvt)
 	read_dct_base_mask(pvt);
 
 	amd64_read_pci_cfg(pvt->F1, DHAR, &pvt->dhar);
-	amd64_read_dbam_reg(pvt);
+	amd64_read_dct_pci_cfg(pvt, DBAM0, &pvt->dbam0);
 
 	amd64_read_pci_cfg(pvt->F3, F10_ONLINE_SPARE, &pvt->online_spare);
 
@@ -1981,8 +1968,10 @@ static void read_mc_regs(struct amd64_pvt *pvt)
 		amd64_read_dct_pci_cfg(pvt, F10_DCHR_1, &pvt->dchr1);
 	}
 
-	if (boot_cpu_data.x86 >= 0x10)
+	if (boot_cpu_data.x86 >= 0x10) {
 		amd64_read_pci_cfg(pvt->F3, EXT_NB_MCA_CFG, &tmp);
+		amd64_read_dct_pci_cfg(pvt, DBAM1, &pvt->dbam1);
+	}
 
 	if (boot_cpu_data.x86 == 0x10 &&
 	    boot_cpu_data.x86_model > 7 &&
-- 
1.7.4.rc2


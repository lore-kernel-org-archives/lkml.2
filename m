Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab2FLPg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:36:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab2FLPgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:36:25 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC] edac: edac_mc_handle_error(): add an error_count parameter
Date: Tue, 12 Jun 2012 12:36:18 -0300
Message-Id: <9eb07a7fb8a90ee39fa9d5489afc0330cfcfbea7.1339515354.git.mchehab@redhat.com>
In-Reply-To: <edeab2af6600f88d329a252acf3ffb6630366bb6.1339507096.git.mchehab@redhat.com>
References: <edeab2af6600f88d329a252acf3ffb6630366bb6.1339507096.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to avoid loosing error events, it is desirable to group
error events together and generate a single trace for several identical
errors.

The trace API already allows reporting multiple errors. Change the
handle_error function to also allow that.

The changes at the drivers were made by this small script:

	$file .=$_ while (<>);
	$file =~ s/(edac_mc_handle_error)\s*\(([^\,]+)\,([^\,]+)\,/$1($2,$3, 1,/g;
	print $file;

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---

v2: Patch rename and fix error count increment logic

 drivers/edac/amd64_edac.c      |   22 ++++++++--------
 drivers/edac/amd76x_edac.c     |    4 +--
 drivers/edac/cell_edac.c       |    4 +--
 drivers/edac/cpc925_edac.c     |    4 +--
 drivers/edac/e752x_edac.c      |    8 +++---
 drivers/edac/e7xxx_edac.c      |    8 +++---
 drivers/edac/edac_core.h       |    1 +
 drivers/edac/edac_mc.c         |   56 +++++++++++++++++++++++-----------------
 drivers/edac/edac_mc_sysfs.c   |    2 +-
 drivers/edac/i3000_edac.c      |    6 ++---
 drivers/edac/i3200_edac.c      |    6 ++---
 drivers/edac/i5000_edac.c      |    8 +++---
 drivers/edac/i5100_edac.c      |    4 +--
 drivers/edac/i5400_edac.c      |    4 +--
 drivers/edac/i7300_edac.c      |    4 +--
 drivers/edac/i7core_edac.c     |    4 +--
 drivers/edac/i82443bxgx_edac.c |    4 +--
 drivers/edac/i82860_edac.c     |    6 ++---
 drivers/edac/i82875p_edac.c    |    6 ++---
 drivers/edac/i82975x_edac.c    |    6 ++---
 drivers/edac/mpc85xx_edac.c    |    4 +--
 drivers/edac/mv64x60_edac.c    |    4 +--
 drivers/edac/pasemi_edac.c     |    4 +--
 drivers/edac/ppc4xx_edac.c     |    4 +--
 drivers/edac/r82600_edac.c     |    4 +--
 drivers/edac/sb_edac.c         |    4 +--
 drivers/edac/tile_edac.c       |    2 +-
 drivers/edac/x38_edac.c        |    6 ++---
 28 files changed, 104 insertions(+), 95 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 6231cbe..5a297a2 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1046,7 +1046,7 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 	if (!src_mci) {
 		amd64_mc_err(mci, "failed to map error addr 0x%lx to a node\n",
 			     (unsigned long)sys_addr);
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 				     page, offset, syndrome,
 				     -1, -1, -1,
 				     "failed to map error addr to a node",
@@ -1057,7 +1057,7 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 	/* Now map the sys_addr to a CSROW */
 	csrow = sys_addr_to_csrow(src_mci, sys_addr);
 	if (csrow < 0) {
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 				     page, offset, syndrome,
 				     -1, -1, -1,
 				     "failed to map error addr to a csrow",
@@ -1077,7 +1077,7 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 			amd64_mc_warn(src_mci, "unknown syndrome 0x%04x - "
 				      "possible error reporting race\n",
 				      syndrome);
-			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 					     page, offset, syndrome,
 					     csrow, -1, -1,
 					     "unknown syndrome - possible error reporting race",
@@ -1096,7 +1096,7 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 		channel = ((sys_addr & BIT(3)) != 0);
 	}
 
-	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, src_mci,
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, src_mci, 1,
 			     page, offset, syndrome,
 			     csrow, channel, -1,
 			     "", "");
@@ -1608,7 +1608,7 @@ static void f1x_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 	csrow = f1x_translate_sysaddr_to_cs(pvt, sys_addr, &nid, &chan);
 
 	if (csrow < 0) {
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 				     page, offset, syndrome,
 				     -1, -1, -1,
 				     "failed to map error addr to a csrow",
@@ -1624,7 +1624,7 @@ static void f1x_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 	if (dct_ganging_enabled(pvt))
 		chan = get_channel_from_ecc_syndrome(mci, syndrome);
 
-	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 			     page, offset, syndrome,
 			     csrow, chan, -1,
 			     "", "");
@@ -1909,7 +1909,7 @@ static void amd64_handle_ce(struct mem_ctl_info *mci, struct mce *m)
 	/* Ensure that the Error Address is VALID */
 	if (!(m->status & MCI_STATUS_ADDRV)) {
 		amd64_mc_err(mci, "HW has no ERROR_ADDRESS available\n");
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 				     0, 0, 0,
 				     -1, -1, -1,
 				     "HW has no ERROR_ADDRESS available",
@@ -1937,7 +1937,7 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 
 	if (!(m->status & MCI_STATUS_ADDRV)) {
 		amd64_mc_err(mci, "HW has no ERROR_ADDRESS available\n");
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
 				     0, 0, 0,
 				     -1, -1, -1,
 				     "HW has no ERROR_ADDRESS available",
@@ -1956,7 +1956,7 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 	if (!src_mci) {
 		amd64_mc_err(mci, "ERROR ADDRESS (0x%lx) NOT mapped to a MC\n",
 				  (unsigned long)sys_addr);
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
 				     page, offset, 0,
 				     -1, -1, -1,
 				     "ERROR ADDRESS NOT mapped to a MC",
@@ -1970,13 +1970,13 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 	if (csrow < 0) {
 		amd64_mc_err(mci, "ERROR_ADDRESS (0x%lx) NOT mapped to CS\n",
 				  (unsigned long)sys_addr);
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
 				     page, offset, 0,
 				     -1, -1, -1,
 				     "ERROR ADDRESS NOT mapped to CS",
 				     "");
 	} else {
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
 				     page, offset, 0,
 				     csrow, -1, -1,
 				     "", "");
diff --git a/drivers/edac/amd76x_edac.c b/drivers/edac/amd76x_edac.c
index c7c208e..29eeb68 100644
--- a/drivers/edac/amd76x_edac.c
+++ b/drivers/edac/amd76x_edac.c
@@ -145,7 +145,7 @@ static int amd76x_process_error_info(struct mem_ctl_info *mci,
 
 		if (handle_errors) {
 			row = (info->ecc_mode_status >> 4) & 0xf;
-			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
 					     mci->csrows[row]->first_page, 0, 0,
 					     row, 0, -1,
 					     mci->ctl_name, "");
@@ -160,7 +160,7 @@ static int amd76x_process_error_info(struct mem_ctl_info *mci,
 
 		if (handle_errors) {
 			row = info->ecc_mode_status & 0xf;
-			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 					     mci->csrows[row]->first_page, 0, 0,
 					     row, 0, -1,
 					     mci->ctl_name, "");
diff --git a/drivers/edac/cell_edac.c b/drivers/edac/cell_edac.c
index 165d255..a1bbd8e 100644
--- a/drivers/edac/cell_edac.c
+++ b/drivers/edac/cell_edac.c
@@ -48,7 +48,7 @@ static void cell_edac_count_ce(struct mem_ctl_info *mci, int chan, u64 ar)
 	syndrome = (ar & 0x000000001fe00000ul) >> 21;
 
 	/* TODO: Decoding of the error address */
-	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 			     csrow->first_page + pfn, offset, syndrome,
 			     0, chan, -1, "", "");
 }
@@ -70,7 +70,7 @@ static void cell_edac_count_ue(struct mem_ctl_info *mci, int chan, u64 ar)
 	offset = address & ~PAGE_MASK;
 
 	/* TODO: Decoding of the error address */
-	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
 			     csrow->first_page + pfn, offset, 0,
 			     0, chan, -1, "", "");
 }
diff --git a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
index 32e9c88..c2ef134 100644
--- a/drivers/edac/cpc925_edac.c
+++ b/drivers/edac/cpc925_edac.c
@@ -554,7 +554,7 @@ static void cpc925_mc_check(struct mem_ctl_info *mci)
 	if (apiexcp & CECC_EXCP_DETECTED) {
 		cpc925_mc_printk(mci, KERN_INFO, "DRAM CECC Fault\n");
 		channel = cpc925_mc_find_channel(mci, syndrome);
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 				     pfn, offset, syndrome,
 				     csrow, channel, -1,
 				     mci->ctl_name, "");
@@ -562,7 +562,7 @@ static void cpc925_mc_check(struct mem_ctl_info *mci)
 
 	if (apiexcp & UECC_EXCP_DETECTED) {
 		cpc925_mc_printk(mci, KERN_INFO, "DRAM UECC Fault\n");
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 				     pfn, offset, 0,
 				     csrow, -1, -1,
 				     mci->ctl_name, "");
diff --git a/drivers/edac/e752x_edac.c b/drivers/edac/e752x_edac.c
index b5a8bf1..a5ed6b7 100644
--- a/drivers/edac/e752x_edac.c
+++ b/drivers/edac/e752x_edac.c
@@ -371,7 +371,7 @@ static void do_process_ce(struct mem_ctl_info *mci, u16 error_one,
 	channel = !(error_one & 1);
 
 	/* e752x mc reads 34:6 of the DRAM linear address */
-	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 			     page, offset_in_page(sec1_add << 4), sec1_syndrome,
 			     row, channel, -1,
 			     "e752x CE", "");
@@ -408,7 +408,7 @@ static void do_process_ue(struct mem_ctl_info *mci, u16 error_one,
 			edac_mc_find_csrow_by_page(mci, block_page);
 
 		/* e752x mc reads 34:6 of the DRAM linear address */
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
 					block_page,
 					offset_in_page(error_2b << 4), 0,
 					 row, -1, -1,
@@ -427,7 +427,7 @@ static void do_process_ue(struct mem_ctl_info *mci, u16 error_one,
 			edac_mc_find_csrow_by_page(mci, block_page);
 
 		/* e752x mc reads 34:6 of the DRAM linear address */
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
 					block_page,
 					offset_in_page(error_2b << 4), 0,
 					row, -1, -1,
@@ -454,7 +454,7 @@ static inline void process_ue_no_info_wr(struct mem_ctl_info *mci,
 		return;
 
 	edac_dbg(3, "\n");
-	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1, 0, 0, 0,
 			     -1, -1, -1,
 			     "e752x UE log memory write", "");
 }
diff --git a/drivers/edac/e7xxx_edac.c b/drivers/edac/e7xxx_edac.c
index c26b69e..9ff57f3 100644
--- a/drivers/edac/e7xxx_edac.c
+++ b/drivers/edac/e7xxx_edac.c
@@ -219,14 +219,14 @@ static void process_ce(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
 	row = edac_mc_find_csrow_by_page(mci, page);
 	/* convert syndrome to channel */
 	channel = e7xxx_find_channel(syndrome);
-	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, page, 0, syndrome,
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1, page, 0, syndrome,
 			     row, channel, -1, "e7xxx CE", "");
 }
 
 static void process_ce_no_info(struct mem_ctl_info *mci)
 {
 	edac_dbg(3, "\n");
-	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0, -1, -1, -1,
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1, 0, 0, 0, -1, -1, -1,
 			     "e7xxx CE log register overflow", "");
 }
 
@@ -242,7 +242,7 @@ static void process_ue(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
 	block_page = error_2b >> 6;	/* convert to 4k address */
 	row = edac_mc_find_csrow_by_page(mci, block_page);
 
-	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, block_page, 0, 0,
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1, block_page, 0, 0,
 			     row, -1, -1, "e7xxx UE", "");
 }
 
@@ -250,7 +250,7 @@ static void process_ue_no_info(struct mem_ctl_info *mci)
 {
 	edac_dbg(3, "\n");
 
-	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0, -1, -1, -1,
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1, 0, 0, 0, -1, -1, -1,
 			     "e7xxx UE log register overflow", "");
 }
 
diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index 500ba66..3843222 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -455,6 +455,7 @@ extern int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci,
 				      unsigned long page);
 void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			  struct mem_ctl_info *mci,
+			  const u16 error_count,
 			  const unsigned long page_frame_number,
 			  const unsigned long offset_in_page,
 			  const unsigned long syndrome,
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index fb41e38c..8d59378 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -897,15 +897,16 @@ const char *edac_layer_name[] = {
 EXPORT_SYMBOL_GPL(edac_layer_name);
 
 static void edac_inc_ce_error(struct mem_ctl_info *mci,
-				    bool enable_per_layer_report,
-				    const int pos[EDAC_MAX_LAYERS])
+			      bool enable_per_layer_report,
+			      const int pos[EDAC_MAX_LAYERS],
+			      const u16 count)
 {
 	int i, index = 0;
 
-	mci->ce_mc++;
+	mci->ce_mc += count;
 
 	if (!enable_per_layer_report) {
-		mci->ce_noinfo_count++;
+		mci->ce_noinfo_count += count;
 		return;
 	}
 
@@ -913,7 +914,7 @@ static void edac_inc_ce_error(struct mem_ctl_info *mci,
 		if (pos[i] < 0)
 			break;
 		index += pos[i];
-		mci->ce_per_layer[i][index]++;
+		mci->ce_per_layer[i][index] += count;
 
 		if (i < mci->n_layers - 1)
 			index *= mci->layers[i + 1].size;
@@ -922,14 +923,15 @@ static void edac_inc_ce_error(struct mem_ctl_info *mci,
 
 static void edac_inc_ue_error(struct mem_ctl_info *mci,
 				    bool enable_per_layer_report,
-				    const int pos[EDAC_MAX_LAYERS])
+				    const int pos[EDAC_MAX_LAYERS],
+				    const u16 count)
 {
 	int i, index = 0;
 
-	mci->ue_mc++;
+	mci->ue_mc += count;
 
 	if (!enable_per_layer_report) {
-		mci->ce_noinfo_count++;
+		mci->ce_noinfo_count += count;
 		return;
 	}
 
@@ -937,7 +939,7 @@ static void edac_inc_ue_error(struct mem_ctl_info *mci,
 		if (pos[i] < 0)
 			break;
 		index += pos[i];
-		mci->ue_per_layer[i][index]++;
+		mci->ue_per_layer[i][index] += count;
 
 		if (i < mci->n_layers - 1)
 			index *= mci->layers[i + 1].size;
@@ -945,6 +947,7 @@ static void edac_inc_ue_error(struct mem_ctl_info *mci,
 }
 
 static void edac_ce_error(struct mem_ctl_info *mci,
+			  const u16 error_count,
 			  const int pos[EDAC_MAX_LAYERS],
 			  const char *msg,
 			  const char *location,
@@ -961,16 +964,18 @@ static void edac_ce_error(struct mem_ctl_info *mci,
 	if (edac_mc_get_log_ce()) {
 		if (other_detail && *other_detail)
 			edac_mc_printk(mci, KERN_WARNING,
-				       "CE %s on %s (%s %s - %s)\n",
+				       "%d CE %s on %s (%s %s - %s)\n",
+				       error_count,
 				       msg, label, location,
 				       detail, other_detail);
 		else
 			edac_mc_printk(mci, KERN_WARNING,
-				       "CE %s on %s (%s %s)\n",
+				       "%d CE %s on %s (%s %s)\n",
+				       error_count,
 				       msg, label, location,
 				       detail);
 	}
-	edac_inc_ce_error(mci, enable_per_layer_report, pos);
+	edac_inc_ce_error(mci, enable_per_layer_report, pos, error_count);
 
 	if (mci->scrub_mode & SCRUB_SW_SRC) {
 		/*
@@ -994,6 +999,7 @@ static void edac_ce_error(struct mem_ctl_info *mci,
 }
 
 static void edac_ue_error(struct mem_ctl_info *mci,
+			  const u16 error_count,
 			  const int pos[EDAC_MAX_LAYERS],
 			  const char *msg,
 			  const char *location,
@@ -1005,12 +1011,14 @@ static void edac_ue_error(struct mem_ctl_info *mci,
 	if (edac_mc_get_log_ue()) {
 		if (other_detail && *other_detail)
 			edac_mc_printk(mci, KERN_WARNING,
-				       "UE %s on %s (%s %s - %s)\n",
+				       "%d UE %s on %s (%s %s - %s)\n",
+				       error_count,
 			               msg, label, location, detail,
 				       other_detail);
 		else
 			edac_mc_printk(mci, KERN_WARNING,
-				       "UE %s on %s (%s %s)\n",
+				       "%d UE %s on %s (%s %s)\n",
+				       error_count,
 			               msg, label, location, detail);
 	}
 
@@ -1023,7 +1031,7 @@ static void edac_ue_error(struct mem_ctl_info *mci,
 			      msg, label, location, detail);
 	}
 
-	edac_inc_ue_error(mci, enable_per_layer_report, pos);
+	edac_inc_ue_error(mci, enable_per_layer_report, pos, error_count);
 }
 
 #define OTHER_LABEL " or "
@@ -1033,6 +1041,7 @@ static void edac_ue_error(struct mem_ctl_info *mci,
  *
  * @type:		severity of the error (CE/UE/Fatal)
  * @mci:		a struct mem_ctl_info pointer
+ * @error_count:	Number of errors of the same type
  * @page_frame_number:	mem page where the error occurred
  * @offset_in_page:	offset of the error inside the page
  * @syndrome:		ECC syndrome
@@ -1047,6 +1056,7 @@ static void edac_ue_error(struct mem_ctl_info *mci,
  */
 void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			  struct mem_ctl_info *mci,
+			  const u16 error_count,
 			  const unsigned long page_frame_number,
 			  const unsigned long offset_in_page,
 			  const unsigned long syndrome,
@@ -1065,7 +1075,6 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 	int i;
 	long grain;
 	bool enable_per_layer_report = false;
-	u16 error_count;	/* FIXME: make it a parameter */
 	u8 grain_bits;
 
 	edac_dbg(3, "MC%d\n", mci->mc_idx);
@@ -1169,13 +1178,13 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			strcpy(label, "unknown memory");
 		if (type == HW_EVENT_ERR_CORRECTED) {
 			if (row >= 0) {
-				mci->csrows[row]->ce_count++;
+				mci->csrows[row]->ce_count += error_count;
 				if (chan >= 0)
-					mci->csrows[row]->channels[chan]->ce_count++;
+					mci->csrows[row]->channels[chan]->ce_count += error_count;
 			}
 		} else
 			if (row >= 0)
-				mci->csrows[row]->ue_count++;
+				mci->csrows[row]->ue_count += error_count;
 	}
 
 	/* Fill the RAM location data */
@@ -1193,7 +1202,6 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 
 	/* Report the error via the trace interface */
 
-	error_count = 1;	/* FIXME: allow change it */
 	grain_bits = fls_long(grain) + 1;
 	trace_mc_event(type, msg, label, error_count,
 		       mci->mc_idx, top_layer, mid_layer, low_layer,
@@ -1206,16 +1214,16 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			"page:0x%lx offset:0x%lx grain:%ld syndrome:0x%lx",
 			page_frame_number, offset_in_page,
 			grain, syndrome);
-		edac_ce_error(mci, pos, msg, location, label, detail,
-			      other_detail, enable_per_layer_report,
+		edac_ce_error(mci, error_count, pos, msg, location, label,
+			      detail, other_detail, enable_per_layer_report,
 			      page_frame_number, offset_in_page, grain);
 	} else {
 		snprintf(detail, sizeof(detail),
 			"page:0x%lx offset:0x%lx grain:%ld",
 			page_frame_number, offset_in_page, grain);
 
-		edac_ue_error(mci, pos, msg, location, label, detail,
-			      other_detail, enable_per_layer_report);
+		edac_ue_error(mci, error_count, pos, msg, location, label,
+			      detail, other_detail, enable_per_layer_report);
 	}
 }
 EXPORT_SYMBOL_GPL(edac_mc_handle_error);
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 107e7a7..55b2f0a 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -823,7 +823,7 @@ static ssize_t edac_fake_inject_write(struct file *file,
 		mci->fake_inject_layer[1],
 		mci->fake_inject_layer[2]
 	       );
-	edac_mc_handle_error(type, mci, 0, 0, 0,
+	edac_mc_handle_error(type, mci, 1, 0, 0, 0,
 			     mci->fake_inject_layer[0],
 			     mci->fake_inject_layer[1],
 			     mci->fake_inject_layer[2],
diff --git a/drivers/edac/i3000_edac.c b/drivers/edac/i3000_edac.c
index dd07bea..d3d19cc 100644
--- a/drivers/edac/i3000_edac.c
+++ b/drivers/edac/i3000_edac.c
@@ -245,7 +245,7 @@ static int i3000_process_error_info(struct mem_ctl_info *mci,
 		return 1;
 
 	if ((info->errsts ^ info->errsts2) & I3000_ERRSTS_BITS) {
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1, 0, 0, 0,
 				     -1, -1, -1,
 				     "UE overwrote CE", "");
 		info->errsts = info->errsts2;
@@ -258,12 +258,12 @@ static int i3000_process_error_info(struct mem_ctl_info *mci,
 	row = edac_mc_find_csrow_by_page(mci, pfn);
 
 	if (info->errsts & I3000_ERRSTS_UE)
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
 				     pfn, offset, 0,
 				     row, -1, -1,
 				     "i3000 UE", "");
 	else
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 				     pfn, offset, info->derrsyn,
 				     row, multi_chan ? channel : 0, -1,
 				     "i3000 CE", "");
diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
index 07ae442..47180a0 100644
--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -218,7 +218,7 @@ static void i3200_process_error_info(struct mem_ctl_info *mci,
 		return;
 
 	if ((info->errsts ^ info->errsts2) & I3200_ERRSTS_BITS) {
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1, 0, 0, 0,
 				     -1, -1, -1, "UE overwrote CE", "");
 		info->errsts = info->errsts2;
 	}
@@ -226,13 +226,13 @@ static void i3200_process_error_info(struct mem_ctl_info *mci,
 	for (channel = 0; channel < nr_channels; channel++) {
 		log = info->eccerrlog[channel];
 		if (log & I3200_ECCERRLOG_UE) {
-			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
 					     0, 0, 0,
 					     eccerrlog_row(channel, log),
 					     -1, -1,
 					     "i3000 UE", "");
 		} else if (log & I3200_ECCERRLOG_CE) {
-			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
 					     0, 0, eccerrlog_syndrome(log),
 					     eccerrlog_row(channel, log),
 					     -1, -1,
diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index 0406f0d..a5c33df 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -519,7 +519,7 @@ static void i5000_process_fatal_error_info(struct mem_ctl_info *mci,
 		 bank, ras, cas, allErrors, specific);
 
 	/* Call the helper to output message */
-	edac_mc_handle_error(HW_EVENT_ERR_FATAL, mci, 0, 0, 0,
+	edac_mc_handle_error(HW_EVENT_ERR_FATAL, mci, 1, 0, 0, 0,
 			     channel >> 1, channel & 1, rank,
 			     rdwr ? "Write error" : "Read error",
 			     msg);
@@ -618,7 +618,7 @@ static void i5000_process_nonfatal_error_info(struct mem_ctl_info *mci,
 			 rank, bank, ras, cas, ue_errors, specific);
 
 		/* Call the helper to output message */
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1, 0, 0, 0,
 				channel >> 1, -1, rank,
 				rdwr ? "Write error" : "Read error",
 				msg);
@@ -672,7 +672,7 @@ static void i5000_process_nonfatal_error_info(struct mem_ctl_info *mci,
 			 specific);
 
 		/* Call the helper to output message */
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 0, 0, 0,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1, 0, 0, 0,
 				channel >> 1, channel % 2, rank,
 				rdwr ? "Write error" : "Read error",
 				msg);
@@ -718,7 +718,7 @@ static void i5000_process_nonfatal_error_info(struct mem_ctl_info *mci,
 			 "Err=%#x (%s)", misc_errors, specific);
 
 		/* Call the helper to output message */
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 0, 0, 0,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1, 0, 0, 0,
 				branch >> 1, -1, -1,
 				"Misc error", msg);
 	}
diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index 1e5c8f6..c4b5e5f 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -431,7 +431,7 @@ static void i5100_handle_ce(struct mem_ctl_info *mci,
 		 "bank %u, cas %u, ras %u\n",
 		 bank, cas, ras);
 
-	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 			     0, 0, syndrome,
 			     chan, rank, -1,
 			     msg, detail);
@@ -453,7 +453,7 @@ static void i5100_handle_ue(struct mem_ctl_info *mci,
 		 "bank %u, cas %u, ras %u\n",
 		 bank, cas, ras);
 
-	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
 			     0, 0, syndrome,
 			     chan, rank, -1,
 			     msg, detail);
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index f2bfc26..50069c6 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -554,7 +554,7 @@ static void i5400_proccess_non_recoverable_info(struct mem_ctl_info *mci,
 		 "Bank=%d Buffer ID = %d RAS=%d CAS=%d Err=0x%lx (%s)",
 		 bank, buf_id, ras, cas, allErrors, error_name[errnum]);
 
-	edac_mc_handle_error(tp_event, mci, 0, 0, 0,
+	edac_mc_handle_error(tp_event, mci, 1, 0, 0, 0,
 			     branch >> 1, -1, rank,
 			     rdwr ? "Write error" : "Read error",
 			     msg);
@@ -626,7 +626,7 @@ static void i5400_process_nonfatal_error_info(struct mem_ctl_info *mci,
 			 branch >> 1, bank, rdwr_str(rdwr), ras, cas,
 			 allErrors, error_name[errnum]);
 
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 0, 0, 0,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1, 0, 0, 0,
 				     branch >> 1, channel % 2, rank,
 				     rdwr ? "Write error" : "Read error",
 				     msg);
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 4a8835f..a09d066 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -449,7 +449,7 @@ static void i7300_process_fbd_error(struct mem_ctl_info *mci)
 			 "Bank=%d RAS=%d CAS=%d Err=0x%lx (%s))",
 			 bank, ras, cas, errors, specific);
 
-		edac_mc_handle_error(HW_EVENT_ERR_FATAL, mci, 0, 0, 0,
+		edac_mc_handle_error(HW_EVENT_ERR_FATAL, mci, 1, 0, 0, 0,
 				     branch, -1, rank,
 				     is_wr ? "Write error" : "Read error",
 				     pvt->tmp_prt_buffer);
@@ -495,7 +495,7 @@ static void i7300_process_fbd_error(struct mem_ctl_info *mci)
 			 "DRAM-Bank=%d RAS=%d CAS=%d, Err=0x%lx (%s))",
 			 bank, ras, cas, errors, specific);
 
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 0, 0,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1, 0, 0,
 				     syndrome,
 				     branch >> 1, channel % 2, rank,
 				     is_wr ? "Write error" : "Read error",
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index aba8d51..a95686e 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1544,7 +1544,7 @@ static void i7core_rdimm_update_errcount(struct mem_ctl_info *mci,
 	int i;
 
 	for (i = 0; i < add; i++) {
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 0, 0, 0,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1, 0, 0, 0,
 				     chan, dimm, -1, "error", "");
 	}
 }
@@ -1796,7 +1796,7 @@ static void i7core_mce_output_error(struct mem_ctl_info *mci,
 	 * only one event
 	 */
 	if (uncorrected_error || !pvt->is_registered)
-		edac_mc_handle_error(tp_event, mci,
+		edac_mc_handle_error(tp_event, mci, 1,
 				     m->addr >> PAGE_SHIFT,
 				     m->addr & ~PAGE_MASK,
 				     syndrome,
diff --git a/drivers/edac/i82443bxgx_edac.c b/drivers/edac/i82443bxgx_edac.c
index 1c414a8..90f303d 100644
--- a/drivers/edac/i82443bxgx_edac.c
+++ b/drivers/edac/i82443bxgx_edac.c
@@ -156,7 +156,7 @@ static int i82443bxgx_edacmc_process_error_info(struct mem_ctl_info *mci,
 	if (info->eap & I82443BXGX_EAP_OFFSET_SBE) {
 		error_found = 1;
 		if (handle_errors)
-			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 					     page, pageoffset, 0,
 					     edac_mc_find_csrow_by_page(mci, page),
 					     0, -1, mci->ctl_name, "");
@@ -165,7 +165,7 @@ static int i82443bxgx_edacmc_process_error_info(struct mem_ctl_info *mci,
 	if (info->eap & I82443BXGX_EAP_OFFSET_MBE) {
 		error_found = 1;
 		if (handle_errors)
-			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
 					     page, pageoffset, 0,
 					     edac_mc_find_csrow_by_page(mci, page),
 					     0, -1, mci->ctl_name, "");
diff --git a/drivers/edac/i82860_edac.c b/drivers/edac/i82860_edac.c
index ff4f590..1faa749 100644
--- a/drivers/edac/i82860_edac.c
+++ b/drivers/edac/i82860_edac.c
@@ -109,7 +109,7 @@ static int i82860_process_error_info(struct mem_ctl_info *mci,
 		return 1;
 
 	if ((info->errsts ^ info->errsts2) & 0x0003) {
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1, 0, 0, 0,
 				     -1, -1, -1, "UE overwrote CE", "");
 		info->errsts = info->errsts2;
 	}
@@ -119,12 +119,12 @@ static int i82860_process_error_info(struct mem_ctl_info *mci,
 	dimm = mci->csrows[row]->channels[0]->dimm;
 
 	if (info->errsts & 0x0002)
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
 				     info->eap, 0, 0,
 				     dimm->location[0], dimm->location[1], -1,
 				     "i82860 UE", "");
 	else
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
 				     info->eap, 0, info->derrsyn,
 				     dimm->location[0], dimm->location[1], -1,
 				     "i82860 CE", "");
diff --git a/drivers/edac/i82875p_edac.c b/drivers/edac/i82875p_edac.c
index 2e3f306..3e416b1 100644
--- a/drivers/edac/i82875p_edac.c
+++ b/drivers/edac/i82875p_edac.c
@@ -236,7 +236,7 @@ static int i82875p_process_error_info(struct mem_ctl_info *mci,
 		return 1;
 
 	if ((info->errsts ^ info->errsts2) & 0x0081) {
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1, 0, 0, 0,
 				     -1, -1, -1,
 				     "UE overwrote CE", "");
 		info->errsts = info->errsts2;
@@ -246,12 +246,12 @@ static int i82875p_process_error_info(struct mem_ctl_info *mci,
 	row = edac_mc_find_csrow_by_page(mci, info->eap);
 
 	if (info->errsts & 0x0080)
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
 				     info->eap, 0, 0,
 				     row, -1, -1,
 				     "i82875p UE", "");
 	else
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 				     info->eap, 0, info->derrsyn,
 				     row, multi_chan ? (info->des & 0x1) : 0,
 				     -1, "i82875p CE", "");
diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index c95ebe5..069e26c 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -288,7 +288,7 @@ static int i82975x_process_error_info(struct mem_ctl_info *mci,
 		return 1;
 
 	if ((info->errsts ^ info->errsts2) & 0x0003) {
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1, 0, 0, 0,
 				     -1, -1, -1, "UE overwrote CE", "");
 		info->errsts = info->errsts2;
 	}
@@ -314,12 +314,12 @@ static int i82975x_process_error_info(struct mem_ctl_info *mci,
 			   (1 << mci->csrows[row]->channels[chan]->dimm->grain));
 
 	if (info->errsts & 0x0002)
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
 				     page, offst, 0,
 				     row, -1, -1,
 				     "i82975x UE", "");
 	else
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 				     page, offst, info->derrsyn,
 				     row, chan ? chan : 0, -1,
 				     "i82975x CE", "");
diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index 56e79a0..117cf00 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -866,13 +866,13 @@ static void mpc85xx_mc_check(struct mem_ctl_info *mci)
 		mpc85xx_mc_printk(mci, KERN_ERR, "PFN out of range!\n");
 
 	if (err_detect & DDR_EDE_SBE)
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 				     pfn, err_addr & ~PAGE_MASK, syndrome,
 				     row_index, 0, -1,
 				     mci->ctl_name, "");
 
 	if (err_detect & DDR_EDE_MBE)
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
 				     pfn, err_addr & ~PAGE_MASK, syndrome,
 				     row_index, 0, -1,
 				     mci->ctl_name, "");
diff --git a/drivers/edac/mv64x60_edac.c b/drivers/edac/mv64x60_edac.c
index e491a29..2b315c2 100644
--- a/drivers/edac/mv64x60_edac.c
+++ b/drivers/edac/mv64x60_edac.c
@@ -611,13 +611,13 @@ static void mv64x60_mc_check(struct mem_ctl_info *mci)
 
 	/* first bit clear in ECC Err Reg, 1 bit error, correctable by HW */
 	if (!(reg & 0x1))
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 				     err_addr >> PAGE_SHIFT,
 				     err_addr & PAGE_MASK, syndrome,
 				     0, 0, -1,
 				     mci->ctl_name, "");
 	else	/* 2 bit error, UE */
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
 				     err_addr >> PAGE_SHIFT,
 				     err_addr & PAGE_MASK, 0,
 				     0, 0, -1,
diff --git a/drivers/edac/pasemi_edac.c b/drivers/edac/pasemi_edac.c
index 04851be5..2d35b78 100644
--- a/drivers/edac/pasemi_edac.c
+++ b/drivers/edac/pasemi_edac.c
@@ -110,14 +110,14 @@ static void pasemi_edac_process_error_info(struct mem_ctl_info *mci, u32 errsta)
 	/* uncorrectable/multi-bit errors */
 	if (errsta & (MCDEBUG_ERRSTA_MBE_STATUS |
 		      MCDEBUG_ERRSTA_RFL_STATUS)) {
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
 				     mci->csrows[cs]->first_page, 0, 0,
 				     cs, 0, -1, mci->ctl_name, "");
 	}
 
 	/* correctable/single-bit errors */
 	if (errsta & MCDEBUG_ERRSTA_SBE_STATUS)
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 				     mci->csrows[cs]->first_page, 0, 0,
 				     cs, 0, -1, mci->ctl_name, "");
 }
diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
index 67a2920..bf09576 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -727,7 +727,7 @@ ppc4xx_edac_handle_ce(struct mem_ctl_info *mci,
 
 	for (row = 0; row < mci->nr_csrows; row++)
 		if (ppc4xx_edac_check_bank_error(status, row))
-			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 					     0, 0, 0,
 					     row, 0, -1,
 					     message, "");
@@ -758,7 +758,7 @@ ppc4xx_edac_handle_ue(struct mem_ctl_info *mci,
 
 	for (row = 0; row < mci->nr_csrows; row++)
 		if (ppc4xx_edac_check_bank_error(status, row))
-			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
 					     page, offset, 0,
 					     row, 0, -1,
 					     message, "");
diff --git a/drivers/edac/r82600_edac.c b/drivers/edac/r82600_edac.c
index aa10178..f854deb 100644
--- a/drivers/edac/r82600_edac.c
+++ b/drivers/edac/r82600_edac.c
@@ -179,7 +179,7 @@ static int r82600_process_error_info(struct mem_ctl_info *mci,
 		error_found = 1;
 
 		if (handle_errors)
-			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 					     page, 0, syndrome,
 					     edac_mc_find_csrow_by_page(mci, page),
 					     0, -1,
@@ -191,7 +191,7 @@ static int r82600_process_error_info(struct mem_ctl_info *mci,
 
 		if (handle_errors)
 			/* 82600 doesn't give enough info */
-			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
 					     page, 0, 0,
 					     edac_mc_find_csrow_by_page(mci, page),
 					     0, -1,
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index ae18d98..2809b07 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1447,13 +1447,13 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	/* FIXME: need support for channel mask */
 
 	/* Call the helper to output message */
-	edac_mc_handle_error(tp_event, mci,
+	edac_mc_handle_error(tp_event, mci, 1,
 			     m->addr >> PAGE_SHIFT, m->addr & ~PAGE_MASK, 0,
 			     channel, dimm, -1,
 			     optype, msg);
 	return;
 err_parsing:
-	edac_mc_handle_error(tp_event, mci, 0, 0, 0,
+	edac_mc_handle_error(tp_event, mci, 1, 0, 0, 0,
 			     -1, -1, -1,
 			     msg, "");
 
diff --git a/drivers/edac/tile_edac.c b/drivers/edac/tile_edac.c
index 0589f56..1e904b7 100644
--- a/drivers/edac/tile_edac.c
+++ b/drivers/edac/tile_edac.c
@@ -71,7 +71,7 @@ static void tile_edac_check(struct mem_ctl_info *mci)
 	if (mem_error.sbe_count != priv->ce_count) {
 		dev_dbg(mci->pdev, "ECC CE err on node %d\n", priv->node);
 		priv->ce_count = mem_error.sbe_count;
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 				     0, 0, 0,
 				     0, 0, -1,
 				     mci->ctl_name, "");
diff --git a/drivers/edac/x38_edac.c b/drivers/edac/x38_edac.c
index 3d46d40..08a9926 100644
--- a/drivers/edac/x38_edac.c
+++ b/drivers/edac/x38_edac.c
@@ -215,7 +215,7 @@ static void x38_process_error_info(struct mem_ctl_info *mci,
 		return;
 
 	if ((info->errsts ^ info->errsts2) & X38_ERRSTS_BITS) {
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1, 0, 0, 0,
 				     -1, -1, -1,
 				     "UE overwrote CE", "");
 		info->errsts = info->errsts2;
@@ -224,13 +224,13 @@ static void x38_process_error_info(struct mem_ctl_info *mci,
 	for (channel = 0; channel < x38_channel_num; channel++) {
 		log = info->eccerrlog[channel];
 		if (log & X38_ECCERRLOG_UE) {
-			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
 					     0, 0, 0,
 					     eccerrlog_row(channel, log),
 					     -1, -1,
 					     "x38 UE", "");
 		} else if (log & X38_ECCERRLOG_CE) {
-			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 					     0, 0, eccerrlog_syndrome(log),
 					     eccerrlog_row(channel, log),
 					     -1, -1,
-- 
1.7.10.2


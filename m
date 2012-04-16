Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab2DPUWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:22:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699Ab2DPUVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:21:54 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [EDAC_ABI PATCH v13 01/26] amd64_edac: convert driver to use the new edac ABI
Date: Mon, 16 Apr 2012 17:21:20 -0300
Message-Id: <1334607705-30320-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334607705-30320-1-git-send-email-mchehab@redhat.com>
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607705-30320-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy edac ABI is going to be removed. Port the driver to use
and benefit from the new API functionality.

Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/amd64_edac.c |  137 ++++++++++++++++++++++++++++++---------------
 1 files changed, 92 insertions(+), 45 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 8804ac8..c4182e4 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1039,6 +1039,37 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 	int channel, csrow;
 	u32 page, offset;
 
+	error_address_to_page_and_offset(sys_addr, &page, &offset);
+
+	/*
+	 * Find out which node the error address belongs to. This may be
+	 * different from the node that detected the error.
+	 */
+	src_mci = find_mc_by_sys_addr(mci, sys_addr);
+	if (!src_mci) {
+		amd64_mc_err(mci, "failed to map error addr 0x%lx to a node\n",
+			     (unsigned long)sys_addr);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     page, offset, syndrome,
+				     -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "failed to map error addr to a node",
+				     NULL);
+		return;
+	}
+
+	/* Now map the sys_addr to a CSROW */
+	csrow = sys_addr_to_csrow(src_mci, sys_addr);
+	if (csrow < 0) {
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     page, offset, syndrome,
+				     -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "failed to map error addr to a csrow",
+				     NULL);
+		return;
+	}
+
 	/* CHIPKILL enabled */
 	if (pvt->nbcfg & NBCFG_CHIPKILL) {
 		channel = get_channel_from_ecc_syndrome(mci, syndrome);
@@ -1048,9 +1079,15 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 			 * 2 DIMMs is in error. So we need to ID 'both' of them
 			 * as suspect.
 			 */
-			amd64_mc_warn(mci, "unknown syndrome 0x%04x - possible "
-					   "error reporting race\n", syndrome);
-			edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
+			amd64_mc_warn(src_mci, "unknown syndrome 0x%04x - "
+				      "possible error reporting race\n",
+				      syndrome);
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+					     page, offset, syndrome,
+					     csrow, -1, -1,
+					     EDAC_MOD_STR,
+					     "unknown syndrome - possible error reporting race",
+					     NULL);
 			return;
 		}
 	} else {
@@ -1065,28 +1102,10 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 		channel = ((sys_addr & BIT(3)) != 0);
 	}
 
-	/*
-	 * Find out which node the error address belongs to. This may be
-	 * different from the node that detected the error.
-	 */
-	src_mci = find_mc_by_sys_addr(mci, sys_addr);
-	if (!src_mci) {
-		amd64_mc_err(mci, "failed to map error addr 0x%lx to a node\n",
-			     (unsigned long)sys_addr);
-		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
-		return;
-	}
-
-	/* Now map the sys_addr to a CSROW */
-	csrow = sys_addr_to_csrow(src_mci, sys_addr);
-	if (csrow < 0) {
-		edac_mc_handle_ce_no_info(src_mci, EDAC_MOD_STR);
-	} else {
-		error_address_to_page_and_offset(sys_addr, &page, &offset);
-
-		edac_mc_handle_ce(src_mci, page, offset, syndrome, csrow,
-				  channel, EDAC_MOD_STR);
-	}
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, src_mci,
+			     page, offset, syndrome,
+			     csrow, channel, -1,
+			     EDAC_MOD_STR, "", NULL);
 }
 
 static int ddr2_cs_size(unsigned i, bool dct_width)
@@ -1568,15 +1587,20 @@ static void f1x_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 	u32 page, offset;
 	int nid, csrow, chan = 0;
 
+	error_address_to_page_and_offset(sys_addr, &page, &offset);
+
 	csrow = f1x_translate_sysaddr_to_cs(pvt, sys_addr, &nid, &chan);
 
 	if (csrow < 0) {
-		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     page, offset, syndrome,
+				     -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "failed to map error addr to a csrow",
+				     NULL);
 		return;
 	}
 
-	error_address_to_page_and_offset(sys_addr, &page, &offset);
-
 	/*
 	 * We need the syndromes for channel detection only when we're
 	 * ganged. Otherwise @chan should already contain the channel at
@@ -1585,16 +1609,10 @@ static void f1x_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 	if (dct_ganging_enabled(pvt))
 		chan = get_channel_from_ecc_syndrome(mci, syndrome);
 
-	if (chan >= 0)
-		edac_mc_handle_ce(mci, page, offset, syndrome, csrow, chan,
-				  EDAC_MOD_STR);
-	else
-		/*
-		 * Channel unknown, report all channels on this CSROW as failed.
-		 */
-		for (chan = 0; chan < mci->csrows[csrow].nr_channels; chan++)
-			edac_mc_handle_ce(mci, page, offset, syndrome,
-					  csrow, chan, EDAC_MOD_STR);
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				page, offset, syndrome,
+				csrow, chan, -1,
+				EDAC_MOD_STR, "", NULL);
 }
 
 /*
@@ -1875,7 +1893,12 @@ static void amd64_handle_ce(struct mem_ctl_info *mci, struct mce *m)
 	/* Ensure that the Error Address is VALID */
 	if (!(m->status & MCI_STATUS_ADDRV)) {
 		amd64_mc_err(mci, "HW has no ERROR_ADDRESS available\n");
-		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     0, 0, 0,
+				     -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "HW has no ERROR_ADDRESS available",
+				     NULL);
 		return;
 	}
 
@@ -1899,11 +1922,17 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 
 	if (!(m->status & MCI_STATUS_ADDRV)) {
 		amd64_mc_err(mci, "HW has no ERROR_ADDRESS available\n");
-		edac_mc_handle_ue_no_info(log_mci, EDAC_MOD_STR);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     0, 0, 0,
+				     -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "HW has no ERROR_ADDRESS available",
+				     NULL);
 		return;
 	}
 
 	sys_addr = get_error_address(m);
+	error_address_to_page_and_offset(sys_addr, &page, &offset);
 
 	/*
 	 * Find out which node the error address belongs to. This may be
@@ -1913,7 +1942,11 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 	if (!src_mci) {
 		amd64_mc_err(mci, "ERROR ADDRESS (0x%lx) NOT mapped to a MC\n",
 				  (unsigned long)sys_addr);
-		edac_mc_handle_ue_no_info(log_mci, EDAC_MOD_STR);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     page, offset, 0,
+				     -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "ERROR ADDRESS NOT mapped to a MC", NULL);
 		return;
 	}
 
@@ -1923,10 +1956,17 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 	if (csrow < 0) {
 		amd64_mc_err(mci, "ERROR_ADDRESS (0x%lx) NOT mapped to CS\n",
 				  (unsigned long)sys_addr);
-		edac_mc_handle_ue_no_info(log_mci, EDAC_MOD_STR);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     page, offset, 0,
+				     -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "ERROR ADDRESS NOT mapped to CS",
+				     NULL);
 	} else {
-		error_address_to_page_and_offset(sys_addr, &page, &offset);
-		edac_mc_handle_ue(log_mci, page, offset, csrow, EDAC_MOD_STR);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     page, offset, 0,
+				     csrow, -1, -1,
+				     EDAC_MOD_STR, "", NULL);
 	}
 }
 
@@ -2486,6 +2526,7 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 	struct amd64_pvt *pvt = NULL;
 	struct amd64_family_type *fam_type = NULL;
 	struct mem_ctl_info *mci = NULL;
+	struct edac_mc_layer layers[2];
 	int err = 0, ret;
 	u8 nid = get_node_id(F2);
 
@@ -2520,7 +2561,13 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 		goto err_siblings;
 
 	ret = -ENOMEM;
-	mci = edac_mc_alloc(0, pvt->csels[0].b_cnt, pvt->channel_count, nid);
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = pvt->csels[0].b_cnt;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = pvt->channel_count;
+	layers[1].is_csrow = false;
+	mci = new_edac_mc_alloc(nid, ARRAY_SIZE(layers), layers, false, 0);
 	if (!mci)
 		goto err_siblings;
 
-- 
1.7.8


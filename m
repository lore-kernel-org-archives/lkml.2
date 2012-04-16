Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab2DPU2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:28:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517Ab2DPUVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:21:53 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [EDAC_ABI PATCH v13 12/26] i7300_edac: convert driver to use the new edac ABI
Date: Mon, 16 Apr 2012 17:21:31 -0300
Message-Id: <1334607705-30320-13-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334607705-30320-1-git-send-email-mchehab@redhat.com>
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607705-30320-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy edac ABI is going to be removed. Port the driver to use
and benefit from the new API functionality.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i7300_edac.c |   81 ++++++++++++++++++--------------------------
 1 files changed, 33 insertions(+), 48 deletions(-)

diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 5e594ae..6e762f5 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -464,17 +464,14 @@ static void i7300_process_fbd_error(struct mem_ctl_info *mci)
 				FERR_FAT_FBD, error_reg);
 
 		snprintf(pvt->tmp_prt_buffer, PAGE_SIZE,
-			"FATAL (Branch=%d DRAM-Bank=%d %s "
-			"RAS=%d CAS=%d Err=0x%lx (%s))",
-			branch, bank,
-			is_wr ? "RDWR" : "RD",
-			ras, cas,
-			errors, specific);
-
-		/* Call the helper to output message */
-		edac_mc_handle_fbd_ue(mci, rank, branch << 1,
-				      (branch << 1) + 1,
-				      pvt->tmp_prt_buffer);
+			 "Bank=%d RAS=%d CAS=%d Err=0x%lx (%s))",
+			 bank, ras, cas, errors, specific);
+
+		edac_mc_handle_error(HW_EVENT_ERR_FATAL, mci, 0, 0, 0,
+				     branch, -1, rank,
+				     is_wr ? "Write error" : "Read error",
+				     pvt->tmp_prt_buffer, NULL);
+
 	}
 
 	/* read in the 1st NON-FATAL error register */
@@ -513,23 +510,14 @@ static void i7300_process_fbd_error(struct mem_ctl_info *mci)
 
 		/* Form out message */
 		snprintf(pvt->tmp_prt_buffer, PAGE_SIZE,
-			"Corrected error (Branch=%d, Channel %d), "
-			" DRAM-Bank=%d %s "
-			"RAS=%d CAS=%d, CE Err=0x%lx, Syndrome=0x%08x(%s))",
-			branch, channel,
-			bank,
-			is_wr ? "RDWR" : "RD",
-			ras, cas,
-			errors, syndrome, specific);
-
-		/*
-		 * Call the helper to output message
-		 * NOTE: Errors are reported per-branch, and not per-channel
-		 *	 Currently, we don't know how to identify the right
-		 *	 channel.
-		 */
-		edac_mc_handle_fbd_ce(mci, rank, channel,
-				      pvt->tmp_prt_buffer);
+			 "DRAM-Bank=%d RAS=%d CAS=%d, Err=0x%lx (%s))",
+			 bank, ras, cas, errors, specific);
+
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 0, 0,
+				     syndrome,
+				     branch >> 1, channel % 2, rank,
+				     is_wr ? "Write error" : "Read error",
+				     pvt->tmp_prt_buffer, NULL);
 	}
 	return;
 }
@@ -807,13 +795,17 @@ static int i7300_init_csrows(struct mem_ctl_info *mci)
 			for (ch = 0; ch < MAX_CH_PER_BRANCH; ch++) {
 				int channel = to_channel(ch, branch);
 
-				dinfo = &pvt->dimm_info[slot][channel];
+				dimm = GET_POS(mci->layers, mci->dimms,
+					       mci->n_layers, branch, ch, slot);
 
-				dimm = mci->csrows[slot].channels[branch * MAX_CH_PER_BRANCH + ch].dimm;
+				dinfo = &pvt->dimm_info[slot][channel];
 
 				mtr = decode_mtr(pvt, slot, ch, branch,
 						 dinfo, dimm);
 
+				mci->tot_dimms++;
+				dimm++;
+
 				/* if no DIMMS on this row, continue */
 				if (!MTR_DIMMS_PRESENT(mtr))
 					continue;
@@ -1034,10 +1026,8 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
 				    const struct pci_device_id *id)
 {
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[3];
 	struct i7300_pvt *pvt;
-	int num_channels;
-	int num_dimms_per_channel;
-	int num_csrows;
 	int rc;
 
 	/* wake up device */
@@ -1054,22 +1044,17 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
 	if (PCI_FUNC(pdev->devfn) != 0)
 		return -ENODEV;
 
-	/* As we don't have a motherboard identification routine to determine
-	 * actual number of slots/dimms per channel, we thus utilize the
-	 * resource as specified by the chipset. Thus, we might have
-	 * have more DIMMs per channel than actually on the mobo, but this
-	 * allows the driver to support up to the chipset max, without
-	 * some fancy mobo determination.
-	 */
-	num_dimms_per_channel = MAX_SLOTS;
-	num_channels = MAX_CHANNELS;
-	num_csrows = MAX_SLOTS * MAX_CHANNELS;
-
-	debugf0("MC: %s(): Number of - Channels= %d  DIMMS= %d  CSROWS= %d\n",
-		__func__, num_channels, num_dimms_per_channel, num_csrows);
-
 	/* allocate a new MC control structure */
-	mci = edac_mc_alloc(sizeof(*pvt), num_csrows, num_channels, 0);
+	layers[0].type = EDAC_MC_LAYER_BRANCH;
+	layers[0].size = MAX_BRANCHES;
+	layers[0].is_csrow = false;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = MAX_CH_PER_BRANCH;
+	layers[1].is_csrow = true;
+	layers[2].type = EDAC_MC_LAYER_SLOT;
+	layers[2].size = MAX_SLOTS;
+	layers[2].is_csrow = true;
+	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
 
 	if (mci == NULL)
 		return -ENOMEM;
-- 
1.7.8


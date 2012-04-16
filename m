Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab2DPU2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:28:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536Ab2DPUVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:21:53 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: [EDAC_ABI PATCH v13 09/26] i5000_edac: convert driver to use the new edac ABI
Date: Mon, 16 Apr 2012 17:21:28 -0300
Message-Id: <1334607705-30320-10-git-send-email-mchehab@redhat.com>
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
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i5000_edac.c |   60 +++++++++++++++++++++++++++++---------------
 1 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index e8d32e8..18b2532 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -533,13 +533,14 @@ static void i5000_process_fatal_error_info(struct mem_ctl_info *mci,
 
 	/* Form out message */
 	snprintf(msg, sizeof(msg),
-		 "(Branch=%d DRAM-Bank=%d RDWR=%s RAS=%d CAS=%d "
-		 "FATAL Err=0x%x (%s))",
-		 branch >> 1, bank, rdwr ? "Write" : "Read", ras, cas,
-		 allErrors, specific);
+		 "Bank=%d RAS=%d CAS=%d FATAL Err=0x%x (%s)",
+		 bank, ras, cas, allErrors, specific);
 
 	/* Call the helper to output message */
-	edac_mc_handle_fbd_ue(mci, rank, channel, channel + 1, msg);
+	edac_mc_handle_error(HW_EVENT_ERR_FATAL, mci, 0, 0, 0,
+			     branch >> 1, -1, rank,
+			     rdwr ? "Write error" : "Read error",
+			     msg, NULL);
 }
 
 /*
@@ -633,13 +634,14 @@ static void i5000_process_nonfatal_error_info(struct mem_ctl_info *mci,
 
 		/* Form out message */
 		snprintf(msg, sizeof(msg),
-			 "(Branch=%d DRAM-Bank=%d RDWR=%s RAS=%d "
-			 "CAS=%d, UE Err=0x%x (%s))",
-			 branch >> 1, bank, rdwr ? "Write" : "Read", ras, cas,
-			 ue_errors, specific);
+			 "Rank=%d Bank=%d RAS=%d CAS=%d, UE Err=0x%x (%s)",
+			 rank, bank, ras, cas, ue_errors, specific);
 
 		/* Call the helper to output message */
-		edac_mc_handle_fbd_ue(mci, rank, channel, channel + 1, msg);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+				channel >> 1, -1, rank,
+				rdwr ? "Write error" : "Read error",
+				msg, NULL);
 	}
 
 	/* Check correctable errors */
@@ -685,13 +687,16 @@ static void i5000_process_nonfatal_error_info(struct mem_ctl_info *mci,
 
 		/* Form out message */
 		snprintf(msg, sizeof(msg),
-			 "(Branch=%d DRAM-Bank=%d RDWR=%s RAS=%d "
+			 "Rank=%d Bank=%d RDWR=%s RAS=%d "
 			 "CAS=%d, CE Err=0x%x (%s))", branch >> 1, bank,
 			 rdwr ? "Write" : "Read", ras, cas, ce_errors,
 			 specific);
 
 		/* Call the helper to output message */
-		edac_mc_handle_fbd_ce(mci, rank, channel, msg);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 0, 0, 0,
+				channel >> 1, channel % 2, rank,
+				rdwr ? "Write error" : "Read error",
+				msg, NULL);
 	}
 
 	if (!misc_messages)
@@ -731,11 +736,12 @@ static void i5000_process_nonfatal_error_info(struct mem_ctl_info *mci,
 
 		/* Form out message */
 		snprintf(msg, sizeof(msg),
-			 "(Branch=%d Err=%#x (%s))", branch >> 1,
-			 misc_errors, specific);
+			 "Err=%#x (%s)", misc_errors, specific);
 
 		/* Call the helper to output message */
-		edac_mc_handle_fbd_ce(mci, 0, 0, msg);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 0, 0, 0,
+				branch >> 1, -1, -1,
+				"Misc error", msg, NULL);
 	}
 }
 
@@ -1251,6 +1257,10 @@ static int i5000_init_csrows(struct mem_ctl_info *mci)
 
 	empty = 1;		/* Assume NO memory */
 
+	/*
+	 * TODO: it would be better to not use csrow here, filling
+	 * directly the dimm_info structs, based on branch, channel, dim number
+	 */
 	for (csrow = 0; csrow < max_csrows; csrow++) {
 		p_csrow = &mci->csrows[csrow];
 
@@ -1312,7 +1322,7 @@ static void i5000_enable_error_reporting(struct mem_ctl_info *mci)
 }
 
 /*
- * i5000_get_dimm_and_channel_counts(pdev, &num_csrows, &num_channels)
+ * i5000_get_dimm_and_channel_counts(pdev, &nr_csrows, &num_channels)
  *
  *	ask the device how many channels are present and how many CSROWS
  *	 as well
@@ -1343,10 +1353,10 @@ static void i5000_get_dimm_and_channel_counts(struct pci_dev *pdev,
 static int i5000_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[3];
 	struct i5000_pvt *pvt;
 	int num_channels;
 	int num_dimms_per_channel;
-	int num_csrows;
 
 	debugf0("MC: %s: %s(), pdev bus %u dev=0x%x fn=0x%x\n",
 		__FILE__, __func__,
@@ -1372,13 +1382,21 @@ static int i5000_probe1(struct pci_dev *pdev, int dev_idx)
 	 */
 	i5000_get_dimm_and_channel_counts(pdev, &num_dimms_per_channel,
 					&num_channels);
-	num_csrows = num_dimms_per_channel * 2;
 
-	debugf0("MC: %s(): Number of - Channels= %d  DIMMS= %d  CSROWS= %d\n",
-		__func__, num_channels, num_dimms_per_channel, num_csrows);
+	debugf0("MC: %s(): Number of Branches=2 Channels= %d  DIMMS= %d\n",
+		__func__, num_channels, num_dimms_per_channel);
 
 	/* allocate a new MC control structure */
-	mci = edac_mc_alloc(sizeof(*pvt), num_csrows, num_channels, 0);
+	layers[0].type = EDAC_MC_LAYER_BRANCH;
+	layers[0].size = 2;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = num_channels;
+	layers[1].is_csrow = false;
+	layers[2].type = EDAC_MC_LAYER_SLOT;
+	layers[2].size = num_dimms_per_channel;
+	layers[2].is_csrow = true;
+	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
 
 	if (mci == NULL)
 		return -ENOMEM;
-- 
1.7.8


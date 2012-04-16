Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab2DPU2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:28:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515Ab2DPUVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:21:53 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Gross <mark.gross@intel.com>, Doug Thompson <norsk5@yahoo.com>
Subject: [EDAC_ABI PATCH v13 05/26] e752x_edac: convert driver to use the new edac ABI
Date: Mon, 16 Apr 2012 17:21:24 -0300
Message-Id: <1334607705-30320-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334607705-30320-1-git-send-email-mchehab@redhat.com>
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607705-30320-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy edac ABI is going to be removed. Port the driver to use
and benefit from the new API functionality.

Cc: Mark Gross <mark.gross@intel.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/e752x_edac.c |   49 +++++++++++++++++++++++++++++++-------------
 1 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/drivers/edac/e752x_edac.c b/drivers/edac/e752x_edac.c
index 6d81d3c..7b6ce11 100644
--- a/drivers/edac/e752x_edac.c
+++ b/drivers/edac/e752x_edac.c
@@ -6,6 +6,9 @@
  *
  * See "enum e752x_chips" below for supported chipsets
  *
+ * Datasheet:
+ *	http://www.intel.in/content/www/in/en/chipsets/e7525-memory-controller-hub-datasheet.html
+ *
  * Written by Tom Zimmerman
  *
  * Contributors:
@@ -350,8 +353,10 @@ static void do_process_ce(struct mem_ctl_info *mci, u16 error_one,
 	channel = !(error_one & 1);
 
 	/* e752x mc reads 34:6 of the DRAM linear address */
-	edac_mc_handle_ce(mci, page, offset_in_page(sec1_add << 4),
-			sec1_syndrome, row, channel, "e752x CE");
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+			     page, offset_in_page(sec1_add << 4), sec1_syndrome,
+			     row, channel, -1,
+			     "e752x CE", "", NULL);
 }
 
 static inline void process_ce(struct mem_ctl_info *mci, u16 error_one,
@@ -385,9 +390,12 @@ static void do_process_ue(struct mem_ctl_info *mci, u16 error_one,
 			edac_mc_find_csrow_by_page(mci, block_page);
 
 		/* e752x mc reads 34:6 of the DRAM linear address */
-		edac_mc_handle_ue(mci, block_page,
-				offset_in_page(error_2b << 4),
-				row, "e752x UE from Read");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+					block_page,
+					offset_in_page(error_2b << 4), 0,
+					 row, -1, -1,
+					"e752x UE from Read", "", NULL);
+
 	}
 	if (error_one & 0x0404) {
 		error_2b = scrb_add;
@@ -401,9 +409,11 @@ static void do_process_ue(struct mem_ctl_info *mci, u16 error_one,
 			edac_mc_find_csrow_by_page(mci, block_page);
 
 		/* e752x mc reads 34:6 of the DRAM linear address */
-		edac_mc_handle_ue(mci, block_page,
-				offset_in_page(error_2b << 4),
-				row, "e752x UE from Scruber");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+					block_page,
+					offset_in_page(error_2b << 4), 0,
+					row, -1, -1,
+					"e752x UE from Scruber", "", NULL);
 	}
 }
 
@@ -426,7 +436,9 @@ static inline void process_ue_no_info_wr(struct mem_ctl_info *mci,
 		return;
 
 	debugf3("%s()\n", __func__);
-	edac_mc_handle_ue_no_info(mci, "e752x UE log memory write");
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+			     -1, -1, -1,
+			     "e752x UE log memory write", "", NULL);
 }
 
 static void do_process_ded_retry(struct mem_ctl_info *mci, u16 error,
@@ -1081,10 +1093,11 @@ static void e752x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 		nr_pages = cumul_size - last_cumul_size;
 		last_cumul_size = cumul_size;
 
-		for (i = 0; i < drc_chan + 1; i++) {
+		for (i = 0; i < csrow->nr_channels; i++) {
 			struct dimm_info *dimm = csrow->channels[i].dimm;
 
-			dimm->nr_pages = nr_pages / (drc_chan + 1);
+			debugf3("Initializing rank at (%i,%i)\n", index, i);
+			dimm->nr_pages = nr_pages / csrow->nr_channels;
 			dimm->grain = 1 << 12;	/* 4KiB - resolution of CELOG */
 			dimm->mtype = MEM_RDDR;	/* only one type supported */
 			dimm->dtype = mem_dev ? DEV_X4 : DEV_X8;
@@ -1232,6 +1245,7 @@ static int e752x_probe1(struct pci_dev *pdev, int dev_idx)
 	u16 pci_data;
 	u8 stat8;
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	struct e752x_pvt *pvt;
 	u16 ddrcsr;
 	int drc_chan;		/* Number of channels 0=1chan,1=2chan */
@@ -1258,11 +1272,16 @@ static int e752x_probe1(struct pci_dev *pdev, int dev_idx)
 	/* Dual channel = 1, Single channel = 0 */
 	drc_chan = dual_channel_active(ddrcsr);
 
-	mci = edac_mc_alloc(sizeof(*pvt), E752X_NR_CSROWS, drc_chan + 1, 0);
-
-	if (mci == NULL) {
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = E752X_NR_CSROWS;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = drc_chan + 1;
+	layers[1].is_csrow = false;
+	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
+			    false, sizeof(*pvt));
+	if (mci == NULL)
 		return -ENOMEM;
-	}
 
 	debugf3("%s(): init mci\n", __func__);
 	mci->mtype_cap = MEM_FLAG_RDDR;
-- 
1.7.8


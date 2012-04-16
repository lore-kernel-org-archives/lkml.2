Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab2DPUXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:23:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755105Ab2DPUWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:22:17 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ranganathan Desikan <ravi@jetztechnologies.com>,
        "Arvind R." <arvino55@gmail.com>
Subject: [EDAC_ABI PATCH v13 17/26] i82975x_edac: convert driver to use the new edac ABI
Date: Mon, 16 Apr 2012 17:21:36 -0300
Message-Id: <1334607705-30320-18-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334607705-30320-1-git-send-email-mchehab@redhat.com>
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607705-30320-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy edac ABI is going to be removed. Port the driver to use
and benefit from the new API functionality.

Cc: Ranganathan Desikan <ravi@jetztechnologies.com>
Cc: "Arvind R." <arvino55@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i82975x_edac.c |   27 ++++++++++++++++++++-------
 1 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index 304af1d..bfd632c 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -29,7 +29,8 @@
 #define PCI_DEVICE_ID_INTEL_82975_0	0x277c
 #endif				/* PCI_DEVICE_ID_INTEL_82975_0 */
 
-#define I82975X_NR_CSROWS(nr_chans)		(8/(nr_chans))
+#define I82975X_NR_DIMMS		8
+#define I82975X_NR_CSROWS(nr_chans)	(I82975X_NR_DIMMS / (nr_chans))
 
 /* Intel 82975X register addresses - device 0 function 0 - DRAM Controller */
 #define I82975X_EAP		0x58	/* Dram Error Address Pointer (32b)
@@ -287,7 +288,8 @@ static int i82975x_process_error_info(struct mem_ctl_info *mci,
 		return 1;
 
 	if ((info->errsts ^ info->errsts2) & 0x0003) {
-		edac_mc_handle_ce_no_info(mci, "UE overwrote CE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+				     -1, -1, -1, "UE overwrote CE", "", NULL);
 		info->errsts = info->errsts2;
 	}
 
@@ -312,10 +314,15 @@ static int i82975x_process_error_info(struct mem_ctl_info *mci,
 			   (1 << mci->csrows[row].channels[chan].dimm->grain));
 
 	if (info->errsts & 0x0002)
-		edac_mc_handle_ue(mci, page, offst , row, "i82975x UE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     page, offst, 0,
+				     row, -1, -1,
+				     "i82975x UE", "", NULL);
 	else
-		edac_mc_handle_ce(mci, page, offst, info->derrsyn, row,
-				chan, "i82975x CE");
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     page, offst, info->derrsyn,
+				     row, chan ? chan : 0, -1,
+				     "i82975x CE", "", NULL);
 
 	return 1;
 }
@@ -473,6 +480,7 @@ static int i82975x_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	int rc = -ENODEV;
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	struct i82975x_pvt *pvt;
 	void __iomem *mch_window;
 	u32 mchbar;
@@ -541,8 +549,13 @@ static int i82975x_probe1(struct pci_dev *pdev, int dev_idx)
 	chans = dual_channel_active(mch_window) + 1;
 
 	/* assuming only one controller, index thus is 0 */
-	mci = edac_mc_alloc(sizeof(*pvt), I82975X_NR_CSROWS(chans),
-					chans, 0);
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = I82975X_NR_DIMMS;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = I82975X_NR_CSROWS(chans);
+	layers[1].is_csrow = false;
+	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
 	if (!mci) {
 		rc = -ENOMEM;
 		goto fail1;
-- 
1.7.8


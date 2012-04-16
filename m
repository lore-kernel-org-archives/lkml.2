Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab2DPU2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:28:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624Ab2DPUVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:21:53 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [EDAC_ABI PATCH v13 16/26] i82875p_edac: convert driver to use the new edac ABI
Date: Mon, 16 Apr 2012 17:21:35 -0300
Message-Id: <1334607705-30320-17-git-send-email-mchehab@redhat.com>
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
 drivers/edac/i82875p_edac.c |   29 +++++++++++++++++++++--------
 1 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/edac/i82875p_edac.c b/drivers/edac/i82875p_edac.c
index dc207dc..4259c4a 100644
--- a/drivers/edac/i82875p_edac.c
+++ b/drivers/edac/i82875p_edac.c
@@ -38,7 +38,8 @@
 #endif				/* PCI_DEVICE_ID_INTEL_82875_6 */
 
 /* four csrows in dual channel, eight in single channel */
-#define I82875P_NR_CSROWS(nr_chans) (8/(nr_chans))
+#define I82875P_NR_DIMMS		8
+#define I82875P_NR_CSROWS(nr_chans)	(I82875P_NR_DIMMS / (nr_chans))
 
 /* Intel 82875p register addresses - device 0 function 0 - DRAM Controller */
 #define I82875P_EAP		0x58	/* Error Address Pointer (32b)
@@ -235,7 +236,9 @@ static int i82875p_process_error_info(struct mem_ctl_info *mci,
 		return 1;
 
 	if ((info->errsts ^ info->errsts2) & 0x0081) {
-		edac_mc_handle_ce_no_info(mci, "UE overwrote CE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+				     -1, -1, -1,
+				     "UE overwrote CE", "", NULL);
 		info->errsts = info->errsts2;
 	}
 
@@ -243,11 +246,15 @@ static int i82875p_process_error_info(struct mem_ctl_info *mci,
 	row = edac_mc_find_csrow_by_page(mci, info->eap);
 
 	if (info->errsts & 0x0080)
-		edac_mc_handle_ue(mci, info->eap, 0, row, "i82875p UE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     info->eap, 0, 0,
+				     row, -1, -1,
+				     "i82875p UE", "", NULL);
 	else
-		edac_mc_handle_ce(mci, info->eap, 0, info->derrsyn, row,
-				multi_chan ? (info->des & 0x1) : 0,
-				"i82875p CE");
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     info->eap, 0, info->derrsyn,
+				     row, multi_chan ? (info->des & 0x1) : 0,
+				     -1, "i82875p CE", "", NULL);
 
 	return 1;
 }
@@ -390,6 +397,7 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	int rc = -ENODEV;
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	struct i82875p_pvt *pvt;
 	struct pci_dev *ovrfl_pdev;
 	void __iomem *ovrfl_window;
@@ -405,9 +413,14 @@ static int i82875p_probe1(struct pci_dev *pdev, int dev_idx)
 		return -ENODEV;
 	drc = readl(ovrfl_window + I82875P_DRC);
 	nr_chans = dual_channel_active(drc) + 1;
-	mci = edac_mc_alloc(sizeof(*pvt), I82875P_NR_CSROWS(nr_chans),
-			nr_chans, 0);
 
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = I82875P_NR_CSROWS(nr_chans);
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = nr_chans;
+	layers[1].is_csrow = false;
+	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
 	if (!mci) {
 		rc = -ENOMEM;
 		goto fail0;
-- 
1.7.8


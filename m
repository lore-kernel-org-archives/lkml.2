Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab2DPUZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:25:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830Ab2DPUV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:21:56 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [EDAC_ABI PATCH v13 25/26] x38_edac: convert driver to use the new edac ABI
Date: Mon, 16 Apr 2012 17:21:44 -0300
Message-Id: <1334607705-30320-26-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334607705-30320-1-git-send-email-mchehab@redhat.com>
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607705-30320-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy edac ABI is going to be removed. Port the driver to use
and benefit from the new API functionality.

Cc: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/x38_edac.c |   28 +++++++++++++++++++++-------
 1 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/edac/x38_edac.c b/drivers/edac/x38_edac.c
index 0de288f..f715269 100644
--- a/drivers/edac/x38_edac.c
+++ b/drivers/edac/x38_edac.c
@@ -215,19 +215,26 @@ static void x38_process_error_info(struct mem_ctl_info *mci,
 		return;
 
 	if ((info->errsts ^ info->errsts2) & X38_ERRSTS_BITS) {
-		edac_mc_handle_ce_no_info(mci, "UE overwrote CE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+				     -1, -1, -1,
+				     "UE overwrote CE", "", NULL);
 		info->errsts = info->errsts2;
 	}
 
 	for (channel = 0; channel < x38_channel_num; channel++) {
 		log = info->eccerrlog[channel];
 		if (log & X38_ECCERRLOG_UE) {
-			edac_mc_handle_ue(mci, 0, 0,
-				eccerrlog_row(channel, log), "x38 UE");
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+					     0, 0, 0,
+					     eccerrlog_row(channel, log),
+					     -1, -1,
+					     "x38 UE", "", NULL);
 		} else if (log & X38_ECCERRLOG_CE) {
-			edac_mc_handle_ce(mci, 0, 0,
-				eccerrlog_syndrome(log),
-				eccerrlog_row(channel, log), 0, "x38 CE");
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+					     0, 0, eccerrlog_syndrome(log),
+					     eccerrlog_row(channel, log),
+					     -1, -1,
+					     "x38 CE", "", NULL);
 		}
 	}
 }
@@ -319,6 +326,7 @@ static int x38_probe1(struct pci_dev *pdev, int dev_idx)
 	int rc;
 	int i, j;
 	struct mem_ctl_info *mci = NULL;
+	struct edac_mc_layer layers[2];
 	u16 drbs[X38_CHANNELS][X38_RANKS_PER_CHANNEL];
 	bool stacked;
 	void __iomem *window;
@@ -334,7 +342,13 @@ static int x38_probe1(struct pci_dev *pdev, int dev_idx)
 	how_many_channel(pdev);
 
 	/* FIXME: unconventional pvt_info usage */
-	mci = edac_mc_alloc(0, X38_RANKS, x38_channel_num, 0);
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = X38_RANKS;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = x38_channel_num;
+	layers[1].is_csrow = false;
+	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
 	if (!mci)
 		return -ENOMEM;
 
-- 
1.7.8


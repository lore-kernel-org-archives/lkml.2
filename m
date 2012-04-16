Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab2DPUZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:25:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab2DPUVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:21:55 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tim Small <tim@buttersideup.com>
Subject: [EDAC_ABI PATCH v13 22/26] r82600_edac: convert driver to use the new edac ABI
Date: Mon, 16 Apr 2012 17:21:41 -0300
Message-Id: <1334607705-30320-23-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334607705-30320-1-git-send-email-mchehab@redhat.com>
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607705-30320-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy edac ABI is going to be removed. Port the driver to use
and benefit from the new API functionality.

Cc: Tim Small <tim@buttersideup.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/r82600_edac.c |   27 ++++++++++++++++++---------
 1 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/edac/r82600_edac.c b/drivers/edac/r82600_edac.c
index 19f3a10..ca64939 100644
--- a/drivers/edac/r82600_edac.c
+++ b/drivers/edac/r82600_edac.c
@@ -179,10 +179,11 @@ static int r82600_process_error_info(struct mem_ctl_info *mci,
 		error_found = 1;
 
 		if (handle_errors)
-			edac_mc_handle_ce(mci, page, 0,	/* not avail */
-					syndrome,
-					edac_mc_find_csrow_by_page(mci, page),
-					0, mci->ctl_name);
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+					     page, 0, syndrome,
+					     edac_mc_find_csrow_by_page(mci, page),
+					     0, -1,
+					     mci->ctl_name, "", NULL);
 	}
 
 	if (info->eapr & BIT(1)) {	/* UE? */
@@ -190,9 +191,11 @@ static int r82600_process_error_info(struct mem_ctl_info *mci,
 
 		if (handle_errors)
 			/* 82600 doesn't give enough info */
-			edac_mc_handle_ue(mci, page, 0,
-					edac_mc_find_csrow_by_page(mci, page),
-					mci->ctl_name);
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+					     page, 0, 0,
+					     edac_mc_find_csrow_by_page(mci, page),
+					     0, -1,
+					     mci->ctl_name, "", NULL);
 	}
 
 	return error_found;
@@ -267,6 +270,7 @@ static void r82600_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 static int r82600_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	u8 dramcr;
 	u32 eapr;
 	u32 scrub_disabled;
@@ -281,8 +285,13 @@ static int r82600_probe1(struct pci_dev *pdev, int dev_idx)
 	debugf2("%s(): sdram refresh rate = %#0x\n", __func__,
 		sdram_refresh_rate);
 	debugf2("%s(): DRAMC register = %#0x\n", __func__, dramcr);
-	mci = edac_mc_alloc(0, R82600_NR_CSROWS, R82600_NR_CHANS, 0);
-
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = R82600_NR_CSROWS;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = R82600_NR_CHANS;
+	layers[1].is_csrow = false;
+	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
 	if (mci == NULL)
 		return -ENOMEM;
 
-- 
1.7.8


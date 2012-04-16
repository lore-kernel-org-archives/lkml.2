Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab2DPUZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:25:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab2DPUVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:21:55 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [EDAC_ABI PATCH v13 19/26] mv64x60_edac: convert driver to use the new edac ABI
Date: Mon, 16 Apr 2012 17:21:38 -0300
Message-Id: <1334607705-30320-20-git-send-email-mchehab@redhat.com>
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
 drivers/edac/mv64x60_edac.c |   25 +++++++++++++++++++------
 1 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/edac/mv64x60_edac.c b/drivers/edac/mv64x60_edac.c
index 281e245..f294da7 100644
--- a/drivers/edac/mv64x60_edac.c
+++ b/drivers/edac/mv64x60_edac.c
@@ -611,12 +611,17 @@ static void mv64x60_mc_check(struct mem_ctl_info *mci)
 
 	/* first bit clear in ECC Err Reg, 1 bit error, correctable by HW */
 	if (!(reg & 0x1))
-		edac_mc_handle_ce(mci, err_addr >> PAGE_SHIFT,
-				  err_addr & PAGE_MASK, syndrome, 0, 0,
-				  mci->ctl_name);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     err_addr >> PAGE_SHIFT,
+				     err_addr & PAGE_MASK, syndrome,
+				     0, 0, -1,
+				     mci->ctl_name, "", NULL);
 	else	/* 2 bit error, UE */
-		edac_mc_handle_ue(mci, err_addr >> PAGE_SHIFT,
-				  err_addr & PAGE_MASK, 0, mci->ctl_name);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     err_addr >> PAGE_SHIFT,
+				     err_addr & PAGE_MASK, 0,
+				     0, 0, -1,
+				     mci->ctl_name, "", NULL);
 
 	/* clear the error */
 	out_le32(pdata->mc_vbase + MV64X60_SDRAM_ERR_ADDR, 0);
@@ -695,6 +700,7 @@ static void mv64x60_init_csrows(struct mem_ctl_info *mci,
 static int __devinit mv64x60_mc_err_probe(struct platform_device *pdev)
 {
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	struct mv64x60_mc_pdata *pdata;
 	struct resource *r;
 	u32 ctl;
@@ -703,7 +709,14 @@ static int __devinit mv64x60_mc_err_probe(struct platform_device *pdev)
 	if (!devres_open_group(&pdev->dev, mv64x60_mc_err_probe, GFP_KERNEL))
 		return -ENOMEM;
 
-	mci = edac_mc_alloc(sizeof(struct mv64x60_mc_pdata), 1, 1, edac_mc_idx);
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = 1;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = 1;
+	layers[1].is_csrow = false;
+	mci = new_edac_mc_alloc(edac_mc_idx, ARRAY_SIZE(layers), layers, false,
+			    sizeof(struct mv64x60_mc_pdata));
 	if (!mci) {
 		printk(KERN_ERR "%s: No memory for CPU err\n", __func__);
 		devres_release_group(&pdev->dev, mv64x60_mc_err_probe);
-- 
1.7.8


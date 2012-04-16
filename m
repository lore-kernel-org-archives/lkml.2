Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab2DPUWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:22:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395Ab2DPUWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:22:20 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohui Xie <Shaohui.Xie@freescale.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [EDAC_ABI PATCH v13 18/26] mpc85xx_edac: convert driver to use the new edac ABI
Date: Mon, 16 Apr 2012 17:21:37 -0300
Message-Id: <1334607705-30320-19-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334607705-30320-1-git-send-email-mchehab@redhat.com>
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607705-30320-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy edac ABI is going to be removed. Port the driver to use
and benefit from the new API functionality.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Shaohui Xie <Shaohui.Xie@freescale.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/mpc85xx_edac.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index c1d9e15..87a9baa 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -854,12 +854,16 @@ static void mpc85xx_mc_check(struct mem_ctl_info *mci)
 		mpc85xx_mc_printk(mci, KERN_ERR, "PFN out of range!\n");
 
 	if (err_detect & DDR_EDE_SBE)
-		edac_mc_handle_ce(mci, pfn, err_addr & ~PAGE_MASK,
-				  syndrome, row_index, 0, mci->ctl_name);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     pfn, err_addr & ~PAGE_MASK, syndrome,
+				     row_index, 0, -1,
+				     mci->ctl_name, "", NULL);
 
 	if (err_detect & DDR_EDE_MBE)
-		edac_mc_handle_ue(mci, pfn, err_addr & ~PAGE_MASK,
-				  row_index, mci->ctl_name);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     pfn, err_addr & ~PAGE_MASK, syndrome,
+				     row_index, 0, -1,
+				     mci->ctl_name, "", NULL);
 
 	out_be32(pdata->mc_vbase + MPC85XX_MC_ERR_DETECT, err_detect);
 }
@@ -961,6 +965,7 @@ static void __devinit mpc85xx_init_csrows(struct mem_ctl_info *mci)
 static int __devinit mpc85xx_mc_err_probe(struct platform_device *op)
 {
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	struct mpc85xx_mc_pdata *pdata;
 	struct resource r;
 	u32 sdram_ctl;
@@ -969,7 +974,14 @@ static int __devinit mpc85xx_mc_err_probe(struct platform_device *op)
 	if (!devres_open_group(&op->dev, mpc85xx_mc_err_probe, GFP_KERNEL))
 		return -ENOMEM;
 
-	mci = edac_mc_alloc(sizeof(*pdata), 4, 1, edac_mc_idx);
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = 4;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = 1;
+	layers[1].is_csrow = false;
+	mci = new_edac_mc_alloc(edac_mc_idx, ARRAY_SIZE(layers), layers, false,
+			    sizeof(*pdata));
 	if (!mci) {
 		devres_release_group(&op->dev, mpc85xx_mc_err_probe);
 		return -ENOMEM;
-- 
1.7.8


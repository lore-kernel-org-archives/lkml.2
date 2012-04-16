Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab2DPUXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:23:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979Ab2DPUWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:22:17 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>
Subject: [EDAC_ABI PATCH v13 03/26] cell_edac: convert driver to use the new edac ABI
Date: Mon, 16 Apr 2012 17:21:22 -0300
Message-Id: <1334607705-30320-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334607705-30320-1-git-send-email-mchehab@redhat.com>
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607705-30320-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy edac ABI is going to be removed. Port the driver to use
and benefit from the new API functionality.

Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/cell_edac.c |   26 +++++++++++++++++++-------
 1 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/edac/cell_edac.c b/drivers/edac/cell_edac.c
index 09e1b5d..4cfd22a 100644
--- a/drivers/edac/cell_edac.c
+++ b/drivers/edac/cell_edac.c
@@ -48,8 +48,9 @@ static void cell_edac_count_ce(struct mem_ctl_info *mci, int chan, u64 ar)
 	syndrome = (ar & 0x000000001fe00000ul) >> 21;
 
 	/* TODO: Decoding of the error address */
-	edac_mc_handle_ce(mci, csrow->first_page + pfn, offset,
-			  syndrome, 0, chan, "");
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+			     csrow->first_page + pfn, offset, syndrome,
+			     0, chan, -1, "", "", NULL);
 }
 
 static void cell_edac_count_ue(struct mem_ctl_info *mci, int chan, u64 ar)
@@ -69,7 +70,9 @@ static void cell_edac_count_ue(struct mem_ctl_info *mci, int chan, u64 ar)
 	offset = address & ~PAGE_MASK;
 
 	/* TODO: Decoding of the error address */
-	edac_mc_handle_ue(mci, csrow->first_page + pfn, offset, 0, "");
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+			     csrow->first_page + pfn, offset, 0,
+			     0, chan, -1, "", "", NULL);
 }
 
 static void cell_edac_check(struct mem_ctl_info *mci)
@@ -156,7 +159,7 @@ static void __devinit cell_edac_init_csrows(struct mem_ctl_info *mci)
 			"Initialized on node %d, chanmask=0x%x,"
 			" first_page=0x%lx, nr_pages=0x%x\n",
 			priv->node, priv->chanmask,
-			csrow->first_page, dimm->nr_pages);
+			csrow->first_page, nr_pages);
 		break;
 	}
 }
@@ -165,9 +168,10 @@ static int __devinit cell_edac_probe(struct platform_device *pdev)
 {
 	struct cbe_mic_tm_regs __iomem	*regs;
 	struct mem_ctl_info		*mci;
+	struct edac_mc_layer		layers[2];
 	struct cell_edac_priv		*priv;
 	u64				reg;
-	int				rc, chanmask;
+	int				rc, chanmask, num_chans;
 
 	regs = cbe_get_cpu_mic_tm_regs(cbe_node_to_cpu(pdev->id));
 	if (regs == NULL)
@@ -192,8 +196,16 @@ static int __devinit cell_edac_probe(struct platform_device *pdev)
 		in_be64(&regs->mic_fir));
 
 	/* Allocate & init EDAC MC data structure */
-	mci = edac_mc_alloc(sizeof(struct cell_edac_priv), 1,
-			    chanmask == 3 ? 2 : 1, pdev->id);
+	num_chans = chanmask == 3 ? 2 : 1;
+
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = 1;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = num_chans;
+	layers[1].is_csrow = false;
+	mci = new_edac_mc_alloc(pdev->id, ARRAY_SIZE(layers), layers, false,
+			    sizeof(struct cell_edac_priv));
 	if (mci == NULL)
 		return -ENOMEM;
 	priv = mci->pvt_info;
-- 
1.7.8


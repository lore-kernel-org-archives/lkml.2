Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab2DPUZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:25:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841Ab2DPUV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:21:56 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [EDAC_ABI PATCH v13 24/26] tile_edac: convert driver to use the new edac ABI
Date: Mon, 16 Apr 2012 17:21:43 -0300
Message-Id: <1334607705-30320-25-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334607705-30320-1-git-send-email-mchehab@redhat.com>
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607705-30320-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy edac ABI is going to be removed. Port the driver to use
and benefit from the new API functionality.

Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/tile_edac.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/tile_edac.c b/drivers/edac/tile_edac.c
index 6314ff9..0e4d628 100644
--- a/drivers/edac/tile_edac.c
+++ b/drivers/edac/tile_edac.c
@@ -71,7 +71,10 @@ static void tile_edac_check(struct mem_ctl_info *mci)
 	if (mem_error.sbe_count != priv->ce_count) {
 		dev_dbg(mci->dev, "ECC CE err on node %d\n", priv->node);
 		priv->ce_count = mem_error.sbe_count;
-		edac_mc_handle_ce(mci, 0, 0, 0, 0, 0, mci->ctl_name);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     0, 0, 0,
+				     0, 0, -1,
+				     mci->ctl_name, "", NULL);
 	}
 }
 
@@ -122,6 +125,7 @@ static int __devinit tile_edac_mc_probe(struct platform_device *pdev)
 	char			hv_file[32];
 	int			hv_devhdl;
 	struct mem_ctl_info	*mci;
+	struct edac_mc_layer	layers[2];
 	struct tile_edac_priv	*priv;
 	int			rc;
 
@@ -131,8 +135,14 @@ static int __devinit tile_edac_mc_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	/* A TILE MC has a single channel and one chip-select row. */
-	mci = edac_mc_alloc(sizeof(struct tile_edac_priv),
-		TILE_EDAC_NR_CSROWS, TILE_EDAC_NR_CHANS, pdev->id);
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = TILE_EDAC_NR_CSROWS;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = TILE_EDAC_NR_CHANS;
+	layers[1].is_csrow = false;
+	mci = new_edac_mc_alloc(pdev->id, ARRAY_SIZE(layers), layers, false,
+			    sizeof(struct tile_edac_priv));
 	if (mci == NULL)
 		return -ENOMEM;
 	priv = mci->pvt_info;
-- 
1.7.8


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab2DPU2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:28:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665Ab2DPUVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:21:53 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jason Uhlenkott <juhlenko@akamai.com>
Subject: [EDAC_ABI PATCH v13 07/26] i3000_edac: convert driver to use the new edac ABI
Date: Mon, 16 Apr 2012 17:21:26 -0300
Message-Id: <1334607705-30320-8-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334607705-30320-1-git-send-email-mchehab@redhat.com>
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607705-30320-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy edac ABI is going to be removed. Port the driver to use
and benefit from the new API functionality.

Cc: Jason Uhlenkott <juhlenko@akamai.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i3000_edac.c |   25 ++++++++++++++++++++-----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/edac/i3000_edac.c b/drivers/edac/i3000_edac.c
index bf8a230..9b2c561 100644
--- a/drivers/edac/i3000_edac.c
+++ b/drivers/edac/i3000_edac.c
@@ -245,7 +245,9 @@ static int i3000_process_error_info(struct mem_ctl_info *mci,
 		return 1;
 
 	if ((info->errsts ^ info->errsts2) & I3000_ERRSTS_BITS) {
-		edac_mc_handle_ce_no_info(mci, "UE overwrote CE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+				     -1, -1, -1,
+				     "UE overwrote CE", "", NULL);
 		info->errsts = info->errsts2;
 	}
 
@@ -256,10 +258,15 @@ static int i3000_process_error_info(struct mem_ctl_info *mci,
 	row = edac_mc_find_csrow_by_page(mci, pfn);
 
 	if (info->errsts & I3000_ERRSTS_UE)
-		edac_mc_handle_ue(mci, pfn, offset, row, "i3000 UE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     pfn, offset, 0,
+				     row, -1, -1,
+				     "i3000 UE", "", NULL);
 	else
-		edac_mc_handle_ce(mci, pfn, offset, info->derrsyn, row,
-				multi_chan ? channel : 0, "i3000 CE");
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     pfn, offset, info->derrsyn,
+				     row, multi_chan ? channel : 0, -1,
+				     "i3000 CE", "", NULL);
 
 	return 1;
 }
@@ -306,6 +313,7 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 	int rc;
 	int i, j;
 	struct mem_ctl_info *mci = NULL;
+	struct edac_mc_layer layers[2];
 	unsigned long last_cumul_size, nr_pages;
 	int interleaved, nr_channels;
 	unsigned char dra[I3000_RANKS / 2], drb[I3000_RANKS];
@@ -347,7 +355,14 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 	 */
 	interleaved = i3000_is_interleaved(c0dra, c1dra, c0drb, c1drb);
 	nr_channels = interleaved ? 2 : 1;
-	mci = edac_mc_alloc(0, I3000_RANKS / nr_channels, nr_channels, 0);
+
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = I3000_RANKS / nr_channels;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = nr_channels;
+	layers[1].is_csrow = false;
+	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
 	if (!mci)
 		return -ENOMEM;
 
-- 
1.7.8


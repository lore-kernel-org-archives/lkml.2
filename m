Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964776Ab2ERQhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:37:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758884Ab2ERQd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:33:27 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Subject: [PATCH EDAC v26 22/66] i82860_edac: convert driver to use the new edac ABI
Date: Fri, 18 May 2012 13:32:09 -0300
Message-Id: <1337358773-6919-23-git-send-email-mchehab@redhat.com>
In-Reply-To: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
References: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy edac ABI is going to be removed. Port the driver to use
and benefit from the new API functionality.

Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i82860_edac.c |   42 +++++++++++++++++++++++++++++-------------
 1 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/edac/i82860_edac.c b/drivers/edac/i82860_edac.c
index 8485bbf..8834e4e 100644
--- a/drivers/edac/i82860_edac.c
+++ b/drivers/edac/i82860_edac.c
@@ -99,6 +99,7 @@ static int i82860_process_error_info(struct mem_ctl_info *mci,
 				struct i82860_error_info *info,
 				int handle_errors)
 {
+	struct dimm_info *dimm;
 	int row;
 
 	if (!(info->errsts2 & 0x0003))
@@ -108,18 +109,25 @@ static int i82860_process_error_info(struct mem_ctl_info *mci,
 		return 1;
 
 	if ((info->errsts ^ info->errsts2) & 0x0003) {
-		edac_mc_handle_ce_no_info(mci, "UE overwrote CE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+				     -1, -1, -1, "UE overwrote CE", "", NULL);
 		info->errsts = info->errsts2;
 	}
 
 	info->eap >>= PAGE_SHIFT;
 	row = edac_mc_find_csrow_by_page(mci, info->eap);
+	dimm = mci->csrows[row].channels[0].dimm;
 
 	if (info->errsts & 0x0002)
-		edac_mc_handle_ue(mci, info->eap, 0, row, "i82860 UE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     info->eap, 0, 0,
+				     dimm->location[0], dimm->location[1], -1,
+				     "i82860 UE", "", NULL);
 	else
-		edac_mc_handle_ce(mci, info->eap, 0, info->derrsyn, row, 0,
-				"i82860 UE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     info->eap, 0, info->derrsyn,
+				     dimm->location[0], dimm->location[1], -1,
+				     "i82860 CE", "", NULL);
 
 	return 1;
 }
@@ -179,18 +187,26 @@ static void i82860_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev)
 static int i82860_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	struct i82860_error_info discard;
 
-	/* RDRAM has channels but these don't map onto the abstractions that
-	   edac uses.
-	   The device groups from the GRA registers seem to map reasonably
-	   well onto the notion of a chip select row.
-	   There are 16 GRA registers and since the name is associated with
-	   the channel and the GRA registers map to physical devices so we are
-	   going to make 1 channel for group.
+	/*
+	 * RDRAM has channels but these don't map onto the csrow abstraction.
+	 * According with the datasheet, there are 2 Rambus channels, supporting
+	 * up to 16 direct RDRAM devices.
+	 * The device groups from the GRA registers seem to map reasonably
+	 * well onto the notion of a chip select row.
+	 * There are 16 GRA registers and since the name is associated with
+	 * the channel and the GRA registers map to physical devices so we are
+	 * going to make 1 channel for group.
 	 */
-	mci = edac_mc_alloc(0, 16, 1, 0);
-
+	layers[0].type = EDAC_MC_LAYER_CHANNEL;
+	layers[0].size = 2;
+	layers[0].is_virt_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_SLOT;
+	layers[1].size = 8;
+	layers[1].is_virt_csrow = true;
+	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers, 0);
 	if (!mci)
 		return -ENOMEM;
 
-- 
1.7.8


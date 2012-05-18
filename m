Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965445Ab2ERQvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:51:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754965Ab2ERQdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:33:03 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tim Small <tim@buttersideup.com>
Subject: [PATCH EDAC v26 21/66] i82443bxgx_edac: convert driver to use the new edac ABI
Date: Fri, 18 May 2012 13:32:08 -0300
Message-Id: <1337358773-6919-22-git-send-email-mchehab@redhat.com>
In-Reply-To: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
References: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy edac ABI is going to be removed. Port the driver to use
and benefit from the new API functionality.

Cc: Tim Small <tim@buttersideup.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i82443bxgx_edac.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/edac/i82443bxgx_edac.c b/drivers/edac/i82443bxgx_edac.c
index 02b252a..524f9a2 100644
--- a/drivers/edac/i82443bxgx_edac.c
+++ b/drivers/edac/i82443bxgx_edac.c
@@ -156,19 +156,19 @@ static int i82443bxgx_edacmc_process_error_info(struct mem_ctl_info *mci,
 	if (info->eap & I82443BXGX_EAP_OFFSET_SBE) {
 		error_found = 1;
 		if (handle_errors)
-			edac_mc_handle_ce(mci, page, pageoffset,
-				/* 440BX/GX don't make syndrome information
-				 * available */
-				0, edac_mc_find_csrow_by_page(mci, page), 0,
-				mci->ctl_name);
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+					     page, pageoffset, 0,
+					     edac_mc_find_csrow_by_page(mci, page),
+					     0, -1, mci->ctl_name, "", NULL);
 	}
 
 	if (info->eap & I82443BXGX_EAP_OFFSET_MBE) {
 		error_found = 1;
 		if (handle_errors)
-			edac_mc_handle_ue(mci, page, pageoffset,
-					edac_mc_find_csrow_by_page(mci, page),
-					mci->ctl_name);
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+					     page, pageoffset, 0,
+					     edac_mc_find_csrow_by_page(mci, page),
+					     0, -1, mci->ctl_name, "", NULL);
 	}
 
 	return error_found;
@@ -235,6 +235,7 @@ static void i82443bxgx_init_csrows(struct mem_ctl_info *mci,
 static int i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	u8 dramc;
 	u32 nbxcfg, ecc_mode;
 	enum mem_type mtype;
@@ -248,8 +249,13 @@ static int i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
 	if (pci_read_config_dword(pdev, I82443BXGX_NBXCFG, &nbxcfg))
 		return -EIO;
 
-	mci = edac_mc_alloc(0, I82443BXGX_NR_CSROWS, I82443BXGX_NR_CHANS, 0);
-
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = I82443BXGX_NR_CSROWS;
+	layers[0].is_virt_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = I82443BXGX_NR_CHANS;
+	layers[1].is_virt_csrow = false;
+	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers, 0);
 	if (mci == NULL)
 		return -ENOMEM;
 
-- 
1.7.8


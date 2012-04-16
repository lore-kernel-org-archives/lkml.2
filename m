Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab2DPUWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:22:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab2DPUWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:22:15 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Subject: [EDAC_ABI PATCH v13 02/26] amd76x_edac: convert driver to use the new edac ABI
Date: Mon, 16 Apr 2012 17:21:21 -0300
Message-Id: <1334607705-30320-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334607705-30320-1-git-send-email-mchehab@redhat.com>
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607705-30320-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy edac ABI is going to be removed. Port the driver to use
and benefit from the new API functionality.

Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/amd76x_edac.c |   28 +++++++++++++++++++---------
 1 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/edac/amd76x_edac.c b/drivers/edac/amd76x_edac.c
index 1532750..fd9ab44 100644
--- a/drivers/edac/amd76x_edac.c
+++ b/drivers/edac/amd76x_edac.c
@@ -29,7 +29,6 @@
 	edac_mc_chipset_printk(mci, level, "amd76x", fmt, ##arg)
 
 #define AMD76X_NR_CSROWS 8
-#define AMD76X_NR_CHANS  1
 #define AMD76X_NR_DIMMS  4
 
 /* AMD 76x register addresses - device 0 function 0 - PCI bridge */
@@ -146,8 +145,10 @@ static int amd76x_process_error_info(struct mem_ctl_info *mci,
 
 		if (handle_errors) {
 			row = (info->ecc_mode_status >> 4) & 0xf;
-			edac_mc_handle_ue(mci, mci->csrows[row].first_page, 0,
-					row, mci->ctl_name);
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+					     mci->csrows[row].first_page, 0, 0,
+					     row, 0, -1,
+					     mci->ctl_name, "", NULL);
 		}
 	}
 
@@ -159,8 +160,10 @@ static int amd76x_process_error_info(struct mem_ctl_info *mci,
 
 		if (handle_errors) {
 			row = info->ecc_mode_status & 0xf;
-			edac_mc_handle_ce(mci, mci->csrows[row].first_page, 0,
-					0, row, 0, mci->ctl_name);
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+					     mci->csrows[row].first_page, 0, 0,
+					     row, 0, -1,
+					     mci->ctl_name, "", NULL);
 		}
 	}
 
@@ -232,7 +235,8 @@ static int amd76x_probe1(struct pci_dev *pdev, int dev_idx)
 		EDAC_SECDED,
 		EDAC_SECDED
 	};
-	struct mem_ctl_info *mci = NULL;
+	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	u32 ems;
 	u32 ems_mode;
 	struct amd76x_error_info discard;
@@ -240,11 +244,17 @@ static int amd76x_probe1(struct pci_dev *pdev, int dev_idx)
 	debugf0("%s()\n", __func__);
 	pci_read_config_dword(pdev, AMD76X_ECC_MODE_STATUS, &ems);
 	ems_mode = (ems >> 10) & 0x3;
-	mci = edac_mc_alloc(0, AMD76X_NR_CSROWS, AMD76X_NR_CHANS, 0);
 
-	if (mci == NULL) {
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = AMD76X_NR_CSROWS;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = 1;
+	layers[1].is_csrow = false;
+	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, 0);
+
+	if (mci == NULL)
 		return -ENOMEM;
-	}
 
 	debugf0("%s(): mci = %p\n", __func__, mci);
 	mci->dev = &pdev->dev;
-- 
1.7.8


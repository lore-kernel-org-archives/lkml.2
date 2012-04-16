Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab2DPUYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:24:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755098Ab2DPUV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:21:59 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Egor Martovetsky <egor@pasemi.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: [EDAC_ABI PATCH v13 20/26] pasemi_edac: convert driver to use the new edac ABI
Date: Mon, 16 Apr 2012 17:21:39 -0300
Message-Id: <1334607705-30320-21-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334607705-30320-1-git-send-email-mchehab@redhat.com>
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607705-30320-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy edac ABI is going to be removed. Port the driver to use
and benefit from the new API functionality.

Cc: Olof Johansson <olof@lixom.net>
Cc: Egor Martovetsky <egor@pasemi.com>
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/pasemi_edac.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/edac/pasemi_edac.c b/drivers/edac/pasemi_edac.c
index 3fcefda..addf893 100644
--- a/drivers/edac/pasemi_edac.c
+++ b/drivers/edac/pasemi_edac.c
@@ -110,15 +110,16 @@ static void pasemi_edac_process_error_info(struct mem_ctl_info *mci, u32 errsta)
 	/* uncorrectable/multi-bit errors */
 	if (errsta & (MCDEBUG_ERRSTA_MBE_STATUS |
 		      MCDEBUG_ERRSTA_RFL_STATUS)) {
-		edac_mc_handle_ue(mci, mci->csrows[cs].first_page, 0,
-				  cs, mci->ctl_name);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     mci->csrows[cs].first_page, 0, 0,
+				     cs, 0, -1, mci->ctl_name, "", NULL);
 	}
 
 	/* correctable/single-bit errors */
-	if (errsta & MCDEBUG_ERRSTA_SBE_STATUS) {
-		edac_mc_handle_ce(mci, mci->csrows[cs].first_page, 0,
-				  0, cs, 0, mci->ctl_name);
-	}
+	if (errsta & MCDEBUG_ERRSTA_SBE_STATUS)
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     mci->csrows[cs].first_page, 0, 0,
+				     cs, 0, -1, mci->ctl_name, "", NULL);
 }
 
 static void pasemi_edac_check(struct mem_ctl_info *mci)
@@ -191,6 +192,7 @@ static int __devinit pasemi_edac_probe(struct pci_dev *pdev,
 		const struct pci_device_id *ent)
 {
 	struct mem_ctl_info *mci = NULL;
+	struct edac_mc_layer layers[2];
 	u32 errctl1, errcor, scrub, mcen;
 
 	pci_read_config_dword(pdev, MCCFG_MCEN, &mcen);
@@ -207,9 +209,14 @@ static int __devinit pasemi_edac_probe(struct pci_dev *pdev,
 		MCDEBUG_ERRCTL1_RFL_LOG_EN;
 	pci_write_config_dword(pdev, MCDEBUG_ERRCTL1, errctl1);
 
-	mci = edac_mc_alloc(0, PASEMI_EDAC_NR_CSROWS, PASEMI_EDAC_NR_CHANS,
-				system_mmc_id++);
-
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = PASEMI_EDAC_NR_CSROWS;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = PASEMI_EDAC_NR_CHANS;
+	layers[1].is_csrow = false;
+	mci = new_edac_mc_alloc(system_mmc_id++, ARRAY_SIZE(layers), layers, false,
+			    0);
 	if (mci == NULL)
 		return -ENOMEM;
 
-- 
1.7.8


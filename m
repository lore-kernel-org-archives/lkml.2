Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731Ab2ERQgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:36:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758893Ab2ERQd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:33:28 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH EDAC v26 28/66] ppc4xx_edac: convert driver to use the new edac ABI
Date: Fri, 18 May 2012 13:32:15 -0300
Message-Id: <1337358773-6919-29-git-send-email-mchehab@redhat.com>
In-Reply-To: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
References: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy edac ABI is going to be removed. Port the driver to use
and benefit from the new API functionality.

Cc: Josh Boyer <jwboyer@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/ppc4xx_edac.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
index 95cfc0f..59f50b6 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -727,7 +727,10 @@ ppc4xx_edac_handle_ce(struct mem_ctl_info *mci,
 
 	for (row = 0; row < mci->nr_csrows; row++)
 		if (ppc4xx_edac_check_bank_error(status, row))
-			edac_mc_handle_ce_no_info(mci, message);
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+					     0, 0, 0,
+					     row, 0, -1,
+					     message, "", NULL);
 }
 
 /**
@@ -755,7 +758,10 @@ ppc4xx_edac_handle_ue(struct mem_ctl_info *mci,
 
 	for (row = 0; row < mci->nr_csrows; row++)
 		if (ppc4xx_edac_check_bank_error(status, row))
-			edac_mc_handle_ue(mci, page, offset, row, message);
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+					     page, offset, 0,
+					     row, 0, -1,
+					     message, "", NULL);
 }
 
 /**
@@ -1233,6 +1239,7 @@ static int __devinit ppc4xx_edac_probe(struct platform_device *op)
 	dcr_host_t dcr_host;
 	const struct device_node *np = op->dev.of_node;
 	struct mem_ctl_info *mci = NULL;
+	struct edac_mc_layer layers[2];
 	static int ppc4xx_edac_instance;
 
 	/*
@@ -1278,12 +1285,14 @@ static int __devinit ppc4xx_edac_probe(struct platform_device *op)
 	 * controller instance and perform the appropriate
 	 * initialization.
 	 */
-
-	mci = edac_mc_alloc(sizeof(struct ppc4xx_edac_pdata),
-			    ppc4xx_edac_nr_csrows,
-			    ppc4xx_edac_nr_chans,
-			    ppc4xx_edac_instance);
-
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = ppc4xx_edac_nr_csrows;
+	layers[0].is_virt_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = ppc4xx_edac_nr_chans;
+	layers[1].is_virt_csrow = false;
+	mci = new_edac_mc_alloc(ppc4xx_edac_instance, ARRAY_SIZE(layers), layers,
+			    sizeof(struct ppc4xx_edac_pdata));
 	if (mci == NULL) {
 		ppc4xx_edac_printk(KERN_ERR, "%s: "
 				   "Failed to allocate EDAC MC instance!\n",
-- 
1.7.8


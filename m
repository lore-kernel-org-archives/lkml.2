Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab2DPUWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:22:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab2DPUWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:22:18 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michal Marek <mmarek@suse.cz>
Subject: [EDAC_ABI PATCH v13 04/26] cpc925_edac: convert driver to use the new edac ABI
Date: Mon, 16 Apr 2012 17:21:23 -0300
Message-Id: <1334607705-30320-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334607705-30320-1-git-send-email-mchehab@redhat.com>
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607705-30320-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy edac ABI is going to be removed. Port the driver to use
and benefit from the new API functionality.

Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/cpc925_edac.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
index 7b764a8..adbeb13 100644
--- a/drivers/edac/cpc925_edac.c
+++ b/drivers/edac/cpc925_edac.c
@@ -555,13 +555,18 @@ static void cpc925_mc_check(struct mem_ctl_info *mci)
 	if (apiexcp & CECC_EXCP_DETECTED) {
 		cpc925_mc_printk(mci, KERN_INFO, "DRAM CECC Fault\n");
 		channel = cpc925_mc_find_channel(mci, syndrome);
-		edac_mc_handle_ce(mci, pfn, offset, syndrome,
-				  csrow, channel, mci->ctl_name);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     pfn, offset, syndrome,
+				     csrow, channel, -1,
+				     mci->ctl_name, "", NULL);
 	}
 
 	if (apiexcp & UECC_EXCP_DETECTED) {
 		cpc925_mc_printk(mci, KERN_INFO, "DRAM UECC Fault\n");
-		edac_mc_handle_ue(mci, pfn, offset, csrow, mci->ctl_name);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     pfn, offset, 0,
+				     csrow, -1, -1,
+				     mci->ctl_name, "", NULL);
 	}
 
 	cpc925_mc_printk(mci, KERN_INFO, "Dump registers:\n");
@@ -933,6 +938,7 @@ static int __devinit cpc925_probe(struct platform_device *pdev)
 {
 	static int edac_mc_idx;
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	void __iomem *vbase;
 	struct cpc925_mc_pdata *pdata;
 	struct resource *r;
@@ -969,8 +975,15 @@ static int __devinit cpc925_probe(struct platform_device *pdev)
 	}
 
 	nr_channels = cpc925_mc_get_channels(vbase) + 1;
-	mci = edac_mc_alloc(sizeof(struct cpc925_mc_pdata),
-			CPC925_NR_CSROWS, nr_channels, edac_mc_idx);
+
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = CPC925_NR_CSROWS;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = nr_channels;
+	layers[1].is_csrow = false;
+	mci = new_edac_mc_alloc(edac_mc_idx, ARRAY_SIZE(layers), layers, false,
+			    sizeof(struct cpc925_mc_pdata));
 	if (!mci) {
 		cpc925_printk(KERN_ERR, "No memory for mem_ctl_info\n");
 		res = -ENOMEM;
-- 
1.7.8


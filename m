Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965161Ab2ERQtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:49:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758528Ab2ERQdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:33:04 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH EDAC v26 15/66] i3200_edac: convert driver to use the new edac ABI
Date: Fri, 18 May 2012 13:32:02 -0300
Message-Id: <1337358773-6919-16-git-send-email-mchehab@redhat.com>
In-Reply-To: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
References: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy edac ABI is going to be removed. Port the driver to use
and benefit from the new API functionality.

Cc: Hitoshi Mitake <h.mitake@gmail.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i3200_edac.c |   32 ++++++++++++++++++++++----------
 1 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
index 3b36222..d152662 100644
--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -23,6 +23,7 @@
 
 #define PCI_DEVICE_ID_INTEL_3200_HB    0x29f0
 
+#define I3200_DIMMS		4
 #define I3200_RANKS		8
 #define I3200_RANKS_PER_CHANNEL	4
 #define I3200_CHANNELS		2
@@ -217,21 +218,25 @@ static void i3200_process_error_info(struct mem_ctl_info *mci,
 		return;
 
 	if ((info->errsts ^ info->errsts2) & I3200_ERRSTS_BITS) {
-		edac_mc_handle_ce_no_info(mci, "UE overwrote CE");
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0,
+				     -1, -1, -1, "UE overwrote CE", "", NULL);
 		info->errsts = info->errsts2;
 	}
 
 	for (channel = 0; channel < nr_channels; channel++) {
 		log = info->eccerrlog[channel];
 		if (log & I3200_ECCERRLOG_UE) {
-			edac_mc_handle_ue(mci, 0, 0,
-				eccerrlog_row(channel, log),
-				"i3200 UE");
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+					     0, 0, 0,
+					     eccerrlog_row(channel, log),
+					     -1, -1,
+					     "i3000 UE", "", NULL);
 		} else if (log & I3200_ECCERRLOG_CE) {
-			edac_mc_handle_ce(mci, 0, 0,
-				eccerrlog_syndrome(log),
-				eccerrlog_row(channel, log), 0,
-				"i3200 CE");
+			edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+					     0, 0, eccerrlog_syndrome(log),
+					     eccerrlog_row(channel, log),
+					     -1, -1,
+					     "i3000 UE", "", NULL);
 		}
 	}
 }
@@ -321,6 +326,7 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 	int rc;
 	int i, j;
 	struct mem_ctl_info *mci = NULL;
+	struct edac_mc_layer layers[2];
 	u16 drbs[I3200_CHANNELS][I3200_RANKS_PER_CHANNEL];
 	bool stacked;
 	void __iomem *window;
@@ -335,8 +341,14 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 	i3200_get_drbs(window, drbs);
 	nr_channels = how_many_channels(pdev);
 
-	mci = edac_mc_alloc(sizeof(struct i3200_priv), I3200_RANKS,
-		nr_channels, 0);
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = I3200_DIMMS;
+	layers[0].is_virt_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = nr_channels;
+	layers[1].is_virt_csrow = false;
+	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
+			    sizeof(struct i3200_priv));
 	if (!mci)
 		return -ENOMEM;
 
-- 
1.7.8


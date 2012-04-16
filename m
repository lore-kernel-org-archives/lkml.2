Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab2DPUaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:30:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443Ab2DPUVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:21:52 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: [EDAC_ABI PATCH v13 06/26] e7xxx_edac: convert driver to use the new edac ABI
Date: Mon, 16 Apr 2012 17:21:25 -0300
Message-Id: <1334607705-30320-7-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334607705-30320-1-git-send-email-mchehab@redhat.com>
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607705-30320-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy edac ABI is going to be removed. Port the driver to use
and benefit from the new API functionality.

Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/e7xxx_edac.c |   37 ++++++++++++++++++++++++++++++-------
 1 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/edac/e7xxx_edac.c b/drivers/edac/e7xxx_edac.c
index aeb69f0..9380f8a 100644
--- a/drivers/edac/e7xxx_edac.c
+++ b/drivers/edac/e7xxx_edac.c
@@ -10,6 +10,9 @@
  * Based on work by Dan Hollis <goemon at anime dot net> and others.
  *	http://www.anime.net/~goemon/linux-ecc/
  *
+ * Datasheet:
+ *	http://www.intel.com/content/www/us/en/chipsets/e7501-chipset-memory-controller-hub-datasheet.html
+ *
  * Contributors:
  *	Eric Biederman (Linux Networx)
  *	Tom Zimmerman (Linux Networx)
@@ -71,7 +74,7 @@
 #endif				/* PCI_DEVICE_ID_INTEL_7505_1_ERR */
 
 #define E7XXX_NR_CSROWS		8	/* number of csrows */
-#define E7XXX_NR_DIMMS		8	/* FIXME - is this correct? */
+#define E7XXX_NR_DIMMS		8	/* 2 channels, 4 dimms/channel */
 
 /* E7XXX register addresses - device 0 function 0 */
 #define E7XXX_DRB		0x60	/* DRAM row boundary register (8b) */
@@ -216,13 +219,15 @@ static void process_ce(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
 	row = edac_mc_find_csrow_by_page(mci, page);
 	/* convert syndrome to channel */
 	channel = e7xxx_find_channel(syndrome);
-	edac_mc_handle_ce(mci, page, 0, syndrome, row, channel, "e7xxx CE");
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, page, 0, syndrome,
+			     row, channel, -1, "e7xxx CE", "", NULL);
 }
 
 static void process_ce_no_info(struct mem_ctl_info *mci)
 {
 	debugf3("%s()\n", __func__);
-	edac_mc_handle_ce_no_info(mci, "e7xxx CE log register overflow");
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0, -1, -1, -1,
+			     "e7xxx CE log register overflow", "", NULL);
 }
 
 static void process_ue(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
@@ -236,13 +241,17 @@ static void process_ue(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
 	/* FIXME - should use PAGE_SHIFT */
 	block_page = error_2b >> 6;	/* convert to 4k address */
 	row = edac_mc_find_csrow_by_page(mci, block_page);
-	edac_mc_handle_ue(mci, block_page, 0, row, "e7xxx UE");
+
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, block_page, 0, 0,
+			     row, -1, -1, "e7xxx UE", "", NULL);
 }
 
 static void process_ue_no_info(struct mem_ctl_info *mci)
 {
 	debugf3("%s()\n", __func__);
-	edac_mc_handle_ue_no_info(mci, "e7xxx UE log register overflow");
+
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 0, 0, 0, -1, -1, -1,
+			     "e7xxx UE log register overflow", "", NULL);
 }
 
 static void e7xxx_get_error_info(struct mem_ctl_info *mci,
@@ -413,6 +422,7 @@ static int e7xxx_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	u16 pci_data;
 	struct mem_ctl_info *mci = NULL;
+	struct edac_mc_layer layers[2];
 	struct e7xxx_pvt *pvt = NULL;
 	u32 drc;
 	int drc_chan;
@@ -423,8 +433,21 @@ static int e7xxx_probe1(struct pci_dev *pdev, int dev_idx)
 	pci_read_config_dword(pdev, E7XXX_DRC, &drc);
 
 	drc_chan = dual_channel_active(drc, dev_idx);
-	mci = edac_mc_alloc(sizeof(*pvt), E7XXX_NR_CSROWS, drc_chan + 1, 0);
-
+	/*
+	 * According with the datasheet, this device has a maximum of
+	 * 4 DIMMS per channel, either single-rank or dual-rank. So, the
+	 * total amount of dimms is 8 (E7XXX_NR_DIMMS).
+	 * That means that the DIMM is mapped as CSROWs, and the channel
+	 * will map the rank. So, an error to either channel should be
+	 * attributed to the same dimm.
+	 */
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = E7XXX_NR_CSROWS;
+	layers[0].is_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = drc_chan + 1;
+	layers[1].is_csrow = false;
+	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false, sizeof(*pvt));
 	if (mci == NULL)
 		return -ENOMEM;
 
-- 
1.7.8


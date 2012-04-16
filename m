Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab2DPUY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:24:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876Ab2DPUV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:21:57 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ericsson.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [EDAC_ABI PATCH v13 10/26] i5100_edac: convert driver to use the new edac ABI
Date: Mon, 16 Apr 2012 17:21:29 -0300
Message-Id: <1334607705-30320-11-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334607705-30320-1-git-send-email-mchehab@redhat.com>
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607705-30320-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy edac ABI is going to be removed. Port the driver to use
and benefit from the new API functionality.

Cc: "Niklas Söderlund" <niklas.soderlund@ericsson.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i5100_edac.c |   90 ++++++++++++++++++++-------------------------
 1 files changed, 40 insertions(+), 50 deletions(-)

diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index a0219a9..ec5de18 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -14,6 +14,11 @@
  * rows for each respective channel are laid out one after another,
  * the first half belonging to channel 0, the second half belonging
  * to channel 1.
+ *
+ * This driver is for DDR2 DIMMs, and it uses chip select to select among the
+ * several ranks. However, instead of showing memories as ranks, it outputs
+ * them as DIMM's. An internal table creates the association between ranks
+ * and DIMM's.
  */
 #include <linux/module.h>
 #include <linux/init.h>
@@ -410,14 +415,6 @@ static int i5100_csrow_to_chan(const struct mem_ctl_info *mci, int csrow)
 	return csrow / priv->ranksperchan;
 }
 
-static unsigned i5100_rank_to_csrow(const struct mem_ctl_info *mci,
-				    int chan, int rank)
-{
-	const struct i5100_priv *priv = mci->pvt_info;
-
-	return chan * priv->ranksperchan + rank;
-}
-
 static void i5100_handle_ce(struct mem_ctl_info *mci,
 			    int chan,
 			    unsigned bank,
@@ -427,21 +424,17 @@ static void i5100_handle_ce(struct mem_ctl_info *mci,
 			    unsigned ras,
 			    const char *msg)
 {
-	const int csrow = i5100_rank_to_csrow(mci, chan, rank);
-	char *label = NULL;
+	char detail[80];
 
-	if (mci->csrows[csrow].channels[0].dimm)
-		label = mci->csrows[csrow].channels[0].dimm->label;
+	/* Form out message */
+	snprintf(detail, sizeof(detail),
+		 "bank %u, cas %u, ras %u\n",
+		 bank, cas, ras);
 
-	printk(KERN_ERR
-		"CE chan %d, bank %u, rank %u, syndrome 0x%lx, "
-		"cas %u, ras %u, csrow %u, label \"%s\": %s\n",
-		chan, bank, rank, syndrome, cas, ras,
-		csrow, label, msg);
-
-	mci->ce_count++;
-	mci->csrows[csrow].ce_count++;
-	mci->csrows[csrow].channels[0].ce_count++;
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+			     0, 0, syndrome,
+			     chan, rank, -1,
+			     msg, detail, NULL);
 }
 
 static void i5100_handle_ue(struct mem_ctl_info *mci,
@@ -453,20 +446,17 @@ static void i5100_handle_ue(struct mem_ctl_info *mci,
 			    unsigned ras,
 			    const char *msg)
 {
-	const int csrow = i5100_rank_to_csrow(mci, chan, rank);
-	char *label = NULL;
-
-	if (mci->csrows[csrow].channels[0].dimm)
-		label = mci->csrows[csrow].channels[0].dimm->label;
+	char detail[80];
 
-	printk(KERN_ERR
-		"UE chan %d, bank %u, rank %u, syndrome 0x%lx, "
-		"cas %u, ras %u, csrow %u, label \"%s\": %s\n",
-		chan, bank, rank, syndrome, cas, ras,
-		csrow, label, msg);
+	/* Form out message */
+	snprintf(detail, sizeof(detail),
+		 "bank %u, cas %u, ras %u\n",
+		 bank, cas, ras);
 
-	mci->ue_count++;
-	mci->csrows[csrow].ue_count++;
+	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+			     0, 0, syndrome,
+			     chan, rank, -1,
+			     msg, detail, NULL);
 }
 
 static void i5100_read_log(struct mem_ctl_info *mci, int chan,
@@ -843,11 +833,10 @@ static void __devinit i5100_init_interleaving(struct pci_dev *pdev,
 static void __devinit i5100_init_csrows(struct mem_ctl_info *mci)
 {
 	int i;
-	unsigned long total_pages = 0UL;
 	struct i5100_priv *priv = mci->pvt_info;
-	struct dimm_info *dimm;
 
-	for (i = 0; i < mci->nr_csrows; i++) {
+	for (i = 0; i < mci->tot_dimms; i++) {
+		struct dimm_info *dimm;
 		const unsigned long npages = i5100_npages(mci, i);
 		const unsigned chan = i5100_csrow_to_chan(mci, i);
 		const unsigned rank = i5100_csrow_to_rank(mci, i);
@@ -855,30 +844,23 @@ static void __devinit i5100_init_csrows(struct mem_ctl_info *mci)
 		if (!npages)
 			continue;
 
-		/*
-		 * FIXME: these two are totally bogus -- I don't see how to
-		 * map them correctly to this structure...
-		 */
-		mci->csrows[i].csrow_idx = i;
-		mci->csrows[i].mci = mci;
-		mci->csrows[i].nr_channels = 1;
-		mci->csrows[i].channels[0].csrow = mci->csrows + i;
-		total_pages += npages;
+		dimm = GET_POS(mci->layers, mci->dimms, mci->n_layers,
+			       chan, rank, 0);
 
-		dimm = mci->csrows[i].channels[0].dimm;
 		dimm->nr_pages = npages;
 		if (npages) {
-			total_pages += npages;
-
 			dimm->grain = 32;
 			dimm->dtype = (priv->mtr[chan][rank].width == 4) ?
-				DEV_X4 : DEV_X8;
+					DEV_X4 : DEV_X8;
 			dimm->mtype = MEM_RDDR2;
 			dimm->edac_mode = EDAC_SECDED;
 			snprintf(dimm->label, sizeof(dimm->label),
 				"DIMM%u",
 				i5100_rank_to_slot(mci, chan, rank));
 		}
+
+		debugf2("dimm channel %d, rank %d, size %zd\n",
+			chan, rank, PAGES_TO_MiB(npages));
 	}
 }
 
@@ -887,6 +869,7 @@ static int __devinit i5100_init_one(struct pci_dev *pdev,
 {
 	int rc;
 	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[2];
 	struct i5100_priv *priv;
 	struct pci_dev *ch0mm, *ch1mm;
 	int ret = 0;
@@ -947,7 +930,14 @@ static int __devinit i5100_init_one(struct pci_dev *pdev,
 		goto bail_ch1;
 	}
 
-	mci = edac_mc_alloc(sizeof(*priv), ranksperch * 2, 1, 0);
+	layers[0].type = EDAC_MC_LAYER_CHANNEL;
+	layers[0].size = 2;
+	layers[0].is_csrow = false;
+	layers[1].type = EDAC_MC_LAYER_SLOT;
+	layers[1].size = ranksperch;
+	layers[1].is_csrow = true;
+	mci = new_edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
+			    false, sizeof(*priv));
 	if (!mci) {
 		ret = -ENOMEM;
 		goto bail_disable_ch1;
-- 
1.7.8


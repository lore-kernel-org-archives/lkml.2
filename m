Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab2LOUoi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 15:44:38 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62016 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab2LOUoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 15:44:37 -0500
MIME-Version: 1.0
Date: Sun, 16 Dec 2012 02:14:36 +0530
Message-ID: <CAA_L+UPmkPVtJBiAanvHQOEmD9SjrSXWU01tCDinXXN8jLL_oQ@mail.gmail.com>
Subject: [PATCH 3.7.0 7/9] i82975x_edac: correct dimm label initialisation
From: Arvind R <arvino55@gmail.com>
To: linux-edac@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 3.7.0 7/9] i82975x_edac: correct dimm label initialisation

DIMM label are the legends on the mobo. Fix their initialisation
to correspond to the legends.
Channels are designated A/B. A single DIMM occupies 2 ranks. And
the first DIMM is 1, not 0. This is as found in Asus P5WDG2 family
of mobos. This patch maps to that.
Signed-off-by: Arvind R. <arvino55@gmail.com>
---
 i82975x_edac.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/drivers/edac/i82975x_edac.c	2012-12-15 22:32:00.000000000 +0530
+++ b/drivers/edac/i82975x_edac.c	2012-12-15 22:42:00.000000000 +0530
@@ -32,6 +32,7 @@
 #define I82975X_NR_DIMMS		8
 #define I82975X_NR_CSROWS(nr_chans)	(I82975X_NR_DIMMS / (nr_chans))
 #define	I82975X_NR_CSROWS_PER_CHANNEL	4
+#define	I82975X_NR_CSROWS_PER_DIMM	2

 /* Intel 82975X register addresses - device 0 function 0 - DRAM Controller */
 #define I82975X_EAP		0x58	/* Dram Error Address Pointer (32b)
@@ -339,13 +340,13 @@ static void i82975x_check(struct mem_ctl
 }

 static void i82975x_init_csrows(struct mem_ctl_info *mci,
-		struct pci_dev *pdev, void __iomem *mch_window)
+			void __iomem *mch_window)
 {
 	struct csrow_info *csrow;
 	unsigned long last_cumul_size;
 	u8 value;
 	u32 cumul_size, nr_pages;
-	int index, chan;
+	unsigned index, chan;
 	struct dimm_info *dimm;

 	last_cumul_size = 0;
@@ -370,7 +371,8 @@ static void i82975x_init_csrows(struct m
 		 * Adjust cumul_size w.r.t number of channels
 		 *
 		 */
-		if (csrow->nr_channels > 1)
+		if (mci->num_cschannel > 1)
+			/* dual_channel symmetric */
 			cumul_size <<= 1;
 		edac_dbg(3, "(%d) cumul_size 0x%x\n", index, cumul_size);

@@ -384,15 +386,18 @@ static void i82975x_init_csrows(struct m
 		 *   [0-7] for single-channel; i.e. csrow->nr_channels = 1
 		 *   [0-3] for dual-channel; i.e. csrow->nr_channels = 2
 		 */
-		for (chan = 0; chan < csrow->nr_channels; chan++) {
+		for (chan = 0; chan < mci->num_cschannel; chan++) {
 			dimm = mci->csrows[index]->channels[chan]->dimm;

-			dimm->nr_pages = nr_pages / csrow->nr_channels;
+			dimm->nr_pages = nr_pages / mci->num_cschannel;

 			snprintf(csrow->channels[chan]->dimm->label,
 				 EDAC_MC_LABEL_LEN, "DIMM %c%d",
-				 (chan == 0) ? 'A' : 'B',
-				 index);
+				 ((mci->num_cschannel <= 1) ?
+					index / I82975X_NR_CSROWS_PER_CHANNEL :
+					chan) + 'A',
+				 ((index % I82975X_NR_CSROWS_PER_CHANNEL) /
+					I82975X_NR_CSROWS_PER_DIMM) + 1);
 			dimm->grain = 1 << 7;	/* always */
 			dimm->dtype = DEV_X8;	/* only with ECC */
 			dimm->mtype = MEM_DDR2; /* only supported */
@@ -589,7 +594,7 @@ static int i82975x_probe1(struct pci_dev
 	mci->ctl_page_to_phys = NULL;
 	pvt = (struct i82975x_pvt *) mci->pvt_info;
 	pvt->chip = dev_idx;
-	i82975x_init_csrows(mci, pdev, mch_window);
+	i82975x_init_csrows(mci, mch_window);
 	mci->scrub_mode = SCRUB_HW_SRC;
 	i82975x_get_error_info(mci, &discard);  /* clear counters */

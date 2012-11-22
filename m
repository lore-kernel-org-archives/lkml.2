Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964780Ab2KVUwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:52:19 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:57748 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327Ab2KVUwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:52:13 -0500
MIME-Version: 1.0
Date: Thu, 22 Nov 2012 14:58:10 +0530
Message-ID: <CAA_L+UM6_MW6V9Mmzp+gmnrsZNw5VMAfpjWzQ8hfRSWL+yZgnw@mail.gmail.com>
Subject: [PATCH 3.6.6 3/3] i82975x_edac: fix fatal crash
From: Arvind R <arvino55@gmail.com>
To: linux-edac@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 3.6.6 3/3] i82975x_edac: fix fatal crash

This patch fixes the crash caused by combination of wrong memory layer
info and dimm_label initialisation.
It is also a rewite of csrow initialisation and error reporting to
handle ALL memory configurations supported by the controller.
 Tested on Asus P5WDG2-WS PRO with 7 ECC memory configurations -
 1 dimm installed, 2 dimms in assymetric mode, 2 dimms in symmetric
 mode, 3 dimms in assymmetric mode and 4 dimms in symmetric mode.
 The initialised values in sysfs were found consistent with installed
 memory in all tested cases.

Tested-by: Arvind R. <arvino55@gmail.com>
Signed-off-by: Arvind R. <arvino55@gmail.com>
---
 drivers/edac/i82975x_edac.c |  150 +++++++++++++++-------------------
 1 file changed, 69 insertions(+), 81 deletions(-)
diff -up a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
--- a/drivers/edac/i82975x_edac.c	2012-11-22 11:56:36.000000000 +0530
+++ b/drivers/edac/i82975x_edac.c	2012-11-22 10:29:51.000000000 +0530
@@ -29,8 +29,19 @@
 #define PCI_DEVICE_ID_INTEL_82975_0	0x277c
 #endif				/* PCI_DEVICE_ID_INTEL_82975_0 */

-#define I82975X_NR_DIMMS		8
-#define I82975X_NR_CSROWS(nr_chans)	(I82975X_NR_DIMMS / (nr_chans))
+#define I82975X_NR_ROWS_PER_CHANNEL	4	/* immutable, in controller */
+#define I82975X_NR_CHANS	2	/* immutable, in controller */
+/*
+ * the product of above immutable constants
+ * MUST equal
+ * the product of following 2 constants.
+ *
+ * max. value of either constant is 4.
+ */
+#define I82975X_RANKS_PER_DIMM	2	/* normally impl. on mobos */
+#define I82975X_NR_DIMMS	4	/* normally impl. on mobos */
+
+#define I82975X_GRAIN	7	/* immutable, in controller */

 /* Intel 82975X register addresses - device 0 function 0 - DRAM Controller */
 #define I82975X_EAP		0x58	/* Dram Error Address Pointer (32b)
@@ -305,32 +316,15 @@ static int i82975x_process_error_info(st
 	if (info->xeap & 1)
 		page |= 0x80000000;
 	page >>= (PAGE_SHIFT - 1);
+	chan = info->eap & 1;
 	row = edac_mc_find_csrow_by_page(mci, page);
+	offst = info->eap & ((1 << PAGE_SHIFT) - (1 << I82975X_GRAIN));
+	err_type = (info->errsts & I82975X_ERRSTS_UE)
+				? HW_EVENT_ERR_UNCORRECTED :
+					HW_EVENT_ERR_CORRECTED;

-	if (row == -1)	{
-		i82975x_mc_printk(mci, KERN_ERR, "error processing EAP:\n"
-			"\tXEAP=%u\n"
-			"\t EAP=0x%08x\n"
-			"\tPAGE=0x%08x\n",
-			(info->xeap & 1) ? 1 : 0, info->eap, (unsigned int) page);
-		return 0;
-	}
-	chan = (mci->csrows[row]->nr_channels == 1) ? 0 : info->eap & 1;
-	offst = info->eap
-			& ((1 << PAGE_SHIFT) -
-			   (1 << mci->csrows[row]->channels[chan]->dimm->grain));
-
-	if (info->errsts & 0x0002)
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
-				     page, offst, 0,
-				     row, -1, -1,
-				     "i82975x UE", "");
-	else
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
-				     page, offst, info->derrsyn,
-				     row, chan ? chan : 0, -1,
-				     "i82975x CE", "");
-
+	edac_mc_handle_error(err_type, mci, 1, page, offst, info->derrsyn,
+				     row, chan, -1, "i82975x UE", "");
 	return 1;
 }

@@ -343,20 +337,17 @@ static void i82975x_check(struct mem_ctl
 	i82975x_process_error_info(mci, &info, 1);
 }

-static void i82975x_init_csrows(struct mem_ctl_info *mci,
-		struct pci_dev *pdev, void __iomem *mch_window)
+static void __devinit i82975x_init_csrows(struct mem_ctl_info *mci,
+		void __iomem *mch_window, bool is_mode_symmetric)
 {
-	static const char *labels[4] = {
-							"DIMM A1", "DIMM A2",
-							"DIMM B1", "DIMM B2"
-						};
+	static const char *label_prefix = "DIMM";
+	static const char chan_designator[I82975X_NR_CHANS] = {'A', 'B'};
 	struct csrow_info *csrow;
 	unsigned long last_cumul_size;
 	u8 value;
 	u32 cumul_size, nr_pages;
-	int index, chan;
+	int row, chan;
 	struct dimm_info *dimm;
-	enum dev_type dtype;

 	last_cumul_size = 0;

@@ -369,47 +360,39 @@ static void i82975x_init_csrows(struct m
 	 *
 	 */

-	for (index = 0; index < mci->nr_csrows; index++) {
-		csrow = mci->csrows[index];
-
-		value = readb(mch_window + I82975X_DRB + index +
-					((index >= 4) ? 0x80 : 0));
-		cumul_size = value;
-		cumul_size <<= (I82975X_DRB_SHIFT - PAGE_SHIFT);
-		/*
-		 * Adjust cumul_size w.r.t number of channels
-		 *
-		 */
-		if (csrow->nr_channels > 1)
-			cumul_size <<= 1;
-		edac_dbg(3, "(%d) cumul_size 0x%x\n", index, cumul_size);
-
-		nr_pages = cumul_size - last_cumul_size;
-		if (!nr_pages)
-			continue;
-
-		/*
-		 * Initialise dram labels
-		 * index values:
-		 *   [0-7] for single-channel; i.e. csrow->nr_channels = 1
-		 *   [0-3] for dual-channel; i.e. csrow->nr_channels = 2
-		 */
-		for (chan = 0; chan < csrow->nr_channels; chan++) {
-			dimm = mci->csrows[index]->channels[chan]->dimm;
-
-			dimm->nr_pages = nr_pages / csrow->nr_channels;
-			strncpy(csrow->channels[chan]->dimm->label,
-					labels[(index >> 1) + (chan * 2)],
-					EDAC_MC_LABEL_LEN);
-			dimm->grain = 1 << 7;	/* always */
+	for (chan = 0; chan < mci->num_cschannel; chan++) {
+		for (row = 0; row < mci->nr_csrows; row++) {
+			value = readb(mch_window + I82975X_DRB
+					+ row + (chan ? 0x80 : 0));
+			cumul_size = value;
+			cumul_size <<= (I82975X_DRB_SHIFT - PAGE_SHIFT);
+			edac_dbg(3, "(row: %d ch: %d) cumul_size 0x%x\n",
+							row, chan, cumul_size);
+
+			nr_pages = cumul_size - last_cumul_size;
+			if (!nr_pages)
+				continue;
+			/*
+			 * Initialise dram labels
+			 */
+			csrow = mci->csrows[row];
+			dimm = csrow->channels[chan]->dimm;
+			dimm->nr_pages = nr_pages;
+			snprintf(dimm->label, EDAC_MC_LABEL_LEN, "%s %c%d",
+					label_prefix,
+					chan_designator[chan],
+					row / I82975X_RANKS_PER_DIMM);
+			dimm->grain = 1 << I82975X_GRAIN; /* always */
 			dimm->dtype = DEV_X8;	/* ECC only with DEV_X8 */
-			dimm->mtype = MEM_DDR2; /* only supported */
+			dimm->mtype = MEM_DDR2; /* supports only DDR2 */
 			dimm->edac_mode = EDAC_SECDED; /* only supported */
-		}

-		csrow->first_page = last_cumul_size;
-		csrow->last_page = cumul_size - 1;
-		last_cumul_size = cumul_size;
+			csrow->first_page = last_cumul_size;
+			csrow->last_page = cumul_size - 1;
+			last_cumul_size = cumul_size;
+		}
+		if (is_mode_symmetric)
+			last_cumul_size = 0;
 	}
 }

@@ -421,8 +404,8 @@ static bool __devinit detect_channel_mod
 	for (chan_mode = true, row = 0;
 			chan_mode && (row < I82975X_NR_ROWS_PER_CHANNEL);
 				row++)
-		chan_mode &= (readb(mch_window + I82975X_DRB + row) ==
-				readb(mch_window + I82975X_DRB + row + 0x80));
+		chan_mode &= (readb(mch_window + I82975X_DRB + row)
+			 == readb(mch_window + I82975X_DRB + row + 0x80));
 	return chan_mode;
 }

@@ -538,7 +521,6 @@ static int __devinit i82975x_probe1(stru
 	u32 mchbar;
 	u32 drc[2];
 	struct i82975x_error_info discard;
-	int	chans;
 	bool is_symmetric_config;

 	edac_dbg(0, "\n");
@@ -550,10 +532,13 @@ static int __devinit i82975x_probe1(stru
 	}
 	mchbar &= 0xffffc000;	/* bits 31:14 used for 16K window */
 	mch_window = ioremap_nocache(mchbar, 0x1000);
+	if (!mch_window)
+		return -ENODEV;

 	is_symmetric_config = detect_channel_mode(mch_window);
 	drc[0] = readl(mch_window + I82975X_DRC_CH0M0);
 	drc[1] = readl(mch_window + I82975X_DRC_CH1M0);
+
 #ifdef CONFIG_EDAC_DEBUG
 	i82975x_print_dram_config(mch_window, mchbar, drc,
 			is_symmetric_config);
@@ -567,10 +552,10 @@ static int __devinit i82975x_probe1(stru
 	}

 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
-	layers[0].size = I82975X_NR_DIMMS;
+	layers[0].size = I82975X_NR_ROWS_PER_CHANNEL;
 	layers[0].is_virt_csrow = true;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
-	layers[1].size = I82975X_NR_CSROWS(chans);
+	layers[1].size = I82975X_NR_CHANS;
 	layers[1].is_virt_csrow = false;
 	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, sizeof(*pvt));
 	if (!mci) {
@@ -589,11 +574,14 @@ static int __devinit i82975x_probe1(stru
 	mci->dev_name = pci_name(pdev);
 	mci->edac_check = i82975x_check;
 	mci->ctl_page_to_phys = NULL;
-	edac_dbg(3, "init pvt\n");
+	mci->scrub_mode = SCRUB_HW_SRC;
+
+	/* initialise private structure */
 	pvt = (struct i82975x_pvt *) mci->pvt_info;
 	pvt->mch_window = mch_window;
-	i82975x_init_csrows(mci, pdev, mch_window);
-	mci->scrub_mode = SCRUB_HW_SRC;
+
+	edac_dbg(3, "init csrows\n");
+	i82975x_init_csrows(mci, mch_window, is_symmetric_config);
 	i82975x_get_error_info(mci, &discard);  /* clear counters */

 	/* finalize this instance of memory controller with edac core */
@@ -655,7 +643,7 @@ static void __devexit i82975x_remove_one
 static DEFINE_PCI_DEVICE_TABLE(i82975x_pci_tbl) = {
 	{
 		PCI_VEND_DEV(INTEL, 82975_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		I82975X
+		I82975X_chip0
 	},
 	{
 		0,

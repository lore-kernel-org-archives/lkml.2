Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab2KVUHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:07:07 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58019 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab2KVUHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:07:00 -0500
MIME-Version: 1.0
Date: Thu, 22 Nov 2012 14:54:54 +0530
Message-ID: <CAA_L+UP_ZC-QY8Gmmk6Ph_CJdC5pxOf-+J9L3h-vPRgxGq+o1g@mail.gmail.com>
Subject: [PATCH 3.6.6 1/3] i82975x_edac: cleanup debug code
From: Arvind R <arvino55@gmail.com>
To: linux-edac@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 3.6.6 1/3] i82975x_edac: cleanup debug code

the patch converts existing debug code to use the edac standard
method instead of hardcoded ifdefs.
Signed-off-by: Arvind R. <arvino55@gmail.com>
---
 drivers/edac/i82975x_edac.c |  196 ++++++++++++++++++----------------
 1 file changed, 105 insertions(+), 91 deletions(-)
diff -up a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
--- a/drivers/edac/i82975x_edac.c	2012-11-03 03:11:32.000000000 +0530
+++ b/drivers/edac/i82975x_edac.c	2012-11-22 11:28:46.000000000 +0530
@@ -336,37 +336,6 @@ static void i82975x_check(struct mem_ctl
 	i82975x_process_error_info(mci, &info, 1);
 }

-/* Return 1 if dual channel mode is active.  Else return 0. */
-static int dual_channel_active(void __iomem *mch_window)
-{
-	/*
-	 * We treat interleaved-symmetric configuration as dual-channel - EAP's
-	 * bit-0 giving the channel of the error location.
-	 *
-	 * All other configurations are treated as single channel - the EAP's
-	 * bit-0 will resolve ok in symmetric area of mixed
-	 * (symmetric/asymmetric) configurations
-	 */
-	u8	drb[4][2];
-	int	row;
-	int    dualch;
-
-	for (dualch = 1, row = 0; dualch && (row < 4); row++) {
-		drb[row][0] = readb(mch_window + I82975X_DRB + row);
-		drb[row][1] = readb(mch_window + I82975X_DRB + row + 0x80);
-		dualch = dualch && (drb[row][0] == drb[row][1]);
-	}
-	return dualch;
-}
-
-static enum dev_type i82975x_dram_type(void __iomem *mch_window, int rank)
-{
-	/*
-	 * ECC is possible on i92975x ONLY with DEV_X8
-	 */
-	return DEV_X8;
-}
-
 static void i82975x_init_csrows(struct mem_ctl_info *mci,
 		struct pci_dev *pdev, void __iomem *mch_window)
 {
@@ -418,7 +387,6 @@ static void i82975x_init_csrows(struct m
 		 *   [0-7] for single-channel; i.e. csrow->nr_channels = 1
 		 *   [0-3] for dual-channel; i.e. csrow->nr_channels = 2
 		 */
-		dtype = i82975x_dram_type(mch_window, index);
 		for (chan = 0; chan < csrow->nr_channels; chan++) {
 			dimm = mci->csrows[index]->channels[chan]->dimm;

@@ -426,9 +394,9 @@ static void i82975x_init_csrows(struct m
 			strncpy(csrow->channels[chan]->dimm->label,
 					labels[(index >> 1) + (chan * 2)],
 					EDAC_MC_LABEL_LEN);
-			dimm->grain = 1 << 7;	/* 128Byte cache-line resolution */
-			dimm->dtype = i82975x_dram_type(mch_window, index);
-			dimm->mtype = MEM_DDR2; /* I82975x supports only DDR2 */
+			dimm->grain = 1 << 7;	/* always */
+			dimm->dtype = DEV_X8;	/* ECC only with DEV_X8 */
+			dimm->mtype = MEM_DDR2; /* only supported */
 			dimm->edac_mode = EDAC_SECDED; /* only supported */
 		}

@@ -438,27 +406,108 @@ static void i82975x_init_csrows(struct m
 	}
 }

-/* #define  i82975x_DEBUG_IOMEM */
+static bool __devinit detect_channel_mode(void __iomem *mch_window)
+{
+	int	row;
+	bool chan_mode;

-#ifdef i82975x_DEBUG_IOMEM
-static void i82975x_print_dram_timings(void __iomem *mch_window)
+	for (chan_mode = true, row = 0;
+			chan_mode && (row < I82975X_NR_ROWS_PER_CHANNEL);
+				row++)
+		chan_mode &= (readb(mch_window + I82975X_DRB + row) ==
+				readb(mch_window + I82975X_DRB + row + 0x80));
+	return chan_mode;
+}
+
+#ifdef CONFIG_EDAC_DEBUG
+static void __devinit i82975x_print_dram_config(void __iomem *mch_window,
+				u32 mchbar, u32 *drc, bool is_symmetric)
 {
-	/*
-	 * The register meanings are from Intel specs;
-	 * (shows 13-5-5-5 for 800-DDR2)
-	 * Asus P5W Bios reports 15-5-4-4
-	 * What's your religion?
-	 */
+static const char *refresh_modes[8] = {
+			"disabled"
+			"15.6 uSec", "7.8 uSec", "3.9 uSec", "1.95 uSec",
+			"reserved", "reserved",
+			"fast refresh (64 clocks)"
+			};
+static const char *rank_attr[8] = {
+			"empty   ", "reserved",
+			"4 Kb    ", "8 Kb    ", "16 Kb   ",
+			"reserved", "reserved", "reserved"
+			};
 	static const int caslats[4] = { 5, 4, 3, 6 };
 	u32	dtreg[2];
+	u8 c0drb[4];
+	u8 c1drb[4];
+	u8 c0dra[2];
+	u8 c1dra[2];
+
+	/* Show memory config if debug level is 1 or upper */
+	if (!edac_debug_level)
+		return;
+
+	i82975x_printk(KERN_INFO, "MCHBAR real = %0x, remapped = %p\n",
+					mchbar, mch_window);
+
+	c0drb[0] = readb(mch_window + I82975X_DRB_CH0R0);
+	c0drb[1] = readb(mch_window + I82975X_DRB_CH0R1);
+	c0drb[2] = readb(mch_window + I82975X_DRB_CH0R2);
+	c0drb[3] = readb(mch_window + I82975X_DRB_CH0R3);
+	c1drb[0] = readb(mch_window + I82975X_DRB_CH1R0);
+	c1drb[1] = readb(mch_window + I82975X_DRB_CH1R1);
+	c1drb[2] = readb(mch_window + I82975X_DRB_CH1R2);
+	c1drb[3] = readb(mch_window + I82975X_DRB_CH1R3);
+	i82975x_printk(KERN_INFO, "DRBCH0R0 = 0x%02x\n", c0drb[0]);
+	i82975x_printk(KERN_INFO, "DRBCH0R1 = 0x%02x\n", c0drb[1]);
+	i82975x_printk(KERN_INFO, "DRBCH0R2 = 0x%02x\n", c0drb[2]);
+	i82975x_printk(KERN_INFO, "DRBCH0R3 = 0x%02x\n", c0drb[3]);
+	i82975x_printk(KERN_INFO, "DRBCH1R0 = 0x%02x\n", c1drb[0]);
+	i82975x_printk(KERN_INFO, "DRBCH1R1 = 0x%02x\n", c1drb[1]);
+	i82975x_printk(KERN_INFO, "DRBCH1R2 = 0x%02x\n", c1drb[2]);
+	i82975x_printk(KERN_INFO, "DRBCH1R3 = 0x%02x\n", c1drb[3]);
+	i82975x_printk(KERN_INFO, "Memory in %ssymmetric mode\n",
+			is_symmetric ? "" : "as");
+
+	i82975x_printk(KERN_INFO, "DRC_CH0 = %0x, %s\n", drc[0],
+			((drc[0] >> 21) & 3) == 1 ?
+				"ECC enabled" : "ECC disabled");
+	i82975x_printk(KERN_INFO, "DRC_CH1 = %0x, %s\n", drc[1],
+			((drc[1] >> 21) & 3) == 1 ?
+				"ECC enabled" : "ECC disabled");
+
+	c0dra[0] = readb(mch_window + I82975X_DRA_CH0R01);
+	c0dra[1] = readb(mch_window + I82975X_DRA_CH0R23);
+	c1dra[0] = readb(mch_window + I82975X_DRA_CH1R01);
+	c1dra[1] = readb(mch_window + I82975X_DRA_CH1R23);
+	i82975x_printk(KERN_INFO, "Rank Attribute:\n"
+		"     Rank:  0            1            2            3\n"
+		"      Ch0:  %s   %s   %s   %s\n"
+		"      Ch1:  %s   %s   %s   %s\n",
+		rank_attr[c0dra[0] & 7],
+		rank_attr[(c0dra[0] >> 4) & 7],
+		rank_attr[c0dra[1] & 7],
+		rank_attr[(c0dra[1] >> 4) & 7],
+		rank_attr[c1dra[0] & 7],
+		rank_attr[(c1dra[0] >> 4) & 7],
+		rank_attr[c1dra[1] & 7],
+		rank_attr[(c1dra[1] >> 4) & 7]);
+
+	i82975x_printk(KERN_INFO, "Bank Architecture:\n"
+		"      2 bits / rank, 0 => 4 banks, 1 => 8 banks\n"
+		"           Channel A: %02x B: %02x\n",
+		readw(mch_window + I82975X_C0BNKARC),
+		readw(mch_window + I82975X_C1BNKARC));
+
+	i82975x_printk(KERN_INFO, "Memory Refresh: Ch0: %s, Ch1: %s\n",
+					refresh_modes[(drc[0] >> 8) & 7],
+					refresh_modes[(drc[1] >> 8) & 7]);

 	dtreg[0] = readl(mch_window + 0x114);
 	dtreg[1] = readl(mch_window + 0x194);
 	i82975x_printk(KERN_INFO, "DRAM Timings :     Ch0    Ch1\n"
-		"                RAS Active Min = %d     %d\n"
+		"                RAS Active Min =  %d      %d\n"
 		"                CAS latency    =  %d      %d\n"
-		"                RAS to CAS     =  %d      %d\n"
-		"                RAS precharge  =  %d      %d\n",
+		"                RAS to CAS     =  %d      %d  (2-6 valid)\n"
+		"                RAS precharge  =  %d      %d  (2-6 valid)\n",
 		(dtreg[0] >> 19 ) & 0x0f,
 			(dtreg[1] >> 19) & 0x0f,
 		caslats[(dtreg[0] >> 8) & 0x03],
@@ -472,7 +521,7 @@ static void i82975x_print_dram_timings(v
 }
 #endif

-static int i82975x_probe1(struct pci_dev *pdev, int dev_idx)
+static int __devinit i82975x_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	int rc = -ENODEV;
 	struct mem_ctl_info *mci;
@@ -483,10 +532,7 @@ static int i82975x_probe1(struct pci_dev
 	u32 drc[2];
 	struct i82975x_error_info discard;
 	int	chans;
-#ifdef i82975x_DEBUG_IOMEM
-	u8 c0drb[4];
-	u8 c1drb[4];
-#endif
+	bool is_symmetric_config;

 	edac_dbg(0, "\n");

@@ -498,53 +544,21 @@ static int i82975x_probe1(struct pci_dev
 	mchbar &= 0xffffc000;	/* bits 31:14 used for 16K window */
 	mch_window = ioremap_nocache(mchbar, 0x1000);

-#ifdef i82975x_DEBUG_IOMEM
-	i82975x_printk(KERN_INFO, "MCHBAR real = %0x, remapped = %p\n",
-					mchbar, mch_window);
-
-	c0drb[0] = readb(mch_window + I82975X_DRB_CH0R0);
-	c0drb[1] = readb(mch_window + I82975X_DRB_CH0R1);
-	c0drb[2] = readb(mch_window + I82975X_DRB_CH0R2);
-	c0drb[3] = readb(mch_window + I82975X_DRB_CH0R3);
-	c1drb[0] = readb(mch_window + I82975X_DRB_CH1R0);
-	c1drb[1] = readb(mch_window + I82975X_DRB_CH1R1);
-	c1drb[2] = readb(mch_window + I82975X_DRB_CH1R2);
-	c1drb[3] = readb(mch_window + I82975X_DRB_CH1R3);
-	i82975x_printk(KERN_INFO, "DRBCH0R0 = 0x%02x\n", c0drb[0]);
-	i82975x_printk(KERN_INFO, "DRBCH0R1 = 0x%02x\n", c0drb[1]);
-	i82975x_printk(KERN_INFO, "DRBCH0R2 = 0x%02x\n", c0drb[2]);
-	i82975x_printk(KERN_INFO, "DRBCH0R3 = 0x%02x\n", c0drb[3]);
-	i82975x_printk(KERN_INFO, "DRBCH1R0 = 0x%02x\n", c1drb[0]);
-	i82975x_printk(KERN_INFO, "DRBCH1R1 = 0x%02x\n", c1drb[1]);
-	i82975x_printk(KERN_INFO, "DRBCH1R2 = 0x%02x\n", c1drb[2]);
-	i82975x_printk(KERN_INFO, "DRBCH1R3 = 0x%02x\n", c1drb[3]);
-#endif
-
+	is_symmetric_config = detect_channel_mode(mch_window);
 	drc[0] = readl(mch_window + I82975X_DRC_CH0M0);
 	drc[1] = readl(mch_window + I82975X_DRC_CH1M0);
-#ifdef i82975x_DEBUG_IOMEM
-	i82975x_printk(KERN_INFO, "DRC_CH0 = %0x, %s\n", drc[0],
-			((drc[0] >> 21) & 3) == 1 ?
-				"ECC enabled" : "ECC disabled");
-	i82975x_printk(KERN_INFO, "DRC_CH1 = %0x, %s\n", drc[1],
-			((drc[1] >> 21) & 3) == 1 ?
-				"ECC enabled" : "ECC disabled");
-
-	i82975x_printk(KERN_INFO, "C0 BNKARC = %0x\n",
-		readw(mch_window + I82975X_C0BNKARC));
-	i82975x_printk(KERN_INFO, "C1 BNKARC = %0x\n",
-		readw(mch_window + I82975X_C1BNKARC));
-	i82975x_print_dram_timings(mch_window);
-	goto fail1;
+#ifdef CONFIG_EDAC_DEBUG
+	i82975x_print_dram_config(mch_window, mchbar, drc,
+			is_symmetric_config);
 #endif
+
+	/* Obey BIOS setting for enabling ECC */
+	/* FIXME: what about partial setting? possible in BIOS? */
 	if (!(((drc[0] >> 21) & 3) == 1 || ((drc[1] >> 21) & 3) == 1)) {
 		i82975x_printk(KERN_INFO, "ECC disabled on both channels.\n");
 		goto fail1;
 	}

-	chans = dual_channel_active(mch_window) + 1;
-
-	/* assuming only one controller, index thus is 0 */
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
 	layers[0].size = I82975X_NR_DIMMS;
 	layers[0].is_virt_csrow = true;

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab2LOUkm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 15:40:42 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58347 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab2LOUkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 15:40:40 -0500
MIME-Version: 1.0
Date: Sun, 16 Dec 2012 02:10:39 +0530
Message-ID: <CAA_L+UNa-C0XvzMbXMf9GchtfacfwJMYt2uuXkWVntWPWANLsA@mail.gmail.com>
Subject: [PATCH 3.7.0 3/9] i82975x_edac.c: cleanup debug code
From: Arvind R <arvino55@gmail.com>
To: linux-edac@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 3.7.0 3/9] i82975x_edac.c: cleanup debug code

modify debug levels to sane levels. Also move random debug code
into CONFIG_EDAC_DEBUG sections.
Signed-off-by: Arvind R. <arvino55@gmail.com>
---
 i82975x_edac.c |  171 +++++++++++++++++++++++-------------------
 1 file changed, 97 insertions(+), 74 deletions(-)

--- a/drivers/edac/i82975x_edac.c	2012-12-15 20:18:24 +0530
+++ b/drivers/edac/i82975x_edac.c	2012-12-15 20:17:58 +0530
@@ -167,7 +167,8 @@ NOTE: Only ONE of the three must be enab
 #define I82975X_C0BNKARC	0x10e
 #define I82975X_C1BNKARC	0x18e

-
+#define I82975X_C0DRT1		0x114
+#define I82975X_C1DRT1		0x194

 #define I82975X_DRC		0x120 /* DRAM Controller Mode0 (32b)
 					 *
@@ -331,7 +332,7 @@ static void i82975x_check(struct mem_ctl
 {
 	struct i82975x_error_info info;

-	edac_dbg(1, "MC%d\n", mci->mc_idx);
+	edac_dbg(4, "MC%d\n", mci->mc_idx);
 	i82975x_get_error_info(mci, &info);
 	i82975x_process_error_info(mci, &info, 1);
 }
@@ -436,27 +437,93 @@ static void i82975x_init_csrows(struct m
 	}
 }

-/* #define  i82975x_DEBUG_IOMEM */
-
-#ifdef i82975x_DEBUG_IOMEM
-static void i82975x_print_dram_timings(void __iomem *mch_window)
-{
-	/*
-	 * The register meanings are from Intel specs;
-	 * (shows 13-5-5-5 for 800-DDR2)
-	 * Asus P5W Bios reports 15-5-4-4
-	 * What's your religion?
-	 */
+#ifdef CONFIG_EDAC_DEBUG
+static void i82975x_print_dram_settings(void __iomem *mch_window,
+				u32 mchbar, u32 *drc, bool is_symmetric)
+{
+	static const char *refresh_modes[8] = {
+			"disabled"
+			"15.6 uSec", "7.8 uSec", "3.9 uSec", "1.95 uSec",
+			"reserved", "reserved",
+			"fast refresh (64 clocks)"
+			};
+	static const char *rank_attr[8] = {
+			"empty   ", "reserved",
+			"4 Kb    ", "8 Kb    ", "16 Kb   ",
+			"reserved", "reserved", "reserved"
+			};
 	static const int caslats[4] = { 5, 4, 3, 6 };
 	u32	dtreg[2];
+	u8 drb[4];
+	u8 dra[2][2];
+
+	/* Show memory config if debug level is 1 or upper */
+	if (!edac_debug_level)
+		return;
+
+	i82975x_printk(KERN_INFO, "MCHBAR real = %0x, remapped = %p\n",
+					mchbar, mch_window);
+
+	drb[0] = readb(mch_window + I82975X_DRB_CH0R0);
+	drb[1] = readb(mch_window + I82975X_DRB_CH0R1);
+	drb[2] = readb(mch_window + I82975X_DRB_CH0R2);
+	drb[3] = readb(mch_window + I82975X_DRB_CH0R3);
+	i82975x_printk(KERN_INFO, "DRBCH0R0 = 0x%02x\n", drb[0]);
+	i82975x_printk(KERN_INFO, "DRBCH0R1 = 0x%02x\n", drb[1]);
+	i82975x_printk(KERN_INFO, "DRBCH0R2 = 0x%02x\n", drb[2]);
+	i82975x_printk(KERN_INFO, "DRBCH0R3 = 0x%02x\n\n", drb[3]);
+	drb[0] = readb(mch_window + I82975X_DRB_CH1R0);
+	drb[1] = readb(mch_window + I82975X_DRB_CH1R1);
+	drb[2] = readb(mch_window + I82975X_DRB_CH1R2);
+	drb[3] = readb(mch_window + I82975X_DRB_CH1R3);
+	i82975x_printk(KERN_INFO, "DRBCH1R0 = 0x%02x\n", drb[0]);
+	i82975x_printk(KERN_INFO, "DRBCH1R1 = 0x%02x\n", drb[1]);
+	i82975x_printk(KERN_INFO, "DRBCH1R2 = 0x%02x\n", drb[2]);
+	i82975x_printk(KERN_INFO, "DRBCH1R3 = 0x%02x\n", drb[3]);
+	i82975x_printk(KERN_INFO, "Memory in %ssymmetric mode\n",
+			is_symmetric ? "" : "as");

-	dtreg[0] = readl(mch_window + 0x114);
-	dtreg[1] = readl(mch_window + 0x194);
+	i82975x_printk(KERN_INFO, "DRC_CH0 = %0x, %s\n", drc[0],
+			((drc[0] >> 21) & 3) == 1 ?
+				"ECC enabled" : "ECC disabled");
+	i82975x_printk(KERN_INFO, "DRC_CH1 = %0x, %s\n", drc[1],
+			((drc[1] >> 21) & 3) == 1 ?
+				"ECC enabled" : "ECC disabled");
+
+	dra[0][0] = readb(mch_window + I82975X_DRA_CH0R01);
+	dra[0][1] = readb(mch_window + I82975X_DRA_CH0R23);
+	dra[1][0] = readb(mch_window + I82975X_DRA_CH1R01);
+	dra[1][1] = readb(mch_window + I82975X_DRA_CH1R23);
+	i82975x_printk(KERN_INFO, "Rank Attribute:\n"
+		"     Rank:  0            1            2            3\n"
+		"      Ch0:  %s   %s   %s   %s\n"
+		"      Ch1:  %s   %s   %s   %s\n",
+		rank_attr[dra[0][0] & 7],
+		rank_attr[(dra[0][0] >> 4) & 7],
+		rank_attr[dra[0][1] & 7],
+		rank_attr[(dra[0][1] >> 4) & 7],
+		rank_attr[dra[1][0] & 7],
+		rank_attr[(dra[1][0] >> 4) & 7],
+		rank_attr[dra[1][1] & 7],
+		rank_attr[(dra[1][1] >> 4) & 7]);
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
+
+	dtreg[0] = readl(mch_window + I82975X_C0DRT1);
+	dtreg[1] = readl(mch_window + I82975X_C1DRT1);
 	i82975x_printk(KERN_INFO, "DRAM Timings :     Ch0    Ch1\n"
-		"                RAS Active Min = %d     %d\n"
+		"                RAS Active Min =  %d     %d\n"
 		"                CAS latency    =  %d      %d\n"
-		"                RAS to CAS     =  %d      %d\n"
-		"                RAS precharge  =  %d      %d\n",
+		"                RAS to CAS     =  %d      %d  (2-6 valid)\n"
+		"                RAS precharge  =  %d      %d  (2-6 valid)\n",
 		(dtreg[0] >> 19 ) & 0x0f,
 			(dtreg[1] >> 19) & 0x0f,
 		caslats[(dtreg[0] >> 8) & 0x03],
@@ -481,67 +548,32 @@ static int i82975x_probe1(struct pci_dev
 	u32 drc[2];
 	struct i82975x_error_info discard;
 	int	chans;
-#ifdef i82975x_DEBUG_IOMEM
-	u8 c0drb[4];
-	u8 c1drb[4];
-#endif

-	edac_dbg(0, "\n");
+	edac_dbg(0, "MC%d probe\n", dev_idx);

 	pci_read_config_dword(pdev, I82975X_MCHBAR, &mchbar);
 	if (!(mchbar & 1)) {
-		edac_dbg(3, "failed, MCHBAR disabled!\n");
+		edac_dbg(0, "MC%d MCHBAR disabled!\n", dev_idx);
 		goto fail0;
 	}
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
+	chans = dual_channel_active(mch_window) ? 2 : 1;
+#ifdef CONFIG_EDAC_DEBUG
+	i82975x_print_dram_settings(mch_window, mchbar, drc,
+			!(chans <= 1));
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
 	/* assuming only one controller, index thus is 0 */
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
 	layers[0].size = I82975X_NR_CSROWS(chans);
@@ -551,11 +583,11 @@ static int i82975x_probe1(struct pci_dev
 	layers[1].is_virt_csrow = false;
 	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, sizeof(*pvt));
 	if (!mci) {
+		edac_dbg(0, "MC%d failed mc_alloc\n", dev_idx);
 		rc = -ENOMEM;
 		goto fail1;
 	}

-	edac_dbg(3, "init mci\n");
 	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_DDR2;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
@@ -566,7 +598,6 @@ static int i82975x_probe1(struct pci_dev
 	mci->dev_name = pci_name(pdev);
 	mci->edac_check = i82975x_check;
 	mci->ctl_page_to_phys = NULL;
-	edac_dbg(3, "init pvt\n");
 	pvt = (struct i82975x_pvt *) mci->pvt_info;
 	pvt->mch_window = mch_window;
 	i82975x_init_csrows(mci, pdev, mch_window);
@@ -575,12 +606,12 @@ static int i82975x_probe1(struct pci_dev

 	/* finalize this instance of memory controller with edac core */
 	if (edac_mc_add_mc(mci)) {
-		edac_dbg(3, "failed edac_mc_add_mc()\n");
+		edac_dbg(0, "MC%d failed add_mc()\n", dev_idx);
 		goto fail2;
 	}

 	/* get this far and it's successful */
-	edac_dbg(3, "success\n");
+	edac_dbg(3, "MC%d success\n", dev_idx);
 	return 0;

 fail2:
@@ -598,8 +629,6 @@ static int __devinit i82975x_init_one(st
 {
 	int rc;

-	edac_dbg(0, "\n");
-
 	if (pci_enable_device(pdev) < 0)
 		return -EIO;

@@ -616,8 +645,6 @@ static void __devexit i82975x_remove_one
 	struct mem_ctl_info *mci;
 	struct i82975x_pvt *pvt;

-	edac_dbg(0, "\n");
-
 	mci = edac_mc_del_mc(&pdev->dev);
 	if (mci  == NULL)
 		return;
@@ -652,8 +679,6 @@ static int __init i82975x_init(void)
 {
 	int pci_rc;

-	edac_dbg(3, "\n");
-
        /* Ensure that the OPSTATE is set correctly for POLL or NMI */
        opstate_init();

@@ -694,8 +719,6 @@ fail0:

 static void __exit i82975x_exit(void)
 {
-	edac_dbg(3, "\n");
-
 	pci_unregister_driver(&i82975x_driver);

 	if (!i82975x_registered) {

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab2JQClY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 22:41:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690Ab2JQClU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 22:41:20 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Arvind R ." <arvino55@gmail.com>
Subject: [PATCH EDAC 2/3] i82975x_edac: Use the edac standard debug macro
Date: Tue, 16 Oct 2012 23:41:09 -0300
Message-Id: <9370a8d717720f6b17221490fea8d798396d9f2f.1350440633.git.mchehab@redhat.com>
In-Reply-To: <cover.1350440633.git.mchehab@redhat.com>
References: <cover.1350440633.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of declaring its own debug macro, that requires
to uncomment part of the code, use the edac standard macro
to add the debug code, and the edac debug level to print it,
just like any other EDAC driver.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i82975x_edac.c | 99 ++++++++++++++++++++++-----------------------
 1 file changed, 48 insertions(+), 51 deletions(-)

diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index a980204..f998d2c 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -435,11 +435,9 @@ static void i82975x_init_csrows(struct mem_ctl_info *mci,
 	}
 }
 
-/* #define  i82975x_DEBUG_IOMEM */
-
-#ifdef i82975x_DEBUG_IOMEM
-static void i82975x_print_dram_timings(void __iomem *mch_window)
+static void i82975x_print_dram_config(void __iomem *mch_window, u32 mchbar, u32 *drc)
 {
+#ifdef CONFIG_EDAC_DEBUG
 	/*
 	 * The register meanings are from Intel specs;
 	 * (shows 13-5-5-5 for 800-DDR2)
@@ -448,26 +446,63 @@ static void i82975x_print_dram_timings(void __iomem *mch_window)
 	 */
 	static const int caslats[4] = { 5, 4, 3, 6 };
 	u32	dtreg[2];
+	u8 c0drb[4];
+	u8 c1drb[4];
+
+	if (!edac_debug_level)
+		return;
+
+	i82975x_printk(KERN_INFO, "MCHBAR real = %0x, remapped = %p\n",
+		       mchbar, mch_window);
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
+
+	i82975x_printk(KERN_INFO, "DRC_CH0 = %0x, %s\n", drc[0],
+		       ((drc[0] >> 21) & 3) == 1 ?
+				"ECC enabled" : "ECC disabled");
+	i82975x_printk(KERN_INFO, "DRC_CH1 = %0x, %s\n", drc[1],
+		       ((drc[1] >> 21) & 3) == 1 ?
+		       "ECC enabled" : "ECC disabled");
+
+	i82975x_printk(KERN_INFO, "C0 BNKARC = %0x\n",
+		readw(mch_window + I82975X_C0BNKARC));
+	i82975x_printk(KERN_INFO, "C1 BNKARC = %0x\n",
+		readw(mch_window + I82975X_C1BNKARC));
 
 	dtreg[0] = readl(mch_window + 0x114);
 	dtreg[1] = readl(mch_window + 0x194);
-	i82975x_printk(KERN_INFO, "DRAM Timings :     Ch0    Ch1\n"
+	i82975x_printk(KERN_INFO,
+		"DRAM Timings :  Ch0    Ch1\n"
 		"                RAS Active Min = %d     %d\n"
 		"                CAS latency    =  %d      %d\n"
 		"                RAS to CAS     =  %d      %d\n"
 		"                RAS precharge  =  %d      %d\n",
 		(dtreg[0] >> 19 ) & 0x0f,
-			(dtreg[1] >> 19) & 0x0f,
+		(dtreg[1] >> 19) & 0x0f,
 		caslats[(dtreg[0] >> 8) & 0x03],
-			caslats[(dtreg[1] >> 8) & 0x03],
+		caslats[(dtreg[1] >> 8) & 0x03],
 		((dtreg[0] >> 4) & 0x07) + 2,
-			((dtreg[1] >> 4) & 0x07) + 2,
+		((dtreg[1] >> 4) & 0x07) + 2,
 		(dtreg[0] & 0x07) + 2,
-			(dtreg[1] & 0x07) + 2
+		(dtreg[1] & 0x07) + 2
 	);
-
-}
 #endif
+}
 
 static int i82975x_probe1(struct pci_dev *pdev, int dev_idx)
 {
@@ -480,10 +515,6 @@ static int i82975x_probe1(struct pci_dev *pdev, int dev_idx)
 	u32 drc[2];
 	struct i82975x_error_info discard;
 	int	chans;
-#ifdef i82975x_DEBUG_IOMEM
-	u8 c0drb[4];
-	u8 c1drb[4];
-#endif
 
 	edac_dbg(0, "\n");
 
@@ -495,45 +526,11 @@ static int i82975x_probe1(struct pci_dev *pdev, int dev_idx)
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
 
-	i82975x_printk(KERN_INFO, "C0 BNKARC = %0x\n",
-		readw(mch_window + I82975X_C0BNKARC));
-	i82975x_printk(KERN_INFO, "C1 BNKARC = %0x\n",
-		readw(mch_window + I82975X_C1BNKARC));
-	i82975x_print_dram_timings(mch_window);
-	goto fail1;
-#endif
+	i82975x_print_dram_config(mch_window, mchbar, drc);
+
 	if (!(((drc[0] >> 21) & 3) == 1 || ((drc[1] >> 21) & 3) == 1)) {
 		i82975x_printk(KERN_INFO, "ECC disabled on both channels.\n");
 		goto fail1;
-- 
1.7.11.7


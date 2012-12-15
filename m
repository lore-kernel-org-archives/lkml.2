Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab2LOUmy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 15:42:54 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52930 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2LOUmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 15:42:52 -0500
MIME-Version: 1.0
Date: Sun, 16 Dec 2012 02:12:51 +0530
Message-ID: <CAA_L+UPvp8i6SaATD=uQmvYeEp6vbYGBFM=LRE1MWCMGff5JkA@mail.gmail.com>
Subject: [PATCH 3.7.0 5/9] i82975x_edac: optimise mode detection
From: Arvind R <arvino55@gmail.com>
To: linux-edac@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 3.7.0 5/9] i82975x_edac: optimise mode detection

Minor optimisation of dual channel symmetric operation. Return
value changed to bool.
Signed-off-by: Arvind R. <arvino55@gmail.com>
---
 i82975x_edac.c |   45 ++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 23 deletions(-)

--- a/drivers/edac/i82975x_edac.c	2012-12-15 22:14:18.000000000 +0530
+++ b/drivers/edac/i82975x_edac.c	2012-12-15 22:17:12.000000000 +0530
@@ -31,6 +31,7 @@

 #define I82975X_NR_DIMMS		8
 #define I82975X_NR_CSROWS(nr_chans)	(I82975X_NR_DIMMS / (nr_chans))
+#define	I82975X_NR_CSROWS_PER_CHANNEL	4

 /* Intel 82975X register addresses - device 0 function 0 - DRAM Controller */
 #define I82975X_EAP		0x58	/* Dram Error Address Pointer (32b)
@@ -337,29 +338,6 @@ static void i82975x_check(struct mem_ctl
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
 static void i82975x_init_csrows(struct mem_ctl_info *mci,
 		struct pci_dev *pdev, void __iomem *mch_window)
 {
@@ -527,6 +505,27 @@ static void i82975x_print_dram_timings(v
 }
 #endif

+/* Return 1 if dual channel mode is active.  Else return 0. */
+static bool dual_channel_active(void __iomem *mch_window)
+{
+	/*
+	 * We treat interleaved-symmetric configuration as dual-channel.
+	 * All other configurations are virtual single channel mode.
+	 * bit-0 of EAP always provides the real channel in error.
+	 */
+	u8	drb[2];
+	int	row;
+	bool    dualch;
+
+	for (dualch = 1, row = 0; dualch &&
+			(row < I82975X_NR_CSROWS_PER_CHANNEL); row++) {
+		drb[0] = readb(mch_window + I82975X_DRB + row);
+		drb[1] = readb(mch_window + I82975X_DRB + row + 0x80);
+		dualch &= (drb[0] == drb[1]);
+	}
+	return dualch;
+}
+
 static int i82975x_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	int rc = -ENODEV;

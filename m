Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab2KVSw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:52:28 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47569 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab2KVSwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:52:25 -0500
MIME-Version: 1.0
Date: Thu, 22 Nov 2012 14:56:33 +0530
Message-ID: <CAA_L+UO5bBcioqM2DA79iPakQDCGORo1AAX2mTkgF18hEV2nKQ@mail.gmail.com>
Subject: [PATCH 3.6.6 2/3] i82975x_edac: fix format problems
From: Arvind R <arvino55@gmail.com>
To: linux-edac@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 3.6.6 2/3] i82975x_edac: fix format problems

This patch fixes format errors and warnings like long lines.
Also, adds defines for previously hardcoded constants.
Signed-off-by: Arvind R. <arvino55@gmail.com>
---
 drivers/edac/i82975x_edac.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)
diff -up a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
--- a/drivers/edac/i82975x_edac.c	2012-11-22 11:55:39.000000000 +0530
+++ b/drivers/edac/i82975x_edac.c	2012-11-22 11:56:36.000000000 +0530
@@ -48,7 +48,7 @@
 #define I82975X_DES		0x5d	/* Dram ERRor DeSTination (8b)
 					 * 0h:    Processor Memory Reads
 					 * 1h:7h  reserved
-					 * More - See Page 65 of Intel DocSheet.
+					 * More - See Page 65 of DocSheet.
 					 */

 #define I82975X_ERRSTS		0xc8	/* Error Status Register (16b)
@@ -62,6 +62,8 @@
 					 *  1    ECC UE (multibit DRAM error)
 					 *  0    ECC CE (singlebit DRAM error)
 					 */
+#define I82975X_ERRSTS_CE	1
+#define I82975X_ERRSTS_UE	2

 /* Error Reporting is supported by 3 mechanisms:
   1. DMI SERR generation  ( ERRCMD )
@@ -98,7 +100,7 @@ NOTE: Only ONE of the three must be enab
 #define I82975X_XEAP	0xfc	/* Extended Dram Error Address Pointer (8b)
 					 *
 					 * 7:1   reserved
-					 * 0     Bit32 of the Dram Error Address
+					 * 0     Bit32 of Dram Error Address
 					 */

 #define I82975X_MCHBAR		0x44	/*
@@ -203,7 +205,7 @@ NOTE: Only ONE of the three must be enab
 #define I82975X_DRC_CH1M1		0x1A4

 enum i82975x_chips {
-	I82975X = 0,
+	I82975X_chip0 = 0,
 };

 struct i82975x_pvt {
@@ -225,7 +227,7 @@ struct i82975x_error_info {
 };

 static const struct i82975x_dev_info i82975x_devs[] = {
-	[I82975X] = {
+	[I82975X_chip0] = {
 		.ctl_name = "i82975x"
 	},
 };
@@ -255,7 +257,9 @@ static void i82975x_get_error_info(struc
 	pci_read_config_byte(pdev, I82975X_DERRSYN, &info->derrsyn);
 	pci_read_config_word(pdev, I82975X_ERRSTS, &info->errsts2);

-	pci_write_bits16(pdev, I82975X_ERRSTS, 0x0003, 0x0003);
+	pci_write_bits16(pdev, I82975X_ERRSTS,
+			I82975X_ERRSTS_UE | I82975X_ERRSTS_CE,
+				I82975X_ERRSTS_UE | I82975X_ERRSTS_CE);

 	/*
 	 * If the error is the same then we can for both reads then
@@ -263,10 +267,11 @@ static void i82975x_get_error_info(struc
 	 * there is a CE no info and the second set of reads is valid
 	 * and should be UE info.
 	 */
-	if (!(info->errsts2 & 0x0003))
+	if (!(info->errsts2 & (I82975X_ERRSTS_UE | I82975X_ERRSTS_CE)))
 		return;

-	if ((info->errsts ^ info->errsts2) & 0x0003) {
+	if ((info->errsts ^ info->errsts2) &
+			(I82975X_ERRSTS_UE | I82975X_ERRSTS_CE)) {
 		pci_read_config_dword(pdev, I82975X_EAP, &info->eap);
 		pci_read_config_byte(pdev, I82975X_XEAP, &info->xeap);
 		pci_read_config_byte(pdev, I82975X_DES, &info->des);
@@ -278,16 +283,18 @@ static void i82975x_get_error_info(struc
 static int i82975x_process_error_info(struct mem_ctl_info *mci,
 		struct i82975x_error_info *info, int handle_errors)
 {
+	enum hw_event_mc_err_type err_type;
 	int row, chan;
 	unsigned long offst, page;

-	if (!(info->errsts2 & 0x0003))
+	if (!(info->errsts2 & (I82975X_ERRSTS_UE | I82975X_ERRSTS_CE)))
 		return 0;

 	if (!handle_errors)
 		return 1;

-	if ((info->errsts ^ info->errsts2) & 0x0003) {
+	if ((info->errsts ^ info->errsts2) &
+			(I82975X_ERRSTS_UE | I82975X_ERRSTS_CE)) {
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1, 0, 0, 0,
 				     -1, -1, -1, "UE overwrote CE", "");
 		info->errsts = info->errsts2;

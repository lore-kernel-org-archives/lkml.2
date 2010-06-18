Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761335Ab0FRRBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 13:01:17 -0400
Received: from www.tglx.de ([62.245.132.106]:33369 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757842Ab0FRRBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 13:01:16 -0400
From: John Ogness <john.ogness@linutronix.de>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] mtd: mxc_nand fixups
Date: Fri, 18 Jun 2010 19:01:03 +0200
Message-ID: <808w6cb7hs.fsf@merkur.tec.linutronix.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes how failures with the hardware ECC error correction
for the NFCv21 are detected.

The patch is against linux-next 20100618.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
---
 drivers/mtd/nand/mxc_nand.c |   39 +++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 10 deletions(-)

Index: linux-next-20100618/drivers/mtd/nand/mxc_nand.c
===================================================================
--- linux-next-20100618.orig/drivers/mtd/nand/mxc_nand.c
+++ linux-next-20100618/drivers/mtd/nand/mxc_nand.c
@@ -359,18 +359,37 @@ static int mxc_nand_correct_data(struct 
 	struct nand_chip *nand_chip = mtd->priv;
 	struct mxc_nand_host *host = nand_chip->priv;
 
-	/*
-	 * 1-Bit errors are automatically corrected in HW.  No need for
-	 * additional correction.  2-Bit errors cannot be corrected by
-	 * HW ECC, so we need to return failure
-	 */
 	uint16_t ecc_status = readw(host->regs + NFC_ECC_STATUS_RESULT);
 
-	if (((ecc_status & 0x3) == 2) || ((ecc_status >> 2) == 2)) {
-		DEBUG(MTD_DEBUG_LEVEL0,
-		      "MXC_NAND: HWECC uncorrectable 2-bit ECC error\n");
-		return -1;
-	}
+	if (nfc_is_v21()) {
+		/*
+		 * Up to 8 9-bit symbol errors can be corrected by the HW.
+		 * A status value of 0xf means that an uncorrectable error
+		 * occurred, so we need to return failure.
+		 */
+		if ((ecc_status & 0xf) == 0xf ||
+		    ((ecc_status >> 4) & 0xf) == 0xf ||
+		    ((ecc_status >> 8) & 0xf) == 0xf ||
+		    ((ecc_status >> 12) & 0xf) == 0xf) {
+			DEBUG(MTD_DEBUG_LEVEL0,
+			      "MXC_NAND: "
+			      "HWECC uncorrectable ECC error\n");
+			return -1;
+		}
+	} else if (nfc_is_v1()) {
+		/*
+		 * 1-Bit errors are automatically corrected in HW. No need for
+		 * additional correction. 2-Bit errors cannot be corrected by
+		 * HW ECC, so we need to return failure.
+		 */
+		if (((ecc_status & 0x3) == 2) || ((ecc_status >> 2) == 2)) {
+			DEBUG(MTD_DEBUG_LEVEL0,
+			      "MXC_NAND: "
+			      "HWECC uncorrectable 2-bit ECC error\n");
+			return -1;
+		}
+	} else
+		BUG();
 
 	return 0;
 }

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab1B1MNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 07:13:15 -0500
Received: from www.tglx.de ([62.245.132.106]:47845 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922Ab1B1MNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 07:13:14 -0500
To: dedekind1@gmail.com
Cc: linux-omap@vger.kernel.org
Cc: s-ghorai@ti.com
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] omap3: nand: report corrected ecc errors
From: John Ogness <john.ogness@linutronix.de>
References: <87oc64qr5b.fsf@vostro.fn.ogness.net>
	<1298631549.2798.56.camel@localhost>
Date: Mon, 28 Feb 2011 13:12:46 +0100
In-Reply-To: <1298631549.2798.56.camel@localhost> (Artem Bityutskiy's message of "Fri\, 25 Feb 2011 12\:59\:09 +0200")
Message-ID: <87y650pdc1.fsf_-_@vostro.fn.ogness.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Ogness <john.ogness@linutronix.de>

The number of corrected ECC errors should be reported since other MTD
systems make use of this information (such as UBI data scrubbing).

Signed-off-by: John Ogness <john.ogness@linutronix.de>
---
Patch v2:
o Patch against linux-next-20110225.
o Added comments explaining return codes.

 drivers/mtd/nand/omap2.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 4e33972..6324230 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -668,6 +668,8 @@ static void gen_true_ecc(u8 *ecc_buf)
  *
  * This function compares two ECC's and indicates if there is an error.
  * If the error can be corrected it will be corrected to the buffer.
+ * If there is no error, %0 is returned. If there is an error but it
+ * was corrected, %1 is returned. Otherwise, %-1 is returned.
  */
 static int omap_compare_ecc(u8 *ecc_data1,	/* read from NAND memory */
 			    u8 *ecc_data2,	/* read from register */
@@ -773,7 +775,7 @@ static int omap_compare_ecc(u8 *ecc_data1,	/* read from NAND memory */
 
 		page_data[find_byte] ^= (1 << find_bit);
 
-		return 0;
+		return 1;
 	default:
 		if (isEccFF) {
 			if (ecc_data2[0] == 0 &&
@@ -794,8 +796,11 @@ static int omap_compare_ecc(u8 *ecc_data1,	/* read from NAND memory */
  * @calc_ecc: ecc read from HW ECC registers
  *
  * Compares the ecc read from nand spare area with ECC registers values
- * and if ECC's mismached, it will call 'omap_compare_ecc' for error detection
- * and correction.
+ * and if ECC's mismatched, it will call 'omap_compare_ecc' for error
+ * detection and correction. If there are no errors, %0 is returned. If
+ * there were errors and all of the errors were corrected, the number of
+ * corrected errors is returned. If uncorrectable errors exist, %-1 is
+ * returned.
  */
 static int omap_correct_data(struct mtd_info *mtd, u_char *dat,
 				u_char *read_ecc, u_char *calc_ecc)
@@ -803,6 +808,7 @@ static int omap_correct_data(struct mtd_info *mtd, u_char *dat,
 	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
 							mtd);
 	int blockCnt = 0, i = 0, ret = 0;
+	int stat = 0;
 
 	/* Ex NAND_ECC_HW12_2048 */
 	if ((info->nand.ecc.mode == NAND_ECC_HW) &&
@@ -816,12 +822,14 @@ static int omap_correct_data(struct mtd_info *mtd, u_char *dat,
 			ret = omap_compare_ecc(read_ecc, calc_ecc, dat);
 			if (ret < 0)
 				return ret;
+			/* keep track of the number of corrected errors */
+			stat += ret;
 		}
 		read_ecc += 3;
 		calc_ecc += 3;
 		dat      += 512;
 	}
-	return 0;
+	return stat;
 }
 
 /**
-- 
1.5.6.5

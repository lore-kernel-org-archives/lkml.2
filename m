Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab0KKSDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 13:03:12 -0500
Received: from smtp-out-138.synserver.de ([212.40.180.138]:1055 "HELO
	smtp-out-138.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755389Ab0KKSDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 13:03:09 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 23909
From: Lars-Peter Clausen <lars@metafoo.de>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] MTD: NAND: jz4740: Remove custom {read,write}_page handlers
Date: Thu, 11 Nov 2010 19:02:48 +0100
Message-Id: <1289498568-12191-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1289498568-12191-1-git-send-email-lars@metafoo.de>
References: <1289498568-12191-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the mtd core supports more then 64 ecc bytes we can use it instead of
some a custom hack in the jz4740 nand driver.
This patch removes the custom {read,write}_page handlers from the jz4740 nand
driver. Thus the driver will now fallback to the default handlers from the nand
core.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/mtd/nand/jz4740_nand.c |   55 ----------------------------------------
 1 files changed, 0 insertions(+), 55 deletions(-)

diff --git a/drivers/mtd/nand/jz4740_nand.c b/drivers/mtd/nand/jz4740_nand.c
index c9e2a59..cea38a5 100644
--- a/drivers/mtd/nand/jz4740_nand.c
+++ b/drivers/mtd/nand/jz4740_nand.c
@@ -251,58 +251,6 @@ static int jz_nand_correct_ecc_rs(struct mtd_info *mtd, uint8_t *dat,
 	return 0;
 }
 
-
-/* Copy paste of nand_read_page_hwecc_oob_first except for different eccpos
- * handling. The ecc area is for 4k chips 72 bytes long and thus does not fit
- * into the eccpos array. */
-static int jz_nand_read_page_hwecc_oob_first(struct mtd_info *mtd,
-	struct nand_chip *chip, uint8_t *buf, int page)
-{
-	int i, eccsize = chip->ecc.size;
-	int eccbytes = chip->ecc.bytes;
-	int eccsteps = chip->ecc.steps;
-	uint8_t *p = buf;
-	unsigned int ecc_offset = chip->page_shift;
-
-	/* Read the OOB area first */
-	chip->cmdfunc(mtd, NAND_CMD_READOOB, 0, page);
-	chip->read_buf(mtd, chip->oob_poi, mtd->oobsize);
-	chip->cmdfunc(mtd, NAND_CMD_READ0, 0, page);
-
-	for (i = ecc_offset; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
-		int stat;
-
-		chip->ecc.hwctl(mtd, NAND_ECC_READ);
-		chip->read_buf(mtd, p, eccsize);
-
-		stat = chip->ecc.correct(mtd, p, &chip->oob_poi[i], NULL);
-		if (stat < 0)
-			mtd->ecc_stats.failed++;
-		else
-			mtd->ecc_stats.corrected += stat;
-	}
-	return 0;
-}
-
-/* Copy-and-paste of nand_write_page_hwecc with different eccpos handling. */
-static void jz_nand_write_page_hwecc(struct mtd_info *mtd,
-	struct nand_chip *chip, const uint8_t *buf)
-{
-	int i, eccsize = chip->ecc.size;
-	int eccbytes = chip->ecc.bytes;
-	int eccsteps = chip->ecc.steps;
-	const uint8_t *p = buf;
-	unsigned int ecc_offset = chip->page_shift;
-
-	for (i = ecc_offset; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
-		chip->ecc.hwctl(mtd, NAND_ECC_WRITE);
-		chip->write_buf(mtd, p, eccsize);
-		chip->ecc.calculate(mtd, p, &chip->oob_poi[i]);
-	}
-
-	chip->write_buf(mtd, chip->oob_poi, mtd->oobsize);
-}
-
 #ifdef CONFIG_MTD_CMDLINE_PARTS
 static const char *part_probes[] = {"cmdline", NULL};
 #endif
@@ -393,9 +341,6 @@ static int __devinit jz_nand_probe(struct platform_device *pdev)
 	chip->ecc.size		= 512;
 	chip->ecc.bytes		= 9;
 
-	chip->ecc.read_page	= jz_nand_read_page_hwecc_oob_first;
-	chip->ecc.write_page	= jz_nand_write_page_hwecc;
-
 	if (pdata)
 		chip->ecc.layout = pdata->ecc_layout;
 
-- 
1.5.6.5


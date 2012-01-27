Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab2A0OZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:25:14 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44008 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441Ab2A0OZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:25:02 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH] mtd/nftlmount: use memchr_inv
Date: Fri, 27 Jan 2012 23:24:53 +0900
Message-Id: <1327674295-3700-6-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1327674295-3700-1-git-send-email-akinobu.mita@gmail.com>
References: <1327674295-3700-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use memchr_inv to check if the data contains all 0xFF bytes.  It is
faster than looping for each byte.
This also removes memcmpb which is no longer used.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/nftlmount.c |   20 +++++---------------
 1 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/mtd/nftlmount.c b/drivers/mtd/nftlmount.c
index 51b9d6a..a96bdb4 100644
--- a/drivers/mtd/nftlmount.c
+++ b/drivers/mtd/nftlmount.c
@@ -255,16 +255,6 @@ The new DiskOnChip driver already scanned the bad block table.  Just query it.
 	return boot_record_count?0:-1;
 }
 
-static int memcmpb(void *a, int c, int n)
-{
-	int i;
-	for (i = 0; i < n; i++) {
-		if (c != ((unsigned char *)a)[i])
-			return 1;
-	}
-	return 0;
-}
-
 /* check_free_sector: check if a free sector is actually FREE, i.e. All 0xff in data and oob area */
 static int check_free_sectors(struct NFTLrecord *nftl, unsigned int address, int len,
 			      int check_oob)
@@ -277,14 +267,14 @@ static int check_free_sectors(struct NFTLrecord *nftl, unsigned int address, int
 	for (i = 0; i < len; i += SECTORSIZE) {
 		if (mtd_read(mtd, address, SECTORSIZE, &retlen, buf))
 			return -1;
-		if (memcmpb(buf, 0xff, SECTORSIZE) != 0)
+		if (memchr_inv(buf, 0xff, SECTORSIZE))
 			return -1;
 
 		if (check_oob) {
 			if(nftl_read_oob(mtd, address, mtd->oobsize,
 					 &retlen, &buf[SECTORSIZE]) < 0)
 				return -1;
-			if (memcmpb(buf + SECTORSIZE, 0xff, mtd->oobsize) != 0)
+			if (memchr_inv(buf + SECTORSIZE, 0xff, mtd->oobsize))
 				return -1;
 		}
 		address += SECTORSIZE;
@@ -392,7 +382,7 @@ static void check_sectors_in_chain(struct NFTLrecord *nftl, unsigned int first_b
 			case SECTOR_FREE:
 				/* verify that the sector is really free. If not, mark
 				   as ignore */
-				if (memcmpb(&bci, 0xff, 8) != 0 ||
+				if (memchr_inv(&bci, 0xff, 8) ||
 				    check_free_sectors(nftl, block * nftl->EraseSize + i * SECTORSIZE,
 						       SECTORSIZE, 0) != 0) {
 					printk("Incorrect free sector %d in block %d: "
@@ -529,10 +519,10 @@ static int check_and_mark_free_block(struct NFTLrecord *nftl, int block)
 				return -1;
 			if (i == SECTORSIZE) {
 				/* skip erase mark */
-				if (memcmpb(buf, 0xff, 8))
+				if (memchr_inv(buf, 0xff, 8))
 					return -1;
 			} else {
-				if (memcmpb(buf, 0xff, 16))
+				if (memchr_inv(buf, 0xff, 16))
 					return -1;
 			}
 		}
-- 
1.7.4.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab2A0OZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:25:03 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44008 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336Ab2A0OY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:24:59 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH] mtd/inftlmount: use memchr_inv
Date: Fri, 27 Jan 2012 23:24:52 +0900
Message-Id: <1327674295-3700-5-git-send-email-akinobu.mita@gmail.com>
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
 drivers/mtd/inftlmount.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/mtd/inftlmount.c b/drivers/mtd/inftlmount.c
index 4adc037..419b1c9 100644
--- a/drivers/mtd/inftlmount.c
+++ b/drivers/mtd/inftlmount.c
@@ -320,16 +320,6 @@ static int find_boot_record(struct INFTLrecord *inftl)
 	return -1;
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
 /*
  * check_free_sector: check if a free sector is actually FREE,
  *	i.e. All 0xff in data and oob area.
@@ -345,14 +335,14 @@ static int check_free_sectors(struct INFTLrecord *inftl, unsigned int address,
 	for (i = 0; i < len; i += SECTORSIZE) {
 		if (mtd_read(mtd, address, SECTORSIZE, &retlen, buf))
 			return -1;
-		if (memcmpb(buf, 0xff, SECTORSIZE) != 0)
+		if (memchr_inv(buf, 0xff, SECTORSIZE))
 			return -1;
 
 		if (check_oob) {
 			if(inftl_read_oob(mtd, address, mtd->oobsize,
 					  &retlen, &buf[SECTORSIZE]) < 0)
 				return -1;
-			if (memcmpb(buf + SECTORSIZE, 0xff, mtd->oobsize) != 0)
+			if (memchr_inv(buf + SECTORSIZE, 0xff, mtd->oobsize))
 				return -1;
 		}
 		address += SECTORSIZE;
-- 
1.7.4.4


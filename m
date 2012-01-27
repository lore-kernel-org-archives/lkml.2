Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab2A0OZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:25:11 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44008 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab2A0OZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:25:06 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH] mtd/tests: use memchr_inv
Date: Fri, 27 Jan 2012 23:24:54 +0900
Message-Id: <1327674295-3700-7-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1327674295-3700-1-git-send-email-akinobu.mita@gmail.com>
References: <1327674295-3700-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use memchr_inv to check if the data contains all 0xFF bytes.  It is
faster than looping for each byte.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/tests/mtd_pagetest.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/tests/mtd_pagetest.c b/drivers/mtd/tests/mtd_pagetest.c
index 252ddb0..08847cf 100644
--- a/drivers/mtd/tests/mtd_pagetest.c
+++ b/drivers/mtd/tests/mtd_pagetest.c
@@ -401,6 +401,7 @@ static int erasetest(void)
 	size_t read, written;
 	int err = 0, i, ebnum, ok = 1;
 	loff_t addr0;
+	unsigned char *p;
 
 	printk(PRINT_PREF "erasetest\n");
 
@@ -442,14 +443,13 @@ static int erasetest(void)
 
 	printk(PRINT_PREF "verifying 1st page of block %d is all 0xff\n",
 	       ebnum);
-	for (i = 0; i < pgsize; ++i)
-		if (twopages[i] != 0xff) {
-			printk(PRINT_PREF "verifying all 0xff failed at %d\n",
-			       i);
-			errcnt += 1;
-			ok = 0;
-			break;
-		}
+	p = memchr_inv(twopages, 0xff, pgsize);
+	if (p) {
+		printk(PRINT_PREF "verifying all 0xff failed at %d\n",
+			       p - twopages);
+		errcnt += 1;
+		ok = 0;
+	}
 
 	if (ok && !err)
 		printk(PRINT_PREF "erasetest ok\n");
-- 
1.7.4.4


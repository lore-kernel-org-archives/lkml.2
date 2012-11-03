Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab2KCPpu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 11:45:50 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58881 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab2KCPob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 11:44:31 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH v2 07/11] mtd: mtd_oobtest: convert to use random32_get_bytes_state()
Date: Sun,  4 Nov 2012 00:43:38 +0900
Message-Id: <1351957422-23243-8-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351957422-23243-1-git-send-email-akinobu.mita@gmail.com>
References: <1351957422-23243-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes home-brewed pseudo-random number generator and use
random32_get_bytes_state().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
---
* v2
- rename prandom32_get_bytes to random32_get_bytes_state

 drivers/mtd/tests/mtd_oobtest.c | 49 ++++++++++++++---------------------------
 1 file changed, 16 insertions(+), 33 deletions(-)

diff --git a/drivers/mtd/tests/mtd_oobtest.c b/drivers/mtd/tests/mtd_oobtest.c
index ed9b628..ef42622 100644
--- a/drivers/mtd/tests/mtd_oobtest.c
+++ b/drivers/mtd/tests/mtd_oobtest.c
@@ -27,6 +27,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/random.h>
 
 #define PRINT_PREF KERN_INFO "mtd_oobtest: "
 
@@ -46,26 +47,7 @@ static int use_offset;
 static int use_len;
 static int use_len_max;
 static int vary_offset;
-static unsigned long next = 1;
-
-static inline unsigned int simple_rand(void)
-{
-	next = next * 1103515245 + 12345;
-	return (unsigned int)((next / 65536) % 32768);
-}
-
-static inline void simple_srand(unsigned long seed)
-{
-	next = seed;
-}
-
-static void set_random_data(unsigned char *buf, size_t len)
-{
-	size_t i;
-
-	for (i = 0; i < len; ++i)
-		buf[i] = simple_rand();
-}
+static struct rnd_state rnd_state;
 
 static int erase_eraseblock(int ebnum)
 {
@@ -130,7 +112,7 @@ static int write_eraseblock(int ebnum)
 	loff_t addr = ebnum * mtd->erasesize;
 
 	for (i = 0; i < pgcnt; ++i, addr += mtd->writesize) {
-		set_random_data(writebuf, use_len);
+		random32_get_bytes_state(&rnd_state, writebuf, use_len);
 		ops.mode      = MTD_OPS_AUTO_OOB;
 		ops.len       = 0;
 		ops.retlen    = 0;
@@ -183,7 +165,7 @@ static int verify_eraseblock(int ebnum)
 	loff_t addr = ebnum * mtd->erasesize;
 
 	for (i = 0; i < pgcnt; ++i, addr += mtd->writesize) {
-		set_random_data(writebuf, use_len);
+		random32_get_bytes_state(&rnd_state, writebuf, use_len);
 		ops.mode      = MTD_OPS_AUTO_OOB;
 		ops.len       = 0;
 		ops.retlen    = 0;
@@ -275,7 +257,7 @@ static int verify_eraseblock_in_one_go(int ebnum)
 	loff_t addr = ebnum * mtd->erasesize;
 	size_t len = mtd->ecclayout->oobavail * pgcnt;
 
-	set_random_data(writebuf, len);
+	random32_get_bytes_state(&rnd_state, writebuf, len);
 	ops.mode      = MTD_OPS_AUTO_OOB;
 	ops.len       = 0;
 	ops.retlen    = 0;
@@ -426,12 +408,12 @@ static int __init mtd_oobtest_init(void)
 	if (err)
 		goto out;
 
-	simple_srand(1);
+	srandom32_state(&rnd_state, 1);
 	err = write_whole_device();
 	if (err)
 		goto out;
 
-	simple_srand(1);
+	srandom32_state(&rnd_state, 1);
 	err = verify_all_eraseblocks();
 	if (err)
 		goto out;
@@ -446,13 +428,13 @@ static int __init mtd_oobtest_init(void)
 	if (err)
 		goto out;
 
-	simple_srand(3);
+	srandom32_state(&rnd_state, 3);
 	err = write_whole_device();
 	if (err)
 		goto out;
 
 	/* Check all eraseblocks */
-	simple_srand(3);
+	srandom32_state(&rnd_state, 3);
 	printk(PRINT_PREF "verifying all eraseblocks\n");
 	for (i = 0; i < ebcnt; ++i) {
 		if (bbt[i])
@@ -481,7 +463,7 @@ static int __init mtd_oobtest_init(void)
 	use_len = mtd->ecclayout->oobavail;
 	use_len_max = mtd->ecclayout->oobavail;
 	vary_offset = 1;
-	simple_srand(5);
+	srandom32_state(&rnd_state, 5);
 
 	err = write_whole_device();
 	if (err)
@@ -492,7 +474,7 @@ static int __init mtd_oobtest_init(void)
 	use_len = mtd->ecclayout->oobavail;
 	use_len_max = mtd->ecclayout->oobavail;
 	vary_offset = 1;
-	simple_srand(5);
+	srandom32_state(&rnd_state, 5);
 	err = verify_all_eraseblocks();
 	if (err)
 		goto out;
@@ -651,7 +633,7 @@ static int __init mtd_oobtest_init(void)
 		goto out;
 
 	/* Write all eraseblocks */
-	simple_srand(11);
+	srandom32_state(&rnd_state, 11);
 	printk(PRINT_PREF "writing OOBs of whole device\n");
 	for (i = 0; i < ebcnt - 1; ++i) {
 		int cnt = 2;
@@ -661,7 +643,7 @@ static int __init mtd_oobtest_init(void)
 			continue;
 		addr = (i + 1) * mtd->erasesize - mtd->writesize;
 		for (pg = 0; pg < cnt; ++pg) {
-			set_random_data(writebuf, sz);
+			random32_get_bytes_state(&rnd_state, writebuf, sz);
 			ops.mode      = MTD_OPS_AUTO_OOB;
 			ops.len       = 0;
 			ops.retlen    = 0;
@@ -683,12 +665,13 @@ static int __init mtd_oobtest_init(void)
 	printk(PRINT_PREF "written %u eraseblocks\n", i);
 
 	/* Check all eraseblocks */
-	simple_srand(11);
+	srandom32_state(&rnd_state, 11);
 	printk(PRINT_PREF "verifying all eraseblocks\n");
 	for (i = 0; i < ebcnt - 1; ++i) {
 		if (bbt[i] || bbt[i + 1])
 			continue;
-		set_random_data(writebuf, mtd->ecclayout->oobavail * 2);
+		random32_get_bytes_state(&rnd_state, writebuf,
+					mtd->ecclayout->oobavail * 2);
 		addr = (i + 1) * mtd->erasesize - mtd->writesize;
 		ops.mode      = MTD_OPS_AUTO_OOB;
 		ops.len       = 0;
-- 
1.7.11.7


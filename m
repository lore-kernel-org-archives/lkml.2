Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab2KMNjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 08:39:48 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61759 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab2KMNht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 08:37:49 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH v3 08/11] mtd: mtd_pagetest: convert to use prandom library
Date: Tue, 13 Nov 2012 22:37:07 +0900
Message-Id: <1352813830-4624-9-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352813830-4624-1-git-send-email-akinobu.mita@gmail.com>
References: <1352813830-4624-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes home-brewed pseudo-random number generator and use
prandom library.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
---
* v3
- rename 'random32_*' to 'prandom_*'

* v2
- rename prandom32_get_bytes to random32_get_bytes_state

 drivers/mtd/tests/mtd_pagetest.c | 43 ++++++++++++----------------------------
 1 file changed, 13 insertions(+), 30 deletions(-)

diff --git a/drivers/mtd/tests/mtd_pagetest.c b/drivers/mtd/tests/mtd_pagetest.c
index 252ddb0..4197280 100644
--- a/drivers/mtd/tests/mtd_pagetest.c
+++ b/drivers/mtd/tests/mtd_pagetest.c
@@ -27,6 +27,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/random.h>
 
 #define PRINT_PREF KERN_INFO "mtd_pagetest: "
 
@@ -45,26 +46,7 @@ static int bufsize;
 static int ebcnt;
 static int pgcnt;
 static int errcnt;
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
@@ -98,7 +80,7 @@ static int write_eraseblock(int ebnum)
 	size_t written;
 	loff_t addr = ebnum * mtd->erasesize;
 
-	set_random_data(writebuf, mtd->erasesize);
+	prandom_bytes_state(&rnd_state, writebuf, mtd->erasesize);
 	cond_resched();
 	err = mtd_write(mtd, addr, mtd->erasesize, &written, writebuf);
 	if (err || written != mtd->erasesize)
@@ -124,7 +106,7 @@ static int verify_eraseblock(int ebnum)
 	for (i = 0; i < ebcnt && bbt[ebcnt - i - 1]; ++i)
 		addrn -= mtd->erasesize;
 
-	set_random_data(writebuf, mtd->erasesize);
+	prandom_bytes_state(&rnd_state, writebuf, mtd->erasesize);
 	for (j = 0; j < pgcnt - 1; ++j, addr += pgsize) {
 		/* Do a read to set the internal dataRAMs to different data */
 		err = mtd_read(mtd, addr0, bufsize, &read, twopages);
@@ -160,7 +142,8 @@ static int verify_eraseblock(int ebnum)
 	}
 	/* Check boundary between eraseblocks */
 	if (addr <= addrn - pgsize - pgsize && !bbt[ebnum + 1]) {
-		unsigned long oldnext = next;
+		struct rnd_state old_state = rnd_state;
+
 		/* Do a read to set the internal dataRAMs to different data */
 		err = mtd_read(mtd, addr0, bufsize, &read, twopages);
 		if (mtd_is_bitflip(err))
@@ -188,13 +171,13 @@ static int verify_eraseblock(int ebnum)
 			return err;
 		}
 		memcpy(boundary, writebuf + mtd->erasesize - pgsize, pgsize);
-		set_random_data(boundary + pgsize, pgsize);
+		prandom_bytes_state(&rnd_state, boundary + pgsize, pgsize);
 		if (memcmp(twopages, boundary, bufsize)) {
 			printk(PRINT_PREF "error: verify failed at %#llx\n",
 			       (long long)addr);
 			errcnt += 1;
 		}
-		next = oldnext;
+		rnd_state = old_state;
 	}
 	return err;
 }
@@ -326,7 +309,7 @@ static int erasecrosstest(void)
 		return err;
 
 	printk(PRINT_PREF "writing 1st page of block %d\n", ebnum);
-	set_random_data(writebuf, pgsize);
+	prandom_bytes_state(&rnd_state, writebuf, pgsize);
 	strcpy(writebuf, "There is no data like this!");
 	err = mtd_write(mtd, addr0, pgsize, &written, writebuf);
 	if (err || written != pgsize) {
@@ -359,7 +342,7 @@ static int erasecrosstest(void)
 		return err;
 
 	printk(PRINT_PREF "writing 1st page of block %d\n", ebnum);
-	set_random_data(writebuf, pgsize);
+	prandom_bytes_state(&rnd_state, writebuf, pgsize);
 	strcpy(writebuf, "There is no data like this!");
 	err = mtd_write(mtd, addr0, pgsize, &written, writebuf);
 	if (err || written != pgsize) {
@@ -417,7 +400,7 @@ static int erasetest(void)
 		return err;
 
 	printk(PRINT_PREF "writing 1st page of block %d\n", ebnum);
-	set_random_data(writebuf, pgsize);
+	prandom_bytes_state(&rnd_state, writebuf, pgsize);
 	err = mtd_write(mtd, addr0, pgsize, &written, writebuf);
 	if (err || written != pgsize) {
 		printk(PRINT_PREF "error: write failed at %#llx\n",
@@ -565,7 +548,7 @@ static int __init mtd_pagetest_init(void)
 	printk(PRINT_PREF "erased %u eraseblocks\n", i);
 
 	/* Write all eraseblocks */
-	simple_srand(1);
+	prandom_seed_state(&rnd_state, 1);
 	printk(PRINT_PREF "writing whole device\n");
 	for (i = 0; i < ebcnt; ++i) {
 		if (bbt[i])
@@ -580,7 +563,7 @@ static int __init mtd_pagetest_init(void)
 	printk(PRINT_PREF "written %u eraseblocks\n", i);
 
 	/* Check all eraseblocks */
-	simple_srand(1);
+	prandom_seed_state(&rnd_state, 1);
 	printk(PRINT_PREF "verifying all eraseblocks\n");
 	for (i = 0; i < ebcnt; ++i) {
 		if (bbt[i])
-- 
1.7.11.7


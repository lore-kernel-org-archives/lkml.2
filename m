Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab2KINNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 08:13:14 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:45415 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab2KINNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 08:13:12 -0500
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH] x86: memtest: make it a bit faster
Date: Fri,  9 Nov 2012 14:12:38 +0100
Message-Id: <1352466758-4596-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While implementing the same functionality for arm, I've noticed that
memtest does an unnecessary round to zero the memory. Just reversing the
order so that the last round writes 0s spares that round.

While there, I've also changed the message if bad memory is found from
informational to emergency.

And last I've removed some warnings from checkpatch.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 arch/x86/mm/memtest.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index c80b9fb..da80083 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -9,7 +9,7 @@
 #include <linux/memblock.h>
 
 static u64 patterns[] __initdata = {
-	0,
+	0, /* Has has to be 0 to leave memtest with zeroed memory */
 	0xffffffffffffffffULL,
 	0x5555555555555555ULL,
 	0xaaaaaaaaaaaaaaaaULL,
@@ -30,7 +30,7 @@ static u64 patterns[] __initdata = {
 
 static void __init reserve_bad_mem(u64 pattern, u64 start_bad, u64 end_bad)
 {
-	printk(KERN_INFO "  %016llx bad mem addr %010llx - %010llx reserved\n",
+	pr_emerg("  %016llx bad mem addr %010llx - %010llx reserved\n",
 	       (unsigned long long) pattern,
 	       (unsigned long long) start_bad,
 	       (unsigned long long) end_bad);
@@ -77,7 +77,7 @@ static void __init do_one_pass(u64 pattern, u64 start, u64 end)
 		this_start = clamp_t(phys_addr_t, this_start, start, end);
 		this_end = clamp_t(phys_addr_t, this_end, start, end);
 		if (this_start < this_end) {
-			printk(KERN_INFO "  %010llx - %010llx pattern %016llx\n",
+			pr_info("  %010llx - %010llx pattern %016llx\n",
 			       (unsigned long long)this_start,
 			       (unsigned long long)this_end,
 			       (unsigned long long)cpu_to_be64(pattern));
@@ -91,8 +91,10 @@ static int memtest_pattern __initdata;
 
 static int __init parse_memtest(char *arg)
 {
+	ssize_t ret __always_unused;
+
 	if (arg)
-		memtest_pattern = simple_strtoul(arg, NULL, 0);
+		ret = kstrtoint(arg, 0, &memtest_pattern);
 	else
 		memtest_pattern = ARRAY_SIZE(patterns);
 
@@ -109,16 +111,9 @@ void __init early_memtest(unsigned long start, unsigned long end)
 	if (!memtest_pattern)
 		return;
 
-	printk(KERN_INFO "early_memtest: # of tests: %d\n", memtest_pattern);
-	for (i = 0; i < memtest_pattern; i++) {
+	pr_info("early_memtest: # of tests: %d\n", memtest_pattern);
+	for (i = memtest_pattern-1; i < UINT_MAX; --i) {
 		idx = i % ARRAY_SIZE(patterns);
 		do_one_pass(patterns[idx], start, end);
 	}
-
-	if (idx > 0) {
-		printk(KERN_INFO "early_memtest: wipe out "
-		       "test pattern from memory\n");
-		/* additional test with pattern 0 will do this */
-		do_one_pass(0, start, end);
-	}
 }
-- 
1.7.11.7


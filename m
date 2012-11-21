Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab2KUQYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 11:24:52 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:57934 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258Ab2KUQYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 11:24:50 -0500
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 2/2] x86: memtest: remove unnecessary round to leave memtest with zeroed mem
Date: Wed, 21 Nov 2012 17:24:11 +0100
Message-Id: <1353515051-11605-2-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1353515051-11605-1-git-send-email-holler@ahsoftware.de>
References: <50ACFEBF.4070906@ahsoftware.de>
 <1353515051-11605-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By just reversing the order memtest is using the test patterns, an
additional round to zero the memory is not necessary.

This makes it a bit faster.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 arch/x86/mm/memtest.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index 855a6d5..da80083 100644
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
@@ -112,15 +112,8 @@ void __init early_memtest(unsigned long start, unsigned long end)
 		return;
 
 	pr_info("early_memtest: # of tests: %d\n", memtest_pattern);
-	for (i = 0; i < memtest_pattern; i++) {
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
1.7.8.6


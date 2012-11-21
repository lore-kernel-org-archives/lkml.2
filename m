Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab2KUQYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 11:24:47 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:57926 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab2KUQYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 11:24:46 -0500
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 1/2] x86: memtest: checkpatch and emergency warning if memtest fails
Date: Wed, 21 Nov 2012 17:24:10 +0100
Message-Id: <1353515051-11605-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <50ACFEBF.4070906@ahsoftware.de>
References: <50ACFEBF.4070906@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've used the source of memtest.c for a 32bit version (to use with ARM)
and checkpatch had some warnings. This patch removes them.

It also changes the message if bad memory was found from warning
to emergency.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 arch/x86/mm/memtest.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index c80b9fb..855a6d5 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
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
 
@@ -109,7 +111,7 @@ void __init early_memtest(unsigned long start, unsigned long end)
 	if (!memtest_pattern)
 		return;
 
-	printk(KERN_INFO "early_memtest: # of tests: %d\n", memtest_pattern);
+	pr_info("early_memtest: # of tests: %d\n", memtest_pattern);
 	for (i = 0; i < memtest_pattern; i++) {
 		idx = i % ARRAY_SIZE(patterns);
 		do_one_pass(patterns[idx], start, end);
-- 
1.7.8.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab1HVQ1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 12:27:24 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:62531 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab1HVQ1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 12:27:20 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 1/4] debug-pagealloc: use plain __ratelimit() instead of printk_ratelimit()
Date: Tue, 23 Aug 2011 01:29:05 +0900
Message-Id: <1314030548-21082-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1314030548-21082-1-git-send-email-akinobu.mita@gmail.com>
References: <1314030548-21082-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk_ratelimit() should not be used, because it shares ratelimiting
state with all other unrelated printk_ratelimit() callsites.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 mm/debug-pagealloc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/mm/debug-pagealloc.c b/mm/debug-pagealloc.c
index a1e3324..a4b6d70 100644
--- a/mm/debug-pagealloc.c
+++ b/mm/debug-pagealloc.c
@@ -2,6 +2,7 @@
 #include <linux/mm.h>
 #include <linux/page-debug-flags.h>
 #include <linux/poison.h>
+#include <linux/ratelimit.h>
 
 static inline void set_page_poison(struct page *page)
 {
@@ -59,6 +60,7 @@ static bool single_bit_flip(unsigned char a, unsigned char b)
 
 static void check_poison_mem(unsigned char *mem, size_t bytes)
 {
+	static DEFINE_RATELIMIT_STATE(ratelimit, 5 * HZ, 10);
 	unsigned char *start;
 	unsigned char *end;
 
@@ -74,7 +76,7 @@ static void check_poison_mem(unsigned char *mem, size_t bytes)
 			break;
 	}
 
-	if (!printk_ratelimit())
+	if (!__ratelimit(&ratelimit))
 		return;
 	else if (start == end && single_bit_flip(*start, PAGE_POISON))
 		printk(KERN_ERR "pagealloc: single bit error\n");
-- 
1.7.4.4


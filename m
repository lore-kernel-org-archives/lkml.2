Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab1JQXFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 19:05:39 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46334 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab1JQXFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 19:05:38 -0400
From: Dan McGee <dpmcgee@gmail.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: benh@kernel.crashing.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>
Subject: [PATCH] powerpc/mm: remove hack in mmap randomize layout
Date: Mon, 17 Oct 2011 18:05:23 -0500
Message-Id: <1318892723-19401-1-git-send-email-dpmcgee@gmail.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <20111017.185357.1185691091043314919.davem@davemloft.net>
References: <20111017.185357.1185691091043314919.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 8a0a9bd4db63bc45e301, this comment in mmap_rnd() does not
hold true as the value returned by get_random_int() will in fact be
different every single call. Remove the comment and simplify the code
back to its original desired form.

This reverts commit a5adc91a4b44b5d1 which is no longer necessary and
also fixes the sparc code that copied this same adjustment.

Signed-off-by: Dan McGee <dpmcgee@gmail.com>
---
 arch/powerpc/mm/mmap_64.c        |   14 +++-----------
 arch/sparc/kernel/sys_sparc_64.c |    6 +++---
 2 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/mm/mmap_64.c b/arch/powerpc/mm/mmap_64.c
index 5a783d8..67a42ed 100644
--- a/arch/powerpc/mm/mmap_64.c
+++ b/arch/powerpc/mm/mmap_64.c
@@ -53,14 +53,6 @@ static inline int mmap_is_legacy(void)
 	return sysctl_legacy_va_layout;
 }
 
-/*
- * Since get_random_int() returns the same value within a 1 jiffy window,
- * we will almost always get the same randomisation for the stack and mmap
- * region. This will mean the relative distance between stack and mmap will
- * be the same.
- *
- * To avoid this we can shift the randomness by 1 bit.
- */
 static unsigned long mmap_rnd(void)
 {
 	unsigned long rnd = 0;
@@ -68,11 +60,11 @@ static unsigned long mmap_rnd(void)
 	if (current->flags & PF_RANDOMIZE) {
 		/* 8MB for 32bit, 1GB for 64bit */
 		if (is_32bit_task())
-			rnd = (long)(get_random_int() % (1<<(22-PAGE_SHIFT)));
+			rnd = (long)(get_random_int() % (1<<(23-PAGE_SHIFT)));
 		else
-			rnd = (long)(get_random_int() % (1<<(29-PAGE_SHIFT)));
+			rnd = (long)(get_random_int() % (1<<(30-PAGE_SHIFT)));
 	}
-	return (rnd << PAGE_SHIFT) * 2;
+	return rnd << PAGE_SHIFT;
 }
 
 static inline unsigned long mmap_base(void)
diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index 908b47a..c2c03c8 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -368,11 +368,11 @@ static unsigned long mmap_rnd(void)
 	if (current->flags & PF_RANDOMIZE) {
 		unsigned long val = get_random_int();
 		if (test_thread_flag(TIF_32BIT))
-			rnd = (val % (1UL << (22UL-PAGE_SHIFT)));
+			rnd = (val % (1UL << (23UL-PAGE_SHIFT)));
 		else
-			rnd = (val % (1UL << (29UL-PAGE_SHIFT)));
+			rnd = (val % (1UL << (30UL-PAGE_SHIFT)));
 	}
-	return (rnd << PAGE_SHIFT) * 2;
+	return rnd << PAGE_SHIFT;
 }
 
 void arch_pick_mmap_layout(struct mm_struct *mm)
-- 
1.7.7


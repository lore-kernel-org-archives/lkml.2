Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422763Ab2JYNJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:09:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:51580 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759476Ab2JYNJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:09:49 -0400
Message-Id: <20121025124833.161298145@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 25 Oct 2012 14:16:26 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 09/31] mm/pgprot: Move the pgprot_modify() fallback definition to mm.h
References: <20121025121617.617683848@chello.nl>
Content-Disposition: inline; filename=0009-mm-pgprot-Move-the-pgprot_modify-fallback-definition.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

pgprot_modify() is available on x86, but on other architectures it only
gets defined in mm/mprotect.c - breaking the build if anything outside
of mprotect.c tries to make use of this function.

Move it to the generic pgprot area in mm.h, so that an upcoming patch
can make use of it.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>
Cc: Paul Turner <pjt@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mm.h |   13 +++++++++++++
 mm/mprotect.c      |    7 -------
 2 files changed, 13 insertions(+), 7 deletions(-)

Index: tip/include/linux/mm.h
===================================================================
--- tip.orig/include/linux/mm.h
+++ tip/include/linux/mm.h
@@ -164,6 +164,19 @@ extern pgprot_t protection_map[16];
 #define FAULT_FLAG_TRIED	0x40	/* second try */
 
 /*
+ * Some architectures (such as x86) may need to preserve certain pgprot
+ * bits, without complicating generic pgprot code.
+ *
+ * Most architectures don't care:
+ */
+#ifndef pgprot_modify
+static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
+{
+	return newprot;
+}
+#endif
+
+/*
  * vm_fault is filled by the the pagefault handler and passed to the vma's
  * ->fault function. The vma's ->fault is responsible for returning a bitmask
  * of VM_FAULT_xxx flags that give details about how the fault was handled.
Index: tip/mm/mprotect.c
===================================================================
--- tip.orig/mm/mprotect.c
+++ tip/mm/mprotect.c
@@ -28,13 +28,6 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
-#ifndef pgprot_modify
-static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
-{
-	return newprot;
-}
-#endif
-
 static void change_pte_range(struct mm_struct *mm, pmd_t *pmd,
 		unsigned long addr, unsigned long end, pgprot_t newprot,
 		int dirty_accountable)



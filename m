Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab2I0F6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:58:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54537 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab2I0F6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:58:22 -0400
Date: Wed, 26 Sep 2012 22:57:56 -0700
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-1dbd3d35fe64c555aed63eaa615e9fa085bb7b57@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        riel@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        riel@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] mm/pgprot: Move the pgprot_modify()
  fallback definition to mm.h
Git-Commit-ID: 1dbd3d35fe64c555aed63eaa615e9fa085bb7b57
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 22:58:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1dbd3d35fe64c555aed63eaa615e9fa085bb7b57
Gitweb:     http://git.kernel.org/tip/1dbd3d35fe64c555aed63eaa615e9fa085bb7b57
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 26 Sep 2012 11:48:08 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 26 Sep 2012 11:48:30 +0200

mm/pgprot: Move the pgprot_modify() fallback definition to mm.h

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
Link: http://lkml.kernel.org/n/tip-nfvarGMj9gjavowroorkizb4@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/mm.h |   13 +++++++++++++
 mm/mprotect.c      |    7 -------
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 311be90..7d573b8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -177,6 +177,19 @@ static inline int is_pfn_mapping(struct vm_area_struct *vma)
 }
 
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
diff --git a/mm/mprotect.c b/mm/mprotect.c
index a409926..e97b0d6 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
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

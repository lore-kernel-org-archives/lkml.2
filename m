Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031241Ab2CUOgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 10:36:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030742Ab2CUOgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 10:36:17 -0400
Subject: build failure in linux-next
From: Mark Salter <msalter@redhat.com>
To: aarcange@redhat.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>
Date: Wed, 21 Mar 2012 10:36:14 -0400
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1332340575.12353.55.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing a build failure in linux-next:

  CC      init/main.o
In file included from /es/linux/linux-next/arch/c6x/include/asm/pgtable.h:76:0,
                 from /es/linux/linux-next/include/linux/mm.h:44,
                 from /es/linux/linux-next/include/linux/ring_buffer.h:5,
                 from /es/linux/linux-next/include/linux/ftrace_event.h:4,
                 from /es/linux/linux-next/include/trace/syscall.h:6,
                 from /es/linux/linux-next/include/linux/syscalls.h:78,
                 from /es/linux/linux-next/init/main.c:16:
/es/linux/linux-next/include/asm-generic/pgtable.h: In function 'pmd_none_or_trans_huge_or_clear_bad':
/es/linux/linux-next/include/asm-generic/pgtable.h:476:4: error: implicit declaration of function 'pmd_clear_bad' [-Werror=implicit-function-declaration]


This patch added some functions to asm-generic/pgtable.h which should
have been placed in the CONFIG_MMU conditional block:

  Author: Andrea Arcangeli <aarcange@redhat.com>
  Date:   Wed Mar 21 10:48:00 2012 +1100

      mm: thp: fix pmd_bad() triggering in code paths holding mmap_sem read mode


The following patch fixes the build problem for me:

diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 202c010..8ba3ba5 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -342,6 +342,64 @@ static inline void ptep_modify_prot_commit(struct mm_struct *mm,
 	__ptep_modify_prot_commit(mm, addr, ptep, pte);
 }
 #endif /* __HAVE_ARCH_PTEP_MODIFY_PROT_TRANSACTION */
+
+/*
+ * This function is meant to be used by sites walking pagetables with
+ * the mmap_sem hold in read mode to protect against MADV_DONTNEED and
+ * transhuge page faults. MADV_DONTNEED can convert a transhuge pmd
+ * into a null pmd and the transhuge page fault can convert a null pmd
+ * into an hugepmd or into a regular pmd (if the hugepage allocation
+ * fails). While holding the mmap_sem in read mode the pmd becomes
+ * stable and stops changing under us only if it's not null and not a
+ * transhuge pmd. When those races occurs and this function makes a
+ * difference vs the standard pmd_none_or_clear_bad, the result is
+ * undefined so behaving like if the pmd was none is safe (because it
+ * can return none anyway). The compiler level barrier() is critically
+ * important to compute the two checks atomically on the same pmdval.
+ */
+static inline int pmd_none_or_trans_huge_or_clear_bad(pmd_t *pmd)
+{
+	/* depend on compiler for an atomic pmd read */
+	pmd_t pmdval = *pmd;
+	/*
+	 * The barrier will stabilize the pmdval in a register or on
+	 * the stack so that it will stop changing under the code.
+	 */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	barrier();
+#endif
+	if (pmd_none(pmdval))
+		return 1;
+	if (unlikely(pmd_bad(pmdval))) {
+		if (!pmd_trans_huge(pmdval))
+			pmd_clear_bad(pmd);
+		return 1;
+	}
+	return 0;
+}
+
+/*
+ * This is a noop if Transparent Hugepage Support is not built into
+ * the kernel. Otherwise it is equivalent to
+ * pmd_none_or_trans_huge_or_clear_bad(), and shall only be called in
+ * places that already verified the pmd is not none and they want to
+ * walk ptes while holding the mmap sem in read mode (write mode don't
+ * need this). If THP is not enabled, the pmd can't go away under the
+ * code even if MADV_DONTNEED runs, but if THP is enabled we need to
+ * run a pmd_trans_unstable before walking the ptes after
+ * split_huge_page_pmd returns (because it may have run when the pmd
+ * become null, but then a page fault can map in a THP and not a
+ * regular page).
+ */
+static inline int pmd_trans_unstable(pmd_t *pmd)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	return pmd_none_or_trans_huge_or_clear_bad(pmd);
+#else
+	return 0;
+#endif
+}
+
 #endif /* CONFIG_MMU */
 
 /*
@@ -444,63 +502,6 @@ static inline int pmd_write(pmd_t pmd)
 #endif /* __HAVE_ARCH_PMD_WRITE */
 #endif
 
-/*
- * This function is meant to be used by sites walking pagetables with
- * the mmap_sem hold in read mode to protect against MADV_DONTNEED and
- * transhuge page faults. MADV_DONTNEED can convert a transhuge pmd
- * into a null pmd and the transhuge page fault can convert a null pmd
- * into an hugepmd or into a regular pmd (if the hugepage allocation
- * fails). While holding the mmap_sem in read mode the pmd becomes
- * stable and stops changing under us only if it's not null and not a
- * transhuge pmd. When those races occurs and this function makes a
- * difference vs the standard pmd_none_or_clear_bad, the result is
- * undefined so behaving like if the pmd was none is safe (because it
- * can return none anyway). The compiler level barrier() is critically
- * important to compute the two checks atomically on the same pmdval.
- */
-static inline int pmd_none_or_trans_huge_or_clear_bad(pmd_t *pmd)
-{
-	/* depend on compiler for an atomic pmd read */
-	pmd_t pmdval = *pmd;
-	/*
-	 * The barrier will stabilize the pmdval in a register or on
-	 * the stack so that it will stop changing under the code.
-	 */
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	barrier();
-#endif
-	if (pmd_none(pmdval))
-		return 1;
-	if (unlikely(pmd_bad(pmdval))) {
-		if (!pmd_trans_huge(pmdval))
-			pmd_clear_bad(pmd);
-		return 1;
-	}
-	return 0;
-}
-
-/*
- * This is a noop if Transparent Hugepage Support is not built into
- * the kernel. Otherwise it is equivalent to
- * pmd_none_or_trans_huge_or_clear_bad(), and shall only be called in
- * places that already verified the pmd is not none and they want to
- * walk ptes while holding the mmap sem in read mode (write mode don't
- * need this). If THP is not enabled, the pmd can't go away under the
- * code even if MADV_DONTNEED runs, but if THP is enabled we need to
- * run a pmd_trans_unstable before walking the ptes after
- * split_huge_page_pmd returns (because it may have run when the pmd
- * become null, but then a page fault can map in a THP and not a
- * regular page).
- */
-static inline int pmd_trans_unstable(pmd_t *pmd)
-{
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	return pmd_none_or_trans_huge_or_clear_bad(pmd);
-#else
-	return 0;
-#endif
-}
-
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_GENERIC_PGTABLE_H */



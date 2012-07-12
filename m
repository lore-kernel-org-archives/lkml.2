Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162349Ab2GLWu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:50:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44509 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162310Ab2GLWp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:45:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andrea Arcangeli <aarcange@redhat.com>,
        Jonathan Nieder <jrnieder@gmail.com>,
        Ulrich Obergfell <uobergfe@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Larry Woodman <lwoodman@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, Rik van Riel <riel@redhat.com>,
        Jan Beulich <jbeulich@suse.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andrew Jones <drjones@redhat.com>
Subject: [ 170/187] thp: avoid atomic64_read in pmd_read_atomic for 32bit PAE
Date: Thu, 12 Jul 2012 15:35:26 -0700
Message-Id: <20120712191539.058077109@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Arcangeli <aarcange@redhat.com>

commit e4eed03fd06578571c01d4f1478c874bb432c815 upstream.

In the x86 32bit PAE CONFIG_TRANSPARENT_HUGEPAGE=y case while holding the
mmap_sem for reading, cmpxchg8b cannot be used to read pmd contents under
Xen.

So instead of dealing only with "consistent" pmdvals in
pmd_none_or_trans_huge_or_clear_bad() (which would be conceptually
simpler) we let pmd_none_or_trans_huge_or_clear_bad() deal with pmdvals
where the low 32bit and high 32bit could be inconsistent (to avoid having
to use cmpxchg8b).

The only guarantee we get from pmd_read_atomic is that if the low part of
the pmd was found null, the high part will be null too (so the pmd will be
considered unstable).  And if the low part of the pmd is found "stable"
later, then it means the whole pmd was read atomically (because after a
pmd is stable, neither MADV_DONTNEED nor page faults can alter it anymore,
and we read the high part after the low part).

In the 32bit PAE x86 case, it is enough to read the low part of the pmdval
atomically to declare the pmd as "stable" and that's true for THP and no
THP, furthermore in the THP case we also have a barrier() that will
prevent any inconsistent pmdvals to be cached by a later re-read of the
*pmd.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Petr Matousek <pmatouse@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Jan Beulich <jbeulich@suse.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Tested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/pgtable-3level.h |   30 +++++++++++++++++-------------
 include/asm-generic/pgtable.h         |   10 ++++++++++
 2 files changed, 27 insertions(+), 13 deletions(-)

--- a/arch/x86/include/asm/pgtable-3level.h
+++ b/arch/x86/include/asm/pgtable-3level.h
@@ -47,16 +47,26 @@ static inline void native_set_pte(pte_t
  * they can run pmd_offset_map_lock or pmd_trans_huge or other pmd
  * operations.
  *
- * Without THP if the mmap_sem is hold for reading, the
- * pmd can only transition from null to not null while pmd_read_atomic runs.
- * So there's no need of literally reading it atomically.
+ * Without THP if the mmap_sem is hold for reading, the pmd can only
+ * transition from null to not null while pmd_read_atomic runs. So
+ * we can always return atomic pmd values with this function.
  *
  * With THP if the mmap_sem is hold for reading, the pmd can become
- * THP or null or point to a pte (and in turn become "stable") at any
- * time under pmd_read_atomic, so it's mandatory to read it atomically
- * with cmpxchg8b.
+ * trans_huge or none or point to a pte (and in turn become "stable")
+ * at any time under pmd_read_atomic. We could read it really
+ * atomically here with a atomic64_read for the THP enabled case (and
+ * it would be a whole lot simpler), but to avoid using cmpxchg8b we
+ * only return an atomic pmdval if the low part of the pmdval is later
+ * found stable (i.e. pointing to a pte). And we're returning a none
+ * pmdval if the low part of the pmd is none. In some cases the high
+ * and low part of the pmdval returned may not be consistent if THP is
+ * enabled (the low part may point to previously mapped hugepage,
+ * while the high part may point to a more recently mapped hugepage),
+ * but pmd_none_or_trans_huge_or_clear_bad() only needs the low part
+ * of the pmd to be read atomically to decide if the pmd is unstable
+ * or not, with the only exception of when the low part of the pmd is
+ * zero in which case we return a none pmd.
  */
-#ifndef CONFIG_TRANSPARENT_HUGEPAGE
 static inline pmd_t pmd_read_atomic(pmd_t *pmdp)
 {
 	pmdval_t ret;
@@ -74,12 +84,6 @@ static inline pmd_t pmd_read_atomic(pmd_
 
 	return (pmd_t) { ret };
 }
-#else /* CONFIG_TRANSPARENT_HUGEPAGE */
-static inline pmd_t pmd_read_atomic(pmd_t *pmdp)
-{
-	return (pmd_t) { atomic64_read((atomic64_t *)pmdp) };
-}
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static inline void native_set_pte_atomic(pte_t *ptep, pte_t pte)
 {
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -485,6 +485,16 @@ static inline int pmd_none_or_trans_huge
 	/*
 	 * The barrier will stabilize the pmdval in a register or on
 	 * the stack so that it will stop changing under the code.
+	 *
+	 * When CONFIG_TRANSPARENT_HUGEPAGE=y on x86 32bit PAE,
+	 * pmd_read_atomic is allowed to return a not atomic pmdval
+	 * (for example pointing to an hugepage that has never been
+	 * mapped in the pmd). The below checks will only care about
+	 * the low part of the pmd with 32bit PAE x86 anyway, with the
+	 * exception of pmd_none(). So the important thing is that if
+	 * the low part of the pmd is found null, the high part will
+	 * be also null or the pmd_none() check below would be
+	 * confused.
 	 */
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	barrier();



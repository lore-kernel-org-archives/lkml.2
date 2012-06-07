Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761356Ab2FGTEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 15:04:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761304Ab2FGTEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 15:04:31 -0400
Date: Thu, 7 Jun 2012 21:04:15 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Boyer <jwboyer@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ulrich Obergfell <uobergfe@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Larry Woodman <lwoodman@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [ 08/82] mm: pmd_read_atomic: fix 32bit PAE pmd walk vs
 pmd_populate SMP race condition
Message-ID: <20120607190414.GF21339@redhat.com>
References: <20120607041406.GA13233@kroah.com>
 <20120607040337.622672845@linuxfoundation.org>
 <CA+5PVA6A0K3WYBQJH8z3ddd2X3=fQm1a34z+fWSYGcUg4TR9+A@mail.gmail.com>
 <20120607144204.GD21339@redhat.com>
 <CA+55aFzv-z0njtAnpgOsVES70+igwV7HCteQbQ6M6uTsYvn5WQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzv-z0njtAnpgOsVES70+igwV7HCteQbQ6M6uTsYvn5WQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 10:46:44AM -0700, Linus Torvalds wrote:
> So I assume that Xen just turns the page tables read-only in order to
> track them, and then assumes that nobody modifies them in the
> particular section. And the cmpxchg64 looks like a modification, even
> if we only use it to read things.

Agreed, the implicit write could be the trigger.

> Andrea, do we have any guarantees like "once it has turned into a
> regular page table, we won't see it turn back if we hold the mmap
> sem"? Or anything like that? Because it is possible that we could do

Yes if it turns in a regular page table it will stop changing.

The problem is this is the THP case. Without THP it can only change
from nono to regular page table. With THP it can change from none to
trans_huge to none to trans_huge and it only stops if it eventually
becomes a regular page table.

> this entirely with some ordering guarantee - something like the
> attached patch?

It's possible to do it with a loop like in the patch, gup_fast does it
that way (and gup_fast does it on the pte so the pte is susciptible to
the exact same instability that the pmd has even when THP=n, as
madvise/pagefault can run under gup_fast), but I'm not sure if it's
safe especially with irqs enabled.  Maybe gup_fast is safe because it
disables irqs to stop MADV_DONTNEED?

The race would be:

            l = pmd.low
            smp_rmb()
            h = pmd.high
	    smp_rmb()
                                       pmd points to page 4G
                                       MADV_DONTNEED
                                       page fault allocates page at 8G
            l = pmd.low

Disabling irqs may be enough to hang MADV_DONTNEED on the tlb flush
IPI. But my feeling is the page fault can happen even while
MADV_DONTNEED waits on the tlb flush IPI. So the above could still
happen on gup_fast too? But of course gup_fast troubles are irrelevant
here, but I was thinking about this one before... so I mentioned it
too as it's the same problem.

The "simple" idea in pmd_none_or_trans_huge_or_clear_bad is that we
need an atomic snapshot of the pmdval, stabilize it in register or
local stack, and do the computations on it to know if the pmd is
stable or unstable.

But the more "complex" idea would be to relay on the below barrier and
deal with "half corrupted" pmds.

#ifdef CONFIG_TRANSPARENT_HUGEPAGE
	barrier();
#endif

the barrier prevents the *pmdp read to be cached across the return of
pmd_none_or_trans_huge_or_clear_bad when THP=y (our problem case). And
all we need is to compute those checks atomically on the "low" part.

	if (pmd_none(pmdval))
		return 1;
	if (unlikely(pmd_bad(pmdval))) {
		if (!pmd_trans_huge(pmdval))
			pmd_clear_bad(pmd);
		return 1;
	}

If we remove the #ifdef CONFIG_TRANSPARENT_HUGEPAGE around the
barrier(), we can get rid of pmd_read_atomic entirely and just do *pmd
as before the fix (however note that if we triggered the crash in
madvise with 32bit pae THP=n it means the value was cached by gcc and
the corrupted pmdval was used for running pte_offset). So if we make
the barrier() unconditional we'll force a second access to
memory. This is the whole point of the barrier() conditional (to avoid
screwing with gcc good work when not absolutely necessary).

Anyway I made a patch below to take advantage of the barrier() and
deal with corrupted pmds on pae 32bit x86 THP=y which I hope could fix
this more optimally:

diff --git a/arch/x86/include/asm/pgtable-3level.h b/arch/x86/include/asm/pgtable-3level.h
index 43876f1..149d968 100644
--- a/arch/x86/include/asm/pgtable-3level.h
+++ b/arch/x86/include/asm/pgtable-3level.h
@@ -31,7 +31,6 @@ static inline void native_set_pte(pte_t *ptep, pte_t pte)
 	ptep->pte_low = pte.pte_low;
 }
 
-#define pmd_read_atomic pmd_read_atomic
 /*
  * pte_offset_map_lock on 32bit PAE kernels was reading the pmd_t with
  * a "*pmdp" dereference done by gcc. Problem is, in certain places
@@ -53,10 +52,18 @@ static inline void native_set_pte(pte_t *ptep, pte_t pte)
  *
  * With THP if the mmap_sem is hold for reading, the pmd can become
  * THP or null or point to a pte (and in turn become "stable") at any
- * time under pmd_read_atomic, so it's mandatory to read it atomically
- * with cmpxchg8b.
+ * time under pmd_read_atomic. We could read it atomically here with a
+ * pmd_read_atomic using atomic64_read for the THP case, but instead
+ * we let the generic version of pmd_read_atomic run, and we instead
+ * relay on the barrier() in pmd_none_or_trans_huge_or_clear_bad() to
+ * prevent gcc to cache the potentially corrupted pmdval in pte_offset
+ * later. The barrier() will force the re-reading of the pmd and the
+ * checks in pmd_none_or_trans_huge_or_clear_bad() will only care
+ * about the low part of the pmd, regardless if the high part is
+ * consistent.
  */
 #ifndef CONFIG_TRANSPARENT_HUGEPAGE
+#define pmd_read_atomic pmd_read_atomic
 static inline pmd_t pmd_read_atomic(pmd_t *pmdp)
 {
 	pmdval_t ret;
@@ -74,11 +81,6 @@ static inline pmd_t pmd_read_atomic(pmd_t *pmdp)
 
 	return (pmd_t) { ret };
 }
-#else /* CONFIG_TRANSPARENT_HUGEPAGE */
-static inline pmd_t pmd_read_atomic(pmd_t *pmdp)
-{
-	return (pmd_t) { atomic64_read((atomic64_t *)pmdp) };
-}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static inline void native_set_pte_atomic(pte_t *ptep, pte_t pte)
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index ae39c4b..29e648a 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -484,6 +484,13 @@ static inline int pmd_none_or_trans_huge_or_clear_bad(pmd_t *pmd)
 	/*
 	 * The barrier will stabilize the pmdval in a register or on
 	 * the stack so that it will stop changing under the code.
+	 *
+	 * The barrier for the "x86 32bit PAE
+	 * CONFIG_TRANSPARENT_HUGEPAGE=y" case will also prevent an
+	 * inconsistent pmd low/high values (obtained by the generic
+	 * version of pmd_read_atomic) to be cached by gcc. The below
+	 * checks will only care about the low part of the pmd with
+	 * 32bit PAE.
 	 */
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	barrier();



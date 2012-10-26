Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab2JZGYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 02:24:10 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:62781 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381Ab2JZGYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 02:24:08 -0400
Date: Fri, 26 Oct 2012 08:24:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 04/31, v2] x86/mm: Introduce pte_accessible()
Message-ID: <20121026062402.GA8141@gmail.com>
References: <20121025121617.617683848@chello.nl>
 <20121025124832.770994193@chello.nl>
 <CA+55aFxSihF0RHc8npWcMdHOo8LOx+d=aV4G6_577REn=OXsQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxSihF0RHc8npWcMdHOo8LOx+d=aV4G6_577REn=OXsQw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> NAK NAK NAK.
> 
> On Thu, Oct 25, 2012 at 5:16 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > +#define __HAVE_ARCH_PTE_ACCESSIBLE
> > +static inline int pte_accessible(pte_t a)
> 
> Stop doing this f*cking crazy ad-hoc "I have some other name
> available" #defines.
> 
> Use the same name, for chissake! Don't make up new random names.
> 
> Just do
> 
>    #define pte_accessible pte_accessible
> 
> and then you can use
> 
>    #ifndef pte_accessible
> 
> to define the generic thing. Instead of having this INSANE "two
> different names for the same f*cking thing" crap.

Yeah...

> Stop it. Really.
> 
> Also, this:
> 
> > +#ifndef __HAVE_ARCH_PTE_ACCESSIBLE
> > +#define pte_accessible(pte)            pte_present(pte)
> > +#endif
> 
> looks unsafe and like a really bad idea.
> 
> You should probably do
> 
>   #ifndef pte_accessible
>     #define pte_accessible(pte) ((void)(pte),1)
>   #endif
> 
> because you have no idea if other architectures do
> 
>  (a) the same trick as x86 does for PROT_NONE (I can already tell you
> from a quick grep that ia64, m32r, m68k and sh do it)
>  (b) might not perhaps be caching non-present pte's anyway

Indeed that's much safer and each arch can opt-in consciously 
instead of us offering a potentially unsafe optimization.

> So NAK on this whole patch. It's bad. It's ugly, it's wrong, 
> and it's actively buggy.

I have fixed it as per the updated patch below. Only very 
lightly tested.

Thanks,

	Ingo

----------------------------->
Subject: x86/mm: Introduce pte_accessible()
From: Rik van Riel <riel@redhat.com>
Date: Tue, 9 Oct 2012 15:31:12 +0200

We need pte_present to return true for _PAGE_PROTNONE pages, to indicate that
the pte is associated with a page.

However, for TLB flushing purposes, we would like to know whether the pte
points to an actually accessible page.  This allows us to skip remote TLB
flushes for pages that are not actually accessible.

Fill in this method for x86 and provide a safe (but slower) method
on other architectures.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Fixed-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-66p11te4uj23gevgh4j987ip@git.kernel.org
[ Added Linus's review fixes. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/pgtable.h |    6 ++++++
 include/asm-generic/pgtable.h  |    4 ++++
 2 files changed, 10 insertions(+)

Index: tip/arch/x86/include/asm/pgtable.h
===================================================================
--- tip.orig/arch/x86/include/asm/pgtable.h
+++ tip/arch/x86/include/asm/pgtable.h
@@ -408,6 +408,12 @@ static inline int pte_present(pte_t a)
 	return pte_flags(a) & (_PAGE_PRESENT | _PAGE_PROTNONE);
 }
 
+#define pte_accessible pte_accessible
+static inline int pte_accessible(pte_t a)
+{
+	return pte_flags(a) & _PAGE_PRESENT;
+}
+
 static inline int pte_hidden(pte_t pte)
 {
 	return pte_flags(pte) & _PAGE_HIDDEN;
Index: tip/include/asm-generic/pgtable.h
===================================================================
--- tip.orig/include/asm-generic/pgtable.h
+++ tip/include/asm-generic/pgtable.h
@@ -219,6 +219,10 @@ static inline int pmd_same(pmd_t pmd_a,
 #define move_pte(pte, prot, old_addr, new_addr)	(pte)
 #endif
 
+#ifndef pte_accessible
+# define pte_accessible(pte)		((void)(pte),1)
+#endif
+
 #ifndef flush_tlb_fix_spurious_fault
 #define flush_tlb_fix_spurious_fault(vma, address) flush_tlb_page(vma, address)
 #endif

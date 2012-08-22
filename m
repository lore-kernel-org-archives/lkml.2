Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab2HVBM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 21:12:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862Ab2HVBMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 21:12:24 -0400
Date: Wed, 22 Aug 2012 03:12:13 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sasha Levin <levinsasha928@gmail.com>, viro <viro@zeniv.linux.org.uk>,
        oleg@redhat.com, "a.p.zijlstra" <a.p.zijlstra@chello.nl>,
        mingo <mingo@kernel.org>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: mm: kernel BUG at mm/memory.c:1230
Message-ID: <20120822011213.GM29978@redhat.com>
References: <1337884054.3292.22.camel@lappy>
 <20120524120727.6eab2f97.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120524120727.6eab2f97.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

On Thu, May 24, 2012 at 12:07:27PM -0700, Andrew Morton wrote:
> On Thu, 24 May 2012 20:27:34 +0200
> Sasha Levin <levinsasha928@gmail.com> wrote:
> 
> > Hi all,
> > 
> > During fuzzing with trinity inside a KVM tools guest, using latest linux-next, I've stumbled on the following:
> > 
> > [ 2043.098949] ------------[ cut here ]------------
> > [ 2043.099014] kernel BUG at mm/memory.c:1230!
> 
> That's
> 
> 	VM_BUG_ON(!rwsem_is_locked(&tlb->mm->mmap_sem));
> 
> in zap_pmd_range()?

Originally split_huge_page_address didn't exist. If the vma was
splitted at a not 2m aligned address by a syscall like madvise that
would only mangle the vma and not touch the pagetables (munmap for
example was safe), the THP would remain in place and it would lead to
a BUG_ON in split_huge_page where the number of rmaps was different
than the page_mapcount for a cascade of side effects of the above bug
triggering. It was a the most more obscure BUG_ON I got in the whole
THP development and the hardest bug to fix (it was not easily
reproducible either, madvise not so common).

After I fixed it adding split_huge_page_address, I also added this
VM_BUG_ON(!rwsem_is_locked(&tlb->mm->mmap_sem)). So if I missed any
split_huge_page_address invocation I would get a more meaningful
VM_BUG_ON, closer to the actual bug, signaling problems in the vma
layout and not anymore a misleading BUG_ON in the split_huge_page
internals when in fact split_huge_page was perfectly fine.

My previous theory was a bug in the vma mangling of mbind, it could
still be it, I didn't review it closely yet. But mbind is one syscall
that like madvise depends on split_huge_page_address when it does
split_vma!

So now I think I found the cause of the above
VM_BUG_ON. split_huge_page_address uses pmd_present so it won't run if
the hugepage is under splitting. So it's likely the below will fix the
above VM_BUG_ON. The race condition is tiny, it's not a critical bug
and it makes sense that only a syscall stresser like trinity can
exercise it and not any real app.

static void split_huge_page_address(struct mm_struct *mm,
				    unsigned long address)
{
[..]
	if (!pmd_present(*pmd))
		return;
	/*
	 * Caller holds the mmap_sem write mode, so a huge pmd cannot
	 * materialize from under us.
	 */
	split_huge_page_pmd(mm, pmd);
}

This time I think it is worth to fix pmd_present for good instead of
converting it to !pmd_none like I did with most others.

I'm well aware pmd_present wasn't ok during split_huge_page but most
have been converted and I didn't change what wasn't absolutely
necessary in case some lowlevel code depended on the lowlevel
semantics of pmd_present (strict _PRESENT check) but now it looks to
risky not to fix it.

The below patch isn't well tested yet. Reviews welcome. Especially if
you could test it again with trinity over the mbind syscall it'd be
wonderful.

Thanks,
Andrea

===
>From 59af0d4348eb07087097e310f60422b994dd3a2c Mon Sep 17 00:00:00 2001
From: Andrea Arcangeli <aarcange@redhat.com>
Date: Tue, 21 Aug 2012 19:32:23 +0200
Subject: [PATCH] thp: make pmd_present more accurate

In many places !pmd_present has been converted to pmd_none. For pmds
that's equivalent and pmd_none is quicker so using pmd_none is
better.

However we should provide a more accurate pmd_present too. This will
avoid the risk of code thinking the pmd is non present because it's
under __split_huge_page_map, see the pmd_mknotpresent there and the
comment above it.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/include/asm/pgtable.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 49afb3f..b49e70d 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -415,7 +415,13 @@ static inline int pte_hidden(pte_t pte)
 
 static inline int pmd_present(pmd_t pmd)
 {
-	return pmd_flags(pmd) & _PAGE_PRESENT;
+	/*
+	 * Checking for _PAGE_PSE is needed too because
+	 * split_huge_page will temporarily clear the present bit (but
+	 * the _PAGE_PSE flag will remain set at all times while the
+	 * _PAGE_PRESENT bit is clear).
+	 */
+	return pmd_flags(pmd) & (_PAGE_PRESENT | _PAGE_PROTNONE | _PAGE_PSE);
 }
 
 static inline int pmd_none(pmd_t pmd)



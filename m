Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab0H1BH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 21:07:29 -0400
Received: from smtp-out.google.com ([216.239.44.51]:34251 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab0H1BH1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 21:07:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UgVsifbNxtbsBHtBJKc+MrifhWu1fxRkBI5ThF/Gu4jSAYjUkTcD1cn7vXIgBCxQoX
         Xgy3mszI2MTFvpcSmiCw==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1008271801080.25115@router.home>
References: <alpine.LSU.2.00.1008252305540.19107@sister.anvils>
	<20100826235052.GZ6803@random.random>
	<AANLkTimgKcP78CNakDf34NrVrd5apfXrtptNw+G6G5DK@mail.gmail.com>
	<20100827095546.GC6803@random.random>
	<AANLkTikvB1fN42A91ZdEHyEXnz2bGw9Q21dJcfa3PBP0@mail.gmail.com>
	<alpine.DEB.2.00.1008271159160.18495@router.home>
	<AANLkTi=FeHnLu4_6M5N6yUL==4YyxVXXxsccsE2kNUbm@mail.gmail.com>
	<alpine.DEB.2.00.1008271420400.18495@router.home>
	<AANLkTinLpDnpwr40dtU5UFq53avODSKxTA4=xnZwmJFX@mail.gmail.com>
	<alpine.DEB.2.00.1008271547200.22988@router.home>
	<AANLkTim16oT13keYK_oz=7kmDmdG=ADfkGXMKp3_dEw_@mail.gmail.com>
	<AANLkTikML=HghpOVK0WZ0t6CRaNOKvu=57ebojZ+YCNS@mail.gmail.com>
	<alpine.DEB.2.00.1008271801080.25115@router.home>
Date: Fri, 27 Aug 2010 18:07:23 -0700
Message-ID: <AANLkTindjNiJXbfsWbFexXBQVB174aprhSbBLFosBvC=@mail.gmail.com>
Subject: Re: [PATCH] mm: fix hang on anon_vma->root->lock
From: Hugh Dickins <hughd@google.com>
To: Christoph Lameter <cl@linux.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 4:06 PM, Christoph Lameter <cl@linux.com> wrote:
> On Fri, 27 Aug 2010, Hugh Dickins wrote:
>
>> >> I do not see a second check (*after* taking the lock) in the patch
>>
>>         if (page_mapped(page))
>>                 return anon_vma;
>
> As far as I can tell you would have to recheck the mapping pointer and the

That's a more interesting question than I'd realized.  When
page_lock_anon_vma() first came in (2.6.9) there was nothing which
updated page->mapping of an anon page after it was set, until the page
was freed.

Since then we've gathered a few places which update it while holding
the page lock (migrate.c, ksm.c) - no problem since the callers of
page_lock_anon_vma() hold and must hold page lock.  Well, there is the
fairly recent call to page_lock_anon_vma() from memory-failure.c, and
its even more recent use on hugepages: there's switching back and
forth between p and hpage and page, but I think it does end up
applying page_lock_anon_vma() to the very page that it locked earlier.

Then there's the recently added page_move_anon_rmap(): fine in
memory.c, the page lock is held; but apparently broken in hugetlb.c,
where it's called only when the pagelock has not been taken!
Horiguchi-san Cc'ed.

__page_set_anon_rmap() looks like it might have changed anon
page->mapping in 2.6.35, but Andrea has fixed that with PageAnon tests
in 2.6.36-rc.  Ah, but what if "exclusive" and non-exclusive calls to
__page_set_anon_rmap() are racing?  Not clear, it may be that Andrea
has only narrowed a window not closed it (and I've not yet looked up
the commit to see his intent); or it may be okay, that there cannot be
a conflict of anon_vma in that case.  Need to dig deeper.

__hugepage_set_anon_rmap() appears to copy the 2.6.35
__page_set_anon_rmap(), and probably needs to add in Andrea's fix, or
whatever else is needed there.

This is a different problem (or it may turn out to be a non-existent
problem, aside from the hugetlb.c case to be fixed there) than I was
fixing with my patch, and can be patched separately; but It certainly
looks as if it's worth adding a BUG_ON or VM_BUG_ON to check for a
switch of anon_vma beneath us there.   Plus a
VM_BUG_ON(PageLocked(page)) going into page_lock_anon_vma().

> pointer to the root too after taking the lock because only taking the lock
> stabilitzes the object.

A change in the pointer to the root is covered by the ACCESS_ONCE:
yes, it can change beneath us there, but only through the anon_vma
being freed and reused, in which case the subsequent page_mapped test
tells us the page is no longer mapped, whereupon we back out,
unlocking what we locked.  (I had at one point been tempted to check
anon_vma->root == root_anon_vma there instead of page_mapped(), but
that would not have been good enough: since anon_vma_prepare() sets
anon_vma->root before taking the lock, anon_vma->root could change
under us anywhere between the page_lock_anon_vma() and its
page_unlock_anon_vma() in that case.)

> Any other data you may have obtained before
> acquiring the lock may have changed.
>
>> >> and the way the lock is taken can be a problem in itself.
>>
>> No, that's what we rely upon SLAB_DESTROY_BY_RCU for.
>
> SLAB_DESTROY_BY_RCU does not guarantee that the object stays the same nor
> does it prevent any fields from changing. Going through a pointer with
> only SLAB_DESTROY_BY_RCU means that you can only rely on the atomicity
> guarantee for pointer updates. You get a valid pointer but pointer changes
> are not prevented by SLAB_DESTROY_BY_RCU.

You're speaking too generally there for me to understand its
relevance!  What specific problem do you see?

>
> The only guarantee of that would be through other synchronization
> techniques. If you believe that the page lock provides sufficient
> synchronization that then this approach may be ok.

The page lock should be guaranteeing that page->mapping (anon_vma)
cannot change underneath us; but there is some doubt on that above,
I'll report back when I've had enough quiet time to think through the
__set_page_anon_rmap() possibilities:
thanks for uncovering those doubts.

Hugh

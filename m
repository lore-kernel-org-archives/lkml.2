Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab0H0V2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 17:28:19 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6374 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab0H0V2Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 17:28:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=A4DRrypMrZ/mvR7oQEv6A+GQYCiaUZE+2IWdQFXOz/1DC3uII6Xs2m5/KnXzO0Y/i7
         cO5F2IfrILB7EazL5F2Q==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1008271547200.22988@router.home>
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
Date: Fri, 27 Aug 2010 14:28:04 -0700
Message-ID: <AANLkTim16oT13keYK_oz=7kmDmdG=ADfkGXMKp3_dEw_@mail.gmail.com>
Subject: Re: [PATCH] mm: fix hang on anon_vma->root->lock
From: Hugh Dickins <hughd@google.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
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

On Fri, Aug 27, 2010 at 1:56 PM, Christoph Lameter <cl@linux.com> wrote:
> On Fri, 27 Aug 2010, Hugh Dickins wrote:
>
>> Nothing ensures that the root pointer was not changed after the
>> ACCESS_ONCE, that's exactly why we use ACCESS_ONCE there: once we've
>> got the lock and realize that what we've locked may not be what we
>> wanted (or may change from what we were wanting at any moment, the
>> page no longer being mapped there - but in that case we no longer want
>> it), we have to be sure to unlock the one we locked, rather than the
>> one which anon_vma->root might subsequently point to.
>
> I do not see any check after we have taken the lock to verify that we
> locked the correct object. Was there a second version of the patch?

No second version of the patch, no.  As I said already, it's that
second page_mapped check which gives the guarantee that the anon_vma
has not yet been freed, hence we've locked the correct object.

>
>> > Since there is no lock taken before the mapped check none of the
>> > earlier reads from the anon vma structure nor the page mapped check
>> > necessarily reflect a single state of the anon_vma.
>>
>> There's no lock (other than RCU's read "lock")  taken before the
>> original mapped check, and that's important, otherwise our attempt to
>> lock might actually spinon or corrupt something that was long ago an
>> anon_vma.  But we do take the anon_vma->root->lock before the second
>> mapped check which I added.  If the page is still mapped at the point
>
> You then are using an object from the anon_vma (the pointer) without a
> lock!

Yes. (not counting RCU's read "lock" as a lock).

> This is unstable therefore unless there are other constraints. The
> anon_vma->lock must be taken before derefencing that pointer.

No, SLAB_DESTROY_BY_RCU gives us just the stablity we need to take the lock.

> The page may
> have been unmapped and mapped again between the two checks. Unlikely but
> possible.

Yes, unlikely but possible.  (Well, actually, is it possible?  It can
be unmapped on exit without any lock, but unmapping for pageout would
require the page lock, would insert a swp_entry_t, and mapping again
would go to do_swap_page which would again require the page lock.  But
never mind that, let's assume there is a way it can be unmapped and
mapped again.)  The thing is, page->mapping will point to the same
anon_vma throughout, that only gets reset when the page is freed, and
there should be nowhere else that modifies page->mapping once it's
been set to anon_vma - if you know of somewhere, please point to it,
we do need to examine that case.

>
>> of that second check, then we know that we got the right anon_vma,
>
> I do not see a second check (*after* taking the lock) in the patch






> and the
> way the lock is taken can be a problem in itself.
>
>

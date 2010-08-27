Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab0H0UOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 16:14:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:30208 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab0H0UOJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 16:14:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CQ3532Q6Qlr/e2ipRhLr85hcANySXkttAGh/FUF61mUln9SFqNOE4SGWHp7EBFTq0G
         lliJfIoM49vEviCi+r4w==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1008271420400.18495@router.home>
References: <alpine.LSU.2.00.1008252305540.19107@sister.anvils>
	<20100826235052.GZ6803@random.random>
	<AANLkTimgKcP78CNakDf34NrVrd5apfXrtptNw+G6G5DK@mail.gmail.com>
	<20100827095546.GC6803@random.random>
	<AANLkTikvB1fN42A91ZdEHyEXnz2bGw9Q21dJcfa3PBP0@mail.gmail.com>
	<alpine.DEB.2.00.1008271159160.18495@router.home>
	<AANLkTi=FeHnLu4_6M5N6yUL==4YyxVXXxsccsE2kNUbm@mail.gmail.com>
	<alpine.DEB.2.00.1008271420400.18495@router.home>
Date: Fri, 27 Aug 2010 13:14:05 -0700
Message-ID: <AANLkTinLpDnpwr40dtU5UFq53avODSKxTA4=xnZwmJFX@mail.gmail.com>
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

On Fri, Aug 27, 2010 at 12:29 PM, Christoph Lameter <cl@linux.com> wrote:
> On Fri, 27 Aug 2010, Hugh Dickins wrote:
>
>> Eh?  My solution was a second page_mapped(page) test i.e. testing an atomic.
>
> Argh. Right. Looked like a global to me. Did not see the earlier local
> def.
>
> If you still use a pointer then what does insure that the root
> pointer was not changed after the ACCESS_ONCE? The free semantics
> of an anon_vma?

Nothing ensures that the root pointer was not changed after the
ACCESS_ONCE, that's exactly why we use ACCESS_ONCE there: once we've
got the lock and realize that what we've locked may not be what we
wanted (or may change from what we were wanting at any moment, the
page no longer being mapped there - but in that case we no longer want
it), we have to be sure to unlock the one we locked, rather than the
one which anon_vma->root might subsequently point to.

(Umm, maybe I'm not the clearest of explainers, sorry!  If you get my
point, fine; if it's gibberish to you, please ask me to try again.)

>
> Since there is no lock taken before the mapped check none of the
> earlier reads from the anon vma structure nor the page mapped check
> necessarily reflect a single state of the anon_vma.

There's no lock (other than RCU's read "lock")  taken before the
original mapped check, and that's important, otherwise our attempt to
lock might actually spinon or corrupt something that was long ago an
anon_vma.  But we do take the anon_vma->root->lock before the second
mapped check which I added.  If the page is still mapped at the point
of that second check, then we know that we got the right anon_vma,
that the page might be mapped in it, and anon_vma->root is not going
to change underneath us before the page_unlock_anon_vma().  (The page
may get unmapped at any time, the lock does not protect against that;
but if it's still mapped once we hold the lock, free_pgtables() cannot
free the anon_vma until we're done.)

Hugh

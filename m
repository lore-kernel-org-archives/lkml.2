Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab0H1CrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 22:47:23 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:45250 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752378Ab0H1CrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 22:47:22 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: E7SH31IVM1mePbiBa.6soPIC8_RBKPoLDAe8O_qOCCbDE0f
 aifLwL5Q4w.wrAad2bb.yPoUFHozdXm.QPmpYu820NE1JvCJ6RF9ZWQOrTP5
 y7a7pkvvVGpyVwhwvAhphZn5sS224IBeyjlgC5rwCdTMaxM0JeToGXiQk47J
 L.22vJDbJK0BtzGL15JqTmPMkNGQptcJ6WNatM29lqKvGS7PH9CKou1l89mi
 TfOzAjj7l0FMVO9I3akpkOyOo_.tK
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 27 Aug 2010 21:47:16 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Hugh Dickins <hughd@google.com>
cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: fix hang on anon_vma->root->lock
In-Reply-To: <AANLkTindjNiJXbfsWbFexXBQVB174aprhSbBLFosBvC=@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1008272136220.28501@router.home>
References: <alpine.LSU.2.00.1008252305540.19107@sister.anvils> <20100826235052.GZ6803@random.random> <AANLkTimgKcP78CNakDf34NrVrd5apfXrtptNw+G6G5DK@mail.gmail.com> <20100827095546.GC6803@random.random> <AANLkTikvB1fN42A91ZdEHyEXnz2bGw9Q21dJcfa3PBP0@mail.gmail.com>
 <alpine.DEB.2.00.1008271159160.18495@router.home> <AANLkTi=FeHnLu4_6M5N6yUL==4YyxVXXxsccsE2kNUbm@mail.gmail.com> <alpine.DEB.2.00.1008271420400.18495@router.home> <AANLkTinLpDnpwr40dtU5UFq53avODSKxTA4=xnZwmJFX@mail.gmail.com> <alpine.DEB.2.00.1008271547200.22988@router.home>
 <AANLkTim16oT13keYK_oz=7kmDmdG=ADfkGXMKp3_dEw_@mail.gmail.com> <AANLkTikML=HghpOVK0WZ0t6CRaNOKvu=57ebojZ+YCNS@mail.gmail.com> <alpine.DEB.2.00.1008271801080.25115@router.home> <AANLkTindjNiJXbfsWbFexXBQVB174aprhSbBLFosBvC=@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Aug 2010, Hugh Dickins wrote:

> >> No, that's what we rely upon SLAB_DESTROY_BY_RCU for.
> >
> > SLAB_DESTROY_BY_RCU does not guarantee that the object stays the same nor
> > does it prevent any fields from changing. Going through a pointer with
> > only SLAB_DESTROY_BY_RCU means that you can only rely on the atomicity
> > guarantee for pointer updates. You get a valid pointer but pointer changes
> > are not prevented by SLAB_DESTROY_BY_RCU.
>
> You're speaking too generally there for me to understand its
> relevance!  What specific problem do you see?

I had the impression that you rely on SLAB_DESTROY_BY_RCU for more than
what it gives you. If the lock taken is not directly in the structure that
is managed by slab but only reachable by a pointer then potential pointer
changes are also danger to consider.

I'd be much more comfortable if the following would be done

A. Pin the anon_vma by either
	I. Take a refcount on the anon vma
	II. Take a lock in the anon vma (something that is not pointed to)

B. Either
	I. All values that have been used before the pinning are
	   verified after the pinning (and the lock is reacquired
           if verification fails).

	II. Or all functions using page_lock_anon_vma() must securely
	    work in the case that the anon_vma was reused for
	    something else before the vma lock was acquired.


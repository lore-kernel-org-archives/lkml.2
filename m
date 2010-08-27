Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab0H0U44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 16:56:56 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:44776 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751694Ab0H0U4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 16:56:54 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: u3IDlH8VM1koOfGzNom8PLyIeK_K5Tx2Z8q0.oeulGldvPH
 w8VmHq5aLk10V02k_jqoQcJhmodkDx5P9cdTBFO3UHubFn4C0z645gzuAaJJ
 6FwXU0bdukM.YIg9ptNxJ5HFBl.4v76zLdcXX8.ppoUgtoaDOwFA1Kv3qhpo
 o771ddv0HTwh139kODE9LKL56XTMvrMExGH1_conla9jZkaLFE7gKFZ1_Dnm
 _
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 27 Aug 2010 15:56:48 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Hugh Dickins <hughd@google.com>
cc: Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: fix hang on anon_vma->root->lock
In-Reply-To: <AANLkTinLpDnpwr40dtU5UFq53avODSKxTA4=xnZwmJFX@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1008271547200.22988@router.home>
References: <alpine.LSU.2.00.1008252305540.19107@sister.anvils> <20100826235052.GZ6803@random.random> <AANLkTimgKcP78CNakDf34NrVrd5apfXrtptNw+G6G5DK@mail.gmail.com> <20100827095546.GC6803@random.random> <AANLkTikvB1fN42A91ZdEHyEXnz2bGw9Q21dJcfa3PBP0@mail.gmail.com>
 <alpine.DEB.2.00.1008271159160.18495@router.home> <AANLkTi=FeHnLu4_6M5N6yUL==4YyxVXXxsccsE2kNUbm@mail.gmail.com> <alpine.DEB.2.00.1008271420400.18495@router.home> <AANLkTinLpDnpwr40dtU5UFq53avODSKxTA4=xnZwmJFX@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Aug 2010, Hugh Dickins wrote:

> Nothing ensures that the root pointer was not changed after the
> ACCESS_ONCE, that's exactly why we use ACCESS_ONCE there: once we've
> got the lock and realize that what we've locked may not be what we
> wanted (or may change from what we were wanting at any moment, the
> page no longer being mapped there - but in that case we no longer want
> it), we have to be sure to unlock the one we locked, rather than the
> one which anon_vma->root might subsequently point to.

I do not see any check after we have taken the lock to verify that we
locked the correct object. Was there a second version of the patch?

> > Since there is no lock taken before the mapped check none of the
> > earlier reads from the anon vma structure nor the page mapped check
> > necessarily reflect a single state of the anon_vma.
>
> There's no lock (other than RCU's read "lock")  taken before the
> original mapped check, and that's important, otherwise our attempt to
> lock might actually spinon or corrupt something that was long ago an
> anon_vma.  But we do take the anon_vma->root->lock before the second
> mapped check which I added.  If the page is still mapped at the point

You then are using an object from the anon_vma (the pointer) without a
lock! This is unstable therefore unless there are other constraints. The
anon_vma->lock must be taken before derefencing that pointer. The page may
have been unmapped and mapped again between the two checks. Unlikely but
possible.

> of that second check, then we know that we got the right anon_vma,

I do not see a second check (*after* taking the lock) in the patch and the
way the lock is taken can be a problem in itself.


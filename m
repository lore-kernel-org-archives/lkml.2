Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab0H0XGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 19:06:12 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:39318 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751819Ab0H0XGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 19:06:11 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: mKXUFPkVM1mSwv_l7Ul3fLSkc8OUcDbznIee6c_MjpCG7g5
 _8GsyhgJjGBGQMZWTMfz6ycnq04Xd2jRQaqpcZVvnhP5xh37g9H4K4nG68Tv
 iCpPXixoJact8UJLwmT61EDtpJEki30xAZcXJk9NLZkc4vzDtQdJza3C8UDv
 l9kqpb6ieJLkZGJEsyYUMOyhLR7mM9X8TqSJHgqJhNABiDFL2vNH.c9MezCk
 SsHfKUIcj8P4jOgeGfk.HbAW4j2R_
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 27 Aug 2010 18:06:07 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Hugh Dickins <hughd@google.com>
cc: Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: fix hang on anon_vma->root->lock
In-Reply-To: <AANLkTikML=HghpOVK0WZ0t6CRaNOKvu=57ebojZ+YCNS@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1008271801080.25115@router.home>
References: <alpine.LSU.2.00.1008252305540.19107@sister.anvils> <20100826235052.GZ6803@random.random> <AANLkTimgKcP78CNakDf34NrVrd5apfXrtptNw+G6G5DK@mail.gmail.com> <20100827095546.GC6803@random.random> <AANLkTikvB1fN42A91ZdEHyEXnz2bGw9Q21dJcfa3PBP0@mail.gmail.com>
 <alpine.DEB.2.00.1008271159160.18495@router.home> <AANLkTi=FeHnLu4_6M5N6yUL==4YyxVXXxsccsE2kNUbm@mail.gmail.com> <alpine.DEB.2.00.1008271420400.18495@router.home> <AANLkTinLpDnpwr40dtU5UFq53avODSKxTA4=xnZwmJFX@mail.gmail.com> <alpine.DEB.2.00.1008271547200.22988@router.home>
 <AANLkTim16oT13keYK_oz=7kmDmdG=ADfkGXMKp3_dEw_@mail.gmail.com> <AANLkTikML=HghpOVK0WZ0t6CRaNOKvu=57ebojZ+YCNS@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Aug 2010, Hugh Dickins wrote:

> >> I do not see a second check (*after* taking the lock) in the patch
>
>         if (page_mapped(page))
>                 return anon_vma;

As far as I can tell you would have to recheck the mapping pointer and the
pointer to the root too after taking the lock because only taking the lock
stabilitzes the object. Any other data you may have obtained before
acquiring the lock may have changed.

> >> and the way the lock is taken can be a problem in itself.
>
> No, that's what we rely upon SLAB_DESTROY_BY_RCU for.

SLAB_DESTROY_BY_RCU does not guarantee that the object stays the same nor
does it prevent any fields from changing. Going through a pointer with
only SLAB_DESTROY_BY_RCU means that you can only rely on the atomicity
guarantee for pointer updates. You get a valid pointer but pointer changes
are not prevented by SLAB_DESTROY_BY_RCU.

The only guarantee of that would be through other synchronization
techniques. If you believe that the page lock provides sufficient
synchronization that then this approach may be ok.

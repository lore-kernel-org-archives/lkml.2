Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab2BPJD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 04:03:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154Ab2BPJDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 04:03:21 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] introduce pmd_to_pte_t()
Date: Thu, 16 Feb 2012 04:02:42 -0500
Message-Id: <1329382962-27039-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20120215165408.a111eefa.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 04:54:08PM -0800, Andrew Morton wrote:
> On Wed,  8 Feb 2012 10:51:41 -0500
> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
> 
> > Casting pmd into pte_t to handle thp is strongly architecture dependent.
> > This patch introduces a new function to separate this dependency from
> > independent part.
> > 
> >
> > ...
> >
> > --- 3.3-rc2.orig/include/asm-generic/pgtable.h
> > +++ 3.3-rc2/include/asm-generic/pgtable.h
> > @@ -434,6 +434,10 @@ static inline int pmd_trans_splitting(pmd_t pmd)
> >  {
> >  	return 0;
> >  }
> > +static inline pte_t pmd_to_pte_t(pmd_t *pmd)
> > +{
> > +	return 0;
> > +}
> 
> This doesn't compile.

Sorry for my failing to make sure of compile testing.
The return value should be cast to pte_t to pass the complie.

> And I can't think of a sensible way of generating a stub for this
> operation - if you have a pmd_t and want to convert it to a pte_t then
> just convert it, dammit.  And there's no rationality behind making that
> conversion unavailable or inoperative if CONFIG_TRANSPARENT_HUGEPAGE=n?
> 
> Shudder.  I'll drop the patch.  Rethink, please.

OK for dropping it.
This patch is not enough to solve the problem of isolating arch dependency.

Although it's not clear from the name, the intension of this function was
to get the lowest level of entry in page table hierarchy which points to
a hugepage.  It is pmd for x86_64, but pte for powerpc64 for example.
So I thought it's useful to introduce a stub like above.
But the callers of this function assume that pmd points to hugepage,
so arch dependency in arch independent code still remains.
We need to work on it when thp supports other archs,
but anyway, removing this patch is not critical for others of this series,
so I'm ok about it.

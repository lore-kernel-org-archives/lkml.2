Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1K2BDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 20:03:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203Ab1K2BDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 20:03:22 -0500
Date: Tue, 29 Nov 2011 01:58:39 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        wli@holomorphy.com, david.woodhouse@intel.com, allen.m.kay@intel.com,
        mtosatti@redhat.com, chrisw@redhat.com, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH 1/2] thp: Add compound tail page _mapcount when mapped
Message-ID: <20111129005839.GE23466@redhat.com>
References: <1322200030-26350-1-git-send-email-youquan.song@intel.com>
 <20111128161626.e4be400a.akpm@linux-foundation.org>
 <20111129001927.GO24062@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129001927.GO24062@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 01:19:27AM +0100, Andi Kleen wrote:
> > > +++ b/arch/x86/mm/gup.c
> > > @@ -201,6 +201,8 @@ static noinline int gup_huge_pud(pud_t pud, unsigned long addr,
> > >  	do {
> > >  		VM_BUG_ON(compound_head(page) != head);
> > >  		pages[*nr] = page;
> > > +		if (PageTail(page))
> > > +			get_huge_page_tail(page);
> > >  		(*nr)++;
> > >  		page++;
> > >  		refs++;
> > 
> > Is the patch also applicable to 3.1.x?
> 
> I suspect it's broken since many kernels back, at least since THP 
> was introduced, maybe earlier.

Correct. And the other patch in this series if applied without the
above too, would make things worse for earlier releases (it'd trigger
the lack of above at first invocation instead of from the second by
having the _count start at 0 instead of 1, so it'd go negative at the
first put_page). The correct thing is to have _count start at 0, but
to increase it with the above during gup_fast (or to increase
_mapcount since 3.2-rc and leave _count at 0 at all times on tail
pages). Both patches should be ok for earlier releases too but I think
it's just a false positive that goes away with DEBUG_VM=n or we should
have noticed sooner (all production systems runs with DEBUG_VM=n of
course). If there is no problem with DEBUG_VM=n like it seems from the
source, I doubt it needs backporting. Also worst case a VM_BUG_ON
hits, there's no risk of memory corruption because the refcounting on
the head pages has always been correct, and that's all it matters
as far as hugetlbfs is concerned.

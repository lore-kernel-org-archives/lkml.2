Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab2JCVro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 17:47:44 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64108 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab2JCVrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 17:47:42 -0400
Date: Wed, 3 Oct 2012 14:46:59 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michel Lespinasse <walken@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch -mm] mm, thp: fix mlock statistics fix
In-Reply-To: <20121003142519.93375e01.akpm@linux-foundation.org>
Message-ID: <alpine.LSU.2.00.1210031430190.14479@eggly.anvils>
References: <alpine.DEB.2.00.1209191818490.7879@chino.kir.corp.google.com> <alpine.LSU.2.00.1209192021270.28543@eggly.anvils> <alpine.DEB.2.00.1209261821380.7745@chino.kir.corp.google.com> <alpine.DEB.2.00.1209261929270.8567@chino.kir.corp.google.com>
 <alpine.LSU.2.00.1209271814340.2107@eggly.anvils> <20121003131012.f88b0d66.akpm@linux-foundation.org> <alpine.DEB.2.00.1210031403270.4352@chino.kir.corp.google.com> <20121003142519.93375e01.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2012, Andrew Morton wrote:
> On Wed, 3 Oct 2012 14:10:41 -0700 (PDT)
> David Rientjes <rientjes@google.com> wrote:
> 
> > > The free_page_mlock() hunk gets dropped because free_page_mlock() is
> > > removed.  And clear_page_mlock() doesn't need this treatment.  But
> > > please check my handiwork.
> > > 
> > 
> > I reviewed what was merged into -mm and clear_page_mlock() does need this 
> > fix as well.
> 
> argh, it got me *again*.  grr.

I've no objection to more documentation on PageHuge, but neither you nor
it were to blame for that "oversight".  It's simply that David's original
patch clearly did not need such a change in clear_page_mlock(), because
it could never be necessary from where it was then called; but I changed
where it's called, whereupon it becomes evident that the extra is needed.

"evident" puts it rather too strongly.  Most munlocking happens through
munlock_vma_page() instead, but the clear_page_mlock() path covers
truncation.  THPages cannot be file pages at present, but perhaps they
could be anonymous pages COWed from file pages (I've not checked the
exact criteria THP applies)?  In which case, subject to truncation too.

Hugh

> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm: document PageHuge somewhat
> 
> Cc: David Rientjes <rientjes@google.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/hugetlb.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff -puN mm/hugetlb.c~mm-document-pagehuge-somewhat mm/hugetlb.c
> --- a/mm/hugetlb.c~mm-document-pagehuge-somewhat
> +++ a/mm/hugetlb.c
> @@ -671,6 +671,11 @@ static void prep_compound_gigantic_page(
>  	}
>  }
>  
> +/*
> + * PageHuge() only returns true for hugetlbfs pages, but not for normal or
> + * transparent huge pages.  See the PageTransHuge() documentation for more
> + * details.
> + */
>  int PageHuge(struct page *page)
>  {
>  	compound_page_dtor *dtor;
> _

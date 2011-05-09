Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab1EITj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 15:39:29 -0400
Received: from mout.perfora.net ([74.208.4.195]:60043 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234Ab1EITj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 15:39:28 -0400
Date: Mon, 9 May 2011 15:39:16 -0400
From: Stephen Wilson <wilsons@start.ca>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Stephen Wilson <wilsons@start.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] mm: remove MPOL_MF_STATS
Message-ID: <20110509193916.GB2865@wicker.gateway.2wire.net>
References: <1303947349-3620-1-git-send-email-wilsons@start.ca>
 <1303947349-3620-4-git-send-email-wilsons@start.ca>
 <20110509164609.1657.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110509164609.1657.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:JUyd7xXCvqB4D9VtT07S3ZXssjDqWqMgi5S3kUxDSHC
 5s7rlOLIyKkATc8MiBf6F4IKEkB9IJhO+7w18PJV8s+VeV6dpb
 4hN4fFS6JA6KZOqQG6K+qSd7huPFnv6lJO0ykdzTxYzpNT6KQc
 Bx4pbGfhK5qaSCrvPYeq9fbWIsdU9W1qDVov50UKNnb8/bLa/b
 Sn17Zk7cdwwJsW72rGB8eDW8h8nm684IiCaTB4x9xg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 04:44:24PM +0900, KOSAKI Motohiro wrote:
> > Mapping statistics in a NUMA environment is now computed using the
> > generic walk_page_range() logic.  Remove the old/equivalent
> > functionality.
> > 
> > Signed-off-by: Stephen Wilson <wilsons@start.ca>
> > ---
> >  mm/mempolicy.c |   10 ++++++----
> >  1 files changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index dfe27e3..63c0d69 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -99,7 +99,6 @@
> >  /* Internal flags */
> >  #define MPOL_MF_DISCONTIG_OK (MPOL_MF_INTERNAL << 0)	/* Skip checks for continuous vmas */
> >  #define MPOL_MF_INVERT (MPOL_MF_INTERNAL << 1)		/* Invert check for nodemask */
> > -#define MPOL_MF_STATS (MPOL_MF_INTERNAL << 2)		/* Gather statistics */
> >  
> >  static struct kmem_cache *policy_cache;
> >  static struct kmem_cache *sn_cache;
> > @@ -492,9 +491,7 @@ static int check_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
> >  		if (node_isset(nid, *nodes) == !!(flags & MPOL_MF_INVERT))
> >  			continue;
> >  
> > -		if (flags & MPOL_MF_STATS)
> > -			gather_stats(page, private, pte_dirty(*pte));
> > -		else if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
> > +		if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
> >  			migrate_page_add(page, private, flags);
> >  		else
> >  			break;
> 
> This hunk looks good to me.
> 
> 
> > @@ -2572,6 +2569,7 @@ static int gather_pte_stats(pte_t *pte, unsigned long addr,
> >  		unsigned long pte_size, struct mm_walk *walk)
> >  {
> >  	struct page *page;
> > +	int nid;
> >  
> >  	if (pte_none(*pte))
> >  		return 0;
> > @@ -2580,6 +2578,10 @@ static int gather_pte_stats(pte_t *pte, unsigned long addr,
> >  	if (!page)
> >  		return 0;
> >  
> > +	nid = page_to_nid(page);
> > +	if (!node_isset(nid, node_states[N_HIGH_MEMORY]))
> > +		return 0;
> > +
> >  	gather_stats(page, walk->private, pte_dirty(*pte));
> >  	return 0;
> 
> However this hunk should be moved into patch [2/8]. because 1) keeping
> bisectability 2) The description says "Remove the old/equivalent
> functionality." but it added new functionality.

Absolutely.  Will move into the proper location and resend the whole
series.

Thanks again,

-- 
steve


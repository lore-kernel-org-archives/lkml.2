Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab2CHPjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 10:39:05 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:47679 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597Ab2CHPjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 10:39:02 -0500
Date: Fri, 9 Mar 2012 01:18:16 +1100
From: David Gibson <dwg@au1.ibm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, hughd@google.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, Andrew Barry <abarry@cray.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH 2/2] hugepages: Fix use after free bug in "quota" handling
Message-ID: <20120308141816.GI10735@truffala.fritz.box>
Mail-Followup-To: David Gibson <dwg@au1.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	akpm@linux-foundation.org, hughd@google.com, paulus@samba.org,
	linux-kernel@vger.kernel.org, Andrew Barry <abarry@cray.com>,
	Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
	Hillf Danton <dhillf@gmail.com>
References: <1331095694-27780-1-git-send-email-david@gibson.dropbear.id.au>
 <1331095694-27780-2-git-send-email-david@gibson.dropbear.id.au>
 <878vjbaf3y.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878vjbaf3y.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12030805-1396-0000-0000-000000C9C0B4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 10:00:57AM +0530, Aneesh Kumar K.V wrote:
> On Wed,  7 Mar 2012 15:48:14 +1100, David Gibson <david@gibson.dropbear.id.au> wrote:
[snip]
> >  out_free:
> > +	if (sbinfo->spool)
> > +		kfree(sbinfo->spool);
> 
> kfree() should handle NULL 

I've already changed that at akpm's suggestion.

> > @@ -53,6 +53,84 @@ static unsigned long __initdata default_hstate_size;
> >   */
> >  static DEFINE_SPINLOCK(hugetlb_lock);
> > 
> > +static inline void unlock_or_release_subpool(struct hugepage_subpool *spool)
> > +{
> > +	bool free = (spool->count == 0) && (spool->used_hpages == 0);
> > +
> 
> I have not see that style in other part of kernel. May be with proper
> 
> if (spool->count == 0 && spool->used_hpages == 0)
>    free = 1
> 
> > +	spin_unlock(&spool->lock);
> > +
> 
> 
> Having the spin_lock held across functions is also strange. Since there
> are only two callers, may be this can be inlined in the callers ?

It's a bit unusual, yes, but it seems to me clearer to outline this
operation in a function.

> > +static inline struct hugepage_subpool *subpool_inode(struct inode
> > *inode)
> 
> s/subpool_inode/subpool_from_inode/ ?
> 
> > +{
> > +	return HUGETLBFS_SB(inode->i_sb)->spool;
> > +}
> > +
> > +static inline struct hugepage_subpool *subpool_vma(struct
> > vm_area_struct *vma)
> 
> s/subpool_vma/subpool_from_vma/ ?

These functions are named to match hstate_inode() and hstate_vma().

> > +{
> > +	return subpool_inode(vma->vm_file->f_dentry->d_inode);
> > +}
> > +
> >  /*
> >   * Region tracking -- allows tracking of reservations and instantiated pages
> >   *                    across the pages in a mapping.
> > @@ -533,9 +611,9 @@ static void free_huge_page(struct page *page)
> >  	 */
> >  	struct hstate *h = page_hstate(page);
> >  	int nid = page_to_nid(page);
> > -	struct address_space *mapping;
> > +	struct hugepage_subpool *spool =
> > +		(struct hugepage_subpool *)page_private(page);
> > 
> > -	mapping = (struct address_space *) page_private(page);
> >  	set_page_private(page, 0);
> >  	page->mapping = NULL;
> >  	BUG_ON(page_count(page));
> > @@ -551,8 +629,7 @@ static void free_huge_page(struct page *page)
> >  		enqueue_huge_page(h, page);
> >  	}
> >  	spin_unlock(&hugetlb_lock);
> > -	if (mapping)
> > -		hugetlb_put_quota(mapping, 1);
> > +	hugepage_subpool_put_pages(spool, 1);
> 
> 
> We would still need the if () checking there. When we do echo x >
> /proc/sys/vm/nr_hugepages we would call free_huge_page to prepare new
> huge page pool. But we don't have page_private set for them.

No, this is correct.  hugepage_subpool_put_pages() is built to be a
nop if spool == NULL.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson


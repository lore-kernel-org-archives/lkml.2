Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab2E0UOE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 16:14:04 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:33104 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab2E0UN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 16:13:59 -0400
Date: Mon, 28 May 2012 01:43:41 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V6 06/14] hugetlb: Simplify migrate_huge_page
Message-ID: <20120527201341.GB7631@skywalker.linux.vnet.ibm.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1334573091-18602-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1205241432290.24113@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205241432290.24113@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12052710-0260-0000-0000-0000013BBA51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 02:35:05PM -0700, David Rientjes wrote:
> On Mon, 16 Apr 2012, Aneesh Kumar K.V wrote:
> 
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index 97cc273..1f092db 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -1414,7 +1414,6 @@ static int soft_offline_huge_page(struct page *page, int flags)
> >  	int ret;
> >  	unsigned long pfn = page_to_pfn(page);
> >  	struct page *hpage = compound_head(page);
> > -	LIST_HEAD(pagelist);
> >  
> >  	ret = get_any_page(page, pfn, flags);
> >  	if (ret < 0)
> > @@ -1429,19 +1428,11 @@ static int soft_offline_huge_page(struct page *page, int flags)
> >  	}
> >  
> >  	/* Keep page count to indicate a given hugepage is isolated. */
> > -
> > -	list_add(&hpage->lru, &pagelist);
> > -	ret = migrate_huge_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL, 0,
> > -				true);
> > +	ret = migrate_huge_page(page, new_page, MPOL_MF_MOVE_ALL, 0, true);
> 
> Was this tested?  Shouldn't this be migrate_huge_page(compound_head(page), 
> ...)?
> 

I tested this using madvise, but by not using tail pages. How about the below diff ?

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 4a45098..53a1495 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1428,8 +1428,8 @@ static int soft_offline_huge_page(struct page *page, int flags)
 	}
 
 	/* Keep page count to indicate a given hugepage is isolated. */
-	ret = migrate_huge_page(page, new_page, MPOL_MF_MOVE_ALL, 0, true);
-	put_page(page);
+	ret = migrate_huge_page(hpage, new_page, MPOL_MF_MOVE_ALL, 0, true);
+	put_page(hpage);
 	if (ret) {
 		pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
 			pfn, ret, page->flags);


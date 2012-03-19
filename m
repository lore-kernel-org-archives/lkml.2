Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab2CSHBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 03:01:49 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:41094 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444Ab2CSHBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 03:01:47 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, dhillf@gmail.com, aarcange@redhat.com,
        mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V4 05/10] hugetlb: add charge/uncharge calls for HugeTLB alloc/free
In-Reply-To: <4F669CC3.9070007@jp.fujitsu.com>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331919570-2264-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4F669CC3.9070007@jp.fujitsu.com>
User-Agent: Notmuch/0.11.1+190~g31a336a (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 19 Mar 2012 12:31:36 +0530
Message-ID: <871uopkran.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12031821-3568-0000-0000-00000161B7CD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2012 11:41:07 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> (2012/03/17 2:39), Aneesh Kumar K.V wrote:
> 
> > From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> > 
> > This adds necessary charge/uncharge calls in the HugeTLB code
> > 
> > Acked-by: Hillf Danton <dhillf@gmail.com>
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> 
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> A nitpick below.
> 
> > ---
> >  mm/hugetlb.c    |   21 ++++++++++++++++++++-
> >  mm/memcontrol.c |    5 +++++
> >  2 files changed, 25 insertions(+), 1 deletions(-)
> > 
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index c672187..91361a0 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -21,6 +21,8 @@
> >  #include <linux/rmap.h>
> >  #include <linux/swap.h>
> >  #include <linux/swapops.h>
> > +#include <linux/memcontrol.h>
> > +#include <linux/page_cgroup.h>
> >  
> >  #include <asm/page.h>
> >  #include <asm/pgtable.h>
> > @@ -542,6 +544,9 @@ static void free_huge_page(struct page *page)
> >  	BUG_ON(page_mapcount(page));
> >  	INIT_LIST_HEAD(&page->lru);
> >  
> > +	if (mapping)
> > +		mem_cgroup_hugetlb_uncharge_page(hstate_index(h),
> > +						 pages_per_huge_page(h), page);
> >  	spin_lock(&hugetlb_lock);
> >  	if (h->surplus_huge_pages_node[nid] && huge_page_order(h) < MAX_ORDER) {
> >  		update_and_free_page(h, page);
> > @@ -1019,12 +1024,15 @@ static void vma_commit_reservation(struct hstate *h,
> >  static struct page *alloc_huge_page(struct vm_area_struct *vma,
> >  				    unsigned long addr, int avoid_reserve)
> >  {
> > +	int ret, idx;
> >  	struct hstate *h = hstate_vma(vma);
> >  	struct page *page;
> > +	struct mem_cgroup *memcg = NULL;
> 
> 
> Can't we this initialization in mem_cgroup_hugetlb_charge_page() ?
> 

Will update in the next iteration.

-aneesh


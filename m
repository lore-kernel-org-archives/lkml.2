Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760726Ab2CNKYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 06:24:05 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:48030 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760574Ab2CNKYB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 06:24:01 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        aarcange@redhat.com, mhocko@suse.cz, akpm@linux-foundation.org,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH -V3 3/8] hugetlb: add charge/uncharge calls for HugeTLB alloc/free
In-Reply-To: <CAJd=RBAHYi-BOXBO+u0u9-C=35Lu=ow=L77w2WSsndUBxVKf9w@mail.gmail.com>
References: <1331622432-24683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331622432-24683-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <CAJd=RBAHYi-BOXBO+u0u9-C=35Lu=ow=L77w2WSsndUBxVKf9w@mail.gmail.com>
User-Agent: Notmuch/0.11.1+190~g31a336a (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 14 Mar 2012 15:52:28 +0530
Message-ID: <87wr6n8ot7.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
x-cbid: 12031410-5564-0000-0000-000001CC03F2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012 21:20:21 +0800, Hillf Danton <dhillf@gmail.com> wrote:
> On Tue, Mar 13, 2012 at 3:07 PM, Aneesh Kumar K.V
> <aneesh.kumar@linux.vnet.ibm.com> wrote:
> > From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> >
> > This adds necessary charge/uncharge calls in the HugeTLB code
> >
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > ---
> >  mm/hugetlb.c    |   21 ++++++++++++++++++++-
> >  mm/memcontrol.c |    5 +++++
> >  2 files changed, 25 insertions(+), 1 deletions(-)
> >
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index fe7aefd..b7152d1 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -21,6 +21,8 @@
> >  #include <linux/rmap.h>
> >  #include <linux/swap.h>
> >  #include <linux/swapops.h>
> > +#include <linux/memcontrol.h>
> > +#include <linux/page_cgroup.h>
> >
> >  #include <asm/page.h>
> >  #include <asm/pgtable.h>
> > @@ -542,6 +544,9 @@ static void free_huge_page(struct page *page)
> >        BUG_ON(page_mapcount(page));
> >        INIT_LIST_HEAD(&page->lru);
> >
> > +       if (mapping)
> > +               mem_cgroup_hugetlb_uncharge_page(h - hstates,
> > +                                                pages_per_huge_page(h), page);
> >        spin_lock(&hugetlb_lock);
> >        if (h->surplus_huge_pages_node[nid] && huge_page_order(h) < MAX_ORDER) {
> >                update_and_free_page(h, page);
> > @@ -1019,12 +1024,15 @@ static void vma_commit_reservation(struct hstate *h,
> >  static struct page *alloc_huge_page(struct vm_area_struct *vma,
> >                                    unsigned long addr, int avoid_reserve)
> >  {
> > +       int ret, idx;
> >        struct hstate *h = hstate_vma(vma);
> >        struct page *page;
> > +       struct mem_cgroup *memcg = NULL;
> >        struct address_space *mapping = vma->vm_file->f_mapping;
> >        struct inode *inode = mapping->host;
> >        long chg;
> >
> > +       idx = h - hstates;
> 
> Better if hstate index is computed with a tiny inline helper?
> Other than that,

Will update in the next iteration.

> 
> Acked-by: Hillf Danton <dhillf@gmail.com>
> 

-aneesh


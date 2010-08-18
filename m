Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751069Ab0HRDHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 23:07:25 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:42391 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab0HRDHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 23:07:21 -0400
Date: Wed, 18 Aug 2010 12:02:00 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9] hugetlb: add allocate function for hugepage migration
Message-ID: <20100818030200.GA19799@spritzera.linux.bs1.fc.nec.co.jp>
References: <1281432464-14833-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1281432464-14833-3-git-send-email-n-horiguchi@ah.jp.nec.com>
 <alpine.DEB.2.00.1008162347400.31544@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008162347400.31544@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Aug 16, 2010 at 11:51:30PM -0700, David Rientjes wrote:
> On Tue, 10 Aug 2010, Naoya Horiguchi wrote:
...
> > +/*
> > + * This allocation function is useful in the context where vma is irrelevant.
> > + * E.g. soft-offlining uses this function because it only cares physical
> > + * address of error page.
> > + */
> > +struct page *alloc_huge_page_no_vma_node(struct hstate *h, int nid)
> > +{
> > +	struct page *page;
> > +
> > +	spin_lock(&hugetlb_lock);
> > +	get_mems_allowed();
> 
> Why is this calling get_mems_allowed()?  dequeue_huge_page_node() isn't 
> concerned if nid can be allocated by current in this context.

OK, I'll remove this.

> > +	page = dequeue_huge_page_node(h, nid);
> > +	put_mems_allowed();
> > +	spin_unlock(&hugetlb_lock);
> > +
> > +	if (!page) {
> > +		page = alloc_buddy_huge_page_node(h, nid);
> > +		if (!page) {
> > +			__count_vm_event(HTLB_BUDDY_PGALLOC_FAIL);
> >  			return NULL;
> > -		}
> > -		prep_new_huge_page(h, page, nid);
> > +		} else
> > +			__count_vm_event(HTLB_BUDDY_PGALLOC);
> >  	}
> >  
> > +	set_page_refcounted(page);
> 
> Possibility of NULL pointer dereference?

I think this allocate function returns without calling
set_page_refcounted() if page == NULL.  Or do you mean another point?

Thanks,
Naoya Horiguchi

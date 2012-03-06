Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab2CFDGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 22:06:22 -0500
Received: from ozlabs.org ([203.10.76.45]:42044 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab2CFDGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 22:06:20 -0500
Date: Tue, 6 Mar 2012 13:37:00 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Hillf Danton <dhillf@gmail.com>
Cc: akpm@linux-foundation.org, abarry@cray.com, hughd@google.com,
        mgorman@suse.de, minchan.kim@gmail.com, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] hugepages: Fix use after free bug in "quota" handling
Message-ID: <20120306023700.GE12818@truffala.fritz.box>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	Hillf Danton <dhillf@gmail.com>, akpm@linux-foundation.org,
	abarry@cray.com, hughd@google.com, mgorman@suse.de,
	minchan.kim@gmail.com, paulus@samba.org,
	linux-kernel@vger.kernel.org
References: <1329366240-11663-1-git-send-email-david@gibson.dropbear.id.au>
 <1329366240-11663-3-git-send-email-david@gibson.dropbear.id.au>
 <CAJd=RBAK-iTs6HfNm+Lv_5GKPbQfpALgYCgB+mitXUPofJ1gtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJd=RBAK-iTs6HfNm+Lv_5GKPbQfpALgYCgB+mitXUPofJ1gtA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 08:33:51PM +0800, Hillf Danton wrote:
> On Thu, Feb 16, 2012 at 12:24 PM, David Gibson
> <david@gibson.dropbear.id.au> wrote:
> > @@ -1046,12 +1124,12 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
> >        if (!page) {
> >                page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
> >                if (!page) {
> > -                       hugetlb_put_quota(inode->i_mapping, chg);
> > +                       hugepage_subpool_put_pages(spool, chg);
> >                        return ERR_PTR(-VM_FAULT_SIGBUS);
> >                }
> >        }
> >
> > -       set_page_private(page, (unsigned long) mapping);
> > +       set_page_private(page, (unsigned long)spool);

Sorry for the very delayed reply.  Somehow I never spotted this when
it first came.  I think I must have acidentally deleted it when
cleaning out automated messages and spam.

> Page mapping is used in unmap_ref_private(), and I am
> wondering it no longer works:-(

Good point.  But unmap_ref_private() does take the vma, so it should
be able to get to the mapping from there.  I'll respin doing that,
instead of using page_private().

> > @@ -2392,7 +2471,8 @@ retry_avoidcopy:
> >
> >        /* Drop page_table_lock as buddy allocator may be called */
> >        spin_unlock(&mm->page_table_lock);
> > -       new_page = alloc_huge_page(vma, address, outside_reserve);
> > +       new_page = alloc_huge_page(vma, address, outside_reserve,
> > +                                  subpool_vma(vma));
> 
> Change in the number of parameters of alloc_huge_page()
> looks unnecessary.

Because alloc_huge_page() also takes vma.  Yeah, fair enough.  I'll
change that in the respin too.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

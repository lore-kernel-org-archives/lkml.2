Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229Ab2CHA6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 19:58:30 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:41583 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab2CHA63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 19:58:29 -0500
Date: Thu, 8 Mar 2012 11:57:26 +1100
From: David Gibson <dwg@au1.ibm.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: akpm@linux-foundation.org, hughd@google.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, Andrew Barry <abarry@cray.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] hugepages: Fix use after free bug in "quota" handling
Message-ID: <20120308005726.GA10735@truffala.fritz.box>
Mail-Followup-To: David Gibson <dwg@au1.ibm.com>,
	Hillf Danton <dhillf@gmail.com>, akpm@linux-foundation.org,
	hughd@google.com, paulus@samba.org, linux-kernel@vger.kernel.org,
	Andrew Barry <abarry@cray.com>, Mel Gorman <mgorman@suse.de>,
	Minchan Kim <minchan.kim@gmail.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
References: <1331095694-27780-1-git-send-email-david@gibson.dropbear.id.au>
 <1331095694-27780-2-git-send-email-david@gibson.dropbear.id.au>
 <CAJd=RBCPFtyLzxyzRVKzypErt_Te1guT8gi6qu1cLvNVFVOgKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJd=RBCPFtyLzxyzRVKzypErt_Te1guT8gi6qu1cLvNVFVOgKQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12030714-7014-0000-0000-000000B1A3E5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 08:28:39PM +0800, Hillf Danton wrote:
> On Wed, Mar 7, 2012 at 12:48 PM, David Gibson
> <david@gibson.dropbear.id.au> wrote:
[snip]
> >  /*
> >  * Region tracking -- allows tracking of reservations and instantiated pages
> >  *                    across the pages in a mapping.
> > @@ -533,9 +611,9 @@ static void free_huge_page(struct page *page)
> >         */
> >        struct hstate *h = page_hstate(page);
> >        int nid = page_to_nid(page);
> > -       struct address_space *mapping;
> > +       struct hugepage_subpool *spool =
> > +               (struct hugepage_subpool *)page_private(page);
> >
> > -       mapping = (struct address_space *) page_private(page);
> >        set_page_private(page, 0);
> >        page->mapping = NULL;
> >        BUG_ON(page_count(page));
> > @@ -551,8 +629,7 @@ static void free_huge_page(struct page *page)
> >                enqueue_huge_page(h, page);
> >        }
> >        spin_unlock(&hugetlb_lock);
> > -       if (mapping)
> > -               hugetlb_put_quota(mapping, 1);
> > +       hugepage_subpool_put_pages(spool, 1);
> 
> Like current code, quota is handed back *unconditionally*, but ...

[snip]
> >        /*
> > -        * Processes that did not create the mapping will have no reserves and
> > -        * will not have accounted against quota. Check that the quota can be
> > -        * made before satisfying the allocation
> > -        * MAP_NORESERVE mappings may also need pages and quota allocated
> > -        * if no reserve mapping overlaps.
> > +        * Processes that did not create the mapping will have no
> > +        * reserves and will not have accounted against subpool
> > +        * limit. Check that the subpool limit can be made before
> > +        * satisfying the allocation MAP_NORESERVE mappings may also
> > +        * need pages and subpool limit allocated allocated if no reserve
> > +        * mapping overlaps.
> >         */
> >        chg = vma_needs_reservation(h, vma, addr);
> >        if (chg < 0)
> >                return ERR_PTR(-VM_FAULT_OOM);
> >        if (chg)
> > -               if (hugetlb_get_quota(inode->i_mapping, chg))
> > +               if (hugepage_subpool_get_pages(spool, chg))
> >                        return ERR_PTR(-VM_FAULT_SIGBUS);
> 
> ... quota is allocated only if needed.
> 
> Given that mismatch, are you fixing the use-after-free bug, or
> quota maintenance, or both?

As you say, this is as before.  So I'm only fixing the use-after-free
bug.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson


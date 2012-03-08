Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab2CHPif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 10:38:35 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:46839 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab2CHPid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 10:38:33 -0500
Date: Fri, 9 Mar 2012 01:19:09 +1100
From: David Gibson <dwg@au1.ibm.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        akpm@linux-foundation.org, hughd@google.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, Andrew Barry <abarry@cray.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 2/2] hugepages: Fix use after free bug in "quota" handling
Message-ID: <20120308141909.GJ10735@truffala.fritz.box>
Mail-Followup-To: David Gibson <dwg@au1.ibm.com>,
	Hillf Danton <dhillf@gmail.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	akpm@linux-foundation.org, hughd@google.com, paulus@samba.org,
	linux-kernel@vger.kernel.org, Andrew Barry <abarry@cray.com>,
	Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>
References: <1331095694-27780-1-git-send-email-david@gibson.dropbear.id.au>
 <1331095694-27780-2-git-send-email-david@gibson.dropbear.id.au>
 <CAJd=RBCPFtyLzxyzRVKzypErt_Te1guT8gi6qu1cLvNVFVOgKQ@mail.gmail.com>
 <87boo7afr2.fsf@linux.vnet.ibm.com>
 <CAJd=RBDQmw6zP5nF41cjQ6oJDiDX1bUKTVwG03BpkG=h+Qt6ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJd=RBDQmw6zP5nF41cjQ6oJDiDX1bUKTVwG03BpkG=h+Qt6ow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12030805-5140-0000-0000-000000DE640E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 07:59:27PM +0800, Hillf Danton wrote:
> On Thu, Mar 8, 2012 at 12:17 PM, Aneesh Kumar K.V
> <aneesh.kumar@linux.vnet.ibm.com> wrote:
> > On Wed, 7 Mar 2012 20:28:39 +0800, Hillf Danton <dhillf@gmail.com> wrote:
> >> On Wed, Mar 7, 2012 at 12:48 PM, David Gibson
> >> > @@ -533,9 +611,9 @@ static void free_huge_page(struct page *page)
> >> >         */
> >> >        struct hstate *h = page_hstate(page);
> >> >        int nid = page_to_nid(page);
> >> > -       struct address_space *mapping;
> >> > +       struct hugepage_subpool *spool =
> >> > +               (struct hugepage_subpool *)page_private(page);
> >> >
> >> > -       mapping = (struct address_space *) page_private(page);
> >> >        set_page_private(page, 0);
> >> >        page->mapping = NULL;
> >> >        BUG_ON(page_count(page));
> >> > @@ -551,8 +629,7 @@ static void free_huge_page(struct page *page)
> >> >                enqueue_huge_page(h, page);
> >> >        }
> >> >        spin_unlock(&hugetlb_lock);
> >> > -       if (mapping)
> >> > -               hugetlb_put_quota(mapping, 1);
> >> > +       hugepage_subpool_put_pages(spool, 1);
> >>
> >> Like current code, quota is handed back *unconditionally*, but ...
> >
> >
> > We will end up doing get_quota for every allocated page. get_quota
> > happens either during mmap() if MAP_NORESERVE is not specified.
> > or during alloc_huge_page if we haven't done a quota reservation during
> > mmap for that range. Are you finding any part of code where we miss that ?
> >
> >
> Thank you, Aneesh, I work it out along the direction of your question.
> 
> Apart from David's approach, quota is no longer reclaimed when pages are freed,
> but when they are truncated, and we end up with smaller .text size, and with
> the use-after-free bug fixed as well.

Sorry, I don't follow what you're saying here.

> --- a/mm/hugetlb.c	Mon Mar  5 20:20:34 2012
> +++ b/mm/hugetlb.c	Thu Mar  8 19:47:26 2012
> @@ -533,9 +533,7 @@ static void free_huge_page(struct page *
>  	 */
>  	struct hstate *h = page_hstate(page);
>  	int nid = page_to_nid(page);
> -	struct address_space *mapping;
> 
> -	mapping = (struct address_space *) page_private(page);
>  	set_page_private(page, 0);
>  	page->mapping = NULL;
>  	BUG_ON(page_count(page));
> @@ -551,8 +549,6 @@ static void free_huge_page(struct page *
>  		enqueue_huge_page(h, page);
>  	}
>  	spin_unlock(&hugetlb_lock);
> -	if (mapping)
> -		hugetlb_put_quota(mapping, 1);
>  }
> 
>  static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
> @@ -2944,8 +2940,8 @@ void hugetlb_unreserve_pages(struct inod
>  	inode->i_blocks -= (blocks_per_huge_page(h) * freed);
>  	spin_unlock(&inode->i_lock);
> 
> -	hugetlb_put_quota(inode->i_mapping, (chg - freed));
> -	hugetlb_acct_memory(h, -(chg - freed));
> +	hugetlb_put_quota(inode->i_mapping, chg);
> +	hugetlb_acct_memory(h, -chg);
>  }
> 
>  #ifdef CONFIG_MEMORY_FAILURE

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson


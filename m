Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab0HXDCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 23:02:44 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:45234 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab0HXDCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 23:02:42 -0400
Date: Tue, 24 Aug 2010 12:01:33 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/9] hugetlb: add corrupted hugepage counter
Message-ID: <20100824030133.GB12507@spritzera.linux.bs1.fc.nec.co.jp>
References: <1281432464-14833-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1281432464-14833-10-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20100819015752.GB5762@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20100819015752.GB5762@localhost>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 09:57:52AM +0800, Wu Fengguang wrote:
> > +void increment_corrupted_huge_page(struct page *page);
> > +void decrement_corrupted_huge_page(struct page *page);
>
> nitpick: increment/decrement are not verbs.

OK, increase/decrease are correct.


> > +void increment_corrupted_huge_page(struct page *hpage)
> > +{
> > +   struct hstate *h = page_hstate(hpage);
> > +   spin_lock(&hugetlb_lock);
> > +   h->corrupted_huge_pages++;
> > +   spin_unlock(&hugetlb_lock);
> > +}
> > +
> > +void decrement_corrupted_huge_page(struct page *hpage)
> > +{
> > +   struct hstate *h = page_hstate(hpage);
> > +   spin_lock(&hugetlb_lock);
> > +   BUG_ON(!h->corrupted_huge_pages);
>
> There is no point to have BUG_ON() here:
>
> /*
>  * Don't use BUG() or BUG_ON() unless there's really no way out; one
>  * example might be detecting data structure corruption in the middle
>  * of an operation that can't be backed out of.  If the (sub)system
>  * can somehow continue operating, perhaps with reduced functionality,
>  * it's probably not BUG-worthy.
>  *
>  * If you're tempted to BUG(), think again:  is completely giving up
>  * really the *only* solution?  There are usually better options, where
>  * users don't need to reboot ASAP and can mostly shut down cleanly.
>  */

OK. I understand.
BUG_ON() is too severe for just a counter.

>
> And there is a race case that (corrupted_huge_pages==0)!
> Suppose the user space calls unpoison_memory() on a good pfn, and the page
> happen to be hwpoisoned between lock_page() and TestClearPageHWPoison(),
> corrupted_huge_pages will go negative.

I see.
When this race happens, unpoison runs and decreases HugePages_Crpt,
but racing memory failure returns without increasing it.
Yes, this is a problem we need to fix.

Moreover for hugepage we should pay attention to the possiblity of
mce_bad_pages mismatch which can occur by race between unpoison and
multiple memory failures, where each failure increases mce_bad_pages
by the number of pages in a hugepage.

I think counting corrupted hugepages is not directly related to
hugepage migration, and this problem only affects the counter,
not other behaviors, so I'll separate hugepage counter fix patch
from this patch set and post as another patch series. Is this OK?

Thanks,
Naoya Horiguchi

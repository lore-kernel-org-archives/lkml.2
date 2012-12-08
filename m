Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151Ab2LHVEu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 16:04:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab2LHVEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 16:04:49 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        aneesh.kumar@linux.vnet.ibm.com, Andi Kleen <andi.kleen@intel.com>,
        Tony Luck <tony.luck@intel.com>, Wu Fengguang <fengguang.wu@intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] HWPOISON, hugetlbfs: fix warning on freeing hwpoisoned hugepage
Date: Sat,  8 Dec 2012 16:04:35 -0500
Message-Id: <1355000675-2008-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20121207143414.b2d33095.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 02:34:14PM -0800, Andrew Morton wrote:
> On Fri,  7 Dec 2012 10:49:57 -0500
> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
>
> > This patch fixes the warning from __list_del_entry() which is triggered
> > when a process tries to do free_huge_page() for a hwpoisoned hugepage.
>
> This changelog is very short.  In fact it is too short, resulting in
> others having to ask questions about the patch.  When this happens,
> please treat it as a sign that the changelog needs additional
> information - so that other readers will not feel a need to ask the
> same questions!

OK, I'll be careful after this.

> I added this paragraph:
>
> : free_huge_page() can be called for hwpoisoned hugepage from
> : unpoison_memory().  This function gets refcount once and clears
> : PageHWPoison, and then puts refcount twice to return the hugepage back to
> : free pool.  The second put_page() finally reaches free_huge_page().
>
>
>
> Also, is the description accurate?  Is the __list_del_entry() warning
> the only problem?

Right, this description is correct and this warning is the only problem.

> Or is it the case that this bug will cause memory corruption?  If so
> then the patch is pretty important and is probably needed in -stable as
> well?  I haven't checked how far back in time the bug exists.

There's no memory corruption even if we leave this bug unfixed, because
in unpoisoning (only way to change the status of hwpoisoned hugepage),
there are two possible operations on page->lru as shown below:

  static void free_huge_page(struct page *page)
  {
          ...
          if (h->surplus_huge_pages_node[nid] && huge_page_order(h) < MAX_ORDER) {
                  /* remove the page from active list */
                  list_del(&page->lru);
                  update_and_free_page(h, page);
                  h->surplus_huge_pages--;
                  h->surplus_huge_pages_node[nid]--;
          } else {
                  arch_clear_hugepage_flags(page);
                  enqueue_huge_page(h, page); /* list_move inside this function*/
          }
          ...
  }

, but both path do simply list_del() or list_move(), so there's no
difference (except for warning) after this block whether page->lru is
dangling or pointing to itself.

This bug was introduced recently on commit 0edaecfab218d747d30de
("hugetlb: add a list for tracking in-use HugeTLB pages").

Naoya

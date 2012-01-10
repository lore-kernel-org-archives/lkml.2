Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab2AJDqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 22:46:00 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36017 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999Ab2AJDp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 22:45:59 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 10 Jan 2012 12:44:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: vmscan: recompute page status when putting back
Message-Id: <20120110124442.ffb63d63.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <CAJd=RBAMtT04n8p4ht4oCSOYKVcUcG0-hbSvmjrP-yhwBYhU1A@mail.gmail.com>
References: <CAJd=RBAMtT04n8p4ht4oCSOYKVcUcG0-hbSvmjrP-yhwBYhU1A@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jan 2012 22:07:29 +0800
Hillf Danton <dhillf@gmail.com> wrote:

> If unlikely the given page is isolated from lru list again, its status is
> recomputed before putting back to lru list, since the comment says page's
> status can change while we move it among lru.
> 
> 
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/mm/vmscan.c	Thu Dec 29 20:20:16 2011
> +++ b/mm/vmscan.c	Fri Jan  6 21:31:56 2012
> @@ -633,12 +633,14 @@ int remove_mapping(struct address_space
>  void putback_lru_page(struct page *page)
>  {
>  	int lru;
> -	int active = !!TestClearPageActive(page);
> -	int was_unevictable = PageUnevictable(page);
> +	int active;
> +	int was_unevictable;
> 
>  	VM_BUG_ON(PageLRU(page));
> 
>  redo:
> +	active = !!TestClearPageActive(page);
> +	was_unevictable = PageUnevictable(page);
>  	ClearPageUnevictable(page);
> 
>  	if (page_evictable(page, NULL)) {

Hm. Do you handle this case ?
==
        /*
         * page's status can change while we move it among lru. If an evictable
         * page is on unevictable list, it never be freed. To avoid that,
         * check after we added it to the list, again.
         */
        if (lru == LRU_UNEVICTABLE && page_evictable(page, NULL)) {
                if (!isolate_lru_page(page)) {
         		put_page(page);
                        goto redo;
                }			
==

Ok, let's start from "was_unevictable"

"was_unevicatable" is used for this
==
  if (was_unevictable && lru != LRU_UNEVICTABLE)
                count_vm_event(UNEVICTABLE_PGRESCUED);
==
This is for checking that the page turned out to be evictable while we put it
into LRU. Assume the 'redo' case, the page's state chages from UNEVICTABLE to
ACTIVE_ANON (for example)

  1. at start of function: Page was Unevictable, was_unevictable=true
  2. lru = LRU_UNEVICTABLE
  3, add the page to LRU.
  4. check page_evictable(),..... it returns 'true'.
  5. isoalte the page again and goto redo.
  6. lru = LRU_ACTIVE_ANON
  7. add the page to LRU.
  8. was_unevictable==true, then, count_vm_event(UNEVICTABLE_PGRESCUED);

Your patch overwrites was_unevictable between 5. and 6., then, 
corrupts this event counting.

about "active" flag.

PageActive() flag will be set in lru_cache_add_lru() and
there will be no inconsistency between page->flags and LRU.
And, in what case the changes in 'active' will be problematic ?

-Kame














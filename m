Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab0CQCDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 22:03:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41660 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab0CQCDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 22:03:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 02/11] mm,migration: Do not try to migrate unmapped anonymous pages
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20100315142124.GL18274@csn.ul.ie>
References: <1268657329.1889.4.camel@barrios-desktop> <20100315142124.GL18274@csn.ul.ie>
Message-Id: <20100317104734.4C8E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 17 Mar 2010 11:03:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> mm,migration: Do not try to migrate unmapped anonymous pages
> 
> rmap_walk_anon() was triggering errors in memory compaction that look like
> use-after-free errors. The problem is that between the page being isolated
> from the LRU and rcu_read_lock() being taken, the mapcount of the page
> dropped to 0 and the anon_vma gets freed. This can happen during memory
> compaction if pages being migrated belong to a process that exits before
> migration completes. Hence, the use-after-free race looks like
> 
>  1. Page isolated for migration
>  2. Process exits
>  3. page_mapcount(page) drops to zero so anon_vma was no longer reliable
>  4. unmap_and_move() takes the rcu_lock but the anon_vma is already garbage
>  4. call try_to_unmap, looks up tha anon_vma and "locks" it but the lock
>     is garbage.
> 
> This patch checks the mapcount after the rcu lock is taken. If the
> mapcount is zero, the anon_vma is assumed to be freed and no further
> action is taken.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Acked-by: Rik van Riel <riel@redhat.com>
> ---
>  mm/migrate.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 98eaaf2..6eb1efe 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -603,6 +603,19 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
>  	 */
>  	if (PageAnon(page)) {
>  		rcu_read_lock();
> +
> +		/*
> +		 * If the page has no mappings any more, just bail. An
> +		 * unmapped anon page is likely to be freed soon but worse,
> +		 * it's possible its anon_vma disappeared between when
> +		 * the page was isolated and when we reached here while
> +		 * the RCU lock was not held
> +		 */
> +		if (!page_mapcount(page)) {
> +			rcu_read_unlock();
> +			goto uncharge;
> +		}

I haven't understand what prevent this check. Why don't we need following scenario?

 1. Page isolated for migration
 2. Passed this if (!page_mapcount(page)) check
 3. Process exits
 4. page_mapcount(page) drops to zero so anon_vma was no longer reliable


Traditionally, page migration logic is, it can touch garbarge of anon_vma, but
SLAB_DESTROY_BY_RCU prevent any disaster. Is this broken concept?




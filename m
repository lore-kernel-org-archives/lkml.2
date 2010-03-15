Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965859Ab0COXxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 19:53:32 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34043 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965849Ab0COXx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 19:53:29 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 16 Mar 2010 08:49:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 02/11] mm,migration: Do not try to migrate unmapped
 anonymous pages
Message-Id: <20100316084934.3798576c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100315142124.GL18274@csn.ul.ie>
References: <1268412087-13536-1-git-send-email-mel@csn.ul.ie>
	<1268412087-13536-3-git-send-email-mel@csn.ul.ie>
	<28c262361003141728g4aa40901hb040144c5a4aeeed@mail.gmail.com>
	<20100315143420.6ec3bdf9.kamezawa.hiroyu@jp.fujitsu.com>
	<20100315112829.GI18274@csn.ul.ie>
	<1268657329.1889.4.camel@barrios-desktop>
	<20100315142124.GL18274@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Mar 2010 14:21:24 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> On Mon, Mar 15, 2010 at 09:48:49PM +0900, Minchan Kim wrote:
> > On Mon, 2010-03-15 at 11:28 +0000, Mel Gorman wrote:
> > > The use after free looks like
> > > 
> > > 1. page_mapcount(page) was zero so anon_vma was no longer reliable
> > > 2. rcu lock taken but the anon_vma at this point can already be garbage because the
> > >    process exited
> > > 3. call try_to_unmap, looks up tha anon_vma and locks it. This causes problems
> > > 
> > > I thought the race would be closed but there is still a very tiny window there all
> > > right. The following alternative should close it. What do you think?
> > > 
> > >         if (PageAnon(page)) {
> > > 		rcu_read_lock();
> > > 
> > >                 /*
> > >                  * If the page has no mappings any more, just bail. An
> > >                  * unmapped anon page is likely to be freed soon but worse,
> > >                  * it's possible its anon_vma disappeared between when
> > >                  * the page was isolated and when we reached here while
> > >                  * the RCU lock was not held
> > >                  */
> > >                 if (!page_mapcount(page)) {
> > > 			rcu_read_unlock();
> > >                         goto uncharge;
> > > 		}
> > > 
> > >                 rcu_locked = 1;
> > >                 anon_vma = page_anon_vma(page);
> > >                 atomic_inc(&anon_vma->external_refcount);
> > >         }
> > > 
> > > The rcu_unlock label is not used here because the reference counts were not taken in
> > > the case where page_mapcount == 0.
> > > 
> > 
> > Please, repost above code with your use-after-free scenario comment.
> > 
> 
> This will be the replacement patch so.
> 
> ==== CUT HERE ====
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

Reviewd-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


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
> +
>  		rcu_locked = 1;
>  		anon_vma = page_anon_vma(page);
>  		atomic_inc(&anon_vma->migrate_refcount);
> 


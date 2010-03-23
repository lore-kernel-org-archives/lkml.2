Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab0CWRZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 13:25:09 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:41084 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab0CWRZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 13:25:07 -0400
Date: Tue, 23 Mar 2010 12:22:57 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 02/11] mm,migration: Do not try to migrate unmapped
 anonymous pages
In-Reply-To: <1269347146-7461-3-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1003231221030.10178@router.home>
References: <1269347146-7461-1-git-send-email-mel@csn.ul.ie> <1269347146-7461-3-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Mar 2010, Mel Gorman wrote:

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

A way to make this simpler would be to move "rcu_locked = 1" before the
if statement and then do

if (!page_mapcount(page))
	goto rcu_unlock;


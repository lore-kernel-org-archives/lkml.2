Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab0IAJah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 05:30:37 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:58470 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274Ab0IAJae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 05:30:34 -0400
Date: Wed, 1 Sep 2010 11:30:13 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vmscan,tmpfs: treat used once pages on tmpfs as used once
Message-ID: <20100901093013.GB4677@cmpxchg.org>
References: <20100901103653.974C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100901103653.974C.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 10:37:49AM +0900, KOSAKI Motohiro wrote:
> When a page has PG_referenced, shrink_page_list() discard it only
> if it is no dirty. This rule works completely fine if the backend
> filesystem is regular one. PG_dirty is good signal that it was used
> recently because flusher thread clean pages periodically. In addition,
> page writeback is costly rather than simple page discard.
> 
> However, When a page is on tmpfs, this heuristic don't works because
> flusher thread don't writeback tmpfs pages. then, tmpfs pages always
> rotate lru twice at least and it makes unnecessary lru churn. Merely
> tmpfs streaming io shouldn't cause large anonymous page swap-out.
> 
> This patch remove this unncessary reclaim bonus of tmpfs pages.
> 
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Rik van Riel <riel@redhat.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

> ---
>  mm/vmscan.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 1919d8a..aba3402 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -617,7 +617,7 @@ static enum page_references page_check_references(struct page *page,
>  	}
>  
>  	/* Reclaim if clean, defer dirty pages to writeback */
> -	if (referenced_page)
> +	if (referenced_page && !PageSwapBacked(page))
>  		return PAGEREF_RECLAIM_CLEAN;
>  
>  	return PAGEREF_RECLAIM;
> -- 
> 1.6.5.2
> 
> 
> 
> 

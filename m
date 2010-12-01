Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab0LAK2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 05:28:00 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:35326 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab0LAK17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 05:27:59 -0500
Date: Wed, 1 Dec 2010 11:27:32 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] mm: vmscan: Convert lumpy_mode into a bitmask
Message-ID: <20101201102732.GK15564@cmpxchg.org>
References: <1290440635-30071-1-git-send-email-mel@csn.ul.ie>
 <1290440635-30071-3-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290440635-30071-3-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 03:43:50PM +0000, Mel Gorman wrote:
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -51,11 +51,20 @@
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/vmscan.h>
>  
> -enum lumpy_mode {
> -	LUMPY_MODE_NONE,
> -	LUMPY_MODE_ASYNC,
> -	LUMPY_MODE_SYNC,
> -};
> +/*
> + * lumpy_mode determines how the inactive list is shrunk
> + * LUMPY_MODE_SINGLE: Reclaim only order-0 pages
> + * LUMPY_MODE_ASYNC:  Do not block
> + * LUMPY_MODE_SYNC:   Allow blocking e.g. call wait_on_page_writeback
> + * LUMPY_MODE_CONTIGRECLAIM: For high-order allocations, take a reference
> + *			page from the LRU and reclaim all pages within a
> + *			naturally aligned range

I find those names terribly undescriptive.  It also strikes me as an
odd set of flags.  Can't this be represented with less?

	LUMPY_MODE_ENABLED
	LUMPY_MODE_SYNC

or, after the rename,

	RECLAIM_MODE_HIGHER	= 1
	RECLAIM_MODE_SYNC	= 2
	RECLAIM_MODE_LUMPY	= 4

where compaction mode is default if RECLAIM_MODE_HIGHER, and
RECLAIM_MODE_LUMPY will go away eventually.

Also, if you have a flag name for 'reclaim with extra efforts for
higher order pages' that is better than RECLAIM_MODE_HIGHER... ;)

> +typedef unsigned __bitwise__ lumpy_mode;

lumpy_mode_t / reclaim_mode_t?

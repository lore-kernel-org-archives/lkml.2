Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967115Ab0GSW1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 18:27:05 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:47116 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967061Ab0GSW1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 18:27:03 -0400
Date: Tue, 20 Jul 2010 00:26:50 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Rik van Riel <riel@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 8/8] vmscan: Kick flusher threads to clean pages when
 reclaim is encountering dirty pages
Message-ID: <20100719222650.GB16031@cmpxchg.org>
References: <1279545090-19169-1-git-send-email-mel@csn.ul.ie>
 <1279545090-19169-9-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279545090-19169-9-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 02:11:30PM +0100, Mel Gorman wrote:
> @@ -933,13 +934,16 @@ keep_dirty:
>  		VM_BUG_ON(PageLRU(page) || PageUnevictable(page));
>  	}
>  
> +	/*
> +	 * If reclaim is encountering dirty pages, it may be because
> +	 * dirty pages are reaching the end of the LRU even though
> +	 * the dirty_ratio may be satisified. In this case, wake
> +	 * flusher threads to pro-actively clean some pages
> +	 */
> +	wakeup_flusher_threads(laptop_mode ? 0 : nr_dirty + nr_dirty / 2);

An argument of 0 means 'every dirty page in the system', I assume this
is not what you wanted, right?  Something like this?

	if (nr_dirty && !laptop_mode)
		wakeup_flusher_threads(nr_dirty + nr_dirty / 2);

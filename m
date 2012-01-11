Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934186Ab2AKWem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 17:34:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58467 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab2AKWel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 17:34:41 -0500
Date: Wed, 11 Jan 2012 14:34:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] mm: Fix NULL ptr dereference in __count_immobile_pages
Message-Id: <20120111143439.538bf274.akpm@linux-foundation.org>
In-Reply-To: <1326213022-11761-1-git-send-email-mhocko@suse.cz>
References: <1326213022-11761-1-git-send-email-mhocko@suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jan 2012 17:30:22 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> This patch fixes the following NULL ptr dereference caused by
> cat /sys/devices/system/memory/memory0/removable:

Which is world-readable, I assume?

> ...
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5608,6 +5608,17 @@ __count_immobile_pages(struct zone *zone, struct page *page, int count)
>  bool is_pageblock_removable_nolock(struct page *page)
>  {
>  	struct zone *zone = page_zone(page);
> +	unsigned long pfn = page_to_pfn(page);
> +
> +	/*
> +	 * We have to be careful here because we are iterating over memory
> +	 * sections which are not zone aware so we might end up outside of
> +	 * the zone but still within the section.
> +	 */
> +	if (!zone || zone->zone_start_pfn > pfn ||
> +			zone->zone_start_pfn + zone->spanned_pages <= pfn)
> +		return false;
> +
>  	return __count_immobile_pages(zone, page, 0);
>  }

So I propose that we backport it into -stable?

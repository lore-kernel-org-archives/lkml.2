Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022Ab2IUVg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 17:36:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42823 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab2IUVg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 17:36:57 -0400
Date: Fri, 21 Sep 2012 14:36:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Richard Davies <richard@arachsys.com>, Shaohua Li <shli@kernel.org>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        QEMU-devel <qemu-devel@nongnu.org>, KVM <kvm@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/9] mm: compaction: Cache if a pageblock was scanned
 and no pages were isolated
Message-Id: <20120921143656.60a9a6cd.akpm@linux-foundation.org>
In-Reply-To: <1348224383-1499-9-git-send-email-mgorman@suse.de>
References: <1348224383-1499-1-git-send-email-mgorman@suse.de>
	<1348224383-1499-9-git-send-email-mgorman@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2012 11:46:22 +0100
Mel Gorman <mgorman@suse.de> wrote:

> When compaction was implemented it was known that scanning could potentially
> be excessive. The ideal was that a counter be maintained for each pageblock
> but maintaining this information would incur a severe penalty due to a
> shared writable cache line. It has reached the point where the scanning
> costs are an serious problem, particularly on long-lived systems where a
> large process starts and allocates a large number of THPs at the same time.
> 
> Instead of using a shared counter, this patch adds another bit to the
> pageblock flags called PG_migrate_skip. If a pageblock is scanned by
> either migrate or free scanner and 0 pages were isolated, the pageblock
> is marked to be skipped in the future. When scanning, this bit is checked
> before any scanning takes place and the block skipped if set.
> 
> The main difficulty with a patch like this is "when to ignore the cached
> information?" If it's ignored too often, the scanning rates will still
> be excessive. If the information is too stale then allocations will fail
> that might have otherwise succeeded. In this patch
> 
> o CMA always ignores the information
> o If the migrate and free scanner meet then the cached information will
>   be discarded if it's at least 5 seconds since the last time the cache
>   was discarded
> o If there are a large number of allocation failures, discard the cache.
> 
> The time-based heuristic is very clumsy but there are few choices for a
> better event. Depending solely on multiple allocation failures still allows
> excessive scanning when THP allocations are failing in quick succession
> due to memory pressure. Waiting until memory pressure is relieved would
> cause compaction to continually fail instead of using reclaim/compaction
> to try allocate the page. The time-based mechanism is clumsy but a better
> option is not obvious.

ick.

Wall time has sooo little relationship to what's happening in there. 
If we *have* to use polling, cannot we clock the poll with some metric
which is at least vaguely related to the amount of activity?  Number
(or proportion) of pages scanned, for example?  Or reset everything on
the Nth trip around the zone?  Or even a combination of one of these
*and* of wall time, so the system will at least work harder when MM is
under load.

Also, what has to be done to avoid the polling altogether?  eg/ie, zap
a pageblock's PB_migrate_skip synchronously, when something was done to
that pageblock which justifies repolling it?

>
> ...
>
> +static void reset_isolation_suitable(struct zone *zone)
> +{
> +	unsigned long start_pfn = zone->zone_start_pfn;
> +	unsigned long end_pfn = zone->zone_start_pfn + zone->spanned_pages;
> +	unsigned long pfn;
> +
> +	/*
> +	 * Do not reset more than once every five seconds. If allocations are
> +	 * failing sufficiently quickly to allow this to happen then continually
> +	 * scanning for compaction is not going to help. The choice of five
> +	 * seconds is arbitrary but will mitigate excessive scanning.
> +	 */
> +	if (time_before(jiffies, zone->compact_blockskip_expire))
> +		return;
> +	zone->compact_blockskip_expire = jiffies + (HZ * 5);
> +
> +	/* Walk the zone and mark every pageblock as suitable for isolation */
> +	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
> +		struct page *page;
> +		if (!pfn_valid(pfn))
> +			continue;
> +
> +		page = pfn_to_page(pfn);
> +		if (zone != page_zone(page))
> +			continue;
> +
> +		clear_pageblock_skip(page);
> +	}

What's the worst-case loop count here?

> +}
> +
>
> ...
>


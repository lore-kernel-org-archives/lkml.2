Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887Ab0CXUfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:35:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932430Ab0CXUfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:35:02 -0400
Date: Wed, 24 Mar 2010 13:33:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 07/11] Memory compaction core
Message-Id: <20100324133347.9b4b2789.akpm@linux-foundation.org>
In-Reply-To: <1269347146-7461-8-git-send-email-mel@csn.ul.ie>
References: <1269347146-7461-1-git-send-email-mel@csn.ul.ie>
	<1269347146-7461-8-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Mar 2010 12:25:42 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> This patch is the core of a mechanism which compacts memory in a zone by
> relocating movable pages towards the end of the zone.
> 
> A single compaction run involves a migration scanner and a free scanner.
> Both scanners operate on pageblock-sized areas in the zone. The migration
> scanner starts at the bottom of the zone and searches for all movable pages
> within each area, isolating them onto a private list called migratelist.
> The free scanner starts at the top of the zone and searches for suitable
> areas and consumes the free pages within making them available for the
> migration scanner. The pages isolated for migration are then migrated to
> the newly isolated free pages.

General comment: it looks like there are some codepaths which could
hold zone->lock for a long time.  It's unclear that they're all
constrained by COMPACT_CLUSTER_MAX. Is there a a latency issue here?

>
> ...
>
> +static struct page *compaction_alloc(struct page *migratepage,
> +					unsigned long data,
> +					int **result)
> +{
> +	struct compact_control *cc = (struct compact_control *)data;
> +	struct page *freepage;
> +
> +	VM_BUG_ON(cc == NULL);

It's a bit strange to test this when we're about to oops anyway.  The
oops will tell us the same thing.

> +	/* Isolate free pages if necessary */
> +	if (list_empty(&cc->freepages)) {
> +		isolate_freepages(cc->zone, cc);
> +
> +		if (list_empty(&cc->freepages))
> +			return NULL;
> +	}
> +
> +	freepage = list_entry(cc->freepages.next, struct page, lru);
> +	list_del(&freepage->lru);
> +	cc->nr_freepages--;
> +
> +	return freepage;
> +}


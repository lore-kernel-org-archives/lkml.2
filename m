Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab0CXUyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:54:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753472Ab0CXUy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:54:29 -0400
Date: Wed, 24 Mar 2010 13:53:47 -0700
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
Subject: Re: [PATCH 11/11] Do not compact within a preferred zone after a
 compaction failure
Message-Id: <20100324135347.7a9eb37b.akpm@linux-foundation.org>
In-Reply-To: <1269347146-7461-12-git-send-email-mel@csn.ul.ie>
References: <1269347146-7461-1-git-send-email-mel@csn.ul.ie>
	<1269347146-7461-12-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Mar 2010 12:25:46 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> The fragmentation index may indicate that a failure it due to external
> fragmentation, a compaction run complete and an allocation failure still
> fail. There are two obvious reasons as to why
> 
>   o Page migration cannot move all pages so fragmentation remains
>   o A suitable page may exist but watermarks are not met
> 
> In the event of compaction and allocation failure, this patch prevents
> compaction happening for a short interval. It's only recorded on the
> preferred zone but that should be enough coverage. This could have been
> implemented similar to the zonelist_cache but the increased size of the
> zonelist did not appear to be justified.
> 
>
> ...
>
> +/* defer_compaction - Do not compact within a zone until a given time */
> +static inline void defer_compaction(struct zone *zone, unsigned long resume)
> +{
> +	/*
> +	 * This function is called when compaction fails to result in a page
> +	 * allocation success. This is somewhat unsatisfactory as the failure
> +	 * to compact has nothing to do with time and everything to do with
> +	 * the requested order, the number of free pages and watermarks. How
> +	 * to wait on that is more unclear, but the answer would apply to
> +	 * other areas where the VM waits based on time.

um.  "Two wrongs don't make a right".  We should fix the other sites,
not use them as excuses ;)

What _is_ a good measure of "time" in this code?  "number of pages
scanned" is a pretty good one in reclaim.  We want something which will
adapt itself to amount-of-memory, number-of-cpus, speed-of-cpus,
nature-of-workload, etc, etc.

Is it possible to come up with some simple metric which approximately
reflects how busy this code is, then pace ourselves via that?

> +	 */
> +	zone->compact_resume = resume;
> +}
> +
> +static inline int compaction_deferred(struct zone *zone)
> +{
> +	/* init once if necessary */
> +	if (unlikely(!zone->compact_resume)) {
> +		zone->compact_resume = jiffies;
> +		return 0;
> +	}
> +
> +	return time_before(jiffies, zone->compact_resume);
> +}


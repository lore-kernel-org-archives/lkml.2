Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab0FNXM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 19:12:57 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:54964 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750784Ab0FNXMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 19:12:55 -0400
Date: Tue, 15 Jun 2010 09:11:44 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Chris Mason <chris.mason@oracle.com>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 11/12] vmscan: Write out dirty pages in batch
Message-ID: <20100614231144.GG6590@dastard>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie>
 <1276514273-27693-12-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276514273-27693-12-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 12:17:52PM +0100, Mel Gorman wrote:
> Page reclaim cleans individual pages using a_ops->writepage() because from
> the VM perspective, it is known that pages in a particular zone must be freed
> soon, it considers the target page to be the oldest and it does not want
> to wait while background flushers cleans other pages. From a filesystem
> perspective this is extremely inefficient as it generates a very seeky
> IO pattern leading to the perverse situation where it can take longer to
> clean all dirty pages than it would have otherwise.
> 
> This patch queues all dirty pages at once to maximise the chances that
> the write requests get merged efficiently. It also makes the next patch
> that avoids writeout from direct reclaim more straight-forward.

Seeing as you have a list of pages for IO, perhaps they could be sorted
before issuing ->writepage on them.

That is, while this patch issues all the IO in one hit, it doesn't
change the order in which the IO is issued - it is still issued in
LRU order. Given that they are issued in a short period of time now,
rather than across a longer scan period, it is likely that it will
not be any faster as:

	a) IO will not be started as soon, and
	b) the IO scheduler still only has a small re-ordering
	   window and will choke just as much on random IO patterns.

However, there is a list_sort() function that could be used to sort
the list; sorting the list of pages by mapping and page->index
within the mapping would result in all the pages on each mapping
being sent down in ascending offset order at once - exactly how the
filesystems want IO to be sent to it.  Perhaps this is a simple
improvement that can be made to this code that will make a big
difference to worst case performance.

FWIW, I did this for delayed metadata buffer writeback in XFS
recently (i.e. sort the queue of (potentially tens of thousands of)
buffers in ascending block order before dispatch) and that showed a
10-15% reduction in seeks on simple kernel compile workloads. This
shows that if we optimise IO patterns at higher layers where the
sort window is much, much larger than in the IO scheduler, then
overall system performance improves....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

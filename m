Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab0FKGRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 02:17:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51741 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754487Ab0FKGRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 02:17:48 -0400
Date: Thu, 10 Jun 2010 23:17:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 6/6] vmscan: Do not writeback pages in direct reclaim
Message-Id: <20100610231706.1d7528f2.akpm@linux-foundation.org>
In-Reply-To: <1275987745-21708-7-git-send-email-mel@csn.ul.ie>
References: <1275987745-21708-1-git-send-email-mel@csn.ul.ie>
	<1275987745-21708-7-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Jun 2010 10:02:25 +0100 Mel Gorman <mel@csn.ul.ie> wrote:

> When memory is under enough pressure, a process may enter direct
> reclaim to free pages in the same manner kswapd does. If a dirty page is
> encountered during the scan, this page is written to backing storage using
> mapping->writepage. This can result in very deep call stacks, particularly
> if the target storage or filesystem are complex. It has already been observed
> on XFS that the stack overflows but the problem is not XFS-specific.
> 
> This patch prevents direct reclaim writing back pages by not setting
> may_writepage in scan_control. Instead, dirty pages are placed back on the
> LRU lists for either background writing by the BDI threads or kswapd. If
> in direct lumpy reclaim and dirty pages are encountered, the process will
> kick the background flushter threads before trying again.
> 

This wouldn't have worked at all well back in the days when you could
dirty all memory with MAP_SHARED.  The balance_dirty_pages() calls on
the fault path will now save us but if for some reason we were ever to
revert those, we'd need to revert this change too, I suspect.


As it stands, it would be wildly incautious to make a change like
this without first working out why we're pulling so many dirty pages
off the LRU tail, and fixing that.


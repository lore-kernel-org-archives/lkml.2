Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab0HZS3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:29:15 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:49263 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554Ab0HZS3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:29:12 -0400
Date: Thu, 26 Aug 2010 20:29:04 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] writeback: Record if the congestion was unnecessary
Message-ID: <20100826182904.GC6805@cmpxchg.org>
References: <1282835656-5638-1-git-send-email-mel@csn.ul.ie>
 <1282835656-5638-3-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282835656-5638-3-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 04:14:15PM +0100, Mel Gorman wrote:
> If congestion_wait() is called when there is no congestion, the caller
> will wait for the full timeout. This can cause unreasonable and
> unnecessary stalls. There are a number of potential modifications that
> could be made to wake sleepers but this patch measures how serious the
> problem is. It keeps count of how many congested BDIs there are. If
> congestion_wait() is called with no BDIs congested, the tracepoint will
> record that the wait was unnecessary.

I am not convinced that unnecessary is the right word.  On a workload
without any IO (i.e. no congestion_wait() necessary, ever), I noticed
the VM regressing both in time and in reclaiming the right pages when
simply removing congestion_wait() from the direct reclaim paths (the
one in __alloc_pages_slowpath and the other one in
do_try_to_free_pages).

So just being stupid and waiting for the timeout in direct reclaim
while kswapd can make progress seemed to do a better job for that
load.

I can not exactly pinpoint the reason for that behaviour, it would be
nice if somebody had an idea.

So personally I think it's a good idea to get an insight on the use of
congestion_wait() [patch 1] but I don't agree with changing its
behaviour just yet, or judging its usefulness solely on whether it
correctly waits for bdi congestion.

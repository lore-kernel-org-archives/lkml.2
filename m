Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab0H0CMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 22:12:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:36515 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132Ab0H0CMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 22:12:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,277,1280732400"; 
   d="scan'208";a="651742419"
Subject: Re: [PATCH 2/3] writeback: Record if the congestion was unnecessary
From: Shaohua Li <shaohua.li@intel.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100826203130.GL20944@csn.ul.ie>
References: <1282835656-5638-1-git-send-email-mel@csn.ul.ie>
	 <1282835656-5638-3-git-send-email-mel@csn.ul.ie>
	 <20100826182904.GC6805@cmpxchg.org>  <20100826203130.GL20944@csn.ul.ie>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Aug 2010 10:12:10 +0800
Message-ID: <1282875130.17594.2.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-27 at 04:31 +0800, Mel Gorman wrote:
> On Thu, Aug 26, 2010 at 08:29:04PM +0200, Johannes Weiner wrote:
> > On Thu, Aug 26, 2010 at 04:14:15PM +0100, Mel Gorman wrote:
> > > If congestion_wait() is called when there is no congestion, the caller
> > > will wait for the full timeout. This can cause unreasonable and
> > > unnecessary stalls. There are a number of potential modifications that
> > > could be made to wake sleepers but this patch measures how serious the
> > > problem is. It keeps count of how many congested BDIs there are. If
> > > congestion_wait() is called with no BDIs congested, the tracepoint will
> > > record that the wait was unnecessary.
> > 
> > I am not convinced that unnecessary is the right word.  On a workload
> > without any IO (i.e. no congestion_wait() necessary, ever), I noticed
> > the VM regressing both in time and in reclaiming the right pages when
> > simply removing congestion_wait() from the direct reclaim paths (the
> > one in __alloc_pages_slowpath and the other one in
> > do_try_to_free_pages).
> > 
> > So just being stupid and waiting for the timeout in direct reclaim
> > while kswapd can make progress seemed to do a better job for that
> > load.
> > 
> > I can not exactly pinpoint the reason for that behaviour, it would be
> > nice if somebody had an idea.
> > 
> 
> There is a possibility that the behaviour in that case was due to flusher
> threads doing the writes rather than direct reclaim queueing pages for IO
> in an inefficient manner. So the stall is stupid but happens to work out
> well because flusher threads get the chance to do work.
If this is the case, we already have queue congested. removing
congestion_wait() might cause regression but either your change or the
congestion_wait_check() should not have the regression, as we do check
if the bdi is congested.

Thanks,
Shaohua


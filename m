Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab1GAPVB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:21:01 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40448 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab1GAPU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:20:57 -0400
Date: Fri, 1 Jul 2011 17:20:48 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/9] writeback: introduce smoothed global dirty limit
Message-ID: <20110701152048.GA2721@thinkpad>
References: <20110629145245.835998321@intel.com>
 <20110629145554.294330838@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629145554.294330838@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 10:52:51PM +0800, Wu Fengguang wrote:
> The start of a heavy weight application (ie. KVM) may instantly knock
> down determine_dirtyable_memory() if the swap is not enabled or full.
> global_dirty_limits() and bdi_dirty_limit() will in turn get global/bdi
> dirty thresholds that are _much_ lower than the global/bdi dirty pages.
> 
> balance_dirty_pages() will then heavily throttle all dirtiers including
> the light ones, until the dirty pages drop below the new dirty thresholds.
> During this _deep_ dirty-exceeded state, the system may appear rather
> unresponsive to the users.
> 
> About "deep" dirty-exceeded: task_dirty_limit() assigns 1/8 lower dirty
> threshold to heavy dirtiers than light ones, and the dirty pages will
> be throttled around the heavy dirtiers' dirty threshold and reasonably
> below the light dirtiers' dirty threshold. In this state, only the heavy
> dirtiers will be throttled and the dirty pages are carefully controlled
> to not exceed the light dirtiers' dirty threshold. However if the
> threshold itself suddenly drops below the number of dirty pages, the
> light dirtiers will get heavily throttled.
> 
> So introduce global_dirty_limit for tracking the global dirty threshold
> with policies
> 
> - follow downwards slowly
> - follow up in one shot
> 
> global_dirty_limit can effectively mask out the impact of sudden drop of
> dirtyable memory. It will be used in the next patch for two new type of
> dirty limits. Note that the new dirty limits are not going to avoid
> throttling the light dirtiers, but could limit their sleep time to 200ms.
> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

...

> +static void global_update_bandwidth(unsigned long thresh,
> +				    unsigned long dirty,
> +				    unsigned long now)
> +{
> +	static DEFINE_SPINLOCK(dirty_lock);
> +	static unsigned long update_time;
> +
> +	/*
> +	 * Do a lockless check first to optimize away locking for most time.
> +	 */
> +	if (now - update_time < MAX_PAUSE)

	if (time_before(now, update_time + MAX_PAUSE))

> +		return;
> +
> +	spin_lock(&dirty_lock);
> +	if (now - update_time >= MAX_PAUSE) {

	if (time_after_eq(now, update_time + MAX_PAUSE))

Thanks,
-Andrea

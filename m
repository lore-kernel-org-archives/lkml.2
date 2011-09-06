Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab1IFOwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 10:52:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:45353 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab1IFOwZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 10:52:25 -0400
Subject: Re: [PATCH 13/18] writeback: limit max dirty pause time
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 06 Sep 2011 16:52:06 +0200
In-Reply-To: <20110904020916.329482509@intel.com>
References: <20110904015305.367445271@intel.com>
	 <20110904020916.329482509@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315320726.14232.11.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-09-04 at 09:53 +0800, Wu Fengguang wrote:

> +static unsigned long bdi_max_pause(struct backing_dev_info *bdi,
> +				   unsigned long bdi_dirty)
> +{
> +	unsigned long hi = ilog2(bdi->write_bandwidth);
> +	unsigned long lo = ilog2(bdi->dirty_ratelimit);
> +	unsigned long t;
> +
> +	/* target for ~10ms pause on 1-dd case */
> +	t = HZ / 50;

1k/50 usually ends up being 20 something

> +	/*
> +	 * Scale up pause time for concurrent dirtiers in order to reduce CPU
> +	 * overheads.
> +	 *
> +	 * (N * 20ms) on 2^N concurrent tasks.
> +	 */
> +	if (hi > lo)
> +		t += (hi - lo) * (20 * HZ) / 1024;
> +
> +	/*
> +	 * Limit pause time for small memory systems. If sleeping for too long
> +	 * time, a small pool of dirty/writeback pages may go empty and disk go
> +	 * idle.
> +	 *
> +	 * 1ms for every 1MB; may further consider bdi bandwidth.
> +	 */
> +	if (bdi_dirty)
> +		t = min(t, bdi_dirty >> (30 - PAGE_CACHE_SHIFT - ilog2(HZ)));

Yeah, I would add the bdi->avg_write_bandwidth term in there, 1g/s as an
avg bandwidth is just too wrong..


> +
> +	/*
> +	 * The pause time will be settled within range (max_pause/4, max_pause).
> +	 * Apply a minimal value of 4 to get a non-zero max_pause/4.
> +	 */
> +	return clamp_val(t, 4, MAX_PAUSE);

So you limit to 50ms min? That still seems fairly large. Is that because
your min sleep granularity might be something like 10ms since you're
using jiffies?

> +}



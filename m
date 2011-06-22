Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572Ab1FVAVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 20:21:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756665Ab1FVAVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 20:21:07 -0400
Date: Tue, 21 Jun 2011 17:20:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] writeback: introduce max-pause and pass-good dirty
 limits
Message-Id: <20110621172043.51621aa9.akpm@linux-foundation.org>
In-Reply-To: <20110619150510.367141119@intel.com>
References: <20110619150108.691351746@intel.com>
	<20110619150510.367141119@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Jun 2011 23:01:12 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> The max-pause limit helps to keep the sleep time inside
> balance_dirty_pages() within 200ms. The 200ms max sleep means per task
> rate limit of 8pages/200ms=160KB/s, which normally is enough to stop
> dirtiers from continue pushing the dirty pages high, unless there are
> a sufficient large number of slow dirtiers (ie. 500 tasks doing 160KB/s
> will still sum up to 80MB/s, reaching the write bandwidth of a slow disk).
> 
> The pass-good limit helps to let go of the good bdi's in the presence of
> a blocked bdi (ie. NFS server not responding) or slow USB disk which for
> some reason build up a large number of initial dirty pages that refuse
> to go away anytime soon.

The hard-wired numbers and hard-wired assumptions about device speeds
shouldn't be here at all.  They will be sub-optimal (and sometimes
extremely so) for all cases.  They will become wronger over time.  Or
less wrong, depending upon which way they were originally wrong.

> +		dirty_thresh = hard_dirty_limit(dirty_thresh);
> +		if (nr_dirty < dirty_thresh + dirty_thresh / DIRTY_MAXPAUSE &&
> +		    jiffies - start_time > MAX_PAUSE)
> +			break;
> +		if (nr_dirty < dirty_thresh + dirty_thresh / DIRTY_PASSGOOD &&
> +		    bdi_dirty < bdi_thresh)
> +			break;

It appears that despite their similarity, DIRTY_MAXPAUSE is a
dimensionless value whereas the units of MAX_PAUSE is jiffies.  Perhaps
more care in naming choices would clarify things like this.

The first comparison might be clearer if it used time_after().

Both statements need comments explaining what they do and *why they do
it*.


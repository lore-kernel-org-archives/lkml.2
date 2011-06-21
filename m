Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab1FUX7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 19:59:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757407Ab1FUX7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 19:59:34 -0400
Date: Tue, 21 Jun 2011 16:59:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] writeback: introduce smoothed global dirty limit
Message-Id: <20110621165905.3c7180a4.akpm@linux-foundation.org>
In-Reply-To: <20110619155546.GA14338@localhost>
References: <20110619150108.691351746@intel.com>
	<20110619150510.246140117@intel.com>
	<20110619153636.GC20424@infradead.org>
	<20110619155546.GA14338@localhost>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Jun 2011 23:55:47 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> On Sun, Jun 19, 2011 at 11:36:37PM +0800, Christoph Hellwig wrote:
> > On Sun, Jun 19, 2011 at 11:01:11PM +0800, Wu Fengguang wrote:
> > > The start of a heavy weight application (ie. KVM) may instantly knock
> > > down determine_dirtyable_memory() and hence the global/bdi dirty
> > > thresholds.
> > > 
> > > So introduce global_dirty_limit for tracking the global dirty threshold
> > > with policies
> > > 
> > > - follow downwards slowly
> > > - follow up in one shot
> > > 
> > > global_dirty_limit can effectively mask out the impact of sudden drop of
> > > dirtyable memory. It will be used in the next patch for two new type of
> > > dirty limits.
> > 
> > This needs to be explained in more detail in comments near the actual
> > code.
> 
> Good point! This is the added comment for the update_dirty_limit() function.
> 
> /*
>  * The global dirtyable memory and dirty threshold could be suddenly knocked
>  * down by a large amount (eg. on the startup of KVM). This may throw the
>  * system into deep dirty exceeded state and throttled to "death" for a couple
>  * of seconds. The solution is to maintain global_dirty_limit for tracking
>  * slowly down to the knocked down dirty threshold.
>  */
> static void update_dirty_limit(unsigned long thresh,
>                                unsigned long dirty)
> 

Neither this nor the changelog explain things well. 

Looking at the code, KVM starts, allocates memory,
global_page_state(NR_FREE_PAGES) decreases by N and
global_reclaimable_pages() increases by N.  Nothing changed.

So what's going on here?

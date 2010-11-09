Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab0KIVOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:14:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754421Ab0KIVOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:14:06 -0500
Date: Tue, 9 Nov 2010 13:13:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Hellwig <hch@lst.de>,
        Jan Engelhardt <jengelh@medozas.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] writeback: stop background/kupdate works from
 livelocking other works
Message-Id: <20101109131310.f442d210.akpm@linux-foundation.org>
In-Reply-To: <20101108231726.993880740@intel.com>
References: <20101108230916.826791396@intel.com>
	<20101108231726.993880740@intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Nov 2010 07:09:19 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:
>

I find the description to be somewhat incomplete...

> From: Jan Kara <jack@suse.cz>
> 
> Background writeback are easily livelockable (from a definition of their
> target).

*why* is background writeback easily livelockable?  Under which
circumstances does this happen and how does it come about?

> This is inconvenient because it can make sync(1) stall forever waiting
> on its queued work to be finished.

Again, why?  Because there are works queued from the flusher thread,
but that thread is stuck in a livelocked state in <unspecified code
location> so it is unable to service the other works?  But the pocess
which called sync() will as a last resort itself perform all the
required IO, will it not?  If so, how can it livelock?

> Generally, when a flusher thread has
> some work queued, someone submitted the work to achieve a goal more specific
> than what background writeback does. So it makes sense to give it a priority
> over a generic page cleaning.
> 
> Thus we interrupt background writeback if there is some other work to do. We
> return to the background writeback after completing all the queued work.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  fs/fs-writeback.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> --- linux-next.orig/fs/fs-writeback.c	2010-11-07 21:56:42.000000000 +0800
> +++ linux-next/fs/fs-writeback.c	2010-11-07 22:00:51.000000000 +0800
> @@ -651,6 +651,15 @@ static long wb_writeback(struct bdi_writ
>  			break;
>  
>  		/*
> +		 * Background writeout and kupdate-style writeback are
> +		 * easily livelockable. Stop them if there is other work
> +		 * to do so that e.g. sync can proceed.
> +		 */
> +		if ((work->for_background || work->for_kupdate) &&
> +		    !list_empty(&wb->bdi->work_list))
> +			break;
> +
> +		/*
>  		 * For background writeout, stop when we are below the
>  		 * background dirty threshold
>  		 */

So...  what prevents higher priority works (eg, sync(1)) from
livelocking or seriously retarding background or kudate writeout?


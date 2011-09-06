Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab1IFPvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 11:51:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:37430 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab1IFPvi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 11:51:38 -0400
Subject: Re: [PATCH 14/18] writeback: control dirty pause time
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 06 Sep 2011 17:51:25 +0200
In-Reply-To: <20110904020916.460538138@intel.com>
References: <20110904015305.367445271@intel.com>
	 <20110904020916.460538138@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315324285.14232.16.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-09-04 at 09:53 +0800, Wu Fengguang wrote:
> plain text document attachment (max-pause-adaption)
> The dirty pause time shall ultimately be controlled by adjusting
> nr_dirtied_pause, since there is relationship
> 
> 	pause = pages_dirtied / task_ratelimit
> 
> Assuming
> 
> 	pages_dirtied ~= nr_dirtied_pause
> 	task_ratelimit ~= dirty_ratelimit
> 
> We get
> 
> 	nr_dirtied_pause ~= dirty_ratelimit * desired_pause
> 
> Here dirty_ratelimit is preferred over task_ratelimit because it's
> more stable.
> 
> It's also important to limit possible large transitional errors:
> 
> - bw is changing quickly
> - pages_dirtied << nr_dirtied_pause on entering dirty exceeded area
> - pages_dirtied >> nr_dirtied_pause on btrfs (to be improved by a
>   separate fix, but still expect non-trivial errors)
> 
> So we end up using the above formula inside clamp_val().
> 
> The best test case for this code is to run 100 "dd bs=4M" tasks on
> btrfs and check its pause time distribution.



> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  mm/page-writeback.c |   15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> --- linux-next.orig/mm/page-writeback.c	2011-08-29 19:08:43.000000000 +0800
> +++ linux-next/mm/page-writeback.c	2011-08-29 19:08:44.000000000 +0800
> @@ -1193,7 +1193,20 @@ pause:
>  	if (!dirty_exceeded && bdi->dirty_exceeded)
>  		bdi->dirty_exceeded = 0;
>  
> -	current->nr_dirtied_pause = dirty_poll_interval(nr_dirty, dirty_thresh);
> +	if (pause == 0)
> +		current->nr_dirtied_pause =
> +				dirty_poll_interval(nr_dirty, dirty_thresh);
> +	else if (period <= max_pause / 4 &&
> +		 pages_dirtied >= current->nr_dirtied_pause)
> +		current->nr_dirtied_pause = clamp_val(
> +					dirty_ratelimit * (max_pause / 2) / HZ,
> +					pages_dirtied + pages_dirtied / 8,
> +					pages_dirtied * 4);
> +	else if (pause >= max_pause)
> +		current->nr_dirtied_pause = 1 | clamp_val(
> +					dirty_ratelimit * (max_pause * 3/8)/HZ,
> +					pages_dirtied / 4,
> +					pages_dirtied * 7/8);
>  

I very much prefer { } over multi line stmts, even if not strictly
needed.

I'm also not quite sure why pause==0 is a special case, also, do the two
other line segments connect on the transition point?

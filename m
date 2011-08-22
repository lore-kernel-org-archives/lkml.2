Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab1HVX0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 19:26:55 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:25372 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754311Ab1HVX0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 19:26:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAC/iUk55LIxD/2dsb2JhbABBqB54gUABAQUnExwjEAgDGC4UJQMhE71ADoY6BKQd
Date: Tue, 23 Aug 2011 09:26:50 +1000
From: Dave Chinner <david@fromorbit.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vmscan: use atomic-long for shrinker batching
Message-ID: <20110822232650.GU3162@dastard>
References: <20110822101721.19462.63082.stgit@zurg>
 <20110822101727.19462.55289.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110822101727.19462.55289.stgit@zurg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 02:17:27PM +0300, Konstantin Khlebnikov wrote:
> Use atomic-long operations instead of looping around cmpxchg().
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> ---
>  include/linux/shrinker.h |    2 +-
>  mm/vmscan.c              |   17 +++++++----------
>  2 files changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
> index 790651b..ac6b8ee 100644
> --- a/include/linux/shrinker.h
> +++ b/include/linux/shrinker.h
> @@ -34,7 +34,7 @@ struct shrinker {
>  
>  	/* These are for internal use */
>  	struct list_head list;
> -	long nr;	/* objs pending delete */
> +	atomic_long_t nr_in_batch; /* objs pending delete */

It's not really the number in a batch - we use the "batch" term to
refer to the value we set sc->nr_to_scan for each shrinker scan call.
This is more the overflow of unscanned objects - objects pending
delete, as the comment says. So renaming it "nr_pending" might be
better.

As it is, this is a good change - I'll fold it into the series I
already have.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

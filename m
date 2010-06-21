Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112Ab0FUXF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 19:05:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364Ab0FUXF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 19:05:26 -0400
Date: Mon, 21 Jun 2010 19:05:18 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Moyer Jeff Moyer <jmoyer@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cfq: always return false from should_idle if
 slice_idle is set to zero
Message-ID: <20100621230518.GA10105@redhat.com>
References: <1277149789-4493-1-git-send-email-jmoyer@redhat.com>
 <1277149789-4493-2-git-send-email-jmoyer@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277149789-4493-2-git-send-email-jmoyer@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 03:49:48PM -0400, Jeff Moyer wrote:
> Hi,
> 
> In testing a competing fsync-ing process and a sequential reader on
> mid-grade storage, I found that cfq was incapable of achieving the I/O
> rates of deadline, no matter how it was tuned.  Investigation, and insight
> from Vivek (mostly the latter), led to identifying that we were still
> idling for the last queue in the service tree.
> 
> Modifying cfq_should_idle to not idle when slice_idle is set to zero got
> us much closer to the performance of deadline for this workload.  I have
> one follow-on patch that gets us on-par with deadline, but I think this
> patch stands alone.
> 
> Comments, as always, are appreciated.
> 

Looks good to me Jeff. This does take away one functionality and that is
ability to get group service differentation even with slice_idle=0.
cfq_should_idle() was making sure that we don't select the next queue
from next group.

But I think a better way to fix that would be to introduce a new tunable
say group_idle. That way if we are running on some powerful storage box
and don't want the overhead of idling, we can do slice_idle=0 and not idle
among the cfqq's with-in group but still do idle a bit on group and get
the group service differentiation.

I have a small patch for implementing group_idle. I will post that once
you patch is in Jens's tree.

Thanks
Vivek

> Cheers,
> Jeff
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> ---
>  block/cfq-iosched.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 5ff4f48..572a050 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1842,6 +1842,10 @@ static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  	if (prio == IDLE_WORKLOAD)
>  		return false;
>  
> +	/* Don't idle if slice idling is disabled by the user */
> +	if (cfqd->cfq_slice_idle == 0)
> +		return false;
> +
>  	/* We do for queues that were marked with idle window flag. */
>  	if (cfq_cfqq_idle_window(cfqq) &&
>  	   !(blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag))
> -- 
> 1.6.5.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

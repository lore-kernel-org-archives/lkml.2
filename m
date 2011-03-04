Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab1CDEBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 23:01:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758465Ab1CDEA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 23:00:59 -0500
Date: Thu, 3 Mar 2011 23:00:48 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, hch@infradead.org,
        NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110304040048.GA32404@redhat.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
 <1295659049-2688-6-git-send-email-jaxboe@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295659049-2688-6-git-send-email-jaxboe@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 22, 2011 at 01:17:24AM +0000, Jens Axboe wrote:

[..]
>  mm/page-writeback.c                |    2 +-
>  mm/readahead.c                     |   12 ---
>  mm/shmem.c                         |    1 -
>  mm/swap_state.c                    |    5 +-
>  mm/swapfile.c                      |   37 --------
>  mm/vmscan.c                        |    2 +-
>  118 files changed, 153 insertions(+), 1248 deletions(-)

block/blk-throttle.c also uses blk_unplug(). We need to get rid of that
also.

[..]
> @@ -632,8 +630,6 @@ void elv_insert(struct request_queue *q, struct request *rq, int where)
>  		 * don't force unplug of the queue for that case.
>  		 * Clear unplug_it and fall through.
>  		 */

Above comments now seem to be redundant.

> -		unplug_it = 0;
> -
>  	case ELEVATOR_INSERT_FRONT:
>  		rq->cmd_flags |= REQ_SOFTBARRIER;
>  		list_add(&rq->queuelist, &q->queue_head);

[..]
>  /*
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index b9e1e15..5ef136c 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -394,7 +394,7 @@ static void raid_unplug(struct dm_target_callbacks *cb)
>  {
>  	struct raid_set *rs = container_of(cb, struct raid_set, callbacks);
>  
> -	md_raid5_unplug_device(rs->md.private);
> +	md_raid5_kick_device(rs->md.private);

With all the unplug logic gone, I think we can get rid of blk_sync_queue()
call from md. It looks like md was syncing the queue just to make sure
that unplug_fn is not called again. Now all that logic is gone so it
should be redundant.

Also we can probably get rid of some queue_lock taking instances in
md code. NeilBrown recently put following patch in, which is taking
queue lock only around plug functions. Now queue plugging gone,
I guess it should not be required.

commit da9cf5050a2e3dbc3cf26a8d908482eb4485ed49
Author: NeilBrown <neilb@suse.de>
Date:   Mon Feb 21 18:25:57 2011 +1100

    md: avoid spinlock problem in blk_throtl_exit

Thanks
Vivek

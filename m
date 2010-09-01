Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab0IANvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 09:51:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479Ab0IANvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 09:51:38 -0400
Date: Wed, 1 Sep 2010 09:51:21 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com,
        jamie@shareable.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        dm-devel@redhat.com
Subject: Re: [PATCH 3/5] dm: relax ordering of bio-based flush implementation
Message-ID: <20100901135120.GA25251@redhat.com>
References: <1283162296-13650-1-git-send-email-tj@kernel.org>
 <1283162296-13650-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283162296-13650-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30 2010 at  5:58am -0400,
Tejun Heo <tj@kernel.org> wrote:

> Unlike REQ_HARDBARRIER, REQ_FLUSH/FUA doesn't mandate any ordering
> against other bio's.  This patch relaxes ordering around flushes.
> 
> * A flush bio is no longer deferred to workqueue directly.  It's
>   processed like other bio's but __split_and_process_bio() uses
>   md->flush_bio as the clone source.  md->flush_bio is initialized to
>   empty flush during md initialization and shared for all flushes.
> 
> * When dec_pending() detects that a flush has completed, it checks
>   whether the original bio has data.  If so, the bio is queued to the
>   deferred list w/ REQ_FLUSH cleared; otherwise, it's completed.
> 
> * As flush sequencing is handled in the usual issue/completion path,
>   dm_wq_work() no longer needs to handle flushes differently.  Now its
>   only responsibility is re-issuing deferred bio's the same way as
>   _dm_request() would.  REQ_FLUSH handling logic including
>   process_flush() is dropped.
> 
> * There's no reason for queue_io() and dm_wq_work() write lock
>   dm->io_lock.  queue_io() now only uses md->deferred_lock and
>   dm_wq_work() read locks dm->io_lock.
> 
> * bio's no longer need to be queued on the deferred list while a flush
>   is in progress making DMF_QUEUE_IO_TO_THREAD unncessary.  Drop it.
> 
> This avoids stalling the device during flushes and simplifies the
> implementation.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Looks good overall.

> @@ -144,11 +143,6 @@ struct mapped_device {
>  	spinlock_t deferred_lock;
>  
>  	/*
> -	 * An error from the flush request currently being processed.
> -	 */
> -	int flush_error;
> -
> -	/*
>  	 * Protect barrier_error from concurrent endio processing
>  	 * in request-based dm.
>  	 */

Could you please document why it is OK to remove 'flush_error' in the
patch header?  The -EOPNOTSUPP handling removal (done in patch 2)
obviously helps enable this but it is not clear how the
'num_flush_requests' flushes that __clone_and_map_flush() generates do
not need explicit DM error handling.

Other than that.

Acked-by: Mike Snitzer <snitzer@redhat.com>

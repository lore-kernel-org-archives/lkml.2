Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab0DLOaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 10:30:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab0DLOaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 10:30:23 -0400
Date: Mon, 12 Apr 2010 10:30:15 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Divyesh Shah <dpshah@google.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, nauman@google.com,
       ctalbott@google.com
Subject: Re: [PATCH] blkio: Changes to more io-controller stats patches to
	address
Message-ID: <20100412143015.GC1294@redhat.com>
References: <20100410023509.17767.21937.stgit@austin.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100410023509.17767.21937.stgit@austin.mtv.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 07:35:35PM -0700, Divyesh Shah wrote:
> review comments.
> 
> Changelog: (in response to Vivek Goyal's comments)
> o group blkiocg_update_blkio_group_dequeue_stats() with other DEBUG functions
> o rename blkiocg_update_set_active_queue_stats() to
>   blkiocg_update_avg_queue_size_stats()
> o s/request/io/ in blkiocg_update_request_add_stats() and
>   blkiocg_update_request_remove_stats()
> o Call cfq_del_timer() at request dispatch() instead of
>   blkiocg_update_idle_time_stats()
> 
> Signed-off-by: Divyesh Shah<dpshah@google.com>
> ---
> 

[..]
> @@ -2395,11 +2395,7 @@ static int cfq_dispatch_requests(struct request_queue *q, int force)
>  	}
>  
>  	cfq_log_cfqq(cfqd, cfqq, "dispatched a request");
> -	/*
> -	 * This is needed since we don't exactly match the mod_timer() and
> -	 * del_timer() calls in CFQ.
> -	 */
> -	blkiocg_update_idle_time_stats(&cfqq->cfqg->blkg);
> +	cfq_del_timer(cfqd, cfqq);

I am trying to think that why do we need this call here. What is that path
which does not delete the timer upon receiving request and lets fix that.

One of the possible path when you got the request but still leave the
timer on is following.

cfq_rq_enqueued()
	if(request_not_big_enough)
		leave_timer_on
		cfq_mark_cfqq_must_dispatch(cfqq);

I guess we need to leave timer on so that if an unplug does not come in, a
timer expirty will dispatch the request from the queue.

In this case we can probably call here blkiocg_update_idle_time_stats()
directly. Anyway, that's the right thing to do otherwise our idle time
stats are little wrong as we got a request from the application and idle
timer is over. Now this is additional wait time enforced by cfq so that
lots of small requests are not dispatched to disk.

Thanks
Vivek

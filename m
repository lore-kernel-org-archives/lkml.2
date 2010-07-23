Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760691Ab0GWQRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 12:17:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757554Ab0GWQRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 12:17:08 -0400
Date: Fri, 23 Jul 2010 12:17:03 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfq-iosched: don't allow aliased requests to starve
 others
Message-ID: <20100723161702.GC13104@redhat.com>
References: <x49zkxuaymb.fsf@segfault.boston.devel.redhat.com>
 <20100723042530.GD11236@redhat.com>
 <x49pqyejkyo.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49pqyejkyo.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 11:07:11AM -0400, Jeff Moyer wrote:

[..]
> >> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> >> index 7982b83..0d8d2cd 100644
> >> --- a/block/cfq-iosched.c
> >> +++ b/block/cfq-iosched.c
> >> @@ -417,6 +417,7 @@ static inline int cfqg_busy_async_queues(struct cfq_data *cfqd,
> >>  }
> >>  
> >>  static void cfq_dispatch_insert(struct request_queue *, struct request *);
> >> +static struct request *cfq_check_fifo(struct cfq_queue *cfqq);
> >>  static struct cfq_queue *cfq_get_queue(struct cfq_data *, bool,
> >>  				       struct io_context *, gfp_t);
> >>  static struct cfq_io_context *cfq_cic_lookup(struct cfq_data *,
> >> @@ -1394,10 +1395,22 @@ static void cfq_add_rq_rb(struct request *rq)
> >>  
> >>  	/*
> >>  	 * looks a little odd, but the first insert might return an alias.
> >> -	 * if that happens, put the alias on the dispatch list
> >> +	 * If that happens, put the alias on the dispatch list, but don't
> >> +	 * allow issuing of aliased requests to starve out the queue.
> >>  	 */
> >> -	while ((__alias = elv_rb_add(&cfqq->sort_list, rq)) != NULL)
> >> +	while ((__alias = elv_rb_add(&cfqq->sort_list, rq)) != NULL) {
> >> +		int fifo_checked = cfq_cfqq_fifo_expire(cfqq);
> >> +		struct request *__rq;
> >> +
> >>  		cfq_dispatch_insert(cfqd->queue, __alias);
> >> +		cfq_clear_cfqq_fifo_expire(cfqq);
> >> +		while ((__rq = cfq_check_fifo(cfqq))) {
> >> +			cfq_dispatch_insert(cfqd->queue, __rq);
> >> +			cfq_clear_cfqq_fifo_expire(cfqq);
> >> +		}
> >> +		if (fifo_checked)
> >> +			cfq_mark_cfqq_fifo_expire(cfqq);
> >> +	}
> >
> > Jeff,
> >
> > IIUC correctly upon receiving an alias, you are checking fifo of same
> > cfqq and not the fifo of other cfqqs which are blocked. So dispatching
> > more expired requests from the cfqq which is generating lots of aliases
> > can at best only worsen the problem. I am wondering how does this patch
> > help in dispatching requests from other cfqqs. 
> 
> I think you're missing a key element, here.  Let's assume some harmless
> process has the I/O scheduler.  Then, your pathological alias generator
> process comes in and inserts a request into the queue.  If that request
> is an alias, then it gets moved to the dispatch list immediately, even
> though the cfqq for that process is not currently being served.
> 
> Now, I'm not sure why we ever get back into select_queue if the request
> queue is always full of these aliases.  I didn't dig down that far, but
> I did verify that progress was made in my simple reproducer.

Jeff, I do understand the problem here. Just that I don't understand
how this patch is going to fix it for CFQ. How this patch will make
sure that requests from other starved queue are put onto dispatch queue.

Also I have been trying to reproduce the issue with 2.6.36-rc6 kernel
and have not been successful so far.

Thanks
Vivek

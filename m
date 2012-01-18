Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985Ab2ARQHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 11:07:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43688 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757948Ab2ARQHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 11:07:18 -0500
Date: Wed, 18 Jan 2012 08:07:13 -0800
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: Kernel crash in icq_free_icq_rcu
Message-ID: <20120118160713.GA30664@google.com>
References: <20120117201823.GD19223@redhat.com>
 <20120117214834.GD26207@google.com>
 <20120117220715.GB23527@redhat.com>
 <CANejiEUfAxR-DFH+eRQUbmc1jKHSkcBP1RxuRQ-9JKLU=1Ds0w@mail.gmail.com>
 <20120118010323.GA32160@htj.dyndns.org>
 <CANejiEUopG3MgUsvGMbkdHKrgBT_c+bir1bApt8p86kQn42huQ@mail.gmail.com>
 <20120118011112.GB32160@htj.dyndns.org>
 <1326850253.22361.619.camel@sli10-conroe>
 <1326866602.22361.624.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326866602.22361.624.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 18, 2012 at 02:03:22PM +0800, Shaohua Li wrote:
> Subject: block: fix NULL icq_cache reference
> 
> CPU0:					CPU1:
> 					switch from cfq to noop
> 					   elv_quiesce_start
> C: get_request
> A:   ioc_create_icq
>       alloc icq with cfq
> 					   B: do elevator switch
> 					       ioc_clear_queue
> 					   elv_quiesce_end
>       insert icq to ioc
> 					switch from noop to cfq
> 					    elv_quiesce_start
> 					    do elevator switch
> 					       ioc_clear_queue
> 					    elv_quiesce_end
> CPU0 leaves some icq to ioc list after elevator is switching from cfq to noop.
> in the second ioc_clear_queue, the ioc has icq in its list, but current
> elevator is noop. so ioc_exit_icq will get a NULL et->icq_cache.
> 
> In above cases, if A runs after B, ioc_create_icq will have a NULL
> et->icq_cache, this will trigger another crash.
> 
> Note, get_request caches et without lock hold. Between C and A, a elevator
> switch can start. But we will have elvpriv++, elv_quiesce_start will drain
> all requests first. So this will not trigger crash.

Thanks a lot for tracking it down.

Hmmm... but I'm having a difficult time following the description.
Maybe we can simplify a bit?  e.g. sth like the following?

  Once a queue is quiesced, it's not supposed to have any elvpriv data
  or icq's, and elevator switching depends on that.  Request alloc
  path followed the rule for elvpriv data but forgot apply it to
  icq's leading to the following crash during elevator switch.

  <oops log>

  Fix it by not allocating icq's if ELVPRIV is not set for the
  request.

> Index: linux/block/blk-core.c
> ===================================================================
> --- linux.orig/block/blk-core.c	2012-01-18 12:44:13.000000000 +0800
> +++ linux/block/blk-core.c	2012-01-18 12:45:28.000000000 +0800
> @@ -872,11 +872,11 @@ retry:
>  	spin_unlock_irq(q->queue_lock);
>  
>  	/* create icq if missing */
> -	if (unlikely(et->icq_cache && !icq))
> +	if (unlikely(et->icq_cache && !icq && (rw_flags & REQ_ELVPRIV)))
>  		icq = ioc_create_icq(q, gfp_mask);
>  
>  	/* rqs are guaranteed to have icq on elv_set_request() if requested */
> -	if (likely(!et->icq_cache || icq))
> +	if (likely(!et->icq_cache || icq || !(rw_flags & REQ_ELVPRIV)))
>  		rq = blk_alloc_request(q, icq, rw_flags, gfp_mask);

Hmmm... I was trying to avoid adding a goto label with the double
testing but with REQ_ELVPRIV test added, it looks more confusing.
Maybe something like the following is better?

	/* rqs are guaranteed to have icq on elv_set_request() if requested */
	if ((rw_flags & REQ_ELVPRIV) && unlikely(et->icq_cache && !icq)) {
		icq = ioc_create_icq(q, gfp_mask);
		if (!icq)
			goto fail_icq;
	}
	rq = blk_alloc_request(q, icq, rw_flags, gfp_mask);
 fail_icq:

Thanks.

-- 
tejun

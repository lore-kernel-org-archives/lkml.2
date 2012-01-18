Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638Ab2AROUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 09:20:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757466Ab2AROUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 09:20:09 -0500
Date: Wed, 18 Jan 2012 09:20:05 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Tejun Heo <tj@kernel.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: Kernel crash in icq_free_icq_rcu
Message-ID: <20120118142005.GC30204@redhat.com>
References: <20120117201823.GD19223@redhat.com>
 <20120117214834.GD26207@google.com>
 <20120117220715.GB23527@redhat.com>
 <CANejiEUfAxR-DFH+eRQUbmc1jKHSkcBP1RxuRQ-9JKLU=1Ds0w@mail.gmail.com>
 <20120118010323.GA32160@htj.dyndns.org>
 <CANejiEUopG3MgUsvGMbkdHKrgBT_c+bir1bApt8p86kQn42huQ@mail.gmail.com>
 <20120118011112.GB32160@htj.dyndns.org>
 <1326850253.22361.619.camel@sli10-conroe>
 <1326866602.22361.624.camel@sli10-conroe>
 <20120118135126.GB30204@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120118135126.GB30204@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 08:51:26AM -0500, Vivek Goyal wrote:

[..]
> > Subject: block: fix NULL icq_cache reference
> > 
> > CPU0:					CPU1:
> > 					switch from cfq to noop
> > 					   elv_quiesce_start
> > C: get_request
> > A:   ioc_create_icq
> >       alloc icq with cfq
> > 					   B: do elevator switch
> > 					       ioc_clear_queue
> > 					   elv_quiesce_end
> >       insert icq to ioc
> > 					switch from noop to cfq
> > 					    elv_quiesce_start
> > 					    do elevator switch
> > 					       ioc_clear_queue
> > 					    elv_quiesce_end
> > CPU0 leaves some icq to ioc list after elevator is switching from cfq to noop.
> > in the second ioc_clear_queue, the ioc has icq in its list, but current
> > elevator is noop. so ioc_exit_icq will get a NULL et->icq_cache.
> > 
> > In above cases, if A runs after B, ioc_create_icq will have a NULL
> > et->icq_cache, this will trigger another crash.
> > 
> > Note, get_request caches et without lock hold. Between C and A, a elevator
> > switch can start. But we will have elvpriv++, elv_quiesce_start will drain
> > all requests first. So this will not trigger crash.
> > 
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > ---
> >  block/blk-core.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > Index: linux/block/blk-core.c
> > ===================================================================
> > --- linux.orig/block/blk-core.c	2012-01-18 12:44:13.000000000 +0800
> > +++ linux/block/blk-core.c	2012-01-18 12:45:28.000000000 +0800
> > @@ -872,11 +872,11 @@ retry:
> >  	spin_unlock_irq(q->queue_lock);
> >  
> >  	/* create icq if missing */
> > -	if (unlikely(et->icq_cache && !icq))
> > +	if (unlikely(et->icq_cache && !icq && (rw_flags & REQ_ELVPRIV)))
> >  		icq = ioc_create_icq(q, gfp_mask);
> >  
> >  	/* rqs are guaranteed to have icq on elv_set_request() if requested */
> > -	if (likely(!et->icq_cache || icq))
> > +	if (likely(!et->icq_cache || icq || !(rw_flags & REQ_ELVPRIV)))
> >  		rq = blk_alloc_request(q, icq, rw_flags, gfp_mask);
> 
> Not allocating icq if request is never going to go to elevator as elevator
> switch was happening makes sense to me.
> 
> I tried this patch. It went little further and crashed at a different
> place. I think this seems to be separate merging issue Tejun is trying
> to track down.

Applied Tejun's debug patch to return early and not call into elevator
for checking whether merge is allowed or not. Things seems to be stable
now for me.

So Shaohua's patch did fix the original crash for me.

Thanks
Vivek

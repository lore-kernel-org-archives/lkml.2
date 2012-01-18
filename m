Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab2ARGCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 01:02:47 -0500
Received: from mga14.intel.com ([143.182.124.37]:34414 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034Ab2ARGCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 01:02:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="97015926"
Subject: Re: Kernel crash in icq_free_icq_rcu
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1326850253.22361.619.camel@sli10-conroe>
References: <20120117201823.GD19223@redhat.com>
	 <20120117214834.GD26207@google.com> <20120117220715.GB23527@redhat.com>
	 <CANejiEUfAxR-DFH+eRQUbmc1jKHSkcBP1RxuRQ-9JKLU=1Ds0w@mail.gmail.com>
	 <20120118010323.GA32160@htj.dyndns.org>
	 <CANejiEUopG3MgUsvGMbkdHKrgBT_c+bir1bApt8p86kQn42huQ@mail.gmail.com>
	 <20120118011112.GB32160@htj.dyndns.org>
	 <1326850253.22361.619.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Jan 2012 14:03:22 +0800
Message-ID: <1326866602.22361.624.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-18 at 09:30 +0800, Shaohua Li wrote:
> On Tue, 2012-01-17 at 17:11 -0800, Tejun Heo wrote:
> > On Wed, Jan 18, 2012 at 09:05:26AM +0800, Shaohua Li wrote:
> > > > Vivek is seeing the problem while switching elevators.  Are you too?
> > > > Or is it during normal operation?
> > > same here. I had some problems when I debug my ioscheduler, but
> > > eventually found even switching cfq and noop can trigger oops.
> > 
> > Hmmm... maybe quiescing isn't working as expected and kmem cache is
> > being destroyed with live icq's.  I'll try to reproduce it.
> this debug patch seems to fix for me.
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index e6c05a9..c6a8ef5 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
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
>  
>  	if (unlikely(!rq)) {
> 
Here is the formal patch. I hope it fixes all the problems related to
icq_cache, but please open an eye :)


Subject: block: fix NULL icq_cache reference

CPU0:					CPU1:
					switch from cfq to noop
					   elv_quiesce_start
C: get_request
A:   ioc_create_icq
      alloc icq with cfq
					   B: do elevator switch
					       ioc_clear_queue
					   elv_quiesce_end
      insert icq to ioc
					switch from noop to cfq
					    elv_quiesce_start
					    do elevator switch
					       ioc_clear_queue
					    elv_quiesce_end
CPU0 leaves some icq to ioc list after elevator is switching from cfq to noop.
in the second ioc_clear_queue, the ioc has icq in its list, but current
elevator is noop. so ioc_exit_icq will get a NULL et->icq_cache.

In above cases, if A runs after B, ioc_create_icq will have a NULL
et->icq_cache, this will trigger another crash.

Note, get_request caches et without lock hold. Between C and A, a elevator
switch can start. But we will have elvpriv++, elv_quiesce_start will drain
all requests first. So this will not trigger crash.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/blk-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/block/blk-core.c
===================================================================
--- linux.orig/block/blk-core.c	2012-01-18 12:44:13.000000000 +0800
+++ linux/block/blk-core.c	2012-01-18 12:45:28.000000000 +0800
@@ -872,11 +872,11 @@ retry:
 	spin_unlock_irq(q->queue_lock);
 
 	/* create icq if missing */
-	if (unlikely(et->icq_cache && !icq))
+	if (unlikely(et->icq_cache && !icq && (rw_flags & REQ_ELVPRIV)))
 		icq = ioc_create_icq(q, gfp_mask);
 
 	/* rqs are guaranteed to have icq on elv_set_request() if requested */
-	if (likely(!et->icq_cache || icq))
+	if (likely(!et->icq_cache || icq || !(rw_flags & REQ_ELVPRIV)))
 		rq = blk_alloc_request(q, icq, rw_flags, gfp_mask);
 
 	if (unlikely(!rq)) {



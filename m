Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab2AQVBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 16:01:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118Ab2AQVBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 16:01:19 -0500
Date: Tue, 17 Jan 2012 16:01:14 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Chris Mason <chris.mason@oracle.com>
Subject: Re: Kernel crash in icq_free_icq_rcu
Message-ID: <20120117210114.GA23527@redhat.com>
References: <20120117201823.GD19223@redhat.com>
 <4F15D7D0.2040203@kernel.dk>
 <20120117204053.GE19223@redhat.com>
 <4F15DD40.5040200@kernel.dk>
 <20120117205816.GF19223@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120117205816.GF19223@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 03:58:16PM -0500, Vivek Goyal wrote:

[..]

> > >> Can you try this?
> > > 
> > > Nope, this does not help either. Can reproduce the issue with below
> > > patch applied.
> > > 
> > >>
> > >>
> > >> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> > >> index 163263d..ee55019 100644
> > >> --- a/block/cfq-iosched.c
> > >> +++ b/block/cfq-iosched.c
> > >> @@ -3117,18 +3117,17 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
> > >>   */
> > >>  static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> > >>  {
> > >> -	struct cfq_queue *old_cfqq = cfqd->active_queue;
> > >> -
> > >>  	cfq_log_cfqq(cfqd, cfqq, "preempt");
> > >> -	cfq_slice_expired(cfqd, 1);
> > >>  
> > >>  	/*
> > >>  	 * workload type is changed, don't save slice, otherwise preempt
> > >>  	 * doesn't happen
> > >>  	 */
> > >> -	if (cfqq_type(old_cfqq) != cfqq_type(cfqq))
> > >> +	if (cfqq_type(cfqd->active_queue) != cfqq_type(cfqq))
> > >>  		cfqq->cfqg->saved_workload_slice = 0;
> > >>  
> > >> +	cfq_slice_expired(cfqd, 1);
> > >> +
> > > 
> > > cfq_slice_expired() will overwrite the value of
> > > cfqq->cfqg->saved_workload_slice. So we need to set it to zero after
> > > cfq_slice_expired.
> > 
> > Good point, lets just fix that up afterwards, the use-after-free needs
> > to go asap.
> > 
> > > I was thinking of just saving the workload type of cfqq before
> > > cfq_slice_expired() so that we don't access old cfqq after
> > > cfq_slice_expired(). But then I noticed that we don't drop a cfqq
> > > reference in cfq_slice_expired(). So not sure how cfq_slice_expired()
> > > can lead to freeing up of queue. It should happen only when process
> > > has exited and last request on the queue if finished. 
> > 
> > It does, it drops a ref to the cic which in turn drops the active async
> > and sync queues.
> 
> Ok, I see it now. Thanks.
> 
> I modified your patch a bit. It does not seem to solve my problem but
> might help with Chris Mason's boot issue.
> 
> Chris, can you please give it a try.

Oops, old mail id of chris. Fixing it now.

Thanks
Vivek

> 
> Thanks
> Vivek
> 
> ---
>  block/cfq-iosched.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/block/cfq-iosched.c
> ===================================================================
> --- linux-2.6.orig/block/cfq-iosched.c	2012-01-18 02:49:33.000000000 -0500
> +++ linux-2.6/block/cfq-iosched.c	2012-01-18 02:50:31.000000000 -0500
> @@ -3117,7 +3117,7 @@ cfq_should_preempt(struct cfq_data *cfqd
>   */
>  static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  {
> -	struct cfq_queue *old_cfqq = cfqd->active_queue;
> +	enum wl_type_t old_cfqq_wl_type = cfqq_type(cfqd->active_queue);
>  
>  	cfq_log_cfqq(cfqd, cfqq, "preempt");
>  	cfq_slice_expired(cfqd, 1);
> @@ -3126,7 +3126,7 @@ static void cfq_preempt_queue(struct cfq
>  	 * workload type is changed, don't save slice, otherwise preempt
>  	 * doesn't happen
>  	 */
> -	if (cfqq_type(old_cfqq) != cfqq_type(cfqq))
> +	if (old_cfqq_wl_type != cfqq_type(cfqq))
>  		cfqq->cfqg->saved_workload_slice = 0;
>  
>  	/*

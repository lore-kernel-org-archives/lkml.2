Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047Ab2EPB12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 21:27:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:40719 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758223Ab2EPB10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 21:27:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="144472812"
Subject: Re: [RFC PATCH 3/3] block: add queue idle timer
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org
In-Reply-To: <x49mx59b6c0.fsf@segfault.boston.devel.redhat.com>
References: <1337071697-30920-1-git-send-email-ming.m.lin@intel.com>
	 <1337071697-30920-4-git-send-email-ming.m.lin@intel.com>
	 <x49mx59b6c0.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 May 2012 09:27:23 +0800
Message-ID: <1337131643.22243.2.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 15:19 -0400, Jeff Moyer wrote:
> Lin Ming <ming.m.lin@intel.com> writes:
> 
> > Add an idle timer that is set to some suitable timeout and would be
> > added when the queue first goes empty. If nothing has happened during
> > the timeout interval, then the queue is suspended.
> >
> > Queueing a new request could check the state and resume queue if it is
> > supended.
> >
> 
> [snip]
> 
> > @@ -1129,6 +1141,13 @@ void __blk_put_request(struct request_queue *q, struct request *req)
> >  	if (unlikely(--req->ref_count))
> >  		return;
> >  
> > +	/* PM request is not accounted */
> > +	if (!(req->cmd_flags & REQ_PM)) {
> > +		if (!(--q->nr_pending))
> > +			/* Hard code to 20secs, will move to sysfs */
> > +			mod_timer(&q->idle, jiffies + 20*HZ);
> > +	}
> > +
> 
> I'm pretty sure Jens wanted to avoid doing a mod_timer, here, given that
> the queue can transition between empty and non-empty fairly rapidly for
> dependent I/O.

I'll remove this idle timer and use runtime pm core's timer.

> 
> > @@ -587,6 +590,13 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
> >  {
> >  	trace_block_rq_insert(q, rq);
> >  
> > +	if (!(rq->cmd_flags & REQ_PM)) {
> > +		if (!(q->pm_status != RPM_ACTIVE) &&
> 
> Uhh, re-read that line.  Not not equal?

Ah, it should be:

if (q->pm_status != RPM_ACTIVE &&

My mistake.

> 
> Cheers,
> Jeff



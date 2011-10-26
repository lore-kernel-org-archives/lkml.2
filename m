Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593Ab1JZTVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 15:21:17 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53591 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab1JZTVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 15:21:16 -0400
Date: Wed, 26 Oct 2011 12:21:10 -0700
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: vgoyal@redhat.com, jgarzik@pobox.com, davem@davemloft.net,
        hch@infradead.org, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] block: allow blk_execute_rq_nowait() to be called
 from IRQ context
Message-ID: <20111026192110.GA24261@google.com>
References: <1319590927-15791-1-git-send-email-tj@kernel.org>
 <1319590927-15791-3-git-send-email-tj@kernel.org>
 <4EA7C094.8000204@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA7C094.8000204@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Jens.

On Wed, Oct 26, 2011 at 10:11:00AM +0200, Jens Axboe wrote:
> On 2011-10-26 03:02, Tejun Heo wrote:
> > Currently blk_execute_rq_nowait() directly calls __blk_run_queue() and
> > thus must be called from sleepable context.  This patch updates the
> > function such that it can be called from non-sleepable context and
> > schedules async execution in such cases.  This will be used to
> > unexport elv_add_request().
> > 
> > While at it, add FIXME comment for REQ_TYPE_PM_RESUME special case.
> > 
> > -v2: hch pointed out that blk_execute_rq_nowait() can be hot path for
> >      some drivers.  Retained direct execution from sleepable context.
> 
> Ugh, this looks nasty:
> 
> > +	bool may_sleep = !preempt_count() && !irqs_disabled();
> 
> please don't ever do that. Pass the context in instead.

Hmmm... I don't know.  This is strictly for optimization in block
layer proper.  It's kinda nasty to expose that, especially when the
interface is named _nowait and we already have separate request
allocation API.  Let's leave this alone for now.  The only offending
driver is ide anyway.

> > +	/*
> > +	 * Some drivers beat this path pretty hard.  As an optimization, if
> > +	 * we're being called from sleepable context, run @q directly.
> > +	 */
> > +	if (may_sleep) {
> > +		__blk_run_queue(q);
> > +		/*
> > +		 * The queue is stopped so it won't be run.
> > +		 * FIXME: Please kill me along with REQ_TYPE_PM_RESUME.
> > +		 */
> > +		if (rq->cmd_type == REQ_TYPE_PM_RESUME)
> > +			q->request_fn(q);
> 
> This is very nasty as well.

That's what the current code has.  We really need to take out those
odd request types.

Thanks.

-- 
tejun

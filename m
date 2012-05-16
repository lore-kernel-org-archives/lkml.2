Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab2EPO2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 10:28:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53930 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752496Ab2EPO2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 10:28:38 -0400
Date: Wed, 16 May 2012 10:28:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jens Axboe <axboe@kernel.dk>
cc: Jeff Moyer <jmoyer@redhat.com>, Lin Ming <ming.m.lin@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [RFC PATCH 3/3] block: add queue idle timer
In-Reply-To: <4FB3B14E.2040306@kernel.dk>
Message-ID: <Pine.LNX.4.44L0.1205161026520.1852-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2012, Jens Axboe wrote:

> On 05/16/2012 03:04 PM, Jeff Moyer wrote:
> > Lin Ming <ming.m.lin@intel.com> writes:
> > 
> >> On Tue, 2012-05-15 at 15:19 -0400, Jeff Moyer wrote:
> >>> Lin Ming <ming.m.lin@intel.com> writes:
> >>>
> >>>> Add an idle timer that is set to some suitable timeout and would be
> >>>> added when the queue first goes empty. If nothing has happened during
> >>>> the timeout interval, then the queue is suspended.
> >>>>
> >>>> Queueing a new request could check the state and resume queue if it is
> >>>> supended.
> >>>>
> >>>
> >>> [snip]
> >>>
> >>>> @@ -1129,6 +1141,13 @@ void __blk_put_request(struct request_queue *q, struct request *req)
> >>>>  	if (unlikely(--req->ref_count))
> >>>>  		return;
> >>>>  
> >>>> +	/* PM request is not accounted */
> >>>> +	if (!(req->cmd_flags & REQ_PM)) {
> >>>> +		if (!(--q->nr_pending))
> >>>> +			/* Hard code to 20secs, will move to sysfs */
> >>>> +			mod_timer(&q->idle, jiffies + 20*HZ);
> >>>> +	}
> >>>> +
> >>>
> >>> I'm pretty sure Jens wanted to avoid doing a mod_timer, here, given that
> >>> the queue can transition between empty and non-empty fairly rapidly for
> >>> dependent I/O.
> >>
> >> I'll remove this idle timer and use runtime pm core's timer.
> > 
> > This issues isn't which timer to use, it's when to modify it.  Since the
> > queue can cycle between empty and non-empty very quickly, you should try
> > to avoid calling mod_timer for every non-empty to empty transition.
> > Jens had described one way to do this in the thread you referenced in
> > your 0/3 email.
> 
> That's exactly right, thanks Jeff.
> 
> Lin, you should have more slack timer handling. Look at the blk-timeout
> handling of request timeouts for inspiration, and/or the thread that
> Jeff also references. Doing a timer add/del for each request put is a no
> go.

Lin, note that if you use the API properly, the runtime PM timer does
not have to get updated every time an I/O event occurs.  Look up 
pm_runtime_mark_last_busy() in the runtime PM documentation.

Alan Stern


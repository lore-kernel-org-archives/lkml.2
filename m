Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab3AHPWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 10:22:48 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:34888 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756569Ab3AHPWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 10:22:46 -0500
Date: Tue, 8 Jan 2013 10:22:45 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Aaron Lu <aaron.lu@intel.com>
cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        <linux-pm@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Aaron Lu <aaron.lwe@gmail.com>,
        Shane Huang <shane.huang@amd.com>
Subject: Re: [PATCH v6 3/4] block: implement runtime pm strategy
In-Reply-To: <50EBCC93.5000203@intel.com>
Message-ID: <Pine.LNX.4.44L0.1301081016310.1535-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2013, Aaron Lu wrote:

> >> --- a/include/linux/blkdev.h
> >> +++ b/include/linux/blkdev.h
> >> @@ -974,6 +974,40 @@ extern int blk_pre_runtime_suspend(struct request_queue *q);
> >>  extern void blk_post_runtime_suspend(struct request_queue *q, int err);
> >>  extern void blk_pre_runtime_resume(struct request_queue *q);
> >>  extern void blk_post_runtime_resume(struct request_queue *q, int err);
> >> +
> >> +static inline void blk_pm_put_request(struct request *rq)
> >> +{
> >> +	if (!(rq->cmd_flags & REQ_PM) && !--rq->q->nr_pending) {
> >> +		pm_runtime_mark_last_busy(rq->q->dev);
> >> +		pm_runtime_autosuspend(rq->q->dev);
> >> +	}
> >> +}
> >> +
> >> +static inline struct request *blk_pm_peek_request(
> >> +	struct request_queue *q, struct request *rq)
> >> +{
> >> +	if (q->rpm_status == RPM_SUSPENDED ||
> >> +		  (q->rpm_status != RPM_ACTIVE && !(rq->cmd_flags & REQ_PM)))
> >> +		return NULL;
> >> +	else
> >> +		return rq;
> >> +}
> >> +
> >> +static inline void blk_pm_requeue_request(struct request *rq)
> >> +{
> >> +	if (!(rq->cmd_flags & REQ_PM))
> >> +		rq->q->nr_pending--;
> >> +}
> >> +
> >> +static inline void blk_pm_add_request(struct request_queue *q,
> >> +	struct request *rq)
> >> +{
> >> +	if (!(rq->cmd_flags & REQ_PM) &&
> >> +	    q->nr_pending++ == 0 &&
> >> +	    (q->rpm_status == RPM_SUSPENDED ||
> >> +	     q->rpm_status == RPM_SUSPENDING))
> >> +		pm_request_resume(q->dev);
> >> +}
> > 
> > These routines also don't belong in include/linux.  And they don't need 
> > to be marked inline.
> 
> OK, will move them.
> 
> What about create a new file blk-pm.c for all these block pm related
> code?

Sure, go ahead if Jens doesn't mind.  Alternatively, you could put each
of these functions in the file where it gets used.

Just as importantly, all of the public routines added in patch 2/4 to
blk-core.c should have kerneldoc explaining how and where to use them.  
In particular, the kerneldoc for blk_pm_runtime_init() has to mention
that the block runtime PM implementation works only for drivers that
use request structures for their I/O; it doesn't work for drivers that
use bio's directly.

Alan Stern


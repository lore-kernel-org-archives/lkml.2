Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908Ab2EVQO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 12:14:59 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46097 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753112Ab2EVQO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 12:14:57 -0400
Date: Tue, 22 May 2012 12:14:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lin Ming <ming.m.lin@intel.com>
cc: Jens Axboe <axboe@kernel.dk>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Subject: Re: [RFC PATCH v3 3/4] block: implement runtime pm strategy
In-Reply-To: <1337671292-15583-4-git-send-email-ming.m.lin@intel.com>
Message-ID: <Pine.LNX.4.44L0.1205221210360.2100-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Lin Ming wrote:

> When a request is added:
>     If device is suspended or is suspending and the request is not a
>     PM request, resume the device.
> 
> When a request finishes:
>     Call pm_runtime_mark_last_busy().
> 
> When pick a request:
>     If device is not active, then only PM request is allowed to go.
>     Return NULL for other request.

You've got the right idea.  There are a few things that need fixing, in 
this patch and in 4/4.

> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1130,6 +1130,10 @@ void __blk_put_request(struct request_queue *q, struct request *req)
>  	if (unlikely(--req->ref_count))
>  		return;
>  
> +	/* PM request is not accounted */
> +	if (!(req->cmd_flags & REQ_PM) && !(--q->nr_pending) && q->dev)

I don't see that it makes any difference.  You might as well count PM 
requests along with the others, here and elsewhere.

> +		pm_runtime_mark_last_busy(q->dev);
> +
>  	elv_completed_request(q, req);
>  
>  	/* this is a bio leak */
> @@ -1918,6 +1922,12 @@ struct request *blk_peek_request(struct request_queue *q)
>  	int ret;
>  
>  	while ((rq = __elv_next_request(q)) != NULL) {
> +		/* Only PM request is allowed to go if the queue is suspended */
> +		if (q->rpm_status != RPM_ACTIVE && !(rq->cmd_flags & REQ_PM)) {
> +			rq = NULL;
> +			break;
> +		}

Not even PM requests should be allowed to go if the status is 
RPM_SUSPENDED.

Is this the only interface by which a client driver can get a request 
from the queue?

Alan Stern


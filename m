Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093Ab2GENyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:54:12 -0400
Received: from netrider.rowland.org ([192.131.102.5]:33634 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933041Ab2GENyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:54:10 -0400
Date: Thu, 5 Jul 2012 09:54:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Lin Ming <ming.m.lin@intel.com>
cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v4 3/4] block: implement runtime pm strategy
In-Reply-To: <1341473199-3837-4-git-send-email-ming.m.lin@intel.com>
Message-ID: <Pine.LNX.4.44L0.1207050951530.30876-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2012, Lin Ming wrote:

> When a request is added:
>     If device is suspended or is suspending and the request is not a
>     PM request, resume the device.
> 
> When a request finishes:
>     Call pm_runtime_mark_last_busy().
> 
> When pick a request:
>     If device is resuming/suspending, then only PM request is allowed to go.
>     Return NULL for other cases.
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>

These changes would look better if you didn't have "#ifdef
CONFIG_PM_RUNTIME" sprinkled throughout the block-layer routines.

Instead, define static helper functions to do your work, and put the 
definitions inside a #ifdef block.  If CONFIG_PM_RUNTIME isn't enabled,
the helper functions can be empty static inlines.
 
> --- a/block/elevator.c +++ b/block/elevator.c @@ -536,6 +537,11 @@

> void elv_requeue_request(struct request_queue *q, struct request *rq)
>  
>  	rq->cmd_flags &= ~REQ_STARTED;
>  
> +#ifdef CONFIG_PM_RUNTIME
> +	/* __elv_add_request will increment the count */
> +	if (!(rq->cmd_flags & REQ_PM))
> +		q->nr_pending--;
> +#endif

__elv_add_request increments nr_pending even when REQ_PM is set.  You 
need to be consistent with that behavior.

Alan Stern


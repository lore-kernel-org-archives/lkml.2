Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab2GFOVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 10:21:53 -0400
Received: from netrider.rowland.org ([192.131.102.5]:46545 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757406Ab2GFOVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 10:21:51 -0400
Date: Fri, 6 Jul 2012 10:21:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Lin Ming <ming.m.lin@intel.com>
cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Shaohua Li <shli@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v5 3/4] block: implement runtime pm strategy
In-Reply-To: <1341547472-6863-4-git-send-email-ming.m.lin@intel.com>
Message-ID: <Pine.LNX.4.44L0.1207061019170.28821-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2012, Lin Ming wrote:

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

Generally okay, but...

> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -908,6 +908,36 @@ extern int blk_pre_runtime_suspend(struct request_queue *q);
>  extern void blk_post_runtime_suspend(struct request_queue *q, int err);
>  extern void blk_pre_runtime_resume(struct request_queue *q);
>  extern void blk_post_runtime_resume(struct request_queue *q, int err);
> +
> +static inline void blk_pm_put_request(struct request_queue *q)
> +{
> +	if (!(--q->nr_pending) && q->dev)
> +		 pm_runtime_mark_last_busy(q->dev);
> +}
...

These new helper routines are private to the block layer, not intended
for use by clients.  Consequently they don't belong in include/linux;
they should go in block/blk.h.

Alan Stern


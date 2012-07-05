Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585Ab2GENFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:05:50 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:54301 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339Ab2GENFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:05:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v4 2/4] block: add runtime pm helpers
Date: Thu, 5 Jul 2012 15:11:20 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>,
        Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
References: <1341473199-3837-1-git-send-email-ming.m.lin@intel.com> <1341473199-3837-3-git-send-email-ming.m.lin@intel.com>
In-Reply-To: <1341473199-3837-3-git-send-email-ming.m.lin@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201207051511.20772.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 05, 2012, Lin Ming wrote:
> Add runtime pm helper functions:
> 
> blk_pm_runtime_init()
> blk_pre_runtime_suspend()
> blk_post_runtime_suspend()
> blk_pre_runtime_resume()
> blk_post_runtime_suspend()

What exactly do you need these things for?  Please be specific.

Thanks,
Rafael


> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
> 
> v4:
> - Adds CONFIG_PM_RUNTIME check
> 
>  block/blk-core.c       |   63 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/blkdev.h |   27 +++++++++++++++++++++
>  2 files changed, 90 insertions(+)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 3c923a7..b94ec5f 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -30,6 +30,7 @@
>  #include <linux/list_sort.h>
>  #include <linux/delay.h>
>  #include <linux/ratelimit.h>
> +#include <linux/pm_runtime.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/block.h>
> @@ -2982,6 +2983,68 @@ void blk_finish_plug(struct blk_plug *plug)
>  }
>  EXPORT_SYMBOL(blk_finish_plug);
>  
> +#ifdef CONFIG_PM_RUNTIME
> +void blk_pm_runtime_init(struct request_queue *q, struct device *dev)
> +{
> +	q->dev = dev;
> +	q->rpm_status = RPM_ACTIVE;
> +
> +	pm_runtime_use_autosuspend(q->dev);
> +	pm_runtime_mark_last_busy(q->dev);
> +	pm_runtime_autosuspend(q->dev);
> +}
> +EXPORT_SYMBOL(blk_pm_runtime_init);
> +
> +int blk_pre_runtime_suspend(struct request_queue *q)
> +{
> +	int ret = 0;
> +
> +	spin_lock_irq(q->queue_lock);
> +	if (q->nr_pending)
> +		ret = -EBUSY;
> +	else
> +		q->rpm_status = RPM_SUSPENDING;
> +	spin_unlock_irq(q->queue_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL(blk_pre_runtime_suspend);
> +
> +void blk_post_runtime_suspend(struct request_queue *q, int err)
> +{
> +	spin_lock_irq(q->queue_lock);
> +	if (!err)
> +		q->rpm_status = RPM_SUSPENDED;
> +	else {
> +		q->rpm_status = RPM_ACTIVE;
> +		pm_runtime_mark_last_busy(q->dev);
> +	}
> +	spin_unlock_irq(q->queue_lock);
> +}
> +EXPORT_SYMBOL(blk_post_runtime_suspend);
> +
> +void blk_pre_runtime_resume(struct request_queue *q)
> +{
> +	spin_lock_irq(q->queue_lock);
> +	q->rpm_status = RPM_RESUMING;
> +	spin_unlock_irq(q->queue_lock);
> +}
> +EXPORT_SYMBOL(blk_pre_runtime_resume);
> +
> +void blk_post_runtime_resume(struct request_queue *q, int err)
> +{
> +	spin_lock_irq(q->queue_lock);
> +	if (!err) {
> +		q->rpm_status = RPM_ACTIVE;
> +		__blk_run_queue(q);
> +		pm_runtime_mark_last_busy(q->dev);
> +		pm_request_autosuspend(q->dev);
> +	} else
> +		q->rpm_status = RPM_SUSPENDED;
> +	spin_unlock_irq(q->queue_lock);
> +}
> +EXPORT_SYMBOL(blk_post_runtime_resume);
> +#endif
> +
>  int __init blk_dev_init(void)
>  {
>  	BUILD_BUG_ON(__REQ_NR_BITS > 8 *
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index ba43f40..a5b255e 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -346,6 +346,12 @@ struct request_queue {
>  	 */
>  	struct kobject kobj;
>  
> +#ifdef CONFIG_PM_RUNTIME
> +	struct device		*dev;
> +	int			rpm_status;
> +	unsigned int		nr_pending;
> +#endif
> +
>  	/*
>  	 * queue settings
>  	 */
> @@ -893,6 +899,27 @@ struct request_queue *blk_alloc_queue_node(gfp_t, int);
>  extern void blk_put_queue(struct request_queue *);
>  
>  /*
> + * block layer runtime pm functions
> + */
> +#ifdef CONFIG_PM_RUNTIME
> +extern void blk_pm_runtime_init(struct request_queue *q, struct device *dev);
> +extern int blk_pre_runtime_suspend(struct request_queue *q);
> +extern void blk_post_runtime_suspend(struct request_queue *q, int err);
> +extern void blk_pre_runtime_resume(struct request_queue *q);
> +extern void blk_post_runtime_resume(struct request_queue *q, int err);
> +#else
> +static inline void blk_pm_runtime_init(struct request_queue *q,
> +	struct device *dev) {}
> +static inline int blk_pre_runtime_suspend(struct request_queue *q)
> +{
> +	return -ENOSYS;
> +}
> +static inline void blk_post_runtime_suspend(struct request_queue *q, int err) {}
> +static inline void blk_pre_runtime_resume(struct request_queue *q) {}
> +static inline void blk_post_runtime_resume(struct request_queue *q, int err) {}
> +#endif
> +
> +/*
>   * blk_plug permits building a queue of related requests by holding the I/O
>   * fragments for a short period. This allows merging of sequential requests
>   * into single larger request. As the requests are moved from a per-task list to
> 


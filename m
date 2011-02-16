Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296Ab1BPE0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 23:26:37 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41399 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412Ab1BPE0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 23:26:35 -0500
Date: Tue, 15 Feb 2011 21:26:31 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: spi-devel-general@lists.sourceforge.net,
        Sascha Hauer <s.hauer@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] [RFC] spi/bitbang: Use a kthread worker instead of
 workqueue
Message-ID: <20110216042631.GA11189@angua.secretlab.ca>
References: <1297158375-25528-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1297158375-25528-2-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1297158375-25528-2-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 10:46:15AM +0100, Uwe Kleine-König wrote:
> From: Sascha Hauer <s.hauer@pengutronix.de>
> 
> Since the concurrency managed workqueues are merged we often have
> several microseconds delays in spi transfers. This patch resolves
> this by using a kthread worker in spi_bitbang instead.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Hmmm, I could use some input here from folks with a better
understanding of the concurrency managed workqueues.  Is switching to
a kthread worker the right thing to do, or is it working around a bug
in the workqueue implementation that should be fixed instead?

Anyone care to chime in?

g.

> ---
>  drivers/spi/spi_bitbang.c       |   17 ++++++++++-------
>  include/linux/spi/spi_bitbang.h |    7 ++++---
>  2 files changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/spi/spi_bitbang.c b/drivers/spi/spi_bitbang.c
> index 14a63f6..e2a874a 100644
> --- a/drivers/spi/spi_bitbang.c
> +++ b/drivers/spi/spi_bitbang.c
> @@ -254,7 +254,7 @@ static int spi_bitbang_bufs(struct spi_device *spi, struct spi_transfer *t)
>   * Drivers can provide word-at-a-time i/o primitives, or provide
>   * transfer-at-a-time ones to leverage dma or fifo hardware.
>   */
> -static void bitbang_work(struct work_struct *work)
> +static void bitbang_work(struct kthread_work *work)
>  {
>  	struct spi_bitbang	*bitbang =
>  		container_of(work, struct spi_bitbang, work);
> @@ -396,7 +396,7 @@ int spi_bitbang_transfer(struct spi_device *spi, struct spi_message *m)
>  		status = -ENETDOWN;
>  	else {
>  		list_add_tail(&m->queue, &bitbang->queue);
> -		queue_work(bitbang->workqueue, &bitbang->work);
> +		queue_kthread_work(&bitbang->worker, &bitbang->work);
>  	}
>  	spin_unlock_irqrestore(&bitbang->lock, flags);
>  
> @@ -432,11 +432,12 @@ EXPORT_SYMBOL_GPL(spi_bitbang_transfer);
>  int spi_bitbang_start(struct spi_bitbang *bitbang)
>  {
>  	int	status;
> +	struct sched_param param = { .sched_priority = 49 };
>  
>  	if (!bitbang->master || !bitbang->chipselect)
>  		return -EINVAL;
>  
> -	INIT_WORK(&bitbang->work, bitbang_work);
> +	init_kthread_work(&bitbang->work, bitbang_work);
>  	spin_lock_init(&bitbang->lock);
>  	INIT_LIST_HEAD(&bitbang->queue);
>  
> @@ -463,12 +464,14 @@ int spi_bitbang_start(struct spi_bitbang *bitbang)
>  
>  	/* this task is the only thing to touch the SPI bits */
>  	bitbang->busy = 0;
> -	bitbang->workqueue = create_singlethread_workqueue(
> +	init_kthread_worker(&bitbang->worker);
> +	bitbang->worker_task = kthread_run(kthread_worker_fn, &bitbang->worker,
>  			dev_name(bitbang->master->dev.parent));
> -	if (bitbang->workqueue == NULL) {
> +	if (bitbang->worker_task == NULL) {
>  		status = -EBUSY;
>  		goto err1;
>  	}
> +	sched_setscheduler(bitbang->worker_task, SCHED_FIFO, &param);
>  
>  	/* driver may get busy before register() returns, especially
>  	 * if someone registered boardinfo for devices
> @@ -480,7 +483,7 @@ int spi_bitbang_start(struct spi_bitbang *bitbang)
>  	return status;
>  
>  err2:
> -	destroy_workqueue(bitbang->workqueue);
> +	kthread_stop(bitbang->worker_task);
>  err1:
>  	return status;
>  }
> @@ -495,7 +498,7 @@ int spi_bitbang_stop(struct spi_bitbang *bitbang)
>  
>  	WARN_ON(!list_empty(&bitbang->queue));
>  
> -	destroy_workqueue(bitbang->workqueue);
> +	kthread_stop(bitbang->worker_task);
>  
>  	return 0;
>  }
> diff --git a/include/linux/spi/spi_bitbang.h b/include/linux/spi/spi_bitbang.h
> index f987a2b..36bb3be 100644
> --- a/include/linux/spi/spi_bitbang.h
> +++ b/include/linux/spi/spi_bitbang.h
> @@ -1,11 +1,12 @@
>  #ifndef	__SPI_BITBANG_H
>  #define	__SPI_BITBANG_H
>  
> -#include <linux/workqueue.h>
> +#include <linux/kthread.h>
>  
>  struct spi_bitbang {
> -	struct workqueue_struct	*workqueue;
> -	struct work_struct	work;
> +	struct kthread_worker	worker;
> +	struct task_struct	*worker_task;
> +	struct kthread_work	work;
>  
>  	spinlock_t		lock;
>  	struct list_head	queue;
> -- 
> 1.7.2.3
> 
> 
> ------------------------------------------------------------------------------
> The ultimate all-in-one performance toolkit: Intel(R) Parallel Studio XE:
> Pinpoint memory and threading errors before they happen.
> Find and fix more than 250 security defects in the development cycle.
> Locate bottlenecks in serial and parallel code that limit performance.
> http://p.sf.net/sfu/intel-dev2devfeb
> _______________________________________________
> spi-devel-general mailing list
> spi-devel-general@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/spi-devel-general

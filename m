Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab0GRHCe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 03:02:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55266 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab0GRHCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 03:02:32 -0400
Date: Sun, 18 Jul 2010 03:02:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 14/16] writeback: move bdi threads exiting logic to
 the forker thread
Message-ID: <20100718070231.GK23811@infradead.org>
References: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
 <1279284312-2411-15-git-send-email-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279284312-2411-15-git-send-email-dedekind1@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, only killing threads from the caller is much better, that's how
the kthread API is supposed to be used anyway.

>  static void bdi_queue_work(struct backing_dev_info *bdi,
>  		struct wb_writeback_work *work)
>  {
> +	bool wakeup_default = false;
> +
>  	trace_writeback_queue(bdi, work);
>  
>  	spin_lock(&bdi->wb_lock);
>  	list_add_tail(&work->list, &bdi->work_list);
> -	spin_unlock(&bdi->wb_lock);
> -
>  	/*
>  	 * If the default thread isn't there, make sure we add it. When
>  	 * it gets created and wakes up, we'll run this work.
>  	 */
> -	if (unlikely(!bdi->wb.task)) {
> +	if (unlikely(!bdi->wb.task))
> +		wakeup_default = true;
> +	else
> +		wake_up_process(bdi->wb.task);
> +	spin_unlock(&bdi->wb_lock);
> +
> +	if (wakeup_default) {
>  		trace_writeback_nothread(bdi, work);
>  		wake_up_process(default_backing_dev_info.wb.task);

Why not simply do the defaul thread wakeup under wb_lock, too?
It keeps the code a lot simpler, and this is not a typical path anyway.

>  		if (dirty_writeback_interval) {
> +			unsigned long wait_jiffies;
> +
>  			wait_jiffies = msecs_to_jiffies(dirty_writeback_interval * 10);
>  			schedule_timeout(wait_jiffies);

No real need for a local variable here.

> @@ -364,7 +395,7 @@ static int bdi_forker_thread(void *ptr)
>  		if (!list_empty(&me->bdi->work_list))
>  			__set_current_state(TASK_RUNNING);
>  
> -		if (!fork) {
> +		if (!fork && !kill) {

I think the code here would be a lot cleaner if you implement the
suggestion I have for the forking restructuring.


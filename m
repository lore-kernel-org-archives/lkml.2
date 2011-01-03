Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab1ACRGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 12:06:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331Ab1ACRGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 12:06:42 -0500
Date: Mon, 3 Jan 2011 18:06:16 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stanislaw Gruszka <stf_xl@wp.pl>,
        linux-usb@vger.kernel.org, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 20/32] video/msm_fb: use system_wq instead of dedicated
 workqueues
Message-ID: <20110103170615.GB2285@redhat.com>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-21-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294062595-30097-21-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 02:49:43PM +0100, Tejun Heo wrote:
> With cmwq, there's no reason to use separate workqueues.  Drop
> msmfb_info->resume_workqueue and use system_wq instead.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Stanislaw Gruszka <stf_xl@wp.pl>
I'm not the right person, CC according to MAINTAINERS

> Cc: linux-usb@vger.kernel.org
> ---
> Only compile tested.  Please feel free to take it into the subsystem
> tree or simply ack - I'll route it through the wq tree.
> 
> Thanks.
> 
>  drivers/video/msm/msm_fb.c |   11 +----------
>  1 files changed, 1 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/video/msm/msm_fb.c b/drivers/video/msm/msm_fb.c
> index debe593..5436aeb 100644
> --- a/drivers/video/msm/msm_fb.c
> +++ b/drivers/video/msm/msm_fb.c
> @@ -81,7 +81,6 @@ struct msmfb_info {
>  	spinlock_t update_lock;
>  	struct mutex panel_init_lock;
>  	wait_queue_head_t frame_wq;
> -	struct workqueue_struct *resume_workqueue;
>  	struct work_struct resume_work;
>  	struct msmfb_callback dma_callback;
>  	struct msmfb_callback vsync_callback;
> @@ -111,7 +110,7 @@ static void msmfb_handle_dma_interrupt(struct msmfb_callback *callback)
>  	if (msmfb->sleeping == UPDATING &&
>  	    msmfb->frame_done == msmfb->update_frame) {
>  		DLOG(SUSPEND_RESUME, "full update completed\n");
> -		queue_work(msmfb->resume_workqueue, &msmfb->resume_work);
> +		schedule_work(&msmfb->resume_work);
>  	}
>  	spin_unlock_irqrestore(&msmfb->update_lock, irq_flags);
>  	wake_up(&msmfb->frame_wq);
> @@ -559,12 +558,6 @@ static int msmfb_probe(struct platform_device *pdev)
>  	spin_lock_init(&msmfb->update_lock);
>  	mutex_init(&msmfb->panel_init_lock);
>  	init_waitqueue_head(&msmfb->frame_wq);
> -	msmfb->resume_workqueue = create_workqueue("panel_on");
> -	if (msmfb->resume_workqueue == NULL) {
> -		printk(KERN_ERR "failed to create panel_on workqueue\n");
> -		ret = -ENOMEM;
> -		goto error_create_workqueue;
> -	}
>  	INIT_WORK(&msmfb->resume_work, power_on_panel);
>  	msmfb->black = kzalloc(msmfb->fb->var.bits_per_pixel*msmfb->xres,
>  			       GFP_KERNEL);
> @@ -589,8 +582,6 @@ static int msmfb_probe(struct platform_device *pdev)
>  	return 0;
>  
>  error_register_framebuffer:
> -	destroy_workqueue(msmfb->resume_workqueue);
> -error_create_workqueue:
>  	iounmap(fb->screen_base);
>  error_setup_fbmem:
>  	framebuffer_release(msmfb->fb);
> -- 
> 1.7.1
> 
> 

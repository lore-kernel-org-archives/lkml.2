Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab2I0H0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:26:42 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38917 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979Ab2I0H0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:26:41 -0400
Date: Thu, 27 Sep 2012 00:23:59 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 30/57] power: ab8500: Flush & sync all works
Message-ID: <20120927072358.GL8836@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-31-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348589574-25655-31-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:12:27AM -0600, mathieu.poirier@linaro.org wrote:
> From: Jonas Aaberg <jonas.aberg@stericsson.com>
> 
> Flush and sync all workqueues at suspend to avoid
> that we suspend in the middle of a work.
> 
> Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
> ---
>  drivers/power/ab8500_charger.c |   11 +++++++++++
>  drivers/power/ab8500_fg.c      |    5 +++++
>  2 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
> index ee5ad7b..071c7c2 100644
> --- a/drivers/power/ab8500_charger.c
> +++ b/drivers/power/ab8500_charger.c
> @@ -2862,6 +2862,17 @@ static int ab8500_charger_suspend(struct platform_device *pdev,
>  	if (delayed_work_pending(&di->check_hw_failure_work))
>  		cancel_delayed_work(&di->check_hw_failure_work);
>  
> +	flush_delayed_work_sync(&di->attach_work);
> +	flush_delayed_work_sync(&di->usb_charger_attached_work);
> +	flush_delayed_work_sync(&di->ac_charger_attached_work);
> +	flush_delayed_work_sync(&di->check_usbchgnotok_work);
> +	flush_delayed_work_sync(&di->check_vbat_work);
> +	flush_delayed_work_sync(&di->kick_wd_work);
> +
> +	flush_work_sync(&di->usb_link_status_work);
> +	flush_work_sync(&di->ac_work);
> +	flush_work_sync(&di->detect_usb_type_work);

I belive each of these have to be added by the patches that add the
appropriate work structs. But really, it's better to avoid these many
delayed work.

>  	return 0;
>  }
>  #else
> diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
> index e7a0e1f..0e71e7e 100644
> --- a/drivers/power/ab8500_fg.c
> +++ b/drivers/power/ab8500_fg.c
> @@ -2626,6 +2626,11 @@ static int ab8500_fg_suspend(struct platform_device *pdev,
>  	struct ab8500_fg *di = platform_get_drvdata(pdev);
>  
>  	flush_delayed_work_sync(&di->fg_periodic_work);
> +	flush_work_sync(&di->fg_work);
> +	flush_work_sync(&di->fg_acc_cur_work);
> +	flush_delayed_work_sync(&di->fg_reinit_work);
> +	flush_delayed_work_sync(&di->fg_low_bat_work);
> +	flush_delayed_work_sync(&di->fg_check_hw_failure_work);
>  
>  	/*
>  	 * If the FG is enabled we will disable it before going to suspend
> -- 
> 1.7.5.4
> 
> 

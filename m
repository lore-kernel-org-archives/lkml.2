Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab0KVJ7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 04:59:36 -0500
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:64798 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750Ab0KVJ7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 04:59:35 -0500
Subject: Re: [PATCH] backlight: grab ops_lock before testing bd->ops
From: Richard Purdie <rpurdie@linux.intel.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        akpm <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de
In-Reply-To: <1290418989-27653-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1290418989-27653-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Nov 2010 09:59:07 +0000
Message-ID: <1290419947.1272.16677.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 10:43 +0100, Uwe Kleine-König wrote:
> According to the comment describing ops_lock in the definition of
> struct backlight_device and when comparing with other functions in
> backlight.c the mutex must be hold when checking ops to be non-NULL.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Acked-by: Richard Purdie <rpurdie@linux.intel.com>

> ---
>  drivers/video/backlight/backlight.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
> index e207810..0870329 100644
> --- a/drivers/video/backlight/backlight.c
> +++ b/drivers/video/backlight/backlight.c
> @@ -197,12 +197,12 @@ static int backlight_suspend(struct device *dev, pm_message_t state)
>  {
>  	struct backlight_device *bd = to_backlight_device(dev);
>  
> -	if (bd->ops->options & BL_CORE_SUSPENDRESUME) {
> -		mutex_lock(&bd->ops_lock);
> +	mutex_lock(&bd->ops_lock);
> +	if (bd->ops && bd->ops->options & BL_CORE_SUSPENDRESUME) {
>  		bd->props.state |= BL_CORE_SUSPENDED;
>  		backlight_update_status(bd);
> -		mutex_unlock(&bd->ops_lock);
>  	}
> +	mutex_unlock(&bd->ops_lock);
>  
>  	return 0;
>  }
> @@ -211,12 +211,12 @@ static int backlight_resume(struct device *dev)
>  {
>  	struct backlight_device *bd = to_backlight_device(dev);
>  
> -	if (bd->ops->options & BL_CORE_SUSPENDRESUME) {
> -		mutex_lock(&bd->ops_lock);
> +	mutex_lock(&bd->ops_lock);
> +	if (bd->ops && bd->ops->options & BL_CORE_SUSPENDRESUME) {
>  		bd->props.state &= ~BL_CORE_SUSPENDED;
>  		backlight_update_status(bd);
> -		mutex_unlock(&bd->ops_lock);
>  	}
> +	mutex_unlock(&bd->ops_lock);
>  
>  	return 0;
>  }



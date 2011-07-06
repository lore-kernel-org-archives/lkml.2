Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab1GFUDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 16:03:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34518 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770Ab1GFUDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 16:03:09 -0400
Date: Wed, 6 Jul 2011 13:03:02 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, Misael Lopez Cruz <misael.lopez@ti.com>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v3 2/5] input: twl6040-vibra: Do not use wrapper for irq
 request
Message-ID: <20110706200302.GC6086@core.coreip.homeip.net>
References: <1309895376-17446-1-git-send-email-peter.ujfalusi@ti.com>
 <1309895376-17446-3-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309895376-17446-3-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 10:49:33PM +0300, Peter Ujfalusi wrote:
> The twl6040_request_irq/free_irq inline functions are going
> to be removed, so replace them with direct calls.
> The irq number is provided by the core driver via resource.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Acked-by: Dmitry Torokhov <dtormail.ru>

> ---
>  drivers/input/misc/twl6040-vibra.c |   17 ++++++++++++-----
>  1 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/input/misc/twl6040-vibra.c b/drivers/input/misc/twl6040-vibra.c
> index dbf745d..c43002e 100644
> --- a/drivers/input/misc/twl6040-vibra.c
> +++ b/drivers/input/misc/twl6040-vibra.c
> @@ -47,6 +47,7 @@ struct vibra_info {
>  	struct workqueue_struct *workqueue;
>  	struct work_struct play_work;
>  	struct mutex mutex;
> +	int irq;
>  
>  	bool enabled;
>  	int weak_speed;
> @@ -277,6 +278,13 @@ static int __devinit twl6040_vibra_probe(struct platform_device *pdev)
>  		goto err_kzalloc;
>  	}
>  
> +	info->irq = platform_get_irq(pdev, 0);
> +	if (info->irq < 0) {
> +		dev_err(info->dev, "invalid irq\n");
> +		ret = -EINVAL;
> +		goto err_kzalloc;
> +	}
> +
>  	mutex_init(&info->mutex);
>  
>  	info->input_dev = input_allocate_device();
> @@ -308,9 +316,8 @@ static int __devinit twl6040_vibra_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, info);
>  
> -	ret = twl6040_request_irq(info->twl6040, TWL6040_IRQ_VIB,
> -				  twl6040_vib_irq_handler, 0,
> -				  "twl6040_irq_vib", info);
> +	ret = request_threaded_irq(info->irq, NULL, twl6040_vib_irq_handler, 0,
> +				   "twl6040_irq_vib", info);
>  	if (ret) {
>  		dev_err(info->dev, "VIB IRQ request failed: %d\n", ret);
>  		goto err_irq;
> @@ -360,7 +367,7 @@ static int __devinit twl6040_vibra_probe(struct platform_device *pdev)
>  err_voltage:
>  	regulator_bulk_free(ARRAY_SIZE(info->supplies), info->supplies);
>  err_regulator:
> -	twl6040_free_irq(info->twl6040, TWL6040_IRQ_VIB, info);
> +	free_irq(info->irq, info);
>  err_irq:
>  	input_unregister_device(info->input_dev);
>  	info->input_dev = NULL;
> @@ -379,7 +386,7 @@ static int __devexit twl6040_vibra_remove(struct platform_device *pdev)
>  	struct vibra_info *info = platform_get_drvdata(pdev);
>  
>  	input_unregister_device(info->input_dev);
> -	twl6040_free_irq(info->twl6040, TWL6040_IRQ_VIB, info);
> +	free_irq(info->irq, info);
>  	regulator_bulk_free(ARRAY_SIZE(info->supplies), info->supplies);
>  	destroy_workqueue(info->workqueue);
>  	kfree(info);
> -- 
> 1.7.6
> 

-- 
Dmitry

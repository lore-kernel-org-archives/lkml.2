Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab0HBKFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 06:05:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:57775 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab0HBKFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 06:05:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,302,1278313200"; 
   d="scan'208";a="591999094"
Date: Mon, 2 Aug 2010 12:04:56 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Tejun Heo <tj@kernel.org>, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH 2/2] hwmon/mc13783-adc: don't access struct mc13783
 directly
Message-ID: <20100802100455.GC3334@sortiz-mobl>
References: <1280740459-11500-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1280740459-11500-2-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1280740459-11500-2-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Mon, Aug 02, 2010 at 11:14:18AM +0200, Uwe Kleine-König wrote:
> There is a shiny new mc13783 API function that can be used instead.
> 
> While at it refactor the code a bit to reduce code duplication a bit.
> 
> This removes the last user of <linux/mfd/mc13783-private.h> and so this
> include file can go away.
That's correct, patch applied.
As I said, we can now move mc13783-private.h to drivers/mfd/

Cheers,
Samuel.


> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/hwmon/mc13783-adc.c |   17 +++++++++++++----
>  1 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/hwmon/mc13783-adc.c b/drivers/hwmon/mc13783-adc.c
> index ce3c7bc..d5226c9 100644
> --- a/drivers/hwmon/mc13783-adc.c
> +++ b/drivers/hwmon/mc13783-adc.c
> @@ -18,7 +18,7 @@
>   * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
>   */
>  
> -#include <linux/mfd/mc13783-private.h>
> +#include <linux/mfd/mc13783.h>
>  #include <linux/platform_device.h>
>  #include <linux/hwmon-sysfs.h>
>  #include <linux/kernel.h>
> @@ -144,6 +144,14 @@ static const struct attribute_group mc13783_group_ts = {
>  	.attrs = mc13783_attr_ts,
>  };
>  
> +static int mc13783_adc_use_touchscreen(struct platform_device *pdev)
> +{
> +	struct mc13783_adc_priv *priv = platform_get_drvdata(pdev);
> +	unsigned flags = mc13783_get_flags(priv->mc13783);
> +
> +	return flags & MC13783_USE_TOUCHSCREEN;
> +}
> +
>  static int __init mc13783_adc_probe(struct platform_device *pdev)
>  {
>  	struct mc13783_adc_priv *priv;
> @@ -162,10 +170,11 @@ static int __init mc13783_adc_probe(struct platform_device *pdev)
>  	if (ret)
>  		goto out_err_create1;
>  
> -	if (!(priv->mc13783->flags & MC13783_USE_TOUCHSCREEN))
> +	if (!mc13783_adc_use_touchscreen(pdev)) {
>  		ret = sysfs_create_group(&pdev->dev.kobj, &mc13783_group_ts);
>  		if (ret)
>  			goto out_err_create2;
> +	}
>  
>  	priv->hwmon_dev = hwmon_device_register(&pdev->dev);
>  	if (IS_ERR(priv->hwmon_dev)) {
> @@ -180,7 +189,7 @@ static int __init mc13783_adc_probe(struct platform_device *pdev)
>  
>  out_err_register:
>  
> -	if (!(priv->mc13783->flags & MC13783_USE_TOUCHSCREEN))
> +	if (!mc13783_adc_use_touchscreen(pdev))
>  		sysfs_remove_group(&pdev->dev.kobj, &mc13783_group_ts);
>  out_err_create2:
>  
> @@ -199,7 +208,7 @@ static int __devexit mc13783_adc_remove(struct platform_device *pdev)
>  
>  	hwmon_device_unregister(priv->hwmon_dev);
>  
> -	if (!(priv->mc13783->flags & MC13783_USE_TOUCHSCREEN))
> +	if (!mc13783_adc_use_touchscreen(pdev))
>  		sysfs_remove_group(&pdev->dev.kobj, &mc13783_group_ts);
>  
>  	sysfs_remove_group(&pdev->dev.kobj, &mc13783_group);
> -- 
> 1.7.1
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

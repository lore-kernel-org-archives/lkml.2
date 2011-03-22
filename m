Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab1CVXar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:30:47 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60445 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab1CVXaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:30:46 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6293"; a="81272993"
Message-ID: <4D893125.3030703@codeaurora.org>
Date: Tue, 22 Mar 2011 16:30:45 -0700
From: David Collins <collinsd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Deadlock scenario in regulator core
References: <4D891C59.1030009@codeaurora.org> <20110322223156.GA10782@opensource.wolfsonmicro.com>
In-Reply-To: <20110322223156.GA10782@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2011 03:31 PM, Mark Brown wrote:
> No need to hold the child lock, when we take the reference on the supply
> we own the reference.  It's just that the systems which need to use
> daisychained regulators (mostly a DCDC to power LDOs for better
> efficiency) are moderately rare and tend to not bother representing the
> supply relationship as the parent regulator tends to be always on.
> 
> In fact it looks rather like the refcounting for supplies is wrong
> anyway, regulator_disable() unconditionally drops references to supplies
> but regulator_enable() only enables them if the refcount was previously
> zero, and it appears we don't clean up supplies after failed enables.
> The below patch (which I've not even compile tested) should resolve both
> issues, could you give it a spin and let me know if it works for you
> please?
> 
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index 3ffc697..0a7fbde 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -1284,19 +1284,6 @@ static int _regulator_enable(struct regulator_dev *rdev)
>  {
>  	int ret, delay;
>  
> -	if (rdev->use_count == 0) {
> -		/* do we need to enable the supply regulator first */
> -		if (rdev->supply) {
> -			mutex_lock(&rdev->supply->mutex);
> -			ret = _regulator_enable(rdev->supply);
> -			mutex_unlock(&rdev->supply->mutex);
> -			if (ret < 0) {
> -				rdev_err(rdev, "failed to enable: %d\n", ret);
> -				return ret;
> -			}
> -		}
> -	}
> -
>  	/* check voltage and requested load before enabling */
>  	if (rdev->constraints &&
>  	    (rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_DRMS))
> @@ -1370,10 +1357,27 @@ int regulator_enable(struct regulator *regulator)
>  {
>  	struct regulator_dev *rdev = regulator->rdev;
>  	int ret = 0;
> +	int disret;
> +
> +	if (rdev->supply) {
> +		ret = regulator_enable(rdev->supply);

This should be _regulator_enable instead of regulator_enable.  There will
also need to be a mutex lock and unlock around it for rdev->supply->mutex.
 I think that it needs to iterate through all supplies in the chain
similar to how it is done in regulator_disable.

> +		if (ret < 0) {
> +			rdev_err(rdev, "failed to enable supply: %d\n", ret);
> +			return ret;
> +		}
> +	}
>  
>  	mutex_lock(&rdev->mutex);
>  	ret = _regulator_enable(rdev);
>  	mutex_unlock(&rdev->mutex);
> +
> +	if (ret != 0 && rdev->supply) {
> +		disret = regulator_disable(rdev->supply);

This should be _regulator_disable instead of regulator_disable.  There
will also need to be a mutex lock and unlock around it for
rdev->supply->mutex.  Additionally, a while loop is needed to disable all
supplies in the chain (same as in regulator_disable).


> +		if (disret < 0)
> +			rdev_err(rdev, "failed to disable supply: %d\n",
> +				 disret);
> +	}
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(regulator_enable);

This patch doesn't compile.  A few changes are needed.

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

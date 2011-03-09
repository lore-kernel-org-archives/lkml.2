Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab1CIIDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 03:03:52 -0500
Received: from compulab.co.il ([67.18.134.219]:58371 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab1CIIDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 03:03:51 -0500
Message-ID: <4D77345F.8040706@compulab.co.il>
Date: Wed, 09 Mar 2011 10:03:43 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.13) Gecko/20101211 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: MyungJoo Ham <myungjoo.ham@samsung.com>
CC: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Subject: Re: [PATCH v2] Regulator: add suspend-finish API for regulator core.
References: <20110308133817.GE20944@opensource.wolfsonmicro.com> <1299638225-29162-1-git-send-email-myungjoo.ham@samsung.com>
In-Reply-To: <1299638225-29162-1-git-send-email-myungjoo.ham@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


just a minor comment issue...


On 03/09/11 04:37, MyungJoo Ham wrote:

> The regulator core had suspend-prepare that turns off the regulators
> when entering a system-wide suspend. However, it did not have
> suspend-finish that pairs with suspend-prepare and the regulator core
> has assumed that the regulator devices and their drivers support
> autonomous recover at resume.
>
> This patch adds regulator_suspend_finish that pairs with the
> previously-existed regulator_suspend_prepare. The function
> regulator_suspend_finish turns on the regulators that have always_on set
> or positive use_count so that we can reset the regulator states
> appropriately at resume.
>
> In regulator_suspend_finish, if has_full_constraints, it disables
> unnecessary regulators.
>
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/regulator/core.c          |   40 +++++++++++++++++++++++++++++++++++++
>  include/linux/regulator/machine.h |    1 +
>  2 files changed, 41 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index 9fa2095..4d34cc0 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -2653,6 +2653,46 @@ out:
>  EXPORT_SYMBOL_GPL(regulator_suspend_prepare);
>  
>  /**
> + * regulator_suspend_prepare - resume regulators from system wide suspend

s/prepare/finish/

> + *
> + * Turn on regulators that might be turned off by regulator_suspend_prepare.
> + */
> +int regulator_suspend_finish(void)
> +{
> +	struct regulator_dev *rdev;
> +	int ret = 0, error;
> +
> +	mutex_lock(&regulator_list_mutex);
> +	list_for_each_entry(rdev, &regulator_list, list) {
> +		struct regulator_ops *ops = rdev->desc->ops;
> +
> +		mutex_lock(&rdev->mutex);
> +		if ((rdev->use_count > 0  || rdev->constraints->always_on) &&
> +				ops->enable) {
> +			error = ops->enable(rdev);
> +			if (error)
> +				ret = error;
> +		} else {
> +			if (!has_full_constraints)
> +				goto unlock;
> +			if (!ops->disable)
> +				goto unlock;
> +			if (ops->is_enabled && !ops->is_enabled(rdev))
> +				goto unlock;
> +
> +			error = ops->disable(rdev);
> +			if (error)
> +				ret = error;
> +		}
> +unlock:
> +		mutex_unlock(&rdev->mutex);
> +	}
> +	mutex_unlock(&regulator_list_mutex);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(regulator_suspend_finish);
> +
> +/**
>   * regulator_has_full_constraints - the system has fully specified constraints
>   *
>   * Calling this function will cause the regulator API to disable all
> diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
> index 761c745..c4c4fc4 100644
> --- a/include/linux/regulator/machine.h
> +++ b/include/linux/regulator/machine.h
> @@ -186,6 +186,7 @@ struct regulator_init_data {
>  };
>  
>  int regulator_suspend_prepare(suspend_state_t state);
> +int regulator_suspend_finish(void);
>  
>  #ifdef CONFIG_REGULATOR
>  void regulator_has_full_constraints(void);

-- 
Regards,
Igor.


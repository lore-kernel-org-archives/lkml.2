Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab0KRAgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 19:36:55 -0500
Received: from mail.perches.com ([173.55.12.10]:1519 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab0KRAgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 19:36:54 -0500
Subject: Re: [PATCH 2/2] drivers: regulator: core: convert to using pr_
 macros
From: Joe Perches <joe@perches.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, bleong@codeaurora.org
In-Reply-To: <1290036628-9928-2-git-send-email-dwalker@codeaurora.org>
References: <1290036628-9928-1-git-send-email-dwalker@codeaurora.org>
	 <1290036628-9928-2-git-send-email-dwalker@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 16:36:51 -0800
Message-ID: <1290040611.28741.332.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 15:30 -0800, Daniel Walker wrote:
> The regulator framework uses a lot of printks with a
> specific formatting using __func__. This converts them
> to use pr_ calls with a central format string.
[]
>  drivers/regulator/core.c |  131 +++++++++++++++++++---------------------------
>  1 files changed, 54 insertions(+), 77 deletions(-)
> 
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index a3ca3d6..67cae17 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
[]
> @@ -113,13 +113,11 @@ static int regulator_check_voltage(struct regulator_dev *rdev,
>  	BUG_ON(*min_uV > *max_uV);
>  
>  	if (!rdev->constraints) {
> -		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
> -		       rdev_get_name(rdev));
> +		pr_err("no constraints for %s\n", rdev_get_name(rdev));
>  		return -ENODEV;

Hi Daniel.

I think it'd be better to introduce and use:

#define rdev_err(rdev, fmt, ...)
	pr_err("%s: " fmt, rdev_get_name(rdev), ##__VA_ARGS__);
#define rdev_warn(rdev, fmt, ...)
	pr_warn("%s: " fmt, rdev_get_name(rdev), ##__VA_ARGS__);
#define rdev_info(rdev, fmt, ...)
	pr_info("%s: " fmt, rdev_get_name(rdev), ##__VA_ARGS__);

There are some pr_<level> uses without any rdev_get_name(rdev),
but wherever an rdev is available, I'd use it.

cheers, Joe

(rest of original patch below, but no additional comments)

>  	}
>  	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE)) {
> -		printk(KERN_ERR "%s: operation not allowed for %s\n",
> -		       __func__, rdev_get_name(rdev));
> +		pr_err("operation not allowed for %s\n", rdev_get_name(rdev));
>  		return -EPERM;
>  	}
>  
> @@ -141,13 +139,11 @@ static int regulator_check_current_limit(struct regulator_dev *rdev,
>  	BUG_ON(*min_uA > *max_uA);
>  
>  	if (!rdev->constraints) {
> -		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
> -		       rdev_get_name(rdev));
> +		pr_err("no constraints for %s\n", rdev_get_name(rdev));
>  		return -ENODEV;
>  	}
>  	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_CURRENT)) {
> -		printk(KERN_ERR "%s: operation not allowed for %s\n",
> -		       __func__, rdev_get_name(rdev));
> +		pr_err("operation not allowed for %s\n", rdev_get_name(rdev));
>  		return -EPERM;
>  	}
>  
> @@ -176,18 +172,15 @@ static int regulator_check_mode(struct regulator_dev *rdev, int mode)
>  	}
>  
>  	if (!rdev->constraints) {
> -		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
> -		       rdev_get_name(rdev));
> +		pr_err("no constraints for %s\n", rdev_get_name(rdev));
>  		return -ENODEV;
>  	}
>  	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_MODE)) {
> -		printk(KERN_ERR "%s: operation not allowed for %s\n",
> -		       __func__, rdev_get_name(rdev));
> +		pr_err("operation not allowed for %s\n", rdev_get_name(rdev));
>  		return -EPERM;
>  	}
>  	if (!(rdev->constraints->valid_modes_mask & mode)) {
> -		printk(KERN_ERR "%s: invalid mode %x for %s\n",
> -		       __func__, mode, rdev_get_name(rdev));
> +		pr_err("invalid mode %x for %s\n", mode, rdev_get_name(rdev));
>  		return -EINVAL;
>  	}
>  	return 0;
> @@ -197,13 +190,11 @@ static int regulator_check_mode(struct regulator_dev *rdev, int mode)
>  static int regulator_check_drms(struct regulator_dev *rdev)
>  {
>  	if (!rdev->constraints) {
> -		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
> -		       rdev_get_name(rdev));
> +		pr_err("no constraints for %s\n", rdev_get_name(rdev));
>  		return -ENODEV;
>  	}
>  	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_DRMS)) {
> -		printk(KERN_ERR "%s: operation not allowed for %s\n",
> -		       __func__, rdev_get_name(rdev));
> +		pr_err("operation not allowed for %s\n", rdev_get_name(rdev));
>  		return -EPERM;
>  	}
>  	return 0;
> @@ -600,20 +591,18 @@ static int suspend_set_state(struct regulator_dev *rdev,
>  	 */
>  	if (!rstate->enabled && !rstate->disabled) {
>  		if (can_set_state)
> -			printk(KERN_WARNING "%s: No configuration for %s\n",
> -			       __func__, rdev_get_name(rdev));
> +			pr_warning("No configuration for %s\n",
> +				   rdev_get_name(rdev));
>  		return 0;
>  	}
>  
>  	if (rstate->enabled && rstate->disabled) {
> -		printk(KERN_ERR "%s: invalid configuration for %s\n",
> -		       __func__, rdev_get_name(rdev));
> +		pr_err("invalid configuration for %s\n", rdev_get_name(rdev));
>  		return -EINVAL;
>  	}
>  
>  	if (!can_set_state) {
> -		printk(KERN_ERR "%s: no way to set suspend state\n",
> -			__func__);
> +		pr_err("no way to set suspend state\n");
>  		return -EINVAL;
>  	}
>  
> @@ -622,15 +611,14 @@ static int suspend_set_state(struct regulator_dev *rdev,
>  	else
>  		ret = rdev->desc->ops->set_suspend_disable(rdev);
>  	if (ret < 0) {
> -		printk(KERN_ERR "%s: failed to enabled/disable\n", __func__);
> +		pr_err("failed to enabled/disable\n");
>  		return ret;
>  	}
>  
>  	if (rdev->desc->ops->set_suspend_voltage && rstate->uV > 0) {
>  		ret = rdev->desc->ops->set_suspend_voltage(rdev, rstate->uV);
>  		if (ret < 0) {
> -			printk(KERN_ERR "%s: failed to set voltage\n",
> -				__func__);
> +			pr_err("failed to set voltage\n");
>  			return ret;
>  		}
>  	}
> @@ -638,7 +626,7 @@ static int suspend_set_state(struct regulator_dev *rdev,
>  	if (rdev->desc->ops->set_suspend_mode && rstate->mode > 0) {
>  		ret = rdev->desc->ops->set_suspend_mode(rdev, rstate->mode);
>  		if (ret < 0) {
> -			printk(KERN_ERR "%s: failed to set mode\n", __func__);
> +			pr_err("failed to set mode\n");
>  			return ret;
>  		}
>  	}
> @@ -733,9 +721,8 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
>  		ret = ops->set_voltage(rdev,
>  			rdev->constraints->min_uV, rdev->constraints->max_uV);
>  			if (ret < 0) {
> -				printk(KERN_ERR "%s: failed to apply %duV constraint to %s\n",
> -				       __func__,
> -				       rdev->constraints->min_uV, name);
> +				pr_err("failed to apply %duV constraint to %s\n",
> +					rdev->constraints->min_uV, name);
>  				rdev->constraints = NULL;
>  				return ret;
>  			}
> @@ -842,8 +829,8 @@ static int set_machine_constraints(struct regulator_dev *rdev,
>  	if (constraints->initial_state) {
>  		ret = suspend_prepare(rdev, constraints->initial_state);
>  		if (ret < 0) {
> -			printk(KERN_ERR "%s: failed to set suspend state for %s\n",
> -			       __func__, name);
> +			pr_err("failed to set suspend state for %s\n",
> +				name);
>  			rdev->constraints = NULL;
>  			goto out;
>  		}
> @@ -851,17 +838,16 @@ static int set_machine_constraints(struct regulator_dev *rdev,
>  
>  	if (constraints->initial_mode) {
>  		if (!ops->set_mode) {
> -			printk(KERN_ERR "%s: no set_mode operation for %s\n",
> -			       __func__, name);
> +			pr_err("no set_mode operation for %s\n",
> +				name);
>  			ret = -EINVAL;
>  			goto out;
>  		}
>  
>  		ret = ops->set_mode(rdev, constraints->initial_mode);
>  		if (ret < 0) {
> -			printk(KERN_ERR
> -			       "%s: failed to set initial mode for %s: %d\n",
> -			       __func__, name, ret);
> +			pr_err("failed to set initial mode for %s: %d\n",
> +				name, ret);
>  			goto out;
>  		}
>  	}
> @@ -872,8 +858,7 @@ static int set_machine_constraints(struct regulator_dev *rdev,
>  	if ((constraints->always_on || constraints->boot_on) && ops->enable) {
>  		ret = ops->enable(rdev);
>  		if (ret < 0) {
> -			printk(KERN_ERR "%s: failed to enable %s\n",
> -			       __func__, name);
> +			pr_err("failed to enable %s\n", name);
>  			rdev->constraints = NULL;
>  			goto out;
>  		}
> @@ -901,9 +886,8 @@ static int set_supply(struct regulator_dev *rdev,
>  	err = sysfs_create_link(&rdev->dev.kobj, &supply_rdev->dev.kobj,
>  				"supply");
>  	if (err) {
> -		printk(KERN_ERR
> -		       "%s: could not add device link %s err %d\n",
> -		       __func__, supply_rdev->dev.kobj.name, err);
> +		pr_err("could not add device link %s err %d\n",
> +			supply_rdev->dev.kobj.name, err);
>  		       goto out;
>  	}
>  	rdev->supply = supply_rdev;
> @@ -1051,9 +1035,8 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
>  		err = sysfs_create_link(&rdev->dev.kobj, &dev->kobj,
>  					buf);
>  		if (err) {
> -			printk(KERN_WARNING
> -			       "%s: could not add device link %s err %d\n",
> -			       __func__, dev->kobj.name, err);
> +			pr_warning("could not add device link %s err %d\n",
> +				   dev->kobj.name, err);
>  			device_remove_file(dev, &regulator->dev_attr);
>  			goto link_name_err;
>  		}
> @@ -1274,8 +1257,8 @@ static int _regulator_enable(struct regulator_dev *rdev)
>  	if (rdev->supply) {
>  		ret = _regulator_enable(rdev->supply);
>  		if (ret < 0) {
> -			printk(KERN_ERR "%s: failed to enable %s: %d\n",
> -			       __func__, rdev_get_name(rdev), ret);
> +			pr_err("failed to enable %s: %d\n",
> +				rdev_get_name(rdev), ret);
>  			return ret;
>  		}
>  	}
> @@ -1301,10 +1284,9 @@ static int _regulator_enable(struct regulator_dev *rdev)
>  			if (ret >= 0) {
>  				delay = ret;
>  			} else {
> -				printk(KERN_WARNING
> -					"%s: enable_time() failed for %s: %d\n",
> -					__func__, rdev_get_name(rdev),
> -					ret);
> +				pr_warning("enable_time() failed for %s: %d\n",
> +					   rdev_get_name(rdev),
> +					   ret);
>  				delay = 0;
>  			}
>  
> @@ -1321,8 +1303,8 @@ static int _regulator_enable(struct regulator_dev *rdev)
>  				udelay(delay);
>  
>  		} else if (ret < 0) {
> -			printk(KERN_ERR "%s: is_enabled() failed for %s: %d\n",
> -			       __func__, rdev_get_name(rdev), ret);
> +			pr_err("is_enabled() failed for %s: %d\n",
> +				rdev_get_name(rdev), ret);
>  			return ret;
>  		}
>  		/* Fallthrough on positive return values - already enabled */
> @@ -1376,8 +1358,8 @@ static int _regulator_disable(struct regulator_dev *rdev,
>  		    rdev->desc->ops->disable) {
>  			ret = rdev->desc->ops->disable(rdev);
>  			if (ret < 0) {
> -				printk(KERN_ERR "%s: failed to disable %s\n",
> -				       __func__, rdev_get_name(rdev));
> +				pr_err("failed to disable %s\n",
> +					rdev_get_name(rdev));
>  				return ret;
>  			}
>  
> @@ -1447,8 +1429,8 @@ static int _regulator_force_disable(struct regulator_dev *rdev,
>  		/* ah well, who wants to live forever... */
>  		ret = rdev->desc->ops->disable(rdev);
>  		if (ret < 0) {
> -			printk(KERN_ERR "%s: failed to force disable %s\n",
> -			       __func__, rdev_get_name(rdev));
> +			pr_err("failed to force disable %s\n",
> +				rdev_get_name(rdev));
>  			return ret;
>  		}
>  		/* notify other consumers that power has been forced off */
> @@ -1878,8 +1860,8 @@ int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
>  	/* get output voltage */
>  	output_uV = rdev->desc->ops->get_voltage(rdev);
>  	if (output_uV <= 0) {
> -		printk(KERN_ERR "%s: invalid output voltage found for %s\n",
> -			__func__, rdev_get_name(rdev));
> +		pr_err("invalid output voltage found for %s\n",
> +			rdev_get_name(rdev));
>  		goto out;
>  	}
>  
> @@ -1889,8 +1871,8 @@ int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
>  	else
>  		input_uV = rdev->constraints->input_uV;
>  	if (input_uV <= 0) {
> -		printk(KERN_ERR "%s: invalid input voltage found for %s\n",
> -			__func__, rdev_get_name(rdev));
> +		pr_err("invalid input voltage found for %s\n",
> +			rdev_get_name(rdev));
>  		goto out;
>  	}
>  
> @@ -1903,16 +1885,16 @@ int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
>  						 total_uA_load);
>  	ret = regulator_check_mode(rdev, mode);
>  	if (ret < 0) {
> -		printk(KERN_ERR "%s: failed to get optimum mode for %s @"
> -			" %d uA %d -> %d uV\n", __func__, rdev_get_name(rdev),
> +		pr_err("failed to get optimum mode for %s @"
> +			" %d uA %d -> %d uV\n",  rdev_get_name(rdev),
>  			total_uA_load, input_uV, output_uV);
>  		goto out;
>  	}
>  
>  	ret = rdev->desc->ops->set_mode(rdev, mode);
>  	if (ret < 0) {
> -		printk(KERN_ERR "%s: failed to set optimum mode %x for %s\n",
> -			__func__, mode, rdev_get_name(rdev));
> +		pr_err("failed to set optimum mode %x for %s\n",
> +			 mode, rdev_get_name(rdev));
>  		goto out;
>  	}
>  	ret = mode;
> @@ -2459,8 +2441,7 @@ int regulator_suspend_prepare(suspend_state_t state)
>  		mutex_unlock(&rdev->mutex);
>  
>  		if (ret < 0) {
> -			printk(KERN_ERR "%s: failed to prepare %s\n",
> -				__func__, rdev_get_name(rdev));
> +			pr_err("failed to prepare %s\n", rdev_get_name(rdev));
>  			goto out;
>  		}
>  	}
> @@ -2618,13 +2599,10 @@ static int __init regulator_init_complete(void)
>  		if (has_full_constraints) {
>  			/* We log since this may kill the system if it
>  			 * goes wrong. */
> -			printk(KERN_INFO "%s: disabling %s\n",
> -			       __func__, name);
> +			pr_info("disabling %s\n", name);
>  			ret = ops->disable(rdev);
>  			if (ret != 0) {
> -				printk(KERN_ERR
> -				       "%s: couldn't disable %s: %d\n",
> -				       __func__, name, ret);
> +				pr_err("couldn't disable %s: %d\n", name, ret);
>  			}
>  		} else {
>  			/* The intention is that in future we will
> @@ -2632,9 +2610,8 @@ static int __init regulator_init_complete(void)
>  			 * so warn even if we aren't going to do
>  			 * anything here.
>  			 */
> -			printk(KERN_WARNING
> -			       "%s: incomplete constraints, leaving %s on\n",
> -			       __func__, name);
> +			pr_warning("incomplete constraints, leaving %s on\n",
> +				   name);
>  		}
>  
>  unlock:




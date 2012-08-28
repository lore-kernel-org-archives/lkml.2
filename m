Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab2H1HiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 03:38:11 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:51289 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666Ab2H1HiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 03:38:01 -0400
Message-ID: <503C7556.1010802@slimlogic.co.uk>
Date: Tue, 28 Aug 2012 09:37:58 +0200
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] regulator: core: Support bypass mode
References: <1346128294-26652-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1346128294-26652-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Mark,

Series looks good to me and works for the palmas. I can now add the
bypass support without the side hack I currently have to do it.

Reviewed-by: Graeme Gregory <gg@slimlogic.co.uk>

On 28/08/12 06:31, Mark Brown wrote:
> Many regulators support a bypass mode where they simply switch their
> input supply to the output. This is mainly used in low power retention
> states where power consumption is extremely low so higher voltage or
> less clean supplies can be used.
>
> This is not supported as a mode since the existing modes are rarely used
> due to fuzzy definition and mostly redundant with modern hardware which is
> able to respond promptly to load changes.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  Documentation/ABI/testing/sysfs-class-regulator |   21 ++++++
>  drivers/regulator/core.c                        |   84 +++++++++++++++++++++++
>  include/linux/regulator/consumer.h              |    8 +++
>  include/linux/regulator/driver.h                |   10 +++
>  include/linux/regulator/machine.h               |    2 +
>  5 files changed, 125 insertions(+)
>
> diff --git a/Documentation/ABI/testing/sysfs-class-regulator b/Documentation/ABI/testing/sysfs-class-regulator
> index e091fa8..bc578bc 100644
> --- a/Documentation/ABI/testing/sysfs-class-regulator
> +++ b/Documentation/ABI/testing/sysfs-class-regulator
> @@ -349,3 +349,24 @@ Description:
>  
>  		This will be one of the same strings reported by
>  		the "state" attribute.
> +
> +What:		/sys/class/regulator/.../bypass
> +Date:		September 2012
> +KernelVersion:	3.7
> +Contact:	Mark Brown <broonie@opensource.wolfsonmicro.com>
> +Description:
> +		Some regulator directories will contain a field called
> +		bypass.  This indicates if the device is in bypass mode.
> +
> +		This will be one of the following strings:
> +
> +		'enabled'
> +		'disabled'
> +		'unknown'
> +
> +		'enabled' means the regulator is in bypass mode.
> +
> +		'disabled' means that the regulator is regulating.
> +
> +		'unknown' means software cannot determine the state, or
> +		the reported state is invalid.
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index db7d59a..d06a82e 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -77,6 +77,7 @@ struct regulator {
>  	struct device *dev;
>  	struct list_head list;
>  	unsigned int always_on:1;
> +	unsigned int bypass:1;
>  	int uA_load;
>  	int min_uV;
>  	int max_uV;
> @@ -394,6 +395,9 @@ static ssize_t regulator_status_show(struct device *dev,
>  	case REGULATOR_STATUS_STANDBY:
>  		label = "standby";
>  		break;
> +	case REGULATOR_STATUS_BYPASS:
> +		label = "bypass";
> +		break;
>  	case REGULATOR_STATUS_UNDEFINED:
>  		label = "undefined";
>  		break;
> @@ -585,6 +589,27 @@ static ssize_t regulator_suspend_standby_state_show(struct device *dev,
>  static DEVICE_ATTR(suspend_standby_state, 0444,
>  		regulator_suspend_standby_state_show, NULL);
>  
> +static ssize_t regulator_bypass_show(struct device *dev,
> +				     struct device_attribute *attr, char *buf)
> +{
> +	struct regulator_dev *rdev = dev_get_drvdata(dev);
> +	const char *report;
> +	bool bypass;
> +	int ret;
> +
> +	ret = rdev->desc->ops->get_bypass(rdev, &bypass);
> +
> +	if (ret != 0)
> +		report = "unknown";
> +	else if (bypass)
> +		report = "enabled";
> +	else
> +		report = "disabled";
> +
> +	return sprintf(buf, "%s\n", report);
> +}
> +static DEVICE_ATTR(bypass, 0444,
> +		   regulator_bypass_show, NULL);
>  
>  /*
>   * These are the only attributes are present for all regulators.
> @@ -2683,6 +2708,58 @@ out:
>  EXPORT_SYMBOL_GPL(regulator_set_optimum_mode);
>  
>  /**
> + * regulator_allow_bypass - allow the regulator to go into bypass mode
> + *
> + * @regulator: Regulator to configure
> + * @allow: enable or disable bypass mode
> + *
> + * Allow the regulator to go into bypass mode if all other consumers
> + * for the regulator also enable bypass mode and the machine
> + * constraints allow this.  Bypass mode means that the regulator is
> + * simply passing the input directly to the output with no regulation.
> + */
> +int regulator_allow_bypass(struct regulator *regulator, bool enable)
> +{
> +	struct regulator_dev *rdev = regulator->rdev;
> +	int ret = 0;
> +
> +	if (!rdev->desc->ops->set_bypass)
> +		return 0;
> +
> +	if (rdev->constraints &&
> +	    !(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_BYPASS))
> +		return 0;
> +
> +	mutex_lock(&rdev->mutex);
> +
> +	if (enable && !regulator->bypass) {
> +		rdev->bypass_count++;
> +
> +		if (rdev->bypass_count == rdev->open_count) {
> +			ret = rdev->desc->ops->set_bypass(rdev, enable);
> +			if (ret != 0)
> +				rdev->bypass_count--;
> +		}
> +
> +	} else if (!enable && regulator->bypass) {
> +		rdev->bypass_count--;
> +
> +		if (rdev->bypass_count != rdev->open_count) {
> +			ret = rdev->desc->ops->set_bypass(rdev, enable);
> +			if (ret != 0)
> +				rdev->bypass_count++;
> +		}
> +	}
> +
> +	if (ret == 0)
> +		regulator->bypass = enable;
> +
> +	mutex_unlock(&rdev->mutex);
> +
> +	return ret;
> +}
> +
> +/**
>   * regulator_register_notifier - register regulator event notifier
>   * @regulator: regulator source
>   * @nb: notifier block
> @@ -3046,6 +3123,11 @@ static int add_regulator_attributes(struct regulator_dev *rdev)
>  		if (status < 0)
>  			return status;
>  	}
> +	if (ops->get_bypass) {
> +		status = device_create_file(dev, &dev_attr_bypass);
> +		if (status < 0)
> +			return status;
> +	}
>  
>  	/* some attributes are type-specific */
>  	if (rdev->desc->type == REGULATOR_CURRENT) {
> @@ -3134,6 +3216,8 @@ static void rdev_init_debugfs(struct regulator_dev *rdev)
>  			   &rdev->use_count);
>  	debugfs_create_u32("open_count", 0444, rdev->debugfs,
>  			   &rdev->open_count);
> +	debugfs_create_u32("bypass_count", 0444, rdev->debugfs,
> +			   &rdev->bypass_count);
>  }
>  
>  /**
> diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
> index b987bcc..07838c9 100644
> --- a/include/linux/regulator/consumer.h
> +++ b/include/linux/regulator/consumer.h
> @@ -177,6 +177,8 @@ int regulator_set_mode(struct regulator *regulator, unsigned int mode);
>  unsigned int regulator_get_mode(struct regulator *regulator);
>  int regulator_set_optimum_mode(struct regulator *regulator, int load_uA);
>  
> +int regulator_allow_bypass(struct regulator *regulator, bool allow);
> +
>  /* regulator notifier block */
>  int regulator_register_notifier(struct regulator *regulator,
>  			      struct notifier_block *nb);
> @@ -328,6 +330,12 @@ static inline int regulator_set_optimum_mode(struct regulator *regulator,
>  	return REGULATOR_MODE_NORMAL;
>  }
>  
> +static inline int regulator_allow_bypass(struct regulator *regulator,
> +					 bool allow)
> +{
> +	return 0;
> +}
> +
>  static inline int regulator_register_notifier(struct regulator *regulator,
>  			      struct notifier_block *nb)
>  {
> diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
> index c10012f..2b2670b 100644
> --- a/include/linux/regulator/driver.h
> +++ b/include/linux/regulator/driver.h
> @@ -32,6 +32,8 @@ enum regulator_status {
>  	REGULATOR_STATUS_NORMAL,
>  	REGULATOR_STATUS_IDLE,
>  	REGULATOR_STATUS_STANDBY,
> +	/* The regulator is enabled but not regulating */
> +	REGULATOR_STATUS_BYPASS,
>  	/* in case that any other status doesn't apply */
>  	REGULATOR_STATUS_UNDEFINED,
>  };
> @@ -68,6 +70,9 @@ enum regulator_status {
>   * @get_optimum_mode: Get the most efficient operating mode for the regulator
>   *                    when running with the specified parameters.
>   *
> + * @set_bypass: Set the regulator in bypass mode.
> + * @get_bypass: Get the regulator bypass mode state.
> + *
>   * @enable_time: Time taken for the regulator voltage output voltage to
>   *               stabilise after being enabled, in microseconds.
>   * @set_ramp_delay: Set the ramp delay for the regulator. The driver should
> @@ -134,6 +139,10 @@ struct regulator_ops {
>  	unsigned int (*get_optimum_mode) (struct regulator_dev *, int input_uV,
>  					  int output_uV, int load_uA);
>  
> +	/* control and report on bypass mode */
> +	int (*set_bypass)(struct regulator_dev *dev, bool enable);
> +	int (*get_bypass)(struct regulator_dev *dev, bool *enable);
> +
>  	/* the operations below are for configuration of regulator state when
>  	 * its parent PMIC enters a global STANDBY/HIBERNATE state */
>  
> @@ -254,6 +263,7 @@ struct regulator_dev {
>  	int exclusive;
>  	u32 use_count;
>  	u32 open_count;
> +	u32 bypass_count;
>  
>  	/* lists we belong to */
>  	struct list_head list; /* list of all regulators */
> diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
> index 40dd0a3..36adbc8 100644
> --- a/include/linux/regulator/machine.h
> +++ b/include/linux/regulator/machine.h
> @@ -32,6 +32,7 @@ struct regulator;
>   *           board/machine.
>   * STATUS:   Regulator can be enabled and disabled.
>   * DRMS:     Dynamic Regulator Mode Switching is enabled for this regulator.
> + * BYPASS:   Regulator can be put into bypass mode
>   */
>  
>  #define REGULATOR_CHANGE_VOLTAGE	0x1
> @@ -39,6 +40,7 @@ struct regulator;
>  #define REGULATOR_CHANGE_MODE		0x4
>  #define REGULATOR_CHANGE_STATUS		0x8
>  #define REGULATOR_CHANGE_DRMS		0x10
> +#define REGULATOR_CHANGE_BYPASS		0x20
>  
>  /**
>   * struct regulator_state - regulator state during low power system states


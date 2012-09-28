Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab2I1AEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 20:04:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40277 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab2I1AEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 20:04:15 -0400
Date: Thu, 27 Sep 2012 17:01:15 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 34/57] power: ab8500_fg: add power cut feature for ab8505
Message-ID: <20120928000115.GA20560@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-35-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348589574-25655-35-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:12:31AM -0600, mathieu.poirier@linaro.org wrote:
> From: Rikard Olsson <rikard.p.olsson@stericsson.com>
> 
> Add support for a power cut feature which allows user to
> configure when ab8505 should shut down system due to low
> battery.
> 
> Signed-off-by: Rikard Olsson <rikard.p.olsson@stericsson.com>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Reviewed-by: Martin SJOBLOM <martin.w.sjoblom@stericsson.com>
> Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
> ---
>  drivers/power/ab8500_fg.c            |  488 +++++++++++++++++++++++++++++++++-
>  include/linux/mfd/abx500.h           |   10 +
>  include/linux/mfd/abx500/ab8500-bm.h |    8 +
>  3 files changed, 502 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
> index 5e4a46b..fde189a 100644
> --- a/drivers/power/ab8500_fg.c
> +++ b/drivers/power/ab8500_fg.c
> @@ -2351,6 +2351,64 @@ static int ab8500_fg_init_hw_registers(struct ab8500_fg *di)
>  		dev_err(di->dev, "BattOk init write failed.\n");
>  		goto out;
>  	}
> +
> +	if ((is_ab8505(di->parent) || is_ab9540(di->parent)) &&
> +			abx500_get_chip_id(di->dev) >= AB8500_CUT2P0) {
> +		ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
> +			AB8505_RTC_PCUT_MAX_TIME_REG,
> +					 di->bat->fg_params->pcut_max_time);
> +

No need for this empty line.

> +		if (ret) {
> +			dev_err(di->dev,
> +				"%s write failed AB8505_RTC_PCUT_MAX_TIME_REG\n",
> +				 __func__);
> +			goto out;
> +		};
> +
> +		ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
> +			AB8505_RTC_PCUT_FLAG_TIME_REG,
> +					 di->bat->fg_params->pcut_flag_time);
> +

Ditto...

> +		if (ret) {
> +			dev_err(di->dev,
> +			"%s write failed AB8505_RTC_PCUT_FLAG_TIME_REG\n",
> +			 __func__);

Wrong indentation.

> +			goto out;

No need for these gotos. Just return.

[...]
>  	return ret;
>  }
> @@ -2572,22 +2630,433 @@ static ssize_t ab8500_show_capacity(struct device *dev,
>  	return scnprintf(buf, PAGE_SIZE, "%d\n", capacity);
>  }
>  
> +static ssize_t ab8505_powercut_flagtime_read(struct device *dev,
> +			     struct device_attribute *attr,
> +			     char *buf)
> +{
> +	int ret;
> +	u8 reg_value;
> +	struct power_supply *psy = dev_get_drvdata(dev);
> +	struct ab8500_fg *di;
> +
> +	di = to_ab8500_fg_device_info(psy);

This can go into the initializer.

> +
> +	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
> +		AB8505_RTC_PCUT_FLAG_TIME_REG, &reg_value);
> +
> +	if (ret < 0) {
> +		dev_err(dev, "Failed to read AB8505_RTC_PCUT_FLAG_TIME_REG\n");
> +		goto fail;

As there's just one fail case, we can just return early, no need for
the label.

> +	}
> +
> +	return scnprintf(buf, PAGE_SIZE, "%d\n", (reg_value & 0x7F));
> +
> +fail:
> +	return ret;
> +}
> +
> +static ssize_t ab8505_powercut_flagtime_write(struct device *dev,
> +				  struct device_attribute *attr,
> +				  const char *buf, size_t count)
> +{
> +	int ret;
> +	long unsigned reg_value;
> +	struct power_supply *psy = dev_get_drvdata(dev);
> +	struct ab8500_fg *di;
> +
> +	di = to_ab8500_fg_device_info(psy);

Into initializer...

> +
> +	if (kstrtoul(buf, 10, &reg_value) != 0)
> +		goto fail;
> +
> +	if (reg_value > 0x7F) {
> +		dev_err(dev, "Incorrect parameter, echo 0 (1.98s) - 127 (15.625ms) for flagtime\n");
> +		goto fail;

No need for 'fail' label, we can just return in both cases.
Plus, currently the code would return success, even if kstroul failed
or on incorrect reg_value. That's not right, I guess the function
should return -EINVAL.

> +	}
> +
> +	ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
> +		AB8505_RTC_PCUT_FLAG_TIME_REG, (u8)reg_value);
> +
> +	if (ret < 0)
> +		dev_err(dev, "Failed to set AB8505_RTC_PCUT_FLAG_TIME_REG\n");
> +
> +fail:
> +	return count;
> +}
> +
> +static ssize_t ab8505_powercut_maxtime_read(struct device *dev,
> +			     struct device_attribute *attr,
> +			     char *buf)
> +{
> +	int ret;
> +	u8 reg_value;
> +	struct power_supply *psy = dev_get_drvdata(dev);
> +	struct ab8500_fg *di;
> +
> +	di = to_ab8500_fg_device_info(psy);

Can go into initializer.

> +
> +	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
> +		AB8505_RTC_PCUT_MAX_TIME_REG, &reg_value);
> +
> +	if (ret < 0) {
> +		dev_err(dev, "Failed to read AB8505_RTC_PCUT_MAX_TIME_REG\n");
> +		goto fail;

No need for goto.

> +	}
> +
> +	return scnprintf(buf, PAGE_SIZE, "%d\n", (reg_value & 0x7F));
> +
> +fail:
> +	return ret;
> +
> +}
> +
> +static ssize_t ab8505_powercut_maxtime_write(struct device *dev,
> +				  struct device_attribute *attr,
> +				  const char *buf, size_t count)
> +{
> +	int ret;
> +	long unsigned int reg_value;
> +	struct power_supply *psy = dev_get_drvdata(dev);
> +	struct ab8500_fg *di;
> +
> +	di = to_ab8500_fg_device_info(psy);

Initializer.

> +
> +	if (kstrtoul(buf, 10, &reg_value) != 0)
> +		goto fail;
> +
> +	if (reg_value > 0x7F) {
> +		dev_err(dev, "Incorrect parameter, echo 0 (0.0s) - 127 (1.98s) for maxtime\n");
> +		goto fail;

No need for gotos, and should return -EINVAL on errors.

> +	}
> +
> +	ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
> +		AB8505_RTC_PCUT_MAX_TIME_REG, (u8)reg_value);
> +
> +	if (ret < 0)
> +		dev_err(dev, "Failed to set AB8505_RTC_PCUT_MAX_TIME_REG\n");
> +
> +fail:
> +	return count;
> +}
> +
> +static ssize_t ab8505_powercut_restart_read(struct device *dev,
> +			     struct device_attribute *attr,
> +			     char *buf)
> +{
> +	int ret;
> +	u8 reg_value;
> +	struct power_supply *psy = dev_get_drvdata(dev);
> +	struct ab8500_fg *di;
> +
> +	di = to_ab8500_fg_device_info(psy);

can be initializer.

> +
> +	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
> +		AB8505_RTC_PCUT_RESTART_REG, &reg_value);
> +

unneeded empty line.

> +	if (ret < 0) {
> +		dev_err(dev, "Failed to read AB8505_RTC_PCUT_RESTART_REG\n");
> +		goto fail;

no need for goto.

.....and more similar stuff in this stuff....

Does it make sense to write a macro that constructs all these
similar functions? Would save numerous lines of code.

[...]
>  static struct device_attribute ab8500_fg_sysfs_psy_attrs[] = {
>  	__ATTR(capacity, S_IRUGO, ab8500_show_capacity, NULL),
>  };
>  
> +static struct device_attribute ab8505_fg_sysfs_psy_attrs[] = {
> +	__ATTR(powercut_flagtime, (S_IRUGO | S_IWUGO),
> +				ab8505_powercut_flagtime_read,
> +				ab8505_powercut_flagtime_write),
> +	__ATTR(powercut_maxtime, (S_IRUGO | S_IWUGO),
> +				ab8505_powercut_maxtime_read,
> +				ab8505_powercut_maxtime_write),
> +	__ATTR(powercut_restart_max, (S_IRUGO | S_IWUGO),
> +				ab8505_powercut_restart_read,
> +				ab8505_powercut_restart_write),
> +	__ATTR(powercut_timer, S_IRUGO, ab8505_powercut_timer_read, NULL),
> +	__ATTR(powercut_restart_counter, S_IRUGO,
> +				ab8505_powercut_restart_counter_read, NULL),
> +	__ATTR(powercut_enable, (S_IRUGO | S_IWUGO), ab8505_powercut_read,
> +							 ab8505_powercut_write),
> +	__ATTR(powercut_flag, S_IRUGO, ab8505_powercut_flag_read, NULL),
> +	__ATTR(powercut_debounce_time, (S_IRUGO | S_IWUGO),
> +				ab8505_powercut_debounce_read,
> +				ab8505_powercut_debounce_write),
> +	__ATTR(powercut_enable_status, S_IRUGO,
> +				ab8505_powercut_enable_status_read, NULL),

Quite inconsistent wrapping. But that's just nitpicking...

Thanks,
Anton.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab2HYPK1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 11:10:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45060 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753332Ab2HYPKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 11:10:25 -0400
Date: Sat, 25 Aug 2012 08:10:20 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        lm-sensors@lm-sensors.org, linux-input@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-leds@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Andrew Jones <drjones@redhat.com>, Donggeun Kim <dg77.kim@samsung.com>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        Wim Van Sebroeck <wim@iguana.be>, Bryan Wu <bryan.wu@canonical.com>,
        "Richard Purdie <rpurdie@rpsys.net> Anthony Olech" 
	<anthony.olech@diasemi.com>
Subject: Re: [RFC PATCH 2/8] regulator: Add Dialog DA906x voltage regulators
 support.
Message-ID: <20120825151020.GB6520@opensource.wolfsonmicro.com>
References: <201208241450@sw-eng-lt-dc-vm2>
 <201208241455@sw-eng-lt-dc-vm2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208241455@sw-eng-lt-dc-vm2>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 02:55:00PM +0100, Krystian Garbaciak wrote:

> +static int da906x_set_voltage(struct regulator_dev *rdev,
> +				int min_uV, int max_uV, unsigned *selector)
> +{
> +	struct da906x_regulator *regl = rdev_get_drvdata(rdev);
> +	const struct field *fvol = &regl->info->voltage;
> +	int ret;
> +	unsigned val;
> +
> +	val = regulator_map_voltage_linear(rdev, min_uV, max_uV);
> +	if (val < 0)
> +		return -EINVAL;
> +
> +	val = (val + fvol->offset) << fvol->shift;
> +	ret = da906x_reg_update(regl->hw, fvol->addr, fvol->mask, val);
> +	if (ret >= 0)
> +		*selector = val;
> +
> +	return ret;
> +}

This is just set_voltage_sel_regmap().

> +static int da906x_enable(struct regulator_dev *rdev)
> +{
> +	struct da906x_regulator *regl = rdev_get_drvdata(rdev);
> +	int ret;
> +
> +	if (regl->info->suspend.mask) {
> +		/* Make sure to exit from suspend mode on enable */
> +		ret = da906x_reg_clear_bits(regl->hw, regl->info->suspend.addr,
> +					    regl->info->suspend.mask);
> +		if (ret < 0)
> +			return ret;
> +
> +		/* BUCKs need mode update after wake-up from suspend state. */
> +		ret = da906x_update_mode_internal(regl, SYS_STATE_NORMAL);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return regulator_enable_regmap(rdev);

If suspend_mask is optional the regulators using it should just use the
standard operation.

> +/* Regulator event handlers */
> +irqreturn_t da906x_ldo_lim_event(int irq, void *data)

By "event handler" you mean "interrupt"

> +	bits = da906x_reg_read(hw, DA906X_REG_STATUS_D);
> +	if (bits < 0)
> +		return IRQ_HANDLED;

If you fail to detect an interrupt you report that you handled one...?

> +	if (!da906x_pdata) {
> +		dev_err(&pdev->dev, "No platform init data supplied\n");
> +		return -ENODEV;
> +	}

Platform data should be totally optional.

> +	bcores_merged = (ret & DA906X_BCORE_MERGE) ? true : false;
> +	bmem_bio_merged = (ret & DA906X_BUCK_MERGE) ? true : false;

The use of the ternery operation here is even worse than normal, you can
assign the values directly.

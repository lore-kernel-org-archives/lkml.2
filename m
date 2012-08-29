Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab2H2Ot1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 10:49:27 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:40479 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab2H2OtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 10:49:25 -0400
From: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        <lm-sensors@lm-sensors.org>, <linux-input@vger.kernel.org>,
        <linux-watchdog@vger.kernel.org>, <linux-leds@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Jean Delvare <khali@linux-fr.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Andrew Jones <drjones@redhat.com>, Donggeun Kim <dg77.kim@samsung.com>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        "Wim Van Sebroeck" <wim@iguana.be>, Bryan Wu <bryan.wu@canonical.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Anthony Olech <anthony.olech@diasemi.com>
Subject: Re: [RFC PATCH 2/8] regulator: Add Dialog DA906x voltage regulators support.
Message-ID: <201208291550@sw-eng-lt-dc-vm2>
References: <201208241450@sw-eng-lt-dc-vm2>
	<201208241455@sw-eng-lt-dc-vm2>
	<20120825151020.GB6520@opensource.wolfsonmicro.com>
In-Reply-To: <20120825151020.GB6520@opensource.wolfsonmicro.com>
Date: Wed, 29 Aug 2012 15:50:00 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static int da906x_set_voltage(struct regulator_dev *rdev,
> > +				int min_uV, int max_uV, unsigned *selector)
> > +{
> > +	struct da906x_regulator *regl = rdev_get_drvdata(rdev);
> > +	const struct field *fvol = &regl->info->voltage;
> > +	int ret;
> > +	unsigned val;
> > +
> > +	val = regulator_map_voltage_linear(rdev, min_uV, max_uV);
> > +	if (val < 0)
> > +		return -EINVAL;
> > +
> > +	val = (val + fvol->offset) << fvol->shift;
> > +	ret = da906x_reg_update(regl->hw, fvol->addr, fvol->mask, val);
> > +	if (ret >= 0)
> > +		*selector = val;
> > +
> > +	return ret;
> > +}
> 
> This is just set_voltage_sel_regmap().

Because, for some regulators, this is required: val += fvol->offset,
I was only able to reduce it to the following form.

+static int da9063_set_voltage(struct regulator_dev *rdev,
+			      int min_uV, int max_uV, unsigned *selector)
+{
+	struct da9063_regulator *regl = rdev_get_drvdata(rdev);
+	const struct field *fvol = &regl->info->voltage;
+	int ret;
+	unsigned val;
+
+	val = regulator_map_voltage_linear(rdev, min_uV, max_uV);
+	if (val < 0)
+		return -EINVAL;
+
+	val += fvol->offset;
+
+	ret = regulator_set_voltage_sel_regmap(rdev, val);
+	if (ret >= 0)
+		*selector = val;
+
+	return ret;
+}

> > +static int da906x_enable(struct regulator_dev *rdev)
> > +{
> > +	struct da906x_regulator *regl = rdev_get_drvdata(rdev);
> > +	int ret;
> > +
> > +	if (regl->info->suspend.mask) {
> > +		/* Make sure to exit from suspend mode on enable */
> > +		ret = da906x_reg_clear_bits(regl->hw, regl->info->suspend.addr,
> > +					    regl->info->suspend.mask);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		/* BUCKs need mode update after wake-up from suspend state. */
> > +		ret = da906x_update_mode_internal(regl, SYS_STATE_NORMAL);
> > +		if (ret < 0)
> > +			return ret;
> > +	}
> > +
> > +	return regulator_enable_regmap(rdev);
> 
> If suspend_mask is optional the regulators using it should just use the
> standard operation.

I guess, you meant here to call regulator_enable_regmap() directly for
regulators NOT using suspend.mask. Then, I will do it.

> > +/* Regulator event handlers */
> > +irqreturn_t da906x_ldo_lim_event(int irq, void *data)
> 
> By "event handler" you mean "interrupt"

Yes. I think, I will update the comment line.

> > +	bits = da906x_reg_read(hw, DA906X_REG_STATUS_D);
> > +	if (bits < 0)
> > +		return IRQ_HANDLED;
> 
> If you fail to detect an interrupt you report that you handled one...?

For me there is no sensible return value for this case.
However, I consider changing the reaction on read failure by reporting event
for all regulators, that might cause this interrupt:
+	bits = da9063_reg_read(hw, DA9063_REG_STATUS_D);
+	if (bits < 0)
+		bits = ~0;

I will update the driver according to your remaining comments.

Thank you for your comments,
Krystian


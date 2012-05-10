Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761385Ab2EJSsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:48:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53661 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760449Ab2EJSsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:48:19 -0400
Date: Thu, 10 May 2012 11:48:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johan Hovold <jhovold@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Rob Landley <rob@landley.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bryan Wu <bryan.wu@canonical.com>
Subject: Re: [PATCH v3] leds: add LM3533 LED driver
Message-Id: <20120510114817.28b24168.akpm@linux-foundation.org>
In-Reply-To: <1336674425-24145-1-git-send-email-jhovold@gmail.com>
References: <1336040799-18433-4-git-send-email-jhovold@gmail.com>
	<1336674425-24145-1-git-send-email-jhovold@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2012 20:27:05 +0200
Johan Hovold <jhovold@gmail.com> wrote:

> Add sub-driver for the LEDs on National Semiconductor / TI LM3533
> lighting power chips.
> 
> The chip provides 256 brightness levels, hardware accelerated blinking
> as well as ambient-light-sensor and pwm input control.
> 
>
> ...
>
> +#define to_lm3533_led(_cdev) \
> +	container_of(_cdev, struct lm3533_led, cdev)

Minor thing: container_of() is not fully type-safe: it can be passed
the address of any struct which contains a field called cdev and will
return a struct lm3533_led* (or something like that - it has holes...).

A way to fix that is to wrap container_of() in a real C function, not a
macro:

static inline struct lm3533_led *to_lm3533_led(struct struct led_classdev *cdev)
{
	return container_of(_cdev, struct lm3533_led, cdev);
}

This has been another episode in the ongoing series "macros are always
wrong" :)

>
> ...
>
> +static int time_to_val(long *t, long t_min, long t_max, long t_step,
> +							int v_min, int v_max)
> +{
> +	int val;
> +
> +	*t += t_step / 2;
> +	val = (*t - t_min) / t_step + v_min;
> +	val = clamp(val, v_min, v_max);
> +	*t = t_step * (val - v_min) + t_min;
> +
> +	return val;
> +}

Oh wow, what does all this do.  Please, take pity upon the poor reader
and add a comment documenting this function's intent?

> +static int lm3533_led_get_delay(long *delay)
> +{
> +	int val;
> +
> +	*delay *= 1000;
> +
> +	if (*delay >= LM3533_LED_DELAY_GROUP3_MIN -
> +					LM3533_LED_DELAY_GROUP3_STEP / 2) {
> +		val = time_to_val(delay, LM3533_LED_DELAY_GROUP3_MIN,
> +					LM3533_LED_DELAY_GROUP3_MAX,
> +					LM3533_LED_DELAY_GROUP3_STEP,
> +					LM3533_LED_DELAY_GROUP3_BASE,
> +					0xff);
> +	} else if (*delay >= LM3533_LED_DELAY_GROUP2_MIN -
> +					LM3533_LED_DELAY_GROUP2_STEP / 2) {
> +		val = time_to_val(delay, LM3533_LED_DELAY_GROUP2_MIN,
> +					LM3533_LED_DELAY_GROUP2_MAX,
> +					LM3533_LED_DELAY_GROUP2_STEP,
> +					LM3533_LED_DELAY_GROUP2_BASE,
> +					LM3533_LED_DELAY_GROUP3_BASE - 1);
> +	} else {
> +		val = time_to_val(delay, LM3533_LED_DELAY_GROUP1_MIN,
> +					LM3533_LED_DELAY_GROUP1_MAX,
> +					LM3533_LED_DELAY_GROUP1_STEP,
> +					LM3533_LED_DELAY_GROUP1_BASE,
> +					LM3533_LED_DELAY_GROUP2_BASE - 1);
> +	}
> +
> +	*delay /= 1000;
> +
> +	return val;
> +}

And this one, please.

> +static int lm3533_led_delay_set(struct lm3533_led *led, u8 base,
> +							unsigned long *delay)
> +{
> +	u8 val;
> +	u8 reg;
> +	long t;
> +	int ret;
> +
> +	t = *delay;
> +	val = lm3533_led_get_delay(&t);
> +
> +	dev_dbg(led->cdev.dev, "%s - %lu: %ld (0x%02x)\n", __func__,
> +							*delay, t, val);
> +	reg = lm3533_led_get_pattern_reg(led, base);
> +	ret = lm3533_write(led->lm3533, reg, val);
> +	if (ret)
> +		dev_err(led->cdev.dev, "failed to set delay (%02x)\n", reg);
> +
> +	*delay = t;
> +
> +	return ret;
> +}

Should `t' have unsigned long type?  I think so.  The above functions
confuddle longs with unsigned longs.  As a negative delay is an
absurdity, perhaps everything should use unsigned long consistently?

> +static int lm3533_led_delay_on_set(struct lm3533_led *led, unsigned long *t)
> +{
> +	*t = min_t(long, *t, LM3533_LED_DELAY_GROUP2_MAX / 1000);

The use of min_t is often a sign that the types are mucked up.  How to
fix this?

Are the LM3533_LED_DELAY_* constants logically to be considered to have
unsigned long type?  If so, put a "L" after their values and everything
should work out nicely.


> +	return lm3533_led_delay_set(led, LM3533_REG_PATTERN_HIGH_TIME_BASE, t);
> +}
> +
>
> ...
>
> +static ssize_t store_als(struct device *dev,
> +					struct device_attribute *attr,
> +					const char *buf, size_t len)
> +{
> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
> +	struct lm3533_led *led = to_lm3533_led(led_cdev);
> +	u8 als;
> +	u8 reg;
> +	u8 mask;
> +	int ret;
> +
> +	if (kstrtou8(buf, 0, &als))
> +		return -EINVAL;
> +
> +	if (als != 0 && (als < LM3533_ALS_LV_MIN || als > LM3533_ALS_LV_MAX))
> +		return -EINVAL;

The `als != 0' test doesn't do anything, and looks odd.  Is there some
magical reason why als==0 would be illegal even if LM3533_ALS_LV_MIN
was negative?  If so, it should be documented.

> +
> +	reg = lm3533_led_get_lv_reg(led, LM3533_REG_CTRLBANK_BCONF_BASE);
> +	mask = LM3533_REG_CTRLBANK_BCONF_ALS_MASK;
> +
> +	ret = lm3533_update(led->lm3533, reg, als, mask);
> +	if (ret)
> +		return ret;
> +
> +	return len;
> +}
> +
>
> ...
>


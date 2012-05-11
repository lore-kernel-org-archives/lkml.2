Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab2EKJyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 05:54:17 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:61425 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932175Ab2EKJyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 05:54:15 -0400
Date: Fri, 11 May 2012 11:54:11 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
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
Message-ID: <20120511095411.GC29437@localhost>
References: <1336040799-18433-4-git-send-email-jhovold@gmail.com>
 <1336674425-24145-1-git-send-email-jhovold@gmail.com>
 <20120510114817.28b24168.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120510114817.28b24168.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 11:48:17AM -0700, Andrew Morton wrote:
> On Thu, 10 May 2012 20:27:05 +0200
> Johan Hovold <jhovold@gmail.com> wrote:
> 
> > Add sub-driver for the LEDs on National Semiconductor / TI LM3533
> > lighting power chips.
> > 
> > The chip provides 256 brightness levels, hardware accelerated blinking
> > as well as ambient-light-sensor and pwm input control.
> > 
> > ...
> >
> > +#define to_lm3533_led(_cdev) \
> > +	container_of(_cdev, struct lm3533_led, cdev)
> 
> Minor thing: container_of() is not fully type-safe: it can be passed
> the address of any struct which contains a field called cdev and will
> return a struct lm3533_led* (or something like that - it has holes...).
> 
> A way to fix that is to wrap container_of() in a real C function, not a
> macro:
> 
> static inline struct lm3533_led *to_lm3533_led(struct struct led_classdev *cdev)
> {
> 	return container_of(_cdev, struct lm3533_led, cdev);
> }
> 
> This has been another episode in the ongoing series "macros are always
> wrong" :)

Fair enough. :) Seems like the vast majority of drivers still use
convenience macros such as the this one for this kind of use (where the
functions are either passed the class device or it is retrieved through
device driver data).

Do you want me to replace the other three instances of container_of
convenience macros in the iio-subdriver and core (already added to the
mfd tree) as well?

> > ...
> >
> > +static int time_to_val(long *t, long t_min, long t_max, long t_step,
> > +							int v_min, int v_max)
> > +{
> > +	int val;
> > +
> > +	*t += t_step / 2;
> > +	val = (*t - t_min) / t_step + v_min;
> > +	val = clamp(val, v_min, v_max);
> > +	*t = t_step * (val - v_min) + t_min;
> > +
> > +	return val;
> > +}
> 
> Oh wow, what does all this do.  Please, take pity upon the poor reader
> and add a comment documenting this function's intent?

Mapping a time in SI-units (us) to device-specific discrete time
and returning the actual time that will be used (multiple of t_step +
offset).

I'll try to make it more clear and add some comments.

> > +static int lm3533_led_get_delay(long *delay)
> > +{
> > +	int val;
> > +
> > +	*delay *= 1000;
> > +
> > +	if (*delay >= LM3533_LED_DELAY_GROUP3_MIN -
> > +					LM3533_LED_DELAY_GROUP3_STEP / 2) {
> > +		val = time_to_val(delay, LM3533_LED_DELAY_GROUP3_MIN,
> > +					LM3533_LED_DELAY_GROUP3_MAX,
> > +					LM3533_LED_DELAY_GROUP3_STEP,
> > +					LM3533_LED_DELAY_GROUP3_BASE,
> > +					0xff);
> > +	} else if (*delay >= LM3533_LED_DELAY_GROUP2_MIN -
> > +					LM3533_LED_DELAY_GROUP2_STEP / 2) {
> > +		val = time_to_val(delay, LM3533_LED_DELAY_GROUP2_MIN,
> > +					LM3533_LED_DELAY_GROUP2_MAX,
> > +					LM3533_LED_DELAY_GROUP2_STEP,
> > +					LM3533_LED_DELAY_GROUP2_BASE,
> > +					LM3533_LED_DELAY_GROUP3_BASE - 1);
> > +	} else {
> > +		val = time_to_val(delay, LM3533_LED_DELAY_GROUP1_MIN,
> > +					LM3533_LED_DELAY_GROUP1_MAX,
> > +					LM3533_LED_DELAY_GROUP1_STEP,
> > +					LM3533_LED_DELAY_GROUP1_BASE,
> > +					LM3533_LED_DELAY_GROUP2_BASE - 1);
> > +	}
> > +
> > +	*delay /= 1000;
> > +
> > +	return val;
> > +}
> 
> And this one, please.

Will do. [ The device has three ranges of supported hardware-accelerated
blink times with different step sizes. ]

> > +static int lm3533_led_delay_set(struct lm3533_led *led, u8 base,
> > +							unsigned long *delay)
> > +{
> > +	u8 val;
> > +	u8 reg;
> > +	long t;
> > +	int ret;
> > +
> > +	t = *delay;
> > +	val = lm3533_led_get_delay(&t);
> > +
> > +	dev_dbg(led->cdev.dev, "%s - %lu: %ld (0x%02x)\n", __func__,
> > +							*delay, t, val);
> > +	reg = lm3533_led_get_pattern_reg(led, base);
> > +	ret = lm3533_write(led->lm3533, reg, val);
> > +	if (ret)
> > +		dev_err(led->cdev.dev, "failed to set delay (%02x)\n", reg);
> > +
> > +	*delay = t;
> > +
> > +	return ret;
> > +}
> 
> Should `t' have unsigned long type?  I think so.  The above functions
> confuddle longs with unsigned longs.  As a negative delay is an
> absurdity, perhaps everything should use unsigned long consistently?

Indeed. 

> > +static int lm3533_led_delay_on_set(struct lm3533_led *led, unsigned long *t)
> > +{
> > +	*t = min_t(long, *t, LM3533_LED_DELAY_GROUP2_MAX / 1000);
> 
> The use of min_t is often a sign that the types are mucked up.  How to
> fix this?
> 
> Are the LM3533_LED_DELAY_* constants logically to be considered to have
> unsigned long type?  If so, put a "L" after their values and everything
> should work out nicely.

Will do.

> > +	return lm3533_led_delay_set(led, LM3533_REG_PATTERN_HIGH_TIME_BASE, t);
> > +}
> > +
> >
> > ...
> >
> > +static ssize_t store_als(struct device *dev,
> > +					struct device_attribute *attr,
> > +					const char *buf, size_t len)
> > +{
> > +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
> > +	struct lm3533_led *led = to_lm3533_led(led_cdev);
> > +	u8 als;
> > +	u8 reg;
> > +	u8 mask;
> > +	int ret;
> > +
> > +	if (kstrtou8(buf, 0, &als))
> > +		return -EINVAL;
> > +
> > +	if (als != 0 && (als < LM3533_ALS_LV_MIN || als > LM3533_ALS_LV_MAX))
> > +		return -EINVAL;
> 
> The `als != 0' test doesn't do anything, and looks odd.  Is there some
> magical reason why als==0 would be illegal even if LM3533_ALS_LV_MIN
> was negative?  If so, it should be documented.

The non-zero-test is not redundant as 0 is the only valid input outside
of [LV_MIN,LV_MAX] (in fact, the only three valid values are 0,2 and 3).

Would you prefer

	if ((als < LM3533_ALS_LV_MIN && als != 0) || als > LM3533_ALS_LV_MAX)
		return -EINVAL;

or nested conditionals? Or should I simply add a comment?

Thanks,
Johan

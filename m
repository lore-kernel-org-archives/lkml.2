Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab3ACIyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 03:54:46 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:43855 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708Ab3ACIyn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 03:54:43 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: RE: [PATCH v2 2/2] backlight: add new lp8788 backlight driver
Thread-Topic: [PATCH v2 2/2] backlight: add new lp8788 backlight driver
Thread-Index: Ac3fUIc+XT4fXXkCRl+TTu4PYuoz9gJ9d6mAABE9w9A=
Date: Thu, 3 Jan 2013 08:54:27 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E11090@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F69E108D2@DQHE02.ent.ti.com>
 <20130103080803.GB30631@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20130103080803.GB30631@avionic-0098.adnet.avionic-design.de>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.78]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

> > (Platform data)
> > Configurable data can be defined in the platform side.
> >  name                  : backlight driver name. (default: "lcd-
> backlight")
> >  initial_brightness    : initial value of backlight brightness
> >  bl_mode               : brightness control by PWM or lp8788 register
> >  dim_mode              : dimming mode selection
> >  full_scale            : full scale current setting
> >  rise_time             : brightness ramp up step time
> >  fall_time             : brightness ramp down step time
> >  pwm_pol               : PWM polarity setting when bl_mode is PWM
> based
> 
> You might want to consider using enum pwm_polarity from linux/pwm.h
> instead and convert to the driver representation internally.
> 
> I'm saying this because I'm thinking about extending the PWM framework
> to allow PWM polarity and period to be specified in the PWM lookup
> table
> so that they can be treated transparently, independent of whether they
> are obtained from DT or the lookup table.
> 
> That would allow the polarity and period to be retrieved with accessors
> like pwm_get_polarity() and pwm_get_period().

OK, pwm_pol will be replaced with pwm_get_polarity() in the next patch.

> 
> >  period_ns             : platform specific PWM period value. unit is
> nano.
> 
> If the period can be encoded in the PWM lookup table this can also go
> away. But for now it's fine to keep it as the changes aren't in place
> yet.

I'd remain it as configurable platform data.

> 
> > diff --git a/drivers/video/backlight/lp8788_bl.c
> b/drivers/video/backlight/lp8788_bl.c
> [...]
> > +/* register address */
> > +#define LP8788_BL_CONFIG		0x96
> > +#define LP8788_BL_BRIGHTNESS		0x97
> > +#define LP8788_BL_RAMP			0x98
> > +
> > +/* mask/shift bits */
> > +#define LP8788_BL_EN			BIT(0)	/* Addr 96h */
> > +#define LP8788_BL_PWM_EN		BIT(5)
> > +#define LP8788_BL_FULLSCALE_S		2
> > +#define LP8788_BL_DIM_MODE_S		1
> > +#define LP8788_BL_PWM_POLARITY_S	6
> > +#define LP8788_BL_RAMP_RISE_S		4	/* Addr 98h */
> 
> The ordering of the defines confuses me. I know you've put comments in
> place to explain which registers the individual bits/fields belong to,
> but I think it would be much clearer if the field definitions were to
> immediately follow the register addresses:
> 
> #define LP8788_BL_CONFIG		0x96
> #define LP8788_BL_EN			BIT(0)
> #define LP8788_BL_PWM_EN		BIT(5)
> ...
> #define LP8788_BL_RAMP			0x98
> #define LP8788_BL_RAMP_RISE_S		4
> 
> While at it, maybe change the _S suffix to _SHIFT, which seems to be
> more commonly used. Also the PWM_EN bit has an unfortunate name. It
> doesn't enable any PWM but, judging by the code, rather configures the
> hardware to use a PWM input to control brightness. Maybe something like
> USE_PWM would be more accurate. Or is the name taken from the datasheet?
> In that case there might be some value in keeping it.

In the datasheet, the name is 'PWM ENABLE' and bit description is 'PWM input con
trol'. So I'd change it as 'LP8788_BL_PWM_INPUT_EN'.
Thanks for your suggestion!

> 
> > +static inline bool is_brightness_ctrl_by_pwm(enum
> lp8788_bl_ctrl_mode mode)
> > +{
> > +	return (mode == LP8788_BL_COMB_PWM_BASED);
> > +}
> > +
> > +static inline bool is_brightness_ctrl_by_register(enum
> lp8788_bl_ctrl_mode mode)
> > +{
> > +	return (mode == LP8788_BL_REGISTER_ONLY ||
> > +		mode == LP8788_BL_COMB_REGISTER_BASED);
> > +}
> > +
> > +static int lp8788_backlight_configure(struct lp8788_bl *bl)
> > +{
> > +	struct lp8788_backlight_platform_data *pdata = bl->pdata;
> > +	struct lp8788_bl_config *cfg = &default_bl_config;
> > +	int ret;
> > +	u8 val;
> > +
> > +	/* update chip configuration if platform data exists,
> > +	   otherwise use the default settings */
> 
> CodingStyle says this should be:
> 
> 	/*
> 	 * Update chip configuration if platform data exists,
> 	 * otherwise use the default settings.
> 	 */
> 

OK, it will be fixed in the next patch.

> > +	/* brightness ramp up/down */
> > +	val = (cfg->rise_time << LP8788_BL_RAMP_RISE_S) | cfg->fall_time;
> > +	ret = lp8788_write_byte(bl->lp, LP8788_BL_RAMP, val);
> > +	if (ret) {
> > +		/* no I2C needed in case of pwm control mode */
> > +		if (is_brightness_ctrl_by_pwm(cfg->bl_mode))
> > +			goto no_err;
> > +		else
> > +			return ret;
> > +	}
> 
> In that case, shouldn't you rather move the is_brightness_ctrl_by_pwm()
> check up and only write the RAMP register if required? If RAMP doesn't
> have any effect in PWM control mode, then you don't need to write it.

The first I2C command in this driver is accessing 'LP8788_BL_RAMP' register.
In case of PWM control mode, I2C communication may get failed because I2C lines 
are not connected or activated.
But this condition is not harmful. Therefore checking PWM mode is unnecessary.
It will be removed in the next patch.
Thanks!

> And I'd prefer if PWM was consistently spelled with all capitals in
> text. There are a few other occurrences in the rest of the patch.

I'll keep it mind.

> 
> > +static ssize_t lp8788_get_bl_ctl_mode(struct device *dev,
> > +				     struct device_attribute *attr, char *buf)
> > +{
> > +	struct lp8788_bl *bl = dev_get_drvdata(dev);
> > +	enum lp8788_bl_ctrl_mode mode = bl->mode;
> > +	char *strmode;
> > +
> > +	if (is_brightness_ctrl_by_pwm(mode))
> > +		strmode = "pwm based";
> > +	else if (is_brightness_ctrl_by_register(mode))
> > +		strmode = "register based";
> > +	else
> > +		strmode = "invalid mode";
> > +
> > +	return scnprintf(buf, BUF_SIZE, "%s\n", strmode);
> > +}
> 
> According to Documentation/filesystems/sysfs.txt, buf is always a whole
> page, so you can use PAGE_SIZE instead of BUF_SIZE.

OK.
Thanks for all your comments.

Best Regards,
Milo

